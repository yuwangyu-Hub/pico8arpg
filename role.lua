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
	role.isroll=false
	role.rollspeed=0
	role.t=0
	role.isattack=false
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


	if wy.state == "idle" then------------------------------------------------idle
		wy.spx=0
		wy.spy=0


		if wy.isattack then
			wy.state=wy.allstate.attack
		end

		if wy.dire!=0 then
			wy.state=wy.allstate.move
		end
		wy.rollspeed=8

		if wy.isroll then
			wy.state=wy.allstate.roll
		end
		--动画
		wy.aniframe= wy.animsprs.idle
		wy.t=0
		

	elseif wy.state == "move" then----------------------------------------------move
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

		if wy.isattack then
			wy.state=wy.allstate.attack
		end

		if wy.isroll then
			wy.state=wy.allstate.roll
		end

		--动画相关

		wy.t+=0.2
		wy.aniframe=wy.animsprs.move[ceil(wy.t%#wy.animsprs.move)]
		--wy.move_t+=0.2
		--wy.aniframe=wy.animsprs.move[ceil(wy.move_t%#wy.animsprs.move)]


	elseif wy.state == "attack" then------------------------------------------attack
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
			wy.isattack=false
			wy.att_t=0
			wy.state=wy.allstate.idle
		end
	elseif wy.state == "roll" then--------------------------------------------roll
		if wy.dire==2 or  wy.dire==4 or wy.dire==6 or wy.dire==8 then
			wy.rollspeed=sqrt(wy.rollspeed*wy.rollspeed/2)--斜方向归一化
		else
			wy.rollspeed=3
		end
	
		
		roll(wy)
		--动画相关
		wy.t+=0.5
		wy.aniframe=wy.animsprs.roll[ceil(wy.t%#wy.animsprs.roll)]
		if wy.t>=5 then
			wy.isroll=false
			wy.state=wy.allstate.idle
			
		end
	elseif wy.state == "hurt" then--------------------------------------------hurt

	elseif wy.state == "death" then------------------------------------------death
	
	end

end


--攻击时武器的显示
function attack()  
	sword_spr=0
    swordx=0
	swordy=0
	sw_flipx=false
	sw_flipy=false


	
	local swordire={
		--{x,y,spr,flipx,flipy}
		{-8, 0, 23,true},      ----1
		{-8,-8, 22,true},      ----2
		{ 0,-8, 24},           ----3
		{ 8,-8, 22},           ----4
		{ 8, 0, 23},           ----5
		{ 8, 8, 22,false,true},----6
		{ 0, 8, 24,false,true},----7
		{-8, 8, 22,true,true} -----8
	}
	if wy.dire!=0 then
		swordx=wy.x+swordire[wy.dire][1]
		swordy=wy.y+swordire[wy.dire][2]
		sword_spr=swordire[wy.dire][3]
		sw_flipx=swordire[wy.dire][4]
		sw_flipy=swordire[wy.dire][5]
	else
		if wy.sprflip then
			swordx=wy.x-8
			swordy=wy.y
			sword_spr=23 --flip
			sw_flipx=true
		else
			swordx=wy.x+8
			swordy=wy.y
			sword_spr=23
		end
	end

	spr(sword_spr,swordx,swordy,1,1,sw_flipx,sw_flipy)
	--[[
		if wy.dire==1 or (wy.dire ==0 and wy.sprflip)then
			--角色:左
			swordx=wy.x-8
			swordy=wy.y
			sword_spr=23 --flip
			sw_flipx=true
		end
		if wy.dire==2 then
			--角色:左上
			swordx=wy.x-8
			swordy=wy.y-8
			sword_spr=22 --flip
			sw_flipx=true
		end
		if wy.dire==3 then
			--角色：上
			swordx=wy.x
			swordy=wy.y-8
			sword_spr=24
		end
		if wy.dire==4 then
			--角色：右上
			swordx=wy.x+8
			swordy=wy.y-8
			sword_spr=22
		end
		if wy.dire==5 or (wy.dire==0 and not wy.sprflip)then
			--角色：右
			swordx=wy.x+8
			swordy=wy.y
			sword_spr=23
		end
		if wy.dire==6 then
			--角色：右下
			swordx=wy.x+8
			swordy=wy.y+8
			sword_spr=22
			sw_flipy=true
		end
		if wy.dire==7 then
			--角色：下
			swordx=wy.x
			swordy=wy.y+8
			sword_spr=24
			sw_flipy=true
		end
		if wy.dire==8 then
			--角色：左下
			swordx=wy.x-8
			swordy=wy.y+8
			sword_spr=22
			sw_flipx=true
			sw_flipy=true
		end
	--]]
end


--主角移动	
function move(sb)
	sb.spx=0
	sb.spy=0

	local xyspeed={
		{-sb.speed,0},          -------1
		{-sb.speed,-sb.speed},  -------2
		{0,-sb.speed},          -------3
		{sb.speed,-sb.speed},   -------4
		{sb.speed,0},           -------5
		{sb.speed,sb.speed},    -------6
		{0,sb.speed},           -------7
		{-sb.speed,sb.speed}    -------8
	}
	if wy.dire!=0 then
		sb.spx=xyspeed[sb.dire][1]
		sb.spy=xyspeed[sb.dire][2]
	end
	--[[	
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
	--]]
end

--翻滚制作
function roll(sb)
	local rollspeed={
		{-sb.rollspeed,0},             ---------1
		{-sb.rollspeed,-sb.rollspeed}, ---------2
		{0,-sb.rollspeed},             ---------3
		{sb.rollspeed,-sb.rollspeed},  ---------4
		{sb.rollspeed,0},              ---------5
		{sb.rollspeed,sb.rollspeed},   ---------6
		{0,sb.rollspeed},              ---------7
		{-sb.rollspeed,sb.rollspeed}   ---------8
	}
	if wy.dire!=0 then
		sb.spx=rollspeed[sb.dire][1]
		sb.spy=rollspeed[sb.dire][2]
	else
		if wy.sprflip then
			sb.spx=-sb.rollspeed
		else
			sb.spx=sb.rollspeed
		end
	end
	--[[
		if sb.dire==1  or (sb.dire==0 and sb.sprflip)then 	
			sb.spx=-sb.rollspeed
		end
		if sb.dire==2 then
			sb.spx=-sb.rollspeed
			sb.spy=-sb.rollspeed
		end
		if sb.dire==3 then 
			sb.spy=-sb.rollspeed
		end
		if sb.dire==4 then
			sb.spx=sb.rollspeed
			sb.spy=-sb.rollspeed
		end
		if sb.dire==5 or (sb.dire==0 and not sb.sprflip)then 
			sb.spx=sb.rollspeed
		end
		if sb.dire==6 then
			sb.spx=sb.rollspeed
			sb.spy=sb.rollspeed
		end
		
		if sb.dire==7 then 
			sb.spy=sb.rollspeed
		end
		if sb.dire==8 then
			sb.spx=-sb.rollspeed
			sb.spy=sb.rollspeed
		end
		sb.rollspeed-=1
	--]]
end


--追逐
function chase(sb1,sb2)
	if sb1.x < sb2.x then
		sb1.x+=sb1.speed
	end
	if sb1.x > sb2.x then
		sb1.x-=sb1.speed
	end
	if sb1.y < sb2.y then
		sb1.y+=sb1.speed
	end
	if sb1.y > sb2.y then
		sb1.y-=sb1.speed
	end
end