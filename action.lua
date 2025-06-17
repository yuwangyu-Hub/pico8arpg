--行为
function wyfsm(sb)--状态机
	--检测方向
	if sb.state!= sb.allstate.roll and sb.state!= sb.allstate.attack then
		input_direct_sys(sb)
	end
	--[[当为斜方向，且上一次的方向不是斜方向时，第一时间进行角色位置修正
	if sb.lastdire!=sb.dire and (sb.dire==2 or sb.dire==4 or sb.dire==6 or sb.dire==8) then
		sb.x=flr(sb.x)+.5
		sb.y=flr(sb.y)+.5
	elseif sb.dire==1 or sb.dire==3 or sb.dire==5 or sb.dire==7 then --当回到正角度将清理小数值
		sb.x=flr(sb.x)
		sb.y=flr(sb.y)
	end]]

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
			--sb.speed = nomalize(sb,.7,1)
			--需求：
			--1.前方有物体停下 
			--2.如果有物体，检测物体的类型
			--3.如果是可以推动的物体，进行推动
			--4.如果是不可推动的物体，进行斜角度移动
			
			local _obj --a为正，bc为斜
			local moreclose =128 --最大可能距离
			for o in all(obj) do
				if sqrt(abs(o.x-sb.x)+abs(o.y-sb.y)) < moreclose then
					moreclose=sqrt(abs(o.x-sb.x)+abs(o.y-sb.y))
					_obj=o
				end
			end
			local colldire=checkdir(_obj,sb)--检测方向
			--debug="move"
			if ck_item(_obj,sb,0,0,0,0) then
				debug1="ck_item"
				--and (a== wy.dire or b == wy.dire or c == wy.dire) then
				--注意，因为pico-8的缺陷，所以存在如果要斜角度归一化，那么像素级别的碰撞，在右边和下边两个角度上，斜角度移动会在设置的像素碰撞上再进一个像素
				--检测碰撞方向
				--如果监测到移动前方有物体（flag get）进入push状态
				
				
				
				if _obj.type=="fixed" then
					--推不动的各种交互逻辑
					move_not_push(sb,colldire)
					--sb.spd.spx=0
					--sb.spd.spy=0
				elseif _obj.type=="move" then
					sb.state=sb.allstate.push
				end
			else
				debug1="move"
				move(sb)
				move_anim(sb)
			end
			debug=colldire
			
			if sb.dire==0 then
				sb.move_t=0
				sb.state=sb.allstate.idle
			end
			--状态切换
			if sb.isattack then
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
			--推动

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
