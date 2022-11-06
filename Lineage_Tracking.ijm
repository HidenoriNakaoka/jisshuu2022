//var dir = "/Volumes/MPFM201207/2022_10_25_12_5/Pos0_2_done/";// Change this line to match your working directory

macro "lineage_tracking [l]" {
	// Forward tracking
	Stack.getPosition(channel, slice, frame);
	if(slice!=1){
		print("Tracking must start at the first slice.");
		return;
	}
	getCursorLoc(x, y, z, modifiers);
	doWand(x, y);
	roiManager("add");
	getBoundingRect(u, v, width, height); // (u,v) = coordinate at left-top corner
	//print(u,v);

	while(slice < nSlices){
		slice++;
		setSlice(slice);
		coordinate = scan_cell(u, v, width, height);// coordinate is an array of size = 2
		if(coordinate[0]>0){// coordinate[0]<0 means that no cells were identified
			doWand(coordinate[0], coordinate[1]);
			roiManager("add");
			getBoundingRect(u, v, width, height);
		}else{
			print("No Cell Found: Tracking aborted");
			return;
		}
	}

	run("Select None");
	setSlice(1);
	
	print("Tracking Finished");
}

macro "measure [m]"{
	run("Set Measurements...", "area stack redirect=None decimal=3");
	roiManager("Deselect");
	roiManager("Measure");

	mark_cell_division();// New born cell is marked by 1, the othres are 0.
	
	measure_fluorescence("GFP");
	measure_fluorescence("RFP");
}

macro "plot_cell_size_trajectory [p]"{
	xarray = newArray(nResults);
	yarray = newArray(nResults);// For cell area
	yarray2 = newArray(nResults);// For division points
	for(i=0; i<nResults; i++){
		xarray[i] = getResult("Slice",i);
		yarray[i] = getResult("Area", i);
		yarray2[i] = getResult("Area", i)*getResult("Division", i);
	}
	
	Plot.create("Cell size trajectory", "Slice", "Area");
	Plot.setColor("#2bbcbb","#2bbcbb");// The second color is used to fill the symbol, and draw lines
	Plot.add("connected circle", xarray, yarray);
	
	Plot.setColor("#ff0099","#ff0099");// Division points
	Plot.add("circle", xarray, yarray2);
	
	Plot.show();
}



// Scan for a new cell, and returns its coordinate
function scan_cell(u, v, width, height){// The argument is a coordinate at left-top corner
	// First, scan horizontally, then move one pixel below.
	// Repeat horizontal scan

	// Initialize an array for cell coordinate
	cell_coordinate = newArray(2);
	cell_coordinate[0] = -1;
	cell_coordinate[1] = -1;
	
	for(j=v; j<v+height; j++){
		for(i=u; i<u+width; i++){
			if(getPixel(i,j)==255){//white pixel == cell
				cell_coordinate[0] = i;
				cell_coordinate[1] = j;
				return cell_coordinate;
			}
		}
	}
	print(u,v,width,height,i,j);
	return cell_coordinate;// Return negative values if no cell is found 
}

function measure_fluorescence(key){
	dir = getInfo("image.directory");
	//print(dir);
	run("Image Sequence...", "open="+dir+" file="+key+" sort");
	run("Subtract Background...", "rolling=50 stack");
	for(i=0; i<roiManager("count"); i++){
		roiManager("select", i);
		List.setMeasurements;
		setResult(key, i, List.getValue("Mean"));
	}
}

function mark_cell_division(){
	for(i=1; i<nResults; i++){
		a_i = getResult("Area", i-1);
		a_f = getResult("Area", i);
		if(a_f/a_i<0.6){// Drastic cell size reduction = cell division
			setResult("Division", i, 1);
		}else setResult("Division", i, 0);
	}
}
