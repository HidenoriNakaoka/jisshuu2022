macro "output_generation_time_list [g]"{
	div_count = 0;
	tau = 0;
	for(i=0; i<nResults; i++){
		if(getResult("Division", i)==1){
			div_count++;
			if(div_count > 1) print(tau);
			tau = 0;
		}else tau = tau + 5;
	}
}

macro "output_cell_cycle_stats [c]"{
	
	for(i=0; i<nResults; i++){
		if(getResult("Division", i)==1){
			a_i = getResult("Area", i);
			s_i = getResult("Slice", i);
			gfp_i = getResult("GFP",i);
			rfp_i = getResult("RFP",i);
			i = find_next_division(i);
			if(i<0) return;
			a_f = getResult("Area", i);
			s_f = getResult("Slice", i);
			gfp_f = getResult("GFP",i);
			rfp_f = getResult("RFP",i);
			tau = (s_f-s_i)*5;
			mean_gfp = (gfp_i + gfp_f)/2;
			mean_rfp = (rfp_i + rfp_f)/2;
			print(tau+"\t"+a_i+"\t"+a_f+"\t"+mean_gfp+"\t"+mean_rfp);
		}
	}
}

macro "autocorrelation [a]"{
	Dialog.create("Autocorrelation");
	Dialog.addString("Column", "GFP");
	Dialog.show();
	key = Dialog.getString();

	mean = 0;
	for(i=0; i<nResults; i++){
		mean = mean + getResult(key, i);
	}
	mean = mean/nResults;

	
	N = round(nResults/2-0.5);
	R_0 = 0;
	for(i=0; i<N; i++){
		R_0 = R_0 + pow(getResult(key, i)-mean, 2);
	}
	//R_0 = R_0/N;
	
	j = 0;
	for(j=0; j<N; j++){	
		R_j = 0;
		for(i=0; i<N; i++){
			R_j = R_j + (getResult(key, i)-mean)*(getResult(key, i+j)-mean);
		}
		//R_j = R_j/N;
		
		print(j*5/60+"\t"+R_j/R_0);
	}
}

macro "histogram [h]"{
	Dialog.create("Histogram");
	Dialog.addString("Column", "GFP");
	Dialog.show();
	key = Dialog.getString();

	array = newArray(nResults);

	for(i=0; i<nResults; i++){
		array[i] = getResult(key, i);
	}
	Plot.create("Histogram", key, "Count");
	Plot.addHistogram(array, 0, 0);
	Plot.show();
}

function find_next_division(row){
	row++;
	while(row<nResults){
		if(getResult("Division", row)==1) return row-1;
		row++;
	}
	return -1;
}