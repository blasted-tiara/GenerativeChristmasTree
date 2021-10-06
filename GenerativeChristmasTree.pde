void setup() {
    size(800, 800);
    colorMode(HSB, 360, 100, 100);
    noStroke();

    redraw();
}

void redraw() {
    background(360, 0, 100);
    drawExamples();
}

void drawExamples() {}

void draw() {}

void mousePressed() {
    if (mouseButton == LEFT) {
        saveFrame("local/ep####.png");
    } else if (mouseButton == RIGHT) {
        redraw();
    }
}
