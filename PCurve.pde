class PCurve {
    ArrayList<PVector> points;
    float[] lut;

    public PCurve(ArrayList<PVector> points) {
        this.points = points;
        initLut(points);
    }

    private void initLut(ArrayList<PVector> input) {
        if(input == null || input.size() < 2) {
            lut = null;
        } else {
            lut = new float[input.size()];
            lut[0] = 0;
            for (int i = 1; i < input.size(); i++) {
                lut[i] = lut[i - 1] + input.get(i - 1).dist(input.get(i));
            }
        }
    }

    public PVector clerp(float ratio) {
        if (lut != null) {
            if (ratio <= 0) {
                return points.get(0).copy();
            }
            else if (ratio >= 1) {
                return points.get(points.size() - 1).copy();
            }
            else {
                float d = ratio * lut[lut.length - 1];
                int idx = 0;
                while(d > lut[idx]) {
                    idx++;
                }
                float interPt = (d - lut[idx - 1]) / (lut[idx] - lut[idx - 1]);
                return lerp(points.get(idx - 1), points.get(idx), interPt);
            }
        } else {
            return null;
        }
    }

    public ArrayList<PVector> cutEqualParts(int n) {
        ArrayList<PVector> output = new ArrayList<PVector>();
        if (n > 0) {
            for (int i = 0; i <= n; i++) {
                output.add(clerp(i / (float) n));
            }
            return output;
        } else {
            return output;
        }
    }

    public ArrayList<PVector> cutEqualParts(float dist) {
        int n = floor(lut[lut.length - 1] / dist);
        return cutEqualParts(n);
    }
}
