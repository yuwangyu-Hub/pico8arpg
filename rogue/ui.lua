--ui

--添加窗口，将需要添加的窗口整合为一个数组，放入wind表内。
function addwind(_x,_y,_w,_h,_txt)
    local w={x=_x,
            y=_y,
            w=_w,
            h=_h,
            txt=_txt}--w代表该窗口
    add(wind,w)
    return w
end

--绘制窗口
function drawind()
    for w in all(wind) do
        

        local wx,wy,ww,wh=w.x,w.y,w.w,w.h--每一个（.）都是一个令牌，所以用这种方式，尽可能减少令牌的损失
        rectfill2(wx,wy,ww,wh,0)
        rect(wx+1,wy+1,wx+ww-2,wy+wh-2,6)
        wx+=4
        wy+=4
        clip(wx,wy,ww-8,wh-8)--进行裁剪
        --循环txt
        for i=1,#w.txt do
            local txt=w.txt[i]
            print(txt,wx,wy,6)
            wy+=6
        end
        clip()--关闭裁剪
      



        --显示一定时长后消失
        if w.dur!=nil then
            w.dur-=1
            if w.dur<=0 then --w消失时间小于等于0，即消失

                --制作一个消失的小动画效果
                local dif=wh/4 --设置一个宽度，然后不断收缩，
                w.h-=dif--本身窗口的宽度减去收缩的值
                w.y+=dif/2--窗口y的位置加上宽度收缩值的一半


                if wh<3 then--当高度小于3的时候
                    del(wind,w)--从窗口数组中删除该窗口。
                end
           
            end
        else--不消失就显示，即消失就不执行，也代表着x号自动消失了
            if w.butt then
                --print("❎",wx+ww-11,wy-3,6)
                oprint8("❎",wx+ww-15,wy-1+sin(time()),6,0)
            end
        end
    end
   
end

--显示信息
function showmsg(txt,dur) --dur:消失的时间
    local wid=(#txt+2)*4+7 --字符长度乘以每个字的像素，再乘左右变量的像素宽
    local w=addwind(63-wid/2,50,wid,13,{" "..txt})--中间位置减去窗口宽度的一半就是x位置
    w.dur=dur
end

function showmsg(txt) --dur:消失的时间
    talkwind=addwind(16,50,94,#txt*6+7,txt)--中间位置减去窗口宽度的一半就是x位置
    talkwind.butt=true --创建一个关闭窗口用的按钮
end