Physics = class()

function Physics.setup()
    CIRCLE = 'circle'
    RECT = 'rect'
end

function Physics:init(xg, yg)
    love.physics.setMeter(64)

    xg = xg or 0
    yg = yg or -9.81*64

    self.world = love.physics.newWorld(x, y, true)
end

function Physics:body(entity, shapeType)
    local body = love.physics.newBody(self.world, entity.position.x, entity.position.y, 'dynamic')
    local shape
    if shapeType == CIRCLE then
        shape = love.physics.newCircleShape(entity.size.w)
    elseif shapeType == RECT then
        shape = love.physics.newRectangleShape(entity.size.w, entity.size.h)
    end
    local fixture = love.physics.newFixture(body, shape)
    entity.body = fixture
end

function Physics:edge(x1, y1, x2, y2)
    local body = love.physics.newBody(self.world, 0, 0, 'static')
    local shape = love.physics.newEdgeShape(x1, y1, x2, y2)
    local fixture = love.physics.newFixture(body, shape)
    fixture:setFriction(0)
    fixture:setRestitution(1)
    return fixture
end

function Physics:update(dt)
    self.world:update(dt)
end

function Physics:draw()
    love.graphics.setColor(red:unpack())
    
    for _,body in pairs(self.world:getBodies()) do
        for _,fixture in pairs(body:getFixtures()) do
            local shape = fixture:getShape()

            if shape:typeOf("CircleShape") then
                local cx, cy = body:getWorldPoints(shape:getPoint())
                love.graphics.circle("line", cx, cy, shape:getRadius())

            elseif shape:typeOf("PolygonShape") then
                love.graphics.polygon("line", body:getWorldPoints(shape:getPoints()))

            else
                love.graphics.line(body:getWorldPoints(shape:getPoints()))
            end
        end
    end
end
