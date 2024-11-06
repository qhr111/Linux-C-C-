-- 只在一个 worker 进程里面处理
if ngx.worker.id() ~= 0 then 
    return
end

local redis = require "resty.redis"
local bklist = ngx.shared.bklist

local function update_blacklist()
    local rdb = redis:new()

    local ok, err = rdb:connect("127.0.0.1", 6379)
    if not ok then
        ngx.log(ngx.ERR, "Failed to connect to Redis: ", err)
        return
    end

    local black_list, err = rdb:smembers("black_list")
    if not black_list then
        ngx.log(ngx.ERR, "Failed to fetch black_list from Redis: ", err)
        return
    end

    bklist:flush_all()
    for _, v in ipairs(black_list) do
        bklist:set(v, true)
    end

    -- 每五秒钟把 Redis 的数据刷到共享内存中
    local ok, err = ngx.timer.at(5, update_blacklist)
    if not ok then
        ngx.log(ngx.ERR, "Failed to create timer: ", err)
    end
end

-- 初始化更新黑名单
local ok, err = ngx.timer.at(0, update_blacklist)
if not ok then
    ngx.log(ngx.ERR, "Failed to start initial blacklist update: ", err)
end
