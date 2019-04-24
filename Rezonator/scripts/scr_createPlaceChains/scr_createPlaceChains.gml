show_message("here!");

var currentTool = obj_toolPane.currentTool;
obj_toolPane.currentTool = obj_toolPane.toolPlaceChains;

for (var i = 0; i < 10; i++) {
	var currentWordIDList = ds_grid_get(obj_control.unitGrid, obj_control.unitGrid_colWordIDList, i);
	
	for (var j = 0; j < ds_list_size(currentWordIDList); j++) {
		var currentWordID = ds_list_find_value(currentWordIDList, j);
		
		with (obj_chain) {
			scr_wordClicked(currentWordID, i);
			show_debug_message("scr_wordClicked(" + string(currentWordID) + ", " + string(i) + ")");
		}
	}
	
	scr_unFocusAllChains();
}

obj_toolPane.currentTool = currentTool;