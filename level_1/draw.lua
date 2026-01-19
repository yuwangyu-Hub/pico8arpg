function sceneset(p,table)--t:table
    local maptable=table
    wy.mappos=maptable[p.mappos]--设置当前地图位置
    enemies={} --清空敌人组
    p.is_s_scene=true --是否为场景地图
end
function sceneswitch_u(p)--场切上
    if p.y<-6 then--上
        p.y+=126
        sceneset(p,{[1]=4,[2]=5,[3]=6,[4]=7,[5]=8,[7]=9,[8]=10})
    end
end
function sceneswitch_d(p)--场切下
    if p.y>126 then--下
        if p.mappos==11 then
            p.x=64
            p.y=80
        elseif p.mappos==12 then
            p.x=16
            p.y=100
        else
            p.y-=127
        end
        sceneset(p,{[4]=1,[5]=2,[6]=3,[7]=4,[8]=5,[9]=7,[10]=8,[11]=4,[12]=6})
    end
end
function sceneswitch_l(p)--场切左
    if p.x<-6 then
        p.x+=128
        sceneset(p,{[2]=1,[3]=2,[5]=4,[6]=5,[8]=7,[10]=9,[12]=11})
    end
end
function sceneswitch_r(p)--场切右
    if p.x>124 then
        p.x-=125
        sceneset(p,{[1]=2,[2]=3,[4]=5,[5]=6,[7]=8,[9]=10,[11]=12})
    end
end
function sceneswitch_in(p)--门/洞的进
    if p.mappos==4 then
        if fget(mget(flr((p.x+4)/ 8+mapnum[p.mappos][1]),flr((p.y+4)/8+mapnum[p.mappos][2])),1) then --当进洞
            --切换到洞口场景            
            wy.mappos=11
            wy.x=64
            wy.y=120
            enemies={}
            p.is_s_scene=true --s:switch
        end 
    end
    if p.mappos==6 then
          if fget(mget(flr((p.x+4)/8+mapnum[p.mappos][1]),flr((p.y+4)/8+mapnum[p.mappos][2])),1) then --当进洞            
            wy.mappos=12
            wy.x=64
            wy.y=120
            enemies={}
            p.is_s_scene=true
        end
    end
    
end
function sceneswitch_othercart(p)--切换到另一个卡
    if p.y<-6 then--上
        --游戏结束
        _upd,_drw=update_gover,draw_gover
    end
end
function mapsys()--地图切换系统
    local switches = {
        [1] = {sceneswitch_u, sceneswitch_r},
        [2] = {sceneswitch_u, sceneswitch_l, sceneswitch_r},
        [3] = {sceneswitch_u, sceneswitch_l},
        [4] = {sceneswitch_u, sceneswitch_d, sceneswitch_r,sceneswitch_in},
        [5] = {sceneswitch_u, sceneswitch_d, sceneswitch_l, sceneswitch_r},
        [6] = {sceneswitch_d, sceneswitch_l,sceneswitch_in,sceneswitch_othercart},
        [7] = {sceneswitch_u, sceneswitch_d, sceneswitch_r},
        [8] = {sceneswitch_u, sceneswitch_d, sceneswitch_l},
        [9] = {sceneswitch_d, sceneswitch_r},
        [10] = {sceneswitch_d, sceneswitch_l},
        [11] = {sceneswitch_in,sceneswitch_r,sceneswitch_d},
        [12] = {sceneswitch_in,sceneswitch_l,sceneswitch_d}}
    --根据当前地图位置调用对应的切换函数
    for _, func in ipairs(switches[wy.mappos] or {}) do
        func(wy)
    end
end

function draw_game()
    map(mapnum[wy.mappos][1],mapnum[wy.mappos][2])--地图绘制
    spr(39,wy.x,wy.y+6,1,1,wy.sprflip)--主角影子(用来跳跃区分)
    if #enemies>0 then--敌人精灵显示
        for e in all (enemies) do
            spr(191, e.x, e.y+8,1,1,e.sprflip)--影子
            draw_p(e)
            --rect(e.x,e.y,e.x+e.w,e.y+e.h,12) --可视碰撞盒
            --if e.name=="lizi" then--敌人检测范围
                --circ(e.x+e.w/2,e.y+e.h/2,e.crange,12)--圆检测范围
                --check_p(e,e.crange)
            --end
        end
    end
    --获得后，显示
    if wy.state==wy.allstate.get then
        if wy.getadheart then
            spr(52,wy.x,wy.y-8,1,1)
        elseif wy.getsowrd then
            spr(41,wy.x-4,wy.y-8,2,1)
        end
    end
    draw_p(wy)--主角绘制
    if #obj>0 then--物体绘制
        for o in all (obj) do
            if  o.mappos==wy.mappos then
                spr(o.spr, o.x, o.y)
                o.appear=1
            else
                o.appear=0
                --rect(o.x,o.y,o.x+o.w,o.y+o.h,12)--物体的碰撞盒
            end
        end
    end
    if not sword.isappear and wy.state != wy.allstate.get then
        actdireshow(wy)
    end
    --rect(wy.x, wy.y, wy.x+wy.w, wy.y+wy.h,8)
    --rect(wy.cx, wy.cy, wy.cx+wy.cw, wy.cy+wy.ch,12)--主角spr框
    draweapon(wy)
    for b in all(bullets) do--射击物（敌人）的绘制
        spr(b.frame,b.x,b.y)
    end
    ui_show()
end
function actdireshow(_sb)--朝向标识显示
    local data=explodeval("[-6,3],[-4,-3],[3,-5],[9,-3],[11,3],[9,9],[3,11],[-4,9]")--12345678
    sspr(atdirex[_sb.lastdire],atdirey[_sb.lastdire],3,3,_sb.x+data[_sb.lastdire][1],_sb.y+data[_sb.lastdire][2]) 
end
function draweapon(_sb)--根据朝向绘制武器攻击
    local swordt=explodeval("43,18,45,19,44,35,61,34") --12345678
    local swordpos=explodeval("[-7,0],[-7,-7],[0,-7],[7,-7],[7,0],[7,7],[0,7],[-7,7]")
    if sword.isappear then	
       draw_p(sword,_sb.x+swordpos[_sb.lastdire][1],_sb.y+swordpos[_sb.lastdire][2],swordt[_sb.lastdire],false)
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
function showend()--游戏结束anim
    --*绘制游戏结束画面
    cprint("gameover",64,90,7)
end
function mapenemy_reset()--切换场景时，重置敌人
    map_trrrans = function(_num,_x,_y)
        ({createnemy_urchin,createnemy_crab,createnemy_spider,createnemy_slime,createnemy_lizi,createnemy_snake})[_num](_x,_y)
    end
    for ep in all(maps[wy.mappos]) do
        map_trrrans(ep[3],ep[1],ep[2])--根据地图上绘制的敌人，创建敌人实例
    end
end

function draw_p(_sb,_x,_y,_spr,_flip)--绘制主角：cx和cy代表差值
	local x,y,frame,flip=_x or _sb.x, _y or _sb.y, _spr or _sb.frame,_flip or _sb.sprflip
    --黑色、边缘偏移
    local black_t,side_t=explodeval("1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1"),explodeval("[-1,0],[1,0],[0,-1],[0,1]")
    pal(black_t) --所有颜色映射为1颜色
    for _,d in ipairs(side_t) do--把四周的偏移写成坐标表，一个循环就搞定
        spr(frame,x+d[1],y+d[2],1,1,flip)
    end
    pal()--恢复默认
	spr(frame,x,y,1,1,flip)--本体
end
--多帧动画系统：动画帧/帧集、对象、时间
function anim_sys(animframe,_sb,t,at,rate)--t:计时器，at:计时器增量，rate：动画速率
    t+=at
    _sb.frame=animframe[ceil(t*rate%#animframe)]
    return t
end
