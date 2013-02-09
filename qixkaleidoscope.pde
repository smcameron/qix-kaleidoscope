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

/* 
 * This implements a simple "Qix monster" - two points moving, with a line
 * drawn between them, trailing lines behind, bouncing off the walls.  No
 * line erasing is done.
 */

int x1,y1,x2, y2;
int vx1, vy1, vx2, vy2;
int xdim, ydim;

void setup()
{
  xdim = 800;
  ydim = 500;
  size(xdim, ydim);
  stroke(255);
  background(0);
  x1 = 0;
  y1 = 0;
  x2 = 10;
  y2 = 11;
  vx1 = 3;
  vy1 = 2;
  vx2 = 2;
  vy2 = 4;
}

int update_vel(int v, int p, int limit)
{
  if (p < 0 || p > limit)
    return -v;
  return v;
}

int update_pos(int p, int v)
{
  return p + v;
}

void draw()
{
   stroke(255);
   line(x1, y1, x2, y2);
   x1 = update_pos(x1, vx1);
   x2 = update_pos(x2, vx2);
   y1 = update_pos(y1, vy1);
   y2 = update_pos(y2, vy2);
   vx1 = update_vel(vx1, x1, xdim);
   vx2 = update_vel(vx2, x2, xdim);
   vy1 = update_vel(vy1, y1, ydim);
   vy2 = update_vel(vy2, y2, ydim);
   
}
