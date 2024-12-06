local file = io.input('input')
if not file then
   return
end

---comment
---@param line string
---@return table
local function parse_line(line)
    local line_table = {}
    for indx = 1, #line do
        table.insert(line_table,line:sub(indx,indx))
    end
    return line_table
end
---comment
---@param position integer
---@param s string
---@return integer
---@return string|unknown
local function insert_value(position,s)
    if position ==1 then
        return 1 , s:sub(1,1)
    elseif position==-1 then
        return #s+1,s:sub(#s,#s)
    else
        return #s+1,nil
    end
end

-- local function reverse_string(str)
--     local reversed = ""
--     for i = #str, 1, -1 do
--         reversed = reversed .. str:sub(i, i)
--     end
--     return reversed
-- end

local function format_str(position)
    if position <0 then
        return string.reverse
    else return function(x) return x end
    end
end

---comment
---@param t string[]
---@return string
local function concatenate(t)
    local tmp = ''
    for _,line in ipairs(t) do
        tmp = tmp .. '\n'.. line
    end
    return tmp
end

---@param text string[]
---@param position number
---@return string
local function shear_text(text,position)
    local formater = format_str(position)
    position = math.abs(position)
    local first_line = text[1]
    local number_lines = #text
    local first_line_table = parse_line(formater(first_line))

    for indx = 2, number_lines do
        for jndx = 1, #text[indx] do
            local to_append = formater(text[indx]):sub(jndx+position,  jndx+position)
            if type(to_append)=="string" then
                first_line_table[jndx] = first_line_table[jndx] .. to_append
            end
        end
        table.insert(first_line_table,insert_value(position, formater(text[indx])))
    end
    return concatenate(first_line_table )
end

local table_lines = {}
for line in file:lines() do
    table.insert(table_lines,line)
end

local crossword_text = ""
local horizontal = concatenate(table_lines)
local vertical = shear_text(table_lines,0)
local sheared_right = shear_text(table_lines,1)
local sheared_left = shear_text(table_lines,-1)
for _,to_add in ipairs({horizontal, vertical,sheared_left, sheared_right}) do
    crossword_text = crossword_text .. "\n" .. to_add
end

local tally = 0
for _ in crossword_text:gmatch("XMAS") do
    tally= tally +1
end
for _ in crossword_text:gmatch("SAMX") do
    tally= tally +1
end
print(tally)


-- part 2

---comment
---@param t_str string[]
local function convolution(t_str)
    local length_of_first_line = #t_str[1]
    tally = 0 
    for row = 1,#t_str-2 do
        for column = 1, length_of_first_line-2 do
            local top_left = t_str[row]:sub(column, column)
            local top_right = t_str[row]:sub(column+2, column+2)
            local middle= t_str[row+1]:sub(column+1, column+1)
            local bot_left = t_str[row+2]:sub(column, column)
            local bot_right = t_str[row+2]:sub(column+2, column+2)
            local tmp_one =top_left .. middle .. bot_right
            local tmp_two = top_right .. middle .. bot_left
            if (( tmp_one =="MAS") or (tmp_one == 'SAM')) and (( tmp_two =="MAS") or (tmp_two == 'SAM')) then
                tally = tally +1
            end
        end
    end
    return tally
end

print(convolution(table_lines))
