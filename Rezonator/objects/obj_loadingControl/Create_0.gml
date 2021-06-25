show_debug_message("obj_loadingControl Create! nodeMap size: " + string(ds_map_size(global.nodeMap)) + scr_printTime());


importGridRow = 0;
importGridHeight = ds_grid_height(global.importGrid);
importGridWidth = ds_grid_width(global.importGrid);
c_ltblue = make_color_rgb(183, 183, 255);
finished = false;

// fill node map with default lists
scr_nodeMapDefaultData();

tokenList = ds_list_create();
unitList = ds_list_create();
displayUnitList = ds_list_create();

indexOfDisplayToken = ds_list_find_index(global.importGridColNameList, global.displayTokenField);
indexOfUnitDelim = ds_list_find_index(global.importGridColNameList, global.unitDelimField);


global.tokenFieldList = ds_list_create();
global.unitFieldList = ds_list_create();


// create discourse node
global.discourseNode = scr_addToNodeMap("Discourse");
var discourseSubMap = global.nodeMap[? global.discourseNode];
ds_map_add_list(discourseSubMap, "tokenList", tokenList);
ds_map_add_list(discourseSubMap, "unitList", unitList);
ds_map_add_list(discourseSubMap, "displayUnitList", displayUnitList);


tokenTagMap = ds_map_create();
unitTagMap  = ds_map_create();

currentUnitID = "";
currentEntryList = -1;


prevNodeMapSize = 0;
nodesPerSec = 0;
alarm[0] = fps;

prevFieldMap = ds_map_create();