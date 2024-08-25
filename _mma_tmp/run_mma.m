NotebookPauseForEvaluation[nb_] := Module[{},
While[NotebookEvaluatingQ[nb],Pause[.25]]];

NotebookEvaluatingQ[nb_]:=Module[{},
SelectionMove[nb,All,Notebook];
Or@@Map["Evaluating"/.#&,Developer`CellInformation[nb]]
];

Run["echo lock > C:/users/rossd/Documents/mma.lock"];

Needs["JLink`"];

$FrontEndLaunchCommand = FileNameJoin[{$InstallationDirectory,"/mnt/c/Program\ Files/Wolfram\ Research/Mathematica/14.0/Mathematica.exe"}];

WriteString[File["_mma_tmp/params.m"], "n = 16; jobname = \"2020-09-18-gosper-1\"; wdir = \"C:/users/rossd/Documents\";"];

UseFrontEnd[
nb = NotebookOpen["Z:/Debian/home/srossd/srossd/personal2/assets/mma/rasterizer.nb"];
FrontEndTokenExecute[nb, "EvaluateNotebook"];
NotebookPauseForEvaluation[nb];
];

Run["del "<>StringReplace["C:/users/rossd/Documents/mma.lock", "/" -> "\\"]];
Run["rm C:/users/rossd/Documents/mma.lock"];
Quit[];
