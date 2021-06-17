// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_refocusChainEntry(ID){
	
	
	
		
	var unitID = "";
	var tokenID = "";
	var chunkID = "";
	var IDsubMap = global.nodeMap[?ID];
	var type = IDsubMap[?"type"];
	if(type == "unit"){
		unitID = ID
		var entryList = IDsubMap[?"entryList"];
		var firstEntry = entryList[|0];
		var entrySubMap = global.nodeMap[?firstEntry];
		tokenID = entrySubMap[?"token"]
	}
	else if(type == "token"){	
		unitID = IDsubMap[?"unit"];
		tokenID = ID
	}
	else if(type == "chunk"){
		chunkID = ID;
		tokenID = scr_getFirstWordOfChunk(ID);
		var tokenSubMap = global.nodeMap[?tokenID];
		unitID = tokenSubMap[?"unit"];
		
	}
	
	// looks in the currentFocusedChain for the given ID of word or unit and focus that entry
	show_debug_message("scr_refocusChainEntry() ... ID: " + string(ID)+",  unitID: " + string(unitID)+",   tokenID: " + string(tokenID));
	// find which chain entry node this word is associated with, so we can refocus it
	if (ds_map_exists(global.nodeMap, obj_chain.currentFocusedChainID)) {
		var entryToFocus = "";
		var chainSubMap = ds_map_find_value(global.nodeMap, obj_chain.currentFocusedChainID);
		var chainSetList = ds_map_find_value(chainSubMap, "setIDList");
		var chainType = ds_map_find_value(chainSubMap, "type");
		var effectColor = chainSubMap[?"chainColor"];
		
		// loop through this chain's entry list to find the entry with the correct word
		var chainSetListSize = ds_list_size(chainSetList);
		for (var i = 0; i < chainSetListSize; i++) {
			var currentChainEntry = ds_list_find_value(chainSetList, i);
			var currentChainEntrySubMap = ds_map_find_value(global.nodeMap, currentChainEntry);
			var currentChainEntryID = ds_map_find_value(currentChainEntrySubMap, (chainType == "stackChain") ? "unit" : "token");
			var currentChainEntryType = currentChainEntrySubMap[?"type"];
			
			
			if (tokenID == currentChainEntryID or unitID == currentChainEntryID or chunkID == currentChainEntryID) {
				entryToFocus = currentChainEntry;
			}
			
			/*
			drawing of rez/tracks chains come back later
			if(chainType == "rezChain" or chainType == "trackChain"){
				if(!scr_isChunk(currentChainEntryTokenID)){
					
					var wordDrawCol = currentChainEntryType == "rez" ? obj_control.wordDrawGrid_colBorder : obj_control.wordDrawGrid_colBorderRounded;
					ds_grid_set(obj_control.wordDrawGrid, wordDrawCol, currentChainEntryTokenID - 1, true);
					if(currentChainEntryType == "rez" ){
						if(ds_grid_get(obj_control.wordDrawGrid, obj_control.wordDrawGrid_colBorderRounded, currentChainEntryTokenID - 1)){
							ds_grid_set(obj_control.wordDrawGrid, obj_control.wordDrawGrid_colBorderRounded, currentChainEntryTokenID - 1, false);
						}
					}
					if(currentChainEntryType == "track" ){
						if(ds_grid_get(obj_control.wordDrawGrid, obj_control.wordDrawGrid_colBorder, currentChainEntryTokenID - 1)){
							ds_grid_set(obj_control.wordDrawGrid, obj_control.wordDrawGrid_colBorder, currentChainEntryTokenID - 1, false);
						}
					}

					ds_grid_set(obj_control.wordDrawGrid, obj_control.wordDrawGrid_colEffectColor, currentChainEntryTokenID - 1, effectColor);
				}
			}
			*/
		}
	
		
		// if we have found the entry to focus, and it exists in the NodeMap, let's focus it!
		if (ds_map_exists(global.nodeMap, entryToFocus)) {
			show_debug_message("scr_refocusChainEntry() ... focusing entry: " + string(entryToFocus));
			ds_map_replace(chainSubMap, "focused", entryToFocus);
		}
		
		// determine which chainList tab and mode we should be on
		var chainListTab = obj_panelPane.functionChainList_tabRezBrush;
		var chainMode = obj_toolPane.modeRez;
		if (chainType == "rezChain") {
			chainListTab = obj_panelPane.functionChainList_tabRezBrush;
			chainMode = obj_toolPane.modeRez;
		}
		else if (chainType == "trackChain") {
			chainListTab = obj_panelPane.functionChainList_tabTrackBrush;
			chainMode = obj_toolPane.modeTrack;
		}
		else if (chainType == "stackChain") {
			chainListTab = obj_panelPane.functionChainList_tabStackBrush;
			chainMode = obj_toolPane.modeRez;
		}
	}

}