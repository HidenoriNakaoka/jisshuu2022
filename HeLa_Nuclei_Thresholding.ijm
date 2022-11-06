threshold = 400;//自分で勝手に変数を定義できる

// 二重 For ループを使って画像中の全てのピクセルにアクセスしながら、その値の情報を得る
// 値に応じた処理を行う
for(x=0; x<getWidth(); x++){
	for(y=0; y<getHeight(); y++){
		if(getPixel(x, y)>threshold){
			setPixel(x,y,65535);// 65535 は 16 bit 画像の最大ピクセル値
		}else setPixel(x, y, 0);
	}
}