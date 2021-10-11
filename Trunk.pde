void drawTrunk(Component tree) {
    TrunkFactory tf = new TrunkFactory();

    Component trunk = tree.getSubComponent("trunk");
    
    float treeHeight = tree.getAttrf("height") * c;
    float w = trunk.getAttrf("width") * c;
    float trunkHeight = treeHeight - tree.getSubComponent("crown").getAttrf("height") * c;
    float x = width/2;
    float bottom = (height + treeHeight) / 2;
    
    Shape s = new Shape(DistortType.UNIFORM);
    s.variance = trunk.getAttrf("shapeVariance");
    s.colour = color(trunk.getAttrf("hue"), 100, 30);
    s.alpha = trunk.getAttrf("alpha");

    String trunkShape = trunk.getTraitCategory("trunkShape");
    if (trunkShape.equals("RECTANGLE")) {
        s.draw(tf.createRectangleTrunk(x, bottom, w, trunkHeight));
    } else if (trunkShape.equals("TRAPEZIUM")) {

    } else if (trunkShape.equals("ROOTED")) {

    } else {
        println("Unknown trunk shape");
    }
}