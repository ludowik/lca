local heaps = table()

function newHeap(heapName)
    heaps[heapName] = table()
    return heaps[heapName]
end

function push(heapName, value)
    heaps[heapName] = heaps[heapName] or {}
    table.insert(heaps[heapName], value or 'nil')
    return value
end

function pop(heapName)
    assert(#heaps[heapName] > 0)
    local value = table.remove(heaps[heapName])
    if type(value) == 'string' and value == 'nil' then
        return nil
    end
    return value
end
