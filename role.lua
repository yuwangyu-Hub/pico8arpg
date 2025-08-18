function makerole()--角色的创建模板
	local role={}
	role.allstate={}
	role.x=0
	role.y=0
	role.w=0
	role.h=0
	role.spd={spx=0,spy=0} --加速度
	role.speed=0
	role.dire=0  --方向
	role.lastdire=0 --最后方向
	role.hurtdire=0
	role.hurtmt=0 --受伤后的移动时间
	role.state=role.allstate[1]
	role.move_t=0
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
		move = {1, 2, 3, 4}, -- 移动状态精灵序列
		push = {13, 15, 13, 14}, -- 推动状态精灵序列 (1(1), 2(3), 3(5), 4())
		roll = {5, 6, 6, 7, 7, 5}, -- 翻滚状态精灵序列
		attack = {8, 9, 10}, -- 攻击状态精灵序列
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
	sword.sprs = {27, 23, 26, 24, 25, 40, 28, 39} -- 匹配角色1-8方向的武器精灵
	sword.isappear = false -- 是否显示
	return sword
end
--*角色：敌人和npc
--敌人分为三种：普通A、普通B、Boss
--普通A：随机移动
--普通B：先随机移动，后发现追击
--普通C：无视墙壁的攻击（飞行类）
--Boss：多种攻击手段
-- 创建蛇形敌人数据
function createsnakenemy(_x,_y)
	local snake = makerole()
	-- 敌人状态常量
	snake.allstate = {
		ran_move = "ran_move",
		trace = "trace", -- 追踪
		death = "death"
	}
	snake.state = snake.allstate.ran_move
	snake.x = _x*8
	snake.y = _y*8
	snake.w = 7
	snake.h = 7
	snake.speed = 0.5
	snake.crange = 5 -- 检测范围
	snake.spr = 50 -- 精灵编号
	
	add(enemies, snake)
	return snake
end
