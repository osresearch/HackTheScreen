/** //<>//
 Simple Example for talking to Ngage API for Blob & Face tracking
 It connects via OSC to the server, which then sends a osc data stream
 to the client (this). 
 */

Ngage mApi;
Swarm swarm;
Squares squares;

void setup() {
  //size(1280, 640); //size of the screen
  fullScreen(2);
  frameRate(30);
  mApi = new Ngage();
  swarm = new Swarm();
  squares = new Squares();
}

void draw() {
  background(0);
  squares.draw();

  squares.intersect(new PVector(mouseX, mouseY));

  // Let's loop through all available blobs
  for (int i = 0; i < mApi.blobs.size(); i++) {
    Blob b = mApi.blobs.get(i);
    if (!b.isAlive())
	continue;

    drawBlob(b);
    squares.intersect(b);
    //swarm.wasp_move(new PVector(b.centerPos.x * 1280, b.centerPos.y * 640));
  }

  // now loop through all of the swarm bees
  for(Particle b : swarm.bees)
  {
    squares.intersect(b.p);
  }
  
  //Also check for available faces
  for (int i = 0; i < mApi.faces.size(); i++){
   Face f = mApi.faces.get(i);
   drawFace(f);
  }

  swarm.draw();
}

void drawFace(Face f) {
  noFill();
  stroke(255, 100);
  rect(f.boundingBox.x*width, f.boundingBox.y*height, f.boundingBox.width*width, f.boundingBox.height*height);    

  // draw circle based on Blob's centroid (also from 0-1)
  fill(255, 255, 255);
  ellipse(f.centerPos.x*width, f.centerPos.y*height, 10, 10);
  fill(255);
}

void drawBlob(Blob b) {
  // draw rect based on Blob's detected size
  // dimensions from NgageAPI are 0-1, so we multiply by window width and height
  noFill();
  stroke(255, 30);
  rect(b.boundingBox.x*width, b.boundingBox.y*height, b.boundingBox.width*width, b.boundingBox.height*height);    

  // draw circle based on Blob's centroid (also from 0-1)
  fill(255, 255, 255);
  ellipse(b.centerPos.x*width, b.centerPos.y*height, 10, 10);

  // draw contours
  noFill();
  stroke(255, 100);
  beginShape();
  for (int j = 0; j< b.contours.size(); j++) {
    PVector pt = (PVector) b.contours.get(j);
    if (pt != null)
      vertex(pt.x*width, pt.y*height);
  }
  endShape();

  // text shows more info available
  text("id: "+b.id, b.boundingBox.x*width, (b.boundingBox.y*height + b.boundingBox.height*height) + 2);

  fill(255);
}
