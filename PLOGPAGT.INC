Procedure EntryAFunc;
begin
  If EEMember.Tipo = ' ' then Tl := 'N'
                         else Tl := 'S';
  TitleTela('P');
  With EEMember do
  Repeat
    K := 1;
    Repeat
      Case K of
             1   : begin
                     If Salario = 0 then J := ''
                                    else begin
                                           Str(Salario:12:2,J);
                                           J := LeftAdjust(J);
                                         end;
                     GotoXY(12,11); Write(' ':15);
                     InputStr(J,12,12,11,0,'S','N','$','N',Tfn,Utx);
                     Val(J,Salario,E);
                     If Salario = 0 then
                        begin
                          ErroMsg := 'O sal†rio n∆o pode ser ZERO';
                          ErrorMessage;
                          K := K - 1;
                        end;
                   end;
             2   : begin
                     J := Tipo;
                     InputStr(J,1,43,11,0,'S','N','T','N',Tfn,Utx);
                     Tipo := UpCase(J[1]);
                     If TC <> #27 then
                        begin
                          GotoXY(43,11);
                          Case Tipo of
                               'H' : Write('Hor/');
                               'M' : Write('Men/');
                               'S' : Write('Sem/');
                               else begin
                                      ErroMsg := 'Informe H,M ou S';
                                      ErrorMessage;
                                      K := K - 1;
                                    end;
                          end;
                        end;
                     TipoP := 'M';
                   end;
             3   : begin
                     J := TipoP;
                     InputStr(J,1,47,11,0,'S','N','T','N',Tfn,Utx);
                     TipoP := UpCase(J[1]);
                     If TC <> #27 then
                        begin
                          GotoXY(47,11); Case TipoP of
                                              'M' : Write('Màs   ');
                                              else begin
                                                     ErroMsg := 'Informe M';
                                                     ErrorMessage;
                                                     K := K - 1;
                                                   end;
                                         end;
                        end;
                   end;
             4   : begin
                     If HNormais = 0 then J := ''
                                     else begin
                                            Str(HNormais:3:2,J);
                                            J := LeftAdjust(J);
                                          end;
                     InputStr(J,6,12,12,0,'S','N','$','N',Tfn,Utx);
                     Val(J,HNormais,E);
                     If (TC       <> #27) and
                        (HNormais =  0  ) then
                        begin
                          ErroMsg := 'Informe as Horas Normais';
                          ErrorMessage;
                          K := K - 1;
                        end;
                     GotoXY(12,12); Write(EditReal(HNormais):6);
                   end;
             5   : begin
                     If MesesT = 0 then J := ''
                                   else begin
                                          Str(MesesT:2,J);
                                          J := LeftAdjust(J);
                                        end;
                     InputStr(J,2,12,13,0,'S','N','N','N',Tfn,Utx);
                     Val(J,MesesT,E);
                   end;
             6   : begin
                     If MesesF = 0 then J := ''
                                   else begin
                                          Str(MesesF:2,J);
                                          J := LeftAdjust(J);
                                        end;
                     InputStr(J,2,27,13,0,'S','N','N','N',Tfn,Utx);
                     Val(J,MesesF,E);
                   end;
             7   : begin
                     J := PgConta;
                     InputStr(J,1,12,14,0,'S','N','T','N',Tfn,Utx);
                     If (J = '' ) or
                        (J = ' ') then PgConta := 'N'
                                  else PgConta := UpCase(J[1]);
                     If (TC      <> #27) and
                        (PgConta <> 'S') and
                        (PgConta <> 'N') and
                        (PgConta <> 'C') then
                        begin
                          ErroMsg := 'Informe S,N ou C';
                          ErrorMessage;
                          K := K - 1;
                        end
                        else If TC <> #27 then
                                begin
                                  GotoXY(12,14);
                                  Case PgConta of
                                       'C' : begin
                                               Write('Cheque        ');
                                               CBPg    := BcoPg;
                                               BcoPg   := '';
                                               ContaPg := '';
                                               GotoXY(12,15);Write(' ':15);
                                             end;
                                       'N' : begin
                                               Write('Dinheiro      ');
                                               CBPg    := BcoPg;
                                               BcoPg   := '';
                                               ContaPg := '';
                                               GotoXY(12,15);Write(' ':15);
                                             end;
                                       'S' : Write('Sim           ');
                                  end;
                                end;
                   end;
             8   : If PgConta = 'S' then
                      begin
                        Color(Blue,White);
                        GotoXY(1,24); Write(ConstStr(' ',80));
                        GotoXY(2,24); Write('F1');
                        Color(Blue,Cyan);
                        GotoXY(5,24); Write('para pesquisar Bancos');
                        J := BcoPg;
                        InputStr(J,10,16,14,0,'S','N','T','N',Tfn,Utx);
                        BcoPg := J;
                        If TC = #21 then
                           begin
                             BBNo := LimpaChave(J);
                             BBAC := BBNo;
                             ScrollBanco;
                             BcoPg := BBAC;
                           end
                           else If TC <> #27 then
                                   begin
                                     BBNo := LimpaChave(J);
                                     SearchTree7 ( Root7 );
                                     If RC = 'S' then
                                        With BBMember do
                                        begin
                                          ReadWrite(#06,'R','N',BBNumber);
                                          BcoPg := OrigBancoC;
                                          GotoXY(16,14);Write(OrigBancoC);
                                        end
                                        else begin
                                               ErroMsg := 'Banco n∆o Existe ';
                                               ErrorMessage;
                                               K := K - 1;
                                             end;
                                   end;
                        LimpaLn(24,Tfd);
                      end;
             9   : If PgConta = 'S' then
                      begin
                        J := ContaPg;
                        InputStr(J,15,12,15,0,'S','N','T','N',Tfn,Utx);
                        ContaPg := J;
                      end;
             10  : If (Vinculo[1] <> 'A') and
                      (Vinculo[1] <> 'N') then
                      begin
                        Color(Blue,White);
                        GotoXY(1,24); Write(ConstStr(' ',80));
                        GotoXY(2,24); Write('F1');
                        Color(Blue,Cyan);
                        GotoXY(5,24); Write('para pesquisar Bancos');
                        J := BcoFgts;
                        InputStr(J,10,12,16,0,'S','N','T','N',Tfn,Utx);
                        BcoFgts := J;
                        If TC = #21 then
                           begin
                             BBNo := LimpaChave(J);
                             BBAC := BBNo;
                             ScrollBanco;
                             BcoFgts := BBAC;
                           end
                           else If TC <> #27 then
                                   begin
                                     BBNo := LimpaChave(J);
                                     SearchTree7 ( Root7 );
                                     If RC = 'S' then
                                        With BBMember do
                                        begin
                                          ReadWrite(#06,'R','N',BBNumber);
                                          BcoFgts := OrigBancoC;
                                          GotoXY(12,16);Write(OrigBancoC);
                                        end
                                        else begin
                                               ErroMsg := 'Banco n∆o Existe ';
                                               ErrorMessage;
                                               K := K - 1;
                                             end;
                                   end;
                        LimpaLn(24,Tfd);
                      end
                      else BcoFgts := '';
             11  : If (Vinculo[1] <> 'A') and
                      (Vinculo[1] <> 'N') then
                      begin
                        J := ContaFgts;
                        InputStr(J,15,12,17,0,'S','N','T','N',Tfn,Utx);
                        ContaFgts := J;
                      end
                      else ContaFgts := '';
             12  : begin
                     If PercAdiant = 0 then J := ''
                                       else begin
                                              Str(PercAdiant:5:2,J);
                                              J := LeftAdjust(J);
                                            end;
                     InputStr(J,5,12,18,0,'S','N','$','N',Tfn,Utx);
                     Val(J,PercAdiant,E);
                   end;
             13  : begin
                     I := 1;
                     Repeat
                       J := Peric[I];
                       InputStr(J,1,(11 + I),19,0,'S','N','T','N',Tfn,Utx);
                       If TC <> #27 then
                          begin
                            If UpCase(J[1]) in ['B','N','S'] then
                               begin
                                 GotoXY((11 + I),19); Write(UpCase(J[1]));
                                 Peric[I] := UpCase(J[1]);
                                 If TC = #24 then I := I - 1
                                             else I := I + 1;
                               end
                               else begin
                                      ErroMsg := 'Informe B=S.Base,S=S.M°nimo ou N';
                                      ErrorMessage;
                                    end;
                          end;
                     Until (I = 0) or (I = 6) or (TC = #27);
                   end;
             14  : begin
                     I := 1;
                     Repeat
                       J := Insalub[I];
                       InputStr(J,1,(11 + I),20,0,'S','N','T','N',Tfn,Utx);
                       If TC <> #27 then
                          begin
                            If UpCase(J[1]) in ['B','N','S'] then
                               begin
                                 GotoXY((11 + I),20); Write(UpCase(J[1]));
                                 Insalub[I] := UpCase(J[1]);
                                 If TC = #24 then I := I - 1
                                             else I := I + 1;
                               end
                               else begin
                                      ErroMsg := 'Informe B=S.Base,S=S.M°nimo ou N';
                                      ErrorMessage;
                                    end;
                          end;
                     Until (I = 0) or (I = 6) or (TC = #27);
                   end;
             15  : begin
                     J := VTransporte;
                     InputStr(J,1,12,21,0,'S','N','T','N',Tfn,Utx);
                     If TC <> #27 then
                        begin
                          If UpCase(J[1]) in ['F','N','S'] then
                             begin
                               VTransporte := UpCase(J[1]);
                               GotoXY(12,21); Write(VTransporte);
                               If VTransporte = 'N' then DiasVT := 0;
                             end
                             else begin
                                    ErroMsg := 'Informe S,F ou N';
                                    ErrorMessage;
                                    K := K - 1;
                                  end;
                        end;
                   end;
             16  : If VTransporte in ['F','S'] then
                      begin
                        If DiasVT = 0 then J := ''
                                      else begin
                                             Str(DiasVT:2,J);
                                             J := LeftAdjust(J);
                                           end;
                        InputStr(J,2,14,21,0,'S','N','N','N',Tfn,Utx);
                        Val(J,DiasVT,E);
                      end;
             17  : begin
                     J := Cartao;
                     InputStr(J,4,43,12,0,'S','N','T','N',Tfn,Utx);
                     Cartao := UpCaseStr(J);
                     GotoXY(43,12); Write(Cartao);
                   end;
             18  : begin
                     If DepIR = 0 then J := ''
                                  else begin
                                         Str(DepIR:2,J);
                                         J := LeftAdjust(J);
                                       end;
                     InputStr(J,2,43,13,0,'S','N','N','N',Tfn,Utx);
                     Val(J,DepIR,E);
                   end;
             19  : begin
                     Move(MemW[$B800:0000],ScArray5[1],4000);
                     DrawBox(13,10,73,17,Bfn,'S');
                     Color(Sfn,Stx);
                     GotoXY(13,10); Write('             Data de Nascimento e Nome dos Filhos            ');
                     Color(Bfn,Btx);
                     GotoXY(14,12); Write('1');
                     GotoXY(14,13); Write('2');
                     GotoXY(14,14); Write('3');
                     GotoXY(14,15); Write('4');
                     GotoXY(14,16); Write('5');
                     For I := 1 to 5 do begin
                                          GotoXY(15,(I+11)); Write('ß filho');
                                          GotoXY(23,(I+11)); Write(DtNascSF[I]);
                                          GotoXY(34,(I+11)); Write(PushLeft(40,FilhosSF[I]));
                                        end;
                     I := 1;
                     Repeat
                       J := DtNascSF[I];
                       If J = '*' then begin
                                         Str(DepSF,J);
                                         J := '*' + J;
                                       end;
                       InputStr(J,10,23,(I+11),0,'S','N','T','N',Bfn,Btx);
                       If (TC <> #27) and (J <> '') then
                          begin
                            If (UpCase(J[1]) <> '*') and
                               (UpCase(J[1]) <> 'D') then
                               begin
                                 J := ChkData(J);
                                 If J = '' then
                                    begin
                                      ErroMsg := 'Data Inv†lida';
                                      ErrorMessage;
                                      I := I - 1;
                                    end
                                    else begin
                                           DtNascSF[I] := J;
                                           GotoXY(23,(I+11)); Write(DtNascSF[I]);
                                           J := FilhosSF[I];
                                           InputStr(J,40,34,(I+11),0,'S','N','T','N',Bfn,Btx);
                                           FilhosSF[I] := J;
                                           GotoXY(34,(I+11)); Write(PushLeft(40,FilhosSF[I]));
                                         end;
                               end
                               else If UpCase(J[1]) = '*' then
                                       begin
                                         DtNascSF[I] := '*';
                                         Delete(J,1,1);
                                         Val(J,DepSF,E);
                                         If TC = #13 then I := 5
                                                     else I := 1;
                                       end
                                       else If UpCase(J[1]) = 'D'
                                               then DtNascSF[I] := 'DEF.';
                          end
                          else If TC <> #27 then
                                  begin
                                    DtNascSF[I] := '';
                                    FilhosSF[I] := '';
                                  end;
                       Case TC of
                            #13 : I := I + 1;
                            #24 : I := I - 1;
                       end;
                     Until (I = 0) or (I = 6) or (TC = #27);
                     If DtNascSF[1] <> '*' then
                        begin
                          DepSF := 0;
                          For I := 1 to 5 do
                          If DtNascSF[I] <> '' then
                             begin
                               If Copy(DtNascSF[I],1,1) = 'D'
                                  then DepSF := DepSF + 1
                                  else begin
                                         Val(Copy(DtNascSF[I],7,4),A,E);
                                         Val(Copy(DtNascSF[I],4,2),M,E);
                                         B := AA - A - 1;
                                         If M <= MM then B     := B + 1;
                                         If B < 14  then DepSF := DepSF + 1;
                                       end;
                             end;
                        end;
                     Move(ScArray5[1],MemW[$B800:0000],4000);
                     Color(Tfn,Utx);
                     GotoXY(43,14);Write(DepSF:2);
                   end;
             20  : begin
                     J := Pensao;
                     InputStr(J,1,43,15,0,'S','N','T','N',Tfn,Utx);
                     If (J = '') or (J = ' ') then Pensao := 'N'
                                              else Pensao := UpCase(J[1]);
                     GotoXY(43,15);
                     If TC <> #27 then
                        begin
                          If Pensao in ['1','2','3','4','5','6','A','B','C','D','E','F','N']
                             then Write(Pensao)
                             else begin
                                    ErroMsg := 'Informe o Tipo de Pens∆o ou N';
                                    ErrorMessage;
                                    K := K - 1;
                                  end;
                        end;
                   end;
             21  : begin
                     If PensaoP = 0 then J := ''
                                    else begin
                                           Str(PensaoP:5:2,J);
                                           J := LeftAdjust(J);
                                         end;
                     InputStr(J,5,43,16,0,'S','N','$','N',Tfn,Utx);
                     Val(J,PensaoP,E);
                   end;
             22  : begin
                     If DDFer <> ''
                        then J := DDFer + '/' + MMFer + '/' + AAFer
                        else J := '';
                     InputStr(J,10,43,17,0,'S','N','D','S',Tfn,Utx);
                     If TC <> #27 then
                        begin
                          DDFer := Copy(J,1,2);
                          MMFer := Copy(J,4,2);
                          AAFer := Copy(J,7,4);
                        end;
                   end;
             23  : begin
                     If PeriodoV = 0 then J := ''
                                     else begin
                                            Str(PeriodoV:1,J);
                                            J := LeftAdjust(J);
                                          end;
                     InputStr(J,2,58,17,0,'S','N','T','N',Tfn,Utx);
                     Val(J,PeriodoV,E);
                     GotoXY(58,17); Write(PeriodoV:1);
                   end;
             24  : begin
                     If DiaI = 0 then J := ''
                                 else begin
                                        Str(DiaI:2,J);
                                        J := LeftAdjust(J);
                                      end;
                     InputStr(J,2,43,18,0,'S','N','T','N',Tfn,Utx);
                     Val(J,DiaI,E);
                     If (TC <> #27) and
                        ((DiaI < 0) or (DiaI > 31)) then
                        begin
                          ErroMsg := 'Dia Inv†lido';
                          ErrorMessage;
                          K := K - 1;
                        end
                        else begin
                               GotoXY(43,18);
                               If DiaI > 0 then Write(QQStr(DiaI,2,'0'));
                             end;
                   end;
             25  : begin
                     If DiaI <> 0 then
                        begin
                          GotoXY(45,18);Write('/');
                        end;
                     If MesI = 0 then J := ''
                                 else begin
                                        Str(MesI:2,J);
                                        J := LeftAdjust(J);
                                      end;
                     InputStr(J,2,46,18,0,'S','N','T','N',Tfn,Utx);
                     Val(J,MesI,E);
                     If (TC <> #27) and
                        ((MesI < 0) or (MesI > 12)) then
                        begin
                          ErroMsg := 'Màs Inv†lido';
                          ErrorMessage;
                          K := K - 1;
                        end
                        else begin
                               GotoXY(46,18);
                               If MesI > 0 then Write(QQStr(MesI,2,'0'));
                             end;
                   end;
             26  : begin
                     If DiaF = 0 then J := ''
                                 else begin
                                        Str(DiaF:2,J);
                                        J := LeftAdjust(J);
                                      end;
                     InputStr(J,2,51,18,0,'S','N','T','N',Tfn,Utx);
                     Val(J,DiaF,E);
                     If (TC <> #27) and
                        ((DiaF < 0) or (DiaF > 31)) then
                        begin
                          ErroMsg := 'Dia Inv†lido';
                          ErrorMessage;
                          K := K - 1;
                        end
                        else begin
                               GotoXY(51,18);
                               If DiaF > 0 then Write(QQStr(DiaF,2,'0'));
                             end;
                   end;
             27  : begin
                     If DiaF <> 0 then
                        begin
                          GotoXY(53,18);Write('/');
                        end;
                     If MesF = 0 then J := ''
                                 else begin
                                        Str(MesF:2,J);
                                        J := LeftAdjust(J);
                                      end;
                     InputStr(J,2,54,18,0,'S','N','T','N',Tfn,Utx);
                     Val(J,MesF,E);
                     If ((MesF < 0) or (MesF > 12)) and (TC <> #27) then
                        begin
                          ErroMsg := 'Màs Inv†lido';
                          ErrorMessage;
                          K := K - 1;
                        end
                        else begin
                               GotoXY(54,18);
                               If MesF > 0 then Write(QQStr(MesF,2,'0'));
                             end;
                   end;
             28  : begin
                     If DDPAq = '' then J := DDAdm + '/' +
                                             MMAdm + '/' + AAAdm
                                   else J := DDPAq + '/' +
                                             MMPAq + '/' + AAPAq;
                     InputStr(J,10,43,19,0,'S','N','D','S',Tfn,Utx);
                     If TC <> #27 then
                        begin
                          DDPAq := Copy(J,1,2);
                          MMPAq := Copy(J,4,2);
                          AAPAq := Copy(J,7,4);
                          GotoXY(55,19); Write(DiaSemana(DDPAq+'/'+MMPAq+'/'+AAPAq));
                        end;
                   end;
             29  : begin
                     Color(Blue,White);
                     GotoXY(1,24); Write(ConstStr(' ',80));
                     GotoXY(2,24); Write('Desconta INSS no Adiantamento? (Sim ou N∆o)');
                     J := INSS[1];
                     InputStr(J,1,43,20,0,'S','N','T','N',Tfn,Utx);
                     LimpaLn(24,Tfd);
                     INSS[1] := UpCase(J[1]);
                     If (INSS[1] <> 'S') and (INSS[1] <> 'N') and (TC <> #27) then
                        begin
                          ErroMsg := 'Informe S ou N';
                          ErrorMessage;
                          K := K - 1;
                        end
                        else begin
                               GotoXY(43,20); Case INSS[1] of
                                                   'S' : Write('Sim');
                                                   'N' : Write('N∆o');
                                              end;
                             end;
                   end;
             30  : begin
                     Color(Blue,White);
                     GotoXY(1,24); Write(ConstStr(' ',80));
                     GotoXY(2,24); Write('Desconta INSS no Pagamento? (Aut.,Coop.,S ou N)');
                     J := INSS[2];
                     InputStr(J,1,47,20,0,'S','N','T','N',Tfn,Utx);
                     LimpaLn(24,Tfd);
                     INSS[2] := UpCase(J[1]);
                     If (INSS[2] <> 'A') and
                        (INSS[2] <> 'C') and
                        (INSS[2] <> 'S') and
                        (INSS[2] <> 'N') and
                        (TC <> #27) then
                        begin
                          ErroMsg := 'Informe A,C,S ou N';
                          ErrorMessage;
                          K := K - 1;
                        end
                        else begin
                               GotoXY(47,20); Case INSS[2] of
                                                   'A' : Write('Aut. ');
                                                   'C' : Write('Coop.');
                                                   'S' : Write('Sim  ');
                                                   'N' : Write('N∆o  ');
                                              end;
                             end;
                   end;
             31  : If INSS[2] in ['A','C'] then
                      begin
                        If FxINSS = 0 then J := ''
                                      else begin
                                             Str(FxINSS:2,J);
                                             J := LeftAdjust(J);
                                           end;
                        InputStr(J,2,56,20,0,'S','N','N','N',Tfn,Utx);
                        Val(J,FxINSS,E);
                      end;
             32  : begin
                     HelpStatus;
                     J := Status;
                     InputStr(J,1,43,21,0,'S','N','T','N',Tfn,Utx);
                     Move(ScArray5[1],Mem[$B800:0000],4000);
                     Status := UpCase(J[1]);
                     If J = ' ' then Status := 'A';
                     If TC <> #27 then
                        begin
                          GotoXY(43,21);
                          If Status in ['A','P','D','E','J','R','F','L','C','O','T','V','M','N','X']
                             then WriteStatus
                             else begin
                                    ErroMsg := 'Informe o Status';
                                    ErrorMessage;
                                    K := K - 1;
                                  end;
                        end;
                   end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : Case Op of
                      'A' : If K = 1 then K := 32
                                     else K := K - 1;
                      'I' : If K > 0 then K := K - 1;
                 end;
      end;
    Until (K = 0) or (K = 33) or (TC = #27);
    If (Op = 'A') or (K = 33) then Confirma
                              else Case TC of
                                        #27  : Confirma;
                                        else   TC := 'N';
                                   end;
  Until (K = 0) or (TC in ['S',#27]);
  If K = 0 then K := 2
           else K := 1000;
end;