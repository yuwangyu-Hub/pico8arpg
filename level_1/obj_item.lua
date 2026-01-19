--心之容器、剑、一次性物品不会刷新
o_name={"addheart","sword","heal_1"}
o_spr=explodeval("52,30,38")
--o_mappos=explodeval("10,3,0") 
o_appear=explodeval("0,0,0") --0：不出现，1：出现
function makeobj(mb,_x,_y,_mapos)-- _mapos:出现的地图编号
    local ins={}
    ins.name,ins.spr,ins.w,ins.h=o_name[mb],o_spr[mb],8,8
    ins.mappos=_mapos
    ins.appear=o_appear[mb]
    ins.x=_x
    ins.y=_y
    ins.t=0
    add(obj,ins)
    return ins
end