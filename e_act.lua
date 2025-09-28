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
				debug="slime_idle"
				hurtm_t=0
				charge_t=0
				tx,ty=0,0
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
					--确保精确到达目标位置
					--en.x = tx
					--en.y = ty
				end
				en.frame=en.sprs.jump
				check_en_hurt(sword,en,wy)
				check_hp(en)
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
function enstate_bat(en) 
	local switchstate={
		
	}
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
