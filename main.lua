--战斗系统：敌人追逐、技能系统、boss战
--背包系统(武器系统\道具系统)
--地图切换系统（不规则地图）
--对话系统
--UI系统
--敌人死亡掉落：金币、血量
--割草掉落：金币、血量
--获得增益道具后的边缘闪烁
--------------当前任务-------------------
--*debug:玩家受伤后不后退
--*debug：玩家受伤后，移动方向bug
--*史莱姆AI和动画
--*敌人受伤后退，会穿越其他敌人的bug
--*bug一次攻击只能伤害敌人一次
--*优化：大量的全局时间，修改为局部时间
--*一定几率受伤后，翻滚速度变慢bug:当翻滚受伤之后，再翻滚
--*敌人死亡后一定几率掉落血袋
--*敌人动画系统：整合
--*翻滚衔接攻击:?可能有
--*特效：移动粒子
input_dire=explodeval("0,1,5,0,3,2,4,3,7,8,6,7,0,1,5,0")--btn()0-15所对应的方向：从左边开始顺时针8方向
dirx=explodeval("-1,-1, 0, 1,1,1, 0,-1")
diry=explodeval(" 0,-1,-1,-1,0,1, 1, 1")
          --1,     2,     3,     4,      5,      6,     7,      8
atdirex=explodeval("40,40,43,46,46,46,42,40")--sspr攻击图标的xy
atdirey=explodeval("10, 8, 8, 8,11,14,14,14")--sspr攻击图标的xy
enemies={}--敌人
en_dspr=explodeval("85,86,87,88")--敌人死亡
character={} --NPC
item={}--物品：获取
obj={}--物体：分为两种，可推动的物体和不可推动的物体
cb_line={}--碰撞盒
debug=""
debug1=""
debug2=""
debug3=""
debug4=""
debug5=""
debug6=""


function _init()
	startgame()
	enstate_slime = create_enstate_slime()
	enstate_snake = create_enstate_snake()
	enstate_urchin = create_enstate_urchin()
	enstate_bat = create_enstate_bat()
end
function _update() 
	_upd()
end
function _draw()
	cls()
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
	print(debug,10,10,5)
	print(debug1,10,20,10)
	print(debug2,10,30,10)
	print(debug3,10,40,11)
	print(debug4,10,50,11)
	print(debug5,10,60,10)
	print(debug6,10,70,10)
end
