/*
	scr_drawTrackChain();
	
	Last Updated: 2018-07-12
	
	Called from: obj_chain
	
	Purpose: draw trackChains with information from trackChainGrid
	
	Mechanism: loop through each row in trackChainGrid, get the wordIDList from each chain, and call scr_drawCurvedLine
				with x and y values for words in wordIDList
*/

draw_set_font(fnt_main);

var lineX1 = undefined;
var lineY1 = undefined;
var lineX2 = undefined;
var lineY2 = undefined;
var mouseLineX = undefined;
var mouseLineY = undefined;

var furthestWordID = -1;
var furthestDisplayCol = -1;

for (var i = 0; i < ds_grid_height(trackChainGrid); i++)
{
	var currentWordIDList = ds_grid_get(trackChainGrid, chainGrid_colWordIDList, i);
	var currentChainColor = ds_grid_get(trackChainGrid, chainGrid_colColor, i);
	
	for (var j = 0; j < ds_list_size(currentWordIDList) - 1; j++)
	{
		var currentWordID1 = ds_list_find_value(currentWordIDList, j);
		var currentUnitID1 = ds_grid_get(obj_control.wordGrid, obj_control.wordGrid_colUnitID, currentWordID1 - 1);
		var currentLineGridIndex1 = ds_grid_value_y(obj_control.currentActiveLineGrid, obj_control.lineGrid_colUnitID, 0, obj_control.lineGrid_colUnitID, ds_grid_height(obj_control.currentActiveLineGrid), currentUnitID1);
		
		var currentWordStringWidth1 = string_width(ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colDisplayString, currentWordID1 -1));
		var currentWordStringHeight1 = string_height(ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colDisplayString, currentWordID1 - 1));
		
		lineX1 = ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colPixelX, currentWordID1 - 1);
		lineY1 = ds_grid_get(obj_control.currentActiveLineGrid, obj_control.lineGrid_colPixelY, currentLineGridIndex1);
		
		var currentWordID2 = ds_list_find_value(currentWordIDList, j + 1);
		var currentUnitID2 = ds_grid_get(obj_control.wordGrid, obj_control.wordGrid_colUnitID, currentWordID2 - 1);
		var currentLineGridIndex2 = ds_grid_value_y(obj_control.currentActiveLineGrid, obj_control.lineGrid_colUnitID, 0, obj_control.lineGrid_colUnitID, ds_grid_height(obj_control.currentActiveLineGrid), currentUnitID2);
		
		var currentWordStringWidth2 = string_width(ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colDisplayString, currentWordID2 - 1));
		var currentWordStringHeight2 = string_height(ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colDisplayString, currentWordID2 - 1));
		
		lineX2 = ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colPixelX, currentWordID2 - 1);
		lineY2 = ds_grid_get(obj_control.currentActiveLineGrid, obj_control.lineGrid_colPixelY, currentLineGridIndex2);
		
		if not (lineX1 == undefined or lineY1 == undefined or lineX2 == undefined or lineY2 == undefined)
		{
			draw_set_color(currentChainColor);
			draw_set_alpha(1);
			
			if (lineY1 == lineY2)
			{
				draw_line_width(lineX1, lineY1, lineX2, lineY2, 2);
			}
			else
			{
				scr_drawCurvedLine(lineX1 + (currentWordStringWidth1 / 2), lineY1, lineX2 + (currentWordStringWidth2 / 2), lineY2, currentChainColor);
			}
		}
	}
	
	
	if (ds_grid_get(trackChainGrid, chainGrid_colChainState, i) == chainStateFocus)
	{	
		if (mouseLineWordID >= 0 && mouseLineWordID < ds_grid_height(obj_control.wordGrid))
		{
			var mouseLineWordUnitID = ds_grid_get(obj_control.wordGrid, obj_control.wordGrid_colUnitID, mouseLineWordID - 1);
			var mouseLineWordGridIndex = ds_grid_value_y(obj_control.currentActiveLineGrid, obj_control.lineGrid_colUnitID, 0, obj_control.lineGrid_colUnitID, ds_grid_height(obj_control.currentActiveLineGrid), mouseLineWordUnitID);
			
			var mouseLineWordStringWidth = string_width(ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colDisplayString, mouseLineWordID - 1));
			var mouseLineWordStringHeight = string_height(ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colDisplayString, mouseLineWordID - 1));
			
			mouseLineX = ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colPixelX, mouseLineWordID - 1) + (mouseLineWordStringWidth / 2);
			mouseLineY = ds_grid_get(obj_control.currentActiveLineGrid, obj_control.lineGrid_colPixelY, mouseLineWordGridIndex) + (mouseLineWordStringHeight / 2);
		}
	}
	
	
	
	var isAligned = ds_grid_get(trackChainGrid, chainGrid_colAlign, i);
	if (isAligned)
	{
		scr_alignChain(currentWordIDList);
	}
	
}

if (not (mouseLineX == undefined or mouseLineY == undefined))
{
	if (ds_grid_value_exists(obj_chain.trackChainGrid, obj_chain.chainGrid_colChainState, 0, obj_chain.chainGrid_colChainState, ds_grid_height(obj_chain.trackChainGrid), obj_chain.chainStateFocus))
	{
		var rowInChainGrid = ds_grid_value_y(obj_chain.trackChainGrid, obj_chain.chainGrid_colChainState, 0, obj_chain.chainGrid_colChainState, ds_grid_height(obj_chain.trackChainGrid), obj_chain.chainStateFocus);
		currentChainColor = ds_grid_get(obj_chain.trackChainGrid, obj_chain.chainGrid_colColor, rowInChainGrid);
		draw_set_color(currentChainColor);
		
		if (not mouseLineHide)
		{
			draw_line_width(mouseLineX, mouseLineY, mouse_x, mouse_y, 2);
		}
	}
}



scr_unfocusOtherChains(obj_toolPane.toolTrackBrush);