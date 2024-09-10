{$M 65520,0,256000,F+}

(**********************************)
(* Heap Size 256000 bytes = 250Kb *)
(**********************************)

PROGRAM PLOG;

Uses
  Overlay,Crt,Dos,PlogOvrl,PlogGlbs,PlogBasP,PlogTree,PlogGera,PlogCmpy,
                  PlogDoct,PlogText,PlogMstr,PlogTabl,PlogFunc,PlogSala,
                  PlogMovt,PlogFeri,PlogResc,PlogCalc,PlogFCol,PlogReor,
                  PlogRpt0,PlogRpt1,PlogRpt2,PlogRpt3,PlogRpt4,PlogRpt5,
                  PlogRpt6,PlogRpt7,PlogRpt8,PlogRpot,PlogFTra,PlogYear,
                  PlogMCon,PlogUpdC;

           (*****************************************)
           (*         Charles Bruce Matheson        *)
           (*                                       *)
           (*          Copyright,1989-2000          *)
           (*                                       *)
	   (*           Vers∆o 9.4  03/1996         *)
           (*                  9.5  09/1999         *)
           (*                                       *)
           (*           Folha de Pagamento          *)
           (*                                       *)
           (*****************************************)

{$O PlogGera }
{$O PlogCmpy }
{$O PlogDoct }
{$O PlogText }
{$O PlogMstr }
{$O PlogTabl }
{$O PlogFunc }
{$O PlogSala }
{$O PlogMovt }
{$O PlogFeri }
{$O PlogResc }
{$O PlogCalc }
{$O PlogFCol }
{$O PlogReor }
{$O PlogRpt0 }
{$O PlogRpt1 }
{$O PlogRpt2 }
{$O PlogRpt3 }
{$O PlogRpt4 }
{$O PlogRpt5 }
{$O PlogRpt6 }
{$O PlogRpt7 }
{$O PlogRpt8 }
{$O PlogRpot }
{$O PlogFTra }
{$O PlogYear }
{$O PlogMCon }
{$O PlogUpdC }

Procedure MostraPrinter;
begin
  Color(Red,Yellow);
  GotoXY(59,6); Write('Prt ');
  Color(Red,White);
  GotoXY(63,6); Write(XPrinter);
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
Var
  MPass  : Str8;
begin
  Case ProcNo of
    1  : begin
           Titulo := 'Empresas   ( Monitoraá∆o )';
           BuildFrame('N');
           Color(Red,White);
           GotoXY(36,07); Write('Total de Empr..: ');
           GotoXY(62,08); Write(#27,#217);
           GotoXY(62,09); Write(#24);
           GotoXY(62,10); Write(#25);
           GotoXY(62,11); Write('F1 ');
           GotoXY(62,12); Write('F2 ');
           GotoXY(62,13); Write('F3 ');
           GotoXY(62,14); Write('F4 ');
           GotoXY(62,15); Write('F5 ');
           GotoXY(62,16); Write('F6 ');
           GotoXY(62,17); Write('F7 ');
           GotoXY(62,18); Write('F9 ');
           GotoXY(62,19); Write('F10');
           Color(Red,Yellow);
           GotoXY(53,07); Write(MasterMember.NEmpresas);
           GotoXY(66,08); Write('C¢digo     ');
           GotoXY(66,09); Write('Anterior   ');
           GotoXY(66,10); Write('Pr¢ximo    ');
           GotoXY(66,11); Write('Empresas   ');
           GotoXY(66,12); Write('Altera Nome');
           GotoXY(66,13); Write('Alteraá∆o  ');
           GotoXY(66,14); Write('Complement.');
           GotoXY(66,15); Write('Outras     ');
           GotoXY(66,16); Write('Liberar    ');
           GotoXY(66,17); Write('Blq.Mensal ');
           GotoXY(66,18); Write('Blq.Total  ');
           GotoXY(66,19); Write('Exclus∆o   ');
           Shade(3,8,60,21,LightGray,Black);
           TitleCiaX;
           Move(Mem[$B800:0000],ScArray4[1],4000);
           UpdateCia;
         end;
    2  : begin
           Titulo := 'Listagens (FeTranspor/Empresas)';
           BuildFrame('N');
           Color(Tfn,Utx);
           TabI[1]  := ' Fetranspor (V.T.)       ';
           TabI[2]  := ' Empresas                ';
           TabI[3]  := ' Encerrar a funá∆o       ';
           TabX[1]  := 10;
           TabX[2]  := 10;
           TabX[3]  := 10;
           TabY[1]  := 14;
           TabY[2]  := 15;
           TabY[3]  := 16;
           Move(Mem[$B800:0000],ScArray6[1],4000);
           YY := 1;
           Repeat
             RetMenuAuxiliar(9,13,3,1,1);
             Move(Mem[$B800:0000],ScArray5[1],4000);
             Case YY of
                  1 : FetransportRel;
                  2 : begin
                        Titulo := 'Lista Empresas Licenciadas';
                        BuildFrame('N');
                        Color(Red,White);
                        GotoXY(36,7); Write('Total de Empr..: ');
                        Color(Red,Yellow);
                        GotoXY(53,7); Write(MasterMember.NEmpresas);
                        Shade(3,8,60,21,LightGray,Black);
                        ListaEmpresas;
                      end;
                  3 : begin
                        TC   := #27;
                        Resp := #27;
                      end;
             end;
             Move(ScArray5[1],Mem[$B800:0000],4000);
           Until Resp = #27;
           Move(ScArray6[1],MemW[$B800:0000],4000);
         end;
    3  : begin
           Titulo := 'Set-Up de Cor';
           BuildFrame('N');
           ColorSetUp;
           If TC = 'S' then
              begin
                Vez   := 'S';
                VezD  := 'S';
                Mudou := 'S';
                ReadWrite(#00,'W','N',0);
                Inicializa;
                Move(ScArray1[1],Mem[$B800:0000],4000);
                ScreenHeader(XSystem,OwnerMember.RSocial,'*');
                DrawBox(60,7,74,10,Bfn,'S');
                Color(Tfn,Ttx);
                GotoXY(60,7); Write(' Ultimo Backup ');
                Color(Bfn,Btx);
                GotoXY(63,9); Write(MasterMember.DataBkp);
                DrawBox(25,10,53,22,Tfn,'S');
                Color(Bfn,Btx);
                GotoXY(25,10); Write('      Funá‰es do Master      ');
                MainScreenTitle3(10);
                Move(Mem[$B800:0000],ScArray1[1],4000);
              end
              else ReadWrite(#00,'R','N',0);
         end;
    4  : begin
           Titulo := 'Configuraá∆o de Impressora';
           BuildFrame('N');
           ConfigPrinter;
           If TC = 'S' then
              begin
                ReadWrite(#00,'W','N',0);
                Inicializa;
                Mudou := 'S';
              end;
           Resp := #00;
           TC   := #13;
         end;
    5  : begin
           Titulo := 'Atualizaá∆o da data do Ultimo Backup';
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
             Until TC in [#27,'S'];
             If TC <> #27 then
                begin
                  Confirma;
                  If TC = 'S' then
                     begin
                       ReadWrite(#00,'W','N',0);
                       Move(Mem[$B800:0000],ScArray1[1],4000);
                     end;
                end;
           Until TC in [#27,'S'];
         end;
    6  : begin
           Titulo := 'Tabelas e ParÉmetros';
           TableFrame;
           Color(Tfn,Ttx);
           GotoXY(04,09); Write('Màs...:');
           GotoXY(04,10); Write('Ano...:');
           GotoXY(04,11); Write('Vers∆o:');
           Color(Tfn,Utx);
           TabI[1]  := ' INSS                    ';
           TabI[2]  := ' INSS (Autonomos)        ';
           TabI[3]  := ' Imp.de Renda na Fonte   ';
           TabI[4]  := ' Sal†rio Fam°lia         ';
           TabI[5]  := ' Tarifas de Vale Transp. ';
           TabI[6]  := ' ParÉmetros gerais       ';
           TabI[7]  := ' Listar tabela           ';
           TabI[8]  := ' Copiar tabela           ';
           TabI[9]  := ' Excluir tabela          ';
           TabI[10] := ' Reativar tabela         ';
           TabI[11] := ' Encerrar a funá∆o       ';
           TabX[1]  := 4;
           TabX[2]  := 4;
           TabX[3]  := 4;
           TabX[4]  := 4;
           TabX[5]  := 4;
           TabX[6]  := 4;
           TabX[7]  := 30;
           TabX[8]  := 30;
           TabX[9]  := 30;
           TabX[10] := 30;
           TabX[11] := 30;
           TabY[1]  := 14;
           TabY[2]  := 15;
           TabY[3]  := 16;
           TabY[4]  := 17;
           TabY[5]  := 18;
           TabY[6]  := 19;
           TabY[7]  := 14;
           TabY[8]  := 15;
           TabY[9]  := 16;
           TabY[10] := 17;
           TabY[11] := 18;
           SelecionaTabela;
         end;
    7  : begin
           Titulo := 'Tabela de Proventos e Descontos';
           BuildFrame('N');
           Color(Red,White);
           GotoXY(36,07); Write('Total de Contas: ');
           GotoXY(62,08); Write(#27,#217);
           GotoXY(62,10); Write(#24);
           GotoXY(62,11); Write(#25);
           GotoXY(62,13); Write('F1');
           GotoXY(62,14); Write('F3');
           GotoXY(62,16); Write('F5');
           Color(Red,Yellow);
           GotoXY(53,07); Write(MasterMember.NContas);
           GotoXY(66,08); Write('C¢digo  ');
           GotoXY(66,10); Write('Anterior');
           GotoXY(66,11); Write('Pr¢ximo ');
           GotoXY(66,13); Write('Contas  ');
           GotoXY(66,14); Write('Alterar ');
           GotoXY(66,16); Write('C†lculos');
           Shade(3,8,60,21,LightGray,Black);
           TitleMstr('C');
           Move(Mem[$B800:0000],ScArray4[1],4000);
           UpdateConta('M');
         end;
    8  : begin
           Titulo := 'Tabela de Sindicatos';
           BuildFrame('N');
           Color(Red,White);
           GotoXY(36,07); Write('Total de Sind..: ');
           GotoXY(62,08); Write(#27,#217);
           GotoXY(62,10); Write(#24);
           GotoXY(62,11); Write(#25);
           GotoXY(62,13); Write('F1');
           GotoXY(62,14); Write('F3');
           Color(Red,Yellow);
           GotoXY(53,07); Write(MasterMember.NSind);
           GotoXY(66,08); Write('C¢digo    ');
           GotoXY(66,10); Write('Anterior  ');
           GotoXY(66,11); Write('Pr¢ximo   ');
           GotoXY(66,13); Write('Sindicatos');
           GotoXY(66,14); Write('Alterar   ');
           Shade(3,8,60,21,LightGray,Black);
           TitleMstr('S');
           Move(Mem[$B800:0000],ScArray4[1],4000);
           UpdateSind('M');
         end;
    9  : begin
           Titulo := 'Impress∆o (Guias)';
           BuildFrame('N');
           Color(Tfn,Ttx);
           GotoXY(04,10); Write('Màs...:');
           GotoXY(04,11); Write('Ano...:');
           Color(Tfn,Utx);
           TabI[1]  := ' GRPS Previdància Social ';
           TabI[2]  := ' GRCS Contrib. Sindical  ';
           TabI[3]  := ' DARF Imposto de Renda   ';
           TabI[4]  := ' GR   FGTS               ';
           TabI[5]  := ' Encerrar a funá∆o       ';
           TabX[1]  := 10;
           TabX[2]  := 10;
           TabX[3]  := 10;
           TabX[4]  := 10;
           TabX[5]  := 10;
           TabY[1]  := 14;
           TabY[2]  := 15;
           TabY[3]  := 16;
           TabY[4]  := 17;
           TabY[5]  := 18;
           Move(Mem[$B800:0000],ScArray6[1],4000);
           PedeMesAno;
           If TC = 'S' then
              begin
                YY := 1;
                Repeat
                  RetMenuAuxiliar(9,13,5,1,1);
                  Move(Mem[$B800:0000],ScArray5[1],4000);
                  Case YY of
                       1 : GeralGRPS;
                       2 : GeralGRCS;
                       3 : GeralDARF;
                       4 : GeralGR;
                       5 : begin
                             TC   := #27;
                             Resp := #27;
                           end;
                  end;
                  Move(ScArray5[1],Mem[$B800:0000],4000);
                Until Resp = #27;
                Move(ScArray6[1],MemW[$B800:0000],4000);
              end;
         end;
    10 : begin
           Titulo := 'Indexaá∆o do P-Log (Arquivos Mestres)';
           BuildFrame('N');
           Confirma;
           If TC = 'S' then
              begin
                ReorganizaM;
                Descarrega1;
              end;
         end;
    30 : begin
           Titulo := 'Licenciamento do Software';
           BuildFrame('N');
           ShowLicenciamento;
           Color(Red,Cyan);
           GotoXY(01,24);  Write(ConstStr(' ',80));
           GotoXY(18,24);  Write('Digite < > para alterar a Marca,< > para atualizar ou <     > ');
           Color(Red,White);
           GotoXY(26,24); Write('M');
           GotoXY(51,24); Write('A');
           GotoXY(73,24); Write('Enter');
           Repeat
             TC := UpCase(ReadKey);
           Until TC in['A','M',#13];
           Color(Tfd,Utx);
           GotoXY(1,24); ClrEol;
           Color(Tfn,Utx);
           Case TC of
                'A' : EntryOwner;
                'M' : EntryOwnerMarca;
           end;
         end;
    40 : HelpManual;
    50 : begin
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
  DrawBox(25,10,53,22,Tfn,'S');
  Color(Bfn,Btx);
  GotoXY(25,10); Write('      Funá‰es do Master      ');
  X  := 4;
  Y  := 12;
  MainScreenTitle3(10);
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
                      If Y < 12 then Y := 21;
                      MainScreenTitle3(10);
                    end;
              #80 : begin
                      Y := Y + 1;
                      If Y > 21 then Y := 12;
                      MainScreenTitle3(10);
                    end;
         end;
       end
       else If (Resp = #13           ) or
               (Resp in ['B','I','M','X']) then
               begin
                 Case Resp of
                      'I' : ProcNo := 10;
                      'X' : ProcNo := 30;
                      'M' : ProcNo := 40;
                      'B' : ProcNo := 50;
                      #13 : Case Y of
                                 12 : ProcNo := 1;
                                 13 : ProcNo := 2;
                                 14 : ProcNo := 3;
                                 15 : ProcNo := 4;
                                 16 : ProcNo := 5;
                                 17 : ProcNo := 6;
                                 18 : ProcNo := 7;
                                 19 : ProcNo := 8;
                                 20 : ProcNo := 9;
                                 21 : Resp   := #27;
                            end;
                 end;
                 If ProcNo <> 99 then
                    begin
                      Move(Mem[$B800:0000],ScArray1[1],4000);
                      MasterFunction;
                      Move(ScArray1[1],Mem[$B800:0000],4000);
                      ShowHeap;
                      Color(Tfn,Ttx);
                    end;
               end
               else Resp := #13;
  Until Resp = #27;
  If D1 = 'S' then
     begin
       Descarrega1;
       Move(ScArray1[1],Mem[$B800:0000],4000);
       ShowHeap;
       Color(Tfn,Ttx);
     end;
end;


Procedure Processo;
begin
  Case ProcNo of
    01 : begin
           Titulo := 'Empregados';
           BuildFrame('S');
           Color(Red,White);
           GotoXY(36,07); Write('Total de Empreg: ');
           GotoXY(62,07); Write(#27,#217);
           GotoXY(62,08); Write(#24,#25);
           GotoXY(62,09); Write('F1');
           GotoXY(62,10); Write('F2');
           GotoXY(62,11); If XSt = 'A' then Write('F3');
           GotoXY(62,12); Write('F4 ');
           GotoXY(62,13); Write('F5 ');
           GotoXY(62,14); Write('F6 ');
           GotoXY(62,15); Write('F7 ');
           GotoXY(62,16); Write('F8 ');
           GotoXY(62,17); Write('F9 ');
           GotoXY(62,18); Write('F10');
           GotoXY(62,19); Write('S/F1');
           Color(Red,Yellow);
           GotoXY(53,07); Write(CMstMember.NFunc);
           GotoXY(66,07); Write('C¢digo      ');
           GotoXY(66,08); Write('Ant./Pr¢ximo');
           GotoXY(66,09); Write('Empregados  ');
           GotoXY(66,10); Write('Ac. de Horas');
           GotoXY(66,11); If XSt = 'A' then Write('Alterar    ');
           GotoXY(66,12); Write('Acum.Anual  ');
           GotoXY(66,13); Write('Lanáamentos ');
           GotoXY(66,14); Write('Pessoais    ');
           GotoXY(66,15); Write('Funcionais  ');
           GotoXY(66,16); Write('Pagamento   ');
           GotoXY(66,17); Write('Hist¢ricos  ');
           GotoXY(66,18); Write('Vale Transp.');
           GotoXY(67,19); Write('Ord.de serv.');
           Shade(3,8,60,21,LightGray,Black);
           Color(Tfn,Ttx);
           GotoXY(04,08); Write('Matr°c:');
           Move(Mem[$B800:0000],ScArray4[1],4000);
           UpdateFunc;
         end;
    02 : If XSt = 'A' then
            begin
              Titulo := 'Alteraá∆o de Sal†rios';
              BuildFrame('S');
              UltimaEtapa;
              Move(Mem[$B800:0000],ScArray4[1],4000);
              Color(Tfn,Utx);
              TabI[1]  := ' Individual         ';
              TabI[2]  := ' Seletiva por Faixa ';
              TabI[3]  := ' Encerrar a funá∆o  ';
              TabX[1]  := 10;
              TabX[2]  := 10;
              TabX[3]  := 10;
              TabY[1]  := 11;
              TabY[2]  := 12;
              TabY[3]  := 13;
              YY := 1;
              Repeat
                RetMenuAuxiliar(9,10,3,1,1);
                Move(Mem[$B800:0000],ScArray5[1],4000);
                Case YY of
                     1,2 : AlteraSalario;
                     3   : Resp := #27;
                end;
                Move(ScArray5[1],Mem[$B800:0000],4000);
              Until Resp = #27;
              Resp := #00;
              TC   := #13;
            end;
    03 : If XSt = 'A' then
            begin
              Titulo := 'Movimento (Lanáamentos)';
              BuildFrame('S');
              UltimaEtapa;
              Color(Red,White);
              GotoXY(36,07); Write('Total de Empreg: ');
              Color(Red,Yellow);
              GotoXY(53,07); Write(CMstMember.NFunc);
              Shade(3,8,60,21,LightGray,Black);
              Move(Mem[$B800:0000],ScArray4[1],4000);
              AtualizaMov;
            end;
    04,05,06 : If XSt = 'A' then
                  begin
                    TTNo := AAFx + Copy(MMFx,2,2) + '1';
                    SearchTree4 ( Root4 );
                    If RC = 'S' then
                       begin
                         ReadWrite(#03,'R','N',TTNumber);
                         Descarrega2;
                         Descarrega3;
                         Case ProcNo of
                              04 : Titulo := 'C†lculos ';
                              05 : Titulo := 'Rescis‰es';
                              06 : Titulo := 'FÇrias   ';
                         end;
                         BuildFrame('S');
                         UltimaEtapa;
                         Color(Red,White);
                         GotoXY(36,07); Write('Total de Empreg: ');
                         Color(Red,Yellow);
                         GotoXY(53,07); Write(CMstMember.NFunc);
                         Shade(3,8,60,21,LightGray,Black);
                         If ProcNo = 05 then
                            begin
                              Color(Tfn,Ttx);
                              GotoXY(04,09); Write('Matr°c:');
                              Color(Tfn,Utx);
                            end;
                         Move(Mem[$B800:0000],ScArray4[1],4000);
                         Case ProcNo of
                              04 : SelecionaCalculo;
                              05 : Rescisao;
                              06 : begin
                                     Color(Tfn,Utx);
                                     TabI[1]  := ' FÇrias Individuais ';
                                     TabI[2]  := ' FÇrias Coletivas   ';
                                     TabI[3]  := ' Encerrar a funá∆o  ';
                                     TabX[1]  := 10;
                                     TabX[2]  := 10;
                                     TabX[3]  := 10;
                                     TabY[1]  := 11;
                                     TabY[2]  := 12;
                                     TabY[3]  := 13;
                                     YY := 1;
                                     Repeat
                                       RetMenuAuxiliar(9,10,3,1,1);
                                       Move(Mem[$B800:0000],ScArray6[1],4000);
                                       Case YY of
                                            1   : FeriasIndividuais;
                                            2   : FeriasColetivas;
                                            3   : Resp := #27;
                                       end;
                                       Move(ScArray6[1],Mem[$B800:0000],4000);
                                     Until Resp = #27;
                                     Resp := #00;
                                     TC   := #13;
                                   end;
                         end;
                       end
                       else begin
                              Color(Blue,Cyan);
                              GotoXY(1,23); Write(ConstStr(' ',80));
                              GotoXY(2,23); Write('Faltam Tabelas, n∆o posso calcular. Verifique!');
                              TeclaReturn;
                            end;
                  end;
    07 : begin
           If (D2 = 'S') or
              (D3 = 'S') then
              begin
                Descarrega2;
                Descarrega3;
                Move(ScArray1[1],Mem[$B800:0000],4000);
              end;
           SelectReport;
         end;
    08 : begin
           Descarrega2;
           Descarrega3;
           Move(ScArray1[1],Mem[$B800:0000],4000);
           TrocaMesAno;
         end;
    20..24 : begin
               Case ProcNo of
                    20 : Titulo := 'Tabela de I.N.S.S.                  ';
                    21 : Titulo := 'Tabela de Imposto de Renda na Fonte ';
                    22 : Titulo := 'Tabela de Sal†rio Fam°lia           ';
                    23 : Titulo := 'Tabela de Tarifas de Vale Transporte';
                    24 : Titulo := 'ParÉmetros (Gerais)                 ';
               end;
               TableFrame;
               Case ProcNo of
                    20 : begin
                           TitleTabl ('1');
                           DataTabl  ('1');
                         end;
                    21 : begin
                           TitleTabl ('2');
                           DataTabl  ('2');
                         end;
                    22 : begin
                           TitleTabl ('3');
                           DataTabl  ('3');
                         end;
                    23 : begin
                           TitleTabl ('4');
                           DataTabl  ('4');
                         end;
                    24 : begin
                           TitleTabl ('5');
                           DataTabl  ('5');
                         end;
               end;
               TeclaReturn;
             end;
    25 : begin
           Titulo := 'Tabela de Contas';
           BuildFrame('S');
           Color(Red,White);
           GotoXY(36,07); Write('Total de Contas: ');
           GotoXY(62,08); Write(#27,#217);
           GotoXY(62,10); Write(#24);
           GotoXY(62,11); Write(#25);
           GotoXY(62,13); Write('F1');
           GotoXY(62,15); Write('F5');
           Color(Red,Yellow);
           GotoXY(53,07); Write(MasterMember.NContas);
           GotoXY(66,08); Write('C¢digo  ');
           GotoXY(66,10); Write('Anterior');
           GotoXY(66,11); Write('Pr¢ximo ');
           GotoXY(66,13); Write('Contas  ');
           GotoXY(66,15); Write('C†lculos');
           Shade(3,8,60,21,LightGray,Black);
           TitleMstr('C');
           Move(Mem[$B800:0000],ScArray4[1],4000);
           UpdateConta('N');
         end;
    26 : begin
           Titulo := 'Tabela de Sindicatos';
           BuildFrame('S');
           Color(Red,White);
           GotoXY(36,07); Write('Total de Sind..: ');
           GotoXY(62,08); Write(#27,#217);
           GotoXY(62,10); Write(#24);
           GotoXY(62,11); Write(#25);
           GotoXY(62,13); Write('F1');
           Color(Red,Yellow);
           GotoXY(53,07); Write(MasterMember.NSind);
           GotoXY(66,08); Write('C¢digo    ');
           GotoXY(66,10); Write('Anterior  ');
           GotoXY(66,11); Write('Pr¢ximo   ');
           GotoXY(66,13); Write('Sindicatos');
           Shade(3,8,60,21,LightGray,Black);
           TitleMstr('S');
           Move(Mem[$B800:0000],ScArray4[1],4000);
           UpdateSind('N');
         end;
    27 : begin
           Titulo := 'Tabela de Departamentos';
           BuildFrame('S');
           Color(Red,White);
           GotoXY(36,07); Write('Total de Deptos: ');
           GotoXY(62,08); Write(#27,#217);
           GotoXY(62,10); Write(#24);
           GotoXY(62,11); Write(#25);
           GotoXY(62,13); Write('F1');
           If XSt = 'A' then
              begin
                GotoXY(62,14); Write('F3');
                GotoXY(62,16); Write('F5');
              end;
           Color(Red,Yellow);
           GotoXY(53,07); Write(CMstMember.NDepto);
           GotoXY(66,08); Write('C¢digo      ');
           GotoXY(66,10); Write('Anterior    ');
           GotoXY(66,11); Write('Pr¢ximo     ');
           GotoXY(66,13); Write('Departamento');
           If XSt = 'A' then
              begin
                GotoXY(66,14); Write('Alterar');
                GotoXY(66,16); Write('Marca/Desm.');
              end;
           Shade(3,8,60,21,LightGray,Black);
           TitleMstr('D');
           Move(Mem[$B800:0000],ScArray4[1],4000);
           UpdateDept;
         end;
    28 : begin
           Titulo := 'Tabela de Bancos (Pagamento e FGTS)';
           BuildFrame('S');
           Color(Red,White);
           GotoXY(36,07); Write('Total de Bancos: ');
           GotoXY(62,08); Write(#27,#217);
           GotoXY(62,10); Write(#24);
           GotoXY(62,11); Write(#25);
           GotoXY(62,13); Write('F1');
           GotoXY(62,14); If XSt = 'A' then Write('F3');
           Color(Red,Yellow);
           GotoXY(53,07); Write(CMstMember.NBancos);
           GotoXY(66,08); Write('C¢digo  ');
           GotoXY(66,10); Write('Anterior');
           GotoXY(66,11); Write('Pr¢ximo ');
           GotoXY(66,13); Write('Bancos  ');
           GotoXY(66,14); If XSt = 'A' then Write('Alterar');
           Shade(3,8,60,21,LightGray,Black);
           TitleMstr('B');
           Move(Mem[$B800:0000],ScArray4[1],4000);
           UpdateBanco;
         end;
    74 : If XSt = 'A' then
            begin
              Titulo := 'Faltas n∆o Justificadas';
              BuildFrame('S');
              UltimaEtapa;
              Color(Red,White);
              GotoXY(36,07); Write('Total de Empreg: ');
              Color(Red,Yellow);
              GotoXY(53,07); Write(CMstMember.NFunc);
              Color(Tfn,Ttx);
              GotoXY(04,09); Write('Matr°c:');
              Color(Tfn,Utx);
              Move(Mem[$B800:0000],ScArray4[1],4000);
              FaltasNJustificadas;
            end;
    76 : If XSt = 'A' then
            begin
              Titulo := 'Operaá‰es em Grupo (Lanáamentos)';
              BuildFrame('S');
              UltimaEtapa;
              Color(Red,White);
              GotoXY(36,07); Write('Total de Empreg: ');
              Color(Red,Yellow);
              GotoXY(53,07); Write(CMstMember.NFunc);
              Color(Tfn,Ttx);
              GotoXY(04,12); Write('Conta.:');
              Color(Tfn,Utx);
              Move(Mem[$B800:0000],ScArray4[1],4000);
              AlteracaoGrupo;
            end;
    77 : If XSt = 'A' then
            begin
              Descarrega2;
              Descarrega3;
              Titulo := 'Abertura de Màs';
              BuildFrame('S');
              UltimaEtapa;
              Confirma;
              If TC = 'S' then
                 begin
                   Abertura;
                   If TC = 'S' then
                      begin
                        Titulo := 'Indexaá∆o de abertura de màs';
                        BuildFrame('S');
                        UltimaEtapa;
                        Reorganiza;
                        Descarrega2;
                        Descarrega3;
                        Move(ScArray1[1],Mem[$B800:0000],4000);
                        ShowMes;
                        Move(Mem[$B800:0000],ScArray1[1],4000);
                        Color(Tfn,Utx);
                        E := AA div 4;
                        If (AA - (E * 4)) = 0 then TabDia[2] := 29
                                              else TabDia[2] := 28;
                      end;
                 end;
            end;
    78 : If XSt = 'A' then
            begin
              Titulo := 'Rateio por Pontos';
              BuildFrame('S');
              Color(Red,White);
              GotoXY(36,07); Write('Total de Empreg: ');
              Color(Red,Yellow);
              GotoXY(53,07); Write(CMstMember.NFunc);
              Color(Tfn,Ttx);
              GotoXY(04,10); Write('Conta.:');
              Color(Tfn,Utx);
              Move(Mem[$B800:0000],ScArray4[1],4000);
              Rateio;
            end;
    79 : If XSt = 'A' then
            begin
              Titulo := 'Geraá∆o de Arquivo p/Fetranspor';
              BuildFrame('S');
              Color(Red,White);
              GotoXY(36,07); Write('Total de Empreg: ');
              Color(Red,Yellow);
              GotoXY(53,07); Write(CMstMember.NFunc);
              Move(Mem[$B800:0000],ScArray4[1],4000);
              Fetransport;
            end;
    80 : If XSt = 'A' then
            begin
              Titulo := 'Indexaá∆o dos Arquivos do P-Log';
              BuildFrame('S');
              UltimaEtapa;
              Confirma;
              If TC = 'S' then
                 begin
                   Reorganiza;
                   Descarrega2;
                   Descarrega3;
                 end;
            end;
    82 : If XSt = 'A' then AtualizaCadastro;
    83 : begin
           Titulo := 'Empresas';
           BuildFrame('S');
           UltimaEtapa;
           Color(Red,White);
           GotoXY(36,7); Write('Total de Empr..: ');
           Color(Red,Yellow);
           GotoXY(53,7); Write(MasterMember.NEmpresas);
           TitleCia;
           DataCia('N');
           TeclaReturn;
         end;
    85 : If XSt = 'A' then
            begin
              D2 := 'S';
              D3 := 'S';
              Descarrega2;
              Descarrega3;
              CloseFiles;
              OpenFiles;
            end;
    92 : If XSt = 'A' then
            begin
              CmpyNX := CmpyNo;
              CmpyAX := CmpyNumber;
              CmpyAN := 0;
              CmpyAC := '';
              CmpyNo := '';

              If Root0 = NIL then LoadCmpy;
              ScrollCia('S');

              If (CmpyAC <> '') and (CmpyAC <> CmpyNo) then
                 begin
                   Assign( WorkFile4, (XDrive + '\PLOGM' + CmpyAC + '\' + FileEE + AAFx + '.' + MMFx ));
                   {$I-}
                   Reset ( WorkFile4 );
                   {$I+}
                   If IOResult = 0 then
                      begin
                        Move(Mem[$B800:0000],ScArray4[1],4000);
                        Color(Red,Cyan);
                        GotoXY(1,23); Write(ConstStr(' ',80));
                        Color(Red,White);
                        GotoXY(2,23); Write('Adicionando cadastro de Empregados.');
                        Color(Blue,Cyan);
                        GotoXY(1,24); Write(ConstStr(' ',80));
                        GotoXY(2,24); Write('Registros lidos:                         Registros selecionados:');
                        Color(Blue,Yellow);
                        R := 0;
                        I := -1;
                        Repeat
                          I := I + 1;
                          Seek ( WorkFile4, I        );
                          Read ( WorkFile4, EEMember );
                          GotoXY(19,24); Write(I+1:4);
                          If (EEMember.Status <> 'R') and
                             (EEMember.Status <> 'V') and
                             (EEMember.Status <> 'X') then
                             begin
                               EENo := EEMember.Matricula;
                               SearchTree5 ( Root5 );
                               If RC = 'S' then EENo := 'X' + EENo;
                               EENumber := FileSize(EEFile);
                               EEMember.Matricula := EENo;
                               For L := 1 to 9 do EEMember.Movimento[L] := Limite;
                               ReadWrite(#08,'W','N',EENumber);
                               ENMember.Empregado := EENo;
                               For L := 1 to 48 do
                               begin
                                 ENMember.MMAA[L] := '';
                                 ENMember.SalC[L] := 0;
                                 ENMember.VRec[L] := 0;
                               end;
                               ReadWrite(#12,'W','N',EENumber);
                               LoadTree5 ( Root5 );
                               CMstMember.NFunc := CMstMember.NFunc + 1;
                               ReadWrite(#16,'W','N',0);
                               R := R + 1;
                               GotoXY(67,24); Write(R:4);
                             end;
                        Until (I + 1) = FileSize(WorkFile4);
                        Close ( WorkFile4 );
                        D2 := 'S';
                        GotoXY(78,24); Write('OK');
                        TC := ReadKey;
                        Move(ScArray4[1],MemW[$B800:0000],4000);
                      end;
                 end;
              CmpyNumber := CmpyAX;
              CmpyNo     := CmpyNX;
            end;
    93 : If XSt = 'A' then
            begin
              Titulo := 'Transporte de Acumulados (Contas)';
              BuildFrame('S');
              TransportaAcumulados;
            end;
    94 : If XSt = 'A' then
            begin
              Titulo := 'Exclus∆o de Ano (Empr./Lanáamentos)';
              BuildFrame('S');
              ExcluiAno;
            end;
    95 : PrintBackGround('*');
    96 : HelpManual;
    97 : If XSt = 'A' then
            begin
              Titulo := ' Rotinas Anuais';
              BuildFrame('S');
              Year;
            end;
    98 : If XSt = 'A' then
            begin
              Titulo := ' M¢dulo Cont†bil';
              BuildFrame('S');
              ModuloC;
            end;
  end;
  Resp := #00;
end;

Procedure Reseta;
begin
  Vez     := 'S';
  VezD    := 'S';
  VezR    := 'S';
  D1      := 'N';
  D2      := 'N';
  D3      := 'N';
  XSt     := '*';
  OpMn    := 'N';
end;

Procedure Recarrega;
begin
  Reset ( OwnerFile  );
  Reset ( MasterFile );
  Reset ( TTFile     );
  Reset ( CCFile     );
  Reset ( SSFile     );
  Reset ( CmpyFile   );
  Reset ( BlkStaFile );
  Reset ( Ind1File   );
  Move(Mem[$B800:0000],ScArrayM[1],4000);
  DrawBox(3,20,41,22,Blue,'S');
  Color(Blue,Yellow);
  GotoXY(4,21);
  Write('Carregando Indice [[ 1 ]]   Aguarde');
  LoadIndex1;
  Move(ScArrayM[1],Mem[$B800:0000],4000);
  Close ( Ind1File );
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
  D1      := 'N';
  D2      := 'N';
  D3      := 'N';
  MF      := 'N';
  XSt     := '*';
  OpMn    := 'N';
  Limite  := 30000;
  XDir    := '';
  XDrive  := XDriveP;

  DriveAnt := XDrive;
  Repeat
    Drive;
    XDriveP := XDrive;
    If TC <> #27 then
       begin
         Move(Mem[$B800:0000],ScArrayM[1],4000);
         XDrive := XDrive + '\PLOGDATA';
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
                   CalculoBase(XSystem,OwnerMember.RSocial);

               {    GotoXY(1,23); Write(NBase:5,' ',NBaseC:5,'  ',XSystem,' ',Produto);
                   TC := ReadKey; }

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
            NContas    := 0;
            NSind      := 0;
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

       Inicializa;
       MostraPrinter;

       Assign ( TTFile, (XDrive + '\' + FileTT + '.DAT' ));
       Assign ( CCFile, (XDrive + '\' + FileCC + '.DAT' ));
       Assign ( SSFile, (XDrive + '\' + FileSS + '.DAT' ));
       {$I-}
       Reset ( TTFile );
       {$I+}
       If IOResult <> 0 then begin
                               ReWrite ( TTFile );
                               Reset   ( TTFile );
                             end;
       {$I-}
       Reset ( CCFile );
       {$I+}
       If IOResult <> 0 then begin
                               ReWrite ( CCFile );
                               Reset   ( CCFile );
                             end;
       {$I-}
       Reset ( SSFile );
       {$I+}
       If IOResult <> 0 then begin
                               ReWrite ( SSFile );
                               Reset   ( SSFile );
                             end;

       Assign ( Ind1File,(XDrive + '\' + FileInd1 ));
       {$I-}
       Reset ( Ind1File );
       {$I+}
       If IOResult <> 0 then ReWrite ( Ind1File );
       Close ( Ind1File );

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
       Close ( TTFile     );
       Close ( CCFile     );
       Close ( SSFile     );
       Close ( CmpyFile   );
       Close ( BlkStaFile );

       Resp := #00;
       Close ( OwnerFile  );
     end
     else Resp := TC;
  PrimeiraVez := 'N';
end;

Procedure Master;
begin
  Recarrega;
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
       Descarrega1;
     end;

  Close ( OwnerFile  );
  Close ( MasterFile );
  Close ( TTFile     );
  Close ( CCFile     );
  Close ( SSFile     );
  Close ( CmpyFile   );
  Close ( BlkStaFile );
  Resp := #00;
end;

Procedure Folha;
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
  If TC = 'S' then
     begin
         MM := CMstMember.MesAtivo;
         AA := CMstMember.AnoAtivo;
         E  := AA div 4;
         If (AA - (E * 4)) = 0 then TabDia[2] := 29
                               else TabDia[2] := 28;
         MMFx := 'M' + QQStr(MM,2,'0');
         IIFx := 'I' + QQStr(MM,2,'0');
         AAFx := QQStr(AA,4,'0');
         E    := AA div 4;
         If (AA - (E * 4)) = 0 then TabDia[2] := 29
                               else TabDia[2] := 28;
         TrocaTabela;

         Assign ( EEFile, (XPath + '\' + FileEE + AAFx + '.' + MMFx ));
         Assign ( MMFile, (XPath + '\' + FileMM + AAFx + '.' + MMFx ));
         Assign ( OOFile, (XPath + '\' + FileOS + AAFx + '.' + MMFx ));
         {$I-}
         Reset ( EEFile );
         {$I+}
         If IOResult <> 0 then
            begin
              ReWrite ( EEFile );
              Reset   ( EEFile );
            end;
         {$I-}
         Reset ( MMFile );
         {$I+}
         If IOResult <> 0 then
            begin
              ReWrite ( MMFile );
              Reset   ( MMFile );
            end;
         {$I-}
         Reset ( OOFile );
         {$I+}
         If IOResult <> 0 then
            begin
              ReWrite ( OOFile );
              Reset   ( OOFile );
            end;
         Assign ( Ind2File, (XPath + '\' + FileInd2 + AAFx + '.' + IIFx ));
         {$I-}
         Reset ( Ind2File );
         {$I+}
         If IOResult <> 0 then ReWrite ( Ind2File )
            else begin
                   DrawBox(3,20,41,22,Red,'S');
                   Color(Red,White);
                   GotoXY(4,21);
                   Write('Carregando Indice [[ 2 ]]   Aguarde');
                   LoadIndex2;
                 end;
         Close  ( Ind2File );
         Assign ( ENFile, (XPath + '\' + FileEN + '.DAT'));
         {$I-}
         Reset ( ENFile );
         {$I+}
         If IOResult <> 0 then
            begin
              ReWrite ( ENFile );
              Reset   ( ENFile );
            end;
         Assign ( DDFile,   (XPath + '\' + FileDD + '.DAT' ));
         Assign ( BBFile,   (XPath + '\' + FileBB + '.DAT' ));
         Assign ( HHFile,   (XPath + '\' + FileHH + '.DAT' ));
         {$I-}
         Reset ( DDFile );
         {$I+}
         If IOResult <> 0 then
            begin
              ReWrite ( DDFile );
              Reset   ( DDFile );
            end;
         {$I-}
         Reset ( BBFile );
         {$I+}
         If IOResult <> 0 then
            begin
              ReWrite ( BBFile );
              Reset   ( BBFile );
            end;
         {$I-}
         Reset ( HHFile );
         {$I+}
         If IOResult <> 0 then
            begin
              ReWrite ( HHFile );
              Reset   ( HHFile );
            end;
         Assign ( Ind3File, (XPath + '\' + FileInd3 ));
         {$I-}
         Reset ( Ind3File );
         {$I+}
         If IOResult <> 0 then ReWrite ( Ind3File )
            else begin
                   DrawBox(3,20,41,22,Blue,'S');
                   Color(Blue,Yellow);
                   GotoXY(4,21);
                   Write('Carregando Indice [[ 3 ]]   Aguarde');
                   LoadIndex3;
                 end;
         Close  ( Ind3File );

         Assign ( TotFile,  (XDrive + '\PLOGTOTL.WRK' ));

         ScreenHeader(XSystem,CMstMember.Descricao,'S');
         MainScreenFrame('Movimentaá∆o','Mestres');
         X  := 4;
         Y  := 12;
         MainScreenTitle1(9);
         MainScreenTitle2(9);
         Move(Mem[$B800:0000],ScArray1[1],4000);
         MostraMes;
         Pg := 1;
         Ut := 'N';
         Sq := '1';
         Repeat
           Resp   := UpCase(ReadKey);
           ProcNo := 99;
           If (Resp = #0 ) and
              (KeyPressed) then
              begin
                If Ut = 'S' then
                   begin
                     Move(ScArray1[1],Mem[$B800:0000],4000);
                     Ut := 'N';
                   end;
                Resp := ReadKey;
                Case Resp of
                     #72 : begin
                             Y := Y - 1;
                             Case Pg of
                                1 : begin
                                      If Y < 12 then Y := 20;
                                      MainScreenTitle1(9);
                                    end;
                                2 : begin
                                      If Y < 10 then Y := 18;
                                      MainScreenTitle2(9);
                                    end;
                             end;
                           end;
                     #80 : begin
                             Y := Y + 1;
                             Case Pg of
                                1 : begin
                                      If Y > 20 then Y := 12;
                                      MainScreenTitle1(9);
                                    end;
                                2 : begin
                                      If Y > 18 then Y := 10;
                                      MainScreenTitle2(9);
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
                                           MainScreenTitle1(9);
                                           MainScreenTitle2(9);
                                         end;
                                     2 : begin
                                           X := 60;
                                           Y := 10;
                                           MainScreenTitle2(9);
                                         end;
                                end;
                              end;
                     #77 : If Pg < 2 then
                              begin
                                Pg := Pg + 1;
                                If Pg = 2 then
                                   begin
                                     X := 60;
                                     Y := 10;
                                     MainScreenTitle1(9);
                                     MainScreenTitle2(9);
                                   end;
                              end;
                end;
              end
              else If Resp <> #27 then
                      begin
                        Case Resp of
                        '?' : begin
                                Ut := 'S';
                                Move(Mem[$B800:0000],ScArray1[1],4000);
                                DrawBox(27,5,56,21,Red,'S');
                                Color(Bfn,Btx);
                                GotoXY(27,05); Write('      Opá‰es  Auxiliares      ');
                                Color(Red,Cyan);
                                GotoXY(28,06); Write('Operaá‰es em Grupo          ');
                                GotoXY(28,07); Write('Rateio por Pontos           ');
                                GotoXY(28,08); Write('Faltas n∆o Justificadas     ');
                                GotoXY(28,09); Write('Abertura de Màs (Reabertura)');
                                GotoXY(28,10); Write('Fetranspor (V.Transporte)   ');
                                GotoXY(28,11); Write('Indexaá∆o dos Arquivos      ');
                                GotoXY(28,12); Write('Descarga de Indices         ');
                                GotoXY(28,13); Write('Empresa                     ');
                                GotoXY(28,14); Write('Exclui ano de Movimento     ');
                                GotoXY(28,15); Write('Imprimir em BackGround      ');
                                GotoXY(28,16); Write('Rotinas Anuais              ');
                                GotoXY(28,17); Write('At.Cadastro c/màs anterior  ');
                                GotoXY(28,18); Write('Importaá∆o de Cadastro(Empr)');
                                GotoXY(28,19); Write('Transporte de Acumulados    ');
                                GotoXY(28,20); Write('Tabela e M¢dulo Cont†bil    ');
                                GotoXY(28,21); Write('Manual do Usu†rio           ');
                                Color(Red,Yellow);
                                GotoXY(41,06); Write('G');
                                GotoXY(39,07); Write('P');
                                GotoXY(39,08); Write('J');
                                GotoXY(28,09); Write('A');
                                GotoXY(28,10); Write('F');
                                GotoXY(28,11); Write('I');
                                GotoXY(28,12); Write('D');
                                GotoXY(28,13); Write('E');
                                GotoXY(29,14); Write('x');
                                GotoXY(40,15); Write('B');
                                GotoXY(28,16); Write('R');
                                GotoXY(31,17); Write('C');
                                GotoXY(31,18); Write('o');
                                GotoXY(31,19); Write('n');
                                GotoXY(28,20); Write('T');
                                GotoXY(28,21); Write('M');
                                Color(Tfn,Ttx);
                              end;
                        'J' : ProcNo := 74;
                        'L' : ProcNo := 75;
                        'G' : ProcNo := 76;
                        'A' : ProcNo := 77;
                        'P' : ProcNo := 78;
                        'F' : ProcNo := 79;
                        'I' : ProcNo := 80;
			'C' : ProcNo := 82;
                        'E' : ProcNo := 83;
                        'D' : ProcNo := 85;
                        'X' : ProcNo := 94;
                        'B' : ProcNo := 95;
                        'M' : ProcNo := 96;
                        'N' : ProcNo := 93;
                        'O' : ProcNo := 92;
                        'R' : ProcNo := 97;
                        'T' : ProcNo := 98;
                        else If Resp = #13 then
                                begin
                                  Case Pg of
                                       1 : Case Y of
                                             12..19 : ProcNo := Y - 11;
                                             20     : Resp   := #27;
                                           end;
                                       2 : ProcNo := Y + 10;
                                  end;
                                end;
                        end;
                        If Ut = 'N'
                           then Move(Mem[$B800:0000],ScArray1[1],4000);
                        If ProcNo <> 99 then
                           begin
                             Move(ScArray1[1],Mem[$B800:0000],4000);
                             Processo;
                             Move(ScArray1[1],Mem[$B800:0000],4000);
                             ShowHeap;
                             Color(Tfn,Ttx);
                             Ut := 'N';
                           end;
                      end
                      else Resp := #13;
         Until Resp = #27;
         Descarrega2;
         Descarrega3;
         CloseFiles;
         TC := #13;
     end;
  If XStAnt = 'I' then
     begin
       ReadWrite(#02,'R','N',CmpyNumber);
       CmpyMember.Status := 'I';
       ReadWrite(#02,'W','N',CmpyNumber);
     end;
  {$I-}
  Close ( MasterFile );
  Close ( TTFile     );
  Close ( CCFile     );
  Close ( SSFile     );
  Close ( CmpyFile   );
  {$I+}
  Resp := #00;
end;

begin
  Tfd         := 3;
  XDriveP     := 'C';
  Op1         := 'S';
  Mch         := 'A';
  I           := 0;
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
  LaserInit  := #27+'E';
  LastCia    := '';
  XPrinter   := '';
  Mudou      := 'N';
  XSystem    := 'P-Log';
  XVersao    := '9.509/1999';
  XData      := XDia + XMes + XAno;

  InitialScreen(XSystem,Op1);
  Move(Mem[$B800:0000],ScArrayM[1],4000);

  SelecionaDrive;

  If TC = 'S'then
     begin
       Move(Mem[$B800:0000],ScArrayM[1],4000);
       Repeat
         Move(ScArrayM[1],Mem[$B800:0000],4000);
         YYAnt := 1;
         Repeat
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
           Release (HeapOrg);
           Color(Tfn,Utx);
           TabI[1]  := ' Folha de Pagamento ';
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
                1   : Folha;
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
