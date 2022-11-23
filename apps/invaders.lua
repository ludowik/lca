function setup()
    setOrientation(PORTRAIT)
    
    scene = Scene()
    scene:add(SpriteObject('documents:joconde')
        :attribs{
            size = vec2(32, 32),
            position = vec2(W/2, H*3/4),
        })
end

function draw()
    scene:draw()
end

class 'SpriteObject' : extends(MeshObject)

function SpriteObject:init(spriteName)
    self.img = Image(spriteName)
end

function SpriteObject:draw()
    spriteMode(CENTER)
    self.img:draw(0, 0, self.size.x, self.size.y)
end
