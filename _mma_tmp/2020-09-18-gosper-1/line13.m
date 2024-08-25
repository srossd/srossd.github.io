ClearAll[Homographic];
Homographic[{{a_Integer, b_Integer}, {c_Integer, d_Integer}}, x_CF] :=
   Homographic[{{a, b}, {c, d}}, x, <||>];
Homographic[{{a_Integer, b_Integer}, {c_Integer, d_Integer}}, x_CF, 
   cache_] := Which[
   KeyExistsQ[cache, {{a, b}, {c, d}, x}],
   CF[cache[{{a, b}, {c, d}, x}]],
   Length[x] == 0,
   ToCF[a/c],
   a == 0 && c == 0,
   ToCF[b/d],
   c != 0 && d != 0 && Floor[a/c] == Floor[b/d],
   Join[CF[Floor[a/c]], 
    Homographic[{{c, d}, {Mod[a, c], Mod[b, d]}}, x, 
     Append[ Join[#, {Floor[a/c]}] & /@ 
       cache, {{a, b}, {c, d}, x} -> {Floor[a/c]}]]],
   True,
   Homographic[{{a First[x] + b, a }, {c First[x] + d, c}}, Rest[x], 
    cache]
   ];