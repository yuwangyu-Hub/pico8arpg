--心之容器、剑、一次性物品不会刷新
o_name,o_spr,o_type,o_mappos,o_x,o_y={"addheart","sword","coin"},explodeval("52,30,55"),{"get","get","get"},explodeval("11,3,12"),explodeval("58,96,58"),explodeval("58,32,58")
function makeobj(mb)--,_sx,_sy,_sw,_sh,_xc,_yc,_wc,_hc)
    local ins={}--obj instance
    --[[
    ins.sprx=_sx
    ins.spry=_sy
    ins.sprw=_sw
    ins.sprh=_sh
    ins.x=_sx+_xc
    ins.y=_sy+_yc
    ins.w=_sw+_wc
    ins.h=_sh+_hc  --碰撞器尺寸：与spr的差值]]
    ins.name,ins.spr,ins.type,ins.mappos,ins.x,ins.y,ins.w,ins.h=o_name[mb],o_spr[mb],o_type[mb],o_mappos[mb],o_x[mb],o_y[mb],8,8
    --ins.collitem=false --是否碰撞到其他物体，如果碰撞了后面就不可推动
    add(obj,ins)
    return ins
end