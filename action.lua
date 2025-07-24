function updatePlayerState(player)--状态机: 更新玩家状态
	--检测方向
	if player.state!= player.allstate.roll and player.state!= player.allstate.attack then
		input_direct_sys(player)
	end
	--角色移动加成（翻滚或移动或推）
	if (player.dire>0 or player.state==player.allstate.roll) and player.state!=player.allstate.attack then
		player.x,player.y=player.x+player.spd.spx,player.y+player.spd.spy
	end
	local switchstate={
		idle = function()
            if player.dire!=0 and not player.isroll then
				player.state=player.allstate.move
            end
			if player.isattack then
				sword.isappear=true
                attack_swordpos(player)
				player.state=player.allstate.attack
			end
			if player.isroll then
				player.state=player.allstate.roll
			end
			--动画
			player.frame=player.sprs.idle
		end,
		move = function()
			local x1,y1=0,0
			local x2,y2=0,0
			if player.dire==1 then
				x1=0
				y1=0
				x2=0
				y2=0
			elseif player.dire==3 then

			elseif player.dire==5 then

			elseif player.dire==7 then

			end
		
			--player.speed = nomalize(player,.7,1)
			if check_wall_iswalk(player) then --
				move(player)
				move_anim(player)
			else
				--推墙
				player.spd.spx=0
				player.spd.spy=0
				pull_anim(player) --都使用推的动画
			end
			--[[
			near_o=findNearestObject(obj, player)
			local colldire=checkdir(near_o,player)
			debug=colldire
			local direnum=(colldire+1)/2
			if ck_sthcoll(near_o, player, 0, 0, 0, 0) then --检测物体(最近的)与主角之间碰撞
				if colldire==1 or colldire==3 or colldire==5 or colldire==7 then--物体在角色的正方向（1357）
					local direnum=(colldire+1)/2
					if checkcoll_edge(near_o,wy,colldire) then --如果在边缘
						if  coll_date[direnum][6]==1 then --检测x方向
							if abs(near_o.x-(player.x+player.w))<=3 and player.dire==coll_date[direnum][1] then
								player.spd.spx=-player.speed
								player.spd.spy=0
							elseif abs((near_o.x+near_o.w)-player.x)<=3 and player.dire==coll_date[direnum][1] then
								player.spd.spx=player.speed
								player.spd.spy=0
							end
						elseif coll_date[direnum][7]==1 then--检测y方向
								if abs(near_o.y-(player.y+player.h))<=3 and player.dire==coll_date[direnum][1] then
										player.spd.spx=0
										player.spd.spy= -player.speed
								elseif abs((near_o.y+near_o.h)-player.y)<=3 and player.dire==coll_date[direnum][1] then
										player.spd.spx=0
										player.spd.spy=player.speed
								end
						end
					else --不在边缘
						if wy.dire==coll_date[direnum][1] then --当前移动方向=物体所在对象方向
							wy.state=wy.allstate.push
						elseif wy.dire==coll_date[direnum][2] or wy.dire==coll_date[direnum][3] then
							wy.spd.spx=dirx[wy.dire]*wy.speed*coll_date[direnum][6]
							wy.spd.spy=diry[wy.dire]*wy.speed*coll_date[direnum][7]
							pull_anim(wy)
						else
							wy.state=wy.allstate.idle
						end
						
					end
				end
			else
				move(player)
			end
			]]
			
			
			
			
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
		push=function()
			--local colldire=checkdir(near_o,player)--检测方向
			--move_and_push(near_o,player,colldire)
			--检测推的物体的类型
			if near_o.type=="move" then--推动
				if player.dire ==1 then
					player.spd.spx=0
					player.spd.spy=diry[player.dire]*player.speed*1
				elseif player.dire ==3 then
					player.spd.spx=dirx[player.dire]*player.speed*1
					player.spd.spy=0
				elseif player.dire ==5 then
					player.spd.spx=0
					player.spd.spy=diry[player.dire]*player.speed*1
				elseif player.dire ==7 then
					player.spd.spx=dirx[player.dire]*player.speed*1
					player.spd.spy=0
				end
			elseif near_o.type=="collect" then--收集
				pushsth(near_o,player)
			end
			pull_anim(player) --都使用推的动画
			if player.dire==0 then
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

