function setup()    
    parameter.link('CodingChallenges #30', 'https://thecodingtrain.com/CodingChallenges/030-phyllotaxis.html')

    parameter.integer('spacing', 2, 20, 4)
    parameter.number('theta', 130, 145, 137.5)

    local function setTheta(label)
        theta = tonumber(label)
        n = 0
    end

    parameter.action('137.3', setTheta)
    parameter.action('137.5', setTheta)
    parameter.action('137.7', setTheta)

    n = 0
end

local cos, sin, deg, rad, sqrt = math.cos, math.sin, math.deg, math.rad, math.sqrt

function autotest()
    if not env.__sliderInTest or not env.__sliderInTest.tween.active then
        for i,ui in ipairs(parameter.instance.scene:items()) do
            if ui.__className == 'Slider' and not ui.tween then
                ui:setValue(ui.min)
                ui.tween = tween(2, ui, {value=ui.max})
                env.__sliderInTest = ui
                break
            end        
        end
    else
        env.__sliderInTest:setValue(env.__sliderInTest.value)
    end    
end

function draw()
    background(51)

    translate(W/2, H/2)
    rotate(rad(n/10))

    local size = spacing - 1

    for i=0,n-1 do
        local radius = spacing * sqrt(i)

        local angle = i * rad(theta)

        local x = radius * cos(angle)
        local y = radius * sin(angle)

        strokeSize(size*2)
        stroke(Color.hsl(((deg(angle)-radius)%360)/360, 1, 0.5))

        point(x, y)
    end

    n = n + 10
end
