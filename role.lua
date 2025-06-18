function makerole()--角色的创建模板
	local role={}
	role.allstate={}
	role.x=0
	role.y=0
	role.spd={spx=0,spy=0} --加速度
	role.speed=0
	role.dire=0 
	role.lastdire=0 --方向
	role.state=role.allstate[1]
	role.move_t=0
	role.frame=0
	role.sprflip=false
	role.sprs={}
	return role
end
function playerdata()
    wy=makerole()
    wy.allstate={
		idle="idle",
		move="move",
		attack="attack",
		jump="jump",--跳跃（需获取道具）
		archery="archery",--射箭
		roll="roll",
		hurt="hurt",
		push="push",--推
		death="death"
	}
    wy.state=wy.allstate.idle
    wy.x=32
    wy.y=32
	wy.w=7
	wy.h=7 --精灵大小
    wy.speed=1
	wy.isroll=false
    wy.rollspeed=3
	wy.roll_t=0
	wy.isattack=false
	wy.att_t=0
	wy.push_type=""
    wy.frame=wy.sprs.idle--动画帧
    wy.sprs={
        idle=2,
        move={1,2,3,4},
		push={13,15,13,14},
        roll={5,6,6,7,7,5},
        attack={8,9,10},
		hurt=11,
		get=12
    }	
end
function sword()
    sword=makerole()--武器
	sword.sprs={27,23,26,24,25,40,28,39}--匹配角色1-8方向
end
--[[
--敌人-蛇
function enemydata()
    snake=makerole()
    snake.allstate={
        idle="idle",
        trace="trace",
        death="death"
    }
    snake.state=snake.allstate.idle
    snake.x=30
    snake.y=0
    snake.speed=0.5
end
--[[
--追逐
function chase(sb1,sb2)
	if sb1.x < sb2.x then
		sb1.x+=sb1.speed
	end
	if sb1.x > sb2.x then
		sb1.x-=sb1.speed
	end
	if sb1.y < sb2.y then
		sb1.y+=sb1.speed
	end
	if sb1.y > sb2.y then
		sb1.y-=sb1.speed
	end
end
--]]