PROGRAM PLOGVE9X;

Uses Crt,Dos;

Type
  Str2       = String[2];
  Str3       = String[3];
  Str4       = String[4];
  Str5       = String[5];
  Str6       = String[6];
  Str8       = String[8];
  Str9       = String[9];
  Str10      = String[10];
  Str13      = String[13];
  Str14      = String[14];
  Str15      = String[15];
  Str17      = String[17];
  Str18      = String[18];
  Str19      = String[19];
  Str20      = String[20];
  Str21      = String[21];
  Str22      = String[22];
  Str23      = String[23];
  Str24      = String[24];
  Str25      = String[25];
  Str30      = String[30];
  Str31      = String[31];
  Str34      = String[34];
  Str35      = String[35];
  Str36      = String[36];
  Str38      = String[38];
  Str39      = String[39];
  Str40      = String[40];
  Str44      = String[44];
  Str45      = String[45];
  Str49      = String[49];
  Str50      = String[50];
  Str80      = String[80];
  Str132     = String[132];
  AnyStr     = String[255];

{-----------------------------------------------------------------------}

{$I Owner.inc   }
{$I Plogfile.inc}

  Pointer5  = ^STree5;

  STree5    = RECORD
		Chave5       : String[8];
                RelAddr5     : Integer;
                Left5,Right5 : Pointer5;
                Weight5      : Integer;
              END;

  PointerY = ^STreeY;

  STreeY   = RECORD
		ChaveY         : Str3;
                LeftY,RightY   : PointerY;
                WeightY        : Integer;
                Origem         : Char;
                AcMensalV      : Real;
                AcMensalH      : Integer;
                AcMensalM      : Integer;
                AcAnualV       : Real;
                AcAnualH       : Integer;
                AcAnualM       : Integer;
                QtdResc        : String[5];
                Parcelas       : Integer;
                BaseUsr        : Char;
                PerctUsr       : Real;
              END;



Var
   OMember        : Owner;
   OFile          : FILE OF Owner;
   CCMember       : TabCmpy;
   CCFile         : FILE OF TabCmpy;
   EEMember       : Empregado;
   EEFile         : FILE OF Empregado;
   MMMember       : Movimento;
   MMFile         : FILE OF Movimento;
   Ind2Member     : Indice2;
   Ind2File       : FILE OF Indice2;

   Root5          : Pointer5;
   RootY          : PointerY;
   YAddress       : PointerY;

   EENumber,XR,Limite,
   M,I,E,R,C,L,A,Ii,Fn   : Integer;
   TC,RC,RW              : Char;

   Dep,
   XAno,XAnoI,
   XAnoF,XMes            : String[2];
   YYNo                  : Str3;
   DataX,DataR           : String[6];
   XDr,
   EENo                  : String[10];
   XDir                  : String[40];


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


Procedure ConectTree5 ( Var Temp,Root5 : Pointer5);
begin
  If Root5^.Right5 = NIL then Root5^.Right5 := Temp
                         else ConectTree5 (Temp,Root5^.Right5);

  Root5^.Weight5 := WtTree5 ( Root5^.Left5  ) +
                    WtTree5 ( Root5^.Right5 );
  ChkRTree5 ( Root5 );
end;


Procedure DelTree5 ( Var Root5 : Pointer5 );
Var
  TempL,TempR : Pointer5;

begin
  If Root5 <> NIL then
     begin
       If EENo < Root5^.Chave5 then DelTree5 ( Root5^.Left5 )
          else If EENo > Root5^.Chave5 then DelTree5 ( Root5^.Right5 )
                  else begin
                         If (Root5^.Left5  <> NIL) and
                            (Root5^.Right5 <> NIL) then
                            begin
                              TempL := Root5^.Left5;
                              TempR := Root5^.Right5;
                              Dispose (Root5);
                              Root5 := TempL;
                              ConectTree5 (TempR,Root5);
                            end
                            else If Root5^.Left5 <> NIL then
                                    begin
                                      TempL := Root5^.Left5;
                                      Dispose (Root5);
                                      Root5 := TempL;
                                    end
                                    else If Root5^.Right5 <> NIL then
                                            begin
                                              TempR := Root5^.Right5;
                                              Dispose (Root5);
                                              Root5 := TempR;
                                            end
                                            else begin
                                                   Dispose (Root5);
                                                   Root5 := NIL;
                                                 end;
                         If Root5 <> NIL then
                            begin
                              Root5^.Weight5 := WtTree5 ( Root5^.Left5  ) +
                                                WtTree5 ( Root5^.Right5 );
                              ChkRTree5 ( Root5 );
                            end;
                       end;
     end;
end;


Procedure LoadTree5 ( Var Root5 : Pointer5 );
begin
  If Root5 = NIL then
     begin
       New ( Root5 );
       Root5^.Chave5    := EENo;
       Root5^.RelAddr5  := EENumber;
       Root5^.Left5     := NIL;
       Root5^.Right5    := NIL;
       Root5^.Weight5   := 2;
     end
     else If EENo <> Root5^.Chave5 then
             begin
               If EENo < Root5^.Chave5 then LoadTree5 ( Root5^.Left5  )
                                       else LoadTree5 ( Root5^.Right5 );
               Root5^.Weight5 := WtTree5 ( Root5^.Left5  ) +
                                 WtTree5 ( Root5^.Right5 );
               ChkRTree5 ( Root5 );
             end;
end;


Procedure SearchTree5 ( Var Root5 : Pointer5 );
begin
  If Root5 = NIL then RC := 'N'
     else If EENo < Root5^.Chave5
             then SearchTree5 ( Root5^.Left5 )
             else If EENo > Root5^.Chave5
                     then SearchTree5 ( Root5^.Right5 )
                     else begin
                            RC       := 'S';
                            EENumber := Root5^.RelAddr5;
                          end;
end;


Procedure SearchAnt5 ( Var Root5 : Pointer5 );
begin
  If Root5 <> NIL then
     begin
       If (Root5^.Right5 <> NIL          ) and
          (EENo           > Root5^.Chave5) then SearchAnt5 ( Root5^.Right5 );
       If (RC   = 'N'          ) and
          (EENo > Root5^.Chave5) then
          begin
            RC       := 'S';
            EENumber := Root5^.RelAddr5;
            EENo     := Root5^.Chave5;
          end
          else If RC = 'N' then If Root5^.Left5  <> NIL
                                   then SearchAnt5 ( Root5^.Left5  );
     end;
end;


Procedure SearchPos5 ( Var Root5 : Pointer5 );
begin
  If Root5 <> NIL then
     begin
       If (Root5^.Left5  <> NIL          ) and
          (EENo          <  Root5^.Chave5) then SearchPos5 ( Root5^.Left5  );
       If (RC   = 'N'          ) and
          (EENo < Root5^.Chave5) then
          begin
            RC       := 'S';
            EENumber := Root5^.RelAddr5;
            EENo     := Root5^.Chave5;
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



Procedure LoadIndex2;
begin
  If FileSize(Ind2File) > 0 then
     begin
       I := -1;
       Repeat
         I := I + 1;
         Seek ( Ind2File, I);
         Read ( Ind2File, Ind2Member);
         XR := 0;
         Repeat
           XR := XR + 1;
           If Ind2Member.ChaveX[XR] <> '' then
              begin
                EENo     := Ind2Member.ChaveX[XR];
                EENumber := Ind2Member.RelAddrX[XR];
                LoadTree5 ( Root5 );
              end;
         Until XR = 42;
       Until (I + 1) = FileSize(Ind2File);
     end;
end;

Function WtTreeY ( Var RootY : PointerY ) : Integer;
begin
  If RootY = NIL then WtTreeY := 1
                 else WtTreeY := RootY^.WeightY;
end;


Procedure LftRTreeY ( Var RootY : PointerY );
Var
   Temp : PointerY;

begin
  Temp           := RootY;
  RootY          := RootY^.RightY;
  Temp^.RightY   := RootY^.LeftY;
  RootY^.LeftY   := Temp;
  RootY^.WeightY := Temp^.WeightY;
  Temp^.WeightY  := WtTreeY ( Temp^.LeftY ) + WtTreeY ( Temp^.RightY );
end;


Procedure RthRTreeY ( Var RootY : PointerY );
Var
   Temp : PointerY;

begin
  Temp           := RootY;
  RootY          := RootY^.LeftY;
  Temp^.LeftY    := RootY^.RightY;
  RootY^.RightY  := Temp;
  RootY^.WeightY := Temp^.WeightY;
  Temp^.WeightY  := WtTreeY ( Temp^.LeftY ) + WtTreeY ( Temp^.RightY );
end;


Procedure ChkRTreeY ( Var RootY : PointerY );
Var
    Wl,Wr : Integer;

begin
  If RootY <> NIL then
     begin
       Wl := WtTreeY ( RootY^.LeftY  );
       Wr := WtTreeY ( RootY^.RightY );

       If Wr > Wl then
          begin
            If WtTreeY ( RootY^.RightY^.RightY ) > Wl then
               begin
                 LftRTreeY ( RootY );
                 ChkRTreeY ( RootY^.LeftY );
               end
               else If WtTreeY ( RootY^.RightY^.LeftY ) > Wl then
                       begin
                         RthRTreeY ( RootY^.RightY );
                         LftRTreeY ( RootY );
                         ChkRTreeY ( RootY^.LeftY  );
                         ChkRTreeY ( RootY^.RightY );
                       end;
          end
          else If Wl > Wr then
                  begin
                    If WtTreeY ( RootY^.LeftY^.LeftY ) > Wr then
                       begin
                         RthRTreeY ( RootY );
                         ChkRTreeY ( RootY^.RightY );
                       end
                       else If WtTreeY ( RootY^.LeftY^.RightY ) > Wr then
                               begin
                                 LftRTreeY ( RootY^.LeftY );
                                 RthRTreeY ( RootY );
                                 ChkRTreeY ( RootY^.LeftY  );
                                 ChkRTreeY ( RootY^.RightY );
                               end;
                  end;
     end;
end;


Procedure ConectTreeY ( Var Temp,RootY : PointerY);
begin
  If RootY^.RightY = NIL then RootY^.RightY := Temp
                         else ConectTreeY (Temp,RootY^.RightY);

  RootY^.WeightY := WtTreeY ( RootY^.LeftY  ) +
                    WtTreeY ( RootY^.RightY );
  ChkRTreeY ( RootY );
end;


Procedure DelTreeY ( Var RootY : PointerY );
Var
  TempL,TempR : PointerY;

begin
  If RootY <> NIL then
     begin
       If YYNo < RootY^.ChaveY then DelTreeY ( RootY^.LeftY )
          else If YYNo > RootY^.ChaveY then DelTreeY ( RootY^.RightY )
                  else begin
                         If (RootY^.LeftY  <> NIL) and
                            (RootY^.RightY <> NIL) then
                            begin
                              TempL := RootY^.LeftY;
                              TempR := RootY^.RightY;
                              Dispose (RootY);
                              RootY := TempL;
                              ConectTreeY (TempR,RootY);
                            end
                            else If RootY^.LeftY <> NIL then
                                    begin
                                      TempL := RootY^.LeftY;
                                      Dispose (RootY);
                                      RootY := TempL;
                                    end
                                    else If RootY^.RightY <> NIL then
                                            begin
                                              TempR := RootY^.RightY;
                                              Dispose (RootY);
                                              RootY := TempR;
                                            end
                                            else begin
                                                   Dispose (RootY);
                                                   RootY := NIL;
                                                 end;
                         If RootY <> NIL then
                            begin
                              RootY^.WeightY := WtTreeY ( RootY^.LeftY  ) +
                                                WtTreeY ( RootY^.RightY );
                              ChkRTreeY ( RootY );
                            end;
                       end;
     end;
end;


Procedure LoadTreeY ( Var RootY : PointerY );
begin
  If RootY = NIL then
     begin
       New ( RootY );
       RootY^.ChaveY    := YYNo;
       RootY^.LeftY     := NIL;
       RootY^.RightY    := NIL;
       RootY^.WeightY   := 2;
       RootY^.Origem    := ' ';
       RootY^.AcMensalV := 0;
       RootY^.AcMensalH := 0;
       RootY^.AcMensalM := 0;
       RootY^.AcAnualV  := 0;
       RootY^.AcAnualH  := 0;
       RootY^.AcAnualM  := 0;
       RootY^.QtdResc   := '';
       RootY^.Parcelas  := 0;
       RootY^.BaseUsr   := ' ';
       RootY^.PerctUsr  := 0;
       YAddress         := RootY;
     end
     else If YYNo < RootY^.ChaveY then LoadTreeY ( RootY^.LeftY  )
                                  else LoadTreeY ( RootY^.RightY );
end;


Procedure SearchTreeY ( Var RootY : PointerY );
begin
  If RootY = NIL then RC := 'N'
     else If YYNo < RootY^.ChaveY
             then SearchTreeY ( RootY^.LeftY )
             else If YYNo > RootY^.ChaveY
                     then SearchTreeY ( RootY^.RightY )
                     else begin
                            RC       := 'S';
                            YAddress := RootY;
                          end;
end;


Procedure SearchAntY ( Var RootY : PointerY );
begin
  If RootY <> NIL then
     begin
       If (RootY^.RightY <> NIL          ) and
          (YYNo           > RootY^.ChaveY) then SearchAntY ( RootY^.RightY );
       If (RC   = 'N'          ) and
          (YYNo > RootY^.ChaveY) then
          begin
            RC       := 'S';
            YAddress := RootY;
            YYNo     := RootY^.ChaveY;
          end
          else If RC = 'N' then If RootY^.LeftY  <> NIL
                                   then SearchAntY ( RootY^.LeftY  );
     end;
end;


Procedure SearchPosY ( Var RootY : PointerY );
begin
  If RootY <> NIL then
     begin
       If (RootY^.LeftY  <> NIL          ) and
          (YYNo          <  RootY^.ChaveY) then SearchPosY ( RootY^.LeftY );
       If (RC   = 'N'          ) and
          (YYNo < RootY^.ChaveY) then
          begin
            RC       := 'S';
            YAddress := RootY;
            YYNo     := RootY^.ChaveY;
          end
          else If RC = 'N' then If RootY^.RightY <> NIL
                                   then SearchPosY ( RootY^.RightY );
     end;
end;


Procedure DisposeY ( Var RootY : PointerY );
begin
  If RootY <> NIL then
     begin
       If RootY^.LeftY  <> NIL then DisposeY ( RootY^.LeftY  );
       If RootY^.RightY <> NIL then DisposeY ( RootY^.RightY );
       Dispose(RootY);
     end;
end;

Procedure ReadWrite (Fl,Op,Ms : Char;
                     No       : Integer);
Var
  Arq        : Str15;
begin
   RW := 'N';
   {$I-}
   Seek ( MMFile, No );
   If Op = 'R' then Read  ( MMFile, MMMember )
               else Write ( MMFile, MMMember );
   Arq := 'MOVIMENTO';
   {$I+}
   If IOResult = 0 then RW := 'S'
      else If Ms = 'S' then
              begin
                ClrScr;
                Case Op of
                     'R' : Write('Erro lendo arquivo: ',Arq);
                     'W' : Write('Erro gravando arquivo: ',Arq);
                end;
                GotoXY(52,13); Write('Enter');
                Repeat
                  TC := ReadKey;
                Until TC = #13;
                ClrScr;
                Halt;
              end;
end;



Procedure LoadMVDsk(X : Char);
Var
  I,S    : Integer;
  Sq     : String[1];
begin
  I := 0;
  S := 0;
  Repeat
    S := S + 1;
    If EEMember.Movimento[S] <> Limite then
       begin
         ReadWrite(X,'R','N',EEMember.Movimento[S]);
         If RW = 'S' then
            For I := 1 to 10
            do If MMMember.Conta[I] <> '' then
                  begin
                    YYNo := MMMember.Conta[I];
                    LoadTreeY ( RootY );
                    YAddress^.Origem    := MMMember.Origem[I];
                    YAddress^.AcMensalV := MMMember.AcMensalV[I];
                    YAddress^.AcMensalH := MMMember.AcMensalH[I];
                    YAddress^.AcMensalM := MMMember.AcMensalM[I];
                    YAddress^.AcAnualV  := MMMember.AcAnualV[I];
                    YAddress^.AcAnualH  := MMMember.AcAnualH[I];
                    YAddress^.AcAnualM  := MMMember.AcAnualM[I];
                    YAddress^.QtdResc   := MMMember.QtdResc[I];
                    YAddress^.Parcelas  := MMMember.Parcelas[I];
                    YAddress^.BaseUsr   := MMMember.BaseUsr[I];
                    YAddress^.PerctUsr  := MMMember.PerctUsr[I];
                  end;
       end
       else RW := 'N';
  Until (RW = 'N') or (S = 9);
end;


Procedure LiberaMVDsk;
begin
  If RootY <> NIL then DisposeY ( RootY );
  RootY := NIL;
end;


Procedure LimpaMVDsk;
begin
  YYNo := '';
  Repeat
    RC := 'N';
    SearchPosY ( RootY );
    If RC = 'S' then If (YAddress^.Origem    = 'S') and
                        (YAddress^.AcMensalV = 0  ) and
                        (YAddress^.AcMensalH = 0  ) and
                        (YAddress^.AcMensalM = 0  ) and
                        (YAddress^.AcAnualV  = 0  ) and
                        (YAddress^.AcAnualH  = 0  ) and
                        (YAddress^.AcAnualM  = 0  ) then DelTreeY ( RootY );
  Until RC = 'N';
end;


Procedure ZeraConta;
Var
  I  : Integer;
begin
  For I := 1 to 10 do
  begin
    MMMember.Conta[I]       := '';
    MMMember.Origem[I]      := ' ';
    MMMember.AcMensalV[I]   := 0;
    MMMember.AcMensalH[I]   := 0;
    MMMember.AcMensalM[I]   := 0;
    MMMember.AcAnualV[I]    := 0;
    MMMember.AcAnualH[I]    := 0;
    MMMember.AcAnualM[I]    := 0;
    MMMember.QtdResc[I]     := '';
    MMMember.Parcelas[I]    := 0;
    MMMember.BaseUsr[I]     := ' ';
    MMMember.PerctUsr[I]    := 0;
  end;
end;


Procedure UnLoadMVDsk;
Var
  I,S    : Integer;
  Sq     : String[1];
begin
  If RootY <> NIL then
     begin
       S    := 0;
       YYNo := '';
       Repeat
         ZeraConta;
         I := 0;
         Repeat
           RC := 'N';
           SearchPosY ( RootY );
           If RC = 'S' then
              begin
                If (YYNo                = '030') or
                   (YAddress^.Origem    = 'U'  ) or
                   (YAddress^.AcMensalV > 0    ) or
                   (YAddress^.AcMensalH > 0    ) or
                   (YAddress^.AcMensalM > 0    ) or
                   (YAddress^.AcAnualV  > 0    ) or
                   (YAddress^.AcAnualH  > 0    ) or
                   (YAddress^.AcAnualM  > 0    ) then
                   begin
                     I := I + 1;
                     MMMember.Conta[I]     := YYNo;
                     MMMember.Origem[I]    := YAddress^.Origem;
                     MMMember.AcMensalV[I] := YAddress^.AcMensalV;
                     MMMember.AcMensalH[I] := YAddress^.AcMensalH;
                     MMMember.AcMensalM[I] := YAddress^.AcMensalM;
                     MMMember.AcAnualV[I]  := YAddress^.AcAnualV;
                     MMMember.AcAnualH[I]  := YAddress^.AcAnualH;
                     MMMember.AcAnualM[I]  := YAddress^.AcAnualM;
                     MMMember.QtdResc[I]   := YAddress^.QtdResc;
                     MMMember.Parcelas[I]  := YAddress^.Parcelas;
                     MMMember.BaseUsr[I]   := YAddress^.BaseUsr;
                     MMMember.PerctUsr[I]  := YAddress^.PerctUsr;
                   end;
              end;
         Until (I = 10) or (RC = 'N');
         S := S + 1;
         MMMember.Empregado := EENo;
         If EEMember.Movimento[S] = Limite then
            begin
              If I > 0 then
                 begin
                   EEMember.Movimento[S] := FileSize(MMFile);
                   ReadWrite(#11,'W','N',EEMember.Movimento[S]);
                 end;
            end
            else If I = 0 then
                    begin
                      ZeraConta;
                      MMMember.Empregado := '';
                      ReadWrite(#11,'W','N',EEMember.Movimento[S]);
                      EEMember.Movimento[S] := Limite;
                    end
                    else ReadWrite(#11,'W','N',EEMember.Movimento[S]);
       Until RC = 'N';
       If S < 9 then For I := S+1 to 9 do
                     begin
                       If EEMember.Movimento[I] <> Limite then
                          begin
                            ReadWrite(#11,'R','N',EEMember.Movimento[I]);
                            MMMember.Empregado := '';
                            ReadWrite(#11,'W','N',EEMember.Movimento[I]);
                            EEMember.Movimento[I] := Limite;
                          end;
                     end;
       ReadWrite(#08,'W','N',EENumber);
       LiberaMVDsk;
     end;
end;

Procedure VerificaConta;
var
  Anterior,
  NovaC        : Str3;

  XOrigem      : Char;
  XAcMensalV   : Real;
  XAcMensalH   : Integer;
  XAcMensalM   : Integer;
  XAcAnualV    : Real;
  XAcAnualH    : Integer;
  XAcAnualM    : Integer;
  XQtdResc     : String[5];
  XParcelas    : Integer;
  XBaseUsr     : Char;
  XPerctUsr    : Real;
begin
  Anterior := YYNo;
  NovaC    := '';
  If YYNo = 'R19' then NovaC := 'R46'
     else If YYNo = 'R20' then NovaC := 'R47'
             else If YYNo = 'R21' then NovaC := 'R48'
                     else If YYNo = 'R22' then NovaC := 'R49'
                             else If YYNo = 'R53' then NovaC := 'R52'
                                     else If YYNo = 'R59' then NovaC := 'R69'
                                             else If YYNo = 'R60' then NovaC := 'R70'
                                                     else If YYNo = 'R62' then NovaC := 'R72';
  If NovaC <> '' then
     begin
       XOrigem    := YAddress^.Origem;
       XAcMensalV := YAddress^.AcMensalV;
       XAcMensalH := YAddress^.AcMensalH;
       XAcMensalM := YAddress^.AcMensalM;
       XAcAnualV  := YAddress^.AcAnualV;
       XAcAnualH  := YAddress^.AcAnualH;
       XAcAnualM  := YAddress^.AcAnualM;
       XQtdResc   := YAddress^.QtdResc;
       XParcelas  := YAddress^.Parcelas;
       XBaseUsr   := YAddress^.BaseUsr;
       XPerctUsr  := YAddress^.PerctUsr;

       YAddress^.Origem    := 'S';
       YAddress^.AcMensalV := 0;
       YAddress^.AcMensalH := 0;
       YAddress^.AcMensalM := 0;
       YAddress^.AcAnualV  := 0;
       YAddress^.AcAnualH  := 0;
       YAddress^.AcAnualM  := 0;
       YAddress^.QtdResc   := '';
       YAddress^.Parcelas  := 0;
       YAddress^.BaseUsr   := ' ';
       YAddress^.PerctUsr  := 0;

       YYNo := NovaC;
       YAddress^.Origem    := XOrigem;
       YAddress^.AcMensalV := XAcMensalV;
       YAddress^.AcMensalH := XAcMensalH;
       YAddress^.AcMensalM := XAcMensalM;
       YAddress^.AcAnualV  := XAcAnualV;
       YAddress^.AcAnualH  := XAcAnualH;
       YAddress^.AcAnualM  := XAcAnualM;
       YAddress^.QtdResc   := XQtdResc;
       YAddress^.Parcelas  := XParcelas;
       YAddress^.BaseUsr   := XBaseUsr;
       YAddress^.PerctUsr  := XPerctUsr;
       LoadTreeY ( RootY );

       YYNo := Anterior;
       RC := 'S';
     end;
end;


begin
  Root5 := NIL;
  RootY := NIL;

  Limite := 30000;

  XDr   := '';
  XDr   := ParamStr(1);
  XAnoI := '';
  XAnoI := ParamStr(2);
  XAnoF := '';
  XAnoF := ParamStr(3);
  DataX := '';
  DataX := ParamStr(4);

  If (XDr   <> '') and
     (XAnoI <> '') and
     (XAnoF <> '') and
     (DataX <> '') then
     begin
       ClrScr;
       Assign (OFile, (XDr + '\PLOGDATA\PLXOWNER.DAT'));
       {$I-}
       Reset   ( OFile );
       {$I+}
       If IOResult = 0 then
          begin
            Seek ( OFile, 0);
            Read ( OFile, OMember);
            If OMember.Versao = '9.403/96'then
               begin
                 Assign (CCFile, (XDr + '\PLOGDATA\PLOGCMPY.DAT'));
                 {$I-}
                 Reset ( CCFile );
                 {$I+}
                 If IOResult = 0 then
                    begin
                      C := -1;
                      Repeat
                        C := C + 1;
                        Seek ( CCFile, C        );
                        Read ( CCFile, CCMember );
                        XDir := XDr + '\PLOGDATA\PLOGM' + CCMember.Chave;
                        Writeln('*** Convertendo Cia ',CCMember.Chave);

                        Val(XAnoI,Ii,E);
                        Val(XAnoF,Fn,E);
                        For A := Ii to Fn do
                        begin
                          Str(A,XAno);
                          If A < 10 then XAno := '0' + XAno;
                          For M := 1 to 12 do
                          begin
                            Str(M,XMes);
                            If M < 10 then XMes := '0' + XMes;
                            Assign (EEFile, (XDir + '\PLOGEX' + XAno + '.M' + XMes));
                            {$I-}
                            Reset   ( EEFile );
                            {$I+}
                            If IOResult = 0 then
                               begin
                                 Writeln('Convertendo mes ',XMes);
                                 Assign ( Ind2File, (XDir + '\PLOGIX' + XAno + '.I' + XMes ));
                                 {$I-}
                                 Reset ( Ind2File );
                                 {$I+}
                                 If IOResult = 0 then LoadIndex2;
                                 Close  ( Ind2File );

                                 Assign (MMFile, (XDir + '\PLOGMX' + XAno + '.M' + XMes));
                                 {$I-}
                                 Reset   ( MMFile );
                                 {$I+}
                                 If IOResult = 0 then
                                    begin

                                      EENo := '';
                                      Repeat
                                        RC := 'N';
                                        SearchPos5 ( Root5 );
                                        If RC = 'S' then
                                           begin
                                             Seek ( EEFile, EENumber );
                                             Read ( EEFile, EEMember );
                                             If EEMember.Status in ['D','J','N','P'] then
                                                begin
                                                  DataR := EEMember.AAResc + EEMember.MMResc + EEMember.DDResc;
                                                  If DataR < DataX then
                                                     begin
                                                       Writeln(EEMember.Nome,' ',DataR,' ',DataX);
                                                       LoadMVDsk(#11);
                                                       YYNo := '';
                                                       Repeat
                                                         RC := 'N';
                                                         SearchPosY ( RootY );
                                                         If (RC = 'S') and (YYNo[1] = 'R') then VerificaConta;
                                                       Until RC = 'N';
                                                       UnloadMVDsk;
                                                       RC := 'S';
                                                     end;
                                                end;
                                           end;
                                      Until RC = 'N';
                                      Close ( MMFile );
                                    end;
                                 Close (EEFile);
                                 Dispose5 ( Root5 );
                                 Root5 := NIL;
                               end;
                          end;
                        end;
                      Until (C + 1) = FileSize(CCFile);
                      Close ( CCFile );
                    end;
               end
               else Writeln('A versao esta incorreta, nao posso executar');
          end
          else Writeln('Nao achei o OWNER FILE');
     end
     else Writeln('PlogVe9X, Faltam parametros (PlogVE9X C: AAi AAf AAMMDD)');
  Halt;
end.