function scr_gridDeleteRow(argument0, argument1) {
	/*
		scr_findInGridTwoParameters(grid, row);
	
		Last Updated: 2018-09-11
	
		Called from: any object
	
		Purpose: delete row from a grid
	
		Mechanism: use GML grid functions to resize and reset grid cells to necessary values
	
		Author: Terry DuBois
	*/

	var grid = argument0;
	var row = argument1;
	var gridWidth = ds_grid_width(grid);
	var gridHeight = ds_grid_height(grid);

	ds_grid_set_grid_region(grid, grid, 0, row + 1, gridWidth - 1, gridHeight - 1, 0, row);
	ds_grid_resize(grid, gridWidth, gridHeight - 1);


}
