--项目目标实现：
--战斗系统
--背包系统
  --武器系统
  --道具系统
--技能系统
--boss战（1个）
--地图切换系统（不规则地图）
--对话系统
--UI系统
------------------------------------------------------------
input_dire={0,1,5,0,3,2,4,3,7,8,6,7,0,1,5,0 } --btn()0-15所对应的方向：从左边开始顺时针8方向
dirx={-1,-1, 0, 1,1,1, 0,-1}
diry={ 0,-1,-1,-1,0,1, 1, 1}
character={} --敌人和NPC
item={}--物品：获取
obj={}--物体：分为两种，可推动的物体和不可推动的物体
cb_line={}--碰撞盒

px1,py1,px2,py2=0,0,0,0
iscoll=false
debug=""
debug1=""
debug2=""
debug3=""
function _init()
	startgame()
	playerdata()
	sword()
	makeobj(1,100,80,7,7,0,0,0,0)--wood
	makeobj(2,64,64,8,8,0,0,0,0)--box
	makeobj(3,32,64,8,8,0,0,0,0)--coin
	
	--enemydata()
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
	--menu光标
	mainmenu_cursor={
		count=1,
		x=64,
		y=90,
		spr=112
	}
	blinkt=0
end
function printbug()
	print(wy.state,20,2,7)
	print("dire:"..wy.dire)
	print("spd:"..wy.speed)
	print(debug)
	print(debug1)
	print(iscoll)
	print(wy.spd.spx)
	print(wy.spd.spy)
	
	--[[
	if #cb_line>0 then
		print(cb_line[1].num,1,20,1)
		print(cb_line[1].coll,10,20,1)
		print(cb_line[2].num,1,30,1)
		print(cb_line[2].coll,10,30,1)
		print(cb_line[3].num,1,40,1)
		print(cb_line[3].coll,10,40,1)
		print(cb_line[4].num,1,50,1)
		print(cb_line[4].coll,10,50,1)
	end]]

	
end







