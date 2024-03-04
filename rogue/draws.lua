--游戏进行状态
function draw_game()
    cls()
    map()
    --drawspr(getframe(p_ani),p_x*8+p_ox,p_y*8+p_oy,10,p_flip)

    --绘制当前在角色组中的所有角色
    for m in all(dmob) do
        if sin(time()*8)>0 then--造成闪烁效果，
            drawmob(m)
        end
        m.dur-=1--持续时间-1
        if m.dur<=0 then--如果持续时长为0
            del(dmob,m)
        end
    end

    for m in all(mob) do
        if m!=p_mob then
            drawmob(m)
        end
    end
    --player绘制在其他角色之上
    drawmob(p_mob)
    --绘制悬浮UI
    for f in all(float) do
        oprint8(f.txt,f.x,f.y,f.c,0)
    end
    
end

--角色绘制
function drawmob(m)
    local col=10 --颜色
    if m.flash>0 then
        m.flash-=1
        col=7
    end
    --需要注意，这里显示了移动过程中的8像素移动偏移值
    drawspr(getframe(m.ani), m.x*8+m.ox, m.y*8+m.oy, col, m.flp)
end

--游戏结束状态
function draw_gover()
    cls(2)
    print("you ded",50,50,7)
end