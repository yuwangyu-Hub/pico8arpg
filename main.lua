--战斗系统：敌人追逐、敌人攻击、敌人受伤弹开、技能系统、boss战
--背包系统(武器系统\道具系统)
--地图切换系统（不规则地图）
--对话系统
--UI系统
--寻路算法（不确定）
--敌人死亡掉落：金币、血量
--割草掉落：金币、血量、

--------------当前任务-------------------
--*BUG翻滚遇敌受伤弹回
--*受伤后弹回穿墙
--*敌人对主角的碰撞
--*敌人之间的碰撞？
input_dire={0,1,5,0,3,2,4,3,7,8,6,7,0,1,5,0 } --btn()0-15所对应的方向：从左边开始顺时针8方向
dirx={-1,-1, 0, 1,1,1, 0,-1} 
diry={ 0,-1,-1,-1,0,1, 1, 1} 
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
	mainmenu_cursor={count=1,x=64,y=90,spr=112}--menu光标
	blinkt=0
end
function printbug()
	print(wy.hurtdire,60,2,7)
	print(wy.state)
	print(wy.dire)
	--print("x:"..wy.x)
	--print("y:"..wy.y)
	print("spdx:"..wy.spd.spx)
	print("spdy:"..wy.spd.spy)
	--print("dire:"..wy.dire)
	print("debug:"..debug)
	--print("debug1:"..debug1)
end