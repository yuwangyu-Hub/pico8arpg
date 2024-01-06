function _init()
    t=0
    p_ani={48,49,50,51}

    dirx={-1,1,0,0}
    diry={0,0,-1,1}



    
    --变量 = 函数   ：指向调用函数
    --变量 = 函数() ：将函数的返回值赋给变量
    _upd=update_game --将函数分配给变量，当调用该变量，变量就会调用该函数
    _drw=draw_game

    startgame()
end



function _update60()
    t+=1
    _upd() --间接调用该函数
    
end

function _draw()
    _drw()
end

function startgame()
    --缓冲区按钮，用来储存按键输入，在动画播放完之后执行
    --button_buffer
    buttbuff=-1
    
    p_x=1
    p_y=1
    p_ox=0 --运动过程中的偏移量(会随着变化)，让角色在移动中的动画显示上有一个偏移量移动的效果
    p_oy=0 --运动过程中的偏移量(会随着变化)
    p_sox=0 --一开始时候的偏移量
    p_soy=0 --一开始时候的偏移量
    p_t=0 --计时器
    p_mov=nil --移动的动画模式，通过变量指向相应的动画行为函数。（行走、撞墙）

    p_flip=false --精灵翻转值
end


