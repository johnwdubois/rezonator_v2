// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_deleteChain(chainID){
	

	if (!ds_map_exists(global.nodeMap,chainID)) {
		show_debug_message("scr_deleteChain()... chainID does not exists in nodeMap, exiting...");
		exit;
	}
	
	// focus the chain we want to delete
	obj_chain.currentFocusedChainID = chainID;
	
	// get chain's submap
	var chainSubMap = ds_map_find_value(global.nodeMap, chainID);
	var chainType = ds_map_find_value(chainSubMap, "type");
	
	// get list of chains
	var listOfChains = -1;
	var filterList = -1;
	var selectedList = -1;
	if (chainType == "rezChainList") {
		listOfChains = ds_map_find_value(global.nodeMap, "rezChainList");
		filterList = obj_chain.filteredRezChainList;
		selectedList = obj_control.selectedRezChainList;
	}
	else if (chainType == "trackChain") {
		listOfChains = ds_map_find_value(global.nodeMap, "trackChainList");
		filterList = obj_chain.filteredTrackChainList;
		selectedList = obj_control.selectedTrackChainList;
	}
	else if (chainType == "stackChain") {
		listOfChains = ds_map_find_value(global.nodeMap, "stackChainList");
		filterList = obj_chain.filteredStackChainList;
		selectedList = obj_control.selectedStackChainList;
	}
	
	// get setIDList
	var setIDList = -1;
	if (is_numeric(chainSubMap)) {
		if (ds_exists(chainSubMap, ds_type_map)) {
			setIDList = ds_map_find_value(chainSubMap, "setIDList");
			if (!is_numeric(setIDList)) exit;
			if (!ds_exists(setIDList, ds_type_list)) exit;
		}
	}
	
	// remove every entry from this chain
	var sizeOfEntryList = ds_list_size(setIDList);
	while (sizeOfEntryList > 0) {
		var currentEntry = ds_list_find_value(setIDList, 0);
		ds_map_replace(chainSubMap, "focused", currentEntry);
		scr_deleteFromChain(false);
		
		if (ds_exists(setIDList, ds_type_list)) {
			sizeOfEntryList = ds_list_size(setIDList);
		}
		else {
			sizeOfEntryList = 0;
		}
	}
	
	// delete this chain from the list of chains (and filter list, and selected list....)
	scr_deleteFromList(listOfChains, chainID);
	scr_deleteFromList(filterList, chainID);
	scr_deleteFromList(selectedList, chainID);
	
	// unfocus chain
	obj_chain.currentFocusedChainID = "";
	
}