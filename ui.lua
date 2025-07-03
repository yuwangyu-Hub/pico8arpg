--UI栏
function ui_show()
    --血量
    heat_heart()
    weapon()
end 
function heat_heart()
    --头像
    spr(16,1,1,2,2)
    --血量:默认三滴血
    showheart()
end
function showheart()
    local count=3
end
function weapon()    --武器/道具
    circfill(112,14,8,7)
    spr(128,104,6,2,2)
    print("a",114,16,8)
end