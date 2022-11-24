function setup()
    setOrientation(LANDSCAPE)

    player = Player()
    :attribs{
        size = vec2(32, 64),
        position = vec2(W/2, H*7/8),
    }

    bombs = Node()
    aliens = Node()

    scene:add(player)
    scene:add(bombs)
    scene:add(aliens)

    local alien
    for i=1,10 do
        alien = Alien()
        :attribs{
            size = vec2(32, 64),
            position = vec2(W/2, H/2),
        }
        aliens:add(alien)

        tween(0.6, alien.position, {x = i * 100, y = 150})
    end

    scene:add(
        {
            update = function (dt)
                for i,bomb in bombs:iter(true) do
                    if bomb.position.y <= 100 then
                        bombs:remove(i)
                    end
                end

                for i,bomb in bombs:iter(true) do
                    for j,alien in aliens:iter(true) do
                        if alien:intersect(bomb) then
                            bombs:remove(i)
                            aliens:remove(j)
                        end
                    end
                end
            end
        })
end

class 'SpriteObject' : extends(Object)

function SpriteObject:init(spriteName)
    Object.init(self)
    self.img = Image(spriteName)
end

function SpriteObject:draw()
    spriteMode(CENTER)
    sprite(self.img, 0, 0, self.size.x, self.size.y)
end

class 'Player' : extends(SpriteObject)

function Player:init()
    SpriteObject.init(self, 'documents:joconde')
end

function Player:update(dt)
    local speed = dt * 250
    if isDown('left') then
        self.position:add(vec2(-speed, 0))

    elseif isDown('right') then
        self.position:add(vec2(speed, 0))
    end

    self.position.x = clamp(player.position.x,
        self.size.x,
        W - self.size.x)
end

function keyboard(key)
    if key == 'space' then 
        bombs:add(Bomb(player.position.x, player.position.y))
    end
end

class 'Bomb' : extends(Object)

function Bomb:init(x, y)
    Object.init(self)
    self.position:set(x, y)
    self.size:set(4, 12)
end

function Bomb:update(dt)
    local speed = dt * 400
    self.position.y = self.position.y - speed
end

function Bomb:draw()
    rect(0, 0, self.size.x, self.size.y)
end

class 'Alien' : extends(SpriteObject)

function Alien:init()
    SpriteObject.init(self, 'documents:joconde')
end
