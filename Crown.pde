void drawCrown(Component tree) {
    CrownFactory cf = new CrownFactory();
    
    Component crown = tree.getSubComponent("crown");
    
    float x = width/2;
    float w = crown.getAttrf("width") * c;
    float treeHeight = tree.getAttrf("height") * c;
    float crownHeight = crown.getAttrf("height") * c;
    float crownBottom = (height - treeHeight) / 2 + crownHeight;
    float crownWidth = crown.getAttrf("width") * c;
    String crownShape = crown.getTraitCategory("crownShape");

    Gradient g = new Gradient();
    g.startHue = crown.getAttrf("startHue");
    g.endHue = crown.getAttrf("endHue");
    g.lowBrightness = crown.getAttrf("lowBrightness");
    g.highBrightness = crown.getAttrf("highBrightness");

    Shape s = new Shape(DistortType.UNIFORM);
    s.variance = crown.getAttrf("shapeVariance");
    s.alpha = crown.getAttrf("alpha");
    
    if (crownShape.equals("TRIANGLE")) {
        int parts = (int) crown.getTraitAttr("crownShape", "parts");
        Polygon initTriangle = cf.createTriangle(x, crownBottom, crownWidth, crownHeight);
        String flavor = crown.getTrait("crownShape").getTraitCategory("flavor");
        if (flavor.equals("UNIFORM")) {
            float hue = crown.getTrait("crownShape").getTraitAttrf("flavor", "hue");
            s.colour = color(hue, 100, 80);
            s.draw(initTriangle);
        } else {
            ArrayList<Polygon> subTriangles;

            if (flavor.equals("SERRATED")) {
                subTriangles  = cutTriangleSerrated(initTriangle, parts);
            } else if (flavor.equals("ZIGZAG")) {
                subTriangles  = cutTriangleZigZag(initTriangle, parts);
            } else if (flavor.equals("PARALLEL")) {
                subTriangles  = cutTriangleParallel(initTriangle, parts);
            } else if (flavor.equals("RADIAL")) {
                subTriangles = cutTriangleRadial(initTriangle, parts);
            } else {
                throw new IllegalStateException("Triangle flavor not recognized");
            }

            drawCrownStack(subTriangles, s, g);
        }
    } else if (crownShape.equals("STACKED_TRIANGLES")) {
        int parts = (int) crown.getTraitAttr("crownShape", "parts");
        Polygon initTriangle = cf.createTriangle(x, crownBottom, crownWidth, crownHeight);
        String flavor = crown.getTrait("crownShape").getTraitCategory("flavor");
        ArrayList<Polygon> subTriangles;
        
        if (flavor.equals("SAME_ANGLE")) {
            float angle = crown.getTrait("crownShape").getTraitAttrf("flavor", "angle") * TWO_PI / 360;
            subTriangles = stackTriangles(initTriangle, parts, angle);
        } else {
            throw new IllegalStateException("Tree shape flavor not recognized");
        }
        
        drawCrownStack(subTriangles, s, g);
    } else {
        println("Unknown crown shape");
    }
}

void drawCrownStack(ArrayList<Polygon> subShapes, Shape s, Gradient g) {
    for (int i = 0; i < subShapes.size(); i++) {
        s.colour = g.getColorAt(i / (subShapes.size() - 1.0));
        s.draw(subShapes.get(i));
    }
}

class Gradient {
    float startHue;
    float endHue;
    float lowBrightness;
    float highBrightness;
    float saturation = 100;
    
    color getColorAt(float p) {
        float hue = lerp(startHue, endHue, p);
        float brightness = lerp(lowBrightness, highBrightness, p);
        return color(hue, saturation, brightness);
    }
}