function makerole()--角色的创建模板
	local role={}
	role.allstate={}
	role.x=0
	role.y=0
	role.w=7
	role.h=7
	role.hp=0
	role.spd={spx=0,spy=0} --加速度
	--role.speed=0
	role.dire=0--方向
	role.lastdire=5 --最后方向
	role.hurtdire=0 --受伤方向
	 --受伤后的移动时间
	role.sprs={}
	role.frame=0
	role.sprflip=false
	return role
end
-- 初始化玩家数据
-- @return 玩家对象
function initializeplayer()
	local player = makerole()
	-- 玩家状态常量
	player.allstate = {
		idle = "idle",--在状态机中，识别为字符串
		move = "move",
		attack = "attack",
		jump = "jump", -- 跳跃（需获取道具）
		archery = "archery", -- 射箭
		roll = "roll",
		push = "push",
		hurt = "hurt",
		death = "death"
	}
	player.state = player.allstate.idle
	player.x = 88
	player.y = 60
	player.spr_cx=0--精灵和真正坐标位置的差值
	player.spr_cy=0
	player.hp=8--当前满血
	player.curhp=6--当前血量
	player.speed =1
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
	-- 精灵帧定义
	player.sprs = {
		idle = 2, --  idle状态精灵
		move = explodeval("1,2,3,4"), -- 移动状态精灵序列
		push = explodeval("13,15,13,14"), -- 推动状态精灵序列 (1(1), 2(3), 3(5), 4())
		roll = explodeval("5,6,6,7,7,5"), -- 翻滚状态精灵序列
		       -- 3, 2/4, 1/5, 6/8, 7
		attack = explodeval("8,9,10,11,12"), -- 攻击状态精灵序列
		fall=explodeval("24,25,26"),
		death=explodeval("27,28,29"),
		hurt = {22,40}, -- 受伤状态精灵
		get = 23 -- 获取物品状态精灵（只一次）
	}
	player.frame = player.sprs.idle -- 初始动画帧
	return player
end
-- 初始化武器数据 武器对象
function initializesword()
	local sword = makerole()
	sword.sprx=explodeval("-7,-6,2,8,8,8,2,-6")	 --1 2 3 4 5 6 7 8
	sword.spry=explodeval("2,-6,-7,-6,2,8,8,8")
	sword.isappear = false -- 是否显示
	return sword
end
--*角色：敌人和npc

function createnemy_urchin(_x,_y)--小海胆
	local urchin = makerole()
	urchin.name="urchin"
	urchin.allstate = {
		idle = "idle",
		hurt="hurt",
		death = "death"}
	urchin.state=urchin.allstate.idle
	urchin.x = _x*8
	urchin.y = _y*8
	urchin.hp=1
	urchin.sprs={
		idle=105,
		hurt={105,121}
		}
	urchin.frame=urchin.sprs.idle
	add(enemies,urchin)
	return urchin
end
function createnemy_snake(_x,_y)--蛇
	local snake = makerole()
	snake.name="snake"
	snake.allstate = {
		idle="idle",
		move = "move",
		hurt="hurt",
		death = "death"}
	snake.state = snake.allstate.idle
	snake.x = _x*8
	snake.y = _y*8
	snake.hp=2
	snake.speed = 0.5
	snake.lastdire=0
	snake.sprs = {
		move={98,99},
		hurt={99,115}
	}
	snake.frame=snake.sprs.move[1]
	add(enemies,snake)
	return snake
end
function createnemy_slime(_x,_y)--史莱姆
	local slime = makerole()
	slime.name="slime"
	slime.allstate = {
		idle="idle",
		charge="charge",--跳跃前的蓄力
		jump = "jump",
		hurt="hurt",
		death = "death"}
	slime.state=slime.allstate.idle
	slime.x = _x*8
	slime.y = _y*8
	slime.hp=1
	slime.speed = 0.5
	slime.crange = 20--检测范围
	slime.sprs= {
		idle={96,117},
		charge={97,113},--跳跃前的蓄力
		jump=114,
		hurt={96,112}}
	slime.frame=slime.sprs.idle[1]
	add(enemies,slime)
	return slime
end
--[[
function createnemy_bat(_x,_y)--小蝙蝠
	local bat = makerole()
	bat.name="bat"
	bat.allstate = {
		ran_move = "ran_move",
		death = "death"}
	bat.state=bat.allstate.ran_move
	bat.x = _x*8
	bat.y = _y*8
	bat.hp=1
	bat.speed = 0.5
	bat.crange = 5 -- 检测范围
	bat.sprs = {100,101} -- 精灵编号
	add(enemies,bat)
	return bat
end

function createnemy_spider(_x,_y)--小蜘蛛
	local spider = makerole()
	spider.name="spider"
	spider.allstate = {
		ran_move = "ran_move",
		hurt="hurt",
		death = "death"}
	spider.state=spider.allstate.ran_move
	spider.x = _x*8
	spider.y = _y*8
	spider.hp=1
	spider.speed = 0.5
	spider.crange = 5 -- 检测范围
	spider.sprs={102,103} -- 精灵编号
	add(enemies,spider)
	return spider
end
function createnemy_ghost(_x,_y)--幽灵
	local ghost = makerole()
	ghost.name="ghost"
	ghost.allstate = {
		ran_move = "ran_move",
		trace = "trace", -- 追踪
		hurt="hurt",
		death = "death"}
	ghost.state=ghost.allstate.ran_move
	ghost.x = _x*8
	ghost.y = _y*8
	ghost.hp=3
	ghost.speed = 0.5
	ghost.crange = 5 -- 检测范围
	ghost.sprs= {104} -- 精灵编号
	add(enemies,ghost)
	return ghost
end
function createnemy_lizi(_x,_y) --丢栗怪
	local lizi = makerole()
	lizi.name="lizi"
	lizi.allstate = {
		idle = "idle",
		death = "death"}
	lizi.state=lizi.allstate.idle
	lizi.x = _x*8
	lizi.y = _y*8
	lizi.hp=2
	lizi.speed=1
	lizi.crange=5 -- 检测范围
	lizi.sprs={106,107,108,109}--精灵编号
	add(enemies,lizi)
	return lizi
end

--大海龟Boss：两阶段]]
