function scr_drawToolPane(toolSprScale) {
	

	var mouseoverCancel = (instance_exists(obj_dropDown) || instance_exists(obj_dialogueBox) || instance_exists(obj_flyout));
	var toolSprWidth = sprite_get_width(spr_toolsNew) * toolSprScale;
	var toolSprHeight = sprite_get_height(spr_toolsNew) * toolSprScale;
	var camHeight = camera_get_view_height(camera_get_active());
	
	var mouseoverRectWidth = 5;
	
	var toolButtonX = floor(x + (windowWidth / 2));
	var toolButtonRectBuffer = toolSprWidth * 0.06;
	

	
	
	// tool button
	var toolButtonY = floor(y + (toolSprHeight * ((0 * 1.3) + 1)));
	var toolButtonRectX1 = floor(toolButtonX - (toolSprWidth / 2) - toolButtonRectBuffer);
	var toolButtonRectY1 = floor(toolButtonY - (toolSprHeight / 2) - toolButtonRectBuffer);
	var toolButtonRectX2 = floor(toolButtonX + (toolSprWidth / 2) + toolButtonRectBuffer);
	var toolButtonRectY2 = floor(toolButtonY + (toolSprHeight / 2) + toolButtonRectBuffer);
	var mouseoverTool = point_in_rectangle(mouse_x, mouse_y, toolButtonRectX1, toolButtonRectY1, toolButtonRectX2, toolButtonRectY2) && !mouseoverCancel;
	var toolImageIndex = 0;
	if (currentMode == modeRead) toolImageIndex = 0;
	else if (currentMode == modeTrack) toolImageIndex = 1;
	else if (currentMode == modeRez) toolImageIndex = 2;
	
	if (mouseoverTool) {
		draw_set_color(c_white);
		scr_drawRectWidth(toolButtonRectX1, toolButtonRectY1, toolButtonRectX2, toolButtonRectY2, mouseoverRectWidth);
		scr_createTooltip(toolButtonRectX1, toolButtonY, "Tool", obj_tooltip.arrowFaceRight);
		
		if (mouse_check_button_released(mb_left)) {
			var toolOptionList = ds_list_create();
			ds_list_add(toolOptionList, "menu_read", "menu_track", "menu_rez");
			scr_createFlyout(toolButtonRectX1, toolButtonY, toolOptionList, global.optionListTypeToolButton, spr_toolsNew, false);
		}
	}
	
	// draw tool sprite
	draw_sprite_ext(spr_toolsNew, toolImageIndex, toolButtonX, toolButtonY, toolSprScale, toolSprScale, 0, c_white, 1);


	
	
	// filter button
	var filterButtonY = floor(y + (toolSprHeight * ((1 * 1.3) + 1)));
	var filterButtonRectX1 = floor(toolButtonX - (toolSprWidth / 2) - toolButtonRectBuffer);
	var filterButtonRectY1 = floor(filterButtonY - (toolSprHeight / 2) - toolButtonRectBuffer);
	var filterButtonRectX2 = floor(toolButtonX + (toolSprWidth / 2) + toolButtonRectBuffer);
	var filterButtonRectY2 = floor(filterButtonY + (toolSprHeight / 2) + toolButtonRectBuffer);
	var mouseoverFilter = point_in_rectangle(mouse_x, mouse_y, filterButtonRectX1, filterButtonRectY1, filterButtonRectX2, filterButtonRectY2) && !mouseoverCancel;
	var filterImageIndex = 0;
	
	// mouseover & click on filter button
	if (mouseoverFilter) {
		draw_set_color(c_white);
		scr_drawRectWidth(filterButtonRectX1, filterButtonRectY1, filterButtonRectX2, filterButtonRectY2, mouseoverRectWidth);
		scr_createTooltip(filterButtonRectX1, filterButtonY, "Filter", obj_tooltip.arrowFaceRight);
		
		if (mouse_check_button_released(mb_left)) {
			var filterList = scr_getFilterList();
			if (ds_list_size(filterList) > 0) {
				
				// toggle filter depending on tab
				if (obj_panelPane.functionChainList_currentTab == obj_panelPane.functionChainList_tabRezBrush) obj_control.filterActiveRez = !obj_control.filterActiveRez;
				else if (obj_panelPane.functionChainList_currentTab == obj_panelPane.functionChainList_tabTrackBrush) obj_control.filterActiveTrack = !obj_control.filterActiveTrack;
				else if (obj_panelPane.functionChainList_currentTab == obj_panelPane.functionChainList_tabStackBrush) obj_control.filterActiveStack = !obj_control.filterActiveStack;
							
				// determine if filter should be activated or disabled
				obj_control.filterGridActive = (obj_panelPane.functionChainList_currentTab == obj_panelPane.functionChainList_tabRezBrush && obj_control.filterActiveRez)
												|| (obj_panelPane.functionChainList_currentTab == obj_panelPane.functionChainList_tabTrackBrush && obj_control.filterActiveTrack)
												|| (obj_panelPane.functionChainList_currentTab == obj_panelPane.functionChainList_tabStackBrush && obj_control.filterActiveStack);
							
				if (obj_control.filterGridActive) {
					scr_renderFilter();
				}
				else {
					scr_disableFilter();
				}
			}
		}
	}
	
	// draw highlight rectangle if filter is on
	if (obj_control.filterGridActive) {
		draw_set_color(global.colorThemeBG);
		draw_roundrect(filterButtonRectX1, filterButtonRectY1, filterButtonRectX2, filterButtonRectY2, false);
		filterImageIndex = 1;
	}
	
	// draw filter sprite
	draw_sprite_ext(spr_filterTool, filterImageIndex, toolButtonX, filterButtonY, toolSprScale, toolSprScale, 0, c_white, 1);
	
	
	
	
	// context button
	var contextButtonY = floor(y + (toolSprHeight * ((2 * 1.3) + 1)));
	var contextButtonRectX1 = floor(toolButtonX - (toolSprWidth / 2) - toolButtonRectBuffer);
	var contextButtonRectY1 = floor(contextButtonY - (toolSprHeight / 2) - toolButtonRectBuffer);
	var contextButtonRectX2 = floor(toolButtonX + (toolSprWidth / 2) + toolButtonRectBuffer);
	var contextButtonRectY2 = floor(contextButtonY + (toolSprHeight / 2) + toolButtonRectBuffer);
	var mouseoverContext = point_in_rectangle(mouse_x, mouse_y, contextButtonRectX1, contextButtonRectY1, contextButtonRectX2, contextButtonRectY2) && !mouseoverCancel;
	
	if (mouseoverContext) {
		draw_set_color(c_white);
		scr_drawRectWidth(contextButtonRectX1, contextButtonRectY1, contextButtonRectX2, contextButtonRectY2, mouseoverRectWidth);
		scr_createTooltip(contextButtonRectX1, contextButtonY, "Context", obj_tooltip.arrowFaceRight);
		
		if (mouse_check_button_released(mb_left)) {
			var contextOptionList = ds_list_create();
			ds_list_add(contextOptionList, "menu_above", "menu_between", "menu_below");
			scr_createFlyout(contextButtonRectX1, contextButtonY, contextOptionList, global.optionListTypeContext, spr_contextOptions, true);
		}
	}
	
	if (obj_panelPane.functionFilter_peek[0]) draw_sprite_ext(spr_contextTool, 1, toolButtonX, contextButtonY, toolSprScale, toolSprScale, 0, c_white, 1);
	if (obj_panelPane.functionFilter_peek[1]) draw_sprite_ext(spr_contextTool, 2, toolButtonX, contextButtonY, toolSprScale, toolSprScale, 0, c_white, 1);
	if (obj_panelPane.functionFilter_peek[2]) draw_sprite_ext(spr_contextTool, 3, toolButtonX, contextButtonY, toolSprScale, toolSprScale, 0, c_white, 1);
	
	// draw context sprite
	draw_sprite_ext(spr_contextTool, 0, toolButtonX, contextButtonY, toolSprScale, toolSprScale, 0, c_white, 1);

	
	
	
	// text shape button
	var shapeTextButtonY = floor(y + (toolSprHeight * ((3 * 1.3) + 1)));
	var shapeTextButtonRectX1 = floor(toolButtonX - (toolSprWidth / 2) - toolButtonRectBuffer);
	var shapeTextButtonRectY1 = floor(shapeTextButtonY - (toolSprHeight / 2) - toolButtonRectBuffer);
	var shapeTextButtonRectX2 = floor(toolButtonX + (toolSprWidth / 2) + toolButtonRectBuffer);
	var shapeTextButtonRectY2 = floor(shapeTextButtonY + (toolSprHeight / 2) + toolButtonRectBuffer);
	var mouseoverShapeText = point_in_rectangle(mouse_x, mouse_y, shapeTextButtonRectX1, shapeTextButtonRectY1, shapeTextButtonRectX2, shapeTextButtonRectY2) && !mouseoverCancel;
	var shapeTextImageIndex = (obj_control.shape == obj_control.shapeText) ? 0 : 1;
	
	if (mouseoverShapeText) {
		draw_set_color(c_white);
		scr_drawRectWidth(shapeTextButtonRectX1, shapeTextButtonRectY1, shapeTextButtonRectX2, shapeTextButtonRectY2, mouseoverRectWidth);
		scr_createTooltip(shapeTextButtonRectX1, shapeTextButtonY, "Prose", obj_tooltip.arrowFaceRight);
		
		if (mouse_check_button_released(mb_left)) {
			var shapeTextOptionList = ds_list_create();
			ds_list_add(shapeTextOptionList, "menu_prose", "menu_grid");
			scr_createFlyout(shapeTextButtonRectX1, shapeTextButtonY, shapeTextOptionList, global.optionListTypeProse, spr_shapeOptions, false);
		}
	}
	
	// draw shape sprite
	draw_sprite_ext(spr_proseGridTool, shapeTextImageIndex, toolButtonX, shapeTextButtonY, toolSprScale, toolSprScale, 0, c_white, 1);

	
	
	// justify button
	var justifyButtonY = floor(y + (toolSprHeight * ((4 * 1.3) + 1)));
	var justifyButtonRectX1 = floor(toolButtonX - (toolSprWidth / 2) - toolButtonRectBuffer);
	var justifyButtonRectY1 = floor(justifyButtonY - (toolSprHeight / 2) - toolButtonRectBuffer);
	var justifyButtonRectX2 = floor(toolButtonX + (toolSprWidth / 2) + toolButtonRectBuffer);
	var justifyButtonRectY2 = floor(justifyButtonY + (toolSprHeight / 2) + toolButtonRectBuffer);
	var mouseoverJustify = point_in_rectangle(mouse_x, mouse_y, justifyButtonRectX1, justifyButtonRectY1, justifyButtonRectX2, justifyButtonRectY2) && !mouseoverCancel;
	var justifyImageIndex = 0;
	if (obj_control.justify == obj_control.justifyCenter) justifyImageIndex = 1;
	else if (obj_control.justify == obj_control.justifyRight) justifyImageIndex = 2;
	
	if (mouseoverJustify) {
		draw_set_color(c_white);
		scr_drawRectWidth(justifyButtonRectX1, justifyButtonRectY1, justifyButtonRectX2, justifyButtonRectY2, mouseoverRectWidth);
		scr_createTooltip(justifyButtonRectX1, justifyButtonY, "Justify", obj_tooltip.arrowFaceRight);
		
		if (mouse_check_button_released(mb_left)) {
			var justifyOptionList = ds_list_create();
			ds_list_add(justifyOptionList, "menu_left", "menu_center", "menu_right");
			scr_createFlyout(justifyButtonRectX1, justifyButtonY, justifyOptionList, global.optionListTypeJustify, spr_justifyOptions, false);
		}
	}
	
	// draw justify sprite
	draw_sprite_ext(spr_justifyTool, justifyImageIndex, toolButtonX, justifyButtonY, toolSprScale, toolSprScale, 0, c_white, 1);
	
	
	
	
	
	
	
	
	


	// Prevent typing in text from changing the tool mode
	if (!obj_control.gridView and !obj_control.dialogueBoxActive and !instance_exists(obj_dropDown) and !instance_exists(obj_dialogueBox) and obj_control.mouseoverTagShortcut == "") {
		if (keyboard_check_pressed(ord("E")) and not keyboard_check(vk_control)) {
			currentMode = modeRead;
			//obj_panelPane.functionChainList_currentTab = obj_panelPane.functionChainList_tabLine;
		}
		if (keyboard_check_pressed(ord("R")) and not keyboard_check(vk_control)) {
			currentMode = modeRez;
			//obj_panelPane.functionChainList_currentTab = obj_panelPane.functionChainList_tabRezBrush;
		}
		if (keyboard_check_pressed(ord("T"))) {
			currentMode = modeTrack;
			//obj_panelPane.functionChainList_currentTab = obj_panelPane.functionChainList_tabTrackBrush;
		}
	}

	if (global.wheresElmo) {
		currentMode = modeTrack;
	}
	
	// clicking on toolpane will deselect chain
	if (device_mouse_check_button_released(0, mb_left) and point_in_rectangle(mouse_x, mouse_y, x, y, x + windowWidth, y + windowHeight)) {
		if (not obj_control.gridView) {
			with (obj_chain) {
				scr_chainDeselect();
			}
		}
	}
	
	// help button
	var helpSpriteWidth = sprite_get_width(spr_helpToggle) * toolSprScale;
	var helpX1 = x + (windowWidth/2) - (helpSpriteWidth/2);
	var helpY1 = camHeight * 0.95;
	var helpX2 = helpX1 + helpSpriteWidth;
	var helpY2 = helpY1 + helpSpriteWidth;
	var mouseOverHelp = point_in_rectangle(mouse_x,mouse_y,helpX1, helpY1, helpX2, helpY2);
	
	var helpSubImage = (mouseOverHelp) ? 1 : 0;
	
	draw_sprite_ext(spr_helpToggle, helpSubImage , floor( mean( helpX2 , helpX1)), floor( mean( helpY2 , helpY1)) , toolSprScale, toolSprScale,0, c_white ,1);
	
	var helpToolTipText = "Help";
	
	if(mouseOverHelp){
		scr_createTooltip(helpX1, floor( mean( helpY2 , helpY1)), helpToolTipText , obj_tooltip.arrowFaceRight);
		if(device_mouse_check_button_released(0, mb_left)){
			with(obj_panelPane){
				functionHelp_collapsed = !functionHelp_collapsed;
			}
		}
	}
	

}
