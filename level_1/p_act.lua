function updatep_state(player)--状态机: 更新玩家状态
	local pst,ps=player.allstate,player.sprs
	
	spr_flip(player)--精灵的反转
	local near_o,is_o_coll--colldire_o,
	if #obj!=0 then --物体不为空
		--colldire_o=checkdir(near_o,player)--物品在主角的朝向
		near_o=findnearest_object(obj, player)--检测最近的物体
		if near_o.appear==1 then--当物体出现的时候才检测碰撞
			is_o_coll=ck_sthcoll(player,near_o)
		end
	end
	
	local is_wall_coll_dire,oneside=check_wall_iswalk(player.cx,player.cy,player.cw+1,player.ch+1,player.mappos)--获取墙在玩家的位置，在边缘的哪一侧
	local switchstate={
		idle = function()
			player.isroll,player.roll_t=false,0
			setspd_0(player)
            if player.dire!=0 and not player.isroll  then
				player.state=pst.move
            end
			if player.isattack and player.getsowrd then --攻击
				sword.isappear,player.state=true,pst.attack
                attack_swordpos(player,sword)
			end
			--动画
			player.frame=ps.idle
		end,
		move = function()
			--切换状态--
			if player.dire==0 then
				player.move_t,player.state=0,pst.idle
			else
				player.lastdire=player.dire--记录上一次的方向
				if player.isroll and not player.ishurt then
            		player.rollspeed,player.state=nomalize(player,2.1213,3),pst.roll
				end
				if is_wall_coll_dire!=0 then --与墙体的碰撞--
					wallcoll_move(player,is_wall_coll_dire,oneside)
				else --普通移动-- 0 
					
					move(player)
					player.move_t=anim_sys(ps.move,player,player.move_t,.2,1)
				end
				xypluspd(player)
			end
			--攻击
			if player.isattack and player.getsowrd then
				sword.isappear,player.state=true,pst.attack
                attack_swordpos(player,sword)
			end

			--获得
			if player.getsth then
				player.state=pst.get
			end
			--[[与可交互物体的碰撞（收集/推动）
			if is_o_coll then ---------------物体(最近的箱子)与主角之间碰撞--------------
				--确保物体和获取的金币分开，避免金币影响物体的推动
				if near_o.type=="move" then--推动	
				elseif near_o.type=="get" then--获取
					--如果当前血量大于血量，则当前血量等于血量	
					if player.curhp>player.hp then
						player.curhp=player.hp
					end
				end
			elseif is_wall_coll_dire!=0 then --与墙体的碰撞---------------------------
				
				wallcoll_move(player,is_wall_coll_dire,oneside)
			else ---------------------------------普通移动----------------------------
				move(player)
    			player.move_t=anim_sys(player.sprs.move,player,player.move_t,.2,1)
			end]]
			if is_o_coll then ---------------物体(最近的箱子)与主角之间碰撞--------------
				--确保物体和获取的金币分开，避免金币影响物体的推动
				--如果当前血量大于血量，则当前血量等于血量	
				if near_o.name=="sword" then
					player.getsowrd,player.getsth=true,true
					del(obj,near_o)
				end
				if near_o.name=="heal_1" then
					if player.curhp<player.hp then 
						player.curhp+=1
					end
					del(obj,near_o)
				elseif near_o.name=="addheart" then
					player.getsth=true
					player.getadheart=true
					del(obj,near_o)
				end
			end
		end,
		attack=function()
			setspd_0(player)
			local att_frame = function(dire) --内部封装了一个函数
				return ({[1]=3,[5]=3,[2]=2,[4]=2,[8]=4,[6]=4,[3]=1})[dire] or 5
			end
			player.frame=ps.attack[att_frame(player.lastdire)]
			player.att_t+=.2
			if player.att_t>2 then
				player.isattack,sword.isappear=false,false
				player.att_t,player.state=0,pst.idle
			end
		end,
		roll=function()
			roll(player,is_wall_coll_dire)
			--动画相关
			player.roll_t+=0.5
			anim_sys(ps.roll,player,player.roll_t,.5,1)
			xypluspd(player)
		end,
		get=function()
			player.getsth=false
			player.get_t+=1
			player.frame=ps.get
			if player.get_t>=30 then
				player.state=pst.idle
				player.get_t=0
				if player.getadheart then
					if player.hp<player.maxhp then
						player.hp+=1
						player.curhp=player.hp
						player.getadheart=false
					end
				end
			end
		end,
		switch=function()
			player.switch_t+=1
			if player.switch_t>=5 then
				player.switch_t=0
				player.state=pst.idle
			end
			player.frame=ps.idle
		end,
		hurt=function()
			player.hurtmt+=0.1
			hurtmove(player,1)
			if player.hurtmt>=1 then
				player.hurtmt,player.state=0,pst.idle
				player.curhp-=1	
			end
			anim_sys(ps.hurt,player,player.hurtmt,.1,5)
			setflrxy(player)
			xypluspd(player)
			if player.curhp<=0 then--检测玩家死亡
				_upd,_drw=update_gover,draw_gover
			end
		end,
		death=function()
			--死亡
		end
	}
	switchstate[player.state]()
end



