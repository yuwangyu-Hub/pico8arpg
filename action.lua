function updatePlayerState(player)--状态机: 更新玩家状态
	--检测方向
	if player.state!= player.allstate.roll and player.state!= player.allstate.attack and player.state!= player.allstate.hurt then
		input_direct_sys(player)
	end
	--角色移动加成（翻滚或移动或推）
	if (player.dire>0 or player.state==player.allstate.roll) and player.state!=player.allstate.attack then
		player.x,player.y=player.x+player.spd.spx,player.y+player.spd.spy
	end
	local switchstate={
		idle = function()
			player.spd.spx=0
			player.spd.spy=0
			--重置精灵偏移（推动需要）
			player.spr_cx=0
			player.spr_cy=0
            if player.dire!=0 and not player.isroll then
				player.state=player.allstate.move
            end
			if player.isattack then --攻击
				sword.isappear=true
                attack_swordpos(player)
				player.state=player.allstate.attack
			end
			if player.isroll then --翻滚
				player.state=player.allstate.roll
			end
			--动画
			player.frame=player.sprs.idle
		end,
		move = function()
			---------切换
			if player.dire==0 then
				player.move_t=0
				player.state=player.allstate.idle
			end
			if player.isattack then
				sword.isappear=true
                attack_swordpos(player)
				player.state=player.allstate.attack
			end
			if player.isroll then
				player.state=player.allstate.roll
			end
			--与可交互物体的碰撞（收集/推动）
			near_o=findNearestObject(obj, player)--检测最近的物体
			near_e=findNearestObject(enemies, player)--检测最近的敌人
			local colldire_o=checkdir(near_o,player)--物品在主角的朝向
			local colldire_e=checkdir(near_e,player)--敌人在主角的朝向
			local is_o_coll=ck_sthcoll(near_o, player, 0, 0, 0, 0)
			local is_e_coll=ck_sthcoll(near_e, player, 0, 0, 0, 0)
			local is_wall_coll_dire,oneside=check_wall_iswalk(player)--获取墙在玩家的位置，在边缘的哪一侧
		
			if is_o_coll then ---------------与物体(最近的箱子)与主角之间碰撞--------------
				debug="o_coll"
				--确保物体和获取的金币分开，避免金币影响物体的推动
				if near_o.type=="move" then
					move_and_push(near_o,player,colldire_o,is_wall_coll_dire)
				elseif near_o.type=="collect" then
					--收集
				end
			elseif is_wall_coll_dire!=0 and not is_o_coll then --与墙体的碰撞---------------------------
				debug="wall_coll"
				wallcoll_move(player,is_wall_coll_dire,oneside)
			elseif is_e_coll then----------------与敌人（最近的）碰撞
				debug="en_coll"
				encoll_move(player,colldire_e)
			else ---------------------------------普通移动----------------------------
				debug="move"
				move(player)
				move_anim(player)
			end
			
		end,
		attack=function()
			local get_attack_frame = function(dire) --内部封装了一个函数
				if dire==1 or dire==5 or dire==0 then return 1
				elseif dire==2 or dire==3 or dire==4 then return 3
				else return 2 end
			end
			player.frame=player.sprs.attack[get_attack_frame(player.dire)]
			player.att_t+=.2
			if player.att_t>2 then
				player.isattack=false
				sword.isappear=false
				player.att_t=0
				player.state=player.allstate.idle
			end
		end,
		roll=function()
			--*翻滚撞墙弹回
			player.rollspeed=3
            --player.rollspeed=nomalize(player,2.1213,3)
			roll(player)
			--动画相关
			player.roll_t+=0.5
			player.frame=player.sprs.roll[ceil(player.roll_t%#player.sprs.roll)]
			if player.roll_t>=5 then
				player.spd.spx=0
				player.spd.spy=0
				player.isroll=false
				player.roll_t=0
				player.state=player.allstate.idle
			end
		end,
		hurt=function()
			
			hurtmove(player)
			hurt_anim(player)
			player.x,player.y=player.x+player.spd.spx,player.y+player.spd.spy
		end,
		death=function()
		end
	}
	player.lastdire=player.dire--记录上一次的方向
	switchstate[player.state]()
end

