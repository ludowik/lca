class('Brick', Item)

function Brick:init(level, i, j, itemType)
    local w, h = CELL_SIZE - CELL_MARGE * 2, CELL_SIZE - CELL_MARGE * 2

    Item.init(self, i, j)

    self.itemType = itemType

    self.size = vec2(
        CELL_SIZE - CELL_MARGE * 2,
        CELL_SIZE - CELL_MARGE * 2)

    self.collision = level

    if itemType == CIRCLE then
        physics:add(self, STATIC, CIRCLE, self.size.x / 2)

    elseif itemType == POLYGON then
        local triangle = randomInt(1, 4)
        local triangles = {
            {vec2(-w/2, -h/2), vec2(w/2, -h/2), vec2(-w/2, h/2)},
            {vec2(-w/2, -h/2), vec2(w/2,  h/2), vec2(-w/2, h/2)},
            {vec2(-w/2, -h/2), vec2(w/2, -h/2), vec2( w/2, h/2)},
            {vec2( w/2, -h/2), vec2(w/2,  h/2), vec2(-w/2, h/2)}
        }
        physics:add(self, STATIC, POLYGON, triangles[triangle])

    elseif itemType == RECT then
        physics:add(self, STATIC, RECT, w, h)
    end
    
    print(itemType)

    self.body.restitution = 1
    self.body.friction = 0

    self.body.categories = {0}
    self.body.mask = {1}
end

function Brick:draw()
    noFill()

    local clr = Color()
    local from, to = colors.yellow, colors.red

    clr.r = map(self.collision, 1, level, from.r, to.r)
    clr.g = map(self.collision, 1, level, from.g, to.g)
    clr.b = map(self.collision, 1, level, from.b, to.b)

    stroke(clr)
    strokeSize(3)

    pushMatrix()
    do
        translate(self.position.x, self.position.y)

        rotate(self.body.angle)

        if self.body.shapeType == POLYGON then
            polygon(self.body.points)

        elseif self.body.shapeType == CIRCLE then
            circleMode(CENTER)
            circle(0, 0, self.size.x / 2)
        end
    end
    popMatrix()

    fill(colors.white)

    textMode(CENTER)
    text(self.collision, self.position.x, self.position.y)
end
