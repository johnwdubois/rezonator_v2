// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_updateChainShowList(inChainsList, chainShowList, inBoxList, chunkShowList){
	
	// get size of inChainsList
	var inChainsListSize = 0;
	if (scr_isNumericAndExists(inChainsList, ds_type_list)) inChainsListSize = ds_list_size(inChainsList);
		
	// if this word has any chains that are not yet in the chainShowList, add them!
	for (var i = 0; i < inChainsListSize; i++) {
		var currentChain = inChainsList[| i];
		if (ds_map_exists(global.nodeMap,currentChain)) {
			if (!is_string(currentChain)) { 
				scr_deleteFromList(inChainsList, currentChain);
				continue;
			}
			if (ds_list_find_index(chainShowList, currentChain) == -1) {
				ds_list_add(chainShowList, currentChain);
			}
		}
		else {
			// if this chain can't be found in the nodeMap, we should remove it from the inChainsList!
			scr_deleteFromList(inChainsList, currentChain);
		}
	}
	
	
	
	// get size of inBoxList
	var inBoxListSize = 0;
	if (scr_isNumericAndExists(inBoxList, ds_type_list)) inBoxListSize = ds_list_size(inBoxList);
	
	// if this word has any chunks that are not yet in chunkShowList, add them!
	for (var i = 0; i < inBoxListSize; i++) {
		var currentChunk = inBoxList[| i];
		if (ds_list_find_index(chunkShowList, currentChunk) == -1) {
			ds_list_add(chunkShowList, currentChunk);
		}
		// check if this chunk is in any chains that should be added to chainShowList
		var currentChunkSubMap = global.nodeMap[? currentChunk];
		if (scr_isNumericAndExists(currentChunkSubMap, ds_type_map)) {
			var currentChunkInChainsList = currentChunkSubMap[? "inChainsList"];
			if (scr_isNumericAndExists(currentChunkInChainsList, ds_type_list)) {
				var currentChunkInChainsListSize = ds_list_size(currentChunkInChainsList);
				for (var j = 0; j < currentChunkInChainsListSize; j++) {
					var currentChain = currentChunkInChainsList[| j];
					if (ds_list_find_index(chainShowList, currentChain) == -1) {
						ds_list_add(chainShowList, currentChain);
					}
				}
			}
		}
		else {
			// if this chunk can't be found in the nodeMap, we should remove it from the inBoxList!
			scr_deleteFromList(inBoxList, currentChunk);
		}
	}

}