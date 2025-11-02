--数组压缩代码
function explodeval(str)--包装字符串为数组格式并解析
    return toval("["..str.."]")
end
function explode(s, sep)
    local sep = sep or ","
    local retval,lastpos,depth={},1,0
    local start_bracket,end_bracket="[","]"-- 开始括号/结束括号
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
-- 简单的字符串修剪函数 - 替代gsub
function trim(str)
    -- 去除开头空格
    while sub(str,1,1) == " " do
        str = sub(str,2)
    end
    -- 去除结尾空格
    while sub(str,#str,#str) == " " do
        str = sub(str,1,#str-1)
    end
    return str
end
-- 检查是否为数组格式
function is_array_format(str)
    return #str >= 2 and sub(str,1,1) == "[" and sub(str,#str,#str) == "]"
end
function toval(val)
    -- 假设val是字符串（PICO-8兼容版本）
    -- 去除首尾空白字符
    val = trim(val)
    -- 检查是否是嵌套数组格式 [1,2,3]
    if is_array_format(val) then
        -- 去除外层括号
        local content = sub(val, 2, #val-1)
        -- 递归解析数组内容
        return toval_arr(explode(content))
    else
        -- 尝试转换为数字
        return flr(val+0)
    end
end
function toval_arr(arr)
    local result = {}
    for i=1,#arr do
        local val = arr[i]
        -- 安全检查字符串长度并检查是否为数组格式
        if val != nil and #val >= 2 and sub(val,1,1) == "[" and sub(val,#val,#val) == "]" then
            add(result, toval(val))
        else
            -- 直接转换为数字
            add(result, flr(val+0))
        end
    end
    return result
end