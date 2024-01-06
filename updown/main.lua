--dev
--受伤系统
--翻滚粒子特效
function _init()
	playerdata()
	--enemydata()
	
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
	--海水颜色
	cls(12)
	--地板颜色
	rectfill(0,32,128,128,13)

	--主角精灵显示
	spr(wy.aniframe, wy.x, wy.y, 1, 1,wy.sprflip)--sb spr

	--敌人蛇 
	--spr(48,snake.x,snake.y)

	--木人桩
	spr(wood.aniframe,wood.x,wood.y)


	print(wy.state)
	print(wy.dire)
	print(attackboxcheck(wy,wood,8,8,8,8))
	--UI显示
	--ui()
	
	--攻击时候的武器绘制
	if wy.state == wy.allstate.attack then
		attacksword()
	end

end



