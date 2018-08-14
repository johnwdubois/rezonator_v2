/*
	scr_drawRezChain();
	
	Last Updated: 2018-07-12
	
	Called from: obj_chain
	
	Purpose: draw rezChains and move words on screen according to the rezChains
	
	Mechanism: loop through each row in rezChainGrid, get the wordIDList from each chain, and draw lines
				from word information
*/

var lineX1 = undefined;
var lineY1 = undefined;
var lineX2 = undefined;
var lineY2 = undefined;
var mouseLineX = undefined;
var mouseLineY = undefined;

var furthestWordID = -1;
var furthestDisplayCol = -1;

for (var i = 0; i < ds_grid_height(rezChainGrid); i++)
{
	var currentWordIDList = ds_grid_get(rezChainGrid, chainGrid_colWordIDList, i);
	var currentChainColor = ds_grid_get(rezChainGrid, chainGrid_colColor, i);
	
	for (var j = 0; j < ds_list_size(currentWordIDList) - 1; j++)
	{
		var currentWordID1 = ds_list_find_value(currentWordIDList, j);
		var currentUnitID1 = ds_grid_get(obj_control.wordGrid, obj_control.wordGrid_colUnitID, currentWordID1 - 1);
		var currentLineGridIndex1 = ds_grid_value_y(obj_control.currentActiveLineGrid, obj_control.lineGrid_colUnitID, 0, obj_control.lineGrid_colUnitID, ds_grid_height(obj_control.currentActiveLineGrid), currentUnitID1);
		
		var currentWordStringWidth1 = string_width(ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colDisplayString, currentWordID1 - 1));
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
			draw_line_width(lineX1 + (currentWordStringWidth1 / 2), lineY1 + (currentWordStringHeight1 / 2), lineX2 + (currentWordStringWidth2 / 2), lineY2 + (currentWordStringHeight2 / 2), 2);
		}
	}
	
	
	if (ds_grid_get(rezChainGrid, chainGrid_colChainState, i) == chainStateFocus)
	{
		if (ds_list_size(currentWordIDList) > 1)
		{
			mouseLineX = lineX2;
			mouseLineY = lineY2;
		}
		else if (ds_list_size(currentWordIDList) > 0)
		{
			var currentWordID = ds_list_find_value(currentWordIDList, 0);
			var currentUnitID = ds_grid_get(obj_control.wordGrid, obj_control.wordGrid_colUnitID, currentWordID - 1);
			var currentLineGridIndex = ds_grid_value_y(obj_control.currentActiveLineGrid, obj_control.lineGrid_colUnitID, 0, obj_control.lineGrid_colUnitID, ds_grid_height(obj_control.currentActiveLineGrid), currentUnitID);
			
			var currentWordStringWidth = string_width(ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colDisplayString, currentWordID - 1));
			var currentWordStringHeight = string_height(ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colDisplayString, currentWordID - 1));
		
			mouseLineX = ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colPixelX, currentWordID - 1) + (currentWordStringWidth / 2);
			mouseLineY = ds_grid_get(obj_control.currentActiveLineGrid, obj_control.lineGrid_colPixelY, currentLineGridIndex) + (currentWordStringHeight / 2);
		}
	}
	
	if (ds_list_size(currentWordIDList) > 0)
	{
		furthestWordID = ds_list_find_value(currentWordIDList, 0);
		
		for (var displayColLoop = 0; displayColLoop < ds_list_size(currentWordIDList); displayColLoop++)
		{
			var currenWordID = ds_list_find_value(currentWordIDList, displayColLoop);
			var currentDisplayCol = ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colDisplayCol, currenWordID - 1);
			furthestDisplayCol = ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colDisplayCol, furthestWordID - 1);
		
			if (currentDisplayCol > furthestDisplayCol)
			{
				furthestWordID = currenWordID;
			}
		}
		
		furthestDisplayCol = ds_grid_get(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colDisplayCol, furthestWordID - 1);
		
		for (var setDisplayColLoop = 0; setDisplayColLoop < ds_list_size(currentWordIDList); setDisplayColLoop++)
		{
			var currenWordID = ds_list_find_value(currentWordIDList, setDisplayColLoop);
			
			ds_grid_set(obj_control.dynamicWordGrid, obj_control.dynamicWordGrid_colDisplayCol, currenWordID - 1, furthestDisplayCol);
		}
	}
}

if (not (mouseLineX == undefined or mouseLineY == undefined))
{
	if (ds_grid_value_exists(obj_chain.rezChainGrid, obj_chain.chainGrid_colChainState, 0, obj_chain.chainGrid_colChainState, ds_grid_height(obj_chain.rezChainGrid), obj_chain.chainStateFocus))
	{
		var rowInChainGrid = ds_grid_value_y(obj_chain.rezChainGrid, obj_chain.chainGrid_colChainState, 0, obj_chain.chainGrid_colChainState, ds_grid_height(obj_chain.rezChainGrid), obj_chain.chainStateFocus);
		currentChainColor = ds_grid_get(obj_chain.rezChainGrid, obj_chain.chainGrid_colColor, rowInChainGrid);
		draw_set_color(currentChainColor);
		draw_line_width(mouseLineX, mouseLineY, mouse_x, mouse_y, 2);
	}
}

scr_unfocusOtherChains(obj_toolPane.toolRezBrush);