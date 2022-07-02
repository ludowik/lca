class 'ut'

function ut.assert(label, test)
    assert(test, label)
end

function ut.assertEqual(label, a, b)
    if type(b) == 'function' then
        assert(a==b(a), label)
    else
        assert(a==b, label)
    end
end

function ut.assertBetween(label, v, min, max)
    assert(min<=v and v<=max, label)
end

function ut.test()
    ut.assert('assert', true)

    ut.assertEqual('assertEqual', 1, 1)
    ut.assertEqual('assertEqual', nil, nil)
    ut.assertEqual('assertEqual', 'test', 'test')

    ut.assertBetween('assertBetween', 1, 1, 3)
    ut.assertBetween('assertBetween', 2, 1, 3)
    ut.assertBetween('assertBetween', 3, 1, 3)
end
