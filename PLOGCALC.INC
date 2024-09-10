Procedure D13Salario(X : Char);
Var
  Adiant13   : Real;
  MesesTrab  : Integer;
begin
  If X <> 'G' then CheckUsrMacro;
  DisplayNome(X);
  CalculaSalario13;
  Produt     := 0;
  AdNot      := 0;
  Valor      := 0;
  Adiant13   := 0;
  ValorHora1 := 0;
  ValorHora2 := 0;
  Case P13 of
       'A' : begin
               YYNo := '009';
               RecuperaConta;
               If YAddress^.AcAnualH > 0 then
                  begin
                    Horas(((YAddress^.AcAnualH * 60) + YAddress^.AcAnualM) / EEMember.MesesT);
                    YYNo := '036';
                    RecuperaConta;
                    If YAddress^.Origem = 'S' then
                       begin
                         YAddress^.AcMensalH := Hora;
                         YAddress^.AcMensalM := Minuto;
                         CalculaValorHora1;
                         ConverteHora('036');
                         YYNo := '036';
                         RecuperaConta;
                         If YAddress^.AcMensalV > 0 then
                            begin
                              AdNot               := YAddress^.AcMensalV;
                              YAddress^.AcMensalV := 0;
                              YAddress^.AcMensalH := 0;
                              YAddress^.AcMensalM := 0;
                            end;
                       end;
                  end;
               CalculaAd13Salario;
               YYNo := '030';
               RecuperaConta;
               YAddress^.AcMensalV := Valor;
               TProv               := TProv + Valor;
               VLiq                := Valor;
             end;
       'P' : begin
               UserMacro('4');
               MesesTrab := EEMember.MesesT;
               Val(EEMember.AAAdm,I,E);
               If I < AA then MesesTrab := MM
                  else begin
                         Val(EEMember.MMAdm,I,E);
                         EEMember.MesesT := MM - I;
                         Val(EEMember.DDAdm,I,E);
                         If I <= 15 then EEMember.MesesT := EEMember.MesesT + 1;
                       end;
               YYNo := '015';
               RecuperaConta;
               If (YAddress^.Origem    = 'S') and
                  (YAddress^.AcMensalV <> 0 ) then YAddress^.AcMensalV := 0;
               YYNo := '024';
               RecuperaConta;
               YAddress^.AcMensalV := 0;
               YAddress^.Origem    := 'S';
               YYNo := '064';
               RecuperaConta;
               If YAddress^.Origem = 'S' then YAddress^.AcMensalV := 0;
               YYNo := '078';
               RecuperaConta;
               YAddress^.AcMensalV := 0;
               YAddress^.Origem    := 'S';
               YYNo := '004';
               RecuperaConta;
               Adiant13 := YAddress^.AcAnualV;
               YYNo := '059';
               RecuperaConta;
               If YAddress^.Origem = 'S' then YAddress^.AcMensalV := Adiant13;
               YYNo  := '017';
               RecuperaConta;
               If (YAddress^.Origem   = 'S') and
                  (YAddress^.PerctUsr <> 0 ) then
                  begin
                    Produt              := TruncX((SalBase13 * YAddress^.PerctUsr)/100);
                    YAddress^.AcMensalV := Produt;
                  end
                  else Produt := YAddress^.AcMensalV;
               YYNo := '009';
               RecuperaConta;
               If YAddress^.AcMensalH > 0 then
                  begin
                    Horas((((YAddress^.AcMensalH * 60) + YAddress^.AcMensalM) / 12) * EEMember.MesesT);
                    YYNo := '036';
                    RecuperaConta;
                    If YAddress^.Origem = 'S' then
                       begin
                         YAddress^.AcMensalH := Hora;
                         YAddress^.AcMensalM := Minuto;
                       end;
                  end;
               YYNo := '005';
               RecuperaConta;
               If YAddress^.Origem = 'S'
                  then YAddress^.AcMensalV := ((SalBase13 + Produt) / 12) * EEMember.MesesT;
               CalculaValorHora1;
               CalculaPeri(Eta);
               CalculaInsa(Eta);
               CalculaValorHora2;
               ProcessaBaseUsr;
               ConverteHora('');
               CalculoConta('S');
               CalculaBases;
               YYNo := '072';
               RecuperaConta;
               If YAddress^.Origem = 'S' then YAddress^.AcMensalV := VBases[3] * 0.08;
               CalculaIapas;
               CalculaBaseIR;
               CalculaIR('1');
               If EEMember.Pensao <> 'N' then CalculaPensao('S');
               CalculaLiquido('S');
               GuardaINSS;
               EEMember.MesesT := MesesTrab;
             end;
  end;
  LFolha := LFolha + VLiq;
  NFunc  := NFunc  + 1;
  If X <> 'G' then CloseUsrMacro;
end;


Procedure RecebeAdiantamento(X : Char);
begin
  Case X of
       'U' : begin
               Color(Blue,White);
               GotoXY(1,23); Write(ConstStr(' ',80));
               GotoXY(2,23);
               Write('Adiantamento (1,2,3,4,A):     Truncar (N,C ou D):    ');
             end;
       'G' : begin
               Color(Tfn,Ttx);
               GotoXY(4,12);  Write('Adiant. (1,2,3,4,A):');
               GotoXY(4,13);  Write('Truncar (N,C ou D).:');
             end;
  end;
  Color(Tfn,Utx);
  Repeat
    K := 1;
    Repeat
      Case K of
           1 : begin
                 J := '';
                 If X = 'U' then InputStr(J,1,28,23,0,'S','N','T','N',Blue,Yellow)
                            else InputStr(J,1,25,12,0,'S','N','T','N',Tfn,Utx);
                 If J = '' then Eta := 'A'
                           else Eta := UpCase(J[1]);
                 If (Eta <> '1') and
                    (Eta <> '2') and
                    (Eta <> '3') and
		    (Eta <> '4') and
                    (Eta <> 'A') then
                    begin
		      ErroMsg  := 'Informe 1,2,3,4 ou Q';
                      ErrorMessage;
                      K := K - 1;
                    end
                    else Case X of
                              'G' : begin
                                      GotoXY(25,12);
                                      Case Eta of
                                           '1' : Write('1¦ Semana   ');
                                           '2' : Write('2¦ Semana   ');
                                           '3' : Write('3¦ Semana   ');
				           '4' : Write('4¦ Semana   ');
                                           'A' : Write('Adiantamento');
                                      end;
                                    end;
                              'U' : begin
                                      GotoXY(28,23); Write(Eta);
                                    end;
                         end;
               end;
           2 : begin
                 J := '';
                 If X = 'U' then InputStr(J,1,52,23,0,'S','N','T','N',Blue,Yellow)
                            else InputStr(J,1,25,13,0,'S','N','T','N',Tfn,Utx);
                 If J = '' then SC := 'N'
                           else SC := UpCase(J[1]);
                 If (SC <> 'N') and
                    (SC <> 'C') and
                    (SC <> 'D') then
                    begin
                      ErroMsg  := 'Informe N,C ou D';
                      ErrorMessage;
                      K := K - 1;
                    end
                    else Case X of
                              'G' : begin
                                      GotoXY(25,13);
                                      Case SC of
                                           'C' : Write('Centavos   ');
                                           'D' : Write('Dezena     ');
                                           'N' : Write('NÆo truncar');
                                      end;
                                    end;
                              'U' : begin
                                      GotoXY(52,23); Write(SC);
                                    end;
                         end;
               end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 3) or (TC = #27);
    If TC <> #27 then Confirma;
  Until TC in ['S',#27];
  If X = 'U' then LimpaLn(23,Tfd);
  TxtMacro := 'N';
end;


Procedure RecebePagamento(X : Char);
begin
  Case X of
       'G' : begin
               Color(Tfn,Ttx);
               GotoXY(4,12);  Write('Adiant.de 13§Sal r:');
               GotoXY(4,13);  Write('Calc.Contr.Sindic.:');
               GotoXY(4,14);  Write('Truncar (N,C ou D):');
               GotoXY(4,15);  Write('N§Dias £teis.(n/f):');
	       If VP2 = 'S' then
                  begin
                    GotoXY(4,16); Write('Reembolso de V.Tr.:');
                  end;
               If CMstMember.Etapa = 'P' then
                  begin
                    GotoXY(4,18);  Write('Folha Complementar:');
                  end;
             end;
       'U' : begin
               Color(Blue,White);
               GotoXY(1,23); Write(ConstStr(' ',80));
               GotoXY(2,23);
               Write('Ad.13§S:  C.Sind:  Trunc(N,C,D):  N§D.Vtr:                             Compl:');
              If VP2 = 'S' then
                  begin
                    GotoXY(62,23); Write('Reemb.VT:');
                  end;
               If CMstMember.Etapa = 'P' then
                  begin
                    GotoXY(73,23); Write('Compl:')
                  end;
             end;
  end;
  Color(Tfn,Utx);
  DU   := 0;
  DUF  := 0;
  D2T  := 0;
  VTR  := 'N';
  TVtr := '*';
  Repeat
    K := 1;
    Repeat
      Case K of
           1 : begin
                 J := '';
                 If X = 'U' then InputStr(J,1,10,23,0,'S','N','T','N',Blue,Yellow)
                            else InputStr(J,1,24,12,0,'S','N','T','N',Tfn,Utx);
                 If J = '' then P13 := 'N'
                           else P13 := UpCase(J[1]);
                 If (P13 <> 'S') and
                    (P13 <> 'N') then
                    begin
                      ErroMsg  := 'Informe S ou N';
                      ErrorMessage;
                      K := K - 1;
                    end
                    else Case X of
                              'G' : begin
                                      GotoXY(24,12);
                                      If P13 = 'S'
                                         then Write('Calcular Ad.de 13§ Sal rio ')
                                         else Write('NÆo Calcular Ad.13§ Sal rio');
                                    end;
                              'U' : begin
                                      GotoXY(10,23); Write(P13);
                                    end;
                         end;
               end;
           2 : begin
                 J := '';
                 If X = 'U' then InputStr(J,1,19,23,0,'S','N','T','N',Blue,Yellow)
                            else InputStr(J,1,24,13,0,'S','N','T','N',Tfn,Utx);
                 If J = '' then CS := 'N'
                           else CS := UpCase(J[1]);
                 If (CS <> 'S') and
                    (CS <> 'N') then
                    begin
                      ErroMsg  := 'Informe S ou N';
                      ErrorMessage;
                      K := K - 1;
                    end
                    else Case X of
                              'G' : begin
                                      GotoXY(24,13);
                                      If CS = 'S'
                                         then Write('Calcular Contr. Sindical   ')
                                         else Write('NÆo Calcular Contr.Sindical');
                                    end;
                              'U' : begin
                                      GotoXY(19,23); Write(CS);
                                    end;
                         end;
               end;
           3 : begin
                 J := '';
                 If X = 'U' then InputStr(J,1,34,23,0,'S','N','T','N',Blue,Yellow)
                            else InputStr(J,1,24,14,0,'S','N','T','N',Tfn,Utx);
                 If J = '' then SC := 'N'
                           else SC := UpCase(J[1]);
                 If (SC <> 'N') and
                    (SC <> 'C') and
                    (SC <> 'D') then
                    begin
                      ErroMsg  := 'Informe N,C ou D';
                      ErrorMessage;
                      K := K - 1;
                    end
                    else Case X of
                              'G' : begin
                                      GotoXY(24,14);
                                      Case SC of
                                           'N' : Write('NÆo truncar');
                                           'C' : Write('Centavos   ');
                                           'D' : Write('Dezenas    ');
                                      end;
                                    end;
                              'U' : begin
                                      GotoXY(34,23); Write(SC);
                                    end;
                         end;
               end;
           4 : begin
                 If DU = 0 then J := ''
                           else begin
                                  Str(DU:2,J);
                                  J := LeftAdjust(J);
                                end;
                 If X = 'U' then InputStr(J,2,44,23,0,'S','N','T','N',Blue,Yellow)
                            else InputStr(J,2,24,15,0,'S','N','T','N',Tfn,Utx);
                 If TC = #13 then
                    If J = '' then
                       begin
                         DU := 22;
                         K  := K - 1;
                       end
                       else begin
                              Val(J,DU,E);
                              If DU = 0 then
                                 begin
                                   ErroMsg  := 'Dias £teis Inv lido';
                                   ErrorMessage;
                                   K := K - 1;
                                 end;
                            end;
               end;
           5 : begin
                 If DUF = 0 then J := ''
                            else begin
                                   Str(DUF:2,J);
                                   J := LeftAdjust(J);
                                 end;
                 If X = 'U' then InputStr(J,2,47,23,0,'S','N','T','N',Blue,Yellow)
                            else InputStr(J,2,27,15,0,'S','N','T','N',Tfn,Utx);
                 If TC = #13 then
                    If J = '' then
                       begin
                         DUF := DU;
                         K   := K - 1;
                       end
                       else begin
                              Val(J,DUF,E);
                              If DUF = 0 then
                                 begin
                                   ErroMsg  := 'Dias £teis Inv lido';
                                   ErrorMessage;
                                   K := K - 1;
                                 end;
                            end;
               end;
           6 : begin
                 J := TVtr;
                 If X = 'U' then InputStr(J,1,49,23,0,'S','N','T','N',Blue,Yellow)
                            else InputStr(J,1,29,15,0,'S','N','T','N',Tfn,Utx);
                 If TC = #13 then
                    Case UpCase(J[1]) of
                         '*' : TVtr := '*';
                         'X' : TVtr := 'X';
                         else begin
                                ErroMsg  := 'Informe * (proporcional) ou X (sal rio)';
                                ErrorMessage;
                                K := K - 1;
                              end;
                    end;
               end;
	   7 : If VP2 = 'S' then
		  begin
		    J := '';
		    If X = 'U' then InputStr(J,1,60,23,0,'S','N','T','N',Blue,Yellow)
			       else InputStr(J,1,24,16,0,'S','N','T','N',Tfn,Utx);
                    If J = '' then VTR := 'N'
		              else VTR := UpCase(J[1]);
		    If (VTR <> 'N') and (VTR <> 'S') then
		       begin
			 ErroMsg  := 'Informe S ou N';
			 ErrorMessage;
			 K := K - 1;
		       end
                       else Case X of
                                 'G' : begin
                                         GotoXY(24,16); Write(VTR);
                                       end;
                                 'U' : begin
                                         GotoXY(60,23); Write(VTR);
                                       end;
                            end;
                  end;
	   8 : If (VP2 = 'S') and
                  (VTR = 'S') then
		  begin
                    Case X of
                         'G' : begin
                                 Color(Tfn,Ttx);
                                 GotoXY(4,17); Write('Dia £til 2¦ Tab.Vt:');
                               end;
                         'U' : begin
                                 Color(Blue,White);
                                 GotoXY(62,23); Write('2¦Tb.VT:');
                               end;
                    end;
		    If D2T = 0 then J := ''
			       else begin
				      Str(D2T:2,J);
				      J := LeftAdjust(J);
				    end;
		    If X = 'U' then InputStr(J,2,70,23,0,'S','N','T','N',Blue,Yellow)
			       else InputStr(J,2,24,17,0,'S','N','T','N',Tfn,Utx);
		    Val(J,D2T,E);
		    If D2T = 0 then
		       begin
			 ErroMsg  := 'Informe o Dia £til em que a tabela foi alterada.';
			 ErrorMessage;
			 K := K - 1;
		       end;
		  end;
           9 : If CMstMember.Etapa = 'P' then
                  begin
                    J := '';
                    If X = 'U' then InputStr(J,1,79,23,0,'S','N','T','N',Blue,Yellow)
                               else InputStr(J,1,24,18,0,'S','N','T','N',Tfn,Utx);
                    If J = '' then FC := 'N'
                              else FC := UpCase(J[1]);
                    If (FC <> 'N') and
                       (FC <> 'S') then
                       begin
                         ErroMsg  := 'Informe S ou N';
                         ErrorMessage;
                         K := K - 1;
                       end
                       else Case X of
                                 'G' : begin
                                         GotoXY(24,18);
                                         Case FC of
                                              'N' : Write('Folha Normal      ');
                                              'S' : Write('Folha Complementar');
                                         end;
                                       end;
                                 'U' : begin
                                         GotoXY(79,23); Write(FC);
                                       end;
                            end;
                  end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 10) or (TC = #27);
    If TC <> #27 then Confirma;
  Until TC in ['S',#27];
  If X = 'U' then LimpaLn(23,Tfd);
end;


Procedure Recebe13Salario(X : Char);
begin
  Case X of
       'G' : begin
               Color(Tfn,Ttx);
               GotoXY(4,12);  Write('Ad.ou Pag. (A ou P):');
               GotoXY(4,13);  Write('Truncar  (N,C ou D):');
             end;
       'U' : begin
               Color(Blue,White);
               GotoXY(1,23); Write(ConstStr(' ',80));
               GotoXY(2,23); Write(' Adiantamento ou Pagamento (A ou P):        Truncar (N,Centavos ou Decimais):');
             end;
  end;
  Color(Tfn,Utx);
  Repeat
    K := 1;
    Repeat
      Case K of
           1 : begin
                 J := '';
                 If X = 'U' then InputStr(J,1,38,23,0,'S','N','T','N',Blue,Yellow)
                            else InputStr(J,1,25,12,0,'S','N','T','N',Tfn,Utx);
                 If J = '' then P13 := 'P'
                           else P13 := UpCase(J[1]);
                 If (P13 <> 'A') and
                    (P13 <> 'P') then
                    begin
                      ErroMsg  := 'Informe S ou N';
                      ErrorMessage;
                      K := K - 1;
                    end
                    else Case X of
                              'G' : begin
                                      GotoXY(25,12);
                                      Case P13 of
                                           'A' : Write('Adiantamento de 13§ Sal rio');
                                           'P' : Write('Pagamento de 13§ Sal rio   ');
                                      end;
                                    end;
                              'U' : begin
                                      GotoXY(38,23); Write(P13);
                                    end;
                         end;
               end;
           2 : begin
                 J := '';
                 If X = 'U' then InputStr(J,1,79,23,0,'S','N','T','N',Blue,Yellow)
                            else InputStr(J,1,25,13,0,'S','N','T','N',Tfn,Utx);
                 If J = '' then SC := 'N'
                           else SC := UpCase(J[1]);
                 If (SC <> 'N') and
                    (SC <> 'C') and
                    (SC <> 'D') then
                    begin
                      ErroMsg  := 'Informe N,C ou D';
                      ErrorMessage;
                      K := K - 1;
                    end
                    else Case X of
                              'G' : begin
                                      GotoXY(25,13);
                                      Case SC of
                                           'N' : Write('NÆo truncar');
                                           'C' : Write('Centavos   ');
                                           'D' : Write('Dezenas    ');
                                      end;
                                    end;
                              'U' : begin
                                      GotoXY(79,23); Write(SC);
                                    end;
                         end;
               end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 3) or (TC = #27);
    If TC <> #27 then Confirma;
  Until TC in ['S',#27];
  If X = 'U' then LimpaLn(23,Tfd);
end;


Procedure TelaTotal;
begin
  DrawBox(36,11,67,18,Sfn,'S');
  Color(Bfn,Btx);
  GotoXY(36,11); Write('          Estat¡sticas          ');
  Color(Sfn,Stx);
  GotoXY(36,12); Write(' N§Empreg.                      ');
  GotoXY(36,14); Write(' Proventos                      ');
  GotoXY(36,15); Write(' Descontos                      ');
  GotoXY(36,16); Write('           -------------------- ');
  GotoXY(36,17); Write(' L¡quido                        ');
end;


Procedure PrintTotal;
begin
  Color(Sfn,Stx);
  GotoXY(47,12); Write(NFunc:4);
  GotoXY(47,14); Write(EditReal(TProv):20);
  GotoXY(47,15); Write(EditReal(TDesc):20);
  GotoXY(47,17); Write(EditReal(LFolha):20);
  Color(Tfn,Utx);
end;


Procedure Calculo;
begin
  Move(ScArray4[1],Mem[$B800:0000],4000);
  Mx     := Copy(MMFx,2,2);
  Ax     := AAFx;
  NFunc  := 0;
  LFolha := 0;
  TProv  := 0;
  TDesc  := 0;
  Color(Sfn,Stx);
  GotoXY(35,08);
  Case YY of
       1 : begin
             Write(' Adiantamento de Sal rio  ');
             Eta := 'A';
             RecebeAdiantamento('G');
           end;
       2 : begin
             Write(' Pagamento de Sal rio     ');
             Eta := 'P';
             RecebePagamento('G');
           end;
       3 : begin
             Write(' 13§ Sal rio              ');
             Eta := 'S';
             Recebe13Salario('G');
             If P13 = 'A' then Eta := 'O'
           end;
  end;
  Color(Tfn,Ttx);
  If TC = 'S' then
     begin
       If Eta in ['P','S'] then CheckUsrMacro;
       TelaTotal;
       EENo := '';
       Repeat
         RC := 'N';
         SearchPos5 ( Root5 );
         If RC = 'S' then
            begin
              ReadWrite(#08,'R','N',EENumber);
              If ((EEMember.Status  in ['A','F']                )  and
                  (Eta              in ['1','2','3','4','A']    )) or
                 ((EEMember.Status  in ['A','E','C','F','L','V'])  and
                  (Eta              in ['P','S','O']            )) then
                 begin
                   LoadMVDsk(#11);
                   Case Eta of
                        '1','2','3','4','A' : If EEMember.Status = 'F' then
                                                 begin
                                                   If (EEMember.MesF   = MM ) and
                                                      (EEMember.DiaF   < 15 ) and
                                                      (Eta             = 'A')
                                                      then Adiantamento('G');
                                                 end
                                                 else Adiantamento('G');
                        'P' : Pagamentos('G');
                        'S','O' : If (EEMember.Vinculo[1] <> 'A') and
                                     (EEMember.Vinculo[1] <> 'N') then
                                     begin
                                       CS := 'N';
                                       D13Salario('G');
                                     end;
                   end;
                   UnLoadMVDsk;
                   PrintTotal;
                   RC := 'S';
                 end;
            end;
       Until RC = 'N';
       CMstMember.Etapa := Eta;
       ReadWrite(#16,'W','N',0);
       Color(Blue,Cyan);
       GotoXY(1,23); Write(ConstStr(' ',80));
       GotoXY(2,23); Write('Fim do C lculo');
       TeclaReturn;
       If (TxtMacro = 'S') and (Eta in ['P','S']) then Close ( TxtFile );
     end;
end;


Procedure SelecionaCalculo;
begin
  Color(Tfn,Utx);
  TabI[1]  := ' Adiantamento      ';
  TabI[2]  := ' Pagamento         ';
  TabI[3]  := ' 13§ Sal rio       ';
  TabI[4]  := ' Encerrar a fun‡Æo ';
  TabX[1]  := 10;
  TabX[2]  := 10;
  TabX[3]  := 10;
  TabX[4]  := 10;
  TabY[1]  := 11;
  TabY[2]  := 12;
  TabY[3]  := 13;
  TabY[4]  := 14;
  YY := 1;
  Repeat
    RetMenuAuxiliar(9,10,4,1,1);
    Move(Mem[$B800:0000],ScArray6[1],4000);
    Case YY of
         1   : Eta := 'A';
         2   : Eta := 'P';
         3   : Eta := 'S';
         4   : Resp := #27;
    end;
    If Resp = #13 then Calculo;
    Move(ScArray6[1],Mem[$B800:0000],4000);
  Until Resp = #27;
  Resp := #00;
  TC   := #13;
end;