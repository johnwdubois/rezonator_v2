// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_destroyAllDropDownsOtherThanSelf(){
	var selfID = self;
	with (obj_dropDown) {
		if (self != selfID) {
			instance_destroy();
		}
	}
}