function scr_drawChains() {
	/*
		Purpose: draw rezChains and move words on screen according to the rezChains
	*/
	
	scr_setMouseLineWordID();

	var lineX1 = undefined;
	var lineY1 = undefined;
	var lineX2 = undefined;
	var lineY2 = undefined;
	var mouseLineX = undefined;
	var mouseLineY = undefined;

	var minWordWidth = 9999999;
	var linePlusX = 0;

	var currentWordStringHeight1 = string_height("0");
	var currentWordStringHeight2 = currentWordStringHeight1;

	var wordTopMargin = obj_control.wordTopMargin;
	var rezChainList = ds_map_find_value(global.nodeMap, "rezChainList");
	var rezChainListSize = ds_list_size(rezChainList);
	var activeLineGridHeight = ds_grid_height(obj_control.currentActiveLineGrid);
	var arrowSize = 0.3 + (0.1 * global.fontSize / 5);

	// loop through rezChainList to get chain info
	var chainShowListSize = ds_list_size(obj_chain.chainShowList);
	for (var i = 0; i < chainShowListSize; i++) {
		minWordWidth = 9999999;
		
		var currentChainID = ds_list_find_value(obj_chain.chainShowList, i);
		
		// skip this chain if we can't find it in the nodeMap
		if (!ds_map_exists(global.nodeMap, currentChainID)) continue;
		
		// make sure this chain's subMap exists and that it is actually a map
		var currentChainSubMap = ds_map_find_value(global.nodeMap, currentChainID);
		if (!is_numeric(currentChainSubMap)) continue;
		if (!ds_exists(currentChainSubMap, ds_type_map)) continue;
		
		// get chain's setIDList and make sure it exists
		var chainType = ds_map_find_value(currentChainSubMap, "type");
		var currentSetIDList = ds_map_find_value(currentChainSubMap, "vizSetIDList");
		if (!is_numeric(currentSetIDList)) continue;
		if (!ds_exists(currentSetIDList, ds_type_list)) continue;
		var currentSetIDListSize = ds_list_size(currentSetIDList);
		var currentChainColor = ds_map_find_value(currentChainSubMap, "chainColor");
		var currentChainVisible = ds_map_find_value(currentChainSubMap, "visible");
		var currentChainAlign = ds_map_find_value(currentChainSubMap, "alignChain");
		
		// make sure this is a rezChain or trackChain and that we should be drawing it
		if (chainType != "rezChain" && chainType != "trackChain") continue;
		var showRezBorder = false;
		var showTrackBorder = false;
		if (currentChainVisible) {
			if (chainType == "rezChain") showRezBorder = true;
			else if (chainType == "trackChain") showTrackBorder = true;
		}
	
		// find minimum word width so we know the X position of the chain
		for (var j = 0; j < currentSetIDListSize; j++) {
			var currentEntry = ds_list_find_value(currentSetIDList, j);
			var currentEntrySubMap = ds_map_find_value(global.nodeMap, currentEntry);
			var currentWordID = ds_map_find_value(currentEntrySubMap, "word");
			var tokenSubMap = global.nodeMap[?currentWordID];
			var currentWordWidth = 0;
			if (scr_isNumericAndExists(tokenSubMap, ds_type_map)){
				var tagMap = tokenSubMap[?"tagMap"];
				if (scr_isNumericAndExists(tagMap, ds_type_map)){
					currentWordWidth = string_width(string(tagMap[?global.displayTokenField]));
				}
			}
			currentWordWidth = max(currentWordWidth, 0);
		
			if (currentWordWidth < minWordWidth) {
				minWordWidth = currentWordWidth;
				linePlusX = minWordWidth;
			}
		}
	
		var wordsInSameLine = false;
		var firstWordInLine = -1;
		var firstWordInLine = -1;
	
		// loop through current chain's wordIDList to draw the lines of the chain
		for (var j = 0; j < currentSetIDListSize - 1; j++) {
			
			// get the wordIDs for the 2 words we want to draw a line between
			var currentEntry1 = currentSetIDList[| j];
			var currentEntry1SubMap = global.nodeMap[? currentEntry1];
			var currentEntry2 = currentSetIDList[| j + 1];
			var currentEntry2SubMap = global.nodeMap[? currentEntry2];
			var currentWordID1 = currentEntry1SubMap[? "word"];
			var currentWordID2 = currentEntry2SubMap[? "word"];
			
			// check if the words are chunks
			var currentWordID1IsChunk = false;
			if (ds_map_exists(global.nodeMap, currentWordID1)) {
				var currentWordID1SubMap = global.nodeMap[? currentWordID1];
				var currentWordID1Type = currentWordID1SubMap[? "type"];
				if (currentWordID1Type == "chunk") currentWordID1IsChunk = true;
				if (currentWordID1IsChunk) {
					var currentWordID1TokenList = currentWordID1SubMap[? "tokenList"];
					currentWordID1 = currentWordID1TokenList[| 0];
				}
			}
			var currentWordID2IsChunk = false;
			if (ds_map_exists(global.nodeMap, currentWordID2)) {
				var currentWordID2SubMap = global.nodeMap[? currentWordID2];
				var currentWordID2Type = currentWordID2SubMap[? "type"];
				if (currentWordID2Type == "chunk") currentWordID2IsChunk = true;
				if (currentWordID2IsChunk) {
					var currentWordID2TokenList = currentWordID2SubMap[? "tokenList"];
					currentWordID2 = currentWordID2TokenList[| 0];
				}
			}
			
		
			var currentLineID1 = ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colDisplayRow, currentWordID1 - 1);
			var chunkWord1 = (ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colWordState, currentWordID1 - 1) == obj_control.wordStateChunk);		
			var currentWordStringWidth1 = string_width(string(ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colDisplayString, currentWordID1 - 1)));
		
			lineX1 = ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colPixelX, currentWordID1 - 1);
			lineY1 = ds_grid_get(obj_control.currentActiveLineGrid, obj_control.lineGrid_colPixelY, currentLineID1);
		
			var currentLineID2 = ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colDisplayRow, currentWordID2 - 1);
			var chunkWord2 = (ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colWordState, currentWordID2 - 1) == obj_control.wordStateChunk);
			var sideLink = false;
			
			// check if this is a side link
			if (currentLineID1 == currentLineID2) {
				wordsInSameLine = true;
				// if we have not set the first word in the line yet, set it to be this one
				if (firstWordInLine < 0) {
					firstWordInLine = currentWordID1;
				}
				sideLink = true;
			}
			else {
				if (wordsInSameLine and firstWordInLine >= 0 and (firstWordInLine - 1) < ds_grid_height(obj_control.wordGrid)) {
					currentWordID1 = firstWordInLine;
					currentLineID1 = ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colDisplayRow, currentWordID1 - 1);
					//currentLineGridIndex1 = ds_grid_value_y(obj_control.currentActiveLineGrid, obj_control.lineGrid_colUnitID, 0, obj_control.lineGrid_colUnitID, activeLineGridHeight, currentUnitID1);
		
					currentWordStringWidth1 = string_width(string(ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colDisplayString, currentWordID1 - 1)));
		
					lineX1 = ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colPixelX, currentWordID1 - 1);
					lineY1 = ds_grid_get(obj_control.currentActiveLineGrid, obj_control.lineGrid_colPixelY, currentLineID1);
				}
			
				firstWordInLine = -1;
			}
		
			var currentWordStringWidth2 = string_width(string(ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colDisplayString, currentWordID2 - 1)));
		
			lineX2 = ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colPixelX, currentWordID2 - 1);
			lineY2 = ds_grid_get(obj_control.currentActiveLineGrid, obj_control.lineGrid_colPixelY, currentLineID2);
		
			var currentLineGridIndex1InDrawRange = true;
			var currentLineGridIndex2InDrawRange = true;
		
			if (currentLineID1 < obj_control.drawRangeStart or currentLineID1 > obj_control.drawRangeEnd) {
				currentLineGridIndex1InDrawRange = false;
			}
		
			if (currentLineID2 < obj_control.drawRangeStart or currentLineID2 > obj_control.drawRangeEnd) {
				currentLineGridIndex2InDrawRange = false;
			}
		
		
		
			//wordTopMargin + 
			// only draw line if every value is real and we are in the draw range
			if not (lineX1 == undefined or lineY1 == undefined or lineX2 == undefined or lineY2 == undefined)
			and not (lineY1 < wordTopMargin + (-obj_control.gridSpaceVertical * 2) and lineY2 < wordTopMargin + (-obj_control.gridSpaceVertical * 2))
			and not (lineY1 > camera_get_view_height(camera_get_active()) + (obj_control.gridSpaceVertical * 2) and lineY2 > camera_get_view_height(camera_get_active()) + (obj_control.gridSpaceVertical * 2)) {
				if (chunkWord1) {
					var wordRectBuffer = 15;
					lineY1 += wordRectBuffer;
					chunkWord1 = 0;
				}
				if (chunkWord2) {
					var wordRectBuffer = 15;
					lineY2 -= (wordRectBuffer);
				}
			
				if (currentChainVisible) {
					draw_set_color(currentChainColor);
					draw_set_alpha(1);
					if (chunkWord2) {
						if (chainType == "rezChain") {
							draw_line_width(lineX1 + linePlusX, lineY1 + (currentWordStringHeight1 / 2), lineX2 + linePlusX, lineY2 - (currentWordStringHeight2 / 2), 2);
						}
						else if (chainType == "trackChain") {
							scr_drawCurvedLine(lineX1 + (currentWordStringWidth1 / 2), lineY1, lineX2 + (currentWordStringWidth2 / 2), lineY2, currentChainColor);
						}
					}
					else {
						if (chainType == "rezChain") {
							draw_line_width(lineX1 + linePlusX, lineY1 + (currentWordStringHeight1 / 2), lineX2 + linePlusX, lineY2 + (currentWordStringHeight2 / 2), 2);
						}
						else if (chainType == "trackChain") {
							scr_drawCurvedLine(lineX1 + (currentWordStringWidth1 / 2), lineY1, lineX2 + (currentWordStringWidth2 / 2), lineY2, currentChainColor);
						}
					}
				}
				// I need to modify this with the Chunk's wordRectBuffer
				chunkWord2 = 0;
			}
		}
	
	
		if (obj_chain.currentFocusedChainID == currentChainID) {	
			if (mouseLineWordID >= 0 && (mouseLineWordID - 1) < ds_grid_height(obj_control.wordGrid)) {
				
				var mouseLineWordDisplayRow = ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colDisplayRow, mouseLineWordID - 1);
				var mouseLineWordStringWidth = string_width(string(ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colDisplayString, mouseLineWordID - 1)));
				var mouseLineWordStringHeight = string_height(string(ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colDisplayString, mouseLineWordID - 1)));
				var wordPixelX = ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colPixelX, mouseLineWordID - 1);
				var wordPixelY = ds_grid_get(obj_control.currentActiveLineGrid, obj_control.lineGrid_colPixelY, mouseLineWordDisplayRow);
					
				if(wordPixelX != undefined and wordPixelY != undefined) {
					mouseLineX = wordPixelX + (mouseLineWordStringWidth / 2);
					mouseLineY = wordPixelY + (mouseLineWordStringHeight / 2);
				}
			}
		}
	}
	
	draw_set_alpha(1);


	// draw pickwhip line to mouse from chain
	var drawPickwhip = (!is_undefined(mouseLineX) && !is_undefined(mouseLineY) && !instance_exists(obj_dialogueBox) && !instance_exists(obj_dropDown)
						&& obj_toolPane.currentMode != obj_toolPane.modeRead && !obj_chain.focusedChainWrongTool);
	
	if (drawPickwhip) {
		if (ds_map_exists(global.nodeMap, obj_chain.currentFocusedChainID)) {
			var chainSubMap = global.nodeMap[? obj_chain.currentFocusedChainID];
			if (scr_isNumericAndExists(chainSubMap, ds_type_map)) {
				var chainType = chainSubMap[? "type"];
				currentChainColor = chainSubMap[? "chainColor"];
				currentChainVisible = chainSubMap[? "visible"];
				draw_set_color(currentChainColor);
			
				if (currentChainVisible) {
					if (not mouseLineHide) {
						if (chainType == "rezChain") {
							draw_line_width(mouseLineX, mouseLineY, mouse_x, mouse_y, 2);
						}
						else if (chainType == "trackChain") {
							scr_drawCurvedLine(mouseLineX, mouseLineY, mouse_x, mouse_y, currentChainColor);
						}
						if (obj_chain.showChainArrows) {
							var arrowAngle = point_direction(mouseLineX, mouseLineY, mouse_x, mouse_y);
							draw_sprite_ext(spr_linkArrow, 1, mouse_x, mouse_y, arrowSize, arrowSize, arrowAngle, currentChainColor, 1);
						}
					}
				}
			}
		}
	}


}
