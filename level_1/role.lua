--makerole(name,x,y,hp,speed,sprs,state)--角色的创建模板
function makerole(cha_tpye,x,y,sprs,state)--角色的创建模板
	local role={}
	role.name=chaname[cha_tpye]
	role.x,role.y,role.w,role.h=x*8,y*8,7,7
	role.hp,role.speed,role.crange,role.lastdire=chahp[cha_tpye],chaspd[cha_tpye],chacrange[cha_tpye],chalastdire[cha_tpye]
	role.dire,role.allstate,role.sprs=3,state,sprs
	role.spd={spx=0,spy=0} --加速度
	role.hurtdire=1 --初始受伤方向?有疑问
	 --受伤后的移动时间
	role.frame=type(sprs.idle)=="number" and sprs.idle or sprs.idle[1]
	role.state=state.idle
	role.sprflip=false
	role.idle_t,role.wudi_t,role.die_t,role.move_t=0,0,0,0
	return role
end
-- 初始化玩家数据
-- @return 玩家对象
function init_player()
	local player = makerole(1,7,7,
		{idle = 2, --  idle状态精灵
		move=explodeval("1,2,3,4"), -- 移动状态精灵序列
		push=explodeval("13,15,13,14"), -- 推动状态精灵序列 (1(1), 2(3), 3(5), 4())
		roll=explodeval("5,6,6,7,7,5"), -- 翻滚状态精灵序列
		       -- 3, 2/4, 1/5, 6/8, 7
		attack=explodeval("8,9,10,11,12"), -- 攻击状态精灵序列
		fall=explodeval("24,25,26"),
		death=explodeval("27,28,29"),
		hurt=explodeval("22,40"), -- 受伤状态精灵		
		get=23 -- 获取物品状态精灵（只一次）
		},
		{idle="idle",--在状态机中，识别为字符串
		move="move",
		attack="attack",
		jump="jump",
		archery="archery",
		roll="roll",
		push="push",
		hurt="hurt",
		death="death"})
	-- 玩家状态常量
	player.spr_cx,player.spr_cy=0,0--精灵和真正坐标位置的差值
	player.curhp=6--当前血量
	player.move_t=0--用来绘制移动动画
	player.ishurt=false
	player.hurtmt=0
	player.isroll = false -- 是否翻滚
	player.rollspeed = 3 -- 翻滚速度
	player.roll_t = 0 -- 翻滚计时器
	player.isclosewall=false--是否靠近墙壁(翻滚时)
	player.isattack = false -- 是否攻击
	player.att_t = 0 -- 攻击计时器
	player.mappos=1--地图位置编号
	return player
end
-- 初始化武器数据 武器对象
function init_sword()
	sword={}
	sword.x,sword.y,sword.w,sword.h=0,0,7,7
	sword.sprx,sword.spry=explodeval("-7,-6,2,8,8,8,2,-6"),explodeval("2,-6,-7,-6,2,8,8,8")	 --1 2 3 4 5 6 7 8
	sword.isappear = false -- 是否显示
	return sword
end
function createnemy_urchin(_x,_y)
	local urchin = makerole(2,_x,_y,
		{idle=64,
		hurt={64,65}},
		{idle = "idle",
		hurt="hurt",
		death = "death"})
	add(enemies,urchin)
	return urchin
end
function createnemy_crab(_x,_y)
	local crab = makerole(3,_x,_y,
		{idle=66,
		move={66,67},
		hurt={66,68}},
		{idle = "idle",
		move = "move",
		hurt="hurt",
		death = "death"})
	add(enemies,crab)
	return crab
end
function createnemy_spider(_x,_y)
	local spider = makerole(4,_x,_y,
		{idle=70,
		move={69,70},
		hurt={70,71}},
		{idle = "idle",
		move = "move",
		hurt="hurt",
		death = "death"})
	add(enemies,spider)
	return spider
end
function createnemy_slime(_x,_y)
	local slime = makerole(5,_x,_y,
		{idle={80,81},
		charge={82,83},
		jump=84,
		hurt={80,85}},
		{idle = "idle",
		charge="charge",--跳跃前的蓄力
		jump = "jump",
		hurt="hurt",
		death="death"})
	add(enemies,slime)
	return slime
end
function createnemy_lizi(_x,_y)
	local lizi = makerole(6,_x,_y,
		{idle={72,74,76},
		move=explodeval("[76,77],[72,73],[76,77],[74,75]"),--1357
		hurt=explodeval("[76,92],[72,88],[76,92],[74,90]")--1357
		},
		{idle = "idle",
		move = "move",
		atk="atk",
		hurt="hurt",
		death = "death"})
	lizi.atk_t,lizi.hurtframe=0,0
	add(enemies,lizi)
	return lizi
end
function init_cnut(en)--栗子弹
	cnut={}
	cnut.x,cnut.y,cnut.w,cnut.h,cnut.t,cnut.dire,cnut.spd,cnut.speed,cnut.sprs,cnut.frame=en.x,en.y,5,5,0,en.dire,{spx=0,spy=0},1,explodeval("96,97,98,99"),96
	add(bullets,cnut)
	return cnut
end
--大海龟Boss：两阶段
