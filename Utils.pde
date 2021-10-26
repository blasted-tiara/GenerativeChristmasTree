/*
 * Rotates a point p around center for a specified amount of radians.
 * 
 * @input p         Point to be rotated 
 * @input center    Pivot point of rotation
 * @input angle     Amount of radians
 * @return          New PVector object that represents the rotated point
 */
PVector rotate(PVector point, PVector center, float angle) {
    return PVector.sub(point, center).rotate(angle).add(center);
}

ArrayList<PVector> rotate(ArrayList<PVector> points, PVector center, float angle) {
    ArrayList<PVector> output = new ArrayList<PVector>();

    for (PVector p: points) {
        output.add(rotate(p, center, angle));
    }

    return output;
}

/*
 * Rotates a point p around center for a specified amount of radians.
 * 
 * @input pX        X coordinate of the point to be rotated 
 * @input pY        Y coordinate of the point to be rotated 
 * @input centerX   X coordinate of the pivot point of rotation
 * @input centerY   Y coordinate of the pivot point of rotation
 * @input angle     Amount of radians
 * @return          New PVector object that represents the rotated point
 */
PVector rotate(float pX, float pY, float centerX, float centerY, float angle) {
    PVector p = new PVector(pX, pY);
    PVector center = new PVector(centerX, centerY);
    return rotate(p, center, angle);
}

void drawLine(ArrayList<PVector> points) {
    stroke(0);
    PVector a, b;
    for (int i = 0; i < points.size() - 1; i++) {
        a = points.get(i);
        b = points.get(i + 1);
        line(a.x, a.y, b.x, b.y);
    }
    noStroke();
}

void drawLine(ArrayList<PVector> points, Line l) {
    PVector a, b;
    for (int i = 0; i < points.size() - 1; i++) {
        a = points.get(i);
        b = points.get(i + 1);
        l.bias((a.x + b.x)/2, (a.y + b.y)/2);
        l.draw(a.x, a.y, b.x, b.y);
    }
}

void drawPoint(PVector point, float radius) {
    ellipse(point.x, point.y, radius, radius);
}

/**
 * Draws dots of specified radius at each position contained in the input array.
 * 
 * @param points    coordinates at which points are to be drawn 
 * @param radius    radius of points
 */
void drawPoints(ArrayList<PVector> points, float radius) {
    for (PVector p: points) {
        drawPoint(p, radius);
    }
}

/**
 * Draws dots of specified radius and color at each position contained in the input array.
 * 
 * @param points    coordinates at which points are to be drawn 
 * @param c         dot color
 * @param radius    radius of points
 */
void drawPoints(ArrayList<PVector> points, color c, float radius) {
    color prevColor = g.fillColor;
    fill(c);
    drawPoints(points, radius);
    fill(prevColor);
}

/**
 * Calculates a point between 2 input points at a specified increment by
 * linear interpolation.
 *
 * @param  startPoint   start point
 * @param  endPoint     end point
 * @param  ratio        ratio at which the calculated point is to be placed
 * @return              new point at a specified ratio between two input points
 */
PVector lerp(PVector startPoint, PVector endPoint, float ratio) {
    return new PVector(lerp(startPoint.x, endPoint.x, ratio), lerp(startPoint.y, endPoint.y, ratio));
}

/**
 * Enum that represents left or right side.
 */
enum Side {
    LEFT,
    RIGHT
}

class Rectangle {
    float left;
    float right;
    float top;
    float bottom;
    
    Rectangle(float left, float right, float top, float bottom) {
        this.left = left;
        this.right = right;
        this.top = top;
        this.bottom = bottom;
    }
}

/**
 * Flips the array of points horizontally around some vertical axis.
 * This function changes the points from the input array.
 *
 * @param points    input points
 * @param x         x coordinate of the flip axis
 */
void flipHorizontal(ArrayList<PVector> points, float x) {
    for (PVector p: points) {
        p.x = -p.x + 2 * x;
    }
}

/**
 * Connects pairs of points with the same index.
 * If one array has more points than the other, some points are dropped from it
 * in order to make the pairing possible.
 *
 * @param l             line object that will do the drawing
 * @param startPoints   start points
 * @param endPoints     end points
 */
void connectTheDots(Line l, ArrayList<PVector> startPoints, ArrayList<PVector> endPoints) {
    if (startPoints.size() > endPoints.size()) {
        startPoints = Utils.symmetricTrimDownsample(startPoints, startPoints.size() - endPoints.size());
    } else if (startPoints.size() < endPoints.size()) {
        endPoints = Utils.symmetricTrimDownsample(endPoints, endPoints.size() - startPoints.size());
    }

    for (int i = 0; i < startPoints.size(); i++) {
        //float lightness = random(-1, 6) > 0 ? (85 + randomGaussian() * 10) % 100 : random(10, 30);
        float lightness = (85 + randomGaussian() * 10) % 100;
        l.colour = color(360, 0, lightness);
        l.draw(
            startPoints.get(i).x,
            startPoints.get(i).y,
            endPoints.get(i).x,
            endPoints.get(i).y
        ); 
    }
}

/**
 * Randomizes the points from the input vector according to the given variances.
 *
 * @param points    input points
 * @param xVariance x axis random variable variance
 * @param yVariance y axis random variable variance
 */
void randomizePoints(ArrayList<PVector> points, float xVariance, float yVariance) {
    for (PVector p: points) {
        p.x = p.x + randomGaussian() * xVariance;
        p.y = p.y + randomGaussian() * yVariance;
    }
}

Rectangle getBoundingBox(ArrayList<PVector> inputShape) {
    Rectangle output = new Rectangle(
        inputShape.get(0).x,
        inputShape.get(0).x,
        inputShape.get(0).y,
        inputShape.get(0).y
    );

    for (int i = 1; i < inputShape.size(); i++) {
        PVector p = inputShape.get(i);
        if (p.x < output.left) {
            output.left = p.x;
        }
        if (p.x > output.right) {
            output.right = p.x;
        }
        if (p.y > output.bottom) {
            output.bottom = p.y;
        }
        if (p.y < output.top) {
            output.top = p.y;
        }
    }
    
    return output;
}

void drawRectangle(Rectangle r) {
    rectMode(CORNERS);
    fill(100);
    alpha(50);
    rect(r.left, r.top, r.right, r.bottom);
}
