void drawCrown(Component tree) {
    CrownFactory cf = new CrownFactory();
    TriangleStacker ts = new TriangleStacker();
    
    Component crown = tree.getSubComponent("crown");
    
    float x = width/2;
    float w = crown.getAttrf("width") * c;
    float treeHeight = tree.getAttrf("height") * c;
    float crownHeight = crown.getAttrf("height") * c;
    float crownBottom = (height - treeHeight) / 2 + crownHeight;
    float crownWidth = crown.getAttrf("width") * c;
    String shape = crown.getTraitCategory("shape");
    Trait shapeT = crown.getTrait("shape");

    Gradient g = new Gradient();
    g.startHue = crown.getAttrf("startHue");
    g.endHue = crown.getAttrf("endHue");
    g.lowBrightness = crown.getAttrf("lowBrightness");
    g.highBrightness = crown.getAttrf("highBrightness");

    Shape s = new Shape(DistortType.UNIFORM);
    s.variance = crown.getAttrf("shapeVariance");
    s.alpha = 150;
    s.threshold = 5;
    s.depth = 11;
    
    if (shape.equals("SINGLE_SHAPE")) {
        int parts = (int) shapeT.getAttr("parts");
        Polygon initTriangle = cf.createTriangle(x, crownBottom, crownWidth, crownHeight);
        String flavor = shapeT.getTraitCategory("flavor");
        if (flavor.equals("UNIFORM")) {
            float hue = shapeT.getTraitAttrf("flavor", "hue");
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
    } else if (shape.equals("STACKED_SHAPES")) {
        Polygon initTriangle = cf.createTriangle(x, crownBottom, crownWidth, crownHeight);
        String flavor = shapeT.getTraitCategory("flavor");
        ArrayList<Polygon> subShapes;
        
        if (flavor.equals("SAME_ANGLE")) {
            int parts = (int) shapeT.getTraitAttr("flavor", "parts");
            float angle = radians(shapeT.getTraitAttrf("flavor", "angle"));;
            subShapes = ts.stackTriangles(initTriangle, parts, angle);
        } else if (flavor.equals("DIFFERENT_ANGLE")) {
            float coreThickness = shapeT.getTraitAttrf("flavor", "coreThickness");
            float startAngle = radians(shapeT.getTraitAttrf("flavor", "startAngle"));
            float angleIncrement = radians(shapeT.getTraitAttrf("flavor", "angleIncrement"));
            subShapes = ts.stackTriangles(initTriangle, coreThickness, startAngle, angleIncrement);
        } else {
            throw new IllegalStateException("Tree shape flavor not recognized");
        }
        
        Trait baseShapeT = shapeT.getTrait("baseShape");
        TriangleShaper shaper = new TriangleShaper();

        drawCrownStack(shaper.reshape(subShapes, baseShapeT.getCategory()), s, g);
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