{$O+,F+}
Unit PlogRpt3;

Interface

Uses Crt,Dos,PlogGlbs,PlogBasP,PlogTree,PlogRpt0,PlogRpt5;


   Procedure ProcNo09Report;
   Procedure ProcNo13Report;
   Procedure ProcNo17Report;



Implementation

Var
  TF,DiaI,DiaF     : Integer;
  Nome             : Array[1..2]  of String[40];
  Mat              : Array[1..2]  of String[8];
  Sala,Ramal       : Array[1..2]  of String[5];
  Tel              : Array[1..2]  of String[15];


Procedure PedeProcNo09;
begin
  Color(Tfn,Ttx);
  GotoXY(04,11); Write('R ou G:');
  Tx := 'R';
  Repeat
    J := Tx;
    InputStr(J,1,12,11,0,'S','N','T','N',Tfn,Utx);
    If TC <> #27 then
       begin
         Tx := UpCase(J[1]);
         GotoXY(12,11);
         Case Tx of
              'G' : Write('Guia (GRCS) ');
              'R' : Write('Relat¢rio   ');
              else begin
                     ErroMsg := 'Tipo inv lido';
                     ErrorMessage;
                     TC := #00;
                   end;
         end;
       end;
    If TC = #13 then Confirma;
  Until TC in [#27,'S'];
end;


Procedure ProcNo09Report;
begin
  PedeProcNo09;
  If TC = 'S' then
     begin
       LoadIndex6 ('S',Tr);
       Str(AA:2,AAx);
       L1 := Nx+'Contribui‡„o Sindical em '+Nf+
             ArrayMesEx[MM]+'/'+AAx;
       L3 := ' ';
       L6 := 'Matr¡cula Nome do Empregado'+ConstStr(' ',24)+
             'Cargo'+ConstStr(' ',12)+'Contribui‡„o';
       ParaContinua;
       Janela('F');
       SSNo  := '';
       Repeat
         RC := 'N';
         SearchPos2 ( Root2 );
         If RC = 'S' then
            begin
              ReadWrite(#07,'R','N',SSNumber);
              L4   := SSMember.Descricao;
              R1   := 0;
              XXNo := SSNo + '#';
              GRCSMember.Cia         := CmpyNo;
              GRCSMember.Func        := 0;
              GRCSMember.NFunc       := 0;
              GRCSMember.VGuia[1]    := 0;
              GRCSMember.VGuia[2]    := 0;
              GRCSMember.Tipo        := '3';
              GRCSMember.Descricao   := SSMember.Descricao;
              GRCSMember.Descricao2  := SSMember.Descricao2;
              GRCSMember.Endereco    := SSMember.Endereco;
              GRCSMember.Numero      := SSMember.Numero;
              GRCSMember.Complemento := SSMember.Complemento;
              GRCSMember.Bairro      := SSMember.Bairro;
              GRCSMember.Cidade      := SSMember.Cidade;
              GRCSMember.Estado      := SSMember.Estado;
              GRCSMember.Cep         := SSMember.Cep;
              GRCSMember.Cgc         := SSMember.Cgc;
              GRCSMember.Cod         := SSMember.Cod;
              Repeat
                RC := 'N';
                SearchPos6 ( Root6 );
                If RC = 'S' then
                   begin
                     ReadWrite(#08,'R','N',XXNumber);
                     If (RW                 = 'S' ) and
                        (EEMember.Sindicato = SSNo) then
                        begin
                          EENo := EEMember.Matricula;
                          LoadMVDsk(#11);
			  YYNo := '050';
                          SearchTreeY ( RootY );
                          If (RC                  = 'S') and
                             (YAddress^.AcMensalV <> 0 ) then
                             begin
                               NCont := NCont + 1;
                               Writeln(EEMember.Nome);
                               GRCSMember.Func := GRCSMember.Func + 1;
                               If EEMember.Tipo = 'H'
                                  then GRMember.VGuia[1] := GRMember.VGuia[1] +
                                                            TruncX((EEMember.Salario * EEMember.HNormais) / 30)
                                  else GRMember.VGuia[1] := GRMember.VGuia[1] +
                                                            TruncX(EEMember.Salario / 30);
                               GRCSMember.VGuia[2] := GRCSMember.VGuia[2] +
                                                      TruncX(YAddress^.AcMensalV);
                               If Tx = 'R' then
                                  begin
                                    If ContLin > 56 then HeaderReport;
                                    WriteLine('L',PushLeft(10,EEMember.Matricula)+
                                                  Acentua(EEMember.Nome)+
                                                  ConstStr(' ',41-Length(EEMember.Nome))+
                                                  Acentua(EEMember.Cargo)+
                                                  ConstStr(' ',16-Length(EEMember.Cargo))+
                                                  PushRight(13,EditReal(YAddress^.AcMensalV)));
                                  end;
                             end
                             else If YAddress^.AcMensalV = 0 then GRCSMember.NFunc := GRCSMember.NFunc + 1;
                          LiberaMVDsk;
                          RC := 'S';
                        end;
                   end;
                GoNoGo;
                If TC = #27 then RC := 'N';
              Until RC = 'N';
              RC := 'S';
              If (GRCSMember.VGuia[2] > 0  ) and
                 (Tx                  = 'R') then
                 begin
                   TC := #13;
                   WriteLine('L',ConstStr(' ',65)+ConstStr('-',15));
                   WriteLine('L',ConstStr(' ',65)+
                                 PushRight(15,EditReal(GRCSMember.VGuia[2])));
                   Footer;
                   If DskRpt = 'N' then WriteLine('W',Qp);
                 end
                 else If GRCSMember.Func > 0 then
                         begin
                           Case DskRpt of
                                'D' : TC := 'S';
                                'N' : ImprimeAgora;
                           end;
                           Case TC of
                                'A','S' : begin
                                            If TC = 'A' then FormTest('S','N','***')
                                                        else TC := 'S';
                                            If TC = 'S' then ImprimeGRCS;
                                          end;
                                'G'     : begin
                                            Assign ( GRCSFile, (XDrive + '\GRCS__'+AAx+'.DAT'));
                                            {$I-}
                                            Reset ( GRCSFile );
                                            {$I+}
                                            If IOResult <> 0 then
                                               begin
                                                 ReWrite ( GRCSFile );
                                                 Reset   ( GRCSFile );
                                               end;
                                            Seek  ( GRCSFile, FileSize(GRCSFile));
                                            Write ( GRCSFile, GRCSMember        );
                                            Close ( GRCSFile );
                                          end;
                           end;
                         end;
              ContLin := 10000;
            end;
       Until RC = 'N';
       FuncImpressos;
     end;
end;


Procedure ProcNo13Report;
Var
  CC,Sel,Usa,Tot     : Char;
  Pct                : Real;
begin
  Color(Tfn,Ttx);
  GotoXY(4,10); Write('Etapa..:');
  CC  := 'N';
  Usa := 'E';
  Tot := 'S';
  Repeat
    K  := 1;
    Repeat
      Case K of
           1 : begin
                 Color(Blue,Cyan);
                 GotoXY(1,24); Write(ConstStr(' ',80));
                 GotoXY(2,24); Write('Informe se  agamento,  3§Sal rio ou  mbos.   (Enter = P)');
                 Color(Blue,White);
                 GotoXY(13,24); Write('P');
                 GotoXY(24,24); Write('1');
                 GotoXY(38,24); Write('A');
                 Color(Tfn,Utx);
                 GotoXY(13,10); Write(ConstStr(' ',20));
                 J := '';
                 InputStr(J,1,13,10,0,'S','N','T','N',Tfn,Utx);
                 LimpaLn(24,Tfd);
                 Eta := UpCase(J[1]);
                 GotoXY(13,10);
                 If TC <> #27 then
                    Case Eta of
                         'A' : Write('Pag.e 13§Sal rio');
                         'P' : Write('Pagamento       ');
                         '1' : Write('13§ Sal rio     ');
                         else  begin
                                 Eta := 'P';
                                 Write('Pagamento       ');
                               end;
                    end;
               end;
           2 : PedeDepto(11,'*');
           3 : If DDNo <> '' then
                  begin
                    Color(Tfn,Ttx);
                    GotoXY(4,12); Write('C.Custo:');
                    J := CC;
                    InputStr(J,1,13,12,0,'S','N','T','N',Tfn,Utx);
                    CC := UpCase(J[1]);
                    GotoXY(13,12);
                    If TC <> #27 then
                       Case CC of
                            'N' : Write('NÆo');
                            'S' : Write('Sim');
                            else begin
                                   CC := 'N';
                                   Write('NÆo');
                                 end;
                       end;
                  end;
           4 : If DDNo <> '' then
                  begin
                    Color(Tfn,Ttx);
                    GotoXY(4,13); Write('Usa E/D:');
                    J := Usa;
                    InputStr(J,1,13,13,0,'S','N','T','N',Tfn,Utx);
                    Usa := UpCase(J[1]);
                    GotoXY(13,13);
                    If TC <> #27 then
                       Case Usa of
                            'E' : Write('Empresa (p/preencher a GRPS)');
                            'D' : Write('Depto.  (p/preencher a GRPS)');
                            else begin
                                   ErroMsg := 'Que Endere‡o/Tipo usar E ou D';
                                   ErrorMessage;
                                   K := K - 1;
                                 end;
                       end;
                  end;
           5 : begin
                 Color(Tfn,Ttx);
                 GotoXY(4,14); Write('Tot.S/N:');
                 J := Tot;
                 InputStr(J,1,13,14,0,'S','N','T','N',Tfn,Utx);
                 Tot := UpCase(J[1]);
                 GotoXY(13,14);
                 If TC <> #27 then
                    Case Tot of
                         'N' : Write('NÆo     (deixar Total em branco)');
                         'S' : Write('Sim     (imprimir o Total)      ');
                         else begin
                                ErroMsg := 'Imprimir o Total, informe S ou N';
                                ErrorMessage;
                                K := K - 1;
                              end;
                    end;
               end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 6) or (TC = #27);
    If TC <> #27 then Confirma;
  Until TC in ['S',#27];
  If TC = 'S' then
     begin
       Color(Sfn,Stx);
       If DDNo <> '' then
          begin
            If CC = 'N' then L6 := ' Departamento '+PushLeft(12,DDNo)
                        else L6 := ' C.Custo '+PushLeft(16,DDNo);
          end
          else L6 := ' Totaliza‡„o Geral ';
       Color(Red,Yellow);
       GotoXY(35,07); Write(PushLeft(35,L6));
       Color(Red,White);
       GotoXY(61,07);
       Case Eta of
            'A' : begin
                    Write('Pag/13Sal.');
                    L6 := L6 + '(Pag/13Sal.)';
                  end;
            '1' : begin
                    Write('13.Sal rio');
                    L6 := L6 + '(13.Sal rio)';
                  end;
            'P' : begin
                    Write('Pagamento');
                    L6 := L6 + '(Pagamento)';
                  end;
       end;
       Color(Tfn,Ttx);
       GotoXY(4,08); Write('08 . N§ de Empregados........: ');
       GotoXY(4,09); Write('   . Empregados..............:                   ');
       GotoXY(4,10); Write('   . Empreg./Aut“nomos.......:                   ');
       GotoXY(4,11); Write('   . C¢d.SAT ',PushLeft(11,CMstMember.Cod_Sat),
                           '.....:                   ',
                           CMstMember.Alq_Sat:5:2,'%');
       GotoXY(4,12); Write('16 Segurados.......... 1031  :                   ');
       GotoXY(4,13); Write('17 Empresa............ 1040  :                   ');
       GotoXY(4,14); Write('18 Terceiros.......... ',
                           PushLeft(6,CMstMember.Terceiros),
                           ':                   ',
                           CMstMember.Alq_Terceiros:5:2,'%');
       GotoXY(4,15); Write('19 Espec¡fico......... ',
                           PushLeft(6,CMstMember.Cod_19),
                           ':                   ');
       GotoXY(4,16); Write('20 Espec¡fico......... ',
                           PushLeft(6,CMstMember.Cod_20),
                           ':                  ');
       GotoXY(4,17); Write('21 1058 Dedu‡”es FPAS........:                   ');
       GotoXY(4,18); Write('   . Sal rio fam¡lia.........:                   ');
       GotoXY(4,19); Write('   . Sal rio maternidade.....:                   ');
       GotoXY(4,20); Write('   . Aux¡lio natalidade......:                   ');
       GotoXY(4,21); Write('22 Total L¡quido.............:                   ');
       For I := 1 to 15 do GuiaMember.VGuia[I] := 0;
       GuiaMember.Endereco  := '';
       GuiaMember.Cidade    := '';
       GuiaMember.Estado    := '';
       GuiaMember.Cep       := '';
       GuiaMember.GRPSTipo  := ' ';
       GuiaMember.GRPSIdent := '';
       If CC = 'S' then LoadIndex6 ('E','C')
                   else LoadIndex6 ('E','N');
       If TC <> #27 then
          begin
            ParaContinua;
            XXNo := '';
            Repeat
              RC := 'N';
              SearchPos6 ( Root6 );
              If RC = 'S' then
                 begin
                   ReadWrite(#08,'R','N',XXNumber);
                   Pct := 100;
                   Sel := 'N';
                   Case CC of
                        'N' : Case Ex of
                                   'D' : If EEMember.Depto = DDNo then Sel := 'S';
                                   'X' : begin
                                           DDNo := EEMember.Depto;
                                           SearchTree3 ( Root3 );
                                           If RC = 'S' then ReadWrite(#05,'R','N',DDNumber)
                                                       else RC := 'S';
                                           If (EEMember.Depto = DDNo) and
                                              (DDMember.Marca = #004) then Sel := 'S';
                                         end;
                                   'N' : If DDNo = '' then Sel := 'S';
                                   '*' : If (EEMember.Depto = DDNo) or
                                            (DDNo           = Copy(EEMember.Depto,1,Length(DDNo))) then Sel := 'S';
                              end;
                        'S' : If DDNo <> '' then
                                 For I := 1 to 5
                                 do If DDNo = EEMember.CentroC[I] then
                                       begin
                                         Sel := 'S';
                                         Pct := EEMember.DiasC[I];
                                       end;
                   end;
                   If (Sel = 'S') and not (EEMember.Status in ['R','V','X']) then
                      begin
                        Pct  := Pct / 100;
                        EENo := EEMember.Matricula;
                        LoadMVDsk(#11);
                        If (EEMember.Vinculo[1] <> 'A') and
                           (EEMember.Vinculo[1] <> 'N') then
                           begin
                             GuiaMember.VGuia[1] := GuiaMember.VGuia[1] + 1;
                             GotoXY(35,08); Write(GuiaMember.VGuia[1]:17:0);
                           end;
                        YYNo := '';
                        Repeat
                          RC := 'N';
                          SearchPosY ( RootY );
                          If RC = 'S' then
                             begin
                               If (((YYNo = '081') or (YYNo = 'R81') or (YYNo = 'R85')) and
                                  (Eta in ['A','P'])) or ((YYNo = '085') and (Eta in ['A','1'])) then
                                  begin
                                    GuiaMember.VGuia[2] := GuiaMember.VGuia[2] + TruncX(YAddress^.AcMensalV * Pct);
                                    GotoXY(35,09); Write(EditReal(GuiaMember.VGuia[2]):17);
                                  end;
                               If (YYNo = '080') and (Eta in ['A','P']) then
                                  begin
                                    GuiaMember.VGuia[3] := GuiaMember.VGuia[3] + TruncX(YAddress^.AcMensalV * Pct);
                                    GotoXY(35,10); Write(EditReal(GuiaMember.VGuia[3]):17);
                                  end;
                               If (((YYNo = '061') or (YYNo = 'R50') or (YYNo = 'R51')) and
                                   (Eta in ['A','P'])) or ((YYNo = '064') and (Eta in ['A','1'])) then
                                  begin
                                    GuiaMember.VGuia[5] := GuiaMember.VGuia[5] + TruncX(YAddress^.AcMensalV * Pct);
                                    GotoXY(35,12); Write(EditReal(GuiaMember.VGuia[5]):17);
                                  end;
                               If (((YYNo = '062') or (YYNo = 'R71') or (YYNo = 'R72')) and (Eta in ['A','P'])) or
                                  ((YYNo = '071') and (Eta in ['A','1'])) then
                                  begin
                                    GuiaMember.VGuia[6] := GuiaMember.VGuia[6] + TruncX(YAddress^.AcMensalV * Pct);
                                    GotoXY(35,13); Write(EditReal(GuiaMember.VGuia[6]):17);
                                  end;
                               If (((YYNo = '003') or (YYNo = 'R06')) and (Eta in ['A','P'])) then
                                  begin
                                    GuiaMember.VGuia[10] := GuiaMember.VGuia[10] + TruncX(YAddress^.AcMensalV * Pct);
                                    GuiaMember.VGuia[11] := GuiaMember.VGuia[11] + TruncX(YAddress^.AcMensalV * Pct);
                                    GotoXY(35,18); Write(EditReal(GuiaMember.VGuia[11]):17);
                                  end;
                               If ((YYNo = '032') or (YYNo = 'R10')) and (Eta in ['A','P']) then
                                  begin
                                    GuiaMember.VGuia[10] := GuiaMember.VGuia[10] + TruncX(YAddress^.AcMensalV * Pct);
                                    GuiaMember.VGuia[12] := GuiaMember.VGuia[12] + TruncX(YAddress^.AcMensalV * Pct);
                                    GotoXY(35,19); Write(EditReal(GuiaMember.VGuia[12]):17);
                                  end;
                               If (YYNo = '033') and (Eta in ['A','P']) then
                                  begin
                                    GuiaMember.VGuia[10] := GuiaMember.VGuia[10] + TruncX(YAddress^.AcMensalV * Pct);
                                    GuiaMember.VGuia[13] := GuiaMember.VGuia[13] + TruncX(YAddress^.AcMensalV * Pct);
                                    GotoXY(35,20); Write(EditReal(GuiaMember.VGuia[13]):17);
                                  end;
                             end;
                        Until RC = 'N';
                        LiberaMVDsk;
                        RC := 'S';
                      end;
                 end;
            Until RC = 'N';
            If CMstMember.Alq_SAt <> 0 then
               begin
                 GuiaMember.VGuia[4] := TruncX((GuiaMember.VGuia[2] * CMstMember.Alq_SAt) / 100);
                 GotoXY(35,11); Write(EditReal(GuiaMember.VGuia[4]):17);
               end;
            If CMstMember.Alq_Terceiros <> 0 then
               begin
                 GuiaMember.VGuia[7] := TruncX((GuiaMember.VGuia[2] * CMstMember.Alq_Terceiros) / 100);
                 GotoXY(35,14); Write(EditReal(GuiaMember.VGuia[7]):17);
               end;
            GuiaMember.VGuia[10] := TruncX(GuiaMember.VGuia[11] + GuiaMember.VGuia[12] + GuiaMember.VGuia[13]);
            GotoXY(35,17); Write(EditReal(GuiaMember.VGuia[10]):17);
            Repeat
              I := 2;
              Repeat
                If GuiaMember.VGuia[I] = 0 then J := ''
                                 else begin
                                        Str(GuiaMember.VGuia[I]:17:2,J);
                                        J := LeftAdjust(J);
                                      end;
                InputStr(J,17,35,(7 + I),0,'S','N','T','N',Tfn,Utx);
                If (((7 + I) = 11) or ((7 + I) = 14)) and
                   (J[1] = '%') then
                   begin
                     Delete(J,1,1);
                     Val(J,R1,E);
                     GuiaMember.VGuia[I] := TruncX((GuiaMember.VGuia[2] * R1) / 100);
                   end
                   else Val(J,GuiaMember.VGuia[I],E);
                GotoXY(35,(7+I)); Write(EditReal(GuiaMember.VGuia[I]):17);
                Case TC of
                     #13 : I := I + 1;
                     #24 : If I > 2 then I := I - 1;
                end;
                GuiaMember.VGuia[10] := TruncX(GuiaMember.VGuia[11] + GuiaMember.VGuia[12] + GuiaMember.VGuia[13]);
                GotoXY(35,17); Write(EditReal(GuiaMember.VGuia[10]):17);
              Until (TC = #27) or (7+I = 21);
              GuiaMember.VGuia[15] := 0;
              For I := 4 to 09 do GuiaMember.VGuia[15] := GuiaMember.VGuia[15] + TruncX(GuiaMember.VGuia[I]);
              GuiaMember.VGuia[14] := TruncX(GuiaMember.VGuia[15] - GuiaMember.VGuia[10]);
              GotoXY(35,21); Write(EditReal(GuiaMember.VGuia[14]):17);
              Confirma;
            Until TC in ['S',#27];
            If TC = 'S' then
               begin
                 AAx := QQStr(AA,4,'0');
                 MMx := QQStr(MM,2,'0');
                 GuiaMember.Cia := CmpyNo;
                 Case Usa of
                      'E' : begin
                              GuiaMember.Endereco  := CMstMember.Endereco+', '+
                                                      CMstMember.Numero  +' '+
                                                      CMstMember.Complemento;
                              GuiaMember.Cidade    := CMstMember.Cidade;
                              GuiaMember.Estado    := CMstMember.Estado;
                              GuiaMember.Cep       := CMstMember.Cep;
                              GuiaMember.GRPSTipo  := CMstMember.Tipo;
                              GuiaMember.GRPSIdent := CMstMember.CGC_CEI;
                            end;
                      'D' : begin
                              GuiaMember.Endereco  := DDMember.Endereco;
                              GuiaMember.Cidade    := DDMember.Cidade;
                              GuiaMember.Estado    := DDMember.Estado;
                              GuiaMember.Cep       := DDMember.Cep;
                              GuiaMember.GRPSTipo  := DDMember.GRPSTipo;
                              GuiaMember.GRPSIdent := DDMember.GRPSIdent;
                            end;
                 end;
                 Case Tot of
                      'N' : GuiaMember.Total := 0;
                      'S' : GuiaMember.Total := GuiaMember.VGuia[14];
                 end;
                 Case DskRpt of
                      'D' : TC := 'S';
                      'N' : ImprimeAgora;
                 end;
                 Case TC of
                      'A','S' : begin
                                  If TC = 'A' then FormTest('S','N','***')
                                              else TC := 'S';
                                  If TC = 'S' then ImprimeGRPS;
                                end;
                      'G' : begin
                              Assign ( GuiaFile, (XDrive + '\GRPS__'+AAx+'.M'+MMx));
                              {$I-}
                              Reset ( GuiaFile );
                              {$I+}
                              If IOResult <> 0 then
                              begin
                                ReWrite ( GuiaFile );
                                Reset   ( GuiaFile );
                              end;
                              Seek  ( GuiaFile, FileSize(GuiaFile));
                              Write ( GuiaFile, GuiaMember        );
                              Close ( GuiaFile );
                            end;
                 end;
                 Window(1,1,80,25);
                 Color(Blue,Cyan);
                 GotoXY(1,23);  Write(ConstStr(' ',80));
                 TeclaReturn;
               end;
          end;
     end;
end;


Procedure PedeProc17;
begin
  Color(Tfn,Ttx);
  GotoXY(4,12); Write('1¦ Obs.:');
  GotoXY(4,13); Write('2¦ Obs.:');
  GotoXY(4,14); Write('3¦ Obs.:');
  Msg1  := '';
  Msg2  := '';
  Msg3  := '';
  Repeat
    TC := #13;
    K  := 1;
    Repeat
      Case K of
           1  :  PedeDepto(11,'L');
           2  :  begin
                   J := Msg1;
                   InputStr(J,39,13,12,0,'S','S','T','N',Tfn,Utx);
                   Msg1 := J;
                 end;
           3  :  begin
                   J := Msg2;
                   InputStr(J,39,13,13,0,'S','S','T','N',Tfn,Utx);
                   Msg2 := J;
                 end;
           4  :  begin
                   J := Msg3;
                   InputStr(J,39,13,14,0,'S','S','T','N',Tfn,Utx);
                   Msg3 := J;
                 end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 5) or (TC = #27);
    If TC <> #27 then Confirma;
  Until (TC = 'S') or (TC = #27);
end;


Procedure ProcNo17Report;
begin
  PedeProc17;
  If TC = 'S' then
     begin
       LoadIndex6 ('D',Tr);
       If TC <> #27 then
          begin
            Str(AA:4,AAx);
            L1 := Nx+'Quadro de Hor rio de Trabalho de '+Nf+
                  ArrayMesEx[MM]+'/'+AAx;
            L6 := Cx+'Nome'+ConstStr(' ',38)+'Cargo'+ConstStr(' ',12)+
                  'Cart.de Trab.   Entr.   Int. p/Refei‡„o   Sa¡da   Descanso'+Cf;
            ParaContinua;
            Janela('F');
            RecordAnt := '';
            DDAC      := DDNo;
            If DDNo <> '' then
               begin
                 RC := 'N';
                 SearchAnt3 ( Root3 );
                 If RC = 'N' then DDNo := '';
               end;
            Repeat
              RC := 'N';
              SearchPos3 ( Root3 );
              If RC = 'S' then
                 begin
                   ReadWrite(#05,'R','N',DDNumber);
                   XXNo := DDNo + '#';
                   Repeat
                     RC := 'N';
                     SearchPos6 ( Root6 );
                     If RC = 'S' then
                        begin
                          ReadWrite(#08,'R','N',XXNumber);
                          If Ex = 'L' then DDNo := EEMember.Depto;
                          If (((Ex             = 'X' ) and
                               (EEMember.Depto = DDNo) and
                               (DDMember.Marca = #004)) or
                              ((Ex             <> 'X') and
                               (EEMember.Depto = DDNo))) and
                             (EEMember.Status     <> 'R') and
                             (EEMember.Status     <> 'X') and
                    {         (EEMember.Cartao     =  '' ) and }
                             (EEMember.Vinculo[1] <> 'A') and
                             (EEMember.Vinculo[1] <> 'N') then
                             begin
                               If ((RecordAnt <> DDNo) and (Ex in ['N','X'])) or
                                  (ContLin    > 55  ) then
                                  begin
                                    If (RecordAnt <> '') and
                                       (Msg1      <> '') then
                                       begin
                                         If ContLin < 55 then
                                            begin
                                              I := ContLin + 1;
                                              For P := I to 56 do WriteLine('L',' ');
                                            end
                                            else WriteLine('L',' ');
                                         WriteLine('L',ConstStr(' ',20)+Acentua(Msg1));
                                         WriteLine('L',ConstStr(' ',20)+Acentua(Msg2));
                                         WriteLine('L',ConstStr(' ',20)+Acentua(Msg3));
                                       end;
                                    HeaderReport;
                                    RecordAnt := DDNo;
                                  end;
                               NCont := NCont + 1;
                               Writeln(EEMember.Nome);
                               If EEMember.Turno = ''
                                  then WriteLine('L',Cx+Acentua(EEMember.Nome)+' '+
                                             ConstStr(' ',41-Length(EEMember.Nome))+
                                             Acentua(EEMember.Cargo)+
                                             ConstStr(' ',16-Length(EEMember.Cargo))+' '+
                                             PushLeft(11,EEMember.CTrabN)+
(*                                              PushLeft(7,EEMember.CtrabS)+ *)
                                             PushLeft(5,EEMember.CtrabE)+
                                             PushLeft(8,EEMember.Entrada)+
                                             PushLeft(18,EEMember.IntRefeicao)+
                                             PushLeft(8,EEMember.Saida)+
                                             EEMember.RepSemanal+Cf)
                                  else WriteLine('L',Cx+Acentua(EEMember.Nome)+' '+
                                             ConstStr(' ',41-Length(EEMember.Nome))+
                                             Acentua(EEMember.Cargo)+
                                             ConstStr(' ',16-Length(EEMember.Cargo))+' '+
                                             PushLeft(11,EEMember.CTrabN)+
(*                                             PushLeft(4,EEMember.CtrabS)+ *)
                                             PushLeft(5,EEMember.CtrabE)+
                                             PushLeft(8,'Turno:')+
                                             Acentua(EEMember.Turno)+Cf);
                             end
                             else If EEMember.Depto <> DDNo then RC := 'N';
                        end;
                     GoNoGo;
                     If TC = #27 then
                        begin
                          RC   := 'N';
                          DDAC := DDNo;
                        end;
                   Until RC = 'N';
                   If DDNo = DDAC then RC := 'N'
                                  else RC := 'S';
                 end;
            Until RC = 'N';
            If NCont <> 0 then
               begin
                 TC := #13;
                 If Msg1 <> '' then
                    begin
                      If ContLin < 55 then
                         begin
                           I := ContLin + 1;
                           For P := I to 56 do WriteLine('L',' ');
                         end
                         else WriteLine('L',' ');
                      WriteLine('L',ConstStr(' ',20)+Acentua(Msg1));
                      WriteLine('L',ConstStr(' ',20)+Acentua(Msg2));
                      WriteLine('L',ConstStr(' ',20)+Acentua(Msg3));
                    end;
                 Footer;
                 If DskRpt = 'N' then WriteLine('W',Qp);
               end;
            FuncImpressos;
          end;
     end;
end;


end.