require 'engine.engine'
require 'graphics.transform'
require 'graphics.styles'
require 'graphics.color'
require 'graphics.graphics2d'
require 'lua.math'
require 'lua.random'

if arg[#arg] == "-debug" then require("mobdebug").start() end

local angle
function setup()
    angle = 0
end

function update(dt)
    angle = angle + dt
end

function draw()
    local w = W/12
    
    rectMode(CENTER)
    
    seed(2423525)

    for j=0,14 do
        translate(0, w)

        pushMatrix()
        for i=0,9 do
            translate(w, 0)
            
            pushMatrix()
            do
                fill(colors.white)
                rotate((random()*2-1)*TAU*j/32)
                rect(0, 0, w-5, w-5)
            end
            popMatrix()
        end
        popMatrix()
    end
end
