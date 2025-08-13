--工具lib
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
--闪烁工具，返回闪烁的颜色动画
function blink()
	local blink_anim={5,5,5,5,5,5,5,5,6,6,7,7,6,6,5,5}
    --blinkt:闪烁计时器，在主函数中创建并且更细
	return blink_anim[blinkt%#blink_anim] 
end
--x位置对称打印，而不是左上角位置
--输入 x 为画面中心位置打印
function cprint(txt,x,y,c)--xy位置，c颜色
	print(txt,x-#txt*2,y,c)
end
--[[
--画面检测：128X128
--对象、左、右、上、下
function checkwall(sb,lx,rx,uy,dy)
	if sb.x<lx then sb.x=lx end
	if sb.x>rx then sb.x=rx end 
	if sb.y<uy then sb.y=uy end
	if sb.y>dy then sb.y=dy end
	return sb
end
function creat_ck_line(_sb,cx,cy,cw,ch)--显示检测的四边
	local collx,colly,collw,collh=_sb.x+cx,_sb.y+cy,_sb.w+cw,_sb.h+ch
	----ck:check，coll:collision
	cb_line[1]={num=1,x1=collx,   y1=colly+7,x2=collx,  y2=colly,   c=14, ck=false, coll=false} --1 0700
	cb_line[2]={num=3,x1=collx,   y1=colly,  x2=collx+7,y2=colly,   c=14, ck=false, coll=false} --3 0070
	cb_line[3]={num=5,x1=collx+7, y1=colly,  x2=collx+7,y2=colly+7, c=14, ck=false, coll=false} --5 7077
	cb_line[4]={num=7,x1=collx+7, y1=colly+7,x2=collx,  y2=colly+7, c=14, ck=false, coll=false} --7 7707
end
function act_checkline(sb)--识别方向激活检测
    if sb.dire==1 or sb.dire== 3 or sb.dire==5 or sb.dire==7 then
        cb_line[(sb.dire+1)/2].c=8
        cb_line[(sb.dire+1)/2].ck=true
    elseif sb.dire==0 then
        for c in all(cb_line) do
            c.c=14
            c.ck=false
        end
    else--斜四方位
        --1
        cb_line[(sb.dire)/2].c=8
        cb_line[(sb.dire)/2].ck=true
        --2
        cb_line[(sb.dire/2)%4+1].c=8
        cb_line[(sb.dire/2)%4+1].ck=true
    end
end]]
function ck_sthcoll(_o,_sb,cx,cy,cw,ch)--检测碰撞,参数代表差值
	--creat_ck_line(_sb,0,0,0,0)--创建检测线
	--act_checkline(_sb)--激活检测盒
	local p={
		x=_sb.x+cx,
		y=_sb.y+cy,
		w=_sb.w+cw,
		h=_sb.h+ch
	}
	return coll_boxcheck(p.x-1,p.y-1,p.w+2,p.h+2,_o.x,_o.y,_o.w,_o.h)
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
--当靠近物体碰撞时，不同的条件触发不同的效果
function move_and_push(_obj,_sb,_colldire) --_colldire:物体在主角的方向
	
	local d_date={
		{1,2,8,3,7,0,1}, --与碰撞相同的方向、四个其他方向、x、y
		{3,2,4,1,5,1,0},
		{5,4,6,3,7,0,1},
		{7,8,6,1,3,1,0}}
	if _colldire==1 or _colldire==3 or _colldire==5 or _colldire==7 then--物体相较于角色的朝向
		--1\2\3\4
		ispush=false
		
		local direnum=(_colldire+1)/2--朝向针对碰撞信息组的值，符合索引
		if _sb.dire==d_date[direnum][1] then --当前移动方向 
			if checkcoll_edge(_obj,_sb,_colldire) then --如果在边缘x
				
				if  d_date[direnum][6]==1 then --检测x方向
					if abs(_obj.x-(_sb.x+_sb.w))<=3 and _sb.dire==d_date[direnum][1] then
						_sb.spd.spx=-_sb.speed
						_sb.spd.spy=0
					elseif abs((_obj.x+_obj.w)-_sb.x)<=3 and _sb.dire==d_date[direnum][1] then
						_sb.spd.spx=_sb.speed
						_sb.spd.spy=0
					end
				elseif d_date[direnum][7]==1 then--检测y方向
					if abs(_obj.y-(_sb.y+_sb.h))<=3 and _sb.dire==d_date[direnum][1] then
						_sb.spd.spx=0
						_sb.spd.spy= -_sb.speed
					elseif abs((_obj.y+_obj.h)-_sb.y)<=3 and _sb.dire==d_date[direnum][1] then
						_sb.spd.spx=0
						_sb.spd.spy=_sb.speed
					end
				end
			else--不在边缘（可推）
				pushsth(_obj,_sb,_colldire)
				pull_anim(_sb,_colldire)
				ispush=true
			end
		elseif _sb.dire==d_date[direnum][2] or _sb.dire==d_date[direnum][3] then --对应的斜方向
			
			_sb.spd.spx=dirx[_sb.dire]*_sb.speed*d_date[direnum][6]
			_sb.spd.spy=diry[_sb.dire]*_sb.speed*d_date[direnum][7]
			pull_anim(_sb,_colldire)
		else
			ispush=false
			move(_sb)
		end
	elseif _colldire==0 then --物体与主角碰撞有叠加
		_sb.spd.spx=0
		_sb.spd.spy=0
	else --2468对角线
		check_Diagonal(_colldire,_sb)
	end
	
end
function check_Diagonal(_colldire,_sb)--检测对角线
	local coll_dire={2,4,6,8}
	for i=1,#coll_dire do
		if coll_dire[i]==_colldire then
			if coll_dire[i]==_sb.dire then
				_sb.spd.spx=0
				_sb.spd.spy=0
			else
				move(_sb)
			end	
		end
	end
end
function checkcoll_edge(_obj,_sb,_colldire)--检测是否在物体碰撞两侧边缘，小于等于3的像素位置
	local sbcenter_x,sbcenter_y=_sb.x+_sb.w/2,_sb.y+_sb.h/2
	local objcenter_x,objcenter_y=_obj.sprx+_obj.sprw/2,_obj.spry+_obj.sprh/2
	if _colldire==1 or _colldire==5 then
		if abs(_obj.spry-(_sb.y+_sb.h))<=3 or abs((_obj.spry+_obj.sprh)-_sb.y)<=3 then
			return true
		end
	elseif _colldire==3 or _colldire==7 then
		if abs(_obj.sprx-(_sb.x+_sb.w))<=3 or abs((_obj.sprx+_obj.sprw)-_sb.x)<=3 then
			return true
		end
	else
		return false
	end
end
function pushsth(_obj,_sb)--推物体
	--dire：1, 3, 5, 7
	--x:   -1, 0, 1, 0
	--y:    0,-1, 0, 1
	--需要说明：当主角靠近物体，刚要推这时候物体就会移动一个像素，所以在显示上会看上去有一个空隙
	--所以要通过缩小物体碰撞器来变相的解决这个问题
	if _sb.dire!=0 then
		_obj.x=_obj.x+dirx[_sb.dire]
		_obj.y=_obj.y+diry[_sb.dire]
		_obj.sprx=_obj.sprx+dirx[_sb.dire]
		_obj.spry=_obj.spry+diry[_sb.dire]
	end
end
--[[
function set_ocoll(_objs)--设置物体的碰撞体(缩小一圈)
	_objs.x=_objs.sprx+1
	_objs.y=_objs.spry+1
	_objs.w=_objs.sprw-2
	_objs.h=_objs.sprh-2
end
function reset_ocoll(_objs)--设置物体的碰撞体(缩小一圈)
	_objs.x=_objs.sprx
	_objs.y=_objs.spry
	_objs.w=_objs.sprw
	_objs.h=_objs.sprh
end]]
function spr_flip(_sb)
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
function move(_sb)
	_sb.spd.spx,_sb.spd.spy=0,0
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
function check_p_hurt(_sb)--玩家受伤
	local _ishurt
	for e in all(enemies) do
		_sb.hurtdire=checkdir(e,_sb)
		_ishurt = coll_boxcheck(_sb.x,_sb.y,_sb.w,_sb.h,e.x,e.y,e.w,e.h)
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
	_sb.hurtmt+=0.1
	local xsum=dirx[_sb.hurtdire]*-1 --反方向加权
	local ysum=diry[_sb.hurtdire]*-1 
	_sb.spd.spx=xsum*m_spd
	_sb.spd.spy=ysum*m_spd
	hurt2idle(_sb)
end
function hurt2idle(_sb)--受伤结束-idle
	if _sb.hurtmt>=0.7 then
		_sb.hurtmt=0
		_sb.spd.spx=0
		_sb.spd.spy=0
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
function check_wall_iswalk(p)--检测玩家是否靠近墙壁（1-8分别对应墙靠近玩家的位置，0不靠墙）
	local x1,y1=flr((p.x-1)/8),flr((p.y)/8)
	local x2,y2=flr((p.x-1)/8),flr((p.y+7)/8)
	local x3,y3=flr((p.x)/8),flr((p.y+8)/8)
	local x4,y4=flr((p.x+7)/8),flr((p.y+8)/8)
	local x5,y5=flr((p.x+8)/8),flr((p.y+7)/8)
	local x6,y6=flr((p.x+8)/8),flr((p.y)/8)
	local x7,y7=flr((p.x+7)/8),flr((p.y-1)/8)
	local x8,y8=flr((p.x)/8),flr((p.y-1)/8)
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
		return 0,"no"
	end
end
function wallside(coll_dire)--是否站在墙的边缘
	local l_px1,l_py1=flr((wy.x-1)/8),flr((wy.y+3)/8)
	local l_px2,l_py2=flr((wy.x-1)/8),flr((wy.y+4)/8)
	local d_px1,d_py1=flr((wy.x+4)/8),flr((wy.y+8)/8)
	local d_px2,d_py2=flr((wy.x+3)/8),flr((wy.y+8)/8)
	local r_px1,r_py1=flr((wy.x+8)/8),flr((wy.y+3)/8)
	local r_px2,r_py2=flr((wy.x+8)/8),flr((wy.y+4)/8)
	local u_px1,u_py1=flr((wy.x+4)/8),flr((wy.y-1)/8)
	local u_px2,u_py2=flr((wy.x+3)/8),flr((wy.y-1)/8)
	if coll_dire==1 then --左
		if (not fget(mget(l_px1,l_py1),0)) and (not fget(mget(l_px2,l_py2),0)) then
			--debug="edge"
			return true
		else
			--debug="wall"
			return false
		end
	elseif coll_dire==3 then --上
		if (not fget(mget(u_px1,u_py1),0)) and (not fget(mget(u_px2,u_py2),0)) then
			--debug="edge"
			return true
		else
			--debug="wall"
			return false
		end
	elseif coll_dire==5 then --右
		if (not fget(mget(r_px1,r_py1),0)) and (not fget(mget(r_px2,r_py2),0)) then
			--debug="edge"
			return true
		else
			--debug="wall"
			return false
		end
	elseif coll_dire==7 then --下
		if (not fget(mget(d_px1,d_py1),0)) and (not fget(mget(d_px2,d_py2),0)) then
			--debug="edge"
			return true
		else
			--debug="wall"
			return false
		end
	end


end
function wallcoll_move(player) --玩家与墙壁的碰撞移动
	local coll_dire,oneside=check_wall_iswalk(player) --获取墙在玩家的位置，在边缘的哪一侧
	if coll_dire==1 then
			if player.dire==1 then
				if wallside(coll_dire) then --如果在边缘
					--如果在上
					if oneside=="up" then
						player.spd.spx=0
						player.spd.spy=-player.speed
					elseif oneside=="down" then
						player.spd.spx=0
						player.spd.spy=player.speed
					end
					--如果在下
				else --不在边缘
					player.spd.spx=0
					player.spd.spy=0
				end
			elseif player.dire==2 or player.dire==8 then
				player.spd.spx=0
				player.spd.spy=diry[player.dire]*player.speed
			else
				move(player)
			end
		move_anim(player)
	elseif coll_dire==3 then
		if player.dire==3 then
			if wallside(coll_dire) then
				if oneside=="left" then
					player.spd.spx=-player.speed
					player.spd.spy=0
				elseif oneside=="right" then
					player.spd.spx=player.speed
					player.spd.spy=0
				end
			else
				player.spd.spx=0
				player.spd.spy=0
			end
		elseif player.dire==2 or player.dire==4 then
			player.spd.spx=dirx[player.dire]*player.speed
			player.spd.spy=0
		else
			move(player)
		end
		move_anim(player)
	elseif coll_dire==5 then
		if player.dire==5 then
			if wallside(coll_dire) then
				if oneside=="up" then
					player.spd.spx=0
					player.spd.spy=-player.speed
				elseif oneside=="down" then
					player.spd.spx=0
					player.spd.spy=player.speed
				end
			else
				player.spd.spx=0
				player.spd.spy=0
			end
		elseif player.dire==4 or player.dire==6 then
			player.spd.spx=0
			player.spd.spy=diry[player.dire]*player.speed
		else
			move(player)
		end
		move_anim(player)
	elseif coll_dire==7 then
		if player.dire==7 then
			if wallside(coll_dire) then
				if oneside=="left" then
					player.spd.spx=-player.speed
					player.spd.spy=0
				elseif oneside=="right" then
					player.spd.spx=player.speed
					player.spd.spy=0
				end
			else
				player.spd.spx=0
				player.spd.spy=0
			end
		elseif player.dire==6 or player.dire==8 then
			player.spd.spx=dirx[player.dire]*player.speed
			player.spd.spy=0
		else
			move(player)
		end
		move_anim(player)
	-------------------------------斜4角度----------------------------
	elseif coll_dire==2 then
		if player.dire==1 or player.dire==2 or player.dire==3 then
			player.spd.spx=0
			player.spd.spy=0
		elseif player.dire==4 then --在角落其他斜角度移动，也要考虑不能穿墙
			player.spd.spx=dirx[player.dire]*player.speed
			player.spd.spy=0
		elseif player.dire==8 then
			player.spd.spx=0
			player.spd.spy=diry[player.dire]*player.speed
		else
			move(player)
		end
		move_anim(player)
	elseif coll_dire==4 then
		if player.dire==3 or player.dire==4 or player.dire==5 then
			player.spd.spx=0
			player.spd.spy=0
		elseif player.dire==2 then
			player.spd.spx=dirx[player.dire]*player.speed
			player.spd.spy=0
		elseif player.dire==6 then
			player.spd.spx=0
			player.spd.spy=diry[player.dire]*player.speed
		else
			move(player)
			move_anim(player)
		end
	elseif coll_dire==6 then
		if player.dire==5 or player.dire==6 or player.dire==7 then
			player.spd.spx=0
			player.spd.spy=0
		elseif player.dire==4 then --在角落其他斜角度移动，也要考虑不能穿墙
			player.spd.spx=0
			player.spd.spy=diry[player.dire]*player.speed
		elseif player.dire==8 then
			player.spd.spx=dirx[player.dire]*player.speed
			player.spd.spy=0
		else
			move(player)
		end
		move_anim(player)
	elseif coll_dire==8 then
		if player.dire==7 or player.dire==8 or player.dire==1 then
			player.spd.spx=0
			player.spd.spy=0
		elseif player.dire==2 then
			player.spd.spx=0
			player.spd.spy=diry[player.dire]*player.speed
		elseif player.dire==6 then
			player.spd.spx=dirx[player.dire]*player.speed
			player.spd.spy=0
		else
			move(player)
		end
		move_anim(player)
	else --0 没有贴墙
		--debug="no edge"
		move(player)
		move_anim(player)
	end
end
--输入系统检测1:像素级别
--输入系统检测2:固定距离