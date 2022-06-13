performance = class 'Performance'

function Performance.timeit(test, f, ...)
    return Performance.__timeit(test, nil, true, f, ...)
end

function Performance.timecall(test, f, ...)
    return Performance.__timeit(test, 1, true, f, ...)
end

function Performance.__timeit(test, n, output, f, ...)
    local infos = {
        n = n or 10^3,
        totalTime = 0,
        totalRam = 0,
        maxTime = 0,
        maxRam = 0
    }

    -- white call
    f(0, ...)

    gc()
    collectgarbage('stop')

    do
        for i=1,infos.n do
            local startTime = os.clock()
            local startRam = ram()
            do
                f(i, ...)
            end
            local endTime = os.clock()
            local endRam = ram()

            local deltaTime = endTime - startTime
            local deltaRam = endRam - startRam

            infos.maxTime = math.max(infos.maxTime, deltaTime)
            infos.maxRam = math.max(infos.maxRam, deltaRam)

            infos.totalTime = infos.totalTime + deltaTime
            infos.totalRam = infos.totalRam + deltaRam
        end
    end

    collectgarbage('restart')
    gc()

    infos.deltaTime = infos.totalTime / infos.n
    infos.deltaRam = infos.totalRam / infos.n

    if output then
        print('====================================')
        print(test)
        print(string.format('total time: %.9f (%s)', infos.totalTime, infos.totalRam))
        print(string.format('delta time: %.9f (%s)', infos.deltaTime, infos.deltaRam))
        print(string.format('max   time: %.9f (%s)', infos.maxTime, infos.maxRam))
    end

    return infos
end

function Performance.compare(test, f1, f2, ...)
    local info1 = Performance.__timeit(test, false, f1, ...)
    local info2 = Performance.__timeit(test, false, f2, ...)
    print(test..' : ' ..(info1.deltaTime < info2.deltaTime and 'first is the best' or 'second is the best'))
    return info1.deltaTime < info2.deltaTime
end

function Performance.run()
    call('perf')
end

class 'perf_div2'
function perf_div2:perf()
    print('divide by 2 vs mul by 0.5')

    local a, b
    b = random() * 10^26

    Performance.timeit('divide by 2',
        function () 
            a = b / 2
        end)

    Performance.timeit('mul by 0.5',
        function () 
            a = b * 0.5
        end)
end
