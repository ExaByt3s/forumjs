const { app, BrowserWindow } = require('electron');

let win;

function createWindow() {
    
}

app.on('ready', () => {
    win = new BrowserWindow({ width: 640, height: 480 });
    win.loadFile('index.html');
    win.on('closed', () => {
        win = null;
    });
});

app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') {
        app.quit();
    }
});
