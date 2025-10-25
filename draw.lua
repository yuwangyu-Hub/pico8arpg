
--token:7624

function draw_game()
    --主角影子(跳跃区分)
    spr(39,wy.x,wy.y+6,1,1,wy.sprflip)

    map()--地图绘制
    --角色(敌人/npc)精灵显示
    if #enemies>0 then
        for e in all (enemies) do
            spr(e.frame, e.x, e.y,1,1,e.sprflip)
            --rect(e.x,e.y,e.x+e.w,e.y+e.h,12)
           if e.crange then
                --圆检测范围
                circ(e.x+e.w/2,e.y+e.h/2,e.crange,12)
            end
        end
    end
    --[[if #obj>0 then--物体显示
        for o in all (obj) do--物体显示
        spr(o.spr[o.frame], o.sprx, o.spry)
        --rect(o.x,o.y,o.x+o.w,o.y+o.h,12)--物体的碰撞盒
        end
    end]]
    --主角绘制
    draw_p(wy,wy.spr_cx,wy.spr_cy)
 
    --朝向显示
    if not sword.isappear then
        actdireshow(wy)
    end
    --rect(wy.x, wy.y, wy.x+wy.w, wy.y+wy.h,8)--主角spr框
    draweapon(wy)
    ui_show()--UI显示
end
function actdireshow(_sb)--朝向标识显示
    --local data={{-2,3},{-2,-2},{3,-2},{8,-2},{8,3},{8,8},{3,8},{-2,8}}改为下方一系列复杂运算
    local xsum=-2+(dirx[_sb.lastdire]+1)*5
    local ysum=-2+(diry[_sb.lastdire]+1)*5
    if _sb.lastdire%2!=0 then --1357
        if _sb.lastdire==3 or _sb.lastdire==7 then
            if _sb.sprflip then
                xsum=-2+(dirx[_sb.lastdire]+1)*5-1
            end
        end
    end
    sspr(atdirex[_sb.lastdire],atdirey[_sb.lastdire],2,2,_sb.x+xsum,_sb.y+ysum) 
end
function draweapon(_sb)--根据朝向绘制武器攻击
                           --1, 2, 3, 4, 5, 6, 7, 8
    local swordx=explodeval("16,26,16,24,16,24,20,26")
    local swordy=explodeval("12,10,16,18, 8, 8,16,16")
    local swordw=explodeval("7, 6, 4, 6, 7, 6, 4, 6")
    local swordh=explodeval("4, 6, 7, 6, 4, 6, 7, 6")
    if sword.isappear then	
        sspr(swordx[_sb.lastdire],swordy[_sb.lastdire],swordw[_sb.lastdire],swordh[_sb.lastdire],sword.x,sword.y)
	end
end
function draw_mamenu()--主菜单
    local cor1,cor2=7,7--color
    if mainmenu_cursor.count == 1 then
        cor1=blink()
        cor2=7
    elseif mainmenu_cursor.count == 2 then
        cor1=7
        cor2=blink()
    end
    --选项
    cprint("playgame",64,90,cor1)
    cprint("exitgame",64,100,cor2)
    --光标
    spr(mainmenu_cursor.spr,38,89+(mainmenu_cursor.count-1)*10)
end
function draw_Inventory_menu() --绘制背包
    --武器/道具的显示和替换
    --可使用道具的使用
    --地图的显示
end
function draw_gover()
    showend()
end
function draw_win()

end


function spr_flip(_sb)--精灵反转
	if _sb.dire==2 or _sb.dire==1 or _sb.dire==8  then
		_sb.sprflip=true --如果是右上方向，精灵翻转
	elseif _sb.dire==4 or _sb.dire==5 or _sb.dire==6 then
		_sb.sprflip=false --其他方向不翻转
	end
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
            --map_trans_en(i,j,105,createnemy_urchin,0)--海胆
            --map_trans_en(i,j,98,createnemy_snake,0)--蛇
            --map_trans_en(i,j,96,createnemy_slime,0)--史莱姆
            --map_trans_en(i,j,101,createnemy_bat,0)--蝙蝠
            --map_trans_en(i,j,103,createnemy_spider,0)--小蜘蛛
            --map_trans_en(i,j,73,createnemy_ghost,74)--幽灵
            --map_trans_en(i,j,106,createnemy_lizi,0)--丢栗怪
            --map_trans_obj(i,j,113,1,0)
            --map_trans_obj(i,j,114,2,0)
		end
	end
end
function map_trrrans(i,j)
    local num=mget(i,j)
    switch(num,{
        [105]=function() --海胆
            createnemy_urchin(i,j)
            mset(i,j,0)
        end,
        [98]=function()--蛇
            createnemy_snake(i,j)
            mset(i,j,0)
        end,
        [96]=function()--史莱姆
            createnemy_slime(i,j)
            mset(i,j,0)
        end,
        [101]=function()--小蝙蝠
            createnemy_bat(i,j)
            mset(i,j,0)
        end,
        [103]=function()--小蜘蛛
            createnemy_spider(i,j)
            mset(i,j,74)
        end,
        [73]=function()--小幽灵
            createnemy_ghost(i,j)
            mset(i,j,0)
        end,
        [106]=function()--丢栗怪
            createnemy_lizi(i,j)
            mset(i,j,0)
        end,}
    )
    

end

function switch(num, cases)
    -- 如果 cases 里能找到，就执行对应函数
    if cases[num] then
        return cases[num]()          -- 把结果返回，方便链式调用
    end
end
--[[
function map_trans_en(i,j,map_num,func,setile)--地图转换为敌人
    local num=mget(i,j)
    if num==map_num then
        func(i,j)
        mset(i,j,setile)
    end
end
function map_trans_obj(i,j,map_num,index,setile)
    local num=mget(i,j)
    if num==map_num then
        makeobj(index,i*8,j*8,7,7,0,0,0,0)--coin
        mset(i,j,setile)
    end
end]]


function draw_p(_sb,cx,cy)--绘制主角：cx和cy代表差值
	local x,y=_sb.x+cx,_sb.y+cy
	spr(_sb.frame, x, y, 1, 1, _sb.sprflip)
end
--*与下面的动画系统整合优化：推动动画 player玩家对象
function pull_anim(_sb)--玩家专有推动动画
    if _sb.dire != 0 then
        if _sb.dire % 2 == 1 then
           _sb.frame = _sb.sprs.push[(_sb.dire + 1) / 2]
        else
            _sb.frame = _sb.sprs.push[_sb.dire / 2]
        end
    end
end
--多帧动画系统：动画帧/帧集、对象、时间
function anim_sys(animframe,_sb,t,at,rate)--t:计时器，at:计时器增量，rate：动画速率
    t+=at
    _sb.frame=animframe[ceil(t*rate%#animframe)]
    return t
end
