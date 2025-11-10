function enstate_urchin(en)--小海胆：静止不动，玩家触碰会掉血，攻击弹开死亡(爆炸)，一滴血
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
		death=function()--死亡爆炸
			debug1="death"
			en.die_t+=.4
			death_do(en,en.die_t)
		end,
	}
	switchstate[en.state]()
end
function enstate_snake(en)--小蛇
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
function enstate_slime(en)--史莱姆
	local switchstate={
		idle=function()
			en.wudi_t=0
			en.charge_t=0
			en.tx,en.ty=0,0
			--因为slime的idle动画是循环播放的，所以这里需要判断是否需要播放idle动画
			--所以需要有idle_t来记录idle动画的播放时间
			en.idle_t=anim_sys(en.sprs.idle,en,en.idle_t,.1,1)
			
			--检测玩家位置靠近
			if check_p_dis(en,wy) then
				en.tx, en.ty=wy.x, wy.y
				en.state=en.allstate.charge
			end
			if check_en_hurt(sword,en,wy) then
				en.state=en.allstate.hurt
			end
			check_hp(en)
		end,
		charge=function() --蓄力
			en.charge_t = anim_sys(en.sprs.charge,en,en.charge_t,.1,4)
			if en.charge_t>=2 then 
				en.state=en.allstate.jump
			end
			if check_en_hurt(sword,en,wy) then
				en.state=en.allstate.hurt
			end
			check_hp(en)
		end,
		jump=function()
			--跳跃移动到玩家位置（线性平移）
			if en.jump_t == nil then
					en.jump_t = 0
				--记录初始位置和跳跃方向
				en.jump_start_x,en.jump_start_y = en.x,en.y
			end
			--更新跳跃计时器
			en.jump_t += 0.2
			--计算移动进度
			local jump_progress = min(1, en.jump_t / 3) --控制移动时间
			--线性移动到目标位置
			en.x = en.jump_start_x + (en.tx - en.jump_start_x) * jump_progress
			en.y = en.jump_start_y + (en.ty - en.jump_start_y) * jump_progress		
			--完成移动或者撞墙后重置状态
			if jump_progress >= 1 then
				en.jump_t = nil
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
function enstate_bat(en) --小蝙蝠
	local switchstate={
		idle=function()
			en.wudi_t=0
			en.fly_init = false --重置飞行初始化状态
			if check_p_dis(en,wy) then
				en.tx, en.ty=wy.x, wy.y
				en.bat_start_x, en.bat_start_y = en.x, en.y-- 记录蝙蝠的初始位置（当发现玩家时的位置）
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
			if not en.fly_init then
				-- 计算初始半径（蝙蝠当时与玩家的距离）
				en.radius = sqrt((en.bat_start_x - en.tx)^2 + (en.bat_start_y - en.ty)^2)
				-- 计算初始角度（使用蝙蝠的初始位置）pico-8中:atan2(x,y)
				en.angle = atan2(en.bat_start_x - en.tx,en.bat_start_y - en.ty)
				-- 根据玩家相对于蝙蝠的位置决定飞行方向
				-- 如果玩家在蝙蝠的左边，逆时针飞行（负方向）
				-- 如果玩家在蝙蝠的右边，顺时针飞行（正方向）
				if wy.x < en.x then
					en.fly_direction = 1 -- 逆时针
					en.sprflip=true
				else
					en.fly_direction = -1 -- 顺时针
					en.sprflip=false
				end
				en.fly_init = true
			end
			-- 更新角度，实现旋转效果，结合en.speed和飞行方向来控制
			en.angle += 0.005 * en.speed * en.fly_direction
			-- 计算圆形飞行的新位置
			en.x = en.tx + en.radius * cos(en.angle)
			en.y = en.ty + en.radius * sin(en.angle)
			en.radius-=0.5 -- 控制飞行半径减小，使蝙蝠向玩家移动
			if  en.radius<=2 then
				en.state=en.allstate.rest
			end
			-- 循环播放飞行动画
			en.fly_t = anim_sys(en.sprs.fly, en, en.fly_t, 0.2, 1)
			if check_en_hurt(sword,en,wy) then
				en.state=en.allstate.hurt
			end
			check_hp(en)
		end,
		rest=function()
			en.rest_t+=.1
			if en.rest_t>=1 then
				en.state=en.allstate.idle
				en.crange=25 -- 检测范围
				en.rest_t=0
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
function enstate_spider(en) --小蜘蛛
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
	local switchstate={
		idle=function()
			--靠近后发现，切换到出现状态
			if check_p_dis(en,wy) then
				en.state=en.allstate.apr
			end
			en.frame=en.sprs.idle
		end,
		apr=function()
			en.apr_t=anim_sys(en.sprs.apr,en,en.apr_t,.1,2)
			en.y-=.2
			if en.apr_t>=5 then
				en.state=en.allstate.fly
				en.apr_t=0
			end
		end,
		fly=function()
			en.w,en.h=7,7
			en.fly_t = anim_sys(en.sprs.fly,en,en.fly_t,.1,1)
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
			en.rest_t=anim_sys(en.sprs.apr,en,en.rest_t,.1,4)
			if en.rest_t>=2 then
				en.state=en.allstate.fly
				en.rest_t=0
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

function enstate_lizi(en) --丢栗怪
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
		end,
	}
	switchstate[en.state]()
end
