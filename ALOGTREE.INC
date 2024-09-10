Procedure UnloadIndex;
begin
  If XR = 23 then
     With IndXMember do
     begin
       I := FileSize(IndXFile);
       ReadWrite(#13,'W','N',I);
       For XR := 1 to 23 do begin
                              TipoX[XR]    := 'X';
                              ChaveX[XR]   := '';
                              RelAddrX[XR] := 0;
                            end;
       XR := 0;
     end;
end;


Procedure UnloadIndexL;
begin
  If XR = 64 then
     With IndLMember do
     begin
       I := FileSize(IndLFile);
       ReadWrite(#14,'W','N',I);
       For XR := 1 to 64 do begin
                              ChaveX[XR]   := '';
                              RelAddrX[XR] := 0;
                            end;
       XR := 0;
     end;
end;


Procedure UnloadIndexM;
begin
  If XR = 14 then
     With IndMMember do
     begin
       I := FileSize(IndMFile);
       ReadWrite(#15,'W','N',I);
       For XR := 1 to 14 do begin
                              ChaveX[XR]   := '';
                              RelAddrX[XR] := 0;
                            end;
       XR := 0;
     end;
end;


Function WtTreeB ( Var RootB : PointerB ) : Integer;
begin
  If RootB = NIL then WtTreeB := 1
                 else WtTreeB := RootB^.WeightB;
end;


Procedure LftRTreeB ( Var RootB : PointerB );
Var
   Temp : PointerB;

begin
  Temp           := RootB;
  RootB          := RootB^.RightB;
  Temp^.RightB   := RootB^.LeftB;
  RootB^.LeftB   := Temp;
  RootB^.WeightB := Temp^.WeightB;
  Temp^.WeightB  := WtTreeB ( Temp^.LeftB ) + WtTreeB ( Temp^.RightB );
end;


Procedure RthRTreeB ( Var RootB : PointerB );
Var
   Temp : PointerB;

begin
  Temp           := RootB;
  RootB          := RootB^.LeftB;
  Temp^.LeftB    := RootB^.RightB;
  RootB^.RightB  := Temp;
  RootB^.WeightB := Temp^.WeightB;
  Temp^.WeightB  := WtTreeB ( Temp^.LeftB ) + WtTreeB ( Temp^.RightB );
end;


Procedure ChkRTreeB ( Var RootB : PointerB );
Var
    Wl,Wr : Integer;

begin
  If RootB <> NIL then
     begin
       Wl := WtTreeB ( RootB^.LeftB  );
       Wr := WtTreeB ( RootB^.RightB );

       If Wr > Wl then
          begin
            If WtTreeB ( RootB^.RightB^.RightB ) > Wl then
               begin
                 LftRTreeB ( RootB );
                 ChkRTreeB ( RootB^.LeftB );
               end
               else If WtTreeB ( RootB^.RightB^.LeftB ) > Wl then
                       begin
                         RthRTreeB ( RootB^.RightB );
                         LftRTreeB ( RootB );
                         ChkRTreeB ( RootB^.LeftB  );
                         ChkRTreeB ( RootB^.RightB );
                       end;
          end
          else If Wl > Wr then
                  begin
                    If WtTreeB ( RootB^.LeftB^.LeftB ) > Wr then
                       begin
                         RthRTreeB ( RootB );
                         ChkRTreeB ( RootB^.RightB );
                       end
                       else If WtTreeB ( RootB^.LeftB^.RightB ) > Wr then
                               begin
                                 LftRTreeB ( RootB^.LeftB );
                                 RthRTreeB ( RootB );
                                 ChkRTreeB ( RootB^.LeftB  );
                                 ChkRTreeB ( RootB^.RightB );
                               end;
                  end;
     end;
end;


Procedure LoadTreeB ( Var RootB : PointerB );
begin
  If RootB = NIL then
     begin
       New ( RootB );
       RootB^.ChaveB   := BlkNo;
       RootB^.RelAddrB := BlkNumber;
       RootB^.LeftB    := NIL;
       RootB^.RightB   := NIL;
       RootB^.WeightB  := 2;
     end
     else If BlkNo <> RootB^.ChaveB then
             begin
               If BlkNo < RootB^.ChaveB then LoadTreeB ( RootB^.LeftB  )
                                        else LoadTreeB ( RootB^.RightB );
               RootB^.WeightB := WtTreeB ( RootB^.LeftB  ) +
                                 WtTreeB ( RootB^.RightB );
               ChkRTreeB ( RootB );
             end;
end;


Procedure SearchTreeB ( Var RootB : PointerB );
begin
  If RootB = NIL then RC := 'N'
     else If BlkNo < RootB^.ChaveB
             then SearchTreeB ( RootB^.LeftB )
             else If BlkNo > RootB^.ChaveB
                     then SearchTreeB ( RootB^.RightB )
                     else begin
                            RC        := 'S';
                            BlkNumber := RootB^.RelAddrB;
                          end;
end;


Procedure SearchAntB ( Var RootB : PointerB );
begin
  If RootB <> NIL then
     begin
       If (RootB^.RightB <> NIL          ) and
          (BlkNo          > RootB^.ChaveB) then SearchAntB ( RootB^.RightB );
       If (RC    = 'N'          ) and
          (BlkNo > RootB^.ChaveB) then
          begin
            RC        := 'S';
            BlkNumber := RootB^.RelAddrB;
            BlkNo     := RootB^.ChaveB;
          end
          else If RC = 'N' then If RootB^.LeftB  <> NIL
                                   then SearchAntB ( RootB^.LeftB  );
     end;
end;


Procedure SearchPosB ( Var RootB : PointerB );
begin
  If RootB <> NIL then
     begin
       If (RootB^.LeftB  <> NIL          ) and
          (BlkNo         <  RootB^.ChaveB) then SearchPosB ( RootB^.LeftB  );
       If (RC    = 'N'          ) and
          (BlkNo < RootB^.ChaveB) then
          begin
            RC        := 'S';
            BlkNumber := RootB^.RelAddrB;
            BlkNo     := RootB^.ChaveB;
          end
          else If RC = 'N' then If RootB^.RightB <> NIL
                                   then SearchPosB ( RootB^.RightB );
     end;
end;

Function WtTree0 ( Var Root0 : Pointer0 ) : Integer;
begin
  If Root0 = NIL then WtTree0 := 1
                 else WtTree0 := Root0^.Weight0;
end;


Procedure LftRTree0 ( Var Root0 : Pointer0 );
Var
   Temp : Pointer0;

begin
  Temp           := Root0;
  Root0          := Root0^.Right0;
  Temp^.Right0   := Root0^.Left0;
  Root0^.Left0   := Temp;
  Root0^.Weight0 := Temp^.Weight0;
  Temp^.Weight0  := WtTree0 ( Temp^.Left0 ) + WtTree0 ( Temp^.Right0 );
end;


Procedure RthRTree0 ( Var Root0 : Pointer0 );
Var
   Temp : Pointer0;

begin
  Temp           := Root0;
  Root0          := Root0^.Left0;
  Temp^.Left0    := Root0^.Right0;
  Root0^.Right0  := Temp;
  Root0^.Weight0 := Temp^.Weight0;
  Temp^.Weight0  := WtTree0 ( Temp^.Left0 ) + WtTree0 ( Temp^.Right0 );
end;


Procedure ChkRTree0 ( Var Root0 : Pointer0 );
Var
    Wl,Wr : Integer;

begin
  If Root0 <> NIL then
     begin
       Wl := WtTree0 ( Root0^.Left0  );
       Wr := WtTree0 ( Root0^.Right0 );

       If Wr > Wl then
          begin
            If WtTree0 ( Root0^.Right0^.Right0 ) > Wl then
               begin
                 LftRTree0 ( Root0 );
                 ChkRTree0 ( Root0^.Left0 );
               end
               else If WtTree0 ( Root0^.Right0^.Left0 ) > Wl then
                       begin
                         RthRTree0 ( Root0^.Right0 );
                         LftRTree0 ( Root0 );
                         ChkRTree0 ( Root0^.Left0  );
                         ChkRTree0 ( Root0^.Right0 );
                       end;
          end
          else If Wl > Wr then
                  begin
                    If WtTree0 ( Root0^.Left0^.Left0 ) > Wr then
                       begin
                         RthRTree0 ( Root0 );
                         ChkRTree0 ( Root0^.Right0 );
                       end
                       else If WtTree0 ( Root0^.Left0^.Right0 ) > Wr then
                               begin
                                 LftRTree0 ( Root0^.Left0 );
                                 RthRTree0 ( Root0 );
                                 ChkRTree0 ( Root0^.Left0  );
                                 ChkRTree0 ( Root0^.Right0 );
                               end;
                  end;
     end;
end;


Procedure LoadTree0 ( Var Root0 : Pointer0 );
begin
  If Root0 = NIL then
     begin
       New ( Root0 );
       Root0^.Chave0   := CmpyNo;
       Root0^.RelAddr0 := CmpyNumber;
       Root0^.Left0    := NIL;
       Root0^.Right0   := NIL;
       Root0^.Weight0  := 2;
     end
     else If CmpyNo <> Root0^.Chave0 then
             begin
               If CmpyNo < Root0^.Chave0 then LoadTree0 ( Root0^.Left0  )
                                         else LoadTree0 ( Root0^.Right0 );
               Root0^.Weight0 := WtTree0 ( Root0^.Left0  ) +
                                 WtTree0 ( Root0^.Right0 );
               ChkRTree0 ( Root0 );
             end;
end;


Procedure SearchTree0 ( Var Root0 : Pointer0 );
begin
  If Root0 = NIL then RC := 'N'
     else If CmpyNo < Root0^.Chave0
             then SearchTree0 ( Root0^.Left0 )
             else If CmpyNo > Root0^.Chave0
                     then SearchTree0 ( Root0^.Right0 )
                     else begin
                            RC         := 'S';
                            CmpyNumber := Root0^.RelAddr0;
                          end;
end;


Procedure SearchAnt0 ( Var Root0 : Pointer0 );
begin
  If Root0 <> NIL then
     begin
       If (Root0^.Right0 <> NIL          ) and
          (CmpyNo         > Root0^.Chave0) then SearchAnt0 ( Root0^.Right0 );
       If (RC     = 'N'          ) and
          (CmpyNo > Root0^.Chave0) then
          begin
            RC         := 'S';
            CmpyNumber := Root0^.RelAddr0;
            CmpyNo     := Root0^.Chave0;
          end
          else If RC = 'N' then If Root0^.Left0  <> NIL
                                   then SearchAnt0 ( Root0^.Left0 );
     end;
end;


Procedure SearchPos0 ( Var Root0 : Pointer0 );
begin
  If Root0 <> NIL then
     begin
       If (Root0^.Left0  <> NIL          ) and
          (CmpyNo        <  Root0^.Chave0) then SearchPos0 ( Root0^.Left0 );
       If (RC     = 'N'          ) and
          (CmpyNo < Root0^.Chave0) then
          begin
            RC         := 'S';
            CmpyNumber := Root0^.RelAddr0;
            CmpyNo     := Root0^.Chave0;
          end
          else If RC = 'N' then If Root0^.Right0 <> NIL
                                   then SearchPos0 ( Root0^.Right0 );
     end;
end;


Function WtTree1 ( Var Root1 : Pointer1 ) : Integer;
begin
  If Root1 = NIL then WtTree1 := 1
                 else WtTree1 := Root1^.Weight1;
end;


Procedure LftRTree1 ( Var Root1 : Pointer1 );
Var
   Temp : Pointer1;

begin
  Temp           := Root1;
  Root1          := Root1^.Right1;
  Temp^.Right1   := Root1^.Left1;
  Root1^.Left1   := Temp;
  Root1^.Weight1 := Temp^.Weight1;
  Temp^.Weight1  := WtTree1 ( Temp^.Left1 ) + WtTree1 ( Temp^.Right1 );
end;


Procedure RthRTree1 ( Var Root1 : Pointer1 );
Var
   Temp : Pointer1;

begin
  Temp           := Root1;
  Root1          := Root1^.Left1;
  Temp^.Left1    := Root1^.Right1;
  Root1^.Right1  := Temp;
  Root1^.Weight1 := Temp^.Weight1;
  Temp^.Weight1  := WtTree1 ( Temp^.Left1 ) + WtTree1 ( Temp^.Right1 );
end;


Procedure ChkRTree1 ( Var Root1 : Pointer1 );
Var
    Wl,Wr : Integer;

begin
  If Root1 <> NIL then
     begin
       Wl := WtTree1 ( Root1^.Left1  );
       Wr := WtTree1 ( Root1^.Right1 );

       If Wr > Wl then
          begin
            If WtTree1 ( Root1^.Right1^.Right1 ) > Wl then
               begin
                 LftRTree1 ( Root1 );
                 ChkRTree1 ( Root1^.Left1 );
               end
               else If WtTree1 ( Root1^.Right1^.Left1 ) > Wl then
                       begin
                         RthRTree1 ( Root1^.Right1 );
                         LftRTree1 ( Root1 );
                         ChkRTree1 ( Root1^.Left1  );
                         ChkRTree1 ( Root1^.Right1 );
                       end;
          end
          else If Wl > Wr then
                  begin
                    If WtTree1 ( Root1^.Left1^.Left1 ) > Wr then
                       begin
                         RthRTree1 ( Root1 );
                         ChkRTree1 ( Root1^.Right1 );
                       end
                       else If WtTree1 ( Root1^.Left1^.Right1 ) > Wr then
                               begin
                                 LftRTree1 ( Root1^.Left1 );
                                 RthRTree1 ( Root1 );
                                 ChkRTree1 ( Root1^.Left1  );
                                 ChkRTree1 ( Root1^.Right1 );
                               end;
                  end;
     end;
end;


Procedure LoadTree1 ( Var Root1 : Pointer1 );
begin
  If Root1 = NIL then
     begin
       New ( Root1 );
       Root1^.Chave1   := ContaNo;
       Root1^.RelAddr1 := ContaNumber;
       Root1^.Left1    := NIL;
       Root1^.Right1   := NIL;
       Root1^.Weight1  := 2;
     end
     else If ContaNo <> Root1^.Chave1 then
             begin
               If ContaNo < Root1^.Chave1 then LoadTree1 ( Root1^.Left1  )
                                          else LoadTree1 ( Root1^.Right1 );
               Root1^.Weight1 := WtTree1 ( Root1^.Left1  ) +
                                 WtTree1 ( Root1^.Right1 );
               ChkRTree1 ( Root1 );
             end;
end;


Procedure SearchTree1 ( Var Root1 : Pointer1 );
begin
  If Root1 = NIL then RC := 'N'
     else If ContaNo < Root1^.Chave1
             then SearchTree1 ( Root1^.Left1 )
             else If ContaNo > Root1^.Chave1
                     then SearchTree1 ( Root1^.Right1 )
                     else begin
                            RC          := 'S';
                            ContaNumber := Root1^.RelAddr1;
                          end;
end;


Procedure SearchAnt1 ( Var Root1 : Pointer1 );
begin
  If Root1 <> NIL then
     begin
       If (Root1^.Right1 <> NIL          ) and
          (ContaNo        > Root1^.Chave1) then SearchAnt1 ( Root1^.Right1 );
       If (RC      = 'N'          ) and
          (ContaNo > Root1^.Chave1) then
          begin
            RC          := 'S';
            ContaNumber := Root1^.RelAddr1;
            ContaNo     := Root1^.Chave1;
          end
          else If RC = 'N' then If Root1^.Left1 <> NIL
                                   then SearchAnt1 ( Root1^.Left1 );
     end;
end;


Procedure SearchPos1 ( Var Root1 : Pointer1 );
begin
  If Root1 <> NIL then
     begin
       If (Root1^.Left1   <> NIL          ) and
          (ContaNo        <  Root1^.Chave1) then SearchPos1 ( Root1^.Left1 );
       If (RC      = 'N'          ) and
          (ContaNo < Root1^.Chave1) then
          begin
            RC          := 'S';
            ContaNumber := Root1^.RelAddr1;
            ContaNo     := Root1^.Chave1;
          end
          else If RC = 'N' then If Root1^.Right1 <> NIL
                                   then SearchPos1 ( Root1^.Right1 );
     end;
end;


Procedure Dispose1 ( Var Root1 : Pointer1 );
begin
  If Root1 <> NIL then
     begin
       If Root1^.Left1  <> NIL then Dispose1 ( Root1^.Left1  );
       If Root1^.Right1 <> NIL then Dispose1 ( Root1^.Right1 );
       Dispose(Root1);
     end;
end;


Procedure UnLoadTree1 ( Var Root1 : Pointer1 );
begin
  If Root1 <> NIL then
     begin
       If Root1^.Left1  <> NIL then UnLoadTree1 ( Root1^.Left1  );
       XR                      := XR + 1;
       IndXMember.TipoX[XR]    := '1';
       IndXMember.ChaveX[XR]   := Root1^.Chave1;
       IndXMember.RelAddrX[XR] := Root1^.RelAddr1;
       UnloadIndex;
       If Root1^.Right1 <> NIL then UnLoadTree1 ( Root1^.Right1 );
     end;
end;


Function WtTree2 ( Var Root2 : Pointer2 ) : Integer;
begin
  If Root2 = NIL then WtTree2 := 1
                 else WtTree2 := Root2^.Weight2;
end;


Procedure LftRTree2 ( Var Root2 : Pointer2 );
Var
   Temp : Pointer2;

begin
  Temp           := Root2;
  Root2          := Root2^.Right2;
  Temp^.Right2   := Root2^.Left2;
  Root2^.Left2   := Temp;
  Root2^.Weight2 := Temp^.Weight2;
  Temp^.Weight2  := WtTree2 ( Temp^.Left2 ) + WtTree2 ( Temp^.Right2 );
end;


Procedure RthRTree2 ( Var Root2 : Pointer2 );
Var
   Temp : Pointer2;

begin
  Temp           := Root2;
  Root2          := Root2^.Left2;
  Temp^.Left2    := Root2^.Right2;
  Root2^.Right2  := Temp;
  Root2^.Weight2 := Temp^.Weight2;
  Temp^.Weight2  := WtTree2 ( Temp^.Left2 ) + WtTree2 ( Temp^.Right2 );
end;


Procedure ChkRTree2 ( Var Root2 : Pointer2 );
Var
    Wl,Wr : Integer;

begin
  If Root2 <> NIL then
     begin
       Wl := WtTree2 ( Root2^.Left2  );
       Wr := WtTree2 ( Root2^.Right2 );

       If Wr > Wl then
          begin
            If WtTree2 ( Root2^.Right2^.Right2 ) > Wl then
               begin
                 LftRTree2 ( Root2 );
                 ChkRTree2 ( Root2^.Left2 );
               end
               else If WtTree2 ( Root2^.Right2^.Left2 ) > Wl then
                       begin
                         RthRTree2 ( Root2^.Right2 );
                         LftRTree2 ( Root2 );
                         ChkRTree2 ( Root2^.Left2  );
                         ChkRTree2 ( Root2^.Right2 );
                       end;
          end
          else If Wl > Wr then
                  begin
                    If WtTree2 ( Root2^.Left2^.Left2 ) > Wr then
                       begin
                         RthRTree2 ( Root2 );
                         ChkRTree2 ( Root2^.Right2 );
                       end
                       else If WtTree2 ( Root2^.Left2^.Right2 ) > Wr then
                               begin
                                 LftRTree2 ( Root2^.Left2 );
                                 RthRTree2 ( Root2 );
                                 ChkRTree2 ( Root2^.Left2  );
                                 ChkRTree2 ( Root2^.Right2 );
                               end;
                  end;
     end;
end;


Procedure LoadTree2 ( Var Root2 : Pointer2 );
begin
  If Root2 = NIL then
     begin
       New ( Root2 );
       Root2^.Chave2   := LoteNo;
       Root2^.RelAddr2 := LoteNumber;
       Root2^.Left2    := NIL;
       Root2^.Right2   := NIL;
       Root2^.Weight2  := 2;
     end
     else If LoteNo <> Root2^.Chave2 then
             begin
               If LoteNo < Root2^.Chave2 then LoadTree2 ( Root2^.Left2  )
                                         else LoadTree2 ( Root2^.Right2 );
               Root2^.Weight2 := WtTree2 ( Root2^.Left2  ) +
                                 WtTree2 ( Root2^.Right2 );
               ChkRTree2 ( Root2 );
             end;
end;


Procedure SearchTree2 ( Var Root2 : Pointer2 );
begin
  If Root2 = NIL then RC := 'N'
     else If LoteNo < Root2^.Chave2
             then SearchTree2 ( Root2^.Left2 )
             else If LoteNo > Root2^.Chave2
                     then SearchTree2 ( Root2^.Right2 )
                     else begin
                            RC         := 'S';
                            LoteNumber := Root2^.RelAddr2;
                          end;
end;


Procedure SearchAnt2 ( Var Root2 : Pointer2 );
begin
  If Root2 <> NIL then
     begin
       If (Root2^.Right2 <> NIL   ) and
          (LoteNo         > Root2^.Chave2) then SearchAnt2 ( Root2^.Right2 );
       If (RC     = 'N'          ) and
          (LoteNo > Root2^.Chave2) then
          begin
            RC         := 'S';
            LoteNumber := Root2^.RelAddr2;
            LoteNo     := Root2^.Chave2;
          end
          else If RC = 'N' then If Root2^.Left2 <> NIL
                                   then SearchAnt2 ( Root2^.Left2  );
     end;
end;


Procedure SearchPos2 ( Var Root2 : Pointer2 );
begin
  If Root2 <> NIL then
     begin
       If (Root2^.Left2  <> NIL   ) and
          (LoteNo        <  Root2^.Chave2) then SearchPos2 ( Root2^.Left2 );
       If (RC     = 'N'          ) and
          (LoteNo < Root2^.Chave2) then
          begin
            RC         := 'S';
            LoteNumber := Root2^.RelAddr2;
            LoteNo     := Root2^.Chave2;
          end
          else If RC = 'N' then If Root2^.Right2 <> NIL
                                   then SearchPos2 ( Root2^.Right2 );
     end;
end;


Procedure Dispose2 ( Var Root2 : Pointer2 );
begin
  If Root2 <> NIL then
     begin
       If Root2^.Left2  <> NIL then Dispose2 ( Root2^.Left2  );
       If Root2^.Right2 <> NIL then Dispose2 ( Root2^.Right2 );
       Dispose(Root2);
     end;
end;


Procedure UnLoadTree2 ( Var Root2 : Pointer2 );
begin
  If Root2 <> NIL then
     begin
       If Root2^.Left2  <> NIL then UnLoadTree2 ( Root2^.Left2  );
       XR                      := XR + 1;
       IndLMember.ChaveX[XR]   := Root2^.Chave2;
       IndLMember.RelAddrX[XR] := Root2^.RelAddr2;
       UnloadIndexL;
       If Root2^.Right2 <> NIL then UnLoadTree2 ( Root2^.Right2 );
     end;
end;


Function WtTree3 ( Var Root3 : Pointer3 ) : Integer;
begin
  If Root3 = NIL then WtTree3 := 1
                 else WtTree3 := Root3^.Weight3;
end;


Procedure LftRTree3 ( Var Root3 : Pointer3 );
Var
   Temp : Pointer3;

begin
  Temp           := Root3;
  Root3          := Root3^.Right3;
  Temp^.Right3   := Root3^.Left3;
  Root3^.Left3   := Temp;
  Root3^.Weight3 := Temp^.Weight3;
  Temp^.Weight3  := WtTree3 ( Temp^.Left3 ) + WtTree3 ( Temp^.Right3 );
end;


Procedure RthRTree3 ( Var Root3 : Pointer3 );
Var
   Temp : Pointer3;

begin
  Temp           := Root3;
  Root3          := Root3^.Left3;
  Temp^.Left3    := Root3^.Right3;
  Root3^.Right3  := Temp;
  Root3^.Weight3 := Temp^.Weight3;
  Temp^.Weight3  := WtTree3 ( Temp^.Left3 ) + WtTree3 ( Temp^.Right3 );
end;


Procedure ChkRTree3 ( Var Root3 : Pointer3 );
Var
    Wl,Wr : Integer;

begin
  If Root3 <> NIL then
     begin
       Wl := WtTree3 ( Root3^.Left3  );
       Wr := WtTree3 ( Root3^.Right3 );

       If Wr > Wl then
          begin
            If WtTree3 ( Root3^.Right3^.Right3 ) > Wl then
               begin
                 LftRTree3 ( Root3 );
                 ChkRTree3 ( Root3^.Left3 );
               end
               else If WtTree3 ( Root3^.Right3^.Left3 ) > Wl then
                       begin
                         RthRTree3 ( Root3^.Right3 );
                         LftRTree3 ( Root3 );
                         ChkRTree3 ( Root3^.Left3  );
                         ChkRTree3 ( Root3^.Right3 );
                       end;
          end
          else If Wl > Wr then
                  begin
                    If WtTree3 ( Root3^.Left3^.Left3 ) > Wr then
                       begin
                         RthRTree3 ( Root3 );
                         ChkRTree3 ( Root3^.Right3 );
                       end
                       else If WtTree3 ( Root3^.Left3^.Right3 ) > Wr then
                               begin
                                 LftRTree3 ( Root3^.Left3 );
                                 RthRTree3 ( Root3 );
                                 ChkRTree3 ( Root3^.Left3  );
                                 ChkRTree3 ( Root3^.Right3 );
                               end;
                  end;
     end;
end;


Procedure LoadTree3 ( Var Root3 : Pointer3 );
begin
  If Root3 = NIL then
     begin
       New ( Root3 );
       Root3^.Chave3   := DeptNo;
       Root3^.RelAddr3 := DeptNumber;
       Root3^.Left3    := NIL;
       Root3^.Right3   := NIL;
       Root3^.Weight3  := 2;
     end
     else If DeptNo <> Root3^.Chave3 then
             begin
               If DeptNo < Root3^.Chave3 then LoadTree3 ( Root3^.Left3  )
                                         else LoadTree3 ( Root3^.Right3 );
               Root3^.Weight3 := WtTree3 ( Root3^.Left3  ) +
                                 WtTree3 ( Root3^.Right3 );
               ChkRTree3 ( Root3 );
             end;
end;


Procedure SearchTree3 ( Var Root3 : Pointer3 );
begin
  If Root3 = NIL then RC := 'N'
     else If DeptNo < Root3^.Chave3
             then SearchTree3 ( Root3^.Left3 )
             else If DeptNo > Root3^.Chave3
                     then SearchTree3 ( Root3^.Right3 )
                     else begin
                            RC         := 'S';
                            DeptNumber := Root3^.RelAddr3;
                          end;
end;


Procedure SearchAnt3 ( Var Root3 : Pointer3 );
begin
  If Root3 <> NIL then
     begin
       If (Root3^.Right3 <> NIL          ) and
          (DeptNo         > Root3^.Chave3) then SearchAnt3 ( Root3^.Right3 );
       If (RC     = 'N'          ) and
          (DeptNo > Root3^.Chave3) then
          begin
            RC         := 'S';
            DeptNumber := Root3^.RelAddr3;
            DeptNo     := Root3^.Chave3;
          end
          else If RC = 'N' then If Root3^.Left3 <> NIL
                                   then SearchAnt3 ( Root3^.Left3  );
     end;
end;


Procedure SearchPos3 ( Var Root3 : Pointer3 );
begin
  If Root3 <> NIL then
     begin
       If (Root3^.Left3  <> NIL          ) and
          (DeptNo        <  Root3^.Chave3) then SearchPos3 ( Root3^.Left3 );
       If (RC     = 'N'          ) and
          (DeptNo < Root3^.Chave3) then
          begin
            RC         := 'S';
            DeptNumber := Root3^.RelAddr3;
            DeptNo     := Root3^.Chave3;
          end
          else If RC = 'N' then If Root3^.Right3 <> NIL
                                   then SearchPos3 ( Root3^.Right3 );
     end;
end;


Procedure Dispose3 ( Var Root3 : Pointer3 );
begin
  If Root3 <> NIL then
     begin
       If Root3^.Left3  <> NIL then Dispose3 ( Root3^.Left3  );
       If Root3^.Right3 <> NIL then Dispose3 ( Root3^.Right3 );
       Dispose(Root3);
     end;
end;


Procedure UnLoadTree3 ( Var Root3 : Pointer3 );
begin
  If Root3 <> NIL then
     begin
       If Root3^.Left3  <> NIL then UnLoadTree3 ( Root3^.Left3  );
       XR                      := XR + 1;
       IndXMember.TipoX[XR]    := '3';
       IndXMember.ChaveX[XR]   := Root3^.Chave3;
       IndXMember.RelAddrX[XR] := Root3^.RelAddr3;
       UnloadIndex;
       If Root3^.Right3 <> NIL then UnLoadTree3 ( Root3^.Right3 );
     end;
end;


Function WtTree4 ( Var Root4 : Pointer4 ) : Integer;
begin
  If Root4 = NIL then WtTree4 := 1
                 else WtTree4 := Root4^.Weight4;
end;


Procedure LftRTree4 ( Var Root4 : Pointer4 );
Var
   Temp : Pointer4;

begin
  Temp           := Root4;
  Root4          := Root4^.Right4;
  Temp^.Right4   := Root4^.Left4;
  Root4^.Left4   := Temp;
  Root4^.Weight4 := Temp^.Weight4;
  Temp^.Weight4  := WtTree4 ( Temp^.Left4 ) + WtTree4 ( Temp^.Right4 );
end;


Procedure RthRTree4 ( Var Root4 : Pointer4 );
Var
   Temp : Pointer4;

begin
  Temp           := Root4;
  Root4          := Root4^.Left4;
  Temp^.Left4    := Root4^.Right4;
  Root4^.Right4  := Temp;
  Root4^.Weight4 := Temp^.Weight4;
  Temp^.Weight4  := WtTree4 ( Temp^.Left4 ) + WtTree4 ( Temp^.Right4 );
end;


Procedure ChkRTree4 ( Var Root4 : Pointer4 );
Var
    Wl,Wr : Integer;

begin
  If Root4 <> NIL then
     begin
       Wl := WtTree4 ( Root4^.Left4  );
       Wr := WtTree4 ( Root4^.Right4 );

       If Wr > Wl then
          begin
            If WtTree4 ( Root4^.Right4^.Right4 ) > Wl then
               begin
                 LftRTree4 ( Root4 );
                 ChkRTree4 ( Root4^.Left4 );
               end
               else If WtTree4 ( Root4^.Right4^.Left4 ) > Wl then
                       begin
                         RthRTree4 ( Root4^.Right4 );
                         LftRTree4 ( Root4 );
                         ChkRTree4 ( Root4^.Left4  );
                         ChkRTree4 ( Root4^.Right4 );
                       end;
          end
          else If Wl > Wr then
                  begin
                    If WtTree4 ( Root4^.Left4^.Left4 ) > Wr then
                       begin
                         RthRTree4 ( Root4 );
                         ChkRTree4 ( Root4^.Right4 );
                       end
                       else If WtTree4 ( Root4^.Left4^.Right4 ) > Wr then
                               begin
                                 LftRTree4 ( Root4^.Left4 );
                                 RthRTree4 ( Root4 );
                                 ChkRTree4 ( Root4^.Left4  );
                                 ChkRTree4 ( Root4^.Right4 );
                               end;
                  end;
     end;
end;


Procedure ConectTree4 ( Var Temp,Root4 : Pointer4);
begin
  If Root4^.Right4 = NIL then Root4^.Right4 := Temp
                         else ConectTree4 (Temp,Root4^.Right4);

  Root4^.Weight4 := WtTree4 ( Root4^.Left4  ) +
                    WtTree4 ( Root4^.Right4 );
  ChkRTree4 ( Root4 );
end;


Procedure DelTree4 ( Var Root4 : Pointer4 );
Var
  TempL,TempR : Pointer4;

begin
  If Root4 <> NIL then
     begin
       If CDVSNo < Root4^.Chave4 then DelTree4 ( Root4^.Left4 )
          else If CDVSNo > Root4^.Chave4 then DelTree4 ( Root4^.Right4 )
                  else begin
                         If (Root4^.Left4  <> NIL) and
                            (Root4^.Right4 <> NIL) then
                            begin
                              TempL := Root4^.Left4;
                              TempR := Root4^.Right4;
                              Dispose (Root4);
                              Root4 := TempL;
                              ConectTree4 (TempR,Root4);
                            end
                            else If Root4^.Left4 <> NIL then
                                    begin
                                      TempL := Root4^.Left4;
                                      Dispose (Root4);
                                      Root4 := TempL;
                                    end
                                    else If Root4^.Right4 <> NIL then
                                            begin
                                              TempR := Root4^.Right4;
                                              Dispose (Root4);
                                              Root4 := TempR;
                                            end
                                            else begin
                                                   Dispose (Root4);
                                                   Root4 := NIL;
                                                 end;
                         If Root4 <> NIL then
                            begin
                              Root4^.Weight4 := WtTree4 ( Root4^.Left4  ) +
                                                WtTree4 ( Root4^.Right4 );
                              ChkRTree4 ( Root4 );
                            end;
                       end;
     end;
end;


Procedure LoadTree4 ( Var Root4 : Pointer4 );
begin
  If Root4 = NIL then
     begin
       New ( Root4 );
       Root4^.Chave4   := CDVSNo;
       Root4^.RelAddr4 := CDVSNumber;
       Root4^.Left4    := NIL;
       Root4^.Right4   := NIL;
       Root4^.Weight4  := 2;
     end
     else If CDVSNo <> Root4^.Chave4 then
             begin
               If CDVSNo < Root4^.Chave4 then LoadTree4 ( Root4^.Left4  )
                                         else LoadTree4 ( Root4^.Right4 );
               Root4^.Weight4 := WtTree4 ( Root4^.Left4  ) +
                                 WtTree4 ( Root4^.Right4 );
               ChkRTree4 ( Root4 );
             end;
end;


Procedure SearchTree4 ( Var Root4 : Pointer4 );
begin
  If Root4 = NIL then RC := 'N'
     else If CDVSNo < Root4^.Chave4 then SearchTree4 ( Root4^.Left4 )
             else If CDVSNo > Root4^.Chave4
                     then SearchTree4 ( Root4^.Right4 )
                     else begin
                            RC         := 'S';
                            CDVSNumber := Root4^.RelAddr4;
                          end;
end;


Procedure SearchAnt4 ( Var Root4 : Pointer4 );
begin
  If Root4 <> NIL then
     begin
       If (Root4^.Right4 <> NIL          ) and
          (CDVSNo         > Root4^.Chave4) then SearchAnt4 ( Root4^.Right4 );
       If (RC     = 'N'          ) and
          (CDVSNo > Root4^.Chave4) then
          begin
            RC         := 'S';
            CDVSNumber := Root4^.RelAddr4;
            CDVSNo     := Root4^.Chave4;
          end
          else If RC = 'N' then If Root4^.Left4 <> NIL
                                   then SearchAnt4 ( Root4^.Left4 );
     end;
end;


Procedure SearchPos4 ( Var Root4 : Pointer4 );
begin
  If Root4 <> NIL then
     begin
       If (Root4^.Left4  <> NIL          ) and
          (CDVSNo        <  Root4^.Chave4) then SearchPos4 ( Root4^.Left4 );
       If (RC     = 'N'          ) and
          (CDVSNo < Root4^.Chave4) then
          begin
            RC         := 'S';
            CDVSNumber := Root4^.RelAddr4;
            CDVSNo     := Root4^.Chave4;
          end
          else If RC = 'N' then If Root4^.Right4 <> NIL
                                   then SearchPos4 ( Root4^.Right4 );
     end;
end;


Procedure Dispose4 ( Var Root4 : Pointer4 );
begin
  If Root4 <> NIL then
     begin
       If Root4^.Left4  <> NIL then Dispose4 ( Root4^.Left4  );
       If Root4^.Right4 <> NIL then Dispose4 ( Root4^.Right4 );
       Dispose(Root4);
     end;
end;


Procedure UnLoadTree4 ( Var Root4 : Pointer4 );
begin
  If Root4 <> NIL then
     begin
       If Root4^.Left4  <> NIL then UnLoadTree4 ( Root4^.Left4  );
       XR                      := XR + 1;
       IndMMember.ChaveX[XR]   := Root4^.Chave4;
       IndMMember.RelAddrX[XR] := Root4^.RelAddr4;
       UnloadIndexM;
       If Root4^.Right4 <> NIL then UnLoadTree4 ( Root4^.Right4 );
     end;
end;


Function WtTree5 ( Var Root5 : Pointer5 ) : Integer;
begin
  If Root5 = NIL then WtTree5 := 1
                 else WtTree5 := Root5^.Weight5;
end;


Procedure LftRTree5 ( Var Root5 : Pointer5 );
Var
   Temp : Pointer5;

begin
  Temp           := Root5;
  Root5          := Root5^.Right5;
  Temp^.Right5   := Root5^.Left5;
  Root5^.Left5   := Temp;
  Root5^.Weight5 := Temp^.Weight5;
  Temp^.Weight5  := WtTree5 ( Temp^.Left5 ) + WtTree5 ( Temp^.Right5 );
end;


Procedure RthRTree5 ( Var Root5 : Pointer5 );
Var
   Temp : Pointer5;

begin
  Temp           := Root5;
  Root5          := Root5^.Left5;
  Temp^.Left5    := Root5^.Right5;
  Root5^.Right5  := Temp;
  Root5^.Weight5 := Temp^.Weight5;
  Temp^.Weight5  := WtTree5 ( Temp^.Left5 ) + WtTree5 ( Temp^.Right5 );
end;


Procedure ChkRTree5 ( Var Root5 : Pointer5 );
Var
    Wl,Wr : Integer;

begin
  If Root5 <> NIL then
     begin
       Wl := WtTree5 ( Root5^.Left5  );
       Wr := WtTree5 ( Root5^.Right5 );

       If Wr > Wl then
          begin
            If WtTree5 ( Root5^.Right5^.Right5 ) > Wl then
               begin
                 LftRTree5 ( Root5 );
                 ChkRTree5 ( Root5^.Left5 );
               end
               else If WtTree5 ( Root5^.Right5^.Left5 ) > Wl then
                       begin
                         RthRTree5 ( Root5^.Right5 );
                         LftRTree5 ( Root5 );
                         ChkRTree5 ( Root5^.Left5  );
                         ChkRTree5 ( Root5^.Right5 );
                       end;
          end
          else If Wl > Wr then
                  begin
                    If WtTree5 ( Root5^.Left5^.Left5 ) > Wr then
                       begin
                         RthRTree5 ( Root5 );
                         ChkRTree5 ( Root5^.Right5 );
                       end
                       else If WtTree5 ( Root5^.Left5^.Right5 ) > Wr then
                               begin
                                 LftRTree5 ( Root5^.Left5 );
                                 RthRTree5 ( Root5 );
                                 ChkRTree5 ( Root5^.Left5  );
                                 ChkRTree5 ( Root5^.Right5 );
                               end;
                  end;
     end;
end;


Procedure LoadTree5 ( Var Root5 : Pointer5 );
begin
  If Root5 = NIL then
     begin
       New ( Root5 );
       Root5^.Chave5   := ExpeNo;
       Root5^.RelAddr5 := ExpeNumber;
       Root5^.Left5    := NIL;
       Root5^.Right5   := NIL;
       Root5^.Weight5  := 2;
     end
     else If ExpeNo <> Root5^.Chave5 then
             begin
               If ExpeNo < Root5^.Chave5 then LoadTree5 ( Root5^.Left5  )
                                         else LoadTree5 ( Root5^.Right5 );
               Root5^.Weight5 := WtTree5 ( Root5^.Left5  ) +
                                 WtTree5 ( Root5^.Right5 );
               ChkRTree5 ( Root5 );
             end;
end;


Procedure SearchTree5 ( Var Root5 : Pointer5 );
begin
  If Root5 = NIL then RC := 'N'
     else If ExpeNo < Root5^.Chave5 then SearchTree5 ( Root5^.Left5 )
             else If ExpeNo > Root5^.Chave5
                     then SearchTree5 ( Root5^.Right5 )
                     else begin
                            RC         := 'S';
                            ExpeNumber := Root5^.RelAddr5;
                          end;
end;


Procedure SearchAnt5 ( Var Root5 : Pointer5 );
begin
  If Root5 <> NIL then
     begin
       If (Root5^.Right5 <> NIL          ) and
          (ExpeNo         > Root5^.Chave5) then SearchAnt5 ( Root5^.Right5 );
       If (RC     = 'N'          ) and
          (ExpeNo > Root5^.Chave5) then
          begin
            RC         := 'S';
            ExpeNumber := Root5^.RelAddr5;
            ExpeNo     := Root5^.Chave5;
          end
          else If RC = 'N' then If Root5^.Left5 <> NIL
                                   then SearchAnt5 ( Root5^.Left5  );
     end;
end;


Procedure SearchPos5 ( Var Root5 : Pointer5 );
begin
  If Root5 <> NIL then
     begin
       If (Root5^.Left5  <> NIL          ) and
          (ExpeNo        <  Root5^.Chave5) then SearchPos5 ( Root5^.Left5  );
       If (RC     = 'N'          ) and
          (ExpeNo < Root5^.Chave5) then
          begin
            RC         := 'S';
            ExpeNumber := Root5^.RelAddr5;
            ExpeNo     := Root5^.Chave5;
          end
          else If RC = 'N' then If Root5^.Right5 <> NIL
                                   then SearchPos5 ( Root5^.Right5 );
     end;
end;


Procedure Dispose5 ( Var Root5 : Pointer5 );
begin
  If Root5 <> NIL then
     begin
       If Root5^.Left5  <> NIL then Dispose5 ( Root5^.Left5  );
       If Root5^.Right5 <> NIL then Dispose5 ( Root5^.Right5 );
       Dispose(Root5);
     end;
end;


Function WtTree6 ( Var Root6 : Pointer6 ) : Integer;
begin
  If Root6 = NIL then WtTree6 := 1
                 else WtTree6 := Root6^.Weight6;
end;


Procedure LftRTree6 ( Var Root6 : Pointer6 );
Var
   Temp : Pointer6;

begin
  Temp           := Root6;
  Root6          := Root6^.Right6;
  Temp^.Right6   := Root6^.Left6;
  Root6^.Left6   := Temp;
  Root6^.Weight6 := Temp^.Weight6;
  Temp^.Weight6  := WtTree6 ( Temp^.Left6 ) + WtTree6 ( Temp^.Right6 );
end;


Procedure RthRTree6 ( Var Root6 : Pointer6 );
Var
   Temp : Pointer6;

begin
  Temp           := Root6;
  Root6          := Root6^.Left6;
  Temp^.Left6    := Root6^.Right6;
  Root6^.Right6  := Temp;
  Root6^.Weight6 := Temp^.Weight6;
  Temp^.Weight6  := WtTree6 ( Temp^.Left6 ) + WtTree6 ( Temp^.Right6 );
end;


Procedure ChkRTree6 ( Var Root6 : Pointer6 );
Var
    Wl,Wr : Integer;

begin
  If Root6 <> NIL then
     begin
       Wl := WtTree6 ( Root6^.Left6  );
       Wr := WtTree6 ( Root6^.Right6 );

       If Wr > Wl then
          begin
            If WtTree6 ( Root6^.Right6^.Right6 ) > Wl then
               begin
                 LftRTree6 ( Root6 );
                 ChkRTree6 ( Root6^.Left6 );
               end
               else If WtTree6 ( Root6^.Right6^.Left6 ) > Wl then
                       begin
                         RthRTree6 ( Root6^.Right6 );
                         LftRTree6 ( Root6 );
                         ChkRTree6 ( Root6^.Left6  );
                         ChkRTree6 ( Root6^.Right6 );
                       end;
          end
          else If Wl > Wr then
                  begin
                    If WtTree6 ( Root6^.Left6^.Left6 ) > Wr then
                       begin
                         RthRTree6 ( Root6 );
                         ChkRTree6 ( Root6^.Right6 );
                       end
                       else If WtTree6 ( Root6^.Left6^.Right6 ) > Wr then
                               begin
                                 LftRTree6 ( Root6^.Left6 );
                                 RthRTree6 ( Root6 );
                                 ChkRTree6 ( Root6^.Left6  );
                                 ChkRTree6 ( Root6^.Right6 );
                               end;
                  end;
     end;
end;


Procedure ConectTree6 ( Var Temp,Root6 : Pointer6);
begin
  If Root6^.Right6 = NIL then Root6^.Right6 := Temp
                         else ConectTree6 (Temp,Root6^.Right6);

  Root6^.Weight6 := WtTree6 ( Root6^.Left6  ) +
                    WtTree6 ( Root6^.Right6 );
  ChkRTree6 ( Root6 );
end;


Procedure DelTree6 ( Var Root6 : Pointer6 );
Var
  TempL,TempR : Pointer6;

begin
  If Root6 <> NIL then
     begin
       If DCVSNo < Root6^.Chave6 then DelTree6 ( Root6^.Left6 )
          else If DCVSNo > Root6^.Chave6 then DelTree6 ( Root6^.Right6 )
                  else begin
                         If (Root6^.Left6  <> NIL) and
                            (Root6^.Right6 <> NIL) then
                            begin
                              TempL := Root6^.Left6;
                              TempR := Root6^.Right6;
                              Dispose (Root6);
                              Root6 := TempL;
                              ConectTree6 (TempR,Root6);
                            end
                            else If Root6^.Left6 <> NIL then
                                    begin
                                      TempL := Root6^.Left6;
                                      Dispose (Root6);
                                      Root6 := TempL;
                                    end
                                    else If Root6^.Right6 <> NIL then
                                            begin
                                              TempR := Root6^.Right6;
                                              Dispose (Root6);
                                              Root6 := TempR;
                                            end
                                            else begin
                                                   Dispose (Root6);
                                                   Root6 := NIL;
                                                 end;
                         If Root6 <> NIL then
                            begin
                              Root6^.Weight6 := WtTree6 ( Root6^.Left6  ) +
                                                WtTree6 ( Root6^.Right6 );
                              ChkRTree6 ( Root6 );
                            end;
                       end;
     end;
end;


Procedure LoadTree6 ( Var Root6 : Pointer6 );
begin
  If Root6 = NIL then
     begin
       New ( Root6 );
       Root6^.Chave6   := DCVSNo;
       Root6^.RelAddr6 := DCVSNumber;
       Root6^.Left6    := NIL;
       Root6^.Right6   := NIL;
       Root6^.Weight6  := 2;
     end
     else If DCVSNo <> Root6^.Chave6 then
             begin
               If DCVSNo < Root6^.Chave6 then LoadTree6 ( Root6^.Left6  )
                                         else LoadTree6 ( Root6^.Right6 );
               Root6^.Weight6 := WtTree6 ( Root6^.Left6  ) +
                                 WtTree6 ( Root6^.Right6 );
               ChkRTree6 ( Root6 );
             end;
end;


Procedure SearchTree6 ( Var Root6 : Pointer6 );
begin
  If Root6 = NIL then RC := 'N'
     else If DCVSNo < Root6^.Chave6 then SearchTree6 ( Root6^.Left6 )
             else If DCVSNo > Root6^.Chave6
                     then SearchTree6 ( Root6^.Right6 )
                     else begin
                            RC         := 'S';
                            DCVSNumber := Root6^.RelAddr6;
                          end;
end;


Procedure SearchAnt6 ( Var Root6 : Pointer6 );
begin
  If Root6 <> NIL then
     begin
       If (Root6^.Right6 <> NIL          ) and
          (DCVSNo         > Root6^.Chave6) then SearchAnt6 ( Root6^.Right6 );
       If (RC     = 'N'          ) and
          (DCVSNo > Root6^.Chave6) then
          begin
            RC         := 'S';
            DCVSNumber := Root6^.RelAddr6;
            DCVSNo     := Root6^.Chave6;
          end
          else If RC = 'N' then If Root6^.Left6 <> NIL
                                   then SearchAnt6 ( Root6^.Left6 );
     end;
end;


Procedure SearchPos6 ( Var Root6 : Pointer6 );
begin
  If Root6 <> NIL then
     begin
       If (Root6^.Left6  <> NIL          ) and
          (DCVSNo        <  Root6^.Chave6) then SearchPos6 ( Root6^.Left6 );
       If (RC     = 'N'          ) and
          (DCVSNo < Root6^.Chave6) then
          begin
            RC         := 'S';
            DCVSNumber := Root6^.RelAddr6;
            DCVSNo     := Root6^.Chave6;
          end
          else If RC = 'N' then If Root6^.Right6 <> NIL
                                   then SearchPos6 ( Root6^.Right6 );
     end;
end;


Procedure Dispose6 ( Var Root6 : Pointer6 );
begin
  If Root6 <> NIL then
     begin
       If Root6^.Left6  <> NIL then Dispose6 ( Root6^.Left6  );
       If Root6^.Right6 <> NIL then Dispose6 ( Root6^.Right6 );
       Dispose(Root6);
     end;
end;


Function WtTree7 ( Var Root7 : Pointer7 ) : Integer;
begin
  If Root7 = NIL then WtTree7 := 1
                 else WtTree7 := Root7^.Weight7;
end;


Procedure LftRTree7 ( Var Root7 : Pointer7 );
Var
   Temp : Pointer7;

begin
  Temp           := Root7;
  Root7          := Root7^.Right7;
  Temp^.Right7   := Root7^.Left7;
  Root7^.Left7   := Temp;
  Root7^.Weight7 := Temp^.Weight7;
  Temp^.Weight7  := WtTree7 ( Temp^.Left7 ) + WtTree7 ( Temp^.Right7 );
end;


Procedure RthRTree7 ( Var Root7 : Pointer7 );
Var
   Temp : Pointer7;

begin
  Temp           := Root7;
  Root7          := Root7^.Left7;
  Temp^.Left7    := Root7^.Right7;
  Root7^.Right7  := Temp;
  Root7^.Weight7 := Temp^.Weight7;
  Temp^.Weight7  := WtTree7 ( Temp^.Left7 ) + WtTree7 ( Temp^.Right7 );
end;


Procedure ChkRTree7 ( Var Root7 : Pointer7 );
Var
    Wl,Wr : Integer;

begin
  If Root7 <> NIL then
     begin
       Wl := WtTree7 ( Root7^.Left7  );
       Wr := WtTree7 ( Root7^.Right7 );

       If Wr > Wl then
          begin
            If WtTree7 ( Root7^.Right7^.Right7 ) > Wl then
               begin
                 LftRTree7 ( Root7 );
                 ChkRTree7 ( Root7^.Left7 );
               end
               else If WtTree7 ( Root7^.Right7^.Left7 ) > Wl then
                       begin
                         RthRTree7 ( Root7^.Right7 );
                         LftRTree7 ( Root7 );
                         ChkRTree7 ( Root7^.Left7  );
                         ChkRTree7 ( Root7^.Right7 );
                       end;
          end
          else If Wl > Wr then
                  begin
                    If WtTree7 ( Root7^.Left7^.Left7 ) > Wr then
                       begin
                         RthRTree7 ( Root7 );
                         ChkRTree7 ( Root7^.Right7 );
                       end
                       else If WtTree7 ( Root7^.Left7^.Right7 ) > Wr then
                               begin
                                 LftRTree7 ( Root7^.Left7 );
                                 RthRTree7 ( Root7 );
                                 ChkRTree7 ( Root7^.Left7  );
                                 ChkRTree7 ( Root7^.Right7 );
                               end;
                  end;
     end;
end;


Procedure LoadTree7 ( Var Root7 : Pointer7 );
begin
  If Root7 = NIL then
     begin
       New ( Root7 );
       Root7^.Chave7   := IINo;
       Root7^.RelAddr7 := IINumber;
       Root7^.Left7    := NIL;
       Root7^.Right7   := NIL;
       Root7^.Weight7  := 2;
     end
     else If IINo <> Root7^.Chave7 then
             begin
               If IINo < Root7^.Chave7 then LoadTree7 ( Root7^.Left7  )
                                       else LoadTree7 ( Root7^.Right7 );
               Root7^.Weight7 := WtTree7 ( Root7^.Left7  ) +
                                 WtTree7 ( Root7^.Right7 );
               ChkRTree7 ( Root7 );
             end;
end;


Procedure SearchTree7 ( Var Root7 : Pointer7 );
begin
  If Root7 = NIL then RC := 'N'
     else If IINo < Root7^.Chave7 then SearchTree7 ( Root7^.Left7 )
             else If IINo > Root7^.Chave7
                     then SearchTree7 ( Root7^.Right7 )
                     else begin
                            RC       := 'S';
                            IINumber := Root7^.RelAddr7;
                          end;
end;


Procedure SearchAnt7 ( Var Root7 : Pointer7 );
begin
  If Root7 <> NIL then
     begin
       If (Root7^.Right7 <> NIL          ) and
          (IINo           > Root7^.Chave7) then SearchAnt7 ( Root7^.Right7 );
       If (RC   = 'N'          ) and
          (IINo > Root7^.Chave7) then
          begin
            RC       := 'S';
            IINumber := Root7^.RelAddr7;
            IINo     := Root7^.Chave7;
          end
          else If RC = 'N' then If Root7^.Left7 <> NIL
                                   then SearchAnt7 ( Root7^.Left7 );
     end;
end;


Procedure SearchPos7 ( Var Root7 : Pointer7 );
begin
  If Root7 <> NIL then
     begin
       If (Root7^.Left7  <> NIL          ) and
          (IINo          <  Root7^.Chave7) then SearchPos7 ( Root7^.Left7 );
       If (RC   = 'N'          ) and
          (IINo < Root7^.Chave7) then
          begin
            RC       := 'S';
            IINumber := Root7^.RelAddr7;
            IINo     := Root7^.Chave7;
          end
          else If RC = 'N' then If Root7^.Right7 <> NIL
                                   then SearchPos7 ( Root7^.Right7 );
     end;
end;


Function WtTree8 ( Var Root8 : Pointer8 ) : Integer;
begin
  If Root8 = NIL then WtTree8 := 1
                 else WtTree8 := Root8^.Weight8;
end;


Procedure LftRTree8 ( Var Root8 : Pointer8 );
Var
   Temp : Pointer8;

begin
  Temp           := Root8;
  Root8          := Root8^.Right8;
  Temp^.Right8   := Root8^.Left8;
  Root8^.Left8   := Temp;
  Root8^.Weight8 := Temp^.Weight8;
  Temp^.Weight8  := WtTree8 ( Temp^.Left8 ) + WtTree8 ( Temp^.Right8 );
end;


Procedure RthRTree8 ( Var Root8 : Pointer8 );
Var
   Temp : Pointer8;

begin
  Temp           := Root8;
  Root8          := Root8^.Left8;
  Temp^.Left8    := Root8^.Right8;
  Root8^.Right8  := Temp;
  Root8^.Weight8 := Temp^.Weight8;
  Temp^.Weight8  := WtTree8 ( Temp^.Left8 ) + WtTree8 ( Temp^.Right8 );
end;


Procedure ChkRTree8 ( Var Root8 : Pointer8 );
Var
    Wl,Wr : Integer;
begin
  If Root8 <> NIL then
     begin
       Wl := WtTree8 ( Root8^.Left8  );
       Wr := WtTree8 ( Root8^.Right8 );

       If Wr > Wl then
          begin
            If WtTree8 ( Root8^.Right8^.Right8 ) > Wl then
               begin
                 LftRTree8 ( Root8 );
                 ChkRTree8 ( Root8^.Left8 );
               end
               else If WtTree8 ( Root8^.Right8^.Left8 ) > Wl then
                       begin
                         RthRTree8 ( Root8^.Right8 );
                         LftRTree8 ( Root8 );
                         ChkRTree8 ( Root8^.Left8  );
                         ChkRTree8 ( Root8^.Right8 );
                       end;
          end
          else If Wl > Wr then
                  begin
                    If WtTree8 ( Root8^.Left8^.Left8 ) > Wr then
                       begin
                         RthRTree8 ( Root8 );
                         ChkRTree8 ( Root8^.Right8 );
                       end
                       else If WtTree8 ( Root8^.Left8^.Right8 ) > Wr then
                               begin
                                 LftRTree8 ( Root8^.Left8 );
                                 RthRTree8 ( Root8 );
                                 ChkRTree8 ( Root8^.Left8  );
                                 ChkRTree8 ( Root8^.Right8 );
                               end;
                  end;
     end;
end;


Procedure ConectTree8 ( Var Temp,Root8 : Pointer8);
begin
  If Root8^.Right8 = NIL then Root8^.Right8 := Temp
                         else ConectTree8 (Temp,Root8^.Right8);

  Root8^.Weight8 := WtTree8 ( Root8^.Left8  ) +
                    WtTree8 ( Root8^.Right8 );
  ChkRTree8 ( Root8 );
end;


Procedure DelTree8 ( Var Root8 : Pointer8 );
Var
  TempL,TempR : Pointer8;

begin
  If Root8 <> NIL then
     begin
       If HHNo < Root8^.Chave8 then DelTree8 ( Root8^.Left8 )
          else If HHNo > Root8^.Chave8 then DelTree8 ( Root8^.Right8 )
                  else begin
                         If (Root8^.Left8  <> NIL) and
                            (Root8^.Right8 <> NIL) then
                            begin
                              TempL := Root8^.Left8;
                              TempR := Root8^.Right8;
                              Dispose (Root8);
                              Root8 := TempL;
                              ConectTree8 (TempR,Root8);
                            end
                            else If Root8^.Left8 <> NIL then
                                    begin
                                      TempL := Root8^.Left8;
                                      Dispose (Root8);
                                      Root8 := TempL;
                                    end
                                    else If Root8^.Right8 <> NIL then
                                            begin
                                              TempR := Root8^.Right8;
                                              Dispose (Root8);
                                              Root8 := TempR;
                                            end
                                            else begin
                                                   Dispose (Root8);
                                                   Root8 := NIL;
                                                 end;
                         If Root8 <> NIL then
                            begin
                              Root8^.Weight8 := WtTree8 ( Root8^.Left8  ) +
                                                WtTree8 ( Root8^.Right8 );
                              ChkRTree8 ( Root8 );
                            end;
                       end;
     end;
end;


Procedure LoadTree8 ( Var Root8 : Pointer8 );
begin
  If Root8 = NIL then
     begin
       New ( Root8 );
       Root8^.Chave8   := HHNo;
       Root8^.RelAddr8 := HHNumber;
       Root8^.Left8    := NIL;
       Root8^.Right8   := NIL;
       Root8^.Weight8  := 2;
     end
     else If HHNo <> Root8^.Chave8 then
             begin
               If HHNo < Root8^.Chave8 then LoadTree8 ( Root8^.Left8  )
                                       else LoadTree8 ( Root8^.Right8 );
               Root8^.Weight8 := WtTree8 ( Root8^.Left8  ) +
                                 WtTree8 ( Root8^.Right8 );
               ChkRTree8 ( Root8 );
             end;
end;


Procedure SearchTree8 ( Var Root8 : Pointer8 );
begin
  If Root8 = NIL then RC := 'N'
     else If HHNo < Root8^.Chave8 then SearchTree8 ( Root8^.Left8 )
             else If HHNo > Root8^.Chave8
                     then SearchTree8 ( Root8^.Right8 )
                     else begin
                            RC       := 'S';
                            HHNumber := Root8^.RelAddr8;
                          end;
end;


Procedure SearchAnt8 ( Var Root8 : Pointer8 );
begin
  If Root8 <> NIL then
     begin
       If (Root8^.Right8 <> NIL          ) and
          (HHNo           > Root8^.Chave8) then SearchAnt8 ( Root8^.Right8 );
       If (RC   = 'N'          ) and
          (HHNo > Root8^.Chave8) then
          begin
            RC       := 'S';
            HHNumber := Root8^.RelAddr8;
            HHNo     := Root8^.Chave8;
          end
          else If RC = 'N' then If Root8^.Left8 <> NIL
                                   then SearchAnt8 ( Root8^.Left8 );
     end;
end;


Procedure SearchPos8 ( Var Root8 : Pointer8 );
begin
  If Root8 <> NIL then
     begin
       If (Root8^.Left8  <> NIL          ) and
          (HHNo          <  Root8^.Chave8) then SearchPos8 ( Root8^.Left8 );
       If (RC   = 'N'          ) and
          (HHNo < Root8^.Chave8) then
          begin
            RC       := 'S';
            HHNumber := Root8^.RelAddr8;
            HHNo     := Root8^.Chave8;
          end
          else If RC = 'N' then If Root8^.Right8 <> NIL
                                   then SearchPos8 ( Root8^.Right8 );
     end;
end;
