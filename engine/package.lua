function makezip()
    log('makezip')
    
    if osx then
        local zip = 'zip'
        os.execute(zip..' -u -1 -r lca.love . -x *.git* *.DS_Store* lca.love __archive/\\*')

    elseif oswindows then
        local zip = '"C:/Program Files/7-Zip/7z.exe"'
        os.execute(zip..' u -mx1 -r -tZIP lca.love . -xr!.git* -xr!.DS_Store* -xr!lca.love -xr!__archive')
    end
end

function makelovejs()
    log('makelovejs')
    
    local build_directory = "build"
    if osx then
        os.execute('makelove')    
        os.execute('unzip -o '..build_directory..'/lovejs/lca-lovejs.zip -d '..build_directory..'/lovejs')
        os.execute('cp '..build_directory..'/lovejs/lca/game.data .')
    end
    
    os.execute('cmd.exe python3 -m http.server 8080 --directory lca')
    openURL('http://localhost:8080')
end
