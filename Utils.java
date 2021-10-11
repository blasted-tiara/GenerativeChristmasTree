import java.util.ArrayList;
import java.util.List;
import java.util.Collections;
import java.lang.Math;

/**
 * Class that contains utility functions.
 */
public class Utils {
    /**
     * Randomly removes n points from a generic input array.
     * 
     * @param <T>   type of array elements
     * @param input input array
     * @param n     number of points to remove
     * @return      array with n points randomly removed
     */
    public static <T> ArrayList<T> stochasticDownsample(ArrayList<T> input, int n) {
        ArrayList<T> output = new ArrayList<T>();
        List<Integer> numArray = new ArrayList<Integer>();
        for (int i = 0; i < input.size(); i++) {
            numArray.add(i);
        }
        Collections.shuffle(numArray);
        numArray = numArray.subList(0, n);
        for (int i = 0; i < input.size(); i++) {
            if (!numArray.contains(i)) {
                output.add(input.get(i));
            }
        }
        return output;
    }
    
    /**
     * Symmetrically remove n elements from an array with generic elements.
     * If n is an even number, removes n/2 elements from the beginning of the array
     * and n/2 elements from the end.
     * If n is an odd number, removes (n + 1) / 2 elements from the beginning and
     * (n - 1) / 2 elements from the end of the array.
     * 
     * @param <T>   type of array elements
     * @param input input array
     * @param n     number of points to remove
     * @return      array with n points symmetrically removed
     */
    public static <T> ArrayList<T> symmetricTrimDownsample(ArrayList<T> input, int n) {
        int leftIdx = n / 2 + n % 2 - 1;
        int rightIdx = input.size() - n / 2 - 1;
        
        return new ArrayList<T>(input.subList(leftIdx, rightIdx));
    }
    
    public static double getNormalProbability(double x) {
        return Math.exp(- Math.pow(x, 2) / 2) / Math.sqrt(2 * Math.PI);
    }
    
    public static double getAreaUnderNormalCurve(double x1, double x2) {
        double area = 0;
        final int rectangles = 100000;
        final double width = (x2 - x1) / rectangles;
        for (int i = 0; i < rectangles; i++) {
            area += width * getNormalProbability(x1 + i * width); 
        }
        return area;
    }
}
