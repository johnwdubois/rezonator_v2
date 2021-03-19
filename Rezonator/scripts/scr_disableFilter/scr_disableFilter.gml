// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_disableFilter(){
	
	with (obj_control) {
		searchGridActive = false;
		filterGridActive = false;
		currentActiveLineGrid = lineGrid;
		obj_toolPane.currentMode = obj_toolPane.setModeMain;
		wordLeftMarginDest = 170; // Make sure the margin is placed correctly

		with (obj_alarm) {
			alarm[1] = 5;
		}
	}
	
	if (obj_panelPane.functionChainList_currentTab == obj_panelPane.functionChainList_tabRezBrush) obj_control.filterActiveRez = false;
	else if (obj_panelPane.functionChainList_currentTab == obj_panelPane.functionChainList_tabTrackBrush) obj_control.filterActiveTrack = false;
	else if (obj_panelPane.functionChainList_currentTab == obj_panelPane.functionChainList_tabStackBrush) obj_control.filterActiveStack = false;

}