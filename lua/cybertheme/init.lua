local M = {}
function M.setup()
    local lush = require('lush')
    local spec = require('cybertheme.colors')
    lush(spec)
end
return M
