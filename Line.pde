/**
 * Line class that draws a line with texture.
 */
class Line extends Shape {
    float lineWidth;
    
    Line(DistortType distortType, float lineWidth) {
        super(distortType);
        this.lineWidth = lineWidth;
    }
    
    /**
     * Draws a line from (x1, y1) to (x2, y2).
     * See Shape class for more details.
     *
     * @param  x1  x coordinate of start point
     * @param  y1  y coordinate of start point
     * @param  x2  x coordinate of end point
     * @param  y2  y coordinate of end point
     */
    void draw(float x1, float y1, float x2, float y2) {
        Polygon p = pf.createRectangle(x1, y1, x2, y2, this.lineWidth);
        draw(p);
    }
}
