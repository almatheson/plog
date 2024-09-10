{$O+,F+}
Unit PlogSala;

Interface

Uses Crt,Dos,PlogGlbs,PlogBasP,PlogTree,PlogFunc,PlogMstr;

   Procedure AlteraSalario;

Implementation

Var
  CentW,
  HistW,
  TipoW               : Char;
  Delta               : Real;
  OpcW                : Array[1..5] of Char;
  Faixa1,Faixa2,Perct : Array[1..5] of Real;
  MotivoW             : Str50;


Procedure TitleSalaU;
begin
  Color(Tfn,Ttx);
  GotoXY(04,09); Write('Matr°c:');
  GotoXY(04,10); Write('Nome..:');
  GotoXY(04,11); Write('Status:');
  GotoXY(04,13); Write('Antigo:');
  GotoXY(04,15); Write('Novo..:');
  GotoXY(04,16); Write('Data..:');
  GotoXY(04,17); Write('Motivo:');
  Color(Tfn,Utx);
end;


Procedure TitleSalaF;
begin
  Color(Tfn,Ttx);
  GotoXY(04,08); Write('H/M/S.:');
  GotoXY(04,09); Write('Sindic:');
  GotoXY(04,10); Write('Depto.:');
  Color(Bfn,Btx);
  GotoXY(12,11); Write('       De      ');
  GotoXY(28,11); Write('      AtÇ      ');
  GotoXY(44,11); Write('   Valor ou %  ');
  Color(Tfn,Ttx);
  GotoXY(04,12); Write('1¶Faix:');
  GotoXY(04,13); Write('2¶Faix:');
  GotoXY(04,14); Write('3¶Faix:');
  GotoXY(04,15); Write('4¶Faix:');
  GotoXY(04,16); Write('5¶Faix:');
  GotoXY(04,17); Write('Centav:');
  GotoXY(04,18); Write('Hist..:');
  GotoXY(04,19); Write('Data..:');
  GotoXY(04,20); Write('Motivo:');
  Color(Tfn,Utx);
end;


Procedure DataSalaU;
begin
  ReadWrite(#08,'R','N',EENumber);
  With EEMember do
  begin
    Color(Tfn,Utx);
    GotoXY(12,09); Write(Matricula,' ':15 - Length(Matricula));
    GotoXY(12,10); Write(Nome);
    GotoXY(12,11);
    Case EEMember.Status of
         'A' : Write('Ativo      ');
         'P' : Write('Dem.Espont.');
         'D' : Write('Demitido   ');
         'J' : Write('Justa Causa');
         'N' : Write('TÇrm.Contr.');
         'R' : Write('Rescindido ');
         'F' : Write('FÇrias     ');
         'L' : Write('Licenáa    ');
         'C' : Write('Acidentado ');
         'M' : Write('Morte      ');
         'T' : Write('Transferido');
         'O' : Write('Aposentado ');
         'X' : Write('Excluir Reg');
         else  Write(EEMember.Status);
    end;
    GotoXY(12,13); Write(EditReal(Salario):12);
  end;
end;


Procedure EntrySalaU;
begin
  Repeat
    K := 1;
    Repeat
      Case K of
           1   : begin
                   If Faixa1[1] = 0 then J := ''
                      else begin
                             Str(Faixa1[1]:12:2,J);
                             J := LeftAdjust(J);
                           end;
                   InputStr(J,12,12,15,0,'S','N','$','N',Tfn,Utx);
                   Val(J,Faixa1[1],E);
                   GotoXY(12,15); Write(EditReal(Faixa1[1]):12);
                   If (TC        <> #27) and
                      (Faixa1[1] =  0  ) then
                      begin
                        ErroMsg := 'Informe o Sal†rio';
                        ErrorMessage;
                        K := K - 1;
                      end;
                 end;
           2   : begin
                   J := WData;
                   InputStr(J,10,12,16,0,'S','N','D','S',Tfn,Utx);
                   If TC <> #27 then WData := J;
                 end;
           3   : begin
                   J := MotivoW;
                   InputStr(J,40,12,17,0,'S','S','T','N',Tfn,Utx);
                   MotivoW := J;
                 end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 4) or (TC = #27);
    If TC <> #27 then Confirma;
  Until (TC = 'S') or (TC = #27);
end;


Procedure Historico;
begin
  HHNo := EENo + '#' + Copy(WData,7,4) +
	               Copy(WData,4,2) +
		       Copy(WData,1,2) + '#S';
  SearchTree10 ( Root10 );
  If RC = 'S' then ReadWrite(#10,'R','N',HHNumber)
     else begin
            HHNumber  := FileSize(HHFile);
            LoadTree10 ( Root10 );
          end;
  HHMember.Empregado := EENo;
  HHMember.Data      := Copy(WData,7,4) + Copy(WData,4,2) +
                        Copy(WData,1,2);
  HHMember.OrigData  := Copy(WData,1,2) + '/' + Copy(WData,4,2) + '/' +
                        Copy(WData,7,4);
  HHMember.Tipo      := 'S';
  HHMember.Salario   := EEMember.Salario;
  HHMember.Motivo    := MotivoW;
  ReadWrite(#10,'W','N',HHNumber);
  RC := 'S';
end;


Procedure AlteracaoUnica;
begin
  Move(Mem[$B800:0000],ScArray6[1],4000);
  EENo := '';
  Repeat
    RecebeCodigo(9,'C','N');
    If EENumber <> Limite then
       With EEMember do
       begin
         DataSalaU;
         If EEMember.Status in ['A','C','F','L'] then
            begin
              Faixa1[1] := 0;
              MotivoW   := '';
              EntrySalaU;
              If TC = 'S' then
                 begin
                   UltSalario := Salario;
                   UltData    := WData;
                   Salario    := TruncX(Faixa1[1]);
                   ReadWrite(#08,'W','N',EENumber);
                   Historico;
                 end;
              Move(ScArray6[1],Mem[$B800:0000],4000);
            end;
       end;
  Until TC = #27;
end;


Procedure EntrySalaF;
begin
  Repeat
    K := 0;
    Repeat
      Case K of
           0   : begin
                   Move(Mem[$B800:0000],ScArray6[1],4000);
                   DrawBox(36,14,48,18,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(36,15); Write(' Horista     ');
                   GotoXY(36,16); Write(' Mensalista  ');
                   GotoXY(36,17); Write(' Semanalista ');
                   Color(Red,White);
                   GotoXY(37,15); Write('H');
                   GotoXY(37,16); Write('M');
                   GotoXY(37,17); Write('S');
                   J := TipoW;
                   InputStr(J,01,12,08,0,'S','N','T','N',Tfn,Utx);
                   Move(ScArray6[1],Mem[$B800:0000],4000);
                   TipoW := UpCase(J[1]);
                   GotoXY(12,08); Case TipoW of
                                       'H' : Write('Horista    ');
                                       'M' : Write('Mensalista ');
                                       'S' : Write('Semanalista');
                                  end;
                 end;
           1   : begin
                   Color(Blue,White);
                   GotoXY(1,24); Write(ConstStr(' ',80));
                   GotoXY(2,24); Write('F1');
                   Color(Blue,Cyan);
                   GotoXY(5,24); Write('para pesquisar Sindicatos');
                   J := SSNo;
                   InputStr(J,2,12,09,0,'S','N','T','N',Tfn,Utx);
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
                                     GotoXY(12,09); Write(' ':40);
                                     GotoXY(12,09);
                                     Write(SSNo,' ',Copy(Descricao,1,35));
                                   end
                                   else begin
                                          ErroMsg := 'Sindicato n∆o Existe';
                                          ErrorMessage;
                                          K := K - 1;
                                        end;
                              end
                              else If TC <> #27 then
                                      begin
                                        GotoXY(12,09); Write(' ':40);
                                        GotoXY(12,09); Write('** Todos')
                                      end;;
                   LimpaLn(24,Tfd);
                 end;
           2   : begin
                   Color(Blue,White);
                   GotoXY(1,24); Write(ConstStr(' ',80));
                   GotoXY(2,24); Write('F1');
                   Color(Blue,Cyan);
                   GotoXY(5,24); Write('para pesquisar Deptos');
                   J := DDNo;
                   InputStr(J,10,12,10,0,'S','N','T','N',Tfn,Utx);
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
                                     GotoXY(12,10); Write(' ':40);
                                     GotoXY(12,10);
                                     Write(DDNo,' ',Copy(Descricao,1,30));
                                   end
                                   else begin
                                          ErroMsg := 'Departamento n∆o Existe';
                                          ErrorMessage;
                                          K := K - 1;
                                        end;
                              end
                              else If TC <> #27 then
                                      begin
                                        GotoXY(12,10); Write(' ':40);
                                        GotoXY(12,10); Write('** Todos');
                                      end;
                   LimpaLn(24,Tfd);
                 end;
           3..7 : begin
                    If Faixa1[1] = 0
                       then J := ''
                       else begin
                              Str(Faixa1[K-2]:15:2,J);
                              J := LeftAdjust(J);
                            end;
                    Color(Tfn,Utx);
                    GotoXY(12,(K+9)); Write(ConstStr(' ',15));
                    InputStr(J,12,12,(K+9),0,'S','N','$','N',Tfn,Utx);
                    If J = '' then Faixa1[K-2] := 0
                              else Val(J,Faixa1[K-2],E);
                    If (K           > 3) and
                       (Faixa1[K-2] = 0) then K := 7
                       else If TC <> #27 then
                               begin
                                 If Faixa2[K-2] = 0 then J := ''
                                    else begin
                                           Str(Faixa2[K-2]:15:2,J);
                                           J := LeftAdjust(J);
                                         end;
                                 Color(Tfn,Utx);
                                 GotoXY(28,(K+9)); Write(ConstStr(' ',15));
                                 InputStr(J,12,28,(K+9),0,'S','N','$','N',Tfn,Utx);
                                 Val(J,Faixa2[K-2],E);
                                 If TC <> #27 then
                                    begin
                                      Move(Mem[$B800:0000],ScArray6[1],4000);
                                      DrawBox(6,16,24,19,Red,'S');
                                      Color(Red,Cyan);
                                      GotoXY(6,17); Write(' % para percentual ');
                                      GotoXY(6,18); Write(' * p/Substituiá∆o. ');
                                      Color(Red,White);
                                      GotoXY(7,17); Write('%');
                                      GotoXY(7,18); Write('*');
                                      If Perct[K-2] = 0 then J := ''
                                         else begin
                                                Str(Perct[K-2]:14:2,J);
                                                J := LeftAdjust(J);
                                              end;
                                      Color(Tfn,Utx);
                                      GotoXY(44,(K+9)); Write(ConstStr(' ',15));
                                      InputStr(J,12,44,(K+9),0,'S','N','T','N',Tfn,Utx);
                                      Move(ScArray6[1],Mem[$B800:0000],4000);
                                      If (J[1] <> '%') and
                                         (J[1] <> '*') then J[1] := ' ';
                                      OpcW[K-2] := J[1];
                                      Delete(J,1,1);
                                      Val(J,Perct[K-2],E);
                                      GotoXY(44,K+9); Write(EditReal(Perct[K-2]):12);
                                    end;
                               end;
                  end;
           8   : begin
                   Move(Mem[$B800:0000],ScArray6[1],4000);
                   DrawBox(36,14,55,17,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(36,15); Write(' Quer  centavos  no ');
                   GotoXY(36,16); Write(' resultado:  im/ ∆o ');
                   Color(Red,White);
                   GotoXY(48,16); Write('S');
                   GotoXY(52,16); Write('N');
                   J := CentW;
                   InputStr(J,1,12,17,0,'S','N','T','N',Tfn,Utx);
                   Move(ScArray6[1],Mem[$B800:0000],4000);
                   CentW := UpCase(J[1]);
                   If (CentW <> 'S') and
                      (CentW <> 'N') then CentW := 'S';
                   GotoXY(12,17); Case CentW of
                                       'S' : Write('Sim');
                                       'N' : Write('N∆o');
                                  end;
                 end;
           9   : begin
                   Move(Mem[$B800:0000],ScArray6[1],4000);
                   DrawBox(36,14,55,17,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(36,15); Write(' Quer registrar  no ');
                   GotoXY(36,16); Write(' Hist¢rico:  im/ ∆o ');
                   Color(Red,White);
                   GotoXY(48,16); Write('S');
                   GotoXY(52,16); Write('N');
                   J := HistW;
                   InputStr(J,1,12,18,0,'S','N','T','N',Tfn,Utx);
                   Move(ScArray6[1],Mem[$B800:0000],4000);
                   HistW := UpCase(J[1]);
                   If (HistW <> 'S') and
                      (HistW <> 'N') then HistW := 'S';
                   GotoXY(12,18); Case HistW of
                                       'S' : Write('Sim');
                                       'N' : Write('N∆o');
                                  end;
                 end;
           10  : If HistW = 'S' then
                    begin
                      J := WData;
                      InputStr(J,10,12,19,0,'S','N','D','S',Tfn,Utx);
                      If TC <> #27 then WData := J;
                    end;
           11  : If HistW = 'S' then
                    begin
                      J := MotivoW;
                      InputStr(J,40,12,20,0,'S','S','T','N',Tfn,Utx);
                      MotivoW := J;
                    end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 12) or (TC = #27);
    If TC <> #27 then Confirma;
  Until (TC = 'S') or (TC = #27);
end;


Procedure AlteracaoFaixa;
begin
  For I := 1 to 5 do begin
                       Faixa1[I] := 0;
                       Faixa2[I] := 0;
                       Perct[I]  := 0;
                       OpcW[I]   := ' ';
                     end;
  SSNo    := '';
  DDNo    := '';
  MotivoW := '';
  TipoW   := 'M';
  HistW   := 'S';
  CentW   := 'S';
  NCont   := 0;
  EntrySalaF;
  If TC = 'S' then
     begin
       DrawBox(27,10,69,19,Sfn,'S');
       Color(Bfn,Btx);
       GotoXY(27,10); Write(' Empregados Selecionados para Alteraá∆o    ');
       Color(Sfn,Stx);
       Window(28,12,69,19);
       GotoXY(1,8);
       EENo := '';
       Repeat
         RC := 'N';
         SearchPos5 ( Root5 );
         If RC = 'S' then
            With EEMember do
            begin
              ReadWrite(#08,'R','N',EENumber);
              If ((SSNo = '') or (SSNo = Sindicato)) and
                 ((DDNo = '') or (DDNo = Depto    )) and
                 (UpCase(Tipo) = TipoW             ) and
                 (Status  in ['A','C','F','L']     ) then
                 begin
                   Writeln(Nome);
                   NCont := NCont + 1;
                   Valor := 0;
                   Delta := 0;
                   I     := 0;
                   Repeat
                     I := I + 1;
                     If (Salario >= Faixa1[I]) and
                        (Salario <= Faixa2[I]) then
                        begin
                          Case OpcW[I] of
                               '%' : Delta := Delta + ((Salario * Perct[I]) / 100);
                               '*' : begin
                                       Delta   := Delta + Perct[I];
                                       Salario := 0;
                                       I       := 5;
                                     end;
                          end;
                        end
                        else If (Salario    > Faixa2[I]) and
                                (Faixa2[I] <> 0        ) then
                                begin
                                  If I = 1 then Valor := Faixa2[I]
                                           else Valor := Faixa2[I] - Faixa2[I - 1];
                                  Delta := Delta + ((Valor * Perct[I]) / 100);
                                end;
                   Until I = 5;
                   UltSalario := Salario;
                   UltData    := WData;
                   Salario    := TruncX(Salario + Delta);
                   If CentW = 'N' then
                      begin
                        R1 := Frac(Salario);
                        R2 := 1 - Frac(Salario);
                        If R1 < 0.50 then Salario := Salario - R1
                                     else Salario := Salario + R2;
                      end;
                   ReadWrite(#08,'W','N',EENumber);
                   If HistW = 'S' then Historico;
                 end;
            end;
       Until RC = 'N';
       Window(1,1,80,25);
       Color(Blue,Black);
       GotoXY(1,23);  Write(ConstStr(' ',80));
       GotoXY(2,23);  Write('Total de Empregados Alterados: ');
       Color(Blue,White);
       GotoXY(33,23); Write(NCont:5);
       TeclaReturn;
     end;
end;


Procedure AlteraSalario;
begin
  WData := XDia + '/' + XMes + '/' + XAno;
  Move(ScArray4[1],Mem[$B800:0000],4000);
  Color(Red,White);
  GotoXY(36,7); Write('Total de Enpreg: ');
  Color(Red,Yellow);
  GotoXY(53,7);  Write(CMstMember.NFunc:3);
  Color(Sfn,Stx);
  GotoXY(35,08);
  Case YY of
       1 : begin
             Write(' Alteraá∆o Individual     ');
             TitleSalaU;
             AlteracaoUnica;
           end;
       2 : begin
             Write(' Alteraá∆o por Faixa      ');
             TitleSalaF;
             AlteracaoFaixa;
           end;
  end;
  TC := #13;
  Move(ScArray5[1],Mem[$B800:0000],4000);
end;

end.