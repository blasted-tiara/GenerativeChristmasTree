void drawTrunk(Component tree) {
    TrunkFactory tf = new TrunkFactory();

    Component trunk = tree.getSubComponent("trunk");
    Trait trunkShapeT = trunk.getTrait("trunkShape");
    Component trunkColorT = trunk.getSubComponent("trunkColor");
    
    float treeHeight = tree.getAttrf("height") * c;
    float w = trunk.getAttrf("width") * c;
    float trunkHeight = treeHeight - tree.getSubComponent("crown").getAttrf("height") * c;
    trunkHeight += 5 * c;
    float x = width/2;
    float bottom = (height + treeHeight) / 2;
    float brightness = 30;
    float hue = trunkColorT.getAttrf("hue");
    
    Shape s = new Shape(DistortType.UNIFORM);
    s.variance = trunk.getAttrf("shapeVariance");
    s.colour = color(hue, 100, brightness);
    s.alpha = trunkColorT.getAttrf("alpha");
    s.depth = 2;

    Polygon baseShape;
    String trunkShape = trunk.getTraitCategory("trunkShape");
    if (trunkShape.equals("RECTANGLE")) {
        baseShape = tf.createRectangleTrunk(x, bottom, w, trunkHeight);
    } else if (trunkShape.equals("TRAPEZIUM")) {
        float angle = radians(trunkShapeT.getAttrf("angle"));
        float upperWidth = 2 * trunkHeight / tan(angle);
        baseShape = tf.createTrapeziumTrunk(x, bottom, w, upperWidth, trunkHeight);
    } else {
        throw new IllegalStateException("Unknown trunk shape.");
    }

    Trait coloringTypeT = trunkColorT.getTrait("coloringType");
    String coloringType = coloringTypeT.getCategory();

    if (coloringType.equals("UNIFORM")) {
        s.draw(baseShape);
    } else if (coloringType.equals("SHADED")) {
        ArrayList<Polygon> parts = cutRectangle(baseShape, 2);
        float shadeValue = coloringTypeT.getAttrf("shadeValue");
        s.draw(parts.get(0));
        s.colour = color(hue, 100, shadeValue);
        s.draw(parts.get(1));
    } else if (coloringType.equals("GRADIENT")) {
        float darkestShade = coloringTypeT.getAttrf("darkestShade");
        int steps = (int) coloringTypeT.getAttrf("steps");

        Gradient g = new Gradient();
        g.startHue = hue;
        g.endHue = hue;
        g.startBrightness = brightness;
        g.endBrightness = darkestShade;

        ArrayList<Polygon> parts = cutRectangle(baseShape, steps);
        for (int i = 0; i < parts.size(); i++) {
            s.colour = g.getColorAt(i / (parts.size() - 1.0));
            s.draw(parts.get(i));
        }
    } else {
        throw new IllegalStateException("Uknown coloring type");
    }
}
