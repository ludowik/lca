function setup()
    env.ui = MenuBar()

    env.ui:add(UIScene(Layout.row):addItems{
            Slider('slider', 0, 100, 50),
            ButtonImage('documents:joconde'),
            Button('button'),
        })

    env.ui:add(UIScene(Layout.row):addItems{
            Slider('slider', 0, 100, 50),
            ButtonImage('documents:joconde'),
            Button('button'),
        })

    env.ui:add(UIScene(Layout.column):addItems{
            Slider('slider', 0, 100, 50),
            ButtonImage('documents:joconde'),
            Button('button'),
        })

    env.ui:add(UIScene(Layout.grid, 3):addItems{
            Slider('slider', 0, 100, 50),
            ButtonImage('documents:joconde'),
            Button('button'),
            Button('button'),
            ColorPicker(),
            Button('button'),
            CheckBox('button'),
            ComboBox('button'):list({'1', '2'}, 1),
            Button('button'),
            Button('button'),
            Button('button'),
            Button('button'),
        })
end
