Engine.keys = table{
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

    ['lalt+r'] = {
        desc = 'Restart',
        f = function ()
            restart()
        end
    },

    ['lalt+,'] = {
        desc = 'Random App',
        f = function () -- ?
            randomApp()
        end
    },

    ['lctrl+a'] = {
        desc = 'Apps App',
        f = function ()
            loadAppOfTheApps()
        end
    },

    ['f3'] = {
        desc = 'Apps App',
        f = function ()
            loadAppOfTheApps()
        end
    },

    ['lalt+t'] = {
        desc = 'Autotest App',
        f = function ()
            _G.env.__autotest = not _G.env.__autotest
        end
    },

    ['lalt+l'] = {
        desc = 'Autotest all Apps',
        f = function ()
            loadAppOfTheApps().__autotest = true
        end
    },

    ['lalt+s'] = {
        desc = 'Scan toxxxx',
        f = function ()
            scanTODO()
        end
    },

    ['lalt+j'] = {
        desc = 'Generate lovejs',
        f = function ()
            makelovejs()
        end
    },

    ['lalt+z'] = {
        desc = 'Generate zip',
        f = function ()
            makezip()
        end
    },

    ['lctrl+tab'] = {
        desc = 'Navigate thru apps - next',
        f = nextApp
    },

    ['lctrl+lshift+tab'] = {
        desc = 'Navigate thru apps - previous',
        f = previousApp
    },

    ['tab'] = {
        desc = 'Navigate thru ui - next focus',
        f = function ()
            local scene = env.parameter.instance.scene -- _G.env.ui or _G.env.scene or 
            if scene then
                scene:nextFocus()
            end
        end
    },

    ['lshift+tab'] = {
        desc = 'Navigate thru ui - previous focus',
        f = function ()
            local scene = env.parameter.instance.scene -- _G.env.ui or _G.env.scene or 
            if scene then
                scene:previousFocus()
            end
        end
    },

    ['lalt+w'] = {
        desc = 'Wireframe',
        f = function ()
            config.wireFrame = not config.wireFrame
        end
    },

    ['lalt+f'] = {
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

    ['lalt+g'] = {
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
}
