class 'Tabs' : extends(UIScene)

--function Tabs:init()
--    UIScene.init(self)
--end

function Tabs:addTab(tab)
    UIScene.add(self, tab)
end

function Tabs:draw()
    UIScene.draw(self)
    
    stroke(colors.red)
    noFill()
    rect(0, 0, self.size.w, self.size.h)
end

class 'Tab' : extends(UIScene)

--function Tab:init()
--    UIScene.init(self)
--end

function Tab:draw()
    UIScene.draw(self)
    
    stroke(colors.blue)
    noFill()
    rect(0, 0, self.size.w, self.size.h)
end