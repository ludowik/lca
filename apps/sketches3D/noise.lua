App('AppMap')

function AppMap:release()
    self.map:clear()
end

function AppMap:init()
    Application.init(self)

    supportedOrientations(LANDSCAPE_ANY)
    
    setOrigin(BOTTOM_LEFT)

    self.imageSize = 512

    function generate(batchMode, map, f, clr, dt)
        clr = clr or colors.white

        local clockStart = os.clock()

        local clockCurrent = 0
        local clockDelay = 0

        local variation = 0.012123

        local h1, h2, h3, h4
        local clr1, clr2, clr3, clr4

        local n = 10

        local w = round(self.imageSize / n)
        local h = round(self.imageSize / n)

        local size = 10

--        local vectorsArray = ffi.typeof('vec3[?]')
--        local colorsArray = ffi.typeof('color[?]')

        for ib=0,n-1 do
            for jb=0,n-1 do
                local block = Mesh()
                block.shader = shaders.default

                map:add(block)

                block.vectorsArray = Buffer('vec3'):alloc(6*w*h) -- vectorsArray(4*(w+1)*(h+1))

                local iVector, vec = 0
                local function vector(x, y, z)
                    iVector = iVector + 1
                    local vec = block.vectorsArray[iVector]
                    vec.x = x
                    vec.y = y
                    vec.z = z
                    return vec
                end

                block.colorsArray = Buffer('color'):alloc(6*w*h) -- colorsArray(4*(w+1)*(h+1))

                local iColor = 0
                local function color(r, g, b, a)
                    local clr = block.colorsArray[iColor]
                    iColor = iColor + 1
                    clr.r = r
                    clr.g = g
                    clr.b = b
                    clr.a = a or 1
                    return clr
                end

                local i = 1

                local x, xp = ib*w*size, ib*w*variation
                for xi=0,w-1 do
                    x = x + size
                    xp = xp + variation

                    local y, yp = jb*h*size, jb*h*variation
                    for yi=0,h-1 do
                        y = y + size
                        yp = yp + variation

                        h1 = f(xp, yp)
                        h2 = f(xp+variation, yp)
                        h3 = f(xp+variation, yp+variation)
                        h4 = f(xp, yp+variation)

                        clr1 = Color(h1 * clr.r, h1 * clr.g, h1 * clr.b)
                        clr2 = Color(h2 * clr.r, h2 * clr.g, h2 * clr.b)
                        clr3 = Color(h3 * clr.r, h3 * clr.g, h3 * clr.b)
                        clr4 = Color(h4 * clr.r, h4 * clr.g, h4 * clr.b)

                        block.vertices[i+0] = vector(x     , h1, y)
                        block.vertices[i+1] = vector(x+size, h3, y+size)
                        block.vertices[i+2] = vector(x+size, h2, y)
                        block.vertices[i+4] = vector(x     , h4, y+size)

                        block.vertices[i+3] = block.vertices[i+0]
                        block.vertices[i+5] = block.vertices[i+1]

                        block.colors[i+0] = clr1
                        block.colors[i+1] = clr3
                        block.colors[i+2] = clr2
                        block.colors[i+3] = clr1
                        block.colors[i+4] = clr4
                        block.colors[i+5] = clr3

                        i = i + 6
                    end

                    block.needUpdate = true

                    clockCurrent = os.clock()
                    clockDelay = clockCurrent - clockStart

                    if batchMode and clockDelay > 1/Engine.frameTarget then
                        coroutine.yield()
                        clockStart = os.clock()
                    end
                end

                Model.computeNormals(block)
            end
        end
    end

    self.map = Node()

    function generateAll(batchMode)
        generate(batchMode, self.map, noise, green, dt)
    end

    local batchMode = false
    if batchMode then
        self.thread = coroutine.create(function (dt)
                generateAll(true)
            end)
    else
        generateAll(false)
    end

    self.scene.physicsOn = true

    local z = self.imageSize * 10

    self.scene:add(MeshObject(self.map):attribs{
            scale = vec3(1, 200, 1),
            position = vec3(0, 0, 0)
        })

    camera(0, 500, 500, self.imageSize*10/2, 0, self.imageSize*10/2)
end

function AppMap:draw()
    background(69)
    
    perspective()
    
    self.scene:draw()
end
