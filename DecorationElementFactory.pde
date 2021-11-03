class DecorationElementFactory {
    public Polygon createRectangle(float x, float y, float w, float angle) {
        ArrayList<PVector> output = new ArrayList<PVector>();
        PVector rotationCenter = new PVector(x, y);
        
        output.add(new PVector(x - w/2, y - w/2));
        output.add(new PVector(x + w/2, y - w/2));
        output.add(new PVector(x + w/2, y + w/2));
        output.add(new PVector(x - w/2, y + w/2));

        return new Polygon(rotate(output, rotationCenter, angle));
    }
    
    public Polygon createStar(
        float x,
        float y,
        int sides,
        float outerRadius,
        float innerRadius,
        float angle
    ) {
        PolygonFactory pf = new PolygonFactory();
        ArrayList<PVector> output = new ArrayList<PVector>();
        PVector center = new PVector(x, y);
        Polygon outerPoints = pf.createRegularPolygon(center, outerRadius, sides);
        Polygon innerPoints = pf.createRegularPolygon(center, innerRadius, sides);
        ArrayList<PVector> outerPointsArr = rotate(outerPoints.getVertices(), center, angle);
        ArrayList<PVector> innerPointsArr = rotate(innerPoints.getVertices(), center, angle + TWO_PI / (2.0 * sides));

        for (int i = 0; i < sides; i++) {
            output.add(outerPointsArr.get(i));
            output.add(innerPointsArr.get(i));
        }

        return new Polygon(output);
    }

    public Polygon createHollyLeaf(PVector center, float angle, float w, float h) {
        ArrayList<PVector> output = new ArrayList<PVector>();

        output.add(new PVector(0, h/2));
        output.add(new PVector(0, h/2));
        output.add(new PVector(w * 0.2, h * 0.3));
        output.add(new PVector(w/2, h/4));
        output.add(new PVector(w/2, h/4));
        output.add(new PVector(w/4, h/8));
        output.add(new PVector(w/2, 0));
        output.add(new PVector(w/2, 0));
        output.add(new PVector(w/4, -h/8));
        output.add(new PVector(w/2, -h/4));
        output.add(new PVector(w/2, -h/4));
        output.add(new PVector(w * 0.2, -h * 0.3));
        output.add(new PVector(0, -h/2));
        output.add(new PVector(0, -h/2));
        output.add(new PVector(-w * 0.2, -h * 0.3));
        output.add(new PVector(-w/2, -h/4));
        output.add(new PVector(-w/2, -h/4));
        output.add(new PVector(-w/4, -h/8));
        output.add(new PVector(-w/2, 0));
        output.add(new PVector(-w/2, 0));
        output.add(new PVector(-w/4, h/8));
        output.add(new PVector(-w/2, h/4));
        output.add(new PVector(-w/2, h/4));
        output.add(new PVector(-w * 0.2, h * 0.3));

        Polygon p = new Polygon(output);
        p.rotate(angle);
        p.translate(center);

        return p;
    }

}