function setup()    
    setOrigin(BOTTOM_LEFT)

    env.ui = UIScene()
    env.scene = Scene()

    createUI()

    local modelName = readProjectData('modelName', 'teapot')
    setModelName(modelName)

    env.scene.camera = Camera(2, 1, 3)
end

function createUI()
    createUIObjects()
    createUILight()
end

function createUIObjects()
    menuObjects = menuObjects or MenuBar()
    menuObjects:clear()

    menuObjects:add(Expression('env.model.shader.name'))

    menuObjects:add(Expression('#env.model.vertices'))
    menuObjects:add(Expression('#env.model.texCoords'))
    menuObjects:add(Expression('#env.model.colors'))
    menuObjects:add(Expression('#env.model.normals'))

    menuObjects:add(
        ListBox('model', 
            {
                'plane',
                'box',
                'sphere',
                'pyramid',
                'tetrahedron',
                'planet',    
                'teapot',
                'trumpet',
                'airboat',
                'roi',
                'shuttle',
                'dragon',
                'musclecar',
                "rubyk's cube"
            },
            function (ui, modelName) 
                setModelName(modelName)
            end))

    env.ui:add(menuObjects)
end

function createUILight(reset)
    menuLights = menuLights or MenuBar()
    menuLights:clear()

    menuLights:add(Button('light',
            function (btn)
                config.light = not config.light
            end))

    menuLights:add(Button('reset',
            function (btn)
                Light.reset()
                createUILight(false)
            end))

    if lights then
        for i,light in pairs(lights) do
            menuLights:add(CheckBox(tostring(i)):bind(lights[i], 'state'))
        end
    end

    if reset == nil then
        env.ui:add(menuLights)
    end
end

function setModelName(modelName)
    local model, keepColor = nil, false

    if modelName == 'plane' then
        model = Model.plane()

    elseif modelName == 'box' then
        model = Model.box()

    elseif modelName == 'sphere' then
        model = Model.sphere()

    elseif modelName == 'planet' then
        model = Model.sphere()
        model.shader = shaders['terrain']

    elseif modelName == 'pyramid' then
        model = Model.pyramid()

    elseif modelName == 'tetrahedron' then
        model = Model.tetrahedron()

    elseif modelName == "rubyk's cube" then
        model = Mesh()
        for x=1,3 do
            for y=1,3 do
                for z=1,3 do
                    Model.add(model, Model.box(x-2, y-2, z-2, 1, 1, 1):setColors(color.random()))
                end
            end
        end
        keepColor = true

    elseif modelName then
        model = Model.load(modelName, true) or Model.box()

    else
        model = Model.box()
    end

--    model.shader = model.shader or shaders['model3d']

    setModel(model:normalize(2):center(), keepColor)

    saveProjectData('modelName', modelName)
end

function setModel(model, keepColor)
    env.model = model

    env.scene:clear()
    env.scene:add(model)

    if not keepColor then
        model:setColors(colors.white)
    end

    return model
end

function update(dt)
    env.ui:update(dt)
    env.scene:update(dt)
end

function draw()
    background()
    
    perspective()
    light(true)
    
    env.scene:draw()

    resetMatrix(true)
    env.ui:draw()
end

function touched(touch)
    env.ui:touched(touch)
end

function keypressed(key)
    if key == 'up' then
        camera():zoom(0, 10)
    elseif key == 'down' then
        camera():zoom(0, -10)
    end
end
