function log_clear() {
    const ui = document.getElementById("log");
    ui.innerHTML = '';
    log.apply(undefined, arguments);
}

function log() {
    const ui = document.getElementById("log");
    let txt = '';
    for (const arg of arguments) {
        txt += arg + ' ';
        console.log(arg);
    }
    ui.innerHTML += txt + '<br>';
}

print = log;
