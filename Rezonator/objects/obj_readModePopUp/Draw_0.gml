/// @description Insert description here
// You can write your code in this editor

//popUpText1 = string_hash_to_newline("You are in Read Mode.# To mark up the #discourse data, choose #either Track Mode or #Rez mode.");
//rectX1 = camera_get_view_width(camera_get_active()) - 245;
//rectY1 = obj_menuBar.menuHeight + obj_toolPane.windowHeight + 50;
//rectX2 = camera_get_view_width(camera_get_active()) - 45;
//rectY2 = 180 + rectY1;//
scr_adaptFont(popUpText1,"L");
rectX2 = rectX1 + 60 + string_width("Track mode (to mark coreference between mentions)");
rectY2 = 40 + rectY1 + string_height(popUpText2) + (string_height(popUpText1) * 2);
var bubblePlus = obj_control.wordDrawGridFocusedAnimation;
draw_set_colour(global.colorThemeBG);
draw_roundrect(rectX1 - bubblePlus, rectY1 - bubblePlus, rectX2 + bubblePlus, rectY2 + bubblePlus, false);

draw_set_colour(global.colorThemeBorders);
draw_roundrect(rectX1 - bubblePlus, rectY1 - bubblePlus, rectX2 + bubblePlus, rectY2 + bubblePlus, true);

	

draw_set_halign(fa_center);
draw_text(floor(mean(rectX1,  rectX2)), floor(20 + rectY1), popUpText1);
draw_line_width(rectX1 + 30, 35 + rectY1,  rectX2 - 30, 35 + rectY1, 3);
	
	
scr_adaptFont(popUpText2,"M");
draw_text( floor(mean(rectX1, rectX2)), floor(mean(rectY1 + 20, rectY2)), popUpText2);

var largeHeight = string_height(popUpText1);

var standardHeight = string_height(popUpText1);
var spriteRatio = largeHeight/standardHeight;
var spriteSize = 0.25 * spriteRatio;

draw_sprite_ext(spr_toolsNew, 8, rectX1 + 15, mean(rectY1 + 45, rectY2), spriteSize, spriteSize, 0, c_white, 1); 
draw_sprite_ext(spr_toolsNew, 5, rectX1 + 40, mean(rectY1 + 45, rectY2) + largeHeight, spriteSize, spriteSize, 0, c_white, 1); 

//draw_sprite_ext(spr_backArrow, 0, camera_get_view_width(camera_get_active()) - 150, obj_menuBar.menuHeight + obj_toolPane.windowHeight - 24 + (bubblePlus * 3), 2.5, 2.5, 270, global.colorThemeBorders, 1); 
//draw_sprite_ext(spr_backArrow, 0, camera_get_view_width(camera_get_active()) - 60, obj_menuBar.menuHeight + obj_toolPane.windowHeight - 24 + (3* bubblePlus), 2.5, 2.5, 270, global.colorThemeBorders, 1); 
//var c_rez = c_maroon;//make_color_rgb(193, 130, 93);
//draw_sprite_ext(spr_linkArrow, 0, camera_get_view_width(camera_get_active()) - 150, obj_menuBar.menuHeight + obj_toolPane.windowHeight - 41 + (bubblePlus * 3), 1, 1, 90, c_rez, 0.85); 
//draw_sprite_ext(spr_linkArrow, 0, camera_get_view_width(camera_get_active()) - 60, obj_menuBar.menuHeight + obj_toolPane.windowHeight - 41 + (3* bubblePlus), 1, 1, 90, c_rez, 0.85); 


draw_set_colour(global.colorThemeText);
scr_adaptFont(scr_get_translation("msg_no-show"), "S");
draw_text(floor(mean(rectX1, rectX2)), floor(rectY2 - largeHeight + 10), scr_get_translation("msg_no-show"));



var buttonX1 = floor(mean(rectX1, rectX2) - (string_width("Don't show again")/2 + 25));
var buttonY1 = floor(rectY2 - largeHeight);
var buttonX2 = buttonX1 + 20;
var buttonY2 = buttonY1 + 20;
		
draw_rectangle(buttonX1, buttonY1, buttonX2, buttonY2, true);
if (global.readHintHide) {
	draw_rectangle(buttonX1, buttonY1, buttonX2, buttonY2, false);	
}

if (point_in_rectangle(mouse_x, mouse_y, buttonX1, buttonY1, buttonX2, buttonY2)){
				
		draw_set_color(c_white);
		draw_rectangle(mouse_x-35, mouse_y+20,mouse_x+35, mouse_y + 40,false);
		draw_set_colour(global.colorThemeBorders);
		draw_rectangle(mouse_x-35, mouse_y+20,mouse_x+35, mouse_y + 40,true);
			
		if(global.readHintHide){
			draw_set_halign(fa_center);
			//draw_text(floor(mean(mouse_x - 25, mouse_x + 25)), floor(mean(mouse_y + 20,mouse_y + 40)), scr_get_translation("msg_enabled"));
			draw_text(floor(mean(mouse_x - 25, mouse_x + 25)), floor(mean(mouse_y + 20,mouse_y + 40)), "Enabled");
		}
		else{
			draw_set_halign(fa_center);
			//draw_text(floor(mean(mouse_x - 25, mouse_x + 25)), floor(mean(mouse_y + 20,mouse_y + 40)), scr_get_translation("msg_disabled"));
			draw_text(floor(mean(mouse_x - 25, mouse_x + 25)), floor(mean(mouse_y + 20,mouse_y + 40)), "disabled");
		}
		if (mouse_check_button_pressed(mb_left)) {
			global.readHintHide = !global.readHintHide;
		}
}