function ChoiceList(title, list, callback)
    local scene = UIScene()
    scene:setAlignment('v-center, h-center')
    scene:add(Label(title))
    
    for i,item in ipairs(list) do
        scene:add(Button(item.name, function () callback(item) end))
    end
    
    return scene
end
