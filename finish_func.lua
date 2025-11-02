--完成的功能专门用来压缩代码
--compressed func--
function explode(s, sep)
    sep = sep or ","
    local retval, lastpos = {}, 1
    local depth = 0
    local start_bracket = "["  -- 开始括号
    local end_bracket = "]"    -- 结束括号
    
    for i=1,#s do
        local char = sub(s,i,i)
        
        -- 跟踪括号嵌套深度
        if char == start_bracket then
            depth += 1
        elseif char == end_bracket then
            depth -= 1
        -- 只有在顶层深度且遇到分隔符时才分割
        elseif char == sep and depth == 0 then
            add(retval, sub(s, lastpos, i-1))
            lastpos = i + 1
        end
    end
    
    -- 添加最后一个元素
    add(retval, sub(s, lastpos, #s))
    return retval
end

function toval(val)
    -- 如果是字符串，尝试解析
    if type(val) == "string" then
        -- 去除首尾空白字符
        val = val:gsub("^%s*", ""):gsub("%s*$", "")
        
        -- 检查是否是嵌套数组格式 [1,2,3]
        if val:sub(1,1) == "[" and val:sub(-1,-1) == "]" then
            -- 去除外层括号
            local content = val:sub(2, -2)
            -- 递归解析数组内容
            return toval_arr(explode(content))
        else
            -- 尝试转换为数字
            return flr(val+0)
        end
    end
    return val
end

function toval_arr(arr)
    local result = {}
    for _, val in all(arr) do
        add(result, toval(val))
    end
    return result
end

function explodeval(str)
    return toval("["..str.."]")
end
--compressed func--
