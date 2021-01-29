/*
	obj_chain: Create
	
	Last Updated: 2019-02-11
	
	Called from: The creation of a chain object
	
	Purpose: Instantiate all variables used by the chain objects
	
	Mechanism: variable creation and assignment
	
	Author: Terry DuBois
*/

toggleDrawRez = true;
toggleDrawTrack = true;
toggleDrawStack = true;

chainGridWidth = 9;
chainGrid_colChainID = 0;
chainGrid_colChainState = 1;
chainGrid_colWordIDList = 2;
chainGrid_colName = 3;
chainGrid_colColor = 4;
chainGrid_colInFilter = 5;
chainGrid_colAlign = 6;
chainGrid_colTiltSum = 7;
chainGrid_colChainSeq = 7;
chainGrid_colAuthor = 8;
chainGrid_colCaption = 9;
chainGrid_colStackType = 10;
chainGrid_colAct = 11; // stack tag
chainGrid_colRepair = 12; // stack tag
chainGrid_colActSequence = 13; // stack tag

chainGrid_colShow = 9;


placeChainGrid = ds_grid_create(chainGridWidth, 0);

chunkGrid_colBoxWordIDList = 8;
chunkGrid_colNest = 9;


chunkGrid = ds_grid_create(chainGridWidth + 2, 0);

//creatingPlaceChains = false;

unitInStackGridWidth = 3;
unitInStackGrid_colUnitID = 0;
unitInStackGrid_colStack = 1;
unitInStackGrid_colStackType = 2;
unitInStackGrid = ds_grid_create(unitInStackGridWidth, 0);
unitInStackGrid_focusedCol = unitInStackGrid_colStack;

currentChain = 0;
currentChainID = 0;

//chainStateTotal = 5;
chainStateNormal = 0;//"Normal";//0
//chainStateActive = 1;
chainStateFocus = 2;//"Focus";//2
//chainStateInactive = 3;
//chainStateHidden = 4;
chainStateDead = 5;//"Dead";//5

chainColorList = ds_list_create();
chainColorID[1] = 0;
chainColorID[2] = 0;
chainColorID[3] = 0;
ds_list_add(chainColorList, c_blue, c_red, c_green, c_purple, c_olive, c_orange, c_fuchsia, c_teal);



rezTier = 1;
trackTier = 2;
stackTier = 3;



rezChainNameCounter = 0;
trackChainNameCounter = 0;
stackChainNameCounter = 0;
placeChainNameCounter = 0;
//chunkNameCounter = 0;

currentFocusedChainID = "";

mouseLineHide = false;

mouseLineWordID = -1;


cliqueGridWidth = 11;
cliqueGrid_colCliqueID = 0;
cliqueGrid_colChainIDList = 1;
cliqueGrid_colUnitIDList = 2;
cliqueGrid_colRangeStart = 3;
cliqueGrid_colRangeEnd = 4;
cliqueGrid_colFlankLeft = 5;
cliqueGrid_colFlankRight = 6;
cliqueGrid_colLength = 7;
cliqueGrid_colBreak = 8;
cliqueGrid_colTilt = 9;
cliqueGrid_colName = 10;
cliqueGrid = ds_grid_create(cliqueGridWidth, 0);

cliqueIDCounter = 0;

cliqueGridRowToRefresh = -1;
cliqueGridRowToCheckBreak = -1;

//cliqueGridChainIDTakenOut = -1;
//cliqueGridChainIndexToTakeOut = -1;

cliqueGridRowToRefreshFlanks = -1;


rezChainGridRowToRefreshTilt = -1;


//recentlyMovedLinks = ds_list_create();
recentlyMovedWords = ds_list_create();
alarm[4] = 30;

//New fields for Tween focus funtionality
chainIDModifyList = ds_list_create();
unitIDOfFirstWord = -1;
unitIDOfLastWord = -1;

focusPrior = false;
focusTween = false;
focusNext = false;

//Fields for keeping tabFocus
oldRezFocus = -1;
oldTrackFocus = -1;
oldStackFocus = -1;


/*
raceGridWidth = 3;
raceGrid_colWordID = 0;
raceGrid_colRaceSteps = 1;
raceGrid_colRaceRank = 2;
*/

chainIDRaceCheck = -1;



goldStandardGridWidth = 4;
//goldStandardGridHeight = 0;
goldStandardGrid = ds_grid_create(goldStandardGridWidth, 0);
goldStandardGrid_colStackID = 0;
goldStandardGrid_colWordIDList = 1;
goldStandardGrid_colUser = 2;
goldStandardGrid_colScore = 3;

// For toggling Place chains
showPlaceChains = false;
showChainArrows = false;


stackChainGridRowToCaption = -1;


chainShowList = ds_list_create();

filteredRezChainList = ds_list_create();
filteredTrackChainList = ds_list_create();
filteredStackChainList = ds_list_create();



trackSeqGridWidth = 8;
trackSeqGrid_colChainID = 0;
trackSeqGrid_colChainName = 1;
trackSeqGrid_colChainSeq = 2;
trackSeqGrid_colTrackSeq = 3;
trackSeqGrid_colWordID = 4;
trackSeqGrid_colText = 5;
trackSeqGrid_colTranscript = 6;
trackSeqGrid_colUnitText = 7;
trackSeqGrid = ds_grid_create(trackSeqGridWidth, 0);