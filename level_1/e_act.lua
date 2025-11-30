function enstate_urchin(en)
	local switchstate={
		idle=function()
			en.wudi_t=0
			if check_en_hurt(sword,en,wy) then
				en.state=en.allstate.hurt
			end
			check_hp(en)
		end,
		hurt=function()--受伤弹开
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
function enstate_crab(en)--螃蟹
	spr_flip(en)
	local switchstate={
		idle=function()
			en.wudi_t,en.move_t=0,0
			--按时进行随机方向
			en.idle_t+=.1
			::redo:: local dire=rnd({1,3,5,7})
			if en.idle_t>=2 then
				if en.lastdire==dire then --如果随机方向等于上一次的方向
					goto redo --回到随机位置
				else --如果随机方向不等于上一次的方向
					en.dire, en.lastdire, en.state, en.idle_t=dire, dire, en.allstate.move, 0
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
			local wall_dire,_=check_wall_iswalk(en,8,8)--检测到朝墙壁
			if wall_dire!=0 then--如果靠近墙
				if wall_dire==data[d][1] or wall_dire==data[d][2] or wall_dire==data[d][3] then--移动方向与靠墙方向一致
					setspd_0(en)
					en.move_t,en.state=0,en.allstate.idle
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
		local charge_t,tx,ty,jump_start_x,jump_start_y,jump_t=0,0,0,0,0--跳跃初始位置
		en.slime_handler = function()
			local switchstate={
				idle=function()
					en.wudi_t=0
					charge_t,tx,ty=0,0,0
					--因为slime的idle动画是循环播放的，所以这里需要判断是否需要播放idle动画
					--所以需要有idle_t来记录idle动画的播放时间
					en.idle_t=anim_sys(en.sprs.idle,en,en.idle_t,.1,1)
					--检测玩家位置靠近
					if check_p_dis(en,wy)  then
						if en_nestwall(wy,en) then
							tx, ty=wy.x, wy.y
							en.state=en.allstate.charge
						end
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
					--*穿墙bug
					--如果跳跃过程中碰到墙壁，直接停止跳跃，回到idle状态
					debug3=en_nestwall(wy,en)
					if not en_nestwall(wy,en) then
						jump_t=nil
						en.state = en.allstate.idle
					end
					--跳跃移动到玩家位置（线性平移）
					if jump_t == nil then
						jump_t=0
						--记录初始位置和跳跃方向
						jump_start_x,jump_start_y=en.x,en.y
					end
					--更新跳跃计时器
					jump_t+=0.2
					--计算移动进度
					local jump_progress=min(1, jump_t / 3) --控制移动时间
					--线性移动到目标位置
					en.x,en.y=jump_start_x + (tx - jump_start_x) * jump_progress,jump_start_y + (ty - jump_start_y) * jump_progress		
					--完成移动或者撞墙后重置状态
					if jump_progress>=1 then
						jump_t=nil
						en.state=en.allstate.idle
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
function enstate_spider(en)
	spr_flip(en)
	local switchstate={
		idle=function()
			en.wudi_t,en.move_t=0,0
			--按时进行随机方向
			en.idle_t+=.1
			::redo:: local dire=rnd({1,3,5,7})
			if en.idle_t>=2 then
				if en.lastdire==dire then --如果随机方向等于上一次的方向
					goto redo --回到随机位置
				else --如果随机方向不等于上一次的方向
					en.dire,en.lastdire,en.state,en.idle_t=dire,dire,en.allstate.move,0
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
			local data,d=explodeval("[1,2,8],[2,3,4],[4,5,6],[6,7,8]"),(en.dire+1)/2 --获取方向的索引
			--移动是四个方向的随机移动
			--限定距离(或时间)
			local wall_dire,_=check_wall_iswalk(en,8,8)--检测到朝墙壁
			if wall_dire!=0 then--如果靠近墙
				if wall_dire==data[d][1] or wall_dire==data[d][2] or wall_dire==data[d][3] then--移动方向与靠墙方向一致
					setspd_0(en)
					en.move_t,en.state=0,en.allstate.idle
				else--随机移动
					rnd_move(en,en.move_t)
				end
			else--不靠近墙,随机移动
				rnd_move(en,en.move_t)
			end
			xypluspd(en)
			en.move_t=anim_sys(en.sprs.move,en,en.move_t,.2,1)
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
function enstate_lizi(en)
	local switchstate={
		idle=function()
			en.wudi_t,en.move_t,en.hurtframe=0,0,0
			en.idle_t+=.1
			::redo:: local dire=rnd({1,3,5,7})
			if en.idle_t>=4 then
				if dire==en.lastdire then
					goto redo
				else
					en.dire,en.lastdire,en.state,en.idle_t=dire,dire,en.allstate.move,0
				end
			end				
			if check_en_hurt(sword,en,wy) then
				en.state,en.hurtframe=en.allstate.hurt,(en.dire+1)/2
			end
			check_hp(en)
		end,
		move=function()
			local data,d=explodeval("[1,2,8],[2,3,4],[4,5,6],[6,7,8]"),(en.dire+1)/2 --获取方向的索引
			if check_en_hurt(sword,en,wy) then
				en.state,en.hurtframe=en.allstate.hurt,(en.dire+1)/2
			end
			local wall_dire,_=check_wall_iswalk(en,8,8)--检测到朝墙壁
			if wall_dire!=0 then--如果靠近墙
				if wall_dire==data[d][1] or wall_dire==data[d][2] or wall_dire==data[d][3] then--移动方向与靠墙方向一致
					setspd_0(en)
					en.move_t,en.state=0,en.allstate.idle
				else
					en.spd.spx,en.spd.spy=dirx[en.dire]*en.speed,diry[en.dire]*en.speed
				end
			else--不靠近墙,随机移动
				en.spd.spx,en.spd.spy=dirx[en.dire]*en.speed,diry[en.dire]*en.speed
			end
			spr_flip(en)
			xypluspd(en)
			--时间到了切换idle状态
			en.move_t+=0.1
			if en.move_t>=6 then
				en.move_t,en.state=0,en.allstate.idle
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
