function input_direct_sys()
	local btnv=btn()&0b1111 --遮罩剔除掉X\O的输入
	wy.dire = input_dire[btnv+1] --获取方向
	
	if btnp()&0b110000 ==16 then --攻击为真
		wy.isattack=true
	end
	if btnp()&0b110000==32 then --翻滚为真
		wy.isroll=true
	end
	if btnp()&0b110000==48 then
		debug="inv"
	end
end


function input_mamenu()--主菜单输入
    if btn(⬆️) then
        if mainmenu_cursor.count>1 then
            mainmenu_cursor.count=1
        end
    elseif btn(⬇️) then
        if mainmenu_cursor.count<2 then
            mainmenu_cursor.count=2
        end
    end
    if btn(5) then
        if mainmenu_cursor.count==1 then
            startgame()
            _upd=update_game
            _drw=draw_game
        elseif mainmenu_cursor.count==2 then
            --继续游戏
        end
    end
end
