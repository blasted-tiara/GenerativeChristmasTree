void checkIfRectangle(Polygon p) {
    if (p.getVertices().size() != 4) {
        throw new IllegalArgumentException("Input has to be rectangle.");
    }
}

ArrayList<Polygon> cutRectangle(Polygon input, int parts) {
    checkIfRectangle(input);
    ArrayList<Polygon> output = new ArrayList<Polygon>();

    for (int i = 0; i < parts; i++) {
        ArrayList<PVector> pts = new ArrayList<PVector>();

        pts.add(lerp(input.get(0), input.get(1), ((float) i) / parts));
        pts.add(lerp(input.get(0), input.get(1), ((float) i + 1.2) / parts));
        pts.add(lerp(input.get(3), input.get(2), ((float) i + 1.2) / parts));
        pts.add(lerp(input.get(3), input.get(2), ((float) i) / parts));

        output.add(new Polygon(pts));
    }

    return output;
}