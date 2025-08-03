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
--敌人系统：敌人的受伤
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
debug2=""
debug3=""

--[[
	l_px1=0 l_py1=0 l_px2=0 l_py2=0 d_px1=0 d_py1=0 d_px2=0 d_py2=0 
	r_px1=0 r_py1=0 r_px2=0 r_py2=0 u_px1=0 u_py1=0 u_px2=0 u_py2=0
w_collx1=0 w_colly1=0 w_collx2=0 w_colly2=0 w_collx3=0 w_colly3=0 w_collx4=0 w_colly4=0 
w_collx5=0 w_colly5=0 w_collx6=0 w_colly6=0 w_collx7=0 w_colly7=0 w_collx8=0 w_colly8=0]]

function _init()
	startgame()
	wy = initializeplayer()  -- 初始化玩家
	sword = initializesword()  -- 初始化武器
end
function _update() 
	_upd()
	--[[
	l_px1=wy.x-1
	l_py1=wy.y+3
	l_px2=wy.x-1
	l_py2=wy.y+4
	d_px1=wy.x+4
	d_py1=wy.y+8
	d_px2=wy.x+3
	d_py2=wy.y+8
	r_px1=wy.x+8
	r_py1=wy.y+3
	r_px2=wy.x+8
	r_py2=wy.y+4
	u_px1=wy.x+4
	u_py1=wy.y-1
	u_px2=wy.x+3
	u_py2=wy.y-1
	
	w_collx1=wy.x-1
	w_colly1=wy.y
	w_collx2=wy.x-1
	w_colly2=wy.y+7
	w_collx3=wy.x
	w_colly3=wy.y+8
	w_collx4=wy.x+7
	w_colly4=wy.y+8
	w_collx5=wy.x+8
	w_colly5=wy.y+7
	w_collx6=wy.x+8
	w_colly6=wy.y
	w_collx7=wy.x+7
	w_colly7=wy.y-1
	w_collx8=wy.x
	w_colly8=wy.y-1]]
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
		count=1,
		x=64,
		y=90,
		spr=112
	}
	blinkt=0
end
function printbug()
	print(wy.state,20,2,7)
	print(wy.dire)
	print(debug)
end