--*缩小玩家的碰撞
--*血量绘制
--*钥匙
--*地洞路线
--*敌人弹出画面
--*玩家切换受伤：敌人位置调整
--*debug：玩家受伤后，移动方向有几率为0的bug
--*一定几率受伤后，翻滚速度变慢bug:当翻滚受伤之后，再翻滚
--*敌人死亡几率掉落:回血道具
--*割草+掉落回血、增益道具
--en：1：urchin 2：crab 3：spider 4:slime 5：lizi 6:snake 7:bat 8:ghost
map1=explodeval("[80,60,2],[108,80,2]")--x,y,type
map2=explodeval("[34,88,2],[48,40,2],[112,72,1]")
map3=explodeval("[8,48,2],[48,40,2]")
map4=explodeval("[48,40,4],[48,40,4],[96,80,2]")
map5=explodeval("[24,72,4],[56,32,3],[96,56,4]")
map6=explodeval("[16,48,4],[88,32,2],[96,80,2]")
map7=explodeval("[32,32,4],[24,88,4],[104,72,4]")
map8=explodeval("[24,56,4],[80,80,4],[88,24,4]")
map9=explodeval("[24,40,4],[104,104,4]")
map10=explodeval("[24,80,4],[88,72,4]")
maps={map1,map2,map3,map4,map5,map6,map7,map8,map9,map10}
chaname={"player","urchin","crab","spider","slime","lizi","snake","bat","ghost"}
chahp=explodeval("3,1,1,1,1,2,2,1,2")
chaspd={1,0,.5,.5,.5,.5,.5,1,.3}
chalastdire=explodeval("5,0,5,5,5,3,5,5,5")
chacrange=explodeval("0,0,0,0,25,20,0,20,10")
-----
atdirex,atdirey=explodeval("40,40,43,46,46,46,42,40"),explodeval("10,8,8,8,11,14,14,14")--sspr攻击icon的x/y
input_dire=explodeval("0,1,5,0,3,2,4,3,7,8,6,7,0,1,5,0")--btn()0-15所对应的方向：从左边开始顺时针8方向
dirx,diry=explodeval("-1,-1,0,1,1,1,0,-1"),explodeval("0,-1,-1,-1,0,1,1,1")
enemies,item,bullets,obj={},{},{},{}
en_dspr=explodeval("57,58,59,60")--dead
mapnum=explodeval("[80,16],[96,16],[112,16],[80,0],[96,0],[112,0],[48,16],[64,16],[48,0],[64,0],[0,16],[16,16],[32,16]")--地图编号()
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
	mainmenu_cursor={count=1,x=64,y=90,spr=53}--menu光标
	blinkt=0
end
function printbug()

end