function enstate_urchin(en)
	local switchstate={
		idle=function()
			debug1="idle"
			en.wudi_t=0
			if check_en_hurt(sword,en,wy) then
				en.state=en.allstate.hurt
			end
			check_hp(en)
		end,
		hurt=function()--受伤弹开
			debug1="hurt"
            en.wudi_t=anim_sys(en.sprs.hurt,en,en.wudi_t,.1,5)
			hurtdo(en,en.wudi_t)
			xypluspd(en)
		end,
		death=function()
			debug1="death"
			en.die_t+=.4
			death_do(en,en.die_t)
		end,
	}
	switchstate[en.state]()
end
function enstate_snake(en)
	spr_flip(en)
	local switchstate={
		idle=function()
			en.wudi_t=0
			en.move_t=0
			--按时进行随机方向
			en.idle_t+=.1
			::redo:: local dire=rnd({1,3,5,7})
			if en.idle_t>=2 then
				if en.lastdire==dire then --如果随机方向等于上一次的方向
					goto redo --回到随机位置
				else --如果随机方向不等于上一次的方向
					en.dire=dire
					en.lastdire=dire
					en.state=en.allstate.move
					en.idle_t=0
				end
			end
			en.frame=en.sprs.idle
			if check_en_hurt(sword,en,wy) then
				en.state=en.allstate.hurt
			end
			check_hp(en)
		end,
		move=function()
			if check_en_hurt(sword,en,wy) then
				en.state=en.allstate.hurt
			end
			local data=explodeval("[1,2,8],[2,3,4],[4,5,6],[6,7,8]")
			local d=(en.dire+1)/2 --获取方向的索引
			--蛇的移动是四个方向的随机移动
			--限定距离(或时间)
			local wall_dire,_=check_wall_iswalk(en)--检测到朝墙壁
			if wall_dire!=0 then--如果靠近墙
				if wall_dire==data[d][1] or wall_dire==data[d][2] or wall_dire==data[d][3] then--移动方向与靠墙方向一致
					setspd_0(en)
					en.move_t=0
					en.state=en.allstate.idle
				else--随机移动
					rnd_move(en,en.move_t)
				end
			else--不靠近墙,随机移动
				rnd_move(en,en.move_t)
			end
			xypluspd(en)
			en.move_t = anim_sys(en.sprs.move,en,en.move_t,.2,1)
		end,
		hurt=function()
            en.wudi_t=anim_sys(en.sprs.hurt,en,en.wudi_t,.1,10)
			hurtdo(en,en.wudi_t)
			xypluspd(en)
		end,
		death=function()
			en.die_t+=.4
			death_do(en,en.die_t)
		end,
	}
	switchstate[en.state]()
end
function enstate_slime(en)
	if not en.slime_handler then
		local charge_t=0
		local tx,ty=0, 0
		local jump_t = nil
		local jump_start_x, jump_start_y=0, 0--跳跃初始位置
		en.slime_handler = function()
			local switchstate={
				idle=function()
					en.wudi_t=0
					charge_t=0
					tx,ty=0,0
					--因为slime的idle动画是循环播放的，所以这里需要判断是否需要播放idle动画
					--所以需要有idle_t来记录idle动画的播放时间
					en.idle_t=anim_sys(en.sprs.idle,en,en.idle_t,.1,1)
					
					--检测玩家位置靠近
					if check_p_dis(en,wy) then
						tx, ty=wy.x, wy.y
						en.state=en.allstate.charge
					end
					if check_en_hurt(sword,en,wy) then
						en.state=en.allstate.hurt
					end
					check_hp(en)
				end,
				charge=function() --蓄力
					charge_t = anim_sys(en.sprs.charge,en,charge_t,.1,4)
					if charge_t>=2 then 
						en.state=en.allstate.jump
					end
					if check_en_hurt(sword,en,wy) then
						en.state=en.allstate.hurt
					end
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
					--完成移动或者撞墙后重置状态
					if jump_progress >= 1 then
						jump_t = nil
						en.state = en.allstate.idle
					end
					en.frame=en.sprs.jump
					if check_en_hurt(sword,en,wy) then
						en.state=en.allstate.hurt
					end
					check_hp(en)
				end,
				hurt=function()
					en.wudi_t=anim_sys(en.sprs.hurt,en,en.wudi_t,.1,5)
					hurtdo(en,en.wudi_t)
					xypluspd(en)
				end,
				death=function()
					en.die_t+=.4
					death_do(en,en.die_t)
				end,
			}
			switchstate[en.state]()	
		end
	end
	en.slime_handler()
end
function enstate_bat(en)
	if not en.bat_handler then
		local rest_t,fly_t=0,0
		local tx, ty=0,0
		local angle,radius=0,0 -- 用于圆形飞行的角度-- 圆形飞行的半径
		local fly_init,fly_direction = false, 1 --是否初始化了飞行参数--飞行方向：1为顺时针，-1为逆时针
		local bat_start_x, bat_start_y=0,0

		en.bat_handler = function()
			local switchstate={
				idle=function()
					en.wudi_t=0
					fly_init = false --重置飞行初始化状态
					if check_p_dis(en,wy) then
						tx, ty=wy.x, wy.y
						bat_start_x, bat_start_y = en.x, en.y-- 记录蝙蝠的初始位置（当发现玩家时的位置）
						en.state=en.allstate.fly
					end
					en.frame=en.sprs.idle
					if check_en_hurt(sword,en,wy) then
						en.state=en.allstate.hurt
					end
					check_hp(en)
				end,
				fly=function()
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
							en.sprflip=true
						else
							fly_direction = -1 -- 顺时针
							en.sprflip=false
						end
						fly_init = true
					end
					-- 更新角度，实现旋转效果，结合en.speed和飞行方向来控制
					angle += 0.005 * en.speed * fly_direction
					-- 计算圆形飞行的新位置
					en.x = tx + radius * cos(angle)
					en.y = ty + radius * sin(angle)
					radius-=0.5 -- 控制飞行半径减小，使蝙蝠向玩家移动
					if  radius<=2 then
						en.state=en.allstate.rest
					end
					-- 循环播放飞行动画
					fly_t = anim_sys(en.sprs.fly, en, fly_t, 0.2, 1)
					if check_en_hurt(sword,en,wy) then
						en.state=en.allstate.hurt
					end
					check_hp(en)
				end,
				rest=function()
					rest_t+=.1
					if rest_t>=1 then
						en.state=en.allstate.idle
						en.crange=25 -- 检测范围
						rest_t=0
					end
					en.frame=en.sprs.rest
					if check_en_hurt(sword,en,wy) then
						en.state=en.allstate.hurt
					end
					check_hp(en)
				end,
				hurt=function()
					en.wudi_t=anim_sys(en.sprs.hurt, en, en.wudi_t, .1, 5)
					hurtdo(en, en.wudi_t)
					xypluspd(en)
				end,
				death=function()
					en.die_t+=.4
					death_do(en, en.die_t)
				end,
			}
			switchstate[en.state]()
		end
	end
	en.bat_handler()
end
function enstate_spider(en)
	spr_flip(en)
	local switchstate={
		idle=function()
			en.wudi_t=0
			en.move_t=0
			--按时进行随机方向
			en.idle_t+=.1
			::redo:: local dire=rnd({1,3,5,7})
			if en.idle_t>=2 then
				if en.lastdire==dire then --如果随机方向等于上一次的方向
					goto redo --回到随机位置
				else --如果随机方向不等于上一次的方向
					en.dire=dire
					en.lastdire=dire
					en.state=en.allstate.move
					en.idle_t=0
				end
			end
			en.frame=en.sprs.idle
			if check_en_hurt(sword,en,wy) then
				en.state=en.allstate.hurt
			end
			check_hp(en)
		end,
		move=function()
			if check_en_hurt(sword,en,wy) then
				en.state=en.allstate.hurt
			end
			local data=explodeval("[1,2,8],[2,3,4],[4,5,6],[6,7,8]")
			local d=(en.dire+1)/2 --获取方向的索引
			--移动是四个方向的随机移动
			--限定距离(或时间)
			local wall_dire,_=check_wall_iswalk(en)--检测到朝墙壁
			if wall_dire!=0 then--如果靠近墙
				if wall_dire==data[d][1] or wall_dire==data[d][2] or wall_dire==data[d][3] then--移动方向与靠墙方向一致
					setspd_0(en)
					en.move_t=0
					en.state=en.allstate.idle
				else--随机移动
					rnd_move(en,en.move_t)
				end
			else--不靠近墙,随机移动
				rnd_move(en,en.move_t)
			end
			xypluspd(en)
			en.move_t = anim_sys(en.sprs.move,en,en.move_t,.2,1)
		end,
		hurt=function()
           en.wudi_t=anim_sys(en.sprs.hurt,en,en.wudi_t,.1,10)
			hurtdo(en,en.wudi_t)
			xypluspd(en)
		end,
		death=function()
			en.die_t+=.4
			death_do(en,en.die_t)
		end,
	}
	switchstate[en.state]()
end
function enstate_ghost(en)
	-- 工厂模式：为每个 en 实例创建一个闭包处理器，闭包内使用局部的 apr_t/fly_t/rest_t
	if not en.ghost_handler then
		local apr_t=0
		local fly_t=0
		local rest_t=0

		en.ghost_handler = function()
			local switchstate={
				idle=function()
					--靠近后发现，切换到出现状态
					if check_p_dis(en,wy) then
						en.state=en.allstate.apr
					end
					en.frame=en.sprs.idle
				end,
				apr=function()
					apr_t = anim_sys(en.sprs.apr,en,apr_t,.1,2)
					en.y-=.2
					if apr_t>=5 then
						en.state=en.allstate.fly
						apr_t=0
					end
				end,
				fly=function()
					en.w,en.h=7,7
					fly_t = anim_sys(en.sprs.fly,en,fly_t,.1,1)
					--具体飞向玩家
					local tx,ty=wy.x,wy.y
					local angle = atan2(tx - en.x, ty - en.y)
					en.x += cos(angle) * en.speed
					en.y += sin(angle) * en.speed
					if wy.state==wy.allstate.hurt then
						en.state=en.allstate.rest
					end
					if wy.x < en.x then
						en.sprflip=true
					else
						en.sprflip=false
					end
					if check_en_hurt(sword,en,wy) then
						en.state=en.allstate.hurt
					end
					check_hp(en)
				end,
				rest=function()
					rest_t = anim_sys(en.sprs.apr,en,rest_t,.1,4)
					if rest_t>=2 then
						en.state=en.allstate.fly
						rest_t=0
					end
				end,
				hurt=function()
					en.wudi_t=anim_sys(en.sprs.hurt, en, en.wudi_t, .1, 5)
					--hurtdo(en, wudi_t)
					hurtmove(en,2.5)
					if en.wudi_t>=0.5 then
						en.state=en.allstate.fly
						en.hp-=1
					end
					xypluspd(en)
				end,
				death=function()
					en.die_t+=.4
					death_do(en, en.die_t)
				end,
			}
			switchstate[en.state]()
		end
	end
	-- 调用该实例的闭包处理器
	en.ghost_handler()
end

function enstate_lizi(en)
	local switchstate={
		idle=function()
			en.wudi_t=0
			en.move_t=0
			en.hurtframe=0
			en.idle_t+=.1
			::redo:: local dire=rnd({1,3,5,7})
			if en.idle_t>=4 then
				if dire==en.lastdire then
					goto redo
				else
					en.dire=dire
					en.lastdire=dire
					en.state=en.allstate.move
					en.idle_t=0
				end
			end				
			if check_en_hurt(sword,en,wy) then
				en.state=en.allstate.hurt
				en.hurtframe=(en.dire+1)/2
			end
			check_hp(en)
		end,
		move=function()
			local data=explodeval("[1,2,8],[2,3,4],[4,5,6],[6,7,8]")
			local d=(en.dire+1)/2 --获取方向的索引
			if check_en_hurt(sword,en,wy) then
				en.state=en.allstate.hurt
				en.hurtframe=(en.dire+1)/2
			end
			local wall_dire,_=check_wall_iswalk(en)--检测到朝墙壁
			if wall_dire!=0 then--如果靠近墙
				if wall_dire==data[d][1] or wall_dire==data[d][2] or wall_dire==data[d][3] then--移动方向与靠墙方向一致
					setspd_0(en)
					en.move_t=0
					en.state=en.allstate.idle
				else
					en.spd.spx,en.spd.spy=dirx[en.dire]*en.speed,diry[en.dire]*en.speed
				end
			else--不靠近墙,随机移动
				en.spd.spx,en.spd.spy=dirx[en.dire]*en.speed,diry[en.dire]*en.speed
			end
			--四方向移动
			if en.dire==1 then
				en.sprflip=false
			elseif en.dire==5 then
				en.sprflip=true
			end
			xypluspd(en)
			--时间到了切换idle状态
			en.move_t+=0.1
			if en.move_t>=6 then
				en.move_t=0
				en.state=en.allstate.idle
			end
			anim_sys(en.sprs.move[(en.dire+1)/2],en,en.move_t,.1,1)
			--检测到玩家，切换射击状态
			if check_p(en,en.crange) then
				en.state=en.allstate.atk
				init_cnut(en)--生成子弹
			end
		end,
		atk=function()
			en.atk_t+=.1
			check_en_hurt(sword,en,wy)
			--发射子弹
			if cnut.t>=0.4 then
				en.state=en.allstate.idle
			end
		end,
		hurt=function()
			en.wudi_t=anim_sys(en.sprs.hurt[en.hurtframe],en,en.wudi_t,.1,8)
			hurtdo(en,en.wudi_t)
			xypluspd(en)
		end,
		death=function()
			en.die_t+=.4
			death_do(en, en.die_t)
			--死亡掉落
	
		end,
	}
	switchstate[en.state]()
end
