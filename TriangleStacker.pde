ArrayList<Polygon> stackTriangles(Polygon input, int n, float angle) {
    CrownFactory cf = new CrownFactory();

    checkIfTriangle(input);
    ArrayList<Polygon> output = new ArrayList<Polygon>();

    PVector p0 = input.get(0);
    PVector p1 = input.get(1);

    float h = PVector.dot(PVector.sub(p1, p0).rotate(-HALF_PI).normalize(), PVector.sub(input.get(2), p0));

    PVector v1 = PVector.sub(p1, p0).rotate(-angle).setMag(h / (n * sin(angle)));
    PVector t = PVector.sub(input.get(2), input.get(0)).sub(v1).div(n);
    PVector t_opposite = new PVector(-t.x, t.y);

    for (int i = 0; i < n; i++) {
        output.add(cf.createTriangle(p0, p1, angle));
        p0.add(t);
        p1.add(t_opposite);
    }
    
    return output;
}