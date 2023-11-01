--dev
--角色的各种相关内容
--简单测试
--角色的创建模板
function makerole()
	local role={}
	role.dire=0 
	role.x=0
	role.y=0
	role.spx=0--speedx
	role.spy=0--speedy
	role.spr=0
	role.speed=0

	role.allstate={}
	role.state=role.allstate[1]
	role.roll=false
	role.rollspeed=0
	role.att=false
	role.move_t=0
	role.roll_t=0
	role.att_t=0
	role.aniframe=0
	role.animsprs={}
	role.sprflip=false
	return role
end



function wyfsm()
--检测方向
	if not wy.roll and not wy.att then
		input_direct_sys(wy)
	end
	
	--player move
	--角色移动加成
	wy.x+=wy.spx
	wy.y+=wy.spy

	if wy.state == "idle" then--------------------------------------------------------------idle
		if wy.dire!=0 then
			wy.state=wy.allstate.move
		end
		wy.rollspeed=8
	elseif wy.state == "move" then----------------------------------------------------------move
		--移动的方向归一化
		if wy.dire==2 or  wy.dire==4 or wy.dire==6 or wy.dire==8 then
			wy.speed=sqrt(1.3*1.3/2)
		else
			wy.speed=1.3
		end

		move(wy)

		if wy.dire==0 then
			wy.state=wy.allstate.idle
		end
	elseif wy.state == "attack" then-------------------------------------------------------attack

	elseif wy.state == "roll" then
		roll(wy)
	elseif wy.state == "hurt" then

	elseif wy.state == "death" then
	
	end

end

--动画播放（角色、物品等）
function wy_anim(sb)
	local animspr= sb.animsprs.idle

	--检测是否移动，播放移动动画
	if (sb.spx!=0 or sb.spy!=0) and not sb.roll then
		sb.move_t+=0.2
		animspr=sb.animsprs.move[ceil(sb.move_t%#sb.animsprs.move)]
	else
		animspr= sb.animsprs.idle
		sb.move_t=0
	end

	--翻滚动画
	if sb.roll then 
		sb.roll_t+=1
		animspr=sb.animsprs.roll[ceil(sb.roll_t%#sb.animsprs.roll)+1]

		if sb.roll_t>=9 then
			sb.roll=false
			sb.roll_t=0
		end
	end


	--攻击动画持续性
	if sb.att then
		sb.spx=0
		sb.spy=0
		if sb.dire==1 or sb.dire ==5 or sb.dire==0 then
			animspr=sb.animsprs.attack[1]
		elseif sb.dire==2 or sb.dire== 3 or sb.dire==4 then
			animspr=sb.animsprs.attack[3]
		else
			animspr=sb.animsprs.attack[2]
		end
		
		sb.att_t+=0.2
		if sb.att_t > 2 then
			sb.att=false
			sb.att_t=0
			sb.aniframe=2
		end
	end

	--精灵绘制
	spr(animspr, sb.x, wy.y, 1, 1,wy.sprflip)--player spr

end

--主角移动	
function move(sb)
	sb.spx=0
	sb.spy=0
	if sb.dire==1 then 	
		sb.spx=-wy.speed
	end

	if sb.dire==2 then
		sb.spx=-wy.speed
		sb.spy=-wy.speed
	end

	if sb.dire==3 then 
		sb.spy=-wy.speed
	end
	
	if sb.dire==4 then
		sb.spx=wy.speed 
		sb.spy=-wy.speed
	end

	if sb.dire==5 then 
		sb.spx=wy.speed 
	end

	
	if sb.dire==6 then
		sb.spx=wy.speed 
		sb.spy=wy.speed
	end
	
	if sb.dire==7 then 
		sb.spy=wy.speed
	end

	if sb.dire==8 then
		sb.spx=-wy.speed
		sb.spy=wy.speed
	end

end

--翻滚制作
function roll(sb)
	local sqrtsp=sqrt(sb.rollspeed*sb.rollspeed/2)--斜方向归一化

	if sb.dire==1  or (sb.dire==0 and sb.sprflip)then 	
		sb.spx=-sb.rollspeed
	end

	if sb.dire==2 then
		sb.spx=-sqrtsp
		sb.spy=-sqrtsp
	end

	if sb.dire==3 then 
		sb.spy=-sb.rollspeed
	end
	
	if sb.dire==4 then
		sb.spx=sqrtsp
		sb.spy=-sqrtsp
	end

	if sb.dire==5 or (sb.dire==0 and not sb.sprflip)then 
		sb.spx=sb.rollspeed
	end

	
	if sb.dire==6 then
		sb.spx=sqrtsp
		sb.spy=sqrtsp
	end
	
	if sb.dire==7 then 
		sb.spy=sb.rollspeed
	end

	if sb.dire==8 then
		sb.spx=-sqrtsp
		sb.spy=sqrtsp
	end

	sb.rollspeed-=1

	
end

--绘制武器
function draweapon(sb)
	local sword_spr=0
	local sword_ani_lr={22,23,24}
	local sword_ani_ud={25,26,27}
	local swordx=0
	local swordy=0
	local sw_flipx=false
	local sw_flipy=false

	if sb.dire==1 then
		--角色向左
		swordx=sb.x-8
		swordy=sb.y
		sword_spr=8
		sw_flipx=true
	end
	if sb.dire==3 then
		--角色向上
		swordx=sb.x
		swordy=sb.y-8
		sword_spr=9
	end
	if sb.dire==5 then
		--角色向右
		swordx=sb.x+8
		swordy=sb.y
		sword_spr=8
	end
	if sb.dire==7 then
		--角色向下
		swordx=sb.x
		swordy=sb.y+8
		sword_spr=9
		sw_flipy=true
	end
	spr(sword_spr,swordx,swordy,1,1,sw_flipx,sw_flipy)
end


