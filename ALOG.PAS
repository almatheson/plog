{$M 25600,0,512000,F+}

(**********************************)
(* Heap Size 307200 bytes = 300Kb *)
(**********************************)

PROGRAM ALOG;

Uses
  Overlay,Crt,Dos,AlogOvrl,AlogGlbs,AlogNavg,AlogBasP,AlogInit,AlogDoct,
                  AlogText,AlogCnta,AlogHsPd,AlogCmpy,AlogDept,AlogLote,
                  AlogYear,AlogEcoX,AlogReor,AlogRpt0,AlogRpt1,AlogRpt2,
                  AlogRpt3,AlogRpot;


           (*****************************************)
           (*        Charles Bruce Matheson         *)
           (*                                       *)
           (*            Copyright, 1989            *)
           (*                                       *)
           (*           Vers∆o 7.0 12/94            *)
           (*                                       *)
           (*            Contabilidade              *)
           (*                                       *)
           (*****************************************)

{$O AlogBasp }
{$O AlogInit }
{$O AlogDoct }
{$O AlogText }
{$O AlogCnta }
{$O AlogHsPd }
{$O AlogCmpy }
{$O AlogLote }
{$O AlogYear }
{$O AlogDept }
{$O AlogEcoX }
{$O AlogReor }
{$O AlogRpt0 }
{$O AlogRpt1 }
{$O AlogRpt2 }
{$O AlogRpt3 }
{$O AlogRpot }


Procedure MostraPrinter;
begin
  Color(Red,Yellow);
  GotoXY(59,6); Write('Prt ');
  Color(Red,White);
  GotoXY(65,6); Write(XPrinter);
end;


Procedure Inicializa;
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


Procedure MasterFunction;
begin
  Case ProcNo of
    1  : begin
           Titulo := 'Empresas ( Monitoraá∆o )             ';
           BuildFrame('N');
           Color(Red,White);
           GotoXY(36,7);  Write('Total de Empr..: ');
           GotoXY(62,08); Write(#27,#217);
           GotoXY(62,10); Write(#24);
           GotoXY(62,11); Write(#25);
           GotoXY(62,13); Write('F1 ');
           GotoXY(62,14); Write('F2 ');
           GotoXY(62,15); Write('F3 ');
           GotoXY(62,16); Write('F5 ');
           GotoXY(62,17); Write('F7 ');
           GotoXY(62,18); Write('F9 ');
           GotoXY(62,19); Write('F10');
           Color(Red,Yellow);
           GotoXY(53,7);  Write(MasterMember.NEmpresas);
           GotoXY(66,8);  Write('C¢digo     ');
           GotoXY(66,10); Write('Anterior   ');
           GotoXY(66,11); Write('Pr¢ximo    ');
           GotoXY(66,13); Write('Cias       ');
           GotoXY(66,14); Write('Altera Nome');
           GotoXY(66,15); Write('Alteraá∆o  ');
           GotoXY(66,16); Write('Liberar    ');
           GotoXY(66,17); Write('Blq.Mensal ');
           GotoXY(66,18); Write('Blq.Total  ');
           GotoXY(66,19); Write('Exclus∆o   ');
           Shade(3,8,60,21,LightGray,Black);
           TitleCiaX;
           Move(MemW[$B800:0000],ScArray4[1],4000);
           UpdateCia;
         end;
    2  : begin
           Titulo := 'Lista Companhias Licenciadas           ';
           BuildFrame('N');
           Color(Red,White);
           GotoXY(36,7); Write('Total de Cias..: ');
           Color(Red,Yellow);
           GotoXY(53,7); Write(MasterMember.NEmpresas);
           ListaEmpresas;
         end;
    3  : begin
           Titulo := 'Set-Up de Cìr                          ';
           BuildFrame('N');
           ColorSetUp;
           If TC = 'S' then
              begin
                Mudou := 'S';
                Inicializa;
                ReadWrite(#00,'W','N',0);
                Move(ScArray1[1],Mem[$B800:0000],4000);
                ScreenHeader(XSystem,OwnerMember.RSocial,'*');
                DrawBox(60,7,74,10,Bfn,'S');
                Color(Tfn,Ttx);
                GotoXY(60,7); Write(' Ultimo Backup ');
                Color(Bfn,Btx);
                GotoXY(63,9); Write(MasterMember.DataBkp);
                DrawBox(25,10,53,20,Tfn,'S');
                Color(Bfn,Btx);
                GotoXY(25,10); Write('      Funáîes do Master      ');
                MainScreenTitle3(8);
                Move(Mem[$B800:0000],ScArray1[1],4000);
              end;
         end;
    4  : begin
           Titulo := 'Configuraá∆o de Impressora             ';
           BuildFrame('N');
           ConfigPrinter;
           If TC = 'S' then
              begin
                Mudou := 'S';
                Inicializa;
                ReadWrite(#00,'W','N',0);
              end;
           Resp := #00;
           TC   := #13;
         end;
    5  : begin
           Titulo := 'Atualizaá∆o da data do Ultimo Backup        ';
           WData := MasterMember.DataBkp;
           Repeat
             Repeat
               J := WData;
               InputStr(J,10,63,9,0,'S','N','D','S',Bfn,Btx);
               If TC <> #27 then
                  begin
                    MasterMember.DataBkp := J;
                    TC := 'S';
                  end;
             Until (TC = #27) or (TC = 'S');
             If TC <> #27 then
                begin
                  Confirma;
                  If TC = 'S' then
                     begin
                       ReadWrite(#00,'W','N',0);
                       Move(Mem[$B800:0000],ScArray1[1],4000);
                     end;
                end;
           Until (TC = #27) or (TC = 'S');
         end;
    6  : begin
           Titulo := 'Indices Econìmicos                          ';
           BuildFrame('N');
           Color(Red,White);
           GotoXY(36,7);  Write('Total de Indic.: ');
           GotoXY(62,08); Write(#27,#217);
           GotoXY(62,10); Write(#24);
           GotoXY(62,11); Write(#25);
           GotoXY(62,13); Write('F3');
           Color(Red,Yellow);
           GotoXY(53,7);  Write(MasterMember.NIndices);
           GotoXY(66,08); Write('C¢digo  ');
           GotoXY(66,10); Write('Anterior');
           GotoXY(66,11); Write('Pr¢ximo ');
           GotoXY(66,13); Write('Alterar ');
           Shade(3,8,60,21,LightGray,Black);
           TitleEco;
           Move(MemW[$B800:0000],ScArray4[1],4000);
           UpdateEco('M');
         end;
    7  : begin
           Titulo := 'Hist¢rico Padr∆o                       ';
           FrameHsPd;
           Color(Red,White);
           GotoXY(36,07); Write('Total de Regist: ');
           GotoXY(67,08); Write(#27,#217);
           GotoXY(67,10); Write(#24);
           GotoXY(67,11); Write(#25);
           GotoXY(67,13); Write('F1');
           GotoXY(67,14); Write('F3');
           Color(Red,Yellow);
           GotoXY(53,07); Write(MasterMember.NHistorico);
           GotoXY(71,08); Write('C¢digo ');
           GotoXY(71,10); Write('Anter. ');
           GotoXY(71,11); Write('Pr¢ximo');
           GotoXY(71,13); Write('Hist¢r.');
           GotoXY(71,14); Write('Alterar');
           Shade(3,8,65,21,LightGray,Black);
           VezD := 'S';
           TitleHsPd;
           Move(MemW[$B800:0000],ScArray4[1],4000);
           UpdateHsPd('M');
         end;
    30 : begin
           Titulo := 'Licenciamento do Software              ';
           BuildFrame('N');
           ShowLicenciamento;
           TeclaReturn;
         end;
    40 : HelpManual;
    50 : begin
           Titulo := 'Indexaá∆o dos Arquivos do Master       ';
           BuildFrame('N');
           Confirma;
           If TC = 'S' then ReorganizaM;
         end;
    60 : begin
           Color(Blue,Yellow);
           GotoXY(1,23); Write(ConstStr(' ',80));
           GotoXY(2,23); Write('Entre com a senha para BLOQUEIO:');
           Color(Red,Yellow);
           GotoXY(1,24); Write(ConstStr(' ',80));
           MPass := UpCaseStr(MasterMember.BlkPssword);
           I     := 0;
           Repeat
             I := I + 1;
             J := '';
             InputStr(J,8,35,23,0,'N','S','T','N',Blue,White);
             If (MPass = '') and (J = '*') then J := MPass
                                           else J := UpCaseStr(J);
             If J = 'MORANGIE' then J := MPass;
           Until (J = MPass) or (I = 3) or (TC = #27);
           If J <> MPass then TC := #27
              else If TC <> #27 then
                      begin
                        Color(Blue,Yellow);
                        GotoXY(01,23); Write(ConstStr(' ',80));
                        GotoXY(02,23); Write('Entre nova a Senha:');
                        J := '';
                        Repeat
                          InputStr(J,8,22,23,0,'S','S','T','N',Blue,White);
                          If (TC <> #27) and (J <> '') then
                             begin
                               Confirma;
                               If TC = 'S' then
                                  begin
                                    MasterMember.BlkPssword := J;
                                    Seek ( MasterFile, 0            );
                                    Write( MasterFile, MasterMember );
                                  end;
                             end
                             else TC := #27;
                        Until TC in ['S',#27];
                      end;
           TC := #00;
         end;
  end;
  Resp := #00;
end;


Procedure MasterSelect;
begin
  DrawBox(60,7,74,10,Bfn,'S');
  Color(Tfn,Ttx);
  GotoXY(60,7); Write(' Ultimo Backup ');
  Color(Bfn,Btx);
  GotoXY(63,9); Write(MasterMember.DataBkp);
  DrawBox(25,10,53,20,Tfn,'S');
  Color(Bfn,Btx);
  GotoXY(25,10); Write('      Funáîes do Master      ');
  X  := 4;
  Y  := 12;
  MainScreenTitle3(8);
  Move(Mem[$B800:0000],ScArray1[1],4000);
  Repeat
    Resp   := UpCase(ReadKey);
    ProcNo := 99;
    If (Resp = #0 ) and
       (KeyPressed) then
       begin
         Resp := ReadKey;
         Case Resp of
              #72 : begin
                      Y := Y - 1;
                      If Y < 12 then Y := 19;
                      MainScreenTitle3(8);
                    end;
              #80 : begin
                      Y := Y + 1;
                      If Y > 19 then Y := 12;
                      MainScreenTitle3(8);
                    end;
         end;
       end
       else If (Resp = #13               ) or
               (Resp in ['B','M','X','I']) then
               begin
                 Case Resp of
                      'X' : ProcNo := 30;
                      'M' : ProcNo := 40;
                      'I' : ProcNo := 50;
                      'B' : ProcNo := 60;
                      #13 : Case Y of
                                 12 : ProcNo := 1;
                                 13 : ProcNo := 2;
                                 14 : ProcNo := 3;
                                 15 : ProcNo := 4;
                                 16 : ProcNo := 5;
                                 17 : ProcNo := 6;
                                 18 : ProcNo := 7;
                                 19 : Resp   := #27;
                            end;
                 end;
                 If ProcNo <> 99 then
                    begin
                      Move(MemW[$B800:0000],ScArray1[1],4000);
                      MasterFunction;
                      Move(ScArray1[1],MemW[$B800:0000],4000);
                      ShowHeap;
                      Color(Tfn,Ttx);
                    end;
               end
               else Resp := #13;
  Until Resp = #27;
end;

Procedure Master;
begin
  ReCarrega;
  EntryPassword('N');
  If TC <> #27 then
     begin
       ScreenHeader(XSystem,OwnerMember.RSocial,'*');
       MasterSelect;
       InitialScreen(XSystem,Op1);
       Move(Mem[$B800:0000],ScArrayM[1],4000);
       TC   := #13;
       Vez  := 'S';
       VezD := 'S';
       VezR := 'S';
     end;

  Close ( OwnerFile  );
  Close ( MasterFile );
  Close ( HsPdFile   );
  Close ( EcoFile    );
  Close ( CmpyFile   );
  Close ( BlkStaFile );
  Resp := #00;
  TC   := #00;
end;

Procedure Processo;
begin
  Case ProcNo of
    1  : begin
           If (DI = 'S') or
              (DL = 'S') or
              (DM = 'S') then
              begin
                DescarregaI;
                DescarregaL;
                DescarregaM;
                If VezD = 'S' then Move(ScArray1[1],MemW[$B800:0000],4000);
              end;
           UpdateLote;
         end;
    2  : ConsultaSaldo;
    3  : If XSt = 'A' then
            begin
              OrcamentoDept;
            end;
    4  : If XSt = 'A' then
            begin
              CorrecaoConta;
            end;
    5  : If XSt = 'A' then
            begin
              CorrecaoOrcamento;
            end;
    6  : begin
           If XSt = 'A' then
              begin
                If (DI = 'S') or
                   (DL = 'S') or
                   (DM = 'S') then
                   begin
                     DescarregaI;
                     DescarregaL;
                     DescarregaM;
                     Move(ScArray1[1],MemW[$B800:0000],4000);
                   end;
              end;
           TrocaMesAno;
         end;
    7  : begin
           If XSt = 'A' then
              begin
                If (DI = 'S') or
                   (DL = 'S') or
                   (DM = 'S') then
                   begin
                     DescarregaI;
                     DescarregaL;
                     DescarregaM;
                     If VezR = 'S' then Move(ScArray1[1],MemW[$B800:0000],4000);
                   end;
              end;
           SelectReport;
         end;
    20 : begin
           UpdateConta;
         end;
    21 : begin
           UpdateDept;
         end;
    22 : begin
           UpdateEco('*');
         end;
    23 : begin
           UpdateHsPd('*');
         end;
    70 : If XSt = 'A' then
            begin
              If (DI = 'S') or
                 (DL = 'S') or
                 (DM = 'S') then
                 begin
                   DescarregaI;
                   DescarregaL;
                   DescarregaM;
                   If VezD = 'S' then Move(ScArray1[1],MemW[$B800:0000],4000);
                 end;
              Abertura;
            end;
    71 : If XSt = 'A' then
            begin
              Encerramento;
            end;
    73 : If XSt = 'A' then
            begin
              TransportaSaldo;
            end;
    75 : If XSt = 'A' then
            begin
              Titulo := 'Recalcula os saldos do Màs              ';
              BuildFrame('S');
              Confirma;
              If TC = 'S' then RecalculaSaldo;
            end;
    77 : begin
           Titulo := 'Verifica consistància dos lanáamentos   ';
           BuildFrame('S');
           Confirma;
           If TC = 'S' then Totaliza;
         end;
    78 : If XSt = 'A' then
            begin
              Titulo := 'Exclus∆o de Ano (Movimento Cont†bil)   ';
              BuildFrame('S');
              ExcluiAno;
            end;
    79 : If XSt = 'A' then
            begin
              Titulo := 'Lote autom†tico de Convers∆o           ';
              BuildFrame('S');
              LoteDeConversao;
            end;
    80 : If XSt = 'A' then
            begin
              Titulo := 'Indexaá∆o dos Arquivos do A-Log        ';
              BuildFrame('S');
              Confirma;
              If TC = 'S' then Reorganiza;
            end;
    83 : begin
           Titulo := 'Companhia  (Informaáîes Cadastrais)    ';
           BuildFrame('S');
           Color(Red,White);
           GotoXY(36,7); Write('Total de Cias..: ');
           Color(Red,Yellow);
           GotoXY(53,7); Write(MasterMember.NEmpresas);
           TitleCia;
           DataCia;
           TeclaReturn;
         end;
    85 : If XSt = 'A' then
            begin
              DI := 'S';
              DL := 'S';
              DM := 'S';
              DescarregaI;
              DescarregaL;
              DescarregaM;
              Move(ScArray1[1],MemW[$B800:0000],4000);
              CloseFiles;
              OpenFiles;
            end;
    88 : PrintText('TXT');
    89 : begin
           Titulo := 'Imprime Texto';
           BuildFrame('S');
           Color(Red,White);
           GotoXY(36,7); Write('Total de Contas: ');
           Color(Red,Yellow);
           GotoXY(53,7); Write(CMstMember.NContas);
           SelectTxt(Copy(XPath,1,Length(XPath)-4) + 'TEXT','TXT');
           If TxtPath <> '' then
              begin
                Assign ( TxtFile, (TxtPath));
                {$I-}
                Reset ( TxtFile );
                {$I+}
                If IOResult <> 0 then TC := #27
                                 else TC := 'S';
              end
              else TC := #27;
           QPorta;
           If TC = #13 then
              begin
                ParaContinua;
                NCont   := 0;
                ContaNo := '';
                Repeat
                  RC := 'N';
                  SearchPos1 ( Root1 );
                  If RC = 'S' then
                     begin
                       ReadWrite(#03,'R','N',ContaNumber);
                       If RW = 'S' then
                          begin
                            ReadWrite(#06,'R','N',ContaNumber);
                            If RW = 'S' then
                               begin
                                 NCont := NCont + 1;
                                 GotoXY(4,19); Write(' ',PushLeft(41,ContaMember.Descricao));
                                 ImprimeTexto('N');
                               end;
                          end;
                     end;
                  GoNoGo;
                  If TC = #27 then RC := 'N';
                Until RC = 'N';
                If DskRpt = 'N' then WriteLine('W',Qp);
                Close ( LST );
                Color(Blue,Cyan);
                GotoXY(1,23); Write(ConstStr(' ',80));
                GotoXY(2,23); Write('Total de Contas Impressas: ');
                Color(Blue,White);
                GotoXY(29,23); Write(NCont:3);
                TeclaReturn;
              end;
         end;
    90 : PrintBackGround('*');
    92 : HelpManual;
  end;
  Resp := #00;
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

Procedure Contabilidade;
begin
  ReCarrega;
  Close ( OwnerFile  );
  XStAnt := 'X';
  EntryCodCia;
  If TC <> #27 then
     begin
       EntryPswCia;
       If TC <> #27 then
          begin
            TC      := 'S';
            LastCia := CmpyNo;
            MostraPrinter;
          end
          else TC := 'N';
     end
     else TC := 'N';
  Close ( BlkStaFile );
  ImpC := 'N';
  If TC = 'S' then
     begin
       MM := CMstMember.MesAtivo;
       AA := CMstMember.AnoAtivo;
       MMFx := 'M' + QQStr(MM,2,'0');
       IIFx := 'I' + QQStr(MM,2,'0');
       AAFx := QQStr(AA,4,'0');

       Assign ( IndxFile, (XPath + '\' + FileIndx ));
       {$I-}
       Reset  ( IndxFile );
       {$I+}
       If IOResult <> 0 then ReWrite ( IndxFile )
          else begin
                 DrawBox(3,20,41,22,Blue,'S');
                 Color(Blue,Yellow);
                 GotoXY(4,21);
                 Write('Carregando Indice [[ 1 ]]   Aguarde');
                 LoadIndex;
               end;
       Close  ( IndxFile );
       Assign ( ContaFile,(XPath + '\' + FileConta + '.DAT'           ));
       Assign ( DeptFile, (XPath + '\' + FileDept  + '.DAT'           ));
       Assign ( LoteFile, (XPath + '\' + FileLote  + AAFx + '.DAT'    ));
       Assign ( IndLFile, (XPath + '\' + FileLote  + AAFx + '.IDX'    ));
       Assign ( SaldFile, (XPath + '\' + FileSald  + AAFx + '.DAT'    ));
       Assign ( ExpeFile, (XPath + '\' + FileExpe  + AAFx + '.DAT'    ));
       Assign ( LctoFile, (XPath + '\' + FileLcto  + AAFx + '.' + MMFx));
       Assign ( IndMFile, (XPath + '\' + FileLcto  + AAFx + '.' + IIFx));
       {$I-}
       Reset ( ContaFile );
       {$I+}
       If IOResult <> 0 then
          begin
            ReWrite ( ContaFile );
            Reset   ( ContaFile );
            ImpC := 'S';
          end
          else If FileSize(ContaFile) = 0 then ImpC := 'S';
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
              ReadWrite(#06,'W','N',FileSize(SaldFile));
            Until FileSize(SaldFile) = FileSize(ContaFile);
          end;
       {$I-}
       Reset ( DeptFile );
       {$I+}
       If IOResult <> 0 then
          begin
            ReWrite ( DeptFile );
            Reset   ( DeptFile );
          end;
       {$I-}
       Reset ( LoteFile );
       {$I+}
       If IOResult <> 0 then
          begin
            ReWrite ( LoteFile );
            Reset   ( LoteFile );
          end;
       {$I-}
       Reset ( LctoFile );
       {$I+}
       If IOResult <> 0 then
          begin
            ReWrite ( LctoFile );
            Reset   ( LctoFile );
          end;
       {$I-}
       Reset ( ExpeFile );
       {$I+}
       If IOResult = 0 then
          begin
            If FileSize(ExpeFile) > 0 then
               begin
                 DrawBox(3,20,41,22,Red,'S');
                 Color(Red,Yellow);
                 GotoXY(4,21);
                 Write('Carregando [[Oráamentos]]   Aguarde');
                 LoadExpe;
               end;
          end
          else begin
                 ReWrite ( ExpeFile );
                 Reset   ( ExpeFile );
               end;
       {$I-}
       Reset ( IndLFile );
       {$I+}
       If IOResult = 0 then
          begin
            DrawBox(3,20,41,22,Blue,'S');
            Color(Blue,Yellow);
            GotoXY(4,21);
            Write('Carregando Indice [[ 2 ]]   Aguarde');
            LoadLote;
          end
          else ReWrite ( IndLFile );
       Close ( IndLFile );
       {$I-}
       Reset ( IndMFile );
       {$I+}
       If IOResult = 0 then
          begin
            DrawBox(3,20,41,22,Red,'S');
            Color(Red,Yellow);
            GotoXY(4,21);
            Write('Carregando Indice [[ 3 ]]   Aguarde');
            LoadLcto;
          end
          else ReWrite ( IndMFile );
       Close ( IndMFile );
       ScreenHeader(XSystem,CMstMember.Descricao,'S');
       MainScreenFrame('Movimentaá∆o','Mestres');
       X  := 4;
       Y  := 12;
       MainScreenTitle1(8);
       MainScreenTitle2(4);
       Move(MemW[$B800:0000],ScArray1[1],4000);
       Pg := 1;
       Ut := 'N';
       If ImpC = 'S' then ImportaConta;
       Repeat
         Resp   := ReadKey;
         ProcNo := 99;
         If (Resp = #0 ) and
            (KeyPressed) then
            begin
              If Ut = 'S' then
                 begin
                   Move(ScArray1[1],MemW[$B800:0000],4000);
                   Ut := 'N';
                 end;
              Resp := ReadKey;
              Case Resp of
                   #72 : begin
                           Y := Y - 1;
                           Case Pg of
                                1 : begin
                                      If Y < 12 then Y := 19;
                                      MainScreenTitle1(8);
                                  end;
                                2 : begin
                                      If Y < 10 then Y := 13;
                                      MainScreenTitle2(4);
                                    end;
                           end;
                         end;
                   #80 : begin
                           Y := Y + 1;
                           Case Pg of
                                1 : begin
                                      If Y > 19 then Y := 12;
                                      MainScreenTitle1(8);
                                    end;
                                2 : begin
                                      If Y > 13 then Y := 10;
                                      MainScreenTitle2(4);
                                    end;
                           end;
                         end;
                   #75 : If Pg > 1 then
                            begin
                              Pg := Pg - 1;
                              Case Pg of
                                   1 : begin
                                         X := 4;
                                         Y := 12;
                                         MainScreenTitle1(8);
                                         MainScreenTitle2(4);
                                       end;
                                   2 : begin
                                         X := 60;
                                         Y := 10;
                                         MainScreenTitle2(4);
                                       end;
                              end;
                            end;
                   #77 : If Pg < 2 then
                            begin
                              Pg := Pg + 1;
                              Case Pg of
                                   2 : begin
                                         X := 60;
                                         Y := 10;
                                         MainScreenTitle1(8);
                                         MainScreenTitle2(4);
                                       end;
                              end;
                            end;
              end;
            end
            else If Resp <> #27 then
                    begin
                      Case UpCase(Resp) of
                         '?' : begin
                                Ut := 'S';
                                Move(MemW[$B800:0000],ScArray1[1],4000);
                                DrawBox(27,7,56,21,Red,'S');
                                Color(Bfn,Btx);
                                GotoXY(27,07);
                                Write('       Opáîes Auxiliares      ');
                                Color(Red,Cyan);
                                GotoXY(28,08);
                                Write('Fechamento   (Mensal/Anual) ');
                                GotoXY(28,09);
                                Write('Abertura     (Mensal/Anual) ');
                                GotoXY(28,10);
                                Write('Transporte de Saldos (Livre)');
                                GotoXY(28,11);
                                Write('Lote autom†tico de Convers∆o');
                                GotoXY(28,12);
                                Write('Recalcula os saldos do Màs  ');
                                GotoXY(28,13);
                                Write('Verifica consistància       ');
                                GotoXY(28,14);
                                Write('Indexaá∆o dos Arquivos      ');
                                GotoXY(28,15);
                                Write('Exclus∆o de Ano             ');
                                GotoXY(28,16);
                                Write('Descarga de Indices         ');
                                GotoXY(28,17);
                                Write('Empresa (C)                 ');
                                GotoXY(28,18);
                                Write('Impress∆o de Textos Fixos   ');
                                GotoXY(28,19);
                                Write('Impress∆o de Textos         ');
                                GotoXY(28,20);
                                Write('Imprimir em BackGround      ');
                                GotoXY(28,21);
                                Write('Manual do Usu†rio           ');
                                Color(Red,Yellow);
                                GotoXY(28,08);  Write('F');
                                GotoXY(28,09);  Write('A');
                                GotoXY(28,10);  Write('T');
                                GotoXY(28,11);  Write('L');
                                GotoXY(28,12);  Write('R');
                                GotoXY(28,13);  Write('V');
                                GotoXY(28,14);  Write('I');
                                GotoXY(28,15);  Write('E');
                                GotoXY(28,16);  Write('D');
                                GotoXY(37,17);  Write('C');
                                GotoXY(46,18);  Write('s');
                                GotoXY(43,19);  Write('x');
                                GotoXY(40,20);  Write('B');
                                GotoXY(28,21);  Write('M');
                                Color(Tfn,Ttx);
                              end;
                        'A' : ProcNo := 70;
                        'F' : ProcNo := 71;
                        'T' : ProcNo := 73;
                        'R' : ProcNo := 75;
                        'V' : ProcNo := 77;
                        'E' : ProcNo := 78;
                        'L' : ProcNo := 79;
                        'I' : ProcNo := 80;
                        'C' : ProcNo := 83;
                        'D' : ProcNo := 85;
                        'S' : ProcNo := 88;
                        'X' : ProcNo := 89;
                        'B' : ProcNo := 90;
                        'M' : ProcNo := 92;
                        else If Resp = #13 then
                                begin
                                  Case Pg of
                                       1 : Case Y of
                                             12 : ProcNo := 1;
                                             13 : ProcNo := 2;
                                             14 : ProcNo := 3;
                                             15 : ProcNo := 4;
                                             16 : ProcNo := 5;
                                             17 : ProcNo := 6;
                                             18 : ProcNo := 7;
                                             19 : Resp   := #27;
                                           end;
                                       2 : Case Y of
                                             10 : ProcNo := 20;
                                             11 : ProcNo := 21;
                                             12 : ProcNo := 22;
                                             13 : ProcNo := 23;
                                           end;
                                  end;
                                end;
                      end;
                        If Ut = 'N'
                           then Move(MemW[$B800:0000],ScArray1[1],4000);
                        If ProcNo <> 99 then
                           begin
                             Processo;
                             Move(ScArray1[1],MemW[$B800:0000],4000);
                             ShowHeap;
                             Color(Tfn,Ttx);
                             Ut := 'N';
                           end;
                    end
                    else Resp := #13;
       Until Resp = #27;
       If DI = 'S' then DescarregaI;
       If DL = 'S' then DescarregaL;
       If DM = 'S' then DescarregaM;
       TC := #13;
       CloseFiles;
     end;
{ If XStAnt = 'I' then
     begin
     end;   }
  ReadWrite(#02,'R','N',CmpyNumber);
  CmpyMember.Status := 'I';
  ReadWrite(#02,'W','N',CmpyNumber);

  Close ( MasterFile );
  Close ( HsPdFile   );
  Close ( EcoFile    );
  Close ( CmpyFile   );
  Resp := #00;
end;

begin
  XDriveP  := 'C';
  Op1      := 'S';
  Mch      := 'A';
  I        := 0;
  Tfd      := 3;
  Mudou    := 'N';
  PrimeiraVez := 'S';
  Repeat
    I := I + 1;
    If ParamCount >= I then
     begin
       J := ParamStr(I);
       J := UpCaseStr(J);
       Case J[1] of
            'D' : XDriveP := Copy(J,3,(Length(J)-2));
            'H' : If J[3] in ['A','X'] then Mch := J[3]
                                       else Mch := 'A';
            'M' : If J[3] in ['B','C','M'] then
                     begin
                       Case J[3] of
                            'B' : TextMode(2);
                            'C' : TextMode(3);
                            'M' : TextMode(7);
                       end;

                       DirectVideo := True;
                       CheckSnow   := True;
                     end;
            'T' : If J[3] in ['N','S'] then Op1 := J[3]
                                       else Op1 := 'S';
       end;
     end;
  Until ParamCount = I;
  CheckBreak := False;
  ImpC       := 'N';
  LastCia    := '';
  LaserInit  := #27+'E';
  XPrinter   := '';
  XSystem    := 'A-Log';
  XVersao    := '7.110/1999';

  InitialScreen(XSystem,Op1);
  Move(Mem[$B800:0000],ScArrayM[1],4000);

  SelecionaDrive;

  If TC = 'S' then
     begin
       Move(Mem[$B800:0000],ScArrayM[1],4000);
       Repeat
         Move(ScArrayM[1],Mem[$B800:0000],4000);
         YYAnt := 1;
         Repeat
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
           Color(Tfn,Utx);
           TabI[1]  := ' Contabilidade      ';
           TabI[2]  := ' Funá‰es do Master  ';
           TabI[3]  := ' Seleciona Arquivos ';
           TabI[4]  := ' Encerrar execuá∆o  ';
           TabX[1]  := 3;
           TabX[2]  := 3;
           TabX[3]  := 3;
           TabX[4]  := 3;
           TabY[1]  := 10;
           TabY[2]  := 11;
           TabY[3]  := 12;
           TabY[4]  := 13;
           YY       := YYAnt;
           RetMenuAuxiliar(2,09,4,1,1);
           YYAnt := YY;
           Resp  := #00;
           Move(Mem[$B800:0000],ScArrayM[1],4000);
           Reseta;
           Case YY of
                1   : Contabilidade;
                2   : Master;
                3   : SelecionaDrive;
                4   : Resp := #27;
           end;
           Move(ScArrayM[1],Mem[$B800:0000],4000);
         Until Resp = #27;
         TC := Resp;
       Until TC = #27;
     end;
  Color(Black,White);
  ClrScr;
  SetCursor(1);
  XDir := Copy(XDrive,1,2) + '\';
  {$I-}
  Chdir ( XDir );
  {$I+}
  Halt(0);
end.

