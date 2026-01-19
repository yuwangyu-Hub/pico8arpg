function update_game()--游戏进行时
	mapsys()--地图系统
	if wy.is_s_scene then--地图切换
		mapenemy_reset()--地图上敌人刷新
		bullets={}
		wy.state=wy.allstate.switch--主角状态重置为idle,修复翻滚切换场景后的穿墙bug
		wy.is_s_scene=false
	end

	if wy.state== wy.allstate.idle or wy.state==wy.allstate.move then
		input_direct_sys()--检测方向
	end
	--受伤无敌
	if wy.ishurt then--如果受伤，受伤无敌时间增加 
		--受伤闪烁和无敌时间相同
		wy.wudi_t+=1
		if wy.wudi_t>20 then
			wy.ishurt,wy.wudi_t=false,0
		end
	end
	updatep_state(wy)
	wy.cx=wy.x+1
	wy.cy=wy.y+3
	--创建敌人组
	for e in all(enemies) do
		local t={["urchin"]=enstate_urchin,["crab"]=enstate_4direcmove,["slime"]=enstate_slime,["spider"]=enstate_4direcmove,["lizi"]=enstate_lizi,["snake"]=enstate_4direcmove}
		t[e.name](e)
		--主角受伤检测（无敌时间0，主角不在攻击状态）
		if check_p_hurt(wy,"en",e) and wy.wudi_t==0 and wy.state!=wy.allstate.attack then --检测玩家受伤
			wy.ishurt,wy.state=true,wy.allstate.hurt
		end
	end
	--敌人子弹的检测
	for b in all(bullets) do
		firebullet(b)--开火
		--玩家受伤
		if check_p_hurt(wy,"bu",b) and wy.wudi_t==0 and wy.state!=wy.allstate.attack then --检测玩家受伤
			wy.ishurt,wy.state=true,wy.allstate.hurt
			del(bullets,b)
		end
		--如果子弹越过屏幕
		if cnut.x>128 or cnut.x<0 or cnut.y>100 or cnut.y<0 then
			del(bullets,b)
		end
	end
end
function update_mamenu()--菜单
	creatobj()
	blinkt+=1
	wy,sword=init_player(),init_sword()  -- 初始化武器
	input_mamenu()--主菜单输入
end
function update_gover()--游戏结束
	--游戏结束
	if btnp(4) and time()>5 then
		enemies,obj,can_create_obj={},{},true--人物死亡后,清空对象组\敌人组,创建对象权限打开
		_upd,_drw=update_mamenu,draw_mamenu
	end
end