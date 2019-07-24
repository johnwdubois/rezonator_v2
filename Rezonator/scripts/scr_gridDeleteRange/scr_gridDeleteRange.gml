var grid = argument0;
var col = argument1;
var gridRangeBegining = argument2;
var gridRangeEnd = argument3;

var gridCopy = ds_grid_create(ds_grid_width(grid), ds_grid_height(grid));
ds_grid_copy(gridCopy, grid);

ds_grid_clear(grid, 0);
ds_grid_resize(grid, ds_grid_width(gridCopy), 0);

//var gridReturn = ds_grid_create(ds_grid_width(grid),0);

for (var i = 0; i< ds_grid_height(gridCopy); i++ ) {
	var currentCell = ds_grid_get(gridCopy, col, i);
	if(real(currentCell) >= gridRangeBegining && real(currentCell) <= gridRangeEnd){
		ds_grid_resize(grid, ds_grid_width(gridCopy), ds_grid_height(grid) + 1);
		for(var j = 0; j < ds_grid_width(gridCopy); j++){
			var currentCellCopy = ds_grid_get(gridCopy,j,i);
			
			/*
			if (scr_isItemAList(gridCopy,j,i)) {
				currentCellCopy = ds_list_create();
				ds_list_copy(currentCellCopy, ds_grid_get(gridCopy,j,i));
					//show_message(scr_getStringOfList(currentCellCopy));
			}
			*/
			
		ds_grid_set(grid, j, ds_grid_height(grid) - 1, currentCellCopy);
			
		}
		
	}
}


//return gridReturn;