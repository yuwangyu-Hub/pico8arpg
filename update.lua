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
	
	--[[
	if check_en_hurt() then--检测敌人受伤
		--debug="en_hurt"
	end]]
end
function update_mamenu()
	blinkt+=1
	input_mamenu()--主菜单
end
function update_gover()
end
function update_win()
end

