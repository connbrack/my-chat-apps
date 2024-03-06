const { app, shell, BrowserWindow, Tray, Menu, MenuItem } = require('electron');
const path = require('path');

const url = 'https://example.com/'
const appName = 'name__of__app__'

let mainWindow;
let tray;
const userAgent = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36'

const gotTheLock = app.requestSingleInstanceLock()

if (!gotTheLock) {
  app.quit()
} else {
  app.on('second-instance', () => {
    if (mainWindow) {
      forceShow();
    }
  })

  app.on('ready', () => {
    createWindow();
    createMenu();
    createContextMenu();
    createTray();
  })
}

app.on('activate', function () {
  if (mainWindow === null) {
    createWindow();
  }
});


function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1300,
    height: 800,
    spellcheck: true,
    autoHideMenuBar: true,
    backgroundColor: '#181926',
    icon: path.join(__dirname, 'icon.png'),
  });

  mainWindow.loadURL(url, {userAgent: userAgent});


  mainWindow.webContents.on('new-window', function(e, url) {
    e.preventDefault();
    require('electron').shell.openExternal(url);
  });


  mainWindow.webContents.setWindowOpenHandler(({ url }) => {
      shell.openExternal(url);
      return { action: 'deny' };
  });

  mainWindow.on('close', function (event) {
    if (!app.isQuiting) {
      mainWindow.webContents.setAudioMuted(true);
      event.preventDefault();
      mainWindow.hide();
    }
    return false;
  });

}

function createMenu() {
  // Define a template for your application's menu
  const template = [
    {
      label: 'File',
      submenu: [
        {
          label: 'Quit',
          accelerator: process.platform === 'darwin' ? 'Cmd+Q' : 'Ctrl+Q',
          click: function () { app.isQuiting = true; app.quit(); },
        },
      ],
    },
  ];

  const menu = Menu.buildFromTemplate(template);
  Menu.setApplicationMenu(menu);
}


function createTray() {
    tray = new Tray(path.join(__dirname, 'icon.png'));

    const contextMenu = Menu.buildFromTemplate([
      {
        label: 'Quit',
        click: function () {
          app.isQuiting = true;
          app.quit();
        },
      },
    ]);

    tray.setToolTip(appName);
    tray.setContextMenu(contextMenu);

    tray.on('click', function () {
      forceShow();
    });
};

function forceShow() {
    mainWindow.hide();
    mainWindow.show();
    mainWindow.webContents.setAudioMuted(false);
}

function createContextMenu() {
    mainWindow.webContents.session.setSpellCheckerLanguages(['en-US', 'fr'])
    mainWindow.webContents.on('context-menu', (event, params) => {
      const menu = new Menu()

      for (const suggestion of params.dictionarySuggestions) {
        menu.append(new MenuItem({
          label: suggestion,
          click: () => mainWindow.webContents.replaceMisspelling(suggestion)
        }))
      }

    menu.popup()
  })
}

