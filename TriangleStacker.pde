class TriangleStacker {
    ArrayList<Polygon> stackTriangles(Polygon input, int n, float angle) {
        // A whole sort of linear algebra mish mash that calculates a shrink coefficient of the
        // base of the triangles, creates them as polygons and returns them in a neat array.
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
    
    ArrayList<Polygon> stackTriangles(Polygon input, float coreThickness, float startAngle, float angleIncrement) {
        CrownFactory cf = new CrownFactory();

        checkIfTriangle(input);
        ArrayList<Polygon> output = new ArrayList<Polygon>();

        PVector p0 = input.get(0);
        PVector p1 = input.get(1);
        PVector p2 = input.get(2);
        PLine outerLineL = new PLine(p2, p0);
        PLine innerLineL = new PLine(p2, lerp(p0, p1, coreThickness));
        PLine outerLineR = new PLine(p2, p1);
        PLine innerLineR = new PLine(p2, lerp(p1, p0, coreThickness));

        float angle = startAngle;

        for (int i = 0; true; i++) {
            output.add(cf.createTriangle(p0, p1, angle + i * angleIncrement));

            try {
                PLine l1 = new PLine(p0, -(angle + i * angleIncrement), 1000000);
                PVector intersection = l1.getIntersection(innerLineL);
                PLine l2 = new PLine(intersection, PI, 1000000);
                p0 = l2.getIntersection(outerLineL);

                l1 = new PLine(p1, (angle + i * angleIncrement) - PI, 1000000);
                intersection = l1.getIntersection(innerLineR);
                l2 = new PLine(intersection, 0, 1000000);
                p1 = l2.getIntersection(outerLineR);
            } catch (NullPointerException e) {
                break;
            }
        }
        
        return output;
    }
}