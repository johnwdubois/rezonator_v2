/*
	scr_drawLine();
	
	Last Updated: 2018-07-12
	
	Called from: obj_control
	
	Purpose: draws words and lines from the lineGrid that are within the drawRange
	
	Mechanism: loop through the lineGrid (only loop through necessary lines) and get wordIDList from each line, then draw out those words
	
	Author: Terry DuBois
*/

if (gridView || ds_grid_height(dynamicWordGrid) < 1)
{
	exit;
}

ds_grid_set_region(wordDrawGrid, wordDrawGrid_colVisible, 0, wordDrawGrid_colVisible, ds_grid_height(wordDrawGrid), false);

// set draw variables for column text
draw_set_font(global.fontMain);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_color(global.colorThemeText);
draw_set_alpha(1);

// set range of lines that we want to draw
drawRangeStart = currentCenterDisplayRow - drawRange;
drawRangeEnd = currentCenterDisplayRow + drawRange;

drawRangeStart = max(drawRangeStart, 0);
drawRangeEnd = min(drawRangeEnd, ds_grid_height(currentActiveLineGrid));

// draw out of bounds rectangles on top & bottom of discourse
if (drawRangeStart == 0 and ds_grid_height(currentActiveLineGrid) > 0) {
	var firstLinePixelY = ds_grid_get(currentActiveLineGrid, obj_control.lineGrid_colPixelY, 0);
	draw_set_color(global.colorThemeOutOfBounds);
	draw_rectangle(0, 0, room_width, firstLinePixelY - (obj_control.gridSpaceVertical / 2), false);
}
if (drawRangeEnd == ds_grid_height(currentActiveLineGrid) and ds_grid_height(currentActiveLineGrid) > 0) {
	var lastLinePixelY = ds_grid_get(currentActiveLineGrid, obj_control.lineGrid_colPixelY, ds_grid_height(currentActiveLineGrid) - 1);
	draw_set_color(global.colorThemeOutOfBounds);
	draw_rectangle(0, lastLinePixelY + (obj_control.gridSpaceVertical / 2), room_width, room_height, false);
}

// draw out of bounds rectangle on left
if (obj_control.wordLeftMargin > obj_control.speakerLabelMargin + obj_control.speakerLabelMarginBuffer) {
	draw_set_color(global.colorThemeOutOfBounds);
	var leftOutOfBoundsRectX1 = obj_control.speakerLabelMargin - obj_control.speakerLabelMarginBuffer;
	var leftOutOfBoundsRectY1 = 0;
	var leftOutOfBoundsRectX2 = obj_control.wordLeftMargin - obj_control.speakerLabelMarginBuffer;
	var leftOutOfBoundsRectY2 = room_height;

	if (currentActiveLineGrid == searchGrid) {
		leftOutOfBoundsRectX2 = leftScreenBound;
	}
	
	draw_rectangle(leftOutOfBoundsRectX1, leftOutOfBoundsRectY1, leftOutOfBoundsRectX2, leftOutOfBoundsRectY2, false);
}

draw_set_color(global.colorThemeText);

obj_control.leftScreenBound = room_width;

// for every row in lineGrid from drawRangeStart to drawRangeEnd, draw the words in that line
for (var drawLineLoop = drawRangeStart; drawLineLoop < drawRangeEnd; drawLineLoop++) {
	if (drawLineLoop < 0 or drawLineLoop >= ds_grid_height(currentActiveLineGrid)) {
		continue;
	}
	
	var currentWordIDList = ds_grid_get(currentActiveLineGrid, lineGrid_colWordIDList, drawLineLoop);
	
	// get & set the correct pixel-Y value for each line
	var currentLineDestY = (ds_grid_get(currentActiveLineGrid, lineGrid_colDisplayRow, drawLineLoop) - currentCenterDisplayRow) * gridSpaceVertical + (room_height / 2);
	var currentLineY = ds_grid_get(currentActiveLineGrid, lineGrid_colPixelY, drawLineLoop);
	
	if (currentLineY < currentLineDestY) {
		currentLineY += abs(currentLineY - currentLineDestY) / 4;
	}
	else if (currentLineY > currentLineDestY) {
		currentLineY -= abs(currentLineY - currentLineDestY) / 4;
	}
	
	ds_grid_set(currentActiveLineGrid, lineGrid_colPixelY, drawLineLoop, currentLineY);
	
	// set speaker label stuff up
	var speakerRectX1 = 0;
	var speakerRectY1 = currentLineY - (gridSpaceVertical / 2);
	var speakerRectX2 = speakerLabelMargin - speakerLabelMarginBuffer;
	var speakerRectY2 = speakerRectY1 + gridSpaceVertical;
	
	var unitID = ds_grid_get(currentActiveLineGrid, lineGrid_colUnitID, drawLineLoop);
	var currentDiscoID = ds_grid_get(currentActiveLineGrid, lineGrid_colDiscoID, drawLineLoop);
	var currentLineNumberLabel = ds_grid_get(currentActiveLineGrid, lineGrid_colLineNumberLabel, drawLineLoop);
	
	var currentLineInStack = false;
	var currentLineInStackList = -1;
	
	if (ds_grid_height(obj_chain.unitInStackGrid) == ds_grid_height(obj_control.unitGrid)) {
		currentLineInStackList = ds_grid_get(obj_chain.unitInStackGrid, obj_chain.unitInStackGrid_colStackList, unitID - 1);
	}
	
	// draw stack rectangle if this line is in a stack
	if (not (currentLineInStackList == -1) and ds_exists(currentLineInStackList, ds_type_list)) {
		for (var i = 0; i < ds_list_size(currentLineInStackList); i++) {
			var currentStackChainID = ds_list_find_value(currentLineInStackList, i);
			var rowInStackChainGrid = ds_grid_value_y(obj_chain.stackChainGrid, obj_chain.chainGrid_colChainID, 0, obj_chain.chainGrid_colChainID, ds_grid_height(obj_chain.stackChainGrid), currentStackChainID);
			var stackColor = ds_grid_get(obj_chain.stackChainGrid, obj_chain.chainGrid_colColor, rowInStackChainGrid);
			
			if not (typeof(stackColor) == "number") {
				continue;
			}
		
			draw_set_color(stackColor);
			draw_set_alpha(0.2);
			
			var stackRectWidth = (room_width - speakerRectX2) / ds_list_size(currentLineInStackList);
			var stackRectX1 = speakerRectX2 + (i * stackRectWidth);
			var stackRectY1 = speakerRectY1;
			var stackRectX2 = stackRectX1 + stackRectWidth;
			var stackRectY2 = speakerRectY2;
			
			draw_rectangle(stackRectX1, stackRectY1, stackRectX2, stackRectY2, false);
		}
	}
	
	
	var previousWordDisplayCol = -1;
	
	// draw hits if in search view, otherwise draw words for this line
	if (searchGridActive) {
		scr_drawLineHitIDListLoop(currentWordIDList, previousWordDisplayCol, currentLineY, drawLineLoop);
	}
	else {
		scr_drawLineWordIDListLoop(currentWordIDList, previousWordDisplayCol, currentLineY, drawLineLoop, unitID);
	}
	
	

	
	var participantColor = ds_grid_get(unitGrid, unitGrid_colParticipantColor, unitID - 1);
	var participantName = ds_grid_get(unitGrid, unitGrid_colParticipantName, unitID - 1);
	draw_set_alpha(1);
	draw_set_halign(fa_left);
	draw_set_color(participantColor);
	var speakerLabelTextBuffer = 3;
	
	
	// draw speaker label parts
	var speakerLabelPlusX = 0;
	for (var i = 0; i < 3; i++) {
		if (i == 0 and ds_grid_height(global.fileLineRipGrid) < 2) {
			continue;
		}
		
		var speakerLabelCurrentColX1 = speakerLabelPlusX;
		var speakerLabelCurrentColY1 = speakerRectY1;
		var speakerLabelCurrentColX2 = speakerLabelCurrentColX1 + speakerLabelColWidth[i];
		var speakerLabelCurrentColY2 = speakerRectY2;
		
		draw_set_color(participantColor);
		draw_rectangle(speakerLabelCurrentColX1, speakerLabelCurrentColY1, speakerLabelCurrentColX2, speakerLabelCurrentColY2, false);
		draw_set_color(global.colorThemeBG);
		draw_rectangle(speakerLabelCurrentColX1, speakerLabelCurrentColY1, speakerLabelCurrentColX2, speakerLabelCurrentColY2, true);
		
		var speakerLabelCurrentColStr = "";
		if (i == 0 and currentDiscoID != undefined) {
			speakerLabelCurrentColStr = string(currentDiscoID);
		}
		else if (i == 1 and currentLineNumberLabel != undefined) {
			speakerLabelCurrentColStr = string(currentLineNumberLabel);
		}
		else if (i == 2 and participantName != undefined) {
			speakerLabelCurrentColStr = string(participantName);
		}
		
		draw_set_color(global.colorThemeText);
		draw_text(speakerLabelCurrentColX1 + speakerLabelTextBuffer, mean(speakerLabelCurrentColY1, speakerLabelCurrentColY2), speakerLabelCurrentColStr);
		
		speakerLabelPlusX += speakerLabelColWidth[i];
	}
	
}

// show draw range of lines if development variables are on
if (showDevVars) {
	draw_set_alpha(1);
	draw_set_font(fnt_debug);
	draw_set_halign(fa_right);
	draw_text(room_width - 100, 250, "drawRange: " + string(drawRangeStart) + " ... " + string(drawRangeEnd));
}

// set Y pixel value for lines outside of draw range, to get them ready to be shown
for (var i = 1; i < drawRange; i++) {
	if (drawRangeStart - i >= 0 and drawRangeStart - i < ds_grid_height(lineGrid)) {
		ds_grid_set(currentActiveLineGrid, lineGrid_colPixelY, drawRangeStart - i, -gridSpaceVertical);
	}
	if (drawRangeEnd + i >= 0 and drawRangeEnd + i < ds_grid_height(lineGrid)) {
		ds_grid_set(currentActiveLineGrid, lineGrid_colPixelY, drawRangeEnd + i, room_height + gridSpaceVertical);
	}
}