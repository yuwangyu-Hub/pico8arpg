 
 --dev
--工具栏

--带检测方向的输入系统
function input_direct_sys()
	if btn(⬅️) then 
		wy.sprflip=true
		if btn(⬆️) then      
			wy.dire=2           --------------------2
		elseif btn(⬇️) then  
			wy.dire=8           --------------------8
		else
			wy.dire=1           --------------------1	
		end
	elseif btn(➡️) then
		wy.sprflip=false 
		if btn(⬆️) then
			wy.dire=4           --------------------4
		elseif btn(⬇️) then
			wy.dire=6           --------------------6
		else
			wy.dire=5           --------------------5
		end
	elseif btn(⬆️) then
		wy.dire=3               --------------------3
	elseif btn(⬇️) then
		wy.dire=7               --------------------7
	else
		wy.dire=0              
	end
	if btn(🅾️) then --攻击为真
		--wy.att=true
		wy.state=wy.allstate.attack
	end
	if btnp(❎) then --翻滚为真
		--sb.roll=true
		wy.state=wy.allstate.roll
	end
end



--wall check
--墙壁检测
function checkwall(sb)
	if sb.x<0 then sb.x=0 end
	if sb.x>120 then sb.x=120 end 

	if sb.y<0 then sb.y=0 end
	if sb.y>120 then sb.y=120 end

	return sb
end


--attack colbox check
--攻击盒检测
function attackboxcheck(sb1,sb2,w1,h1,w2,h2)
	
	local ax1=sb1.x
	local ay1=sb1.y
	local ax2=sb1.x+w1
	local ay2=sb1.y+h1
	local bx1=sb2.x
	local by1=sb2.y
	local bx2=sb2.x+w2
	local by2=sb2.y+h2

	if bx1>ax2 or by1>ay2 then  
		return false
	elseif bx2<ax1 or by2<ay1 then
		return false
	end

	return true
end

