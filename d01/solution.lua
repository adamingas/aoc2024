local file = io.input('input')

if not file then
    return
end

local l_table, r_table = {}, {}
for line in file:lines() do
    local num1, num2 = line:match("(%S+)%s+(%S+)")
    if num1 and num2 then
        table.insert(l_table, tonumber(num1))
        table.insert(r_table, tonumber(num2))
    end
end

table.sort(l_table)
table.sort(r_table)
local diff = 0
for i = 1, #l_table do
    diff = diff + math.abs( r_table[i] - l_table[i] )
end
print("Part 1 " .. diff)

-- Part 2. Find numbers appearing in list on the left with elements in list on the right
local function defaultdict(default_value)
    return setmetatable({}, {
        __index = function(t, key)
            -- If the key doesn't exist, set it to the default value
            t[key] = default_value
            return default_value
        end
    })
end

local counter = defaultdict(0)

for _,v in ipairs( r_table ) do
    counter[v] = counter[v] + 1
end
local sim = 0
for _,v in ipairs(l_table) do
    sim = sim + v*counter[v]
end
print(sim)
