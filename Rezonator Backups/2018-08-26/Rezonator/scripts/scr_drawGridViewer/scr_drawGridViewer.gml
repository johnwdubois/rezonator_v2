var gridArrayIndex = argument0;

scr_drawGridViewerGridTabs(gridArrayIndex);

var scrollBarWidth = 20;
var gridColWidth = windowWidth[gridArrayIndex] / ds_grid_width(grid[gridArrayIndex]);
var textY = 0;
var colNameHeight = 16;

var windowX1 = windowX[gridArrayIndex];
var windowY1 = windowY[gridArrayIndex];
var windowX2 = windowX1 + windowWidth[gridArrayIndex];
var windowY2 = windowY1 + windowHeight[gridArrayIndex];

gridCurrentTopViewRow[gridArrayIndex] = max(0, gridCurrentTopViewRow[gridArrayIndex]);
gridCurrentTopViewRow[gridArrayIndex] = min(ds_grid_height(grid[gridArrayIndex]) - scrollRange[gridArrayIndex], gridCurrentTopViewRow[gridArrayIndex]);

draw_set_color(c_white);
draw_rectangle(windowX1 - scrollBarWidth, windowY1, windowX1, windowY2, false);
draw_set_font(fnt_debug);

var currentItemString = " ";
var mouseoverItemString = " ";
var mouseoverRow = -1;
var mouseoverCol = -1;

for (var gridLoopCol = 0; gridLoopCol < ds_grid_width(grid[gridArrayIndex]); gridLoopCol++)
{
	var colRectX1 = windowX[gridArrayIndex] + (gridLoopCol * gridColWidth);
	var colRectY1 = windowY[gridArrayIndex];
	var colRectX2 = colRectX1 + gridColWidth;//windowWidth[gridArrayIndex];
	var colRectY2 = colRectY1 + windowHeight[gridArrayIndex];
		
	draw_set_color(c_white);
	draw_rectangle(colRectX1, colRectY1, colRectX2, colRectY2, false);
	draw_set_color(c_black);
	draw_rectangle(colRectX1, colRectY1, colRectX2, colRectY2, true);
	
	draw_set_halign(fa_left);
	draw_set_valign(fa_middle);
	
	var colName = scr_drawGridViewGetColName(grid[gridArrayIndex], gridLoopCol)
	draw_text(colRectX1, colRectY1 + (colNameHeight / 2), colName);
	
	textY = colRectY1 + colNameHeight;
	
	for (var gridLoopRow = gridCurrentTopViewRow[gridArrayIndex]; gridLoopRow < (gridCurrentTopViewRow[gridArrayIndex] + scrollRange[gridArrayIndex]); gridLoopRow++)
	{
		if (gridLoopRow < 0 or gridLoopRow >= ds_grid_height(grid[gridArrayIndex]))
		{
			continue;
		}
		
		currentItemString = scr_drawGridViewerGetItemString(grid[gridArrayIndex], gridLoopCol, gridLoopRow);

		if (currentItemString == "undefined")
		{
			continue;
		}
		
		
		var textX = windowX[gridArrayIndex] + (gridLoopCol * gridColWidth);
		textY += string_height(currentItemString);
		
		var currentCellRectX1 = colRectX1;
		var currentCellRectY1 = textY - (string_height(currentItemString) / 2);
		var currentCellRectX2 = colRectX2;
		var currentCellRectY2 = currentCellRectY1 + string_height(currentItemString);
		
		if (gridLoopRow == mouseoverRelativeRow[gridArrayIndex])
		{
			draw_set_color(c_ltgray);
			draw_rectangle(currentCellRectX1, currentCellRectY1, currentCellRectX2, currentCellRectY2, false);
		}
		
		if (point_in_rectangle(mouse_x, mouse_y, currentCellRectX1, currentCellRectY1, currentCellRectX2, currentCellRectY2))
		{
			mouseoverRow = gridLoopRow;
			mouseoverCol = gridLoopCol;
			mouseoverItemString = currentItemString;
			mouseoverRelativeRow[gridArrayIndex] = gridLoopRow;
			draw_set_color(c_dkgray);
			draw_rectangle(currentCellRectX1, currentCellRectY1, currentCellRectX2, currentCellRectY2, true);
		}

		
		draw_set_color(c_black);
		draw_text(textX, textY, currentItemString);
	}
}

draw_set_color(c_black);
draw_rectangle(windowX1, windowY1, windowX2, windowY1 + colNameHeight, true);

scrollRange[gridArrayIndex] = (windowHeight[gridArrayIndex] / string_height(currentItemString)) - 2;

if (point_in_rectangle(mouse_x, mouse_y, windowX1, windowY1, windowX2, windowY2))
{
	if (mouse_wheel_up() || keyboard_check(vk_up))
	{
		if (gridCurrentTopViewRow[gridArrayIndex] > 0)
		{
			gridCurrentTopViewRow[gridArrayIndex]--;
			
			if (scrollTogether)
			{
				for (var scrollTogetherLoop = 0; scrollTogetherLoop < array_length_1d(grid); scrollTogetherLoop++)
				{
					if (scrollTogetherLoop != gridArrayIndex)
					{
						gridCurrentTopViewRow[scrollTogetherLoop]--;
					}
				}
			}
		}
	}
	else if (mouse_wheel_down() || keyboard_check(vk_down))
	{
		if (gridCurrentTopViewRow[gridArrayIndex] + scrollRange[gridArrayIndex] < ds_grid_height(grid[gridArrayIndex]))
		{
			gridCurrentTopViewRow[gridArrayIndex]++;
		}
		
		if (scrollTogether)
		{
			for (var scrollTogetherLoop = 0; scrollTogetherLoop < array_length_1d(grid); scrollTogetherLoop++)
			{
				if (scrollTogetherLoop != gridArrayIndex)
				{
					gridCurrentTopViewRow[scrollTogetherLoop]++;
				}
			}
		}
	}
}


var scrollBarHeight = (scrollRange[gridArrayIndex] * windowHeight[gridArrayIndex]) / ds_grid_height(grid[gridArrayIndex]);
var scrollBarRectX1 = windowX1 - scrollBarWidth;
var scrollBarRectY1 = windowY1 + ((gridCurrentTopViewRow[gridArrayIndex] * windowHeight[gridArrayIndex]) / ds_grid_height(grid[gridArrayIndex]));
var scrollBarRectX2 = scrollBarRectX1 + scrollBarWidth;
var scrollBarRectY2 = scrollBarRectY1 + scrollBarHeight;


draw_set_color(c_ltgray);
draw_rectangle(scrollBarRectX1, scrollBarRectY1, scrollBarRectX2, scrollBarRectY2, false);

if (point_in_rectangle(mouse_x, mouse_y, scrollBarRectX1, scrollBarRectY1, scrollBarRectX2, scrollBarRectY2))
{
	if (mouse_check_button_pressed(mb_left))
	{
		scrollBarHolding[gridArrayIndex] = true;
		scrollBarHoldingPlusY[gridArrayIndex] = mouse_y - scrollBarRectY1;
	}
}

scrollBarHoldingPlusY[gridArrayIndex] = 0;

if (mouse_check_button_released(mb_left))
{
	scrollBarHolding[gridArrayIndex] = false;
}

if (scrollBarHolding[gridArrayIndex])
{
	gridCurrentTopViewRow[gridArrayIndex] = floor(((mouse_y - windowY1 - scrollBarHoldingPlusY[gridArrayIndex]) * ds_grid_height(grid[gridArrayIndex])) / (windowHeight[gridArrayIndex]));
	
	if (scrollTogether)
	{
		for (var scrollTogetherLoop = 0; scrollTogetherLoop < array_length_1d(grid); scrollTogetherLoop++)
		{
			if (scrollTogetherLoop != gridArrayIndex)
			{
				gridCurrentTopViewRow[scrollTogetherLoop] = floor(((mouse_y - windowY1 - scrollBarHoldingPlusY[scrollTogetherLoop]) * ds_grid_height(grid[scrollTogetherLoop])) / (windowHeight[scrollTogetherLoop]));
			}
		}
	}
}

draw_set_color(c_black);
draw_rectangle(windowX1, windowY1, windowX2, windowY2, true);

draw_set_font(fnt_main);
draw_set_halign(fa_right);
draw_text(windowX1 + 100 - 20, windowY2 + 70, "(" + string(mouseoverCol) + "," + string(mouseoverRow) + "):")
draw_set_halign(fa_left);
draw_text(windowX1 + 100, windowY2 + 70, mouseoverItemString);

for (var j = 0; j < 5; j++)
{
	draw_set_color(c_black);
	draw_rectangle(windowX1 - scrollBarWidth - j, windowY1 - j, windowX2 + j, windowY2 + j, true);
}

if (not point_in_rectangle(mouse_x, mouse_y, windowX1, windowY1, windowX2, windowY2))
{
	mouseoverRelativeRow[gridArrayIndex] = -1;
}