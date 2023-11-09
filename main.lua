--dev
--敌人追踪系统
--翻滚粒子特效
function _init()
	playerdata()
	enemydata()
	
end

function _update()
	--墙壁检测
	checkwall(wy)
	--主角的行为
	--wy_act(wy)
	wyfsm()
	--chase(snake,wy)
end

function _draw()
	cls()--屏幕颜色

	--攻击武器动画
	--if wy.att then
		--draweapon(wy)
	--end

	--主角精灵显示
	spr(wy.aniframe, wy.x, wy.y, 1, 1,wy.sprflip)--sb spr


	--敌人蛇
	--spr(48,snake.x,snake.y)


	print(wy.state)
	--UI显示
	--ui()
	

	--攻击时候的武器绘制
	if wy.state == wy.allstate.attack then
		attack()  
	end

end



