--mobs小怪/生物角色系统

function addmob(typ,mx,my)
    local m={
        x=mx,
        y=my,
        ox=0,--运动过程中的偏移量(会随着变化)，让角色在移动中的动画显示上有一个偏移量移动的效果
        oy=0,--运动过程中的偏移量(会随着变化)，让角色在移动中的动画显示上有一个偏移量移动的效果
        sox=0,--一开始时候的偏移量
        soy=0,--一开始时候的偏移量
        ani={},
        flp=false, --精灵翻转值
        mov=nil--移动的动画模式，通过变量指向相应的动画行为函数。（行走、撞墙）
    }

    for i=0,3 do
        add(m.ani,mob_ani[typ]+i)
    end

    add(mob,m)
    return m
end