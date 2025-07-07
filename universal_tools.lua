--通用工具lib
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
--画面检测：128X128
--对象、左、右、上、下
function checkwall(sb,lx,rx,uy,dy)
	if sb.x<lx then sb.x=lx end
	if sb.x>rx then sb.x=rx end 
	if sb.y<uy then sb.y=uy end
	if sb.y>dy then sb.y=dy end
	return sb
end
--[[
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
	if coll_boxcheck(p.x,p.y,p.w,p.h,_o.x,_o.y,_o.w,_o.h)then
		return true
	else
		return false
	end
end
--检测被检测对象在检测对象的哪个方向
function checkdir(obj,sb)
	local ox1,oy1=obj.x,obj.y
	local ox2=obj.x+obj.w
	local oy2=obj.y+obj.h
	local sx1,sy1=sb.x,sb.y
	local sx2=sb.x+sb.w
 	local sy2=sb.y+sb.h
	if sx1>=ox2 and sy2>oy1 and sy1<oy2 then--物体在左边
		return 1
	elseif sx1>=ox2 and sy1>=oy2 then--物体在左上
		return 2
	elseif sy1>=oy2 and sx2>ox1 and sx1<ox2 then--物体在上边
		return 3
	elseif sx2<=ox1 and sy1>=oy2 then--物体在右上
		return 4
	elseif sx2<=ox1 and sy2>oy1 and sy1<oy2 then--物体在右边
		return 5
	elseif sx2<=ox1 and sy2<=oy1 then--物体在右下
		return 6
	elseif sy2<=oy1 and sx2>ox1 and sx1<ox2 then--物体在下边
		return 7
	elseif sx1>=ox2 and sy2<=oy1 then--物体在左下
		return 8
	else
		return 0
	end
end
--碰撞盒检测
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
function cdis(_Group,_sb)--check_distance检测集合内的最近距离
	local mdis =128--最大距离
	local mdis_o
	for o in all(_Group) do
		if sqrt(abs(o.x-_sb.x)+abs(o.y-_sb.y)) < mdis then
			mdis=sqrt(abs(o.x-_sb.x)+abs(o.y-_sb.y))
			mdis_o =  o
		end
	end
	return mdis_o
end
--当靠近物体碰撞时，不同的条件触发不同的效果
function move_and_push(_obj,_sb,_colldire) --_colldire:物体在主角的方向
	local d_date={
		{1,2,8,3,7,0,1}, --与碰撞相同的方向、四个其他方向、x、y
		{3,2,4,1,5,1,0},
		{5,4,6,3,7,0,1},
		{7,8,6,1,3,1,0}}
	if _colldire==1 or _colldire==3 or _colldire==5 or _colldire==7 then--与物体碰撞的物体方向
		
		local direnum=(_colldire+1)/2
		if _sb.dire==d_date[direnum][1] then --当前移动方向
			if checkcoll_edge(_obj,_sb,_colldire) then 
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
			else
				if _obj.type=="fixed" then
					_sb.spd.spx=dirx[_sb.dire]*_sb.speed*d_date[direnum][6]
					_sb.spd.spy=diry[_sb.dire]*_sb.speed*d_date[direnum][7]
				elseif _obj.type=="move" then
					pushsth(_obj,_sb,_colldire)
				end
				pull_anim(_sb,_colldire)
			end
		elseif _sb.dire==d_date[direnum][2] or _sb.dire==d_date[direnum][3] then
			_sb.spd.spx=dirx[_sb.dire]*_sb.speed*d_date[direnum][6]
			_sb.spd.spy=diry[_sb.dire]*_sb.speed*d_date[direnum][7]
			pull_anim(_sb,_colldire)
		else
			_sb.state=_sb.allstate.move
		end
	else --2468
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
function checkcoll_edge(_obj,_sb,_colldire)--检测是否在碰撞斜边缘，小于等于3的像素位置
	local sbcenter_x,sbcenter_y=_sb.x+_sb.w/2,_sb.y+_sb.h/2
	local objcenter_x,objcenter_y=_obj.x+_obj.w/2,_obj.y+_obj.h/2
	if _colldire==1 or _colldire==5 then
		if abs(_obj.y-(_sb.y+_sb.h))<=3 or abs((_obj.y+_obj.h)-_sb.y)<=3 then
			return true
		end
	elseif _colldire==3 or _colldire==7 then
		if abs(_obj.x-(_sb.x+_sb.w))<=3 or abs((_obj.x+_obj.w)-_sb.x)<=3 then
			return true
		end
	else
		return false
	end
end

function pushsth(_obj,_sb) --推物体
	local pushspd=1
	if _sb.dire%2==1 then
		local xsum=pushspd*dirx[_sb.dire]
		local ysum=pushspd*diry[_sb.dire]
		_sb.spd.spx=xsum 
		_sb.spd.spy=ysum
		_obj.x=_obj.x+xsum
		_obj.y=_obj.y+ysum
		_obj.sprx=_obj.sprx+xsum
		_obj.spry=_obj.spry+ysum
	end
end
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
function check_p_hurt(_sb)--检测玩家受伤
	local _ishurt
	for e in all(enemies) do
		_sb.hurtdire=checkdir(e,_sb)
		_ishurt = coll_boxcheck(_sb.x,_sb.y,_sb.w,_sb.h,e.x,e.y,e.w,e.h)
	end
	return _ishurt
end
function check_en_hurt()
	--if 
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
--输入系统检测1:像素级别
--输入系统检测2:固定距离