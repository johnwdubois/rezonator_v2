var optionSelected = argument0;

switch (optionSelected)
{	
	
	case "Default":

		show_message("Click or Drag on Speaker Labels to create default stacks.");
		break;
	case "Random":
		//show_message("Create Random");
		obj_stacker.splitSave = true;
		obj_stacker.alarm[1] = 1;
		break;
	case "Turn":
		//show_message("Create Turn");
		obj_stacker.splitSave = true;
		obj_stacker.alarm[4] = 1;
		break;
	default:
		break;
}