--游戏玩法核心

--角色移动
function moveplayer(dx,dy)
    --destx,desty代表目标移动位置，用来检测目标移动位置是否在不可移动的位置上。
    local destx, desty = p_mob.x+dx, p_mob.y+dy 
    
    --获取目的地位置的地图块精灵
    local tile = mget(destx,desty)
    


    --判断地图块是否能够碰撞(墙或者其他可交互物，不能穿过)，0代表第一个位置上的红灯，如果点亮了会返回true
    if iswalkable(destx,desty,"checkmobs") then --无阻挡，可以移动
        sfx(63)
        mobwalk(p_mob,dx,dy)
        --将用来移动的时间重置为0
        p_t=0
    else--不可移动（有碰撞效果）
        mobbump(p_mob,dx,dy)
        --将用来移动的时间重置为0
        p_t=0
        local mob=getmob(destx,desty)--获取该位置上的角色
        if mob==false then --如果没有角色，检测其他碰撞
            --如果碰撞物可交互，则为1为true
            if fget(tile,1) then
                --触发碰撞函数(获取目标方向位置)
                trig_bump(tile,destx,desty) 
            end
        else --如果有
            sfx(58)
            hitmob(p_mob,mob)--攻击
        end
    end
    mobflip(p_mob,dx)

    --游戏模式改为pturn状态
    _upd=update_pturn
end



--触发碰撞的方法，检测该位置的瓷砖上的物体
function trig_bump(tile,destx,desty)
    if tile ==7 or tile ==8 then
        --罐子
        sfx(59)--声效
        --将该位置上的地图快更改为1
        mset(destx,desty,1)
    elseif tile ==10 or tile ==12 then
        --宝箱
        sfx(61)--声效

         --将该位置上的地图快更改为1
         mset(destx,desty,tile-1)
    elseif tile ==13 then
        --门

        sfx(62)--声效
         --将该位置上的地图快更改为1
         mset(destx,desty,1)

    elseif tile == 6 then
        --石碑
        --添加一个窗口
        --addwind(32,64,64,24,{"welcome to the wold","of roguelike"})
        --showmsg("hello wold",80)
        if destx==2 and desty==5 then
            showmsg({"welcome to roguelike","","clime the tower","to obtain the","golden kielbasa"})
        elseif destx==13 and desty==6 then
            showmsg({"this is the 2nd message"})
        elseif destx==13 and desty==11 then
            showmsg({"you're almost there!"})
        end

    end
end


--获取当前某个位置的角色
function getmob(x,y)
    for m in all(mob) do
        --遍历角色组中所有角色，如果输入的位置与某个角色的位置重叠，返回该角色
        if m.x==x and m.y==y then
            return m
        end 
    end
    return false --如果不是返回false
end


--判断是否能够行走
function iswalkable(x,y,mode)
    if mode==nil then mode="" end
    --sight
    if inbounds(x,y) then --如果在界限之内
        local tile = mget(x,y)--只能获取到地图快上的精灵，我们绘制的角色无法在这里获取，所以需要单独进行检测角色碰撞

        --用于检测不可穿越地图快精灵
        if fget(tile,0)==false then --如果返回false则获取的该图块未点亮0编号（点亮为设置的不可穿越物体）
             --用于检测角色精灵
            if mode=="checkmobs" then--如果模式为检查角色
                return getmob(x,y)==false --如果函数结果为真，则等于false，返回false。反之返回true
            end
            return true
        end
    end
    return false --不能行走
end

--判断是否在画面边界内
function inbounds(x,y)
    return not (x<0 or y<0 or x>15 or y>15) --如果括号内都不满足既没错去，为false。 not false为true。表达上在限制内为真 
end

function hitmob(atkm,defm) --攻击者，受击者
    local dmg=atkm.atk   
    defm.hp-=dmg
    defm.flash=10
 
    --悬浮物显示
    addfloat("-"..dmg, defm.x*8, defm.y*8, 9)

    if defm.hp<=0 then--当被攻击者生命值小于0
        add(dmob,defm)--添加到死亡合集
        del(mob,defm)--从mob合集中移除
        defm.dur=15
    end
end 

--检测是否结束
function checkend()
    if p_mob.hp<=0 then
        wind={}--将窗口集合清空
        _upd=update_gover
        _drw=draw_gover
        fadeout(0.02)--淡出120帧，也就是两秒
        return false
    end
    return true
end 


--视线
--转向实现检测，获取到player坐标和该小怪坐标，然后检测两点之间是否遮挡。如果有遮挡则看不到。无遮挡就能看到
--返回true则可看到允许做其他行为，返回false则看不到
function los(x1,y1,x2,y2)--源点和目标点
    --sx,sy,dx,dy局部变量，用于实际的算法
    local fast,sx,sy,dx,dy=true --fast初始赋值为真，其他无初始默认值

    --如果距离为邻近则可以看到
    if dist(x1,y1,x2,y2)==1 then return true end--如果距离为1，则不必进行算法直接返回真
    
    if x1<x2 then
        sx=1
        dx=x2-x1
    else
        sx=-1
        dx=x1-x2
    end
    if y1<y2 then
        sy=1
        dy=y2-y1
    else
        sy=-1
        dy=y1-y2
    end

    local err,e2=dx-dy,nil

    while not(x1==x2 and y1==y2) do
        --sight 一种新的模式（视野）
        if not fast and iswalkable(x1,y1,"sight")==false then return false end
        fast=false
        e2=err+err
        if e2>-dy then
        err=err-dy
        x1=x1+sx
        end
        if e2<dx then
            err=err+dx
            y1=y1+sy
        end
    end
    return true
end