Simplify[CF[a___, b__, {b__}]] ^:= CF[a, {b}];
Simplify[CF[a___, {b__, b__}]] ^:= CF[a, {b}];
4 phi // Simplify