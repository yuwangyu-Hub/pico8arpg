--UI栏
function ui_show()
    rectfill(0,96,127,127,13)--底
    rect(0,96,127,127,10)--底框
    head()
    health()
    ui_weap()
end 
function head()--头像图标
    --头像（*可拓展，播放表情）
    spr(16,4,108,2,2)
end
function health()--血量
    --local count=3
    spr(36,20,108)
    spr(36,28,108)
    spr(36,20,116)
    spr(36,28,116)
    --for i=0,count do
    --end
end
function ui_weap()--武器/道具
    local x1,y1=92,115
    local x2,y2=114,115
    circfill(x1,y1+1,8,1)
    circfill(x1,y1,8,6)
    circfill(x2,y2+1,8,1)
    circfill(x2,y2,8,6)
    sspr(88,34,6,13,x1-4,y1-6)
    sspr(95,34,9,13,x2-4,y2-6)
    spr(43,x1+2,y1+2)
    spr(44,x2+2,y2+2)
end