function sceneset(p,table)--t:table
    local maptable=table
    wy.mappos=maptable[p.mappos]
    enemies={}
    obj={}
    p.is_s_scene=true
end
function sceneswitch_u(p)
    if p.y<-6 then--上
        p.y+=126
        sceneset(p,{[1]=4,[2]=5,[3]=6,[4]=7,[5]=8,[7]=9,[8]=10})
    end
end
function sceneswitch_d(p)
    if p.y>126 then--下
        p.y-=127
        sceneset(p,{[4]=1,[5]=2,[6]=3,[7]=4,[8]=5,[9]=7,[10]=8})
    end
end
function sceneswitch_l(p)
    if p.x<-6 then--左
        p.x+=128
        sceneset(p,{[2]=1,[3]=2,[5]=4,[6]=5,[8]=7,[10]=9})
    end
end
function sceneswitch_r(p)
    if p.x>124 then--右
        p.x-=125
        sceneset(p,{[1]=2,[2]=3,[4]=5,[5]=6,[7]=8,[9]=10})
        if p.mappos==3 then--当在第三张图时
            makeobj(2)--创建剑
        end
    end
end
function mapsys()
    local switches = {
        [1] = {sceneswitch_u, sceneswitch_r},
        [2] = {sceneswitch_u, sceneswitch_l, sceneswitch_r},
        [3] = {sceneswitch_u, sceneswitch_l},
        [4] = {sceneswitch_u, sceneswitch_d, sceneswitch_r},
        [5] = {sceneswitch_u, sceneswitch_d, sceneswitch_l, sceneswitch_r},
        [6] = {sceneswitch_d, sceneswitch_l},
        [7] = {sceneswitch_u, sceneswitch_d, sceneswitch_r},
        [8] = {sceneswitch_u, sceneswitch_d, sceneswitch_l},
        [9] = {sceneswitch_d, sceneswitch_r},
        [10] = {sceneswitch_d, sceneswitch_l}
    }
    for _, func in ipairs(switches[wy.mappos] or {}) do
        func(wy)
    end
end
function draw_game()
    --地图绘制
    map(mapnum[wy.mappos][1],mapnum[wy.mappos][2])
    spr(39,wy.x,wy.y+6,1,1,wy.sprflip)--主角影子(用来跳跃区分)
    if #enemies>0 then--敌人精灵显示
        for e in all (enemies) do
            spr(191, e.x, e.y+8,1,1,e.sprflip)--影子
            draw_p(e)
            --rect(e.x,e.y,e.x+e.w,e.y+e.h,12) --可视碰撞盒
            --if e.name=="slime" then--敌人检测范围
                --circ(e.x+e.w/2,e.y+e.h/2,e.crange,12)--圆检测范围
            --end
        end
    end
    --get sword 
    if wy.state==wy.allstate.get and wy.getsowrd then
        spr(41,wy.x-4,wy.y-8,2,1)
    end
    draw_p(wy)--主角绘制
    if #obj>0 then--物体显示
        for o in all (obj) do
        spr(o.spr, o.x, o.y)
        --rect(o.x,o.y,o.x+o.w,o.y+o.h,12)--物体的碰撞盒
        end
    end
    if not sword.isappear then
        actdireshow(wy)
    end
    --rect(wy.x, wy.y, wy.x+wy.w, wy.y+wy.h,8)--主角spr框
    draweapon(wy)
    for b in all(bullets) do --射击物（敌人）的绘制
        spr(b.frame,b.x,b.y)
    end
    ui_show()
end
function actdireshow(_sb)--朝向标识显示
    local data=explodeval("[-3,3],[-2,-2],[3,-3],[8,-2],[9,3],[8,8],[3,9],[-2,8]")--124578
    sspr(atdirex[_sb.lastdire],atdirey[_sb.lastdire],2,2,_sb.x+data[_sb.lastdire][1],_sb.y+data[_sb.lastdire][2]) 
end
function draweapon(_sb)--根据朝向绘制武器攻击
    --1,2,3,4,5,6,7,8
    local swordx,swordy,swordw,swordh=explodeval("16,26,16,24,16,24,20,26"),explodeval("12,10,16,18, 8, 8,16,16"),explodeval("7, 6, 4, 6, 7, 6, 4, 6"),explodeval("4, 6, 7, 6, 4, 6, 7, 6")
    if sword.isappear then	
        sspr(swordx[_sb.lastdire],swordy[_sb.lastdire],swordw[_sb.lastdire],swordh[_sb.lastdire],sword.x,sword.y)
	end
end
function draw_mamenu()--主菜单
    local cor1,cor2=7,7--color
    if mainmenu_cursor.count==1 then
        cor1,cor2=blink(),7
    elseif mainmenu_cursor.count==2 then
        cor1,cor2=7,blink()
    end
    cprint("playgame",64,90,cor1)--选项
    cprint("exitgame",64,100,cor2)
    spr(mainmenu_cursor.spr,38,89+(mainmenu_cursor.count-1)*10)--光标
end

function draw_gover()--游戏结束界面
    showend()
end
function draw_win()--游戏胜利界面
    showend()
end
function showend()--游戏结束动画播放
    --*绘制游戏结束画面
    cprint("gameover",64,90,7)
    --*按键回到游戏开始
end
function mapenemy_reset()--切换场景时，重置敌人
    map_trrrans = function(_num,_x,_y)
        ({createnemy_urchin,createnemy_crab,createnemy_spider,createnemy_slime,createnemy_lizi})[_num](_x,_y)
    end
    for ep in all(maps[wy.mappos]) do
        --ep=enemy position  
        map_trrrans(ep[3],ep[1],ep[2])--根据地图上绘制的敌人，创建敌人实例
    end
end
--[[
function map_trrrans(_num,_x,_y)
    switch(_num,{
        [1]=function()
            createnemy_urchin(_x,_y)
        end,
        [2]=function()
            createnemy_crab(_x,_y)
        end,
        [3]=function()
            createnemy_spider(_x,_y)
        end,
        [4]=function()
            createnemy_slime(_x,_y)
        end,
        [5]=function()
            createnemy_lizi(_x,_y)
        end,}
    )
end
function switch(num, cases)
    if cases[num] then--能找到，就执行对应函数
        return cases[num]()--把结果返回，方便链式调用
    end
end]]
function draw_p(_sb)--绘制主角：cx和cy代表差值
	local x,y,frame,flip=_sb.x,_sb.y,_sb.frame,_sb.sprflip
    --黑边
    pal({1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}) -- 所有颜色映射为1颜色
    for _,d in ipairs{{-1,0},{1,0},{0,-1},{0,1}} do--把四周的偏移写成坐标表，一个循环就搞定：
        spr(frame, x+d[1], y+d[2], 1, 1, flip)
    end
    pal() -- 恢复默认
	spr(frame, x, y, 1, 1, flip)--本体
end
--多帧动画系统：动画帧/帧集、对象、时间
function anim_sys(animframe,_sb,t,at,rate)--t:计时器，at:计时器增量，rate：动画速率
    t+=at
    _sb.frame=animframe[ceil(t*rate%#animframe)]
    return t
end
