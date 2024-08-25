BiHomographic[{{a_Integer, b_Integer, c_Integer, 
     d_Integer}, {e_Integer, f_Integer, g_Integer, h_Integer}}, x_CF, 
   y_CF] :=
  Which[
   Length[x] == 0,(*x is infinity*)
   Homographic[{{a,b},{e,f}},y],
   Length[y] == 0,(*y is infinity*)
   Homographic[{{a,c},{e,g}},x],
   a == b == e == d == 0,(*does not depend on x*)
   Homographic[{{c, d}, {g, h}}, y],
   a == c == e == f == 0,(*does not depend on y*)
   Homographic[{{b, d}, {f, h}}, x],
   e != 0 && f != 0 && g != 0 && h != 0 && 
    Floor[a/e] == Floor[b/f] == Floor[c/g] == 
     Floor[d/h],(*we know the integer part*)
   Join[CF[Floor[a/e]], 
    BiHomographic[{{e, f, g, h}, Mod[{a, b, c, d}, {e, f, g, h}]}, x, 
     y]],
   f g h == 0 || Abs[b/f - d/h] > Abs[c/g - d/h],(*expand x*)
   BiHomographic[{{a First[x] + c, b First[x] + d, a, 
      b }, {e First[x] + g, f First[x] + h, e, f}}, Rest[x], y],
   True,(*expand y*)
   BiHomographic[{{a First[y] + b, a, c First[y] + d, 
      c }, {e First[y] + f, e, g First[y] + h, g}}, x, Rest[y]]
  ];