--游戏玩法核心

--角色移动
function moveplayer(dx,dy)
    --destx,desty代表目标移动位置，用来检测目标移动位置是否在不可移动的位置上。
    local destx, desty = p_mob.x+dx, p_mob.y+dy 
    
    --获取目的地位置的地图块编号
    local tile = mget(destx,desty)
     --检测角色翻转
    if dx<0 then
        p_mob.flp =true
    elseif dx>0 then
        p_mob.flp =false
    end

    --判断地图块是否能够碰撞(墙或者其他可交互物，不能穿过)，0代表第一个位置上的红灯，返回true则点亮
    if fget(tile,0) then 
        --wall
        --根据输入，获取初始偏移值
        p_mob.sox= dx*8--将两行代码，简化为一行，能省一个代币
        p_mob.soy= dy*8
        --将0值赋给p_ox,p_oy(实际偏移值),这样一开始就不会偏移
        p_mob.ox = 0 
        p_mob.oy = 0 
        --将用来移动的时间重置为0
        p_t=0
        --游戏模式改为pturn状态
        _upd=update_pturn
        --将pturn下的移动状态改为：撞
        p_mob.mov=mov_bump --一种状态机的用法，将方法放入变量内，然后执行变量(),即执行该方法

        --如果碰撞物可交互，则为1为true
        if fget(tile,1) then
            --触发碰撞函数(获取目标方向位置)
            trig_bump(tile,destx,desty)
        end
    else--如果不为墙，则可以移动
        sfx(63)
        --移动相应的位置
        p_mob.x+=dx
        p_mob.y+=dy
    
        --根据输入，获取初始偏移值，然后作为反量抵消移动
        p_mob.sox, p_mob.soy = -dx*8, -dy*8--将两行代码，简化为一行，能省一个代币
        --将初始偏移值赋给p_ox,p_oy(实际偏移值)
        p_mob.ox, p_mob.oy = p_mob.sox, p_mob.soy 
        --将用来移动的时间重置为0
        p_t=0

        --游戏模式改为pturn状态
        _upd=update_pturn
        --将pturn下的移动状态改为：可移动
        p_mob.mov=mov_walk
    end
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