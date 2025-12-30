--*黑洞掉落
--*敌人受伤方向改成4方向而不是8方向
--*缩小玩家的碰撞
--*钥匙
--*地下洞穴路线
--*敌人弹出画面bug
--*玩家切换受伤：敌人位置调整?
--*一定几率受伤后，翻滚速度变慢bug:当翻滚受伤之后，再翻滚
--1urchin 2crab 3spider 4slime 5lizi 6snake 7bat 8ghost
map1,map2,map3,map4,map5,map6,map7,map8,map9,map10=explodeval("[44,36,1],[80,60,2],[108,80,2]"),explodeval("[68,24,1],[34,88,2],[48,40,2]"),explodeval("[8,48,2],[48,40,2]"),explodeval("[48,40,4],[28,80,6],[96,80,2]"),explodeval("[24,72,4],[56,32,3],[96,56,6]"),explodeval("[16,48,4],[88,32,5],[96,80,2]"),explodeval("[32,32,6],[24,88,5],[104,72,4]"),explodeval("[24,56,5],[80,80,6],[88,24,4]"),explodeval("[24,40,6],[104,104,4]"),explodeval("[24,80,6],[88,72,4]")
maps={map1,map2,map3,map4,map5,map6,map7,map8,map9,map10}
chaname,chahp,chaspd,chalastdire,chacrange={"player","urchin","crab","spider","slime","lizi","snake","bat","ghost"},explodeval("3,1,1,1,1,2,2,1,2"),{1,0,.5,.5,.5,.5,.5,1,.3},explodeval("5,0,5,5,5,3,5,5,5"),explodeval("0,0,0,0,25,20,0,20,10")
--sspr攻击朝向icon的x/y
atdirex,atdirey,dirx,diry=explodeval("40,40,43,46,46,46,42,40"),explodeval("10,8,8,8,11,14,14,14"),explodeval("-1,-1,0,1,1,1,0,-1"),explodeval("0,-1,-1,-1,0,1,1,1")
input_dire=explodeval("0,1,5,0,3,2,4,3,7,8,6,7,0,1,5,0")--btn()0-15所对应的方向：从左边开始顺时针8方向
enemies,item,bullets,obj,en_dspr={},{},{},{},explodeval("57,58,59,60")
mapnum=explodeval("[80,16],[96,16],[112,16],[80,0],[96,0],[112,0],[48,16],[64,16],[48,0],[64,0],[0,16],[16,16],[32,16]")--地图编号()
--cb_line={}--碰撞盒
--debug=""
function _init()
	makeobj(2,96,32)--创建剑
	makeobj(1,40,40)--创建心之容器
	startgame()
end
function _update()    
	_upd()
end
function _draw()
	cls()
	_drw()
	--printbug()
end
function startgame()
	_upd,_drw=update_mamenu,draw_mamenu
	mainmenu_cursor={count=1,x=64,y=90,spr=53}--menu光标
	blinkt=0
end

--function printbug()	
--end
