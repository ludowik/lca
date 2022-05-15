let random = Math.random;

function randomInt(min, max) {
    if (max)
        return Math.floor(random() * (max - min) + min);
    else
        return Math.floor(random() * min);
}

function randomColor() {
    return color(random(), random(), random());
}

function randomPoint() {
    return new createVector(randomInt(width), randomInt(height));
}

function random2D(len = 1) {
    return p5.Vector.random2D().mult(len);
}

function noiseColor() {
    return color(random(), random(), random());
}

function noiseScale(x, y) {
    return noise(x * 0.005, y * 0.005);
}