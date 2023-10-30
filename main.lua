--主框架

--动画系统
--攻击制作
--翻滚粒子特效

function _init()

	--主角
	wy=makerole()
	wy.x=60
	wy.y=60
	wy.spx=0
	wy.spy=0
	wy.speed=1.3
	wy.rollspeed=8

	wy.move_t=0
	wy.roll_t=0
	wy.att_t=0

	wy.aniframe=2
	--精灵动画的表
	wy.animsprs={
		idle=2,
		move={1,2,3,4},
		roll={5,5,6,6,7,7,8,8},
		attack={9,10,11}
	}
	wy.att=false--if attack
	wy.dire=0
end

function _update()
	--墙壁检测
	checkwall(wy)
	--主角的行为
	wy_act(wy)
end



function _draw()
	cls(3)--屏幕颜色

	--攻击武器动画
	if wy.att then
		--draweapon(wy)
	end

	--动画播放
	wy_anim(wy)

	--UI显示
	--ui()

	--[[--测试用八方向显示
	if not wy.roll then
		draw_direct_sys(wy)
	end--]]
end



