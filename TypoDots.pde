// coded by Yota Odaka
import java.util.*;
public class TypoDots  {
	String typoText; // text
	PFont font;
	PGraphics imaginaryCanvas; // graphics canvas
	int canvasWidth = 1000, canvasHeight = 800; // graphics canvas size
	int dotsThickness = 5; // thickness of typography of z direction
	float dotsDensity = 0.01; // upto 1.0(100%)
	int textSize = 100; // text size
	int threshold = 15;
	ArrayList<PVector> allDots2D = new ArrayList<PVector>(); // buffer for coordinate of black
	ArrayList<PVector> dots3D = new ArrayList<PVector>(); // coordinate info
	ArrayList<PVector> dots3D_base = new ArrayList<PVector>(); // base of coordinate info

	public TypoDots(String text, float density, int zThickness) {
		setFont("");
		typoText = text;
		dotsDensity = density;
		dotsThickness = zThickness;
	}

	public TypoDots (String text) {
		this(text, 0.01, 5);
	}
	public TypoDots() {
		this("Processing");
	}

	public void setText(String text) {
		typoText = text;
	}
	public void setFont(String fontName) {
		font = createFont(fontName, 30);
	}
	public void setTextSize(int size) {
		textSize = size;
	}
	public ArrayList<PVector> getDots() {
		return dots3D;
	}
	public void setDensity(float density) {
		dotsDensity = density;
	}
	public void setThickness(int thickness) {
		dotsThickness = thickness;
	}

	public void updateThreshold(int value) {
		threshold = value;
	}
	public void initialize() {
		allDots2D.clear();
		imaginaryCanvas = createGraphics(canvasWidth, canvasHeight);
		imaginaryCanvas.beginDraw();
		imaginaryCanvas.background(255);
		imaginaryCanvas.textFont(font);
		imaginaryCanvas.textAlign(CENTER, CENTER);
		imaginaryCanvas.textSize(textSize);
		imaginaryCanvas.fill(0);
		imaginaryCanvas.text(typoText, canvasWidth/2, canvasHeight/2);
		imaginaryCanvas.endDraw();

		imaginaryCanvas.loadPixels();
		
		// detect pixels which are letters drawn
		for(int i = 0; i < imaginaryCanvas.pixels.length; i++){
			if(imaginaryCanvas.pixels[i] != #000000)continue;
			allDots2D.add(new PVector(i%canvasWidth-canvasWidth/2, i/canvasWidth-canvasHeight/2, 0));
		}
		makeGraph3D();
	}
	private void makeGraph3D() {
		// shuffle
		Collections.shuffle(allDots2D);
		// init result data
		ArrayList<PVector> dots = new ArrayList<PVector>();
		// reduce density of dots
		for(int i = 0;i < (float)allDots2D.size()*dotsDensity; i++){
			float _z = random(-dotsThickness/2, dotsThickness/2);
			dots.add(new PVector(allDots2D.get(i).x, allDots2D.get(i).y, _z));
		}
		dots3D = dots;
		dots3D_base.clear();
		for(int i = 0; i < dots.size(); i++){
			dots3D_base.add(new PVector(dots.get(i).x, dots.get(i).y, dots.get(i).z));
		}
	}

	public void draw(color rectColor, int rectSize) {
		fill(rectColor);
		noStroke();
		for (int i = 0; i < dots3D.size(); i++) {
			PVector d = dots3D.get(i);
			pushMatrix();
			translate(d.x, d.y, d.z);
			box(rectSize);
			popMatrix();
		}
	}

	public void connect(color lineColor, int lineWidth) {
		for (int i = 0; i < dots3D.size(); i++) {
			PVector d1 = dots3D.get(i);
			for (int j = 0; j < dots3D.size();j++) {
				if(i == j)continue;
				PVector d2 = dots3D.get(j);
				if(PVector.dist(d1, d2)>threshold)continue;
				stroke(lineColor);
				strokeWeight(lineWidth);
				line(d1.x, d1.y, d1.z, d2.x, d2.y, d2.z);
			}
		}
	}
	float noiseCount = 0;
	public void perlinNoise(float amp) {
		for(int i = 0; i < dots3D.size(); i++){
			PVector d = dots3D.get(i);
			PVector db = dots3D_base.get(i);
			d.x = amp*(noise(noiseCount+db.x)) + db.x;
			d.y = amp*(noise(noiseCount+db.y)) + db.y;
			d.z = amp*(noise(noiseCount+db.z)) + db.z;
		}
		noiseCount+=0.01;
	}
}