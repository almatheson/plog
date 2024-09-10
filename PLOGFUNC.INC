Procedure EntryFFunc;
Var
   IndD   : Integer;
begin
  If EEMember.Depto = '' then Tl := 'N'
                         else Tl := 'S';
  TitleTela('F');
  With EEMember do
  Repeat
    K := 1;
    Repeat
      Case K of
             1   : begin
                     Color(Blue,White);
                     GotoXY(1,24); Write(ConstStr(' ',80));
                     GotoXY(2,24); Write('F1');
                     Color(Blue,Cyan);
                     GotoXY(5,24); Write('para pesquisar Deptos');
                     Color(Tfn,Utx);
                     GotoXY(12,11); Write(ConstStr(' ',41));
                     J := Depto;
                     InputStr(J,10,12,11,0,'S','N','T','N',Tfn,Utx);
                     Depto := J;
                     If TC = #21 then
                        begin
                          DDNo := J;
                          DDAC := DDNo;
                          ScrollDept('N');
                          Depto := DDAC;
                        end
                        else If (TC    <> #27) and
                                (Depto <> '' ) then
                                begin
                                  DDNo  := Depto;
                                  SearchTree3 ( Root3 );
                                  If RC = 'S' then
                                     With DDMember do
                                     begin
                                       ReadWrite(#05,'R','N',DDNumber);
                                       GotoXY(12,11);
                                       Write(Depto,' ',Copy(Descricao,1,30));
                                     end
                                     else begin
                                            ErroMsg := 'Departamento n∆o Existe';
                                            ErrorMessage;
                                            K := K - 1;
                                          end;
                                end
                                else If TC <> #27 then
                                        begin
                                          ErroMsg := 'Informe o Departamento';
                                          ErrorMessage;
                                          K := K - 1;
                                        end;
                     LimpaLn(24,Tfd);
                   end;
             2   : begin
                     Color(Blue,White);
                     GotoXY(1,24); Write(ConstStr(' ',80));
                     GotoXY(2,24); Write('F1');
                     Color(Blue,Cyan);
                     GotoXY(5,24); Write('para pesquisar Sindicatos');
                     J := Sindicato;
                     InputStr(J,2,12,12,0,'S','N','T','N',Tfn,Utx);
                     Sindicato := J;
                     If TC = #21 then
                        begin
                          SSNo := J;
                          SSAC := SSNo;
                          ScrollSind;
                          Sindicato := SSAC;
                        end
                        else If (TC        <> #27) and
                                (Sindicato <> '' ) then
                                begin
                                  SSNo := Sindicato;
                                  SearchTree2 ( Root2 );
                                  If RC = 'S' then
                                     With SSMember do
                                     begin
                                       ReadWrite(#07,'R','N',SSNumber);
                                       GotoXY(12,12); Write(' ':35);
                                       GotoXY(12,12);
                                       Write(Sindicato,' ',Copy(Descricao,1,35));
                                     end
                                     else begin
                                            ErroMsg := 'Sindicato n∆o Existe';
                                            ErrorMessage;
                                            K := K - 1;
                                          end;
                                end
                                else If TC <> #27 then
                                        begin
                                          ErroMsg := 'Informe o Sindicato';
                                          ErrorMessage;
                                          K := K - 1;
                                        end;;
                     LimpaLn(24,Tfd);
                   end;
             3  :  begin
                     Move(MemW[$B800:0000],ScArray5[1],4000);
                     Color(Blue,White);
                     GotoXY(1,24); Write(ConstStr(' ',80));
                     GotoXY(2,24); Write('F1');
                     Color(Blue,Cyan);
                     GotoXY(5,24); Write('para pesquisar Deptos');
                     Color(Tfn,Utx);
                     DrawBox(49,10,73,17,Bfn,'S');
                     Color(Sfn,Stx);
                     GotoXY(49,10); Write(' Departamentos   Nß.Dias ');
                     Color(Bfn,Btx);
                     GotoXY(52,12); Write('1ß');
                     GotoXY(52,13); Write('2ß');
                     GotoXY(52,14); Write('3ß');
                     GotoXY(52,15); Write('4ß');
                     GotoXY(52,16); Write('5ß');
                     For I := 1 to 5 do begin
                                          GotoXY(55,I+11); Write(CentroC[I]);
                                          GotoXY(66,I+11); Write(EditReal(DiasC[I]):6);
                                        end;
                     IndD := 1;
                     Repeat
                       J := CentroC[IndD];
                       InputStr(J,6,55,IndD+11,0,'S','N','T','N',Bfn,Btx);
                       Case TC of
                            #21 : begin
                                    DDNo := J;
                                    DDAC := DDNo;
                                    ScrollDept('N');
                                    CentroC[IndD] := DDAC;
                                    IndD := IndD - 1;
                                    TC   := #13;
                                  end;
                            #13 : If J <> '' then
                                     begin
                                       CentroC[IndD] := TiraBranco(J);
                                       If DiasC[IndD] = 0 then J := ''
                                          else begin
                                                 Str(DiasC[IndD]:5:2,J);
                                                 J := LeftAdjust(J);
                                               end;
                                       InputStr(J,6,66,IndD+11,0,'S','N','$','N',Bfn,Btx);
                                       Val(J,DiasC[IndD],E);
                                     end
                                     else begin
                                            CentroC[IndD] := '';
                                            DiasC[IndD]   := 0;
                                          end;
                       end;
                       Case TC of
                            #13 : IndD := IndD + 1;
                            #24 : IndD := IndD - 1;
                       end;
                     Until (IndD = 0) or (IndD = 6) or (TC = #27);
                     Move(ScArray5[1],MemW[$B800:0000],4000);
                     Color(Tfn,Utx);
                     GotoXY(12,13); Write(PushLeft(7,CentroC[1]));
                     GotoXY(19,13); Write(EditReal(DiasC[1]):6);
                   end;
             4   : begin
                     J := Cargo;
                     InputStr(J,15,12,14,0,'S','S','T','N',Tfn,Utx);
                     Cargo := J;
                   end;
             5  :  begin
                     J := Grau;
                     InputStr(J,1,12,15,0,'S','N','T','N',Tfn,Utx);
                     Grau := J;
                   end;
             6   : begin
                     If DDAdm = '' then J := ''
                                   else J := DDAdm + '/' +
                                             MMAdm + '/' + AAAdm;
                     InputStr(J,10,12,16,0,'S','N','D','S',Tfn,Utx);
                     If TC <> #27 then
                        begin
                          DDAdm := Copy(J,1,2);
                          MMAdm := Copy(J,4,2);
                          AAAdm := Copy(J,7,4);
                        end;
                   end;
             7   : begin
                     J := TipoE;
                     InputStr(J,1,12,17,0,'S','N','T','N',Tfn,Utx);
                     TipoE := UpCase(J[1]);
                     If TC <> #27 then
                        begin
                          GotoXY(12,17); Case TipoE of
                                              '1' : Write('1ß Emprego   ');
                                              'R' : Write('Reemprego    ');
                                              'T' : Write('Transferància');
                                              'O' : Write('Outros       ');
                                              else begin
                                                     ErroMsg := 'Tipo de Emprego Inv†lido (1,R ou T)';
                                                     ErrorMessage;
                                                     K := K - 1;
                                                   end;
                                         end;
                        end;
                   end;
             8   : begin
                     J := CBO;
                     InputStr(J,6,12,18,0,'S','N','T','N',Tfn,Utx);
                     CBO := J;
                   end;
             9   : begin
                     J := NoMTrab;
                     InputStr(J,15,12,19,0,'S','N','T','N',Tfn,Utx);
                     NoMTrab := J;
                   end;
             10  : begin
                     J := Opcao;
                     InputStr(J,1,12,20,0,'S','N','T','N',Tfn,Utx);
                     If UpCase(J[1]) = 'S'  then Opcao := 'S'
                                            else Opcao := 'N';
                     GotoXY(12,20); Case Opcao of
                                         'N' : Write('N∆o');
                                         'S' : Write('Sim');
                                         else begin
                                                ErroMsg := 'Informe S ou N';
                                                ErrorMessage;
                                                K := K - 1;
                                              end;
                                    end;
                   end;
             11  : If Opcao = 'S' then
                      begin
                        DataOpcao := DDAdm + '/' + MMAdm + '/' + AAAdm;
                        J := DataOpcao;
                        InputStr(J,10,16,20,0,'S','N','D','S',Tfn,Utx);
                        If TC <> #27 then DataOpcao := J;
                      end;
             12  : begin
                     Move(Mem[$B800:0000],ScArray5[1],4000);
                     DrawBox(06,09,22,13,Red,'S');
                     Color(Red,Cyan);
                     GotoXY(07,10); Write('C¢digos da RAIS');
                     GotoXY(07,11); Write('N - Empregador ');
                     GotoXY(07,12); Write('A - Autonomo   ');
                     Color(Red,White);
                     GotoXY(18,10); Write('RAIS');
                     GotoXY(07,11); Write('N');
                     GotoXY(07,12); Write('A');
                     J := Vinculo;
                     InputStr(J,2,12,21,0,'S','N','T','N',Tfn,Utx);
                     Move(ScArray5[1],Mem[$B800:0000],4000);
                     If J = '' then J := '10';
                     Vinculo := UpCaseStr(J);
                     If (TC <> #27) and
                        (Vinculo[1] <> 'A' ) and
                        (Vinculo[1] <> 'N' ) and
                        (Vinculo    <> '10') and
                        (Vinculo    <> '15') and
                        (Vinculo    <> '20') and
                        (Vinculo    <> '25') and
                        (Vinculo    <> '30') and
                        (Vinculo    <> '35') and
                        (Vinculo    <> '40') and
                        (Vinculo    <> '50') and
                        (Vinculo    <> '60') and
                        (Vinculo    <> '70') and
                        (Vinculo    <> '80') then
                        begin
                          ErroMsg := 'Vinculo Inv†lido';
                          ErrorMessage;
                          K := K - 1;
                        end;
                     GotoXY(12,21); Write(PushLeft(2,Vinculo));
                   end;
             13  : begin
                     J := TipoExame;
                     InputStr(J,1,36,13,0,'S','S','T','N',Tfn,Utx);
                     TipoExame := UpCase(J[1]);
                   end;
             14  : begin
                     J := DataExame;
                     InputStr(J,10,38,13,0,'S','N','T','S',Tfn,Utx);
                     If (TC <> #27) and (J <> '') then
                        begin
                          J := ChkData(J);
                          If J = '' then
                             begin
                               ErroMsg := 'Data Inv†lida';
                               ErrorMessage;
                               K := K - 1;
                             end
                             else begin
                                    DataExame := J;
                                    GotoXY(38,13); Write(DataExame);
                                  end;
                        end;
                   end;
             15  : begin
                     J := Registro;
                     InputStr(J,15,36,14,0,'S','S','T','N',Tfn,Utx);
                     Registro := J;
                   end;
             16  : begin
                     J := Turno;
                     InputStr(J,20,36,15,0,'S','N','T','N',Tfn,Utx);
                     Turno := J;
                     If Turno <> '' then
                        begin
                          Entrada     := '';
                          Saida       := '';
                          IntRefeicao := '';
                          RepSemanal  := '';
                          GotoXY(36,16); Write(' ':5);
                          GotoXY(50,16); Write(' ':5);
                          GotoXY(36,17); Write(' ':15);
                          GotoXY(36,18); Write(' ':10);
                          If TC = #13 then K := 21;
                        end;
                   end;
             17  : begin
                     J := Entrada;
                     InputStr(J,5,36,16,0,'S','S','T','N',Tfn,Utx);
                     Entrada := J;
                   end;
             18  : begin
                     J := Saida;
                     InputStr(J,5,50,16,0,'S','S','T','N',Tfn,Utx);
                     Saida := J;
                   end;
             19  : begin
                     J := IntRefeicao;
                     InputStr(J,15,36,17,0,'S','S','T','N',Tfn,Utx);
                     IntRefeicao := J;
                   end;
             20  : begin
                     J := RepSemanal;
                     InputStr(J,10,36,18,0,'S','S','T','N',Tfn,Utx);
                     RepSemanal := J;
                   end;
             21  : begin
                     J := DataAvp;
                     InputStr(J,10,36,19,0,'S','N','T','N',Tfn,Utx);
                     DataAvp := J;
                   end;
             22  : begin
                     If DDResc = '' then J := ''
                                    else J := DDResc + '/' +
                                              MMResc + '/' + AAResc;
                     InputStr(J,10,45,19,0,'S','N','T','N',Tfn,Utx);
                     If TC <> #27 then
                        begin
                          If Status in ['A','C','E','F','L','T','V'] then
                             begin
                               DDResc := '';
                               MMResc := '';
                               AAResc := '';
                               GotoXY(45,19); Write(ConstStr(' ',10));
                             end
                             else begin
                                    J := ChkData(J);
                                    If J = '' then
                                       begin
                                         ErroMsg := 'Data Inv†lida';
                                         ErrorMessage;
                                         K := K - 1;
                                       end
                                       else begin
                                              DDResc := Copy(J,1,2);
                                              MMResc := Copy(J,4,2);
                                              AAResc := Copy(J,7,4);
                                              GotoXY(45,19); Write(J);
                                            end;
                                  end;
                        end;
                   end;
             23  : begin
                     J := Causa;
                     InputStr(J,2,54,19,0,'S','N','T','N',Tfn,Utx);
                     Causa := J;
                   end;
             24  : begin
                     If Pontos = 0 then J := ''
                                   else begin
                                          Str(Pontos:5,J);
                                          J := LeftAdjust(J);
                                        end;
                     InputStr(J,5,36,20,0,'S','N','T','N',Tfn,Utx);
                     Val(J,Pontos,E);
                     GotoXY(36,20); Write(Pontos:5);
                   end;
             25  : begin
                     J := Sala;
                     InputStr(J,5,49,20,0,'S','N','T','N',Tfn,Utx);
                     Sala := J;
                   end;
             26  : begin
                     J := Ramal;
                     InputStr(J,5,55,20,0,'S','N','T','N',Tfn,Utx);
                     Ramal := J;
                   end;
             27  : begin
                     HelpStatus;
                     J := Status;
                     InputStr(J,1,36,21,0,'S','N','T','N',Tfn,Utx);
                     Move(ScArray5[1],Mem[$B800:0000],4000);
                     Status := UpCase(J[1]);
                     If J = ' ' then Status := 'A';
                     If TC <> #27 then
                        begin
                          GotoXY(36,21);
                          If Status in ['A','P','D','E','J','R','F','L','C','O','T','V','M','N','X']
                             then WriteStatus
                             else begin
                                    ErroMsg := 'Status Inv†lido';
                                    ErrorMessage;
                                    K := K - 1;
                                  end;
                        end;
                   end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : Case Op of
                      'A' : If K = 1 then K := 27
                                     else K := K - 1;
                      'I' : If K > 0 then K := K - 1;
                 end;
      end;
    Until (K = 0) or (K = 28) or (TC = #27);
    If Op = 'A' then Confirma
                else Case TC of
                          #27 : Confirma;
                          else TC := 'S';
                     end;
  Until TC in ['S',#27];
  If K = 0 then K := 1
           else If K = 28 then K := 3;
end;