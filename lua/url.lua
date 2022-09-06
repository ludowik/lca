function openURL(url, internal)
    assert(not internal)
    
    local cmd = windows and 'start' or 'open'
    os.execute(cmd..' '..url)
end
