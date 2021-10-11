class CrownFactory {
    Polygon createTriangleCrown(float x, float bottom, float w, float h) {
        ArrayList<PVector> points = new ArrayList<PVector>();
        
        points.add(new PVector(x - w/2, bottom));
        points.add(new PVector(x + w/2, bottom));
        points.add(new PVector(x, bottom - h));
        
        return new Polygon(points);
    }
 }