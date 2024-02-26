--游戏进行状态
function update_game()

    if talkwind then--如果对话窗口为真，即存在
        if getbutt()==5 then--如果获得按钮方法为5，即按下了5按钮
            talkwind.dur=0--对话窗口消失时间为0，即立即消失
            talkwind=nil
        end
    else   
         --如果缓冲区无值的时候，进行检测
        dobuffbutt()
    
        dobutt(buttbuff)
        buttbuff=-1
    end

    --[[
        if btnp(0) then 
            p_x-=1
            p_ox=8 
            _upd=update_pturn
        end
        if btnp(1) then 
            p_x+=1 
            p_ox=-8
            _upd=update_pturn
        end
        if btnp(2) then 
            p_y-=1 
            p_oy=8
            _upd=update_pturn
        end
        if btnp(3) then 
            p_y+=1
            p_oy=-8 
            _upd=update_pturn
        end
    ]]--
    --if hp==0 then
        --_upd=update_gameover--将变量作为一个可变函数载体，用来模拟不同状态，实现状态机
    --end
end

--移动中的转向状态，主要用于动画的显示中的移动效果，设计了一个延时移动
function update_pturn()
    --在移动转向过程中，获取输出缓冲区的值。
    dobuffbutt()

    --可控制移动速度
    p_t = min(p_t+0.125,1) --使用去最小值的方法，让p_t始终在1的范围之内

    --角色的行动状态变量，用于储存行动函数(移动、撞)
    --p_mov()
    p_mob.mov(p_mob,p_t)

    if  p_t ==1 then
        _upd=update_game
    end


    --[[
        if p_ox>0 then
            p_ox-=1
        end
    
        if p_ox<0 then
            p_ox+=1
        end

        if p_oy>0 then
            p_oy-=1
        end

        if p_oy<0 then
            p_oy+=1
        end

        if p_ox==0and p_oy==0 then
            _upd=update_game
        end
    ]]--
end

--游戏结束状态
function update_gameover()

end

--从一个位置移动到另一个位置的效果
function mov_walk(mob,ani_t)
    mob.ox=mob.sox*(1-ani_t) --通过不断获取自身变小值而实现p_ox的值减小。因为p_t是0-1之间不断增大
    mob.oy=mob.soy*(1-ani_t) --而 1-p_t 就是不断变小再乘以自身的变小值赋给自身，达到值变小的目的
end

--从一个地方移动但撞到然后返回，可以用来撞墙，或撞向其他物体
function mov_bump(mob,ani_t)
   
    local tme=ani_t
    --[[
        if p_t<0.5 then
            p_ox=p_sox*(p_t)
            p_oy=p_soy*(p_t)
        else
            p_ox=p_sox*(1-p_t) 
            p_oy=p_soy*(1-p_t)
        end
    ]]--
    if ani_t>0.5 then
        tme=1-ani_t
    end
    mob.ox=mob.sox*tme
    mob.oy=mob.soy*tme

end

--获取缓冲区按钮
function getbutt()
    for i=0,5 do
        if btnp(i) then
            return i
        end
    end
    return -1
end

--缓冲区检测按钮的获取
function dobuffbutt()
    if buttbuff==-1 then--如果值为-1代表缓冲区暂时无值
        buttbuff=getbutt()--将获取的按钮放入缓冲区
    end
end

--执行按钮行为
function dobutt(butt)
     --通过循环判断，进行输入检测
    if butt<0 then return end

    if butt<4 then
        moveplayer(dirx[butt+1],diry[butt+1])--移动
    end
end

