function makezip()
    log('makezip')
    
    if oswindows then
        local zip = '"C:/Program Files/7-Zip/7z.exe"'
        os.execute(zip..' u -mx1 -r -tZIP lca.love . -xr!.git* -xr!.DS_Store* -xr!lca.love -xr!__archive')
        
    else
        local zip = 'zip'
        local zipCommand = zip..' -u -1 -r lca.love . -x *.git* *.DS_Store* lca.love __archive/\\*'
        print(zipCommand)
        os.execute(zipCommand)
    end
end

function makelovejs()
    log('makelovejs')
    
    local build_directory = "build"
    if osx then
        os.execute('makelove')    
        os.execute('unzip -o '..build_directory..'/lovejs/lca-lovejs.zip -d '..build_directory..'/lovejs')
        os.execute('cp '..build_directory..'/lovejs/lca/game.data .')
        
        os.execute('cmd.exe python3 -m http.server 8080 --directory lca')
    else    
        os.execute('cmd.exe python -m http.server 8080 --directory lca')
    end
    
    openURL('http://localhost:8080')
end
