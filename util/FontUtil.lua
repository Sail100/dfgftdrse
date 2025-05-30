local fonts = {};

local api = {
    random = {
        number = function(self, min, max)
            return math.random(min, max);
        end,
        string = function(self, length)
            local characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
            local final = '';
            
            for i = 1, length do
                local index = math.random(1, #characters);
                final = final..characters:sub(index, index);
            end;
            
            return final;
        end,
        boolean = function(self, chance)
            chance = chance or 2;
            return (math.random(1, chance) == 1);
        end
    }    
}

local httpservice = game:GetService('HttpService');

function fonts.new(name, fonturl, faces)
    local random = api.random:string(6);
    
    if not isfolder('sl_fonts') then makefolder('sl_fonts') end;
    if not isfolder(`sl_fonts/{name}`) then makefolder(`sl_fonts/{name}`) end;

    fonturl = game:HttpGet(fonturl);

    writefile(`sl_fonts/{name}/{random}.ttf`, fonturl);

    for i, v in faces do
        v.assetId = getcustomasset(`sl_fonts/{name}/{random}.ttf`);
    end

    local data = httpservice:JSONEncode({
        name = name,
        faces = faces
    });

    writefile(`sl_fonts/{name}/{name}.json`, data);

    return getcustomasset(`sl_fonts/{name}/{name}.json`);
end;

return fonts;