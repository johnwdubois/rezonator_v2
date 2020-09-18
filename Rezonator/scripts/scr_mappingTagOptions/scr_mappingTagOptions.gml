function scr_mappingTagOptions(argument0) {
	var optionSelected = argument0;

	switch (optionSelected)
	{
		case "Token":
			ds_grid_set(global.tagInfoGrid, obj_importMapping.colToChange, obj_importMapping.rowToChange , global.levelToken);
			var checkIfDisplayT = ds_grid_get(global.tagInfoGrid, global.tagInfoGrid_colSpecialFields,obj_importMapping.rowToChange);
			var checkIfDisplayU = ds_grid_get(global.tagInfoGrid, global.tagInfoGrid_colSpecialFields,obj_importMapping.rowToChange);
			if(checkIfDisplayT == "Display Token" || checkIfDisplayU == "Speaker"){
				ds_grid_set(global.tagInfoGrid, global.tagInfoGrid_colSpecialFields , obj_importMapping.rowToChange , "");
			}
			break;
		case "Unit":
			ds_grid_set(global.tagInfoGrid, obj_importMapping.colToChange, obj_importMapping.rowToChange , global.levelUnit);
			var checkIfDisplayT = ds_grid_get(global.tagInfoGrid, global.tagInfoGrid_colSpecialFields,obj_importMapping.rowToChange);
			var checkIfDisplayU = ds_grid_get(global.tagInfoGrid, global.tagInfoGrid_colSpecialFields,obj_importMapping.rowToChange);
			if(checkIfDisplayT == "Display Token" || checkIfDisplayU == "Speaker"){
				ds_grid_set(global.tagInfoGrid, global.tagInfoGrid_colSpecialFields , obj_importMapping.rowToChange , "");
			}
			break;
		case "Discourse":	
			ds_grid_set(global.tagInfoGrid, obj_importMapping.colToChange, obj_importMapping.rowToChange , global.levelDiscourse);
			var checkIfDisplayT = ds_grid_get(global.tagInfoGrid, global.tagInfoGrid_colSpecialFields,obj_importMapping.rowToChange);
			var checkIfDisplayU = ds_grid_get(global.tagInfoGrid, global.tagInfoGrid_colSpecialFields,obj_importMapping.rowToChange);
			if(checkIfDisplayT == "Display Token" || checkIfDisplayU == "Speaker"){
				ds_grid_set(global.tagInfoGrid, global.tagInfoGrid_colSpecialFields , obj_importMapping.rowToChange , "");
			}
			break;
		case "Exception":
			ds_grid_set(global.tagInfoGrid, obj_importMapping.colToChange, obj_importMapping.rowToChange , global.levelUnknown);
			var checkIfDisplayT = ds_grid_get(global.tagInfoGrid, global.tagInfoGrid_colSpecialFields,obj_importMapping.rowToChange);
			var checkIfDisplayU = ds_grid_get(global.tagInfoGrid, global.tagInfoGrid_colSpecialFields,obj_importMapping.rowToChange);
			if(checkIfDisplayT == "Display Token" || checkIfDisplayU == "Speaker"){
				ds_grid_set(global.tagInfoGrid, global.tagInfoGrid_colSpecialFields , obj_importMapping.rowToChange , "");
			}
			break;
		default:
			break;
	}

	//scr_gridMultiColSort(global.tagInfoGrid, global.tagInfoGrid_colLevel, true, global.tagInfoGrid_colTokenCount, false, global.tagInfoGrid_colDisplayToken, false, global.tagInfoGrid_colDisplayUnit, false);

	with(obj_dropDown){
		instance_destroy();
	}


}
