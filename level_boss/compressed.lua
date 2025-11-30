--数组压缩代码
function explodeval(str)return toval("["..str.."]")end
function explode(s, sep)local sep = sep or ","local retval,lastpos,depth={},1,0 local start_bracket,end_bracket="[","]"for i=1,#s do local char = sub(s,i,i)if char == start_bracket then depth += 1 elseif char == end_bracket then depth -= 1 elseif char == sep and depth == 0 then add(retval, sub(s, lastpos, i-1))lastpos = i + 1 end end add(retval, sub(s, lastpos, #s))return retval end
function trim(str)while sub(str,1,1) == " " do str = sub(str,2)end while sub(str,#str,#str) == " " do str = sub(str,1,#str-1)end return str end
function is_array_format(str)return #str >= 2 and sub(str,1,1) == "[" and sub(str,#str,#str) == "]"end
function toval(val)val = trim(val)if is_array_format(val) then local content = sub(val, 2, #val-1)return toval_arr(explode(content))else return flr(val+0)end end
function toval_arr(arr)local result = {}for i=1,#arr do local val = arr[i]if val != nil and #val >= 2 and sub(val,1,1) == "[" and sub(val,#val,#val) == "]" then add(result, toval(val))else add(result, flr(val+0))end end return result end