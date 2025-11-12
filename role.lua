--makerole(name,x,y,hp,speed,sprs,state)--角色的创建模板
function makerole(cha_tpye,x,y,sprs,state)--角色的创建模板
	local role={}
	role.name=chaname[cha_tpye]
	role.x,role.y=x*8,y*8
	role.hp=chahp[cha_tpye]
	role.speed=chaspd[cha_tpye]
	role.lastdire=chalastdire[cha_tpye] --最后方向
	role.crange=chacrange[cha_tpye] --检测范围
	role.w,role.h=7,7
	role.allstate=state
	role.sprs=sprs
	role.spd={spx=0,spy=0} --加速度
	role.dire=3--方向
	role.hurtdire=0 --初始受伤方向
	 --受伤后的移动时间
	if type(sprs.idle)=="number" then
		role.frame=sprs.idle
	else
		role.frame=sprs.idle[1]
	end
	role.state = state.idle
	role.sprflip=false
	role.idle_t=0
	role.wudi_t=0--无敌时间
	role.die_t=0
	role.move_t=0
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
		{idle=105,
		hurt={105,121}},
		{idle = "idle",
		hurt="hurt",
		death = "death"})
	add(enemies,urchin)
	return urchin
end
function createnemy_snake(_x,_y)
	local snake = makerole(3,_x,_y,
		{idle=99,
		move={98,99},
		hurt={99,115}},
		{idle = "idle",
		move = "move",
		hurt="hurt",
		death = "death"})
	add(enemies,snake)
	return snake
end
function createnemy_spider(_x,_y)
	local spider = makerole(4,_x,_y,
		{idle=103,
		move={102,103},
		hurt={103,104}},
		{idle = "idle",
		move = "move",
		hurt="hurt",
		death = "death"})
	add(enemies,spider)
	return spider
end
function createnemy_slime(_x,_y)
	local slime = makerole(5,_x,_y,
		{idle={96,117},
		charge={97,113},
		jump=114,
		hurt={96,112}},
		{idle = "idle",
		charge="charge",--跳跃前的蓄力
		jump = "jump",
		hurt="hurt",
		death = "death"})
	slime.w,slime.h=2,2
	add(enemies,slime)
	return slime
end
function createnemy_bat(_x,_y)
	local bat = makerole(6,_x,_y,
		{idle=101,
		fly={100,101},
		rest=101,
		hurt={100,116}},
		{idle = "idle",
		fly = "fly",
		rest="rest",
		hurt="hurt",
		death = "death"})
	add(enemies,bat)
	return bat
end
function createnemy_ghost(_x,_y)
	local ghost = makerole(7,_x,_y,
		{idle=126,--空白
		apr={126,122,123},--出现
		fly={123,124},
		hurt={123,125}},
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
function createnemy_lizi(_x,_y)
	local lizi = makerole(8,_x,_y,
		{idle={89,106,108},
		move=explodeval("[108,109],[89,90],[108,109],[106,107]"),--1357
		hurt=explodeval("[108,120],[89,118],[108,120],[106,119]")--1357
		},
		{idle = "idle",
		move = "move",
		atk="atk",
		hurt="hurt",
		death = "death"})
	lizi.atk_t=0
	lizi.hurtframe=0
	add(enemies,lizi)
	return lizi
end
function init_cnut(en)--栗子弹
	cnut={}
	cnut.x=en.x
	cnut.y=en.y
	cnut.t=0
	cnut.dire=en.dire
	cnut.spd={spx=0,spy=0}
	cnut.w,cnut.h=5,5
	cnut.speed=1
	cnut.sprs=explodeval("77,78,94,93")
	cnut.frame=77
	add(bullets,cnut)
	return cnut
end
--大海龟Boss：两阶段
