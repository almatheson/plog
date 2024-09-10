{$O+,F+}
Unit PlogTabl;

Interface

Uses Crt,Dos,PlogGlbs,PlogBasP,PlogTree,PlogCmpy,PlogRpt0;


   Procedure TableFrame;
   Procedure SelecionaTabela;
   Procedure TitleTabl (X : Char);
   Procedure DataTabl  (X : Char);


Implementation

Procedure TableFrame;
begin
  Color(Tfd,Utx);
  For K := 6 to 23 do LimpaLn(K,Tfd);
  DrawBox(35,6,77,19,Red,'S');
  Color(Bfn,Btx);
  GotoXY(35,6); Write(' ':43);
  GotoXY(36,6); Write(Titulo);
  DrawBox(2,8,66,21,Tfn,'S');
  Color(Tfn,Utx);
end;

Procedure RecebeTabl;
begin
  Repeat
    K  := 1;
    Repeat
      Case K of
           1  :  begin
                   Color(Tfn,Utx);
                   GotoXY(12,09); Write(' ':17);
                   J := '';
                   InputStr(J,2,12,09,0,'S','N','T','N',Tfn,Utx);
                   If TC = #13 then
                      begin
                        Val(J,MM,E);
                        If (MM < 1) or (MM > 12) then
                           begin
                             ErroMsg := 'Informe o Màs a que se refere a Tabela';
                             ErrorMessage;
                             K := K - 1;
                           end
                           else begin
                                  GotoXY(12,09);
                                  Write(MM:2,' ',PushLeft(10,ArrayMesEx[MM]));
                                  Str(MM:2,J);
                                  J := LeftAdjust(J);
                                  If Length(J) = 1 then J := '0' + J;
                                  MMFx := 'M' + J;
                                end;
                      end;
                 end;
           2  :  begin
                   J := '';
                   InputStr(J,4,12,10,0,'S','N','T','N',Tfn,Utx);
                   If TC = #13 then
                      begin
                        Val(J,AA,E);
                        If AA = 0 then
                           begin
                             ErroMsg := 'Informe o Ano a que se refere a Tabela';
                             ErrorMessage;
                             K := K - 1;
                           end
                           else begin
                                  GotoXY(12,10); Write(AA);
                                  Str(AA:4,J);
                                  AAFx := LeftAdjust(J);
                                end;
                      end;
                 end;
           3  :  begin
                   J := Sq;
                   InputStr(J,1,12,11,0,'S','N','T','N',Tfn,Utx);
                   GotoXY(12,11);
                   Case TC of
                        #13 : begin
                                Sq := J[1];
                                Case Sq of
                                     '1' : Write('1¶ vers∆o');
                                     '2' : Write('2¶ vers∆o');
                                     else begin
                                            ErroMsg := 'Informe a Vers∆o 1 ou 2';
                                            ErrorMessage;
                                            K := K - 1;
                                          end;
                                end;
                              end;
                   end;
                 end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 4) or (TC = #27);
    If TC <> #27 then Confirma;
  Until TC in ['S',#27];
end;


Procedure TitleTabl(X : Char);
begin
  Color(Sfn,Stx);
  Case X of
       '1' : begin
               GotoXY(3,9);
               Write('                   AtÇ       %Empregado     %Empresa     ');
             end;
       '2' : begin
               GotoXY(3,9);
               Write('           AtÇ        Percentual         Deduá∆o         ');
             end;
       '3' : begin
               GotoXY(3,9);
               Write('          AtÇ             Sal.Familia                    ');
             end;
       '4' : begin
               Color(Tfn,Ttx);
               GotoXY(2,08); Write('...Use O',#26,'Onibus, M',#26,'Metrì, B',#26,'Barca ou F',#26,'Fixo no campo ?');
               Color(Sfn,Stx);
               GotoXY(2,09); Write('Fx ?tarifa Fx ?tarifa Fx ?tarifa Fx ?tarifa Fx ?tarifa Fx ?tarifa');
               Color(Tfn,Ttx);
               GotoXY(2,10); Write('01         13         25         37         49         61        ');
               GotoXY(2,11); Write('02         14         26         38         50         62        ');
               GotoXY(2,12); Write('03         15         27         39         51         63        ');
               GotoXY(2,13); Write('04         16         28         40         52         64        ');
               GotoXY(2,14); Write('05         17         29         41         53         65        ');
               GotoXY(2,15); Write('06         18         30         42         54         66        ');
               GotoXY(2,16); Write('07         19         31         43         55         67        ');
               GotoXY(2,17); Write('08         20         32         44         56         68        ');
               GotoXY(2,18); Write('09         21         33         45         57         69        ');
               GotoXY(2,19); Write('10         22         34         46         58         70        ');
               GotoXY(2,20); Write('11         23         35         47         59         71        ');
               GotoXY(2,21); Write('12         24         36         48         60         72        ');
             end;
       '5' : begin
               Color(Tfn,Ttx);
               GotoXY(4,10); Write('Deduá∆o por Dep.(IR):');
               GotoXY(4,11); Write('Sal†rio M°nimo .....:');
               GotoXY(4,12); Write('Teto Contrib.de INSS:');
               Color(Sfn,Stx);
               GotoXY(4,14);
               Write('                      ...1¶ ...2¶ ...3¶ ...4¶ ...5¶ ');
               Color(Tfn,Ttx);
               GotoXY(4,16); Write('% de Periculosidade :');
               GotoXY(4,18); Write('% de Insalubridade .:');
             end;
       '6' : begin
               GotoXY(3,9);
               Write('                   Faixa     Sal.Contr.     Contrib.     ');
             end;
  end;
  Color(Tfn,Utx);
end;


Procedure PreparaTabela;
begin
  TTMember.AnoMesSeq    := TTNo;
  TTMember.DependenteIR := 0;
  TTMember.SalMinimo    := 0;
  TTMember.TetoSalContr := 0;
  For I := 1 to 5 do begin
                       TTMember.Peri[I] := 0;
                       TTMember.Insa[I] := 0;
                     end;
  For I := 1 to 10 do begin
                        TTMember.FaixaIapas[I] := 0;
                        TTMember.TaxaIapas[I]  := 0;
                        TTMember.TaxaEIapas[I] := 0;
                        TTMember.FaixaIR[I]    := 0;
                        TTMember.TaxaIR[I]     := 0;
                        TTMember.DeducaoIR[I]  := 0;
                        TTMember.FaixaSF[I]    := 0;
                        TTMember.ValorSF[I]    := 0;
                        TTMember.TxINSS[I]     := 0;
                        TTMember.TxEINSS[I]    := 0;
                      end;
  For I := 1 to 100 do
  begin
    TTMember.VPass[I] := 0;
    TTMember.TPass[I] := ' ';
  end;
end;


Procedure DataTabl(X : Char);
begin
  ReadWrite(#03,'R','N',TTNumber);
  If RW = 'S' then
     begin
       Color(Red,Yellow);
       GotoXY(36,07); Write(Copy(TTNo,7,1),'¶ ');
       Color(Red,White);
       GotoXY(39,07); Write('Vers∆o da Tabela');
       I := 0;
       Color(Tfn,Utx);
       Case X of
            '1' : Repeat
                    I := I + 1;
                    GotoXY(14,I+10); Write(EditReal(TTMember.FaixaIapas[I]):15);
                    GotoXY(36,I+10); Write(EditReal(TTMember.TaxaIapas[I]):5);
                    GotoXY(49,I+10); Write(EditReal(TTMember.TaxaEIapas[I]):5);
                  Until I = 10;
            '2' : Repeat
                    I := I + 1;
                    GotoXY(06,I+10); Write(EditReal(TTMember.FaixaIR[I]):15);
                    GotoXY(28,I+10); Write(EditReal(TTMember.TaxaIR[I]):5);
                    GotoXY(38,I+10); Write(EditReal(TTMember.DeducaoIR[I]):15);
                  Until I = 10;
            '3' : Repeat
                    I := I + 1;
                    GotoXY(06,I+10); Write(EditReal(TTMember.FaixaSF[I]):15);
                    GotoXY(25,I+10); Write(EditReal(TTMember.ValorSF[I]):15);
                  Until I = 10;
            '4' : For I := 1 to 12 do
                  begin
                    GotoXY(05,9+I); Write(TTMember.TPass[I],EditReal(TTMember.VPass[I]):6);
                    GotoXY(16,9+I); Write(TTMember.TPass[I+12],EditReal(TTMember.VPass[I+12]):6);
                    GotoXY(27,9+I); Write(TTMember.TPass[I+24],EditReal(TTMember.VPass[I+24]):6);
                    GotoXY(38,9+I); Write(TTMember.TPass[I+36],EditReal(TTMember.VPass[I+36]):6);
                    GotoXY(49,9+I); Write(TTMember.TPass[I+48],EditReal(TTMember.VPass[I+48]):6);
                    GotoXY(60,9+I); Write(TTMember.TPass[I+60],EditReal(TTMember.VPass[I+60]):6);
                  end;
            '5' : begin
                    GotoXY(26,10); Write(EditReal(TTMember.DependenteIR):15);
                    GotoXY(26,11); Write(EditReal(TTMember.SalMinimo):15);
                    GotoXY(26,12); Write(EditReal(TTMember.TetoSalContr):15);
                    GotoXY(26,16); Write(EditReal(TTMember.Peri[1]):5,' ',
                                         EditReal(TTMember.Peri[2]):5,' ',
                                         EditReal(TTMember.Peri[3]):5,' ',
                                         EditReal(TTMember.Peri[4]):5,' ',
                                         EditReal(TTMember.Peri[5]):5);
                    GotoXY(26,18); Write(EditReal(TTMember.Insa[1]):5,' ',
                                         EditReal(TTMember.Insa[2]):5,' ',
                                         EditReal(TTMember.Insa[3]):5,' ',
                                         EditReal(TTMember.Insa[4]):5,' ',
                                         EditReal(TTMember.Insa[5]):5);
                  end;
            '6' : Repeat
                    I := I + 1;
                    GotoXY(23,I+10); Write(I:2);
                    GotoXY(36,I+10); Write(EditReal(TTMember.TxINSS[I]):5);
                    GotoXY(49,I+10); Write(EditReal(TTMember.TxEINSS[I]):5);
                  Until I = 10;
       end;
     end;
end;


Procedure Entry1;
begin
  Repeat
    K := 1;
    I := 1;
    Repeat
      Case K of
           1   : With TTMember do
                 begin
                   If FaixaIapas[I] = 0 then J := ''
                      else begin
                             Str(FaixaIapas[I]:12:2,J);
                             J := LeftAdjust(J);
                           end;
                   InputStr(J,14,15,I + 10,0,'S','N','$','N',Tfn,Utx);
                   Val(J,FaixaIapas[I],E);
                   If TC = #24 then
                      begin
                        K := 3;
                        If I > 1 then I := I - 1;
                      end
                      else K := 2;
                 end;
           2   : With TTMember do
                 begin
                   If TaxaIapas[I] = 0 then J := ''
                      else begin
                             Str(TaxaIapas[I]:5:2,J);
                             J := LeftAdjust(J);
                           end;
                   InputStr(J,5,36,I + 10,0,'S','N','$','N',Tfn,Utx);
                   Val(J,TaxaIapas[I],E);
                   If TC = #24 then K := 1
                               else K := 3;
                 end;
           3   : With TTMember do
                 begin
                   If TaxaEIapas[I] = 0 then J := ''
                      else begin
                             Str(TaxaEIapas[I]:5:2,J);
                             J := LeftAdjust(J);
                           end;
                   InputStr(J,5,49,I + 10,0,'S','N','$','N',Tfn,Utx);
                   Val(J,TaxaEIapas[I],E);
                   If TC = #24 then K := 2
                               else If I < 10 then
                                       begin
                                         K := 1;
                                         I := I + 1;
                                       end
                                       else K := 4;
                 end;
      end;
    Until (K = 4) or (TC = #27);
    Confirma;
  Until TC in ['S',#27];
end;


Procedure Entry2;
begin
  Repeat
    K := 1;
    I := 1;
    Repeat
      Case K of
           1   : With TTMember do
                 begin
                   If FaixaIR[I] = 0 then J := ''
                      else begin
                             Str(FaixaIR[I]:12:2,J);
                             J := LeftAdjust(J);
                           end;
                   InputStr(J,14,7,I + 10,0,'S','N','$','N',Tfn,Utx);
                   Val(J,FaixaIR[I],E);
                   If TC = #24 then
                      begin
                        K := 3;
                        If I > 1 then I := I - 1;
                      end
                      else K := 2;
                 end;
           2   : With TTMember do
                 begin
                   If TaxaIR[I] = 0 then J := ''
                      else begin
                             Str(TaxaIR[I]:5:2,J);
                             J := LeftAdjust(J);
                           end;
                      InputStr(J,5,28,I + 10,0,'S','N','$','N',Tfn,Utx);
                      Val(J,TaxaIR[I],E);
                      If TC = #24 then K := 1
                                  else K := 3;
                 end;
           3   : With TTMember do
                 begin
                   If DeducaoIR[I] = 0 then J := ''
                      else begin
                             Str(DeducaoIR[I]:12:2,J);
                             J := LeftAdjust(J);
                           end;
                   InputStr(J,14,39,I + 10,0,'S','N','$','N',Tfn,Utx);
                   Val(J,DeducaoIR[I],E);
                   If TC = #24 then K := 2
                               else If I < 10 then
                                       begin
                                         K := 1;
                                         I := I + 1;
                                       end
                                       else K := 4;
                 end;
      end;
    Until (K = 4) or (TC = #27);
    Confirma;
  Until TC in ['S',#27];
end;


Procedure Entry3;
begin
  Repeat
    K := 1;
    I := 1;
    Repeat
      Case K of
           1   : With TTMember do
                 begin
                   If FaixaSF[I] = 0 then J := ''
                      else begin
                             Str(FaixaSF[I]:12:2,J);
                             J := LeftAdjust(J);
                           end;
                   InputStr(J,14,7,I + 10,0,'S','N','$','N',Tfn,Utx);
                   Val(J,FaixaSF[I],E);
                   If TC = #24 then
                      begin
                        K := 3;
                        If I > 1 then I := I - 1;
                      end
                      else K := 2;
                 end;
           2   : With TTMember do
                 begin
                   If ValorSF[I] = 0 then J := ''
                      else begin
                             Str(ValorSF[I]:12:2,J);
                             J := LeftAdjust(J);
                           end;
                      InputStr(J,14,26,I + 10,0,'S','N','$','N',Tfn,Utx);
                      Val(J,ValorSF[I],E);
                      If TC = #24 then K := 1
                                  else If I < 10 then
                                          begin
                                            K := 1;
                                            I := I + 1;
                                          end
                                          else K := 3;
                 end;
      end;
    Until (K = 3) or (TC = #27);
    Confirma;
  Until TC in ['S',#27];
end;


Procedure Entry4;
begin
  Repeat
    K := 1;
    Repeat
      J := TTMember.TPass[K];
      Case K of
           1..12  : InputStr(J,1,05,(9 + K),0,'S','N','T','N',Tfn,Utx);
           13..24 : InputStr(J,1,16,(K - 3),0,'S','N','T','N',Tfn,Utx);
           25..36 : InputStr(J,1,27,(K - 15),0,'S','N','T','N',Tfn,Utx);
           37..48 : InputStr(J,1,38,(K - 27),0,'S','N','T','N',Tfn,Utx);
           49..60 : InputStr(J,1,49,(K - 39),0,'S','N','T','N',Tfn,Utx);
           61..72 : InputStr(J,1,60,(K - 51),0,'S','N','T','N',Tfn,Utx);
      end;
      If TC <> #27 then
         begin
           TTMember.TPass[K] := UpCase(J[1]);
           If TTMember.VPass[K] = 0 then J := ''
                                    else begin
                                           Str(TTMember.VPass[K]:6:2,J);
                                           J := LeftAdjust(J);
                                         end;
           Case K of
                1..12  : InputStr(J,6,06,(9 + K),0,'S','N','$','N',Tfn,Utx);
                13..24 : InputStr(J,6,17,(K - 3),0,'S','N','$','N',Tfn,Utx);
                25..36 : InputStr(J,6,28,(K - 15),0,'S','N','$','N',Tfn,Utx);
                37..48 : InputStr(J,6,39,(K - 27),0,'S','N','$','N',Tfn,Utx);
                49..60 : InputStr(J,6,50,(K - 39),0,'S','N','$','N',Tfn,Utx);
                61..72 : InputStr(J,6,61,(K - 51),0,'S','N','$','N',Tfn,Utx);
           end;
           If TC <> #27 then Val(J,TTMember.VPass[K],E);
         end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 73) or (TC = #27);
    Confirma;
  Until TC in ['S',#27];
end;


Procedure Entry5;
begin
  Repeat
    K := 1;
    Repeat
      Case K of
           1   : begin
                   If TTMember.DependenteIR = 0 then J := ''
                      else begin
                             Str(TTMember.DependenteIR:12:2,J);
                             J := LeftAdjust(J);
                           end;
                   InputStr(J,14,27,10,0,'S','N','$','N',Tfn,Utx);
                   Val(J,TTMember.DependenteIR,E);
                 end;
           2   : begin
                   If TTMember.SalMinimo = 0 then J := ''
                      else begin
                             Str(TTMember.SalMinimo:12:2,J);
                             J := LeftAdjust(J);
                           end;
                   InputStr(J,14,27,11,0,'S','N','$','N',Tfn,Utx);
                   Val(J,TTMember.SalMinimo,E);
                 end;
           3   : begin
                   If TTMember.TetoSalContr = 0 then J := ''
                      else begin
                             Str(TTMember.TetoSalContr:12:2,J);
                             J := LeftAdjust(J);
                           end;
                   InputStr(J,14,27,12,0,'S','N','$','N',Tfn,Utx);
                   Val(J,TTMember.TetoSalContr,E);
                 end;
           4   : begin
                   I := 1;
                   Repeat
                     If TTMember.Peri[I] = 0 then J := ''
                        else begin
                               Str(TTMember.Peri[I]:5:2,J);
                               J := LeftAdjust(J);
                             end;
                     InputStr(J,5,(20+(I* 6)),16,0,'S','N','$','N',Tfn,Utx);
                     If TC <> #27 then
                        begin
                          Val(J,TTMember.Peri[I],E);
                          If TC = #24 then I := I - 1
                                      else I := I + 1;
                        end;
                   Until (I = 0) or (I = 6) or (TC = #27);
                 end;
           5   : begin
                   I := 1;
                   Repeat
                     If TTMember.Insa[I] = 0 then J := ''
                        else begin
                               Str(TTMember.Insa[I]:5:2,J);
                               J := LeftAdjust(J);
                             end;
                     InputStr(J,5,(20+(I* 6)),18,0,'S','N','$','N',Tfn,Utx);
                     If TC <> #27 then
                        begin
                          Val(J,TTMember.Insa[I],E);
                          If TC = #24 then I := I - 1
                                      else I := I + 1;
                        end;
                   Until (I = 0) or (I = 6) or (TC = #27);
                 end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 6) or (TC = #27);
    Confirma;
  Until TC in ['S',#27];
end;


Procedure Entry6;
begin
  Repeat
    K := 1;
    I := 1;
    Repeat
      Case K of
           1   : With TTMember do
                 begin
                   If TxINSS[I] = 0 then J := ''
                      else begin
                             Str(TxINSS[I]:5:2,J);
                             J := LeftAdjust(J);
                           end;
                   InputStr(J,5,36,I + 10,0,'S','N','$','N',Tfn,Utx);
                   Val(J,TxINSS[I],E);
                   If TC = #24 then K := 1
                               else K := 3;
                 end;
           3   : With TTMember do
                 begin
                   If TxEINSS[I] = 0 then J := ''
                      else begin
                             Str(TxEINSS[I]:5:2,J);
                             J := LeftAdjust(J);
                           end;
                   InputStr(J,5,49,I + 10,0,'S','N','$','N',Tfn,Utx);
                   Val(J,TxEINSS[I],E);
                   If TC = #24 then K := 2
                               else If I < 10 then
                                       begin
                                         K := 1;
                                         I := I + 1;
                                       end
                                       else K := 4;
                 end;
      end;
    Until (K = 4) or (TC = #27);
    Confirma;
  Until TC in ['S',#27];
end;


Procedure UpdateTabl(X : Char);
begin
  TTNo := AAFx + Copy(MMFx,2,2) + Sq;
  SearchTree4 ( Root4 );
  If RC = 'N' then
     begin
       If Sq = '2' then
          begin
            TTAC := TTNo;
            TTNo := AAFx + Copy(MMFx,2,2) + '1';
            SearchTree4 ( Root4 );
            TTNo := TTAC;
            If RC = 'S' then
               begin
                 ReadWrite(#03,'R','N',TTNumber);
                 TTMember.AnoMesSeq := TTNo;
               end
               else PreparaTabela;
          end
          else PreparaTabela;
       TTNumber := FileSize (TTFile);
       LoadTree4 ( Root4 );
       ReadWrite(#03,'W','N',TTNumber);
       D1 := 'S';
     end;
  If TTNumber <> Limite then
     Repeat
       DataTabl(X);
       Resp := ReadKey;
       If (Resp = #0) and (KeyPressed) then
          begin
            Resp := ReadKey;
            If Resp = #61 then
               begin
                 Case X of
                      '1' : Entry1;
                      '2' : Entry2;
                      '3' : Entry3;
                      '4' : Entry4;
                      '5' : Entry5;
                      '6' : Entry6;
                 end;
                 If TC = 'S' then ReadWrite(#03,'W','N',TTNumber);
               end;
          end;
     Until Resp = #27;
end;


Procedure CopiaTabl;
begin
  TTNo := AAFx + Copy(MMFx,2,2) + Sq;
  SearchTree4 ( Root4 );
  If RC = 'S' then
     begin
       ReadWrite(#03,'R','N',TTNumber);
       TTAC := TTNo;
       TTAN := TTNumber;
       RecebeTabl;
       If TC = 'S' then
          begin
            TTNo := AAFx + Copy(MMFx,2,2) + Sq;
            SearchTree4 ( Root4 );
            If RC = 'N' then
               begin
                 TTMember.AnoMesSeq := TTNo;
                 TTNumber           := FileSize (TTFile);
                 LoadTree4 ( Root4 );
                 D1 := 'S';
                 ReadWrite(#03,'W','N',TTNumber);
                 Color(Blue,White);
                 GotoXY(01,23); Write(ConstStr(' ',80));
                 GotoXY(02,23); Write('Tabela foi copiada.');
                 TeclaReturn;
                 LimpaLn(23,Tfd);
               end;
          end;
       TTNo     := TTAC;
       TTNumber := TTAN;
       ReadWrite(#03,'R','N',TTNumber);
       AAFx := Copy(TTMember.AnoMesSeq,1,4);
       MMFx := 'M' + Copy(TTMember.AnoMesSeq,5,2);
       Sq   := TTMember.AnoMesSeq[7];
     end
     else begin
            ErroMsg := 'A Tabela n∆o Existe';
            ErrorMessage;
          end;
  Resp := #13;
  TC   := #13;
end;


Procedure DeletaReativaTabl(X : Char);
begin
  TC := 'N';
  ReadWrite(#03,'R','N',TTNumber);
  Case X of
       'D' : If TTMember.AnoMesSeq[7] in ['.',':'] then
                begin
                  Color(Blue,White);
                  GotoXY(01,23); Write(ConstStr(' ',80));
                  GotoXY(02,23); Write('O registro j† esta Exclu°do.');
                  TeclaReturn;
                  LimpaLn(23,Tfd);
                end
                else TC := 'S';
       'R' : If TTMember.AnoMesSeq[7] in ['1','2'] then
                begin
                  Color(Blue,White);
                  GotoXY(01,23); Write(ConstStr(' ',80));
                  GotoXY(02,23); Write('O registro j† esta Reativado.');
                  TeclaReturn;
                  LimpaLn(23,Tfd);
                end
                else TC := 'S';
  end;
  If TC = 'S' then Confirma;
  If TC = 'S' then
     begin
       Case X of
            'D' : Case TTMember.AnoMesSeq[7] of
                       '1' :  TTMember.AnoMesSeq[7] := '.';
                       '2' :  TTMember.AnoMesSeq[7] := ':';
                  end;
            'R' : Case TTMember.AnoMesSeq[7] of
                       '.' :  TTMember.AnoMesSeq[7] := '1';
                       ':' :  TTMember.AnoMesSeq[7] := '2';
                  end;
       end;
       ReadWrite(#03,'W','N',TTNumber);
       TTAC := TTMember.AnoMesSeq;
       Dispose4 ( Root4 );
       Root4    := NIL;
       TTNumber := -1;
       Repeat
         TTNumber := TTNumber + 1;
         ReadWrite(#03,'R','N',TTNumber);
         TTNo := TTMember.AnoMesSeq;
         SearchTree4 ( Root4 );
         If RC = 'N' then LoadTree4 ( Root4 );
       Until (TTNumber + 1) = FileSize(TTFile);
       TTNo := TTAC;
       SearchTree4 ( Root4 );
       If RC = 'S' then ReadWrite(#03,'R','N',TTNumber);
       D1 := 'S';
       Color(Blue,White);
       GotoXY(01,23); Write(ConstStr(' ',80));
       GotoXY(02,23);
       Case X of
            'D' : Write('Registro exclu°do logicamente, (Indexe para excluir fisicamente).');
            'R' : Write('Registro reativado.');
       end;
       TeclaReturn;
       LimpaLn(23,Tfd);
     end;
end;


Procedure MoveParaArrayS(L : Integer);
begin
  ReadWrite(#03,'R','N',TTNumber);
  If RW = 'S' then
     begin
       KArray[L] := TTMember.AnoMesSeq;
       RArray[L] := TTNumber;
     end;
end;


Procedure ArrayParaArrayS(D,P : Integer);
begin
  KArray[P]  := KArray[D];
  RArray[P]  := RArray[D];
end;


Procedure ScrollTabl;
Var
   ScArrayS       : Array [1..4000] of Char;
begin
  Move(Mem[$B800:0000],ScArrayS[1],4000);
  FootScroll;
  DrawBox(40,10,50,19,Sfn,'S');
  Color(Bfn,Btx);
  GotoXY(40,10); Write(' MM/AAAA V ');
  Color(Sfn,Stx);
  TTAC    := TTNo;
  TTAN    := TTNumber;
  Tkb     := 'L';
  F       := 'N';
  Direcao := 'P';
  L       := 0;
  Sx      := 1;
  For I := 1 to 7 do begin
                       KArray[I] := '';
                       RArray[I] := 0;
                     end;
  RC := 'N';
  SearchAnt4 ( Root4 );
  If RC = 'N' then TTNo := '';
  Repeat
    RC := 'N';
    SearchPos4 ( Root4 );
    If RC = 'S' then
       begin
         L := L + 1;
         MoveParaArrayS(L);
       end
       else L := 7;
  Until L = 7;
  Repeat
    Window(40,12,51,19);
    For I := 1 to 7 do If KArray[I] <> '' then
                          begin
                            If I = Sx then Color(Tfn,Utx)
                                      else Color(Sfn,Stx);
                            GotoXY(1,I); Writeln(' ',Copy(KArray[I],5,2),'/',
                                                     Copy(KArray[I],1,4),' ',
                                                     Copy(KArray[I],7,1),' ');
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
                                TTNo := KArray[1];
                                SearchAnt4 ( Root4 );
                                If RC = 'S' then
                                   begin
                                     For I := 7 downto 2
                                     do ArrayParaArrayS((I-1),I);
                                     MoveParaArrayS(1);
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
                                TTNo := KArray[R];
                                RC   := 'N';
                                SearchPos4 ( Root4 );
                                If RC = 'S' then
                                   begin
                                     For I := 2 to 7
                                     do ArrayParaArrayS(I,(I - 1));
                                     MoveParaArrayS(R);
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
  Window(1,1,80,25);
  Move(ScArrayS[1],Mem[$B800:0000],4000);
  Color(Tfn,Utx);
  If Cont = #13 then
     begin
       TTAN := RArray[Sx];
       TTAC := KArray[Sx];
     end
     else TTAC := '';
end;


Procedure SelecionaTabela;
begin
  MM := 0;
  AA := 0;
  Sq := '1';
  TTNo := '';
  TTAC := '';
  Repeat
    TC := 'N';
    ScrollTabl;
    If TTAC <> '' then
       begin
         TTNo := TTAC;
         SearchTree4 (Root4);
         If RC = 'S' then
            begin
              ReadWrite(#03,'R','N',TTNumber);
              Val(Copy(TTMember.AnoMesSeq,1,4),AA,E);
              Val(Copy(TTMember.AnoMesSeq,5,2),MM,E);
              Sq := TTMember.AnoMesSeq[7];
              GotoXY(12,09); Write(MM:2,' ',PushLeft(10,ArrayMesEx[MM]));
              MMFx := 'M' + QQStr(MM,2,'0');
              GotoXY(12,10); Write(AA);
              AAFx := QQStr(AA,4,'0');
              GotoXY(12,11); Case Sq of
                                  '1' : Write('1¶ vers∆o           ');
                                  '2' : Write('2¶ vers∆o           ');
                                  '.' : Write('1¶ vers∆o (Exclu°do)');
                                  ':' : Write('2¶ vers∆o (Exclu°do)');
                             end;
              TC := 'S';
            end;
       end
       else begin
              Color(Tfn,Utx);
              GotoXY(12,09); Write(ConstStr(' ',20));
              GotoXY(12,10); Write(ConstStr(' ',20));
              GotoXY(12,11); Write(ConstStr(' ',20));
            end;
    If TC = 'N' then RecebeTabl;
    If TC = 'S' then
       begin
         Move(Mem[$B800:0000],ScArray6[1],4000);
         YY := 1;
         Repeat
           RetMenuAuxiliar(3,13,11,1,6);
           Move(Mem[$B800:0000],ScArray5[1],4000);
           Case YY of
                1  : begin
                       Titulo := 'Tabela de I.N.S.S.                          ';
                       Op     := '1';
                     end;
                2  : begin
                       Titulo := 'Tabela de I.N.S.S.(Autonomos)               ';
                       Op     := '6';
                     end;
                3  : begin
                       Titulo := 'Tabela de Imposto de Renda na Fonte         ';
                       Op     := '2';
                     end;
                4  : begin
                       Titulo := 'Tabela de Sal†rio Fam°lia                   ';
                       Op     := '3';
                     end;
                5  : begin
                       Titulo := 'Tarifas de Vale Transporte                   ';
                       Op     := '4';
                     end;
                6  : begin
                       Titulo := 'ParÉmetros ( Gerais )                        ';
                       Op     := '5';
                     end;
                7  : begin
                       QPorta;
                       If TC = #13 then
                          begin
                            ListaTabelas;
                            Close ( LST );
                          end;
                     end;
                8  : CopiaTabl;
                9  : DeletaReativaTabl('D');
                10 : DeletaReativaTabl('R');
                11 : begin
                       TC   := #27;
                       Resp := #27;
                     end;
           end;
           If YY in [1,2,3,4,5,6] then
              begin
                TableFrame;
                Color(Red,White);
                GotoXY(68,10); Write('F3');
                Color(Red,Yellow);
                GotoXY(71,10); Write('Alterar');
                Shade(2,8,66,21,LightGray,Black);
                TitleTabl(Op);
                Move(Mem[$B800:0000],ScArray4[1],4000);
                UpdateTabl(Op);
                Resp := #13;
              end;
           Move(ScArray5[1],MemW[$B800:0000],4000);
         Until Resp = #27;
         Move(ScArray6[1],MemW[$B800:0000],4000);
         Resp := #13;
         TC   := #13;
       end;
  Until TC = #27;
end;


end.

