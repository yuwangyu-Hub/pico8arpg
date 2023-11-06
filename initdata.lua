function playerdata()
    --主角
    wy=makerole()
    wy.allstate={
        idle="idle",
        move="move",
        attack="attack",
        roll="roll",
        hurt="hurt",
        death="death"
    }
    wy.state=wy.allstate.idle
    wy.x=60
    wy.y=60
    wy.spx=0
    wy.spy=0
    wy.speed=1.3
    wy.rollspeed=8
    wy.t=0
    wy.att_t=0
    wy.aniframe=wy.animsprs.idle
    --精灵动画的表
    wy.animsprs={
        idle=2,
        move={1,2,3,4},
        roll={5,5,6,6,7,7,8,8},
        attack={9,10,11}
    }
    wy.dire=0 
end


--绘制武器
function weapon()  
 
	sword_spr=0
	sword_att_lr={22,23,24}
	sword_att_ud={25,26,27}
	
    swordx=0
	swordy=0
	sw_flipx=false
	sw_flipy=false

	if wy.dire==1 then
		--角色向左
		swordx=wy.x-8
		swordy=wy.y
		sword_spr=8
		sw_flipx=true
	end
	if wy.dire==3 then
		--角色向上
		swordx=wy.x
		swordy=wy.y-8
		sword_spr=9
	end
	if wy.dire==5 then
		--角色向右
		swordx=wy.x+8
		swordy=wy.y
		sword_spr=8
	end
	if wy.dire==7 then
		--角色向下
		swordx=wy.x
		swordy=wy.y+8
		sword_spr=9
		sw_flipy=true
	end
	spr(sword_spr,swordx,swordy,1,1,sw_flipx,sw_flipy)
end







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
    snake.spx=0
    snake.spy=0

end