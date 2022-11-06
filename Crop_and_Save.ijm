var image = 0;
var width = 200;
var height = 200;

macro "Crop_and_Save [p]"{
	getCursorLoc(x, y, z, modifiers);
	makeRectangle(x-width/2, y-height/2, width, height);
	run("Duplicate...", " ");
	saveAs("Jpeg", "/Users/nakaokahidenori/Desktop/embryos-"+image+".jpg");
	image++;
}

macro "Change_rectangular_size [c]"{
	Dialog.create("Change_rectangular_size");
	Dialog.addString("Width", 200);
	Dialog.addString("Height", 200);
	Dialog.show();

	width = Dialog.getString();
	height = Dialog.getString();
}




