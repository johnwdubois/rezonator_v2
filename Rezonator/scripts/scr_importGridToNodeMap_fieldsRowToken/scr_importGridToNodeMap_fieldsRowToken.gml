// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_importGridToNodeMap_fieldsRowToken(row){

	// make sure row is still in range
	if (row >= importGridHeight) exit;
	
	// get current unit delimiter cell value
	var unitDelimValue = global.importGrid[# indexOfUnitDelim, row];
	if (unitDelimValue == "" || unitDelimValue == "0") unitDelimValue = prevFieldMap[? global.unitDelimField];
	else prevFieldMap[? global.unitDelimField] = unitDelimValue;
	
	
	// check if this unit delim value is the same as the "current unit"
	var currentUnitSubMap = global.nodeMap[? currentUnitID];
	var currentUnitDelimValue = "";
	if (scr_isNumericAndExists(currentUnitSubMap, ds_type_map)) {
		var currentUnitTagMap = currentUnitSubMap[? "tagMap"];
		currentUnitDelimValue = currentUnitTagMap[? global.unitDelimField];
	}
	
	
	var unitTagMap = -1;
	var newUnitMade = false;
	if (unitDelimValue != currentUnitDelimValue) {
		
		newUnitMade = true;
		
		// make a new unit node for this row
		var unitNode = scr_addToNodeMap("unit");
		var unitSubMap = global.nodeMap[? unitNode];
		ds_list_add(unitList, unitNode);
		
		currentUnitID = unitNode;
	
		// make tag map for unit
		unitTagMap = ds_map_create();
		ds_map_add_map(unitSubMap, "tagMap", unitTagMap);
	
		// add values to unit node
		ds_map_add(unitSubMap, "unitSeq", ds_list_size(unitList));
		currentEntryList = ds_list_create();
		ds_map_add_list(unitSubMap, "entryList", currentEntryList);
		ds_map_add_list(unitSubMap, "inChainsList", ds_list_create());
		ds_map_add(unitSubMap, "pixelY", 0);
		ds_map_add(unitSubMap, "pID", 0);
		ds_map_add(unitSubMap, "speakerColor", c_ltblue);
		ds_map_add(unitSubMap, "filter", false);
		ds_map_add(unitSubMap, "active", true);
		if (!ds_map_exists(unitSubMap, "unitStart")) ds_map_add(unitSubMap, "unitStart", "");
		if (!ds_map_exists(unitSubMap, "unitEnd")) ds_map_add(unitSubMap, "unitEnd", "");
	}
	
	
	
	
	// some essentials
	if(row == 0){
		
		var unitFieldMap = global.nodeMap[?"unitTagMap"];
		var tokenFieldMap = global.nodeMap[?"tokenTagMap"];

		//add all fields to appropriate field lists
		for(var i = 0 ; i < ds_list_size(global.importGridColNameList); i++){
			var fieldName = global.importGridColNameList[| i];
			if(global.fieldLevelMap[? fieldName] == "unit"){
				if(fieldName == "~blockID"){continue;}
				ds_list_add(global.unitFieldList, fieldName);
				
				var newUnitFieldMap = ds_map_create();
				ds_map_add_map(unitFieldMap,fieldName, newUnitFieldMap);
				ds_map_add_list(newUnitFieldMap, "tagSet", ds_list_create());
			}
			else if(global.fieldLevelMap[? fieldName] == "token"){
				ds_list_add(global.tokenFieldList, fieldName);
				
				var newTokenFieldMap = ds_map_create();
				ds_map_add_map(tokenFieldMap, fieldName, newTokenFieldMap);
				ds_map_add_list(newTokenFieldMap, "tagSet", ds_list_create());
			}
		}
	}
	
	
	
	
	// make token node
	var currentTokenNode = scr_addToNodeMap("token");
	var currentTokenSubMap = global.nodeMap[? currentTokenNode];
	ds_map_add(currentTokenSubMap, "discourseTokenSeq", ds_list_size(tokenList) + 1);
	ds_map_add(currentTokenSubMap, "tokenSeq", ds_list_size(currentEntryList) + 1);
	ds_map_add(currentTokenSubMap, "displayCol", ds_list_size(currentEntryList));
	ds_map_add(currentTokenSubMap, "void", 1);
	ds_map_add(currentTokenSubMap, "pixelX", 0);
	ds_map_add(currentTokenSubMap, "border", "");
	ds_map_add(currentTokenSubMap, "searched", false);
	ds_map_add(currentTokenSubMap, "unit", currentUnitID);
	ds_map_add_list(currentTokenSubMap, "inChainsList", ds_list_create());
	ds_map_add_list(currentTokenSubMap, "inChunkList", ds_list_create());
	
	// make entry node
	var currentEntryNode = scr_addToNodeMap("entry");
	var currentEntrySubMap = global.nodeMap[? currentEntryNode];
	ds_map_add(currentEntrySubMap, "token", currentTokenNode);
	ds_map_add(currentEntrySubMap, "unit", currentUnitID);
	ds_list_add(currentEntryList, currentEntryNode);
	
	
	// make tag map for token
	var currentTokenTagMap = ds_map_create();
	ds_map_add_map(currentTokenSubMap, "tagMap", currentTokenTagMap);
	

	for (var i = 0; i < importGridWidth; i++) {
		
		var currentCell = global.importGrid[# i, row];
		var currentField = global.importGridColNameList[| i];
		var currentLevel = global.fieldLevelMap[? currentField];
		
		
		if (currentLevel == "token") {
			if (scr_isNumericAndExists(currentTokenTagMap, ds_type_map)) {
				ds_map_add(currentTokenTagMap, currentField, currentCell);
			}
		}
		else if (currentLevel == "unit" && newUnitMade) {
			ds_map_add(unitTagMap, currentField, currentCell);
		}
	}


	importGridRow++;

}