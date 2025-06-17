--通用工具lib,镜头抖动
function doshake()
	local shakex,shakey=rnd(shake)-(shake/2),rnd(shake)-(shake/2)
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
function checkwall(sb,lx,rx,uy,dy)
	if sb.x<lx then sb.x=lx end
	if sb.x>rx then sb.x=rx end 
	if sb.y<uy then sb.y=uy end
	if sb.y>dy then sb.y=dy end
	return sb
end
function creat_ck_line(_sb,cx,cy,cw,ch)--显示检测的四边
	local collx,colly,collw,collh=_sb.x+cx,_sb.y+cy,_sb.w+cw ,_sb.h+ch
	cb_line[1]={num=1,x1=collx,   y1=colly+7,x2=collx,  y2=colly,   c=14, ck=false, coll=false}
	cb_line[2]={num=3,x1=collx,   y1=colly,  x2=collx+7,y2=colly,   c=14, ck=false, coll=false}
	cb_line[3]={num=5,x1=collx+7, y1=colly,  x2=collx+7,y2=colly+7, c=14, ck=false, coll=false}
	cb_line[4]={num=7,x1=collx+7, y1=colly+7,x2=collx,  y2=colly+7, c=14, ck=false, coll=false}
	--return collx,colly
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
end
function ck_item(_o,_sb,cx,cy,cw,ch)--检测碰撞,参数代表差值
	creat_ck_line(_sb,cx,cy,cw,ch)--创建检测线
	act_checkline(_sb)--激活检测盒
	local p={
		x=_sb.x+cx,
		y=_sb.y+cy,
		w=_sb.w+cw,
		h=_sb.h+ch
	}
	--creat_ck_line(_sb,0,0,0,0)--创建检测线
	--act_checkline(_sb)--激活检测盒
	if coll_boxcheck(p.x,p.y,p.w,p.h,_o.x,_o.y,_o.w,_o.h)then
		return true
	else
		return false
	end
end
--检测被检测对象在检测对象的哪个方向
function checkdir(obj,sb)
	local ox1,oy1,ox2,oy2=obj.x,obj.y,obj.x+obj.w,obj.y+obj.h
	local sx1,sy1,sx2,sy2=sb.x,sb.y,sb.x+sb.w,sb.y+sb.h

	if sx1>=ox2 and sy2>oy1 and sy1<oy2 then--物体在左边
		return 1
	elseif sx2<=ox1 and sy2<=oy1 then
		return 2--物体在右上边
	elseif sy1>=oy2 and sx2>ox1 and sx1<ox2 then--物体在上边
		return 3
	elseif sx1>=ox2 and sy2<=oy1 then
		return 4--物体在左上边
	elseif sx2<=ox1 and sy2>oy1 and sy1<oy2 then--物体在右边
		return 5	
	elseif sx1>=ox2 and sy1>=oy2 then
		return 6--物体在右下边
	elseif sy2<=oy1 and sx2>ox1 and sx1<ox2 then--物体在下边
		return 7 
	elseif sx2<=ox1 and sy1>=oy2 then
		return 8--物体在左下边 
	else
		return 0
	end
end
--碰撞盒检测
--物体1、物体2、物体1的宽、物体1的高、物体2的宽、物体2的高
function coll_boxcheck(_px,_py,_pw,_ph,_bx,_by,_bw,_bh) 
	local px1,py1,px2,py2=_px,_py,_px+_pw,_py+_ph	
	local bx1,by1,bx2,by2=_bx,_by,_bx+_bw,_by+_bh
	if px2>=bx1 and px1<=bx2 and py2>=by1 and py1<=by2 then
		return true
	else
		return false
	end
end

function move_not_push(_sb,_colldire)
	--移动状态下碰撞到不可移动的物体时的反馈（像素级别）
	if _colldire==1 then
		if _sb.dire==1 or _sb.dire==2 or _sb.dire==8 then
			_sb.spd.spx=0
			_sb.spd.spy=diry[_sb.dire]*_sb.speed
			pull_anim(_sb,_colldire)
		elseif _sb.dire==3 or _sb.dire==7 then
			_sb.spd.spx=0
			_sb.spd.spy=diry[_sb.dire]*_sb.speed
			move_anim(_sb)
		else
			move(_sb)
		end
	elseif _colldire==3 then
		if _sb.dire==3  or _sb.dire==2 or _sb.dire==4 then
			_sb.spd.spx=dirx[_sb.dire]*_sb.speed
			_sb.spd.spy=0
			pull_anim(_sb,_colldire)
		elseif _sb.dire==1 or _sb.dire==5 then
			_sb.spd.spx=dirx[_sb.dire]*_sb.speed
			_sb.spd.spy=0
			move_anim(_sb)
		else
			move(_sb)
		end
	elseif _colldire==5 then
		if _sb.dire==5  or _sb.dire==4 or _sb.dire==6 then
			_sb.spd.spx=0
			_sb.spd.spy=diry[_sb.dire]*_sb.speed
			pull_anim(_sb,_colldire)
		elseif _sb.dire==3 or _sb.dire==7 then
			_sb.spd.spx=0
			_sb.spd.spy=diry[_sb.dire]*_sb.speed
			move_anim(_sb)
		else
			move(_sb)
		end
	elseif _colldire==7 then
		if _sb.dire==7  or _sb.dire==8 or _sb.dire==6 then
			_sb.spd.spx=dirx[_sb.dire]*_sb.speed
			_sb.spd.spy=0
			pull_anim(_sb,_colldire)
		elseif _sb.dire==1 or _sb.dire==5 then
			_sb.spd.spx=dirx[_sb.dire]*_sb.speed
			_sb.spd.spy=0
			move_anim(_sb)
		else
			move(_sb)
		end
	elseif _colldire==2 then
		if _sb.dire==6 then
			_sb.spd.spx=0
			_sb.spd.spy=0
		else
			move(_sb)
		end
	elseif _colldire==4 then
		if _sb.dire==8 then
			_sb.spd.spx=0
			_sb.spd.spy=0
		else
			move(_sb)
		end
	elseif _colldire==6 then
		if _sb.dire==2 then
			_sb.spd.spx=0
			_sb.spd.spy=0
		else
			move(_sb)
		end
	elseif _colldire==8 then
		if _sb.dire==4 then
			_sb.spd.spx=0
			_sb.spd.spy=0
		else
			move(_sb)
		end
	end
end
function spr_flip(_sb)
    if _sb.dire==2 or _sb.dire==1 or _sb.dire==8  then
		_sb.sprflip=true --如果是右上方向，精灵翻转
	elseif _sb.dire==4 or _sb.dire==5 or _sb.dire==6 then
		_sb.sprflip=false --其他方向不翻转
	end
end
function move_anim(_sb)
	_sb.move_t+=.2
	_sb.frame=_sb.sprs.move[ceil(_sb.move_t%#_sb.sprs.move)]
end
function pull_anim(_sb,_colldire)
    _sb.frame=_sb.sprs.push[(_colldire+1)/2]
end
function attack_swordpos(_sb)--处理update中的武器实时位置
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
function move(_sb)
	_sb.spd.spx=0
	_sb.spd.spy=0
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
function hurt()
	--攻击碰撞后，向收到攻击的方向后退
	--1识别受到攻击的方向
	--2向后退
end

--归一化
function nomalize(sb,speed1,speed2)
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