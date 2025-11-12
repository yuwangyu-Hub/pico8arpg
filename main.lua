--技能系统、/背包系统(武器系统\道具系统)/对话系统--
--------------当前任务-------------------
--*史莱姆的穿墙bug
--*蝙蝠的受伤被墙挡住的bug
--*boss
--*敌人的影子
--*debug：玩家受伤后，移动方向有几率为0的bug
--*一定几率受伤后，翻滚速度变慢bug:当翻滚受伤之后，再翻滚
--*敌人死亡几率掉落:金币、回血、增益道具
--*割草掉落：金币、回血、增益道具
--*获得增益道具后的边缘闪烁
--*场景地图切换
--*翻滚衔接攻击:?可能有
--*特效：移动粒子
chaname={"player","urchin","snake","spider","slime","bat","ghost","lizi"}
chahp=explodeval("8,1,2,1,1,1,4,2")
chaspd={1,0,.5,.5,.5,1,.3,.5}
chalastdire=explodeval("5,0,5,5,5,5,5,3")
chacrange=explodeval("0,0,0,0,20,25,10,20")

atdirex=explodeval("40,40,43,46,46,46,42,40")--sspr攻击icon的x
atdirey=explodeval("10,8,8,8,11,14,14,14")--sspr攻击icon的y
input_dire=explodeval("0,1,5,0,3,2,4,3,7,8,6,7,0,1,5,0")--btn()0-15所对应的方向：从左边开始顺时针8方向
dirx,diry=explodeval("-1,-1,0,1,1,1,0,-1"),explodeval("0,-1,-1,-1,0,1,1,1")
enemies,character,item,cb_line={}
en_dspr=explodeval("85,86,87,88")--敌人死亡
bullets={}--子弹,敌人所有可发射的物体
obj={}--物体：分为两种，可推动的物体和不可推动的物体
--cb_line={}--碰撞盒
debug=""
debug1=""
--debug2=""
function _init()
	startgame()
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
	_upd,_drw=update_mamenu,draw_mamenu
	mainmenu_cursor={count=1,x=64,y=90,spr=79}--menu光标
	blinkt=0
end

function printbug()
	--print(debug,10,10,10)
	print(debug1,10,40,10)
	if enemies[1] then
		print(enemies[1].hp,10,60,10)
	end
end