/*
	scr_panelPane_drawChainListLoop();
	
	Last Updated: 2019-01-29
	
	Called from: obj_panelPane
	
	Purpose: draw the chains for whatever tab you are on, if a user clicks on a chain then focus it and
			set chainContents panelPane to look at that chain
	
	Mechanism: loop through chainGrid of whatever tab you are on and draw chainName
	
	Author: Terry DuBois, Georgio Klironomos
*/

var grid = obj_chain.rezChainGrid;

// Based on user selection, get the grid of the current tab
switch (functionChainList_currentTab) {
	case functionChainList_tabRezBrush:
		grid = obj_chain.rezChainGrid;
		break;
	case functionChainList_tabTrackBrush:
		grid = obj_chain.trackChainGrid;
		break;
	case functionChainList_tabStackBrush:
		grid = obj_chain.stackChainGrid;
		break;
	case functionChainList_tabClique:
		grid = obj_chain.cliqueDisplayGrid;
		break;
	default:
		grid = obj_chain.rezChainGrid;
		break;
}

// Set text margin area
var filterRectMargin = 8;
var filterRectSize = 8;
if (functionChainList_currentTab == functionChainList_tabStackBrush) {
	var textMarginLeft = 24;
}
else {
	var textMarginLeft = 48;
}

var textMarginTop = 16;
var textPlusY = 0;
var chainNameRectMinusY = 4;


var scrollBarWidth = 16;
draw_set_color(global.colorThemeBG);
draw_rectangle(x + windowWidth - scrollBarWidth, y + (textMarginTop * 2), x + windowWidth, y + windowHeight, false);

// Set opacity, font, and alignment of text chain lists
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_color(global.colorThemeText);
draw_set_font(global.fontChainList);
var strHeight = string_height("0");

scr_surfaceStart();

for (var i = 0; i < ds_grid_height(grid); i++) {
	
	/*
	if (y + textPlusY + scrollPlusY < y - strHeight
	or y + textPlusY + scrollPlusY > y + windowHeight + strHeight) {
		continue;
	}
	*/

	
	// Get grid info of current chain
	var currentChainID = ds_grid_get(grid, obj_chain.chainGrid_colChainID, i);
	var currentChainState = ds_grid_get(grid, obj_chain.chainGrid_colChainState, i);
	var currentChainName = ds_grid_get(grid, obj_chain.chainGrid_colName, i);
	var currentChainColor = ds_grid_get(grid, obj_chain.chainGrid_colColor, i);
	
	
	// Get dimensions of rectagle around chain name
	var chainNameRectX1 = x + textMarginLeft;
	var chainNameRectY1 = y + textMarginTop + textPlusY + scrollPlusY - (strHeight / 2);
	var chainNameRectX2 = chainNameRectX1 + string_width(currentChainName);
	var chainNameRectY2 = chainNameRectY1 + string_height(currentChainName) - chainNameRectMinusY;
	
		//Check mouse clicks to focus a chain in the list
	if (point_in_rectangle(mouse_x, mouse_y, chainNameRectX1, chainNameRectY1, chainNameRectX2, chainNameRectY2)
	and mouse_check_button_pressed(mb_left)) {
		
		// Unfocus chain if previously focused
		if (currentChainState == obj_chain.chainStateFocus) {
			currentChainState = obj_chain.chainStateNormal;
		}
		else {
		// Focuses on selected chain
			switch (functionChainList_currentTab) {
				case functionChainList_tabRezBrush:
					obj_toolPane.currentTool = obj_toolPane.toolRezBrush;
					break;
				case functionChainList_tabTrackBrush:
					obj_toolPane.currentTool = obj_toolPane.toolTrackBrush;
					break;
				case functionChainList_tabStackBrush:
					obj_toolPane.currentTool = obj_toolPane.toolStackBrush;
					break;
				default:
					break;
			}
				
				
			// Unfocus any already focused chains
			for (var j = 0; j < ds_grid_height(grid); j++) {
				if (ds_grid_get(grid, obj_chain.chainGrid_colChainState, j) == obj_chain.chainStateFocus) {
					ds_grid_set(grid, obj_chain.chainGrid_colChainState, j, obj_chain.chainStateNormal);
				}
			}
				
			// Set chain to focus in the grid
			ds_grid_set(grid, obj_chain.chainGrid_colChainState, i, obj_chain.chainStateFocus);
			scr_setAllValuesInCol(obj_chain.linkGrid, obj_chain.linkGrid_colFocus, false);
				
			// Set chain to focus in the main screen
			if (obj_chain.mouseLineWordID >= 0 and obj_chain.mouseLineWordID < ds_grid_height(obj_control.wordDrawGrid)) {
				scr_setAllValuesInCol(obj_control.wordDrawGrid, obj_control.wordDrawGrid_colFillRect, false);
			}
			obj_chain.mouseLineWordID = -1;
		}
			
		// Set scroll range in the chain list
		with (obj_panelPane) {
			functionChainContents_scrollRangeMin[functionChainList_currentTab] = 0;
			functionChainContents_scrollRangeMax[functionChainList_currentTab] = functionChainContents_maxScrollRange;
		}
		if (doubleClickTimer > -1) {	
				var rowInLineGrid = -1;
				var currentUnitIDList = -1;
				var currentUnitID = -1;
						
				currentUnitIDList = ds_grid_get(grid, obj_chain.chainGrid_colWordIDList, ds_grid_value_y(grid, obj_chain.chainGrid_colChainID, 0, obj_chain.chainGrid_colChainID, ds_grid_height(grid), currentChainID));
				
				if (functionChainList_currentTab == functionChainList_tabStackBrush
				or functionChainList_currentTab == functionChainList_tabClique) {
					currentUnitID = ds_list_find_value(currentUnitIDList, 0);
				}
				else {
					currentUnitID = ds_grid_get(obj_control.wordGrid, obj_control.wordGrid_colUnitID, ds_list_find_value(currentUnitIDList, 0));
				}
					
				rowInLineGrid = ds_grid_value_y(obj_control.lineGrid, obj_control.lineGrid_colUnitID, 0, obj_control.lineGrid_colUnitID, ds_grid_height(obj_control.lineGrid), currentUnitID);
					
				// Set first unit of the double clicked chain to center display row, if possible
				if (rowInLineGrid >= 0 and rowInLineGrid < ds_grid_height(obj_control.lineGrid)) {
					var displayRow = ds_grid_get(obj_control.lineGrid, obj_control.lineGrid_colDisplayRow, rowInLineGrid);
					obj_control.currentCenterDisplayRow = ds_grid_get(obj_control.lineGrid, obj_control.lineGrid_colDisplayRow, displayRow);
				}
		}
		else {
			doubleClickTimer = 0;
		}
	}
	
	//Color codes the chain lists for User
	var chainColor = ds_grid_get(grid, obj_chain.chainGrid_colColor, i); // Access color of new chain
	var rectX1 = x + textMarginLeft - 2; // Create the colored rectangle
	var rectX2 = chainNameRectX2 + 5; //x + textMarginLeft + 50;

	if (currentChainState == obj_chain.chainStateFocus) {
		rectX1 = x;
	}
	draw_set_color(merge_color(chainColor, global.colorThemeBG, 0.65)); //soften the color
	draw_rectangle(rectX1 - clipX, y + textMarginTop + textPlusY + scrollPlusY - 9 - clipY, rectX2 - clipX, y + textMarginTop + textPlusY + scrollPlusY + 7 - clipY, false);
	
	// Outline the rectangle in black
	if (currentChainState == obj_chain.chainStateFocus) {
		draw_set_color(global.colorThemeBorders);
		draw_rectangle(rectX1 - clipX, y + textMarginTop + textPlusY + scrollPlusY - 9 - clipY, rectX2 - clipX, y + textMarginTop + textPlusY + scrollPlusY + 7 - clipY, true);
	}
	
	// Draw text of chain names
	draw_set_color(global.colorThemeText);
	draw_text(x + textMarginLeft - clipX, y + textMarginTop + scrollPlusY + textPlusY - clipY, currentChainName);
	
	// Draw little boxes for filter selection
	var chainFilterRectX1 = x + filterRectMargin - clipX;
	var chainFilterRectY1 = y + textMarginTop + scrollPlusY + textPlusY - (filterRectSize / 2) - clipY;
	var chainFilterRectX2 = chainFilterRectX1 + filterRectSize;
	var chainFilterRectY2 = chainFilterRectY1 + filterRectSize;
	var inFilter = ds_grid_get(grid, obj_chain.chainGrid_colInFilter, i);
	
	// Fill in boxes if filtered
	if (inFilter) {
		draw_rectangle(chainFilterRectX1, chainFilterRectY1, chainFilterRectX2, chainFilterRectY2, false);
	}
	else {
		draw_rectangle(chainFilterRectX1, chainFilterRectY1, chainFilterRectX2, chainFilterRectY2, true);
	}
	
	// Check boxes for user selection with mouse click
	if ((point_in_rectangle(mouse_x, mouse_y, chainFilterRectX1 + clipX, chainFilterRectY1 + clipY, chainFilterRectX2 + clipX, chainFilterRectY2 + clipY) and mouse_check_button_pressed(mb_left))
	or (keyboard_check_pressed(ord("P")) and !keyboard_check(vk_control) and currentChainState == obj_chain.chainStateFocus)) {
		// Record previous display row in case Filter is empty
		obj_control.prevCenterDisplayRow = ds_grid_get(obj_control.filterGrid, obj_control.lineGrid_colUnitID, obj_control.currentCenterDisplayRow); // Shouldn't get in the of the other PrevRow check
		// Set selected objects to be filtered
		inFilter = !inFilter;
		ds_grid_set(grid, obj_chain.chainGrid_colInFilter, i, inFilter);
			
		// Render the filter in the mainscreen
		if (obj_control.filterGridActive) {
			with (obj_control) {
				scr_renderFilter();
			}
		}
	}
	
	
	
	// Create little boxes for alignment selection
	if (functionChainList_currentTab == functionChainList_tabRezBrush
	or functionChainList_currentTab == functionChainList_tabTrackBrush) {
		draw_set_alpha(1);
		draw_set_color(c_purple);
		
		// Set dimensions for little boxes
		var chainAlignRectX1 = x + (filterRectMargin * 2) + filterRectSize - clipX;
		var chainAlignRectY1 = y + textMarginTop + textPlusY - (filterRectSize / 2) + scrollPlusY - clipY;
		var chainAlignRectX2 = chainAlignRectX1 + filterRectSize;
		var chainAlignRectY2 = chainAlignRectY1 + filterRectSize;
		var isAligned = ds_grid_get(grid, obj_chain.chainGrid_colAlign, i);
	
		// Fill in selected boxes
		if (isAligned) {
			draw_rectangle(chainAlignRectX1, chainAlignRectY1, chainAlignRectX2, chainAlignRectY2, false);
		}
		else if (isAligned == -1) {
			draw_set_alpha(0.5);
			draw_rectangle(chainAlignRectX1, chainAlignRectY1, chainAlignRectX2, chainAlignRectY2, false);
		}
		else {
			draw_set_alpha(1);
			draw_rectangle(chainAlignRectX1, chainAlignRectY1, chainAlignRectX2, chainAlignRectY2, true);
		}
		
		draw_set_alpha(1);
	
		//Check for user selection of alignment with mouse clicks
		if (point_in_rectangle(mouse_x, mouse_y, chainAlignRectX1 + clipX, chainAlignRectY1 + clipY, chainAlignRectX2 + clipX, chainAlignRectY2 + clipY)) {
			if (mouse_check_button_pressed(mb_left)) {
				
				// Unselect alignment if already selected
				if (functionChainList_currentTab == functionChainList_tabTrackBrush and not isAligned) {
					scr_setAllValuesInCol(obj_chain.trackChainGrid, obj_chain.chainGrid_colAlign, false);
				}
				
				// Show alignments in main screen
				isAligned = !isAligned;
				if (isAligned) {
					with (obj_chain) {
						alarm[6] = 5;
						// Protect against RaceToInfinity
						chainIDRaceCheck = currentChainID;
					}
				}
				
				// Set alignment in grid
				ds_grid_set(grid, obj_chain.chainGrid_colAlign, i, isAligned);
			}
		}
	}
	
	
	
	
	
	

	
	// Get height of chain name
	textPlusY += strHeight;
}



var focusedChainRow = ds_grid_value_y(grid, obj_chain.chainGrid_colChainState, 0, obj_chain.chainGrid_colChainState, ds_grid_height(grid), obj_chain.chainStateFocus);
if (focusedChainRow > -1 and focusedChainRow < ds_grid_height(grid)) {
	
	if (clickedIn) {
		
		if (keyboard_check_pressed(vk_up)) {
			if (focusedChainRow > 0) {
				scr_unFocusAllChains();
				scr_setAllValuesInCol(obj_chain.linkGrid, obj_chain.linkGrid_colFocus, false); 
				focusedChainRow--;
				ds_grid_set(grid, obj_chain.chainGrid_colChainState, focusedChainRow, obj_chain.chainStateFocus);
			}
		}
		else if (keyboard_check_pressed(vk_down)) {
			if (focusedChainRow < ds_grid_height(grid) - 1) {
				scr_unFocusAllChains();
				scr_setAllValuesInCol(obj_chain.linkGrid, obj_chain.linkGrid_colFocus, false); 
				focusedChainRow++;
				ds_grid_set(grid, obj_chain.chainGrid_colChainState, focusedChainRow, obj_chain.chainStateFocus);
			}
		}
	}
}




// Create scroll bars
var scrollBarHeight = windowHeight;
var scrollBarRectX1 = x + windowWidth - scrollBarWidth - clipX;
var scrollBarRectY1 = y - clipY;
var scrollBarRectX2 = scrollBarRectX1 + scrollBarWidth;
var scrollBarRectY2 = scrollBarRectY1 + scrollBarHeight;

scrollBarRectY1 = max(scrollBarRectY1, y + (textMarginTop * 2));
scrollBarRectY2 = max(scrollBarRectY2, y + (textMarginTop * 2));

//Don't draw scroll bars if there's no chains
if (ds_grid_height(grid) == 0) {
	scrollBarRectY1 = y + (textMarginTop * 2);
	scrollBarRectY2 = y + windowHeight;
	scrollBarHolding = false;
}

// Set color of scroll bars
draw_set_color(global.colorThemeSelected1);
draw_rectangle(scrollBarRectX1, scrollBarRectY1, scrollBarRectX2, scrollBarRectY2, false);

// Check mouse clicks for scroll bar use
if (point_in_rectangle(mouse_x, mouse_y, scrollBarRectX1 + clipX, scrollBarRectY1 + clipY, scrollBarRectX2 + clipX, scrollBarRectY2 + clipY)) {
	if (mouse_check_button_pressed(mb_left)) {
		scrollBarHolding = true;
		scrollBarHoldingPlusY = mouse_y - scrollBarRectY1;
	}
}

scrollBarHoldingPlusY = 0;

//Let clicked mouse move the scroll bar, until unclicked
if (mouse_check_button_released(mb_left)) {
	scrollBarHolding = false;
}

if (scrollBarHolding) {
	scrollPlusY = mouse_y - y;
}

if (ds_grid_height(grid) * strHeight < windowHeight) {
	scrollPlusY = textMarginTop;
}
else {
	scrollPlusY = clamp(scrollPlusY, -windowHeight, windowHeight);
}






scr_suraceEnd();