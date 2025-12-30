--心之容器、剑、一次性物品不会刷新
--类型：只有一次或可多次
o_name={"addheart","sword","heal_1"}
o_spr=explodeval("52,30,38")
o_mappos=explodeval("10,3,0")
o_appear=explodeval("0,0,0") --0：不出现，1：出现
--o_used=explodeval("1,1,1") --1未使用，0已使用
function makeobj(mb,_x,_y)--,_sx,_sy,_sw,_sh,_xc,_yc,_wc,_hc)
    local ins={}
    ins.name,ins.spr,ins.mappos,ins.w,ins.h=o_name[mb],o_spr[mb],o_mappos[mb],8,8
    ins.appear=o_appear[mb]
    ins.x=_x
    ins.y=_y
    add(obj,ins)
    return ins
end