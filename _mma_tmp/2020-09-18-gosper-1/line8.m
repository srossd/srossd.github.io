CF /: Plus[x_CF, y_Integer] := Homographic[{{1, y}, {0, 1}}, x];
CF /: Times[x_CF, y_Integer] := Homographic[{{y, 0}, {0, 1}}, x];

CF /: Plus[x_CF, Rational[p_, q_]] := Homographic[{{q, p}, {0, q}}, x];
CF /: Times[x_CF, Rational[p_, q_]] := Homographic[{{p, 0}, {0, q}}, x];