Procedure TitleTela(X : Char);
begin
  TitleFunc(X);
  Color(Red,White);
  GotoXY(36,7); Write('Total de Empreg: ');
  Color(Red,Yellow);
  GotoXY(53,7); Write(CMstMember.NFunc);
  Case Tl of
       'S' : DataFunc(X);
       'N' : MatNome;
  end;
end;


Procedure EntryPFunc;
begin
  If EEMember.Nome = '' then Tl := 'N'
                        else Tl := 'S';
  TitleTela('B');
  With EEMember do
  Repeat
    K := 1;
    Repeat
        Case K of
             1   : begin
                     J := Nome;
                     InputStr(J,40,21,08,0,'S','S','T','N',Tfn,Utx);
                     Nome := J;
                     If (TC   <> #27) and
                        (Nome =  '' ) then
                        begin
                          ErroMsg := 'Preencha o Nome de Empregado';
                          ErrorMessage;
                          K := -1;
                        end;
                   end;
             2   : begin
                     J := Pai;
                     InputStr(J,40,12,09,0,'S','S','T','N',Tfn,Utx);
                     Pai := J;
                   end;
             3   : begin
                     J := Mae;
                     InputStr(J,40,12,10,0,'S','S','T','N',Tfn,Utx);
                     Mae := J;
                   end;
             4   : begin
                     J := Endereco;
                     InputStr(J,40,12,11,0,'S','S','T','N',Tfn,Utx);
                     Endereco := J;
                   end;
             5   : begin
                     J := Bairro;
                     InputStr(J,20,12,12,0,'S','S','T','N',Tfn,Utx);
                     Bairro := J;
                   end;
             6   : begin
                     J := Cidade;
                     InputStr(J,20,33,12,0,'S','S','T','N',Tfn,Utx);
                     Cidade := J;
                   end;
             7   : begin
                     J := Estado;
                     InputStr(J,2,54,12,0,'S','N','T','N',Tfn,Utx);
                     If J <> '' then
                        begin
                          Estado := UpCaseStr(J);
                          GotoXY(54,12); Write(Estado);
                          CheckUF(Estado);
                          If (TC <> #27) and
                             (R   = 1  ) then
                             begin
                               ErroMsg := 'Sigla do Estado Inv lida';
                               ErrorMessage;
                               K := K - 1;
                             end;
                        end;
                   end;
             8   : begin
                     J := Cep;
                     InputStr(J,5,12,13,0,'S','N','T','N',Tfn,Utx);
                     Cep := J;
                   end;
             9   : begin
                     J := CepCompl;
                     InputStr(J,3,18,13,0,'S','N','T','N',Tfn,Utx);
                     CepCompl := J;
                   end;
             10  : begin
                     J := Telefone;
                     InputStr(J,15,12,14,0,'S','N','T','N',Tfn,Utx);
                     Telefone := J;
                   end;
             11  : begin
                     If DDNasc = '' then J := ''
                                    else J := DDNasc + '/' +
                                              MMNasc + '/' + AANasc;
                     InputStr(J,10,12,15,0,'S','N','D','S',Tfn,Utx);
                     If TC <> #27 then
                        begin
                          DDNasc := Copy(J,1,2);
                          MMNasc := Copy(J,4,2);
                          AANasc := Copy(J,7,4);
                          GotoXY(23,15); Write(DiaSemana(DDNasc+'/'+MMNasc+'/'+AANasc));
                        end;
                   end;
             12  : begin
                     J := Sexo;
                     InputStr(J,1,12,16,0,'S','N','T','N',Tfn,Utx);
                     Sexo := UpCase(J[1]);
                     If (TC   <> #27) and
                        (Sexo <> 'F') and
                        (Sexo <> 'M') then
                        begin
                          ErroMsg := 'Sexo Inv lido ( M ou F )';
                          ErrorMessage;
                          K := K - 1;
                        end;
                     GotoXY(12,16); Case Sexo of
                                         'F' : Write('Feminino   ',#12);
                                         'M' : Write('Masculino  ',#11);
                                    end;
                   end;
             13  : begin
                     J := RacaCor;
                     InputStr(J,1,12,17,0,'S','N','T','N',Tfn,Utx);
                     if J = '' then RacaCor := '2'
                               else RacaCor := UpCase(J[1]);
                     If (TC   <> #27) and
                        (RacaCor <> '1') and
                        (RacaCor <> '2') and
                        (RacaCor <> '4') and
                        (RacaCor <> '6') and
                        (RacaCor <> '8') and
                        (RacaCor <> '9') then
                        begin
                          ErroMsg := 'Raca/Cor Inv lida (1,2,4,6,8 ou 9)';
                          ErrorMessage;
                          K := K - 1;
                        end;
                     GotoXY(12,17); Case RacaCor of
                                         '1' : Write('1 Indigena');
                                         '2' : Write('2 Branca  ');
                                         '4' : Write('4 Preta   ');
                                         '6' : Write('6 Amarela ');
                                         '8' : Write('8 Parda   ');
                                         '9' : Write('9 N.Info. ');
                                    end;
                   end;
             14  : begin
                     J := Deficiente;
                     InputStr(J,1,31,17,0,'S','N','T','N',Tfn,Utx);
                     if J = '' then Deficiente := 'N'
                               else Deficiente := UpCase(J[1]);
                     If (Deficiente <> 'S') and (Deficiente <> 'N') and (TC <> #27) then
                        begin
                          ErroMsg := 'Informe S ou N';
                          ErrorMessage;
                          K := K - 1;
                        end
                        else begin
                               GotoXY(31,17); Case Deficiente of
                                                   'S' : Write('Sim');
                                                   'N' : Write('NÆo');
                                              end;
                             end;
                   end;
             15  : begin
                     J := Eciv;
                     InputStr(J,1,12,18,0,'S','N','T','N',Tfn,Utx);
                     Eciv := UpCase(J[1]);
                     If TC <> #27 then
                        begin
                          GotoXY(12,18);  Case ECiv of
                                               'C' : Write('Casado    ');
                                               'S' : Write('Solteiro  ');
                                               'M' : Write('Marital   ');
                                               'D' : Write('Divorciado');
                                               'V' : Write('Vi£vo     ');
                                               else begin
                                                      ErroMsg := 'Estado Civil Inv lido';
                                                      ErrorMessage;
                                                      K := K - 1;
                                                    end;
                                          end;
                        end;
                   end;
             16  : begin
                     J := Nacional;
                     InputStr(J,2,12,19,0,'S','N','T','N',Tfn,Utx);
                     If J = '' then J := '10';
                     Nacional := UpCaseStr(J);
                     GotoXY(12,19); Write(Nacional);
                   end;
             17  : begin
                     J := Natural;
                     InputStr(J,2,31,19,0,'S','N','T','N',Tfn,Utx);
                     Natural := UpCaseStr(J);
                   end;
             18  : begin
                     J := Naturalz;
                     InputStr(J,1,12,20,0,'S','N','T','N',Tfn,Utx);
                     Naturalz := UpCase(J[1]);
                   end;
             19  : begin
                     J := DataChBr;
                     InputStr(J,10,16,20,0,'S','N','T','N',Tfn,Utx);
                     DataChBr := J;
                   end;
             20  : begin
                     J := Cpf;
                     InputStr(J,12,12,21,0,'S','N','T','N',Tfn,Utx);
                     Cpf := J;
                   end;
             21  : begin
                     J := CtrabN;
                     InputStr(J,10,40,13,0,'S','N','T','N',Tfn,Utx);
                     CtrabN := J;
                   end;
             22  : begin
                     J := CtrabS;
                     InputStr(J,6,51,13,0,'S','N','T','N',Tfn,Utx);
                     CtrabS := J;
                   end;
             23  : begin
                     J := CtrabE;
                     InputStr(J,2,58,13,0,'S','N','T','N',Tfn,Utx);
                     CtrabE := UpCaseStr(J);
                     GotoXY(58,13); Write(CtrabE);
                     If CtrabN <> '' then
                        begin
                          CheckUF(CtrabE);
                          If (TC <> #27) and
                             (R   = 1  ) then
                             begin
                               ErroMsg := 'Sigla do Estado Inv lida';
                               ErrorMessage;
                               K := K - 1;
                             end;
                        end;
                   end;
             24  : begin
                     J := PisPasep;
                     InputStr(J,11,40,14,0,'S','N','T','N',Tfn,Utx);
                     PisPasep := J;
                   end;
             25  : begin
                     J := Identidade;
                     InputStr(J,15,40,15,0,'S','N','T','N',Tfn,Utx);
                     Identidade := J;
                   end;
             26  : begin
                     J := CertReserv;
                     InputStr(J,15,43,16,0,'S','N','T','N',Tfn,Utx);
                     CertReserv := J;
                   end;
             27  : begin
                     J := TitEleitor;
                     InputStr(J,15,43,17,0,'S','N','T','N',Tfn,Utx);
                     TitEleitor := J;
                   end;
             28  : begin
                     J := Uniforme;
                     InputStr(J,10,43,18,0,'S','N','T','N',Tfn,Utx);
                     Uniforme := J;
                   end;
             29  : begin
                     J := Calcado;
                     InputStr(J,2,43,19,0,'S','N','T','N',Tfn,Utx);
                     Calcado := J;
                   end;
             30  : begin
                     J := Origem;
                     InputStr(J,5,43,20,0,'S','N','T','N',Tfn,Utx);
                     Origem := J;
                   end;
             31  : begin
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
                                    ErroMsg := 'Status Inv lido';
                                    ErrorMessage;
                                    K := K - 1;
                                  end;
                        end;
                   end;
        end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1
                          else K := 31;
      end;
    Until (K = 32) or (TC = #27);
    If Op = 'A' then Confirma
                else Case TC of
                          #27 : Confirma;
                          else  TC := 'S';
                     end;
  Until TC in [#27,'S'];
  K := 2;
end;