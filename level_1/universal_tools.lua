function doshake()--镜头抖动
	local shakex,shakey=rnd(shake)-(shake/2),rnd(shake)-(shake/2)
	camera(shakex,shakey)
	if shake>10 then
		shake*=0.9
	else
		shake-=1
		if(shake<1)shake=0
	end
end
function blink()--闪烁工具，返回闪烁的颜色动画
	local blink_anim=explodeval("5,5,5,5,5,5,5,5,6,6,7,7,6,6,5,5")
    --blinkt:闪烁计时器，在主函数中创建并且更新
	return blink_anim[blinkt%#blink_anim]
end
--x位置对称打印，而不是左上角位置。输入 x 为画面中心位置打印
function cprint(txt,x,y,c)--xy位置，c颜色
	print(txt,x-#txt*2,y,c)
end
--主角与物碰撞
function ck_sthcoll(_sb,_sth)--检测碰撞,参数代表差值(用于仅对主角碰撞器的缩放)
	local x,y,w,h=_sb.cx or _sb.x , _sb.cy or _sb.y ,_sb.cw or _sb.w , _sb.ch or _sb.h
	return coll_boxcheck(x-1, y-1, w+2, h+2, _sth.x,_sth.y,_sth.w,_sth.h)
end
--具体的碰撞盒
--物体1、物体2、物体1的宽、物体1的高、物体2的宽、物体2的高
function coll_boxcheck(_px,_py,_pw,_ph,_bx,_by,_bw,_bh) 
	return _px+_pw>=_bx and _px<=_bx+_bw and _py+_ph>=_by and _py<=_by+_bh
end
--点与物体碰撞
function c_pcheck(_e,_px,_py) --coll_pointcheck
	--local sx,sy,sw,sh=_e.x,_e.y,_e.w,_e.h
	return _px>=_e.x and _px<=_e.x+_e.w and _py>=_e.y and _py<=_e.y+_e.h
end
--检测物体\角色在sb的哪个方向
function checkdir(_ob2,_sb1)--obj/sb
	local ox1,oy1,ox2,oy2=_ob2.x+2,_ob2.y+2,_ob2.x+_ob2.w-4,_ob2.y+_ob2.h-4 --将碰撞盒向内收缩2个像素，来达到检测深度
	local sx1,sy1,sx2,sy2=_sb1.x+2,_sb1.y+2,_sb1.x+_sb1.w-4,_sb1.y+_sb1.h-4--将碰撞盒向内收缩2个像素，来达到检测深度
	if sx1>ox2 and sy2>=oy1 and sy1<=oy2 then--ob2在sb1左边
		return 1 --ob2为sb的1
	elseif sx1>ox2 and sy1>oy2 then--ob2在sb1左上
		return 2 --2
	elseif sy1>oy2 and sx2>=ox1 and sx1<=ox2 then--ob2在sb1上边
		return 3 --3
	elseif sx2<ox1 and sy1>oy2 then--ob2在sb1右上
		return 4 --4
	elseif sx2<ox1 and sy2>=oy1 and sy1<=oy2 then--ob2在sb1右边
		return 5 --5
	elseif sx2<ox1 and sy2<oy1 then--ob2在sb1右下
		return 6 --6
	elseif sy2<oy1 and sx2>=ox1 and sx1<=ox2 then--ob2在sb1下边
		return 7 --7
	elseif sx1>ox2 and sy2<oy1 then--ob2在sb1左下
		return 8 --8
	else --在物体内？(碰撞)
		return 0
	end
end
--检测敌人如果靠墙后识别 玩家位置 是否在靠墙一侧。如果在靠墙一侧就false不追，如果不在靠墙一侧true追
function en_nestwall(p,en)--p:玩家,en:敌人
	if check_wall_iswalk(en.x,en.y,8,8,wy.mappos)==1 then --34567
		return ({[3]=true,[4]=true,[5]=true,[6]=true,[7]=true})[checkdir(p,en)]
	elseif check_wall_iswalk(en.x,en.y,8,8,wy.mappos)==2 then--567
		return ({[5]=true,[6]=true,[7]=true})[checkdir(p,en)]
	elseif check_wall_iswalk(en.x,en.y,8,8,wy.mappos)==3 then--15678
		return ({[1]=true,[5]=true,[6]=true,[7]=true,[8]=true})[checkdir(p,en)]
	elseif check_wall_iswalk(en.x,en.y,8,8,wy.mappos)==4 then--178
		return ({[1]=true,[7]=true,[8]=true})[checkdir(p,en)]
	elseif check_wall_iswalk(en.x,en.y,8,8,wy.mappos)==5 then--12378
		return ({[1]=true,[2]=true,[3]=true,[7]=true,[8]=true})[checkdir(p,en)]
	elseif check_wall_iswalk(en.x,en.y,8,8,wy.mappos)==6 then--123
		return ({[1]=true,[2]=true,[3]=true})[checkdir(p,en)]
	elseif check_wall_iswalk(en.x,en.y,8,8,wy.mappos)==7 then--12345
		return ({[1]=true,[2]=true,[3]=true,[4]=true,[5]=true})[checkdir(p,en)]
	elseif check_wall_iswalk(en.x,en.y,8,8,wy.mappos)==8 then--345
		return ({[3]=true,[4]=true,[5]=true})[checkdir(p,en)]
	else--0
		return true
	end
end
-- 查找集合中距离主体最近的对象
-- objectGroup 对象集合
-- subject 主体对象
function findnearest_object(objectgroup, subject)
	local mindistance = 128  -- 初始最大距离
	local nearestobject --最近的对象
	for object in all(objectgroup) do
		local distance = sqrt(abs(object.x - subject.x) + abs(object.y - subject.y))
		if distance < mindistance then
			mindistance,nearestobject = distance,object
		end
	end
	return nearestobject
end
function attack_swordpos(_sb,_wea)--处理update中的武器实时位置
	if _wea then
		_wea.x, _wea.y = _sb.x+_wea.sprx[_sb.lastdire], _sb.y+_wea.spry[_sb.lastdire]
	end
end
function setspd_0(sb)--速度设置为0
	sb.spd.spx,sb.spd.spy=0,0
end
function setspd_xydire(sb,spd)
	local uspd=sb.speed --如果没指定，就自身的spd
	if spd then uspd=spd end
	sb.spd.spx,sb.spd.spy=dirx[sb.dire]*uspd,diry[sb.dire]*uspd
end
function setspd_xdire(sb,spd)
	local uspd=sb.speed
	if spd then uspd=spd end
	sb.spd.spx,sb.spd.spy=dirx[sb.dire]*uspd,0
end
function setspd_ydire(sb,spd)
	local uspd=sb.speed
	if spd then uspd=spd end
	sb.spd.spx,sb.spd.spy=0,diry[sb.dire]*uspd
end

function setflrxy(_sb)--将 xy位置 四舍五入到最近的整数
	_sb.x, _sb.y=flr(_sb.x), flr(_sb.y)
end 
function xypluspd(_sb)--xy位置加上速度
	_sb.x,_sb.y=_sb.x+_sb.spd.spx,_sb.y+_sb.spd.spy
end
function move(_sb)
	setspd_0(_sb)
	if _sb.dire!=0 then setspd_xydire(_sb) end
end
function rnd_move(_sb,mt)--四方向随机移动,movet
	mt+=0.1
	--移动
	setspd_xydire(_sb)
	--敌人后停止
	local data=explodeval("2,2,3,3,7,7,7,8,8,9,9,9")
	local t=rnd(data) --*bug
	--一定距离后停止返回idle
	if mt>=t then
		_sb.state=_sb.allstate.idle
	end
end

function check_inbounds(_sb)--检查是否在画面内，如果在返回true
	return _sb.x>=2 and _sb.x<=118 and _sb.y>=2 and _sb.y<=118
end
function inbounds_side(_sb)--检查哪一条边在画面内
	if _sb.x<2 then 
		return 1 
	elseif _sb.x>118 then 
		return 5 
	elseif _sb.y<2 then 
		return 3 
	elseif _sb.y>118 then 
		return 7 
	else
		return 0
	end
end

--value(1-3)
function check_closewall_or_en(_sb,value,dire,c_type)--检测翻滚是否即将靠近墙/敌人？(value个像素的预判距离)
	local _x,_y,_w,_h=_sb.cx or _sb.x,_sb.cy or _sb.y,_sb.cw or 7 ,_sb.ch or 7
	local _e,colldire_e,is_e_coll --e:最近的敌人
	if #enemies!=0 then --敌人
		_e=findnearest_object(enemies, _sb)--检测最近的敌人
		colldire_e=checkdir(_e,_sb)--敌人在主角的朝向
	end
	local zpoints={ --翻滚正角度的点(wall+en)
		{x=_x-value,y=_y},--1
		{x=_x-value,y=_y+_h},--2
		{x=_x+_w,y=_y-value},--3
		{x=_x,y=_y-value},--4
		{x=_x+_w+value,y=_y+_h},--5
		{x=_x+_w+value,y=_y},--6
		{x=_x,y=_y+_h+value},--7
		{x=_x+_w,y=_y+_h+value},--8
		{x=_x-value,y=_y},--9(重复1)
		{x=_x-value,y=_y+_h}--10(重复2)
	}
	local xpoints={ --翻滚斜角度的点(wall)
		{x=_x+value,y=_y-value},
		{x=_x-value,y=_y+value},--2
		{x=_x+_w-value,y=_y-value},
   		{x=_x+_w+value,y=_y+value},--4
    	{x=_x+_w+value,y=_y+_h-value},
    	{x=_x+_w-value,y=_y+_h+value},--6
    	{x=_x+value,y=_y+_h+value},
    	{x=_x-value,y=_y+_h-value}--8
	}
	local en_xp={--
		{x=_x-value,y=_y-value},--（2）
		{x=_x+_w+value,y=_y-value},--（4）
		{x=_x+_w+value,y=_y+_h+value},--（6）
		{x=_x-value,y=_y+_h+value},--（8）
	}
	if dire!=0 then
		if c_type=="wall" then
			if dire%2==1 then--sb.dire1\3\5\7
				return fget(mget(flr(zpoints[dire].x/8)+mapnum[wy.mappos][1],flr(zpoints[dire].y/8)+mapnum[wy.mappos][2]),0) or fget(mget(flr(zpoints[dire+1].x/8)+mapnum[wy.mappos][1],flr(zpoints[dire+1].y/8)+mapnum[wy.mappos][2]),0)
			else --sb.dire2468
				return fget(mget(flr(xpoints[dire-1].x/8)+mapnum[wy.mappos][1],flr(xpoints[dire-1].y/8)+mapnum[wy.mappos][2]),0) or fget(mget(flr(xpoints[dire].x/8)+mapnum[wy.mappos][1],flr(xpoints[dire].y/8)+mapnum[wy.mappos][2]),0)
			end
		elseif c_type=="en" then
			if dire%2==1 then--sb.dire1\3\5\7
				return c_pcheck(_e,zpoints[dire].x,zpoints[dire].y) or 
				c_pcheck(_e,zpoints[dire+1].x,zpoints[dire+1].y)
			else --sb.dire2468 --*需要优化	
				return c_pcheck(_e,zpoints[dire-1].x,zpoints[dire-1].y) or 
				c_pcheck(_e,zpoints[dire].x,  zpoints[dire].y) or 
				c_pcheck(_e,zpoints[dire+1].x,zpoints[dire+1].y) or 
				c_pcheck(_e,zpoints[dire+2].x,zpoints[dire+2].y) or 
				c_pcheck(_e,en_xp[dire/2].x,en_xp[dire/2].y)
			end
		end
	end
end
function check_roll_near_wall(_sb,iwcd)--检测翻滚是否贴墙 iwcd:
	local xymove=""--xy轴移动方向,贴墙斜角度也可翻滚，只是速度较低:1
	local _rollspd
	if not _sb.isclosewall then--如果不是贴墙
		_rollspd=_sb.rollspeed
	end
	if check_closewall_or_en(_sb,3,_sb.lastdire,"wall") then--如果靠近贴墙或敌人
		_rollspd=1--速度为1
		_sb.isclosewall=true
	end
	if #enemies>0 then
		if check_closewall_or_en(_sb,3,_sb.lastdire,"en") then--如果靠近敌人
			_rollspd=1
			_sb.isclosewall=true
		end
	end
	if _sb.dire==2 or _sb.dire==4 or _sb.dire==6 or _sb.dire==8 then
		local data={
		{3,"x",1,"y"},
		{3,"x",5,"y"},
		{7,"x",5,"y"},
		{7,"x",1,"y"}}
		local ind=_sb.dire/2
		if _sb.dire==iwcd then
			_rollspd= 0--速度为0
			xymove="no"
		elseif iwcd==data[ind][1] then
			_rollspd=1
			xymove=data[ind][2]
			_sb.isclosewall=true
		elseif iwcd==data[ind][3] then
			_rollspd=1
			xymove=data[ind][4]
			_sb.isclosewall=true
		end
	else--1357
		if _sb.dire==1 then
			local v={[8]=true,[1]=true,[2]=true}
			if v[iwcd] then
				_rollspd,xymove=0,"no"--速度为0
			end
		else --357
			if iwcd==_sb.dire-1 or iwcd==_sb.dire or iwcd==_sb.dire+1 then
				_rollspd,xymove=0,"no"--速度为0
			end
		end
	end
	--if _sb.cx<3 or _sb.cx >120 or _sb.cy<3 or _sb.cy >124 then
		--_rollspd=1
	--end
	return _rollspd,xymove
end
function roll(_sb,iwcd)--is_wall_coll_dire
	local _rollspd,xymove=check_roll_near_wall(_sb,iwcd)--检测翻滚是否贴墙
	local t={["x"]=setspd_xdire,["y"]=setspd_ydire}
	if not _rollspd then _rollspd= _sb.dire%2==1 and 3 or 2.1213 end
	(t[xymove]or setspd_xydire)(_sb,_rollspd)
	--[[if xymore=="x" then
		setspd_xdire(_sb,_rollspd)
	elseif xymore=="y" then
		setspd_ydire(_sb,_rollspd)
	else
		setspd_xydire(_sb,_rollspd)
	end]]
	--翻滚所需时间结束
	if _sb.roll_t>=5 then
		setspd_0(_sb)
		_sb.isroll, _sb.isclosewall, _sb.roll_t, _sb.state=false, false, 0, _sb.allstate.idle
		setflrxy(_sb)--前面翻滚的归一化会导致一定xy坐标不为整数的可能性。
	end
end
function hurtdir(_sb,_v1,_v2)--如果碰撞了受伤方向设置为检测方向
	if ck_sthcoll(_sb,_v1) then
		if checkdir(_sb,_v2)!=0 then
			_sb.hurtdire=checkdir(_sb,_v2)
		end
		return true
	end
end
function check_p_hurt(_sb,type,v)--玩家受伤,最近的敌人,type:检测类型,v:bullet/enemy
	if type=="en" then--检测类型为敌人
		if v.name=="ghost" then--如果敌人是小幽灵
			if v.state==v.allstate.fly then
				return hurtdir(_sb,v,v)
			end
		else
			return hurtdir(_sb,v,v)
		end
	elseif type=="bu" then  --检测类型为子弹
		return hurtdir(_sb,v,v)
	end
end
function check_en_hurt(_sword,_en,_p) --敌人受伤
	if _sword.isappear and _en.state!=_en.allstate.hurt and _en.wudi_t==0 then
		return hurtdir(_en,_sword,_p)
	end
end
function switchhurt(en)
	if check_en_hurt(sword,en,wy) then
		en.state=en.allstate.hurt
	end
end
function switch_framehurt(en)
	if check_en_hurt(sword,en,wy) then
		en.state,en.hurtframe=en.allstate.hurt,(en.dire+1)/2
	end
end
function hurtmove(_sb,speed)--依照方向执行受伤
	local m_spd=speed --受伤移动速度
	if check_closewall_or_en(_sb,2,_sb.hurtdire,"wall") then
		m_spd=0--速度为1
	end
	_sb.spd.spx, _sb.spd.spy = dirx[_sb.hurtdire]*m_spd, diry[_sb.hurtdire]*m_spd
end
function hurtdo(_e,_spr,t1,t2)
	_e.wudi_t=anim_sys(_spr,_e,_e.wudi_t,t1,t2)
	if check_inbounds(_e) then
		hurtmove(_e,2.5)
	else
		setspd_0(_e)
	end
	--受伤动画
	if _e.wudi_t>=1 then
		_e.state=_e.allstate.idle
		_e.hp-=1
	end
end
function death_do(_e)
	_e.die_t+=.4
	anim_sys(en_dspr,_e,_e.die_t,.4,1)
	if _e.die_t>=4 then
		del(enemies,_e)
	end
end
function nomalize(sb,speed1,speed2)--归一化
	local respeed=0
	respeed=(sb.dire==2 or sb.dire==4 or sb.dire==6 or sb.dire==8) and speed1 or speed2 
	return respeed
end
function check_wall_iswalk(x,y,w,h,num)--检测物体v(物体)是否靠近墙壁（1-8分别对应墙靠近玩家的位置，0不靠墙）num:地图位置编号
	--mapnum[num][1]和mapnum[num][2]用来对应不同地图下的图块位置偏移量
	--*w,h为物体的宽度和高度
	--*修改函数，来匹配不同尺寸的物体/人物
	--检测该点是否在图块上
	--八个点分别为上下左右四个侧面的两个端点。
	local x1,y1,x2,y2=flr((x-1)/8)+mapnum[num][1],flr((y)/8)+mapnum[num][2],flr((x-1)/8)+mapnum[num][1],flr((y+h-1)/8)+mapnum[num][2]
	local x3,y3,x4,y4=flr(x/8)+mapnum[num][1],flr((y+h)/8)+mapnum[num][2],flr((x+w-1)/8)+mapnum[num][1],flr((y+h)/8)+mapnum[num][2]
	local x5,y5,x6,y6=flr((x+w)/8)+mapnum[num][1],flr((y+h-1)/8)+mapnum[num][2],flr((x+w)/8)+mapnum[num][1],flr((y)/8)+mapnum[num][2]
	local x7,y7,x8,y8=flr((x+w-1)/8)+mapnum[num][1],flr((y-1)/8)+mapnum[num][2],flr((x)/8)+mapnum[num][1],flr((y-1)/8)+mapnum[num][2]
	--分别对应这八个点的图块
	local lu,ld,dl,dr,rd,ru,ur,ul=fget(mget(x1,y1),0),fget(mget(x2,y2),0),fget(mget(x3,y3),0),fget(mget(x4,y4),0),fget(mget(x5,y5),0),fget(mget(x6,y6),0),fget(mget(x7,y7),0),fget(mget(x8,y8),0)--左上,左下,下左,下右,右下,右上,上右,上左
	--物体的四个顶点位置
	local x02,y02,x04,y04,x06,y06,x08,y08=flr((x-1)/8),flr((y-1)/8),flr((x+w)/8),flr((y-1)/8),flr((x+w)/8),flr((y+h)/8),flr((x-1)/8),flr((y+h)/8)--左上角--右上角--右下角--左下角
	if (lu or ld) and not(ur or ul) and not (dl or dr) then --是否靠墙1
		if lu and not ld then
			return 1,"down" --因为左上角检测点检测到了，而左下角没检测到，所以在下面
		elseif not lu and  ld then
			return 1,"up"
		else
			return 1,"no" --考虑到玩家不在边缘
		end
	elseif (lu or ld) and (ur or ul) then --是否靠墙2
		return 2,"no"
	elseif (ur or ul) and not(lu or ld) and not(rd or ru) then--是否靠墙3
		if ur and not ul then
			return 3,"left"
		elseif not ur and  ul then
			return 3,"right"
		else
			return 3,"no"
		end
	elseif(ur or ul)and(rd or ru)then --是否靠墙4
		return 4,"no"
	elseif(rd or ru)and not(ur or ul)and not(dl or dr)then --是否靠墙5
		if rd and not ru then
			return 5,"up"
		elseif not rd and ru then
			return 5,"down"
		else
			return 5,"no"
		end	
	elseif(rd or ru)and(dl or dr)then --是否靠墙6
		return 6,"no"
	elseif(dl or dr)and not(lu or ld)and not(rd or ru)then --是否靠墙7
		if dl and not dr then
			return 7,"right"
		elseif not dl and  dr then
			return 7,"left"
		else
			return 7,"no"
		end
	elseif(dl or dr)and(lu or ld)then --是否靠墙8
		return 8,"no"
	else  ----不靠墙
		--对角检测
		if fget(mget(x02+mapnum[num][1],y02+mapnum[num][2]),0) then
			return -1,"left_up"
		elseif fget(mget(x04+mapnum[num][1],y04+mapnum[num][2]),0) then
			return -1,"right_up"
		elseif fget(mget(x06+mapnum[num][1],y06+mapnum[num][2]),0) then
			return -1,"right_down"
		elseif fget(mget(x08+mapnum[num][1],y08+mapnum[num][2]),0) then
			return -1,"left_down"
		else
			return 0,"no"
		end
	end
end
function wallside(coll_dire)--是否站在墙角边缘(用于滑动)
	local data=({{flr((wy.x-1)/8),flr((wy.y+3)/8),flr((wy.x-1)/8),flr((wy.y+4)/8)},{flr((wy.x+4)/8),flr((wy.y-1)/8),flr((wy.x+3)/8),flr((wy.y-1)/8)},{flr((wy.x+8)/8),flr((wy.y+3)/8),flr((wy.x+8)/8),flr((wy.y+4)/8)},{flr((wy.x+4)/8),flr((wy.y+8)/8),flr((wy.x+3)/8),flr((wy.y+8)/8)}})[(coll_dire+1)/2]
	return checkwallside(data[1],data[2],data[3],data[4])
end
function checkwallside(x1,y1,x2,y2)
	return not (fget(mget(x1+mapnum[wy.mappos][1],y1+mapnum[wy.mappos][2]),0) and fget(mget(x2+mapnum[wy.mappos][1],y2+mapnum[wy.mappos][2]),0))
end
function wallcoll_move(player,coll_dire,oneside) --玩家与墙壁的碰撞移动
	
	if coll_dire==1 or coll_dire==3 or coll_dire==5 or coll_dire==7 then
		z1357wmove(coll_dire,player,oneside)
	-------------------------------斜4角度----------------------------
	elseif coll_dire==-1 then --无常规碰撞
		if oneside=="no" then
			move(player)
		else --左上、右上、左下、右下
			edge_wmove(oneside,player)
		end
	else --2468
		x2468wmove(coll_dire,player)
	end
end
function z1357wmove(_dire,_sb,side)--正wall
	local data=({{1,2,8,"up",0,-1,"down",0,1},{3,2,4,"left",-1,0,"right",1,0},{5,4,6,"up",0,-1,"down",0,1},{7,6,8,"left",-1,0,"right",1,0}})[(_dire+1)/2]
	if _sb.dire==data[1] then
		if wallside(_dire) then
			if side==data[4] then
				_sb.spd.spx, _sb.spd.spy=data[5], data[6]
			elseif side==data[7] then
				_sb.spd.spx, _sb.spd.spy=data[8], data[9]
			end
		else
			setspd_0(_sb)
		end
	elseif _sb.dire==data[2] or _sb.dire==data[3] then
		(_dire%4==1 and setspd_ydire or setspd_xdire)(_sb)
		--[[if _dire==1 or _dire==5 then
			setspd_ydire(_sb)--*bug
		else
			setspd_xdire(_sb)--*bug
		end]]
	else
		move(_sb)
	end
	_sb.move_t = anim_sys(_sb.sprs.move,_sb,_sb.move_t,.2,1)
end
function x2468wmove(_dire,_sb,t)--斜wall：2468情况
	--x=xie_data
	local x=explodeval("[1,2,3,4,8],[3,4,5,2,6],[5,6,7,8,4],[7,8,1,6,2]")[_dire/2]
	if _sb.dire!=0 then
		(({[x[1]]=setspd_0,[x[2]]=setspd_0,[x[3]]=setspd_0,[x[4]]=setspd_xdire,[x[5]]=setspd_ydire})[_sb.dire]or move)(_sb)
	end
	--[[if _sb.dire==xie_data[1] or _sb.dire==xie_data[2] or _sb.dire==xie_data[3] then
		setspd_0(_sb)
	elseif _sb.dire==xie_data[4] then
		setspd_xdire(_sb)
	elseif _sb.dire==xie_data[5] then
		setspd_ydire(_sb)
	else--
		move(_sb)
	end]]
	_sb.move_t = anim_sys(_sb.sprs.move,_sb,_sb.move_t,.2,1)
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
function check_hp(e)--检测敌人血量
	if e.hp<=0 then
		e.state,e.rnd=e.allstate.death,flr(rnd(10))
	end
end
function check_p_dis(e,p)--检测玩家与敌人之间的距离
	return dist(e.x+e.w/2,e.y+e.h/2,p.x+p.w/2,p.y+p.h/2)<e.crange
end
function dist(x1,y1,x2,y2)--计算两点之间的距离
	return sqrt((x1-x2)^2+(y1-y2)^2)
end
function check_p(e,c)--矩形范围内检测玩家,c为检测长度
	--x,y,w,h,1357
	local data=({{e.x-c,e.y,c,7},{e.x,e.y-c,7,c},{e.x+7,e.y,c+7,7},{e.x,e.y+7,7,c+7}})[(e.lastdire+1)/2]
	--rect(data[1],data[2],data[1]+data[3],data[2]+data[4],12)
	return ck_sthcoll(wy,{x=data[1],y=data[2],w=data[3],h=data[4]})
end
function firebullet(c)--栗子怪发射子弹
	setspd_xydire(c)
	cnut.t+=0.1
	xypluspd(c)
	anim_sys(c.sprs,c,c.t,.1,4)
end

function drop_heart(en,_mapos)--生成血袋
	makeobj(3,en.x,en.y,_mapos)
end



