int MAX_VERTICES = 100000;

/*
 * Class that contains methods for polygon transformations.
 * Currently all polygons are distorted in such way that
 * a new point is added in the middle of every polygon side,
 * and then the points (all or just some of them) are moved
 * around by adding a gaussian random number with given variance
 * to their x and y coordinates.
 *
 * Distort methods differ in the prefered way of moving these
 * points. Some methods don't have a prefered direction,
 * others prefer to move towards a point, in the direction
 * of a vector, around some axis etc.
 *
 * The amount of preference is determined by 2 fields: distance
 * coefficient and relative-mode.
 * If relative-mode is on, then the amount of preference depends
 * on the position of a point relative to some other vector/point.
 * Otherwise, all points are moved by the same absolute amount.
 * Absolute/relative amounts of displacement are determined by
 * the distance coefficient.
 * 
 * If the field odd == true, it means that the points from the
 * original polygon are fixed, and the only points that move
 * are the ones newly inserted into the polygon.
 * This mode can add nice textures to lines.
 *
 * Design decision: Since the rendering of polygons occurs only
 * after all polygons are pushed on stack, all methods in this
 * class return a list of completely new points, ie. points
 * from the input polygon aren't reused, even if the points with
 * same coordinates occur in the output polygon.
 */
 
class PolygonTransformer {
    // FIXME: The operation of adding points to a polygon should be separated
    // from the distortion operations.

    /**
     * This type of distort moves points in random directions,
     * without any preference for one direction over another.
     *
     * @param p         input polygon
     * @param variance  gaussian distribution variance
     * @odd             odd-mode flag, see class description
     * @return          distorted polygon
     */    
    Polygon uniformDistort(Polygon p, float variance, boolean odd) {
        ArrayList<PVector> output = new ArrayList<PVector>();
        PVector temp;
        for (int i = 0; i < p.size(); ++i) {
            temp = new PVector(p.get(i).x, p.get(i).y);
            output.add(odd ? temp : disturbPoint(temp, variance));

            temp = getMidpoint(p.get(i), p.get((i + 1) % p.size()));
            temp = disturbPoint(temp, variance);
            output.add(temp);
        }
        return new Polygon(output);
    }

    /**
     * This type of distort moves points in random directions,
     * but the prefered direction of displacement is towards the
     * bias point. 
     *
     * @param p         input polygon
     * @param variance  gaussian distribution variance
     * @param bias      bias point
     * @param distCoeff amount of preference towards the bias point
     * @relative        relative-mode flag, see class description
     * @odd             odd-mode flag, see class description
     * @return          distorted polygon
     */    
    Polygon pointBiasedDistort(
                Polygon p,
                float variance,
                PVector bias,
                float distCoeff,
                boolean relative,
                boolean odd
    ) {
        ArrayList<PVector> output = new ArrayList<PVector>();
        PVector temp;
        for (int i = 0; i < p.size(); ++i) {
            temp = new PVector(p.get(i).x, p.get(i).y);
            output.add(odd ? temp : disturbPoint(temp, variance));

            temp = getMidpoint(p.get(i), p.get((i + 1) % p.size()));
            if (relative) {
                temp.add(PVector.sub(bias, temp).mult(distCoeff));
            } else {
                temp.add(PVector.sub(bias, temp).setMag(distCoeff));
            }
            temp = disturbPoint(temp, variance);
            output.add(temp);
        }
        return new Polygon(output);
    }

    /**
     * This type of distort moves points in random directions,
     * but the prefered direction of displacement is in the
     * direction of the bias vector.
     *
     * @param p         input polygon
     * @param variance  gaussian distribution variance
     * @param direction direction in which the points are to be biased
     * @param distCoeff amount of preference along the bias vector
     * @relative        relative-mode flag, see class description
     * @odd             odd-mode flag, see class description
     * @return          distorted polygon
     */    
    Polygon vectorBiasedDistort(
                Polygon p,
                float variance,
                PVector direction,
                float distCoeff,
                boolean relative,
                boolean odd
    ) {
        ArrayList<PVector> output = new ArrayList<PVector>();
        PVector temp;
        for (int i = 0; i < p.size(); ++i) {
            temp = new PVector(p.get(i).x, p.get(i).y);
            output.add(odd ? temp : disturbPoint(temp, variance));

            temp = getMidpoint(p.get(i), p.get((i + 1) % p.size()));
            if (relative) {
                temp.add(direction.mult(distCoeff));
            } else {
                temp.add(direction.setMag(distCoeff));
            }
            temp = disturbPoint(temp, variance);
            output.add(temp);
        }
        return new Polygon(output);
    }

    /**
     * This type of distort moves points in random directions,
     * but the prefered direction of displacement is rotation 
     * around the bias point.
     *
     * @param p         input polygon
     * @param variance  gaussian distribution variance
     * @param center    center of rotation
     * @param biasCoeff amount of preference along the bias vector
     * @relative        relative-mode flag, see class description
     * @odd             odd-mode flag, see class description
     * @return          distorted polygon
     */
    Polygon rotationalDistort(
            Polygon p,
            float variance,
            PVector center,
            float intensity,
            boolean relative,
            boolean odd
    ) {
        ArrayList<PVector> output = new ArrayList<PVector>();
        PVector temp;
        for (int i = 0; i < p.size(); ++i) {
            temp = new PVector(p.get(i).x, p.get(i).y);
            output.add(odd ? temp : disturbPoint(temp, variance));

            temp = getMidpoint(p.get(i), p.get((i + 1) % p.size()));
            temp = rotatePoint(temp, center, intensity, relative);
            temp = disturbPoint(temp, variance);
            output.add(temp);
        }
        return new Polygon(output);
    }
}
    
/**
 * Returns point that represents input point rotated around the center point.
 *
 * @param point     point to be rotated
 * @param center    center of rotation
 * @param intensity amount of displacement
 * @relative        relative-mode flag, see class description
 * @return          rotated point
 */
PVector rotatePoint(PVector point, PVector center, float intensity, boolean relative) {
    if (relative) {
        return PVector.add(point, PVector.sub(point, center).rotate(HALF_PI).mult(intensity));
    } else {
        return PVector.add(point, PVector.sub(point, center).rotate(HALF_PI).setMag(intensity));
    }
}

/**
 * Returns point that is in the middle of the line connecting the two input points.
 *
 * @param start start position
 * @param end   end position
 * @return      middle point
 */
PVector getMidpoint(PVector start, PVector end) {
    PVector temp = PVector.sub(end, start).mult(0.5);
    return PVector.add(start, temp);
}

/**
* Returns a point that is at a random place somewhere in the neighborhood
* of the input point.
*
* @param point      input point
* @param variance   gaussian distribution variance
* @return           point with changed position
*/
PVector disturbPoint(PVector point, float variance) {
    return new PVector(point.x + randomGaussian() * variance, point.y + randomGaussian() * variance);
}


/**
 * Enum that contains various ways of distorting a polygon.
 */
enum DistortType {
    UNIFORM,
    POINT_BIASED,
    VECTOR_BIASED,
    ROTATIONAL
}
