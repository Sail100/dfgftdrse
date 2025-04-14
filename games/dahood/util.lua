local replicated = game:GetService('ReplicatedStorage')
local players = game:GetService('Players')
local userinputservice = game:GetService('UserInputService')
local lplr = players.LocalPlayer
local tweenservice = game:GetService('TweenService')

local skyline = {
    shoot = function(args)
        replicated.MainEvent:FireServer('ShootGun', args.tool.Handle, args.rootpos, args.head.Position, args.head, args.direction)
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
            return tool and tool:FindFirstChild('Handle') and tool
        end
        return false
    end,
    reload = function(weapon)
        replicated.MainEvent:FireServer('Reload', weapon)
    end,
    hasarmor = function(player)
        return player.Character.BodyEffects.Armor.Value < 30
    end,
    customassets = {
        Sounds = {
            ['None'] = '',
            ['OSU'] = 'rbxassetid://7147454322',
            ['Neverlose'] = 'rbxassetid://7216848832',
            ['Bameware'] = 'rbxassetid://3124331820',
            ['Hitmarker'] = 'rbxassetid://160432334',
            ['skeet'] = 'rbxassetid://4817809188',
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
            if type == 'Pulse' then
                local Attachment = Instance.new('Attachment', RootPart)
                local Particle1 = Instance.new('ParticleEmitter', Attachment); Particle1.Name = 'Particle1'; Particle1.LightEmission = 3; Particle1.Transparency = NumberSequence.new(0); Particle1.Color = ColorSequence.new(Color3.fromRGB(0, 89, 255)); Particle1.Size = NumberSequence.new{NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 6, 1.2)}; Particle1.Rotation = NumberRange.new(0); Particle1.RotSpeed = NumberRange.new(0)
                Particle1.Enabled = false
                Particle1.Rate = 2
                Particle1.Lifetime = NumberRange.new(0.25)
                Particle1.Speed = NumberRange.new(0.1)
                Particle1.Squash = NumberSequence.new(0)
                Particle1.ZOffset = 1
                Particle1.Texture = 'rbxassetid://2916153928'
                Particle1.Orientation = 'VelocityPerpendicular'
                Particle1.Shape = 'Box'
                Particle1.ShapeInOut = 'Outward'
                Particle1.ShapeStyle = 'Volume'

                local Particle2 = Instance.new('ParticleEmitter', Attachment)
                Particle2.Name = 'Particle2'
                Particle2.LightEmission = 3
                Particle2.Transparency = NumberSequence.new(0)
                Particle2.Color = ColorSequence.new()
                Particle2.Size = NumberSequence.new{NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 6, 1.2)}
                Particle2.Rotation = NumberRange.new(0)
                Particle2.RotSpeed = NumberRange.new(0)
                Particle2.Enabled = false
                Particle2.Rate = 2
                Particle2.Lifetime = NumberRange.new(0.25)
                Particle2.Speed = NumberRange.new(0.1)
                Particle2.Squash = NumberSequence.new(0)
                Particle2.ZOffset = 1
                Particle2.Texture = 'rbxassetid://2916153928'
                Particle2.Orientation = 'FacingCamera'
                Particle2.Shape = 'Box'
                Particle2.ShapeInOut = 'Outward'
                Particle2.ShapeStyle = 'Volume'

                Particle1:Emit(1)
                Particle2:Emit(1)

                game:GetService('Debris'):AddItem(Attachment, 1)
            elseif type == 'Clone' then
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
    local nearestplayer = nil
    local nearestmagnitude = 9.2^18
    for _, player in next, players:GetPlayers() do
        if player ~= lplr and skyline.isvalidtarget(player) and (not table.find(skyline.friends, player.Name)) then
            local head = player.Character:FindFirstChild('Head')
            if head then
                local screenpos, onscreen = workspace.CurrentCamera:WorldToScreenPoint(head.Position)
                if onscreen then
                    local magnitude = (Vector2.new(screenpos.X, screenpos.Y) - userinputservice:GetMouseLocation()).magnitude
                    if magnitude < nearestmagnitude then
                        nearestplayer = player
                        nearestmagnitude = magnitude
                    end
                end
            end
        end
    end
    return nearestplayer
end

return skyline