function update_game()
	wyfsm(wy)--主角的行为
	--chase(snake,wy)
	spr_flip(wy)
end
function jishi()
	local t=0
	t+=1
	return t
end
function update_mamenu()
	blinkt+=1
	input_mamenu()--主菜单
end
function update_gover()
end
function update_win()
end