local utils = require('utils')
local file = io.input('d05/input')

if not file then
    return
end

---Parses a line that looks like this "65,23,88" to a table
---@param line string
---@return table
local function parse_update(line)
    local tmp = {}
    for v in line:gmatch("(%d%d?%d?),?") do
        table.insert(tmp,v)
    end
    return tmp
end

---comment
---@param update string[]
---@param rules { [string]: string[]}
---@return boolean
local function check_valid_update(update, rules)
    for indx = 1, #update-1 do
        local to_check = update[indx]
        for jndx = indx+1, #update do
            for _,v in ipairs(rules[to_check] or {}) do
                if v ==update[jndx] then
                    return false
                end
            end
        end
    end
    return true
end

---@type string[]
local comparison_table = {}
local updates_table = {}
local control_flow = false
for line in file:lines() do
    if line =='' then
        print(line)
        control_flow = true
    elseif not control_flow then
        table.insert(comparison_table,line)
    else
        table.insert(updates_table,line)
    end
end

local less_than_map = utils.defaultdict(function() return {} end)


for _,comparison in ipairs(comparison_table) do
    local left, right = comparison:match("(%d%d?)|(%d%d?)")
    table.insert(less_than_map[right],left)
end

local tally = 0
local incorrect = {}
for _,line in ipairs(updates_table) do
    local tmp = parse_update(line)
    if check_valid_update(tmp, less_than_map) then
        tally = tally +tmp[#tmp//2 +1]
    else
        table.insert(incorrect, tmp)
    end
end

print(tally)
-- part 2
-- creating a sorter than given a rule set returns a sort function

---creates a comparator function with custom rules to sort a table
---@param rules {[string]: string[]}
---@return fun(left: string, right: string): boolean
local function sorter(rules)
    return function (left,right)
        for _, v in ipairs(rules[left]) do
            if right==v then
                return true
            end
        end
        return false
    end
end

local reduced_map = utils.defaultdict(function() return {} end)
local sort_function = sorter(less_than_map)
for _,i in ipairs(incorrect[2]) do
    for _,j in ipairs(less_than_map[i]) do
        for _,k in ipairs(incorrect[2]) do
            if j==k then
                table.insert( reduced_map[i] ,j)
            end
        end
    end
end
utils.pprint(reduced_map)
t = {
    "64",
    "25",
    "11",
    "14",
    "62",
    "99",
    "74",
    "55",
    "26",
    "97",
    "34",
    "22",
    "66",
    "58",
    "73",
}
reduced_sort = sorter(reduced_map)
print('unsortable')
table.sort(t,sort_function)
utils.pprint(t)
t = {"1","3","2",}
rules = {["1"]={}, ["2"]={"1"},["3"]={"1","2"}}
table.sort(t, function(x,y) return sorter(rules)(y,x) end )
utils.pprint(t)
-- utils.pprint(incorrect[1])
-- utils.pprint(incorrect[3])
-- table.sort(incorrect[3], sort_function)
-- table.sort(incorrect[1], sort_function)
-- utils.pprint(incorrect[1])
-- utils.pprint(incorrect[3])

local incorrect_tally = 0
for _,line in ipairs(incorrect) do
    table.sort(line,function(x,y) return  sorter(less_than_map)(y,x) end)
    incorrect_tally = incorrect_tally+ line[#line//2+1]
end
print("Part 2 answer is " .. incorrect_tally)
