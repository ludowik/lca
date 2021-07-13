function setup()
    win.position.x = 100
    win.position.y = 100

    scene = Scene()
    scene:add(UI('apps.the2048'))
    scene:add(UI('apps.creativeCoding.colors'))
    scene:add(UI('apps.morpion.morpion'))
end

function draw()
    background(51)
    scene:draw()
end

function touched(touch)
    scene:touched(touch)
end

class 'UI' : extends(Rect)

function UI:init(label)
    self:super(0, 0, 100, 32)
    self.label = label

    self:computSize()
end

function UI:computSize()
    self.w, self.h = textSize(self.label)
end

function UI:draw()
    text(self.label, self.x, self.y)
end

class 'Scene' : extends(table)

function Scene:layout()
    local x, y = 0, 0
    for i,node in ipairs(self) do
        node.y = y
        y = y + node.h
    end
end

function Scene:touched(touch)
    if touch.state == RELEASED then
        local x, y = 0, 0
        for i,node in ipairs(self) do
            if node:contains(touch.x, touch.y) then
                log('click on '..node.label)
                loadApp(node.label)
            end
        end
    end
end

function Scene:draw()
    self:layout()

    for i,node in ipairs(self) do
        pushMatrix()
        translate(node.x, node.y)
        node:draw()
        popMatrix()
    end    
end
