local file = io.input('input')

if not file then
    return
end


local function parse(line)
    local tally = 0
    for left,right in line:gmatch("mul%((%d%d?%d?),(%d%d?%d?)%)") do
        tally = tally +left*right
    end
    return tally
end

local lines = {}
local tally = 0
for line in file:lines() do
    table.insert(lines,line)
    tally= tally+ parse(line)
end
print("Part 1 answer is ".. tally)

-- For part 2 we have to ignore any multiplications that happen between don't() and do()
-- What if do the opposite and only capture those multiplications and subtract them from the original tally?

local invalid_tally = 0
local concatenated_lines = ""

for _,line in ipairs( lines) do
    concatenated_lines = concatenated_lines .. line
end
local function parse_false(line)
    local matched = line:match("do%(%)(.-)don't%(%)")
    if matched == nil then
        return 0
    end
    local inner_tally = parse(matched)
    local dont = line:match("do%(%).-don't%(%)(.*)")
    inner_tally = inner_tally + parse_false(dont)
    return inner_tally
end
local part2_tally = 0
local valid = concatenated_lines:match("(.-)don't%(%)")
local invalid = concatenated_lines:match("don't%(%)(.*)")
part2_tally = part2_tally + parse(valid) + parse_false(invalid)

-- for invalid in concatenated_lines:gmatch("don't%(%).-do%(%)") do
--     invalid_tally = invalid_tally + parse(invalid)
-- end
print(part2_tally)
