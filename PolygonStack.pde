/**
 * Class that contains, manipulates and renders polygon stacks.
 */
class PolygonStack {
    ArrayList<Polygon> stack;
    float alpha;
    color c;
    
    void setAlpha(float alpha) {
        this.alpha = alpha;
    }
    
    float getAlpha() {
        return this.alpha;
    }
    
    void setColor(color c) {
        this.c = c;
    }
    
    color getColor() {
        return this.c;
    }
    
    PolygonStack() {
        this.stack = new ArrayList<Polygon>();
    }
    
    PolygonStack(color c, float alpha) {
        this.c = c;
        this.alpha = alpha;
        this.stack = new ArrayList<Polygon>();
    }

    /**
     * Increments the alpha parameter.
     *
     * @param  inc  increment value
     */
    void incrementAlpha(float inc) {
        this.alpha += inc;
        if (this.alpha < 0) {
            this.alpha = 0;
        } else if (this.alpha > 100) {
            this.alpha = 100;
        }
    }
    
    /**
     * Adds polygon to the stack
     *
     * @param  p  polygon
     */
    void add(Polygon p) {
        this.stack.add(p);
    }
    
    /**
     * Draws the polygon stack.
     */
    void draw() {
        for (Polygon p : this.stack) {
            fill(c, alpha);
            p.draw();
        }
    }
    
    /**
     * Draws the polygon stack, but changes the alpha value in every iteration.
     *
     * @param  alphaIncrement  amount of change per iteration
     */
    void draw(float alphaIncrement) {
        for (Polygon p : this.stack) {
            p.draw(c, alpha);
            this.alpha += alphaIncrement;
        }
    }
}