CF::usage = 
  "CF[a,b,...] represents the continued fraction a + 1/(b + 1/(...))";
ToCF[x_Integer] := CF[x];
ToCF[Rational[p_, q_]] := 
  If[q == 0, CF[], Join[CF[Floor[p/q]], ToCF[q/Mod[p, q]]]];
ToCF[17/6]