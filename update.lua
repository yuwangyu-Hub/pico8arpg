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

function direhurt(_sb)--依照方向执行受伤
	local m_spd=1
	_sb.hurtmt+=0.1
	if _sb.hurtdire==1 then
		_sb.spd.spx=m_spd
		_sb.spd.spy=0
		if _sb.hurtmt>=0.7 then
			_sb.hurtmt=0
			_sb.spd.spx=0
			_sb.spd.spy=0
			_sb.state=_sb.allstate.idle
		end
	elseif  _sb.hurtdire==2 then
		--_sb.hurtmt+=0.1
		_sb.spd.spx=-m_spd
		_sb.spd.spy=-m_spd
		if _sb.hurtmt>=0.7 then
			_sb.hurtmt=0
			_sb.spd.spx=0
			_sb.spd.spy=0
			_sb.state=_sb.allstate.idle
		end
	elseif  _sb.hurtdire==3 then
		--_sb.hurtmt+=0.1
		_sb.spd.spx=0
		_sb.spd.spy=m_spd
		if _sb.hurtmt>=0.7 then
			_sb.hurtmt=0
			_sb.spd.spx=0
			_sb.spd.spy=0
			_sb.state=_sb.allstate.idle
		end
	elseif  _sb.hurtdire==4 then
		--_sb.hurtmt+=0.1
		_sb.spd.spx=m_spd
		_sb.spd.spy=-m_spd
		if _sb.hurtmt>=0.7 then
			_sb.hurtmt=0
			_sb.spd.spx=0
			_sb.spd.spy=0
			_sb.state=_sb.allstate.idle
		end
	elseif  _sb.hurtdire==5 then
		--_sb.hurtmt+=0.1
		_sb.spd.spx=-m_spd
		_sb.spd.spy=0
		if _sb.hurtmt>=0.7 then
			_sb.hurtmt=0
			_sb.spd.spx=0
			_sb.spd.spy=0
			_sb.state=_sb.allstate.idle
		end
	elseif  _sb.hurtdire==6 then
		--_sb.hurtmt+=0.1
		_sb.spd.spx=m_spd
		_sb.spd.spy=m_spd
		if _sb.hurtmt>=0.7 then
			_sb.hurtmt=0
			_sb.spd.spx=0
			_sb.spd.spy=0
			_sb.state=_sb.allstate.idle
		end
	elseif  _sb.hurtdire==7 then
		--_sb.hurtmt+=0.1
		_sb.spd.spx=0
		_sb.spd.spy=-m_spd
		if _sb.hurtmt>=0.7 then
			_sb.hurtmt=0
			_sb.spd.spx=0
			_sb.spd.spy=0
			_sb.state=_sb.allstate.idle
		end
	elseif  _sb.hurtdire==8 then
		--_sb.hurtmt+=0.1
		_sb.spd.spx=-m_spd
		_sb.spd.spy=m_spd
		if _sb.hurtmt>=0.7 then
			_sb.hurtmt=0
			_sb.spd.spx=0
			_sb.spd.spy=0
			_sb.state=_sb.allstate.idle
		end
	end
end

function hurtmove()

end
