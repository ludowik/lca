function gcd(a, b) {
    if (a < b) {
        [a, b] = [b, a];
    }
    let m = a % b;
    if (m === 0) {
        return b;
    }
    return this.gcd(b, m);
}

function coprime(a, b) {
    return this.gcd(a, b) === 1 ? true : false;
}

function cofactor(a, b) {
    return this.gcd(a, b) !== 1 ? true : false;
}

function prime(a) {
    if (a <= 1) return false;
    for (let i = 2; i <= sqrt(a); i++) {
        if (a % i === 0) {
            return false;
        }
    }
    return true;
}

function fract(v) {
    return v - floor(v);
}

radians = Math.radians;
rad = radians;

min = Math.min;
max = Math.max;
cos = Math.cos;
sin = Math.sin;
