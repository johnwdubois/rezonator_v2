// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_panelPane_drawSearchList(){

		
	var strHeight = string_height("0") * 1.5;
	var numColX = x;
	var numColWidth = windowWidth * 0.1;
	var nameColX = numColX + numColWidth;
	var nameColWidth = windowWidth * 0.3;
	var termColX = nameColX + nameColWidth;
	
	var textBuffer = 8;
	var headerHeight = functionTabs_tabHeight;
	var textPlusY = 0;
	var textAdjustY = 0;
	var drawScrollbar = true;
	
	var anyOptionMousedOver = false;
	var mouseoverScrollBar = (drawScrollbar) ? point_in_rectangle(mouse_x, mouse_y, x + windowWidth - global.scrollBarWidth, y, x + windowWidth, y + windowHeight) : false;
	
	
	
	
	
	
	// get the instance ID for the searchContents pane so we can easily reference it
	var chainContentsPanelPaneInst = 0;
	with (obj_panelPane) {
		if (currentFunction == functionChainContents) {
			chainContentsPanelPaneInst = self.id;
		}
	}
	var relativeScrollPlusY = (drawScrollbar) ? scrollPlusY : chainContentsPanelPaneInst.scrollPlusY;
	
	
	
	// get the search list & make sure it exists
	var searchList = global.nodeMap[? "searchNodeList"];
	if (!scr_isNumericAndExists(searchList, ds_type_list)) {
		show_debug_message("scr_panelPane_drawsearchList ... searchList does not exist");
		exit;
	}
	var searchListSize = ds_list_size(searchList);
	
	scr_surfaceStart();
	
	draw_set_halign(fa_left);
	draw_set_valign(fa_middle);
	draw_set_alpha(1);
	var setList = "";
	var setListSize = 0;
	
	// loop over searchs
	for (var i = 0; i < searchListSize; i++) {
		
		// get data for currentSearch
		var currentSearch = searchList[| i];
		if(!scr_isNumericAndExists( global.searchMap, ds_type_map)){exit;}
		var currentSearchSubMap = global.searchMap[? currentSearch];
		if (!scr_isNumericAndExists(currentSearchSubMap, ds_type_map)) continue;
		
		var currentSearchName = currentSearchSubMap[? "name"];
		var currentSearchTermList = currentSearchSubMap[? "searchTermList"];
		var currentSearchSelected = (functionSearchList_searchSelected == currentSearch);
		
		
		// Get dimensions of rectangle around search name
		var searchRectX1 = x;
		var searchRectY1 = y + headerHeight + relativeScrollPlusY + textPlusY - (strHeight / 2);
		var searchRectX2 = x + windowWidth;
		var searchRectY2 = searchRectY1 + strHeight;
		var mouseoverSearchRect = scr_pointInRectangleClippedWindow(mouse_x, mouse_y, searchRectX1, searchRectY1, searchRectX2, searchRectY2) && !mouseoverScrollBar;
		var highlight = (mouseoverSearchRect || functionSearchList_searchMouseover == currentSearch);
		var textY = floor(mean(searchRectY1, searchRectY2));
		
		// click on search name
		if (mouseoverSearchRect) {
			anyOptionMousedOver = true;
			if (mouse_check_button_released(mb_left) && !instance_exists(obj_dropDown)) {
				with (obj_panelPane) functionSearchList_searchSelected = currentSearch;
				obj_control.selectedSearchID = functionSearchList_searchSelected;
				scr_renderFilter2();
			}
			
			if (mouse_check_button_released(mb_right)) {
				with (obj_panelPane) functionSearchList_searchSelected = currentSearch;
				obj_control.selectedSearchID = functionSearchList_searchSelected;
				var dropDownOptionList = ds_list_create();

				ds_list_add(dropDownOptionList, "Rename", "Delete");

				if (ds_list_size(dropDownOptionList) > 0 and obj_control.ableToCreateDropDown) {
					//scr_createDropDown(mouse_x, mouse_y, dropDownOptionList, global.optionListTypesearchList);
				}
			
			}
		}

		
		// draw rect
		var rectColor = (currentSearchSelected) ? global.colorThemeSelected2 : merge_color(global.colorThemeBG, global.colorThemeSelected1, highlight ? 0.8 : 0.4);
		var textColor = (currentSearchSelected) ? global.colorThemeBG : global.colorThemeText;
		draw_set_color(rectColor);
		draw_rectangle(searchRectX1 - clipX, searchRectY1 - clipY, searchRectX2 - clipX, searchRectY2 - clipY, false);
		
		// # column
		draw_set_color(textColor);
		draw_text(floor(numColX + textBuffer) - clipX, textY - clipY, string(i + 1));
		
		// name column
		draw_set_color(textColor);
		draw_text(floor(nameColX + textBuffer) - clipX, textY - clipY, string(currentSearchName));

		
		// ListOfTerms column
		draw_set_color(textColor);
		draw_text(floor(termColX + textBuffer) - clipX, textY - clipY, scr_getStringOfList(currentSearchTermList));

		
	
		// increment plusY
		textPlusY += strHeight;
		
	}
	
	
	// draw "create search" option at end of list
	var createsearchRectX1 = x;
	var createsearchRectY1 = y + headerHeight + relativeScrollPlusY + textPlusY - (strHeight / 2);
	var createsearchRectX2 = x + windowWidth;
	var createsearchRectY2 = createsearchRectY1 + strHeight;
	var mouseoverCreatesearchRect = scr_pointInRectangleClippedWindow(mouse_x, mouse_y, createsearchRectX1, createsearchRectY1, createsearchRectX2, createsearchRectY2) && !mouseoverScrollBar && !instance_exists(obj_dropDown) && !instance_exists(obj_dialogueBox);
	draw_set_color(merge_color(c_green, global.colorThemeSelected1, mouseoverCreatesearchRect ? 0.4 : 0.6));
	draw_rectangle(createsearchRectX1 - clipX, createsearchRectY1 - clipY, createsearchRectX2 - clipX, createsearchRectY2 - clipY, false);
	draw_set_color(global.colorThemeText);
	draw_set_halign(fa_center);
	draw_text(floor(mean(x, nameColX)) - clipX, floor(mean(createsearchRectY1, createsearchRectY2)) - clipY, "+");
	draw_set_halign(fa_left);
	draw_text(floor(nameColX + textBuffer) - clipX, floor(mean(createsearchRectY1, createsearchRectY2)) - clipY, "Create search");
	
	// click on "create search"
	if (mouseoverCreatesearchRect && mouse_check_button_released(mb_left)) {
		
		// Activates word searching using search grid
		obj_control.preSwitchDisplayRow = obj_control.scrollPlusYDest;
		obj_control.preSwitchLineGrid = obj_control.currentActiveLineGrid;
		obj_control.preSwitchSearchDisplayRow = 0;

		if (!obj_control.dialogueBoxActive) {
			keyboard_string = "";
			obj_control.fPressed = true;
		}


		obj_control.dialogueBoxActive = true;

		if (!instance_exists(obj_dialogueBox)) {
			instance_create_layer(x, y, "InstancesDialogue", obj_dialogueBox);
		}
	}
	
	
	
	
	
	// only search a scrollbar if we're in 1toMany
	if (drawScrollbar) {
		scr_scrollBar(searchListSize + 1, -1, strHeight, headerHeight,
			global.colorThemeSelected1, global.colorThemeSelected2,
			global.colorThemeSelected1, global.colorThemeSelected2, spr_ascend, windowWidth, windowHeight);
	}

	
		
	scr_surfaceEnd();

	
	
	
	// draw column headers
	var headerPlusX = 0;
	for (var i = 0; i < 3; i++) {
		
		// get column data
		var colWidth = 0;
		var colText = "";
		if (i == 0) {
			colWidth = numColWidth;
			colText = "#";
		}
		else if (i == 1) {
			colWidth = nameColWidth;
			colText = "Name";
		}
		else if (i == 2) {
			colWidth = windowWidth - termColX;
			colText = "Searched Words";
		}
		
		// get header coordinates
		var headerRectX1 = x + headerPlusX;
		var headerRectY1 = y;
		var headerRectX2 = headerRectX1 + colWidth;
		var headerRectY2 = headerRectY1 + headerHeight;
		
		// draw header rects
		draw_set_color(global.colorThemeBG);
		draw_rectangle(headerRectX1, headerRectY1, headerRectX2, headerRectY2, false);
		draw_set_color(global.colorThemeBorders);
		draw_rectangle(headerRectX1, headerRectY1, headerRectX2, headerRectY2, true);
		
		// draw header text
		var headerTextX = floor(headerRectX1 + textBuffer);
		var headerTextY = floor(mean(headerRectY1, headerRectY2));
		draw_set_halign(fa_left);
		draw_set_valign(fa_middle);
		draw_set_color(global.colorThemeText);
		draw_text(headerTextX, headerTextY, colText);
		

		
		
		headerPlusX += colWidth;
	}
	

}