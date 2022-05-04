local logs = table()

__print = __print or print
function print(...)
    __log(...)
    __print(...)
end

function log(...)
    __log(...)
    __print(...)
end

function __log(...)
    local t = table()
    for i,v in ipairs({...}) do
        t[i] = tostring(v)
    end
    
    local text = t:concat('  ') or ''

    if not logs[text] then
        logs[text] = {
            count = 0,
            text = text
        }
        logs:insert(logs[text])
    end

    logs[text].count = logs[text].count + 1
end

function implement(...)
    return log(...)
end


class 'Console' : extends(Window)

function Console:init(x, y, w, h)
    self.appName = 'console'    
        
    w = w or screen.w
    h = h or safeArea.dy
    
    x = x or 0
    y = y or (screen.h - h)
    
    Window.init(self, self, x, y, w, h)
    self.index = 1
end

function Console:draw()
    local index = self.index

    background()
    for i=index,#logs do
        local log = logs[i]
        if log.count > 1 then
            text(log.count..' '..log.text, 15)
        else
            text(log.text, 15)
        end
        if styles.yText > self.size.h then
            self.index = self.index + 1
            break
        end
    end
end
