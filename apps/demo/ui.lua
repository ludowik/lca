function setup()
    app = env

    parameter.watch('parameter')
    parameter.watch('yesno')

    parameter.watch('isButtonDown(BUTTON_LEFT)')
    parameter.watch('isButtonDown(BUTTON_RIGHT)')

    parameter.watch('Couleur')

    parameter.boolean('MyBoolean', true)

    parameter.integer('nbGroups' , 1, 10, 2, reset)
    parameter.integer('nbButtons', 1, 10, 2, reset)

    parameter.integer('gridSize' , 2, 6, 2, reset)


    app.uiScene = MenuBar(0, HEIGHT)
    app.uiScene.alignment = 'v-center,h-center'

    local tabs = Tabs('boîte à onglet')
    app.uiScene:add(tabs)

    local tab = Tab()
    tabs:addTab(tab)

    tab:add(Label('Label'))
    tab:add(Button('Button', function () print('button clicked') end))
    tab:add(ButtonImage('res/images/joconde.png'))
    tab:add(Sprite('res/images/joconde.png'))
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

    parameter.integer('env.app.uiScene.innerMarge' , 0, 20, 5, reset)
    parameter.integer('env.app.uiScene.outerMarge' , 0, 20, 5, reset)
end

function reset()
    nbGroups = nbGroups or 1
    nbButtons = nbButtons or 1

    gridSize = gridSize or 2

    local gridScene = UIScene(Layout.grid, gridSize)
    env.ui = UIScene(Layout.column):add(
        env.uiScene,
        gridScene)

    env.ui.alignment = 'v-center,h-center'

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
    app.uiScene.position:set(100, 100)
    app.uiScene:draw()
end

function touched(touch)
    app.uiScene:touched(touch)
end
