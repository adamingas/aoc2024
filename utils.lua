local utils = {}

---comment
---@param default_value_factory function
---@return table
function utils.defaultdict(default_value_factory)
    return setmetatable({}, {
        __index = function(t, key)
            -- If the key doesn't exist, set it to the default value
            t[key] = default_value_factory(key)
            return t[key]
        end
    })
end

function utils.pprint(var,key,prefix)
    if type(var) == 'table' then
        print(key or '')
        for k,v in pairs(var) do
            utils.pprint(v,k,'\t')
        end
    elseif (type(var)=="string") or (type(var) == "number")then
        print(prefix or '', key or '',var)
    end
end

return utils
