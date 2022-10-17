function setup()
    env.ui = UIScene()
    
    local ui = env.ui
    
    local group = MenuBar()
    ui:add(group)
    
    ui = group
    
    local tabs = Tabs()
    ui:add(tabs)
    
    local tab = Tab('un groupe')
    tabs:addTab(tab)
    
    tab:add(Button('hell world!'))
    tab:add(Button('hell world!'))
    
    tab = Tab('un 2ème groupe')
    tabs:addTab(tab)
    tab:add(Button('hell world!'))
    tab:add(Button('hell world!'))
    tab:add(Button('hell world!'))
end

function draw()
    background()
    ui:draw()
end

function touched(touch)
    ui:touched(touch)
end
