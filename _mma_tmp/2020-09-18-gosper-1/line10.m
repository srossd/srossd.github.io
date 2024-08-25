Normal[CF[a_, b__]] ^:= a + 1/Normal[CF[b]];
Normal[CF[a_]] ^:= a;