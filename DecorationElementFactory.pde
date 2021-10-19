class DecorationElementFactory {
    public Polygon createRectangle(float x, float y, float w, float angle) {
        ArrayList<PVector> output = new ArrayList<PVector>();
        
        output.add(new PVector(x - w/2, y - w/2));
        output.add(new PVector(x + w/2, y - w/2));
        output.add(new PVector(x + w/2, y + w/2));
        output.add(new PVector(x - w/2, y + w/2));
        
        PVector centre = new PVector(x, y);
        for (PVector p: output) {
            rotatePoint()
        }
        
        return new Polygon(output);
    }
    
    public Polygon create
}