// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_drawLineEntryList(unitID, unitSubMap, entryList, pixelY){
	
	draw_set_color(global.colorThemeText);
	draw_set_alpha(1);
	draw_set_valign(fa_middle);
	
	// set halign
	var halign = fa_left;
	if (justify == justifyRight && shape == shapeBlock) halign = fa_right;
	draw_set_halign(halign);
	
	var camWidth = camera_get_view_width(camera_get_active());
	var shapeTextX = 0;
	var spaceWidth = string_width(" ");
	
	// get unit width
	var unitWidth = 0;
	if (justify != justifyLeft) {
		unitWidth = string_width(scr_getUnitText(unitSubMap));
	}
	
	var entryListSize = ds_list_size(entryList);
	var i = (obj_control.drawLineState == obj_control.lineState_ltr)? 0 : entryListSize-1;
	var j = 0;

	repeat(entryListSize) {
		
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
		scr_tokenCalculateVoid(currentToken);
		var currentDisplayCol = currentTokenSubMap[? "displayCol"];
		var currentPixelX = scr_setTokenX(currentTokenSubMap, currentDisplayCol, entryListSize, j, unitWidth, shapeTextX, camWidth);
		shapeTextX += string_width(currentDisplayStr) + spaceWidth;
		
		
		//mouseover Token check
		currentDisplayStr = scr_adaptFont(currentDisplayStr,"M");
		var currentTokenStringWidth = string_width(currentDisplayStr);
		var currentTokenStringHeight = string_height(currentDisplayStr);		
		var tokenRectBuffer = 3;
		var tokenRectX1 = currentPixelX - tokenRectBuffer;
		var tokenRectY1 = pixelY - (currentTokenStringHeight / 2) - tokenRectBuffer;
		var tokenRectX2 = tokenRectX1 + currentTokenStringWidth + (tokenRectBuffer * 2);
		var tokenRectY2 = tokenRectY1 + currentTokenStringHeight + (tokenRectBuffer * 2);
		if (halign == fa_right) {
			tokenRectX1 -= currentTokenStringWidth;
			tokenRectX2 -= currentTokenStringWidth;
		}
		var mouseOverToken = point_in_rectangle(mouse_x,mouse_y, tokenRectX1, tokenRectY1, tokenRectX2, tokenRectY2) && hoverTokenID == "" && !mouseoverPanelPane;
		
		// draw background tokenRect
		draw_set_color(global.colorThemeBG);
		draw_set_alpha(1);
		draw_rectangle(tokenRectX1, tokenRectY1, tokenRectX2, tokenRectY2, false);
		
		// check if this token is in mouse rect
		var mouseRectExists = (mouseHoldRectX1 >= 0 && mouseHoldRectY1 >= 0);
		var inMouseRect = false;
		if (mouseRectExists) {
			inMouseRect = rectangle_in_rectangle(tokenRectX1, tokenRectY1, tokenRectX2, tokenRectY2, min(mouse_x, mouseHoldRectX1), min(mouse_y, mouseHoldRectY1), max(mouse_x, mouseHoldRectX1), max(mouse_y, mouseHoldRectY1));
			if (inMouseRect && !mouse_check_button_released(mb_left)) {
				ds_list_add(inRectTokenIDList, currentToken);
				scr_addToListOnce(inRectUnitIDList, unitID);
			}
		}
		
		// draw border on this token if it is in the mouse rect
		if (mouseRectExists && inMouseRect && !mouse_check_button_released(mb_left)) {
			draw_set_color(c_ltblue);
			scr_drawRectWidth(tokenRectX1, tokenRectY1, tokenRectX2, tokenRectY2, 2, true);
		}
	
		// get this token's inChainsList, and update the chainShowList accordingly
		var inChainsList = currentTokenSubMap[?"inChainsList"];
		scr_updateChainShowList(inChainsList, obj_chain.chainShowList, currentTokenSubMap[?"inChunkList"], obj_chain.chunkShowList, currentToken, tokenRectX1, tokenRectY1, tokenRectX2, tokenRectY2);	
		
		// mouseover token
		if(mouseOverToken){
			
			// if this token is not in a chain, draw a thin border when mousing over
			var sizeOfInChainsList = 0;
			if (scr_isNumericAndExists(inChainsList, ds_type_list)) sizeOfInChainsList = ds_list_size(inChainsList);
			if (sizeOfInChainsList == 0) {
				draw_set_color(global.colorThemeBorders);
				draw_rectangle(tokenRectX1,tokenRectY1,tokenRectX2,tokenRectY2, true);
			}
			obj_control.hoverTokenID = currentToken;
			
			// click on token
			if(device_mouse_check_button_released(0, mb_left) and !obj_control.mouseoverPanelPane and !instance_exists(obj_dialogueBox)) {
				var focusedchainIDSubMap = global.nodeMap[? obj_chain.currentFocusedChainID];
				
				// if focused chain is a stack, deselect it
				if (scr_isNumericAndExists(focusedchainIDSubMap, ds_type_map)){
					var focusedChainType = focusedchainIDSubMap[? "type"];
					if (focusedChainType == "stackChain") {
						scr_chainDeselect();
					}
				}
				
				if (obj_control.ctrlHold) {
					// combine chains
					var inChainsList = currentTokenSubMap[?"inChainsList"];
					scr_combineChainsDrawLine(inChainsList);
				}
				
				scr_tokenClicked(currentToken);
			}
			
			// Check for rightMouseClick
			if (device_mouse_check_button_released(0, mb_right) and !instance_exists(obj_dialogueBox)) {
				
				obj_control.rightClickID = obj_control.hoverTokenID;
	
				// wait 1 frame and then show the right click dropdown
				with (obj_alarm) {
					alarm[11] = 2;
				}

			}
			
			
		}
		
		// draw the token's text
		var wordFound = currentTokenSubMap[?"searched"];
		if(wordFound){
			draw_set_color(make_color_rgb(20, 146, 181));
		}
		else{
			draw_set_color(global.colorThemeText);
		}
		draw_set_alpha(1);
		draw_text(currentPixelX, pixelY, currentDisplayStr);
		
		// run through the loop forward or backward depending on if LTR or RTL
		if (drawLineState = lineState_ltr) i++;
		else i--;
		j++;
		
	}

}