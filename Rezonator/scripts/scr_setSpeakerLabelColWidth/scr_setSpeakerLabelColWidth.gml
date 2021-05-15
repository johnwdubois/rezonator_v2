function scr_setSpeakerLabelColWidth() {
	
	/*
		Purpose: Adapt the Speaker Label width based on the font size of the Speaker Name
	*/

	if (object_index != obj_control) {
		exit;
	}
	
	var camHeight = camera_get_view_height(camera_get_active());
	var minColWidth = string_width("00000");
	var maxColWidth = camera_get_view_width(camera_get_active()) * 0.16;
	var sectionMouseWidth = 3;
	
	// reset variables when not holding left click
	if (!mouse_check_button(mb_left)) {
		speakerLabelColXHolding = -1;
		speakerLabelColXHoldingPrev = 0;
		speakerLabelColXHoldingDiff = 0;
		ds_list_clear(speakerLabelColPrevList);
	}
	
	
	var speakerLabelColXListSize = ds_list_size(speakerLabelColXList);
	for (var i = 0; i < speakerLabelColXListSize; i++) {
		
		var colX = speakerLabelColXList[| i];
		var mouseoverColX = point_in_rectangle(mouse_x, mouse_y, colX - sectionMouseWidth, wordTopMargin, colX + sectionMouseWidth, camHeight);
		
		if (mouseoverColX) {
			if (mouse_check_button_pressed(mb_left)) {
				speakerLabelColXHolding = i;
				speakerLabelColXHoldingPrev = colX;
				ds_list_copy(speakerLabelColPrevList, speakerLabelColXList);
			}
		}
		
		// if we are dragging this column
		if (speakerLabelColXHolding == i) {
			
			var newColX = max(mouse_x, minColWidth);
		
			// clamp column x values
			if (speakerLabelColXHolding >= 0) {
				var prevColX = 0;
				if (speakerLabelColXHolding > 0) {
					prevColX = ds_list_find_value(speakerLabelColXList, i - 1);
				}
				var minColX = prevColX + minColWidth;
				var maxColX = prevColX + maxColWidth;
				newColX = clamp(newColX, minColX, maxColX);
			}
		
			ds_list_set(speakerLabelColXList, i, newColX);
			speakerLabelColXHoldingDiff = newColX - speakerLabelColXHoldingPrev;
		
			// set X positions for all following columns
			for (var j = i + 1; j < speakerLabelColXListSize; j++) {
				var currentNewColX = ds_list_find_value(speakerLabelColPrevList, j) + speakerLabelColXHoldingDiff;
				ds_list_set(speakerLabelColXList, j, currentNewColX);
			}
		}
	}

}
