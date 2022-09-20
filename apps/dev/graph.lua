class 'classItem' : extends(Object)

function classItem:init(className, classRef)
    Object.init(self, classRef.__className or className)

    self.id = id('classItem')
    self.description = className
    self.label = className

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

    self.position = vec2.random(1, 1)
    self.force = vec2()
    self.speed = vec2()

    fontName(DEFAULT_FONT_NAME)
    fontSize(10)

    self.size = vec2(textSize(self.description))
end

function classItem:draw()
    pushMatrix()
    translate(self.position.x, self.position.y)

    zLevel(-1)

    fontName(DEFAULT_FONT_NAME)
    fontSize(10)

    local w, h = textSize(self.description)

    for i,v in ipairs(self.basesRef) do
        local base = env.scene:ui(v.__className)
        if base then
            local a = self.position
            local b = base.position

            local direction = b - a

            local start = vec2(0, h/2)
            local to = direction - vec2(0, h/2)

            stroke(colors.red)
            strokeSize(1)
            line(-w/2, h/2, w/2, h/2)

            stroke(colors.gray)
            line(start.x, start.y, to.x, to.y)

            stroke(colors.green)
            strokeSize(5)
            point(to.x, to.y)
        end
    end

    zLevel(0)

    textColor(colors.cyan)

    textMode(CENTER)
    text(self.description, 0, 0)

    popMatrix()
end

function setup()
    env.scene = Scene()

    for k,v in pairs(_G) do
        if type(v) == 'table' and v.__className then
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

    parameter.number('pivot', 1, 1000, 50)
    parameter.number('attraction', 1, 1000, 160)
end

function constraints(dt)
    local nodes = env.scene:items()
    local n = #nodes

    local direction, dist

    for i=1,n do
        nodes[i].force:set()
    end

    for i=1,n do
        local a = nodes[i]

        for j=i+1,n do
            local b = nodes[j]

            if a ~= b then
                direction = b.position - a.position
                dist = direction:len()

                direction:normalizeInPlace()

                if a.childs[b] or b.childs[a] then
--                    if dist < pivot then
                    local speed = math.map(dist, pivot, 2*pivot, 0, 100)
                    local speed = math.exp(dist) * 100

                    a.force:add(-speed*direction)
                    b.force:add( speed*direction)
--                    end
                end

                local speed = math.log(dist+1) * 100 --  math.map(dist, 0, 10*pivot, 1000, 0)

                a.force:add(-speed*direction)
                b.force:add( speed*direction)
            end

        end
    end

    for i=1,n do
        local a = nodes[i]

        a.speed:add(a.force:mul(dt))
        a.position:add(a.speed:mul(dt))

        a.speed:mul(0.9)
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
    dt = dt *2

    local n = 4
    local dtn = dt/n
    for i=1,n do
        constraints(dt)
    end
    rebase()
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
