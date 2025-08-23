function doshake()--镜头抖动
	local shakex=rnd(shake)-(shake/2)
	local shakey=rnd(shake)-(shake/2)
	camera(shakex,shakey)
	if shake>10 then
		shake*=0.9
	else
		shake-=1
		if(shake<1)shake=0
	end
end
function blink()--闪烁工具，返回闪烁的颜色动画
	local blink_anim={5,5,5,5,5,5,5,5,6,6,7,7,6,6,5,5}
    --blinkt:闪烁计时器，在主函数中创建并且更细
	return blink_anim[blinkt%#blink_anim] 
end
--x位置对称打印，而不是左上角位置
--输入 x 为画面中心位置打印
function cprint(txt,x,y,c)--xy位置，c颜色
	print(txt,x-#txt*2,y,c)
end
function draw_p(player,cx,cy)--cx和cy代表差值
	local x=player.x+cx
	local y=player.y+cy
	spr(wy.frame, x, y, 1, 1, wy.sprflip)
end
function ck_sthcoll(_sth,_sb,cx,cy,cw,ch)--检测碰撞,参数代表差值
	--creat_ck_line(_sb,0,0,0,0)--创建检测线
	--act_checkline(_sb)--激活检测盒
	local p={
		x=_sb.x+cx,
		y=_sb.y+cy,
		w=_sb.w+cw,
		h=_sb.h+ch
	}
	--将主角向外扩一个像素，来达到触碰即碰撞
	return coll_boxcheck(p.x-1,p.y-1,p.w+2,p.h+2,_sth.x,_sth.y,_sth.w,_sth.h)
end

--具体的碰撞盒
--物体1、物体2、物体1的宽、物体1的高、物体2的宽、物体2的高
function coll_boxcheck(_px,_py,_pw,_ph,_bx,_by,_bw,_bh) 
	local px1=_px
	local py1=_py
	local px2=_px+_pw
	local py2=_py+_ph
	local bx1=_bx
	local by1=_by
	local bx2=_bx+_bw
	local by2=_by+_bh
	if px2>=bx1 and px1<=bx2 and py2>=by1 and py1<=by2 then
		return true
	else
		return false
	end
end
--检测obj在sb的哪个方向
function checkdir(obj,sb)
	local ox1,oy1=obj.x,obj.y
	local ox2=obj.x+obj.w
	local oy2=obj.y+obj.h
	local sx1,sy1=sb.x,sb.y
	local sx2=sb.x+sb.w
 	local sy2=sb.y+sb.h
	if sx1>ox2 and sy2>=oy1 and sy1<=oy2 then--物体在左边
		return 1
	elseif sx1>ox2 and sy1>oy2 then--物体在左上
		return 2
	elseif sy1>oy2 and sx2>=ox1 and sx1<=ox2 then--物体在上边
		return 3
	elseif sx2<ox1 and sy1>oy2 then--物体在右上
		return 4
	elseif sx2<ox1 and sy2>=oy1 and sy1<=oy2 then--物体在右边
		return 5
	elseif sx2<ox1 and sy2<oy1 then--物体在右下
		return 6
	elseif sy2<oy1 and sx2>=ox1 and sx1<=ox2 then--物体在下边
		return 7
	elseif sx1>ox2 and sy2<oy1 then--物体在左下
		return 8
	else --在物体内？(碰撞)
		return 0
	end
end
-- 查找集合中距离主体最近的对象
-- @param objectGroup 对象集合
-- @param subject 主体对象
-- @return 最近的对象
function findNearestObject(objectGroup, subject)
	local minDistance = 128  -- 初始最大距离
	local nearestObject --最近的对象
	for object in all(objectGroup) do
		local distance = sqrt(abs(object.x - subject.x) + abs(object.y - subject.y))
		if distance < minDistance then
			minDistance = distance
			nearestObject = object
		end
	end
	return nearestObject
end
function spr_flip(_sb)--精灵反转
	if _sb.dire==2 or _sb.dire==1 or _sb.dire==8  then
		_sb.sprflip=true --如果是右上方向，精灵翻转
	elseif _sb.dire==4 or _sb.dire==5 or _sb.dire==6 then
		_sb.sprflip=false --其他方向不翻转
	end
end
function attack_swordpos(_sb)--处理update中的武器实时位置
	if sword then
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
end
function setspd_0(sb)--速度设置为0
	sb.spd.spx=0
	sb.spd.spy=0
end
function setspd_xydire(sb,spd)
	local uspd=sb.speed
	if spd then
		uspd=spd
	end
	sb.spd.spx=dirx[sb.dire]*uspd
	sb.spd.spy=diry[sb.dire]*uspd
end
function setspd_xdire(sb,spd)
	local uspd=sb.speed
	if spd then
		uspd=spd
	end
	sb.spd.spx=dirx[sb.dire]*uspd
	sb.spd.spy=0
end
function setspd_ydire(sb,spd)
	local uspd=sb.speed
	if spd then
		uspd=spd
	end
	sb.spd.spx=0
	sb.spd.spy=diry[sb.dire]*uspd
end
function move(_sb)
	setspd_0(_sb)
	if _sb.dire!=0 then
		setspd_xydire(_sb)
	end
end
function check_roll_closewall(_sb)--检测翻滚是否即将靠近墙(3像素的预判距离)
	local zpoints={ --翻滚正角度的点
		{x=flr((_sb.x-3)/8),y=flr((_sb.y)/8)},--1
		{x=flr((_sb.x-3)/8),y=flr((_sb.y+7)/8)},
		{x=flr((_sb.x+7)/8),y=flr((_sb.y-3)/8)},--3
		{x=flr((_sb.x)/8),y=flr((_sb.y-3)/8)},
		{x=flr((_sb.x+10)/8),y=flr((_sb.y+7)/8)},--5
		{x=flr((_sb.x+10)/8),y=flr((_sb.y)/8)},
		{x=flr((_sb.x)/8),y=flr((_sb.y+10)/8)},--7
		{x=flr((_sb.x+7)/8),y=flr((_sb.y+10)/8)},
	}
	local xpoints={ --翻滚斜角度的点
		{x=flr((_sb.x+3)/8),y=flr((_sb.y-3)/8)},--2
		{x=flr((_sb.x-3)/8),y=flr((_sb.y+3)/8)},
		{x=flr((_sb.x+4)/8),y=flr((_sb.y-3)/8)},--4
   		{x=flr((_sb.x+10)/8),y=flr((_sb.y+3)/8)},
    	{x=flr((_sb.x+10)/8),y=flr((_sb.y+4)/8)},--6
    	{x=flr((_sb.x+4)/8),y=flr((_sb.y+10)/8)},
    	{x=flr((_sb.x+3)/8),y=flr((_sb.y+10)/8)},--8
    	{x=flr((_sb.x-3)/8),y=flr((_sb.y+4)/8)},
	}
	if _sb.dire%2==1 then--_sb.dire==1\_sb.dire==3\_sb.dire==5\_sb.dire==7
		if(fget(mget(zpoints[_sb.dire].x,zpoints[_sb.dire].y),0)) or (fget(mget(zpoints[_sb.dire+1].x,zpoints[_sb.dire+1].y),0)) then
			return true
		else
			return false
		end
	
	else --_sb.dire==2\_sb.dire==4\_sb.dire==6\_sb.dire==8
		if(fget(mget(xpoints[_sb.dire-1].x,xpoints[_sb.dire-1].y),0)) or (fget(mget(xpoints[_sb.dire].x,xpoints[_sb.dire].y),0)) then
			return true
		else
			return false
		end
	end
end
function check_roll_near_wall(_sb,iwcd,rspd)--检测翻滚是否贴墙
	local _rollspd=_sb.rollspeed
	local xymove=""--xy轴移动方向,贴墙斜角度也可翻滚，只是速度较低:1
	if check_roll_closewall(_sb) then
		_rollspd=1--速度为1
	end
	if _sb.dire==1 then
		if iwcd==8 or iwcd==1 or iwcd==2 then
			_rollspd= 0--速度为0
			xymove="no"
		end
	elseif _sb.dire==2 then
		if iwcd==2 then
			_rollspd= 0--速度为0
			xymove="no"
		elseif iwcd==1 then
			_rollspd=1
			xymove="y"
		elseif iwcd==3 then
			_rollspd=1
			xymove="x"
		end
	elseif _sb.dire==4 then
		if iwcd==4 then
			_rollspd= 0--速度为0
			xymove="no"
		elseif iwcd==3 then
			_rollspd=1
			xymove="x"
		elseif iwcd==5 then
			_rollspd=1
			xymove="y"
		end
	elseif _sb.dire==6 then
		if iwcd==6 then
			_rollspd= 0--速度为0
			xymove="no"
		elseif iwcd==5 then
			_rollspd=1
			xymove="y"
		elseif iwcd==7 then
			_rollspd=1
			xymove="x"
		end
	elseif _sb.dire==8 then
		if iwcd==8 then
			_rollspd= 0--速度为0
			xymove="no"
		elseif iwcd==1 then
			_rollspd=1
			xymove="y"
		elseif iwcd==7 then
			_rollspd=1
			xymove="x"
		end
	else--357
		if iwcd==_sb.dire-1 or iwcd==_sb.dire or iwcd==_sb.dire+1 then
			_rollspd= 0--速度为0
			xymove="no"
		end
	end
	return _rollspd,xymove	
end
function roll(_sb,iwcd)--is_wall_coll_dire
	local _rollspd,xymove=check_roll_near_wall(_sb,iwcd)
	if xymove=="x" then
		setspd_xdire(_sb,_rollspd)
	elseif xymove=="y" then
		setspd_ydire(_sb,_rollspd)
	else
		setspd_xydire(_sb,_rollspd)--设置速度
	end
end
function check_p_hurt(_sb)--玩家受伤
	local _ishurt
	for e in all(enemies) do
		_sb.hurtdire=checkdir(e,_sb)
		_ishurt = coll_boxcheck(_sb.x-1,_sb.y-1,_sb.w+2,_sb.h+2,e.x,e.y,e.w,e.h)
	end
	return _ishurt
end
function check_en_hurt() --敌人受伤
	local _ishurt
	if sword.isappear then
		for e in all(enemies) do
			--e.hurtdire=checkdir(e,sword)
			_ishurt = coll_boxcheck(sword.x,sword.y,sword.w,sword.h,e.x,e.y,e.w,e.h)
		end
	end
	return _ishurt
end
function hurtmove(_sb)--依照方向执行受伤
	local m_spd=1
	local iscollwall,_ = check_wall_iswalk(_sb)
	_sb.hurtmt+=0.1
	--反方向加权
	local xsum=dirx[_sb.hurtdire]*-1 
	local ysum=diry[_sb.hurtdire]*-1 
	if iscollwall==0 then
		_sb.spd.spx=xsum*m_spd
		_sb.spd.spy=ysum*m_spd
	else
		setspd_0(_sb)
	end
	hurt2idle(_sb)	
end
function hurt2idle(_sb)--受伤结束-idle
	if _sb.hurtmt>=0.7 then
		_sb.hurtmt=0
		setspd_0(_sb)
		_sb.state=_sb.allstate.idle
	end
end
function nomalize(sb,speed1,speed2)--归一化
	local respeed=0
	if sb.dire==2 or  sb.dire==4 or sb.dire==6 or sb.dire==8 then
		respeed=speed1 --2.1213--sqrt(wy.rollspeed*wy.rollspeed/2)--斜方向归一化
	else
		respeed=speed2 --3
	end
	return respeed
end
--检测地图上绘制的敌人/物品精灵，将其转换为对应的实例
function check_map_sth()
	for i=0,15 do--行
		for j=0,15 do--列
			local en_mount=mget(i,j)
			if en_mount==50 then --蛇
				createsnakenemy(i,j)  -- 创建蛇形敌人
				mset(i,j,0)
			elseif en_mount==81 then --箱子
				makeobj(1,i*8,j*8,7,7,0,0,0,0)--box
				mset(i,j,0)
			elseif en_mount==82 then --金币
				makeobj(2,i*8,j*8,7,7,0,0,0,0)--coin
				mset(i,j,0)
			end
		end
	end
end
function check_wall_iswalk(v)--检测物体(角色、箱子)是否靠近墙壁（1-8分别对应墙靠近玩家的位置，0不靠墙）
	local x1,y1=flr((v.x-1)/8),flr((v.y)/8) --检测该点是否在图块上
	local x2,y2=flr((v.x-1)/8),flr((v.y+7)/8)
	local x3,y3=flr((v.x)/8),flr((v.y+8)/8)
	local x4,y4=flr((v.x+7)/8),flr((v.y+8)/8)
	local x5,y5=flr((v.x+8)/8),flr((v.y+7)/8)
	local x6,y6=flr((v.x+8)/8),flr((v.y)/8)
	local x7,y7=flr((v.x+7)/8),flr((v.y-1)/8)
	local x8,y8=flr((v.x)/8),flr((v.y-1)/8)
	local x02,y02=flr((v.x-1)/8),flr((v.y-1)/8) --左上角
	local x04,y04=flr((v.x+8)/8),flr((v.y-1)/8) --右上角
	local x06,y06=flr((v.x+8)/8),flr((v.y+8)/8) --右下角
	local x08,y08=flr((v.x-1)/8),flr((v.y+8)/8) --左下角
	if (fget(mget(x1,y1),0) or fget(mget(x2,y2),0)) and not( fget(mget(x7,y7),0) or  fget(mget(x8,y8),0)) and not (fget(mget(x3,y3),0) or fget(mget(x4,y4),0)) then --是否靠墙1
		if fget(mget(x1,y1),0) and not fget(mget(x2,y2),0) then
			return 1,"down" --因为左上角检测点检测到了，而左下角没检测到，所以在下面
		elseif not fget(mget(x1,y1),0) and  fget(mget(x2,y2),0) then
			return 1,"up"
		else
			return 1,"no" --考虑到玩家不在边缘
		end
	elseif (fget(mget(x1,y1),0) or fget(mget(x2,y2),0)) and (fget(mget(x7,y7),0) or fget(mget(x8,y8),0)) then --是否靠墙2
		return 2,"no"
	elseif (fget(mget(x7,y7),0) or fget(mget(x8,y8),0)) and not(fget(mget(x1,y1),0) or fget(mget(x2,y2),0)) and not(fget(mget(x5,y5),0) or fget(mget(x6,y6),0)) then--是否靠墙3
		if fget(mget(x7,y7),0) and not fget(mget(x8,y8),0) then
			return 3,"left"
		elseif not fget(mget(x7,y7),0) and  fget(mget(x8,y8),0) then
			return 3,"right"
		else
			return 3,"no"
		end
	elseif (fget(mget(x7,y7),0) or fget(mget(x8,y8),0)) and (fget(mget(x5,y5),0) or fget(mget(x6,y6),0)) then --是否靠墙4
		return 4,"no"
	elseif (fget(mget(x5,y5),0) or fget(mget(x6,y6),0)) and not(fget(mget(x7,y7),0) or fget(mget(x8,y8),0)) and not(fget(mget(x3,y3),0) or fget(mget(x4,y4),0)) then --是否靠墙5
		if fget(mget(x5,y5),0) and not fget(mget(x6,y6),0) then
			return 5,"up"
		elseif not fget(mget(x5,y5),0) and  fget(mget(x6,y6),0) then
			return 5,"down"
		else
			return 5,"no"
		end	
	elseif (fget(mget(x5,y5),0) or fget(mget(x6,y6),0)) and (fget(mget(x3,y3),0) or fget(mget(x4,y4),0)) then --是否靠墙6
		return 6,"no"
	elseif (fget(mget(x3,y3),0) or fget(mget(x4,y4),0)) and not(fget(mget(x1,y1),0) or fget(mget(x2,y2),0)) and not(fget(mget(x5,y5),0) or fget(mget(x6,y6),0)) then --是否靠墙7
		if fget(mget(x3,y3),0) and not fget(mget(x4,y4),0) then
			return 7,"right"
		elseif not fget(mget(x3,y3),0) and  fget(mget(x4,y4),0) then
			return 7,"left"
		else
			return 7,"no"
		end
	elseif (fget(mget(x3,y3),0) or fget(mget(x4,y4),0)) and (fget(mget(x1,y1),0) or fget(mget(x2,y2),0)) then --是否靠墙8
		return 8,"no"
	else  ----不靠墙
		--对角检测
		if fget(mget(x02,y02),0) then
			return -1,"left_up"
		elseif fget(mget(x04,y04),0) then
			return -1,"right_up"
		elseif fget(mget(x06,y06),0) then
			return -1,"right_down"
		elseif fget(mget(x08,y08),0) then
			return -1,"left_down"
		else
			return 0,"no"
		end
	end
end
function wallside(coll_dire)--是否站在墙角边缘(用于滑动)
	--[[local l_px1,l_py1=flr((wy.x-1)/8),flr((wy.y+3)/8)
		local l_px2,l_py2=flr((wy.x-1)/8),flr((wy.y+4)/8)
		local d_px1,d_py1=flr((wy.x+4)/8),flr((wy.y+8)/8)
		local d_px2,d_py2=flr((wy.x+3)/8),flr((wy.y+8)/8)
		local r_px1,r_py1=flr((wy.x+8)/8),flr((wy.y+3)/8)
		local r_px2,r_py2=flr((wy.x+8)/8),flr((wy.y+4)/8)
		local u_px1,u_py1=flr((wy.x+4)/8),flr((wy.y-1)/8)
		local u_px2,u_py2=flr((wy.x+3)/8),flr((wy.y-1)/8)]]
	local data={
		{flr((wy.x-1)/8),flr((wy.y+3)/8),flr((wy.x-1)/8),flr((wy.y+4)/8)},
		{flr((wy.x+4)/8),flr((wy.y-1)/8),flr((wy.x+3)/8),flr((wy.y-1)/8)},
		{flr((wy.x+8)/8),flr((wy.y+3)/8),flr((wy.x+8)/8),flr((wy.y+4)/8)},
		{flr((wy.x+4)/8),flr((wy.y+8)/8),flr((wy.x+3)/8),flr((wy.y+8)/8)},
	}
	local index=(coll_dire+1)/2
	return checkwallside(data[index][1],data[index][2],data[index][3],data[index][4])
	--[[
	if coll_dire==1 then --左
		return checkwallside(l_px1,l_py1,l_px2,l_py2)
	elseif coll_dire==3 then --上
		return checkwallside(u_px1,u_py1,u_px2,u_py2)
	elseif coll_dire==5 then --右
		return checkwallside(r_px1,r_py1,r_px2,r_py2)
	elseif coll_dire==7 then --下
		return checkwallside(d_px1,d_py1,d_px2,d_py2)
	end]]
end
function checkwallside(x1,y1,x2,y2)
	if (not fget(mget(x1,y1),0)) and (not fget(mget(x2,y2),0)) then
		return true--edge
	else
		return false--wall
	end
end
function wallcoll_move(player,coll_dire,oneside) --玩家与墙壁的碰撞移动
	if coll_dire==1 then
		z1357wmove(coll_dire,player,oneside)
	elseif coll_dire==3 then
		z1357wmove(coll_dire,player,oneside)
	elseif coll_dire==5 then
		z1357wmove(coll_dire,player,oneside)
	elseif coll_dire==7 then
		z1357wmove(coll_dire,player,oneside)
	-------------------------------斜4角度----------------------------
	elseif coll_dire==-1 then --无常规碰撞
		if oneside=="no" then
			move(player)
		else --左上、右上、左下、右下
			edge_wmove(oneside,player)
		end
		--[[
		if oneside=="left_up" then--是否对角碰撞
			if player.dire==2 then
				setspd_0(player)
			else
				if player.dire!=0 then
					setspd_xydire(player)
				end
			end
		elseif oneside=="right_up" then
			if player.dire==4 then
				setspd_0(player)
			else
				if player.dire!=0 then
					setspd_xydire(player)
				end
			end
		elseif oneside=="right_down" then
			if player.dire==6 then
				setspd_0(player)
			else
				if player.dire!=0 then
					setspd_xydire(player)
				end
			end
		elseif oneside=="left_down" then
			if player.dire==8 then
				setspd_0(player)
			else
				if player.dire!=0 then
					setspd_xydire(player)
				end
			end
		elseif oneside=="no" then
			move(player)
		end]]
	else --2468
		x2468wmove(coll_dire,player)
	end
end
function z1357wmove(_dire,_sb,side)--正wall
	local data={
		{1,2,8,"up",0,-1,"down",0,1},
		{3,2,4,"left",-1,0,"right",1,0},
		{5,4,6,"up",0,-1,"down",0,1},
		{7,6,8,"left",-1,0,"right",1,0}
	}
	local index=(_dire+1)/2
	if _sb.dire==data[index][1] then
		if wallside(_dire) then
			if side==data[index][4] then
				_sb.spd.spx=data[index][5]
				_sb.spd.spy=data[index][6]
			elseif side==data[index][7] then
				_sb.spd.spx=data[index][8]
				_sb.spd.spy=data[index][9]
			end
		else
			setspd_0(_sb)
		end

	elseif _sb.dire==data[index][2] or _sb.dire==data[index][3] then
		if _dire==1 or _dire==5 then
			setspd_ydire(_sb)--*bug
		else
			setspd_xdire(_sb)--*bug
		end
		
	else
		move(_sb)
	end
	move_anim(_sb)
end
function x2468wmove(_dire,_sb)--斜wall
	--墙：2468情况
	local xie_data={
		{1,2,3,4,8},
		{3,4,5,2,6},
		{5,6,7,8,4},
		{7,8,1,6,2}}
	local index=_dire/2
	if _sb.dire==xie_data[index][1] or _sb.dire==xie_data[index][2] or _sb.dire==xie_data[index][3] then
		setspd_0(_sb)
	elseif _sb.dire==xie_data[index][4] then
		setspd_xdire(_sb)
	elseif _sb.dire==xie_data[index][5] then
		setspd_ydire(_sb)
	else--
		move(_sb)
	end
	move_anim(_sb)
end
function edge_wmove(side,player)--斜墙边缘对角碰撞
	data={{"left_up",2},{"right_up",4},{"right_down",6},{"left_down",8}}
	for k in all(data) do
		if side==k[1] then
			if player.dire==k[2] then
				setspd_0(player)
			else
				if player.dire!=0 then
					setspd_xydire(player)
				end
			end
		end
	end
end
function encoll_roll(player,colldire)

end
function encoll_move(player,colldire)--当玩家与角色（敌人或npc）碰撞时的移动
	if colldire==1 then --左
		if player.dire==1  then
			setspd_0(player)
		elseif player.dire==2 or player.dire==8 then
			 setspd_ydire(player)
		else--可离开
			move(player)
		end
	elseif colldire==3  then --上
		if player.dire==3 then
			setspd_0(player)
		elseif player.dire==2 or player.dire==4 then 
			setspd_xdire(player)
		else
			move(player)
		end
	elseif colldire==5 then --右
		if player.dire==5 then
			setspd_0(player)
		elseif player.dire==4 or player.dire==6 then
			setspd_ydire(player)
		else
			move(player)
		end
	elseif colldire==7 then --下
		if player.dire==7 then
			setspd_0(player)
		elseif player.dire==6 or player.dire==8 then
			setspd_xdire(player)
		else
			move(player)
		end
	else --敌人在2468对角线
		setspd_0(player)
		move(player)
	end
end


