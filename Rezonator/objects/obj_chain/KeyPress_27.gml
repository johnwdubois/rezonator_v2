///@description End Chain Use
// End chain adding/use
//if (obj_panelPane.functionChainList_currentTab != obj_panelPane.functionChainList_tabLine and (obj_panelPane.functionChainList_lineGridRowFocused > 0 and obj_panelPane.functionChainList_lineGridRowFocused < ds_grid_height(obj_control.lineGrid))) {
	scr_chainDeselect();

	scr_refreshVizLinkGrid();
//}

if (obj_control.gridView) {
	obj_control.gridView = false;
}
// If we're not in grid view and there is a search, switch between the main and search screen
else if (ds_grid_height(obj_control.searchGrid) > 0 and !obj_control.gridView) {
	with(obj_control) {
		// Switch back to either main or filter grids
		if(currentActiveLineGrid == searchGrid) { 
			searchGridActive = false;
		
			// Check to see which grid we're switching back into
			if(preSwitchLineGrid == filterGrid) {
				scr_renderFilter(); // Thankfully this script does a lot of work for us
			}
			else {
				currentActiveLineGrid = lineGrid;
			}
			preSwitchSearchDisplayRow = obj_control.scrollPlusYDest;//currentCenterDisplayRow;
		
			// Make sure we don't try to render a line that doesn't exist
			if(highlightedSearchRow > 0 && ds_grid_value_exists(preSwitchLineGrid, 0, 0, 0, ds_grid_height(preSwitchLineGrid), highlightedSearchRow)){
				var linePixelY = ds_grid_get(obj_control.lineGrid, obj_control.lineGrid_colPixelYOriginal, highlightedSearchRow);
				preSwitchDisplayRow = -linePixelY + (camera_get_view_height(view_camera[0]) / 2) - 100;
			}
			//currentCenterDisplayRow = preSwitchDisplayRow;
			obj_control.scrollPlusYDest = preSwitchDisplayRow;
		
			//wordLeftMarginDest = 170;
			with (obj_alarm) {
				alarm[0] = 5;
			}
		}
		// Give the user another way to leave the filter view
		else if(currentActiveLineGrid == filterGrid) { 
			// Exit the stackShow
			if(stackShowActive) {
				obj_control.currentStackShowListPosition = ds_list_size(obj_control.stackShowList)-1;
				scr_stackShow();
			}
			// Exit the plain filter
			else {
				// Remember the user's place
				if(obj_control.currentCenterDisplayRow >= 0 and obj_control.currentCenterDisplayRow < ds_grid_height(obj_control.filterGrid)) {
					obj_control.scrollPlusYDest = obj_control.prevCenterYDest;
				}
			
				// Switch to active grid
				obj_control.filterGridActive = false;
				obj_control.currentActiveLineGrid = obj_control.lineGrid
			}
		
			with (obj_alarm) {
				alarm[1] = 5;
			}
		}
	}
}
else if(obj_control.currentActiveLineGrid == obj_control.filterGrid) { 
	with(obj_control) {
		// Exit the stackShow
		if(stackShowActive) {
			obj_control.currentStackShowListPosition = ds_list_size(obj_control.stackShowList)-1;
			scr_stackShow();
		}
		// Exit the plain filter
		else {
			// Remember the user's place
			if(obj_control.currentCenterDisplayRow >= 0 and obj_control.currentCenterDisplayRow < ds_grid_height(obj_control.filterGrid)) {
				obj_control.scrollPlusYDest = obj_control.prevCenterYDest;
			}
			
			// Switch to active grid
			obj_control.filterGridActive = false;
			obj_control.currentActiveLineGrid = obj_control.lineGrid
		}
	
		with (obj_alarm) {
			alarm[1] = 5;
		}
	}
}