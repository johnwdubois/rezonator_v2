// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_createTokenNode(discourseTokenSeq , textToDisplay,newTokenSeq,newDisplayCol, unitID){
		// make token node
		var currentTokenNode = scr_addToNodeMap("token");
		var currentTokenSubMap = global.nodeMap[? currentTokenNode];
		ds_map_add(currentTokenSubMap, "discourseTokenSeq", discourseTokenSeq);
		ds_map_add(currentTokenSubMap, "tokenSeq", newTokenSeq);
		ds_map_add(currentTokenSubMap, "displayCol", newDisplayCol);
		ds_map_add(currentTokenSubMap, "void", 1);
		ds_map_add(currentTokenSubMap, "pixelX", 0);
		ds_map_add(currentTokenSubMap, "border", "");
		ds_map_add(currentTokenSubMap, "searched", false);
		ds_map_add(currentTokenSubMap, "unit", unitID);
		ds_map_add_list(currentTokenSubMap, "inChainsList", ds_list_create());
		ds_map_add_list(currentTokenSubMap, "inChunkList", ds_list_create());
				
		// make tag map for token & copy tags from tokenImportGrid
		var tagMap = ds_map_create();
		ds_map_add_map(currentTokenSubMap, "tagMap", tagMap);
		var tokenImportColNameListSize = ds_list_size(obj_control.tokenFieldList);
		for (var i = 0; i < tokenImportColNameListSize; i++) {
			var currentField = string(obj_control.tokenFieldList[| i]);
			var currentTag = "";
			if(currentField == global.displayTokenField){
				currentTag = textToDisplay
			}
			ds_map_add(tagMap, currentField, currentTag);
		}
		
		return currentTokenNode;
}