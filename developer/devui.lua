type skylinemain = {
	ui: Instance,
	library: table,
	assets: table,
	api: table
}

local players = game:GetService('Players') :: Players;
local runservice = game:GetService('RunService') :: RunService;
local lplr = players.LocalPlayer :: Players;
local playergui = runservice:IsStudio() and lplr.PlayerGui or game:GetService('CoreGui');

local skylinegui = Instance.new('ScreenGui');
skylinegui.Parent = playergui;
skylinegui.ResetOnSpawn = false;

local skyline: skylinemain = {
	ui = skylinegui,
	library = {},
	assets = {
		sounds = {
			['TF2 Hitsound'] = 'rbxassetid://3455144981',
			['TF2 Critical'] = 'rbxassetid://296102734',
			['Gamesense'] = 'rbxassetid://4817809188',
			['Neverlose'] = 'rbxassetid://7216848832',
			['Lazer Beam'] = 'rbxassetid://130791043',
			['Bameware'] = 'rbxassetid://3124331820',
			['Hitmarker'] = 'rbxassetid://160432334',
			['Bow Hit'] = 'rbxassetid://1053296915',
			['Rust'] = 'rbxassetid://5043539486',
			['Bow'] = 'rbxassetid://3442683707',
			['OSU'] = 'rbxassetid://7147454322',
		},
		textures = {
			['Normal'] = 'rbxassetid://7151778302',
			['Fog'] = 'rbxassetid://9150635648'
		},
	},
	api = {
		random = {
			number = math.random,
			string = function(length: number)
				local characters: string = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()[]';
				local final: string = '';
				
				for i = 1, length do
					local index: number = math.random(1, #characters);
					final = final..characters:sub(index, index);
				end;
				
				return final;
			end,
			boolean = function(chance: number)
				chance = chance or 2;
				return (math.random(1, chance) == 1);
			end,
		}	
	};
};

local instances = {
	create = function(self: any, name: string, data: table): Instance
		local new: Instance = Instance.new(name);

		for i: string, v: any? in data do
			if i ~= 'Parent' then
				new[i] = v;
			end;
		end;

		new.Parent = data.Parent or skyline.ui;
		return new;
	end,
	corner = function(self: any, parent: Instance?, radius: UDim?): Instance
		local new = Instance.new('UICorner');

		new.CornerRadius = radius or UDim.new(0, 8);
		new.Parent = parent or skyline.ui;

		return new;
	end,
}

local main = instances:create('Frame', {
	Name = skyline.api.random.string(12),
	BackgroundColor3 = Color3.fromRGB(31, 30, 30),
	Size = UDim2.new(0, 718, 0, 465),
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.503, 0, 0.511, 0),
});

local corner = instances:corner(main);

local selection = instances:create('Frame', {
	BackgroundTransparency = 1,
	Size = UDim2.fromOffset(52, 369),
	Position = UDim2.fromScale(0.017, 0.142),
	Parent = main
})

local ui = instances:create('UIListLayout', {
	Padding = UDim.new(0, 8),
	Parent = selection
});

function skyline.library:CreateTab(data)
	data.icon = data.icon or '';
	
	local frame = instances:create('Frame', {
		
	});
	
end;

skylinegui.Name = `__counterstrike__{skyline.api.random.string(10)}`;
return skyline;