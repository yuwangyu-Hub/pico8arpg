--dev
--角色的各种相关内容

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
	--role.roll=false
	role.rollspeed=0
	role.t=0
	--role.att=false
	role.att_t=0
	role.aniframe=0
	role.animsprs={}
	role.sprflip=false
	return role
end



function wyfsm()
	--检测方向
	if wy.state!= wy.allstate.roll and wy.state!= wy.allstate.attack then
		input_direct_sys(wy)
	end
	--player move
	--角色移动加成
	wy.x+=wy.spx
	wy.y+=wy.spy
	

	if wy.state == "idle" then--------------------------------------------------------------idle
		wy.spx=0
		wy.spy=0
		if wy.dire!=0 then
			wy.state=wy.allstate.move
		end
		wy.rollspeed=8

		--动画
		wy.aniframe= wy.animsprs.idle
		wy.t=0
		

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

		--动画相关

		wy.t+=0.2
		wy.aniframe=wy.animsprs.move[ceil(wy.t%#wy.animsprs.move)]
		--wy.move_t+=0.2
		--wy.aniframe=wy.animsprs.move[ceil(wy.move_t%#wy.animsprs.move)]


	elseif wy.state == "attack" then-------------------------------------------------------attack
		wy.spx=0
		wy.spy=0
		if wy.dire==1 or wy.dire ==5 or wy.dire==0 then
			wy.aniframe=wy.animsprs.attack[1]
		elseif wy.dire==2 or wy.dire== 3 or wy.dire==4 then
			wy.aniframe=wy.animsprs.attack[3]
		else
			wy.aniframe=wy.animsprs.attack[2]
		end
		
		
		wy.att_t+=0.2
		if wy.att_t > 2 then
			--wy.att=false
			wy.att_t=0
			wy.state=wy.allstate.idle
		end
	elseif wy.state == "roll" then----------------------------------------------------------roll
		roll(wy)
		--动画相关
		wy.t+=1
		wy.aniframe=wy.animsprs.roll[ceil(wy.t%#wy.animsprs.roll)]
		if wy.t>=9 then
			--wy.roll=false
			wy.state=wy.allstate.idle
		end
	elseif wy.state == "hurt" then-----------------------------------------------------------hurt

	elseif wy.state == "death" then----------------------------------------------------------death
	
	end

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


