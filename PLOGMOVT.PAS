{$O+,F+}
Unit PlogMovt;

Interface

Uses Crt,Dos,PlogGlbs,PlogBasP,PlogTree,PlogMstr,PlogFunc;

   Procedure AtualizaMov;
   Procedure AlteracaoGrupo;
   Procedure Rateio;
   Procedure TransportaAcumulados;


Implementation

Var
  Funcao    : Str30;
  NuOS      : Str8;
  ObsOS     : Str20;

Procedure SomaHoraMinuto;
Var
   SomaH,SomaM    : Integer;
   ScArrayM       : Array [1..4000] of Char;
begin
  Move(Mem[$B800:0000],ScArrayM[1],4000);
  SomaH := YAddress^.AcMensalH;
  SomaM := YAddress^.AcMensalM;
  DrawBox(31,13,49,15,Sfn,'N');
  Color(Sfn,Stx);
  GotoXY(32,14); Write('Parcelas:');
  GotoXY(46,14); Write(':');
  Repeat
    Hora   := 0;
    Minuto := 0;
    Color(Tfn,Utx);
    GotoXY(12,14); Write(SomaH:4);
    GotoXY(17,14); Write(SomaM:2);
    Color(Sfn,Stx);
    GotoXY(42,14); Write('    ');
    GotoXY(47,14); Write('  ');
    J := '';
    InputStr(J,4,42,14,0,'S','N','T','N',Sfn,Stx);
    Val(J,Hora,E);
    GotoXY(42,14); Write(Hora:4);
    If TC <> #27 then
       begin
         J := '';
         InputStr(J,2,47,14,0,'S','N','T','N',Sfn,Stx);
         Val(J,Minuto,E);
         GotoXY(47,14); Write(Minuto:2);
       end;
    HoraMinuto;
    Hora   := SomaH + Hora;
    Minuto := SomaM + Minuto;
    HoraMinuto;
    SomaH := Hora;
    SomaM := Minuto;
  Until TC = #27;
  Move(ScArrayM[1],Mem[$B800:0000],4000);
  Hora   := SomaH;
  Minuto := SomaM;
  Color(Tfn,Utx);
  GotoXY(12,14); Write(Hora:4);
  GotoXY(17,14); Write(Minuto:2);
end;


Procedure EntryMov(X : Char);
begin
  Repeat
    TC := #13;
    K  := 0;
    Repeat
      Case K of
           0   : If X = 'O' then
                    begin
                      J := NuOS;
                      InputStr(J,8,12,14,0,'S','N','T','S',Tfn,Utx);
                      If TC <> #27 then NuOS := J;
                    end;
           1   : If X in ['H','T'] then
                    begin
                      Color(Blue,White);
                      GotoXY(1,24); Write(ConstStr(' ',80));
                      GotoXY(2,24); Write('F1');
                      Color(Blue,Cyan);
                      GotoXY(5,24); Write('para somar Horas/minutos.');
                      If Hora = 0 then J := ''
                                  else begin
                                         Str(Hora:4,J);
                                         J := LeftAdjust(J);
                                       end;
                      InputStr(J,4,12,14,0,'S','N','T','N',Tfn,Utx);
                      LimpaLn(24,Tfd);
                      Case TC of
                        #21 : begin
                                SomaHoraMinuto;
                                K  := 0;
                                TC := #13;
                              end;
                        #13 : begin
                                If UpCase(J[1]) in ['A','F','S','Z'] then
                                   begin
                                     OpH := UpCase(J[1]);
                                     J   := Copy(J,2,3);
                                   end
                                   else OpH := ' ';
                                Val(J,Hora,E);
                                GotoXY(12,14); Write(Hora:4);
                              end;
                      end;
                    end;
           2   : If X in ['H','T'] then
                    begin
                      If Minuto = 0 then J := ''
                                    else begin
                                           Str(Minuto:2,J);
                                           J := LeftAdjust(J);
                                         end;
                      InputStr(J,2,17,14,0,'S','N','T','N',Tfn,Utx);
                      Val(J,Minuto,E);
                      GotoXY(17,14); Write(QQStr(Minuto,2,'0'));
                      If ((Hora + Minuto) <> 0) and (TC = #13) then
                         begin
                           Valor := 0;
                           GotoXY(12,15); Write(ConstStr(' ',15));
                           K := 4;
                         end;
                    end;
           3   : If ((Hora + Minuto) = 0) and (X in ['V','O','T']) then
                    begin
                      If Valor = 0 then J := ''
                                   else begin
                                          Str(Valor:15:2,J);
                                          J := LeftAdjust(J);
                                        end;
                      InputStr(J,15,12,15,0,'S','N','T','N',Tfn,Utx);
                      If (UpCase(J[1]) = 'A') and (X <> 'O') then
                         begin
                           OpV := 'A';
                           J   := Copy(J,2,9);
                         end
                         else If (UpCase(J[1]) in ['S','Z']) and (X <> 'O') then
                                 begin
                                   OpV := UpCase(J[1]);
                                   J   := Copy(J,2,9);
                                 end
                                 else OpV := ' ';
                      Val(J,Valor,E);
                      GotoXY(12,15); Write(EditReal(Valor):15);
                    end;
           4   : If (OpX = 'N') and ((Hora + Minuto) = 0) and (Valor <> 0) and (X <> 'O') then
                    begin
                      If Parc = 0 then J := ''
                                  else begin
                                         Str(Parc:2,J);
                                         J := LeftAdjust(J);
                                       end;
                      InputStr(J,2,43,15,0,'S','N','N','N',Tfn,Utx);
                      Val(J,Parc,E);
                    end;
           5   : If OpX = 'S' then
                    begin
                      J := WData;
                      InputStr(J,10,12,16,0,'S','N','D','S',Tfn,Utx);
                      If TC <> #27 then WData := J;
                      If ((Hora + Minuto) <> 0) and (TC = #24) then K := 3;
                    end;
           6   : If (OpX = 'N') and (Valor = 0) and ((Hora + Minuto) = 0) and (X <> 'O') then
                    begin
                      If R1 = 0 then J := ''
                                else begin
                                       Str(R1:4:2,J);
                                       J := LeftAdjust(J);
                                     end;
                      InputStr(J,6,12,16,0,'S','N','$','N',Tfn,Utx);
                      Val(J,R1,E);
                    end;
           7   : If (OpX = 'N') and (Valor = 0) and ((Hora + Minuto) = 0) and (X <> 'O') then
                    begin
                      J := QB;
                      InputStr(J,1,43,16,0,'S','N','T','N',Tfn,Utx);
                      If TC <> #27 then
                         begin
                           If J = '' then J := ' ';
                           If UpCase(J[1]) in ['0','6','7','8','9',' ','M','S']
                              then QB := UpCase(J[1])
                              else begin
                                     ErroMsg := 'Informe 0,6,7,8,9,M ou S';
                                     ErrorMessage;
                                     K := K - 1;
                                   end;
                         end;
                    end;
           8   : If X = 'O' then
                    begin
                      J := ObsOS;
                      InputStr(J,20,12,16,0,'S','N','T','S',Tfn,Utx);
                      If TC <> #27 then ObsOS := J;
                    end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 0 then K := K - 1;
      end;
    Until (K = 9) or (TC = #27);
    If TC <> #27 then Confirma;
  Until TC in ['S',#27];
end;


Procedure EntryMovGrupo(Y : Integer;X : Char);
begin
  Repeat
    K := 0;
    Repeat
      Case K of
           0   : begin
                   Color(Blue,White);
                   GotoXY(1,24); Write(ConstStr(' ',80));
                   GotoXY(2,24); Write('F1');
                   Color(Blue,Cyan);
                   GotoXY(5,24); Write('para pesquisar Sindicatos');
                   J := SSNo;
                   InputStr(J,2,12,Y,0,'S','N','T','N',Tfn,Utx);
                   SSNo := J;
                   If TC = #21 then
                      begin
                        SSAC := SSNo;
                        ScrollSind;
                        SSNo := SSAC;
                      end
                      else If (TC   <> #27) and
                              (SSNo <> '' ) then
                              begin
                                SearchTree2 ( Root2 );
                                If RC = 'S' then
                                   With SSMember do
                                   begin
                                     ReadWrite(#07,'R','N',SSNumber);
                                     GotoXY(12,Y); Write(' ':40);
                                     GotoXY(12,Y); Write(SSNo,' ',Copy(Descricao,1,35));
                                   end
                                   else begin
                                          ErroMsg := 'Sindicato n∆o Existe';
                                          ErrorMessage;
                                          K := K - 1;
                                        end;
                              end
                              else If TC <> #27 then
                                      begin
                                        GotoXY(12,Y); Write(' ':40);
                                        GotoXY(12,Y); Write('** Todos')
                                      end;;
                   LimpaLn(24,Tfd);
                 end;
           1   : begin
                   Color(Blue,White);
                   GotoXY(1,24); Write(ConstStr(' ',80));
                   GotoXY(2,24); Write('F1');
                   Color(Blue,Cyan);
                   GotoXY(5,24); Write('para pesquisar Deptos');
                   J := DDNo;
                   InputStr(J,10,12,Y+1,0,'S','N','T','N',Tfn,Utx);
                   DDNo := J;
                   If TC = #21 then
                      begin
                        DDAC := DDNo;
                        ScrollDept('N');
                        DDNo := DDAC;
                      end
                      else If (TC   <> #27) and
                              (DDNo <> '' ) then
                              begin
                                SearchTree3 ( Root3 );
                                If RC = 'S' then
                                   With DDMember do
                                   begin
                                     ReadWrite(#05,'R','N',DDNumber);
                                     GotoXY(12,Y+1); Write(' ':40);
                                     GotoXY(12,Y+1); Write(DDNo,' ',Copy(Descricao,1,30));
                                   end
                                   else begin
                                          ErroMsg := 'Departamento n∆o Existe';
                                          ErrorMessage;
                                          K := K - 1;
                                        end;
                              end
                              else If TC <> #27 then
                                      begin
                                        GotoXY(12,Y+1); Write(' ':40);
                                        GotoXY(12,Y+1); Write('** Todos');
                                      end;
                   LimpaLn(24,Tfd);
                 end;
           2   : If (CCNo <> '*') and (X = 'S') then
                    begin
                      Move(Mem[$B800:0000],ScArray5[1],4000);
                      DrawBox(35,09,55,19,Red,'S');
                      Color(Red,Cyan);
                      GotoXY(35,09); Write('   cumulado anual   ');
                      GotoXY(35,10); Write('   ias de Sal†rio   ');
                      GotoXY(35,11); Write('   oras de Sal†rio  ');
                      GotoXY(35,12); Write('   istema (Zerar)   ');
                      GotoXY(35,13); Write('   alor (Substituir)');
                      GotoXY(35,14); Write('   erar (Foráar 0)  ');
                      GotoXY(35,15); Write('  % sobre o Sal†rio ');
                      GotoXY(35,16); Write('  + somar a         ');
                      GotoXY(35,17); Write('  - diminuir de     ');
                      GotoXY(35,18); Write('  * multiplicar por ');
                      GotoXY(35,19); Write('  / dividir por     ');
                      Color(Red,White);
                      GotoXY(37,09); Write('A');
                      GotoXY(37,10); Write('D');
                      GotoXY(37,11); Write('H');
                      GotoXY(37,12); Write('S');
                      GotoXY(37,13); Write('V');
                      GotoXY(37,14); Write('Z');
                      GotoXY(37,15); Write('%');
                      GotoXY(37,16); Write('+');
                      GotoXY(37,17); Write('-');
                      GotoXY(37,18); Write('*');
                      GotoXY(37,19); Write('/');
                      Color(Blue,Cyan);
                      GotoXY(1,24); Write(ConstStr(' ',80));
                      GotoXY(2,24);
                      Write('Entre com uma letra ou um s°mbolo seguido do valor (Ex.        ou       )');
                      Color(Blue,White);
                      GotoXY(58,24); Write('V');
                      GotoXY(68,24); Write('%');
                      Color(Blue,Yellow);
                      GotoXY(59,24); Write('12.74');
                      GotoXY(69,24); Write('11.04');
                      If Valor = 0 then J := ''
                                   else begin
                                          Str(Valor:10:2,J);
                                          J := LeftAdjust(J);
                                        end;
                      InputStr(J,10,12,Y+2,0,'S','N','T','N',Tfn,Utx);
                      Move(ScArray5[1],Mem[$B800:0000],4000);
                      If TC <> #27 then
                         begin
                           If UpCase(J[1]) in ['A','D','H','S','V','Z','%','+','-','*','/'] then
                              begin
                                OpV := UpCase(J[1]);
                                J   := Copy(J,2,9);
                                Val(J,Valor,E);
                                GotoXY(12,Y+2); Write(Valor:10:2);
                                GotoXY(24,Y+2);
                                Case OpV of
                                     'A' : Write('Substituir no acumulado anual   ');
                                     'D' : Write('Substituir por dias de Sal†rio  ');
                                     'H' : Write('Substituir por horas de Sal†rio ');
                                     'S' : Write('Marcar a Conta com "S" (sistema)');
                                     'V' : Write('Substituir pelo Valor           ');
                                     'Z' : Write('Zerar marcando a Conta com "U"  ');
                                     '%' : Write('Substituir por % sobre o Sal†rio');
                                     '+' : Write('Somar o valor a Conta           ');
                                     '-' : Write('Subtrair o valor da Conta       ');
                                     '*' : Write('Multiplicar o valor pela Conta  ');
                                     '/' : Write('Dividir o valor pela Conta      ');
                                end;
                              end
                              else begin
                                     ErroMsg := 'Informe A,D,H,S,V,Z,%,+,-,* ou /';
                                     ErrorMessage;
                                     K := K - 1;
                                   end;
                         end;
                    end
                    else OpV := 'T';
           3   : If (CCNo <> '*') and (X = 'S') then
                    begin
                      If Parc = 0 then J := ''
                                  else begin
                                         Str(Parc:2,J);
                                         J := LeftAdjust(J);
                                       end;
                      InputStr(J,2,12,Y+3,0,'S','N','N','N',Tfn,Utx);
                      Val(J,Parc,E);
                    end;
           4   : If (CCNo <> '*') and (X = 'S') then
                    begin
                      J := Op;
                      InputStr(J,1,12,Y+5,0,'S','N','T','N',Tfn,Utx);
                      If J[1] = ' ' then J := 'N';
                      Op := UpCase(J[1]);
                      GotoXY(12,Y+5);
                      Case Op of
                           'N' : Write('N∆o (S¢ para quem tem a conta)');
                           'S' : Write('Sim (Para todos)              ');
                      end;
                    end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 5) or (TC = #27);
    If TC <> #27 then Confirma;
  Until TC in ['S',#27];
end;


Procedure HistMov;
begin
  HHNo := EENo + '#' + Copy(WData,7,4) + Copy(WData,4,2) + Copy(WData,1,2) +
                 '#' + HHMember.Tipo;
  SearchTree10 ( Root10 );
  If RC = 'S' then
     begin
       ErroMsg := 'N∆o pode haver duas transaáîes iguais ';
       ErrorMessage;
     end
     else With HHMember do
          begin
            D3        := 'S';
            HHNumber  := FileSize(HHFile);
            Empregado := EENo;
            OrigData  := WData;
            Data      := Copy(WData,7,4) + Copy(WData,4,2) + Copy(WData,1,2);
            Salario   := 0;
            ReadWrite(#10,'W','N',HHNumber);
            LoadTree10 ( Root10 );
          end;
end;


Procedure DisplayMov;
begin
  YYNo := CCNo;
  SearchTreeY ( RootY );
  If RC = 'N' then
     begin
       LoadTreeY ( RootY );
       YAddress^.Origem := 'U';
     end;
  Color(Bfn,Btx);
  GotoXY(17,18); Write(' Acumulados          Mensal         Anual ');
  Color(Sfn,Stx);
  GotoXY(17,19); Write(' Horas                                    ');
  GotoXY(17,20); Write(' Valor                                    ');
  GotoXY(37,19); Write(YAddress^.AcMensalH:4,':',QQStr(YAddress^.AcMensalM,2,'0'));
  GotoXY(51,19); Write(YAddress^.AcAnualH:4,':',QQStr(YAddress^.AcAnualM,2,'0'));
  GotoXY(32,20); Write(EditReal(YAddress^.AcMensalV):12);
  GotoXY(45,20); Write(EditReal(YAddress^.AcAnualV):13);
  Color(Tfn,Utx);
  If YAddress^.BaseUsr <> ' ' then
     begin
       GotoXY(48,16); Write(YAddress^.PerctUsr:4:2);
       GotoXY(56,16); Write(YAddress^.BaseUsr);
     end;
  QB := YAddress^.BaseUsr;
  R1 := YAddress^.PerctUsr;
end;


Procedure AtualizaVHMov;
begin
  YAddress^.Origem := 'U';
  Case OpV of
       'A' : YAddress^.AcAnualV  := Valor;
       'Z' : YAddress^.AcMensalV := 0;
       'S' : begin
               YAddress^.AcMensalV := 0;
               YAddress^.Origem    := 'S';
             end;
       else YAddress^.AcMensalV := YAddress^.AcMensalV + Valor;
  end;
  Case OpH of
       'A' : begin
               YAddress^.AcAnualH := Hora;
               YAddress^.AcAnualM := Minuto;
             end;
       'Z' : begin
               YAddress^.AcMensalH := 0;
               YAddress^.AcMensalM := 0;
             end;
       'S' : begin
               YAddress^.AcMensalH := 0;
               YAddress^.AcMensalM := 0;
               YAddress^.Origem    := 'S';
             end;
       else begin
              HoraMinuto;
              Hora    := YAddress^.AcMensalH + Hora;
              Minuto  := YAddress^.AcMensalM + Minuto;
              HoraMinuto;
              YAddress^.AcMensalH := Hora;
              YAddress^.AcMensalM := Minuto;
            end;
  end;
  YAddress^.Parcelas := Parc;
  If (Hora   <> 0) or
     (Minuto <> 0) or
     (Valor  <> 0) then
     begin
       YAddress^.BaseUsr  := ' ';
       YAddress^.PerctUsr := 0;
     end
     else begin
            YAddress^.BaseUsr  := QB;
            YAddress^.PerctUsr := R1;
          end;
end;


Procedure AtualizaVGrupo;
begin
  YAddress^.Origem := 'U';
  Case UpCase(OpV) of
       'A' : begin
               YAddress^.AcAnualV := Valor;
               YAddress^.Origem   := 'S';
             end;
       'D','H' : begin
                   If EEMember.Tipo = 'H'
                      then SalBase := EEMember.Salario * EEMember.HNormais
                      else SalBase := EEMember.Salario;
                   If UpCase(OpV) = 'D'
                      then YAddress^.AcMensalV := (SalBase / 30) * Valor
                      else YAddress^.AcMensalV := ValorHora1 * Valor;
             end;
       'V' : YAddress^.AcMensalV := Valor;
       'S' : begin
               YAddress^.AcMensalV := 0;
               YAddress^.AcMensalH := 0;
               YAddress^.AcMensalM := 0;
               YAddress^.Origem    := 'S';
             end;
       'T' : begin
               YAddress^.AcAnualV := 0;
               YAddress^.AcAnualH := 0;
               YAddress^.AcAnualM := 0;
               YAddress^.Origem   := 'S';
             end;
       'Z' : begin
               YAddress^.AcMensalV := 0;
               YAddress^.AcMensalH := 0;
               YAddress^.AcMensalM := 0;
             end;
       '%' : begin
               If EEMember.Tipo = 'H'
                  then SalBase := EEMember.Salario * EEMember.HNormais
                  else SalBase := EEMember.Salario;
               YAddress^.AcMensalV := (SalBase * Valor) / 100;
             end;
       '+' : YAddress^.AcMensalV := YAddress^.AcMensalV + Valor;
       '-' : YAddress^.AcMensalV := YAddress^.AcMensalV - Valor;
       '*' : YAddress^.AcMensalV := YAddress^.AcMensalV * Valor;
       '/' : If Valor > 0 then YAddress^.AcMensalV := YAddress^.AcMensalV / Valor;
  end;
  YAddress^.Parcelas := Parc;
end;


Procedure RecebeConta(Y : Integer;X : Char);
begin
  Color(Blue,White);
  GotoXY(1,24); Write(ConstStr(' ',80));
  GotoXY(2,24); Write('F1');
  Color(Blue,Cyan);
  GotoXY(5,24); Write('para pesquisar Contas (Proventos e Descontos)');
  J := '';
  InputStr(J,3,12,Y,0,'S','N','T','N',Tfn,Utx);
  LimpaLn(24,Tfd);
  If TC = #21 then
     begin
       CCNo := '';
       CCAC := '';
       ScrollConta;
       If CCAC <> '' then
          begin
            CCNo := CCAC;
            SearchTree1 ( Root1 );
            If RC = 'N' then CCNumber := Limite;
          end
          else CCNumber := Limite;
     end
     else If TC = #27 then CCNumber := Limite
                      else If (TC =  #13) and
                              (J  <> '' ) and
                              (J  <> '*') then
                              begin
                                CCNo := J;
                                SearchTree1 ( Root1 );
                                If RC = 'N' then
                                   begin
                                     ErroMsg := 'Conta n∆o Existe';
                                     ErrorMessage;
                                     CCNumber := Limite;
                                   end;
                              end
                              else If (TC <> #27) and
                                      (X   = 'S') and
                                      (J   = '*') then CCNo := '*'
                                                  else CCNumber := Limite;
end;


Procedure AtualizaMovN;
begin
  Repeat
    RecebeConta(12,'N');
    If CCNumber <> Limite then
       With CCMember do
       begin
         ReadWrite(#04,'R','N',CCNumber);
         If (RW     = 'S') and
            (Status = 'A') and
            (Aceita = 'S') then
            begin
              Color(Tfn,Utx);
              GotoXY(12,12); Write(CCNo,' ',Descricao);
              Color(Tfn,Ttx);
              GotoXY(04,14); Write('Horas.:');
              GotoXY(16,14); Write(':');
              GotoXY(04,15); Write('Valor.:');
              GotoXY(35,15); Write('Parcel:');
              GotoXY(04,16); Write('Perct.:');
              GotoXY(35,16); Write('Base..:');
              DisplayMov;
              Hora   := 0;
              Minuto := 0;
              Valor  := 0;
              Parc   := 0;
              OpH    := ' ';
              OpV    := ' ';
              EntryMov('T');
              If TC = 'S' then AtualizaVHMov;
              TC := #13;
            end
            else begin
                   ErroMsg := 'Conta n∆o pode Receber Lanáamento';
                   ErrorMessage;
                 end;
       end;
    Color(Tfn,Ttx);
    GotoXY(12,12);  Write(' ':45);
    GotoXY(04,14);  Write(' ':55);
    GotoXY(04,15);  Write(' ':55);
    GotoXY(04,16);  Write(' ':55);
    GotoXY(04,17);  Write(' ':55);
    GotoXY(04,18);  Write(' ':55);
    GotoXY(04,19);  Write(' ':55);
    GotoXY(04,20);  Write(' ':55);
  Until TC = #27;
end;


Procedure AtualizaMovOS;
begin
  Repeat
    RecebeConta(12,'N');
    If TC <> #27 then
       begin
         Repeat
           If CCNumber <> Limite then
              With CCMember do
              begin
                ReadWrite(#04,'R','N',CCNumber);
                If (RW     = 'S') and
                   (Status = 'A') then
                   begin
                     Color(Tfn,Utx);
                     GotoXY(12,12); Write(CCNo,' ',Descricao);
                     Color(Tfn,Ttx);
                     GotoXY(04,14); Write('N£mero:');
                     GotoXY(04,15); Write('Valor.:');
                     GotoXY(04,16); Write('Obs...:');
                     DisplayMov;
                     NuOS   := '';
                     ObsOS  := '';
                     Valor  := 0;
                     OpH    := ' ';
                     OpV    := ' ';
                     EntryMov('O');
                     If TC = 'S' then
                        begin
                          AtualizaVHMov;

                          OONo     := EENo + '#' + NuOS;
                          OONumber := FileSize(OOFile);
                          LoadTree8 ( Root8 );
                          OOMember.Empregado := EENo;
                          OOMember.NumeroOS  := NuOs;
                          OOMember.ValorOS   := Valor;
                          OOMember.ContaOS   := CCNo;
                          OOMember.DescricaoOS := ObsOS;
                          ReadWrite(#19,'W','N',OONumber);
                          TC := #13;
                        end;
                   end;
              end;
           Color(Tfn,Ttx);
           GotoXY(04,14);  Write(' ':55);
           GotoXY(04,15);  Write(' ':55);
           GotoXY(04,16);  Write(' ':55);
           GotoXY(04,17);  Write(' ':55);
           GotoXY(04,18);  Write(' ':55);
           GotoXY(04,19);  Write(' ':55);
           GotoXY(04,20);  Write(' ':55);
         Until TC = #27;
         GotoXY(12,12);  Write(' ':45);
         TC := #00;
       end;
  Until TC = #27;
  D3 := 'S';
end;



Procedure AtualizaMovF;
begin
  If CCNumber <> Limite then
     With CCMember do
     begin
       Color(Tfn,Utx);
       GotoXY(12,12); Write(CCNo);
       ReadWrite(#04,'R','N',CCNumber);
       If (RW     = 'S') and
          (Status = 'A') and
          (Aceita = 'S') then
          begin
            Color(Tfn,Utx);
            GotoXY(12,12); Write(PushLeft(4,CCNo),
                                 PushLeft(31,Descricao));
            Color(Tfn,Ttx);
            Case EEMember.Tipo of
                 'H': begin
                         GotoXY(04,14); Write('Horas.:');
                         GotoXY(16,14); Write(':');
                       end;
                 'M' : begin
                         GotoXY(04,15); Write('Valor.:');
                       end;
            end;
            GotoXY(04,16); Write('Data..:');
            DisplayMov;
            Valor  := 0;
            Hora   := 0;
            Minuto := 0;
            Parc   := 0;
            R1     := 0;
            QB     := ' ';
            Case EEMember.Tipo of
                 'H' : begin
                         Hora   := CMstMember.FaltaH + CMstMember.RepousoH;
                         Minuto := CMstMember.FaltaM + CMstMember.RepousoM;
                         If Minuto > 60 then
                            begin
                              M      := Trunc(Minuto / 60);
                              Minuto := Minuto - (M * 60);
                              Hora   := Hora   + (M);
                            end
                            else If Minuto = 60 then
                                    begin
                                      Minuto := 0;
                                      Hora   := Hora + 1;
                                    end;
                         Color(Bfn,Btx);
                         GotoXY(39,13);  Write(' Expediente:        ');
                         GotoXY(39,14);  Write(' Repouso...:        ');
                         GotoXY(52,13); Write(CMstMember.FaltaH:3,':',QQStr(CMstMember.FaltaM,2,'0'));
                         GotoXY(52,14); Write(CMstMember.RepousoH:3,':',QQStr(CMstMember.RepousoM,2,'0'));
                         Color(Tfn,Utx);
                         GotoXY(12,14); Write(Hora:4);
                         GotoXY(17,14); Write(QQStr(Minuto,2,'0'));
                         EntryMov('H');
                       end;
                 else  begin
                         Color(Bfn,Btx);
                         GotoXY(39,13); Write(' Sal†rio:           ');
                         GotoXY(48,13); Write(EditReal(EEMember.Salario):10);
                         Color(Tfn,Utx);
                         Valor := EEMember.Salario / 30;
                         EntryMov('V');
                       end;
            end;
            If TC = 'S' then
               begin
                 OpH := ' ';
                 OpV := ' ';
                 HistMov;
                 If RC = 'N' then
                    begin
                      AtualizaVHMov;
                      EEMember.FaltasNJ := EEMember.FaltasNJ + 1;
                      ReadWrite(#08,'W','N',EENumber);
                    end;
               end;
          end
          else begin
                 ErroMsg := 'Conta n∆o pode Receber Lanáamento';
                 ErrorMessage;
               end;
     end;
end;


Procedure AtualizaMovAS;
begin
  If CCNumber <> Limite then
     With CCMember do
     begin
       Color(Tfn,Utx);
       GotoXY(12,12); Write(CCNo);
       ReadWrite(#04,'R','N',CCNumber);
       If (RW     = 'S') and
          (Status = 'A') and
          (Aceita = 'S') then
          begin
            Color(Tfn,Utx);
            GotoXY(12,12); Write(PushLeft(4,CCNo),
                                 PushLeft(31,Descricao));
            Color(Tfn,Ttx);
            GotoXY(4,14);  Write('Horas.:');
            GotoXY(16,14); Write(':');
            GotoXY(4,15);  Write('Valor.:');
            GotoXY(4,16);  Write('Data..:');
            DisplayMov;
            Hora   := 0;
            Minuto := 0;
            Valor  := 0;
            Parc   := 0;
            R1     := 0;
            QB     := ' ';
            EntryMov('H');
            If TC = 'S' then
               begin
                 OpH := ' ';
                 OpV := ' ';
                 HistMov;
                 If RC = 'N' then AtualizaVHMov;
               end
          end
          else begin
                 ErroMsg := 'Conta n∆o pode Receber Lanáamento';
                 ErrorMessage;
               end;
     end;
end;


Procedure Recebe;
begin
  Move(ScArray4[1],Mem[$B800:0000],4000);
  Color(Sfn,Stx);
  GotoXY(35,08); Write(PushLeft(26,Funcao));
  Color(Tfn,Ttx);
  GotoXY(04,09); Write('Matr°c:');
  RecebeCodigo(9,'C','N');
  If EENumber <> Limite then
     begin
       ReadWrite(#08,'R','N',EENumber);
       Color(Tfn,Ttx);
       GotoXY(04,10); Write('Nome..:');
       Color(Tfn,Utx);
       GotoXY(12,09); Write(PushLeft(9,EEMember.Matricula));
       GotoXY(12,10); Write(PushLeft(41,EEMember.Nome));
       Move(Mem[$B800:0000],ScArray5[1],4000);
       LoadMVDsk(#11);
     end;
end;


Procedure AtualizaMov;
begin
  EENo  := '';
  WData := XDia + '/' + XMes + '/' + XAno;
  Color(Tfn,Utx);
  TabI[1]  := ' Movimento Normal   ';
  TabI[2]  := ' Falta ao Trabalho  ';
  TabI[3]  := ' Atrasos na Chegada ';
  TabI[4]  := ' Sa°da Antecipada   ';
  TabI[5]  := ' Ordens de serviáo  ';
  TabI[6]  := ' Encerrar a funá∆o  ';
  TabX[1]  := 10;
  TabX[2]  := 10;
  TabX[3]  := 10;
  TabX[4]  := 10;
  TabX[5]  := 10;
  TabX[6]  := 10;
  TabY[1]  := 11;
  TabY[2]  := 12;
  TabY[3]  := 13;
  TabY[4]  := 14;
  TabY[5]  := 15;
  TabY[6]  := 16;
  DrawBox(9,10,30,17,Sfn,'S');
  YY := 1;
  MenuAuxiliar(6,Tfn,Utx,Sfn,Stx);
  Repeat
    Resp := ReadKey;
    If (Resp = #0 ) and
       (KeyPressed) then
       begin
         Resp := ReadKey;
         Case Resp of
              #72 : begin
                      YY := YY - 1;
                      If YY < 1 then YY := 6;
                    end;
              #80 : begin
                      YY := YY + 1;
                      If YY > 6 then YY := 1;
                    end;
         end;
         MenuAuxiliar(6,Tfn,Utx,Sfn,Stx);
       end
       else If Resp = #13 then
               begin
                 Move(Mem[$B800:0000],ScArray6[1],4000);
                 Case YY of
                      1   : begin
                              Funcao := ' Movimento Normal';
                              Repeat
                                Recebe;
                                If EENumber <> Limite then
                                   begin
                                     Color(Tfn,Ttx);
                                     GotoXY(4,12);  Write('Conta.:');
                                     Color(Tfn,Utx);
                                     OpX := 'N';
                                     AtualizaMovN;
                                     UnLoadMVDsk;
                                     TC := #13;
                                   end;
                              Until TC = #27;
                            end;
                      2   : begin
                              Funcao := ' Falta ao Trabalho';
                              Repeat
                                Recebe;
                                If EENumber <> Limite then
                                   begin
                                     CCNo := CMstMember.ContaF;
                                     SearchTree1 ( Root1 );
                                     If RC = 'S' then
                                        begin
                                          HHMember.Tipo   := 'F';
                                          HHMember.Motivo := 'Falta ao Trabalho';
                                          Color(Tfn,Ttx);
                                          GotoXY(4,12);  Write('Conta.:');
                                          Color(Tfn,Utx);
                                          OpX := 'S';
                                          AtualizaMovF;
                                          UnLoadMVDsk;
                                          TC := #13;
                                        end
                                        else begin
                                               ErroMsg := 'Conta n∆o Existe';
                                               ErrorMessage;
                                               TC := #27;
                                             end;
                                   end;
                              Until TC = #27;
                            end;
                      3   : begin
                              Funcao := ' Atraso na Chegada';
                              Repeat
                                Recebe;
                                If EENumber <> Limite then
                                   begin
                                     CCNo := CMstMember.ContaA;
                                     SearchTree1 ( Root1 );
                                     If RC = 'S' then
                                        begin
                                          HHMember.Tipo   := 'A';
                                          HHMember.Motivo := 'Atraso na Chegada';
                                          Color(Tfn,Ttx);
                                          GotoXY(4,12);  Write('Conta.:');
                                          Color(Tfn,Utx);
                                          OpX := 'S';
                                          AtualizaMovAS;
                                          UnLoadMVDsk;
                                          TC := #13;
                                        end
                                        else begin
                                               ErroMsg := 'Conta n∆o Existe';
                                               ErrorMessage;
                                               TC := #27;
                                             end;
                                   end;
                              Until TC = #27;
                            end;
                      4   : begin
                              Funcao := ' Sa°da Antecipada';
                              Repeat
                                Recebe;
                                If EENumber <> Limite then
                                   begin
                                     CCNo := CMstMember.ContaS;
                                     SearchTree1 ( Root1 );
                                     If RC = 'S' then
                                        begin
                                          HHMember.Tipo   := 'C';
                                          HHMember.Motivo := 'Sa°da Antecipada';
                                          Color(Tfn,Ttx);
                                          GotoXY(4,12);  Write('Conta.:');
                                          Color(Tfn,Utx);
                                          OpX := 'S';
                                          AtualizaMovAS;
                                          UnLoadMVDsk;
                                          TC := #13;
                                        end
                                        else begin
                                               ErroMsg := 'Conta n∆o Existe';
                                               ErrorMessage;
                                               TC := #27;
                                             end;
                                   end;
                              Until TC = #27;
                            end;
                      5   : begin
                              Funcao := ' Ordens de serviáo';
                              Repeat
                                Recebe;
                                If EENumber <> Limite then
                                   begin
                                     Color(Tfn,Ttx);
                                     GotoXY(4,12);  Write('Conta.:');
                                     Color(Tfn,Utx);
                                     OpX := 'N';
                                     AtualizaMovOS;
                                     UnLoadMVDsk;
                                     TC := #13;
                                   end;
                              Until TC = #27;
                            end;
                      6   : Resp := #27;
                 end;
                 Move(ScArray6[1],Mem[$B800:0000],4000);
               end
               else Resp := #13;
  Until Resp = #27;
  Resp := #00;
  TC   := #13;
end;


Procedure AlteracaoGrupo;
begin
  Repeat
    RecebeConta(12,'S');
    If ((CCNumber <> Limite) or (CCNo = '*')) and (TC <> #27) then
       With CCMember do
       begin
         Color(Tfn,Utx);
         If CCNo <> '*' then ReadWrite(#04,'R','N',CCNumber);
         If ((RW = 'S') and (Status = 'A') and (Aceita = 'S')) or
            (CCNo = '*') then
            begin
              GotoXY(12,12);
              If CCNo <> '*' then Write(CCNo,' ',Descricao)
                             else Write('Zerar acumulado anual de todas as Contas');
              Color(Tfn,Ttx);
              GotoXY(04,13); Write('Sindic:');
              GotoXY(04,14); Write('Depto.:');
              If CCNo <> '*' then
                 begin
                   GotoXY(04,15); Write('Valor.:');
                   GotoXY(04,16); Write('Parcel:');
                   GotoXY(04,18); Write('Todos.:');
                 end;
              Valor := 0;
              SSNo  := '';
              DDNo  := '';
              Parc  := 0;
              R1    := 0;
              Op    := 'N';
              OpV   := ' ';
              EntryMovGrupo(13,'S');
              If TC = 'S' then
                 begin
                   DrawBox(27,10,69,19,Sfn,'S');
                   Color(Bfn,Btx);
                   GotoXY(27,10); Write(' Empregados Selecionados para Alteraá∆o    ');
                   Color(Sfn,Stx);
                   Window(28,12,69,19);
                   GotoXY(1,8);
                   LiberaMVdsk;
                   NCont := 0;
                   EENo  := '';
                   Repeat
                     RC := 'N';
                     SearchPos5 ( Root5 );
                     If RC = 'S' then
                        begin
                          ReadWrite(#08,'R','N',EENumber);
                          If ((SSNo = '') or (SSNo = EEMember.Sindicato)) and
                             ((DDNo = '') or (DDNo = EEMember.Depto    )) and
                             (EEMember.Status  in ['A','E','C','F','L'] ) then
                             begin
                               Writeln(EEMember.Nome);
                               NCont := NCont + 1;
                               LoadMVDsk(#11);
                               If CCNo = '*' then YYNo := ''
                                             else YYNo := CCNo;
                               Repeat
                                 RC := 'N';
                                 If CCNo = '*' then SearchPosY ( RootY )
                                               else SearchTreeY ( RootY );
                                 Case RC of
                                    'N' : If CCNo <> '*' then
                                             begin
                                               If Op = 'S' then
                                                  begin
                                                    LoadTreeY ( RootY );
                                                    YAddress^.Origem := 'U';
                                                    AtualizaVGrupo;
                                                    UnLoadMVDsk;
                                                  end
                                                  else LiberaMVDsk;
                                               RC := 'N';
                                             end;
                                    'S' : begin
                                            AtualizaVGrupo;
                                            If CCNo <> '*' then
                                               begin
                                                 UnLoadMVDsk;
                                                 LiberaMVDsk;
                                                 RC := 'N';
                                               end;
                                          end;
                                 end;
                                 If YYNo = CCNo then RC := 'N';
                               Until RC = 'N';
                               If CCNo = '*' then UnLoadMVDsk;
                               RC := 'S';
                             end;
                        end;
                   Until RC = 'N';
                   Window(1,1,80,25);
                   Color(Blue,Cyan);
                   GotoXY(1,23);  Write(ConstStr(' ',80));
                   GotoXY(2,23);  Write('Total de Empregados Afetados:  ');
                   Color(Blue,White);
                   GotoXY(32,23); Write(NCont:5);
                   TeclaReturn;
                 end;
              TC := #13;
            end
            else begin
                   ErroMsg := 'Conta n∆o pode Receber Lanáamento';
                   ErrorMessage;
                 end;
       end;
    Move(ScArray4[1],Mem[$B800:0000],4000);
  Until TC = #27;
end;


Procedure Rateio;
Var
  ValorTotal,TotalPontos,Parcela  : Real;
begin
  Repeat
    DrawBox(4,17,49,19,Red,'S');
    Color(Red,Cyan);
    GotoXY(4,17); Write(' O valor informado ser† rateado proporcional- ');
    GotoXY(4,18); Write(' mente ao n£mero de pontos encontrado em cada ');
    GotoXY(4,19); Write(' Empregado, lanáando o resultado em conta.    ');
    Color(Tfn,Utx);
    RecebeConta(10,'S');
    If ((CCNumber <> Limite) or (CCNo = '*')) and (TC <> #27) then
       With CCMember do
       begin
         Color(Tfn,Utx);
         If CCNo <> '*' then ReadWrite(#04,'R','N',CCNumber);
         If (RW = 'S') and (Status = 'A') and (Aceita = 'S') and (CCNo <> '*') then
            begin
              GotoXY(12,10); Write(CCNo,' ',Descricao);
              Color(Tfn,Ttx);
              GotoXY(04,11); Write('Sindic:');
              GotoXY(04,12); Write('Depto.:');
              Valor := 0;
              SSNo  := '';
              DDNo  := '';
              Parc  := 0;
              R1    := 0;
              Op    := 'N';
              OpV   := ' ';
              EntryMovGrupo(11,'N');
              If TC = 'S' then
                 begin
                   Color(Tfn,Ttx);
                   GotoXY(04,13); Write('Valor.:');
                   ValorTotal := 0;
                   Repeat
                     If ValorTotal = 0 then J := ''
                        else begin
                               Str(ValorTotal:15:2,J);
                               J := LeftAdjust(J);
                             end;
                     InputStr(J,15,12,13,0,'S','N','$','N',Tfn,Utx);
                     Val(J,ValorTotal,E);
                     GotoXY(12,13); Write(EditReal(ValorTotal):15);
                     If TC <> #27 then
                        begin
                          If ValorTotal = 0 then
                             begin
                               ErroMsg := 'Informe o Valor a ser Rateado';
                               ErrorMessage;
                             end
                             else Confirma;
                        end;
                   Until TC in [#27,'S'];
                   If TC = 'S' then
                      begin
                        Color(Tfn,Ttx);
                        GotoXY(04,14); Write('Pontos:');
                        Color(Blue,Cyan);
                        GotoXY(1,23);  Write(ConstStr(' ',80));
                        GotoXY(2,23);  Write('Contagem dos Pontos para Rateio');
                        Color(Tfn,Utx);
                        TotalPontos := 0;
                        EENo  := '';
                        Repeat
                          RC := 'N';
                          SearchPos5 ( Root5 );
                          If RC = 'S' then
                             begin
                               ReadWrite(#08,'R','N',EENumber);
                               If ((SSNo = '') or (SSNo = EEMember.Sindicato)) and
                                  ((DDNo = '') or (DDNo = EEMember.Depto    )) and
                                  (EEMember.Status  in ['A','C','E']         )
                                  then TotalPontos := TotalPontos + EEMember.Pontos;
                               GotoXY(12,14); Write(TotalPontos:10:0);
                             end;
                        Until RC = 'N';
                        LimpaLn(23,Tfd);
                        If TotalPontos > 0 then Confirma
                           else begin
                                  ErroMsg := 'N∆o h† pontuaá∆o nos Empregados';
                                  ErrorMessage;
                                  TC := 'N';
                                end;
                        If TC = 'S' then
                           begin
                             Parcela := ValorTotal / TotalPontos;
                             DrawBox(27,10,69,19,Sfn,'S');
                             Color(Bfn,Btx);
                             GotoXY(27,10); Write(' Empregados Selecionados para o Rateio     ');
                             Color(Sfn,Stx);
                             Window(28,12,69,19);
                             GotoXY(1,8);
                             LiberaMVdsk;
                             NCont := 0;
                             EENo  := '';
                             Repeat
                               RC := 'N';
                               SearchPos5 ( Root5 );
                               If RC = 'S' then
                                  begin
                                    ReadWrite(#08,'R','N',EENumber);
                                    If ((SSNo = '') or (SSNo = EEMember.Sindicato)) and
                                       ((DDNo = '') or (DDNo = EEMember.Depto    )) and
                                       (EEMember.Status  in ['A','C','E']         ) then
                                       begin
                                         Writeln(EEMember.Nome);
                                         NCont := NCont + 1;
                                         LoadMVDsk(#11);
                                         YYNo := CCNo;
                                         SearchTreeY ( RootY );
                                         If RC = 'N' then
                                            begin
                                              LoadTreeY ( RootY );
                                              YAddress^.Origem    := 'S';
                                              YAddress^.AcMensalV := TruncX(Parcela * EEMember.Pontos);
                                            end
                                            else If YAddress^.Origem = 'S'
                                                    then YAddress^.AcMensalV := TruncX(Parcela * EEMember.Pontos);
                                         UnLoadMVDsk;
                                         LiberaMVDsk;
                                         RC := 'S';
                                       end;
                                  end;
                             Until RC = 'N';
                             Window(1,1,80,25);
                             Color(Blue,Cyan);
                             GotoXY(1,23);  Write(ConstStr(' ',80));
                             GotoXY(2,23);  Write('Total de Empregados Afetados:  ');
                             Color(Blue,White);
                             GotoXY(32,23); Write(NCont:5);
                             TeclaReturn;
                           end;
                      end;
                 end;
              TC := #13;
            end
            else begin
                   If CCNo = '*' then ErroMsg := 'Informe uma Conta'
                      else If RW = 'N' then ErroMsg := 'N∆o consigo ler o registro da Conta ' + CCNo
                              else If Status <> 'A' then ErroMsg := 'A Conta n∆o esta Ativa'
                                      else If Aceita = 'N' then ErroMsg := 'A Conta n∆o aceita Lanáamento';
                   ErrorMessage;
                 end;
       end;
    Move(ScArray4[1],Mem[$B800:0000],4000);
  Until TC = #27;
end;


Procedure TransportaAcumulados;
Var
  Lidos,Grav  : Integer;
  Carga       : Char;
begin
  DrawBox(4,10,49,19,Sfn,'S');
  Color(Red,Yellow);
  GotoXY(4,10); Write('               Leia com Atená∆o               ');
  Color(Red,Cyan);
  GotoXY(4,11); Write('               ----------------               ');
  GotoXY(4,12); Write(' Esta funá∆o transporta a Acumulado da Conta, ');
  GotoXY(4,13); Write(' do màs que o Sistema esta posicionado para o ');
  GotoXY(4,14); Write(' pr¢ximo màs da seguinte maneira:             ');
  GotoXY(4,15); Write('  +----------------+      +-----------------+ ');
  GotoXY(4,16); Write('  | Màs Corrente   |      | Pr¢ximo Màs     | ');
  GotoXY(4,17); Write('  | Acumulados     | para |                 | ');
  GotoXY(4,18); Write('  | Anual + Mensal |      | Acumulado Anual | ');
  GotoXY(4,19); Write('  +----------------+      +-----------------+ ');
  Color(Tfn,Utx);
  Confirma;
  If TC = 'S' then
     begin
       M := MM + 1;
       A := AA;
       If M = 13 then
          begin
            M := 1;
            A := A + 1;
          end;
       If XCondicional[1] <> '#' then
          begin
            J := QQStr(M,2,'0') + QQStr(A,2,'0');
            If (J <> Copy(XCondicional,1,4)) and
               (J <> Copy(XCondicional,5,4)) then TC := #27;
          end;
       If TC = 'S' then
          begin
            Lidos := 0;
            Grav  := 0;
            MMFn  := 'M' + QQStr(M,2,'0');
            IIFn  := 'I' + QQStr(M,2,'0');
            AAFn  := QQStr(A,2,'0');
            Assign ( PXFile,(XPath + '\PLOGTPAC.TMP'));
            {$I-}
            Reset ( PXFile );
            {$I+}
            If IOResult = 0 then begin
                                   Close  ( PXFile );
                                   Erase  ( PXFile );
                                 end
                                 else ReWrite ( PXFile );
            Color(Blue,White);
            GotoXY(01,23); Write(' ':80);
            GotoXY(02,23); Write('Registros lidos:');
            Color(Blue,Yellow);
            EENo := '';
            Repeat
              RC := 'N';
              SearchPos5 ( Root5 );
              If RC = 'S' then
                 begin
                   ReadWrite(#08,'R','N',EENumber);
                   If RW = 'S' then
                      begin
                        LoadMVDsk(#11);
                        YYNo := '';
                        Repeat
                          RC := 'N';
                          SearchPosY ( RootY );
                          If RC = 'S' then
                             begin
                               PXMember.Empregado := EENo;
                               PXMember.Conta     := YYNo;
                               PXMember.AcMensalV := YAddress^.AcAnualV + TruncX(YAddress^.AcMensalV);
                               Hora   := YAddress^.AcAnualH + YAddress^.AcMensalH;
                               Minuto := YAddress^.AcAnualM + YAddress^.AcMensalM;
                               HoraMinuto;
                               PXMember.AcMensalH := Hora;
                               PXMember.AcMensalM := Minuto;
                               Lidos := Lidos + 1;
                               GotoXY(19,23); Write(Lidos:4);
                               Seek ( PXFile, FileSize(PXFile));
                               Write( PXFile, PXMember        );
                             end;
                        Until RC = 'N';
                        LiberaMVDsk;
                        RC := 'S';
                      end;
                 end;
            Until RC = 'N';
            Color(Blue,Yellow);
            GotoXY(65,23); Write('Carregando...');
            Carga := 'N';
            Close  ( EEFile );
            Assign ( EEFile, (XPath + '\' + FileEE + AAFn + '.' + MMFn ));
            {$I-}
            Reset ( EEFile );
            {$I+}
            If IOResult <> 0 then
               begin
                 Color(Blue,White);
                 GotoXY(1,23); Write(' ':80);
                 GotoXY(2,23); Write('O màs de ',ArrayMesEx[M],' de ',A:2,' ainda n∆o foi Aberto');
                 TeclaReturn;
               end
               else begin
                      Carga := 'S';
                      Close  ( MMFile );
                      Assign ( MMFile,   (XPath + '\' + FileMM + AAFn + '.' + MMFn ));
                      {$I-}
                      Reset ( MMFile );
                      {$I+}
                      If IOResult <> 0 then
                         begin
                           Color(Blue,White);
                           GotoXY(1,23); Write(' ':80);
                           GotoXY(2,23); Write('O màs de ',ArrayMesEx[M],' de ',A:2,
                                               ' ainda n∆o foi Aberto');
                           TeclaReturn;
                         end
                         else begin
                                If Root5 <> NIL then Dispose5 ( Root5 );
                                Root5 := NIL;
                                Assign ( Ind2File, (XPath + '\' + FileInd2 + AAFn + '.' + IIFn ));
                                {$I-}
                                Reset ( Ind2File );
                                {$I+}
                                If IOResult <> 0 then
                                   begin
                                     ReWrite ( Ind2File );
                                     Reset   ( Ind2File );
                                     Color(Blue,White);
                                     GotoXY(1,23); Write(' ':80);
                                     GotoXY(2,23); Write('N∆o h† °ndice para ',ArrayMesEx[M],' de ',A:2,' Indexe (Opá∆o I)');
                                     TeclaReturn;
                                   end
                                   else LoadIndex2;
                                Close ( Ind2File );
                                Color(Blue,White);
                                GotoXY(36,23); Write('Registros gravados:');
                                GotoXY(65,23); Write('             ');
                                Color(Blue,Yellow);
                                I := -1;
                                Repeat
                                  I := I + 1;
                                  {$I-}
                                  Seek ( PXFile, I        );
                                  Read ( PXFile, PXMember );
                                  {$I+}
                                  If IOResult = 0 then
                                     begin
                                       Grav := Grav + 1;
                                       GotoXY(56,23); Write(Grav:4);
                                       EENo := PXMember.Empregado;
                                       SearchTree5 ( Root5 );
                                       If RC = 'S' then
                                          begin
                                            ReadWrite(#08,'R','N',EENumber);
                                            If RW = 'S' then
                                               begin
                                                 LoadMVDsk(#11);
                                                 YYNo := PXMember.Conta;
                                                 SearchTreeY ( RootY );
                                                 If RC = 'N' then
                                                    begin
                                                      LoadTreeY ( RootY );
                                                      YAddress^.Origem := 'S';
                                                    end;
                                                 YAddress^.AcAnualV := PXMember.AcMensalV;
                                                 YAddress^.AcAnualH := PXMember.AcMensalH;
                                                 YAddress^.AcAnualM := PXMember.AcMensalM;
                                                 UnLoadMVDsk;
                                                 RC := 'S';
                                               end;
                                          end;
                                     end;
                                Until I+1 = FileSize(PXFile);
                                If Root5 <> NIL then Dispose5 ( Root5 );
                                Root5 := NIL;
                                Assign ( Ind2File, (XPath + '\' + FileInd2 + AAFx + '.' + IIFx ));
                                {$I-}
                                Reset ( Ind2File );
                                {$I+}
                                If IOResult <> 0 then
                                   begin
                                     ReWrite ( Ind2File );
                                     Reset   ( Ind2File );
                                   end
                                   else LoadIndex2;
                                Close ( Ind2File );
                                Close ( MMFile   );
                                Close ( EEFile   );
                                TeclaReturn;
                              end;
                    end;
            Close ( PXFile );
            Erase ( PXFile );
            Assign ( EEFile, (XPath + '\' + FileEE + AAFx + '.' + MMFx));
            Reset  ( EEFile );
            If Carga = 'S' then
               begin
                 Assign ( MMFile, (XPath + '\' + FileMM + AAFx + '.' + MMFx));
                 Reset  ( MMFile );
               end;
          end;
     end;
end;

end.