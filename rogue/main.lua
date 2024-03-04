function _init()
    t=0

    --一组颜色的递变数据
    dpal={0,1,1,2,1,13,6,4,4,9,3,13,1,13,14}
    --fadeperc=0

    p_ani={240,241,242,243}

    --dirx={-1,1,0,0}
    --diry={0,0,-1,1}

    dirx={-1,1,0,0,1,1,-1,-1}--前四位代表上下左右，后四位代表斜四方向
    diry={0,0,-1,1,-1,1,1,-1}

    --1位置上代表主角的动画第一帧、2位置上代表史莱姆动画第一帧
    mob_ani={240,192}
    mob_atk={1,1}
    mob_hp={5,2}
 
    startgame()
end



function _update60()
    t+=1
    _upd() --间接调用该函数
    --UI效果不受到影响
    dofloats()
end

function _draw()
    _drw()--执行当前变量所指向的具体函数
    --绘制所有窗口
    drawind()
    dohpwind()
    checkfade()
end



function startgame()
    --淡出百分比，默认为1，100%
    fadeperc=1
    --button_buffer--缓冲区按钮，用来储存按键输入，在动画播放完之后执行，可以精确到每个按钮的输入。
    buttbuff=-1
    
    mob={}--创建角色组（游戏中所有角色放入其中，包括主角和敌人）
    dmob={}--角色死亡后，放入该合集中，deadmob
    p_mob = addmob(1,1,1) --主角
   
    --生成怪物
    for x=0,15 do
        for y=0,15 do
            if mget(x,y)==3 then
                addmob(2,x,y)
            end
        end
    end
   
    
    p_t=0 --计时器


    
    wind={}--ui窗口数量的数组
    float={}--悬浮UI数组，用来显示伤害值
    talkwind=nil --对话窗口
    
    hpwind=addwind(5,5,28,13,{})
   
    --变量 = 函数   ：指向调用函数
    --变量 = 函数() ：将函数的返回值赋给变量
    _upd=update_game --将函数分配给变量，当调用该变量，变量就会调用该函数
    _drw=draw_game

end


