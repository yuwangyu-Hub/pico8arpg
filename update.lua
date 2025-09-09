function update_game()
	check_map_sth()--检测地图上的东西
	--主角的行为: 更新玩家状态
	updatep_state(wy)
	
	--敌人行为
	for e in all(enemies) do
		if e.type=="a" then
			
			enstate_a(e)
		elseif e.type=="b" then
			enstate_b(e)
		elseif e.type=="c" then
			enstate_c(e)
		end
	end
	--主角受伤检测
	if check_p_hurt(wy) and wy.wudi_t==0 and wy.state!=wy.allstate.attack then --检测玩家受伤
		wy.ishurt=true
		wy.state=wy.allstate.hurt
	end
	--受伤无敌
	if wy.ishurt then
		--受伤闪烁和无敌时间相同
		wy.wudi_t+=1 
		if wy.wudi_t>20 then 
			wy.ishurt=false
			wy.wudi_t=0  
		end
	end--如果受伤，受伤无敌时间增加
end
function update_mamenu()
	blinkt+=1
	wy = initializeplayer()  -- 初始化玩家
	sword = initializesword()  -- 初始化武器
	--startgame()
	input_mamenu()--主菜单输入
end
function update_gover()
	--游戏结束
	if btnp(4) and time()>5 then
		_upd=update_mamenu
		_drw=draw_mamenu
	end
end
function update_nextlevel()
	--下一关
end
function update_win()
	--游戏通关
end

