requireLib(
    'performance',
    'performanceCheck',
    'profiler',
    'reporting',
    'introspection')

--requirePlist('lua/dev/#.plist')

function profile()
    Profiler.resetClasses()

    if not Profiler.running then
        Profiler.init()
        Profiler.start()

        reporting = Reporting()
    else
        Profiler.stop()
    end
end