function updatep_state(player)--状态机: 更新玩家状态
	spr_flip(wy)--精灵的反转
	--检测方向
	if player.state== player.allstate.idle or player.state== player.allstate.move then
		input_direct_sys(player)
	end
	--角色移动加成（翻滚或移动或推）
	if player.dire>0 and player.state!=player.allstate.attack then
		player.x,player.y=player.x+player.spd.spx,player.y+player.spd.spy
	end
	local near_o,colldire_o,is_o_coll
	if #obj!=0 then --物体不为空
		near_o=findnearest_object(obj, player)--检测最近的物体
		colldire_o=checkdir(near_o,player)--物品在主角的朝向
		is_o_coll=ck_sthcoll(near_o, player, 0, 0, 0, 0)
	end
	local is_wall_coll_dire,oneside=check_wall_iswalk(player)--获取墙在玩家的位置，在边缘的哪一侧
		--debug=is_wall_coll_dire
	local switchstate={
		idle = function()
			player.isroll=false
			player.roll_t=0
			setspd_0(player)
            if player.dire!=0 and not player.isroll  then
				player.state=player.allstate.move
            end
			if player.isattack then --攻击
				sword.isappear=true
                attack_swordpos(player,sword)
				player.state=player.allstate.attack
			end
			--动画
			player.frame=player.sprs.idle
		end,
		move = function()
			---------切换状态-----------------
			if player.dire==0 then
				player.move_t=0
				player.state=player.allstate.idle
			else
				player.lastdire=player.dire--记录上一次的方向
				if player.isroll and not player.ishurt then
					player.state=player.allstate.roll
				end
			end
			if player.isattack then
				sword.isappear=true
                attack_swordpos(player,sword)
				player.state=player.allstate.attack
			end
			--与可交互物体的碰撞（收集/推动）
			if is_o_coll then ---------------与物体(最近的箱子)与主角之间碰撞--------------
				--确保物体和获取的金币分开，避免金币影响物体的推动
				if near_o.type=="move" then--推动	
				elseif near_o.type=="collect" then--收集	
				end
			elseif is_wall_coll_dire!=0 then --与墙体的碰撞---------------------------
				wallcoll_move(player,is_wall_coll_dire,oneside)
			else ---------------------------------普通移动----------------------------
				move(player)
				move_anim(player)
			end
		end,
		attack=function()
			setspd_0(player)
			local att_frame = function(dire) --内部封装了一个函数
				if dire==1 or dire==5 then 
					return 3
				elseif dire==2 or dire==4 then 
					return 2
				elseif dire==8 or dire==6 then 
					return 4
				elseif dire==3 then
					return 1
				else --7
					return 5
				end
			end
			player.frame=player.sprs.attack[att_frame(player.lastdire)]
			player.att_t+=.2
			if player.att_t>2 then
				player.isattack=false
				sword.isappear=false
				player.att_t=0
				player.state=player.allstate.idle
			end
		end,
		roll=function()
			local is_wall_coll_dire,oneside=check_wall_iswalk(player)--获取墙在玩家的位置，在边缘的哪一侧
			player.rollspeed=3
            player.rollspeed=nomalize(player,2.1213,3)
			roll(player,is_wall_coll_dire)

			--动画相关
			player.roll_t+=0.5
			player.frame=player.sprs.roll[ceil(player.roll_t%#player.sprs.roll)]

			--翻滚所需时间结束
			if player.roll_t>=5  then
				setspd_0(player)
				player.isroll=false
				player.roll_t=0
				player.state=player.allstate.idle
				setflrxy(player)--前面翻滚的归一化会导致一定xy坐标不为整数的可能性。
			end
		end,
		hurt=function()
			player.hurtmt+=0.1
			--无敌闪烁
			hurtmove(player)
			if player.hurtmt>=0.7 then
				player.hurtmt=0
				player.state=player.allstate.idle
			end
			hurt_anim(player)
			setflrxy(player)
			player.x,player.y=player.x+player.spd.spx,player.y+player.spd.spy
		end,
		death=function()
		end
	}
	switchstate[player.state]()
end
function enstate_a(en) --大眼怪，静止不动
	local switchstate={
		stay=function()--静止不动
			if check_en_hurt(sword) then
				en.health-=1
			end
			if en.health<=0 then
				en.state="death"
			end
		end,
		hurt=function()--受伤弹开
			
		end,
		death=function()--死亡爆炸
			debug="death"
		end,
	}
	switchstate[en.state]()
end

function enstate_b(en) 
	local switchstate={
		
	}
end
function enstate_c(en) 
	local switchstate={
		
	}
end
function enstate_d(en) 
	local switchstate={
		
	}
end
function enstate_e(en) 
	local switchstate={
		
	}
end
function enstate_f(en) 
	local switchstate={
		
	}
end
function enstate_g(en) 
	local switchstate={
		
	}
end
