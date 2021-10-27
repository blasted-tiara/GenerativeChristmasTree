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
        type.equals("POLYGON") ||
        type.equals("ROUNDISH") ||
        type.equals("SWIRLING") ||
        type.equals("RADIATING")
    ) {
        drawLine(cableArr, color(360, 0, 25));
    }
}

void drawLightbulbs(ArrayList<PVector> lightbulbsArr, Component lightbulbs) {
    String type = lightbulbs.getTraitCategory("type");
    float radius = lightbulbs.getAttrf("radius") * c; 
    for (int i = 0; i < lightbulbsArr.size(); i++) {
        if (type.equals("CIRCLE")) {
            int count = (int) lightbulbs.getTrait("type").getAttr("count");
            drawCircleLightbulb(lightbulbsArr.get(i), radius, count);
        } else if (type.equals("POLYGON")) {
            PVector direction = getLineDirection(lightbulbsArr, i);
            if (i % 2 == 1) {
                direction = direction.mult(-1);
            }
            int count = (int) lightbulbs.getTrait("type").getAttr("count");
            int sides = (int) lightbulbs.getTrait("type").getAttr("sides");
            drawPolygonLightbulb(
                lightbulbsArr.get(i),
                direction,
                radius,
                sides,
                count
            );
        } else if (type.equals("SWIRLING")) {
            drawSwirlingLightbulb(lightbulbsArr.get(i), radius);
        } else if (type.equals("RADIATING")) {
            float saturation = lightbulbs.getTraitAttrf("type", "saturation");
            drawRadiatingLightbulb(lightbulbsArr.get(i), radius, saturation);
        }
    }
}

PVector getLineDirection(ArrayList<PVector> linePts, int idx) {
    if (linePts != null && linePts.size() >= 2) {
        if (idx == 0) {
            return PVector.sub(linePts.get(1), linePts.get(0));
        } else if (idx == linePts.size() - 1) {
            return PVector.sub(
                linePts.get(linePts.size() - 1),
                linePts.get(linePts.size() - 2)
            );
        } else {
            return PVector.sub(linePts.get(idx + 1), linePts.get(idx - 1));
        }
    } else {
        return null;
    }
}

void drawSwirlingLightbulb(PVector lightbulb, float radius) {
    PolygonFactory pf = new PolygonFactory();
    Polygon p = pf.createRegularPolygon(lightbulb, radius * 0.2, 3);

    Shape s = new Shape(DistortType.ROTATIONAL);
    s.depth = 10;
    s.alpha = 150;
    s.variance = radius * 0.09;
    s.bias(lightbulb.x, lightbulb.y);
    s.distCoeff = 3;
    s.colour = color(random(0, 360), 60, 100);
    s.draw(p);

}

void drawRadiatingLightbulb(PVector lightbulb, float radius, float saturation) {
    PolygonFactory pf = new PolygonFactory();
    Polygon p = pf.createRegularPolygon(lightbulb, radius * 1.2, 5);

    Shape s = new Shape(DistortType.POINT_BIASED);
    s.depth = 10;
    s.alpha = 80;
    s.variance = radius * 0.1;
    s.bias(lightbulb.x, lightbulb.y);
    s.distCoeff = 2;
    s.colour = color(random(0, 360), saturation, 100);
    s.draw(p);
}

void drawCircleLightbulb(PVector lightbulb, float radius, int count) {
    float hue = random(0, 360);
    for (int i = 0; i < count; i++) {
        fill(hue, 70, 100, 300);
        float diameter = 2.0 * (count - i) * radius / count ;
        ellipse(lightbulb.x, lightbulb.y, diameter, diameter);
        hue = (hue + (360.0 / count)) % 360.0;
    }
}

void drawPolygonLightbulb(
    PVector lightbulb,
    PVector direction,
    float radius,
    int sides,
    int count
) {
    PolygonFactory pf = new PolygonFactory();
    float hue = random(0, 360);
    for (int i = 0; i < count; i++) {
        fill(hue, 70, 100, 300);
        Polygon p = pf.createRegularPolygon(
            lightbulb,
            (count - i) * radius / count, sides
        );
        p.setVertices(rotate(p.getVertices(), lightbulb, direction.heading()));
        p.draw();
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