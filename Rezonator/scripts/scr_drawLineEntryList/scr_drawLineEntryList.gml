// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_drawLineEntryList(entryList, pixelY){
	
	draw_set_color(global.colorThemeText);
	draw_set_alpha(1);
	draw_set_halign(fa_left);
	draw_set_valign(fa_middle);
	
	var camWidth = camera_get_view_width(camera_get_active());
	var shapeTextX = 0;
	var spaceWidth = string_width(" ");
	
	var entryListSize = ds_list_size(entryList);
	for (var i = 0; i < entryListSize; i++) {
		
		// get current entry submap and make sure it exists
		var currentEntry = entryList[| i];
		var currentEntrySubMap = global.nodeMap[? currentEntry];
		if (!scr_isNumericAndExists(currentEntrySubMap, ds_type_map)) continue;
		
		// get token for this entry and make sure that exists
		var currentToken = currentEntrySubMap[? "token"];
		var currentTokenSubMap = global.nodeMap[? currentToken];
		if (!scr_isNumericAndExists(currentTokenSubMap, ds_type_map)) continue;
		
		// get tag map for this token
		var currentTagMap = currentTokenSubMap[? "tagMap"];
		if (!scr_isNumericAndExists(currentTagMap, ds_type_map)) continue;
		var currentDisplayStr = string(currentTagMap[? global.displayTokenField]);
		
		// get & set pixelX value
		var currentDisplayCol = currentTokenSubMap[? "displayCol"];
		var currentPixelX = scr_setTokenX(currentTokenSubMap, currentDisplayCol, entryListSize, 0, shapeTextX, camWidth);
		shapeTextX += string_width(currentDisplayStr) + spaceWidth;
		
		//mouseover Token check
		scr_adaptFont(currentDisplayStr,"M");
		var currentTokenStringWidth = string_width(currentDisplayStr);
		var currentTokenStringHeight = string_height(currentDisplayStr);
	
		
		var tokenRectBuffer = 3;
		var tokenRectX1 = currentPixelX - tokenRectBuffer;
		var tokenRectY1 = pixelY - (currentTokenStringHeight / 2) - tokenRectBuffer;
		var tokenRectX2 = tokenRectX1 + currentTokenStringWidth + (tokenRectBuffer * 2);
		var tokenRectY2 = tokenRectY1 + currentTokenStringHeight + (tokenRectBuffer * 2);
		
		var mouseOverToken = point_in_rectangle(mouse_x,mouse_y, tokenRectX1,tokenRectY1,tokenRectX2,tokenRectY2) && obj_control.hoverTokenID == "";
		
		if(mouseOverToken){
			draw_rectangle(tokenRectX1,tokenRectY1,tokenRectX2,tokenRectY2, true);
			obj_control.hoverTokenID = currentToken;
			if(device_mouse_check_button_released(0, mb_left)){
				scr_tokenClicked(currentToken);
			}
		}


		
		draw_text(currentPixelX, pixelY, currentDisplayStr);
		
		
	}

}