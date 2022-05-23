ListBox = class('ListBox') : extends(UI)

function ListBox:init(list)
    UI.init(self)
    
    self.list = table()
    for k,v in pairs(list) do
        self.list:add({k=k, v=v})
    end
    
    self.size = vec2(200, 200)
end

function ListBox:touched(touch)
end

function ListBox:draw()
    local position = self.position:clone()
    for i,item in ipairs(self.list) do
        item.position = position:clone() 
        item.position.y = styles.yText
        
        text(item.k)
    end
end


function setup()
    viewer.mode = FULLSCREEN
    
    scene = table()
    scene:add(ListBox(asset.documents))
        
--    content = love.filesystem.read(asset.documents.Ide.Main)
    
--    local x = 50
--    local y = HEIGHT - layout.safeArea.top - 50
    
--    local w, h = 250, 450
--    editor = Editor(x, y, w, h)
    
--    menu = Menu()
--    menu:add(Command("keyboard", function ()
--        if isKeyboardShowing() then
--            hideKeyboard()
--        else
--            showKeyboard()
--        end
--    end))
    
--    menu:add(Slider("sizeSpace", 10, 50, 10))
    
--    scene = table()
--    scene:add(editor)
--    scene:add(menu)
end

local regexList = {
    {'space', '%s+'},
    
    {'keyword', 'local'},
    {'keyword', 'function'},
    {'keyword', 'do'},
    {'keyword', 'end'},
    {'keyword', 'if'},
    {'keyword', 'else'},
    {'keyword', 'elseif'},
    {'keyword', 'then'},
    {'keyword', 'for'},
    {'keyword', 'while'},
    
    {'alpha', '%w+'},
    
    {'parenthesis', '%('},
    {'parenthesis', '%)'},
    
    {'none', '%S+'},
}

function lexical(content)
    local t = table()
    while content:len() > 0 do
        local token = {}
        local start, len
        for i,regex in ipairs(regexList) do
            start, len = content:find('^'..regex[2])
            
            if start then
                token.type = regex[1]
                break
            end
        end
        assert(start == 1)
        
        token.word = content:sub(start, len)
        t:add(token)
        
        content = content:sub(len+1)
    end
    return t
end

function update(dt)
    scene:update(dt)
end

function draw()
    update(deltaTime)
    background(0)
    
    scene:draw()
end

local keywords = {
    ["local"] = red,
    ["function"] = green,
    ["do"] = blue,
}

Editor = class(Command)

function Editor:init(x, y, w, h)
    Command.init(self)
    self.position = vec2(x, y)
    self.size = vec2(w, h)
    self.offset = 0
end

function Editor:draw()
    local x, y, w, h = self.position.x, self.position.y, self.size.x, self.size.y
    local xt, yt = 0, -self.offset
    
    fill(255)
    
    font("CourierNewPSMT")
    fontSize(12)
    
    clip(x, y-h, w, h)
    
    local lines = content:split("\n") 
    
    textMode(CORNER)
    for i,line in ipairs(lines) do
        if #line > 0 then
            local wt, ht = textSize(line)
            xt = 0
            yt = yt + ht
            
            if yt >= 0 then
                local tokens = lexical(line)
                for j,token in ipairs(tokens) do
                    local word = token.word
                    if token.type == 'space' then
                        xt = xt + sizeSpace * word:len() / 4
                    else
                        local ww, hw = textSize(word)
                        
                        if token.type == 'keyword' then
                            fill(keywords[word] or color(233, 80, 200))
                            
                        elseif token.type == 'parenthesis' then
                            fill(255, 0, 0)
                        else
                            fill(255)
                        end
                        text(word, x + xt, y - yt)
                        xt = xt + ww
                    end
                end
            end
        else
            yt = yt + fontSize()
        end
    end
    
    self.ht = yt + self.offset - fontSize()
    
    clip()
    
    noFill()
    strokeSize(2)
    stroke(255)
    rectMode(CORNER)
    rect(x, y-h, w, h)
end

function Editor:touched(touch)
    self.offset = min(self.ht, max(0, self.offset + touch.delta.y))
end 