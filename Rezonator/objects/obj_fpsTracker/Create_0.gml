fpsGridWidth = 3;
fpsGrid_colTime = 0;
fpsGrid_colFPS = 1;
fpsGrid_colLinkGridHeight = 2;

fpsGridCurrentRow = 0;

fpsGrid = ds_grid_create(fpsGridWidth, 1000);

alarm[0] = fps * 5;