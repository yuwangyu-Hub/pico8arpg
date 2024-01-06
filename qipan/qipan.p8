pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
function _init()
	hand={x=64, y=64, pre_d=false}
	board={h=5,w=10,x=14,y=56,long=10,c=6,bd=13}--bd=border color



end


function _update()
	cls(5)
	input()
	
	checkwall()
	--if hand.pre_d then
	--	checkpressd(hand.x+4,hand.y,board.x,board.y,board.x+10,board.y+10)
	--end
end

function _draw()
	checkerboard(board.h,board.w,board.x,board.y)
	
	spr(1,hand.x,hand.y)
	
end
-->8
--tool

function input()
	if btn(⬅️) then	hand.x-=2 end 
	if btn(➡️) then hand.x+=2 end
	if btn(⬆️) then	hand.y-=2 end 
	if btn(⬇️) then hand.y+=2 end


	if btn(4) then hand.pre_d=true end
end

function checkwall()
	if hand.x<0 then hand.x=0 end
	if hand.x>122 then hand.x=122 end
	if hand.x<0 then hand.x=0 end	
	if hand.x<0 then hand.x=0 end
end
-->8
--draw


function checkpressd(che_x,che_y,x1,y1,x2,y2)
	if che_x >x1 and che_x < x2 and che_y>y1 and che_y<y2 then 
		return true
	else
		return false
	end
end

function checkerboard(h_count,w_count,board_x,board_y)
	local h=h_count
	local w=w_count
	
	for j=1,h,1 do 	
		for i=1,w,1 do 
			checker(board_x+(i-1)*10,board_y+(j-1)*10,board.long,board.c,board.bd)
		end
	end
	
	
end


function checker(x1,y1,long,checker_c,border_c)
	local lg=long --long
	
	local lx1=x1
	local ly1=y1
	local lx2=x1+lg
	local ly2=y1+lg
	local c=checker_c
	local cl=border_c
	

	--check the checker hand press or not	
	if checkpressd(hand.x+4,hand.y,lx1,ly1,lx2,ly2) then
		if hand.pre_d==true then
			c=9
			print("an le")
			hand.pre_d=false
		end
	end

	rectfill(lx1,ly1,lx2,ly2,c)
	rect(lx1,ly1,lx2,ly2,cl)
end
__gfx__
00000000001700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700001700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000001767000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000171767600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700177777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000177777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000017777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
