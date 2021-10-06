
/**
 * Factoy class containing methods that generate various kinds of polygons.
 */
class PolygonFactory {
    /**
     * Creates a rectangle that goes from start to end points with the given
     * width.
     *
     * @param  start    start point
     * @param  end      end point
     * @param  width    rectangle width
     * @return          polygon in the shape of rectangle
     */
    Polygon createRectangle(PVector start, PVector end, float width) {
        ArrayList<PVector> rectangle = new ArrayList<PVector>();
        
        PVector temp = PVector.sub(end, start);

        temp.rotate(HALF_PI);
        temp.setMag(width/2);

        rectangle.add(PVector.add(start, temp));
        rectangle.add(PVector.add(end, temp));
        
        temp.rotate(PI);
        
        rectangle.add(PVector.add(end, temp));
        rectangle.add(PVector.add(start, temp));

        return new Polygon(rectangle);
    }
    
    /**
     * Creates a rectangle that goes from (x1, y1) to (x2, y2) and has given
     * width.
     *
     * @param  x1       start point x coordinate
     * @param  y1       start point y coordinate
     * @param  x2       end point x coordinate
     * @param  y2       end point y coordinate
     * @param  width    rectangle width
     * @return          polygon in the shape of rectangle
     */
    Polygon createRectangle(float x1, float y1, float x2, float y2, float width) {
        return createRectangle(new PVector(x1, y1), new PVector(x2, y2), width);
    }

    /**
     * Creates a regular n-gon centered at center with a given radius.
     *
     * @param  center   polygon center point
     * @param  radius   polygon radius
     * @param  nSides   number of sides
     * @return          polygon in the shape of regular n-gon
     */
    Polygon createRegularPolygon(PVector center, float radius, int nSides) {
        ArrayList<PVector> points = new ArrayList<PVector>();
        float angle = TWO_PI / nSides;
        for (int i = 0; i < nSides; i++) {
           points.add(new PVector(center.x + cos(angle * i) * radius, center.y + sin(angle * i) * radius));
        }
        
        return new Polygon(points);
    }
}