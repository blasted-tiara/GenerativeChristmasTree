class ECircle {
    PVector center;
    float radius;

    public ECircle(float x, float y, float radius) {
        this(new PVector(x, y), radius);
    }

    public ECircle(PVector center, float radius) {
        if (center != null && radius > 0) {
            this.center = center;
            this.radius = radius;
        } else {
            if (center == null) {
                throw new IllegalArgumentException("Center cannot be null.");
            }
            if (radius <= 0) {
                throw new IllegalArgumentException("Radius must be positive.");
            }
        }
    }

    boolean isTouching(ECircle c) {
        return (this.radius + c.radius) >= this.center.dist(c.center);
    }

    boolean isOverlapping(ECircle c) {
        return (this.radius + c.radius) > this.center.dist(c.center);
    }

    boolean isOverlapping(ArrayList<ECircle> input) {
        for (ECircle c: input) {
            if (isOverlapping(c)) {
                return true;
            }
        }
        return false;
    }

    void draw() {
        noFill();
        stroke(0);
        ellipse(center.x, center.y, 2 * radius, 2 * radius);
    }
}

void drawAllParticles() {
    for (ECircle p: particles) {
        p.draw();
    }
}