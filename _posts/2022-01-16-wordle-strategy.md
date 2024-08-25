---
layout: post
title: "Optimizing your Wordle Strategy"
tags: mathematica
mma: true
---

[Wordle](https://www.powerlanguage.co.uk/wordle/) seems to have quickly become quite popular. As word games go, it's a good option if you want a quick dose. And as I'm beginning to find, it can be rather addictive.

Every day, the game refreshes with a new five-letter target English word. You then get six tries to guess the word. With each guess, the game tells you if each letter is correct (green), if it appears in the target word but you have it in the wrong place (yellow), or if it does not appear at all in the target word (gray). For instance, here's a possible sequence of guesses for once of the recent target words, `ABBEY`:

```mma-hide
colorMap = <| 1 -> RGBColor[106/255, 170/255, 100/255], 0 -> RGBColor[201/255, 180/255, 80/255], -1 -> RGBColor[134/255, 136/255, 138/255] |>;
tag[word_, target_] := 
  With[{sc = Characters[word], tc = Characters[target]}, 
   With[{neq = Select[Range[5], sc[[#]] != tc[[#]] &]},
    Table[
     Which[sc[[i]] == tc[[i]], 1, 
      MemberQ[tc[[neq]], sc[[i]]] && 
       Length[Position[sc[[neq]][[;; Position[neq, i][[1, 1]]]], 
          sc[[i]]]] <= Length[Position[tc[[neq]], sc[[i]]]], 0, 
      True, -1], {i, 5}]]];
WordlePlot[ss_List, target_] := Column[WordlePlot[#, target] & /@ ss];
WordlePlot[s_String, target_] := 
  With[{sc = Characters[s], tc = Characters[target], colors = colorMap /@ tag[s, target]},
    Row[Table[
      Graphics[{colors[[i]], Rectangle[], White, 
        Text[Style[sc[[i]], FontSize -> 48, 
          FontFamily -> "Clear Sans", Bold, White], {.5, .5}]}], {i, 
       5}]]
   ];
```

```mma
WordlePlot[{"STARE", "CLEAN", "FADED", "ABBEY"}, "ABBEY"]
```

The first guess, `STARE`, has so far been one of my favorites, since right away you learn about five of the most frequently occuring letters. But while we're on the topic, what are the most frequent letters for five letter words? In principle this could be different from the distribution for all English words. Let's see:

```mma
words = ToUpperCase /@ Select[WordList["KnownWords"], 
    StringLength[#] == 5 && AllTrue[Characters[#], x |-> MemberQ[CharacterRange["a", "z"], x]] &];
chardata = Association[Rule @@@ ReverseSortBy[Tally@Flatten@Characters@words, Last]];

BarChart[Labeled[#2, 
    Style[#1, FontSize -> 24, FontFamily -> "Clear Sans"], Before] & @@@
   Reverse@Take[Normal@chardata, 15], BarSpacing -> 0, 
 BarOrigin -> Left, Axes -> False, ImageSize -> 600]
```

So, using `STARE` we do hit the three most common letters (A, E, and R), but S and T are not as prevalent as I thought. Could we use this data to find a better starting word? For starters, we could form a very simple heuristic: for each word, add the frequency counts for each of its distinct letters, and let that be a score. By this metric, here are the top 15 starter words:

```mma
score[word_] := Total[chardata /@ Union[Characters[word]]]
scores = {#, score[#]} & /@ words;

TableForm[
 Style[First[#] <> "    (" <> ToString[Last[#]] <> ")", 
    FontSize -> 24, FontFamily -> "Courier New"] & /@ 
  Take[ReverseSortBy[scores, Last], 15], 
 TableHeadings -> {Style[#, FontSize -> 24, 
      FontFamily -> "Courier New"] & /@ Range[15], {}}]
```

`STARE` is down at #13 (though really #6 if we count groups of anagrams as one). Maybe I'll start using `ORATE`. But of course, this is just a heuristic. Can we do better with the starting word, or more importantly, develop a strategy for choosing a word at any stage of Wordle?

As with any strategy, we have to decide what we're optimizing. We could, for instance, aim to minimize the expected number of guesses it takes to get to the target word. This would involve playing with probabilities and occasionally taking measured risks. For instance, maybe such a strategy would boost the chances of guessing the target word using an impressive three guesses, but at the cost of risking failure even after six guesses in some cases.

I'll take a different approach, that of a conservative player: we simply want to minimize the chance of failure. If we average five or six guesses, so be it, as long as we reliably get the morning rush of discovering the target word. Another way to think of this is playing as if we're confronting an adversary, rather than a random word. Imagine there's a person on the other end of Wordle, watching our strategy, and carefully choosing a target word to foil us. Then risk-taking as described above is certain folly. Instead, we should plan for the worst case scenario.

## Starting Word

First things first, we'll need a way to select only the words that are consistent with the constraints Wordle has given us thus far. When playing the game as a human, it's typical to interpret the colors to build up a list of more abstract constraints: *"okay, so there's at least one B, it can't be in the fourth position, ..."*. But for a computer, it's much easier to just keep track of what colors the game has given us, and restrict the possibilities to words that would give those same colors on all our guesses if they were the target words. For instance, after the first two guesses above, we would have the data
```mma
guessData[guesses_, target_] := AssociationMap[w |-> tag[w, target], guesses];
gd = guessData[{"STARE", "CLEAN"}, "ABBEY"]
```
The function `tag` is defined in the downloaded notebook, and represents a green letter with a 1, a yellow letter with a 0, and a gray letter with a -1. We could then retrieve a list of candidate target words by
```mma
candidates[guessData_, words_] := Select[words, candidate |-> AllTrue[Keys @ guessData, tag[#, candidate] == guessData[#] &]]
candidates[gd, words]
```

Now we can start asking some concrete questions. Any starting word will reduce the pool of candidates for any target word. In some cases we could get lucky and the reduction is dramatic (for instance, if we were to guess the target word right away). But remember, we're imagining that we play against an adversary. This means we should pick a starting word and then put ourselves in the shoes of the adversary, and pick a target word that maximizes the number of remaining candidates. That is, for any given word `start`, the adversary computes:
```mma
maxRemaining[start_, words_] := 
 Last@SortBy[Table[{tup, Length[candidates[<|start -> tup|>, words]]}, {tup, Tuples[{-1, 0, 1}, 5]}], Last]
```
Note we are only maximizing over the possible colors, not the target words themselves, since two target words that give the same colors are equivalent for our purposes. Let's see what we get for the two starting words we were looking at earlier:
```mma
Length[words]
maxRemaining["STARE", words]
maxRemaining["ORATE", words]
```
So indeed, `ORATE` is a better starting word than `STARE`, in terms of the worst-case reduction in the number of candidate words they leave behind. Both of them reduce the pool of words by a factor of at least 10, which is a surprise to me. Also, it may come as a surprise that when the player starts with `ORATE`, it's in the adversary's best interest to pick a target word that contains an A. What happens if the target word doesn't have an A? Then we have
```mma
Length[candidates[<| "ORATE" -> {-1, -1, -1, -1, -1} |>, words]]
```
Ah, so in fact it was a perfect tie!

On this note, it's hard to imagine the adversary could ever benefit by giving us a green letter. Let's just make that assumption, because it speeds up this process considerably:
```mma
maxRemaining[start_, words_] := 
 Last@SortBy[Table[{tup, Length[candidates[<|start -> tup|>, words]]}, {tup, Tuples[{-1, 0}, 5]}], Last]
```
Now we can afford to check several more words. Let's look at the top 30 words we found using our letter-frequency heuristic, and see how they do according to this new metric:
```mma
contestants = First /@ Take[ReverseSortBy[scores, Last], 30];
ranking[cs_, words_] := With[{data = SortBy[
   Table[With[{mr = maxRemaining[w, words]}, {WordlePlot[w, 
       First@candidates[<|w -> mr[[1]]|>, words]], 
      Style[mr[[2]], FontSize -> 36, 
       FontFamily -> "Clear Sans"]}], {w, cs}], Last]},
TableForm[data[[;;5]], TableSpacing -> {5, 10}, 
 TableHeadings -> {(Style["#" <> ToString@#, 24, 
       FontFamily -> "Clear Sans"] & /@ Range[5]), None}]
];

ranking[contestants, words]
```
It seems like `RAISE` is a significant cut above the rest, reducing the worst-case candidate pool by 42 relative to the next-best starting word, `IRATE`. Another trend that jumps out is that it's occasionally beneficial for the adversary to give a yellow A, but otherwise the adversary will choose to make all letters gray. So, to be sure we're not missing any missing any potentially strong starting words, let's sort all of the words in order of how much they reduce the pool when all the letters are gray and then score those:
```mma
nonOverlapping[w1_, w2_] := 
  Length[Intersection[Characters[w1], Characters[w2]]] == 0;
grayScore[w_, words_] := Length[Select[words, nonOverlapping[#, w] &]];
newContestants = SortBy[words, grayScore[#, words] &][[;; 30]];

newContestants[[;;5]]

ranking[newContestants, words]
```
Good, so we haven't missed anything. `ALOES` does well if all the letters are gray, but in that case the adversary can actually do much better by making the A yellow, so it doesn't make our worst-case scenario ranking.

## Game Play

Great, so we have our starting word, `RAISE`. Once we play it, we know we'll be down to no more than 286 candidate words. Where do we go from here?

In principle, we're allowed to choose any of the 4000+ five-letter words as our next guess. In some cases, though, it would be ridiculous to guess a word that's not among the candidate target words. This is definitely true if all the letters from the starting word came up gray: once a letter comes up gray, we know it will come up gray in any other word, so that's a waste of a letter. For green letters, though, the situation is reversed: if we play that same letter in that same position again, we know it will come up green, so why bother, unless only one candidate word remains and we're ready to finish the game?

To avoid these puzzles, let's play Wordle as if we're in "hard mode". This is a setting that requires you to use what you've learned from previous guesses. So, if a letter comes up gray, we can't use it in the next guess; but if a letter comes up green, we must keep that letter in place in all future guesses. It's unclear to me whether this is actually "hard", in the sense that it makes it more difficult to reliably guess the word in six tries, but it does make the search space smaller, so we'll play by this rule.

So, for starters, let's imagine we played `RAISE` -- our best move -- and the adversary makes all the letters gray, her best move. Touch&eacute;, digne adversaire. We should then repeat the same analysis: which of the remaining candidate words minimizes the maximum possible number of words left over after we guess it?

We'll use the same trick as before: sort by the number that would remain if our second guess also comes up all gray, and then check for adjustments if we include yellows.
```mma
raiseWords = candidates[<| "RAISE" -> {-1, -1, -1, -1, -1} |>, words];

raiseContestants = SortBy[raiseWords, grayScore[#, raiseWords] &][[;; 30]];

ranking[raiseContestants, raiseWords]
```
Perhaps shockingly, by playing the ideal word `HOTLY`, we have again reduced the number of possibilities by more than a factor of 10!

Also, it shouldn't be surprising here that the adversary benefits by giving us some yellows. We're assuming that `RAISE` came up all gray, so there must be either an O or a U in the target word, for starters.

Let's play `HOTLY`, and again let the adversary make her best reply, a yellow O and L. Then there are only 15 remaining possibilities, so we might as well just rank them all (with a slight adjustment to the ranking function to now look at adversary words directly rather than color assignments):
```mma
raiseHotlyWords = 
  candidates[<|"HOTLY" -> {-1, 0, -1, 0, -1}|>, raiseWords];

ranking[words_] := With[{data = SortBy[
         Table[
       With[{mr = 
          Last@SortBy[
            Table[{w2, 
              Length[candidates[<|w -> tag[w, w2]|>, words]]}, {w2, 
              words}], Last]}, {WordlePlot[w, 
                mr[[1]]], 
               Style[mr[[2]], FontSize -> 36, 
                 FontFamily -> "Clear Sans"]}], {w, words}], Last]},
   TableForm[data[[;; 4]], TableSpacing -> {5, 10}, 
     TableHeadings -> {(Style["#" <> ToString@#, 24, 
                 FontFamily -> "Clear Sans"] & /@ Range[5]), None}]
   ];

ranking[raiseHotlyWords]
```

Great, so we play `BLOCK`:
```mma
raiseHotlyBlockWords = 
  candidates[<|"BLOCK" -> {1, 1, 1, -1, -1}|>, raiseHotlyWords];
ranking[raiseHotlyBlockWords]
```

Now our best move is to play either `BLOOD` or `BLOND`, and in either case only one word remains, namely `BLOWN`. So in other words, here is the perfect game of Wordle, where the player always minimizes the number of remaining words, and the adversary always maximizes this number:
```mma
WordlePlot[{"RAISE", "HOTLY", "BLOCK", "BLOOD", "BLOWN"}, "BLOWN"]
```
That's five guesses, so we win!

This probably means that Wordle is always solvable in five tries. I say probably because technically, our analysis here wasn't complete. We only allowed the player and adversary to think "one move ahead". Perhaps the adversary could do even a bit better by letting the set of possible words shrink more than it needs to, but in a way that makes it more difficult for the player to shrink it further on the next turn. I somewhat doubt this, but we can't rule out the possibility. However, it seems quite far-fetched for such gamesmanship on the part of the adversary to increase the number of turns all the way to 7. It looks like Wordle is always solvable in six tries, or maybe only five.