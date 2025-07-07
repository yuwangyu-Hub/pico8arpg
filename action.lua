function wyfsm(sb)--状态机
	--检测方向
	if sb.state!= sb.allstate.roll and sb.state!= sb.allstate.attack then
		input_direct_sys(sb)
	end
	--角色移动加成（翻滚或移动或推）
	if (sb.dire>0 or sb.state==sb.allstate.roll) and sb.state!=sb.allstate.attack then
		sb.x,sb.y=sb.x+sb.spd.spx,sb.y+sb.spd.spy
	end
	local switchstate={
		idle = function()
            if sb.dire!=0 and not sb.isroll then
				sb.state=sb.allstate.move
            end
			if sb.isattack then
				sword.isappear=true
                attack_swordpos(sb)
				sb.state=sb.allstate.attack
			end
			if sb.isroll then
				sb.state=sb.allstate.roll
			end
			--动画
			sb.frame=sb.sprs.idle
		end,
		move = function()
			--sb.speed = nomalize(sb,.7,1)
			local direnum=(colldire+1)/2
			if checkcoll_edge(near_o,wy,colldire) then --如果在边缘
				if  coll_date[direnum][6]==1 then --检测x方向
						if abs(near_o.x-(wy.x+wy.w))<=3 and wy.dire==coll_date[direnum][1] then
							wy.spd.spx=-wy.speed
							wy.spd.spy=0
						elseif abs((near_o.x+near_o.w)-wy.x)<=3 and wy.dire==coll_date[direnum][1] then
							wy.spd.spx=wy.speed
							wy.spd.spy=0
						end
				elseif coll_date[direnum][7]==1 then--检测y方向
						if abs(near_o.y-(wy.y+wy.h))<=3 and wy.dire==coll_date[direnum][1] then
							wy.spd.spx=0
							wy.spd.spy= -wy.speed
						elseif abs((near_o.y+near_o.h)-wy.y)<=3 and wy.dire==coll_date[direnum][1] then
							wy.spd.spx=0
							wy.spd.spy=wy.speed
						end
				end
			else
				move(sb)
			end
			
			
			move_anim(sb)
			
			if sb.dire==0 then
				sb.move_t=0
				sb.state=sb.allstate.idle
			end
			if sb.isattack then
				sword.isappear=true
                attack_swordpos(sb)
				sb.state=sb.allstate.attack
			end
			if sb.isroll then
				sb.state=sb.allstate.roll
			end
		end,
		attack=function()
			if sb.dire==1 or sb.dire ==5 or sb.dire==0 then
				sb.frame=sb.sprs.attack[1]
			elseif sb.dire==2 or sb.dire== 3 or sb.dire==4 then
				sb.frame=sb.sprs.attack[3]
			else
				sb.frame=sb.sprs.attack[2]
			end
			sb.att_t+=.2
			if sb.att_t>2 then
				sb.isattack=false
				sword.isappear=false
				sb.att_t=0
				sb.state=sb.allstate.idle
			end
		end,
		roll=function()
			--*翻滚撞墙弹回
			sb.rollspeed=3
            --sb.rollspeed=nomalize(sb,2.1213,3)
			roll(sb)
			--动画相关
			sb.roll_t+=0.5
			sb.frame=sb.sprs.roll[ceil(sb.roll_t%#sb.sprs.roll)]
			if sb.roll_t>=5 then
				sb.spd.spx=0
				sb.spd.spy=0
				sb.isroll=false
				sb.roll_t=0
				sb.state=sb.allstate.idle
			end
		end,
		push=function()
			--local colldire=checkdir(near_o,wy)--检测方向
			--move_and_push(near_o,sb,colldire)
			if near_o.type=="fixed" then
				if wy.dire ==1 then
					wy.spd.spx=0
					wy.spd.spy=diry[wy.dire]*wy.speed*1
				elseif wy.dire ==3 then
					wy.spd.spx=dirx[wy.dire]*wy.speed*1
					wy.spd.spy=0
				elseif wy.dire ==5 then
					wy.spd.spx=0
					wy.spd.spy=diry[wy.dire]*wy.speed*1
				elseif wy.dire ==7 then
					wy.spd.spx=dirx[wy.dire]*wy.speed*1
					wy.spd.spy=0
				end
			elseif near_o.type=="move" then
				pushsth(near_o,wy)
			end
			pull_anim(wy)
		end,
		hurt=function()
			hurtmove(sb)
			hurt_anim(sb)
			sb.x,sb.y=sb.x+sb.spd.spx,sb.y+sb.spd.spy
		end,
		death=function()
		end
	}
	sb.lastdire=sb.dire--记录上一次的方向
	switchstate[sb.state]()
end

