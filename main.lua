--7640
--技能系统、boss战/背包系统(武器系统\道具系统)/地图切换系统（不规则地图）/对话系统/敌人死亡掉落：金币、血量
--割草掉落：金币、血量/获得增益道具后的边缘闪烁
--------------当前任务-------------------
--*d token d chars
--*史莱姆的穿墙bug+蝙蝠的受伤被墙挡住的bug
--完成所有敌人ai系统
--*敌人的影子
--*debug：玩家受伤后，移动方向有几率为0的bug
--*优化：一次攻击只能伤害敌人一次
--*一定几率受伤后，翻滚速度变慢bug:当翻滚受伤之后，再翻滚
--*敌人死亡后一定几率掉落血袋
--*翻滚衔接攻击:?可能有
--*特效：移动粒子
input_dire=explodeval("0,1,5,0,3,2,4,3,7,8,6,7,0,1,5,0")--btn()0-15所对应的方向：从左边开始顺时针8方向
dirx=explodeval("-1,-1, 0, 1,1,1, 0,-1")
diry=explodeval(" 0,-1,-1,-1,0,1, 1, 1")
                  --1, 2, 3, 4, 5, 6, 7, 8
atdirex=explodeval("40,40,43,46,46,46,42,40")--sspr攻击icon的x
atdirey=explodeval("10, 8, 8, 8,11,14,14,14")--sspr攻击icon的y
enemies={}--敌人
en_dspr=explodeval("85,86,87,88")--敌人死亡
character={} --NPC
item={}--物品：获取
obj={}--物体：分为两种，可推动的物体和不可推动的物体
cb_line={}--碰撞盒
debug=""
--debug1=""
--debug2=""
function _init()
	startgame()
	--enstate_lizi = create_enstate_lizi()
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
	print(debug,10,10,10)
end
