ArrayList<PVector> chaikinSmooth(ArrayList<PVector> points, float ratio, int iterations, boolean closed) {
    if (iterations == 0) {
        return points;
    }
    
    ArrayList<PVector> output = new ArrayList<PVector>();
    int numCorners = closed ? points.size() : points.size() - 1;
    
    for (int i = 0; i < numCorners; i++) {
        PVector a = points.get(i);
        PVector b = points.get((i + 1) % points.size());
        
        if (closed == false && i == 0) {
                output.add(a);
        }
        output.add(lerp(a, b, ratio));
        output.add(lerp(b, a, ratio));
        if (closed == false && i == numCorners - 1) {
                output.add(b);
        }
    }
    
    return chaikinSmooth(output, ratio, iterations - 1, closed);
}

Polygon chaikinSmooth(Polygon p, float ratio, int iterations, boolean closed) {
    return new Polygon(chaikinSmooth(p.vertices, ratio, iterations, closed));
}