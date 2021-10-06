
/**
 * Class used for drawing generative shapes with various textures.
 */
class Shape {
    protected PolygonTransformer pt = new PolygonTransformer();
    protected PolygonFactory pf = new PolygonFactory();
    protected PVector bias = new PVector(width/2, height/2);
    DistortType distortType;
    color colour;
    float alpha = 100;
    float variance = 3;
    float distCoeff = 1;
    int threshold = 0;
    int depth = 15;
    boolean relative = false;
    boolean odd = false;
    
    Shape(DistortType distortType) {
       this.distortType = distortType; 
    }

    protected Polygon transform(Polygon p) {
        switch (this.distortType) {
            case UNIFORM:
                    return pt.uniformDistort(p, variance, this.odd);
            case POINT_BIASED:
                if (bias == null) {
                    throw new NullPointerException("Bias point cannot be null.");
                }
                return pt.pointBiasedDistort(p, variance, bias, distCoeff, this.relative, this.odd);
            case VECTOR_BIASED:
                if (bias == null) {
                    throw new NullPointerException("Bias vector cannot be null.");
                }
                return pt.vectorBiasedDistort(p, variance, bias, distCoeff, this.relative, this.odd);
            case ROTATIONAL:
                if (bias == null) {
                    throw new NullPointerException("Rotation center cannot be null.");
                }
                return pt.rotationalDistort(p, variance, bias, distCoeff, this.relative, this.odd);
            default:
               return p; 
        }
    }
    
    /**
     * Draws a shape with texture.
     * This method does a lot of heavy lifting, since it first generates the line as
     * a polygon stack of given depth, and then does the drawing to the screen.
     * 
     * FIXME: This is not so nicely designed and should be separated in several
     * functions in the future.
     *
     * @param p initial polygon out of which every other layer is generated 
     */
    void draw(Polygon p) {
        PolygonStack ps = new PolygonStack(this.colour, this.alpha);

        if (this.threshold == 0) {
            ps.add(p);
        }
        for (int i = 0; i < this.depth; i++) {
            p = transform(p);
            if (i >= this.threshold - 1) {
                ps.add(p);
            }
        }
        ps.draw();
    }

    /**
     * Sets the bias point that is important for some types of shapes.
     * Default bias point is in the center of the rendering area.
     * If for some reason bias point null when draw() function is called,
     * NullPointerException will be thrown and the program will freeze/crash.
     *
     * @param  x  x coordinate of bias point
     * @param  y  y coordinate of bias point
     */
    void bias(float x, float y) {
        this.bias = new PVector(x, y);
    }
}