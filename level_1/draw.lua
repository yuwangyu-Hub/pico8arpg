function mapsys()
    if wy.mappos==1 then
        if wy.x>124 then
            wy.mappos=2
            wy.x-=124
        elseif wy.y<0 then
            wy.mappos=4
            wy.y+=120
        end
    elseif wy.mappos==2 then
        if wy.x<0 then
            wy.mappos=1
            wy.x+=124
        elseif wy.y<0 then
            wy.mappos=4
            wy.y+=120
        end
    elseif wy.mappos==3 then
           
    elseif wy.mappos==4 then
          
    elseif wy.mappos==5 then

    elseif wy.mappos==6 then
    elseif wy.mappos==7 then
    elseif wy.mappos==8 then
    elseif wy.mappos==9 then
    elseif wy.mappos==10 then

    end
        map(mapnum[wy.mappos][1],mapnum[wy.mappos][2])
end

function draw_game()
    mapsys()
    spr(39,wy.x,wy.y+6,1,1,wy.sprflip)--主角影子(用来跳跃区分)
    if #enemies>0 then--敌人精灵显示
        for e in all (enemies) do
            spr(112,e.x,e.y+6,1,1,e.sprflip)--主角影子(用来跳跃区分)
            spr(e.frame, e.x, e.y,1,1,e.sprflip)
            --rect(e.x,e.y,e.x+e.w,e.y+e.h,12) --可视化碰撞盒
            --if e.name=="slime" then--敌人检测范围
            --圆检测范围
            --circ(e.x+e.w/2,e.y+e.h/2,e.crange,12)
            --end
        end
    end
    draw_p(wy,wy.spr_cx,wy.spr_cy)--主角绘制
    --[[if #obj>0 then--物体显示
        for o in all (obj) do--物体显示
        spr(o.spr[o.frame], o.sprx, o.spry)
        --rect(o.x,o.y,o.x+o.w,o.y+o.h,12)--物体的碰撞盒
        end
    end]]
    if not sword.isappear then--主角的朝向显示
        actdireshow(wy)
    end
    --rect(wy.x, wy.y, wy.x+wy.w, wy.y+wy.h,8)--主角spr框
    draweapon(wy)
    for b in all(bullets) do --射击物的绘制
        spr(b.frame,b.x,b.y)
    end
    ui_show()--UI显示
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
function draw_Inventory_menu() --绘制背包
    --武器/道具的显示和替换
    --可使用道具的使用
    --地图的显示不确定暂时是否需要添加-可能移植picotron
end
function draw_gover()
    showend()
end
function draw_win()

end
function spr_flip(_sb)--精灵反转
    _sb.sprflip = (_sb.dire == 2 or _sb.dire == 1 or _sb.dire == 8) and true or false

        

end
function showend()--游戏结束动画播放
    --local data={6,13,5,1,0,0}
    --cls(data[flr(time()*2%#data)+1])
    --if time() >5 then--一定时间后显示文字
       --cls(0)
    --end
    cprint("gameover",64,90,7)
    --*按键回到游戏开始
end
--检测地图上绘制的敌人/物品精灵，将其转换为对应的实例，*可优化提炼
function check_map_sth()
	for i=0,15 do--行
		for j=0,15 do--列
            map_trrrans(i,j)
		end
	end
end
function map_trrrans(i,j)
    local num=mget(i,j)
    switch(num,{
        [64]=function()createnemy_urchin(i,j)mset(i,j,0)end,
        [66]=function()createnemy_crab(i,j)mset(i,j,0)end,
        [80]=function()createnemy_slime(i,j)mset(i,j,0)end,
        [70]=function()createnemy_spider(i,j)mset(i,j,0)end,
        [72]=function()createnemy_lizi(i,j)mset(i,j,0)end,})
end
function switch(num, cases)
    if cases[num] then--能找到，就执行对应函数
        return cases[num]()--把结果返回，方便链式调用
    end
end
function draw_p(_sb,cx,cy)--绘制主角：cx和cy代表差值
	local x,y=_sb.x+cx,_sb.y+cy
	spr(_sb.frame, x, y, 1, 1, _sb.sprflip)
end
--*与下面的动画系统整合优化：推动动画 player玩家对象
function pull_anim(_sb)--玩家专有推动动画
    if _sb.dire != 0 then
        _sb.frame = _sb.sprs.push[(_sb.dire % 2 == 1) and ((_sb.dire + 1) / 2) or (_sb.dire / 2)]
        --[[if _sb.dire % 2==1 then
           _sb.frame=_sb.sprs.push[(_sb.dire+1)/2]
        else
            _sb.frame=_sb.sprs.push[_sb.dire/2]
        end]]
    end
end
--多帧动画系统：动画帧/帧集、对象、时间
function anim_sys(animframe,_sb,t,at,rate)--t:计时器，at:计时器增量，rate：动画速率
    t+=at
    _sb.frame=animframe[ceil(t*rate%#animframe)]
    return t
end
