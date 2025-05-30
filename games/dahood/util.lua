local replicated = game:GetService('ReplicatedStorage')
local players = game:GetService('Players')
local userinputservice = game:GetService('UserInputService')
local lplr = players.LocalPlayer
local tweenservice = game:GetService('TweenService')

local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Exclude

local skyline = {
    shoot = function(args)
        replicated.MainEvent:FireServer('ShootGun',
            args.tool:FindFirstChild('Handle'),                          --> [outer] tool handle
            args.startposition,                                          --> [outer] starting position
            args.position,                                               --> [outer] hit position
            args.part,                                                   --> [outer] hit part,
            (args.position - args.startposition).unit                    --> [outer] hit offset
        )
    end,
    iskod = function(player)
        local character = player and player.Character or lplr.Character

        if character then
            local bodyeffects = character:FindFirstChild('BodyEffects')
            local KOd = bodyeffects and bodyeffects:FindFirstChild('K.O') and bodyeffects['K.O'].Value
            return KOd
        end

        return false;
    end,
    getarmor = function(player)
        return player.Character.BodyEffects.Armor.Value
    end,
    say = function(message)
        replicated.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, 'All')
    end,
    isvalidtarget = function(target)
        if not target then return false end

        local character = target.Character
        if not character then return false end

        local humanoid = character:FindFirstChild('Humanoid')
        if not humanoid then return false end

        local bodyeffects = character:FindFirstChild('BodyEffects')
        local KOd = bodyeffects and bodyeffects:FindFirstChild('K.O') and bodyeffects['K.O'].Value
        local forcefield = character:FindFirstChildOfClass('ForceField')

        return humanoid.Health > 0 and not KOd and forcefield == nil
    end,
    hasgun = function(player)
        local character = player and player.Character or lplr.Character

        if character then
            local tool = character:FindFirstChildOfClass('Tool')
            return tool and tool:FindFirstChild('Handle') ~= nil
        end

        return false
    end,
    redeemcode = function(code)
        replicated.MainEvent:FireServer('EnterPromoCode', code)
    end,
    stomp = function()
        replicated.MainEvent:FireServer('Stomp')
    end,
    getgun = function(player)
        local character = player and player.Character or lplr.Character
        if character then
            local tool = character:FindFirstChildOfClass('Tool')
            return tool:FindFirstChild('Handle') and tool:FindFirstChild('GunScript') and tool
        end
        return nil
    end,
    getfullammo = function(tool)
        local ammo = lplr:WaitForChild('PlayerGui'):WaitForChild('MainScreenGui'):WaitForChild('AmmoFrame'):FindFirstChild('AmmoText')

        if ammo then
            return tonumber(ammo.Text)
        end

        return nil
    end,
    stomped = function(player)
        local character = player and player.Character or lplr.Character
        local bodyeffects = character:FindFirstChild('BodyEffects')
        local KOd = bodyeffects and bodyeffects:FindFirstChild('SDeath') and bodyeffects.SDeath.Value
        return KOd
    end,
    reload = function(weapon)
        replicated.MainEvent:FireServer('Reload', weapon)
    end,
    getmoney = function()
        local text = lplr:WaitForChild('PlayerGui'):WaitForChild('MainScreenGui'):FindFirstChild('MoneyText')
        return text.Text:gsub('[%$,]', '')
    end,
    hasarmor = function(player)
        player = player or lplr
        return tonumber(player.Character.BodyEffects.Armor.Value) > 0
    end,
    needsarmor = function(player)
        player = player or lplr
        return tonumber(player.Character.BodyEffects.Armor.Value) < 30
    end,
    wallcheck = function(root)        
        params.FilterDescendantsInstances = {lplr.Character}
        
        local cframe = CFrame.lookAt(root.CFrame.Position, lplr.Character.PrimaryPart.CFrame.Position)
        local raycast = workspace:Raycast(root.Position, (lplr.Character.PrimaryPart.Position - root.Position).Unit * 12, params)
        return (raycast) and true or false
    end,
    customassets = {
        Sounds = {
            ['None'] = '',
            ['OSU'] = 'rbxassetid://7147454322',
            ['Neverlose'] = 'rbxassetid://7216848832',
            ['Bameware'] = 'rbxassetid://3124331820',
            ['Hitmarker'] = 'rbxassetid://160432334',
            ['Skeet'] = 'rbxassetid://4817809188',
            ['Rust'] = 'rbxassetid://5043539486',
            ['Lazer Beam'] = 'rbxassetid://130791043',
            ['Bow Hit'] = 'rbxassetid://1053296915',
            ['Bow'] = 'rbxassetid://3442683707',
            ['TF2 Hitsound'] = 'rbxassetid://3455144981',
            ['TF2 Critical'] = 'rbxassetid://296102734',
        },
        Textures = {
            ['Normal'] = 'rbxassetid://7151778302',
            ['Fog'] = 'rbxassetid://9150635648'
        };
    },
    hiteffect = function(plr, type)
        if not workspace:FindFirstChild('SkylineParts') then
            Instance.new('Folder', workspace).Name = 'SkylineParts'
        end

        local SkylineParts = workspace:FindFirstChild('SkylineParts')

        local Character = plr.Character
        local RootPart = Character and Character:FindFirstChild('HumanoidRootPart')

        if Character and RootPart then
            if type == 'Clone' then
                Character.Archivable = true

                local clone = Character:Clone()
                clone.Parent = SkylineParts
                clone.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

                task.spawn(LPH_NO_VIRTUALIZE(function()
                    for i, v in clone:GetDescendants() do
                        if v:IsA('BasePart') then
                            v.Material = Enum.Material.ForceField
                            v.Color = Color3.new(0, 0.349019, 1)
                            v.CanCollide = false
                            v.Anchored = true
                            v.CanQuery = false
                            v.CanTouch = false
                        end

                        if v:IsA('Accessory') or v:IsA('Tool') then
                            v:Destroy()
                        end
                    end

                    clone:FindFirstChild('HumanoidRootPart').CanCollide = false

                    for i, v in Character:GetDescendants() do
                        if v:IsA('BasePart') then
                            local ClonePart = clone:FindFirstChild(v.Name)
                            if ClonePart then
                                ClonePart.CFrame = v.CFrame
                            end
                        end
                    end

                    for i, v in clone:GetDescendants() do
                        if v:IsA('BasePart') then
                            tweenservice:Create(v, TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { Transparency = 1 }):Play()
                        end
                    end

                    for _, v in pairs(clone.Head:GetDescendants()) do
                        v:Destroy()
                    end
                end))

                Character.Archivable = false
                game:GetService('Debris'):AddItem(clone, 2)
            end
        end
    end,
    friends = {}
}

function skyline:getnearestplayer()
    if getgenv().sl_targets and #getgenv().sl_targets > 0 then
        local target = getgenv().sl_targets[math.random(1, #getgenv().sl_targets)]
        if target and target.Character and target.Character:FindFirstChild('Head') then
            return target
        else
            return nil
        end
    end

    local nearestplayer = nil
    local nearestmagnitude = 9.2^18
    for _, player in next, players:GetPlayers() do
        if player ~= lplr and skyline.isvalidtarget(player) and (not table.find(skyline.friends, player.Name)) then
            local head = player.Character:FindFirstChild('Head')
            if head then
                local screenpos = workspace.CurrentCamera:WorldToScreenPoint(head.Position)
                local magnitude = (Vector2.new(screenpos.X, screenpos.Y) - userinputservice:GetMouseLocation()).magnitude
                if magnitude < nearestmagnitude then
                    nearestplayer = player
                    nearestmagnitude = magnitude
                end
            end
        end
    end
    return nearestplayer
end


local bad = {'Fist', 'Phone'}

local lasttarget = nil
skyline.randomplayer = function(self, list: any)
    if not list then list = {armed = false} end;
    if getgenv().sl_targets and #getgenv().sl_targets > 0 then
        local target = getgenv().sl_targets[math.random(1, #getgenv().sl_targets)]
        if target and target.Character and target.Character:FindFirstChild('Head') and not skyline.stomped(target) then
            if list.armed then
                local has = false
                for _, v in target.Character:GetChildren() do
                    if v:IsA('Tool') and not table.find(bad, v.Name) then
                        has = true
                        break
                    end
                end

                if has then return nil end;
            end
            return target
        else
            return nil
        end
    end
    
    for _, player in next, players:GetPlayers() do
        if player and player ~= lplr and player.Character and (not table.find(skyline.friends, player.Name)) and player ~= lasttarget and not skyline.stomped(player) then
            local head = player.Character:FindFirstChild('Head')
            if list.armed then
                local has = false
                for _, v in player.Character:GetChildren() do
                    if v:IsA('Tool') and not table.find(bad, v.Name) then
                        has = true
                        break
                    end
                end

                if has then return nil end;
            end
            if head then
                lasttarget = player
                return player
            end
        end
    end
    return nil
end

return skyline