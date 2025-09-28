--盒子,金币,
-- 1,  2
o_name={"box","coin"}
o_spr= {81,82}
o_type={"move","get"}
function makeobj(mb,_sx,_sy,_sw,_sh,_xc,_yc,_wc,_hc)
    local ins={}--obj instance
    ins.sprx=_sx --绘制x点
    ins.spry=_sy --绘制y点
    ins.sprw=_sw --绘制宽度
    ins.sprh=_sh --绘制高度
    ins.x=_sx+_xc  --碰撞器尺寸：与spr的差值
    ins.y=_sy+_yc
    ins.w=_sw+_wc
    ins.h=_sh+_hc
    ins.name=o_name[mb]
    ins.spr=o_spr[mb]
    ins.type=o_type[mb]
    ins.collitem=false --是否碰撞到其他物体，如果碰撞了后面就不可推动
    add(obj,ins)
    return ins
end