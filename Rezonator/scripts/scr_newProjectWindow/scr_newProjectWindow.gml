if (keyboard_check_pressed(vk_escape))
{
	global.newProject = false;
	global.openProject = false;
}

draw_set_font(fnt_main);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var importButtonRectWidth = 200;
var importButtonRectHeight = 60;

var importButtonRectX1 = room_width / 2 - (importButtonRectWidth / 2);
var importButtonRectY1 = (room_height / 4) * 3 - (importButtonRectHeight / 2);
var importButtonRectX2 = importButtonRectX1 + importButtonRectWidth;
var importButtonRectY2 = importButtonRectY1 + importButtonRectHeight;

if (point_in_rectangle(mouse_x, mouse_y, importButtonRectX1, importButtonRectY1, importButtonRectX2, importButtonRectY2))
{
	draw_set_color(c_ltgray);
	
	if (mouse_check_button_pressed(mb_left))
	{
		scr_openXML();
	}
}
else
{
	draw_set_color(c_white);
}
draw_rectangle(importButtonRectX1, importButtonRectY1, importButtonRectX2, importButtonRectY2, false);
draw_set_color(c_black);
draw_rectangle(importButtonRectX1, importButtonRectY1, importButtonRectX2, importButtonRectY2, true);

var importButtonString = "Open file";
if (ds_grid_height(global.fileLineRipGrid) >= 1)
{
	importButtonString = "Open another file";
}

draw_text(mean(importButtonRectX1, importButtonRectX2), mean(importButtonRectY1, importButtonRectY2), importButtonString);



canContinue = (global.totalUnitAmount > 0);


var continueButtonRectWidth = 200;
var continueButtonRectHeight = 60;

var continueButtonRectX1 = room_width / 2 - (continueButtonRectWidth / 2);
var continueButtonRectY1 = (room_height / 8) * 7 - (continueButtonRectHeight / 2);
var continueButtonRectX2 = continueButtonRectX1 + continueButtonRectWidth;
var continueButtonRectY2 = continueButtonRectY1 + continueButtonRectHeight;

if (point_in_rectangle(mouse_x, mouse_y, continueButtonRectX1, continueButtonRectY1, continueButtonRectX2, continueButtonRectY2) && canContinue)
{
	draw_set_color(c_ltgray);
	
	if (mouse_check_button_pressed(mb_left))
	{
		room_goto_next();
	}
}
else
{
	draw_set_color(c_white);
}

if (canContinue)
{
	draw_set_alpha(1);
}
else
{
	draw_set_alpha(0.25);
}

draw_rectangle(continueButtonRectX1, continueButtonRectY1, continueButtonRectX2, continueButtonRectY2, false);
draw_set_color(c_black);
draw_rectangle(continueButtonRectX1, continueButtonRectY1, continueButtonRectX2, continueButtonRectY2, true);

draw_text(mean(continueButtonRectX1, continueButtonRectX2), mean(continueButtonRectY1, continueButtonRectY2), "Go!");


draw_set_alpha(1);


var totalUnitAmount = 0;
for (var i = 0; i < ds_grid_height(global.fileLineRipGrid); i++)
{
	totalUnitAmount += ds_grid_get(global.fileLineRipGrid, global.fileLineRipGrid_colUnitAmount, i);
}
global.totalUnitAmount = totalUnitAmount;
draw_set_halign(fa_right);
draw_text(importWindowX2, importWindowY2 + 24, "Total unit count: " + string(totalUnitAmount));



var scrollBarWidth = 16;
currentTopViewRow = max(0, currentTopViewRow);
currentTopViewRow = min(ds_grid_height(global.fileLineRipGrid) - scrollRange, currentTopViewRow);

var mouseoverAny = false;
var calloutBubbleX = -1;
var calloutBubbleY = -1;
var calloutBubbleText = "";

var textPlusY = 24;
for (var i = currentTopViewRow; i < currentTopViewRow + scrollRange; i++)
{
	if (i < 0 or i > ds_grid_height(global.fileLineRipGrid))
	{
		continue;
	}
	
	var discoID = string(ds_grid_get(global.fileLineRipGrid, global.fileLineRipGrid_colDiscoID, i));
	var unitAmount = string(ds_grid_get(global.fileLineRipGrid, global.fileLineRipGrid_colUnitAmount, i));
	
	if (discoID == "undefined" or unitAmount == "undefined")
	{
		continue;
	}
	
	var currentParticipantList = ds_grid_get(global.fileLineRipGrid, global.fileLineRipGrid_colParticipantList, i);
	
	var textBuffer = 10;
	draw_set_color(c_black);
	draw_set_halign(fa_left);
	draw_text(importWindowX1 + textBuffer, importWindowY1 + textPlusY, discoID);
	draw_set_halign(fa_right);
	draw_text(importWindowX2 - scrollBarWidth - textBuffer, importWindowY1 + (textPlusY), unitAmount + " lines");
	
	var participantRectColorList = ds_grid_get(global.fileLineRipGrid, global.fileLineRipGrid_colColorList, i);
	for (var j = 0; j < ds_list_size(currentParticipantList); j++)
	{
		var participantRectX1 = importWindowX1 + 100 + (j * 20);
		var participantRectY1 = importWindowY1 + textPlusY - 5;
		var participantRectX2 = participantRectX1 + 10;
		var participantRectY2 = participantRectY1 + 10;
		
		var participantRectColor = ds_list_find_value(participantRectColorList, j);
		
		draw_set_color(participantRectColor);
		draw_rectangle(participantRectX1, participantRectY1, participantRectX2, participantRectY2, false);
		
		var participantName = ds_list_find_value(currentParticipantList, j);
		
		if point_in_rectangle(mouse_x, mouse_y, participantRectX1, participantRectY1, participantRectX2, participantRectY2)
		{
			mouseoverAny = true;
			calloutBubbleX = mean(participantRectX1, participantRectX2);
			calloutBubbleY = mean(participantRectY1, participantRectY2);
			calloutBubbleText = participantName;
		}
	}
	
	textPlusY += string_height(".");
}


var scrollBarHeight = ((scrollRange * importWindowHeight) / ds_grid_height(global.fileLineRipGrid));
var scrollBarRectX1 = importWindowX1 + importWindowWidth - scrollBarWidth;
var scrollBarRectY1 = importWindowY1 + ((currentTopViewRow * importWindowHeight) / ds_grid_height(global.fileLineRipGrid));
var scrollBarRectX2 = scrollBarRectX1 + scrollBarWidth;
var scrollBarRectY2 = scrollBarRectY1 + scrollBarHeight;

scrollBarRectY1 = max(scrollBarRectY1, importWindowY1 + 1);
scrollBarRectY2 = max(scrollBarRectY2, importWindowY1 + 24);
scrollBarRectY2 = min(scrollBarRectY2, importWindowY2);

if (ds_grid_height(global.fileLineRipGrid) == 0)
{
	scrollBarRectY1 = importWindowY1 + 1;
	scrollBarRectY2 = importWindowY1 + importWindowHeight;
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
	currentTopViewRow = floor(((mouse_y - y - scrollBarHoldingPlusY) * ds_grid_height(global.fileLineRipGrid)) / (importWindowHeight));
}

if (mouseoverAny and calloutBubbleX > -1 and calloutBubbleY > -1)
{
	draw_sprite(spr_calloutBubble, 0, calloutBubbleX, calloutBubbleY);
	draw_set_color(c_black);
	draw_set_halign(fa_center);
	draw_set_font(fnt_calloutBubble);
	draw_text(calloutBubbleX, calloutBubbleY - 15, calloutBubbleText);
}

draw_set_color(c_black);
draw_rectangle(importWindowX1, importWindowY1, importWindowX2, importWindowY2, true);