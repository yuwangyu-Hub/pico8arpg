--dev
--敌人追踪系统
--翻滚粒子特效

function _init()
	playerdata()
	
end

function _update()
	--墙壁检测
	checkwall(wy)
	--主角的行为
	--wy_act(wy)
	wyfsm()
end



function _draw()
	cls(3)--屏幕颜色

	--攻击武器动画
	if wy.att then
		--draweapon(wy)
	end

	--主角精灵显示
	spr(wy.aniframe, wy.x, wy.y, 1, 1,wy.sprflip)--sb spr

	print(wy.state)
	print(ceil(wy.t%#wy.animsprs.roll))
	--UI显示
	--ui()
	if wy.state == wy.allstate.attack then
		weapon()
	end
	
end



