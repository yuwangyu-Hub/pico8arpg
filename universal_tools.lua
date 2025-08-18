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
--移动方向与物体朝向一致：在中间推，在边缘滑
function dire_o_colldire(_obj,_sb,_colldire,iswallcoll)
	local d_date={
	--与碰撞相同的方向、四个其他方向、是或否、是或否
		{1,8,2,3,7,0,1},
		{3,2,4,1,5,1,0},
		{5,4,6,3,7,0,1},
		{7,6,8,1,3,1,0}}
	local direnum=(_colldire+1)/2--朝向针对碰撞信息组的值，符合索引
	--移动方向和物体所在方向一致
	if checkcoll_edge(_obj,_sb,_colldire) then --如果在边缘
		--*需要考虑到墙壁的碰撞
		if  d_date[direnum][6]==1 then --dire：3/7（在物体上下两端朝上或者下移动）
			if abs(_obj.x-(_sb.x+_sb.w))<=3 and _sb.dire==d_date[direnum][1] then
						--左侧上下移动
				if iswallcoll ==1 or iswallcoll==3 or iswallcoll==7 then--如果滑动时候贴墙停止
					_sb.spd.spx=0
				else
					_sb.spd.spx=-_sb.speed
				end
					_sb.spd.spy=0	
			elseif abs((_obj.x+_obj.w)-_sb.x)<=3 and _sb.dire==d_date[direnum][1] then
						--右侧上下移动
				if iswallcoll==5 or iswallcoll==3 or iswallcoll==7 then --墙壁在右侧、在上、在下
					_sb.spd.spx=0
				else
					_sb.spd.spx=_sb.speed
				end
				_sb.spd.spy=0
			end
		elseif d_date[direnum][7]==1 then--dire：1/5（在物体左右两端朝左或者右移动）
			if abs(_obj.y-(_sb.y+_sb.h))<=3 and _sb.dire==d_date[direnum][1] then
						--上侧左右移动
				if iswallcoll==3 or iswallcoll==1 or iswallcoll==5 then
					_sb.spd.spy=0
				else
					_sb.spd.spy= -_sb.speed
				end
				_sb.spd.spx=0
			elseif abs((_obj.y+_obj.h)-_sb.y)<=3 and _sb.dire==d_date[direnum][1] then
						--下侧左右移动
				if iswallcoll ==7 or iswallcoll==1 or iswallcoll==5 then
					_sb.spd.spy=0
				else
					_sb.spd.spy=_sb.speed
				end
				_sb.spd.spx=0
			end
		end
	else--不在边缘（可推）
		if _sb.dire==iswallcoll then--当推动方向和撞墙方向一致：角色在推的时候露出一部分(马脚)撞墙了
			setspd_0(_sb)
		else
			pushsth(_obj,_sb,iswallcoll)
			pull_anim(_sb,_colldire)
		end
	end
end
--当靠近物体碰撞时，不同的条件触发不同的效果
function move_and_push(_obj,_sb,_colldire,iswallcoll) --_colldire:物体在主角的方向
	if _colldire ==1  then ----物体在左边---
		move_anim(_sb)--移动动画
		--iswallcoll!=2\8
		if _sb.dire==1 then --移动方向与物体朝向一致
			dire_o_colldire(_obj,_sb,_colldire,iswallcoll)
		elseif _sb.dire==8 or _sb.dire==7 then --贴物体斜角度:因为有物体遮挡，所以与另一侧正角度移动方式保持一致
			--重置精灵偏移:因为推的动作能直接按住切换到斜向移动，如果不重置，会偏离
			resetspr(_sb)
			if iswallcoll==6 or iswallcoll==7 or iswallcoll==8 then
				setspd_0(_sb)
			else--0\1\2\3\4\5
				_sb.spd.spx=0
				_sb.spd.spy=1
			end
		elseif _sb.dire==2 or _sb.dire==3 then --贴物体斜角度
			--重置精灵偏移:因为推的动作能直接按住切换到斜向移动，如果不重置，会偏离
			resetspr(_sb)
			if iswallcoll==2 or iswallcoll==3 or iswallcoll==4 then
				setspd_0(_sb)
			else --0\1\5\6\7\8
				_sb.spd.spx=0
				_sb.spd.spy=-1
			end
		elseif _sb.dire==5 then
			--重置精灵偏移:因为推的动作能直接按住切换到斜向移动，如果不重置，会偏离
			resetspr(_sb)
			if iswallcoll==4 or iswallcoll==5 or iswallcoll==6 then
				setspd_0(_sb)
			else --0\1\2\3\7\8
				setspd_xydire(_sb)
			end
		elseif _sb.dire==4 then
			--重置精灵偏移:因为推的动作能直接按住切换到斜向移动，如果不重置，会偏离
			resetspr(_sb)
			if iswallcoll==4 then
				setspd_0(_sb)
			elseif iswallcoll==2 or iswallcoll==3 then
				setspd_xdire(_sb)
			elseif iswallcoll==5 or iswallcoll==6 then
				setspd_ydire(_sb)
			else --0\1\7\8
				setspd_xydire(_sb)
			end
		elseif _sb.dire==6 then
			--重置精灵偏移:因为推的动作能直接按住切换到斜向移动，如果不重置，会偏离
			resetspr(_sb)
			if iswallcoll==6 then
				setspd_0(_sb)
			elseif iswallcoll==7 or iswallcoll==8 then
				setspd_xdire(_sb)
			elseif iswallcoll==4 or iswallcoll==5 then
				setspd_ydire(_sb)
			else--0\1\2\3\
				setspd_xydire(_sb)
			end
		end
	elseif  _colldire==3 then -----物体在上边-----------------------------------
		move_anim(_sb)--移动动画
		--iswallcoll!=2\4
		if _sb.dire==3 then --移动方向与物体朝向一致
			dire_o_colldire(_obj,_sb,_colldire,iswallcoll)
		elseif _sb.dire==2 or _sb.dire==1 then --贴物体斜角度
			--重置精灵偏移:因为推的动作能直接按住切换到斜向移动，如果不重置，会偏离
			resetspr(_sb)
			if iswallcoll==1 or iswallcoll==2 or iswallcoll==8 then
				setspd_0(_sb)
			else --0\3\4\5\6\7
				_sb.spd.spx=-1
				_sb.spd.spy=0
			end
		elseif _sb.dire==4 or _sb.dire==5 then --贴物体斜角度
			--重置精灵偏移:因为推的动作能直接按住切换到斜向移动，如果不重置，会偏离
			resetspr(_sb)
			if iswallcoll==4 or iswallcoll==5 or iswallcoll==6 then
				setspd_0(_sb)
			else --0\1\2\3\7\8
				_sb.spd.spx=1
				_sb.spd.spy=0
			end
		elseif _sb.dire==7 then
			--重置精灵偏移:因为推的动作能直接按住切换到斜向移动，如果不重置，会偏离
			resetspr(_sb)
			if iswallcoll==6 or iswallcoll==7 or iswallcoll==8 then
				setspd_0(_sb)
			else --0\1\2\3\4\5
				setspd_xydire(_sb)
			end
		elseif _sb.dire==6 then
			--重置精灵偏移:因为推的动作能直接按住切换到斜向移动，如果不重置，会偏离
			resetspr(_sb)
			if iswallcoll==6 then
				setspd_0(_sb)
			elseif iswallcoll==4 or iswallcoll==5 then
				setspd_ydire(_sb)
			elseif iswallcoll==7 or iswallcoll==8 then
				setspd_xdire(_sb)
			else --0\1\2\3
				setspd_xydire(_sb)
			end
		elseif _sb.dire==8 then
			--重置精灵偏移:因为推的动作能直接按住切换到斜向移动，如果不重置，会偏离
			resetspr(_sb)
			if iswallcoll==8 then
				setspd_0(_sb)
			elseif iswallcoll==1 or iswallcoll==2 then
				setspd_ydire(_sb)
			elseif iswallcoll==6 or iswallcoll==7 then
				setspd_xdire(_sb)
			else --0\3\4\5
				setspd_xydire(_sb)
			end
		end
	elseif  _colldire==5 then ------物体在右边-------------
		move_anim(_sb)--移动动画
		--iswallcoll!=4\6
		if _sb.dire==5 then--移动方向与物体朝向一致
			dire_o_colldire(_obj,_sb,_colldire,iswallcoll)
		elseif _sb.dire==4 or _sb.dire==3 then --贴物体斜角度
			--重置精灵偏移:因为推的动作能直接按住切换到斜向移动，如果不重置，会偏离
			resetspr(_sb)
			if iswallcoll==2 or iswallcoll==3 or iswallcoll==4 then 
				setspd_0(_sb)
			else --0\1\5\6\7\8
				_sb.spd.spx=0
				_sb.spd.spy=-1
			end
		elseif _sb.dire==6 or _sb.dire==7 then --贴物体斜角度
			--重置精灵偏移:因为推的动作能直接按住切换到斜向移动，如果不重置，会偏离
			resetspr(_sb)
			if iswallcoll==6 or iswallcoll==7 or iswallcoll==8 then
				setspd_0(_sb)
			else --0\1\2\3\4\5
				_sb.spd.spx=0
				_sb.spd.spy=1
			end
		elseif _sb.dire==1 then 
			--重置精灵偏移:因为推的动作能直接按住切换到斜向移动，如果不重置，会偏离
			resetspr(_sb)
			if iswallcoll==1 or iswallcoll==2 or iswallcoll==8 then
				setspd_0(_sb)
			else --0\3\4\5\6\7
				setspd_xydire(_sb)
			end
		elseif _sb.dire==2 then
			--重置精灵偏移:因为推的动作能直接按住切换到斜向移动，如果不重置，会偏离
			resetspr(_sb)
			if iswallcoll==2 then 
				setspd_0(_sb)
			elseif iswallcoll==1 or iswallcoll==8 then
				setspd_ydire(_sb)
			elseif iswallcoll==3 or iswallcoll==4 then
				setspd_xdire(_sb)
			else --0\5\6\7
				setspd_xydire(_sb)
			end
		elseif _sb.dire==8 then
			--重置精灵偏移:因为推的动作能直接按住切换到斜向移动，如果不重置，会偏离
			resetspr(_sb)
			if iswallcoll==8 then
				setspd_0(_sb)
			elseif iswallcoll==1 or iswallcoll==2 then
				setspd_ydire(_sb)
			elseif iswallcoll==6 or iswallcoll==7 then
				setspd_xdire(_sb)
			else --0\3\4\5
				setspd_xydire(_sb)
			end
		end
	elseif  _colldire==7 then --------物体在下边---------------------------
		move_anim(_sb)--移动动画
		--iswallcoll!=6\8
		if _sb.dire==7 then--移动方向与物体朝向一致
			dire_o_colldire(_obj,_sb,_colldire,iswallcoll)
		elseif _sb.dire==6 or _sb.dire==5 then --贴物体斜角度
			--重置精灵偏移:因为推的动作能直接按住切换到斜向移动，如果不重置，会偏离
			resetspr(_sb)
			if iswallcoll==4 or iswallcoll==5 or iswallcoll==6 then
				setspd_0(_sb)
			else--0\1\2\3\7\8  
				_sb.spd.spx=1
				_sb.spd.spy=0
			end
		elseif _sb.dire==8 or _sb.dire==1 then --贴物体斜角度
			--重置精灵偏移:因为推的动作能直接按住切换到斜向移动，如果不重置，会偏离
			resetspr(_sb)
			if iswallcoll==1 or iswallcoll==2 or iswallcoll==8 then
				setspd_0(_sb)
			else --0\3\4\5\6\7
				_sb.spd.spx=-1
				_sb.spd.spy=0
			end
		elseif _sb.dire==3 then
			--重置精灵偏移:因为推的动作能直接按住切换到斜向移动，如果不重置，会偏离
			resetspr(_sb)
			if iswallcoll==2 or iswallcoll==3 or iswallcoll==4 then
				setspd_0(_sb)
			else --0\1\5\6\7\8
				setspd_xydire(_sb)
			end
		elseif _sb.dire==2 then
			--重置精灵偏移:因为推的动作能直接按住切换到斜向移动，如果不重置，会偏离
			resetspr(_sb)
			if iswallcoll==2 then 
				setspd_0(_sb)
			elseif iswallcoll==1 or iswallcoll==8  then
				setspd_ydire(_sb)
			elseif iswallcoll==3 or iswallcoll==4 then
				setspd_xdire(_sb)
			else --0\5\6\7
				setspd_xydire(_sb)
			end
		elseif _sb.dire==4 then
			--重置精灵偏移:因为推的动作能直接按住切换到斜向移动，如果不重置，会偏离
			resetspr(_sb)
			if iswallcoll==4 then
				setspd_0(_sb)
			elseif iswallcoll==2 or iswallcoll==3 then 
				setspd_xdire(_sb)
			elseif iswallcoll==5 or iswallcoll==6 then
				setspd_ydire(_sb)
			else --0\1\7\8
				setspd_xydire(_sb)
			end
		end
	else --2468
		if _sb.dire!=0 then --必须要有
			check_Diagonal(_colldire,_sb,iswallcoll)
			move_anim(_sb)
		end
	end
end

function check_Diagonal(_colldire,_sb,iswallcoll)--检测对角线
	if _sb.dire==2 or _sb.dire==4 or _sb.dire==6 or _sb.dire==8 then---------------2
		diagonal2468_move(_sb,_colldire,iswallcoll)
	else--1357
		diagonal1357_move(_sb,iswallcoll)
	end
end
function diagonal1357_move(_sb,iswallcoll)
	local data={
		{1,2,8},--0\3\4\5\6\7
		{2,3,4},--0\1\5\6\7\8
		{4,5,6},--0\1\2\3\7\8
		{6,7,8}}--0\1\2\3\4\5
	local index=(_sb.dire+1)/2
	if iswallcoll==data[index][1] or iswallcoll==data[index][2] or iswallcoll==data[index][3] then
		setspd_0(_sb)
	else 
		setspd_xydire(_sb)
	end
end
function diagonal2468_move(_sb,_colldire,iswallcoll) --对角线斜方向移动的具体实现（针对不同的墙壁方向）

	local xy_data={
		{2,3,4,1,8,0,5,6,7},--2\34\18\0567\：墙在不同的位置
		{4,2,3,5,6,0,1,7,8},--4\23\56\0178\
		{6,7,8,4,5,0,1,2,3},--6\78\45\0123\
		{8,6,7,1,2,0,3,4,5}}--8\67\12\0345\
	local cum=_sb.dire/2--将方向值（2468）转换为表的索引值
	if iswallcoll==xy_data[cum][1] then --2
		setspd_0(_sb)
	elseif iswallcoll==xy_data[cum][2] or iswallcoll==xy_data[cum][3] then --3\4
		setspd_xdire(_sb)
	elseif iswallcoll==xy_data[cum][4] or iswallcoll==xy_data[cum][5] then --1\8
		setspd_ydire(_sb)
	else --0\5\6\7
		if  _sb.dire==_colldire then
			setspd_0(_sb)
		else
			setspd_xydire(_sb)
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
	--贴墙壁后，停止移动
	local iscollwall,_ = check_wall_iswalk(_obj) --物体靠墙值（1-8，0不靠墙）
	--需要说明：当主角靠近物体，刚要推这时候物体就会移动一个像素，所以在显示上会看上去有一个空隙
	if _sb.dire==1 and iscollwall!=1 and iscollwall!=2 and iscollwall!=8 then
		--正方向移动，且物体不靠墙，才可以推动
		_obj.x=_obj.x-1
		_obj.sprx=_obj.sprx-1		
	elseif _sb.dire==3 and iscollwall!=3 and iscollwall!=2 and iscollwall!=4 then
		_obj.y=_obj.y-1
		_obj.spry=_obj.spry-1		
	elseif _sb.dire==5 and iscollwall!=5 and iscollwall!=4 and iscollwall!=6 then
		_obj.x=_obj.x+1
		_obj.sprx=_obj.sprx+1		
	elseif _sb.dire==7 and iscollwall!=7 and iscollwall!=6 and iscollwall!=8 then
		_obj.y=_obj.y+1
		_obj.spry=_obj.spry+1		
	else--靠墙停止推动，主角停止移动
		setspd_0(_sb)
	end
	--进行精灵偏移，消除一个像素的空隙
	if _sb.dire==1 then
		_sb.spr_cx=-1
	elseif _sb.dire==3 then
		_sb.spr_cy=-1
	elseif _sb.dire==5 then
		_sb.spr_cx=1
	elseif _sb.dire==7 then
		_sb.spr_cy=1
	end
end
function resetspr(_sb)--重置精灵偏移
	_sb.spr_cx=0
	_sb.spr_cy=0
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
function setspd_xydire(sb)
	sb.spd.spx=dirx[sb.dire]*sb.speed
	sb.spd.spy=diry[sb.dire]*sb.speed
end
function setspd_xdire(sb)
	sb.spd.spx=dirx[sb.dire]*sb.speed
	sb.spd.spy=0
end
function setspd_ydire(sb)
	sb.spd.spx=0
	sb.spd.spy=diry[sb.dire]*sb.speed
end
function move(_sb)
	_sb.spd.spx,_sb.spd.spy=0,0
	if _sb.dire!=0 then
		setspd_xydire(_sb)
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
			return true--edge
		else
			return false--wall
		end
	elseif coll_dire==3 then --上
		if (not fget(mget(u_px1,u_py1),0)) and (not fget(mget(u_px2,u_py2),0)) then
			return true--edge
		else
			return false--wall
		end
	elseif coll_dire==5 then --右
		if (not fget(mget(r_px1,r_py1),0)) and (not fget(mget(r_px2,r_py2),0)) then
			return true--edge
		else
			return false--wall
		end
	elseif coll_dire==7 then --下
		if (not fget(mget(d_px1,d_py1),0)) and (not fget(mget(d_px2,d_py2),0)) then
			return true--edge
		else
			return false--wall
		end
	end
end
function wallcoll_move(player,coll_dire,oneside) --玩家与墙壁的碰撞移动
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
		else--
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
		end
		move_anim(player)
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
	end
end
function encoll_move(player,colldire)--当玩家与角色（敌人或npc）碰撞
	
	if colldire==1 then --左
		if player.dire==1  then
			player.spd.spx=0
			player.spd.spy=0
		elseif player.dire==2  then
			player.spd.spx=0
			player.spd.spy=-1
		elseif  player.dire==8 then
			player.spd.spx=0
			player.spd.spy=1
		else--可离开
			move(player)
		end
	elseif colldire==3  then --上
		if player.dire==3 then
			player.spd.spx=0
			player.spd.spy=0
		elseif player.dire==2 then 
			player.spd.spx=-1
			player.spd.spy=0
		elseif player.dire==4 then 
			player.spd.spx=0
			player.spd.spy=1
		else
			move(player)
		end
	elseif colldire==5 then --右
		if player.dire==5 then
			player.spd.spx=0
			player.spd.spy=0
		elseif player.dire==4 then
			player.spd.spx=0
			player.spd.spy=-1
		elseif player.dire==6 then
			player.spd.spx=0
			player.spd.spy=1
		else
			move(player)
		end
	elseif colldire==7 then --下
		if player.dire==7 then
			player.spd.spx=0
			player.spd.spy=0
		elseif player.dire==6 then
			player.spd.spx=1
			player.spd.spy=0
		elseif player.dire==8 then
			player.spd.spx=-1
			player.spd.spy=0
		else
			move(player)
		end
	else --敌人在2468对角线
		player.spd.spx=0
		player.spd.spy=0
		move(player)
	end
end
