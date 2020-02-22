var camWidth = camera_get_view_width(view_camera[0]);
var camHeight = camera_get_view_height(view_camera[0]);

var rowHeight = string_height("A") * 1.3;



// Rez Info window
var rezInfoWindowRectX1 = (camWidth / 2) + 50;
var rezInfoWindowRectY1 = (camHeight / 2) - 100;
var rezInfoWindowRectX2 = camWidth - 40;
var rezInfoWindowRectY2 = camHeight - 150;



windowWidth = clamp(rezInfoWindowRectX2 - rezInfoWindowRectX1, 48, 2000);
windowHeight = clamp(rezInfoWindowRectY2 - rezInfoWindowRectY1, 48, 1500);
clipWidth = windowWidth;
clipHeight = windowHeight;
	
windowX = x;
windowY = y;
clipX = x;
clipY = y;

if (!surface_exists(clipSurface)) {
    clipSurface = surface_create(clipWidth, clipHeight);
}

scr_windowCameraAdjust();

surface_set_target(clipSurface);
draw_clear_alpha(c_black, 0);







x = rezInfoWindowRectX1;
y = rezInfoWindowRectY1;






// Draw Rez Info window contents
draw_set_font(fnt_main);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
var mouseoverRow = -1;

for (var i = 0; i < ds_grid_width(global.rezInfoGrid); i++) {
	
	var colX = 0;
	if (i == 0) {
		colX = rezInfoWindowRectX1;
	}
	else {
		colX = (rezInfoWindowRectX1 + 30) + (((rezInfoWindowRectX2 - scrollBarWidth - (rezInfoWindowRectX1 + 30)) / 3) * (i - 1));
	}
	
	var plusY = rezInfoWindowRectY1 + rowHeight;
	
	for (var j = 0; j < ds_grid_height(global.rezInfoGrid); j++) {
		
		var cellRectX1 = colX;
		var cellRectY1 = plusY + scrollPlusY;
		var cellRectX2 = (rezInfoWindowRectX1 + 30) + (((rezInfoWindowRectX2 - (rezInfoWindowRectX1 + 30)) / 3) * (i));
		var cellRectY2 = plusY + rowHeight;
		cellRectX2 = clamp(cellRectX2, 0, rezInfoWindowRectX2 - scrollBarWidth)
		
		// draw BG stripes
		draw_set_color(global.colorThemeBG);
		var tagInfoGridRow = ds_grid_get(global.rezInfoGrid, global.rezInfoGrid_colAssignedCol, j);
		if (obj_importMapping.rezInfoGridSelectedRow == j or tagInfoGridRow >= 0) {
			if (tagInfoGridRow >= 0 and tagInfoGridRow < ds_grid_height(obj_importMapping.tagInfoGrid)) {
				draw_set_color(ds_grid_get(obj_importMapping.tagInfoGrid, obj_importMapping.tagInfoGrid_colColor, tagInfoGridRow));
			}
			else {
				draw_set_color(make_color_rgb(183, 183, 255));
			}
		}
		draw_rectangle(cellRectX1 - clipX, cellRectY1 - clipY, cellRectX2 - clipX, cellRectY2 - clipY, false);
		
		if (scr_pointInRectangleClippedWindow(mouse_x, mouse_y, cellRectX1, cellRectY1, cellRectX2, cellRectY2)) {
			mouseoverRow = j;
			if (mouse_check_button_pressed(mb_left)) {
				obj_importMapping.rezInfoGridSelectedRow = j;
			}
		}
		
		
		var currentCell = ds_grid_get(global.rezInfoGrid, i, j);
		if (i == global.rezInfoGrid_colAssignedTag) {
			if (currentCell == -1) {
				currentCell = "...";
			}
		}
		
		draw_set_color(global.colorThemeText);
		draw_set_font(fnt_main);
		draw_text(floor(colX + 5) - clipX, floor(plusY + (rowHeight / 2) + scrollPlusY) - clipY, string(currentCell));
		
		plusY += rowHeight;
	}
}











// draw header for column
draw_set_color(global.colorThemeBG);
draw_rectangle(rezInfoWindowRectX1 - clipX, rezInfoWindowRectY1 - clipY, rezInfoWindowRectX2 - clipX, rezInfoWindowRectY1 + rowHeight - clipY, false);
for (var i = 0; i < ds_grid_width(global.rezInfoGrid) - 1; i++) {
	var colX = 0;
	if (i == 0) {
		colX = rezInfoWindowRectX1;
	}
	else {
		colX = (rezInfoWindowRectX1 + 30) + (((rezInfoWindowRectX2 - scrollBarWidth - (rezInfoWindowRectX1 + 30)) / 3) * (i - 1));
	}
	var headerStr = "";
	switch (i) {
		case 0:
			headerStr = "#";
			break;
		case 1:
			headerStr = "Level";
			break;
		case 2:
			headerStr = "Tier";
			break;
		case 3:
			headerStr = "Assigned Tag";
			break;
		default:
			break;
	}
	draw_set_font(fnt_mainBold);
	draw_set_color(global.colorThemeText);
	draw_text(colX + 5 - clipX, floor(rezInfoWindowRectY1 + (rowHeight / 2)) - clipY, headerStr);
	
	// draw column lines
	draw_set_color(global.colorThemeBorders);
	draw_line(colX - clipX, rezInfoWindowRectY1 - clipY, colX - clipX, rezInfoWindowRectY2 - clipY);
}
draw_set_color(global.colorThemeBorders);
draw_rectangle(rezInfoWindowRectX1 - clipX, rezInfoWindowRectY1 - clipY, rezInfoWindowRectX2 - clipX, rezInfoWindowRectY1 + rowHeight - clipY, true);


// draw mouseover/selected rectangles
if (mouseoverRow >= 0) {
	draw_set_color(global.colorThemeBorders);
	var mouseoverRowY1 = rezInfoWindowRectY1 + (rowHeight * (mouseoverRow + 1)) + scrollPlusY;
	var mouseoverRowY2 = mouseoverRowY1 + rowHeight;
	draw_rectangle(rezInfoWindowRectX1 - clipX, mouseoverRowY1 - clipY, rezInfoWindowRectX2 - clipX, mouseoverRowY2 - clipY, true);
}
// deleting tag and cancelling tag
if (obj_importMapping.rezInfoGridSelectedRow > -1) {
	
	if (keyboard_check_pressed(vk_delete)) {
		var oldTag = ds_grid_get(global.rezInfoGrid, global.rezInfoGrid_colAssignedTag, obj_importMapping.rezInfoGridSelectedRow);
		if (oldTag != 0) {
			var oldTagRow = ds_grid_value_y(obj_importMapping.tagInfoGrid, obj_importMapping.tagInfoGrid_colTag, 0, obj_importMapping.tagInfoGrid_colTag, ds_grid_height(obj_importMapping.tagInfoGrid), oldTag);
				
			var occurences = 0;
			for (var i = 0; i < ds_grid_height(obj_importMapping.tagInfoGrid); i++) {
				occurences += (ds_grid_get(global.rezInfoGrid, global.rezInfoGrid_colAssignedTag, i) == oldTag) ? 1 : 0;
			}
				
			if (occurences < 2) {
				ds_grid_set(obj_importMapping.tagInfoGrid, obj_importMapping.tagInfoGrid_colMapped, oldTagRow, false);
			}
		}
		ds_grid_set(global.rezInfoGrid, global.rezInfoGrid_colAssignedTag, obj_importMapping.rezInfoGridSelectedRow, -1);
		ds_grid_set(global.rezInfoGrid, global.rezInfoGrid_colAssignedCol, obj_importMapping.rezInfoGridSelectedRow, -1);
		obj_importMapping.rezInfoGridSelectedRow = -1;
	}
	
	if (keyboard_check_pressed(vk_escape)) {
		obj_importMapping.rezInfoGridSelectedRow = -1;
	}
	
	draw_set_color(global.colorThemeBorders);
	var selectedRowY1 = rezInfoWindowRectY1 + (rowHeight * (obj_importMapping.rezInfoGridSelectedRow + 1)) + scrollPlusY;
	var selectedRowY2 = selectedRowY1 + rowHeight;
	draw_rectangle(rezInfoWindowRectX1 - clipX, selectedRowY1 - clipY, rezInfoWindowRectX2 - clipX, selectedRowY2 - clipY, true);
}





// mousewheel input
if (point_in_rectangle(mouse_x, mouse_y, x, y, x + windowWidth, y + windowHeight)) {
	if (mouse_wheel_up()) {
		scrollPlusYDest += 8;
	}
	if (mouse_wheel_down()) {
		scrollPlusYDest -= 8;
	}
}

scr_scrollBar(ds_grid_height(global.rezInfoGrid), -1, rowHeight, rowHeight,
	global.colorThemeSelected1, global.colorThemeSelected2,
	global.colorThemeSelected1, global.colorThemeSelected2, spr_ascend, (rezInfoWindowRectX2 - rezInfoWindowRectX1), (rezInfoWindowRectY2 - rezInfoWindowRectY1));
	
scrollPlusY = min(scrollPlusY, 0);



scr_surfaceEnd();


draw_set_color(global.colorThemeText);
draw_set_font(fnt_mainBold);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_text(rezInfoWindowRectX1, floor(rezInfoWindowRectY1 - string_height("0")), "Rez Info");


// draw Rez Info window border
draw_set_color(global.colorThemeBorders);
draw_set_alpha(1);
draw_rectangle(rezInfoWindowRectX1, rezInfoWindowRectY1, rezInfoWindowRectX2, rezInfoWindowRectY2, true);