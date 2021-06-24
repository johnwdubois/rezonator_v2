function scr_loadREZ() {

	

	var delimiter = (os_type == os_macosx) ? "/" : "\\";
	var RezDirString = global.rezonatorDirString + delimiter + "Data" + delimiter + "SBCorpus" + delimiter + "REZ";

	if (global.previousRezDirectory != "") {
		RezDirString = global.previousRezDirectory;
	
		// trimming the spaces off of RezDirString
		var charAt = string_length(RezDirString);
		while (string_char_at(RezDirString, charAt) == " " and charAt > 0) {
			charAt--;
		}
		RezDirString = string_delete(RezDirString, charAt, string_length(RezDirString) - charAt);
	}







	if (directory_exists(global.rezonatorDirString)) {
		var fileName = get_open_filename_ext("REZ file|*.rez", "", RezDirString, "Open REZ");
	}
	else {
		var fileName = get_open_filename_ext("REZ file|*.rez", "", program_directory, "Open REZ");
	}

	if (fileName == "" or not file_exists(fileName)) {
		room_goto(rm_openingScreen);
		exit;
	}
	else{
		global.previousRezDirectory = filename_path(fileName);
	}
	




	global.fileSaveName = fileName;
	if (filename_path(global.fileSaveName) == global.rezonatorDefaultDiscourseDirString + "\\") {
		global.fileSaveName = "";
	}

	var newInstList = ds_list_create();

	if (file_exists(fileName)) {
		var wrapper = scr_loadJSONBuffer(fileName);
	
		if (not ds_exists(wrapper, ds_type_map)) {
			show_message("Error loading " + fileName);
			room_goto(rm_openingScreen);
			exit;
		}
	
		var list = ds_map_find_value(wrapper, "ROOT");
	
		if (is_undefined(list)) {
			show_message("Error loading " + fileName);
			room_goto(rm_openingScreen);
			exit;
		}
	
		global.openedREZFile = true;
	
	
		var listSize = ds_list_size(list);
		for (var i = 0; i < listSize; i++) {
			var map = ds_list_find_value(list, i);
		
			var objectIndex = ds_map_find_value(map, "objectIndex");
		
		
			with (asset_get_index(objectIndex)) {
				if (objectIndex == "obj_control") {
					obj_control.currentCenterDisplayRow = 0;
			
					global.importGridWidth = ds_map_find_value(map, "importGridWidth");
					global.importCSVGridWidth = ds_map_find_value(map, "importCSVGridWidth");
				
					global.unitDelimField = ds_map_find_value(map, "unitDelimField");
					global.unitImportTurnDelimColName = ds_map_find_value(map, "unitImportTurnDelimColName");
					global.wordImportWordDelimColName = ds_map_find_value(map, "wordImportWordDelimColName");
					global.currentTranslation = ds_map_find_value(map, "currentTranslation");
					global.unitImportSpeakerColName = ds_map_find_value(map, "unitImportSpeakerColName");
					global.unitImportUnitEndColName = ds_map_find_value(map, "unitImportUnitEndColName");
					global.unitImportUnitStartColName = ds_map_find_value(map, "unitImportUnitStartColName");
					global.tokenImportTranscriptColName = ds_map_find_value(map, "tokenImportTranscriptColName");
					global.tokenImportDisplayTokenColName = ds_map_find_value(map, "tokenImportDisplayTokenColName");
					with(obj_panelPane){
						functionChainList_focusedUnit = ds_map_find_value(map, "functionChainList_focusedUnit");
						functionChainList_focusedUnitIndex = ds_map_find_value(map, "functionChainList_focusedUnitIndex");
					}
					
					if(global.tokenImportDisplayTokenColName == undefined ){
						global.tokenImportDisplayTokenColName = "~text";
					}
					
					
					global.translationList = ds_map_find_value(map, "translationList");
				
					global.importGridColNameList = ds_map_find_value(map, "importGridColNameList");
				
					if (ds_map_find_value(map, "showSpeakerName") != undefined) {
						obj_control.showSpeakerName = ds_map_find_value(map, "showParticipantName");
					}
					if (ds_map_find_value(map, "justify") != undefined) {
						obj_control.justify = ds_map_find_value(map, "justify");
					}
					
					if (global.translationList == undefined) {
						global.translationList = ds_list_create();
					}

					global.nodeMap = ds_map_find_value(map, "nodeMap");			
					if (is_undefined(global.nodeMap)) {
						show_debug_message("scr_loadREZ() ... global.nodeMap is undefined");
						global.nodeMap = ds_map_create();
					}
					
					if(!scr_isNumericAndExists( global.nodeMap[?"nodeList"], ds_type_list)){
						var nodeList = ds_list_create();
						ds_map_add_list(global.nodeMap, "nodeList", nodeList);
					}
				
				
					if (is_undefined(global.importGridColNameList)) {
						var tempList3 = ds_list_create();
						global.importGridColNameList = tempList3;
					}
					
					
					// get navTokenFieldList, if supplied
					var navTokenFieldList = ds_map_find_value(map, "navTokenFieldList");
					if (scr_isNumericAndExists(navTokenFieldList, ds_type_list)) {
						ds_list_destroy(obj_control.navTokenFieldList);
						obj_control.navTokenFieldList = navTokenFieldList;
					}
					
					// get navTokenFieldList, if supplied
					var tokenFieldList = ds_map_find_value(map, "tokenFieldList");
					if (scr_isNumericAndExists(tokenFieldList, ds_type_list)) {
						ds_list_destroy(obj_control.tokenFieldList);
						obj_control.tokenFieldList = tokenFieldList;
					}
					
					
					// get navUnitFieldList, if supplied
					var navUnitFieldList = ds_map_find_value(map, "navUnitFieldList");
					if (scr_isNumericAndExists(navUnitFieldList, ds_type_list)) {
						ds_list_destroy(obj_control.navUnitFieldList);
						obj_control.navUnitFieldList = navUnitFieldList;
					}
					
					// get navTokenFieldList, if supplied
					var unitFieldList = ds_map_find_value(map, "unitFieldList");
					if (scr_isNumericAndExists(unitFieldList, ds_type_list)) {
						ds_list_destroy(obj_control.unitFieldList);
						obj_control.unitFieldList = unitFieldList;
					}
					
					
					// get chainEntryFieldList, if supplied
					var chainEntryFieldList = ds_map_find_value(map, "chainEntryFieldList");
					if (!is_undefined(chainEntryFieldList)) {
						ds_list_destroy(global.chainEntryFieldList);
						global.chainEntryFieldList = chainEntryFieldList;
					}
					
					// get entry field map, if supplied
					var entryFieldMap = ds_map_find_value(map, "entryFieldMap");
					if (!is_undefined(entryFieldMap)) {
						ds_map_destroy(global.entryFieldMap);
						global.entryFieldMap = entryFieldMap;
					}
					
					// get chainFieldList, if supplied
					var chainFieldList = ds_map_find_value(map, "chainFieldList");
					if (!is_undefined(chainFieldList)) {
						ds_list_destroy(global.chainFieldList);
						global.chainFieldList = chainFieldList;
					}
					
					// get chain field map, if supplied
					var chainFieldMap = ds_map_find_value(map, "chainFieldMap");
					if (!is_undefined(chainFieldMap)) {
						ds_map_destroy(global.chainFieldMap);
						global.chainFieldMap = chainFieldMap;
					}
					
					
	
					
					// get displayTokenField & speakerField
					var getDisplayTokenField = ds_map_find_value(map, "displayTokenField");
					var getSpeakerField = ds_map_find_value(map, "speakerField");
					if (is_string(getDisplayTokenField)) global.displayTokenField = getDisplayTokenField;
					if (is_string(getSpeakerField)) global.speakerField = getSpeakerField;
					
					// get discourse node
					global.discourseNode = map[? "discourseNode"];
					if (!ds_map_exists(global.nodeMap, global.discourseNode)) {
						scr_initializeDiscourseNodes();
					}
				}
			}		
		}
	}

	ds_list_destroy(newInstList);
	
	// get chain lists from nodeMap, and if they aren't provided in the nodeMap then we'll make them!
	var rezChainList = global.nodeMap[? "rezChainList"];
	var trackChainList = global.nodeMap[? "trackChainList"];
	var stackChainList = global.nodeMap[? "stackChainList"];
	var showList = global.nodeMap[? "showList"];
	var chunkList = global.nodeMap[? "chunkList"];
	var nodeList = global.nodeMap[? "nodeList"];
	if (!is_numeric(rezChainList)) {
		rezChainList = ds_list_create();
		ds_map_add_list(global.nodeMap, "rezChainList", rezChainList);
	}
	if (!is_numeric(trackChainList)) {
		trackChainList = ds_list_create();
		ds_map_add_list(global.nodeMap, "trackChainList", trackChainList);
	}
	if (!is_numeric(stackChainList)) {
		stackChainList = ds_list_create();
		ds_map_add_list(global.nodeMap, "stackChainList", stackChainList);
	}
	if (!is_numeric(showList)) {
		ds_map_add_list(global.nodeMap, "showList", ds_list_create());
	}
	if (!is_numeric(chunkList)) {
		ds_map_add_list(global.nodeMap, "chunkList", ds_list_create());
	}
	if (!is_numeric(nodeList)) {
		ds_map_add_list(global.nodeMap, "nodeList", ds_list_create());
	}
	


}
