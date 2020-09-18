function scr_cliqueGetCross(argument0) {
	var rowInCliqueGrid = argument0;

	var chainIDList = ds_grid_get(obj_chain.cliqueGrid, obj_chain.cliqueGrid_colChainIDList, rowInCliqueGrid);

	var vizLinkLookupGrid = ds_grid_create(3, 0);
	var vizLinkLookupGrid_colChainID = 0;
	var vizLinkLookupGrid_colStart = 1;
	var vizLinkLookupGrid_colEnd = 2;

	var vizLinkGrid = obj_chain.vizLinkGrid;
	var vizLinkGrid_colChainID = obj_chain.vizLinkGrid_colChainID;
	var vizLinkGrid_colSource = obj_chain.vizLinkGrid_colSource;
	var vizLinkGrid_colGoal = obj_chain.vizLinkGrid_colGoal;
	var vizLinkGrid_colCross = obj_chain.vizLinkGrid_colCross;
	var vizLinkGridHeight = ds_grid_height(vizLinkGrid);
	var lineGrid = obj_control.lineGrid;
	var lineGrid_colPixelY = obj_control.lineGrid_colPixelY
	var lineGridHeight = ds_grid_height(lineGrid);
	var wordGrid = obj_control.wordGrid;
	var wordGrid_colUnitID = obj_control.wordGrid_colUnitID;
	var dynamicWordGrid = obj_control.dynamicWordGrid;
	var dynamicWordGrid_colPixelX = obj_control.dynamicWordGrid_colPixelX;

	var chainIDListSize = ds_list_size(chainIDList);
	for (var i = 0; i < chainIDListSize; i++)
	{
		var currentChainID = ds_list_find_value(chainIDList, i);
		var rowInVizLinkGrid = ds_grid_value_y(vizLinkGrid, vizLinkGrid_colChainID, 0, vizLinkGrid_colChainID, vizLinkGridHeight, currentChainID);
	
		if (rowInVizLinkGrid < 0 or rowInVizLinkGrid >= vizLinkGridHeight)
		{
			continue;
		}
	
		//show_message("currentChainID: " + string(currentChainID));
	
		var k = 0;
		while (ds_grid_get(vizLinkGrid, vizLinkGrid_colChainID, rowInVizLinkGrid + k) == currentChainID)
		{
			k++;
			if (rowInVizLinkGrid + k >= vizLinkGridHeight)
			{
				break;
			}
		}
	
		ds_grid_resize(vizLinkLookupGrid, ds_grid_width(vizLinkLookupGrid), ds_grid_height(vizLinkLookupGrid) + 1);
	
		ds_grid_set(vizLinkLookupGrid, vizLinkLookupGrid_colChainID, ds_grid_height(vizLinkLookupGrid) - 1, currentChainID);
		ds_grid_set(vizLinkLookupGrid, vizLinkLookupGrid_colStart, ds_grid_height(vizLinkLookupGrid) - 1, rowInVizLinkGrid);
		ds_grid_set(vizLinkLookupGrid, vizLinkLookupGrid_colEnd, ds_grid_height(vizLinkLookupGrid) - 1, rowInVizLinkGrid + k - 1);
	}



	for (var i = 0; i < chainIDListSize; i++)
	{
	
		var currentChainID = ds_list_find_value(chainIDList, i);
		//var rowInviLinkGrid = ds_grid_value_y(obj_chain.vizLinkGrid, obj_chain.vizLinkGrid_colChainID, 0, obj_chain.vizLinkGrid_colChainID, ds_grid_height(obj_chain.vizLinkGrid), currentChainID);
	
		if (rowInVizLinkGrid < 0 or rowInVizLinkGrid >= vizLinkGridHeight)
		{
			continue;
		}
	
		var plusRow = 0;
		while (ds_grid_get(vizLinkGrid, vizLinkGrid_colChainID, rowInVizLinkGrid + plusRow) == currentChainID)
		{
			var currentSource1 = ds_grid_get(vizLinkGrid, vizLinkGrid_colSource, rowInVizLinkGrid + plusRow);
			var currentGoal1 = ds_grid_get(vizLinkGrid, vizLinkGrid_colGoal, rowInVizLinkGrid + plusRow);
		
			if (currentSource1 == -1 or currentGoal1 == -1)
			{
				plusRow++;
				if (rowInVizLinkGrid + plusRow >= vizLinkGridHeight)
				{
					break;
				}
			
				continue;
			}
		
			var currentSource1UnitID = ds_grid_get(wordGrid, wordGrid_colUnitID, currentSource1 - 1);
			var currentGoal1UnitID = ds_grid_get(wordGrid, wordGrid_colUnitID, currentGoal1 - 1);
			var rowInLineGridcurrentSource1 = ds_grid_value_y(obj_control.lineGrid, obj_control.lineGrid_colUnitID, 0, obj_control.lineGrid_colUnitID, lineGridHeight, currentSource1UnitID);
			var rowInLineGridcurrentGoal1 = ds_grid_value_y(obj_control.lineGrid, obj_control.lineGrid_colUnitID, 0, obj_control.lineGrid_colUnitID, lineGridHeight, currentGoal1UnitID);
			//var rowInLineGridcurrentSource1 =  currentSource1UnitID - 1;
			//var rowInLineGridcurrentGoal1 = currentGoal1UnitID - 1;
		
		
			if (rowInLineGridcurrentSource1 < 0 or rowInLineGridcurrentSource1 >= lineGridHeight)
			{
				plusRow++;
				if (rowInVizLinkGrid + plusRow >= vizLinkGridHeight)
				{
					break;
				}
				continue;
			}
			if (rowInLineGridcurrentGoal1 < 0 or rowInLineGridcurrentGoal1 >= lineGridHeight)
			{
				plusRow++;
				if (rowInVizLinkGrid + plusRow >= vizLinkGridHeight)
				{
					break;
				}
				continue;
			}
		
			var source1PixelX = ds_grid_get(dynamicWordGrid, dynamicWordGrid_colPixelX, currentSource1 - 1);
			var source1PixelY = ds_grid_get(lineGrid, lineGrid_colPixelY, rowInLineGridcurrentSource1);
			var goal1PixelX = ds_grid_get(dynamicWordGrid, dynamicWordGrid_colPixelX, currentGoal1 - 1);
			var goal1PixelY = ds_grid_get(lineGrid, lineGrid_colPixelY, rowInLineGridcurrentGoal1);
		
			var vizLinkLookupGridHeight = ds_grid_height(vizLinkLookupGrid);
			for (var k = 0; k < vizLinkLookupGridHeight; k++)
			{
				var lookupGridChainID = ds_grid_get(vizLinkLookupGrid, vizLinkLookupGrid_colChainID, k);
				if (currentChainID == lookupGridChainID)
				{
					continue;
				}
				var lookupGridStart = ds_grid_get(vizLinkLookupGrid, vizLinkLookupGrid_colStart, k);
				var lookupGridEnd = ds_grid_get(vizLinkLookupGrid, vizLinkLookupGrid_colEnd, k);
			
				for (var l = lookupGridStart; l < lookupGridEnd; l++)
				{
					if (l < 0 or l >= vizLinkGridHeight)
					{
						continue;
					}
				
					var currentSource2 = ds_grid_get(vizLinkGrid, vizLinkGrid_colSource, l);
					var currentGoal2 = ds_grid_get(vizLinkGrid, vizLinkGrid_colGoal, l);
				
					if (currentSource2 == -1 or currentGoal2 == -1)
					{
						continue;
					}
					if (currentSource1 == currentSource2 or currentSource1 == currentGoal2)
					{
						continue;
					}
					if (currentGoal1 == currentGoal2 or currentGoal1 == currentSource2)
					{
						continue;
					}
				
					var currentSource2UnitID = ds_grid_get(wordGrid, wordGrid_colUnitID, currentSource2 - 1);
					var currentGoal2UnitID = ds_grid_get(wordGrid, wordGrid_colUnitID, currentGoal2 - 1);
					var rowInLineGridcurrentSource2 = ds_grid_value_y(obj_control.lineGrid, obj_control.lineGrid_colUnitID, 0, obj_control.lineGrid_colUnitID, lineGridHeight, currentSource2UnitID);
					var rowInLineGridcurrentGoal2 = ds_grid_value_y(obj_control.lineGrid, obj_control.lineGrid_colUnitID, 0, obj_control.lineGrid_colUnitID, lineGridHeight, currentGoal2UnitID);
					//var rowInLineGridcurrentSource2 = currentSource2UnitID - 1;
					//var rowInLineGridcurrentGoal2 = currentGoal2UnitID - 1;
				
				
					if (rowInLineGridcurrentSource2 < 0 or rowInLineGridcurrentSource2 >= lineGridHeight)
					{
						continue;
					}
					if (rowInLineGridcurrentGoal2 < 0 or rowInLineGridcurrentGoal2 >= lineGridHeight)
					{
						continue;
					}
				
					var source2PixelX = ds_grid_get(dynamicWordGrid, dynamicWordGrid_colPixelX, currentSource2 - 1);
					var source2PixelY = ds_grid_get(lineGrid, lineGrid_colPixelY, rowInLineGridcurrentSource2);
					var goal2PixelX = ds_grid_get(dynamicWordGrid, dynamicWordGrid_colPixelX, currentGoal2 - 1);
					var goal2PixelY = ds_grid_get(lineGrid, lineGrid_colPixelY, rowInLineGridcurrentGoal2);
				
					var intersection = scr_lineIntersection(source1PixelX, source1PixelY, goal1PixelX, goal1PixelY, source2PixelX, source2PixelY, goal2PixelX, goal2PixelY, true);
					if (intersection > 0 and intersection <= 1)
					{
						var currentCross = ds_grid_get(vizLinkGrid, vizLinkGrid_colCross, l);
						ds_grid_set(vizLinkGrid, vizLinkGrid_colCross, l, currentCross + 1);
						//show_message("CROSS");
					}
				}
			}
		
			plusRow++;
			if (rowInVizLinkGrid + plusRow >= vizLinkGridHeight)
			{
				break;
			}
		}
	}




	ds_grid_destroy(vizLinkLookupGrid);


}
