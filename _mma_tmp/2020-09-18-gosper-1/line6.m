Plus[x_CF, y_CF] ^:= BiHomographic[{{0, 1, 1, 0}, {0, 0, 0, 1}}, x, y];
Times[x_CF, y_CF] ^:= 
  BiHomographic[{{1, 0, 0, 0}, {0, 0, 0, 1}}, x, y];

CF /: Times[x_CF, -1] := Homographic[{{-1, 0}, {0, 1}}, x];
CF /: Power[x_CF, -1] := Homographic[{{0, 1}, {1, 0}}, x];