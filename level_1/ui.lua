--UI栏
function ui_show()
    head()
    health(wy)
    --ui_weap()
end 
function head()--头像图标
    spr(16,0,0,2,2)  --头像（*可拓展，播放表情）
end
function health(_sb)--血量
    local count=1 --血量显示计数器
    local snum=function()--血显示代码
        
        if _sb.curhp>0 and count<=_sb.curhp then
            return 36--当前血量
        elseif count>_sb.curhp and count<=_sb.hp then
            return 37--总血量
        else
            return 20--最大可容纳血量
        end
    end
    for i=1,2 do
        for j=1,3 do
            spr(snum(),15+(j-1)*8,(i-1)*8)
            count+=1
        end
    end
end