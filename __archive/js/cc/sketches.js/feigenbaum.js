class Feigenbaum extends Sketch {
    init() {
        this.params = {
            y: 0.5,
            yMin: 0.0,
            yMax: 1.0,
            yStep: 0.05,
            yOnChange: () => this.reset(),
        };

        this.reset();
    }

    reset() {
        this.start = true;
    }

    render() {
        if (this.start) {
            background(colors.white);

            stroke(colors.black);
            strokeWeight(1);

            this.base = minSize * 0.9;
            line(0, this.base, width, this.base);

            this.start = false;
        }

        stroke(colors.black);
        strokeWeight(0.5);

        noFill();

        let rMin = 2;
        let rMax = 4;
        let rStep = 0.001;
        let iMax = 150;

        let ratio = minSize / (rMax - rMin);
        for (let r = rMin; r <= rMax; r += rStep) {
            this.y = this.params.y;
            for (let index = 0; index < iMax; index++) {
                this.y = r * this.y * (1 - this.y);
                if (index > iMax * 0.75) {
                    point((r - rMin) * ratio, this.base - this.y * minSize * 0.8);
                }
            }
        }
    }
}

setSketch(Feigenbaum);