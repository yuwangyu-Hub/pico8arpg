function draw_game()
    map()--地图
    --角色(敌人/npc)精灵显示
    if #enemies>0 then
        for e in all (enemies) do
            if e.state==e.allstate.hurt then
                pal(10,8)pal(6,8)pal(15,14)pal(4,2) 
            end
            spr(e.frame, e.x, e.y)
            pal()
            --rect(e.x,e.y,e.x+e.w,e.y+e.h,12)
        end
    end
    if #obj>0 then
        for o in all (obj) do--物体显示
        spr(o.spr[o.frame], o.sprx, o.spry)
        rect(o.x,o.y,o.x+o.w,o.y+o.h,12)--物体的碰撞盒
        end
    end
    --主角绘制
    if wy.ishurt then--受伤闪烁
        if wy.wudi_t%8<5 then pal(10,8)pal(6,8)pal(15,14)pal(4,2) end
    end
    draw_p(wy,wy.spr_cx,wy.spr_cy)
    pal()

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
    local w,h=2,2
    if _sb.lastdire%2==0 then --2468
        w,h=2,2
    else
        if _sb.lastdire==1 or _sb.lastdire==5 then
            w,h=2,3
        else --3\7
            if _sb.sprflip then
                xsum=-2+(dirx[_sb.lastdire]+1)*5-1
            end
            w,h=3,2
        end
    end
    sspr(atdirex[_sb.lastdire],atdirey[_sb.lastdire],w,h,_sb.x+xsum,_sb.y+ysum) 
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
    cprint("continue",64,100,cor2)
    --光标
    spr(mainmenu_cursor.spr,38,89+(mainmenu_cursor.count-1)*10)
end
function draw_Inventory_menu()
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
    local data={6,13,5,1,0,0}
    cls(data[flr(time()*2%#data)+1])
    if time() >5 then--一定时间后显示文字
        cls(0)
        cprint("gameover",64,90,7)
    end
end
--检测地图上绘制的敌人/物品精灵，将其转换为对应的实例
function check_map_sth()
	for i=0,15 do--行
		for j=0,15 do--列
			local en_mount=mget(i,j)
			if en_mount==96 then --slime
				createnemy_slime(i,j)
				mset(i,j,0)
			elseif en_mount==98 then --蛇
				createnemy_snake(i,j)  -- 创建蛇形敌人
				mset(i,j,0)
			elseif en_mount==105 then --大眼怪
				createnemy_bigeye(i,j)
				mset(i,j,0)
			elseif en_mount==113 then --箱子
				makeobj(1,i*8,j*8,7,7,0,0,0,0)--box
				mset(i,j,0)
			elseif en_mount== 114 then --金币
				makeobj(2,i*8,j*8,7,7,0,0,0,0)--coin
				mset(i,j,0)
			end
		end
	end
end

function draw_p(_sb,cx,cy)--cx和cy代表差值
	local x,y=_sb.x+cx,_sb.y+cy
	spr(_sb.frame, x, y, 1, 1, _sb.sprflip)
end


--推动动画 player玩家对象
function pull_anim(_sb)--玩家专有
    if _sb.dire != 0 then
        if _sb.dire % 2 == 1 then
            _sb.frame = _sb.sprs.push[(_sb.dire + 1) / 2]
        else
            _sb.frame = _sb.sprs.push[_sb.dire / 2]
        end
    end
end
function p_hurt_anim(_sb)--玩家
    --循环动画还是一次性动画
    --多帧动画还是单帧动画
    _sb.frame=_sb.sprs.hurt
end
function move_anim(_sb)--敌人和玩家共有
	_sb.move_t+=.2
	_sb.frame=_sb.sprs.move[ceil(_sb.move_t%#_sb.sprs.move)]
end
function explode_anim(_sb)--死亡爆炸
    _sb.die_t+=.4
    _sb.frame=_sb.sprs.death[ceil(_sb.die_t%#_sb.sprs.death)]
end