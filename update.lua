function update_game()
	wyfsm(wy)--主角的行为
	--chase(snake,wy)
	spr_flip(wy)
	--wy.y+=1
	
	near_o=cdis(obj,wy)
	colldire=checkdir(near_o,wy)
	if ck_sthcoll(near_o,wy,0,0,0,0) then--检测物体与主角之间碰撞
		if wy.state=="roll" then --翻滚状态碰撞

		elseif wy.state=="hurt" then --受伤状态碰撞

		elseif wy.state=="move" then --move
			if not wy.iscoll then --如果之前没碰撞
				wy.spd.spx=0
				wy.spd.spy=0
				wy.iscoll=true
			end
			if colldire==1 or colldire==3 or colldire==5 or colldire==7 then--物体在角色的正方向（1357）
				local direnum=(colldire+1)/2
				if checkcoll_edge(near_o,wy,colldire) then --如果在边缘
					wy.state=wy.allstate.move
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
			else --物体在角色的直对角线位置2468
				check_Diagonal(colldire,wy)
			end

		end

		
	else
		wy.iscoll=false
	end
	
	if check_p_hurt(wy) then
		wy.state=wy.allstate.hurt
	end

end
function update_mamenu()
	blinkt+=1
	input_mamenu()--主菜单
end
function update_gover()
end
function update_win()
end

