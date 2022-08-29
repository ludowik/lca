-- graphics
color = Color
font = fontName
strokeWidth = strokeSize

fill = __fill

class 'image'

image.rgba16f = 'rgba16f' 

function image:init(img, ...)
    if img == CAMERA then return CAMERA end
    return Image(img, ...)
end

function saveImage(path, img)
    img:save(path)
end

function readImage(...)
    return Image(...)
end

function shader(...)
    return Shader(...)
end
