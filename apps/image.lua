function setup()
    n = n or 200
    img = Image(n, n)
    setContext(img)
    background(0, 0, 0, 0)
    ellipseMode(CENTER)
    for i=n,1,-1 do
        noStroke()
        fill(1, 1, 1, map(i, 1, n, 1, 0))
        ellipse(n/2, n/2, i, i)
    end
    setContext()
end

function draw()
    sprite(img, W/2, H/2)
end
