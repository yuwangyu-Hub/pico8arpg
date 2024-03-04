--mobs小怪/生物角色系统

--添加角色
--将新建的角色添加进角色集，并且能够返回该角色
function addmob(typ,mx,my)
    local m={
        x=mx,
        y=my,
        ox=0,--运动过程中的偏移量(会随着变化)，让角色在移动中的动画显示上有一个偏移量移动的效果
        oy=0,--运动过程中的偏移量(会随着变化)，让角色在移动中的动画显示上有一个偏移量移动的效果
        sox=0,--一开始时候的偏移量
        soy=0,--一开始时候的偏移量
        flp=false, --精灵翻转值
        mov=nil,--移动的动画模式，通过变量指向相应的动画行为函数。（行走、撞墙）
        ani={},--动画帧集合
        flash=0,--闪烁
        hp=mob_hp[typ],--当前血量
        hpmax=mob_hp[typ],--最大血量
        atk=mob_atk[typ]
    }

    for i=0,3 do
        add(m.ani,mob_ani[typ]+i)
    end

    add(mob,m)
    return m
end

--角色移动,适用于所有角色
function mobwalk(mb,dx,dy)
    --移动相应的位置
    mb.x+=dx--真正的位移在draw中的角色显示上，乘以8个像素位
    mb.y+=dy
    --根据输入，获取初始偏移值，然后作为反量抵消移动
    mb.sox, mb.soy = -dx*8, -dy*8--将两行代码，简化为一行，省代币
    --将初始偏移值赋给p_ox,p_oy(实际偏移值)
    mb.ox, mb.oy = mb.sox, mb.soy 

    --将pturn下的移动状态改为：移动
    mb.mov=mov_walk
end

--角色撞墙
function mobbump(mb,dx,dy)
    --根据输入，获取初始偏移值
    mb.sox,mb.soy= dx*8,dy*8--将两行代码，简化为一行，能省一个代币
    --将0值赋给p_ox,p_oy(实际偏移值),这样一开始就不会偏移
    mb.ox = 0 
    mb.oy = 0 

    --将pturn下的移动状态改为：撞
    mb.mov=mov_bump --一种状态机的用法，将方法放入变量内，然后执行变量(),即执行该方法
end


--从一个位置移动到另一个位置的效果
--该移动在pturn下实现效果
function mov_walk(mb,ani_t)--p_t
    mb.ox=mb.sox*(1-ani_t) --通过不断获取自身变小值而实现p_ox的值减小。因为p_t是0-1之间不断增大
    mb.oy=mb.soy*(1-ani_t) --而 1-p_t 就是不断变小再乘以自身的变小值赋给自身，达到值变小的目的
end

--从一个地方移动但撞到然后返回，可以用来撞墙，或撞向其他物体
--该移动在pturn下实现效果
function mov_bump(mb,ani_t)--p_t
   
    local tme=ani_t
    --[[
        if p_t<0.5 then
            p_ox=p_sox*(p_t)
            p_oy=p_soy*(p_t)
        else
            p_ox=p_sox*(1-p_t) 
            p_oy=p_soy*(1-p_t)
        end
    ]]--

    if ani_t>0.5 then
        tme=1-ani_t
    end
    mb.ox=mb.sox*tme
    mb.oy=mb.soy*tme
end 

--角色反转
function mobflip(mb,dx)
   --检测角色翻转
    if dx<0 then
        mb.flp =true
    elseif dx>0 then
        mb.flp =false
    end
end

function doai()
    for m in all(mob) do
        if m !=p_mob then--非player的所有角色
            m.mov=nil--因为mov行为在AI上一次的移动中被赋值，所以当即时是攻击玩家时候，仍然为该动画效果
            if dist(m.x,m.y,p_mob.x,p_mob.y) ==1 then --判断敌人与player是否为邻近
                --攻击玩家

                --通过用player坐标减去当前角色的坐标，获取到撞击的方向。
                dx,dy=p_mob.x-m.x,p_mob.y-m.y
                mobbump(m,dx,dy)
                hitmob(m,p_mob)
                sfx(57)
            
            else
                --移动向玩家
                local bdst,bx,by = 999,0,0 --bdst最佳距离 best distance，999，0，0为初始默认值
                for i=1,4 do
                    local dx,dy=dirx[i],diry[i]
                    local tx,ty=m.x+dx,m.y+dy --tx，ty：目标x和目标y
                    --如果是可行动的
                    if iswalkable(tx,ty,"checkmobs") then
                        local dst=dist(tx, ty, p_mob.x,p_mob.y)--获取当前角色正四方位上每个位置与player的距离
        
                        if dst<bdst then
                            bdst,bx,by=dst,dx,dy--通过这个方法对八个方位上的与player的距离进行对比，选出最近位置。
                        end
                    end
                end
                mobwalk(m,bx,by)
                _upd=update_aiturn
                p_t=0
            end
        end
    end
end
