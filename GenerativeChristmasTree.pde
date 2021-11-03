import geomerative.*;

Metagen treeGenerator;
Polygon baseTriangle;
ArrayList<ECircle> particles;
float c;


String getFilePath(String fileName) {
    return sketchPath() + "/" + fileName;
}

void setup() {
    size(800, 800);
    RG.init(this);
    colorMode(HSB, 360, 100, 100);
    c = width/100;

    try {
        treeGenerator = new Metagen(getFilePath("tree.sm"));
    } catch(IOException e) {
        println("Could not find the input file, stopping script...");
        exit();
    }

    redraw();
}

void reinit() {
    background(360, 0, 100);
    noStroke();
    particles = new ArrayList<ECircle>();
}

void redraw() {
    reinit();
    drawExamples();
}

void drawExamples() {
    Component model = treeGenerator.generate();
    Component tree = model.getSubComponent("tree");
    drawTrunk(tree);
    drawCrown(tree);
    drawTinselGarland(tree);
    drawLights(tree);
    drawOrnaments(tree);
}

void draw() {}

void mousePressed() {
    if (mouseButton == LEFT) {
        saveFrame("local/ep####.png");
    } else if (mouseButton == RIGHT) {
        redraw();
    }
}
