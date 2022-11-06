// It takes about  3 min
setBatchMode("hide");// In order not to show images while processing, because drawing images is time-consuming.

// Background subtraction: subtraction value is a mode pixel value in each image multiplied by 1.3
for(i=0; i<nSlices; i++){
	setSlice(i+1);
	List.setMeasurements;
	m = List.getValue("Mode");
	m = m*1.3;// 1.3 is an empirical parameter
	run("Subtract...", "value="+m+" stack");
}

// Apply Mexican hat filter with radius=4, and convert the image into 8-bit
run("Mexican Hat Filter", "radius=4 stack");
run("8-bit");


// Binarize: make a black(0) or white(255) image
run("Multiply...", "value=255 stack");

// Eliminate salt-pepper type noise
run("Fill Holes", "stack");
run("Despeckle", "stack");
run("Open", "stack");// This sometimes separate "about-to-divide" cells into two daughters.

setBatchMode("show");// Exit the batch mode and show results