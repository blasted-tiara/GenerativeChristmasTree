class PLine {
    PVector startPoint;
    PVector endPoint;
    
    PLine(PVector startPoint, PVector endPoint) {
        this.startPoint = startPoint;
        this.endPoint = endPoint;
    }
    
    PLine(PVector startPoint, float angle, float length) {
        this.startPoint = startPoint;
        endPoint = PVector.add(startPoint, (new PVector(length, 0)).rotate(angle));
    }
   
   PVector getIntersection(PLine l) {
        float x1 = l.startPoint.x;
        float y1 = l.startPoint.y;
        float x2 = l.endPoint.x;
        float y2 = l.endPoint.y;
        float x3 = this.startPoint.x;
        float y3 = this.startPoint.y;
        float x4 = this.endPoint.x;
        float y4 = this.endPoint.y;

        float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
        float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));

        if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
            float intersectionX = x1 + (uA * (x2-x1));
            float intersectionY = y1 + (uA * (y2-y1));
            return new PVector(intersectionX, intersectionY);
        } else {
            return null;
        }
   }
}