ArrayList<Polygon> cutTriangleSerrated(Polygon input, int parts) {
    if (input.getVertices().size() != 3) {
        throw new IllegalArgumentException("Input has to be triangle");
    }

    ArrayList<Polygon> output = new ArrayList<Polygon>();

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

ArrayList<Polygon> cutTriangleZigZag(Polygon input, int parts) {
    if (input.getVertices().size() != 3) {
        throw new IllegalArgumentException("Input has to be triangle");
    }
    ArrayList<Polygon> output = new ArrayList<Polygon>();
    
    ArrayList<PVector> first = new ArrayList<PVector>();
    first.add(new PVector(input.get(0).x, input.get(0).y));
    first.add(new PVector(input.get(1).x, input.get(1).y));
    first.add(lerp(input.get(0), input.get(2), 1.2 / (float) parts));
    output.add(new Polygon(first));
    
    for (int i = 0; i < parts - 2; i++) {
        ArrayList<PVector> t = new ArrayList<PVector>();
        
        t.add(lerp(input.get((i + 1) % 2), input.get(2), i / (float) parts));
        t.add(lerp(input.get((i) % 2), input.get(2), (i + 1) / (float) parts));
        t.add(lerp(input.get((i + 1) % 2), input.get(2), (i + 2.3) / (float) parts));
        
        output.add(new Polygon(t));
    }
    
    // make the last point be the upper point of the input triangle
    output.get(output.size() - 1).getVertices().set(2, new PVector(input.get(2).x, input.get(2).y));

    return output;
}

ArrayList<Polygon> cutTriangleParallel(Polygon input, int parts) {
    if (input.getVertices().size() != 3) {
        throw new IllegalArgumentException("Input has to be triangle");
    }
    ArrayList<Polygon> output = new ArrayList<Polygon>();
    
    for (int i = 0; i < parts - 1; i++) {
        ArrayList<PVector> p = new ArrayList<PVector>();
        
        p.add(lerp(input.get(0), input.get(2), i / (float) parts));
        p.add(lerp(input.get(1), input.get(2), i / (float) parts));
        p.add(lerp(input.get(1), input.get(2), (i + 1.2) / (float) parts));
        p.add(lerp(input.get(0), input.get(2), (i + 1.2) / (float) parts));

        output.add(new Polygon(p));
    }
    
    ArrayList<PVector> last = new ArrayList<PVector>();
    last.add(lerp(input.get(0), input.get(2), (parts - 1.0) / parts));
    last.add(lerp(input.get(1), input.get(2), (parts - 1.0) / parts));
    last.add(lerp(input.get(1), input.get(2), 1.0));
    output.add(new Polygon(last));

    return output;
}

ArrayList<Polygon> cutTriangleRadial(Polygon input, int parts) {
    if (input.getVertices().size() != 3) {
        throw new IllegalArgumentException("Input has to be triangle");
    }
    ArrayList<Polygon> output = new ArrayList<Polygon>();
    
    for (int i = 0; i < parts; i++) {
        ArrayList<PVector> p = new ArrayList<PVector>();
        
        p.add(lerp(input.get(0), input.get(1), i / (float) parts));
        if (i == parts - 1) {
            p.add(lerp(input.get(0), input.get(1), 1.0));
        } else {
            p.add(lerp(input.get(0), input.get(1), (i + 1.2) / (float) parts));
        }
        p.add(new PVector(input.get(2).x, input.get(2).y));
        
        output.add(new Polygon(p));
    }

    return output;
}