

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

    
end

--player移动中的转换状态(即移动状态)，主要用于动画的显示中的移动效果，设计了一个延时移动(主要有两种情况，一种是移动转向，另一种是移动后撞墙返回)
function update_pturn()
    --在移动转向过程中，获取输出缓冲区的值。
    dobuffbutt()

    --可控制移动速度
    p_t = min(p_t+0.125,1) --使用去最小值的方法，让p_t始终在1的范围之内
    
    --角色的行动状态(变量)，用于储存行动函数(移动、撞)
    p_mob.mov(p_mob,p_t)


    --即移动时间完成
    if  p_t ==1 then
        _upd=update_game--？
        if checkend() then
            doai()--角色ai行为
        end
    end

end

--非player的角色转向状态
function update_aiturn()
    dobuffbutt()--待小怪移动时也需要获取按钮缓冲的输入
    --可控制移动速度
    p_t = min(p_t+0.125,1) --使用去最小值的方法，让p_t始终在1的范围之内
    
    for m in all(mob) do
        if m!=p_mob and m.mov then--当角色不为主角，且mov不为空
            m.mov(m,p_t)
        end
    end

    if  p_t ==1 then
        _upd=update_game
        checkend()
    end

end

--游戏结束状态
function update_gover()
    if btnp(❎) then
        --fadeout() --不需要，因为本身，开始游戏fadeperc=1，所以就会淡入
        startgame()
    end
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

    if butt<4 then--输入上下左右移动
        moveplayer(dirx[butt+1],diry[butt+1])--移动角色

    end
end

