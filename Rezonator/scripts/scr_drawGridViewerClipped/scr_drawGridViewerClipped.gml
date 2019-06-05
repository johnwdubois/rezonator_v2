scr_drawGridViewerGridTabs();

scr_surfaceStart();

var scrollBarWidth = 20;
var gridColWidth = windowWidth / ds_grid_width(grid);
var textY = 0;
var textPlusY = 0;
var colNameHeight = 16;

var windowX1 = windowX;
var windowY1 = windowY;
var windowX2 = windowX1 + windowWidth;
var windowY2 = windowY1 + windowHeight;


draw_set_color(global.colorThemeBG);
draw_rectangle(windowX1 - scrollBarWidth - clipX, windowY1 - clipY, windowX1 - clipX, windowY2 - clipY, false);
draw_set_font(fnt_debug);
var strHeight = string_height("0");

var currentItemString = " ";
var mouseoverItemString = " ";
var mouseoverCol = -1;

for (var gridLoopCol = 0; gridLoopCol < ds_grid_width(grid); gridLoopCol++) {
	var colRectX1 = windowX + (gridLoopCol * gridColWidth);
	var colRectY1 = windowY;
	var colRectX2 = colRectX1 + gridColWidth;//windowWidth;
	var colRectY2 = colRectY1 + windowHeight;
		
	draw_set_color(global.colorThemeBG);
	draw_rectangle(colRectX1 - clipX, colRectY1 - clipY, colRectX2 - clipX, colRectY2 - clipY, false);
	draw_set_color(global.colorThemeBorders);
	draw_rectangle(colRectX1 - clipX, colRectY1 - clipY, colRectX2 - clipX, colRectY2 - clipY, true);
	
	draw_set_halign(fa_left);
	draw_set_valign(fa_middle);
	
	//var colName = scr_getColNameString(grid, gridLoopCol);
	//draw_text(colRectX1 - clipX, colRectY1 + (colNameHeight / 2), colName);
	
	//textY = colRectY1 + colNameHeight;
	textPlusY = 0;
	
	for (var gridLoopRow = 0; gridLoopRow < ds_grid_height(grid); gridLoopRow++) {
		
		
		if (windowY1 + colNameHeight + scrollPlusY + textPlusY < windowY1 - strHeight
		or windowY1 + colNameHeight + scrollPlusY + textPlusY > windowY1 + windowHeight + strHeight) {
			textPlusY += strHeight;
			continue;
		}
		
		
		
		currentItemString = scr_drawGridViewerGetItemString(grid, gridLoopCol, gridLoopRow);

		if (currentItemString == "undefined") {
			continue;
		}
		
		
		var textX = windowX + (gridLoopCol * gridColWidth);
		//textY += strHeight;
		
		var currentCellRectX1 = colRectX1;
		var currentCellRectY1 = textY - (string_height(currentItemString) / 2) + scrollPlusY;
		var currentCellRectX2 = colRectX2;
		var currentCellRectY2 = currentCellRectY1 + string_height(currentItemString);
		
		if (gridLoopRow == mouseoverRow) {
			draw_set_color(global.colorThemeSelected1);
			draw_rectangle(currentCellRectX1 - clipX, currentCellRectY1 - clipY, currentCellRectX2 - clipX, currentCellRectY2 - clipY, false);
		}
		
		if (point_in_rectangle(mouse_x, mouse_y, currentCellRectX1, currentCellRectY1, currentCellRectX2, currentCellRectY2)) {
			mouseoverRow = gridLoopRow;
			mouseoverCol = gridLoopCol;
			mouseoverItemString = currentItemString;
			draw_set_color(global.colorThemeSelected2);
			draw_rectangle(currentCellRectX1 - clipX, currentCellRectY1 - clipY, currentCellRectX2 - clipX, currentCellRectY2 - clipY, true);
		}
		
		var textY = windowY1 + colNameHeight + scrollPlusY + textPlusY;
		
		draw_set_color(global.colorThemeText);
		draw_text(textX - clipX, textY - clipY, currentItemString);
		
		textPlusY += strHeight;
	}
}

draw_set_color(global.colorThemeBG);
draw_rectangle(windowX1 - clipX, windowY1 - clipY, windowX2 - clipX, windowY1 + colNameHeight - clipY, false);
draw_set_color(global.colorThemeBorders);
draw_rectangle(windowX1 - clipX, windowY1 - clipY, windowX2 - clipX, windowY1 + colNameHeight - clipY, true);

scr_scrollBar(ds_grid_height(grid), -1, strHeight, colNameHeight,
	global.colorThemeSelected1, global.colorThemeSelected2,
	global.colorThemeSelected1, global.colorThemeBG, spr_ascend, windowWidth, windowHeight);

scr_surfaceEnd();

for (var gridLoopCol = 0; gridLoopCol < ds_grid_width(grid); gridLoopCol++) {
	draw_set_halign(fa_left);
	draw_set_valign(fa_middle);
	draw_set_color(global.colorThemeText);
	
	var colName = scr_getColNameString(grid, gridLoopCol);
	draw_text(windowX1 + (gridLoopCol * gridColWidth), windowY1 + (colNameHeight / 2), colName);
}

for (var j = 0; j < 5; j++) {
	draw_set_color(global.colorThemeBorders);
	draw_rectangle(windowX1 - scrollBarWidth - j, windowY1 - j, windowX2 + j, windowY2 + j, true);
}

draw_text(mouse_x, mouse_y, string(mouseoverRow));