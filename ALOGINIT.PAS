{$O+,F+}
Unit AlogInit;

Interface

Uses Crt,Dos,AlogGlbs,AlogNavg,AlogBasP;


   Procedure OpenFiles;
   Procedure CloseFiles;
   Procedure LoadCmpy;
   Procedure LoadBlkSta;
   Procedure LoadEcoI;
   Procedure LoadHist;
   Procedure LoadIndex;
   Procedure LoadLote;
   Procedure LoadExpe;
   Procedure LoadLcto;
   Procedure TrocaLcto;
   Procedure TrocaSaldo;
   Procedure TrocaExpe;
   Procedure TrocaLote;
   Procedure TrocaMesAno;
   Procedure DescarregaI;
   Procedure DescarregaL;
   Procedure DescarregaM;
   Procedure CalculoBase (Prodt : Str6;
                          Campo : Str80);
   Procedure InitialScreen(Var SName  : Str6;
                               X      : Char);
   Procedure ScreenHeader (Var SName  : Str6;
                               UName  : Str40;
                               X      : Char);
   Procedure EntryPassword(P : Char);
   Procedure Drive;
   Procedure EntryPswCia;
   Procedure MainScreenFrame(X1,X2 : Str80);
   Procedure MainScreenTitle1(T : Integer);
   Procedure MainScreenTitle2(T : Integer);
   Procedure MainScreenTitle3(T : Integer);
   Procedure BuildFrame(X : Char);
   Procedure ConfigPrinter;
   Procedure ColorSetUp;
   Procedure ShowLicenciamento;
   Procedure MostraPrinter;
   Procedure InicializaI;
   Procedure Reseta;
   Procedure ReCarrega;
   Procedure SelecionaDrive;

Implementation

{$I AlogOpen.inc }
{$I AlogClos.inc }
{$I Login.rot    }
{$I Base.rot     }
{$I BuildFra.rot }
{$I ConfigPr.rot }
{$I ColorSet.rot }
{$I ShowLic.rot  }

Procedure LoadCmpy;
begin
  MasterMember.NEmpresas := 0;
  I                      := -1;

  If FileSize(CmpyFile) > 0 then
     begin
       Repeat
         I := I + 1;
         ReadWrite(#02,'R','N',I);
         If RW = 'S' then
            begin
              CmpyNo     := CmpyMember.Chave;
              CmpyNumber := I;
              LoadTree0 ( Root0 );
              MasterMember.NEmpresas := MasterMember.NEmpresas + 1;
            end;
       Until (I + 1) = FileSize(CmpyFile);
     end;
  ReadWrite(#00,'W','N',0);
end;

Procedure LoadBlkSta;
begin
  I := -1;
  If FileSize(BlkStaFile) > 0 then
     begin
       Repeat
         I := I + 1;
         ReadWrite(#17,'R','N',I);
         If RW = 'S' then
            begin
              BlkNo     := BlkStaMember.Cia + '#' + BlkStaMember.MesAno;
              BlkNumber := I;
              LoadTreeB ( RootB );
            end;
       Until (I + 1) = FileSize(BlkStaFile);
     end;
end;

Procedure LoadEcoI;
begin
  I := -1;
  If FileSize(EcoFile) > 0 then
     Repeat
       I := I + 1;
       ReadWrite(#12,'R','N',I);
       If RW = 'S' then
          begin
            IINo     := EcoMember.Ano + '#' + EcoMember.Chave;
            IINumber := I;
            LoadTree7 ( Root7 );
          end;
     Until (I + 1) = FileSize(EcoFile);
end;


Procedure LoadHist;
begin
  I := -1;
  If FileSize(HsPdFile) > 0 then
     Repeat
       I := I + 1;
       ReadWrite(#10,'R','N',I);
       If RW = 'S' then
          begin
            HHNo     := HsPdMember.CodigoH;
            HHNumber := I;
            LoadTree8 ( Root8 );
          end;
     Until (I + 1) = FileSize(HsPdFile);
end;


Procedure LoadIndex;
begin
  If FileSize(IndXFile) > 0 then
     With IndXMember do
     begin
       I := -1;
       Repeat
         I := I + 1;
         ReadWrite(#13,'R','N',I);
         If RW = 'S' then
            begin
              XR := 0;
              Repeat
                XR := XR + 1;
                Case TipoX[XR] of
                     '1' : begin
                             ContaNo     := ChaveX[XR];
                             ContaNumber := RelAddrX[XR];
                             LoadTree1 ( Root1 );
                           end;
                     '3' : begin
                             DeptNo     := ChaveX[XR];
                             DeptNumber := RelAddrX[XR];
                             LoadTree3 ( Root3 );
                           end;
                end;
              Until XR = 23;
            end;
       Until (I + 1) = FileSize(IndXFile);
     end;
end;


Procedure LoadLote;
begin
  If FileSize(IndLFile) > 0 then
     With IndLMember do
     begin
       I := -1;
       Repeat
         I  := I + 1;
         XR := 0;
         ReadWrite(#14,'R','N',I);
         If RW = 'S' then
            Repeat
              XR := XR + 1;
              If ChaveX[XR] <> '' then
                 begin
                   LoteNo     := ChaveX[XR];
                   LoteNumber := RelAddrX[XR];
                   LoadTree2 ( Root2 );
                 end;
            Until XR = 64;
       Until (I + 1) = FileSize(IndLFile);
     end;
end;


Procedure LoadExpe;
begin
  I := -1;
  If FileSize(ExpeFile) > 0 then
     With ExpeMember do
     Repeat
       I := I + 1;
       ReadWrite(#07,'R','N',I);
       If RW = 'S' then
          begin
            ExpeNo     := LimpaChave(Depto) + '#' + LimpaChave(Conta);
            ExpeNumber := I;
            LoadTree5 ( Root5 );
          end;
     Until (I + 1) = FileSize(ExpeFile);
end;


Procedure LoadLcto;
begin
  I := -1;
  If FileSize(IndMFile) > 0 then
     With IndMMember do
     Repeat
       K := 0;
       I := I + 1;
       ReadWrite(#15,'R','N',I);
       If RW = 'S' then
           Repeat
            K := K + 1;
            If ChaveX[K] <> '' then
               begin
                 CDVSNo     := ChaveX[K];
                 CDVSNumber := RelAddrX[K];
                 LoadTree4 ( Root4 );
               end;
           Until K = 14;
     Until (I + 1) = FileSize(IndMFile);
end;


Procedure TrocaLcto;
begin
  Close ( LctoFile );
  Assign( LctoFile,   (XPath + '\' + FileLcto  + AAFx + '.' + MMFx ));
  Assign( IndMFile,   (XPath + '\' + FileLcto  + AAFx + '.' + IIFx ));
  {$I-}
  Reset ( LctoFile );
  {$I+}
  If IOResult <> 0 then
     begin
       ReWrite ( LctoFile );
       Reset   ( LctoFile );
     end;
  If Root4 <> NIL then Dispose4 (Root4);
  If Root6 <> NIL then Dispose6 (Root6);
  Root4 := NIL;
  Root6 := NIL;
  {$I-}
  Reset ( IndMFile );
  {$I+}
  If IOResult = 0 then LoadLcto
                  else ReWrite ( IndMFile );
  Close ( IndMFile );
end;


Procedure TrocaSaldo;
begin
  Close ( SaldFile );
  Assign( SaldFile, (XPath + '\' + FileSald  + AAFx + '.DAT'));
  {$I-}
  Reset ( SaldFile );
  {$I+}
  If IOResult <> 0 then
     begin
       ReWrite ( SaldFile );
       Reset   ( SaldFile );
     end;
  If FileSize(SaldFile) < FileSize(ContaFile) then
     begin
       SaldMember.Status := 'A';
       For I := 1 to 12 do begin
                             SaldMember.Abertura[I] := 0;
                             SaldMember.Debitos[I]  := 0;
                             SaldMember.Creditos[I] := 0;
                             SaldMember.Saldo[I]    := 0;
                             SaldMember.SaldoB[I]   := 0;
                             SaldMember.NLanctos[I] := 0;
                           end;
       Repeat
         I := FileSize(SaldFile);
         ReadWrite(#06,'W','N',I);
       Until FileSize(SaldFile) = FileSize(ContaFile);
     end;
end;


Procedure TrocaExpe;
begin
  If Root5 <> NIL then Dispose5 (Root5);
  Root5 := NIL;
  Close ( ExpeFile );
  Assign( ExpeFile, (XPath + '\' + FileExpe  + AAFx + '.DAT'));
  {$I-}
  Reset ( ExpeFile );
  {$I+}
  If IOResult <> 0 then
     begin
       ReWrite ( ExpeFile );
       Reset   ( ExpeFile );
     end
     else LoadExpe;
end;


Procedure TrocaLote;
begin
  If Root2 <> NIL then Dispose2 (Root2);
  Root2 := NIL;
  Close ( LoteFile );
  Assign( LoteFile, (XPath + '\' + FileLote  + AAFx + '.DAT'));
  Assign( IndLFile, (XPath + '\' + FileLote  + AAFx + '.IDX'));
  {$I-}
  Reset ( LoteFile );
  {$I+}
  If IOResult <> 0 then
     begin
       ReWrite ( LoteFile );
       Reset   ( LoteFile );
     end;
  {$I-}
  Reset ( IndLFile );
  {$I+}
  If IOResult = 0 then LoadLote
                  else ReWrite ( IndLFile );
  Close ( IndLFile );
end;


Procedure TrocaMesScreen;
begin
  For I := 1 to 12 do begin
                        If I = M then Color(Bfn,Btx)
                                 else Color(Sfn,Stx);
                        GotoXY(32,(I+6)); Write(' ',PushLeft(10,ArrayMesEx[I]));
                      end;
  Color(Tfn,Ttx);
end;


Procedure TrocaMesAno;
begin
  M  := MM;
  A  := AA;

  DrawBox(32,6,42,18,Sfn,'S');
  Color(Tfn,Ttx);
  GotoXY(32,6);  Write('    Màs    ');
  TrocaMesScreen;
  Repeat
    Repeat
      TC := ReadKey;
      If (TC = #0   ) and
         (KeyPressed) then
         begin
           TC := ReadKey;
           Case TC of
                #72 : begin
                        M := M - 1;
                        If M < 1 then M := 12;
                        TrocaMesScreen;
                      end;
                #80 : begin
                        M := M + 1;
                        If M > 12 then M := 1;
                        TrocaMesScreen;
                      end;
           end;
         end;
    Until (TC = #27) or (TC = #13);
    If TC = #13 then Confirma;
  Until (TC = #27) or (TC = 'S');
  If TC = 'S' then
     begin
       DrawBox(50,10,62,12,Sfn,'S');
       Color(Sfn,Stx);
       GotoXY(51,11); Write('Ano..:');
       Repeat
         Repeat
           If A = 0 then J := ''
                    else begin
                           Str(A:4,J);
                           J := LeftAdjust(J);
                         end;
           InputStr(J,4,58,11,0,'S','N','T','N',Sfn,Stx);
           If TC <> #27 then Val(J,A,E);
         Until (TC = #27) or (TC = #13);
         If TC = #13 then Confirma;
       Until (TC = #27) or (TC = 'S');
       If XCondicional[1] <> '#' then
          begin
            J := QQStr(M,2,'0') + QQStr(A,4,'0');
            If (J <> Copy(XCondicional,1,4)) and
               (J <> Copy(XCondicional,5,4)) then TC := #27;
          end;
       If (TC                   = 'S' ) and
          ((CMstMember.MesAtivo <> M )  or
           (CMstMember.AnoAtivo <> A )) then
          begin
            CMstMember.MesAtivo := M;
            CMstMember.AnoAtivo := A;
            ReadWrite(#16,'W','N',0);
            Str(M:2,J);
            J := LeftAdjust(J);
            If Length(J) = 1 then J := '0' + J;
            MMFx := 'M' + J;
            IIFx := 'I' + J;
            Str(A:2,J);
            J := LeftAdjust(J);
            If Length(J) = 1 then J := '0' + J;
            AAFx := J;
            Color(Bfn,(White + Blink));
            GotoXY(01,24); Write(' Aguarde ');
            TrocaLcto;
            If AA <> A then
               begin
                 TrocaSaldo;
                 TrocaExpe;
                 TrocaLote;
               end;
            MM   := M;
            AA   := A;
            Vez  := 'S';
            VezD := 'S';
            VezR := 'S';
            Move(ScArray1[1],MemW[$B800:0000],4000);
            ShowMes;
            Move(MemW[$B800:0000],ScArray1[1],4000);
            Color(Tfn,Utx);
          end;
     end;
end;


Procedure DescarregaI;
begin
  If DI = 'S' then
     begin
       {$I-}
       Erase ( IndXFile );
       {$I+}
       If IOResult = 0 then ReWrite ( IndXFile );
       {$I-}
       Reset   ( IndXFile );
       {$I+}
       If IOResult = 0 then
          begin
            Color(Blue,White);
            ClrScr;
            GotoXY(17,12);
            Write('Descarregando Arquivo Indice (( 1 ))  Aguarde');
            Color(Tfn,Utx);
            For XR := 1 to 23 do begin
                                   IndXMember.TipoX[XR]    := 'X';
                                   IndXMember.ChaveX[XR]   := '';
                                   IndXMember.RelAddrX[XR] := 0;
                                 end;
            XR := 0;
            UnLoadTree1 ( Root1 );
            UnLoadTree3 ( Root3 );
            If XR > 0 then
               begin
                 XR := 23;
                 UnloadIndex;
               end;
            Close ( IndXFile );
            DI := 'N';
          end
          else begin
                 Color(Blue,Black);
                 GotoXY(01,23);  Write(ConstStr(' ',80));
                 GotoXY(02,23);  Write('NÑo estou conseguindo descarregar o Indice dos Mestres..');
                 TeclaReturn;
                 LimpaLn(23,Tfd);
               end;
     end;
end;


Procedure DescarregaL;
begin
  If DL = 'S' then
     begin
       {$I-}
       Erase ( IndLFile );
       {$I+}
       If IOResult = 0 then ReWrite ( IndLFile );
       {$I-}
       Reset   ( IndLFile );
       {$I+}
       If IOResult = 0 then
          begin
            Color(Red,White);
            ClrScr;
            GotoXY(17,12);
            Write('Descarregando Arquivo Indice (( 2 ))  Aguarde');
            Color(Tfn,Utx);
            For XR := 1 to 64 do begin
                                   IndLMember.ChaveX[XR]   := '';
                                   IndLMember.RelAddrX[XR] := 0;
                                 end;
            XR := 0;
            UnLoadTree2 ( Root2 );
            If XR > 0 then
               begin
                 XR := 64;
                 UnloadIndexL;
               end;
            Close ( IndLFile );
            DL := 'N';
          end
          else begin
                 Color(Blue,Black);
                 GotoXY(01,23);  Write(ConstStr(' ',80));
                 GotoXY(02,23);  Write('NÑo estou conseguindo descarregar o Indice de Lote.');
                 TeclaReturn;
                 LimpaLn(23,Tfd);
               end;
     end;
end;


Procedure DescarregaM;
begin
  If DM = 'S' then
     begin
       {$I-}
       Erase ( IndMFile );
       {$I+}
       If IOResult = 0 then ReWrite ( IndMFile );
       {$I-}
       Reset   ( IndMFile );
       {$I+}
       If IOResult = 0 then
          begin
            Color(Green,White);
            ClrScr;
            GotoXY(17,12);
            Write('Descarregando Arquivo Indice (( 3 ))  Aguarde');
            Color(Tfn,Utx);
            For XR := 1 to 14 do begin
                                   IndMMember.ChaveX[XR]   := '';
                                   IndMMember.RelAddrX[XR] := 0;
                                 end;
            XR := 0;
            UnLoadTree4 ( Root4 );
            If XR > 0 then
               begin
                 XR := 14;
                 UnloadIndexM;
               end;
            Close ( IndMFile );
            DM := 'N';
          end
          else begin
                 Color(Blue,Black);
                 GotoXY(01,23);  Write(ConstStr(' ',80));
                 GotoXY(02,23);  Write('NÑo estou conseguindo descarregar o Indice de Movimento.');
                 TeclaReturn;
                 LimpaLn(23,Tfd);
               end;
     end;
end;

Procedure MostraPrinter;
begin
  Color(Red,Yellow);
  GotoXY(59,6); Write('Prt ');
  Color(Red,White);
  GotoXY(65,6); Write(XPrinter);
end;


Procedure InicializaI;
begin
  Dx       := MasterMember.Don;
  Df       := MasterMember.Dof;
  Cx       := MasterMember.Con;
  Cf       := MasterMember.Cof;
  Nx       := MasterMember.Non;
  Nf       := MasterMember.Nof;
  QP       := MasterMember.Qpa;
  Laser    := MasterMember.LJet;
  XPrinter := MasterMember.TipoImpr;
  Bfn      := MasterMember.BfnO;
  Btx      := MasterMember.BtxO;
  Tfn      := MasterMember.TfnO;
  Ttx      := MasterMember.TtxO;
  Sfn      := MasterMember.SfnO;
  Stx      := MasterMember.StxO;
  Utx      := MasterMember.UtxO;
  Tfd      := MasterMember.TfdO;
end;

Procedure Reseta;
begin
  Vez     := 'S';
  VezD    := 'S';
  VezR    := 'S';
  DI      := 'N';
  DL      := 'N';
  DM      := 'N';
  Limite  := 32000;
  XDir    := '';
  MF      := 'N';
  XSt     := '*';
  OpMn    := 'N';
end;

Procedure ReCarrega;
begin
  Reset ( OwnerFile  );
  Reset ( MasterFile );
  Reset ( HsPdFile   );
  Reset ( EcoFile    );
  Reset ( CmpyFile   );
  Reset ( BlkStaFile );
  LoadHist;
  LoadEcoI;
  LoadCmpy;
  LoadBlkSta;
end;

Procedure SelecionaDrive;
Var
  DriveAnt  : Str40;
begin
  Vez     := 'S';
  VezD    := 'S';
  VezR    := 'S';
  DI      := 'N';
  DL      := 'N';
  DM      := 'N';
  Limite  := 32000;
  XDir    := '';
  MF      := 'N';
  XSt     := '*';
  OpMn    := 'N';
  XDrive  := XDriveP;

  DriveAnt := XDrive;
  Repeat
    Drive;
    XDriveP := XDrive;
    If TC <> #27 then
       begin
         XDrive := XDrive + '\ALOGDATA';
         Assign( OwnerFile,  (XDrive + '\' + FileOwner ));
         {$I-}
         Reset ( OwnerFile );
         {$I+}
         If IOResult <> 0 then
            begin
              ErroMsg := 'N∆o encontrei os arquivos, tente outra vez.';
              ErrorMessage;
              XDrive := DriveAnt;
              Move(ScArrayM[1],MemW[$B800:0000],4000);
            end
            else With OwnerMember do
                 begin
                   ReadWrite(#01,'R','N',0);
                   CalculoBase(XSystem,RSocial);
                   If (NBase   = NBaseC ) and
                      (Produto = XSystem) then
                      begin
                        If OwnerMember.Versao <> XVersao then
                           begin
                             Close ( OwnerFile );
                             ErroMsg := 'A vers∆o do sistema n∆o Ç compat°vel com os dados.';
                             ErrorMessage;
                             XDrive := DriveAnt;
                             Move(ScArrayM[1],MemW[$B800:0000],4000);
                           end;
                      end
                      else begin
                             Close ( OwnerFile );
                             TC := #27;
                            { Write(NBase,' ',NBaseC,'   ',Produto,' ',XSystem); }
                            { TC := ReadKey;}
                           end;
                 end;
       end
       else If PrimeiraVez = 'N' then TC := #00;
  Until TC in ['S',#27];
  If TC = 'S' then
     begin
       XMarca := OwnerMember.Marca;
       Assign( MasterFile,  (XDrive + '\' + FileMaster));
       {$I-}
       Reset ( MasterFile );
       {$I+}
       If IOResult <> 0 then
          With MasterMember do
          begin
            ReWrite   ( MasterFile );
            PassWord   := '*';
            NEmpresas  := 0;
            NIndices   := 0;
            NHistorico := 0;
            Don        := #14;
            Dof        := #20;
            Con        := #15;
            Cof        := #18;
            Non        := #71;
            Nof        := #72;
            Qpa        := #12;
            BfnO       := 2;
            BtxO       := 0;
            TfnO       := 1;
            TtxO       := 14;
            SfnO       := 3;
            StxO       := 0;
            UtxO       := 15;
            TfdO       := 7;
            LJet       := 'N';
            TipoImpr   := 'EPSON';
            DataBkp    := '';
            ReadWrite(#00,'W','N',0);
            MF := 'S';
          end
          else MF := 'N';

       ReadWrite(#00,'R','N',0);

       InicializaI;
       MostraPrinter;

       Assign( HsPdFile,   (XDrive + '\' + FileHsPd + '.DAT'));
       Assign( EcoFile,    (XDrive + '\' + FileEco  + '.DAT'));
       {$I-}
       Reset ( HsPdFile );
       {$I+}
       If IOResult <> 0 then
          begin
            ReWrite ( HsPdFile );
            Reset   ( HsPdFile );
          end;
       {$I-}
       Reset ( EcoFile );
       {$I+}
       If IOResult <> 0 then
          begin
            ReWrite ( EcoFile );
            Reset   ( EcoFile );
          end;
       Assign( CmpyFile,   (XDrive + '\' + FileCmpy ));
       {$I-}
       Reset ( CmpyFile );
       {$I+}
       If IOResult <> 0 then
          begin
            ReWrite ( CmpyFile );
            Reset   ( CmpyFile );
          end;
       Assign( BlkStaFile,   (XDrive + '\' + FileBlkSta ));
       {$I-}
       Reset ( BlkStaFile );
       {$I+}
       If IOResult <> 0 then
          begin
            ReWrite ( BlkStaFile );
            Reset   ( BlkStaFile );
          end;
       Close ( MasterFile );
       Close ( HsPdFile   );
       Close ( EcoFile    );
       Close ( CmpyFile   );
       Close ( BlkStaFile );

       Resp := #00;

       Close ( OwnerFile  );
     end
     else Resp := TC;
  PrimeiraVez := 'N';
end;



end.

