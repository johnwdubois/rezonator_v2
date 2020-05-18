/// @description GridList Dynamic
// You can write your code in this editor

var importGridXColList = ds_map_find_value(gridViewColXListMap, global.labelWordGrid);


var currentColX = windowX;
var importGridWidth = ds_grid_width(global.labelWordGrid);
var defaultGridColWidth = windowWidth / importGridWidth;

ds_list_clear(importGridXColList);

for (var j = 0; j < importGridWidth; j++) {
	ds_list_add(importGridXColList, currentColX + scrollBarWidth);
	currentColX += defaultGridColWidth;
}