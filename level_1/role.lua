--makerole(name,x,y,hp,speed,sprs,state)--角色的创建模板
function makerole(cha_tpye,x,y,sprs,state)--角色的创建模板
	local role={}
	role.name=chaname[cha_tpye]
	role.x,role.y,role.w,role.h=x,y,7,7
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
	local player = makerole(1,54,70,
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
		get="get",
		hurt="hurt",
		death="death"})
	--player.spr_cx,player.spr_cy=0,0--精灵和真正坐标位置的差值
	player.curhp=6--当前血量
	player.is_s_scene,player.mappos=true,1--场景切换、地图位置编号
	player.ishurt,player.isroll,player.isclosewall,player.isattack=false,false,false,false
	player.getsth,player.getsowrd,player.get_t=false,false,0
	player.hurtmt,player.move_t,player.roll_t,player.att_t,player.rollspeed=0,0,0,0,3--受伤移动、绘制移动动画、翻滚计时、攻击计时、翻滚速度
	return player
end
-- 初始化武器数据 武器对象
function init_sword()
	sword={x=0,y=0,w=7,h=7,sprx=explodeval("-7,-6,2,8,8,8,2,-6"),spry=explodeval("2,-6,-7,-6,2,8,8,8")}--1 2 3 4 5 6 7 8
	sword.isappear = false -- 是否显示
	return sword
end
function createnemy_urchin(_x,_y)
	local urchin = makerole(2,_x,_y,
		{idle=137,
		hurt={137,138}},
		{idle = "idle",
		hurt="hurt",
		death = "death"})
	add(enemies,urchin)
	return urchin
end
function createnemy_crab(_x,_y)
	local crab = makerole(3,_x,_y,
		{idle=139,
		move={139,140},
		hurt={139,141}},
		{idle = "idle",
		move = "move",
		hurt="hurt",
		death = "death"})
	add(enemies,crab)
	return crab
end

function createnemy_spider(_x,_y)
	local spider = makerole(4,_x,_y,
		{idle=143,
		move={142,143},
		hurt={143,159}},
		{idle = "idle",
		move = "move",
		hurt="hurt",
		death = "death"})
	add(enemies,spider)
	return spider
end
function createnemy_slime(_x,_y)
	local slime = makerole(5,_x,_y,
		{idle={153,154},
		charge={155,156},
		jump=157,
		hurt={153,158}},
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
		{idle=explodeval("85,187,189"),
		move=explodeval("[189,190],[185,186],[189,190],[187,188]"),--1357
		hurt=explodeval("[189,175],[185,173],[189,175],[187,174]")--1357
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
	cnut.x,cnut.y,cnut.w,cnut.h,cnut.t,cnut.dire,cnut.spd,cnut.speed,cnut.sprs,cnut.frame=en.x,en.y,5,5,0,en.dire,{spx=0,spy=0},1,explodeval("169,170,171,172"),96
	add(bullets,cnut)
	return cnut
end

function createnemy_snake(_x,_y)
	local snake = makerole(7,_x,_y,
		{idle=64,
		move={64,65},
		hurt={64,66}},
		{idle = "idle",
		move = "move",
		hurt="hurt",
		death = "death"})
	add(enemies,snake)
	return snake
end

function createnemy_bat(_x,_y)
	local bat = makerole(8,_x,_y,
		{idle=67,
		fly={68,67},
		rest=67,
		hurt={68,69}},
		{idle = "idle",
		fly = "fly",
		rest="rest",
		hurt="hurt",
		death = "death"})
	add(enemies,bat)
	return bat
end
function createnemy_ghost(_x,_y)
	local ghost = makerole(9,_x,_y,
		{idle=96,--空白
		apr=explodeval("96,82,83"),--出现
		fly={83,84},
		hurt={83,85}},
		{idle = "idle",--idle:隐藏
		apr="apr",--出现
		fly = "fly",
		rest="rest",--休息
		hurt="hurt",
		death = "death"}
	)
	add(enemies,ghost)
	return ghost
end
--大海龟Boss：两阶段
