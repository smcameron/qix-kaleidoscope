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
int vx1, vy1, vx2, vy2;
int xdim, ydim;
int i;
int r, g, b;
color linecolor;
int colorangle;

void setup()
{
  i = 0;
  xdim = 1000;
  ydim = 700;
  size(xdim, ydim);
  stroke(255);
  background(0);
  
  x1 = new int[nlines];
  y1 = new int[nlines];
  x2 = new int[nlines];
  y2 = new int[nlines];
  
  for (i = 0; i < nlines; i++) {
    x1[i] = 0;
    y1[i] = 0;
    x2[i] = 0;
    y2[i] = 0;
  }
  i = 0;

  vx1 = 3;
  vy1 = 2;
  vx2 = 2;
  vy2 = 4;
  r = 255;
  g = 255;
  b = 255;
  
  linecolor = color(r, g, b);
}

int update_color(float phase)
{
  float ca;

  ca = colorangle * PI / 180.0;
  
  return ((int) (256 * sin(ca + phase))) % 256;
}

void update_linecolor()
{
  if (random(100) < 15)
     colorangle = (colorangle + (int) (random(7) - 3)) % 360;
    
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

void myline(int x1, int y1, int x2, int y2)
{
  int a1, b1, a2, b2;
  
  a1 = reflectx(x1);
  a2 = reflectx(x2);
  b1 = reflecty(y1);
  b2 = reflecty(y2);
  
  line(x1, y1, x2, y2);
  line(a1, y1, a2, y2);
  line(x1, b1, x2, b2);
  line(a1, b1, a2, b2);
}

void draw()
{
   int n;
   
   n = (i + 1) % nlines;
      
   x1[n] = update_pos(x1[i], vx1);
   x2[n] = update_pos(x2[i], vx2);
   y1[n] = update_pos(y1[i], vy1);
   y2 [n]= update_pos(y2[i], vy2);
   vx1 = update_vel(vx1, x1[n], xdim);
   vx2 = update_vel(vx2, x2[n], xdim);
   vy1 = update_vel(vy1, y1[n], ydim);
   vy2 = update_vel(vy2, y2[n], ydim);
   update_linecolor();
   stroke(linecolor);
   myline(x1[i], y1[i], x2[i], y2[i]);
   n = (n + 1) % nlines;
   stroke(0);
   myline(x1[n], y1[n], x2[n], y2[n]);
   i = (i + 1) % nlines;  
}
