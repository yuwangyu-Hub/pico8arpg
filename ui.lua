--UI栏
function ui_show()
    rectfill(0,96,127,127,13)--底
    rect(0,96,127,127,10)--底框
    head()
    health(wy)
    ui_weap()
end 
function head()--头像图标
    spr(16,2,98,2,2)  --头像（*可拓展，播放表情）
end
function health(_sb)--血量
    local count=1
    local snum=function()--血显示代码
        --当前血量
        --总血量
        --最大可容纳血量
        if _sb.curhp>0 and count<=_sb.curhp then
            return 36
        elseif count>_sb.curhp and count<=_sb.hp then
            return 37
        else
            return 20
        end
    end
    for i=1,3 do
        for j=1,3 do
            spr(snum(),20+(j-1)*8,100+(i-1)*8)
            count+=1
        end
    end
end
function ui_weap()--武器/道具
    local x1,y1=92,110
    local x2,y2=114,110
    circfill(x1,y1+1,8,1)
    circfill(x1,y1,8,6)
    circfill(x2,y2+1,8,1)
    circfill(x2,y2,8,6)
    sspr(88,34,6,13,x1-4,y1-6)--o位置显示
    sspr(95,34,9,13,x2-4,y2-6)--x位置显示
    spr(48,x1+2,y1+4)
    spr(49,x2+2,y2+4)
end