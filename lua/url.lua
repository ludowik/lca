function openURL(url, internal)
    assert(not internal)
    
    local cmd = oswindows and 'start' or 'open'
    os.execute(cmd..' '..url)
end
