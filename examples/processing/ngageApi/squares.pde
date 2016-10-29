/**
 * \file Draw a grid of squares and intersect them with the blobs.
 */
import java.util.Iterator;

class Square
{
	PVector center;
	float w;
	float a;
	float s;
	color c;
	boolean intersected;

	Square(float x, float y, float size)
	{
		center = new PVector(x,y);
		w = size;
		c = color(128 + (x-width/2) * 255.0 / width, 128 + (height/2 - y) * 255.0 / height, 256 - y * 256.0 / height, 150);
		s = 1;
	}

	void draw()
	{
		if (intersected)
		{
			s *= 0.90;
			a += 0.2;
		} else {
			if (s < 1)
				s = (s * 1.01) + 0.01;
			a *= 0.95;
		}

		pushMatrix();
		translate(center.x, center.y);
		rotate(a);
		scale(s);
		fill(c);
		noStroke();
		rect(-w/2, -w/2, w, w);
		//ellipse(0.0,0.0, w, w);
		popMatrix();

		intersected = false;
	}

	void intersect(Blob b)
	{
/*
		float dx = center.x - b.centerPos.x * width;
		float dy = center.y - b.centerPos.y * height;
		float dist = sqrt(dx*dx + dy*dy);

		if (dist < w)
			intersected = true;
*/
		if (b.isInside(new PVector(center.x / width, center.y / height)))
			intersected = true;
	}

	void intersect(PVector p)
	{
		float dx = center.x - p.x;
		float dy = center.y - p.y;
		float dist = sqrt(dx*dx + dy*dy);

		if (dist < w/2)
			intersected = true;
	}
}


class Squares
{
ArrayList<Square> squares = new ArrayList<Square>();

Squares()
{
	float w = width / 48;
	pushStyle();
	strokeWeight(0);

	for(float x = 0 ; x < width; x += w)
	{
		for(float y = 0 ; y < height ; y += w)
		{
			Square s = new Square(x,y,w);
			squares.add(s);
		}
	}

	popStyle();
}

void intersect(Blob b)
{
	for(Square s : squares)
		s.intersect(b);
}

void intersect(PVector p)
{
	for(Square s : squares)
		s.intersect(p);
}

void draw()
{
	for(Square s : squares)
		s.draw();
}

}
