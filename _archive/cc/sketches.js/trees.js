class Trees extends Sketch {
    init() {
        noLoop();
        this.params.reset = () => redraw();
        this.params.branches = 2;
        this.params.branchesMax = 6;
        this.params.branchesStep = 1;
    }

    line(ax, ay, aa, x, y, a, l, level) {
        if (level === 0) {
            return;
        }

        push();

        translate(x, y);
        rotate(a);

        strokeWeight(level);
        if (l > 10) {
            stroke(155 / 255, 103 / 255, 60 / 255, 1);//, level / 10);
        } else {
            stroke(0, 1, 0, 1);//level / 10);
        }

        vertex(ax, ay);
        aa += a;
        ax += sin(-aa) * l;
        ay += cos(-aa) * l;
        vertex(ax, ay);

        line(0, 0, 0, l);

        level--;

        this.line(ax, ay, aa, 0, l, -PI / random(4, 8), l * random(0.3, 0.8), level);
        this.line(ax, ay, aa, 0, l, +PI / random(4, 8), l * random(0.3, 0.8), level);

        for (const i of range(this.params.branches)) {
            this.line(ax, ay, aa, 0, l, random(-PI / 4, PI / 4), l * random(0.5, 0.8), level);
        }

        pop();
        this.count++;
    }

    render() {
        background(colors.black);
        scale(1, -1);
        translate(0, -height * 0.95);

        beginShape(LINES);
        this.count = 0;
        let l = random(4, 8);
        this.line(xc, 0, 0, xc, 0, 0, height / l, 8);

        translate(0, height / 2);
        endShape();
    }
}

setSketch(Trees);
