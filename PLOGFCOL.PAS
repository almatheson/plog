{$O+,F+}
Unit PlogFCol;

Interface

Uses Crt,Dos,PlogGlbs,PlogBasp,PlogTree,PlogFunc;

   Procedure FeriasColetivas;
   Procedure FaltasNJustificadas;

Implementation


Procedure DataFaltas;
begin
  Color(Tfn,Ttx);
  GotoXY(04,10); Write('Nome..:');
  GotoXY(04,12); Write('Cargo.:');
  GotoXY(04,13); Write('Status:');
  GotoXY(04,15); Write('Tipo..:');
  GotoXY(04,16); Write('Sal r.:');
  GotoXY(04,18); Write('Faltas:');

  Color(Tfn,Utx);
  GotoXY(12,09); Write(PushLeft(9,EEMember.Matricula));
  GotoXY(12,10); Write(PushLeft(41,EEMember.Nome));
  GotoXY(12,12); Write(PushLeft(20,EEMember.Cargo));

  GotoXY(12,13);
  Case EEMember.Status of
       'A' : Write('Ativo      ');
       'P' : Write('Dem.Espont.');
       'D' : Write('Demitido   ');
       'J' : Write('Justa Causa');
       'N' : Write('T‚rm.Contr.');
       'R' : Write('Rescindido ');
       'F' : Write('F‚rias     ');
       'L' : Write('Licen‡a    ');
       'C' : Write('Acidentado ');
       'M' : Write('Morte      ');
       'T' : Write('Transferido');
       'O' : Write('Aposentado ');
       'X' : Write('Excluir Reg');
  end;

  GotoXY(12,15);
  Case EEMember.Tipo of
       'M' : Write('Mensalista ');
       'H' : Write('Horista    ');
       'S' : Write('Semanalista');
  end;
  GotoXY(12,16); Write(EditReal(Sal):13);
end;


Procedure FaltasNJustificadas;
begin
  EENo := '';
  Repeat
    RecebeCodigo(9,'C','N');
    If EENumber <> Limite then
       With EEMember do
       begin
         ReadWrite(#08,'R','N',EENumber);
         If EEMember.Status <> 'R' then
            begin
              DataFaltas;
              Repeat
                If FaltasNJ = 0 then J := ''
                   else begin
                          Str(FaltasNJ:2,J);
                          J := LeftAdjust(J);
                        end;
                InputStr(J,2,12,18,0,'S','N','N','N',Tfn,Utx);
                Val(J,FaltasNJ,E);
                If TC <> #27 then Confirma;
              Until (TC = 'S') or (TC = #27);
              If TC = 'S' then ReadWrite(#08,'W','N',EENumber)
                          else TC := #13;
              LiberaMVDsk;
            end
            else begin
                   ErroMsg := 'Empregado esta Rescindido';
                   ErrorMessage;
                 end;
         Move(ScArray4[1],Mem[$B800:0000],4000);
         TC := #13;
       end;
  Until TC = #27;
end;


Procedure PedeColetivas;
begin
  Color(Tfn,Ttx);
  GotoXY(4,10); Write('Departamento..:');
  GotoXY(4,11); Write('Data do In¡cio:');
  GotoXY(4,12); Write('Data do Final.:');
  GotoXY(4,13); Write('N£mero de dias:');
  GotoXY(4,14); Write('Per¡odo(1.N/U):');
  GotoXY(4,15); Write('Parcial/Final.:');
  GotoXY(4,16); Write('Centavos (S/N):');

  IData := '';
  FData := '';
  DDNo  := '';
  P     := 0;
  Tr    := ' ';
  Tp    := 'P';
  XC    := 'S';

  Repeat
    K := 1;
    Repeat
      Case K of
           1  : begin
                  Color(Tfn,Utx);
                  GotoXY(20,10); Write(' ':35);
                  J := DDNo;
                  InputStr(J,3,20,10,0,'S','N','T','N',Tfn,Utx);
                  If TC <> #27 then
                     begin
                       GotoXY(20,10);
                       If J = '' then
                          begin
                            DDNo := '';
                            Write('********* Todos');
                          end
                          else begin
                                 DDNo := J;
                                 SearchTree3 ( Root3 );
                                 If RC = 'S' then
                                    begin
                                      ReadWrite(#05,'R','N',DDNumber);
                                      Write(DDNo,' ',
                                            Copy(DDMember.Descricao,1,30));
                                    end
                                    else begin
                                           ErroMsg := 'Departamento n„o Existe';
                                           ErrorMessage;
                                           K := K - 1;
                                         end;
                               end;
                     end;
                end;
           2  : begin
                  J := IData;
                  InputStr(J,8,20,11,0,'S','N','D','S',Tfn,Utx);
                  If TC <> #27 then IData := J;
                end;
           3  : begin
                  J := FData;
                  InputStr(J,8,20,12,0,'S','N','D','S',Tfn,Utx);
                  If TC <> #27 then FData := J;
                end;
           4  : begin
                  If P = 0 then J := ''
                           else begin
                                  Str(P:2,J);
                                  J := LeftAdjust(J);
                                end;
                  InputStr(J,2,20,13,0,'S','N','N','N',Tfn,Utx);
                  If TC <> #27 then
                     begin
                       Val(J,P,E);
                       If (P < 3) or (P > 30) then
                          begin
                            ErroMsg := 'N£mero de dias Inv lido';
                            ErrorMessage;
                            K := K - 1;
                          end;
                     end;
                end;
           5  : begin
                  GotoXY(20,14); Write(' ':20);
                  J := Tr;
                  InputStr(J,1,20,14,0,'S','N','T','N',Tfn,Utx);
                  If TC <> #27 then
                     begin
                       Tr := UpCase(J[1]);
                       If Tr in ['1','2','3','4','5','U'] then
                          begin
                            GotoXY(20,14);
                            Case Tr of
                                 '1'..'9' : Write(Tr,'§ per¡odo');
                                 'U'      : begin
                                              Write('Unico per¡odo');
                                              Tp := 'F';
                                              GotoXY(20,15); Write('Final  ');
                                              K := 6;
                                            end;
                            end;
                          end
                          else begin
                                 ErroMsg := 'Informe 1 a N ou U (£ltimo)';
                                 ErrorMessage;
                                 K := K - 1;
                               end
                     end;
                end;
           6  : begin
                  J := Tp;
                  InputStr(J,1,20,15,0,'S','N','T','N',Tfn,Utx);
                  If TC <> #27 then
                     begin
                       If J = ' ' then Tp := 'F'
                                  else Tp := UpCase(J[1]);
                       If Tp in ['F','P'] then
                          begin
                            GotoXY(20,15);
                            If Tp = 'P' then Write('Parcial')
                                        else Write('Final  ');
                          end
                          else begin
                                 ErroMsg := 'Informe P (parcial) ou F (final)';
                                 ErrorMessage;
                                 K := K - 1;
                               end;
                     end;
                end;
           7  : begin
                  J := XC;
                  InputStr(J,1,20,16,0,'S','N','T','N',Tfn,Utx);
                  If TC <> #27 then
                     begin
                       If J = ' ' then XC := 'S'
                                  else XC := UpCase(J[1]);
                       If XC in ['N','S'] then
                          begin
                            GotoXY(20,16);
                            If XC = 'S' then Write('Com centavos')
                                        else Write('Sem centavos');
                          end
                          else begin
                                 ErroMsg := 'Informe S ou N';
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
    Until (K = 8) or (TC = #27);
    If TC <> #27 then Confirma;
  Until (TC = 'S') or (TC = #27);
end;


Procedure CalculaPeriodo;
begin
  Case EEMember.FaltasNJ of
       00..05 : K := 1;
       06..14 : K := 2;
       15..23 : K := 3;
       24..32 : K := 4;
       else K := 0;
  end;

  If K > 0 then
     Case K of
          1 : Case R of
                   01 : R1 := 2.5;
                   02 : R1 := 5;
                   03 : R1 := 7.5;
                   04 : R1 := 10;
                   05 : R1 := 12.5;
                   06 : R1 := 15;
                   07 : R1 := 17.5;
                   08 : R1 := 20;
                   09 : R1 := 22.5;
                   10 : R1 := 25;
                   11 : R1 := 27.5;
                   12 : R1 := 30;
              end;
          2 : Case R of
                   01 : R1 := 2;
                   02 : R1 := 4;
                   03 : R1 := 6;
                   04 : R1 := 8;
                   05 : R1 := 10;
                   06 : R1 := 12;
                   07 : R1 := 14;
                   08 : R1 := 16;
                   09 : R1 := 18;
                   10 : R1 := 20;
                   11 : R1 := 22;
                   12 : R1 := 24;
              end;
          3 : Case R of
                   01 : R1 := 1.5;
                   02 : R1 := 3;
                   03 : R1 := 4.5;
                   04 : R1 := 6;
                   05 : R1 := 7.5;
                   06 : R1 := 9;
                   07 : R1 := 10.5;
                   08 : R1 := 12;
                   09 : R1 := 13.5;
                   10 : R1 := 15;
                   11 : R1 := 16.5;
                   12 : R1 := 18;
              end;
          4 : Case R of
                   01 : R1 := 1;
                   02 : R1 := 2;
                   03 : R1 := 3;
                   04 : R1 := 4;
                   05 : R1 := 5;
                   06 : R1 := 6;
                   07 : R1 := 7;
                   08 : R1 := 8;
                   09 : R1 := 9;
                   10 : R1 := 10;
                   11 : R1 := 11;
                   12 : R1 := 12;
              end;
     end;
end;


Procedure FeriasColetivas;
begin
  Move(ScArray4[1],Mem[$B800:0000],4000);
  Color(Sfn,Stx);
  GotoXY(35,08); Write(' F‚rias Coletivas         ');
  PedeColetivas;
  If TC = 'S' then
     begin
       LoadIndex6 ('D','N');
       If TC <> #27 then QPorta;
       If TC = #13 then
          begin
            Color(Bfn,Btx);
            GotoXY(01,24); Write(ConstStr(' ',80));
            GotoXY(20,24); Write('      ',#026,' Para/Continua          ',#026,
                                 ' Cancela');
            Color(Bfn,Yellow);
            GotoXY(20,24); Write('Enter');
            GotoXY(47,24); Write('Esc');
            Color(Tfn,Utx);

            DrawBox(24,11,65,20,Sfn,'S');
            Color(Bfn,Btx);
            GotoXY(24,11); Write(' Empregados Selecionados para F‚rias      ');
            Color(Sfn,Stx);
            Window(24,13,65,20);
            GotoXY(1,9);

            J := DDNo;

            If DDNo <> '' then
               begin
                 RC := 'N';
                 SearchAnt3 ( Root3 );
                 If RC = 'N' then DDNo := '';
               end;

            NCont := 0;

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

                          If (EEMember.Depto  = DDNo      ) and
                             (EEMember.Status in ['A','F']) then
                             begin
                               R1    := 0;
                               R2    := 0;
                               R3    := 0;
                               R4    := 0;
                               R5    := 0;
                               R6    := 0;
                               Valor := 0;
                               TProv := 0;
                               TDesc := 0;
                               VLiq  := 0;

                               If Tp = 'F' then
                                  begin
                                    If EEMember.PeriodoV <> 0
                                       then R := 12
                                       else R := EEMember.MesesF;

                                    If EEMember.FaltasNJ > 0
                                       then CalculaPeriodo
                                       else begin
                                              K  := 1;
                                              R1 := P;
                                            end;
                                  end
                                  else K  := 1;

                               If K > 0 then
                                  begin
                                    NCont := NCont + 1;
                                    Writeln(EEMember.Nome);

                                    EENo    := EEMember.Matricula;
                                    SalBase := Sal;

                                    R2 := (SalBase / 30) * P;
                                    R2 := TruncX(R2);

                                    R3 := R2 / 3;
                                    R3 := TruncX(R3);

                                    R4 := R2 + R3;

                                    If Tp = 'F' then
                                       begin
                                         R6 := (SalBase / 30) * (P - R1);
                                         R6 := TruncX(R6);
                                       end;

                                    I := 0;
                                    Repeat
                                      I := I + 1;
                                    Until R4 <= TTMember.FaixaIapas[I];

                                    If EEMember.Vinculo[1] <> 'N' then
                                       begin
                                         If R4 > TTMember.TetoSalContr
                                            then R4 := TTMember.TetoSalContr *
                                                       (TTMember.TaxaIapas[I]  / 100)
                                            else R4 := R4 * (TTMember.TaxaIapas[I] /  100);
                                         R4 := TruncX(R4);
                                       end
                                       else R4 := 0;


                                    VLiq := R2 + R3 - (R4 + R6);

                                    If (XC   = 'N') and
                                       (VLiq > 0  ) then
                                       begin
                                         R5 := 1 - Frac(VLiq);
                                         If (R5 > 0) and
                                            (R5 < 1) then R5 := TruncX(R5);

                                         VLiq := VLiq + TruncX(R5);
                                       end
                                       else R5 := 0;


                                    TProv := R2 + R3 + R5;
                                    TDesc := R4 + R6;

                                    CCNo := '019';
                                    YYNo := CCNo;
                                    SearchTreeY ( RootY );
                                    If RC = 'N' then LoadTreeY ( RootY );
                                    YAddress^.AcMensalV := R2;
                                    YAddress^.Origem    := 'S';

                                    CCNo := '021';
                                    YYNo := CCNo;
                                    SearchTreeY ( RootY );
                                    If RC = 'N' then LoadTreeY ( RootY );
                                    YAddress^.AcMensalV := R3;
                                    YAddress^.Origem    := 'S';

                                    CCNo := '061';
                                    YYNo := CCNo;
                                    SearchTreeY ( RootY );
                                    If RC = 'N' then LoadTreeY ( RootY );
                                    YAddress^.AcMensalV := R4;
                                    YAddress^.Origem    := 'S';

                                    CCNo := '026';
                                    YYNo := CCNo;
                                    SearchTreeY ( RootY );
                                    If RC = 'N' then LoadTreeY ( RootY );
                                    YAddress^.AcMensalV := R5;
                                    YAddress^.Origem    := 'S';

                                    CCNo := '057';
                                    YYNo := CCNo;
                                    SearchTreeY ( RootY );
                                    If RC = 'N' then LoadTreeY ( RootY );
                                    YAddress^.AcMensalV := VLiq;
                                    YAddress^.Origem    := 'S';

                                    CCNo := '067';
                                    YYNo := CCNo;
                                    SearchTreeY ( RootY );
                                    If R6 > 0 then
                                       begin
                                         If RC = 'N' then LoadTreeY ( RootY );
                                         YAddress^.AcMensalV := R6;
                                         YAddress^.Origem    := 'S';
                                       end
                                       else If Qx = 'S' then
                                               begin
                                                 If RC = 'N' then LoadTreeY ( RootY );
                                                 YAddress^.AcMensalV := 0;
                                                 YAddress^.Origem    := 'S';
                                               end;

                                    EEMember.Status := 'F';

                                    Val(Copy(IData,1,2),EEMember.DiaI,E);
                                    Val(Copy(IData,4,2),EEMember.MesI,E);

                                    Val(Copy(FData,1,2),EEMember.DiaF,E);
                                    Val(Copy(FData,4,2),EEMember.MesF,E);

                                    ReadWrite(#08,'W','N',XXNumber);

                                    If NCont = 1
                                       then Writeln(LST,Dx,
                                                    Acentua(CMstMember.Descricao),Df)
                                       else Writeln(LST,Qp,Dx,
                                                    Acentua(CMstMember.Descricao),Df);

                                    Writeln(LST,ConstStr('-',80));
                                    Writeln(LST,Cx,
                                            Acentua(CMstMember.Endereco),', ',
                                            Acentua(CMstMember.Cidade),', ',
                                            CMstMember.Estado,'  Cep: ',
                                            CMstMember.Cep,Cf);
                                    Writeln(LST);
                                    Writeln(LST,ConstStr('-',80));

                                    If Tr <> 'U'
                                       then Writeln(LST,#27,Nx,
                                            Acentua('Recibo de F‚rias'),
                                            #27,Nf,'  ',
                                            Acentua('(F‚rias coletivas '),
                                            Tr,'o ',
                                            Acentua('Per¡odo)'),
                                            ' ':14,'Carimbo do C.G.C.')
                                       else Writeln(LST,#27,Nx,
                                            Acentua('Recibo de F‚rias'),
                                            #27,Nf,'  ',
                                            Acentua('(F‚rias coletivas per¡odo £nico)'),
                                            ' ':11,'Carimbo do C.G.C.');

                                    Writeln(LST,ConstStr('-',56));
                                    Writeln(LST);
                                    Writeln(LST,Acentua('Empregado.....: '),
                                            Acentua(EEMember.Nome));
                                    Writeln(LST,Acentua('Carteira Prof.: '),
                                            EEMember.CTrabN,
                                            Acentua(' S‚rie '),
                                            EEMember.CTrabS,' ',
                                            EEMember.CTrabE);
                                    Writeln(LST);
                                    Writeln(LST,Acentua('In¡cio / Fim..: '),
                                            IData,' a ',FData);
                                    Writeln(LST,Acentua('N£mero de Dias: '),
                                            P:2);

                                    If Tp = 'F'
                                       then Writeln(LST,Acentua('Faltas n/Just.: '),
                                                    EEMember.FaltasNJ:2)
                                       else Writeln(LST);

                                    Writeln(LST,Acentua('Remunera‡„o...: '),
                                            EditReal(SalBase));

                                    Writeln(LST,ConstStr('-',80));
                                    Writeln(LST,Acentua('C¢d.'),'  ',
                                            Acentua('Descri‡„o'),' ':39,
                                            'Proventos',' ':7,
                                            'Descontos');
                                    Writeln(LST,ConstStr('-',80));
                                    Writeln(LST);

                                    If R2 > 0 then
                                       begin
                                         CCNo := '019';
                                         SearchTree1 ( Root1 );
                                         If RC = 'S' then
                                            begin
                                              ReadWrite(#04,'R','N',CCNumber);
                                              Tit := CCMember.Descricao;
                                            end
                                            else TiT := 'F‚rias Coletivas';

                                         Writeln(LST,CCNo:3,'  ',
                                                 Acentua(Tit),
                                                 ' ':42 - Length(Tit),
                                                 EditReal(R2):15);
                                       end;

                                    If R3 > 0 then
                                       begin
                                         CCNo := '021';
                                         SearchTree1 ( Root1 );
                                         If RC = 'S' then
                                            begin
                                              ReadWrite(#04,'R','N',CCNumber);
                                              Tit := CCMember.Descricao;
                                            end
                                            else TiT := '1/3 F‚rias Coletivas';

                                         Writeln(LST,CCNo:3,'  ',
                                                 Acentua(Tit),
                                                 ' ':42 - Length(Tit),
                                                 EditReal(R3):15);
                                       end;

                                    If R5 > 0 then
                                       begin
                                         CCNo := '026';
                                         SearchTree1 ( Root1 );
                                         If RC = 'S' then
                                            begin
                                              ReadWrite(#04,'R','N',CCNumber);
                                              Tit := CCMember.Descricao;
                                            end
                                            else TiT := 'Arredondamento';

                                         Writeln(LST,CCNo:3,'  ',
                                                 Acentua(Tit),
                                                 ' ':42 - Length(Tit),
                                                 EditReal(R5):15);
                                       end;

                                    If R4 > 0 then
                                       begin
                                         CCNo := '061';
                                         SearchTree1 ( Root1 );
                                         If RC = 'S' then
                                            begin
                                              ReadWrite(#04,'R','N',CCNumber);
                                              Tit := CCMember.Descricao;
                                            end
                                            else TiT := 'INSS F‚rias Coletivas';

                                         Writeln(LST,CCNo:3,'  ',
                                                 Acentua(Tit),
                                                 ' ':58 - Length(Tit),
                                                 EditReal(R4):15);
                                       end;

                                    If R6 > 0 then
                                       begin
                                         CCNo := '067';
                                         SearchTree1 ( Root1 );
                                         If RC = 'S' then
                                            begin
                                              ReadWrite(#04,'R','N',CCNumber);
                                              Tit := CCMember.Descricao;
                                            end
                                            else TiT := 'Faltas N„o Justificadas';

                                         Writeln(LST,CCNo:3,'  ',
                                                 Acentua(Tit),
                                                 ' ':58 - Length(Tit),
                                                 EditReal(R6):15);
                                       end;

                                    Writeln(LST,' ':47,
                                            ConstStr('-',15),' ',
                                            ConstStr('-',15));

                                    Tit := '';
                                    Writeln(LST,' ':47,EditReal(TProv):15,' ',
                                            EditReal(TDesc):15);

                                    Writeln(LST);
                                    Writeln(LST,' ':28,
                                            Acentua('*** Total L¡quido'),
                                            ' ':2,EditReal(VLiq):15);
                                    Writeln(LST);

                                    Extenso(50,50,50,EditReal(VLiq));

                                    Writeln(LST,' ':14,'(',#27,Nx,Res1,#27,Nf,')');
                                    If Res2 <> ''
                                       then Writeln(LST,' ':14,'(',#27,Nx,Res2,#27,Nf,')');
                                    If Res3 <> ''
                                       then Writeln(LST,' ':14,'(',#27,Nx,Res3,#27,Nf,')');

                                    Writeln(LST);

                                    Writeln(LST,' ':5,
                                            'Recibo : Confirmando como ',
                                            'exatos todos os registros ',
                                            'acima, que conferi,');
                                    Writeln(LST,' ':14,
                                            'declaro ter recebido o val',
                                            'or constante deste recibo.');

                                    Writeln(LST);
                                    Writeln(LST);

                                    Writeln(LST,CMstMember.Cidade,' ',
                                            XDia,' de ',
                                            Acentua(ArrayMesEx[MM]),
                                            ' de 19',XAno,'.');

                                    Writeln(LST,' ':40,ConstStr('-',40));
                                    Writeln(LST,'[',XXNo,']',
                                            ' ':38 - Length(XXNo),
                                            Acentua(EEMember.Nome));

                                    Writeln(LST);
                                    Writeln(LST,ConstStr('-',80));
                                    Writeln(LST);

                                    Writeln(LST,#27,Nx,' ':32,
                                            Acentua('Aviso de F‚rias'),
                                            #27,Nf);
                                    Writeln(LST);

                                    If EEMember.Sexo = 'M'
                                       then Writeln(LST,' ':10,
                                                    'Comunicamos ao Sr. ',
                                                    Acentua(EEMember.Nome),'.')
                                       else Writeln(LST,' ':10,
                                                    'Comunicamos a Sra. ',
                                                    Acentua(EEMember.Nome),'.');
                                    Writeln(LST);

                                    Writeln(LST,' ':19,
                                            'De acordo com o artigo 135 da ',
                                            Acentua('lei n£mero 7414, de'));
                                    Writeln(LST,' ':10,
                                            '09/12/85, V.Sa.  esta avisado ',
                                            Acentua('que,  sair  de f‚rias '),
                                            'no dia');

                                    I := EEMember.DiaF + 1;
                                    K := EEMember.MesF;
                                    R := CMstMember.AnoAtivo;

                                    If I > TabDia[K] then
                                       begin
                                         I := 1;
                                         K := K + 1;
                                         If K > 12 then
                                            begin
                                              K := 1;
                                              R := R + 1;
                                            end;
                                       end;

                                    Str(I,J);
                                    If I < 10 then J := '0' + J;
                                    FData := J + Copy(FData,3,6);

                                    Str(K,J);
                                    If K < 10 then J := '0' + J;
                                    FData := Copy(FData,1,3) + J + Copy(FData,6,3);

                                    Str(R,J);
                                    FData := Copy(FData,1,6) + J;

                                    Writeln(LST,' ':10,IData,
                                            ', voltando a trabalhar',
                                            ' no dia ',FData,'.');

                                    Writeln(LST);

                                    Writeln(LST,' ':10,
                                            CMstMember.Cidade,' ',
                                            XDia,' de ',
                                            Acentua(ArrayMesEx[MM]),
                                            ' de 19',XAno,'.');

                                    Writeln(LST);
                                    Writeln(LST);

                                    Writeln(LST,' ':10,
                                            'Empregador.:   ',
                                            ConstStr('-',40));
                                    Writeln(LST,' ':25,
                                            Acentua(CMstMember.Descricao));

                                    Writeln(LST);
                                    Writeln(LST);
                                    Writeln(LST);

                                    Writeln(LST,' ':10,
                                            Acentua('Empregado..:   '),
                                            ConstStr('-',40));
                                    Writeln(LST,'[',XXNo,']',
                                            ' ':23 - Length(XXNo),
                                            Acentua(EEMember.Nome));

                                    UnLoadMVDsk;
                                    LiberaMVDsk;
                                    RC := 'S';
                                  end;
                             end
                             else If EEMember.Depto <> DDNo then RC := 'N';
                        end;

                     If KeyPressed then
                        begin
                          TC := ReadKey;
                          If TC = #13 then
                             Repeat
                               TC := ReadKey;
                             Until (TC = #13) or (TC = #27);
                        end;

                     If TC = #27 then
                        begin
                          RC := 'N';
                          J  := DDNo;
                        end;

                   Until RC = 'N';

                   If DDNo = J then RC := 'N'
                               else RC := 'S';
                 end;

            Until RC = 'N';

            If NCont > 0 then
               begin
                If DskRpt = 'N' then Write (LST,Qp);
               end;

            Window(1,1,80,25);
            Color(Blue,Cyan);
            GotoXY(1,23);  Write(ConstStr(' ',80));
            GotoXY(1,23);  Write(' Total de Empregados Impressos: ');
            Color(Blue,White);
            GotoXY(33,23); Write(NCont:5);
            TeclaReturn;

            If Root6 <> NIL then Dispose6 (Root6);
            Root6 := NIL;

            Close ( LST );
          end;
     end;
end;


end.

