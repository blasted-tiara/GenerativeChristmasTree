void drawCrown(Component tree) {
    CrownFactory cf = new CrownFactory();
    
    Component crown = tree.getSubComponent("crown");
    
    float x = width/2;
    float w = crown.getAttrf("width") * c;
    float treeHeight = tree.getAttrf("height") * c;
    float crownHeight = crown.getAttrf("height") * c;
    float crownBottom = (height - treeHeight) / 2 + crownHeight;
    float crownWidth = crown.getAttrf("width") * c;
    float startHue = crown.getAttrf("startHue");
    float endHue = crown.getAttrf("endHue");
    float lowBrightness = crown.getAttrf("lowBrightness");
    float highBrightness = crown.getAttrf("highBrightness");
    int parts = (int) crown.getTraitAttr("crownShape", "parts");
    String crownShape = crown.getTraitCategory("crownShape");

    Shape s = new Shape(DistortType.UNIFORM);
    s.variance = crown.getAttrf("shapeVariance");
    s.alpha = crown.getAttrf("alpha");
    
    if (crownShape.equals("TRIANGLE")) {
        Polygon initTriangle = cf.createTriangleCrown(x, crownBottom, crownWidth, crownHeight);
        String triangleFlavor = crown.getTrait("crownShape").getTraitCategory("triangleFlavor");
        if (triangleFlavor.equals("UNIFORM")) {
            float hue = crown.getTrait("crownShape").getTraitAttrf("triangleFlavor", "hue");
            s.colour = color(hue, 100, 80);
            s.draw(initTriangle);
        } else {
            ArrayList<Polygon> subTriangles;

            if (triangleFlavor.equals("SERRATED")) {
                subTriangles  = cutTriangleSerrated(initTriangle, parts);
            } else if (triangleFlavor.equals("ZIGZAG")) {
                subTriangles  = cutTriangleZigZag(initTriangle, parts);
            } else if (triangleFlavor.equals("PARALLEL")) {
                subTriangles  = cutTriangleParallel(initTriangle, parts);
            } else if (triangleFlavor.equals("RADIAL")) {
                subTriangles = cutTriangleRadial(initTriangle, parts);
            } else {
                throw new IllegalStateException("Triangle flavor not recognized");
            }

            for (int i = 0; i < subTriangles.size(); i++) {
                float hue = lerp(startHue, endHue, i / (subTriangles.size() - 1.0));
                float brightness = lerp(lowBrightness, highBrightness, i / (subTriangles.size() - 1.0));
                s.colour = color(hue, 100, brightness);
                s.draw(subTriangles.get(i));
            }
        }
    } else {
        println("Unknown crown shape");
    }
}