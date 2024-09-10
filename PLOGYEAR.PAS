{$O+,F+}
Unit PlogYear;

Interface

Uses Crt,Dos,PlogGlbs,PlogBasP,PlogTree,PlogFunc;

   Procedure Year;
   Procedure MontaDisco;

   Function FReal(I : Real; D,T : Integer) : Str30;
   Function FString(St1 : Str80; T : Integer) : Str80;
   Function Maiuscula(S : Str80; I : Integer) : Str80;

Implementation

Const
  Zeros        = '000000000000000000000000000000';

Type
   UFIRREG     = RECORD
                   VUfir     : Array[1..12] of Real;
                 END;
Var
  UFIRMember   : UFIRREG;
  UFIRFile     : FILE OF UFIRREG;
  TxtFile      : TEXT;

  Ate5Sal,
  Mais5Sal,
  PerctServProp,
  PerctAdmCoz,
  PerctRefConv,
  PerctRefTransp,
  PerctCestaAlim,
  PerctAlimConv,
  Pag,
  Estab,
  TPag,
  Ad13M,
  Pg13M,
  Linhas,
  NFu          : Integer;
  Ad13,
  Pg13,
  AB,
  TotalR,
  TotalD,
  TotalP,
  TotalI       : Real;
  Porte,
  Simples,
  Pat,
  Encerramento,
  SouA,
  PgS,
  PgO,
  Opt,
  CausaX,
  MudE,
  MudC,
  TipoEmpreg,
  RaisNeg,
  Recibo,
  Ratif,
  Opcao,
  TipoSal,
  TipoInscr,
  Tipo         : Char;
  PgM,
  PgQ1,
  PgQ2,
  HSemana,
  RescCausa,
  Propriet,
  Situacao,
  UFR,
  UF           : String[2];
  DataBase,
  Chegada,
  RescDiaMes,
  MesAnoOpcao,
  DDDResp,
  DDDR,
  AnoBase      : String[4];
  Atividade,
  SerieCT      : String[5];
  RAMALResp,
  NumeroR,
  Numero       : String[6];
  CMuniR       : String[7];
  DRatif,
  DataEncerra,
  QuantReg2,
  QuantEst,
  TELResp,
  FAXResp,
  CepR,
  Cep          : String[8];
  TelFaxR,
  CPFResp,
  CpfR,
  Pis          : String[11];
  CGCAnt       : String[14];
  Ad13s,
  Pg13s,
  Sal          : String[15];
  BairroR,
  Bairro       : String[19];
  UsoEmpresa2,
  UsoEmpresa3,
  UsoEmpresa1,
  ComplR,
  Complemento,
  NMuniR,
  Municipio,
  Nome         : String[30];
  NomeR,
  EndR,
  EMAILResp,
  RSocial,
  Endereco     : String[52];
  A            : Array[1..12] of Real;
  As           : Array[0..12] of Str20;


Procedure ParaContinua;
begin
  Color(Red,Cyan);
  GotoXY(01,24); Write(ConstStr(' ',80));
  GotoXY(20,24); Write('      ',#026,' Para/Continua          ',#026,' Cancela');
  Color(Red,Yellow);
  GotoXY(20,24); Write('Enter');
  GotoXY(47,24); Write('Esc');
  Color(Tfn,Utx);
  NCont := 0;
  DrawBox(26,11,67,21,Sfn,'S');
  Color(Bfn,Btx);
  GotoXY(26,11); Write(' Empregados Selecionados para ImpressÆo   ');
  Color(Sfn,Stx);
  Window(27,13,67,21);
  GotoXY(1,9);
end;


{$I PlogRais.inc }
{$I PlogRDsk.inc }
{$I PlogDirf.inc }
{$I PlogInss.inc }


Procedure UpdateRais;
begin
  EENo := '';
  Repeat
    RecebeCodigo(8,'U','P');
    If EENumber <> Limite then
       begin
         Repeat
           Repeat
             ReadWrite(#08,'R','N',EENumber);
             ReadWrite(#09,'R','N',EENumber);
             If RW = 'N' then
                begin
                  HPMember.Empregado := EENo;
                  For I := 1 to 12 do
                  begin
                    HPMember.RendRais[I]    := 0;
                    HPMember.RendDirf[I]    := 0;
                    HPMember.Dependentes[I] := 0;
                    HPMember.Pensao[I]      := 0;
                    HPMember.IRenda[I]      := 0;
                    HPMember.SalarioFaml[I] := 0;
                    HPMember.ValorInss[I]   := 0;
                  end;
                  HPMember.Ferias_Valor := 0;
                  HPMember.Ferias_Dep   := 0;
                  HPMember.Ferias_IR    := 0;
                  HPMember.Ferias_Mes   := 0;
                  HPMember.Ad13_Valor   := 0;
                  HPMember.Ad13_Mes     := 0;
                  HPMember.Pg13_Valor   := 0;
                  HPMember.Pg13_ValorD  := 0;
                  HPMember.Pg13_IR      := 0;
                  HPMember.Pg13_Dep     := 0;
                  HPMember.Pg13_Mes     := 0;
                  HPMember.ContrSind    := 0;
                end;
             DataRais;
             Resp := ReadKey;
             If (Resp = #0) and (KeyPressed) then
                begin
                  Resp := ReadKey;
                  Case Resp of
                       #59 : begin
                               EEAC := EENo;
                               EEAN := EENumber;
                               ScrollFunc;
                               EENumber := EEAN;
                               EENo     := EEAC;
                             end;
                       #61 : If XSt = 'A' then
                                begin
                                  EntryRais;
                                  If TC = 'S' Then
                                     begin
                                       ReadWrite(#08,'W','N',EENumber);
                                       ReadWrite(#09,'W','N',EENumber);
                                     end;
                                end;
                       #72,#80 : begin
                                   RC := 'N';
                                   Case Resp of
                                        #72 : SearchAnt5 ( Root5 );
                                        #80 : SearchPos5 ( Root5 );
                                   end;
                                   If RC = 'N' then AvisoFinal;
                                 end;
                  end;
                end;
           Until (Resp in [#13,#27]) or ((Resp in [#72,#80]) and (RC <> 'N'));
           Move(ScArray4[1],Mem[$B800:0000],4000);
         Until Resp in [#13,#27];
         TC := #13;
       end;
  Until TC = #27;
end;


Procedure UpdateDirf;
Var
  Op    : Char;
begin
  Op   := '1';
  EENo := '';
  Repeat
    RecebeCodigo(8,'U','N');
    If EENumber <> Limite then
       begin
         Repeat
           Repeat
             ReadWrite(#08,'R','N',EENumber);
             ReadWrite(#09,'R','N',EENumber);
             If RW = 'N' then
                begin
                  HPMember.Empregado := EENo;
                  For I := 1 to 12 do
                  begin
                    HPMember.RendRais[I]    := 0;
                    HPMember.RendDirf[I]    := 0;
                    HPMember.Dependentes[I] := 0;
                    HPMember.Pensao[I]      := 0;
                    HPMember.IRenda[I]      := 0;
                    HPMember.SalarioFaml[I] := 0;
                    HPMember.ValorInss[I]   := 0;
                  end;
                  HPMember.Ferias_Valor := 0;
                  HPMember.Ferias_Dep   := 0;
                  HPMember.Ferias_IR    := 0;
                  HPMember.Ferias_Mes   := 0;
                  HPMember.Ad13_Valor   := 0;
                  HPMember.Ad13_Mes     := 0;
                  HPMember.Pg13_Valor   := 0;
                  HPMember.Pg13_ValorD  := 0;
                  HPMember.Pg13_IR      := 0;
                  HPMember.Pg13_Inss    := 0;
                  HPMember.Pg13_Dep     := 0;
                  HPMember.Pg13_Mes     := 0;
                  HPMember.ContrSind    := 0;
                end;
             Case Op of
                  '1' : DataDirf1;
                  '2' : DataDirf2;
                  '3' : DataDirf3;
             end;
             Resp := ReadKey;
             If (Resp = #0) and (KeyPressed) then
                begin
                  Resp := ReadKey;
                  Case Resp of
                       #59 : begin
                               EEAC := EENo;
                               EEAN := EENumber;
                               ScrollFunc;
                               EENumber := EEAN;
                               EENo     := EEAC;
                             end;
                       #61 : If XSt = 'A' then
                                begin
                                  Case Op of
                                       '1' : EntryDirf1;
                                       '2' : EntryDirf2;
                                       '3' : EntryDirf3;
                                  end;
                                  If TC = 'S' then ReadWrite(#09,'W','N',EENumber);
                                end;
                       #63 : begin
                               Move(ScArray4[1],MemW[$B800:0000],4000);
                               DataDirf1;
                               Op := '1';
                             end;
                       #64 : begin
                               Move(ScArray4[1],MemW[$B800:0000],4000);
                               DataDirf2;
                               Op := '2';
                             end;
                       #65 : begin
                               Move(ScArray4[1],MemW[$B800:0000],4000);
                               DataDirf3;
                               Op := '3';
                             end;
                       #72,#80 : begin
                                   RC := 'N';
                                   Case Resp of
                                        #72 : SearchAnt5 ( Root5 );
                                        #80 : SearchPos5 ( Root5 );
                                   end;
                                   If RC = 'N' then AvisoFinal;
                                 end;
                  end;
                end;
           Until (Resp in [#13,#27]) or ((Resp in [#72,#80]) and (RC <> 'N'));
           Move(ScArray4[1],Mem[$B800:0000],4000);
         Until Resp in [#13,#27];
         TC := #13;
       end;
  Until TC = #27;
end;


Procedure TotaisAnuais;
Var
  R,N,Mes     : Integer;
begin
  Color(Blue,Cyan);
  GotoXY(1,24); Write(ConstStr(' ',80));
  GotoXY(2,24); Write('Calcular totais a partir de que mˆs?');
  Color(Blue,White);
  J := '1';
  Repeat
    InputStr(J,2,39,24,0,'S','S','T','N',Blue,White);
    If J = '' then J := '1';
    Val(J,Mes,E);
    If (Mes > 0) and (Mes < 12) then Confirma;
  Until (TC in [#27,'S']);
  If TC = 'S' then
     begin
       LoadIndex6('E','N');
       EENo := '';
       Repeat
         RC := 'N';
         SearchPos5 ( Root5 );
         If RC = 'S' then
            begin
              ReadWrite(#09,'R','N',EENumber);
              HPMember.Empregado := EENo;
              For N := Mes to 12 do
              begin
                HPMember.RendRais[N]    := 0;
                HPMember.RendDirf[N]    := 0;
                HPMember.Dependentes[N] := 0;
                HPMember.Pensao[N]      := 0;
                HPMember.IRenda[N]      := 0;
                HPMember.SalarioFaml[N] := 0;
                HPMember.ValorInss[N]   := 0;
              end;
              HPMember.Ferias_Valor := 0;
              HPMember.Ferias_Dep   := 0;
              HPMember.Ferias_IR    := 0;
              HPMember.Ferias_Mes   := 0;
              HPMember.Ad13_Valor   := 0;
              HPMember.Ad13_Mes     := 0;
              HPMember.Pg13_Valor   := 0;
              HPMember.Pg13_ValorD  := 0;
              HPMember.Pg13_IR      := 0;
              HPMember.Pg13_Inss    := 0;
              HPMember.Pg13_Dep     := 0;
              HPMember.Pg13_Mes     := 0;
              HPMember.ContrSind    := 0;
              ReadWrite(#09,'W','N',EENumber);
            end;
       Until RC = 'N';
       Close ( EEFile );
       Close ( MMFile );
       Color(Blue,Yellow);
       GotoXY(1,23); Write(ConstStr(' ',80));
       GotoXY(2,23); Write('Calculando os totais anuais, Aguarde..');
       Color(Red,White);
       GotoXY(1,24); Write(ConstStr(' ',80));
       For N := Mes to 12 do
       begin
         TTNo := AAFx + QQStr(N,2,'0') + '1';
         SearchTree4 ( Root4 );
         If RC = 'S' then ReadWrite(#03,'R','N',TTNumber);
         GotoXY(2,24); Write(Pushleft(20,ArrayMesEx[N]+' de '+AAFx));
         Assign ( EEFile, (XPath + '\' + FileEE + AAFx + '.M' + QQStr(N,2,'0')));
         {$I-}
         Reset ( EEFile );
         {$I+}
         If IOResult = 0 then
            begin
              Assign ( Ind2File, (XPath + '\' + FileInd2 + AAFx + '.I' + QQStr(N,2,'0')));
              {$I-}
              Reset ( Ind2File );
              {$I+}
              If IOResult <> 0 then ReWrite ( Ind2File )
                 else begin
                        If Root5 <> NIL then
                           begin
                             Dispose5 ( Root5 );
                             Root5 := NIL;
                           end;
                        LoadIndex2;
                      end;
              Close  ( Ind2File );
              Assign ( MMFile, (XPath + '\' + FileMM + AAFx + '.M' + QQStr(N,2,'0')));
              {$I-}
              Reset ( MMFile );
              {$I+}
              If (IOResult = 0) and (FileSize(EEFile) > 0) then
                 begin
                   EENo := '';
                   Repeat
                     RC := 'N';
                     SearchPos5 ( Root5 );
                     If RC = 'S' then
                        begin
                          XXNo := EENo;
                          SearchTree6 ( Root6 );
                          ReadWrite(#08,'R','N',EENumber);
                          If RC = 'N' then
                             begin
                               EEMember.Status := 'X';
                               RC := 'S';
                             end;
                        end;
                     If (RC = 'S') and (EEMember.Status <> 'X') then
                        begin
{                          Case EEMember.Grau[1] of
                               '1' : EEMember.Grau := '1';
                               '2' : If EEMember.Grau = '20' then EEMember.Grau := '2'
                                        else If EEMember.Grau = '25' then EEMember.Grau := '3';
                               '3' : If EEMember.Grau = '30' then EEMember.Grau := '4'
                                        else If EEMember.Grau = '35' then EEMember.Grau := '5';
                               '4' : If EEMember.Grau = '40' then EEMember.Grau := '6'
                                        else If EEMember.Grau = '45' then EEMember.Grau := '7';
                               '5' : If EEMember.Grau = '50' then EEMember.Grau := '8'
                                        else If EEMember.Grau = '55' then EEMember.Grau := '9';
                          end; }
                          ReadWrite(#08,'W','N',EENumber);

                          ReadWrite(#09,'R','N',XXNumber);
                          LoadMVDsk(#11);
                          YYNo := '';
                          Repeat
                            RC := 'N';
                            SearchPosY ( RootY );
                            If (RC                  = 'S') and
                               (YAddress^.AcMensalV > 0  ) then
                               begin
                                 CCNo := YYNo;
                                 SearchTree1 ( Root1 );
                                 If RC = 'S' then
                                    begin
                                      ReadWrite(#04,'R','N',CCNumber);
                                      If RW = 'S'then
                                         begin
                                           Case CCMember.Operacao of
                                           'P' : begin
                                                   If CCMember.Bases[1] = 'F' then
                                                      begin
                                                        HPMember.Ferias_Mes := N;
                                                        Case CCMember.Tipo of
                                                             'P' : HPMember.Ferias_Valor := HPMember.Ferias_Valor +
                                                                                            TruncX(YAddress^.AcMensalV);
                                                             'D' : HPMember.Ferias_Valor := HPMember.Ferias_Valor -
                                                                                            TruncX(YAddress^.AcMensalV);
                                                        end;
                                                      end;
                                                   If (YYNo = '081') or (YYNo = 'R81') then
                                                      begin
                                                        HPMember.RendRais[N] := HPMember.RendRais[N] +
                                                                                TruncX(YAddress^.AcMensalV);
                                                        HPMember.RendDirf[N] := HPMember.RendDirf[N] +
                                                                                TruncX(YAddress^.AcMensalV);
                                                      end;
                                                   If YYNo = '070' then HPMember.Pensao[N] := HPMember.Pensao[N] +
                                                                                              TruncX(YAddress^.AcMensalV);
                                                 end;
                                           'S' : If (CCMember.Bases[4] = 'S') or
                                                    (CCMember.Bases[5] = 'S') then
                                                    begin
                                                      If CCMember.Bases[4] = 'S' then
                                                         begin
                                                           If YYNo = '004' then
                                                              begin
                                                                HPMember.Ad13_Valor := YAddress^.AcMensalV;
                                                                HPMember.Ad13_Mes   := N;
                                                              end
                                                              else begin
                                                                     HPMember.Pg13_Mes := N;
                                                                     Case CCMember.Tipo of
                                                                          'P' : HPMember.Pg13_Valor := HPMember.Pg13_Valor +
                                                                                                TruncX(YAddress^.AcMensalV);
                                                                          'D' : HPMember.Pg13_Valor := HPMember.Pg13_Valor -
                                                                                                TruncX(YAddress^.AcMensalV);
                                                                     end;
                                                                     If YYNo = '079'
                                                                        then HPMember.Pensao[N] := HPMember.Pensao[N] +
                                                                                              TruncX(YAddress^.AcMensalV);
                                                                   end;
                                                         end;
                                                      If (CCMember.Bases[1] = '1'  ) and
                                                         (CCMember.Bases[5] = 'S'  ) and
                                                         (YYNo             <> '004') then
                                                         Case CCMember.Tipo of
                                                              'P' : HPMember.Pg13_ValorD := HPMember.Pg13_ValorD +
                                                                                            TruncX(YAddress^.AcMensalV);
                                                              'D' : HPMember.Pg13_ValorD := HPMember.Pg13_ValorD -
                                                                                            TruncX(YAddress^.AcMensalV);
                                                         end;
                                                    end;
                                           'O' : If (CCMember.Bases[4] = 'S'  ) and
                                                    (YYNo              = '004') then
                                                    begin
                                                      HPMember.Ad13_Valor := YAddress^.AcMensalV;
                                                      HPMember.Ad13_Mes   := N;
                                                    end;
                                           end;
                                           If (YYNo = '003') or (YYNo = 'R06')
                                              then HPMember.SalarioFaml[N] := HPMember.SalarioFaml[N] +
                                                                              TruncX(YAddress^.AcMensalV);
                                           If ((YYNo = 'R04') or (YYNo = 'R05')) and
                                              (CCMember.Bases[4] = 'S') then
                                              begin
                                                HPMember.Pg13_Mes    := N;
                                                HPMember.Pg13_Valor  := HPMember.Pg13_Valor +
                                                                        TruncX(YAddress^.AcMensalV);
                                                HPMember.Pg13_ValorD := HPMember.Pg13_ValorD +
                                                                        TruncX(YAddress^.AcMensalV);
                                              end;
                                           If YYNo = 'R02'
                                              then HPMember.ContrSind := TruncX(YAddress^.AcMensalV);
                                           If (YYNo = '061') or (YYNo = 'R50')
                                              then HPMember.ValorInss[N] := HPMember.ValorInss[N] +
                                                                            TruncX(YAddress^.AcMensalV);
                                        {   If (YYNo = '064') or (YYNo = 'R51')
                                              then HPMember.Pg13_Inss := HPMember.Pg13_Inss +
                                                                         TruncX(YAddress^.AcMensalV);   }

                                           If (YYNo = '060') or (YYNo = 'R54')
                                              then HPMember.IRenda[N] := HPMember.IRenda[N] + TruncX(YAddress^.AcMensalV);
                                           If (YYNo = '058') or (YYNo = 'R53') then HPMember.Ferias_IR := HPMember.Ferias_IR +
                                                                                    TruncX(YAddress^.AcMensalV);
                                           If (YYNo = '068') or (YYNo = 'R55')
                                              then HPMember.Pg13_IR := HPMember.Pg13_IR + TruncX(YAddress^.AcMensalV);
                                         end;
                                    end
                                    else RC := 'S';
                               end;
                          Until RC = 'N';
                          If HPMember.IRenda[N] > 0
                             then HPMember.Dependentes[N] := TTMember.DependenteIR * EEMember.DepIR;
                          If HPMember.Ferias_IR > 0
                             then HPMember.Ferias_Dep := TTMember.DependenteIR * EEMember.DepIR;
                          If HPMember.Pg13_IR > 0
                             then HPMember.Pg13_Dep := TTMember.DependenteIR * EEMember.DepIR;
                          ReadWrite(#09,'W','N',XXNumber);
                          LiberaMVDsk;
                          RC := 'S';
                        end;
                   Until RC = 'N';
                   Close ( MMFile );
                 end
                 else If FileSize(EEFile) = 0 then Close (MMFile);
              Close ( EEFile );
            end;
       end;
       Assign ( EEFile, (XPath + '\' + FileEE + AAFx + '.' + MMFx));
       Reset  ( EEFile );
       Assign ( MMFile, (XPath + '\' + FileMM + AAFx + '.' + MMFx ));
       Reset  ( MMFile );
       Assign ( Ind2File, (XPath + '\' + FileInd2 + AAFx + '.'+ IIFx));
       Reset ( Ind2File );
       If Root5 <> NIL then
          begin
            Dispose5 ( Root5 );
            Root5 := NIL;
          end;
       LoadIndex2;
       Close  ( Ind2File );
       If Root6 <> NIL then
          begin
            Dispose6 ( Root6 );
            Root6 := NIL;
          end;
       EENo := '';
       Color(Blue,Yellow);
       GotoXY(1,23); Write(ConstStr(' ',80));
       GotoXY(2,23); Write('Os totais foram recalculados.');
       TeclaReturn;
     end;
end;


Procedure Year;
begin
  Assign ( HPFile, (XPath + '\' + FileHP + AAFx + '.DAT'));
  {$I-}
  Reset ( HPFile );
  {$I+}
  If IOResult <> 0 then ReWrite ( HPFile );
  TabI[1]  := ' Calcular Totais Anuais  ';
  TabI[2]  := ' Informa‡”es para RAIS   ';
  TabI[3]  := ' Informa‡”es para DIRF   ';
  TabI[4]  := ' 48 £ltimas Contr.INSS   ';
  TabI[5]  := ' Info. para RAIS (papel) ';
  TabI[6]  := ' EmissÆo da RAIS (disco) ';
  TabI[7]  := ' Relat¢rio da DIRF       ';
  TabI[8]  := ' Informe de rendimentos  ';
  TabI[9]  := ' Contribui‡”es do INSS   ';
  TabI[10] := ' Encerrar a fun‡Æo       ';
  TabX[1]  := 5;
  TabX[2]  := 5;
  TabX[3]  := 5;
  TabX[4]  := 5;
  TabX[5]  := 5;
  TabX[6]  := 31;
  TabX[7]  := 31;
  TabX[8]  := 31;
  TabX[9]  := 31;
  TabX[10] := 31;
  TabY[1]  := 13;
  TabY[2]  := 14;
  TabY[3]  := 15;
  TabY[4]  := 16;
  TabY[5]  := 17;
  TabY[6]  := 13;
  TabY[7]  := 14;
  TabY[8]  := 15;
  TabY[9]  := 16;
  TabY[10] := 17;
  YY := 1;
  Repeat
    RetMenuAuxiliar(4,12,10,1,6);
    Move(Mem[$B800:0000],ScArray5[1],4000);
    Case YY of
         1     : TotaisAnuais;
         2,3   : begin
                   If YY = 2 then Titulo := 'Informa‡”es para RAIS'
                             else Titulo := 'Informa‡”es para DIRF';
                   BuildFrame('S');
                   Color(Red,White);
                   GotoXY(36,07); Write('Total de Empreg: ');
                   GotoXY(62,09); Write(#27,#217);
                   GotoXY(62,10); Write(#24);
                   GotoXY(62,11); Write(#25);
                   GotoXY(62,13); Write('F1');
                   GotoXY(62,15); If XSt = 'A' then Write('F3');
                   GotoXY(62,16); If YY = 3 then Write('F5');
                   GotoXY(62,17); If YY = 3 then Write('F6');
                   GotoXY(62,18); If YY = 3 then Write('F7');
                   Color(Red,Yellow);
                   GotoXY(53,07); Write(CMstMember.NFunc);
                   GotoXY(66,09); Write('C¢digo      ');
                   GotoXY(66,10); Write('Anterior    ');
                   GotoXY(66,11); Write('Pr¢ximo     ');
                   GotoXY(66,13); Write('Empregados  ');
                   GotoXY(66,15); If XSt = 'A' then Write('Alterar    ');
                   GotoXY(66,16); If YY = 3 then Write('Rendimentos');
                   GotoXY(66,17); If YY = 3 then Write('S.Faml/INSS');
                   GotoXY(66,18); If YY = 3 then Write('F‚rias/13§S');
                   Shade(3,8,60,21,LightGray,Black);
                   Color(Tfn,Ttx);
                   GotoXY(04,08); Write('Matr¡c:');
                   Move(MemW[$B800:0000],ScArray4[1],4000);
                   If YY = 2 then UpdateRais
                             else UpdateDirf;
                 end;
         4     : begin
                   Titulo := '48 £ltimas Contribui‡”es do INSS';
                   BuildFrame('S');
                   ProcessInss;
                 end;
         5     : begin
                   Titulo := 'Informa‡”es para RAIS (papel)';
                   BuildFrame('S');
                   ProcessRais;
                 end;
         6     : If MM = 12 then
                    begin
                      Titulo := 'EmissÆo da RAIS (disco)';
                      BuildFrame('S');
                      ProcessRaisD;
                    end
                    else begin
                           ErroMsg := 'O mˆs nÆo ‚ dezembro.';
                           ErrorMessage;
                         end;
         7     : begin
                   Titulo := 'EmissÆo da DIRF (papel)';
                   BuildFrame('S');
                   ProcessDirf;
                 end;
         8     : begin
                   Titulo := 'Informe de Rendimentos';
                   BuildFrame('S');
                   Color(Tfn,Ttx);
                   GotoXY(4,9); Write('Matr¡c:');
                   Move(Mem[$B800:0000],ScArray4[1],4000);
                   InformeRend;
                 end;
         9     : begin
                   Titulo := '48 £ltimas Contribui‡”es do INSS';
                   BuildFrame('S');
                   Color(Tfn,Ttx);
                   GotoXY(4,9); Write('Matr¡c:');
                   Move(Mem[$B800:0000],ScArray4[1],4000);
                   SalContribuicao;
                 end;
         10    : Resp := #27;
    end;
    Move(ScArray5[1],MemW[$B800:0000],4000);
  Until Resp = #27;
  Close  ( HPFile );
  Resp := #00;
  TC   := #13;
end;


end.

