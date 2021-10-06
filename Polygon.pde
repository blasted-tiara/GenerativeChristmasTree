/**
 * Polygon class
 */

class Polygon {
   ArrayList<PVector> vertices; 
   
   ArrayList<PVector> getVertices() {
       return this.vertices;
   }
   
   void setVertices(ArrayList<PVector> vertices) {
       this.vertices = vertices;
   }
   
   Polygon() {
       this.vertices = new ArrayList<PVector>();
   }
   
   Polygon(ArrayList<PVector> vertices) {
       this.vertices = vertices;
   }
   
   /**
    * Returns number of vertices in the polygon.
    *
    * @return number of vertices
    */
   int size() {
       return this.vertices.size();
   }
   
   /**
    * Returns i-th vertex of the polygon.
    *
    * @return i-th vertex
    */
   PVector get(int i) {
       return this.vertices.get(i);
   }
   
   /**
    * Draws polygon.
    */
   void draw() {
       beginShape();
       for (PVector v: this.vertices) {
           vertex(v.x, v.y);
        }
        endShape();
   }
   
   /**
    * Draws polygon with given color and alpha.
    * 
    * @param c      polygon color
    * @param alpha  polygon alpha
    */
   void draw(color c, float alpha) {
       fill(c, alpha);
       this.draw();
   }
}
