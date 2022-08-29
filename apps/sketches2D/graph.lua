class 'classItem' : extends(Object)

function classItem:init(className, classRef)
    Object.init(self, classRef.__className or className)

    self.id = id('classItem')
    self.description = className

    self.classRef = classRef

    self.basesRef = attributeof('__bases', classRef) or table()

    self.childs = table()
    self.parents = table()

    local basesRef = self.basesRef

    self.level = 0
    while basesRef and #basesRef > 0 do
        self.level = self.level + 1
        basesRef = attributeof('__bases', basesRef[1])
    end

    self.position = vec2.random(W, H)
    self.force = vec2()

    fontName(DEFAULT_FONT_NAME)
    fontSize(10)

    self.size = vec2(textSize(self.description))
end

function classItem:draw()
    zLevel(-1)

    for i,v in ipairs(self.basesRef) do
        local base = env.scene:ui(v.__className)
        if base then
            local a = self.position
            local b = base.position

            local direction = b - a

            local start = direction * 0.1
            local to = direction * 0.9

            stroke(colors.gray)
            strokeSize(1)
            line(start.x, start.y, to.x, to.y)

            stroke(colors.red)
            strokeSize(5)
            point(to.x, to.y)
        end
    end

    zLevel(0)

    fill(colors.cyan)

    fontName(DEFAULT_FONT_NAME)
    fontSize(10)

    textMode(CENTER)
    text(self.description, 0, 0)
end

function setup()
    env.scene = Scene()

    for k,v in pairs(_G) do
        if type(v) == 'table' then
            local item = env.scene:ui(v.__className)
            if item == nil then
                item = classItem(k, v)
                env.scene:add(item)
            end
        end
    end

    for _,item in env.scene:iter() do
        for i,base in ipairs(item.basesRef) do
            local node = env.scene:ui(base.__className)
            if node then
                node.childs[item] = true
                item.parents[node] = true
            end
        end
    end

    parameter.number('pivot', 1, 1000, 80)
    parameter.number('attraction', 1, 1000, 160)
end

local map = math.map

function constraints(dt)
    local nodes = env.scene:items()
    local n = #nodes

    local a, b, direction, dist, a_position, a_force

    dt = dt * 5

    for i=1,n do
        nodes[i].force:set()
    end

    for i=1,n do
        a = nodes[i]

        a_position = a.position
        a_force = a.force

        for j=i+1,n do
            b = nodes[j]

            direction = b.position - a_position
            dist = direction:len()

            direction:div(dist)

            if dist < pivot then
                direction:mul(map(dist, 0, pivot, 10, 0))

            elseif a.childs[b] or a.parents[b] then
                direction:mul(-map(dist, pivot, W, 0, attraction))

            else
                direction:mul(-map(dist, pivot, W, 0, 10))
            end

            a_force:sub(direction)
            b.force:add(direction)
            
        end

        a_position:add(a_force:mul(dt))
    end
end

function rebase()
    local xmin, ymin, xmax, ymax = math.maxinteger, math.maxinteger, -math.maxinteger, -math.maxinteger

    local position

    for _,item in env.scene:iter() do
        position = item.position
        xmin = min(xmin, position.x)
        ymin = min(ymin, position.y)
        xmax = max(xmax, position.x)
        ymax = max(ymax, position.y)
    end

    local w = xmax - xmin
    local h = ymax - ymin

    local rx = W/w
    local ry = H/h

    for _,item in env.scene:iter() do
        position = item.position
        position.x = (position.x - xmin) * rx * 0.9 + 0.05 * W
        position.y = (position.y - ymin) * ry * 0.9 + 0.05 * H
    end
end

function update(dt)
    for i=1,2 do
        constraints(0.015)
        rebase()
    end
end

function draw()
    background()
    env.scene:draw()
end

function keyboard(key)
    if key == 'return' then
        for _,item in env.scene:iter() do
            item.position = vec2.random(W, H)
        end
    end
end
