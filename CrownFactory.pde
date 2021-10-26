class CrownFactory {
    Polygon createTriangle(float x, float bottom, float w, float h) {
        ArrayList<PVector> points = new ArrayList<PVector>();
        
        points.add(new PVector(x - w/2, bottom));
        points.add(new PVector(x + w/2, bottom));
        points.add(new PVector(x, bottom - h));
        
        return new Polygon(points);
    }
    
    Polygon createTriangle(PVector p1, PVector p2, float angle) {
        ArrayList<PVector> arr = new ArrayList<PVector>();
        
        try {
            float h = p1.dist(p2);
            arr.add(new PVector(p1.x, p1.y));
            arr.add(new PVector(p2.x, p2.y));
            arr.add(PVector.sub(p2, p1).rotate(-angle).setMag(h / (2 * cos(angle))).add(p1));
        } catch (NullPointerException e) {
            e.printStackTrace();
        }
        
        return new Polygon(arr);
    }
 }