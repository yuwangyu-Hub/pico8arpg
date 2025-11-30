--技能系统、/背包系统(武器系统\道具系统)/对话系统--
--------------当前任务-------------------
--*debug：玩家受伤后，移动方向有几率为0的bug
--*一定几率受伤后，翻滚速度变慢bug:当翻滚受伤之后，再翻滚
--*敌人死亡几率掉落:金币、回血、增益道具
--*割草掉落：金币、回血、增益道具
--*获得增益道具后的边缘闪烁
--*场景地图切换
--*特效：移动粒子
chaname,chahp,chaspd,chalastdire,chacrange={"player","urchin","crab","spider","slime","lizi"},explodeval("8,1,1,1,1,2"),{1,0,.5,.5,.5,.5},explodeval("5,0,5,5,5,3"),explodeval("0,0,0,0,25,20")
----------------------------------------------
atdirex,atdirey=explodeval("40,40,43,46,46,46,42,40"),explodeval("10,8,8,8,11,14,14,14")--sspr攻击icon的x/y
input_dire=explodeval("0,1,5,0,3,2,4,3,7,8,6,7,0,1,5,0")--btn()0-15所对应的方向：从左边开始顺时针8方向
dirx,diry=explodeval("-1,-1,0,1,1,1,0,-1"),explodeval("0,-1,-1,-1,0,1,1,1")
enemies,item,bullets,obj={},{},{},{}
en_dspr=explodeval("124,125,126,127")--敌人死亡
mapnum=explodeval("[80,16],[96,16],[112,16],[80,0],[96,0],[112,0],[48,16],[64,16],[48,0],[64,0]")--地图编号】

--cb_line={}--碰撞盒
debug=""
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
	print(wy.sprflip)
	print(wy.dire)

end