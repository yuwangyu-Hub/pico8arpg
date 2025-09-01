function makerole()--角色的创建模板
	local role={}
	role.allstate={}
	role.x=0
	role.y=0
	role.w=0
	role.h=0
	role.health=0
	role.spd={spx=0,spy=0} --加速度
	role.speed=0
	role.dire=0--方向
	role.lastdire=5 --最后方向
	role.hurtdire=0 --受伤方向
	role.hurtmt=0 --受伤后的移动时间
	role.move_t=0--用来绘制移动动画
	role.frame=0
	role.sprflip=false
	role.sprs={}
	return role
end
-- 初始化玩家数据
-- @return 玩家对象
function initializeplayer()
	local player = makerole()
	
	-- 玩家状态常量
	player.allstate = {
		idle = "idle",
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
	player.w = 7
	player.h = 7 -- 精灵大小
	player.spr_cx=0--精灵和真正坐标位置的差值
	player.spr_cy=0
	player.speed = 1
	player.ishurt=false
	player.wudi_t=0 --无敌时间
	player.isroll = false -- 是否翻滚
	player.rollspeed = 3 -- 翻滚速度
	player.roll_t = 0 -- 翻滚计时器
	player.isattack = false -- 是否攻击
	player.att_t = 0 -- 攻击计时器
	-- 精灵帧定义
	player.sprs = {
		idle = 2, --  idle状态精灵
		move = explodeval("1, 2, 3, 4"), -- 移动状态精灵序列
		push = explodeval("13, 15, 13, 14"), -- 推动状态精灵序列 (1(1), 2(3), 3(5), 4())
		roll = explodeval("5, 6, 6, 7, 7, 5"), -- 翻滚状态精灵序列
		       -- 3, 2/4, 1/5, 6/8, 7
		attack = explodeval("8, 9,   10,  11,  12"), -- 攻击状态精灵序列
		hurt = 11, -- 受伤状态精灵
		get = 12 -- 获取物品状态精灵（只一次）
	}
	player.frame = player.sprs.idle -- 初始动画帧
	return player
end
-- 初始化武器数据 武器对象
function initializesword()
	local sword = makerole()
	sword.w = 7
	sword.h = 7 -- 精灵大小
	sword.sprx=explodeval("-7,-6,2,8,8,8,2,-6")	 --1 2 3 4 5 6 7 8
	sword.spry=explodeval("2,-6,-7,-6,2,8,8,8")
	sword.isappear = false -- 是否显示
	return sword
end
--*角色：敌人和npc
--敌人分为三种：普通A、普通B、Boss
--普通A：随机移动
--A：根据血量不同，分为1血和2血和3血的
--普通B：先随机移动，后发现追击？
--普通C：无视墙壁的攻击（飞行类）
function createnemy_slime(_x,_y)--史莱姆
	local slime = makerole()
	slime.type="d"
	slime.allstate = {
		ran_move = "ran_move",
		death = "death"}
	slime.state=slime.allstate.ran_move
	slime.x = _x*8
	slime.y = _y*8
	slime.w = 7
	slime.h = 7
	slime.health=1
	slime.speed = 0.5
	slime.crange = 5 -- 检测范围
	slime.spr = 96 -- 精灵编号
	slime.frame=2 --两帧动画
	add(enemies,slime)
	return slime
end
function createnemy_snake(_x,_y)--蛇
	local snake = makerole()
	snake.type="b"
	snake.allstate = {
		ran_move = "ran_move",
		death = "death"}
	snake.state = snake.allstate.ran_move
	snake.x = _x*8
	snake.y = _y*8
	snake.w = 7
	snake.h = 7
	snake.health=1
	snake.speed = 0.5
	snake.crange = 5 -- 检测范围
	snake.spr = 98 -- 精灵编号
	snake.frame=2 --两帧动画
	
	add(enemies,snake)
	return snake
end
function createnemy_bat(_x,_y)--蝙蝠
	local bat = makerole()
	bat.type="f"
	bat.allstate = {
		ran_move = "ran_move",
		death = "death"}
	bat.state=bat.allstate.ran_move
	bat.x = _x*8
	bat.y = _y*8
	bat.w = 7
	bat.h = 7
	bat.health=1
	bat.speed = 0.5
	bat.crange = 5 -- 检测范围
	bat.spr = 104 -- 精灵编号
	bat.frame=1 --两帧动画
	add(enemies,bat)
	return bat
end
function createnemy_spider(_x,_y)--蜘蛛
	local spider = makerole()
	spider.type="b"
	spider.allstate = {
		ran_move = "ran_move",
		hurt="hurt",
		death = "death"}
	spider.state=spider.allstate.ran_move
	spider.x = _x*8
	spider.y = _y*8
	spider.w = 7
	spider.h = 7
	spider.health=1
	spider.speed = 0.5
	spider.crange = 5 -- 检测范围
	spider.spr = 104 -- 精灵编号
	spider.frame=1 --两帧动画
	add(enemies,spider)
	return spider
end
function createnemy_ghost(_x,_y)--幽灵
	local ghost = makerole()
	ghost.type="e"
	ghost.allstate = {
		ran_move = "ran_move",
		trace = "trace", -- 追踪
		hurt="hurt",
		death = "death"}
	ghost.state=ghost.allstate.ran_move
	ghost.x = _x*8
	ghost.y = _y*8
	ghost.w = 7
	ghost.h = 7
	ghost.health=3
	ghost.speed = 0.5
	ghost.crange = 5 -- 检测范围
	ghost.spr = 104 -- 精灵编号
	ghost.frame=1 --两帧动画
	add(enemies,ghost)
	return ghost
end
function createnemy_bigeye(_x,_y)--大眼怪
	local beye = makerole()
	beye.type="a"
	beye.allstate = {
		stay = "stay",
		hurt="hurt",
		death = "death"}
	beye.state=beye.allstate.stay
	beye.x = _x*8
	beye.y = _y*8
	beye.w = 7
	beye.h = 7
	beye.health=1
	beye.spr = 105 -- 精灵编号
	beye.frame=1 --1帧动画
	add(enemies,beye)
	return beye
end
function createnemy_lizi(_x,_y) --栗子怪
	local lizi = makerole()
	lizi.type="c-2"
	lizi.allstate = {
		stay = "stay",
		death = "death"}
	lizi.state=lizi.allstate.stay
	lizi.x = _x*8
	lizi.y = _y*8
	lizi.w = 7
	lizi.h = 7
	lizi.health=2
	lizi.speed=1
	lizi.crange=5 -- 检测范围
	lizi.spr = 105 -- 精灵编号
	lizi.frame=2 --2帧动画
	add(enemies,lizi)
	return lizi
end

--大海龟Boss：两阶段
