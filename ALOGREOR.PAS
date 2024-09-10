{$O+,F+}
Unit AlogReor;

Interface

Uses Crt,Dos,AlogGlbs,AlogNavg,AlogBasP,AlogInit;


   Procedure Reorganiza;
   Procedure ReorganizaM;


Implementation

Var
  Res      : Char;


Procedure RecebeResposta(X,Y : Integer);
begin
  Move(MemW[$B800:0000],ScArray5[1],4000);
  DrawBox(4,14,47,19,Red,'S');
  Color(Red,Cyan);
  GotoXY(4,14); Write(' Recupera os Indices e exclui as Contas que ');
  GotoXY(4,15); Write(' estiverem com Status X, informe:           ');
  GotoXY(4,16); Write('       - pode haver altera‡„o nos C¢digos   ');
  GotoXY(4,17); Write('         reduzidos das Contas.              ');
  GotoXY(4,18); Write('       - apenas os Indices s„o recuparados. ');
  Color(Red,White);
  GotoXY(9,16); Write('S');
  GotoXY(9,18); Write('N');
  Color(Tfn,Utx);
  Repeat
    GotoXY(X,Y); Write('N');
    GotoXY(X,Y); Res := UpCase(ReadKey);
    GotoXY(X,Y); Write(Res);
  Until (Res = 'S') or (Res = 'N');
  Move(ScArray5[1],MemW[$B800:0000],4000);
  Color(Tfn,Ttx);
  GotoXY(X-1,Y);
  Case Res of
       'N' : Write('N„o');
       'S' : Write('Sim');
  end;
end;


Procedure Reorganiza;
begin
  Color(Bfn,Btx);
  GotoXY(3,10); Write(' Entidade           Lidos    Excl.   Carreg  S/N ');
  Color(Tfn,Ttx);
  ReadWrite(#00,'W','N',0);
  ReadWrite(#16,'W','N',0);
  CloseFiles;
  Close ( HsPdFile   );
  Close ( EcoFile    );
  {$I-}
  ChDir ( XPath );
  {$I+}
  If IOResult =  0 then
     begin
       RootB := NIL;
       Root0 := NIL;
       Root1 := NIL;
       Root2 := NIL;
       Root3 := NIL;
       Root4 := NIL;
       Root5 := NIL;
       Root6 := NIL;
       Root7 := NIL;
       Root8 := NIL;
       Release (HeapOrg);
       OpMn := 'N';
       ShowHeap;
       Color(Tfn,Ttx);
       ReadWrite(#00,'R','N',0);
       Reset ( OwnerFile );
       ReadWrite(#01,'R','N',0);
       Reset ( CMstFile );
       ReadWrite(#16,'R','N',0);
       Reset ( ContaFile );
       Reset ( SaldFile  );
       If FileSize(ContaFile) > 0 then
          begin
            GotoXY(4,12); Write('Guia Cont bil ');
            RecebeResposta(49,12);
            If Res = 'S' then
               begin
                 Close ( SaldFile );
                 Assign ( WorkFile4, (XPath + '\' + FileSald + AAFx + '.WRK' ));
                 {$I-}
                 Reset ( WorkFile4 );
                 {$I+}
                 If IOResult = 0 then
                    begin
                      Close ( WorkFile4 );
                      Erase ( WorkFile4 );
                    end;
                 Assign ( WorkFile4, (XPath + '\' + FileSald + AAFx + '.DAT'));
                 Rename ( WorkFile4, (XPath + '\' + FileSald + AAFx + '.WRK'));
	         {$I-}
                 Reset ( WorkFile4 );
                 {$I+}
                 If IOResult = 0 then
                    begin
                      Assign ( SaldFile, (XPath + '\' + FileSald + AAFx + '.DAT' ));
                      {$I-}
                      Reset ( SaldFile );
                      {$I+}
                      If IOResult <> 0 then
                         begin
                           ReWrite ( SaldFile );
                           Reset   ( SaldFile );
                         end;
                    end;
                 Close  ( ContaFile );
                 Assign ( WorkFile1, (XPath + '\' + FileConta + '.WRK' ));
                 {$I-}
                 Reset ( WorkFile1 );
                 {$I+}
                 If IOResult = 0 then
                    begin
                      Close ( WorkFile1 );
                      Erase ( WorkFile1 );
                    end;
                 Assign ( WorkFile1, (XPath + '\' + FileConta + '.DAT' ));
                 Rename ( WorkFile1, (FileConta + '.WRK'));
	         {$I-}
                 Reset  ( WorkFile1 );
                 {$I+}
                 If IOResult = 0 then
                    begin
                      Assign ( ContaFile, (XPath + '\' + FileConta + '.DAT' ));
                      {$I-}
                      Reset  ( ContaFile );
                      {$I+}
                      If IOResult <> 0 then
                         begin
                           ReWrite ( ContaFile );
                           Reset   ( ContaFile );
                         end;
                      I := -1;
                      R := 0;
                      D := 0;
                      CMstMember.NContas := 0;
                      Repeat
                        I := I + 1;
                        GotoXY(24,12); Write((I + 1):4);
                        Seek ( WorkFile1, I           );
                        Read ( WorkFile1, ContaMember );
                        ContaNo := ContaMember.Conta;
                        SearchTree1 ( Root1 );
                        If RC = 'N' then
                           begin
                             {$I-}
                             Seek ( WorkFile4, I           );
                             Read ( WorkFile4, SaldMember  );
                             {$I+}
                             If IOResult <> 0 then
                                begin
                                  SaldMember.Status := 'A';
                                  For K := 1 to 12 do
                                  begin
                                    SaldMember.Abertura[K] := 0;
                                    SaldMember.Debitos[K]  := 0;
                                    SaldMember.Creditos[K] := 0;
                                    SaldMember.Saldo[K]    := 0;
                                    SaldMember.SaldoB[K]   := 0;
                                    SaldMember.NLanctos[K] := 0;
                                  end;
                                end
                                else SaldMember.NLanctos[MM] := 0;
                             If SaldMember.Status <> 'X' then
                                begin
                                  R := FileSize(ContaFile);
                                  GotoXY(41,12); Write((R + 1):4);
                                  ContaNumber := R;
                                  LoadTree1 ( Root1 );
                                  ReadWrite(#03,'W','N',R);
                                  ReadWrite(#06,'W','N',R);
                                  CMstMember.NContas := CMstMember.NContas + 1;
                                end
                                else begin
                                       D := D + 1;
                                       GotoXY(32,12); Write(D:4);
                                     end;
                             ShowHeap;
                             Color(Tfn,Ttx);
                           end;
                      Until (I + 1) = FileSize(WorkFile1);
                      Close ( WorkFile1 );
                      Close ( WorkFile4 );
                      Erase ( WorkFile1 );
                      Erase ( WorkFile4 );
                      Close ( SaldFile  );
                      Reset ( SaldFile  );
                      Close ( ContaFile );
                      Reset ( ContaFile );
                    end;
               end
               else begin
                      I := -1;
                      CMstMember.NContas := 0;
                      Repeat
                        I := I + 1;
                        GotoXY(24,12); Write((I + 1):4);
                        Seek ( ContaFile, I           );
                        Read ( ContaFile, ContaMember );
                        ContaNo := ContaMember.Conta;
                        SearchTree1 ( Root1 );
                        If RC = 'N' then
                           begin
                             GotoXY(41,12); Write((I + 1):4);
                             ContaNumber := I;
                             LoadTree1 ( Root1 );
                             CMstMember.NContas := CMstMember.NContas + 1;
                             ReadWrite(#06,'R','N',ContaNumber);
                             If RW = 'N' then
                                begin
                                  SaldMember.Status := 'A';
                                  For K := 1 to 12 do
                                  begin
                                    SaldMember.Abertura[K] := 0;
                                    SaldMember.Debitos[K]  := 0;
                                    SaldMember.Creditos[K] := 0;
                                    SaldMember.Saldo[K]    := 0;
                                    SaldMember.SaldoB[K]   := 0;
                                    SaldMember.NLanctos[K] := 0;
                                  end;
                                end
                                else SaldMember.NLanctos[MM] := 0;
                             ReadWrite(#06,'W','N',ContaNumber);
                             ShowHeap;
                             Color(Tfn,Ttx);
                           end;
                      Until (I + 1) = FileSize(ContaFile);
                    end;
          end;
       Reset ( LoteFile  );
       If FileSize(LoteFile) > 0 then
          begin
            Close ( LoteFile );
            Assign( WorkFile2, (XPath + '\' + FileLote + AAFx + '.WRK' ));
            {$I-}
            Reset ( WorkFile2 );
            {$I+}
            If IOResult = 0 then
               begin
                 Close ( WorkFile2 );
                 Erase ( WorkFile2 );
               end;
            Assign ( WorkFile2, (XPath + '\' + FileLote + AAFx + '.DAT'));
            Rename ( WorkFile2, (XPath + '\' + FileLote + AAFx + '.WRK'));
	    {$I-}
            Reset  ( WorkFile2 );
            {$I+}
            If IOResult = 0 then
               begin
                 Assign ( LoteFile, (XPath + '\' + FileLote + AAFx + '.DAT'));
                 {$I-}
                 Reset ( LoteFile );
                 {$I+}
                 If IOResult <> 0 then
                    begin
                      ReWrite ( LoteFile );
                      Reset   ( LoteFile );
                    end;
                 GotoXY(4,13); Write('Header de Lotes  ');
                 I := -1;
                 R := 0;
                 D := 0;
                 Repeat
                   I := I + 1;
                   GotoXY(24,13); Write((I + 1):4);
                   Seek ( WorkFile2, I          );
                   Read ( WorkFile2, LoteMember );
                   If (LoteMember.Status in ['A','C']) or
                      ((LoteMember.Status      = 'E')  and
                       (LoteMember.MesContabil <> MM)) then
                      begin
                        LoteNo := LoteMember.Chave;
                        SearchTree2 ( Root2 );
                        If RC = 'N' then
                           begin
                             R := FileSize(LoteFile);
                             GotoXY(41,13); Write((R + 1):4);
                             LoteNumber := R;
                             LoadTree2 ( Root2 );
                             For K := 1 to 31 do If (LoteMember.Dias[K] <> 'S') and
                                                    (LoteMember.Dias[K] <> 'C')
                                                    then LoteMember.Dias[K] := '.';
                             ReadWrite(#04,'W','N',R);
                             ShowHeap;
                             Color(Tfn,Ttx);
                           end;
                      end
                      else begin
                             D := D + 1;
                             GotoXY(32,13); Write(D:4);
                           end;
                 Until (I + 1) = FileSize(WorkFile2);
                 Close ( WorkFile2 );
                 Erase ( WorkFile2 );
               end;
            Close ( LoteFile  );
            Reset ( LoteFile  );
          end;
       Reset ( DeptFile  );
       If FileSize(DeptFile) > 0 then
          begin
            Close ( DeptFile );
            Assign( WorkFile3, (XPath + '\' + FileDept + '.WRK' ));
            {$I-}
            Reset ( WorkFile3 );
            {$I+}
            If IOResult = 0 then
               begin
                 Close ( WorkFile3 );
                 Erase ( WorkFile3 );
               end;
            Assign ( WorkFile3, (XPath + '\' + FileDept + '.DAT'));
            Rename ( WorkFile3, (XPath + '\' + FileDept + '.WRK'));
	    {$I-}
            Reset  ( WorkFile3 );
            {$I+}
            If IOResult = 0 then
               begin
                 Assign ( DeptFile, (XPath + '\' + FileDept + '.DAT'));
                 {$I-}
                 Reset ( DeptFile );
                 {$I+}
                 If IOResult <> 0 then
                    begin
                      ReWrite ( DeptFile );
                      Reset   ( DeptFile );
                    end;
                 GotoXY(4,14); Write('Departamentos  ');
                 I := -1;
                 R := 0;
                 D := 0;
                 CMstMember.NDeptos := 0;
                 Repeat
                   I := I + 1;
                   GotoXY(24,14); Write((I + 1):4);
                   Seek ( WorkFile3, I          );
                   Read ( WorkFile3, DeptMember );
                   If DeptMember.Status in ['A','D'] then
                      begin
                        DeptNo := DeptMember.Chave;
                        SearchTree3 ( Root3 );
                        If RC = 'N' then
                           begin
                             R := FileSize(DeptFile);
                             GotoXY(41,14); Write((R + 1):4);
                             DeptNumber := R;
                             LoadTree3 ( Root3 );
                             ReadWrite(#05,'W','N',R);
                             CMstMember.NDeptos := CMstMember.NDeptos + 1;
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
            Close ( DeptFile  );
            Reset ( DeptFile  );
          end
          else CMstMember.NDeptos := 0;
       Reset ( EcoFile );
       If FileSize(EcoFile) > 0 then
          begin
            GotoXY(4,15); Write('Indices Econ“micos');
            I := -1;
            Repeat
              I := I + 1;
              GotoXY(24,15); Write((I + 1):4);
              ReadWrite(#12,'R','N',I);
              If RW = 'S' then
                 begin
                   IINo := EcoMember.Ano + '#' + EcoMember.Chave;
                   SearchTree7 ( Root7 );
                   If RC = 'N' then
                      begin
                        GotoXY(41,15); Write((I + 1):4);
                        IINumber := I;
                        LoadTree7 ( Root7 );
                        ShowHeap;
                        Color(Tfn,Ttx);
                      end;
                 end;
            Until (I + 1) = FileSize(EcoFile);
            Close ( EcoFile  );
            Reset ( EcoFile  );
          end;
       Reset ( HsPdFile );
       If FileSize(HsPdFile) > 0 then
          begin
            GotoXY(4,16); Write('Hist¢rico Padr„o ');
            MasterMember.NHistorico := 0;
            I                       := -1;
            Repeat
              I := I + 1;
              ReadWrite(#10,'R','N',I);
              If RW = 'S' then
                 begin
                   If HsPdMember.CodigoH <> '' then
                      begin
                        HHNo     := HsPdMember.CodigoH;
                        HHNumber := I;
                        LoadTree8 ( Root8 );
                      end;
                   GotoXY(24,16); Write(I+1:4);
                   MasterMember.NHistorico := MasterMember.NHistorico + 1;
                   GotoXY(41,16); Write(I+1:4);
                 end;
            Until (I + 1) = FileSize(HsPdFile);
          end;
       Reset ( ExpeFile );
       If FileSize(ExpeFile) > 0 then
          begin
            I  := -1;
            Repeat
              I := I + 1;
              ReadWrite(#07,'R','N',I);
              If RW = 'S' then
                 begin
                   DeptNo := LimpaChave(ExpeMember.Depto);
                   SearchTree3 ( Root3 );
                   If RC = 'S' then
                      begin
                        ExpeNo     := DeptNo + '#' +
                                      LimpaChave(ExpeMember.Conta);
                        ExpeNumber := I;
                        LoadTree5 ( Root5 );
                        ShowHeap;
                        Color(Tfn,Ttx);
                      end;
                 end;
            Until (I + 1) = FileSize(ExpeFile);
          end;
       Reset ( LctoFile );
       If FileSize(LctoFile) > 0 then
          With LctoMember do
          begin
            Close ( LctoFile );
            Assign( WorkFile5, (XPath + '\' + FileLcto + AAFx + '.WRK' ));
            {$I-}
            Reset ( WorkFile5 );
            {$I+}
            If IOResult = 0 then
               begin
                 Close ( WorkFile5 );
                 Erase ( WorkFile5 );
               end;
            Assign ( WorkFile5, (XPath + '\' + FileLcto + AAFx + '.' + MMFx ));
            Rename ( WorkFile5, (XPath + '\' + FileLcto + AAFx + '.WRK'));
	    {$I-}
            Reset   ( WorkFile5 );
            {$I+}
            If IOResult = 0 then
               begin
                 Assign ( LctoFile, (XPath + '\' + FileLcto + AAFx + '.' + MMFx ));
                 {$I-}
                 Reset  ( LctoFile );
                 {$I+}
                 If IOResult <> 0 then
                    begin
                      ReWrite ( LctoFile );
                      Reset   ( LctoFile );
                    end;
                 GotoXY(4,17); Write('Lan‡amentos    ');
                 I := -1;
                 R := 0;
                 D := 0;
                 Repeat
                   I := I + 1;
                   GotoXY(24,17); Write((I + 1):4);
                   Seek ( WorkFile5, I          );
                   Read ( WorkFile5, LctoMember );
                   LoteNo := LctoMember.Lote;
                   SearchTree2 ( Root2 );
                   If RC = 'S' then
                      begin
                        ContaNo := LimpaChave(LctoMember.Conta);
                        SearchTree1 ( Root1 );
                        If (RC = 'S') and (LctoMember.MesLancto = MM) then
                           begin
                             R          := FileSize(LctoFile);
                             CDVSNo     := ContaNo                        + '#' +
                                           Copy(LctoMember.OrigData,1,2)  + '#' +
                                           LctoMember.Lote                + '#' +
                                           LctoMember.SeqLote;
                             CDVSNumber := R;
                             LoadTree4 ( Root4 );
                             ReadWrite(#08,'W','N',R);
                             ReadWrite(#06,'R','N',ContaNumber);
                             SaldMember.NLanctos[MM] := SaldMember.NLanctos[MM] + 1;
                             ReadWrite(#06,'W','N',ContaNumber);
                             GotoXY(41,17); Write((R + 1):4);
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
            Close ( LctoFile  );
            Reset ( LctoFile  );
          end;
       ReadWrite(#00,'W','N',0);
       ReadWrite(#16,'W','N',0);
       DI := 'S';
       DL := 'S';
       DM := 'S';
       Color(Blue,White);
       GotoXY(1,23); Write(' ':80);
       GotoXY(2,23); Write('O Banco de Dados est  Reorganizado');
     end
     else begin
            DI := 'N';
            DL := 'N';
            DM := 'N';
            Color(Blue,White);
            GotoXY(1,23); Write(' ':80);
            GotoXY(2,23); Write('N„o consegui Reorganizar o Banco de Dados');
          end;
  LoadCmpy;
  TeclaReturn;
  LimpaLn(23,Tfd);
  DescarregaI;
  DescarregaL;
  DescarregaM;
end;


Procedure ReorganizaM;
Var
  Ax       : Str2;
begin
  Color(Bfn,Btx);
  GotoXY(3,10); Write(' Entidade           Lidos    Excl.   Carreg      ');
  Color(Tfn,Ttx);
  {$I-}
  ChDir ( XDrive );
  {$I+}
  If IOResult =  0 then
     begin
       RootB := NIL;
       Root0 := NIL;
       Root7 := NIL;
       Root8 := NIL;
       Release(HeapOrg);
       ShowHeap;
       Color(Tfn,Ttx);
       ReadWrite(#00,'R','N',0);
       If FileSize(CmpyFile) > 0 then
          begin
            Color(Red,White);
            GotoXY(1,24); Write(ConstStr(' ',80));
            GotoXY(2,24); Write('Quer excluir as Empresas marcadas com X (    ou    ): ');
            Color(Red,Yellow);
            GotoXY(43,24); Write('Sim');
            GotoXY(50,24); Write('N„o');
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
            Assign( WorkFileX, (XDrive + '\ALOGCMPY.WRK' ));
            {$I-}
            Reset ( WorkFileX );
            {$I+}
            If IOResult = 0 then
               begin
                 Close ( WorkFileX );
                 Erase ( WorkFileX );
               end;
            Assign ( WorkFileX, (XDrive + '\ALOGCMPY.DAT' ));
            Rename ( WorkFileX, (XDrive + '\ALOGCMPY.WRK' ));
            {$I-}
            Reset   ( WorkFileX );
            {$I+}
            If IOResult = 0 then
               begin
                 Assign ( CmpyFile, (XDrive + '\ALOGCMPY.DAT' ));
                 {$I-}
                 Reset  ( CmpyFile );
                 {$I+}
                 If IOResult <> 0 then
                    begin
                      ReWrite ( CmpyFile );
                      Reset   ( CmpyFile );
                    end;
                 GotoXY(4,12); Write('Empresas');
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
       If FileSize(HsPdFile) > 0 then
          begin
            Close ( HsPdFile );
            Assign( WorkFile6, (XDrive + '\' + FileHsPd + '.WRK' ));
            {$I-}
            Reset ( WorkFile6 );
            {$I+}
            If IOResult = 0 then
               begin
                 Close ( WorkFile6 );
                 Erase ( WorkFile6 );
               end;
            Assign ( WorkFile6, (XDrive + '\' + FileHsPd + '.DAT'));
            Rename ( WorkFile6, (XDrive + '\' + FileHsPd + '.WRK'));
	    {$I-}
            Reset  ( WorkFile6 );
            {$I+}
            If IOResult = 0 then
               begin
                 Assign ( HsPdFile, (XDrive + '\' + FileHsPd + '.DAT'));
                 {$I-}
                 Reset ( HsPdFile );
                 {$I+}
                 If IOResult <> 0 then
                    begin
                      ReWrite ( HsPdFile );
                      Reset   ( HsPdFile );
                    end;
                 GotoXY(4,14); Write('Hist¢ricos     ');
                 I := -1;
                 R := 0;
                 D := 0;
                 MasterMember.NHistorico := 0;
                 Repeat
                   I := I + 1;
                   GotoXY(24,14); Write((I + 1):4);
                   Seek ( WorkFile6, I          );
                   Read ( WorkFile6, HsPdMember );
                   If HsPdMember.Status = 'A' then
                      begin
                        HHNo := HsPdMember.CodigoH;
                        SearchTree8 ( Root8 );
                        If RC = 'N' then
                           begin
                             R := FileSize(HsPdFile);
                             GotoXY(41,14); Write((R + 1):4);
                             HHNumber := R;
                             LoadTree8 ( Root8 );
                             ReadWrite(#10,'W','N',R);
                             MasterMember.NHistorico := MasterMember.NHistorico + 1;
                             ShowHeap;
                             Color(Tfn,Ttx);
                           end;
                      end
                      else begin
                             D := D + 1;
                             GotoXY(32,14); Write(D:4);
                           end;
                 Until (I + 1) = FileSize(WorkFile6);
                 Close ( WorkFile6 );
                 Erase ( WorkFile6 );
               end;
            Close ( HsPdFile  );
            Reset ( HsPdFile  );
          end
          else MasterMember.NHistorico := 0;
       If FileSize(EcoFile) > 0 then
          begin
            GotoXY(4,15); Write('Indices Econ“micos');
            MasterMember.NIndices := 0;
            I                     := -1;
            Repeat
              I := I + 1;
              GotoXY(24,15); Write((I + 1):4);
              ReadWrite(#12,'R','N',I);
              If RW = 'S' then
                 begin
                   IINo := EcoMember.Ano + '#' + EcoMember.Chave;
                   SearchTree7 ( Root7 );
                   If RC = 'N' then
                      begin
                        MasterMember.NIndices := MasterMember.NIndices + 1;
                        GotoXY(41,15); Write((I + 1):4);
                        IINumber := I;
                        LoadTree7 ( Root7 );
                        ShowHeap;
                        Color(Tfn,Ttx);
                      end;
                 end;
            Until I = FileSize(EcoFile);
          end;
     end;
end;

end.