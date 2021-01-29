function scr_panelPane_drawTracker() {

	/*
		scr_panelPane_drawTracker();
	
		Last Updated: 2019-07-06
	
		Called from: obj_panelPane
	
		Purpose: alllows user to access time taken and moves used information
	
		Mechanism: draws a clickable rectangle that will expand upwards from the bottom corner of the screen
		displaying the movecounter and time taken as well as a reset button.
				
		Author: Brady Moore
	*/
	var yBase = obj_menuBar.menuHeight;
	if(obj_panelPane.showNav) {
		yBase += inst_PanelPane_chainContents.windowHeight;	
	}

	var Xdistance = 120;
	//var Ydistance = 30;
	var newYheight = 80;
	var newYheightText1 = 65;
	var newYheightText2 = 45;
	var newYheightText3 = 20;
	var resetX1val = 80;
	var resetX2val = 20;
	var resetY1val = 30;
	var resetY2val = 10;

	var trackerX2 = camera_get_view_width(camera_get_active()) - global.scrollBarWidth;

	var Yheightbuffer = 10;
	//var oldYheight = 0;

	//convert seconds into displayable seconds
	var displaySeconds = string(timerSecs); 
	var displayMinutes = string(timerMins);

	if(string_length(displaySeconds)<2){
		 displaySeconds = string_insert("0",displaySeconds, 0);
	}
	if (showTracker) {

	
		var mouseOverEndButton = false;
		if (point_in_rectangle(mouse_x, mouse_y,0, yBase, 140, yBase + newYheight) and not instance_exists(obj_dialogueBox)) {
			mouseOverEndButton = true;
			if (device_mouse_check_button_released(0, mb_left)) {
				obj_control.currentStackShowListPosition = ds_list_size(obj_control.stackShowList)-1;
				scr_stackShow();
			}
		}

		//draw end show button
		if(mouseOverEndButton) {
			// Draw the button as grey is being hovered over
			draw_set_alpha(1);
			draw_set_colour(c_gray);
		}
		else {
			draw_set_colour(global.colorThemePaneBG);
		}
		draw_rectangle(0, yBase, 140, yBase+ newYheight, false);
		draw_set_alpha(1);
		draw_set_colour(global.colorThemeBorders);
		draw_rectangle(0, yBase, 140, yBase + newYheight, true);

		//draw end show text

		draw_set_halign(fa_left);
		draw_set_colour(global.colorThemeText);
		scr_adaptFont(scr_get_translation("msg_end_stackshow"), "L");
		draw_text(0 + 5, yBase + (newYheight/2), scr_get_translation("msg_end_stackshow"));

		var nameOfStack = "";
		var colorOfStack = 0;
		var captionOfStack = "";

		var currentListChainID = ds_list_find_value(obj_control.stackShowList, obj_control.currentStackShowListPosition);
		var chainSubMap = ds_map_find_value(global.nodeMap, currentListChainID);
		if(is_numeric(chainSubMap)){
			if(ds_exists(chainSubMap,ds_type_map)){
				nameOfStack = ds_map_find_value(chainSubMap, "chainName");
				colorOfStack = ds_map_find_value(chainSubMap, "chainColor");
				captionOfStack = ds_map_find_value(chainSubMap, "caption");
			}
		}

		var chainNameRectX1 = 140, 
		chainNameRectY1 = yBase, 
		chainNameRectX2 = 300, 
		chainNameRectY2 = yBase + newYheight;
		
		//draw stack name background
		if(colorOfStack == undefined){
			draw_set_colour(global.colorThemeBG);
		}
		else{
		draw_set_color(merge_color(colorOfStack, global.colorThemeBG, 0.65));
		}
		draw_rectangle( chainNameRectX1, chainNameRectY1, chainNameRectX2, chainNameRectY2, false);
		draw_set_colour(global.colorThemeBorders);
		draw_rectangle( chainNameRectX1, chainNameRectY1, chainNameRectX2, chainNameRectY2, true);

		//draw stack name text
		draw_set_halign(fa_left);
		draw_set_colour(global.colorThemeText);
		if(nameOfStack == undefined) {
			nameOfStack = "";	
		}
		scr_adaptFont(nameOfStack, "M");
		draw_text(chainNameRectX1 + 5, yBase + (newYheight/2), nameOfStack);

		var chainCaptionRectX1 = chainNameRectX2, 
		chainCaptionRectY1 = yBase, 
		chainCaptionRectX2 = trackerX2 - Xdistance, 
		chainCaptionRectY2 = yBase + newYheight;

		//draw stack description background
		draw_set_colour(global.colorThemePaneBG);
		draw_rectangle(chainCaptionRectX1, chainCaptionRectY1, chainCaptionRectX2, chainCaptionRectY2, false);
		draw_set_colour(global.colorThemeBorders);
		draw_rectangle(chainCaptionRectX1, chainCaptionRectY1, chainCaptionRectX2, chainCaptionRectY2, true);

	
		//draw stack caption text
		draw_set_halign(fa_left);
		draw_set_colour(global.colorThemeText);
		if(captionOfStack == undefined) {
			captionOfStack = "";	
		}
		scr_adaptFont(captionOfStack, "M");
		draw_text((chainCaptionRectX1 + chainNameRectX1 + 180)/2, yBase + (newYheight/2), captionOfStack);


	
		var mouseOverLeftButton = false;
		if (point_in_rectangle(mouse_x, mouse_y,trackerX2 - Xdistance - 80, yBase, trackerX2 - Xdistance - 40, yBase + newYheight) and not instance_exists(obj_dialogueBox)) {
			mouseOverLeftButton = true;
			if (device_mouse_check_button_released(0, mb_left)) {
				obj_control.stackShowBackwards = true;

				if(obj_control.currentStackShowListPosition > 0){
						scr_stackShow();
				}


			}
		}
		obj_control.stackShowBackwards = false;
		var mouseOverRightButton = false;
		if (point_in_rectangle(mouse_x, mouse_y,trackerX2 - Xdistance - 40, yBase, trackerX2 - Xdistance, yBase + newYheight) and not instance_exists(obj_dialogueBox)) {
			mouseOverRightButton = true;
			if (device_mouse_check_button_released(0, mb_left)) {
				/*
				if(obj_control.currentStackShowListPosition < ds_list_size(obj_control.stackShowList)){
					obj_control.currentStackShowListPosition += 1;
				}
				*/
				scr_stackShow();
			}
		}



		//draw selection arrow background left
		if(mouseOverLeftButton){
				draw_set_colour(c_gray);
		}
		else{
				draw_set_colour(global.colorThemePaneBG);
		}
		draw_rectangle( trackerX2 - Xdistance - 80, yBase, trackerX2 - Xdistance - 40, yBase + newYheight, false);
		draw_set_colour(global.colorThemeBorders);
		draw_rectangle( trackerX2 - Xdistance - 80, yBase, trackerX2 - Xdistance - 40, yBase + newYheight, true);

		//draw selection arrow background right
		if(mouseOverRightButton){
				draw_set_colour(c_gray);
		}
		else{
				draw_set_colour(global.colorThemePaneBG);
		}
		draw_rectangle( trackerX2 - Xdistance - 40, yBase, trackerX2 - Xdistance, yBase + newYheight, false);
		draw_set_colour(global.colorThemeBorders);
		draw_rectangle( trackerX2 - Xdistance - 40, yBase, trackerX2 - Xdistance, yBase + newYheight, true);

			draw_sprite_ext(spr_ascend, 0, trackerX2 - Xdistance - 60, yBase + (newYheight/2), 1, 1, 90, c_white, 1);
			draw_sprite_ext(spr_ascend, 0, trackerX2 - Xdistance - 20, yBase + (newYheight/2), 1, 1, 270, c_white, 1);

	}

	
		draw_set_alpha(1);
		draw_set_halign(fa_left);
		draw_set_colour(global.colorThemeBG);
		draw_rectangle(trackerX2 - Xdistance, yBase, trackerX2, yBase  + newYheight, false);
		draw_set_colour(global.colorThemeBorders);
		draw_rectangle(trackerX2 - Xdistance, yBase, trackerX2, yBase  + newYheight, true);

		// move counter text
		draw_set_color(global.colorThemeText);
		scr_adaptFont(scr_get_translation("msg_move_counter"),"S");
		draw_text(trackerX2 - Xdistance + 5, yBase + currentYheightCounterText, scr_get_translation("msg_move_counter")+ string(obj_control.moveCounter) +"");
	
		// timer text
		draw_set_color(global.colorThemeText);
		draw_text(trackerX2 - Xdistance + 5, yBase + currentYheightTimerText, scr_get_translation("msg_time_taken")+ displayMinutes + ":"+ displaySeconds );
	

		// reset button
		var mouseOverResetButton = false;
		if (point_in_rectangle(mouse_x, mouse_y, trackerX2 - resetX1val, yBase + currentResetY1value, trackerX2 - resetX2val, yBase + currentResetY2value)) {
			mouseOverResetButton = true;
			//check for reset button pressed
			if ( device_mouse_check_button_released(0, mb_left)) {
				obj_control.moveCounter = 0;
				alarm[5] = -1;
				timerMins = 0;
				timerSecs = 0;
				alarm[5] = 60;
			}
		}
	
		draw_set_halign(fa_left);
		draw_set_colour(global.colorThemeBG);
		if(mouseOverResetButton) {
			draw_set_colour(c_gray);	
		}
		draw_rectangle(trackerX2 - resetX1val, yBase + currentResetY1value, trackerX2 - resetX2val, yBase + currentResetY2value, false);
		draw_set_colour(global.colorThemeBorders);
		draw_rectangle(trackerX2 - resetX1val, yBase + currentResetY1value, trackerX2 - resetX2val, yBase + currentResetY2value, true);

		// reset text
		draw_set_color(global.colorThemeText);
		scr_adaptFont(scr_get_translation("label_reset"), "L");
		draw_text(trackerX2 - resetX1val + 7, yBase + currentYheightResetText, scr_get_translation("label_reset"));

	


		//now draw reztracker box
		draw_set_halign(fa_left);
		draw_set_alpha(1);

		draw_set_colour(global.colorThemePaneBG);
	
		

		// bring up background interface
		//if (isTrackerOpen) {
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
	
	
		
		//}

		/*//slide interface back down
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

		}*/


}
