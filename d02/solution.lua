local file = io.input('input')

if not file then
    return
end

local function parse(line)
    local line_table = {}
    for nu in line:gmatch("(%d+)") do
        local numb = tonumber(nu)
        table.insert(line_table, numb)
    end
    return line_table
end

local function safe(line_table)
    local prev_diff = 0
    for indx, numb in ipairs( line_table ) do
        if line_table[indx-1] ~= nil then
            local diff = numb - line_table[indx-1]
            if math.abs(diff) >3 or math.abs(diff)<1 then
                return false
            elseif ((diff>0) and (prev_diff<0)) or
                    ((diff<0) and (prev_diff>0)) then
                return false
            else
                prev_diff = diff
            end
        end
    end
    return true
end

local total_length = 0
local faulty_list  = {}

for line in file:lines() do
    total_length = total_length + 1
    local line_table = parse(line)

    local flag = safe(line_table)
    if not flag then
        table.insert(faulty_list,line)
    end
end
local safe_length =total_length - #faulty_list
print("Part 1 answer is " .. safe_length)

List = {}

function List:new(existing_table)
    local tmp = {}
    if existing_table~= nil then
        tmp = existing_table
    end
    self.__index = self
    return setmetatable(tmp,self)
end
function List:pop(key)
    local tmp = List:new()
    for indx,value in ipairs(self) do
        if indx~=key then
            table.insert(tmp, value)
        end
    end
    return tmp
end
local function check_sequence_dumper(list)
    local tmp = List:new(list)
    for indx, _ in ipairs(list) do
        if safe(tmp:pop(indx)) then
            return true
        end
    end
    return false
end

for _, line in ipairs(faulty_list) do
    local line_table = parse(line)
    if check_sequence_dumper(line_table) then
        safe_length = safe_length +1
    end
end
print("Part 2 answer is "..safe_length)
-- local function safe_dumper(line)
--     local tmp_l = {}
--     for nu in line:gmatch("(%d+)") do
--         local numb = tonumber(nu)
--         table.insert(tmp_l,numb )

--     local prev_diff = 0
--     for nu in line:gmatch("(%d+)") do
--         local numb = tonumber(nu)
--         if tmp_l[#tmp_l] ~= nil then
--             local diff = numb - tmp_l[#tmp_l]
--             if math.abs(diff) >3 or math.abs(diff)<1 then
--                 return false
--             elseif ((diff>0) and (prev_diff<0)) or
--                     ((diff<0) and (prev_diff>0)) then
--                 return false
--             else
--                 prev_diff = diff
--             end
--         end
--         table.insert(tmp_l,numb )
--     end
-- end
-- end
