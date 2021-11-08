RPolygon createRingSector(
    float x,
    float y,
    float radiusBig,
    float radiusSmall,
    float angleStart,
    float angle
) {
    RPoint center = new RPoint(x, y);
    int detail = 20;
    float angleInc = angle / detail;

    RContour outline = new RContour();
    for (int i = 0; i <= detail; i++) {
        RPoint p = new RPoint(x + radiusBig, y);
        p.rotate(angleStart + i * angleInc, center);
        outline.addPoint(p);
    } 

    for (int i = detail; i >= 0; i--) {
        RPoint p = new RPoint(x + radiusSmall, y);
        p.rotate(angleStart + i * angleInc, center);
        outline.addPoint(p);
    }

    RPolygon output = new RPolygon(outline);
    return output;
}