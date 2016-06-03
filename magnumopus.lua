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

	local targetItemLink = "http://tosdb.org/item/" .. targetItemClass.ClassID;

	local targetItemHeader = string.format("### [%s](%s)\n\n", dictionary.ReplaceDicIDInCompStr(targetItemClass.Name), targetItemLink);
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

		local ingredientLink = "http://tosdb.org/item/" .. ingredientItemClass.ClassID;

		local tableRow = string.format("|[%s](%s)|%s|%s|\n", dictionary.ReplaceDicIDInCompStr(ingredientItemClass.Name), ingredientLink, column, row);

		file:write(tableRow);
	end

	file:write("\n\n");
end

file:flush();
file:close();

print("Magnum Opus output complete!");
