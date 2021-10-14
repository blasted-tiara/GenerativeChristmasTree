void checkIfTriangle(Polygon p) {
    if (p.getVertices().size() != 3) {
        throw new IllegalArgumentException("Input has to be triangle");
    }
}
