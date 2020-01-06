// initiate rezInfoGrid
var levelList = ds_list_create();
ds_list_add(levelList, "unit", "unit", "unit", "unit", "word", "word");
ds_list_add(levelList, "morph", "morph", "unit");
var tierList = ds_list_create();
ds_list_add(tierList, "_UnitID", "_UnitStartTime", "_UnitEndTime", "_Participant", "text", "word");
ds_list_add(tierList, "morph", "gloss", "translation");

global.rezInfoGridWidth = 5;
global.rezInfoGrid_colNumber = 0;
global.rezInfoGrid_colLevel = 1;
global.rezInfoGrid_colTier = 2;
global.rezInfoGrid_colAssignedTag = 3;
global.rezInfoGrid_colAssignedCol = 4;
global.rezInfoGrid = ds_grid_create(global.rezInfoGridWidth, ds_list_size(levelList));
	
for (var j = 0; j < ds_grid_height(global.rezInfoGrid); j++) {
	ds_grid_set(global.rezInfoGrid, global.rezInfoGrid_colNumber, j, j + 1);
	ds_grid_set(global.rezInfoGrid, global.rezInfoGrid_colLevel, j, ds_list_find_value(levelList, j));
	ds_grid_set(global.rezInfoGrid, global.rezInfoGrid_colTier, j, ds_list_find_value(tierList, j));
	ds_grid_set(global.rezInfoGrid, global.rezInfoGrid_colAssignedTag, j, -1);
	ds_grid_set(global.rezInfoGrid, global.rezInfoGrid_colAssignedCol, j, -1);
}