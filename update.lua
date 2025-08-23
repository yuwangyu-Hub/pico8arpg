function update_game()
	check_map_sth()
	updatePlayerState(wy)--主角的行为: 更新玩家状态
	--chase(snake,wy)
	spr_flip(wy)
	
	
	if check_p_hurt(wy) and wy.wudi_t==0 then --检测玩家受伤
		wy.ishurt=true
		wy.state=wy.allstate.hurt
	end
	if wy.ishurt then wy.wudi_t+=1 end
	if wy.wudi_t>20000 then 
		wy.ishurt=false
		wy.wudi_t=0 
	end
	if check_en_hurt() then--检测敌人受伤
		--debug="en_hurt"
	end
end
function update_mamenu()
	blinkt+=1
	input_mamenu()--主菜单
end
function update_gover()
end
function update_win()
end

