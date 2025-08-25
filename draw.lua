function draw_game()
    map()--地图
	
    --角色(敌人/npc)精灵显示
    for c in all (enemies) do
        spr(c.spr, c.x, c.y)
        rect(c.x,c.y,c.x+c.w,c.y+c.h,12)
    end
    for o in all (obj) do--物体显示
        spr(o.spr, o.sprx, o.spry)
        rect(o.x,o.y,o.x+o.w,o.y+o.h,12)--物体的碰撞盒
    end
    --主角
    draw_p(wy,wy.spr_cx,wy.spr_cy)
    rect(wy.x, wy.y, wy.x+wy.w, wy.y+wy.h,8)--主角spr框
    draweapon(wy)
    ui_show()--UI显示
end
-- 绘制攻击武器 player玩家对象
function draweapon(player)
    local swordspr
    if sword.isappear then	
        if not player.sprflip and player.dire == 0 then
            swordspr = 25 -- 翻转武器精灵
        elseif player.sprflip and player.dire == 0 then
            swordspr = 27 -- 翻转武器精灵
        else
            swordspr = sword.sprs[player.dire]
        end
        spr(swordspr, sword.x, sword.y)
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

end
function draw_win()

end
function move_anim(_sb)
	_sb.move_t+=.2
	_sb.frame=_sb.sprs.move[ceil(_sb.move_t%#_sb.sprs.move)]
end
--推动动画 player玩家对象
function pull_anim(player)
    if player.dire ~= 0 then
        if player.dire % 2 == 1 then
            player.frame = player.sprs.push[(player.dire + 1) / 2]
        else
            player.frame = player.sprs.push[player.dire / 2]
        end
    end
end
function hurt_anim(_sb)
    _sb.frame=_sb.sprs.hurt
end