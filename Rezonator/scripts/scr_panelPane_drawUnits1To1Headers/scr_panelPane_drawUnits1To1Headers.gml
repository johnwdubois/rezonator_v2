// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_panelPane_drawUnits1To1Headers(){
	
	var headerList = obj_control.navUnitFieldList;
	var headerListSize = ds_list_size(headerList);
	var headerHeight = functionTabs_tabHeight;
	var colWidth = windowWidth / ds_list_size(headerList);
	var lineStateLTR = (obj_control.drawLineState == obj_control.lineState_ltr);
	var textMarginLeft = 8;
	var plusX = x;
	for (var i = 0; i < headerListSize; i++) {
		
		var currentField = headerList[| i];
		
		// get header coordinates
		var headerRectX1 = plusX;
		var headerRectY1 = y;
		var headerRectX2 = headerRectX1 + colWidth;
		var headerRectY2 = headerRectY1 + headerHeight;
		var headerTextX = headerRectX1 + (textMarginLeft);
		if (!lineStateLTR) {
			headerTextX = headerRectX2 - (textMarginLeft);
		}
		var headerTextY = floor(mean(headerRectY1, headerRectY2));
		
		// draw headers
		draw_set_color(global.colorThemeBG);
		draw_rectangle(headerRectX1, headerRectY1, headerRectX2, headerRectY2, false);
		
		// draw vertical lines dividing columns
		if(lineStateLTR){	
			if(i > 0){
				draw_set_color(global.colorThemeBorders);
				draw_line_width(headerRectX1, headerRectY1, headerRectX1, y + windowHeight, 1);
			}
		}
		else{
			if(i < headerListSize-1){
				draw_set_color(global.colorThemeBorders);
				draw_line_width(headerRectX1 + 1, headerRectY1, headerRectX1 + 1, y + windowHeight, 1);
			}
		}


		
		// draw displayUnit button
		var displayUnitButtonSize = (headerHeight / 4);
		var displayUnitButtonX = headerRectX1 + (colWidth - displayUnitButtonSize / 2) - (textMarginLeft * 2);
		var displayUnitButtonY = mean(headerRectY1, headerRectY2);
		var mouseoverDisplayUnit = point_in_circle(mouse_x, mouse_y, displayUnitButtonX, displayUnitButtonY, displayUnitButtonSize) && !instance_exists(obj_dropDown) && !instance_exists(obj_dialogueBox);
		var mouseoverHeader = scr_pointInRectangleClippedWindow(mouse_x, mouse_y, headerRectX1, headerRectY1, headerRectX2, headerRectY2) && !instance_exists(obj_dropDown) && !instance_exists(obj_dialogueBox) && !mouseoverDisplayUnit;
	
		
		// mouseover & click on header
		if (mouseoverHeader) {
			
			// draw underline
			var underlineX1 = headerTextX;
			var underlineX2 = headerTextX + string_width(currentField);
			var underlineY = headerTextY + (headerHeight * 0.25);
			draw_set_color(global.colorThemeBorders);
			draw_line_width(underlineX1, underlineY, underlineX2, underlineY, 2);
			scr_createTooltip(mean(headerRectX1, headerRectX2), headerRectY2, "Change field", obj_tooltip.arrowFaceUp);
			
			if (mouse_check_button_released(mb_left)) {
				obj_control.unitFieldToChange = currentField;
				with (obj_panelPane) {
					chosenCol = i;
				}
				
				var dropDownOptionList = ds_list_create();
				ds_list_add(dropDownOptionList, "Set Field", "Create Field", "Add new Tag", "Remove From Tag Set", "Set as Translation");
				scr_createDropDown(headerRectX1, headerRectY2, dropDownOptionList, global.optionListTypeFieldUnits1To1);
			}
		}

		

	
		// change display unit
		if (mouseoverDisplayUnit && !instance_exists(obj_dropDown)) {
				
			scr_createTooltip(displayUnitButtonX, displayUnitButtonY + displayUnitButtonSize, "Display Unit", obj_tooltip.arrowFaceUp);
			draw_set_color(global.colorThemeSelected1);
			draw_circle(displayUnitButtonX, displayUnitButtonY, displayUnitButtonSize * 0.75, false);
			
			if (mouse_check_button_released(mb_left)) {
				global.speakerField = currentField;		
			}
		}
	
	
		// draw circle for display unit selection
		draw_set_color(global.colorThemeBorders);
		draw_circle(displayUnitButtonX, displayUnitButtonY, displayUnitButtonSize, true);
		if (global.speakerField == currentField) {
			draw_set_color(merge_color(global.colorThemeBorders, global.colorThemeBG, 0.1));
			draw_circle(displayUnitButtonX, displayUnitButtonY, displayUnitButtonSize * 0.75, false);
			draw_set_color(global.colorThemeBorders);
		}

			    

		// draw header text
		scr_adaptFont(string(currentField), "M");
		draw_set_color(global.colorThemeText);
	

		draw_text(headerTextX, headerTextY, currentField);
	
		plusX += colWidth;
	}
	
	
	// draw horizontal line to separate column headers from data
	draw_set_color(global.colorThemeBorders);
	draw_rectangle(x, y, x + windowWidth, y + headerHeight, true);

}