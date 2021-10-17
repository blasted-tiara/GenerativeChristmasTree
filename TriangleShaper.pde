class TriangleShaper {
    public ArrayList<Polygon> reshape(ArrayList<Polygon> shapeStack, String shapeType) {
        if (shapeType.equals("TRIANGLE")) {
            return shapeStack;
        } else {
            ArrayList<Polygon> output = new ArrayList<Polygon>();
            for (Polygon p: shapeStack) {
                checkIfTriangle(p);
                output.add(reshape(p, shapeType));
            }
            return output;
        } 
    }
    
    private Polygon reshape(Polygon shape, String shapeType) {
        if (shapeType.equals("THIN_DROP")) {
            return thinDropReshape(shape);
        } else if (shapeType.equals("THICK_DROP")) {
            return thickDropReshape(shape);
        } else if (shapeType.equals("UP_ARROW")) {
            return upArrowReshape(shape);
        } else if (shapeType.equals("JAGGED_TRIANGLE")) {
            return jaggedTriangleReshape(shape);
        } else if (shapeType.equals("UMBRELLA")) {
            return umbrellaReshape(shape);
        } else {
            throw new IllegalStateException("Crown base shape not recognized");
        }
    }
    
    private Polygon thinDropReshape(Polygon shape) {
        ArrayList<PVector> input = shape.getVertices();
        ArrayList<PVector> modifiedShape = new ArrayList<PVector>();
        ArrayList<PVector> output = new ArrayList<PVector>();
        
        float w = input.get(1).x - input.get(0).x;
        float coeff = 0.1;

        modifiedShape.add(input.get(0));
        modifiedShape.add(input.get(1));
        PVector ctrlP1 = lerp(input.get(1), input.get(2), 0.7);
        ctrlP1.x -= w * coeff;
        modifiedShape.add(ctrlP1);
        modifiedShape.add(input.get(2));
        modifiedShape.add(input.get(2));
        PVector ctrlP2 = lerp(input.get(2), input.get(0), 0.3);
        ctrlP2.x += w * coeff;
        modifiedShape.add(ctrlP2);

        output = chaikinSmooth(modifiedShape, 0.3, 4, true);

        return new Polygon(output);
    }

    private Polygon thickDropReshape(Polygon shape) {
        ArrayList<PVector> input = shape.getVertices();
        ArrayList<PVector> modifiedShape = new ArrayList<PVector>();
        ArrayList<PVector> output = new ArrayList<PVector>();
        
        float w = input.get(1).x - input.get(0).x;
        float coeff = 0.2;

        modifiedShape.add(input.get(0));
        modifiedShape.add(input.get(1));
        PVector ctrlP1 = lerp(input.get(2), input.get(1), 0.6);
        ctrlP1.x += w * coeff;
        modifiedShape.add(ctrlP1);
        modifiedShape.add(input.get(2));
        modifiedShape.add(input.get(2));
        PVector ctrlP2 = lerp(input.get(2), input.get(0), 0.6);
        ctrlP2.x -= w * coeff;
        modifiedShape.add(ctrlP2);

        output = chaikinSmooth(modifiedShape, 0.3, 4, true);

        return new Polygon(output);
    }
    
    private Polygon upArrowReshape(Polygon shape) {
        ArrayList<PVector> input = shape.getVertices();
        ArrayList<PVector> output = new ArrayList<PVector>();
        
        float h = input.get(0).y - input.get(2).y;
        float coeff = 0.1;

        output.add(input.get(0));
        PVector p3 = lerp(input.get(0), input.get(1), 0.5);
        p3.y -= h * coeff;
        output.add(p3);
        output.add(input.get(1));
        output.add(input.get(2));

        return new Polygon(output);
    }

    private Polygon jaggedTriangleReshape(Polygon shape) {
        ArrayList<PVector> input = shape.getVertices();
        ArrayList<PVector> output = new ArrayList<PVector>();
        
        float h = input.get(0).y - input.get(2).y;
        float coeff = 0.07;
        int n = 9;

        output.add(input.get(0));
        for (int i = 0; i < n; i++) {
            PVector p = lerp(input.get(0), input.get(1), (i +1.0) / (n + 1.0));
            if (i % 2 == 0) {
                p.y -= h * coeff;
            }
            output.add(p);
        }
        output.add(input.get(1));
        output.add(input.get(2));

        return new Polygon(output);
    }
    
    private Polygon umbrellaReshape(Polygon shape) {
        ArrayList<PVector> input = shape.getVertices();
        ArrayList<PVector> modifiedShape = new ArrayList<PVector>();
        ArrayList<PVector> output = new ArrayList<PVector>();
        
        float w = input.get(1).x - input.get(0).x;
        float coeff = 0.15;

        modifiedShape.add(input.get(0));
        modifiedShape.add(input.get(0));
        modifiedShape.add(input.get(1));
        modifiedShape.add(input.get(1));
        modifiedShape.add(new PVector(input.get(2).x + w * coeff, input.get(2).y));
        modifiedShape.add(new PVector(input.get(2).x - w * coeff, input.get(2).y));

        output = chaikinSmooth(modifiedShape, 0.25, 5, true);

        return new Polygon(output);
    }
}