function zip()
    if os.name == 'ios-osx' or os.name == 'osx' then
        local zip = 'zip'
        os.execute(zip..' -u -1 -r lca.love . -x *.git* *.DS_Store* lca.love __archive/\\*')

    elseif os.nameSupport == 'windows' then
        local zip = '"C:/Program Files/7-Zip/7z.exe"'
        os.execute(zip..' u -mx1 -r -tZIP lca.love . -xr!.git* -xr!.DS_Store* -xr!lca.love -xr!__archive')
    end
end

zip()
