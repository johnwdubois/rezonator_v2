/*
	scr_panelPane_drawchainContentsLoop();
	
	Last Updated: 2018-07-12
	
	Called from: obj_panelPane
	
	Purpose: whatever chain is focused on in the chainList panelPane, draw information on the individual contents of that chain
	
	Mechanism: loop through the IDList of the focused chain and gather information from corresponding grids
	
	Author: Terry DuBois, Georgio Klironomos
*/

// Set opacity, alignment, and font of contents list
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_font(global.fontChainContents);

var grid = obj_chain.rezChainGrid;

// Find current tab to draw correct contents
switch (functionChainList_currentTab) {
	case 0:
		grid = obj_chain.rezChainGrid;
		break;
	case 1:
		grid = obj_chain.trackChainGrid;
		break;
	case 2:
		grid = obj_chain.stackChainGrid;
		break;
	case 3:
		grid = obj_chain.cliqueDisplayGrid;
		break;
	default:
		grid = obj_chain.rezChainGrid;
		break;
}

// Set text margins
var textMarginTop = 32;
var textPlusY = 0;
var ableToBeMouseOver = true;

var alignTabWidth = 12;

// Create scroll bars
var scrollBarWidth = 16;
draw_set_color(c_white);
draw_rectangle(x + windowWidth - scrollBarWidth, y + (textMarginTop * 2), x + windowWidth, y + windowHeight, false);

var focusedChainExists = false;
var alignRectSize = 8;

// Check for focused chain, gather information from grids
if (ds_grid_value_exists(grid, obj_chain.chainGrid_colChainState, 0, obj_chain.chainGrid_colChainState, ds_grid_height(grid), obj_chain.chainStateFocus)) {
	// Collect beginning of chain info
	focusedChainExists = true;
	var rowInChainGrid = ds_grid_value_y(grid, obj_chain.chainGrid_colChainState, 0, obj_chain.chainGrid_colChainState, ds_grid_height(grid), obj_chain.chainStateFocus);
	var chainID = ds_grid_get(grid, obj_chain.chainGrid_colChainID, rowInChainGrid);
	var chainAligned = ds_grid_get(grid, obj_chain.chainGrid_colAlign, rowInChainGrid);
	
	// Get wordID list
	with (obj_panelPane) {
		functionChainContents_IDList = ds_grid_get(grid, obj_chain.chainGrid_colWordIDList, rowInChainGrid);
	}
	
	// Select top of the content list
	if (functionChainContents_hop > -1) {
		if (ds_list_find_index(functionChainContents_IDList, functionChainContents_hop) > -1) {
			currentTopViewRow = ds_list_find_index(functionChainContents_IDList, functionChainContents_hop);
		}
		
		functionChainContents_hop = -1;
	}
	
	// Set contraints for top view
	currentTopViewRow = max(0, currentTopViewRow);
	currentTopViewRow = min(ds_list_size(functionChainContents_IDList) - scrollRange, currentTopViewRow);
	
	// Gather specfic information on words
	for (var j = currentTopViewRow; j < currentTopViewRow + scrollRange; j++) {	
		
		//Safety check
		if (j < 0 or j >= ds_list_size(functionChainContents_IDList)) {
			continue;
		}
		
		//Get info on current word
		var currentWordID = ds_list_find_value(functionChainContents_IDList, j);
		var currentWordAligned = ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colAligned, currentWordID - 1);
		var currentWordInfoCol;
		currentWordInfoCol[0] = "";
		
		//Set size of rectangle around word
		var stringHeight = 14;
		var rectX1 = x + alignTabWidth;
		var rectY1 = y + textMarginTop + textPlusY - (stringHeight / 2);
		var rectX2 = x + windowWidth - scrollBarWidth;
		var rectY2 = rectY1 + stringHeight;
		
		// Find link info
		var rowInLinkGrid = scr_findInGridThreeParameters(obj_chain.linkGrid, obj_chain.linkGrid_colSource, currentWordID, obj_chain.linkGrid_colChainID, chainID, obj_chain.linkGrid_colDead, false);
		var focusedLink = ds_grid_get(obj_chain.linkGrid, obj_chain.linkGrid_colFocus, rowInLinkGrid);
		var sourceWordID = ds_grid_get(obj_chain.linkGrid, obj_chain.linkGrid_colSource, rowInLinkGrid);
		
		// Draw red rectangles if stretch word
		if (grid == obj_chain.rezChainGrid or grid == obj_chain.trackChainGrid) {
			if (ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colStretch, sourceWordID - 1)) {
				draw_set_alpha(0.25);
				draw_set_color(c_red);
				draw_rectangle(rectX1, rectY1, rectX2, rectY2, false);
			}
		}
			
		// Sets the link focused in the panelPane to the link focused in the main screen
		if (focusedLink) {
			
			// Fill in square
			draw_set_alpha(0.25);
			draw_set_color(c_black);
			draw_rectangle(rectX1, rectY1, rectX2, rectY2, false);
			
			// Focus in the main screen
			if (grid == obj_chain.rezChainGrid or grid == obj_chain.trackChainGrid) {
				ds_grid_set_region(obj_control.wordDrawGrid, obj_control.wordDrawGrid_colFillRect, 0, obj_control.wordDrawGrid_colFillRect, ds_grid_height(obj_control.wordDrawGrid), false);
				ds_grid_set(obj_control.wordDrawGrid, obj_control.wordDrawGrid_colFillRect, sourceWordID - 1, true);
				obj_chain.mouseLineWordID = sourceWordID;
			}
		}
		else if (point_in_rectangle(mouse_x, mouse_y, rectX1, rectY1, rectX2, rectY2) and ableToBeMouseOver) {
			ableToBeMouseOver = false;
			draw_set_alpha(0.25);
			draw_set_color(c_black);
			draw_rectangle(rectX1, rectY1, rectX2, rectY2, false);
			
			// Focus in the main screen
			if (mouse_check_button_pressed(mb_left))
			{	
				ds_grid_set_region(obj_chain.linkGrid, obj_chain.linkGrid_colFocus, 0, obj_chain.linkGrid_colFocus, ds_grid_height(obj_chain.linkGrid), false);
				ds_grid_set(obj_chain.linkGrid, obj_chain.linkGrid_colFocus, rowInLinkGrid, true);
				scr_refreshChainGrid();
				
				
			}
		}
		draw_set_alpha(1);
	
		// Check for double click
		if (point_in_rectangle(mouse_x, mouse_y, rectX1, rectY1, rectX2, rectY2) and mouse_check_button_pressed(mb_left)) {
			if (doubleClickTimer > -1) {	
				
				var rowInLineGrid = -1;
				
				// Set double clicked word to center display row, if possible
				if (functionChainList_currentTab == functionChainList_tabStackBrush
				or functionChainList_currentTab == functionChainList_tabClique) {
					var currentUnitID = currentWordID;
					rowInLineGrid = ds_grid_value_y(obj_control.lineGrid, obj_control.lineGrid_colUnitID, 0, obj_control.lineGrid_colUnitID, ds_grid_height(obj_control.lineGrid), currentUnitID);
				}
				else {
					var currentUnitID = ds_grid_get(obj_control.wordGrid, obj_control.wordGrid_colUnitID, currentWordID - 1);
					rowInLineGrid = ds_grid_value_y(obj_control.lineGrid, obj_control.lineGrid_colUnitID, 0, obj_control.lineGrid_colUnitID, ds_grid_height(obj_control.lineGrid), currentUnitID);
				}
					
				if (rowInLineGrid >= 0 and rowInLineGrid < ds_grid_height(obj_control.lineGrid)) {
					var displayRow = ds_grid_get(obj_control.lineGrid, obj_control.lineGrid_colDisplayRow, rowInLineGrid);
					obj_control.currentCenterDisplayRow = ds_grid_get(obj_control.lineGrid, obj_control.lineGrid_colDisplayRow, displayRow);
				}
			}
			else {
				doubleClickTimer = 0;
			}
		
		}
		
		// Set collected info into correct places
		for (var getInfoLoop = 0; getInfoLoop < 3; getInfoLoop++) {
			currentWordInfoCol[getInfoLoop] = "";
			
			switch (functionChainContents_infoCol[getInfoLoop]) {
				case 0:
					if (functionChainList_currentTab == functionChainList_tabStackBrush
					or functionChainList_currentTab == functionChainList_tabClique) {
						var unitID = currentWordID;
						currentWordInfoCol[getInfoLoop] = string(ds_grid_get(obj_control.unitGrid, obj_control.unitGrid_colUtteranceID, unitID - 1));
					}
					else {
						var unitID = ds_grid_get(obj_control.wordGrid, obj_control.wordGrid_colUnitID, currentWordID - 1);
						currentWordInfoCol[getInfoLoop] = string(ds_grid_get(obj_control.unitGrid, obj_control.unitGrid_colUtteranceID, unitID - 1));
					}
					break;
				case 1:
					if (functionChainList_currentTab == functionChainList_tabStackBrush
					or functionChainList_currentTab == functionChainList_tabClique) {
						currentWordInfoCol[getInfoLoop] = ds_grid_get(obj_control.unitGrid, obj_control.unitGrid_colParticipantName, currentWordID);
					}
					else {
						currentWordInfoCol[getInfoLoop] = string(ds_grid_get(obj_control.wordGrid, obj_control.wordGrid_colWordSeq, currentWordID - 1));
					}
					break;
				case 2:
					if (functionChainList_currentTab == functionChainList_tabStackBrush
					or functionChainList_currentTab == functionChainList_tabClique) {
						currentWordInfoCol[getInfoLoop] = "";
						var currentWordIDList = ds_grid_get(obj_control.unitGrid, obj_control.unitGrid_colWordIDList, currentWordID - 1);
						for (var i = 0; i < ds_list_size(currentWordIDList); i++) {
							var currentWordID = ds_list_find_value(currentWordIDList, i);
							var currentWordString = ds_grid_get(obj_control.wordGrid, obj_control.wordGrid_colWordToken, currentWordID - 1);
							currentWordInfoCol[getInfoLoop] += currentWordString + " ";
						}
						
						if (string_length(currentWordInfoCol[getInfoLoop]) > 16) {
							currentWordInfoCol[getInfoLoop] = string_delete(currentWordInfoCol[getInfoLoop], 12, string_length(currentWordInfoCol[getInfoLoop]) - 12);
							currentWordInfoCol[getInfoLoop] += "...";
						}
					}
					else
					{
						currentWordInfoCol[getInfoLoop] = string(ds_grid_get(obj_control.wordGrid, obj_control.wordGrid_colWordTranscript, currentWordID - 1));
					}
					break;
			}
			
			var textX = x + (getInfoLoop * (windowWidth / 3)) + alignTabWidth;
			var textY = y + textMarginTop + textPlusY;
			
			draw_set_color(c_black);
			draw_set_alpha(1);
			draw_text(textX, textY, currentWordInfoCol[getInfoLoop]);
		}
		
		if (point_in_rectangle(mouse_x, mouse_y, x + 2, y + textMarginTop + textPlusY - (alignRectSize / 2), x + 2 + alignRectSize, y + textMarginTop + textPlusY + (alignRectSize / 2)) and mouse_check_button_pressed(mb_left)
		and chainAligned and not ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colStretch, currentWordID - 1)) {
			currentWordAligned = !currentWordAligned;
			ds_grid_set(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colAligned, currentWordID - 1, currentWordAligned);
			
			if (ds_grid_height(obj_chain.vizLinkGrid) > 0) {
				var rowInVizLinkGrid = scr_findInGridTwoParameters(obj_chain.vizLinkGrid, obj_chain.vizLinkGrid_colSource, currentWordID, obj_chain.vizLinkGrid_colAlign, !currentWordAligned);
				while (rowInVizLinkGrid >= 0 and rowInVizLinkGrid < ds_grid_height(obj_chain.vizLinkGrid)) {
					ds_grid_set(obj_chain.vizLinkGrid, obj_chain.vizLinkGrid_colAlign, rowInVizLinkGrid, currentWordAligned);
					rowInVizLinkGrid = scr_findInGridTwoParameters(obj_chain.vizLinkGrid, obj_chain.vizLinkGrid_colSource, currentWordID, obj_chain.vizLinkGrid_colAlign, !currentWordAligned);
				}
			}
		}
		
		if (chainAligned)
		{
			draw_set_alpha(1);
		}
		else
		{
			draw_set_alpha(0.5);
		}
		draw_set_color(c_purple);
		draw_rectangle(x + 2, y + textMarginTop + textPlusY - (alignRectSize / 2), x + 2 + alignRectSize, y + textMarginTop + textPlusY + (alignRectSize / 2), !currentWordAligned)
		
		textPlusY += string_height(currentWordInfoCol[0]) * 0.75;
	}
}

draw_set_alpha(1);


draw_set_font(fnt_panelTab);
var tabHeight = 16;

//draw_line(x + alignTabWidth, y, x + alignTabWidth, y + tabHeight);

for (var i = 0; i < 3; i++)
{
	var colRectX1 = x + (i * (windowWidth / 3)) + alignTabWidth;
	var colRectY1 = y;
	var colRectX2 = colRectX1 + (windowWidth / 3);
	var colRectY2 = colRectY1 + windowHeight;
	
	var colName = "";
	
	switch (functionChainContents_infoCol[i])
	{
		// 0 --> wordID
		// 1 --> unitID
		// 2 --> wordTranscript
		case 0:
			if (functionChainList_currentTab == functionChainList_tabStackBrush
			or functionChainList_currentTab == functionChainList_tabClique)
			{
				colName = "uID";
			}
			else
			{
				colName = "uID";
			}
			break;
		case 1:
			if (functionChainList_currentTab == functionChainList_tabStackBrush
			or functionChainList_currentTab == functionChainList_tabClique)
			{
				colName = "speaker";
			}
			else
			{
				colName = "place";
			}
			break;
		case 2:
			if (functionChainList_currentTab == functionChainList_tabStackBrush
			or functionChainList_currentTab == functionChainList_tabClique)
			{
				colName = "utterance";
			}
			else
			{
				colName = "text";
			}
			break;
		default:
			colName = "";
			break;
	}
	
	draw_set_color(c_black);
	draw_rectangle(colRectX1, colRectY1, colRectX2, colRectY2, true);
	draw_text(colRectX1, y + (tabHeight / 2), colName);
}

draw_line(x, y + tabHeight, x + windowWidth, y + tabHeight);

draw_set_font(global.fontChainContents);
var str = "a";
scrollRange = floor((windowHeight - tabHeight) / string_height(str)) + 2;


var windowHeightMinus = windowHeight + tabHeight;
var scrollBarHeight = ((scrollRange * (windowHeight - tabHeight)) / (ds_list_size(functionChainContents_IDList)));
var scrollBarRectX1 = x + windowWidth - scrollBarWidth;
var scrollBarRectY1 = y + tabHeight + ((currentTopViewRow * windowHeight) / (ds_list_size(functionChainContents_IDList)));
var scrollBarRectX2 = scrollBarRectX1 + scrollBarWidth;
var scrollBarRectY2 = scrollBarRectY1 + scrollBarHeight;

if (ds_list_size(functionChainContents_IDList) < scrollRange) {
	scrollBarRectY1 = y + tabHeight;
	scrollBarRectY2 = y + windowHeight;
}
else {
	scrollBarRectY1 = max(scrollBarRectY1, y + tabHeight);
	scrollBarRectY2 = min(scrollBarRectY2, y + windowHeight);
}


if (ds_list_size(functionChainContents_IDList) < 1 or not focusedChainExists)
{
	scrollBarRectY1 = y + tabHeight;
	scrollBarRectY2 = y + windowHeight;
	scrollBarHolding = false;
}

draw_set_color(c_ltgray);
draw_rectangle(scrollBarRectX1, scrollBarRectY1, scrollBarRectX2, scrollBarRectY2, false);

if (point_in_rectangle(mouse_x, mouse_y, scrollBarRectX1, scrollBarRectY1, scrollBarRectX2, scrollBarRectY2))
{
	if (mouse_check_button_pressed(mb_left))
	{
		scrollBarHolding = true;
		scrollBarHoldingPlusY = mouse_y - scrollBarRectY1;
	}
}

scrollBarHoldingPlusY = 0;

if (mouse_check_button_released(mb_left))
{
	scrollBarHolding = false;
}

if (scrollBarHolding)
{
	currentTopViewRow = floor(((mouse_y - y - scrollBarHoldingPlusY) * ds_list_size(functionChainContents_IDList)) / (windowHeight));
}

// Allows use of arrow keys, pgUp/pgDwn, and ctrl+key in chain list if clicked in chainContents
with(obj_panelPane){
	if (currentFunction == functionChainContents and clickedIn) {
	
		// Scroll up with mouse/key
		if ((mouse_wheel_up() || keyboard_check(vk_up)) and (obj_panelPane.holdUp < 2 || obj_panelPane.holdUp > 30)) {
			if (currentTopViewRow > 0) {
				currentTopViewRow--;
			}
		}
	
		// Scroll down with mouse/key
		if ((mouse_wheel_down() || keyboard_check(vk_down)) and (obj_panelPane.holdDown < 2 || obj_panelPane.holdDown > 30)){
			if (currentTopViewRow + scrollRange < ds_list_size(functionChainContents_IDList)){
				currentTopViewRow++;
			}
		}
	
		// Scroll up with pgUp/key
		if (keyboard_check_pressed(vk_pageup)){
			if (currentTopViewRow > 0){
				currentTopViewRow -= scrollRange;
			}
		}
	
		// Scroll up with ctrl+key
		if (keyboard_check(vk_control) and keyboard_check_pressed(vk_up)) {
			if (currentTopViewRow > 0) {
				currentTopViewRow -= ds_list_size(functionChainContents_IDList);
			}
		}
	
		// Scroll down with pgDwn
		if (keyboard_check_pressed(vk_pagedown)){
			if (currentTopViewRow + scrollRange < ds_list_size(functionChainContents_IDList)){
				currentTopViewRow += scrollRange;
			}
		}
	
		// Scroll down with ctrl+key
		if (keyboard_check(vk_control) and keyboard_check_pressed(vk_down)) {
			if (currentTopViewRow + scrollRange < ds_list_size(functionChainContents_IDList)) {
				currentTopViewRow += ds_list_size(functionChainContents_IDList);
			}
		}
	}
}