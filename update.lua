function update_game()--游戏进行时
	check_map_sth()--检测地图上的东西
	--主角受伤检测（无敌时间0，主角不在攻击状态）
	if check_p_hurt(wy) and wy.wudi_t==0 and wy.state!=wy.allstate.attack then --检测玩家受伤
		wy.ishurt=true
		wy.state=wy.allstate.hurt
	end
	--受伤无敌
	if wy.ishurt then--如果受伤，受伤无敌时间增加
		--受伤闪烁和无敌时间相同
		wy.wudi_t+=1
		if wy.wudi_t>20 then
			wy.ishurt=false
			wy.wudi_t=0
		end
	end 
	updatep_state(wy)--主角的行为: 更新玩家状态
	for e in all(enemies) do
		en_update(e,"urchin",enstate_urchin)
		en_update(e,"snake",enstate_snake)
		en_update(e,"slime",enstate_slime)
		en_update(e,"bat",enstate_bat)
		en_update(e,"spider",enstate_spider)
		en_update(e,"ghost",enstate_ghost)
		en_update(e,"lizi",enstate_lizi)
	end
	--敌人子弹的检测
	for b in all(bullets) do
		firebullet()
		if cnut.x>128 or cnut.x<0 or cnut.y>100 or cnut.y<0 then
			debug1="cnut out"
			del(bullets,b)
		end
	end
end
function en_update(e,name,func)
	if e.name==name then func(e) end
end
function update_mamenu()--菜单
	blinkt+=1
	wy = initializeplayer()  -- 初始化玩家
	sword = initializesword()  -- 初始化武器
	--startgame()
	input_mamenu()--主菜单输入
end
function update_gover()--游戏结束
	--游戏结束
	if btnp(4) and time()>5 then
		_upd,_drw=update_mamenu,draw_mamenu
	end
end
function update_win()
	--游戏通关
end

