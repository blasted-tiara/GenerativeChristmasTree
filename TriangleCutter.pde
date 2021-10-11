ArrayList<Polygon> cutTriangleSawtooth(Polygon input, int parts) {
    ArrayList<Polygon> output = new ArrayList<Polygon>();
    
    ArrayList<PVector> allPoints = new ArrayList<PVector>();
    int levels = parts / 2;
    float temp = levels + 1.0;

    for (int i = 0; i < levels; i++) {
        ArrayList<PVector> a1 = new ArrayList<PVector>();
        a1.add(lerp(input.get(0), input.get(2), i / temp)); 
        a1.add(lerp(input.get(1), input.get(2), i / temp)); 
        a1.add(lerp(input.get(0), input.get(2), (i + 1.2) / temp)); 

        ArrayList<PVector> a2 = new ArrayList<PVector>();
        a2.add(lerp(input.get(1), input.get(2), i / temp)); 
        a2.add(lerp(input.get(0), input.get(2), (i + 1) / temp)); 
        a2.add(lerp(input.get(1), input.get(2), (i + 1.2) / temp)); 

        output.add(new Polygon(a1));
        output.add(new Polygon(a2));
    }
    
    ArrayList<PVector> last = new ArrayList<PVector>();
    last.add(lerp(input.get(0), input.get(2), levels / temp));
    last.add(lerp(input.get(1), input.get(2), levels / temp));
    last.add(lerp(input.get(0), input.get(2), 1));
    
    output.add(new Polygon(last));
    
    return output;
}