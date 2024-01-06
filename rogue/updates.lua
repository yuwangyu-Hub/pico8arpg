--游戏进行状态
function update_game()
   

    for i=0,3 do
        if btnp(i) then
            moveplayer(dirx[i+1],diry[i+1])
        end
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
    --可控制移动速度
    p_t = min(p_t+0.125,1) --使用去最小值的方法，让p_t始终在1的范围之内

    p_mov()

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
function mov_walk()
    p_ox=p_sox*(1-p_t) --通过不断获取自身变小值而实现p_ox的值减小。因为p_t是0-1之间不断增大
    p_oy=p_soy*(1-p_t) --而 1-p_t 就是不断变小再乘以自身的变小值赋给自身，达到值变小的目的
end

--从一个地方移动但撞到然后返回，可以用来撞墙，或撞向其他物体
function mov_bump()
   
    local tme=p_t
    --[[
        if p_t<0.5 then
            p_ox=p_sox*(p_t)
            p_oy=p_soy*(p_t)
        else
            p_ox=p_sox*(1-p_t) 
            p_oy=p_soy*(1-p_t)
        end
    ]]--
    if p_t>0.5 then
        tme=1-p_t
    end
    p_ox=p_sox*tme
    p_oy=p_soy*tme

end


function getbutt()
    
end

