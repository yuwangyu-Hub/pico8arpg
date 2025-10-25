---------------------压缩技巧----------------------
function explode(s)--字符串恢复为数组
    local retval,lastpos={},1 
    for i=1,#s do
        if sub(s,i,i)=="," then
            add(retval,sub(s, lastpos, i-1))
            i+=1
            lastpos=i
        end
    end
    add(retval,sub(s,lastpos,#s))--添加最后一个
    return retval--返回该字符串组
end
function explodeval(_arr)--
    return toval(explode(_arr))
end
function toval(_arr)--将字符串转换为非字符串
    local _retarr={}--重新保存为数组
    for _i in all(_arr) do
        add(_retarr,flr(_i+0))--字符串加数字会变成数字
    end
    return _retarr--返回数字组
end
---------------------压缩技巧----------------------
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
function ck_sthcoll(_sth,_sb,cx,cy,cw,ch)--检测碰撞,参数代表差值(用于仅对主角碰撞器的缩放)
	local p={x=_sb.x+cx, y=_sb.y+cy, w=_sb.w+cw, h=_sb.h+ch}
	return coll_boxcheck(p.x-1,p.y-1,p.w+2,p.h+2,_sth.x,_sth.y,_sth.w,_sth.h)--将主角向外扩一个像素，来达到触碰即碰撞
end
--具体的碰撞盒
--物体1、物体2、物体1的宽、物体1的高、物体2的宽、物体2的高
function coll_boxcheck(_px,_py,_pw,_ph,_bx,_by,_bw,_bh) 
	local px1,py1,px2,py2=_px,_py,_px+_pw,_py+_ph
	local bx1,by1,bx2,by2=_bx,_by,_bx+_bw,_by+_bh
	--true:碰撞
	--false:不碰撞
	return px2>=bx1 and px1<=bx2 and py2>=by1 and py1<=by2
end
--点与物体碰撞
function c_pcheck(_e,_px,_py) --coll_pointcheck
	local sx,sy,sw,sh=_e.x,_e.y,_e.w,_e.h
	return _px>=sx and _px<=sx+sw and _py>=sy and _py<=sy+sh
end
--检测物体\角色在sb的哪个方向
function checkdir(_ore,_sb)--obj or en
	local ox1,oy1,ox2,oy2=_ore.x+2,_ore.y+2,_ore.x+_ore.w-4,_ore.y+_ore.h-4--将碰撞盒向内收缩2个像素，来达到检测深度
	local sx1,sy1,sx2,sy2=_sb.x+2,_sb.y+2,_sb.x+_sb.w-4,_sb.y+_sb.h-4--将碰撞盒向内收缩2个像素，来达到检测深度
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
function findnearest_object(objectgroup, subject)
	local mindistance = 128  -- 初始最大距离
	local nearestobject --最近的对象
	for object in all(objectgroup) do
		local distance = sqrt(abs(object.x - subject.x) + abs(object.y - subject.y))
		if distance < mindistance then
			mindistance = distance
			nearestobject = object
		end
	end
	return nearestobject
end
function attack_swordpos(_sb,_wea)--处理update中的武器实时位置
	if _wea then
		_wea.x = _sb.x+_wea.sprx[_sb.lastdire]
		_wea.y = _sb.y+_wea.spry[_sb.lastdire]
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
	_sb.x=flr(_sb.x)
	_sb.y=flr(_sb.y)
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
	local t=rnd({3,4,5,6}) --*bug
	--一定距离后停止返回idle
	if mt>=t then
		_sb.state=_sb.allstate.idle
	end
end
--value(1-3)
function check_closewall_or_en(_sb,value,dire,c_type)--检测翻滚是否即将靠近墙(value个像素的预判距离)
	local _e,colldire_e,is_e_coll --e:最近的敌人
	if #enemies!=0 then --敌人
		_e=findnearest_object(enemies, _sb)--检测最近的敌人
		colldire_e=checkdir(_e,_sb)--敌人在主角的朝向
		--is_e_coll=ck_sthcoll(_e, _sb, 0, 0, 0, 0) --是否撞上敌人
	end
	local zpoints={ --翻滚正角度的点(wall+en)
		{x=_sb.x-value,y=_sb.y},--1
		{x=_sb.x-value,y=_sb.y+7},--2
		{x=_sb.x+7,y=_sb.y-value},--3
		{x=_sb.x,y=_sb.y-value},--4
		{x=_sb.x+7+value,y=_sb.y+7},--5
		{x=_sb.x+7+value,y=_sb.y},--6
		{x=_sb.x,y=_sb.y+7+value},--7
		{x=_sb.x+7,y=_sb.y+7+value},--8
		{x=_sb.x-value,y=_sb.y},--9(重复1)
		{x=_sb.x-value,y=_sb.y+7}--10(重复2)
	}
	local xpoints={ --翻滚斜角度的点(wall)
		{x=_sb.x+value,y=_sb.y-value},
		{x=_sb.x-value,y=_sb.y+value},--2
		{x=_sb.x+7-value,y=_sb.y-value},
   		{x=_sb.x+7+value,y=_sb.y+value},--4
    	{x=_sb.x+7+value,y=_sb.y+7-value},
    	{x=_sb.x+7-value,y=_sb.y+7+value},--6
    	{x=_sb.x+value,y=_sb.y+7+value},
    	{x=_sb.x-value,y=_sb.y+7-value}--8
	}
	local en_xp={--
		{x=_sb.x-value,y=_sb.y-value},--（2）
		{x=_sb.x+7+value,y=_sb.y-value},--（4）
		{x=_sb.x+7+value,y=_sb.y+7+value},--（6）
		{x=_sb.x-value,y=_sb.y+7+value},--（8）
	}
	if dire!=0 then
		if c_type=="wall" then
			if dire%2==1 then--sb.dire1\3\5\7
				return fget(mget(flr(zpoints[dire].x/8),flr(zpoints[dire].y/8)),0) or fget(mget(flr(zpoints[dire+1].x/8),flr(zpoints[dire+1].y/8)),0)
			else --sb.dire2468
				return fget(mget(flr(xpoints[dire-1].x/8),flr(xpoints[dire-1].y/8)),0) or fget(mget(flr(xpoints[dire].x/8),flr(xpoints[dire].y/8)),0)
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
function check_roll_near_wall(_sb,iwcd)--检测翻滚是否贴墙
	local xymove=""--xy轴移动方向,贴墙斜角度也可翻滚，只是速度较低:1
	local _rollspd
	if not _sb.isclosewall then
		_rollspd=_sb.rollspeed
	end
	if check_closewall_or_en(_sb,3,_sb.lastdire,"wall") then
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
			if iwcd==8 or iwcd==1 or iwcd==2 then
				_rollspd= 0--速度为0
				xymove="no"
			end
		else
			if iwcd==_sb.dire-1 or iwcd==_sb.dire or iwcd==_sb.dire+1 then
				_rollspd= 0--速度为0
				xymove="no"
			end
		end
		--_sb.isclosewall=true
	end
	return _rollspd,xymove	
end
function roll(_sb,iwcd)--is_wall_coll_dire
	local _rollspd,xymove=check_roll_near_wall(_sb,iwcd)--检测翻滚是否贴墙
	if xymove=="x" then
		setspd_xdire(_sb,_rollspd)
	elseif xymove=="y" then
		setspd_ydire(_sb,_rollspd)
	else
		setspd_xydire(_sb,_rollspd)--设置速度
	end
	--翻滚所需时间结束
	if _sb.roll_t>=5  then
		setspd_0(_sb)
		_sb.isroll=false
		_sb.roll_t=0
		_sb.isclosewall=false
		_sb.state=_sb.allstate.idle
		setflrxy(_sb)--前面翻滚的归一化会导致一定xy坐标不为整数的可能性。
	end
end
function check_p_hurt(_sb)--玩家受伤,最近的敌人
	for e in all(enemies) do
		if e.name=="ghost" then
			if e.state==e.allstate.fly then
				if ck_sthcoll(_sb,e,0,0,0,0) then
					if checkdir(_sb,e)!=0 then
						_sb.hurtdire=checkdir(_sb,e)
					end
					return true
				end
			end
		else
			if ck_sthcoll(_sb,e,0,0,0,0) then
				if checkdir(_sb,e)!=0 then
					_sb.hurtdire=checkdir(_sb,e)
				end
				return true
			end
		end
	end
end
function check_en_hurt(_sword,_en,_p) --敌人受伤
	if _sword.isappear and _en.state!=_en.allstate.hurt then
		if ck_sthcoll(_en,_sword,0,0,0,0) then
			if checkdir(_en,_p)!=0 then
				_en.hurtdire=checkdir(_en,_p)
			end
			--_en.state=_en.allstate.hurt
			return true
		end
	end
end
function hurtmove(_sb,speed)--依照方向执行受伤
	local m_spd=speed --受伤移动速度
	if check_closewall_or_en(_sb,2,_sb.hurtdire,"wall") then
		m_spd=0--速度为1
	end
	_sb.spd.spx=dirx[_sb.hurtdire]*m_spd
	_sb.spd.spy=diry[_sb.hurtdire]*m_spd
end
function hurtdo(_sb,ht)
	hurtmove(_sb,2.5)
	--受伤动画
	if ht>=0.5 then
		_sb.state=_sb.allstate.idle
		_sb.hp-=1
	end
end
function death_do(_e,dt)
	anim_sys(en_dspr,_e,dt,.4,1)
	if dt>=4 then
		del(enemies,_e)
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
function check_wall_iswalk(v)--检测物体(角色、箱子)是否靠近墙壁（1-8分别对应墙靠近玩家的位置，0不靠墙）
	local x1,y1=flr((v.x-1)/8),flr((v.y)/8) --检测该点是否在图块上
	local x2,y2=flr((v.x-1)/8),flr((v.y+7)/8)
	local x3,y3=flr((v.x)/8),flr((v.y+8)/8)
	local x4,y4=flr((v.x+7)/8),flr((v.y+8)/8)
	local x5,y5=flr((v.x+8)/8),flr((v.y+7)/8)
	local x6,y6=flr((v.x+8)/8),flr((v.y)/8)
	local x7,y7=flr((v.x+7)/8),flr((v.y-1)/8)
	local x8,y8=flr((v.x)/8),flr((v.y-1)/8)
	local lu,ld,dl,dr,rd,ru,ur,ul=fget(mget(x1,y1),0),fget(mget(x2,y2),0),fget(mget(x3,y3),0),fget(mget(x4,y4),0),fget(mget(x5,y5),0),fget(mget(x6,y6),0),fget(mget(x7,y7),0),fget(mget(x8,y8),0)
	local x02,y02=flr((v.x-1)/8),flr((v.y-1)/8) --左上角
	local x04,y04=flr((v.x+8)/8),flr((v.y-1)/8) --右上角
	local x06,y06=flr((v.x+8)/8),flr((v.y+8)/8) --右下角
	local x08,y08=flr((v.x-1)/8),flr((v.y+8)/8) --左下角
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
	elseif (ur or ul) and (rd or ru) then --是否靠墙4
		return 4,"no"
	elseif (rd or ru) and not(ur or ul) and not(dl or dr) then --是否靠墙5
		if rd and not ru then
			return 5,"up"
		elseif not rd and ru then
			return 5,"down"
		else
			return 5,"no"
		end	
	elseif (rd or ru) and (dl or dr) then --是否靠墙6
		return 6,"no"
	elseif (dl or dr) and not(lu or ld) and not(rd or ru) then --是否靠墙7
		if dl and not dr then
			return 7,"right"
		elseif not dl and  dr then
			return 7,"left"
		else
			return 7,"no"
		end
	elseif (dl or dr) and (lu or ld) then --是否靠墙8
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
	local data={
		{flr((wy.x-1)/8),flr((wy.y+3)/8),flr((wy.x-1)/8),flr((wy.y+4)/8)},
		{flr((wy.x+4)/8),flr((wy.y-1)/8),flr((wy.x+3)/8),flr((wy.y-1)/8)},
		{flr((wy.x+8)/8),flr((wy.y+3)/8),flr((wy.x+8)/8),flr((wy.y+4)/8)},
		{flr((wy.x+4)/8),flr((wy.y+8)/8),flr((wy.x+3)/8),flr((wy.y+8)/8)},
	}
	local index=(coll_dire+1)/2
	return checkwallside(data[index][1],data[index][2],data[index][3],data[index][4])
end
function checkwallside(x1,y1,x2,y2)
	return not (fget(mget(x1,y1),0) and fget(mget(x2,y2),0))
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
	_sb.move_t = anim_sys(_sb.sprs.move,_sb,_sb.move_t,.2,1)
end
function x2468wmove(_dire,_sb,t)--斜wall
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

--当玩家与npc碰撞时的移动
function npc_cmove(player,colldire)
	local data={
		{1,2,8},
		{3,2,4},
		{5,4,6},
		{7,6,8}}
	local index=(colldire+1)/2
	if colldire==1 or colldire==3 or colldire==5 or colldire==7 then
		if player.dire==data[index][1] then
			setspd_0(player)
		elseif player.dire==data[index][2] or player.dire==data[index][3] then
			if index%2==0 then
				setspd_xdire(player)
			else
				setspd_ydire(player)
			end
		else
			move(player)
		end
	else --在2468对角线
		if colldire==player.dire then
			setspd_0(player)
		else
			move(player)
		end
	end
end

function check_hp(e)--检测敌人血量
	if e.hp<=0 then
		e.state=e.allstate.death
	end
end

function check_p_dis(e,p)--检测玩家与敌人之间的距离
	return dist(e.x+e.w/2,e.y+e.h/2,p.x+p.w/2,p.y+p.h/2)<e.crange
end

function dist(x1,y1,x2,y2)--计算两点之间的距离
	return sqrt((x1-x2)^2+(y1-y2)^2)
end



