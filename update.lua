function update_game()
	wyfsm(wy)--主角的行为
	--chase(snake,wy)
	spr_flip(wy)
	if checkhurt(wy) then
		wy.state=wy.allstate.hurt
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

function checkhurt(_sb)--检测玩家受伤
	local _ishurt
	for e in all(enemies) do
		_sb.hurtdire=checkdir(e,_sb)
		_ishurt = coll_boxcheck(_sb.x,_sb.y,_sb.w,_sb.h,e.x,e.y,e.w,e.h)
	end
	return _ishurt
end

function hurtmove(_sb)
	if _sb.hurtdire==1 then

	elseif  _sb.hurtdire==2 then

	elseif  _sb.hurtdire==3 then

	elseif  _sb.hurtdire==4 then

	elseif  _sb.hurtdire==5 then

	elseif  _sb.hurtdire==6 then

	elseif  _sb.hurtdire==7 then

	elseif  _sb.hurtdire==8 then

	end
end
