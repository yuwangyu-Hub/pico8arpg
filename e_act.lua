function create_enstate_urchin(en)--小海胆：静止不动，玩家触碰会掉血，攻击弹开死亡(爆炸)，一滴血
	local hurtm_t,die_t=0,0
	return function(en)
		local switchstate={
			idle=function()
				hurtm_t=0
				check_en_hurt(sword,en,wy)
				check_hp(en)
			end,
			hurt=function()--受伤弹开
                hurtm_t=anim_sys(en.sprs.hurt,en,hurtm_t,.1,10)
				hurtdo(en,hurtm_t)
				xypluspd(en)
			end,
			death=function()--死亡爆炸
				die_t+=.4
				death_do(en,die_t)
			end,
		}
		switchstate[en.state]()
	end
end
function create_enstate_snake(en)--小蛇
	local idle_t,move_t,hurtm_t,die_t=0,0,0,0
	return function(en) --闭包
		spr_flip(en)
		local switchstate={
			idle=function()
				hurtm_t=0
				move_t=0
				--按时进行随机方向
				idle_t+=.1
				::redo:: local dire=rnd({1,3,5,7})
				if idle_t>=1 then
					if en.lastdire==dire then --如果随机方向等于上一次的方向
						goto redo --回到随机位置
					else --如果随机方向不等于上一次的方向
						en.dire=dire
						en.lastdire=dire
						en.state=en.allstate.move
						idle_t=0
					end
				end
				check_en_hurt(sword,en,wy)
				check_hp(en)
			end,
			move=function()
				check_en_hurt(sword,en,wy)
				local data={{1,2,8},{2,3,4},{4,5,6},{6,7,8}}
				local d=(en.dire+1)/2 --获取方向的索引
				--蛇的移动是四个方向的随机移动
				--限定距离(或时间)
				local wall_dire,_=check_wall_iswalk(en)--检测到朝墙壁
				if wall_dire!=0 then--如果靠近墙
					if wall_dire==data[d][1] or wall_dire==data[d][2] or wall_dire==data[d][3] then--移动方向与靠墙方向一致
						setspd_0(en)
						move_t=0
						en.state=en.allstate.idle
					else--随机移动
						rnd_move(en,move_t)
					end
				else--不靠近墙,随机移动
					rnd_move(en,move_t)
				end
				--move_t+=.2
				xypluspd(en)
				move_t = anim_sys(en.sprs.move,en,move_t,.2,1)
			end,
			hurt=function()
                hurtm_t=anim_sys(en.sprs.hurt,en,hurtm_t,.1,10)
				hurtdo(en,hurtm_t)
				xypluspd(en)
			end,
			death=function()
				die_t+=.4
				death_do(en,die_t)
			end,
		}
		switchstate[en.state]()
	end
end
function create_enstate_slime(en)--史莱姆
	local charge_t,idle_t,hurtm_t,die_t=0,0,0,0
	local tx,ty
	--跳跃相关变量，作为局部变量存储在闭包中
	local jump_t = nil
	local jump_start_x, jump_start_y --跳跃初始位置
	local jump_dir_x, jump_dir_y--跳跃方向
	local jump_dist--跳跃距离
	return function(en)
		local switchstate={
			idle=function()
				hurtm_t=0
				charge_t=0
				tx,ty=0,0
				--因为slime的idle动画是循环播放的，所以这里需要判断是否需要播放idle动画
				--所以需要有idle_t来记录idle动画的播放时间
				idle_t=anim_sys(en.sprs.idle,en,idle_t,.1,1)
				
				--检测玩家位置靠近
				if check_p_dis(en,wy) then
					tx=wy.x
					ty=wy.y
					en.state=en.allstate.charge
				end
				check_en_hurt(sword,en,wy)
				check_hp(en)
			end,
			charge=function()
				charge_t = anim_sys(en.sprs.charge,en,charge_t,.1,4)
				if charge_t>=2 then 
					en.state=en.allstate.jump
				end
				check_en_hurt(sword,en,wy)
				check_hp(en)
			end,
			jump=function()
				--跳跃移动到玩家位置（线性平移）

				if jump_t == nil then
					jump_t = 0
					--记录初始位置和跳跃方向
					jump_start_x,jump_start_y = en.x,en.y
				end
				--更新跳跃计时器
				jump_t += 0.2
				--计算移动进度
				local jump_progress = min(1, jump_t / 3) --控制移动时间
				--线性移动到目标位置
				en.x = jump_start_x + (tx - jump_start_x) * jump_progress
				en.y = jump_start_y + (ty - jump_start_y) * jump_progress
				
				--完成移动后重置状态
				if jump_progress >= 1 then
					jump_t = nil
					en.state = en.allstate.idle
				end
				en.frame=en.sprs.jump
				check_en_hurt(sword,en,wy)
				check_hp(en)
			end,
			hurt=function()
				hurtm_t=anim_sys(en.sprs.hurt,en,hurtm_t,.1,5)
				hurtdo(en,hurtm_t)
				xypluspd(en)
			end,
			death=function()
				die_t+=.4
				death_do(en,die_t)
			end,
		}
		switchstate[en.state]()
	end
end
function create_enstate_bat(en) --小蝙蝠
	local rest_t,fly_t, hurtm_t, die_t = 0, 0, 0, 0
	local tx, ty=0,0
	local angle = 0 -- 用于圆形飞行的角度
	local radius = 0 -- 圆形飞行的半径
	local fly_init = false -- 是否初始化了飞行参数
	local fly_direction = 1 -- 飞行方向：1为顺时针，-1为逆时针
	local bat_start_x, bat_start_y=0,0
	--local cur_crange -- 当前检测范围
	return function(en)
		local switchstate={
			idle=function()
				hurtm_t=0
				en.crange=30 -- 检测范围
				fly_init = false --重置飞行初始化状态
				if check_p_dis(en,wy) then
					tx=wy.x
					ty=wy.y
					bat_start_x, bat_start_y = en.x, en.y-- 记录蝙蝠的初始位置（当发现玩家时的位置）
					en.state=en.allstate.fly
				end
				en.frame=en.sprs.idle
				check_en_hurt(sword, en, wy)
				check_hp(en)
			end,
			fly=function()
				--debug1="fly"
				-- 初始化飞行参数
				if not fly_init then
					-- 计算初始半径（蝙蝠当时与玩家的距离）
					radius = sqrt((bat_start_x - tx)^2 + (bat_start_y - ty)^2)
					-- 计算初始角度（使用蝙蝠的初始位置）pico-8中:atan2(x,y)
					angle = atan2(bat_start_x - tx,bat_start_y - ty)
					-- 根据玩家相对于蝙蝠的位置决定飞行方向
					-- 如果玩家在蝙蝠的左边，逆时针飞行（负方向）
					-- 如果玩家在蝙蝠的右边，顺时针飞行（正方向）
					if wy.x < en.x then
						fly_direction = 1 -- 逆时针
					else
						fly_direction = -1 -- 顺时针
					end
					fly_init = true
				end
				-- 更新角度，实现旋转效果，结合bat.speed和飞行方向来控制
				angle += 0.005 * en.speed * fly_direction
				-- 计算圆形飞行的新位置
				en.x = tx + radius * cos(angle)
				en.y = ty + radius * sin(angle)
				radius-=0.5 -- 控制飞行半径减小，使蝙蝠向玩家移动

				if  radius<=2 then
					en.state=en.allstate.rest
				end
				-- 循环播放飞行动画
				fly_t = anim_sys(en.sprs.fly, en, fly_t, .2, 1)
				check_en_hurt(sword, en, wy)
				check_hp(en)
			end,
			rest=function()
				rest_t+=.1
				if rest_t>=1 then
					en.state=en.allstate.idle
					rest_t=0
				end
				en.frame=en.sprs.rest
				check_en_hurt(sword, en, wy)
				check_hp(en)
			end,
			hurt=function()
				hurtm_t=anim_sys(en.sprs.hurt, en, hurtm_t, .1, 5)
				hurtdo(en, hurtm_t)
				xypluspd(en)
			end,
			death=function()
				die_t+=.4
				death_do(en, die_t)
			end,
		}
		switchstate[en.state]()
	end
end
function enstate_spider(en) 
	local switchstate={
		
	}
end
function enstate_ghost(en) 
	local switchstate={
		
	}
end
function enstate_lizi(en) 
	local switchstate={
		
	}
end
