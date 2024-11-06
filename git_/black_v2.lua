local bklist = ngx.shared.bklist

local ip = ngx.var.remote_addr

if bklist:get(ip) then
    return ngx.exit(403)
end
