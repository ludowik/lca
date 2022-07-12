let colors;

class Colors extends Component {
    constructor() {
        super();
        colorMode(RGB, 1);
        this.push({
            transparent: color(0, 0, 0, 0),

            white: color(1, 1, 1),
            black: color(0, 0, 0),

            gray: color(0.5, 0.5, 0.5),

            red: color(1, 0, 0),
            green: color(0, 1, 0),
            blue: color(0, 0, 1),

            yellow: color(1, 1, 0),
            purple: color(1, 0, 1),
            cyan: color(0, 1, 1),
        });

        colors = this;

        Color = {
            random: randomColor,
        };
    }

    reverse(clr) {
        return color(
            1 - clr._array[0],
            1 - clr._array[1],
            1 - clr._array[2],
            1
        );
    }
}
