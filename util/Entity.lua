local Entity = {
    Entities = {}
}

function Entity:Get()
    local ents = table.clone(self.Entities)
    for i,v in game:GetService('Players'):GetPlayers() do
        table.insert(ents, v)
    end
    return ents
end

function Entity:New(info)  
    local realinfo = table.clone(info)
    function realinfo:FindFirstChild(ind)
        return realinfo[ind]
    end
    if not realinfo.Parent then
        realinfo.Parent = realinfo
    end
    table.insert(Entity.Entities, realinfo)
    return realinfo
end

return Entity