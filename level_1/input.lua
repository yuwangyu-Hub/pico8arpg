function input_direct_sys()
	local btnv_mask,btnp=btn()&0b001111,btnp()&0b110000--遮罩剔除掉X\O的输入\获取方向键输入

	wy.dire = input_dire[btnv_mask+1] --获取方向
    --攻击为真(遮罩剔除掉方向输入只查看xo输入)
	
	if btnp==32 then--x键为真
		wy.isroll=true
    elseif btnp==16 and wy.getsowrd then --o键为真
		wy.isattack=true
	end
end
function input_mamenu()--主菜单输入
    
    if btn(2) then
        mainmenu_cursor.count = max(1, mainmenu_cursor.count - 1)
    elseif btn(3) then
        mainmenu_cursor.count = min(2, mainmenu_cursor.count + 1)
    end
    if btn(5) then
        if mainmenu_cursor.count==1 then
            _upd,_drw=update_game,draw_game
        elseif mainmenu_cursor.count==2 then
            stop()--游戏退出
        end
    end
end