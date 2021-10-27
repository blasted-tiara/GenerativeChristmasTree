Metagen treeGenerator;
Polygon baseTriangle;
float c;

String getFilePath(String fileName) {
    return sketchPath() + "/" + fileName;
}

void setup() {
    size(800, 800);
    colorMode(HSB, 360, 100, 100);
    noStroke();
    c = width/100;

    try {
        treeGenerator = new Metagen(getFilePath("tree.sm"));
    } catch(IOException e) {
        println("Could not find the input file, stopping script...");
        exit();
    }

    redraw();
}

void redraw() {
    background(360, 0, 100);
    drawExamples();
}

void drawExamples() {
    Component model = treeGenerator.generate();
    Component tree = model.getSubComponent("tree");
    drawTrunk(tree);
    drawCrown(tree);
    drawTinselGarland(tree);
    drawLights(tree);
}

void draw() {}

void mousePressed() {
    if (mouseButton == LEFT) {
        saveFrame("local/ep####.png");
    } else if (mouseButton == RIGHT) {
        redraw();
    }
}
