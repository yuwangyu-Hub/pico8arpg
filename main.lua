--战斗系统：敌人追逐、敌人攻击、敌人受伤弹开、技能系统、boss战
--背包系统(武器系统\道具系统)
--地图切换系统（不规则地图）
--对话系统
--UI系统
--寻路算法（不确定）:暂且不要
--敌人死亡掉落：金币、血量
--割草掉落：金币、血量
--获得增益道具后的边缘闪烁
--------------当前任务-------------------
--*敌人受伤后退
--*敌人之间的碰撞:通过移动算法（移动方向位置上无角色）实现敌人之间的碰撞。但是当被动的移动后（玩家的盾弹）可重叠
input_dire=explodeval("0,1,5,0,3,2,4,3,7,8,6,7,0,1,5,0")--btn()0-15所对应的方向：从左边开始顺时针8方向
dirx=explodeval("-1,-1, 0, 1,1,1, 0,-1")
diry=explodeval(" 0,-1,-1,-1,0,1, 1, 1")
          --1,     2,     3,     4,      5,      6,     7,      8
atdirex=explodeval("40,40,43,46,46,46,42,40")--sspr攻击图标的xy
atdirey=explodeval("10, 8, 8, 8,11,14,14,14")--sspr攻击图标的xy
enemies={}--敌人
character={} --NPC
item={}--物品：获取
obj={}--物体：分为两种，可推动的物体和不可推动的物体
cb_line={}--碰撞盒
debug=""
debug1=""
function _init()
	startgame()
	wy = initializeplayer()  -- 初始化玩家
	sword = initializesword()  -- 初始化武器
end
function _update() 
	_upd()
end
function _draw()
	cls(2)
	_drw()
	printbug()
end
function startgame()
	_upd=update_mamenu
	_drw=draw_mamenu
	mainmenu_cursor={count=1,x=64,y=90,spr=79}--menu光标
	blinkt=0
end
function printbug()
	print(wy.state,60,2,7)
	print(wy.dire)
	print(wy.lastdire)
	print("x:"..wy.x)
	print("y:"..wy.y)
	--print("spdx:"..wy.spd.spx)
	--print("spdy:"..wy.spd.spy)
	--print("dire:"..wy.dire)
	print("debug:"..debug)
	--print("debug1:"..debug1)
end