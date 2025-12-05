--盒子,金币,
-- 1,  2
o_name={"box","coin"}
o_spr={54,55}
o_type={"move","get"}
function makeobj(mb,_sx,_sy,_sw,_sh,_xc,_yc,_wc,_hc)
    local ins={}--obj instance
    ins.sprx,ins.spry,ins.sprw,ins.sprh,ins.x,ins.y,ins.w,ins.h=_sx,_sy,_sw,_sh,_sx+_xc,_sy+_yc,_sw+_wc,_sh+_hc  --碰撞器尺寸：与spr的差值
    ins.name,ins.spr,ins.type=o_name[mb],o_spr[mb],o_type[mb]
    ins.collitem=false --是否碰撞到其他物体，如果碰撞了后面就不可推动
    add(obj,ins)
    return ins
end