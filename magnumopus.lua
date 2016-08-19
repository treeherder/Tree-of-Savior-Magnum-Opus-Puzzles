local xml = require("xmlSimple").newParser();
local recipeXml = xml:loadFile("../addons/magnumopus/recipe_puzzle.xml");
local recipes = recipeXml["Recipe_Puzzle"]:children();

local file, error = io.open("../addons/magnumopus/README.md", "w");

if error then
	return;
end

for i=1,#recipes do
	local recipe = recipes[i];
	local targetItemClassName = recipe["@TargetItem"];
	local targetItemClass = GetClass("Item", targetItemClassName);

	local targetItemLinkEN = "https://tos.neet.tv/items/" .. targetItemClass.ClassID;
	local targetItemLinkKR = "https://tos-kr.neet.tv/items/" .. targetItemClass.ClassID;

	local targetItemHeader = string.format("### %s [EN](%s) [KR](%s)\n\n",
		dictionary.ReplaceDicIDInCompStr(targetItemClass.Name),
		targetItemLinkEN,
		targetItemLinkKR
	);

	file:write(targetItemHeader);

	local ingredients = recipe:children();

	file:write("| Ingredient  | Column | Row |\n");
	file:write("| ----------- | ------ | --- |\n");

	for j=1,#ingredients do
		local ingredient = ingredients[j];
		local ingredientItemClassName = ingredient["@Name"];
		local row = ingredient["@Row"];
		local column = ingredient["@Col"];

		local ingredientItemClass = GetClass("Item", ingredientItemClassName);

		local ingredientLinkEN = "https://tos.neet.tv/items/" .. ingredientItemClass.ClassID;
		local ingredientLinkKR = "https://tos-kr.neet.tv/items/" .. ingredientItemClass.ClassID;

		local tableRow = string.format("|%s [EN](%s) [KR](%s)|%s|%s|\n",
			dictionary.ReplaceDicIDInCompStr(ingredientItemClass.Name),
			ingredientLinkEN,
			ingredientLinkKR,
			column,
			row
		);

		file:write(tableRow);
	end

	file:write("\n\n");
end

file:flush();
file:close();

print("Magnum Opus output complete!");
