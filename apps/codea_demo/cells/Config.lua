config = {
    show = readProjectData("show", 1) == 1 and true or false
}

function config.save()
    for k,v in pairs(config) do
        if type(k) == "string" then
            if type(v) == "boolean" then
                saveProjectData(k, v and 1 or 0)
            elseif type(v) == "string" then
                saveProjectData(k, v)
            end
        end
    end
end
