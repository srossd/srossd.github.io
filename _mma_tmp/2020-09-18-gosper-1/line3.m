Homographic[{{a_Integer, b_Integer}, {c_Integer, d_Integer}}, x_CF] :=
   Which[
    Length[x] == 0,(*x is CF[], which we can think of as infinity*)
    ToCF[a/c],
    a == c == 0, (*does not depend on x*)
    ToCF[b/d],
    c != 0 && d != 0 && Floor[a/c] == Floor[b/d], (*we know the integer part*)
    Join[CF[Floor[a/c]], Homographic[{{c, d}, {Mod[a, c], Mod[b, d]}}, x]],
    True, (*rewrite using a term of x*)
    Homographic[{{a First[x] + b, a }, {c First[x] + d, c }}, Rest[x]]
   ];