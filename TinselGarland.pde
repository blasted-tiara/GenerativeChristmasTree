void drawTinselGarland(Component tree) {
    ArrayList<Component> tinselGarlands = (ArrayList<Component>) tree
        .getSubComponent("crown")
        .getSubComponent("decorations")
        .getSubComponentList("tinselGarland");
    loadPixels();
    for (int i = 0; i < tinselGarlands.size(); i++) {
        PVector p0 = getBoundaryPoint(tree, random(0.1, 0.4));
        PVector p1 = getBoundaryPoint(tree, random(0.6, 0.9));
        String type = tinselGarlands.get(i).getTraitCategory("type");
        ArrayList<PVector> initPts = getInitPts(p0, p1);
        ArrayList<PVector> lineArr = chaikinSmooth(initPts, 0.2, 4, false);
        PCurve pc = new PCurve(lineArr);
        ArrayList<PVector> tinselGarlandArr = pc.cutEqualParts(15.0);
        drawTinselGarland(tinselGarlandArr, type);
    }
}

void drawTinselGarland(ArrayList<PVector> path, String type) {
    for (PVector p: path) {
        particles.add(new ECircle(p, c));
    }
    if (type.equals("STRIP_LIKE")) {
        Line l = new Line(DistortType.POINT_BIASED, 1);
        l.distCoeff = 4;
        l.depth = 6;
        l.variance = 0.6;
        l.alpha = 80;
        l.colour = color(random(0, 360), 60, 100);

        drawLine(path, l);
    } else if (type.equals("FLUFFY")) {
        PolygonFactory pf = new PolygonFactory();
        Shape s = new Shape(DistortType.POINT_BIASED);
        s.distCoeff = -1;
        s.variance = .5;
        s.depth = 10;
        s.threshold = 3;
        s.odd = true;
        s.alpha = 100;
        float hue = random(0, 360);
        for (int i = 0; i < path.size(); i++) {
            s.colour = color(hue, random(20, 70), 100);
            s.bias(path.get(i).x, path.get(i).y);
            s.draw(pf.createRegularPolygon(path.get(i), 2, 5));
        }
    } else {
        throw new IllegalArgumentException("Tinsel garland type not recognized.");
    }
}
