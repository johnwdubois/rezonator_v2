
/*
	scr_panelPane_drawTracker();
	
	Last Updated: 2019-07-06
	
	Called from: obj_panelPane
	
	Purpose: alllows user to access time taken and moves used information
	
	Mechanism: draws a clickable rectangle that will expand upwards from the bottom corner of the screen
	displaying the movecounter and time taken as well as a reset button.
				
	Author: Brady Moore
*/

var Xdistance = 100;
var Ydistance = 30;
var newYheight = 80;
var newYheightText1 = 95;
var newYheightText2 = 75;
var newYheightText3 = 50;
var resetX1val = 80;
var resetX2val = 20;
var resetY1val = 60;
var resetY2val = 40;

var Yheightbuffer = 10;
var oldYheight = 0;

//convert seconds into displayable seconds
var displaySeconds = string(timerSecs); 
var displayMinutes = string(timerMins);

if(string_length(displaySeconds)<2){
	 displaySeconds = string_insert("0",displaySeconds, 0);
}
if (showTracker) {

// draw hidden stuff first y value will be changed if clicked on
draw_set_halign(fa_left);
draw_set_colour(global.colorThemeBG);
draw_rectangle(camera_get_view_width(view_camera[0]) - Xdistance, camera_get_view_height(view_camera[0]) - Ydistance  - currentYheight, camera_get_view_width(view_camera[0]), camera_get_view_height(view_camera[0]), false);
draw_set_colour(global.colorThemeBorders);
draw_rectangle(camera_get_view_width(view_camera[0]) - Xdistance, camera_get_view_height(view_camera[0]) - Ydistance  - currentYheight, camera_get_view_width(view_camera[0]), camera_get_view_height(view_camera[0]), true);

// move counter text
draw_set_font(fnt_panelTab);
draw_set_color(global.colorThemeText);
draw_text(camera_get_view_width(view_camera[0]) - Xdistance + 5, camera_get_view_height(view_camera[0]) - currentYheightCounterText, "Move Counter: "+ string(obj_control.moveCounter) +"");
	
// timer text
draw_set_font(fnt_panelTab);
draw_set_color(global.colorThemeText);
draw_text(camera_get_view_width(view_camera[0]) - Xdistance + 5, camera_get_view_height(view_camera[0]) - currentYheightTimerText, "Time Taken: "+ displayMinutes + ":"+ displaySeconds );
	

// reset button
draw_set_halign(fa_left);
draw_set_colour(global.colorThemeBG);
draw_rectangle(camera_get_view_width(view_camera[0]) - resetX1val, camera_get_view_height(view_camera[0]) - currentResetY1value, camera_get_view_width(view_camera[0]) - resetX2val, camera_get_view_height(view_camera[0]) - currentResetY2value, false);
draw_set_colour(global.colorThemeBorders);
draw_rectangle(camera_get_view_width(view_camera[0]) - resetX1val, camera_get_view_height(view_camera[0]) - currentResetY1value, camera_get_view_width(view_camera[0]) - resetX2val, camera_get_view_height(view_camera[0]) - currentResetY2value, true);

// reset text
draw_set_font(fnt_mainBold);
draw_set_color(global.colorThemeText);
draw_text(camera_get_view_width(view_camera[0]) - resetX1val + 7, camera_get_view_height(view_camera[0]) - currentYheightResetText, "RESET");
	


//now draw reztracker box
draw_set_halign(fa_left);

if (isTrackerOpen) {
	draw_set_colour(global.colorThemeText);
}
else {
	draw_set_colour(global.colorThemePaneBG);
}
draw_rectangle(camera_get_view_width(view_camera[0]) - Xdistance, camera_get_view_height(view_camera[0]) - Ydistance, camera_get_view_width(view_camera[0]), camera_get_view_height(view_camera[0]), false);
draw_set_colour(global.colorThemeBorders);
draw_rectangle(camera_get_view_width(view_camera[0]) - Xdistance, camera_get_view_height(view_camera[0]) - Ydistance, camera_get_view_width(view_camera[0]), camera_get_view_height(view_camera[0]), true);


draw_set_font(fnt_mainBold);

if (isTrackerOpen) {
	draw_set_colour(global.colorThemeBG);
}
else {
	draw_set_colour(global.colorThemeText);
}
draw_text(camera_get_view_width(view_camera[0]) - Xdistance + 5, camera_get_view_height(view_camera[0]) - Ydistance +15, "Rez Tracker");
	




// Check for mouse location over "RezTracker" button and check for open/close button
if (point_in_rectangle(mouse_x, mouse_y, camera_get_view_width(view_camera[0]) - Xdistance, camera_get_view_height(view_camera[0]) - Ydistance, camera_get_view_width(view_camera[0]), camera_get_view_height(view_camera[0])) and mouse_check_button_pressed(mb_left)) {
	isTrackerOpen = !isTrackerOpen ;
}


// bring up background interface
if (isTrackerOpen) {
	// Slide background up
	if (currentYheight < newYheight) {
		currentYheight += 10;
	}
	
	//slide in the move counter text
	if (currentYheightCounterText < newYheightText1) {
		if (currentYheightCounterText < newYheightText1 - Yheightbuffer) {
			currentYheightCounterText += 10;
		}
		else {
			currentYheightCounterText += 1;
		}
	}
		
	//slide out the timer text
	if (currentYheightTimerText < newYheightText2) {
		if (currentYheightTimerText < newYheightText2 - Yheightbuffer) {
			currentYheightTimerText += 10;
		}
		else {
			currentYheightTimerText += 1;
		}
	}
	
	//slide out the reset text
	if (currentYheightResetText < newYheightText3) {
		if (currentYheightResetText < newYheightText3 - Yheightbuffer) {
			currentYheightResetText += 10;
		}
		else {
			currentYheightResetText += 1;
		}
	}
		//slide out the reset box height val 1
	if (currentResetY1value < resetY1val) {
		if (currentResetY1value < resetY1val - Yheightbuffer) {
			currentResetY1value += 12;
		}
		else {
			currentResetY1value += 1;
		}
	}
			//slide out the reset box height val 2
	if (currentResetY2value < resetY2val) {
		if (currentResetY2value < resetY2val - Yheightbuffer) {
			currentResetY2value += 8;
		}
		else {
			currentResetY2value += 1;
		}
	}
	
	
	//check for reset button pressed
	if (point_in_rectangle(mouse_x, mouse_y, camera_get_view_width(view_camera[0]) - resetX1val, camera_get_view_height(view_camera[0]) - resetY1val, camera_get_view_width(view_camera[0]) - resetX2val, camera_get_view_height(view_camera[0]) - resetY2val) and mouse_check_button_pressed(mb_left)) {
		obj_control.moveCounter = 0;
		alarm[5] = -1;
		timerMins = 0;
		timerSecs = 0;
		alarm[5] = 60;
	}
}

//slide interface back down
else {
	// move outside borders
	if (currentYheight > oldYheight) {
		currentYheight -= 10;
	}
	
	//slide out the move counter text
	if (currentYheightCounterText > oldYheight) {
		currentYheightCounterText -= 10;
	}
	
	//slide out the timer text
	if (currentYheightTimerText > oldYheight) {
		currentYheightTimerText -= 10;
	}
	
	
	//slide out the reset text
	if (currentYheightResetText > oldYheight) {
		currentYheightResetText -= 10;
	}
	
	//slide out the reset box height val 1
	if (currentResetY1value > oldYheight) {
			currentResetY1value -= 12;
	}
	
	//slide out the reset box height val 2
	if (currentResetY2value > oldYheight) {
			currentResetY2value -= 8;
	}

}


}