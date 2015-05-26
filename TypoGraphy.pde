// coded by Yota Odaka
TypoDots myTypography;
void setup(){
	size(1280, 720, P3D);
	myTypography = new TypoDots();
	myTypography.setThickness(15);
	myTypography.setDensity(.11);
	myTypography.setNoiseSpeed(0.08);
	myTypography.initialize();
}

int angle_x = 0, angle_y = 0;
void draw(){
	background(255);
	pushMatrix();
	translate(width/2, height/2, 300);
	rotateY(radians(angle_x));
	rotateX(radians(angle_y));
	myTypography.connect(color(#156279, 80), 1);
	myTypography.draw(color(#0E62F5, 255), 1);
	popMatrix();
	//myTypography.updateThreshold((int)(sin(radians(millis())))+14);
	myTypography.perlinNoise(10);
}

void mouseDragged(){
	angle_x += mouseX - pmouseX;
	angle_y += mouseY - pmouseY;
}