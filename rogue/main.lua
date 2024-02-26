function _init()
    t=0
    p_ani={240,241,242,243}

    --dirx={-1,1,0,0}
    --diry={0,0,-1,1}

    dirx={-1,1,0,0,1,1,-1,-1}
    diry={0,0,-1,1,-1,1,1,-1}

    --230代表主角的动画第一帧、192代表史莱姆动画第一帧
    mob_ani={240,192}


    
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
    _drw()--执行当前变量所指向的具体函数
    drawind()
end

function startgame()
    
    
    --button_buffer--缓冲区按钮，用来储存按键输入，在动画播放完之后执行，可以精确到每个按钮的输入。
    buttbuff=-1
    
    mob={}
    p_mob = addmob(1,1,1) --主角
    addmob(2,2,3)
    --[[
    p_x=1
    p_y=1
    p_ox=0 
    p_oy=0 
    p_sox=0 
    p_soy=0 
    p_mov=nil 
    p_flip=false]]--
    
    p_t=0 --计时器

    --ui窗口数量的数组
    wind={}

    talkwind=nil --对话窗口
    
  
end


