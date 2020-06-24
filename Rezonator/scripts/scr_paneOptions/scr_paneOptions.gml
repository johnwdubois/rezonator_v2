//paneOptions
var optionSelected = argument0;

switch (optionSelected)
{
	case "Main":
		if (obj_control.gridView) {
			obj_control.gridView = false;
		}
		// If we're not in grid view and there is a search, switch between the main and search screen
		else if (ds_grid_height(obj_control.searchGrid) > 0 and !obj_control.gridView) {

			// Switch back to either main or filter grids
			if(obj_control.currentActiveLineGrid == obj_control.searchGrid) { 
				obj_control.searchGridActive = false;
		
				// Check to see which grid we're switching back into
				if(obj_control.preSwitchLineGrid == obj_control.filterGrid) {
					scr_renderFilter(); // Thankfully this script does a lot of work for us
				}
				else {
					obj_control.currentActiveLineGrid = obj_control.lineGrid;
				}
				obj_control.preSwitchSearchDisplayRow = obj_control.scrollPlusYDest;//currentCenterDisplayRow;
		
				// Make sure we don't try to render a line that doesn't exist
				if(obj_control.highlightedSearchRow > 0 && ds_grid_value_exists(obj_control.preSwitchLineGrid, 0, 0, 0, ds_grid_height(obj_control.preSwitchLineGrid), obj_control.highlightedSearchRow)){
					var linePixelY = ds_grid_get(obj_control.lineGrid, obj_control.lineGrid_colPixelYOriginal, obj_control.highlightedSearchRow);
					obj_control.preSwitchDisplayRow = -linePixelY + (camera_get_view_height(view_camera[0]) / 2) - 100;
				}
				//currentCenterDisplayRow = preSwitchDisplayRow;
				obj_control.scrollPlusYDest = obj_control.preSwitchDisplayRow;
		
				//wordLeftMarginDest = 170;
				with (obj_alarm) {
					alarm[0] = 5;
				}
			}
			// Give the user another way to leave the filter view
			else if(obj_control.currentActiveLineGrid == obj_control.filterGrid) { 
				// Exit the stackShow
				if(obj_control.stackShowActive) {
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
	break;
	case "Search":
		
		if (ds_grid_height(obj_control.searchGrid) > 0 and !obj_control.gridView) {
			// Main/filter to search
			if(obj_control.currentActiveLineGrid == obj_control.lineGrid) {// or currentActiveLineGrid == filterGrid) {
				scr_unFocusAllChains();
				// Which grid are we switching from?
				obj_control.preSwitchLineGrid = obj_control.currentActiveLineGrid; 
				obj_control.searchGridActive = true;
				obj_control.currentActiveLineGrid = obj_control.searchGrid;
				// Which row are we switching from?
				obj_control.preSwitchDisplayRow = obj_control.scrollPlusYDest;//currentCenterDisplayRow; 
				obj_control.highlightedSearchRow = 0;
				//currentCenterDisplayRow = preSwitchSearchDisplayRow;
				obj_control.scrollPlusYDest  = obj_control.preSwitchSearchDisplayRow;
			//	var linePixelY = ds_grid_get(obj_control.lineGrid, obj_control.lineGrid_colPixelYOriginal, currentCenterDisplayRow);
				//obj_control.scrollPlusYDest = -linePixelY + (camera_get_view_height(view_camera[0]) / 2) - 100;
		
				obj_control.wordLeftMarginDest = window_get_width() / 2;
			}
		}
		//show_message("BUH 2");
	break;
	case "Nav": // Show/hide Nav Window
		case "Toggle Nav Window":
		with(obj_panelPane){
			showNav = not showNav;	
				
		}
		obj_toolPane.showTool = !obj_toolPane.showTool;
		//show_message("BUH 1");
		break;
	break;
	case "Dev": // show grid view
		obj_control.gridView = !obj_control.gridView;
	break;
}