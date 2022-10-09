class 'Editor' : extends(UI) 

function Editor:init()
    UI.init(self)
    self.label = [[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur ac risus non ante commodo ornare. Maecenas quis eros lectus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Proin sodales, dui non feugiat eleifend, dui diam cursus sem, ut vulputate lectus enim ornare arcu. Nullam tristique mauris sapien, eget pharetra neque fermentum porta. Nullam sed dignissim nulla. Maecenas nunc orci, tincidunt vel ipsum quis, aliquam posuere lectus.
Cras quis bibendum lorem, sed rutrum eros. Integer venenatis, ante ornare mattis ultrices, mauris urna porta sem, eget accumsan enim quam in ligula. Suspendisse potenti. Morbi nunc lectus, venenatis ac dolor eu, convallis gravida velit. Ut bibendum egestas cursus. Maecenas massa diam, pretium non tempus in, cursus ut odio. Fusce ac pulvinar mi. Integer elit libero, accumsan ac lacinia quis, pulvinar et nunc. Maecenas id ex ligula. Morbi quis sollicitudin leo.
Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Aliquam erat volutpat. Donec vulputate malesuada arcu non consequat. Etiam eget eros et mi eleifend consectetur ut et quam. Etiam pulvinar, turpis in vehicula auctor, augue augue elementum dui, et ultrices ante felis in est. Sed fringilla eros convallis mi bibendum venenatis. Ut vitae justo hendrerit, vulputate ligula eget, auctor erat. Phasellus accumsan faucibus enim. Pellentesque sed nibh sapien. Aliquam erat risus, pellentesque sed sem non, malesuada iaculis massa. In ullamcorper varius sagittis. Ut gravida nec erat eu sodales. Donec rhoncus orci quis lectus pharetra faucibus.
Nullam ornare consectetur arcu, eget pharetra tellus viverra nec. Sed tempus auctor tristique. In quis eleifend odio, interdum hendrerit sem. Fusce in orci maximus, dapibus sapien nec, laoreet risus. Mauris urna nisi, finibus at ornare et, faucibus a nunc. Vestibulum magna dui, suscipit ac porttitor quis, efficitur quis nunc. Morbi enim ante, suscipit nec imperdiet vel, porttitor convallis orci.
]]
  
end

function Editor:computeSize()
    self.size.x = ws(6)
    self.size.y = hs(4)
end

function Editor:draw()
    text(self.label, 0, 0, self.size.x, self.size.y)
end

function Editor:touched(touch)
    self.focus = not self.focus

    if self.focus then
        showKeyboard()
    else
        hideKeyboard()
    end
end

-- TODO : connect input
function Editor:keyboard(key)
    assert()
    self.label = self.label or ''

    if key == 'space' then
        self.label = self.label..' '

    elseif key == 'backspace' then
        if #self.label > 0 then
            self.label = self.label:left(#self.label-1)
        end

    else
        self.label = self.label..key
    end
end
