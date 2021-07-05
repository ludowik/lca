local logs = table()

local __print = print
function print(...)
    log(...)
    __print(...)
end

function log(...)
    local text = table{...}:concat('  ')

    if not logs[text] then
        logs[text] = {
            count = 0,
            text = text
        }
        logs:insert(logs[text])
    end

    logs[text].count = logs[text].count + 1
end

class 'Console' : extends(Window)

function Console:init(x, y)
    self:super(self, x or 0, y or (H-100), W, 100)
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
        if styles.yText > self.position.h then
            self.index = self.index + 1
            break
        end
    end
end
