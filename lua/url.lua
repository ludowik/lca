function openURL(url, internal)
    assert(not internal)
    os.execute('start '..url)
end
