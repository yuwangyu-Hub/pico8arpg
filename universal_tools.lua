--通用工具lib
--镜头抖动
function doshake()
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
--闪烁工具
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

function creat_ck_line(_sb,cx,cy,cw,ch)--显示检测的四边
	local collx=_sb.x+cx
	local colly=_sb.y+cy
	local collw=_sb.w+cw 
	local collh=_sb.h+ch
	----ck:check，coll:collision
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
	local ox1,oy1=obj.x,obj.y
	local ox2=obj.x+obj.w
	local oy2=obj.y+obj.h
	local sx1,sy1=sb.x,sb.y
	local sx2=sb.x+sb.w
 	local sy2=sb.y+sb.h
	if sx1>=ox2-1 and sy2>=oy1 and sy1<=oy2 then--物体在左边
		return 1--,8,2
	elseif sx2<=ox1+1 and sy2>=oy1 and sy1<=oy2 then--物体在右边
		return 5--,4,6	
	elseif sy2<=oy1+1 and sx2>=ox1 and sx1<=ox2 then--物体在下边
		return 7--,8,6
	elseif sy1>=oy2-1 and sx2>=ox1 and sx1<=ox2 then--物体在上边
		return 3--,2,4
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