// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_refreshDisplayCol(){
	
	var camWidth = camera_get_view_width(view_camera[0]);
	var docSubMap = global.nodeMap[? global.discourseNode];
	var unitList = docSubMap[? "unitList"];
	var unitListSize = ds_list_size(unitList);
	
	for (var i = 0; i < unitListSize; i++) {
		var currentUnit = unitList[| i];
		var currentUnitSubMap = global.nodeMap[? currentUnit];
		var currentEntryList = currentUnitSubMap[? "entryList"];
		var currentEntryListSize = ds_list_size(currentEntryList);
		for (var j = 0; j < currentEntryListSize; j++) {
			var currentEntry = currentEntryList[| j];
			var currentEntrySubMap = global.nodeMap[? currentEntry];
			var currentToken = currentEntrySubMap[? "token"];
			var currentTokenSubMap = global.nodeMap[? currentToken];
			

			var currentDisplayCol = 0;
			if (obj_control.justify == obj_control.justifyLeft) {
				currentDisplayCol = j;
			}
			else {
				var maxColsOnScreen = floor((camWidth - global.toolPaneWidth) / obj_control.gridSpaceHorizontal);
				currentDisplayCol = maxColsOnScreen - currentEntryListSize + j - 1;
			}
			currentTokenSubMap[? "displayCol"] = currentDisplayCol;
			
		}
	}
	
	scr_refreshAlignment();
}