Engine.keys = {
    ['f1'] = {
        desc = 'Help',
        f = function ()
            openURL('https://codea.io/reference')
            openURL('https://love2d-community.github.io/love-api')
        end
    },

    ['escape'] = {
        desc = 'Quit',
        f = function ()
            quit()
        end
    },

    ['r'] = {
        desc = 'Restart',
        f = function ()
            restart()
        end
    },

    [','] = {
        desc = 'Random App',
        f = function () -- ?
            randomApp()
        end
    },

    ['a'] = {
        desc = 'Apps App',
        f = function ()
            loadApp('apps', 'apps')
        end
    },

    ['i'] = {
        desc = 'Info App',
        f = function ()
            loadApp('apps', 'info')
        end
    },

    ['t'] = {
        desc = 'Autotest App',
        f = function ()
            _G.env.__autotest = not _G.env.__autotest
        end
    },

    ['l'] = {
        desc = 'Autotest all Apps',
        f = function ()
            loadApp('apps', 'apps').__autotest = true
        end
    },

    ['m'] = {
        desc = 'Orientation',
        f = function ()
            if getMode() == PORTRAIT then
                setMode(LANDSCAPE)
            else
                setMode(PORTRAIT)
            end
        end
    },

    ['s'] = {
        desc = 'Scan toxxxx',
        f = function ()
            scanTODO()
        end
    },

    ['j'] = {
        desc = 'Generate lovejs',
        f = function () -- js
            makelovejs()
            makezip()
        end
    },

    ['tab'] = {
        desc = 'Navigate thru apps',
        f = function ()
            if isDown('lshift') then
                previousApp()
            else
                nextApp()
            end
        end
    },

    ['w'] = {
        desc = 'Wireframe',
        f = function ()
            config.wireFrame = not config.wireFrame
        end
    },

    ['f'] = {
        desc = 'Framework mode',
        f = function ()
            if config.framework == 'love2d' then
                config.framework = 'core'

            else
                config.framework = 'love2d'
            end
            restart()
        end
    },

    ['g'] = {
        desc = 'Graphics mode',
        f = function ()
            if config.renderer == 'love2d' then
                config.renderer = 'core'

            elseif config.renderer == 'core' then
                config.renderer = 'soft'

            else
                config.renderer = 'love2d'
            end
            restart()
        end
    },

    ['p'] = {
        desc = 'Capture Image',
        f = function ()
            Engine.captureImage()
        end
    },
}