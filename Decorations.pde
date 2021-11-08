void drawOrnaments(Component tree) {
    ArrayList<Component> ornaments = tree
        .getSubComponent("crown")
        .getSubComponent("decorations")
        .getSubComponentList("ornament");
    ArrayList<ECircle> positions = tryGetFreePositions(tree, ornaments.size(), 3*c);
    for (int i = 0; i < positions.size(); i++) {
        drawOrnament(positions.get(i).center, ornaments.get(i));
    }
}

void drawOrnament(PVector position, Component ornament) {
    String type = ornament.getTraitCategory("type");
    if (type.equals("BALL")) {
        drawBallOrnament(position, ornament);
    } else if (type.equals("SQUARE")) {
        drawSquareOrnament(position, ornament);
    } else if (type.equals("HOLLY_DECORATION")) {
        drawHollyDecoration(position, ornament);
    } else if (type.equals("BELL")) {
        drawBellDecoration(position, ornament);
    } else if (type.equals("CANDY_CANE")) {
        drawCandyCaneDecoration(position, ornament);
    }
} 

void drawCandyCaneDecoration(PVector position, Component ornament) {
    Trait type = ornament.getTrait("type");

    float angle = radians(type.getAttrf("angle"));
    float stripesAngle = radians(type.getAttrf("stripesAngle"));
    float w = type.getAttrf("width") * c;
    float h = type.getAttrf("height") * c;
    float radius = type.getAttrf("radius") * c;
    float curvingAngle = radians(type.getAttrf("curvingAngle"));
    int stripeDensity = (int) type.getAttrf("stripeDensity");

    DecorationElementFactory def = new DecorationElementFactory ();
    color[] colors = new color[2];
    colors[0] = color(358, 86, 76);
    colors[1] = color(0, 0, 100);

    RPolygon candyCane = def.createCandyCane(position, w, h, angle, radius, curvingAngle);
    drawStripedShape(candyCane.toShape(), stripesAngle, stripeDensity, colors);
}

void drawStripedShape(
    RShape mask,
    float angle,
    int stripes,
    color[] colors)
{
    RPoint[] bounds = mask.getBoundsPoints();
    RPoint center = new RPoint(
        (bounds[0].x + bounds[2].x)/2,
        (bounds[0].y + bounds[2].y)/2
    );
    float sideLength = bounds[0].dist(bounds[2]);
    float stripeThickness = sideLength / stripes;
    
    for (int i = 0; i < stripes; i++) {
        float x = center.x - sideLength/2;
        float y = center.y - sideLength/2 + i * stripeThickness;
        RShape stripe = RShape.createRectangle(x, y, sideLength, stripeThickness);
        stripe.rotate(angle, center);
        fill(colors[i % colors.length]);
        RShape masked = stripe.intersection(mask);
        RG.shape(masked);
    }
}

void drawBellDecoration(PVector position, Component ornament) {
    DecorationElementFactory def = new DecorationElementFactory();

    Trait bell = ornament.getTrait("type");
    float angle = radians(bell.getAttrf("angle"));
    float h = bell.getAttrf("height") * c;
    float w = bell.getAttrf("width") * c;

    pushMatrix();
    translate(position.x, position.y);
    fill(46, 55, 60);
    ellipse(0, h/2, w/3, w/3);
    popMatrix();

    drawHollyDecoration(PVector.add(position, new PVector(0, -h * 0.4)), ornament);

    Polygon bellBase = def.createBell(position, angle, w, h);
    Polygon bellSmooth = chaikinSmooth(bellBase, 0.3, 4, true);
    fill(46, 55, 83);
    bellSmooth.draw();
}

void drawHollyDecoration(PVector position, Component ornament) {
    fill(color(0, 0, 0));
    Trait hollyDecoration = ornament.getTrait("type");
    float angle = radians(hollyDecoration.getAttrf("angle"));
    ArrayList<Component> bgLeaves = hollyDecoration.getSubComponentList("bgLeaf");
    fill(74, 90, 74);
    for (int i = 0; i < bgLeaves.size(); i++) {
        float w = bgLeaves.get(i).getAttrf("width") * c;
        float h = bgLeaves.get(i).getAttrf("height") * c;
        float angleDisplacement = radians(bgLeaves.get(i).getAttrf("angleDisplacement"));
        float leafAngle = angle + (4 + 2 * i) * TWO_PI / 6 + angleDisplacement;
        PVector leafPosition = (new PVector(h/2, 0)).rotate(leafAngle).add(position);
        drawHollyLeaf(leafPosition, leafAngle + HALF_PI, w, h);
    }

    fill(156, 65, 30);
    ArrayList<Component> fgLeaves = hollyDecoration.getSubComponentList("fgLeaf");
    for (int i = 0; i < fgLeaves.size(); i++) {
        float w = fgLeaves.get(i).getAttrf("width") * c;
        float h = fgLeaves.get(i).getAttrf("height") * c;
        float angleDisplacement = radians(fgLeaves.get(i).getAttrf("angleDisplacement"));
        float leafAngle = angle + (3 + 2 * i) * TWO_PI / 6 + angleDisplacement;
        PVector leafPosition = (new PVector(h/2, 0)).rotate(leafAngle).add(position);
        drawHollyLeaf(leafPosition, leafAngle + HALF_PI, w, h);
    }

    ArrayList<Component> berries = hollyDecoration.getSubComponentList("berry");
    for (int i = 0; i < berries.size(); i++) {
        float brightness = berries.get(i).getAttrf("brightness");
        float berryAngle = radians(berries.get(i).getAttrf("angle"));
        float dist = berries.get(i).getAttrf("dist") * c;
        drawHollyBerry(position, dist, berryAngle, brightness);
    }
}

void drawHollyLeaf(PVector position, float angle, float w, float h) {
    DecorationElementFactory def = new DecorationElementFactory();
    Polygon leafBase = def.createHollyLeaf(position, angle, w, h);
    Polygon leafSmooth = chaikinSmooth(leafBase, 0.3, 4, true);
    leafSmooth.draw();
}

void drawHollyBerry(PVector position, float dist, float angle, float brightness) {
    fill(357, 86, brightness);
    pushMatrix();

    translate(position.x + dist * cos(angle), position.y + dist * sin(angle));
    ellipse(0, 0, c * 0.8, c * 0.8);

    popMatrix();
}

void drawBallOrnament(PVector position, Component ornament) {
    Trait ornamentType = ornament.getTrait("type");
    float baseHue = ornamentType.getAttrf("baseHue");
    float radius = ornamentType.getAttrf("radius") * c;
    Trait ballType = ornamentType.getTrait("type");
    String ballCategory = ballType.getCategory();
    color ballColor = color(baseHue, 86, 80);
    if (ballCategory.equals("UNIFORM")) {
        drawUniformCircle(position, radius, ballColor);
    } else if (ballCategory.equals("STRIPED")) {
        float angle = ballType.getAttrf("angle");
        drawStripedCircle(position, radius, angle, ballColor);
    } else if (ballCategory.equals("STAR")) {
        float angle = ballType.getAttrf("angle");
        drawStarCircle(position, radius, angle, ballColor);
    } else if (ballCategory.equals("CONCENTRIC")) {
        drawConcentricCircle(position, radius, round(baseHue));
    } else {
        throw new IllegalStateException("Unknown ball shape.");
    }
}

void drawUniformCircle(PVector center, float radius, color c) {
    fill(c);
    ellipse(center.x, center.y, 2 * radius, 2 * radius);
}

void drawStripedCircle(PVector center, float radius, float angle, color c) {
    pushMatrix();

    translate(center.x, center.y);
    rotate(radians(angle));

    RShape mask = RShape.createEllipse(0, 0, radius * 2, radius * 2);
    int stripeNum = 5;
    float stripeThickness = 2 * radius / stripeNum;
    for (int i = 0; i < stripeNum; i++) {
        RShape strip = RShape.createRectangle(
            -radius,
            -radius + i * stripeThickness,
            2 * radius,
            stripeThickness
        );
        RShape masked = strip.intersection(mask);
        masked.setStroke(false);
        fill(i % 2 == 0 ? c : color(360, 0, 100));
        RG.shape(masked);
    }

    popMatrix();
}

void drawStarCircle(PVector position, float radius, float angle, color c) {
    pushMatrix();

    translate(position.x, position.y);
    rotate(angle);

    drawUniformCircle(new PVector(0, 0), radius, c);
    RShape star = RShape.createStar(0, 0, radius * 1.7, radius * 0.9, 5);
    fill(color(360, 0, 100));
    RG.shape(star);

    popMatrix();
}

void drawConcentricCircle(PVector position, float radius, int baseHue) {
    pushMatrix();

    translate(position.x, position.y);
    int currentHue = (baseHue + 40) % 360;
    fill(color((baseHue + 310) % 360, 80, 100));
    ellipse(0, 0, 2 * radius, 2 * radius);
    fill(color(baseHue, 80, 100));
    ellipse(0, 0, 1.8 * radius, 1.8 * radius);
    fill(color((baseHue + 50) % 360, 80, 100));
    ellipse(0, 0, radius, radius);
    fill(color(baseHue, 80, 100));
    ellipse(0, 0, 0.8 * radius, 0.8 * radius);
    fill(color((baseHue + 180) % 360, 80, 100));
    ellipse(0, 0, 0.2 * radius, 0.2 * radius);

    popMatrix();
}

void drawSquareOrnament(PVector position, Component ornament) {
    Trait ornamentType = ornament.getTrait("type");
    float baseHue = ornamentType.getAttrf("baseHue");
    float radius = ornamentType.getAttrf("radius") * c;
    float angle = ornamentType.getAttrf("angle");
    Trait squareType = ornamentType.getTrait("type");
    String squareCategory = squareType.getCategory();
    color squareColor = color(baseHue, 86, 80);
    if (squareCategory.equals("UNIFORM")) {
        drawUniformSquare(position, radius, angle, color(baseHue, 80, 100));
    } else if (squareCategory.equals("STRIPED")) {
        float ratio = squareType.getAttrf("ratio");
        drawStripedSquare(position, radius, ratio, angle, color(baseHue, 80, 100));
    } else if (squareCategory.equals("CONCENTRIC")) {
        drawConcentricSquare(position, radius, angle, baseHue);
    } else if (squareCategory.equals("STAR")) {
        drawStarredSquare(position, radius, angle, baseHue);
    }
}

void drawConcentricSquare(PVector position, float radius, float angle, float baseHue) {
    color[] colors = new color[3];
    colors[0] = color(baseHue, 32, 80);
    colors[1] = color((baseHue + 263) % 360, 53, 90);
    colors[2] = color((baseHue + 54) % 360, 66, 70);
    for (int i = 0; i < 3; i++) {
        drawUniformSquare(position, radius * (float)Math.pow((3.0 - i)/ 3, 2), angle, colors[i]);
    }
}

void drawStarredSquare(PVector position, float radius, float angle, float baseHue) {
    drawUniformSquare(position, radius, angle, color(baseHue, 30, 80));
    pushMatrix();
    translate(position.x, position.y);
    rotate(radians(angle) + PI / 4);
    RShape star = RShape.createStar(0, 0, radius * 2, radius * 0.5, 4);
    fill(color((baseHue + 30) % 360, 50, 60));
    RG.shape(star);
    popMatrix();
}

void drawStripedSquare(PVector position, float radius, float ratio, float angle, color c) {
    int stripes = 3;
    float w = getSquareWidth(radius);
    float stripHeight = w / stripes;
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle);
    fill(color((hue(c) + 60) % 360, 40, 100));
    rect(-w/2, -w/2, w, w);
    fill(c);
    for (int i = 0; i <= stripes; i++) {
        rect(-w/2, -w/2 + i*stripHeight, w, stripHeight*ratio);
    }
    popMatrix();
}

void drawUniformSquare(PVector position, float radius, float angle, color c) {
    pushMatrix();

    translate(position.x, position.y);
    float w = getSquareWidth(radius);
    rotate(radians(angle));
    fill(c);
    rect(-w/2, -w/2, w, w);
    
    popMatrix();
}

ArrayList<ECircle> tryGetFreePositions(Component tree, int n, float radius) {
    int attempts = 100;
    ArrayList<ECircle> output = new ArrayList<ECircle>();
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < attempts; j++) {
            PVector randTreePt = getRandomTreePoint(tree);
            ECircle particle = new ECircle(randTreePt, radius);
            if (!particle.isOverlapping(particles) && !particle.isOverlapping(output)) {
                output.add(particle);
                break;
            }
        }
    }
    return output;
}

PVector getRandomTreePoint(Component tree) {
    float randomY = getHeightFromRatio(tree, random(0.1, 0.9));
    PVector randomBoundary = getClosestBoundaryPoint(randomY);
    float w = width - 2 * randomBoundary.x;
    float randomX = random(randomBoundary.x + 0.1 * w, randomBoundary.x + 0.9 * w);

    return new PVector(randomX, randomBoundary.y);
}

PVector getClosestBoundaryPoint(float h) {
    float y = h;
    while (true) {
        for (int i = 0; i < width / 2; i++) {
            if (getPixel(i, floor(y)) != color(360, 0, 100)) {
                return new PVector(i, y);
            }
        }
        if (y > height/2) {
            y -= 1;
        } else {
            y += 1;
        }
    }
}

float getHeightFromRatio(Component tree, float r) {
    if (r >= 0 && r <= 1) {
        float crownHeight = tree.getSubComponent("crown").getAttrf("height") * c;
        float treeHeight = tree.getAttrf("height") * c;

        return (height - treeHeight) / 2 + (1 - r) * crownHeight;
    } else {
        throw new IllegalArgumentException("Percentage must be in [0, 1] range.");
    }
}

float getSquareWidth(float radius) {
    return 1.41421 * radius;
}
