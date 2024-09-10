Unit PlogTree;

Interface

Uses Crt,Dos,PlogGlbs;


   Procedure UnloadIndex1;
   Procedure UnloadIndex2;
   Procedure UnloadIndex3;

   Procedure LoadTreeB   (Var RootB : PointerB);
   Procedure SearchTreeB (Var RootB : PointerB);
   Procedure SearchAntB  (Var RootB : PointerB);
   Procedure SearchPosB  (Var RootB : PointerB);
   Procedure LoadTree0   (Var Root0 : Pointer0);
   Procedure SearchTree0 (Var Root0 : Pointer0);
   Procedure SearchAnt0  (Var Root0 : Pointer0);
   Procedure SearchPos0  (Var Root0 : Pointer0);
   Procedure LoadTree1   (Var Root1 : Pointer1);
   Procedure SearchTree1 (Var Root1 : Pointer1);
   Procedure SearchAnt1  (Var Root1 : Pointer1);
   Procedure SearchPos1  (Var Root1 : Pointer1);
   Procedure Dispose1    (Var Root1 : Pointer1);
   Procedure UnLoadTree1 (Var Root1 : Pointer1);
   Procedure LoadTree2   (Var Root2 : Pointer2);
   Procedure SearchTree2 (Var Root2 : Pointer2);
   Procedure SearchAnt2  (Var Root2 : Pointer2);
   Procedure SearchPos2  (Var Root2 : Pointer2);
   Procedure Dispose2    (Var Root2 : Pointer2);
   Procedure UnLoadTree2 (Var Root2 : Pointer2);
   Procedure LoadTree3   (Var Root3 : Pointer3);
   Procedure SearchTree3 (Var Root3 : Pointer3);
   Procedure SearchAnt3  (Var Root3 : Pointer3);
   Procedure SearchPos3  (Var Root3 : Pointer3);
   Procedure Dispose3    (Var Root3 : Pointer3);
   Procedure UnLoadTree3 (Var Root3 : Pointer3);
   Procedure LoadTree4   (Var Root4 : Pointer4);
   Procedure SearchTree4 (Var Root4 : Pointer4);
   Procedure SearchAnt4  (Var Root4 : Pointer4);
   Procedure SearchPos4  (Var Root4 : Pointer4);
   Procedure Dispose4    (Var Root4 : Pointer4);
   Procedure UnLoadTree4 (Var Root4 : Pointer4);
   Procedure DelTree5    (Var Root5 : Pointer5);
   Procedure LoadTree5   (Var Root5 : Pointer5);
   Procedure SearchTree5 (Var Root5 : Pointer5);
   Procedure SearchAnt5  (Var Root5 : Pointer5);
   Procedure SearchPos5  (Var Root5 : Pointer5);
   Procedure Dispose5    (Var Root5 : Pointer5);
   Procedure UnLoadTree5 (Var Root5 : Pointer5);
   Procedure LoadTree6   (Var Root6 : Pointer6);
   Procedure SearchTree6 (Var Root6 : Pointer6);
   Procedure SearchAnt6  (Var Root6 : Pointer6);
   Procedure SearchPos6  (Var Root6 : Pointer6);
   Procedure Dispose6    (Var Root6 : Pointer6);
   Procedure LoadTree7   (Var Root7 : Pointer7);
   Procedure SearchTree7 (Var Root7 : Pointer7);
   Procedure SearchAnt7  (Var Root7 : Pointer7);
   Procedure SearchPos7  (Var Root7 : Pointer7);
   Procedure Dispose7    (Var Root7 : Pointer7);
   Procedure UnLoadTree7 (Var Root7 : Pointer7);
   Procedure LoadTree8   (Var Root8 : Pointer8);
   Procedure SearchTree8 (Var Root8 : Pointer8);
   Procedure SearchAnt8  (Var Root8 : Pointer8);
   Procedure SearchPos8  (Var Root8 : Pointer8);
   Procedure Dispose8    (Var Root8 : Pointer8);
   Procedure UnLoadTree8 (Var Root8 : Pointer8);
   Procedure LoadTree10   (Var Root10: Pointer10);
   Procedure SearchTree10 (Var Root10: Pointer10);
   Procedure SearchAnt10  (Var Root10: Pointer10);
   Procedure SearchPos10  (Var Root10: Pointer10);
   Procedure UnLoadTree10 (Var Root10: Pointer10);
   Procedure DelTreeY    (Var RootY : PointerY);
   Procedure LoadTreeY   (Var RootY : PointerY);
   Procedure SearchTreeY (Var RootY : PointerY);
   Procedure SearchAntY  (Var RootY : PointerY);
   Procedure SearchPosY  (Var RootY : PointerY);
   Procedure DisposeY    (Var RootY : PointerY);


Implementation


{$I PlogTree.inc }

end.

