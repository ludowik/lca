--- performance

function performance(name, f1, f2, m, n)
	m = m or 10000
    
	local tab = {}
    n = n or 1
	for i=1,n do
		tab[i] = i
	end

	function computePerf(f, i)
		local t = Chrono()
        t:start()
		do
			f(tab)
		end
        t:stop()
		return t:delay()
	end

	local t1 = 0
	local t2 = 0
	
	for i=1,m do
		t1 = t1 + computePerf(f1, 1)
		t2 = t2 + computePerf(f2, 2)
	end

	t1 = t1 / m
	t2 = t2 / m

	print("Performance : "..name..'('..m..')'..' best is '..(t1<t2 and '1' or '2'))

	print("T1 => "..t1)
	print("T2 => "..t2)
end