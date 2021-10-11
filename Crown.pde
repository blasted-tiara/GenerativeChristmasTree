void drawCrown(Component tree) {
    CrownFactory cf = new CrownFactory();
    
    Component crown = tree.getSubComponent("crown");
    
    float x = width/2;
    float w = crown.getAttrf("width") * c;
    float treeHeight = tree.getAttrf("height") * c;
    float crownHeight = crown.getAttrf("height") * c;
    float crownBottom = (height - treeHeight) / 2 + crownHeight;
    float crownWidth = crown.getAttrf("width") * c;
    float hue = crown.getAttrf("hue");
    float hueDecrement = crown.getAttrf("hueDecrement");
    float brightness = crown.getAttrf("brightness");
    float brightnessIncrement = crown.getAttrf("brightnessIncrement");
    String crownShape = crown.getTraitCategory("crownShape");
    

    Shape s = new Shape(DistortType.UNIFORM);
    s.variance = crown.getAttrf("shapeVariance");
    s.alpha = crown.getAttrf("alpha");
    s.colour = color(hue, 100, 30);
    
    if (crownShape.equals("TRIANGLE")) {
        Polygon initTriangle = cf.createTriangleCrown(x, crownBottom, crownWidth, crownHeight);
        ArrayList<Polygon> subTriangles = cutTriangleSawtooth(initTriangle, 7);
        for (Polygon p: subTriangles) {
            s.colour = color(hue, 100, brightness);
            s.draw(p);
            hue -= hueDecrement;
            brightness += brightnessIncrement;

        }
    } else {
        println("Unknown crown shape");
    }
}