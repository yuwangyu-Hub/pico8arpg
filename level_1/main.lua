--1urchin 2crab 3spider 4slime 5lizi 6snake
map1,map2,map3,map4,map5,map6,map7,map8,map9,map10=explodeval("[44,36,1],[80,60,2],[108,80,2]"),explodeval("[68,24,1],[34,88,2],[48,40,2]"),explodeval("[8,48,2],[48,40,2]"),explodeval("[48,40,4],[28,80,6],[96,80,2]"),explodeval("[24,72,4],[56,32,3],[96,56,6]"),explodeval("[16,48,4],[88,32,5],[96,80,2]"),explodeval("[32,32,6],[24,88,5],[104,72,4]"),explodeval("[24,56,5],[80,80,6],[88,24,4]"),explodeval("[24,40,6],[104,104,4]"),explodeval("[24,80,6],[88,72,4]")
maps={map1,map2,map3,map4,map5,map6,map7,map8,map9,map10}
chaname,chahp,chaspd,chalastdire,chacrange={"player","urchin","crab","spider","slime","lizi","snake"},explodeval("3,1,1,1,1,2,2"),{1,0,.5,.5,.5,.5,.5},explodeval("5,0,5,5,5,3,5"),explodeval("0,0,0,0,25,20,0")
--sspr攻击朝向icon的x/y，3x3
atdirex=explodeval("21, 8,17,13,21,13,17,8")
atdirey=explodeval("29,24,24,24,24,29,29,29")

dirx,diry=explodeval("-1,-1,0,1,1,1,0,-1"),explodeval("0,-1,-1,-1,0,1,1,1")
input_dire=explodeval("0,1,5,0,3,2,4,3,7,8,6,7,0,1,5,0")--btn()0-15所对应的方向：从左边开始顺时针8方向
enemies,item,bullets,obj,en_dspr={},{},{},{},explodeval("57,58,59,60")
mapnum=explodeval("[80,16],[96,16],[112,16],[80,0],[96,0],[112,0],[48,16],[64,16],[48,0],[64,0],[16,0],[32,0]")--地图编号(),最后两个是地下洞穴
can_create_obj=true
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
	print(wy.y,10,20,7)
end
function creatobj()
	if can_create_obj then --限制后，只创建一次
		makeobj(1,30,60,6)--创建心之容器
		makeobj(1,40,40,10)--创建心之容器
		makeobj(2,96,32,3)--创建剑
		can_create_obj=false
	end
end