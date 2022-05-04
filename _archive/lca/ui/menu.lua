class 'Menu' : extends(UIScene)

function Menu:init()
    UIScene.init(self)
end

class 'MenuBar' : extends(Menu)

function MenuBar:init()
    Menu.init(self)
end
