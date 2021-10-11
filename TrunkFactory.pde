class TrunkFactory {
    Polygon createRectangleTrunk(float x, float bottom, float w, float h) {
        return createTrapeziumTrunk(x, bottom, w, w, h);
    }
    
    Polygon createTrapeziumTrunk(float x, float bottom, float lowerW, float upperW, float h) {
        ArrayList<PVector> points = new ArrayList<PVector>();
        
        points.add(new PVector(x - upperW/2, bottom - h));
        points.add(new PVector(x + upperW/2, bottom - h));
        points.add(new PVector(x + lowerW/2, bottom));
        points.add(new PVector(x - lowerW/2, bottom));
        
        return new Polygon(points);
    }
}