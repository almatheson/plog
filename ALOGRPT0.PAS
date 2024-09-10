{$O+,F+}
Unit AlogRpt0;

Interface

Uses Crt,Dos,AlogGlbs,AlogNavg,AlogBasP,AlogText,AlogCnta;


     Procedure MarkBlue;
     Procedure MessageReport;
     Procedure PedeLFReport;
     Procedure PedeContaRazao;
     Procedure PedeMesPeC;
     Procedure HeaderReportSetUp;
     Procedure HeaderReport;
     Procedure HeaderAnualReport;
     Procedure EntryAssinatura;
     Procedure ImprimeTexto(X : Char);


Implementation

Var
  L1,L2,L3,L4,L5,La  : AnyStr;


Procedure MarkBlue;
begin
  Color(Blue,Cyan);
  GotoXY(1,23); Write(ConstStr(' ',80));
end;


Procedure MessageReport;
begin
  Case ProcNo of
       1,3,5..13,16,17 : DrawBox(27,11,68,20,Sfn,'S');
       2               : DrawBox(06,11,67,20,Sfn,'S');
       4               : DrawBox(21,11,57,20,Sfn,'S');
  end;
  Color(Bfn,Btx);
  Case ProcNo of
       1,6..10,16 : begin
                      GotoXY(27,11);
                      Write('                  Contas                  ');
                    end;
       3,11..13,17 : begin
                       GotoXY(27,11);
                       Write('              Departamentos               ');
                     end;
       2 : begin
             GotoXY(6,11);
             Write('                          Hist¢ricos                          ');
           end;
       4 : begin
             GotoXY(21,11);
             Write('               Indices               ');
           end;
       5 : begin
             GotoXY(27,11);
             Write('                  Lotes                   ');
           end;
  end;
  Color(Sfn,Stx);
  Case ProcNo of
       1,3,5..13,16,17 : begin
                           Window(28,13,68,20);
                           GotoXY(1,8);
                         end;
       2 : begin
             Window(07,13,67,20);
             GotoXY(1,8);
           end;
       4 : begin
             Window(22,13,57,20);
             GotoXY(1,8);
           end;
  end;
end;


Procedure PedeMes(Y : Integer);
begin
  If M1 = 0 then J := ''
     else begin
            Str(M1:2,J);
            J := LeftAdjust(J);
          end;
  GotoXY(12,Y); Write(' ':10);
  InputStr(J,2,12,Y,0,'S','N','T','N',Tfn,Utx);
  If J = '' then J := '1';
  If (TC <> #27) and
     (J  <> '' ) then
     begin
       Val(J,M1,E);
       If (M1 < 1 ) or
          (M1 > 12) then
          begin
            ErroMsg := 'Mˆs de in¡cio do relat¢rio inv lido';
            ErrorMessage;
            K := K - 1;
          end
          else begin
                 GotoXY(12,Y); Write(ArrayMesEx[M1]);
               end;
     end;
end;

Procedure PedeAno(Y : Integer);
begin
  If M2 = 0 then J := ''
            else begin
                   Str(M2:2,J);
                   J := LeftAdjust(J);
                 end;
  GotoXY(12,Y); Write(' ':10);
  InputStr(J,2,12,Y,0,'S','N','T','N',Tfn,Utx);
  If J = '' then J := '12';
  If (TC <> #27) and
     (J  <> '' ) then
     begin
       Val(J,M2,E);
       If (M2 < M1) or
          (M2 > 12) then
          begin
            ErroMsg := 'Mˆs do final do relat¢rio inv lido';
            ErrorMessage;
            K := K - 1;
          end
          else begin
                 GotoXY(12,Y); Write(ArrayMesEx[M2]);
               end;
     end;
end;


Procedure PedeLFReport;
begin
  Color(Tfn,Ttx);
  GotoXY(4,09); Write('Livro.:');
  GotoXY(4,10); Write('Folha.:');
  Case ProcNo of
       08 : begin
              GotoXY(4,15); Write('de  MM:');
              GotoXY(4,16); Write('at‚ MM:');
            end;
       09 : begin
              GotoXY(4,11); Write('T¡tulo:');
              GotoXY(4,12); Write('Zerada:');
              GotoXY(4,13); Write('Modˆlo:');
            end;
       10 : begin
              GotoXY(4,11); Write('T¡tulo:');
            end;
  end;
  Color(Tfn,Utx);
  LivroD  := 0;
  ContPag := 0;
  Tit     := '';
  Sx      := 'S';
  Modelo  := 0;
  M1      := 0;
  M2      := 0;
  Repeat
    K := 1;
    Repeat
      Case K of
           1   : begin
                   If LivroD = 0 then J := ''
                                 else begin
                                        Str(LivroD:2,J);
                                        J := LeftAdjust(J);
                                      end;
                   InputStr(J,2,14,09,0,'S','N','T','N',Tfn,Utx);
                   If TC <> #27 then
                      begin
                        If J = '' then
                           begin
                             LivroD := 1;
                             GotoXY(14,09); Write(LivroD:2);
                           end
                           else begin
                                  Val(J,LivroD,E);
                                  If LivroD = 0 then
                                     begin
                                       ErroMsg := 'N£mero do Livro ' +
                                                  'Inv lido';
                                       ErrorMessage;
                                       K := K - 1;
                                     end
                                     else begin
                                            GotoXY(14,09); Write(LivroD:2);
                                          end;
                                end;
                      end;
                 end;
           2   : begin
                   If ContPag = 0 then J := ''
                                else begin
                                       Str(ContPag:4,J);
                                       J := LeftAdjust(J);
                                     end;
		   InputStr(J,4,12,10,0,'S','N','T','N',Tfn,Utx);
                   If TC <> #27 then
                      begin
                        If J = '' then
                           begin
                             ContPag := 1;
                             GotoXY(12,10); Write(ContPag:4);
                           end
                           else begin
                                  Val(J,ContPag,E);
                                  If ContPag = 0 then
                                     begin
                                       ErroMsg := 'N£mero da Folha Inv lido';
                                       ErrorMessage;
                                       K := K - 1;
                                     end
                                     else begin
                                            GotoXY(12,10); Write(ContPag:4);
                                          end;
                                end;
                      end;
                 end;
           3   : If (ProcNo = 09) or
                    (ProcNo = 10) then
                    begin
                      J := Tit;
		      InputStr(J,45,12,11,0,'S','S','T','N',Tfn,Utx);
                      If TC <> #27 then
                         begin
                           If J = '' then
                              begin
                                Str(AA,Tit);
                                Case ProcNo of
                                     09 : Tit := 'Balan‡o Patrimonial encerrado em ' +
                                                 ArrayMesEx[MM] + '/' + Tit;
                                     10 : Tit := 'Apura‡„o de Resultados em ' +
                                                 ArrayMesEx[MM] + ' de ' + Tit;
                                end;
                                GotoXY(12,11); Write(Tit);
                                K := K - 1;
                              end
                              else Tit := J;
                         end;
                    end;
           4   : If ProcNo = 09 then
                    begin
                      J := Sx;
		      InputStr(J,1,12,12,0,'S','N','T','N',Tfn,Utx);
                      If TC <> #27 then
                         begin
                           GotoXY(12,12);
                           Case UpCase(J[1]) of
                             'S' : begin
                                     Write('Sim imprimir contas Zeradas    ');
                                     Sx := 'S';
                                   end;
                             'N' : begin
                                     Write('N„o imprimir contas Zeradas');
                                     Sx := 'N';
                                   end;
                             else begin
                                    ErroMsg := 'Imprimir contas com saldo Zero (S ou N)';
                                    ErrorMessage;
                                    K := K - 1;
                                  end;
                           end;
                         end;
                    end;
           5   : If ProcNo = 09 then
                    begin
                      Move(MemW[$B800:0000],ScArray5[1],4000);
                      DrawBox(23,15,57,19,Red,'S');
                      Color(Red,Cyan);
                      GotoXY(23,15); Write(' de 1 a 5 de acordo com o definido ');
                      GotoXY(23,16); Write(' no Plano de Contas no campo Balan ');
                      GotoXY(23,17); Write(' ‡o, ‚ poss¡vel  criar at‚ 5 tipos ');
                      GotoXY(23,18); Write(' diferentes   de  Balan‡os,  basta ');
                      GotoXY(23,19); Write(' especificar no Plano de Contas.   ');
                      Color(Tfn,Utx);
                      If Modelo = 0 then J := '1'
                                    else begin
                                           Str(Modelo:1,J);
                                           J := LeftAdjust(J);
                                         end;
                      InputStr(J,1,12,13,0,'S','N','T','N',Tfn,Utx);
                      If TC <> #27 then
                         begin
                           If J[1] in ['1','2','3','4','5'] then
                              begin
                                Val(J[1],Modelo,E);
                              end
                              else begin
                                     ErroMsg := 'Responda de 1 at‚ 5';
                                     ErrorMessage;
                                     K := K - 1;
                                   end;
                           Move(ScArray5[1],Mem[$B800:0000],4000);
                           GotoXY(12,13); Write(Modelo);
                         end;
                    end;
           6   : If ProcNo = 08 then PedeMes(15);
           7   : If ProcNo = 08 then PedeAno(16);
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 8) or (TC = #27);
    If TC <> #27 then Confirma;
  Until (TC = 'S') or (TC = #27);
end;


Procedure PedeContaRazao;
begin
  Color(Tfn,Ttx);
  GotoXY(4,12); Write('1¦ Cta:');
  GotoXY(4,13); Write('Ul.Cta:');
  GotoXY(4,15); Write('de  MM:');
  GotoXY(4,16); Write('at‚ MM:');
  GotoXY(4,18);
  If CMstMember.TipoE = 'L' then Write('1§ mˆs:');
  GotoXY(4,19); Write('A ou M:');
  P        := 0;
  M1       := 0;
  M2       := 0;
  ContaI   := '';
  UltConta := '';
  TipR     := 'M';
  Repeat
    K := 1;
    Repeat
      Case K of
           1   : begin
                   Color(Blue,White);
                   GotoXY(1,24); Write(ConstStr(' ',80));
                   GotoXY(2,24); Write('F1');
                   Color(Blue,Cyan);
                   GotoXY(5,24); Write('para pesquisar Contas');
                   J := ContaI;
                   Color(Tfn,Utx);
                   GotoXY(12,12); Write(ConstStr(' ',40));
		   InputStr(J,18,12,12,0,'S','N','T','N',Tfn,Utx);
                   LimpaLn(24,Tfd);
                   If TC <> #27 then
                      Case TC of
                           #13 : If J <> '' then
                                    begin
                                      ContaNo := LimpaChave(J);
                                      SearchTree1 ( Root1 );
                                      If RC = 'S' then
                                         begin
                                           ReadWrite(#03,'R','N',ContaNumber);
                                           ContaI := ContaNo;
                                           GotoXY(12,12);
                                           Write(ContaMember.OrigConta,' ',
                                                 PushLeft(31,Copy(ContaMember.Descricao,1,30)));
                                         end
                                         else begin
                                                ErroMsg := 'Conta n„o Existe';
                                                ErrorMessage;
                                                K := K - 1;
                                              end;
                                    end
                                    else If J = '' then
                                            begin
                                              GotoXY(12,12); Write('** Todas as Contas');
                                              GotoXY(12,13); Write(ConstStr(' ',40));
                                              ContaI := '';
                                            end;
                           #21 : begin
                                   ContaAC := LimpaChave(J);
                                   ContaNo := ContaAC;
                                   ScrollConta('C');
                                   ContaI := ContaAC;
                                 end;
                      end;
                 end;
           2   : begin
                   Color(Blue,White);
                   GotoXY(1,24); Write(ConstStr(' ',80));
                   GotoXY(2,24); Write('F1');
                   Color(Blue,Cyan);
                   GotoXY(5,24); Write('para pesquisar Contas');
                   J := UltConta;
                   Color(Tfn,Utx);
                   GotoXY(12,13); Write(ConstStr(' ',40));
		   InputStr(J,18,12,13,0,'S','N','T','N',Tfn,Utx);
                   LimpaLn(24,Tfd);
                   If TC <> #27 then
                      Case TC of
                           #13 : If J <> '' then
                                    begin
                                      ContaNo := LimpaChave(J);
                                      SearchTree1 ( Root1 );
                                      If RC = 'S' then
                                         begin
                                           If ContaNo < ContaI then
                                              begin
                                                ErroMsg := 'Conta Fim Menor';
                                                ErrorMessage;
                                                K := K - 1;
                                              end
                                              else begin
                                                     ReadWrite(#03,'R','N',ContaNumber);
                                                     UltConta := ContaNo;
                                                     GotoXY(12,13);
                                                     Write(ContaMember.OrigConta,' ',
                                                           PushLeft(31,Copy(ContaMember.Descricao,1,30)));
                                                   end;
                                         end
                                         else begin
                                                ErroMsg := 'Conta n„o Existe';
                                                ErrorMessage;
                                                K := K - 1;
                                              end;
                                    end
                                    else If J = '' then
                                            begin
                                              GotoXY(12,13); Write('** At‚ o Fim      ');
                                              UltConta := '999999999999999';
                                            end;
                           #21 : begin
                                   ContaAC := LimpaChave(J);
                                   ContaNo := ContaAC;
                                   ScrollConta('C');
                                   UltConta := ContaAC;
                                 end;
                      end;
                 end;
           3   : PedeMes(15);
           4   : PedeAno(16);
           5   : If CMstMember.TipoE = 'L' then
                    begin
                      If P = 0 then J := ''
                               else begin
                                      Str(P:2,J);
                                      J := LeftAdjust(J);
                                    end;
                      GotoXY(12,18); Write(ConstStr(' ',10));
		      InputStr(J,2,12,18,0,'S','N','T','N',Tfn,Utx);
                      If J = '' then J := '0';
                      If (TC <> #27) and (J <> '') then
                         begin
                           Val(J,P,E);
                           If (P < 01) or (P > 12) then
                              begin
                                ErroMsg := 'Primeiro Mˆs inv lido';
                                ErrorMessage;
                                K := K - 1;
                              end
                              else begin
                                     GotoXY(12,18); Write(ArrayMesEx[P]);
                                   end;
                         end;
                    end;
           6   : begin
                   J := TipR;
                   GotoXY(12,19); Write(ConstStr(' ',10));
	 	   InputStr(J,1,12,19,0,'S','N','T','N',Tfn,Utx);
                   If J = '' then J := 'M';
                   If TC <> #27 then
                      begin
                        TipR := UpCase(J[1]);
                        GotoXY(12,19);
                        Case TipR of
                             'A' : Write('Anual ');
                             'M' : Write('Mensal');
                             else begin
                                    ErroMsg := 'Informe o Tipo (A ou M)';
                                    ErrorMessage;
                                    K := K - 1;
                                  end;
                        end;
                      end;
                 end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 7) or (TC = #27);
    If TC <> #27 then Confirma;
  Until TC in [#27,'S'];
end;


Procedure PedeMesPeC;
begin
  Color(Tfn,Ttx);
  GotoXY(4,11); Write('Mˆs(P):');
  GotoXY(4,12); Write('Mˆs(C):');
  Color(Tfn,Utx);
  MP := 0;
  MC := 0;
  Repeat
    K := 1;
    Repeat
      Case K of
           1   : begin
                   If MP = 0 then J := ''
                             else begin
                                    Str(MP:2,J);
                                    J := LeftAdjust(J);
                                  end;
		   InputStr(J,2,14,11,0,'S','N','T','N',Tfn,Utx);
                   If J = '' then MP := MM
                             else Val(J,MP,E);
                   If TC <> #27 then
                      begin
                        If (MP < 1) or (MP > 12) then
                           begin
                             ErroMsg := 'Mˆs Inv lido';
                             ErrorMessage;
                             K := K - 1;
                           end
                           else begin
                                  GotoXY(14,11); Write(PushLeft(25,ArrayMesEx[MP]));
                                end;
                      end;
                 end;
           2   : begin
                   If MC = 0 then J := ''
                             else begin
                                    Str(MC:2,J);
                                    J := LeftAdjust(J);
                                  end;
		   InputStr(J,2,14,12,0,'S','N','T','N',Tfn,Utx);
                   If J = '' then MC := 0
                             else Val(J,MC,E);
                   If TC <> #27 then
                      begin
                        If (MC < 1) or (MC > 12) or (MC = MP) then
                           begin
                             ErroMsg := 'Mˆs Inv lido';
                             ErrorMessage;
                             K := K - 1;
                           end
                           else begin
                                  GotoXY(14,12); Write(PushLeft(25,ArrayMesEx[MC]));
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
  Until TC in [#27,'S'];
end;


Procedure HeaderReportSetUp;
begin
  L2 := '';
  L3 := '';
  L4 := '';
  L5 := '';
  Str(AA:4,La);
  Case ProcNo of
       02 : L2 := Nx+'HISTORICO PADRAO'+Nf+
                  ConstStr(' ',T-30)+'Data: '+XDia+'/'+XMes+'/'+XAno;
       03 : L2 := Nx+'DEPARTAMENTOS  '+Nf+
                  ConstStr(' ',T-29)+'Data: '+
                  XDia+'/'+XMes+'/'+XAno;
       04 : L2 := Nx+'INDICES ECONOMICOS'+Nf+
                  ConstStr(' ',T-32)+'Data: '+
                  XDia+'/'+XMes+'/'+XAno;
       05 : L2 := Nx+'CONTROLE DE LOTES em '+
                  Acentua(ArrayMesEx[MM])+'/'+
                  La+Nf+
                  ConstStr(' ',10-Length(ArrayMesEx[MM]))+
                  ConstStr(' ',T-48)+'Data: '+
                  XDia+'/'+XMes+'/'+XAno;
       11 : L2 := Nx+'ORCAMENTO de DESPESAS'+Nf+
                  ConstStr(' ',T-35)+'Data: '+XDia+'/'+XMes+'/'+XAno;
       12 : L2 := Nx+'ACOMPANHAMENTO de DESPESAS de '+
                  Acentua(ArrayMesEx[MM])+'/'+
                  La+Nf+
                  ConstStr(' ',10-Length(ArrayMesEx[MM]))+
                  ConstStr(' ',T-57)+'Data: '+XDia+'/'+XMes+'/'+XAno;
       13 : L2 := Nx+'MOVIMENTO de CONTAS por DEPARTAMENTO '+
                  Acentua(ArrayMesEx[MM])+'/'+
                  La+Nf+
                  ConstStr(' ',10-Length(ArrayMesEx[MM]))+
                  ConstStr(' ',T-64)+'Data: '+XDia+'/'+XMes+'/'+XAno;
       15 : L2 := Nx+'BALANCETE GERENCIAL COMPARATIVO - 19'+
                  La+Nf+
                  ConstStr(' ',T-52)+'Data: '+XDia+'/'+XMes+'/'+XAno;
       16 : L2 := Nx+'BALANCETE por DEPARTAMENTO 19'+
                  La+Nf+
                  ConstStr(' ',T-45)+'Data: '+XDia+'/'+XMes+'/'+XAno;
       17 : L2 := Nx+'ACOMPANHAMENTO DE PROJETOS 19'+
                  La+Nf+
                  ConstStr(' ',T-45)+'Data: '+XDia+'/'+XMes+'/'+XAno;
  end;
  If XMo = 'S' then L3 := ConstStr(' ',T-19)+'Relat¢rio em '+NMo
               else L3 := ' ';
  Case ProcNo of
       02 : L4 := 'C¢d.   Descri‡„o';
       03 : L4 := 'C¢digo   Nome do Local'+ConstStr(' ',20)+
                  'Nome do Departamento'+ConstStr(' ',12)+'Status';
       04 : If T = 80 then
               begin
                 L4 := 'Cd Descr. T ---Janeiro -Fevereiro'+
                       ' -----Mar‡o -----Abril ------Maio -----Junho';
                 L5 := ConstStr(' ',12)+'-----Julho ----Agosto --Setembro '+
                       '---Outubro --Novembro --Dezembro';
               end
               else begin
                      L4 := '  Cd    Descr.    T      ---Janeiro   '+
                            '    -Fevereiro       -----Mar‡o       '+
                            '-----Abril       ------Maio       -----Junho';
                      L5 := '                         -----Julho'+
                            '       ----Agosto       --Setembro'+
                            '       ---Outubro       --Novembro'+
                            '       --Dezembro';
                    end;
       05 : If T = 80
               then L4 := 'C¢digo'+ConstStr(' ',3)+
                          'Tip Sta  Abertura  ------- D‚bitos'+
                          ' ------- ------- Cr‚ditos ------ Obs'
               else L4 := ConstStr(' ',26)+'C¢digo'+ConstStr(' ',3)+
                          'Tip Sta  Abertura  ------- D‚bitos'+
                          ' ------- ------- Cr‚ditos ------ Obs';
       11 : begin
              L4 := 'C¢digo Nome do Departamento';
              If T = 80 then L5 := ConstStr(' ',7)+Cx+'Conta'+
                                   ConstStr(' ',14)+'Descri‡„o'+
                                   ConstStr(' ',34)+'Indice'+
                                   ConstStr(' ',3)+'Meses'+
                                   ConstStr(' ',19)+'Valor'+Cf
                        else L5 := ConstStr(' ',7)+'Conta'+
                                   ConstStr(' ',14)+'Descri‡„o'+
                                   ConstStr(' ',34)+'Indice'+
                                   ConstStr(' ',3)+'Meses'+
                                   ConstStr(' ',19)+'Valor';
            end;
       12 : begin
              L4 := 'C¢digo Nome do Departamento';
              If T = 80 then L5 := ConstStr(' ',7)+Cx+'Conta'+
                                   ConstStr(' ',14)+'Descri‡ao'+
                                   ConstStr(' ',40)+'Valor Or‡ado'+
                                   ConstStr(' ',8)+'Valor Gasto'+
                                   ConstStr(' ',2)+'Var.%'+Cf
                        else L5 := ConstStr(' ',7)+'Conta'+
                                   ConstStr(' ',14)+'Descri‡ao'+
                                   ConstStr(' ',40)+'Valor Or‡ado'+
                                   ConstStr(' ',8)+'Valor Gasto'+
                                   ConstStr(' ',2)+'Var.%';
            end;
       13 : If T = 80
               then L4 := 'DD Conta     Descri‡„o             '+
                          '                D‚bito  Cr‚dito      Saldo'
               else L4 := 'DD C¢digo da Conta    Descri‡„o da Conta'+
                          ConstStr(' ',43)+'D‚bito'+
                          ConstStr(' ',10)+'Cr‚dito'+
                          ConstStr(' ',10)+'Saldo';
       15 : If T = 80
               then L4 := Cx+'Conta'+ConstStr(' ',14)+
                          'Descri‡„o da Conta'+ConstStr(' ',20)+
                          PushRight(17,ArrayMesEx[MP])+'  '+
                          PushRight(17,ArrayMesEx[MC])+ConstStr(' ',11)+
                          'Varia‡„o    %Horiz.      %Vert..'+Cf
               else L4 := 'Conta'+ConstStr(' ',14)+
                          'Descri‡„o da Conta'+ConstStr(' ',20)+
                          PushRight(17,ArrayMesEx[MP])+'  '+
                          PushRight(17,ArrayMesEx[MC])+ConstStr(' ',11)+
                          'Varia‡„o   %Horiz.   %Vert..';
       16 : begin
              If T = 80 then
                 begin
                   L4 := 'Departamento';
                   L5 := Cx+PushLeft(19,'Conta')+
                         PushLeft(42,'Descri‡„o')+
                         PushRight(16,ArrayMesEx[MM])+' '+
                         PushRight(16,'Acumulado')+' '+
                         PushRight(16,ArrayMesEx[MM])+' '+
                         PushRight(16,'Acumulado')+Cf;
                 end
                 else begin
                        L4 := 'Departamento';
                        L5 := PushLeft(19,'Conta')+
                              PushLeft(42,'Descri‡„o')+
                              PushRight(16,'Acumulado')+' '+
                              PushRight(16,ArrayMesEx[MM])+' '+
                              PushRight(16,'Acumulado')+' '+
                              PushRight(16,ArrayMesEx[MM]);
                      end;
            end;
       17 : begin
              If T = 80 then
                 begin
                   L4 := Cx+PushLeft(46,'Conta')+
                         'Janeiro     Fevereiro         Marco         Abril          Maio         Junho'+Cf;
                   L5 := Cx+ConstStr(' ',46)+
                         '  Julho        Agosto      Setembro       Outubro      Novembro      Dezembro        Total'+Cf;
                 end
                 else begin
                        L4 := PushLeft(46,'Conta')+
                              'Janeiro     Fevereiro         Marco         Abril          Maio         Junho';
                        L5 := ConstStr(' ',46)+
                              '  Julho        Agosto      Setembro       Outubro      Novembro       Dezembro        Total';
                      end;
            end;
  end;
end;


Procedure HeaderReport;
begin
  If ContLin < 1000 then Footer;
  ContPag := ContPag + 1;
  With CMstMember do
  begin
    If Laser in ['D','L']
       then WriteLine('W',LaserInit)
       else If ContLin < 1000
               then If Laser = 'N' then WriteLine('W',Qp)
                       else If Laser = 'X' then WriteLine('L',Qp);
    L1      := Dx+Acentua(Descricao)+Df;
    ContLin := 0;
    WriteLine('L',L1);
    WriteLine('L',ConstStr('-',T));
    WriteLine('L',Cx+Acentua(Endereco)+', '+Acentua(Cidade)+', '+Estado+
                 '  Cep: '+Cep+Cf);
  end;
  WriteLine('L',ConstStr(' ',T-14)+'Pag.: '+PushRight(8,EditInteger(Contpag)));
  WriteLine('L',Acentua(L2));
  WriteLine('L',Acentua(L3));
  WriteLine('L',ConstStr('-',T));
  If L4 <> '' then WriteLine('L',Acentua(L4));
  If L5 <> '' then WriteLine('L',Acentua(L5));
  WriteLine('L',ConstStr('-',T));
  WriteLine('L',' ');
end;


Procedure HeaderAnualReport;
begin
  Str(AA:4,La);
  If ContLin < 1000 then Footer;
  ContPag := ContPag + 1;
  With CMstMember do
  begin
    If Laser in ['D','L']
       then WriteLine('W',LaserInit)
       else If ContLin < 1000
               then If Laser = 'N' then WriteLine('W',Qp)
                       else If Laser = 'X' then WriteLine('L',Qp);
    L1      := Dx+Acentua(Descricao)+Df;
    ContLin := 0;
    WriteLine('L',L1);
    WriteLine('L',ConstStr('-',T));
    WriteLine('L',Cx+Acentua(Endereco)+', '+Acentua(Cidade)+', '+
                  Estado+'  Cep: '+Cep+'  Tel. '+Telefone+Cf);
    WriteLine('L',ConstStr(' ',T-11)+'Folha: '+Nx+PushRight(4,EditInteger(Contpag))+Nf);
    Case ProcNo of
         01 : WriteLine('L',Nx+'PLANO DE CONTAS'+Nf+
                            ConstStr(' ',T-26)+'Livro: '+Nx+
                            PushRight(4,EditInteger(LivroD))+Nf);
         06 : Case TipR of
                   'A' : WriteLine('L',Nx+Acentua('RAZAO ANALITICO')+
                                   ConstStr(' ',T-28)+'Livro: '+Nx+
                                   PushRight(4,EditInteger(LivroD))+Nf);
                   'M' : WriteLine('L',Nx+Acentua('RAZAO ANALITICO de ')+
                                   Acentua(ArrayMesEx[MM])+'/'+
                                   La+Nf+
                                   ConstStr(' ',10-Length(ArrayMesEx[MM]))+
                                   ConstStr(' ',T-45)+'Livro: '+Nx+
                                   PushRight(4,EditInteger(LivroD))+Nf);
              end;
         07 : WriteLine('L',Nx+'BALANCETE de '+
                            Acentua(ArrayMesEx[MM])+'/'+
                            La+Nf+
                            ConstStr(' ',10-Length(ArrayMesEx[MM]))+
                            ConstStr(' ',T-39)+'Livro: '+Nx+
                            PushRight(4,EditInteger(LivroD))+Nf);
         08 : WriteLine('L',Nx+Acentua('LIVRO DIARIO do mˆs de ')+
                            Acentua(ArrayMesEx[MM])+'/'+
                            La+Nf+
                            ConstStr(' ',10-Length(ArrayMesEx[MM]))+
                            ConstStr(' ',T-49)+'Livro: '+Nx+
                            PushRight(4,EditInteger(LivroD))+Nf);
         09,10 : WriteLine('L',Nx+Acentua(Tit)+
                               ConstStr(' ',46-Length(Tit))+Nf+
                               ConstStr(' ',T-59)+'Livro: '+Nx+
                               PushRight(4,EditInteger(LivroD))+Nf);
    end;
    If XMo = 'S' then WriteLine('L',Acentua('Relat¢rio em ')+Acentua(NMo))
                 else WriteLine('L',' ');
    WriteLine('L',ConstStr('-',T));
    Case ProcNo of
         01 : begin
                If T = 80 then
                   begin
                     WriteLine('L',Cx+ConstStr(' ',68)+'GTGAADGCP'+
                                   ConstStr(' ',50)+'S'+Cf);
                     WriteLine('L',Cx+ConstStr(' ',68)+'RPRCVPEOE'+
                                   ConstStr(' ',50)+'T'+Cf);
                     WriteLine('L',Cx+'Conta'+ConstStr(' ',14)+
                                   Acentua('Descri‡„o')+ConstStr(' ',40)+
                                   'POATSTNRR In Contra-Partida'+
                                   ConstStr(' ',7)+Acentua('Conta de Corre‡„o')+
                                   ConstStr(' ',4)+'His A  Rdz'+Cf);
                   end
                   else begin
                          WriteLine('L',ConstStr(' ',68)+'GTGAADGCP'+
                                        ConstStr(' ',46)+'S');
                          WriteLine('L',ConstStr(' ',68)+'RPRCVPEOE'+
                                        ConstStr(' ',46)+'T');
                          WriteLine('L','Conta'+ConstStr(' ',14)+
                                        Acentua('Descri‡„o')+
                                        ConstStr(' ',40)+
                                        'POATSTNRR In Contra-Partida'+
                                        ConstStr(' ',5)+Acentua('Corre‡„o')+
                                        ConstStr(' ',11)+'His A  Rdz');
                        end;
                WriteLine('L',ConstStr('-',T));
              end;
         06 : begin
                If T = 80
                   then WriteLine('L',Cx+ConstStr(' ',6)+'Dia  Documento   '+
                                      Acentua('Hist¢rico')+
                                      ConstStr(' ',60)+
                                      Acentua('D‚bito        Cr‚dito')+
                                      ConstStr(' ',13)+'Saldo'+Cf)
                   else WriteLine('L','DD Documento   '+
                                      Acentua('Hist¢rico')+ConstStr(' ',64)+
                                      Acentua('D‚bito')+ConstStr(' ',12)+
                                      Acentua('Cr‚dito')+ConstStr(' ',14)+
                                      'Saldo');
                WriteLine('L',ConstStr('-',T));
              end;
         07 : begin
                If T = 80 then WriteLine('L',Cx+'Conta'+ConstStr(' ',14)+
                                             'Descri‡„o da Conta'+
                                             ConstStr(' ',26)+'Saldo Anterior'+
                                             ConstStr(' ',4)+
                                             'Total do D‚bito'+ConstStr(' ',3)+
                                             'Total do Cr‚dito'+ConstStr(' ',13)+'Saldo'+Cf)
                          else WriteLine('L','Conta'+ConstStr(' ',14)+
                                             'Descri‡„o da Conta'+
                                             ConstStr(' ',26)+
                                             'Saldo Anterior'+ConstStr(' ',12)+
                                             'D‚bito'+ConstStr(' ',10)+
                                             'Cr‚dito'+ConstStr(' ',13)+'Saldo');
                WriteLine('L',ConstStr('-',T));
              end;
         08 : begin
                If T = 80
                   then WriteLine('L',Cx+'DD'+' '+Acentua('C¢digo da Conta')+
                                  ConstStr(' ',4)+Acentua('Descricao(Abreviada)')+
                                  ' '+Acentua('Historico do Lancamento')+
                                  ConstStr(' ',48)+Acentua('D‚bito')+
                                  ConstStr(' ',10)+Acentua('Cr‚dito')+Cf)
                   else WriteLine('L',Acentua('DD C¢digo da Conta   ')+
                                      '  LOTExLANC '+
                                      Acentua('Hist¢rico do Lan‡amento')+
                                      ConstStr(' ',50)+Acentua('D‚bito')+
                                      ConstStr(' ',12)+Acentua('Cr‚dito'));
                WriteLine('L',ConstStr('-',T));
              end;
         09 : begin
                If T = 80
                   then WriteLine('L',ConstStr(' ',16)+Nx+'ATIVO'+Nf+
                                  ConstStr(' ',33)+ Nx+'PASSIVO'+Nf)
                   else WriteLine('L',Nx+ConstStr(' ',25)+'ATIVO'+
                                      Nf+ConstStr(' ',62)+Nx+'PASSIVO'+Nf);
                WriteLine('L',ConstStr('-',T));
              end;
         10 : WriteLine('L',' ');
    end;
    WriteLine('L',' ');
  end;
end;


Procedure EntryAssinatura;
begin
  Color(Tfn,Ttx);
  GotoXY(4,14);  Write('Cargo.:');
  GotoXY(4,15);  Write('Nome..:');
  GotoXY(4,16);  Write('Cargo.:');
  GotoXY(4,17);  Write('Nome..:');
  Titulo1   := '';
  Assin1    := '';
  Titulo2   := '';
  Assin2    := '';
  Repeat
    K := 1;
    Repeat
    Case K of
         1   : begin
                 J := Titulo1;
		 InputStr(J,35,12,14,0,'S','S','T','N',Tfn,Utx);
                 If TC <> #27 then Titulo1 := J;
               end;
         2   : begin
                 J := Assin1;
		 InputStr(J,35,12,15,0,'S','S','T','N',Tfn,Utx);
                 If TC <> #27 then Assin1 := J;
               end;
         3   : begin
                 J := Titulo2;
		 InputStr(J,35,12,16,0,'S','S','T','N',Tfn,Utx);
                 If TC <> #27 then Titulo2 := J;
               end;
         4   : begin
                 J := Assin2;
		 InputStr(J,35,12,17,0,'S','S','T','N',Tfn,Utx);
                 If TC <> #27 then Assin2 := J;
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


Procedure ImprimeTexto(X : Char);
Var
  RegLst,Regtxt : AnyStr;
begin
  If DskRpt = 'N' then If Laser <> 'N' then WriteLine('W',LaserInit);
  While (not Eof(TxtFile)) and (TC <> #27) do
  begin
    {$I-}
    Readln(TxtFile,RegTxt);
    {$I+}
    If IOResult = 0 then
       begin
         TC     := #13;
         RegLst := Substitui(RegTxt);
         Case X of
              'S' : Case TC of
                         #13 : WriteLine('L',Acentua(RegLst));
                         else  WriteLine('W',Acentua(RegLst));
                    end;
              'N' : Case TC of
                         #13 : WriteLine('L',RegLst);
                         else  WriteLine('W',RegLst);
                    end;
         end;
       end;
  end;
  Reset ( TxtFile );
  TC := #13;
end;


end.
