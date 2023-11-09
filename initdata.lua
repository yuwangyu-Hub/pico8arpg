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
    wy.rollspeed=3
    wy.t=0
    wy.att_t=0
    wy.aniframe=wy.animsprs.idle
    --精灵动画的表
    wy.animsprs={
        idle=2,
        move={1,2,3,4},
        roll={5,6,6,7,7,5},
        attack={9,10,11}
    }
    wy.dire=0 

	
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
    snake.speed=0.5
end