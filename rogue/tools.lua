--动画帧方法
function getframe(ani)--接受数组参数
    return ani[flr(t/15)% #ani +1] --#获取组或者列表长度
end

--角色绘制，游戏中所有得角色都在绘制时候采用灰色，统一使用该方法修改颜色，并设置为不透明
function drawspr(_spr,_x,_y,_c,_flip)
    palt(0,false) --将黑色作为不透明，这样精灵上的黑色就不会被底色透上来
    --通过改变颜色让其变色
    pal(6,_c) 

    --先将时间进行除法（需要去掉小数位），能够减慢值得增长，再取余
    spr(_spr,_x,_y,1,1,_flip) 
    
    --通过重置颜色让其他的还原，这两种方式可以单独修改某一物体颜色
    pal() 
end

--一种变体的绘制填充矩形的方式，输入左上角坐标加上长宽
function rectfill2(_x,_y,_w,_h,_c)
    rectfill(_x,_y,_x+max(_w-1,0),_y+max(_h-1,0),_c)
end

--覆盖打印显示，在打印的文字会显示边框
function oprint8(_t,_x,_y,_c,_c2)
    for i=1,8 do
        print(_t,_x+dirx[i],_y+diry[i],_c2)
    end
    print(_t,_x,_y,_c)
end

--勾股定理获取对角边长度
function dist(fx,fy,tx,ty)
    local dx,dy=fx-tx,fy-ty
    return sqrt(dx*dx+dy*dy)--sqrt开根号
end

--淡入效果
function dofade()
    local p,kmax,col,k=flr(mid(0,fadeperc,1)*100)
    for j=1,15 do
        col=j
        kamx=flr((p+(j*1.46))/22)
        for k=1,kamx do
            col=dpal[col]
        end
        pal(j,col,1)
    end
end

--用于检测淡出，当淡出的百分比大于0，执行淡出效果
function checkfade()
    if fadeperc>0 then
        fadeperc=max(fadeperc-0.04,0)
        dofade()
    end
end

--一种暂停游戏的方式，_wait输入暂停等待的时间，所有更新被中断
function wait(_wait)
    repeat
        _wait-=1
        flip()
    until _wait<0
end

--淡出效果
--spd淡出的速度
function fadeout(spd,_wait)
    if (spd==nil) spd=0.04
    if (_wait==nil) _wait=0
    repeat
        fadeperc=min(fadeperc+spd,1)
        dofade()
        flip()
    until fadeperc==1
    wait(_wait)
end