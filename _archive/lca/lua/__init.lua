require 'lua.debug'
require 'lua.io'    
require 'lua.require'

requireLib(
    'bit',
    'table',
    'class',
    'string',
    'id',
    'args',
    'eval',
    'date',
    'time',
    'range',
    'ut',
    'callback',
    'tween',
    'convert',
    'enum',
    'decorator',
    'http',
    'todo',
    'video',
    'memory',
    'url'
)

function toggle(value, opt1, opt2)
    if value == nil then return opt1 end

    if value == opt1 then
        return opt2
    end
    return opt1
end


niltable = {}

nilf = function () end

class('__table__')

function __table__.test()
    local array = {}

    ut.assert('exist', Table)
    ut.assert('new', Table())
    ut.assert('new(array)', Table(array) == array)

    local t1 = Table()
    ut.assert('add(item)', t1:add('item') == t1)
    ut.assert('getn', t1:getn() == 1)

    local t = {}
    table.insert(t, 1)
    table.remove(t, 1)

    assert(#t == 0)

    local t1 = Table{1,2,3,4,0,5,6,7,8,9}
    local t2 = Table{{a=3},{a=7},{a=2}}

    ut.assertEqual('min 1', t1:min(), 0)
    ut.assertEqual('min 2', t2:min('a'), 2)

    ut.assertEqual('max 1', t1:max(), 9)
    ut.assertEqual('max 2', t2:max('a'), 7)

    ut.assertEqual('avg 1', t1:avg(), 4.5)
    ut.assertEqual('avg 2', t2:avg('a'), 4)

    table.scan(_G, nil, function () end)
end
