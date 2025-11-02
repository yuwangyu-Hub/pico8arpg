function makerole(name,x,y,hp,speed,sprs,state)--角色的创建模板
	local role={}
	role.name=name
	role.allstate=state
	role.x,role.y,role.w,role.h=x,y,7,7
	role.hp=hp
	role.speed=speed
	role.spd={spx=0,spy=0} --加速度
	--role.speed=0
	role.dire=0--方向
	role.lastdire=5 --最后方向?
	role.hurtdire=0 --受伤方向
	 --受伤后的移动时间
	role.sprs=sprs
	role.frame=0
	role.sprflip=false
	role.idle_t=0
	role.hurtm_t=0
	role.die_t=0
	role.move_t=0
	return role
end
-- 初始化玩家数据
-- @return 玩家对象
function initializeplayer()
	local player = makerole("p",
		70,70,8,1,
		{idle = 2, --  idle状态精灵
		move = explodeval("1,2,3,4"), -- 移动状态精灵序列
		push = explodeval("13,15,13,14"), -- 推动状态精灵序列 (1(1), 2(3), 3(5), 4())
		roll = explodeval("5,6,6,7,7,5"), -- 翻滚状态精灵序列
		       -- 3, 2/4, 1/5, 6/8, 7
		attack = explodeval("8,9,10,11,12"), -- 攻击状态精灵序列
		fall=explodeval("24,25,26"),
		death=explodeval("27,28,29"),
		hurt = explodeval("22,40"), -- 受伤状态精灵		
		get = 23 -- 获取物品状态精灵（只一次）
		},
		{idle= "idle",--在状态机中，识别为字符串
		move="move",
		attack="attack",
		jump="jump",
		archery="archery",
		roll="roll",
		push="push",
		hurt="hurt",
		death="death"})
	-- 玩家状态常量
	player.state = player.allstate.idle
	player.spr_cx,player.spr_cy=0,0--精灵和真正坐标位置的差值
	player.curhp=6--当前血量
	player.move_t=0--用来绘制移动动画
	player.ishurt=false
	player.hurtmt=0
	player.wudi_t=0 --无敌时间
	player.isroll = false -- 是否翻滚
	player.rollspeed = 3 -- 翻滚速度
	player.roll_t = 0 -- 翻滚计时器
	player.isclosewall=false--是否靠近墙壁(翻滚时)
	player.isattack = false -- 是否攻击
	player.att_t = 0 -- 攻击计时器
	player.frame = player.sprs.idle -- 初始动画帧
	return player
end
-- 初始化武器数据 武器对象
function initializesword()
	sword={}
	sword.x,sword.y,sword.w,sword.h=0,0,7,7
	sword.sprx,sword.spry=explodeval("-7,-6,2,8,8,8,2,-6"),explodeval("2,-6,-7,-6,2,8,8,8")	 --1 2 3 4 5 6 7 8
	sword.isappear = false -- 是否显示
	return sword
end

function init_cnut(dire)
	--栗子子弹动画帧sspr
	local cnut_anim=explodeval("[104,32,5,4],[110,32,4,5],[109,38,5,4],[104,37,4,5]")
	local index=(dire+1)/2
	cnut={}
	cnut.x=0
	cnut.y=0
	cnut.w=5
	cnut.h=5
	cnut.ssprx=cnut_anim[index][1]
	cnut.sspry=cnut_anim[index][2]
	cnut.ssprw=cnut_anim[index][3]	
	cnut.ssprh=cnut_anim[index][4]
	cnut.isappear = false -- 是否显示
	return cnut
end
--*角色：敌人和npc
function createnemy_urchin(_x,_y)--小海胆
	local urchin = makerole("urchin", 
		_x*8,_y*8,1,0,
		{idle=105,
		hurt={105,121}
		},
		{idle = "idle",
		hurt="hurt",
		death = "death"})
	urchin.state=urchin.allstate.idle
	urchin.frame=urchin.sprs.idle
	add(enemies,urchin)
	return urchin
end
function createnemy_snake(_x,_y)--蛇
	local snake = makerole("snake", 
		_x*8,_y*8,2,0.5,
		{idle=99,
		move={98,99},
		hurt={99,115}},
		{idle = "idle",
		move = "move",
		hurt="hurt",
		death = "death"})
		snake.state = snake.allstate.idle
		snake.frame=snake.sprs.idle
		snake.lastdire=0
		add(enemies,snake)
	return snake
end
function createnemy_spider(_x,_y)--小蜘蛛
	local spider = makerole("spider",
		_x*8,_y*8,1,0.5,
		{idle=103,
		move={102,103},
		hurt={103,104}},
		{idle = "idle",
		move = "move",
		hurt="hurt",
		death = "death"})
		spider.state=spider.allstate.idle
		spider.frame=spider.sprs.idle
		add(enemies,spider)
	return spider
end
function createnemy_slime(_x,_y)--史莱姆
	local slime = makerole("slime", 
		_x*8,_y*8,1,0.5,
		{idle={96,117},
		charge={97,113},--跳跃前的蓄力
		jump=114,
		hurt={96,112}},
		{idle = "idle",
		charge="charge",--跳跃前的蓄力
		jump = "jump",
		hurt="hurt",
		death = "death"})
	slime.charge_t=0
	slime.tx, slime.ty=0, 0
	slime.jump_t = nil
	slime.jump_start_x, slime.jump_start_y=0, 0--跳跃初始位置
	slime.jump_dir_x, slime.jump_dir_y=0, 0--跳跃方向
	slime.jump_dist=0--跳跃距离
	slime.state=slime.allstate.idle
	slime.frame=slime.sprs.idle[1]
	slime.crange = 20--检测范围
	add(enemies,slime)
	return slime
end
function createnemy_bat(_x,_y)--小蝙蝠
	local bat = makerole("bat",
		_x*8,_y*8,1,1,
		{idle=101,
		fly={100,101},
		rest=101,
		hurt={100,116}},
		{idle = "idle",
		fly = "fly",
		rest="rest",
		hurt="hurt",
		death = "death"})
	bat.crange = 25 -- 检测范围
	bat.rest_t,bat.fly_t= 0,0
	bat.tx, bat.ty=0,0
	bat.angle,bat.radius=0,0 -- 用于圆形飞行的角度-- 圆形飞行的半径
	bat.fly_init,bat.fly_direction = false, 1 --是否初始化了飞行参数--飞行方向：1为顺时针，-1为逆时针
	bat.bat_start_x, bat.bat_start_y=0,0
	bat.state=bat.allstate.idle
	bat.frame=bat.sprs.idle
	add(enemies,bat)
	return bat
end
function createnemy_ghost(_x,_y)--幽灵
	local ghost = makerole("ghost",
		_x*8,_y*8,1,0.3, --缩小幽灵在不出现时的体积，避免玩家触碰
		{disapr=126,--空白
		apr={126,122,123},--出现
		fly={123,124},
		hurt={123,125}},
		{disapr = "disapr",--消失/隐藏
		apr="apr",--出现
		fly = "fly",
		rest="rest",--休息
		hurt="hurt",
		death = "death"}
	)
	ghost.apr_t=0
	ghost.fly_t=0
	ghost.rest_t=0
	ghost.crange = 10 -- 检测范围
	ghost.state=ghost.allstate.disapr
	ghost.frame=ghost.sprs.disapr
	add(enemies,ghost)
	return ghost
end
function createnemy_lizi(_x,_y) --丢栗怪
	local lizi = makerole("lizi",
		_x*8,_y*8,10,.5,
		{idle={89,106,108},
		move=explodeval("[108,109],[89,90],[108,109],[106,107]"),--1357
		hurt=explodeval("[108,120],[89,118],[108,120],[106,119]")--1357
		},
		{idle = "idle",
		move = "move",
		atk="atk",
		hurt="hurt",
		death = "death"})
	lizi.state=lizi.allstate.idle
	lizi.hurtframe=0
	lizi.frame=lizi.sprs.idle[1]
	lizi.dire=3--朝上
	lizi.cubeline=5 -- 检测矩形视线
	add(enemies,lizi)
	return lizi
end

--大海龟Boss：两阶段
