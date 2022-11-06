run("HeLa Cells (48-bit RGB)"); // サンプル画像を開く
run("Stack to Images"); // スタックをばらす

// 緑と赤の画像は不要なので消しておく
selectWindow("Green");
close();
selectWindow("Red");
close();

// 青の画像をコピーしておく
selectWindow("Blue");
run("Duplicate...", " "); // デフォルト設定ではコピーされた画像名は Blue-1
selectWindow("Blue-1"); //コピーした画像に対して以下の操作を行う

// 以下二値化の処理
run("Subtract Background...", "rolling=50"); // バックグラウンドを差し引く
run("Median...", "radius=5"); // Median filter によるノイズ除去
run("Mexican Hat Filter", "radius=10"); // Mexican Hat Filter によるエッジ検出
run("8-bit"); // 元の16 bit を 8 bit に変換する
run("Subtract...", "value=254"); // この処理によって飽和しているピクセル値は１に、それ以外は０になる
run("Multiply...", "value=255.000"); // 残ったピクセルを最大値である２５５に回復
run("Fill Holes");// 空洞を埋める便利な関数

// ここからは粒子(細胞核)の同定と各種パラメータの定量
run("Analyze Particles...", "size=20-Infinity show=Masks exclude add");// サイズの範囲を適切に決めるにはある程度の下調べが必要
run("Set Measurements...", "area mean standard min perimeter shape redirect=None decimal=3"); // 測定したいパラメータを決める
roiManager("Deselect");//全選択解除　ここではおまじない程度
selectWindow("Blue");//オリジナル画像を選択してこれを計測する
roiManager("measure");//測定