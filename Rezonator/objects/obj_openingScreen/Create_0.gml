/*
	obj_openingScreen: Create
	
	Last Updated: 2019-02-11
	
	Called from: The creation of the openingScreen object
	
	Purpose: Instantiate all variables used by the openingScreen object
	
	Mechanism: variable creation and assignment
	
	Author: Terry DuBois
*/

scr_colorThemeGridInit();

global.fileLineRipList = ds_list_create();

global.fileLineRipGripWidth = 6;
global.fileLineRipGrid_colDiscoID = 0;
global.fileLineRipGrid_colFileLineRipList = 1;
global.fileLineRipGrid_colUnitAmount = 2;
global.fileLineRipGrid_colParticipantList = 3;
global.fileLineRipGrid_colColorList = 4;
global.fileLineRipGrid_colParticipantIDList = 5;
global.fileLineRipGrid = ds_grid_create(global.fileLineRipGripWidth, 0);

global.totalUnitAmount = 0;

global.participantColorList = ds_list_create();

global.wordGridWidth = 7;
global.dynamicWordGridWidth = 14;
global.unitGridWidth = 9;

global.openProject = false;
global.newProject = false;
global.menuOpen = true;
global.neworOpen = false;
global.tutorial = false;


global.fileSaveName = "undefined";
global.stackGrabSave = false;

wordAmountList = ds_list_create();

lineTotal = 0;
wordTotal = 0;
wordsToLoad = 0;

windowWidth = (room_width * 0.6);
windowHeight = (room_height * 0.6);
windowX1 = (room_width * 0.2);
windowY1 = (room_height * 0.4) - 20;
windowX2 = windowX1 + windowWidth;
windowY2 = windowY1 + windowHeight;


importWindowWidth = camera_get_view_width(view_camera[0]) / 2;
importWindowHeight = camera_get_view_height(view_camera[0]) / 5;
importWindowX1 = camera_get_view_width(view_camera[0]) * 0.25;
importWindowY1 = camera_get_view_height(view_camera[0]) * 0.4;
importWindowX2 = importWindowX1 + importWindowWidth;
importWindowY2 = importWindowY1 + importWindowHeight;

scrollBarHolding = false;
scrollBarHoldingPlusY = 0;
currentTopViewRow = 0;
scrollRange = 6;

//scr_openXML();

//room_goto_next();

canContinue = false;

participantHueOffset = 0;

showDevVars = false;

scr_importPackage();

global.rememberMe = false;

global.importCSVGrid = ds_grid_create(0, 0);
global.importCSVGrid_colIndex = 1;
global.importCSVGrid_colDiscoID = 2;
global.importCSVGrid_colPID = 3;
global.importCSVGrid_colSpeaker = 4;
global.importCSVGrid_colUID = 5;
global.importCSVGrid_colWID = 6;
global.importCSVGrid_colPlace = 7;
global.importCSVGrid_colWord = 10;
global.importCSVGrid_colText = 11;
global.importCSVGrid_colUnitStart = 22;
global.importCSVGrid_colUnitEnd = 23;


//variables for keyboard
cursorPos = 1 ;
cursorViz = false;
inputText = "";
cursorTimer = 20;
global.userName = "";






var userSettingsList = ds_list_create();

if (directory_exists(global.rezonatorDirString)) {
	if (os_type == os_macosx) {
		var filename = global.rezonatorDirString + "/~usersettings.ini";
	}
	else {
		var filename = global.rezonatorDirString + "\\~usersettings.ini";
	}
	
	if (file_exists(filename)) {

		var file = file_text_open_read(filename);
		
		while (!file_text_eof(file)) {
			ds_list_add(userSettingsList, file_text_readln(file));
		}
		
		file_text_close(file);
	}
}


global.iniFileString = scr_getStringOfList(userSettingsList);

if (ds_list_size(userSettingsList) > 1) {
	
	if (string_count("rememberMe:", global.iniFileString) > 0) {
		global.rememberMe = real(scr_getValueFromString(global.iniFileString, "rememberMe:", ","));
	}

	if (global.rememberMe) {
		inputText = scr_getValueFromString(global.iniFileString, "userName:", ",");
		cursorPos = string_length(inputText) + 1;
	}
}

ds_list_destroy(userSettingsList);