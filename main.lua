--战斗系统：敌人追逐、敌人攻击、敌人受伤、技能系统、boss战
--背包系统(武器系统\道具系统)
--地图切换系统（不规则地图）
--对话系统
--UI系统
--------------当前任务-------------------
--物体之间的碰撞（可能做）
--物体边缘滑动穿墙
------------------------------------------------------------
input_dire={0,1,5,0,3,2,4,3,7,8,6,7,0,1,5,0 } --btn()0-15所对应的方向：从左边开始顺时针8方向
dirx={-1,-1, 0, 1,1,1, 0,-1} 
diry={ 0,-1,-1,-1,0,1, 1, 1} 
enemies={}--敌人
character={} --NPC
item={}--物品：获取
obj={}--物体：分为两种，可推动的物体和不可推动的物体
near_o=nil--最近物品
cb_line={}--碰撞盒
iscollFlip=false --是否碰撞翻转
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
	mainmenu_cursor={--menu光标
		count=1,x=64,y=90,spr=112}
	blinkt=0
end
function printbug()
	print(wy.state,60,2,7)
	--print("x:"..wy.x)
	--print("y:"..wy.y)
	--print("spdx:"..wy.spd.spx)
	--print("spdy:"..wy.spd.spy)
	--print("dire:"..wy.dire)
	--print("debug:"..debug)
	--print("debug1:"..debug1)
	
end