/*
 * Copyright (c) 2013 Stephen M. Cameron
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is furnished to do
 * so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

final int nlines = 3;
int[] x1,y1,x2, y2;
float[] ang;
int vx1, vy1, vx2, vy2;
int xdim, ydim;
int i;
int r, g, b;
color linecolor;
float colorangle;
float angle;
float anglevel;
float maxanglev = 90;

void setup()
{
  i = 0;
  xdim = 800;
  ydim = 800;
  size(xdim + 50, ydim + 50);
  stroke(255);
  background(0);
  
  x1 = new int[nlines];
  y1 = new int[nlines];
  x2 = new int[nlines];
  y2 = new int[nlines];
  ang = new float[nlines];
  
  for (i = 0; i < nlines; i++) {
    x1[i] = 0;
    y1[i] = 0;
    x2[i] = 0;
    y2[i] = 0;
    ang[i] = 0.0;
  }
  i = 0;

  vx1 = 3;
  vy1 = 2;
  vx2 = 2;
  vy2 = 4;
  r = 255;
  g = 255;
  b = 255;
  angle = 0;
  anglevel = 0;//maxanglev;
  
  linecolor = color(r, g, b);
}

void dorotate()
{
  angle = (angle + anglevel);
  if (angle > 360)
     angle -= 360;
  if (angle < 0)
    angle += 360;
    
    if (random(100) < 20) {
        anglevel = anglevel + ((random(100) - 50) / 100.0) * 20 * PI / 180.0;
        if (anglevel < -maxanglev * PI / 180.0)
          anglevel = -maxanglev * PI / 180.0;
        if (anglevel > maxanglev * PI / 180.0)
          anglevel = maxanglev * PI / 180.0;
    }
}
  
int update_color(float phase)
{
  float ca;

  ca = colorangle * PI / 180.0;
  
  return ((int) ((sin(ca + phase) + 1.0) * 255.0)) ;
}


void update_linecolor()
{
  //if (random(100) < 15)
    // colorangle = (colorangle + (int) (random(7) - 3)) % 360;
    
  colorangle += 1.8;
  if (colorangle > 360)
    colorangle -= 360;
  r = update_color(0);
  g = update_color(2.0 * PI / 3.0);
  b = update_color(4.0 * PI / 3.0);
  linecolor = color(r, g, b);
}

int update_vel(int v, int p, int limit)
{
  if (random(1000) < 20) {
    v += (random(5) - 2);
  }
  if (p < 0 || p > limit)
    return -v;
  return v;
}

int update_pos(int p, int v)
{
  return p + v;
}

int reflect(int v, int vlimit)
{
  int c = vlimit / 2;
  if (v > c)
    return c - (v - c);
  return c + (c - v);
}

int reflectx(int x)
{
  return reflect(x, xdim);
}

int reflecty(int y)
{
  return reflect(y, ydim);
}

int xtoy(int x)
{
  return (ydim * x) / xdim;
}

int ytox(int y)
{
  return (xdim * y) / ydim;
}

int xrot(int x, int y, float angle)
{
  int ox = xdim / 2;
  int oy = ydim / 2;
  
  return (int) (cos(angle) * (x - ox) - sin(angle) * (y - oy) + ox);
}

int yrot(int x, int y, float angle)
{
  int ox = xdim / 2;
  int oy = ydim / 2;
  
  return (int) (sin(angle) * (x - ox) + cos(angle) * (y - oy) + oy);
}

void rotline(int x1, int y1, int x2, int y2, float a)
{
  int a1, b1, a2, b2;

  a1 = xrot(x1, y1, a);
  b1 = yrot(x1, y1, a);
  a2 = xrot(x2, y2, a);
  b2 = yrot(x2, y2, a);
  
  line(a1, b1, a2, b2);
}

void myline(int x1, int y1, int x2, int y2, float a)
{
  int a1, b1, a2, b2;
  
  a1 = reflectx(x1);
  a2 = reflectx(x2);
  b1 = reflecty(y1);
  b2 = reflecty(y2);
  
  rotline(x1, y1, x2, y2, a);
  rotline(a1, y1, a2, y2, a);
  rotline(x1, b1, x2, b2, a);
  rotline(a1, b1, a2, b2, a);
  
  rotline(ytox(y1), xtoy(x1), ytox(y2), xtoy(x2), a);
  rotline(ytox(y1), xtoy(a1), ytox(y2), xtoy(a2), a);
  rotline(ytox(b1), xtoy(x1), ytox(b2), xtoy(x2), a);
  rotline(ytox(b1), xtoy(a1), ytox(b2), xtoy(a2), a);
}

void draw()
{
   int n;
   
   n = (i + 1) % nlines;
      
   x1[n] = update_pos(x1[i], vx1);
   x2[n] = update_pos(x2[i], vx2);
   y1[n] = update_pos(y1[i], vy1);
   y2 [n]= update_pos(y2[i], vy2);
   ang[n] = angle * PI / 180.0;
   vx1 = update_vel(vx1, x1[n], xdim);
   vx2 = update_vel(vx2, x2[n], xdim);
   vy1 = update_vel(vy1, y1[n], ydim);
   vy2 = update_vel(vy2, y2[n], ydim);
   update_linecolor();
   stroke(linecolor);
   myline(x1[i], y1[i], x2[i], y2[i], ang[i]);
   n = (n + 1) % nlines;
   stroke(0);
   myline(x1[n], y1[n], x2[n], y2[n], ang[n]);
   i = (i + 1) % nlines;  
   dorotate();
}
