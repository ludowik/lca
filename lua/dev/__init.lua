requireLib(
    'performance',
    'performanceCheck',
    'profiler',
    'override',
    'reporting',
    'introspection')

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
