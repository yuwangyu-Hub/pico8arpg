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
			local _obj=cdis(obj,wy)
			local colldire=checkdir(_obj,sb)--检测方向
			if ck_item(_obj,sb,0,0,0,0) then
				move_and_push(_obj,sb,colldire)
			else
				move(sb)
				move_anim(sb)
			end
			if sb.dire==0 then
				sb.move_t=0
				sb.state=sb.allstate.idle
			end
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
		hurt=function()
		end,
		death=function()
		end
	}
	sb.lastdire=sb.dire--记录上一次的方向
	switchstate[sb.state]()
end

