--行为
function wyfsm(sb)--状态机
	--检测方向
	if sb.state!= sb.allstate.roll and sb.state!= sb.allstate.attack then
		input_direct_sys(sb)
	end
	--当为斜方向，且上一次的方向不是斜方向时，第一时间进行角色位置修正
	if sb.lastdire!=sb.dire and (sb.dire==2 or sb.dire==4 or sb.dire==6 or sb.dire==8) then
		sb.x=flr(sb.x)+.5
		sb.y=flr(sb.y)+.5
	elseif sb.dire==1 or sb.dire==3 or sb.dire==5 or sb.dire==7 then --当回到正角度将清理小数值
		sb.x=flr(sb.x)
		sb.y=flr(sb.y)
	end

	--player move
	--角色移动加成（翻滚或移动或推）
	if (sb.dire>0 or sb.state==sb.allstate.roll) and sb.state!=sb.allstate.attack then
		sb.x=sb.x+sb.spd.spx
		sb.y=sb.y+sb.spd.spy
		
	end
	local switchstate={
		idle = function()
            if sb.dire!=0 and not sb.isroll then
				sb.state=sb.allstate.move
            end
			if sb.isattack then
                attack_swordpos(sb)
				sb.state=sb.allstate.attack
			end
			if sb.isroll then
				sb.state=sb.allstate.roll
			end
			
			sb.rollspeed=8
			--动画
			sb.frame=sb.sprs.idle
		end,
		move = function()
			sb.speed = nomalize(sb,.7,1)
			--需求：
			--1.前方有物体停下 
			--2.如果有物体，检测物体的类型
			--3.如果是可以推动的物体，进行推动
			--4.如果是不可推动的物体，进行斜角度移动
			
			local _obj --a为正，bc为斜
			local moreclose =128
			for o in all(obj) do
				if sqrt(abs(o.x-sb.x)+abs(o.y-sb.y)) < moreclose then
					moreclose=sqrt(abs(o.x-sb.x)+abs(o.y-sb.y))
					_obj=o
				end
			end


			local colldire=checkdir(_obj,sb)--检测方向
			--debug="move"
			if ck_item(_obj,sb,0,0,0,0) then
				iscoll=true
				--and (a== wy.dire or b == wy.dire or c == wy.dire) then
				--注意，因为pico-8的缺陷，所以存在如果要斜角度归一化，那么像素级别的碰撞，在右边和下边两个角度上，斜角度移动会在设置的像素碰撞上再进一个像素
				debug="push"
				--检测碰撞方向
				 --如果监测到移动前方有物体（flag get）进入push状态
				if colldire==1 then
					if sb.dire==1 or sb.dire==2 or sb.dire==8 then
						sb.spd.spx=0
						sb.spd.spy=diry[sb.dire]*sb.speed
					else
						move(sb)
					end
				elseif colldire==3 then
					if sb.dire==3  or sb.dire==2 or sb.dire==4 then
						sb.spd.spx=dirx[sb.dire]*sb.speed
						sb.spd.spy=0
					else
						move(sb)
					end
				elseif colldire==5 then
					if sb.dire==5  or sb.dire==4 or sb.dire==6 then
						sb.spd.spx=0
						sb.spd.spy=diry[sb.dire]*sb.speed
					else
						move(sb)
					end
				elseif colldire==7 then
					if sb.dire==7  or sb.dire==8 or sb.dire==6 then
						sb.spd.spx=dirx[sb.dire]*sb.speed
						sb.spd.spy=0
					else
						move(sb)
					end
				end
				sb.frame=sb.sprs.push[(colldire+1)/2]

			else
				iscoll=false
				move(sb)
				--动画相关
				sb.move_t+=.2
				sb.frame=sb.sprs.move[ceil(sb.move_t%#sb.sprs.move)]
			end
           	debug1=colldire
			
			
			if sb.dire==0 then
				sb.move_t=0
				sb.state=sb.allstate.idle
			end
			--[[状态切换
			if sb.isattack then
                attack_swordpos(sb)
				sb.state=sb.allstate.attack
			end
			if sb.isroll then
				sb.state=sb.allstate.roll
			end]]
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
				sb.att_t=0
				sb.state=sb.allstate.idle
			end
		end,
		roll=function()
            sb.rollspeed=nomalize(sb,2.1213,3)
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
			--需求：
			--1.检测移动前方是否有物体
			--2.如果有物体，检测物体的类型
			--3.如果是可以推动的物体，进行推动
			--4.如果是不可推动的物体，进行斜角度移动
			--5.如果没有物体，回到idle状态
			debug1=""
			if not ck_item(wy,0,0,0,0) then
				sb.state=sb.allstate.move
			end
           
            --推的状态:推得动和推不动两种类型
            if sb.push_type=="fixed" then--推不动
				--斜角度移动
				if sb.dire==1 then
					--sb.spd.spx=-.3
				elseif sb.dire==2 then
					
				elseif sb.dire==3 then
					--sb.spd.spy=-.3
				elseif sb.dire==4 then

				elseif sb.dire==5 then
					--sb.spd.spx=.3
				elseif sb.dire==6 then

				elseif sb.dire==7 then	
					--sb.spd.spy=.3
				elseif sb.dire==8 then

				end
				--[[
				if colldire==1 then --在主角左边
					if sb.dire==2 or sb.dire==8  then
						--sb.spd.spx=.3
						sb.spd.spy=diry[sb.dire]*.3
						--debug="in"
					else 
						sb.spd.spy=0
					end
				elseif colldire==3 then --在主角上边
					if sb.dire==2  or sb.dire==4 then
						sb.spd.spx=dirx[sb.dire]*.3
					else 
						sb.spd.spx=0
					end
				elseif colldire==5 then --在主角右边
					if sb.dire==4  or sb.dire==6 then
						sb.spd.spy=diry[sb.dire]*.3
					else 
						sb.spd.spy=0
					end
				elseif colldire==7 then --在主角下边
					if sb.dire==6  or sb.dire==8 or sb.dire==1  then
						sb.spd.spx=dirx[sb.dire]*.3
					else 
						sb.spd.spx=0
					end
				end]]
			elseif sb.push_type=="move" then
				--可以推动
			end
			if sb.dire==0 then --如果检测碰撞返回false
        		sb.state=sb.allstate.idle
            end
			--sb.frame=sb.sprs.push[(colldire+1)/2]
        end,
		hurt=function()
		end,
		death=function()
		end
	}
	sb.lastdire=sb.dire--记录上一次的方向
	switchstate[sb.state]()
end
function attack_swordpos(_sb)--处理update中的武器实时位置
    if _sb.dire!=0 then
        sword.x = _sb.x+dirx[_sb.dire]*8
        sword.y = _sb.y+diry[_sb.dire]*8
    elseif _sb.dire==0 then
        if _sb.sprflip then
            sword.x = _sb.x-7
        else
            sword.x = _sb.x+7
        end
        sword.y = _sb.y
    end
end
function move(_sb)
	_sb.spd.spx=0
	_sb.spd.spy=0
	if _sb.dire!=0 then
		_sb.spd.spx=dirx[_sb.dire]*_sb.speed
		_sb.spd.spy=diry[_sb.dire]*_sb.speed
	end
end
function roll(_sb)
	if _sb.dire!=0 then
		_sb.spd.spx=dirx[_sb.dire]*_sb.rollspeed
		_sb.spd.spy=diry[_sb.dire]*_sb.rollspeed
	else
		if _sb.sprflip then
			_sb.spd.spx=-_sb.rollspeed
		else
			_sb.spd.spx=_sb.rollspeed
		end
	end
end
function hurt()
	--攻击碰撞后，向收到攻击的方向后退
	--1识别受到攻击的方向
	--2向后退
end