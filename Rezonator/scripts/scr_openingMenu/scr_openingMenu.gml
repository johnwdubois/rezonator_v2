function scr_openingMenu() {
	/*
		scr_openingMenu();
	
		Last Updated: 2020-01-23
	
		Called from: obj_openingScreen
	
		Purpose: Display the opening menu UI to the user
	
		Mechanism: Display a multitude of buttons and track the user's clicks
	*/

	

	scr_fontSizeControlOpeningScreen();

	//Work in here to set the new menu buttons
	draw_set_font(global.fontMain);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);

	var buttonWidth = max(camera_get_view_width(camera_get_active()) * 0.15, string_width("Play and Learn  "));
	var buttonHeight = 65;
	var middleBuffer = 115;
	var verticalYSpacing = 50;




	// open rez selection
	var openProjectButtonX1 = (camera_get_view_width(camera_get_active()) / 2) - (buttonWidth / 2); 
	var openProjectButtonY1 = camera_get_view_height(camera_get_active()) * 0.40;
	var openProjectButtonX2 = openProjectButtonX1 + buttonWidth;
	var openProjectButtonY2 = openProjectButtonY1 + buttonHeight;

	if (point_in_rectangle(mouse_x, mouse_y, openProjectButtonX1, openProjectButtonY1, openProjectButtonX2, openProjectButtonY2))
	{
		draw_set_color(global.colorThemeSelected1);
		draw_rectangle(openProjectButtonX1, openProjectButtonY1, openProjectButtonX2, openProjectButtonY2, false);
	
		if (device_mouse_check_button_released(0, mb_left))
		{
			global.newProject = false;
			global.openProject = true;
		}
	}

	draw_set_color(global.colorThemeBorders);
	draw_rectangle(openProjectButtonX1, openProjectButtonY1, openProjectButtonX2, openProjectButtonY2, true);
	draw_set_color(global.colorThemeText);
	draw_text(mean(openProjectButtonX1, openProjectButtonX2), mean(openProjectButtonY1, openProjectButtonY2), scr_get_translation("help_label_open"));



	// import new file selection
	var newProjectButtonX1 = (camera_get_view_width(camera_get_active()) / 2) - (buttonWidth / 2);
	var newProjectButtonY1 = openProjectButtonY2 + verticalYSpacing;
	var newProjectButtonX2 = newProjectButtonX1 + buttonWidth;
	var newProjectButtonY2 = newProjectButtonY1 + buttonHeight;

	if (point_in_rectangle(mouse_x, mouse_y, newProjectButtonX1, newProjectButtonY1, newProjectButtonX2, newProjectButtonY2))
	{
		draw_set_color(global.colorThemeSelected1);
		draw_rectangle(newProjectButtonX1, newProjectButtonY1, newProjectButtonX2, newProjectButtonY2, false);
	
		if (device_mouse_check_button_released(0, mb_left))
		{
			global.newProject = true;
			global.openProject = false;
		}
	}

	draw_set_color(global.colorThemeBorders);
	draw_rectangle(newProjectButtonX1, newProjectButtonY1, newProjectButtonX2, newProjectButtonY2, true);
	draw_set_color(global.colorThemeText);
	draw_text(mean(newProjectButtonX1, newProjectButtonX2), mean(newProjectButtonY1, newProjectButtonY2), scr_get_translation("menu_import"));






	//play and learn selection
	var wheresElmoButtonX1 = (camera_get_view_width(camera_get_active()) / 2) - (buttonWidth / 2);
	var wheresElmoButtonY1 = newProjectButtonY2 + verticalYSpacing;
	var wheresElmoButtonX2 = (camera_get_view_width(camera_get_active()) / 2) + (buttonWidth / 2);
	var wheresElmoButtonY2 = wheresElmoButtonY1 + buttonHeight;

	if (point_in_rectangle(mouse_x, mouse_y, wheresElmoButtonX1, wheresElmoButtonY1, wheresElmoButtonX2, wheresElmoButtonY2))
	{
		draw_set_color(global.colorThemeSelected1);
		draw_rectangle(wheresElmoButtonX1, wheresElmoButtonY1, wheresElmoButtonX2, wheresElmoButtonY2, false);
	
		if (device_mouse_check_button_released(0, mb_left))
		{
			global.menuOpen = false;
			global.newProject = false;
			global.openProject = true;
			global.games = true;
			global.rezzles = false;
			global.wheresElmo = true;
			global.tutorial = false;

		}
	}

	draw_set_color(global.colorThemeBorders);
	draw_rectangle(wheresElmoButtonX1, wheresElmoButtonY1, wheresElmoButtonX2, wheresElmoButtonY2, true);
	draw_set_color(global.colorThemeText);
	draw_text(mean(wheresElmoButtonX1, wheresElmoButtonX2), mean(wheresElmoButtonY1, wheresElmoButtonY2), scr_get_translation("menu_play-learn"));




	/*
	var rezzlesButtonX1 = openProjectButtonX1
	var rezzlesButtonY1 = openProjectButtonY2 + 70;
	var rezzlesButtonX2 = openProjectButtonX2;
	var rezzlesButtonY2 = rezzlesButtonY1 + buttonHeight;

	if (point_in_rectangle(mouse_x, mouse_y, rezzlesButtonX1, rezzlesButtonY1, rezzlesButtonX2, rezzlesButtonY2))
	{
		draw_set_color(global.colorThemeSelected1);
		draw_rectangle(rezzlesButtonX1, rezzlesButtonY1, rezzlesButtonX2, rezzlesButtonY2, false);
	
		if (device_mouse_check_button_released(0, mb_left))
		{
			global.menuOpen = false;
			global.newProject = false;
			global.openProject = true;
			global.games = true;

			global.rezzles = true;
			global.wheresElmo = false;
			global.tutorial = false;
	

		}
	}

	draw_set_color(global.colorThemeBorders);
	draw_rectangle(rezzlesButtonX1, rezzlesButtonY1, rezzlesButtonX2, rezzlesButtonY2, true);
	draw_set_color(global.colorThemeText);
	draw_text(mean(rezzlesButtonX1, rezzlesButtonX2), mean(rezzlesButtonY1, rezzlesButtonY2), "Rezzles");



	//tutorial button


	var openTutorialButtonX1 = (camera_get_view_width(camera_get_active()) / 2) - (buttonWidth / 2);
	var openTutorialButtonY1 = rezzlesButtonY2 + 70;
	var openTutorialButtonX2 = openTutorialButtonX1 + buttonWidth;
	var openTutorialButtonY2 = openTutorialButtonY1 + buttonHeight;
	/*
	if (point_in_rectangle(mouse_x, mouse_y, openTutorialButtonX1, openTutorialButtonY1, openTutorialButtonX2, openTutorialButtonY2))
	{
		draw_set_color(global.colorThemeSelected1);
		draw_rectangle(openTutorialButtonX1, openTutorialButtonY1, openTutorialButtonX2, openTutorialButtonY2, false);
	
		if (device_mouse_check_button_released(0, mb_left))
		{
			global.menuOpen = false;
			global.newProject = false;
			global.openProject = true;
			global.tutorial = true;
			global.rezzles = false;
			global.wheresElmo = false;
		}
	}




	draw_set_color(global.colorThemeBorders);
	draw_rectangle(openTutorialButtonX1, openTutorialButtonY1, openTutorialButtonX2, openTutorialButtonY2, true);
	draw_set_color(global.colorThemeText);
	draw_text(mean(openTutorialButtonX1, openTutorialButtonX2), mean(openTutorialButtonY1, openTutorialButtonY2), "Tutorial");

	*/


	var signInXBuffer = 20;
	var signInYBuffer = 25;

	var userSignInBoxX1 = camera_get_view_width(camera_get_active()) - 250 - signInXBuffer;
	var userSignInBoxY1 = signInYBuffer;
	var userSignInBoxX2 = userSignInBoxX1 + 250;
	var userSignInBoxY2 = userSignInBoxY1 + 30;
	/*
	var userSignInBoxX1 = openTutorialButtonX1
	var userSignInBoxY1 = openTutorialButtonY2 + 50;
	var userSignInBoxX2 = openTutorialButtonX2;
	var userSignInBoxY2 = userSignInBoxY1 + 30;
	*/


	draw_set_color(global.colorThemeBorders);
	draw_rectangle(userSignInBoxX1, userSignInBoxY1, userSignInBoxX2, userSignInBoxY2, true);
	draw_set_color(global.colorThemeText);


	draw_set_font(fnt_main);
	draw_text(mean(userSignInBoxX1, userSignInBoxX2)+10, userSignInBoxY2 + 18, scr_get_translation("menu_remember"));

	draw_set_font(fnt_main);
	draw_set_alpha(0.5);

	if(string_length(obj_openingScreen.inputText) > 0 ){
		obj_openingScreen.clickedIn = true;
	}

	if(string_length(obj_openingScreen.inputText) == 0 and obj_openingScreen.clickedIn == false){
		//draw_text(mean(userSignInBoxX1, userSignInBoxX2), mean(userSignInBoxY1, userSignInBoxY2), scr_get_translation("menu_signin"));
		draw_text(mean(userSignInBoxX1, userSignInBoxX2), mean(userSignInBoxY1, userSignInBoxY2), scr_get_translation("menu_signin"));
	}
	draw_set_alpha(1);

	var remeberMeBoxX1 = mean(userSignInBoxX1, userSignInBoxX2)-95;
	var remeberMeBoxY1 = userSignInBoxY2 + 5;
	var remeberMeBoxX2 = mean(userSignInBoxX1, userSignInBoxX2)-75;
	var remeberMeBoxY2 = userSignInBoxY2 + 25;


		draw_rectangle(remeberMeBoxX1, remeberMeBoxY1, remeberMeBoxX2,remeberMeBoxY2, true);
		if (global.rememberMe) {
			draw_rectangle(remeberMeBoxX1, remeberMeBoxY1, remeberMeBoxX2, remeberMeBoxY2, false);	
		}

		if (point_in_rectangle(mouse_x, mouse_y,userSignInBoxX1, userSignInBoxY1, userSignInBoxX2, userSignInBoxY2)){
				if (device_mouse_check_button_released(0, mb_left)) {
					obj_openingScreen.clickedIn = true;
				}
		}

		// current chain boolean switch
		else if (point_in_rectangle(mouse_x, mouse_y,remeberMeBoxX1, remeberMeBoxY1, remeberMeBoxX2, remeberMeBoxY2)){
				if (device_mouse_check_button_released(0, mb_left)) {
					global.rememberMe = !global.rememberMe;	
				}
		}
		else {
			if (device_mouse_check_button_released(0, mb_left)) {
				obj_openingScreen.clickedIn = false;
			}
		}
	


	draw_set_alpha(1);
	draw_set_font(global.fontMain);
	var documentationStr = scr_get_translation("msg_open_docs");
	var documentationButtonX1 = 20;
	var documentationButtonY1 = 20;
	var documentationButtonX2 = documentationButtonX1 + 50;
	var documentationButtonY2 = documentationButtonY1 + 50;
	var mouseoverDocumenation = point_in_rectangle(mouse_x, mouse_y, documentationButtonX1, documentationButtonY1, documentationButtonX2, documentationButtonY2);

	draw_sprite_ext(spr_helpToggle, mouseoverDocumenation, mean(documentationButtonX1, documentationButtonX2), mean(documentationButtonY1, documentationButtonY2), 1, 1, 0, c_white, 1);
	draw_set_color(mouseoverDocumenation ? global.colorThemeSelected1 : global.colorThemeBG);
	//draw_rectangle(documentationButtonX1, documentationButtonY1, documentationButtonX2, documentationButtonY2, false);
	draw_set_color(global.colorThemeBorders);
	//draw_rectangle(documentationButtonX1, documentationButtonY1, documentationButtonX2, documentationButtonY2, true);
	draw_set_halign(fa_left);
	draw_set_valign(fa_middle);
	draw_set_color(global.colorThemeText);
	//draw_text(documentationButtonX1, floor(mean(documentationButtonY1, documentationButtonY2)), documentationStr);

	if (mouseoverDocumenation && documentationButtonActive) {
		draw_text(documentationButtonX2 + 5, floor(mean(documentationButtonY1, documentationButtonY2)), documentationStr);
		if(mouse_check_button_released(mb_left)){
			scr_openURL("https://rezonator.com/documentation/");
		}
	}




	if(global.menuOpen){
		//code for keyboard input into user sign in
		// Variables
		var ctext = "";
		// Clipboard
		if(keyboard_check(vk_control) && keyboard_check(ord("V")) && clipboard_has_text()) {
			ctext = clipboard_get_text();
		}
		if(ctext!="" && (keyboard_check_pressed(ord("V")) || keyboard_check_pressed(vk_control))) { 
			obj_openingScreen.inputText = string_insert(ctext, obj_openingScreen.inputText, obj_openingScreen.cursorPos);
			obj_openingScreen.cursorPos += string_length(ctext);
		}

		// Backspace
		if (keyboard_check(vk_backspace)) {
			obj_openingScreen.cursorViz = true;
			if(canDelete){
				obj_openingScreen.inputText = string_delete(obj_openingScreen.inputText, obj_openingScreen.cursorPos-1, 1);
				if (obj_openingScreen.cursorPos >=2) {
					obj_openingScreen.cursorPos--;
				}
				else {
					obj_openingScreen.cursorPos = 2;
				}
				canDelete = false;
			}
			canDeleteHoldingCounter++
			if(canDeleteHoldingCounter == holdingLimit){
				canDelete = true;
				loopItterations ++;
				canDeleteHoldingCounter = 0;
			}
			if(string_length(obj_openingScreen.inputText) == 0 ){
				obj_openingScreen.clickedIn = false;
			}
		}
		if (keyboard_check_released(vk_backspace)) {
		loopItterations = 0;
		canDeleteHoldingCounter = 0;
		canDelete = true;
		}
	
		if (global.menuOpen  && keyboard_string != "-" && keyboard_string != "+" && string_length(obj_openingScreen.inputText) < 30 ) {
			//show_message(keyboard_string);
			var t = keyboard_string;
			obj_openingScreen.inputText = string_insert(t, obj_openingScreen.inputText, obj_openingScreen.cursorPos);
			obj_openingScreen.cursorPos += string_length(t);
			keyboard_string = "";
			obj_openingScreen.cursorViz = true;
			obj_openingScreen.cursorTimer = 20;
		}

		// Cursor
		if(keyboard_check(vk_left)) {
			obj_openingScreen.cursorViz = true;
			if(canPressLeft){
				if (obj_openingScreen.cursorPos >=2) {
					obj_openingScreen.cursorPos--;
				}
				else {
					obj_openingScreen.cursorPos = 1;
				}
				canPressLeft = false;
			}
			canPressLeftHoldingCounter ++;
			if(canPressLeftHoldingCounter == holdingLimit){
				canPressLeft = true;
				loopItterations ++;
				canPressLeftHoldingCounter = 0;
			}
		}
		if (keyboard_check_released(vk_left)) {
		loopItterations = 0;
		canPressLeftHoldingCounter = 0;
		canPressLeft = true;
		}
	
		if(keyboard_check(vk_right)) {
			obj_openingScreen.cursorViz = true;
			if(canPressRight){
				if (obj_openingScreen.cursorPos <= string_length(obj_openingScreen.inputText) + 1 && obj_openingScreen.cursorPos >=1){
					//show_message("buh");
					obj_openingScreen.cursorPos++;
				}
				else {
					obj_openingScreen.cursorPos = string_length(obj_openingScreen.inputText) +1;
				}
						
				canPressRight = false;
			}
				canPressRightHoldingCounter ++;
			if(canPressRightHoldingCounter == holdingLimit){
				canPressRight = true;
				loopItterations ++;
				canPressRightHoldingCounter = 0;
			}
		}
		if (keyboard_check_released(vk_right)) {
		loopItterations = 0;
		canPressRightHoldingCounter = 0;
		canPressRight = true;
		}
	
	

		clamp(obj_openingScreen.cursorPos, 1, string_length(obj_openingScreen.inputText));

		displayText = obj_openingScreen.inputText;
		if(string_width(obj_openingScreen.inputText) > obj_openingScreen.maxDisplaySize){
			displayText = string_copy(obj_openingScreen.inputText, (string_length(obj_openingScreen.inputText) - maxDisplaySize), string_length(obj_openingScreen.inputText) );
		}

		if (obj_openingScreen.cursorTimer >=0){
			obj_openingScreen.cursorTimer --;
		}
		else{
			obj_openingScreen.cursorViz = !obj_openingScreen.cursorViz;
			obj_openingScreen.cursorTimer =30;
		}



		if(obj_openingScreen.cursorViz and obj_openingScreen.clickedIn == true){
			displayText = string_insert("|", displayText, obj_openingScreen.cursorPos);
		}
		else{
			displayText = string_delete(displayText, obj_openingScreen.cursorPos, 0);
		}

		draw_set_halign(fa_middle);
		draw_text(mean(userSignInBoxX1, userSignInBoxX2), mean(userSignInBoxY1,userSignInBoxY2) , displayText);
	
		global.userName = obj_openingScreen.inputText;
	}

	//draw_set_font(fnt_mainBoldLarge2);
	//draw_text((camera_get_view_width(camera_get_active()) / 2) , wheresElmoButtonY1 - 25 ,scr_get_translation("msg_games"));
	//draw_text((camera_get_view_width(camera_get_active()) / 2) , newProjectButtonY1 - 25 ,scr_get_translation("msg_research"));
	//draw_text((camera_get_view_width(camera_get_active()) / 2) , openTutorialButtonY1 - 25 ,scr_get_translation("msg_tutorial"));



}
