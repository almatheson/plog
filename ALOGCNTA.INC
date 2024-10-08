Procedure EntryConta;
Var
  DescrInd : String[6];

begin
  Repeat
    K := 1;
    Repeat
      Case K of
           1   : begin
                   J := DescricaoW;
		   InputStr(J,40,12,10,0,'S',Tfn,Utx);
                   DescricaoW := J;
                   If (DescricaoW = '') and (TC <> #27) then
                       begin
                         ErroMsg := 'Descri��o Inv�lida';
                         ErrorMessage;
                         K := K - 1;
                       end;
                 end;
           2   : begin
                   Move(MemW[$B800:0000],ScArray5[1],4000);
                   DrawBox(38,13,57,19,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(42,14); Write('tivo');
                   GotoXY(42,15); Write('assivo');
                   GotoXY(42,16); Write('eceitas');
                   GotoXY(42,17); Write('espesas');
                   GotoXY(42,18); Write('ransit�rias');
                   Color(Red,White);
                   GotoXY(41,14); Write('A');
                   GotoXY(41,15); Write('P');
                   GotoXY(41,16); Write('R');
                   GotoXY(41,17); Write('D');
                   GotoXY(41,18); Write('T');
                   J := GrupoW;
		   InputStr(J,1,12,11,0,'S',Tfn,Utx);
                   GrupoW := UpCase(J[1]);
                   If (TC <> #27) then
                      If (GrupoW <> 'A') and
                         (GrupoW <> 'P') and
                         (GrupoW <> 'R') and
                         (GrupoW <> 'D') and
                         (GrupoW <> 'T') then
                         begin
                           ErroMsg := 'Grupo Inv�lido';
                           ErrorMessage;
                           K := K - 1;
                         end;
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(12,11);
                   Case GrupoW of
                        'A' : Write('Ativo      ');
                        'P' : Write('Passivo    ');
                        'R' : Write('Receita    ');
                        'D' : Write('Despesa    ');
                        'T' : Write('Transit�ria');
                        else  Write('           ');
                   end;
                 end;
           3   : begin
                   Move(MemW[$B800:0000],ScArray5[1],4000);
                   DrawBox(38,14,57,17,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(45,15); Write('int�tica');
                   GotoXY(45,16); Write('nal�tica');
                   Color(Red,White);
                   GotoXY(44,15); Write('S');
                   GotoXY(44,16); Write('A');
                   J := TipoW;
		   InputStr(J,1,12,12,0,'S',Tfn,Utx);
                   TipoW := UpCase(J[1]);
                   If (TC <> #27) then
                      If (TipoW <> 'S') and (TipoW <> 'A') then
                         begin
                           ErroMsg := 'Tipo Inv�lido';
                           ErrorMessage;
                           K := K - 1;
                         end;
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(12,12);
                   If TipoW = 'S'
                      then Write('Sint�tica')
                      else If TipoW = 'A' then Write('Anal�tica');
                 end;
           4   : begin
                   Move(MemW[$B800:0000],ScArray5[1],4000);
                   DrawBox(38,14,57,19,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(38,15); Write(' 1 .............( ) ');
                   GotoXY(38,16); Write(' 1.10 ..........( ) ');
                   GotoXY(38,17); Write(' 1.10.10 .......( ) ');
                   GotoXY(38,18); Write('  de   a   Graus.   ');
                   Color(Red,White);
                   GotoXY(55,15); Write('1');
                   GotoXY(55,16); Write('2');
                   GotoXY(55,17); Write('3');
                   GotoXY(43,18); Write('1');
                   GotoXY(47,18); Write('9');
                   J := GrauW;
		   InputStr(J,1,12,13,0,'S',Tfn,Utx);
                   GrauW := J[1];
                   If (TC <> #27) then
                      If GrauW in ['1','2','3','4','5','6','7','8','9'] then
                         begin
                           If (TC   <> #24) and
                              (TipoW = 'S') then K := 5;
                         end
                         else begin
                                ErroMsg := 'Grau Inv�lido';
                                ErrorMessage;
                                K := K - 1;
                              end;
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(12,13); Write(GrauW);
                   If TipoW = 'S' then
                      begin
                        AceitaW     := 'N';
                        PedeDeptoW  := 'N';
                        IndiceCW    := '';
                        PeriodoCW   := ' ';
                        CPartidaCW  := '';
                        HistoricoCW := 0;
                        GotoXY(12,14); Write('N�o aceita');
                        GotoXY(12,16); Write('N�o pede  ');
                        If (GrupoW = 'A') or (GrupoW = 'P') then
                           begin
                             GrupoEW := 'N';
                             GotoXY(12,18); Write(GrupoEW);
                             GotoXY(14,18); Write('N�o Considerada');
                           end;
                      end;
                 end;
           5   : begin
                   Move(MemW[$B800:0000],ScArray5[1],4000);
                   DrawBox(38,14,57,18,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(46,15); Write('�bito');
                   GotoXY(46,16); Write('r�dito');
                   GotoXY(46,17); Write('mbos');
                   Color(Red,White);
                   GotoXY(45,15); Write('D');
                   GotoXY(45,16); Write('C');
                   GotoXY(45,17); Write('A');
                   J := AceitaW;
		   InputStr(J,1,12,14,0,'S',Tfn,Utx);
                   If J = ' ' then AceitaW := 'A'
                              else AceitaW := UpCase(J[1]);
                   If (TC <> #27) then
                      If (AceitaW <> 'D') and
                         (AceitaW <> 'C') and
                         (AceitaW <> 'A') and
                         (AceitaW <> 'N') then
                         begin
                           ErroMsg := 'Resposta Inv�lida';
                           ErrorMessage;
                           K := K - 1;
                         end;
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(12,14);
                   Case AceitaW of
                        'D' : Write('D�bito    ');
                        'C' : Write('Cr�dito   ');
                        'A' : Write('Ambos     ');
                        'N' : Write('N�o aceita');
                        else  Write('          ');
                   end;
                 end;
           6   : begin
                   Move(MemW[$B800:0000],ScArray5[1],4000);
                   DrawBox(38,14,57,18,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(46,15); Write('evedor');
                   GotoXY(46,16); Write('redor');
                   GotoXY(46,17); Write('�o Avisa');
                   Color(Red,White);
                   GotoXY(45,15); Write('D');
                   GotoXY(45,16); Write('C');
                   GotoXY(45,17); Write('N');
                   J := AvisaW;
		   InputStr(J,1,12,15,0,'S',Tfn,Utx);
                   If J = ' ' then AvisaW := 'N'
                              else AvisaW := UpCase(J[1]);
                   If (TC <> #27) then
                      If (AvisaW <> 'D') and
                         (AvisaW <> 'C') and
                         (AvisaW <> 'N') then
                         begin
                           ErroMsg := 'Resposta Inv�lida';
                           ErrorMessage;
                           K := K - 1;
                         end
                         else If TipoW = 'S' then
                                 Case TC of
                                      #24 : K := 5;
                                      else  K := 7;
                                 end;
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(12,15);
                   Case AvisaW of
                        'D' : Write('Devedor   ');
                        'C' : Write('Credor    ');
                        'N' : Write('N�o avisa ');
                        else  Write('          ');
                   end;
                 end;
           7   : begin
                   Move(MemW[$B800:0000],ScArray5[1],4000);
                   DrawBox(38,14,57,17,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(47,15); Write('im');
                   GotoXY(47,16); Write('�o');
                   Color(Red,White);
                   GotoXY(46,15); Write('S');
                   GotoXY(46,16); Write('N');
                   J := PedeDeptoW;
		   InputStr(J,1,12,16,0,'S',Tfn,Utx);
                   If J = ' ' then PedeDeptoW := 'N'
                              else PedeDeptoW := UpCase(J[1]);
                   If (TC <> #27) then
                      If (PedeDeptoW <> 'S') and
                         (PedeDeptoW <> 'N') then
                         begin
                           ErroMsg := 'Resposta Inv�lida';
                           ErrorMessage;
                           K := K - 1;
                         end;
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(12,16);
                   Case PedeDeptoW of
                        'S' : Write('Sim      ');
                        'N' : Write('N�o pede ');
                        else  Write('         ');
                   end;
                 end;
           8   : begin
                   Move(MemW[$B800:0000],ScArray5[1],4000);
                   DrawBox(34,10,58,19,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(34,10); Write('    Receita L�quida      ');
                   GotoXY(34,11); Write('    Lucro Bruto          ');
                   GotoXY(34,12); Write('    Lucro Operacional    ');
                   GotoXY(34,13); Write('    Lucro antes da C.M.  ');
                   GotoXY(34,14); Write('    Lucro antes da C.S.  ');
                   GotoXY(34,15); Write('    Lucro a/Prov.p/I.R.  ');
                   GotoXY(34,16); Write('    Lucro L�quido        ');
                   GotoXY(34,17); Write('    Apura��o de Resultado');
                   GotoXY(34,18); Write('    Balan�o              ');
                   GotoXY(34,19); Write('    N�o � Considerada    ');
                   Color(Red,White);
                   GotoXY(35,10); Write('0');
                   GotoXY(35,11); Write('1');
                   GotoXY(35,12); Write('2');
                   GotoXY(35,13); Write('3');
                   GotoXY(35,14); Write('4');
                   GotoXY(35,15); Write('5');
                   GotoXY(35,16); Write('6');
                   GotoXY(35,17); Write('7');
                   GotoXY(35,18); Write('8');
                   GotoXY(35,19); Write('N');
                   J := GrupoEW;
		   InputStr(J,1,12,18,0,'S',Tfn,Utx);
                   If J = ' ' then GrupoEW := 'N'
                              else GrupoEW := UpCase(J[1]);
                   If (TC <> #27) then
                      If GrupoEW in ['0','1','2','3','4','5','6','7','8','N'] then
                         begin
                           If (TC    = #24) and
                              (TipoW = 'S') then K := 7
                              else If (TC   <> #24) and
                                      (TipoW = 'S') then
                                      begin
                                        K           := 14;
                                        CorrecaoW   := 'N';
                                        IndiceCW    := '';
                                        PeriodoCW   := ' ';
                                        CPartidaXW  := '';
                                        CPartidaCW  := '';
                                        HistoricoCW := 0;
                                        GotoXY(38,13); Write(CorrecaoW);
                                        GotoXY(38,14); Write(' ':15);
                                        GotoXY(38,15); Write(' ':15);
                                        GotoXY(38,16); Write(' ':15);
                                        GotoXY(38,17); Write(' ':15);
                                      end;
                         end
                         else begin
                                ErroMsg := 'Grupo de Apura��o Inv�lido';
                                ErrorMessage;
                                K := K - 1;
                              end;
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(12,18); Write(GrupoEW);
                   GotoXY(14,18);
                   Case GrupoEW of
                        '0' : Write('Receita L�quida');
                        '1' : Write('Lucro Bruto    ');
                        '2' : Write('Lucro Operacio.');
                        '3' : Write('Lucro a/Corr.M.');
                        '4' : Write('Lucro a/Cont.S.');
                        '5' : Write('Lucro a/Pr.I.R.');
                        '6' : Write('Lucro L�quido  ');
                        '7' : Write('Ap.de Resultado');
                        '8' : Write('Balan�o        ');
                        'N' : Write('N�o Considerada');
                   end;
                 end;
           9   : begin
                   Move(MemW[$B800:0000],ScArray5[1],4000);
                   DrawBox(5,14,24,18,Red,'S');
                   MakeBox(4,14,18,22,Red,1,0);
                   Color(Red,Cyan);
                   GotoXY(05,15); Write('  em  Conta Result. ');
                   GotoXY(05,16); Write('  om  Conta Result. ');
                   GotoXY(05,17); Write('  �o  Corrige       ');
                   Color(Red,White);
                   GotoXY(06,15); Write('S');
                   GotoXY(06,16); Write('C');
                   GotoXY(06,17); Write('N');
                   J := CorrecaoW;
		   InputStr(J,1,38,12,0,'S',Tfn,Utx);
                   If J = ' ' then CorrecaoW := 'N'
                              else CorrecaoW := UpCase(J[1]);
                   If (TC <> #27) then
                      If (CorrecaoW <> 'S') and
                         (CorrecaoW <> 'C') and
                         (CorrecaoW <> 'N') then
                         begin
                           ErroMsg := 'Resposta Inv�lida';
                           ErrorMessage;
                           K := K - 1;
                         end
                         else If (TC       <> #24) and
                                 (CorrecaoW = 'N') then
                                 begin
                                   K           := 14;
                                   IndiceCW    := '';
                                   PeriodoCW   := ' ';
                                   CPartidaXW  := '';
                                   CPartidaCW  := '';
                                   HistoricoCW := 0;
                                 end;
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(38,12);
                   Case CorrecaoW of
                        'S' : Write('Sem Cta.Resultado');
                        'C' : Write('Com Cta.Resultado');
                        'N' : begin
                                Write('N�o Corrige      ');
                                GotoXY(38,13); Write(' ':15);
                                GotoXY(38,14); Write(' ':15);
                                GotoXY(38,15); Write(' ':15);
                                GotoXY(38,16); Write(' ':15);
                              end;
                   end;
                 end;
           10  : begin
                   Move(MemW[$B800:0000],ScArray5[1],4000);
                   DrawBox(5,14,24,18,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(05,15); Write('         do Indice  ');
                   GotoXY(05,16); Write('  econ�mico  usado  ');
                   GotoXY(05,17); Write('  para a         .  ');
                   Color(Red,White);
                   GotoXY(07,15); Write('C�digo');
                   GotoXY(14,17); Write('Corre��o');
                   J := IndiceCW;
		   InputStr(J,2,38,13,0,'S',Tfn,Utx);
                   If TC <> #27 then
                      begin
                        If J <> '' then
                           With EcoMember do
                           begin
                             Str(CMstMember.AnoAtivo,XAno);
                             IndiceCW := UpCaseStr(J);
                             IINo     := XAno + '#' + IndiceCW;
                             SearchTree7 ( Root7 );
                             If RC = 'S' then
                                begin
                                  ReadWrite(#12,'R','N',IINumber);
                                  If RW = 'S'
                                     then DescrInd := Descricao
                                     else begin
                                            DescrInd := '      ';
                                            ErroMsg  := 'Indice n�o existe';
                                            ErrorMessage;
                                            K := K - 1;
                                          end;
                                end
                                else begin
                                       DescrInd := '      ';
                                       ErroMsg  := 'Indice n�o existe';
                                       ErrorMessage;
                                       K := K - 1;
                                     end;
                           end
                           else begin
                                  DescrInd := '      ';
                                  ErroMsg  := 'Indice Inv�lido';
                                  ErrorMessage;
                                  K := K - 1;
                                end;
                      end;
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(38,13); Write(IndiceCW);
                   GotoXY(41,13); Write(DescrInd);
                 end;
           11  : begin
                   Move(MemW[$B800:0000],ScArray5[1],4000);
                   DrawBox(5,14,24,18,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(13,15); Write('nual');
                   GotoXY(13,16); Write('ensal');
                   Color(Red,White);
                   GotoXY(12,15); Write('A');
                   GotoXY(12,16); Write('M');
                   J := PeriodoCW;
		   InputStr(J,1,38,14,0,'S',Tfn,Utx);
                   PeriodoCW := UpCase(J[1]);
                   If (TC <> #27) then
                      If (PeriodoCW <> 'A') and (PeriodoCW <> 'M') then
                         begin
                           ErroMsg := 'Per�odo de Corre��o Inv�lido';
                           ErrorMessage;
                           K := K - 1;
                         end
                         else If (TC       <> #24) and
                                 (CorrecaoW = 'S') then K := 12;
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(38,14);
                   If PeriodoCW = 'A'
                      then Write('Anual ')
                      else If PeriodoCW = 'M' then Write('Mensal');
                 end;
           12  : begin
                   Move(MemW[$B800:0000],ScArray5[1],4000);
                   DrawBox(5,14,24,18,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(05,15); Write('         da  Conta  ');
                   GotoXY(05,16); Write('  que vai  receber  ');
                   GotoXY(05,17); Write('  o resultado.      ');
                   Color(Red,Cyan);
                   GotoXY(07,15); Write('C�digo');
                   J := CPartidaXW;
		   InputStr(J,18,38,15,0,'S',Tfn,Utx);
                   CPartidaXW := J;
                   If TC <> #27 then
                      If CPartidaXW <> '' then
                         begin
                           RC         := 'N';
                           ContaNo    := LimpaChave(J);
                           CPartidaXW := ContaNo;
                           SearchTree1 ( Root1 );
                           If RC = 'S' then
                              With ContaMember do
                              begin
                                ReadWrite(#03,'R','N',ContaNumber);
                                If (RW   = 'S') and
                                   (Tipo = 'S') then
                                   begin
                                     ErroMsg := 'Conta � Sint�tica';
                                     ErrorMessage;
                                     K := K - 1;
                                   end;
                              end
                              else begin
                                     ErroMsg := 'Conta n�o existe';
                                     ErrorMessage;
                                     K := K - 1;
                                   end;
                         end
                         else begin
                                ErroMsg := 'Conta Resultado � Obrigat�ria';
                                ErrorMessage;
                                K := K - 1;
                              end;
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(38,15); Write(CPartidaXW,' ':19-Length(CPartidaXW));
                 end;
           13  : begin
                   Move(MemW[$B800:0000],ScArray5[1],4000);
                   DrawBox(5,14,24,18,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(05,15); Write('         da  Conta  ');
                   GotoXY(05,16); Write('  Contra - partida  ');
                   GotoXY(05,17); Write('  para a         .  ');
                   Color(Red,White);
                   GotoXY(07,15); Write('C�digo');
                   GotoXY(14,17); Write('Corre��o');
                   J := CPartidaCW;
		   InputStr(J,18,38,16,0,'S',Tfn,Utx);
                   CPartidaCW := J;
                   If TC <> #27 then
                      If CPartidaCW <> '' then
                         begin
                           RC         := 'N';
                           ContaNo    := LimpaChave(J);
                           CPartidaCW := ContaNo;
                           SearchTree1 ( Root1 );
                           If RC = 'S' then
                              With ContaMember do
                              begin
                                ReadWrite(#03,'R','N',ContaNumber);
                                If (RW   = 'S') and
                                   (Tipo = 'S') then
                                   begin
                                     ErroMsg := 'Conta � Sint�tica';
                                     ErrorMessage;
                                     K := K - 1;
                                   end
                                   else If (TC        = #24) and
                                           (CorrecaoW = 'S') then K := 12;
                              end
                              else begin
                                     ErroMsg := 'Conta n�o existe';
                                     ErrorMessage;
                                     K := K - 1;
                                   end;
                         end;
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(38,16); Write(CPartidaCW,' ':19-Length(CPartidaCW));
                 end;
           14  : begin
                   Color(Blue,White);
                   GotoXY(1,24); Write(ConstStr(' ',80));
                   GotoXY(2,24); Write('F1');
                   Color(Blue,Cyan);
                   GotoXY(5,24); Write('para pesquisar Hist�ricos');
                   If HistoricoCW = 0 then J := ''
                      else begin
                             Str(HistoricoCW:4,J);
                             J := LeftAdjust(J);
                           end;
		   InputStr(J,4,38,17,0,'S',Tfn,Utx);
                   LimpaLn(24,Tfd);
                   Val(J,HistoricoCW,E);
                   If (TC <> #27) then
                      begin
                        If TC = #21 then
                            begin
                              RecordNumber := 1;
                              XavAnt       := 0;
                              ScrollHsPd;
                              If XavAnt <> 0 then
                                 begin
                                   ReadWrite(#10,'R','N',XavAnt);
                                   If RW = 'S' then HistoricoCW := XavAnt;
                                 end;
                            end
                            else If HistoricoCW <> 0 then
                                    begin
                                      ReadWrite(#10,'R','N',HistoricoCW);
                                      If (RW                   = 'N ') or
                                         (HsPdMember.Ocupado  <> #255) then
                                         begin
                                           ErroMsg := 'Hist�rico n�o existe';
                                           ErrorMessage;
                                           K := K - 1;
                                         end;
                                    end;
                      end;
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(38,17); Write(HistoricoCW);
                 end;
           15  : begin
                   Move(MemW[$B800:0000],ScArray5[1],4000);
                   DrawBox(5,14,24,17,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(14,15); Write('im');
                   GotoXY(14,16); Write('�o');
                   Color(Red,White);
                   GotoXY(13,15); Write('S');
                   GotoXY(13,16); Write('N');
                   J := DiarioW;
		   InputStr(J,1,38,18,0,'S',Tfn,Utx);
                   If J = ' ' then DiarioW := 'S'
                              else DiarioW := UpCase(J[1]);
                   If (TC <> #27) then
                      If (DiarioW <> 'S') and
                         (DiarioW <> 'N') then
                         begin
                           ErroMsg := 'Resposta Inv�lida';
                           ErrorMessage;
                           K := K - 1;
                         end
                         else If TC = #24
                                 then If (CorrecaoW <> 'S') and
                                         (CorrecaoW <> 'C')
                                         then K := 10;
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(38,18);
                   Case DiarioW of
                        'S' : Write('Sim');
                        'N' : Write('N�o');
                        else  Write('   ');
                   end;
                 end;
           16  : begin
                   Move(MemW[$B800:0000],ScArray5[1],4000);
                   DrawBox(5,14,24,17,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(14,15); Write('im');
                   GotoXY(14,16); Write('�o');
                   Color(Red,White);
                   GotoXY(13,15); Write('S');
                   GotoXY(13,16); Write('N');
                   I := 1;
                   Repeat
                     J := BalanceteW[I];
                     InputStr(J,1,(37 + I),19,0,'S','N',Tfn,Utx);
                     If TC <> #27 then
                        begin
                          If UpCase(J[1]) in ['N','S'] then
                             begin
                               GotoXY((37 + I),19); Write(UpCase(J[1]));
                               BalanceteW[I] := UpCase(J[1]);
                               If TC = #24 then I := I - 1
                                           else I := I + 1;
                             end
                             else begin
                                    ErroMsg := 'Responda S ou N';
                                    ErrorMessage;
                                  end;
                        end;
                   Until (I = 0) or (I = 6) or (TC = #27);
                 end;
           17  : begin
                   Move(MemW[$B800:0000],ScArray5[1],4000);
                   DrawBox(5,14,24,17,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(14,15); Write('im');
                   GotoXY(14,16); Write('�o');
                   Color(Red,White);
                   GotoXY(13,15); Write('S');
                   GotoXY(13,16); Write('N');
                   I := 1;
                   Repeat
                     J := BalancoW[I];
                     InputStr(J,1,(37 + I),20,0,'S','N',Tfn,Utx);
                     If TC <> #27 then
                        begin
                          If UpCase(J[1]) in ['N','S'] then
                             begin
                               GotoXY((37 + I),20); Write(UpCase(J[1]));
                               BalancoW[I] := UpCase(J[1]);
                               If TC = #24 then I := I - 1
                                           else I := I + 1;
                             end
                             else begin
                                    ErroMsg := 'Responda S ou N';
                                    ErrorMessage;
                                  end;
                        end;
                   Until (I = 0) or (I = 6) or (TC = #27);
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   For I := 1 to 5 do
                   begin
                     GotoXY((37 + I),19); Write(BalanceteW[I]);
                     GotoXY((37 + I),20); Write(BalancoW[I]);
                   end;
                 end;
           18  : begin
                   Move(MemW[$B800:0000],ScArray5[1],4000);
                   DrawBox(38,14,57,19,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(45,15); Write('tiva');
                   GotoXY(45,16); Write('esativada');
                   GotoXY(45,17); Write('ancelada');
                   GotoXY(44,18); Write('E cluir');
                   Color(Red,White);
                   GotoXY(44,15); Write('A');
                   GotoXY(44,16); Write('D');
                   GotoXY(44,17); Write('C');
                   GotoXY(45,18); Write('x');
                   J := StatusW;
		   InputStr(J,1,12,20,0,'S',Tfn,Utx);
                   If J = ' ' then StatusW := 'A'
                              else StatusW := UpCase(J[1]);
                   If (TC <> #27) then
                      If (StatusW <> 'A') and (StatusW <> 'D') and
                         (StatusW <> 'C') and (StatusW <> 'X') then
                         begin
                           ErroMsg := 'Status Inv�lido';
                           ErrorMessage;
                           K := K - 1;
                         end;
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(12,20);
                   Case StatusW of
                        'A' : Write('Ativa     ');
                        'D' : Write('Desativada');
                        'C' : Write('Cancelada ');
                        'X' : Write('Excluir   ');
                   end;
                 end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K = 1 then K := 18
                          else K := K - 1;
      end;
    Until (K = 19) or (TC = #27);
    If ((TC <> #27) and (Op = 'I')) or (Op = 'A') then Confirma;
  Until (TC = 'S') or (TC = #27);
end;


Procedure IncluiConta(X : Char);
begin
  With ContaMember do
  begin
    Op           := 'I';
    ContaAtual   := ContaNumber;
    OrigContaW   := J;
    DescricaoW   := '';
    GrupoW       := ' ';
    GrauW        := ' ';
    TipoW        := ' ';
    AceitaW      := ' ';
    AvisaW       := ' ';
    PedeDeptoW   := ' ';
    GrupoEW      := ' ';
    CorrecaoW    := 'N';
    IndiceCW     := '';
    PeriodoCW    := ' ';
    CPartidaXW   := '';
    CPartidaCW   := '';
    HistoricoCW  := 0;
    SinteticaW   := '';
    DiarioW      := ' ';
    BalanceteW   := ' ';
    BalancoW     := ' ';
    StatusW      := 'A';
    ContaXX      := ContaNo;
    If X = 'I' then
       begin
         Move(ScArray4[1],MemW[$B800:0000],4000);
         TitleConta;
         Color(Tfn,Utx);
         GotoXY(12,09);  Write(PushLeft(21,OrigContaW));
       end;
    EntryConta;
    If TC = 'S' then
       begin
         If GrauW <> '1' then
            begin
              ContaNo := ContaXX;
              Repeat
                RC := 'N';
                SearchAnt1 ( Root1 );
                If RC = 'S' then ReadWrite(#03,'R','N',ContaNumber);
              Until ((Tipo = 'S') and (Grau < GrauW) and (Grupo = GrupoW)) or
                    (RC = 'N');
              If RC = 'S' then SinteticaW := ContaNo;
            end
            else begin
                   SinteticaW := '';
                   RC         := 'S';
                 end;

         If RC = 'S' then
            begin
              DI           := 'S';
              ContaNumber  := ContaAtual;
              J            := OrigContaW;
              LimpaChave;
              Conta        := ContaXX;
              ContaNo      := ContaXX;
              OrigConta    := OrigContaW;
              Descricao    := DescricaoW;
              Grupo        := GrupoW;
              Grau         := GrauW;
              Tipo         := TipoW;
              Aceita       := AceitaW;
              Avisa        := AvisaW;
              PedeDepto    := PedeDeptoW;
              GrupoE       := GrupoEW;
              Correcao     := CorrecaoW;
              IndiceC      := IndiceCW;
              PeriodoC     := PeriodoCW;
              CPartidaX    := CPartidaXW;
              CPartidaC    := CPartidaCW;
              HistoricoC   := HistoricoCW;
              Sintetica    := SinteticaW;
              Diario       := DiarioW;
              Balancete    := BalanceteW;
              Balanco      := BalancoW;
              Status       := 'A';
              ReadWrite(#03,'W','N',ContaNumber);
              LoadTree1 ( Root1 );
              CMstMember.NContas := CMstMember.NContas + 1;
              ReadWrite(#16,'W','N',0);
              ReadWrite(#06,'R','N',ContaNumber);
              SaldMember.Status := StatusW;
              For I := 1 to 12 do begin
                                    SaldMember.Abertura[I] := 0;
                                    SaldMember.Debitos[I]  := 0;
                                    SaldMember.Creditos[I] := 0;
                                    SaldMember.Saldo[I]    := 0;
                                    SaldMember.SaldoB[I]   := 0;
                                    SaldMember.NLanctos[I] := 0;
                                  end;
              ReadWrite(#06,'W','N',ContaNumber);
              If X = 'I' then
                 begin
                   Move(ScArray4[1],MemW[$B800:0000],4000);
                   Color(Red,Yellow);
                   GotoXY(53,7); Write(CMstMember.NContas);
                   Move(MemW[$B800:0000],ScArray4[1],4000);
                   TitleConta;
                   DataConta;
                 end;
            end
            else begin
                   ErroMsg := 'N�o encontrei a Sint�tica';
                   ErrorMessage;
                   ContaNumber := ContaAtual;
                   ContaNo     := ContaXX;
                 end;
       end
       else begin
              ContaNumber := Limite;
              If X = 'I' then Move(ScArray4[1],MemW[$B800:0000],4000);
            end;
    TC := #13;
  end;
end;


