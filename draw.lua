function draw_game()
    map() --地图
    --
    
	drawWeapon(wy)
	
    
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
    shadow(wy)
    spr(wy.frame, wy.x, wy.y, 1, 1, wy.sprflip)
    rect(wy.x, wy.y, wy.x+wy.w, wy.y+wy.h,8)--主角spr框

    --UI显示
    ui_show()
    --检测碰撞线显示
end
-- 绘制攻击武器
-- @param player 玩家对象
function drawWeapon(player)
    local swordSpr
    if sword.isappear then	
        if not player.sprflip and player.dire == 0 then
            swordSpr = 25 -- 翻转武器精灵
        elseif player.sprflip and player.dire == 0 then
            swordSpr = 27 -- 翻转武器精灵
        else
            swordSpr = sword.sprs[player.dire]
        end
        spr(swordSpr, sword.x, sword.y)
	end
end
function shadow(_sb)
    local x1,x2
    local y1,y2,col=_sb.y+6,_sb.y+_sb.h+1,13
    --主角影子
    if _sb.sprflip then
        x1=_sb.x
        x2=_sb.x+_sb.w-1
    else
        x1=_sb.x+1
        x2=_sb.x+_sb.w
    end
    ovalfill(x1,y1,x2,y2,col)--脚底影子
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
-- 更新推动动画
-- @param player 玩家对象
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