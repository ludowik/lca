CloudLevels = class()

CULLPADDING = 300

function CloudLevels:init()
    -- you can accept and set parameters here
    self.clouds = {}
    self.nextCloudHeight = 100
end

function CloudLevels:generateNextCloud()
    cloud = Cloud()
    cloud.position = vec2(math.random(-WIDTH/2,WIDTH/2),
                          self.nextCloudHeight)
    
    table.insert(self.clouds, cloud)
    
    self.nextCloudHeight = self.nextCloudHeight + math.random(150,300)
end

function CloudLevels:cullClouds(floor)
    for i,v in ipairs(self.clouds) do
        if v.position.y < floor then
            table.remove(self.clouds,i)
        end
    end
end

function CloudLevels:isColliding(pos)
    for i,v in ipairs(self.clouds) do
        if v:isColliding(pos) then
            return true
        end
    end
    
    return false
end

function CloudLevels:update(cam)
    curHeight = -cam.y + HEIGHT + CULLPADDING
    
    if curHeight > self.nextCloudHeight then
        self:generateNextCloud()
    end
    
    self:cullClouds(-cam.y - CULLPADDING)
end

function CloudLevels:draw()
    -- Codea does not automatically call this method
    for i,v in ipairs(self.clouds) do
        v:draw()
    end
end

function CloudLevels:touched(touch)
    -- Codea does not automatically call this method
end
