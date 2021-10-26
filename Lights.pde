void drawLights(Component tree) {
    Component lights = tree
                        .getSubComponent("crown")
                        .getSubComponent("decorations")
                        .getSubComponent("lights");
    Component lightbulbs = lights.getSubComponent("lightbulbs");
    int noOfLevels = (int) lights.getAttrf("levels");
    loadPixels();
    for (int i = 0; i < noOfLevels; i++) {
        float denominator = 4 * (noOfLevels + 1);
        PVector p0 = getBoundaryPoint(tree, (2 + random(-1, 1) + 2*i) / denominator);
        PVector p1 = getBoundaryPoint(tree, (denominator - 2 - 2*i + random(-1, 1)) / denominator);

        ArrayList<PVector> initPts = getInitPts(p0, p1);
        ArrayList<PVector> cableArr = chaikinSmooth(initPts, 0.2, 4, false);
        PCurve pc = new PCurve(cableArr);
        ArrayList<PVector> lightbulbsArr = pc.cutEqualParts(20.0);
        drawCable(cableArr, lightbulbs);
        drawLightbulbs(lightbulbsArr, lightbulbs);
    }
    noStroke();
}

ArrayList<PVector> getInitPts(PVector p0, PVector p1) {
    ArrayList<PVector> output = new ArrayList<PVector>();
    output.add(p0);
    float y = Math.max(p0.y, p1.y) + 0.2 * p0.dist(p1);
    output.add(new PVector(lerp(p0.x, p1.x, 0.33), y));
    output.add(new PVector(lerp(p0.x, p1.x, 0.66), y));
    output.add(p1);
    return output;
}

void drawCable(ArrayList<PVector> cableArr, Component lightbulbs) {
    String type = lightbulbs.getTraitCategory("type");
    if (
        type.equals("CIRCLE") ||
        type.equals("SQUARE") ||
        type.equals("ROUNDISH") ||
        type.equals("SWIRLING") ||
        type.equals("RADIATING")
    ) {
        drawLine(cableArr);
    }
}

void drawLightbulbs(ArrayList<PVector> lightbulbsArr, Component lightbulbs) {
    String type = lightbulbs.getTraitCategory("type");
    float radius = lightbulbs.getAttrf("radius") * c; 
    int count = (int) lightbulbs.getTrait("type").getAttr("count");
    for (PVector lightbulb: lightbulbsArr) {
        if (type.equals("CIRCLE")) {
            drawCircleLightbulb(lightbulb, radius, count);
        }
    }
}

void drawCircleLightbulb(PVector lightbulb, float radius, int count) {
    float hue = random(0, 360);
    for (int i = 0; i < count; i++) {
        fill(hue, 70, 100, 200);
        float diameter = 2.0 * (count - i) * radius / count ;
        ellipse(lightbulb.x, lightbulb.y, diameter, diameter);
        hue = (hue + (360.0 / count)) % 360.0;
    }
}

PVector getBoundaryPoint(Component tree, float ratio) {
    float w = tree.getSubComponent("crown").getAttrf("width") * c;
    int x = round((width/2 + w * (ratio - 0.5)));

    while (true) {
        for (int i = 0; i < height; i++) {
            if (getPixel(x, i) != color(360, 0, 100)) {
                return new PVector(x, i);
            }
        }
        if (x < width/2) {
            x++;
        } else {
            x--;
        }
    }

}

color getPixel(int x, int y) {
    if (x < 0 || x >= width || y < 0 || y >= height) {
        throw new IllegalArgumentException("Pixel index out of bounds");
    }

    return pixels[y * width + x];
}