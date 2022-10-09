function setup()
    env.uiScene = MenuBar(0, HEIGHT)
    env.uiScene.alignment = 'v-center,h-center'

    local tabs = Tabs('boîte à onglet')
    env.uiScene:add(tabs)

    local tab = Tab()
    tabs:addTab(tab)

    tab:add(Label('Label'))
    tab:add(Button('Button', function () print('button clicked') end))
    tab:add(ButtonImage('documents:joconde', function () print('joconde clicked') end))
    tab:add(Sprite('documents:joconde'))
    tab:add(Separator())
    tab:add(UISpace())
    tab:add(Separator())

    tab = Tab()
    tabs:addTab(tab)

    tab:add(Button():setstyles{bgColor=colors.red})
    tab:add(Button():setstyles{bgColor=colors.blue})
    tab:add(ColorPicker('Couleur', red, function (clr)
                print('new color : '..tostring(clr))
            end))
    tab:add(CheckBox('yesno'))
    tab:add(Editor('Editor'))

    gridScene = UIScene(Layout.grid, gridSize)
    tab = Tab()
    tabs:addTab(tab)
    tab:add(gridScene)
    
    parameter.watch('parameter')
    parameter.watch('yesno')

    parameter.watch('isButtonDown(BUTTON_LEFT)')
    parameter.watch('isButtonDown(BUTTON_RIGHT)')

    parameter.watch('Couleur')

    parameter.boolean('MyBoolean', true)

    parameter.integer('nbGroups' , 1, 10, 2, reset)
    parameter.integer('nbButtons', 1, 10, 2, reset)

    parameter.integer('gridSize' , 2, 6, 2, reset)

    parameter.integer('env.uiScene.innerMarge' , 0, 20, 5, reset)
    parameter.integer('env.uiScene.outerMarge' , 0, 20, 5, reset)
end

function reset()
    nbGroups = nbGroups or 1
    nbButtons = nbButtons or 1

    gridSize = gridSize or 2

    env.ui = env.uiScene
    env.ui.alignment = 'v-center,h-center'
    
    gridScene:clear()

    for i=1,nbGroups do
        local node = UIScene(Layout.grid, gridSize)
        gridScene:add(node)

        bgColor = Color(i/4, 0, 0)

        for j=1,nbButtons do
            node:add(Button(i..'.'..j):attribs{
                    bgColor = bgColor
                })
        end
    end
end

function draw()
    background()
    env.ui:draw()
end

function touched(touch)
    env.ui:touched(touch)
end
