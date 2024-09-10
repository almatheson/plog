{$O+,F+}
Unit PlogReor;

Interface

Uses Crt,Dos,PlogGlbs,PlogBasP,PlogTree,PlogFunc;

   Procedure Reorganiza;
   Procedure ReorganizaM;
   Procedure Abertura;
   Procedure ExcluiAno;

Implementation

Procedure Cabecalho;
begin
  Color(Bfn,Btx);
  GotoXY(3,10); Write(' Entidade           Lidos    Excl.   Reorg. ');
  Color(Tfn,Ttx);
end;


Procedure Reorganiza;
begin
  Cabecalho;
  {$I-}
  ChDir ( XDrive );
  {$I+}
  If IOResult =  0 then
     begin
       CmpyAC := CmpyNo;
       CmpyAN := CmpyNumber;
       Close ( CmpyFile   );
{       Close ( BlkStaFile ); }
       Close ( SSFile );
       Close ( DDFile );
       Close ( BBFile );
       Close ( EEFile );
       Close ( HHFile );
       Close ( MMFile );
       Close ( ENFile );
       Close ( TTFile );
       D2     := 'S';
       D3     := 'S';
       RootB  := NIL;
       Root0  := NIL;
       Root1  := NIL;
       Root2  := NIL;
       Root3  := NIL;
       Root4  := NIL;
       Root5  := NIL;
       Root6  := NIL;
       Root7  := NIL;
       Root8  := NIL;
       Root10 := NIL;
       RootY  := NIL;
       Release(HeapOrg);
       OpMn := 'N';
       ShowHeap;
       Color(Tfn,Ttx);
       If FileSize(CCFile) > 0 then
          begin
            GotoXY(4,12); Write('Proventos/Descontos');
            I := -1;
            R := 0;
            D := 0;
            Repeat
              I := I + 1;
              GotoXY(24,12); Write((I + 1):4);
              ReadWrite(#04,'R','N',I);
              If CCMember.Status <> 'C' then
                 begin
                   CCNo := CCMember.Conta;
                   SearchTree1 ( Root1 );
                   If RC = 'N' then
                      begin
                        R := R + 1;
                        GotoXY(41,12); Write(R:4);
                        CCNumber := I;
                        LoadTree1 ( Root1 );
                        ShowHeap;
                        Color(Tfn,Ttx);
                      end;
                 end
                 else begin
                        D := D + 1;
                        GotoXY(32,12); Write(D:4);
                      end;
            Until (I + 1) = FileSize(CCFile);
          end;
       Close ( CCFile  );
       Reset ( SSFile  );
       If FileSize(SSFile) > 0 then
          begin
            GotoXY(4,13); Write('Sindicatos       ');
            I := -1;
            R := 0;
            D := 0;
            Repeat
              I := I + 1;
              GotoXY(24,13); Write((I + 1):4);
              ReadWrite(#07,'R','N',I);
              If SSMember.Status <> 'C' then
                 begin
                   SSNo := SSMember.Codigo;
                   SearchTree2 ( Root2 );
                   If RC = 'N' then
                      begin
                        R := R + 1;
                        GotoXY(41,13); Write(R:4);
                        SSNumber := I;
                        LoadTree2 ( Root2 );
                        ShowHeap;
                        Color(Tfn,Ttx);
                      end;
                 end
                 else begin
                        D := D + 1;
                        GotoXY(32,13); Write(D:4);
                      end;
            Until (I + 1) = FileSize(SSFile);
          end;
       Close ( SSFile );
       {$I-}
       ChDir ( XPath );
       {$I+}
       If IOResult =  0 then
          begin
            Reset ( DDFile );
            If FileSize(DDFile) > 0 then
               begin
                 Close  ( DDFile );
                 Assign ( WorkFile3, (XPath + '\' + FileDD + '.WRK' ));
                 {$I-}
                 Reset ( WorkFile3 );
                 {$I+}
                 If IOResult = 0 then
                    begin
                      Close ( WorkFile3 );
                      Erase ( WorkFile3 );
                    end;
                 Assign ( WorkFile3, (XPath + '\' + FileDD + '.DAT'));
                 Rename ( WorkFile3, (XPath + '\' + FileDD + '.WRK'));
                 {$I-}
                 Reset   ( WorkFile3 );
                 {$I+}
                 If IOResult = 0 then
                    begin
                      Assign ( DDFile, (XPath + '\' + FileDD + '.DAT'));
                      {$I-}
                      Reset ( DDFile );
                      {$I+}
                      If IOResult <> 0 then
                         begin
                           ReWrite ( DDFile );
                           Reset   ( DDFile );
                         end;
                      GotoXY(4,14); Write('Departamentos    ');
                      I := -1;
                      R := 0;
                      D := 0;
                      CMstMember.NDepto := 0;
                      Repeat
                        I := I + 1;
                        GotoXY(24,14); Write((I + 1):4);
                        Seek ( WorkFile3, I        );
                        Read ( WorkFile3, DDMember );
                        If DDMember.Status <> 'C' then
                           begin
                             DDNo := DDMember.Codigo;
                             SearchTree3 ( Root3 );
                             If RC = 'N' then
                                begin
                                  R := FileSize(DDFile);
                                  GotoXY(41,14); Write((R + 1):4);
                                  DDNumber := R;
                                  LoadTree3 ( Root3 );
                                  ReadWrite(#05,'W','N',R);
                                  CMstMember.NDepto := CMstMember.NDepto + 1;
                                  ShowHeap;
                                  Color(Tfn,Ttx);
                                end;
                           end
                           else begin
                                  D := D + 1;
                                  GotoXY(32,14); Write(D:4);
                                end;
                      Until (I + 1) = FileSize(WorkFile3);
                      Close ( WorkFile3 );
                      Erase ( WorkFile3 );
                    end;
               end
               else CMstMember.NDepto := 0;
            Close ( DDFile );
            Reset ( BBFile );
            If FileSize(BBFile) > 0 then
               begin
                 Close  ( BBFile );
                 Assign ( WorkFile6, (XPath + '\' + FileBB + '.WRK' ));
                 {$I-}
                 Reset ( WorkFile6 );
                 {$I+}
                 If IOResult = 0 then
                    begin
                      Close ( WorkFile6 );
                      Erase ( WorkFile6 );
                    end;
                 Assign ( WorkFile6, (XPath + '\' + FileBB + '.DAT'));
                 Rename ( WorkFile6, (XPath + '\' + FileBB + '.WRK'));
                 {$I-}
                 Reset   ( WorkFile6 );
                 {$I+}
                 If IOResult = 0 then
                    begin
                      Assign(BBFile,(XPath + '\' + FileBB + '.DAT'));
                      {$I-}
                      Reset ( BBFile );
                      {$I+}
                      If IOResult <> 0 then
                         begin
                           ReWrite ( BBFile );
                           Reset   ( BBFile );
                         end;
                      GotoXY(4,15); Write('Bancos         ');
                      I := -1;
                      R := 0;
                      D := 0;
                      CMstMember.NBancos := 0;
                      Repeat
                        I := I + 1;
                        GotoXY(24,15); Write((I + 1):4);
                        Seek ( WorkFile6, I        );
                        Read ( WorkFile6, BBMember );
                        If BBMember.Status <> 'C' then
                           begin
                             BBNo := BBMember.BancoC;
                             SearchTree7 ( Root7 );
                             If RC = 'N' then
                                begin
                                  R := FileSize(BBFile);
                                  GotoXY(41,15); Write((R + 1):4);
                                  BBNumber := R;
                                  LoadTree7 ( Root7 );
                                  ReadWrite(#06,'W','N',R);
                                  CMstMember.NBancos := CMstMember.NBancos + 1;
                                  ShowHeap;
                                  Color(Tfn,Ttx);
                                end;
                           end
                           else begin
                                  D := D + 1;
                                  GotoXY(32,15); Write(D:4);
                                end;
                      Until (I + 1) = FileSize(WorkFile6);
                      Close ( WorkFile6 );
                      Erase ( WorkFile6 );
                    end;
               end
               else CMstMember.NBancos := 0;
            Close ( BBFile );
            Reset ( EEFile );
            If FileSize(EEFile) > 0 then
               begin
                 Assign( WorkFile8, (XPath + '\' + FileEN + '.WRK'));
                 {$I-}
                 Reset ( WorkFile8 );
                 {$I+}
                 If IOResult = 0 then
                    begin
                      Close ( WorkFile8 );
                      Erase ( WorkFile8 );
                    end;
                 Assign ( WorkFile8, (XPath + '\' + FileEN + '.DAT'));
                 Rename ( WorkFile8, (XPath + '\' + FileEN + '.WRK'));
                 {$I-}
                 Reset   ( WorkFile8 );
                 {$I+}
                 If IOResult = 0 then
                    begin
                      Assign ( ENFile, (XPath + '\' + FileEN + '.DAT'));
                      {$I-}
                      Reset  ( ENFile );
                      {$I+}
                      If IOResult <> 0 then ReWrite ( ENFile );
                    end;
                 Close ( EEFile );
                 Assign( WorkFile4, (XPath + '\' + FileEE + AAFx + '.WRK' ));
                 {$I-}
                 Reset ( WorkFile4 );
                 {$I+}
                 If IOResult = 0 then
                    begin
                      Close ( WorkFile4 );
                      Erase ( WorkFile4 );
                    end;
                 Assign ( WorkFile4, (XPath + '\' + FileEE + AAFx + '.' + MMFx ));
                 Rename ( WorkFile4, (XPath + '\' + FileEE + AAFx + '.WRK'));
                 {$I-}
                 Reset  ( WorkFile4 );
                 {$I+}
                 If IOResult = 0 then
                    begin
                      Assign ( EEFile, (XPath + '\' + FileEE + AAFx + '.' + MMFx ));
                      {$I-}
                      Reset  ( EEFile );
                      {$I+}
                      If IOResult <> 0 then ReWrite ( EEFile );
                      GotoXY(4,16); Write('Empregados     ');
                      I := -1;
                      R := 0;
                      D := 0;
                      CMstMember.NFunc := 0;
                      Repeat
                        I := I + 1;
                        GotoXY(24,16); Write((I + 1):4);
                        Seek ( WorkFile4, I        );
                        Read ( WorkFile4, EEMember );
                        EENo := Trim(EEMember.Matricula);
                        If (EEMember.Status <> 'X') and
                           (EENo            <> '' ) then
                           begin
                             SearchTree5 ( Root5 );
                             If RC = 'N' then
                                begin
                                  EENumber := FileSize(EEFile);
                                  R        := EENumber;
                                  GotoXY(41,16); Write((R + 1):4);
                                  For L := 1 to 9 do EEMember.Movimento[L] := 30000;
                                  ReadWrite(#08,'W','N',EENumber);
                                  {$I-}
                                  Seek ( WorkFile8, R        );
                                  Read ( WorkFile8, ENMember );
                                  {$I+}
                                  If IOResult <> 0 then
                                     For E := 1 to 48 do
                                     begin
                                       ENMember.MMAA[E] := '';
                                       ENMember.SalC[E] := 0;
                                       ENMember.VRec[E] := 0;
                                     end;
                                  ENMember.Empregado := EEMember.Matricula;
                                  ReadWrite(#12,'W','N',R);
                                  LoadTree5 ( Root5 );
                                  CMstMember.NFunc := CMstMember.NFunc + 1;
                                  RC := 'S';
                                  ShowHeap;
                                  Color(Tfn,Ttx);
                                end
                                else begin
                                       D := D + 1;
                                       GotoXY(32,16); Write(D:4);
                                     end;
                           end
                           else begin
                                  D := D + 1;
                                  GotoXY(32,16); Write(D:4);
                                end;
                      Until (I + 1) = FileSize(WorkFile4);
                      Close ( WorkFile4 );
                      Erase ( WorkFile4 );
                      Close ( WorkFile8 );
                      Erase ( WorkFile8 );
                      Close ( ENFile    );
                    end;
               end
               else With CMstMember do NFunc := 0;
            Close ( EEFile );
            Reset ( MMFile );
            Reset ( CCFile );
            Reset ( EEFile );
            Reset ( OOFile );
            If FileSize(MMFile) > 0 then
               begin
                 Close  ( MMFile );
                 Assign ( WorkFile5, (XPath + '\' + FileMM + AAFx + '.WRK' ));
                 {$I-}
                 Reset ( WorkFile5 );
                 {$I+}
                 If IOResult = 0 then
                    begin
                      Close ( WorkFile5 );
                      Erase ( WorkFile5 );
                    end;
                 Assign ( WorkFile5, (XPath + '\' + FileMM + AAFx + '.' + MMFx));
                 Rename ( WorkFile5, (XPath + '\' + FileMM + AAFx + '.WRK'));
                 {$I-}
                 Reset   ( WorkFile5 );
                 {$I+}
                 If IOResult = 0 then
                    begin
                      Assign ( MMFile, (XPath + '\' + FileMM + AAFx + '.' + MMFx ));
                      {$I-}
                      Reset  ( MMFile );
                      {$I+}
                      If IOResult <> 0 then ReWrite ( MMFile );
                      GotoXY(4,17); Write('Regs.de Movimento');
                      I := -1;
                      R := 0;
                      D := 0;
                      Repeat
                        I := I + 1;
                        GotoXY(24,17); Write((I + 1):4);
                        Seek ( WorkFile5, I        );
                        Read ( WorkFile5, MMMember );
                        If MMMember.Empregado <> '' then
                           begin
                             EENo := MMMember.Empregado;
                             SearchTree5 ( Root5 );
                             If RC = 'S' then
                                begin
                                  R := FileSize(MMFile);
                                  GotoXY(41,17); Write((R + 1):4);
                                  For L := 1 to 10 do
                                  begin
                                    CCNo := MMMember.Conta[L];
                                    SearchTree1 ( Root1 );
                                    If RC = 'N' then
                                       begin
                                         MMMember.Conta[L]     := '';
                                         MMMember.Origem[L]    := ' ';
                                         MMMember.AcMensalV[L] := 0;
                                         MMMember.AcMensalH[L] := 0;
                                         MMMember.AcMensalM[L] := 0;
                                         MMMember.AcAnualV[L]  := 0;
                                         MMMember.AcAnualH[L]  := 0;
                                         MMMember.AcAnualM[L]  := 0;
                                         MMMember.QtdResc[L]   := '';
                                         MMMember.Parcelas[L]  := 0;
                                         MMMember.BaseUsr[L]   := ' ';
                                         MMMember.PerctUsr[L]  := 0;
                                       end;
                                  end;
                                  ReadWrite(#11,'W','N',R       );
                                  ReadWrite(#08,'R','N',EENumber);
                                  If (EEMember.Status <> 'R') and
                                     (EEMember.Status <> 'X') then
                                     begin
                                       L := 0;
                                       Repeat
                                         L := L + 1;
                                       Until (EEMember.Movimento[L] = 30000) or (L = 9);
                                       If EEMember.Movimento[L] = 30000 then
                                          begin
                                            EEMember.Movimento[L] := R;
                                            ReadWrite(#08,'W','N',EENumber);
                                          end;
                                     end;
                                  ShowHeap;
                                  Color(Tfn,Ttx);
                                end
                                else begin
                                       D := D + 1;
                                       GotoXY(32,17); Write(D:4);
                                     end;
                           end
                           else begin
                                  D := D + 1;
                                  GotoXY(32,17); Write(D:4);
                                end;
                      Until (I + 1) = FileSize(WorkFile5);
                      Close ( WorkFile5 );
                      Erase ( WorkFile5 );
                    end;
               end;
            If FileSize(OOFile) > 0 then
               begin
                 I := -1;
                 Repeat
                   I := I + 1;
                   ReadWrite(#19,'R','N',I);
                   OONo := OOMember.Empregado + '#' +  OOMember.NumeroOS;
                   SearchTree8 ( Root8 );
                   If RC = 'N' then
                      begin
                        OONumber := I;
                        LoadTree8 ( Root8 );
                      end;
                   ShowHeap;
                   Color(Tfn,Ttx);
                 Until (I + 1) = FileSize(OOFile);
               end;
          end;
       Close ( MMFile );
       Close ( OOFile );
       Close ( CCFile );
       Close ( EEFile );
       Reset ( TTFile );
       If FileSize(TTFile) > 0 then
          begin
            GotoXY(4,18); Write('Tabelas e ParÉmetros');
            I := -1;
            R := 0;
            D := 0;
            Repeat
              I := I + 1;
              GotoXY(24,18); Write((I + 1):4);
              ReadWrite(#03,'R','N',I);
              TTNo := TTMember.AnoMesSeq;
              SearchTree4 ( Root4 );
              If RC = 'N' then
                 begin
                   R := R + 1;
                   GotoXY(41,18); Write(R:4);
                   TTNumber := I;
                   LoadTree4 ( Root4 );
                   ShowHeap;
                   Color(Tfn,Ttx);
                 end
                 else begin
                        D := D + 1;
                        GotoXY(32,18); Write(D:4);
                      end;
            Until (I + 1) = FileSize(TTFile);
          end;
       Close ( TTFile );
       Reset ( EEFile );
       {$I-}
       ChDir ( XPath );
       {$I+}
       If IOResult =  0 then
          begin
            Reset ( HHFile );
            If FileSize(HHFile) > 0 then
               begin
                 Color(Blue,White);
                 GotoXY(1,24); Write(ConstStr(' ',80));
                 GotoXY(2,24); Write('Quer excluir registros hist¢ricos (Sim ou N∆o)? ');
                 Color(Blue,Yellow);
                 GotoXY(37,24); Write('S');
                 GotoXY(44,24); Write('N');
                 TC := ' ';
                 Repeat
                   TC := UpCase(ReadKey);
                   If TC = #13 then TC := 'N';
                 Until TC in ['N','S'];
                 If TC = 'S' then
                    begin
                      Color(Blue,White);
                      GotoXY(55,24); Write('Excluir atÇ que Ano:');
                      Ax := '';
                      Repeat
                        J := Ax;
                        InputStr(J,2,76,24,0,'S','N','T','N',Blue,Yellow);
                        If TC = #13 then Ax := J
                                    else Ax := '';
                      Until ((Ax <> '') and (TC = #13)) or
                            ((Ax =  '') and (TC = #27));
                    end;
                 If TC in [#27,'N'] then Ax := '00';
                 LimpaLn(24,Tfd);
                 Color(Tfn,Ttx);
                 Close ( HHFile );
                 Assign( WorkFile9, (XPath + '\' + FileHH + '.WRK' ));
                 {$I-}
                 Reset ( WorkFile9 );
                 {$I+}
                 If IOResult = 0 then
                    begin
                      Close ( WorkFile9 );
                      Erase ( WorkFile9 );
                    end;
                 Assign ( WorkFile9, (XPath + '\' + FileHH + '.DAT'));
                 Rename ( WorkFile9, (XPath + '\' + FileHH + '.WRK'));
                 {$I-}
                 Reset   ( WorkFile9 );
                 {$I+}
                 If IOResult = 0 then
                    begin
                      Assign ( HHFile,(XPath + '\' + FileHH + '.DAT'));
                      {$I-}
                      Reset ( HHFile );
                      {$I+}
                      If IOResult <> 0 then
                         begin
                           ReWrite ( HHFile );
                           Reset   ( HHFile );
                         end;
                      GotoXY(4,19); Write('Hist¢ricos       ');
                      I := -1;
                      R := 0;
                      D := 0;
                      Repeat
                        I := I + 1;
                        GotoXY(24,19); Write((I + 1):4);
                        Seek ( WorkFile9, I        );
                        Read ( WorkFile9, HHMember );
                        EENo := HHMember.Empregado;
                        SearchTree5 ( Root5 );
                        If RC = 'S' then
                           begin
                             ReadWrite(#08,'R','N',EENumber);
                             If (EEMember.Status         <> 'R' ) and
                                (Copy(HHMember.Data,1,2)  >= Ax ) and
                                (HHMember.Tipo           <> '*' ) then
                                begin
                                  R := FileSize(HHFile);
                                  GotoXY(41,19); Write((R + 1):4);
                                  HHNo     := HHMember.Empregado + '#' +
                                              HHMember.Data      + '#' +
                                              HHMember.Tipo;
                                  HHNumber := R;
                                  LoadTree10 ( Root10 );
                                  ReadWrite(#10,'W','N',R);
                                  ShowHeap;
                                  Color(Tfn,Ttx);
                                end
                                else begin
                                       D := D + 1;
                                       GotoXY(32,19); Write(D:4);
                                     end;
                           end
                           else begin
                                  D := D + 1;
                                  GotoXY(32,19); Write(D:4);
                                end;
                      Until (I + 1) = FileSize(WorkFile9);
                      Close ( WorkFile9 );
                      Erase ( WorkFile9 );
                    end;
                 LimpaLn(24,Tfd);
               end;
            Close ( HHFile );
            ReadWrite(#16,'W','N',0);
          end;
       Reset ( CmpyFile   );
       Reset ( CCFile );
       Reset ( DDFile );
       Reset ( BBFile );
       Reset ( SSFile );
       Reset ( HHFile );
       Reset ( MMFile );
       Reset ( ENFile );
       Reset ( TTFile );
       TrocaTabela;
       LoadCmpy;
       CmpyNo     := CmpyAC;
       CmpyNumber := CmpyAN;
       ReadWrite(#02,'R','N',CmpyNumber);
{       LoadBlkSta; }
     end;
  Color(Blue,White);
  GotoXY(1,23); Write(' ':80);
  GotoXY(2,23); Write('O Banco de Dados est† Reorganizado');
  TeclaReturn;
  LimpaLn(23,Tfd);
end;


Procedure ReorganizaM;
begin
  Cabecalho;
  {$I-}
  ChDir ( XDrive );
  {$I+}
  If IOResult =  0 then
     begin
       D1     := 'S';
       RootB  := NIL;
       Root0  := NIL;
       Root1  := NIL;
       Root2  := NIL;
       Root4  := NIL;
       Release(HeapOrg);
       OpMn := 'N';
       ShowHeap;
       Color(Tfn,Ttx);
       If FileSize(CmpyFile) > 0 then
          begin
            Color(Red,White);
            GotoXY(1,24); Write(ConstStr(' ',80));
            GotoXY(2,24); Write('Quer excluir as Companhias marcadas com X (    ou    ): ');
            Color(Red,Yellow);
            GotoXY(45,24); Write('Sim');
            GotoXY(52,24); Write('N∆o');
            Ax := '';
            Repeat
              J := Ax;
              InputStr(J,1,58,24,0,'S','N','T','N',Red,White);
              If TC <> #27 then Ax := UpCase(J[1])
                           else Ax := 'N';
            Until (Ax[1] in ['N','S']) or (TC = #27);
            LimpaLn(24,Tfd);
            Color(Tfn,Ttx);
            Close ( CmpyFile );
            Assign( WorkFileX, (XDrive + '\PLOGCMPY.WRK' ));
            {$I-}
            Reset ( WorkFileX );
            {$I+}
            If IOResult = 0 then
               begin
                 Close ( WorkFileX );
                 Erase ( WorkFileX );
               end;
            Assign ( WorkFileX, (XDrive + '\PLOGCMPY.DAT' ));
            Rename ( WorkFileX, (XDrive + '\PLOGCMPY.WRK' ));
            {$I-}
            Reset   ( WorkFileX );
            {$I+}
            If IOResult = 0 then
               begin
                 Assign ( CmpyFile, (XDrive + '\PLOGCMPY.DAT' ));
                 {$I-}
                 Reset  ( CmpyFile );
                 {$I+}
                 If IOResult <> 0 then
                    begin
                      ReWrite ( CmpyFile );
                      Reset   ( CmpyFile );
                    end;
                 GotoXY(4,12); Write('Companhias');
                 I := -1;
                 R := 0;
                 D := 0;
                 MasterMember.NEmpresas := 0;
                 Repeat
                   I := I + 1;
                   GotoXY(24,12); Write((I + 1):4);
                   Seek ( WorkFileX, I          );
                   Read ( WorkFileX, CmpyMember );
                   If (Ax = 'N') or
                      ((CmpyMember.Status <> 'X') and (Ax = 'S')) then
                      begin
                        CmpyNo := CmpyMember.Chave;
                        SearchTree0 ( Root0 );
                        If RC = 'N' then
                           begin
                             R := FileSize(CmpyFile);
                             GotoXY(41,12); Write((R + 1):4);
                             CmpyNumber := R;
                             LoadTree0 ( Root0 );
                             ReadWrite(#02,'W','N',R);
                             MasterMember.NEmpresas := MasterMember.NEmpresas + 1;
                             ShowHeap;
                             Color(Tfn,Ttx);
                           end;
                      end
                      else begin
                             D := D + 1;
                             GotoXY(32,12); Write(D:4);
                           end;
                 Until (I + 1) = FileSize(WorkFileX);
                 Close ( WorkFileX );
                 Erase ( WorkFileX );
               end;
          end
          else MasterMember.NEmpresas := 0;
       If FileSize(CCFile) > 0 then
          begin
            Close ( CCFile );
            Assign( WorkFile1, (XDrive + '\' + FileCC + '.WRK' ));
            {$I-}
            Reset ( WorkFile1 );
            {$I+}
            If IOResult = 0 then
               begin
                 Close ( WorkFile1 );
                 Erase ( WorkFile1 );
               end;
            Assign ( WorkFile1, (XDrive + '\' + FileCC + '.DAT' ));
            Rename ( WorkFile1, (XDrive + '\' + FileCC + '.WRK' ));
            {$I-}
            Reset   ( WorkFile1 );
            {$I+}
            If IOResult = 0 then
               begin
                 Assign ( CCFile, (XDrive + '\' + FileCC + '.DAT' ));
                 {$I-}
                 Reset  ( CCFile );
                 {$I+}
                 If IOResult <> 0 then
                    begin
                      ReWrite ( CCFile );
                      Reset   ( CCFile );
                    end;
                 GotoXY(4,13); Write('Proventos/Descontos');
                 I := -1;
                 R := 0;
                 D := 0;
                 MasterMember.NContas := 0;
                 Repeat
                   I := I + 1;
                   GotoXY(24,13); Write((I + 1):4);
                   Seek ( WorkFile1, I        );
                   Read ( WorkFile1, CCMember );
                   If CCMember.Status <> 'C' then
                      begin
                        CCNo := CCMember.Conta;
                        SearchTree1 ( Root1 );
                        If RC = 'N' then
                           begin
                             R := FileSize(CCFile);
                             GotoXY(41,13); Write((R + 1):4);
                             CCNumber := R;
                             LoadTree1 ( Root1 );
                             ReadWrite(#04,'W','N',R);
                             MasterMember.NContas := MasterMember.NContas + 1;
                             ShowHeap;
                             Color(Tfn,Ttx);
                           end;
                      end
                      else begin
                             D := D + 1;
                             GotoXY(32,13); Write(D:4);
                           end;
                 Until (I + 1) = FileSize(WorkFile1);
                 Close ( WorkFile1 );
                 Erase ( WorkFile1 );
               end;
          end
          else MasterMember.NContas := 0;
       Close ( CCFile  );
       Reset ( SSFile  );
       If FileSize(SSFile) > 0 then
          begin
            Close  ( SSFile );
            Assign ( WorkFile2, (XDrive + '\' + FileSS + '.WRK' ));
            {$I-}
            Reset ( WorkFile2 );
            {$I+}
            If IOResult = 0 then
               begin
                 Close ( WorkFile2 );
                 Erase ( WorkFile2 );
               end;
            Assign ( WorkFile2, (XDrive + '\' + FileSS + '.DAT' ));
            Rename ( WorkFile2, (XDrive + '\' + FileSS + '.WRK' ));
            {$I-}
            Reset   ( WorkFile2 );
            {$I+}
            If IOResult = 0 then
               begin
                 Assign ( SSFile, (XDrive + '\' + FileSS + '.DAT' ));
                 {$I-}
                 Reset ( SSFile );
                 {$I+}
                 If IOResult <> 0 then
                    begin
                      ReWrite ( SSFile );
                      Reset   ( SSFile );
                    end;
                 GotoXY(4,14); Write('Sindicatos       ');
                 MasterMember.NSind := 0;
                 I                  := -1;
                 R                  := 0;
                 D                  := 0;
                 Repeat
                   I := I + 1;
                   GotoXY(24,14); Write((I + 1):4);
                   Seek ( WorkFile2, I        );
                   Read ( WorkFile2, SSMember );
                   If SSMember.Status <> 'C' then
                      begin
                        SSNo := SSMember.Codigo;
                        SearchTree2 ( Root2 );
                        If RC = 'N' then
                           begin
                             R := FileSize(SSFile);
                             GotoXY(41,14); Write((R + 1):4);
                             SSNumber := R;
                             LoadTree2 ( Root2 );
                             ReadWrite(#07,'W','N',R);
                             MasterMember.NSind := MasterMember.NSind + 1;
                             ShowHeap;
                             Color(Tfn,Ttx);
                           end;
                      end
                      else begin
                             D := D + 1;
                             GotoXY(32,14); Write(D:4);
                           end;
                 Until (I + 1) = FileSize(WorkFile2);
                 Close ( WorkFile2 );
                 Erase ( WorkFile2 );
               end;
          end
          else MasterMember.NSind := 0;
       Close ( SSFile );
       If FileSize(TTFile) > 0 then
          begin
            Close  ( TTFile );
            Assign ( WorkFile0, (XDrive + '\' + FileTT + '.WRK' ));
            {$I-}
            Reset ( WorkFile0 );
            {$I+}
            If IOResult = 0 then
               begin
                 Close ( WorkFile0 );
                 Erase ( WorkFile0 );
               end;
            Assign ( WorkFile0, (XDrive + '\' + FileTT  + '.DAT'));
            Rename ( WorkFile0, (XDrive + '\' + FileTT + '.WRK'));
            {$I-}
            Reset   ( WorkFile0 );
            {$I+}
            If IOResult = 0 then
               begin
                 Assign(TTFile,(XDrive + '\' + FileTT + '.DAT'));
                 {$I-}
                 Reset ( TTFile );
                 {$I+}
                 If IOResult <> 0 then
                    begin
                      ReWrite ( TTFile );
                      Reset   ( TTFile );
                    end;
                 GotoXY(4,15); Write('Tabelas & ParÉmetros');
                 I := -1;
                 R := 0;
                 D := 0;
                 Repeat
                   I := I + 1;
                   GotoXY(24,15); Write((I + 1):4);
                   Seek ( WorkFile0, I        );
                   Read ( WorkFile0, TTMember );
                   If TTMember.AnoMesSeq[7] in ['1','2'] then
                      begin
                        TTNo := TTMember.AnoMesSeq;
                        SearchTree4 ( Root4 );
                        If RC = 'N' then
                           begin
                             R := FileSize(TTFile);
                             GotoXY(41,15); Write((R + 1):4);
                             TTNumber := R;
                             LoadTree4 ( Root4 );
                             ReadWrite(#03,'W','N',R);
                             ShowHeap;
                             Color(Tfn,Ttx);
                           end;
                      end
                      else begin
                             D := D + 1;
                             GotoXY(32,15); Write(D:4);
                           end;
                 Until (I + 1) = FileSize(WorkFile0);
                 Close ( WorkFile0 );
                 Erase ( WorkFile0 );
               end;
          end;
       Close ( TTFile );
       Reset ( CCFile );
       Reset ( SSFile );
       Reset ( TTFile );
       TrocaTabela;
       ReadWrite(#00,'W','N',0);
       LastCia := '';
       LoadBlkSta;
     end;
  Color(Blue,White);
  GotoXY(1,23); Write(' ':80);
  GotoXY(2,23); Write('Os Mestres est∆o Reorganizados');
  TeclaReturn;
  LimpaLn(23,Tfd);
end;


Procedure SomaHorasFerias;
begin
  R1 := Trunc((YAddress^.AcMensalH * 60) + YAddress^.AcMensalM);
  If CCMember.Taxa > 0 then R1 := Trunc(R1 * CCMember.Taxa);
  Case EEMember.PeriodoV of
       0 : begin
             R1 := (EEMember.SomaHF1 * 60) + EEMember.SomaMF1 + R1;
             Horas(R1);
             EEMember.SomaHF1 := Hora;
             EEMember.SomaMF1 := Minuto;
           end;
       1 : begin
             R1 := (EEMember.SomaHF2 * 60) + EEMember.SomaMF2 + R1;
             Horas(R1);
             EEMember.SomaHF2 := Hora;
             EEMember.SomaMF2 := Minuto;
           end;
  end;
end;


Procedure MesNovo;
Var
  Comis,
  PagoC    : Real;
begin
  If EEMember.Status in ['D','J','M','N','O','P','T','R','X'] then
     begin
       If MM = 1 then EEMember.Status := 'X'
                 else If EEMember.Status <> 'X'
                         then EEMember.Status := 'R';
     end
     else begin
            If MM = 1 then EEMember.MesesT  := 0;
            Valor := 0;
            VLiq  := 0;
            Comis := 0;
            PagoC := 0;
            YYNo  := '';
            Repeat
              RC := 'N';
              SearchPosY ( RootY );
              If RC = 'S' then
                 begin
                   YAddress^.AcAnualV := YAddress^.AcAnualV + TruncX(YAddress^.AcMensalV);
                   Hora   := YAddress^.AcAnualH + YAddress^.AcMensalH;
                   Minuto := YAddress^.AcAnualM + YAddress^.AcMensalM;
                   HoraMinuto;
                   YAddress^.AcAnualH := Hora;
                   YAddress^.AcAnualM := Minuto;
                   CCNo := YYNo;
                   If CCNo = '014'
                      then PagoC := YAddress^.AcMensalV
                      else If CCNo = '015'
                              then Valor := YAddress^.AcMensalV
                              else If CCNo = '025'
                                      then VLiq := YAddress^.AcMensalV
                                      else If CCNo = '035'
                                              then Comis := YAddress^.AcMensalV;
                   SearchTree1 ( Root1 );
                   If RC = 'S' then
                      begin
                        If YAddress^.Parcelas > 0
                           then YAddress^.Parcelas := YAddress^.Parcelas - 1
                           else YAddress^.Parcelas := 0;
                        ReadWrite(#04,'R','N',CCNumber);
                        If CCMember.Media = 'S' then SomaHorasFerias;
                        If (CCMember.Tempo     = 'T') and
                           (YAddress^.Parcelas = 0  ) then
                           begin
                             If ((CCNo         <> '088')  and
                                 (CCNo         <> '089')) or
                                ((EEMember.MesI = M    )  and
                                 (CCNo          = '088')) or
                                ((EEMember.MesF = M    )  and
                                 (CCNo          = '089')) then
                                begin
                                  YAddress^.AcMensalV := 0;
                                  YAddress^.AcMensalH := 0;
                                  YAddress^.AcMensalM := 0;
                                  YAddress^.BaseUsr   := ' ';
                                  YAddress^.PerctUsr  := 0;
                                end;
                             If MM = 1 then
                                begin
                                  YAddress^.AcAnualV := 0;
                                  YAddress^.AcAnualH := 0;
                                  YAddress^.AcAnualM := 0;
                                end;
                           end
                           else If CCMember.Tempo = 'P' then
                                   begin
                                     If MM = 1 then
                                        begin
                                          YAddress^.AcAnualV := 0;
                                          YAddress^.AcAnualH := 0;
                                          YAddress^.AcAnualM := 0;
                                        end;
                                   end;
                      end;
                   YAddress^.Origem := 'S';
                   RC               := 'S';
                 end;
            Until RC = 'N';
            If Valor <> 0 then
               begin
                 YYNo := '066';
                 SearchTreeY ( RootY );
                 If RC = 'N' then LoadTreeY ( RootY );
                 YAddress^.Origem    := 'S';
                 YAddress^.AcMensalV := Valor;
               end;
            If VLiq <> 0 then
               begin
                 YYNo := '065';
                 SearchTreeY ( RootY );
                 If RC = 'N' then LoadTreeY ( RootY );
                 YAddress^.Origem    := 'S';
                 YAddress^.AcMensalV := VLiq;
               end;
            If Comis <> 0 then
               begin
                 YYNo := '095';
                 SearchTreeY ( RootY );
                 If RC = 'N' then LoadTreeY ( RootY );
                 YAddress^.Origem    := 'S';
                 YAddress^.AcMensalV := Comis;
               end;
            If PagoC <> 0 then
               begin
                 YYNo := '048';
                 SearchTreeY ( RootY );
                 If RC = 'N' then LoadTreeY ( RootY );
                 YAddress^.Origem    := 'S';
                 YAddress^.AcMensalV := PagoC;
               end;
            If Op = 'S' then
               begin
                 For I := 1 to 6 do EEMember.Passagens[I] := 0;
                 EEMember.VTransporte := 'N';
               end;
            If EEMember.MesF < MM then
               begin
                 If EEMember.Status in ['C','F','L'] then EEMember.Status := 'A';
                 EEMember.DiaI := 0;
                 EEMember.MesI := 0;
                 EEMember.DiaF := 0;
                 EEMember.MesF := 0;
               end;
            For I := 1 to 7 do
            begin
              EEMember.ChBco[I]  := '';
              EEMember.Cheque[I] := '';
              EEMember.VChq[I]   := 0;
            end;
            RC := 'S';
            If EEMember.Status = 'E' then EEMember.Status := 'A';
          end;
end;


Procedure Abertura;
Var
  MM1,AA1    : Integer;
begin
  MM1 := MM + 1;
  AA1 := AA;
  If XCondicional[1] <> '#' then
     begin
       If MM1 = 12 then
          begin
            MM1 := 01;
            AA1 := AA1 + 1;
          end;
       J := QQStr(MM1,2,'0') + QQStr(AA1,2,'0');
       If (J <> Copy(XCondicional,1,4)) and
          (J <> Copy(XCondicional,5,4)) then TC := #27
                                        else TC := 'S';
     end
     else TC := 'S';
  If TC = 'S' then
     begin
       M := MM;
       A := AA;
       Color(Red,Cyan);
       GotoXY(1,24); Write(ConstStr(' ',80));
       GotoXY(2,24);
       Write('Quer zerar o n£mero de passagens do Empregado (Vale Transporte)?   Sim/N∆o');
       Color(Red,White);
       GotoXY(69,24); Write('S');
       GotoXY(73,24); Write('N');
       Repeat
         TC := UpCase(ReadKey);
       Until TC in ['S','N',#27];
     end;
  LimpaLn(24,Tfd);
  If TC <> #27 then
     begin
       Op := TC;
       Close ( SSFile );
       Close ( BBFile );
       Close ( EEFile );
       Close ( MMFile );

       Assign( WorkFile4, (XPath + '\' + FileEE + AAFx + '.' + MMFx));
       {$I-}
       Reset ( WorkFile4 );
       {$I+}
       If IOResult = 0 then
          begin
            MM := CMstMember.MesAtivo;
            AA := CMstMember.AnoAtivo;
            If MM < 12 then MM := MM + 1
                       else begin
                              MM := 1;
                              AA := AA + 1;
                            end;
            MMFn := 'M' + QQStr(MM,2,'0');
            IIFn := 'I' + QQStr(MM,2,'0');
            AAFn := QQStr(AA,4,'0');
            Assign ( EEFile, (XPath + '\' + FileEE + AAFn + '.' + MMFn));
            {$I-}
            Reset  ( EEFile );
            {$I+}
            If IOResult = 0 then
               begin
                 Color(Blue,Yellow);
                 GotoXY(1,23); Write(' ':80);
                 GotoXY(2,23); Write(ArrayMesEx[MM],'/',AA,' j† esta aberto');
                 Color(Red,Cyan);
                 GotoXY(01,24); Write(' ':80);
                 GotoXY(56,24); Write('Quer refaze-lo? (S ou N)');
                 Color(Red,Yellow);
                 GotoXY(73,24); Write('S');
                 GotoXY(78,24); Write('N');
                 Repeat
                   TC := UpCase(ReadKey);
                 Until TC in ['S','N'];
                 LimpaLn(23,Tfd);
                 LimpaLn(24,Tfd);
                 If TC = 'S' then
                    begin
                      Close ( EEFile );
                      Erase ( EEFile );
                      TC := 'X';
                    end;
               end
               else TC := 'S';
            If TC in ['S','X'] then
               begin
                 ReWrite ( EEFile );
                 Reset   ( EEFile );
                 Assign ( WorkFile5, (XPath + '\' + FileMM + AAFx + '.' + MMFx ));
                 {$I-}
                 Reset  ( WorkFile5 );
                 {$I+}
                 If IOResult = 0 then
                    begin
                      Assign ( MMFile, (XPath + '\' + FileMM + AAFn + '.' + MMFn));
                      {$I-}
                      Reset  ( MMFile );
                      {$I+}
                      If IOResult = 0 then
                         begin
                           If TC = 'X' then
                              begin
                                Close ( MMFile );
                                Erase ( MMFile );
                              end
                              else TC := 'N';
                         end;
                      If TC in ['S','X'] then
                         begin
                           Assign ( OOFile, (XPath + '\' + FileOS + AAFn + '.' + MMFn ));
                           ReWrite ( OOFile );
                           ReWrite ( MMFile );
                           Reset   ( MMFile );
                           DrawBox(7,10,49,19,Sfn,'S');
                           Color(Bfn,Btx);
                           GotoXY(7,10); Write(' Empregados Analisados na Abertura         ');
                           Color(Sfn,Stx);
                           Window(8,12,49,19);
                           GotoXY(1,7);
                           EENo := '';
                           Repeat
                             RC := 'N';
                             SearchPos5 ( Root5 );
                             If RC = 'S' then
                                begin
                                  Seek ( WorkFile4, EENumber );
                                  Read ( WorkFile4, EEMember );
                                  Writeln(EEMember.Nome);
                                  LoadMVDsk(#17);
                                  MesNovo;
                                  For I := 1 to 9 do EEMember.Movimento[I] := Limite;
                                  UnLoadMVDsk;
                                  ReadWrite(#08,'W','N',EENumber);
                                  RC := 'S';
                                end;
                           Until RC = 'N';
                           Assign ( PXFile,(XPath + '\' + FileMM + AAFx + '.T' + Copy(MMFx,2,2)));
                           {$I-}
                           Reset ( PXFile );
                           {$I+}
                           If IOResult = 0 then
                              begin
                                I := -1;
                                Repeat
                                  I := I + 1;
                                  Seek ( PXFile, I               );
                                  Read ( PXFile, PXMember        );
                                  EENo := PXMember.Empregado;
                                  SearchTree5 ( Root5 );
                                  If RC = 'S' then
                                     begin
                                       ReadWrite(#08,'R','N',EENumber);
                                       LoadMVDsk(#11);
                                       YYNo := PXMember.Conta;
                                       SearchTreeY ( RootY );
                                       If RC = 'N' then LoadTreeY ( RootY );
                                       YAddress^.AcMensalV := PXMember.AcMensalV;
                                       YAddress^.AcMensalH := PXMember.AcMensalH;
                                       YAddress^.AcMensalM := PXMember.AcMensalM;
                                       YAddress^.Origem    := 'U';
                                       EEMember.Status     := 'F';
                                       UnLoadMVDsk;
                                       ReadWrite(#08,'W','N',EENumber);
                                     end;
                                Until I+1 = FileSize(PXFile);
                                Close ( PXFile );
                              end;
                           Window(1,1,80,25);
                           TTNo := AAFx + Copy(MMFx,2,2) + '2';
                           SearchTree4 ( Root4 );
                           Case RC of
                                'N' : begin
                                        TTNo := AAFx + Copy(MMFx,2,2) + '1';
                                        SearchTree4 ( Root4 );
                                        If RC = 'S' then ReadWrite(#03,'R','N',TTNumber);
                                      end;
                                'S' : ReadWrite(#03,'R','N',TTNumber);
                           end;
                           TTNo := AAFn + Copy(MMFn,2,2) + '1';
                           SearchTree4 ( Root4 );
                           If RC = 'N' then
                              begin
                                TTMember.AnoMesSeq := TTNo;
                                TTNumber           := FileSize(TTFile);
                                ReadWrite(#03,'W','N',TTNumber);
                                D1 := 'S';
                              end;
                           VP2  := 'N';
                           Vez  := 'S';
                           VezD := 'S';
                           VezR := 'S';
                           MMFx := MMFn;
                           AAFx := AAFn;
                           IIFx := 'I' + Copy(MMFx,2,2);
                           CMstMember.MesAtivo := MM;
                           CMstMember.AnoAtivo := AA;
                           CMstMember.Etapa    := 'X';
                           ReadWrite(#16,'W','N',0);
                           Color(Blue,White);
                           GotoXY(1,23); Write(' ':80);
                           GotoXY(2,23);
                           If TC = 'S'
                              then Write(ArrayMesEx[MM],'/',AA:4,' est† aberto.')
                              else Write(ArrayMesEx[MM],'/',AA:4,' est† refeito.');
                           TeclaReturn;
                           LimpaLn(23,Tfd);
                           Assign(Ind2File,(XPath + '\' + FileInd2 + AAFx + '.' + IIFx));
                           {$I-}
                           Reset (Ind2File);
                           {$I+}
                           If IOResult <> 0 then ReWrite (Ind2File);
                           Close (Ind2File);
                           TC := 'S';
                         end;
                      Close ( MMFile    );
                      Close ( WorkFile5 );
                      Close ( OOFile    );
                    end;
               end
               else begin
                      MM := CMstMember.MesAtivo;
                      AA := CMstMember.AnoAtivo;
                    end;
            Close ( EEFile    );
          end;
       Close ( WorkFile4 );
       Assign( EEFile, (XPath + '\' + FileEE + AAFx + '.' + MMFx));
       Reset ( EEFile );
       Assign( MMFile, (XPath + '\' + FileMM + AAFx + '.' + MMFx));
       Reset ( MMFile );
       Reset ( SSFile );
       Reset ( BBFile );
       DDNo := '';
       Repeat
         RC := 'N';
         SearchPos3 ( Root3 );
         If RC = 'S' then
            begin
              ReadWrite(#05,'R','N',DDNumber);
              DDMember.Dias1 := DDMember.Dias2;
              DDMember.Dias2 := 0;
              ReadWrite(#05,'W','N',DDNumber);
            end;
       Until RC = 'N';

       Reset ( BlkStaFile );
       BlkNumber              := FileSize( BlkStaFile );
       BlkStaMember.Cia       := CmpyNo;
       BlkStaMember.MesAno    := QQStr(CMstMember.AnoAtivo,4,'0') + '/' +
                                 QQStr(CMstmember.MesAtivo,2,'0');
       BlkStaMember.BlkStatus := 'L';
       ReadWrite(#18,'W','N',BlkNumber);
       Close ( BlkStafile );
     end;
end;


Procedure ExcluiAno;
begin
  Move(Mem[$B800:0000],ScArray4[1],4000);
  DrawBox(4,10,49,19,Sfn,'S');
  Color(Red,Yellow);
  GotoXY(4,10); Write('               Leia com Atená∆o               ');
  Color(Red,Cyan);
  GotoXY(4,11); Write('               ----------------               ');
  GotoXY(4,12); Write(' Este  procedimento  exclui  fisicamente  dos ');
  GotoXY(4,13); Write(' arquivos do Sistema, todo o ano(Lanáamentos/ ');
  GotoXY(4,14); Write(' Empregados). Por precauá∆o, deve-se fazer um ');
  GotoXY(4,15); Write(' BACKUP, evitando  a perda  de informaáîes se ');
  GotoXY(4,16); Write(' algo sair errado, ou se por  qualquer raz∆o, ');
  GotoXY(4,17); Write(' a exclus∆o for indevida.                     ');
  GotoXY(4,18); Write('                                              ');
  GotoXY(4,19); Write('                      Veja Manual do Usu†rio. ');
  Color(Tfn,Utx);
  Confirma;
  If TC = 'S' then
     begin
       Move(ScArray4[1],Mem[$B800:0000],4000);
       XAno := '';
       Color(Tfn,Ttx);
       GotoXY(04,10); Write('Ano...:');
       Repeat
         J := XAno;
	 InputStr(J,4,12,10,0,'S','N','T','N',Tfn,Utx);
         XAno := J;
         Val(J,I,E);
         If I = CMstMember.AnoAtivo then
            begin
              DrawBox(4,12,49,18,Red,'S');
              Color(Red,Yellow);
              GotoXY(4,12); Write('               Leia com Atená∆o               ');
              Color(Red,Cyan);
              GotoXY(4,13); Write('               ----------------               ');
              GotoXY(4,14); Write(' N∆o Ç poss°vel prosseguir com esta exclus∆o, ');
              GotoXY(4,15); Write(' uma vez que o ano que se deseja excluir esta ');
              GotoXY(4,16); Write(' ativo.  Mude o ano,  de modo  que este fique ');
              GotoXY(4,17); Write(' inativo, e volte a executar a exclus∆o.      ');
              Color(Tfn,Utx);
              TeclaReturn;
              TC := #27;
            end
            else If TC <> #27 then Confirma;
       Until TC in [#27,'S'];
       If TC = 'S' then
          begin
            Color(Blue,Yellow);
            GotoXY(1,23); Write(ConstStr(' ',80));
            GotoXY(2,23);
            Write('Excluindo movimento de entrada e sa°da.                         Aguarde');
            Close  ( HPFile );
            Assign ( HPFile,  (XPath + '\' + FileHP   + XAno + '.DAT'));
            {$I-}
            Reset ( HPFile );
            {$I+}
            If IOResult = 0 then
               begin
                 Close ( HPFile );
                 Erase ( HPFile );
               end;
            Assign ( HPFile,  (XPath + '\' + FileHP   + AAFx + '.DAT'));
            Reset ( HPFile );
            Close ( EEFile );
            Close ( MMFile );
            For I := 1 to 12 do
            begin
              Str(I:2,J);
              J := LeftAdjust(J);
              If Length(J) = 1 then J := '0' + J;
              Assign ( EEFile,  (XPath + '\' + FileEE   + XAno + '.M' + J));
              Assign ( MMFile,  (XPath + '\' + FileMM   + XAno + '.M' + J));
              Assign ( Ind2File,(XPath + '\' + FileInd2 + XAno + '.I' + J));
              {$I-}
              Reset ( EEFile );
              {$I+}
              If IOResult = 0 then
                 begin
                   Close ( EEFile );
                   Erase ( EEFile );
                 end;
              {$I-}
              Reset ( MMFile );
              {$I+}
              If IOResult = 0 then
                 begin
                   Close ( MMFile );
                   Erase ( MMFile );
                 end;
              {$I-}
              Reset ( Ind2File );
              {$I+}
              If IOResult = 0 then
                 begin
                   Close ( Ind2File );
                   Erase ( Ind2File );
                 end;
            end;
            Color(Blue,Cyan);
            GotoXY(1,23); Write(' ':80);
            GotoXY(2,23);
            Write('O ano de ',XAno,' foi exclu°do fisicamente dos arquivos.');
            TeclaReturn;
            Assign ( EEFile,  (XPath + '\' + FileEE   + AAFx + '.' + MMFx));
            Assign ( MMFile,  (XPath + '\' + FileMM   + AAFx + '.' + MMFx));
            Assign ( Ind2File,(XPath + '\' + FileInd2 + AAFx + '.' + IIFx));
            Reset ( EEFile   );
            Reset ( MMFile   );
          end;
     end;
end;

end.

