--心之容器、剑、一次性物品不会刷新
o_name={"addheart","sword","coin"}
o_spr={52,30,55}
o_type={"get","get","get"}
o_mappos={11,3,12} --所在地图编号
o_x={58,96,58}
o_y={58,32,58}

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
    ins.h=_sh+_hc  --碰撞器尺寸：与spr的差值
]]
    ins.name=o_name[mb]
    ins.spr=o_spr[mb]
    ins.type=o_type[mb]
    ins.mappos=o_mappos[mb]
    ins.x=o_x[mb]
    ins.y=o_y[mb]
    ins.w=8
    ins.h=8
    ins.isget=false --
    --ins.collitem=false --是否碰撞到其他物体，如果碰撞了后面就不可推动
    add(obj,ins)
    return ins
end