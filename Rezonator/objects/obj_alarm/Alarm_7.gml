if(global.unitImportGridWidth == 2){
	var participantCheck = ds_grid_get(global.unitImportGrid,global.unitImport_colParticipant, (ds_grid_height(global.unitImportGrid)-1));
	if(participantCheck == undefined or participantCheck == 0 or participantCheck == "" or participantCheck == "undefined"){
		scr_hideSpeakerName();
	}
}