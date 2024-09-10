Procedure HelpBox;
begin
  Move(MemW[$B800:0000],ScArray5[1],4000);
  DrawBox(38,13,57,16,Red,'S');
  Color(Red,Cyan);
  GotoXY(38,14); Write('         im         ');
  GotoXY(38,15); Write('         Æo         ');
  Color(Red,White);
  GotoXY(46,14); Write('S');
  GotoXY(46,15); Write('N');
  Color(Tfn,Utx);
end;


Procedure DataCalculos(X : Char);
begin
  Move(MemW[$B800:0000],ScArray5[1],4000);
  Color(Red,White);
  GotoXY(62,08); Write('                ');
  GotoXY(62,09); Write('                ');
  GotoXY(62,10); Write('                ');
  GotoXY(62,11); Write('                ');
  GotoXY(62,12); Write('                ');
  GotoXY(62,13); Write('                ');
  GotoXY(62,14); Write('                ');
  GotoXY(62,15); Write('                ');
  GotoXY(62,16); Write('                ');
  GotoXY(62,17); Write('                ');
  If X = 'S' then
     begin
       GotoXY(62,18); Write('F3              ');
     end;
  GotoXY(62,19); Write('Esc             ');
  Color(Red,Yellow);
  If X = 'S' then
     begin
       GotoXY(66,18); Write('Alterar   ');
     end;
  GotoXY(66,19); Write('Retornar  ');
  Shade(3,8,60,21,LightGray,Black);
  DrawBox(29,12,54,17,Sfn,'S');
  Color(Bfn,Btx);
  GotoXY(29,12); Write(' C¢d V,H +,- N123.4 ou  S ');
  GotoXY(29,13); Write(' Cta $,A *,/ D,F,M,P,T  A ');
  Color(Sfn,Stx);
  For I := 1 to 2 do begin
                       GotoXY(30,14+I);
                       Write(PushLeft(5,CCMember.Resultado[I]),
                             PushLeft(4,CCMember.Conteudo[I]),
                             PushLeft(3,CCMember.Operador[I]),
                             PushLeft(11,CCMember.Operando[I]),
                             CCMember.SubAdic[I]);
                     end;
end;


Procedure EntryCalculos;
begin
  Repeat
    K := 1;
    Repeat
      Case K of
           1,6   : With CCMember do
                   begin
                     If K = 1 then I := 1
                              else I := 2;
                     J := Resultado[I];
                     InputStr(J,3,30,14+I,0,'S','N','T','N',Sfn,Stx);
                     Resultado[I] := J;
                     If (TC           <> #27) and
                        (Resultado[I] <> '' ) then
                        begin
                          GotoXY(30,14+I); Write(Resultado[I]);
                        end;
                   end;
           2,7   : With CCMember do
                   begin
                     If K = 2 then I := 1
                              else I := 2;
                     If Resultado[I] <> '' then
                        begin
                          J := Conteudo[I];
                          InputStr(J,1,35,14+I,0,'S','N','T','N',Sfn,Stx);
                          Conteudo[I] := UpCase(J[1]);
                          If (TC          <> #27) and
                             (Conteudo[I] <> '$') and
                             (Conteudo[I] <> 'A') and
                             (Conteudo[I] <> 'H') and
                             (Conteudo[I] <> 'V') then
                             begin
                               ErroMsg := 'Informe $,V para valor ou A,H para horas';
                               ErrorMessage;
                               K := K - 1;
                             end
                             else begin
                                    GotoXY(35,14+I); Write(Conteudo[I]);
                                  end;
                        end;
                   end;
           3,8   : With CCMember do
                   begin
                     If K = 3 then I := 1
                              else I := 2;
                     If Resultado[I] <> '' then
                        begin
                          J := Operador[I];
                          InputStr(J,1,39,14+I,0,'S','N','T','N',Sfn,Stx);
                          Operador[I] := UpCase(J[1]);
                          If (TC <> #27) and
                             (not (Operador[I] in ['+','-','*','/'])) then
                             begin
                               ErroMsg := 'Informe a opera‡Æo +,-,* ou /';
                               ErrorMessage;
                               K := K - 1;
                             end
                             else begin
                                    GotoXY(39,14+I); Write(Operador[I]);
                                  end;
                        end;
                   end;
           4,9   : With CCMember do
                   begin
                     If K = 4 then I := 1
                              else I := 2;
                     J := Operando[I];
                     If Resultado[I] <> '' then
                        begin
                          InputStr(J,10,42,14+I,0,'S','N','T','N',Sfn,Stx);
                          Operando[I] := UpcaseStr(J);
                          If TC <> #27 then
                             begin
                               If not (Upcase(J[1]) in ['D','F','M','N','P','T']) then
                                  begin
                                    ErroMsg := 'Informe (D,F,M,P,T ou N12345)';
                                    ErrorMessage;
                                    K := K - 1;
                                  end
                                  else begin
                                         GotoXY(42,14+I); Write(Operando[I]);
                                       end;
                             end;
                        end;
                   end;
           5,10  : With CCMember do
                   begin
                     If K = 5 then I := 1
                              else I := 2;
                     If Resultado[I] <> '' then
                        begin
                          J := SubAdic[I];
                          InputStr(J,1,53,14+I,0,'S','N','T','N',Sfn,Stx);
                          SubAdic[I] := UpCase(J[1]);
                          If (TC         <> #27) and
                             (SubAdic[I] <> 'S') and
                             (SubAdic[I] <> 'A') then
                             begin
                               ErroMsg := 'Informe S para substituir ou A para adicionar';
                               ErrorMessage;
                               K := K - 1;
                             end
                             else begin
                                    GotoXY(53,14+I); Write(SubAdic[I]);
                                  end;
                        end;
                   end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1
                          else K := 10;
      end;
    Until (K = 11) or (TC = #27);
    Confirma;
  Until TC in ['S',#27];
end;


Procedure EntryConta;
begin
  Repeat
    K := 1;
    Repeat
      Case K of
           1   : With CCMember do
                 begin
                   J := Descricao;
                   InputStr(J,30,12,10,0,'S','S','T','N',Tfn,Utx);
                   Descricao := J;
                   If (Descricao = '') and (TC <> #27) then
                      begin
                        ErroMsg := 'Informe a Descri‡Æo da Conta';
                        ErrorMessage;
                        K := K - 1;
                      end;
                 end;
           2   : With CCMember do
                 begin
                   Move(MemW[$B800:0000],ScArray5[1],4000);
                   DrawBox(38,14,57,18,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(38,15); Write('       rovento      ');
                   GotoXY(38,16); Write('       esconto      ');
                   GotoXY(38,17); Write('       utros        ');
                   Color(Red,White);
                   GotoXY(44,15); Write('P');
                   GotoXY(44,16); Write('D');
                   GotoXY(44,17); Write('O');
                   J := Tipo;
                   InputStr(J,1,12,11,0,'S','N','T','N',Tfn,Utx);
                   Tipo := UpCase(J[1]);
                   If J = ' ' then Tipo := 'P';
                   If (TC   <> #27) and
                      (Tipo <> 'P') and
                      (Tipo <> 'D') and
                      (Tipo <> 'O') then
                      begin
                        ErroMsg := 'Informe P,D ou O';
                        ErrorMessage;
                        K := K - 1;
                      end;
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(12,11); Case Tipo of
                                       'P' : Write('Provento');
                                       'D' : Write('Desconto');
                                       'O' : Write('Outros  ');
                                       else  Write(Tipo);
                                  end;
                 end;
           3   : With CCMember do
                 begin
                   Move(MemW[$B800:0000],ScArray5[1],4000);
                   DrawBox(38,14,57,17,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(38,15); Write('      empor ria     ');
                   GotoXY(38,16); Write('      ermanente     ');
                   Color(Red,White);
                   GotoXY(43,15); Write('T');
                   GotoXY(43,16); Write('P');
                   J := Tempo;
                   InputStr(J,1,12,12,0,'S','N','T','N',Tfn,Utx);
                   Tempo := UpCase(J[1]);
                   If J = ' ' then Tempo := 'P';
                   If (TC    <> #27) and
                      (Tempo <> 'P') and
                      (Tempo <> 'T') then
                      begin
                        ErroMsg := 'Informe T ou P';
                        ErrorMessage;
                        K := K - 1;
                      end;
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(12,12); Case Tempo of
                                       'T' : Write('Tempor ria');
                                       'P' : Write('Permanente');
                                       else  Write(Tempo);
                                  end;
                 end;
           4   : With CCMember do
                 begin
                   Move(MemW[$B800:0000],ScArray5[1],4000);
                   DrawBox(38,12,57,17,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(38,13); Write('    diantamento     ');
                   GotoXY(38,14); Write('   Semana  , , ou   ');
                   GotoXY(38,15); Write('    agamento        ');
                   GotoXY(38,16); Write('   Ad.13§ Sal.( ),  ');
                   GotoXY(38,17); Write('   13§ Sal rio      ');
                   Color(Red,White);
                   GotoXY(41,13); Write('A');
                   GotoXY(48,14); Write('1');
                   GotoXY(50,14); Write('2');
                   GotoXY(52,14); Write('3');
                   GotoXY(56,14); Write('4');
                   GotoXY(41,15); Write('P');
                   GotoXY(53,16); Write('O');
                   GotoXY(45,17); Write('S');
                   J := Operacao;
                   InputStr(J,1,12,13,0,'S','N','T','N',Tfn,Utx);
                   Operacao := UpCase(J[1]);
                   If J = ' ' then Operacao := 'P';
                   If (TC       <> #27) and
                      (Operacao <> 'A') and
                      (Operacao <> '1') and
                      (Operacao <> '2') and
                      (Operacao <> '3') and
                      (Operacao <> '4') and
                      (Operacao <> 'O') and
                      (Operacao <> 'P') and
                      (Operacao <> 'S') then
                      begin
                        ErroMsg := 'Informe A,1,2,3,4,O,P ou S';
                        ErrorMessage;
                        K := K - 1;
                      end;
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(12,13); Case Operacao of
                                       'A' : Write('Adiantamento');
                                       '1' : Write('1¦ Senana   ');
                                       '2' : Write('2¦ Semana   ');
                                       '3' : Write('3¦ Semana   ');
                                       '4' : Write('4¦ Semana   ');
                                       'O' : Write('Ad.13§ Sal. ');
                                       'P' : Write('Pagamento   ');
                                       'S' : Write('13§ Sal rio ');
                                       else  Write(Operacao);
                                  end;
                 end;
           5   : With CCMember do
                 begin
                   HelpBox;
                   J := Aceita;
                   InputStr(J,1,12,14,0,'S','N','T','N',Tfn,Utx);
                   Aceita := UpCase(J[1]);
                   If J = ' ' then Aceita := 'S';
                   If (TC     <> #27) and
                      (Aceita <> 'S') and
                      (Aceita <> 'N') then
                      begin
                        ErroMsg := 'Informe S ou N';
                        ErrorMessage;
                        K := K - 1;
                      end;
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(12,14); Case Aceita of
                                       'S' : Write('Sim');
                                       'N' : Write('NÆo');
                                       else  Write(Aceita);
                                  end;
                 end;
           6   : With CCMember do
                 begin
                   Move(MemW[$B800:0000],ScArray5[1],4000);
                   DrawBox(38,14,57,18,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(38,15); Write(' Acumula horas para ');
                   GotoXY(38,16); Write(' f‚rias: Sim        ');
                   GotoXY(38,17); Write('         NÆo        ');
                   Color(Red,White);
                   GotoXY(47,16); Write('S');
                   GotoXY(47,17); Write('N');
                   J := Media;
                   InputStr(J,1,12,15,0,'S','N','T','N',Tfn,Utx);
                   Media := UpCase(J[1]);
                   If J = ' ' then Media := 'N';
                   If (TC    <> #27) and
                      (Media <> 'N') and
                      (Media <> 'S') then
                      begin
                        ErroMsg := 'Informe S ou N';
                        ErrorMessage;
                        K := K - 1;
                      end;
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(12,15); Case Media of
                                       'N' : Write('NÆo');
                                       'S' : Write('Sim');
                                       else  Write(Media);
                                  end;
                 end;
           7   : With CCMember do
                 begin
                   Move(MemW[$B800:0000],ScArray5[1],4000);
                   DrawBox(38,14,57,18,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(38,15); Write(' Fator utilizado na ');
                   GotoXY(38,16); Write(' conversÆo de horas ');
                   GotoXY(38,17); Write(' p/corrigir o VALOR ');
                   If Taxa = 0 then J := ''
                               else begin
                                      Str(Taxa:8:4,J);
                                      J := LeftAdjust(J);
                                    end;
                   InputStr(J,8,12,16,0,'S','N','T','N',Tfn,Utx);
                   If TC = '' then Taxa := 0
                              else Val(J,Taxa,E);
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(12,16); Write(Taxa:8:4);
                 end;
           8   : With CCMember do
                 begin
                   Move(MemW[$B800:0000],ScArray5[1],4000);
                   DrawBox(18,12,59,16,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(18,12); Write(' Taxa hor ria usada na conversÆo em VALOR ');
                   GotoXY(18,13); Write('      (Sal rio+Produtividade)/HNormais    ');
                   GotoXY(18,14); Write('      (Sal+Prod+Peri+Ins+AdNot)/HNormais  ');
                   GotoXY(18,15); Write(' 6..0 Bases do Usu rio/HNormais           ');
                   GotoXY(18,16); Write(' Atencao: qdo. omitida a TAXA   ‚ usada.  ');
                   Color(Red,White);
                   GotoXY(19,13); Write('1');
                   GotoXY(19,14); Write('2');
                   GotoXY(19,15); Write('6..0');
                   GotoXY(48,16); Write('1');
                   J := TxConv;
                   InputStr(J,1,12,17,0,'S','N','T','N',Tfn,Utx);
                   TxConv := UpCase(J[1]);
                   If (TC     <> #27) and
                      (TxConv <> ' ') and
                      (TxConv <> '0') and
                      (TxConv <> '1') and
                      (TxConv <> '2') and
                      (TxConv <> '6') and
                      (TxConv <> '7') and
                      (TxConv <> '8') and
                      (TxConv <> '9') and
                      (TxConv <> 'N') then
                      begin
                        ErroMsg := 'Informe 1,2 ou 6,7,8,9 ou 0 para bases do usu rio';
                        ErrorMessage;
                        K := K - 1;
                      end;
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(12,17);
                   Case TxConv of
                        '1','2'      : Write(TxConv,' Taxa hor ria   ');
                        '0','6'..'9' : Write(TxConv,' Base de Usu rio');
                        else begin
                               Write('                 ');
                               TxConv := ' ';
                             end;
                   end;
                 end;
           9   : With CCMember do
                 begin
                   Move(MemW[$B800:0000],ScArray5[1],4000);
                   DrawBox(38,14,57,19,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(38,15); Write('         im         ');
                   GotoXY(38,16); Write('         Æo         ');
                   GotoXY(38,17); Write('         ‚rias      ');
                   GotoXY(38,18); Write('         3§Sal rio  ');
                   Color(Red,White);
                   GotoXY(46,15); Write('S');
                   GotoXY(46,16); Write('N');
                   GotoXY(46,17); Write('F');
                   GotoXY(46,18); Write('1');
                   J := Bases[1];
                   InputStr(J,1,12,18,0,'S','N','T','N',Tfn,Utx);
                   Bases[1] := UpCase(J[1]);
                   If J = ' ' then Bases[1] := 'S';
                   If (TC     <> #27) and
                      (Bases[1] <> 'S') and
                      (Bases[1] <> 'N') and
                      (Bases[1] <> 'F') and
                      (Bases[1] <> '1') then
                      begin
                        ErroMsg := 'Informe S,N,F (f‚rias) ou 1 (13§Sal.)';
                        ErrorMessage;
                        K := K - 1;
                      end;
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(12,18); Case Bases[1] of
                                       'S' : Write('Sim    ');
                                       'N' : Write('NÆo    ');
                                       'F' : Write('F‚rias ');
                                       '1' : Write('13§Sal.');
                                       else  Write(Bases[1]);
                                  end;
                 end;
           10  : With CCMember do
                 begin
                   Move(MemW[$B800:0000],ScArray5[1],4000);
                   DrawBox(38,14,57,19,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(38,15); Write('  im                ');
                   GotoXY(38,16); Write('  Æo                ');
                   GotoXY(38,17); Write('  ‚rias  (RescisÆo) ');
                   GotoXY(38,18); Write('  3§ Sal.(RescisÆo) ');
                   Color(Red,White);
                   GotoXY(39,15); Write('S');
                   GotoXY(39,16); Write('N');
                   GotoXY(39,17); Write('F');
                   GotoXY(39,18); Write('1');
                   J := Bases[2];
                   InputStr(J,1,12,19,0,'S','N','T','N',Tfn,Utx);
                   Bases[2] := UpCase(J[1]);
                   If J = ' ' then Bases[2] := 'S';
                   If (TC     <> #27) and
                      (Bases[2] <> 'S') and
                      (Bases[2] <> 'N') and
                      (Bases[2] <> '1') and
                      (Bases[2] <> 'F') then
                      begin
                        ErroMsg := 'Informe S,N, F (f‚rias) ou 1 (13§Sal rio)';
                        ErrorMessage;
                        K := K - 1;
                      end;
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(12,19); Case Bases[2] of
                                       'S' : Write('Sim    ');
                                       'N' : Write('NÆo    ');
                                       'F' : Write('F‚rias ');
                                       '1' : Write('13§Sal.');
                                       else  Write(Bases[1]);
                                  end;
                 end;
           11  : With CCMember do
                 begin
                   HelpBox;
                   J := Bases[3];
                   InputStr(J,1,12,20,0,'S','N','T','N',Tfn,Utx);
                   Bases[3] := UpCase(J[1]);
                   If J = ' ' then Bases[3] := 'S';
                   If (TC       <> #27) and
                      (Bases[3] <> 'S') and
                      (Bases[3] <> 'N') then
                      begin
                        ErroMsg := 'Informe S ou N';
                        ErrorMessage;
                        K := K - 1;
                      end;
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(12,20); Case Bases[3] of
                                       'S' : Write('Sim');
                                       'N' : Write('NÆo');
                                       else  Write(Bases[3]);
                                  end;
                 end;
           12  : With CCMember do
                 begin
                   HelpBox;
                   J := Bases[4];
                   InputStr(J,1,48,11,0,'S','N','T','N',Tfn,Utx);
                   If J = ' ' then Bases[4] := 'N'
                              else If UpCase(J[1]) in ['S','N']
                                      then Bases[4] := UpCase(J[1])
                                      else Bases[4] := 'N';
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(48,11); Case Bases[4] of
                                       'S' : Write('Sim');
                                       'N' : Write('NÆo');
                                  end;
                 end;
           13  : With CCMember do
                 begin
                   HelpBox;
                   J := Bases[5];
                   InputStr(J,1,48,12,0,'S','N','T','N',Tfn,Utx);
                   If J = ' ' then Bases[5] := 'N'
                              else If UpCase(J[1]) in ['S','N']
                                      then Bases[5] := UpCase(J[1])
                                      else Bases[5] := 'N';
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(48,12); Case Bases[5] of
                                       'S' : Write('Sim');
                                       'N' : Write('NÆo');
                                  end;
                 end;
           14  : With CCMember do
                 begin
                   Move(MemW[$B800:0000],ScArray5[1],4000);
                   DrawBox(18,9,46,12,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(18,09); Write(' Bases de c lculo do Usu rio ');
                   GotoXY(18,10); Write(' Informe S para considerar a ');
                   GotoXY(18,11); Write(' conta nesta base, ou N para ');
                   GotoXY(18,12); Write(' nÆo considerar.             ');
                   Color(Red,White);
                   GotoXY(27,10); Write('S');
                   GotoXY(40,11); Write('N');
                   J := Bases[6];
                   InputStr(J,1,48,13,0,'S','N','T','N',Tfn,Utx);
                   If J = ' ' then Bases[6] := 'N'
                              else If UpCase(J[1]) in ['S','N']
                                      then Bases[6] := UpCase(J[1])
                                      else Bases[6] := 'N';
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(48,13); Case Bases[6] of
                                       'S' : Write('Sim');
                                       'N' : Write('NÆo');
                                  end;
                 end;
           15  : With CCMember do
                 begin
                   J := Bases[7];
                   InputStr(J,1,48,14,0,'S','N','T','N',Tfn,Utx);
                   If J = ' ' then Bases[7] := 'N'
                              else If UpCase(J[1]) in ['S','N']
                                      then Bases[7] := UpCase(J[1])
                                      else Bases[7] := 'N';
                   GotoXY(48,14); Case Bases[7] of
                                       'S' : Write('Sim');
                                       'N' : Write('NÆo');
                                  end;
                 end;
           16  : With CCMember do
                 begin
                   J := Bases[8];
                   InputStr(J,1,48,15,0,'S','N','T','N',Tfn,Utx);
                   If J = ' ' then Bases[8] := 'N'
                              else If UpCase(J[1]) in ['S','N']
                                      then Bases[8] := UpCase(J[1])
                                      else Bases[8] := 'N';
                   GotoXY(48,15); Case Bases[8] of
                                       'S' : Write('Sim');
                                       'N' : Write('NÆo');
                                  end;
                 end;
           17  : With CCMember do
                 begin
                   J := Bases[9];
                   InputStr(J,1,48,16,0,'S','N','T','N',Tfn,Utx);
                   If J = ' ' then Bases[9] := 'N'
                              else If UpCase(J[1]) in ['S','N']
                                      then Bases[9] := UpCase(J[1])
                                      else Bases[9] := 'N';
                   GotoXY(48,16); Case Bases[9] of
                                       'S' : Write('Sim');
                                       'N' : Write('NÆo');
                                  end;
                 end;
           18  : With CCMember do
                 begin
                   J := Bases[10];
                   InputStr(J,1,48,17,0,'S','N','T','N',Tfn,Utx);
                   If J = ' ' then Bases[10] := 'N'
                              else If UpCase(J[1]) in ['S','N']
                                      then Bases[10] := UpCase(J[1])
                                      else Bases[10] := 'N';
                   GotoXY(48,17); Case Bases[10] of
                                       'S' : Write('Sim');
                                       'N' : Write('NÆo');
                                  end;
                 end;
           19  : With CCMember do
                 begin
                   HelpBox;
                   J := RepousoM;
                   InputStr(J,1,48,18,0,'S','N','T','N',Tfn,Utx);
                   If J = ' ' then Custo := 'N'
                              else If UpCase(J[1]) in ['S','N']
                                      then RepousoM := UpCase(J[1])
                                      else RepousoM := 'N';
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(48,18); Case RepousoM of
                                       'S' : Write('Sim');
                                       'N' : Write('NÆo');
                                  end;
                 end;
           20  : With CCMember do
                 begin
                   HelpBox;
                   J := Custo;
                   InputStr(J,1,48,19,0,'S','N','T','N',Tfn,Utx);
                   If J = ' ' then Custo := 'N'
                              else If UpCase(J[1]) in ['S','N']
                                      then Custo := UpCase(J[1])
                                      else Custo := 'N';
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(48,19); Case Custo of
                                       'S' : Write('Sim');
                                       'N' : Write('NÆo');
                                  end;
                 end;
           21  : With CCMember do
                 begin
                   Move(MemW[$B800:0000],ScArray5[1],4000);
                   DrawBox(8,11,27,15,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(08,12); Write('      tiva          ');
                   GotoXY(08,13); Write('      esativada     ');
                   GotoXY(08,14); Write('      ancelada      ');
                   Color(Red,White);
                   GotoXY(13,12); Write('A');
                   GotoXY(13,13); Write('D');
                   GotoXY(13,14); Write('C');
                   J := Status;
                   InputStr(J,1,48,20,0,'S','N','T','N',Tfn,Utx);
                   Status := UpCase(J[1]);
                   If J = ' ' then Status := 'A';
                   If (TC     <> #27) and
                      (Status <> 'A') and
                      (Status <> 'D') and
                      (Status <> 'C') then
                      begin
                        ErroMsg := 'Informe A,D ou C';
                        ErrorMessage;
                        K := K - 1;
                      end;
                   Op := 'A';
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(48,20); Case Status of
                                       'A' : Write('Ativa     ');
                                       'D' : Write('Desativada');
                                       'C' : Write('Cancelada ');
                                       else  Write(Status);
                                  end;
                 end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1
                          else K := 21;
      end;
    Until (K = 22) or (TC = #27);
    If Op = 'A' then Confirma;
  Until TC in [#27,'S'];
end;


Procedure IncluiConta;
begin
  With CCMember do
  begin
    Op         := 'I';
    Conta      := CCNo;
    Descricao  := '';
    Tipo       := ' ';
    Tempo      := 'T';
    Operacao   := 'P';
    Aceita     := 'S';
    Media      := 'N';
    Taxa       := 0;
    TxConv     := ' ';
    Custo      := 'N';
    RepousoM   := 'N';
    For I := 1 to 10 do Bases[I] := 'N';
    For I := 1 to 2 do begin
                         Resultado[I] := '';
                         Conteudo[I]  := ' ';
                         Operador[I]  := ' ';
                         Operando[I]  := '';
                         SubAdic[I]   := ' ';
                       end;
    Status     := 'A';
    EntryConta;
    Move(ScArray4[1],Mem[$B800:0000],4000);
    If TC = 'S' then
       begin
         D1 := 'S';
         ReadWrite(#04,'W','N',CCNumber);
         LoadTree1 ( Root1 );
         MasterMember.NContas := MasterMember.NContas + 1;
         ReadWrite(#00,'W','N',0);
         ShowHeap;
         Color(Red,Yellow);
         GotoXY(53,7); Write(MasterMember.NContas);
         Move(Mem[$B800:0000],ScArray4[1],4000);
       end
       else begin
              CCNumber := Limite;
              TC       := #13;
            end;
  end;
end;


Procedure MoveParaArray(L : Integer);
begin
  ReadWrite(#04,'R','N',CCNumber);
  KArray[L] := CCMember.Conta;
  RArray[L] := CCNumber;
  NArray[L] := CCMember.Descricao;
end;


Procedure ArrayParaArray(D,P : Integer);
begin
  KArray[P]  := KArray[D];
  RArray[P]  := RArray[D];
  NArray[P]  := NArray[D];
end;


Procedure ScrollConta;
Var
   ScArrayS       : Array [1..4000] of Char;
begin
  Move(Mem[$B800:0000],ScArrayS[1],4000);
  FootScroll;
  DrawBox(23,11,68,20,Sfn,'S');
  Color(Bfn,Btx);
  GotoXY(23,11); Write(' Cta Descri‡Æo                                ');
  Color(Sfn,Stx);
  CCAC    := CCNo;
  CCAN    := CCNumber;
  Tkb     := 'L';
  F       := 'N';
  Direcao := 'P';
  L       := 0;
  Sx      := 1;
  For I := 1 to 7 do begin
                       KArray[I] := '';
                       RArray[I] := 0;
                       NArray[I] := '';
                     end;
  RC := 'N';
  SearchAnt1 ( Root1 );
  If RC = 'N' then CCNo := '';
  Repeat
    RC := 'N';
    SearchPos1 ( Root1 );
    If RC = 'S' then
       begin
         L := L + 1;
         MoveParaArray(L);
       end
       else L := 7;
  Until L = 7;
  Repeat
    Window(23,13,69,20);
    For I := 1 to 7 do If KArray[I] <> '' then
                          begin
                            If I = Sx then Color(Tfn,Utx)
                                      else Color(Sfn,Stx);
                            GotoXY(1,I);
                            Writeln(' ',PushLeft(4,KArray[I]),
                                        PushLeft(41,NArray[I]));
                            Color(Sfn,Stx);
                          end;
    Window(1,1,80,25);
    Cont := ReadKey;
    If (Cont = #0 ) and
       (KeyPressed) then ScrollDir
                    else Direcao := 'N';
    Case Direcao of
         'A' : If F <> 'A' then
                  begin
                    If (Tkb = 'L') and
                       (Sx  >  1 ) then
                       begin
                         Sx := Sx - 1;
                         F  := 'N';
                       end
                       else begin
                              Case Tkb of
                                   'L' : N := 6;
                                   'P' : N := 0;
                              end;
                              Sx := 1;
                              Repeat
                                RC   := 'N';
                                CCNo := KArray[1];
                                SearchAnt1 ( Root1 );
                                If RC = 'S' then
                                   begin
                                     For I := 7 downto 2
                                     do ArrayParaArray((I - 1),I);
                                     MoveParaArray(1);
                                     F := 'N';
                                     N := N + 1;
                                   end
                                   else F := 'A';
                              Until (N = 7) or (RC = 'N');
                            end;
                  end;
         'P' : If F <> 'P' then
                  begin
                    If (Tkb = 'L') and
                       (Sx  <  7 ) then
                       begin
                         If KArray[Sx + 1] <> '' then
                            begin
                              Sx := Sx + 1;
                              F  := 'N';
                            end
                            else F := 'P';
                       end
                       else begin
                              Case Tkb of
                                   'L' : begin
                                           N := 6;
                                           R := 7;
                                         end;
                                   'P' : begin
                                           Sx := 1;
                                           N  := 0;
                                           R  := 7;
                                           For L := 1 to 7
                                           do If KArray[L] <> '' then R := L;
                                         end;
                              end;
                              Repeat
                                CCNo := KArray[R];
                                RC   := 'N';
                                SearchPos1 ( Root1 );
                                If RC = 'S' then
                                   begin
                                     For I := 2 to 7
                                     do ArrayParaArray(I,(I - 1));
                                     MoveParaArray(R);
                                     N := N + 1;
                                     F := 'N';
                                   end
                                   else F := 'P';
                              Until (N = 7) or (RC = 'N');
                              If Tkb = 'P' then F := 'N';
                            end;
                  end;
    end;
    If ((F <> 'N') or (N < 7)) and (Cont in [#72,#73,#80,#81]) then ScrollFim;
  Until Cont in [#13,#27];
  Move(ScArrayS[1],Mem[$B800:0000],4000);
  Color(Tfn,Utx);
  If Cont = #13 then
     begin
       CCAN := RArray[Sx];
       CCAC := KArray[Sx];
     end;
end;


