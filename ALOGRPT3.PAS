{$O+,F+}
Unit AlogRpt3;

Interface

Uses Crt,Dos,AlogGlbs,AlogNAvg,AlogBasP,AlogInit,AlogRpt0;

   Procedure ProcNo08Report;
   Procedure ProcNo09Report;
   Procedure ProcNo15Report;

Implementation


Procedure LinhaDiarioReport;
begin
  With LctoMember do
  begin
    HistP := '';
    If ((Historico[2] <> '') or (Historico[3] <> '')) then
       begin
         Case T of
              80  : WriteLine('L',Cx+Copy(OrigData,1,2)+' '+
                              PushLeft(19,ContaMember.OrigConta)+
                              Acentua(Copy(ContaMember.Descricao,1,20))+
                              ConstStr(' ',21-Length(Copy(ContaMember.Descricao,1,20)))+
                              Acentua(Historico[1])+Cf);
              else WriteLine('L',Copy(OrigData,1,2)+' '+
                             PushLeft(19,ContaMember.OrigConta)+
                             PushLeft(6,Lote)+'x'+
                             PushLeft(5,SeqLote)+
                             Acentua(Historico[1]));
         end;
         If ((Historico[2] <> '') and (Historico[3] <> '')) then
            Case T of
                 80  : WriteLine('L',Cx+ConstStr(' ',43)+
                                   Acentua(Historico[2])+Cf);
                 else  WriteLine('L',ConstStr(' ',34)+
                                   Acentua(Historico[2]));
            end;
         If Historico[3] <> '' then HistP := Historico[3]
                               else HistP := Historico[2];
         Case T of
              80  : Case Tipo of
                         'D' : begin
                                 WriteLine('L',Cx+ConstStr(' ',43)+
                                           Acentua(HistP)+
                                           ConstStr(' ',61-Length(HistP))+
                                           PushRight(16,EditDouble(Valor))+Cf);
                                 TDebitos := TDebitos + TruncX(Valor);
                               end;
                         'C' : begin
                                 WriteLine('L',Cx+ConstStr(' ',43)+
                                           Acentua(HistP)+
                                           ConstStr(' ',78-Length(HistP))+
                                           PushRight(16,EditDouble(Valor))+Cf);
                                 TCreditos := TCreditos + TruncX(Valor);
                               end;
                    end;
              else  Case Tipo of
                         'D' : begin
                                 WriteLine('L',ConstStr(' ',34)+
                                           Acentua(HistP)+
                                           ConstStr(' ',61-Length(HistP))+
                                           PushRight(18,EditDouble(Valor)));
                                 TDebitos := TDebitos + TruncX(Valor);
                               end;
                         'C' : begin
                                 WriteLine('L',ConstStr(' ',34)+
                                           Acentua(HistP)+
                                           ConstStr(' ',80-Length(HistP))+
                                           PushRight(18,EditDouble(Valor)));
                                 TCreditos := TCreditos + TruncX(Valor);
                               end;
                    end;
         end;
       end
       else Case T of
                 80  : Case Tipo of
                            'D' : begin
                                    WriteLine('L',Cx+Copy(OrigData,1,2)+' '+
                                              PushLeft(19,ContaMember.OrigConta)+
                                              Acentua(Copy(ContaMember.Descricao,1,20))+
                                              ConstStr(' ',21-Length(Copy(ContaMember.Descricao,1,20)))+
                                              Acentua(Historico[1])+
                                              ConstStr(' ',61-Length(Historico[1]))+
                                              PushRight(16,EditDouble(Valor))+Cf);
                                    TDebitos := TDebitos + TruncX(Valor);
                                  end;
                            'C' : begin
                                    WriteLine('L',Cx+Copy(OrigData,1,2)+' '+
                                              PushLeft(19,ContaMember.OrigConta)+
                                              Acentua(Copy(ContaMember.Descricao,1,20))+
                                              ConstStr(' ',21-Length(Copy(ContaMember.Descricao,1,20)))+
                                              Acentua(Historico[1])+
                                              ConstStr(' ',78-Length(Historico[1]))+
                                              PushRight(16,EditDouble(Valor))+Cf);
                                    TCreditos := TCreditos + TruncX(Valor);
                                  end;
                       end;
                 132 : Case Tipo of
                            'D' : begin
                                    WriteLine('L',Copy(OrigData,1,2)+' '+
                                              PushLeft(19,ContaMember.OrigConta)+
                                              PushLeft(6,Lote)+'x'+
                                              PushLeft(5,SeqLote)+
                                              Acentua(Historico[1])+
                                              ConstStr(' ',61-Length(Historico[1]))+
                                              PushRight(18,EditDouble(Valor)));
                                    TDebitos := TDebitos + TruncX(Valor);
                                  end;
                            'C' : begin
                                    WriteLine('L',Copy(OrigData,1,2)+' '+
                                              PushLeft(19,ContaMember.OrigConta)+
                                              PushLeft(6,Lote)+'x'+
                                              PushLeft(5,SeqLote)+
                                              Acentua(Historico[1])+
                                              ConstStr(' ',80-Length(Historico[1]))+
                                              PushRight(18,EditDouble(Valor)));
                                    TCreditos := TCreditos + TruncX(Valor);
                                  end;
                       end;
            end;
  end;
end;


Procedure ProcNo08Report;
Var
  MesP  : Integer;
begin
  PedeLFReport;
  If TC = 'S' then
     begin
       {$I-}
       Close ( LctoFile );
       {$I+}
       MesP := M1 - 1;
       Repeat
         MesP := MesP + 1;
         Assign (LctoFile, (XPath + '\' + FileLcto  + AAFx + '.M' + QQStr(MesP,2,'0')));
         {$I-}
         Reset  ( LctoFile );
         {$I+}
         If IOResult = 0 then
            begin
              If FileSize(LctoFile) > 0 then
                 With LctoMember do
                 begin
                   Color(Blue,Cyan);
                   GotoXY(1,24);  Write(ConstStr(' ',80));
                   GotoXY(2,24);
                   Write('Estou carregando o Indice para Impress„o do           de ',
                   ArrayMesEx[MesP]);
                   Color(Blue,Yellow);
                   GotoXY(46,24); Write('Relat¢rio');
                   If Root4 <> NIL then Dispose4 (Root4);
                   Root4 := NIL;
                   I     := -1;
                   Repeat
                     I := I + 1;
                     ReadWrite(#08,'R','N',I);
                     If (RW     = 'S') and
                        (Status = 'A') then
                        begin
                          CDVSNumber := I;
                          CDVSNo     := Copy(OrigData,1,2) + '#' +
                                        Lote               + '#' +
                                        SeqLote            + '#' +
                                        Conta;
                          LoadTree4 ( Root4 );
                          ShowHeap;
                          Color(Tfd,Utx);
                        end;
                   Until (I + 1) = FileSize(LctoFile);
                   LimpaLn(24,Tfd);
                   Color(Blue,White);
                   GotoXY(1,23); Write(ConstStr(' ',80));
                   GotoXY(2,23); Write('Imprimindo ',ArrayMesEx[MesP],' de 19',AA);
                   Color(Tfn,Utx);
                   TC := 'S';
                 end
                 else begin
                        {$I-}
                        Close ( LctoFile );
                        {$I+}
                        TC := #27;
                      end;
            end
            else TC := #27;
         If TC = 'S' then
            begin
              ParaContinua;
              MessageReport;
              ContLin   := 1000;
              TCreditos := 0;
              TDebitos  := 0;
              NCont     := 0;
              ContaNo   := '';
              CDVSNo    := '';
              MM        := MesP;
              Repeat
                RC := 'N';
                SearchPos4 ( Root4 );
                If RC = 'S' then
                   begin
                     ReadWrite(#08,'R','N',CDVSNumber);
                     If (RW                       = 'S') and
                        (TruncX(LctoMember.Valor) > 0  ) then
                        begin
                          ContaNo := LimpaChave(LctoMember.Conta);
                          SearchTree1 ( Root1 );
                          If RC = 'S' then ReadWrite(#03,'R','N',ContaNumber);
                          If (ContaMember.Tipo   = 'A') and
                             (ContaMember.Diario = 'S') and
                             (RW                 = 'S')then
                             With LctoMember do
                             begin
                               Writeln(ContaMember.Descricao);
                               If ContLin > 53 then
                                  begin
                                    If ContLin <> 1000 then
                                       begin
                                         WriteLine('L',' ');
                                         Case T of
                                            80  : begin
                                                    WriteLine('L',Cx+ConstStr(' ',75)+
                                                              Acentua('A Transportar - Total do D‚bito.:')+' '+
                                                              PushRight(28,EditDouble(TDebitos))+Cf);
                                                    WriteLine('L',Cx+ConstStr(' ',91)+
                                                              Acentua('Total do Cr‚dito:')+' '+
                                                              PushRight(28,EditDouble(TCreditos))+Cf);
                                                    HeaderAnualReport;
                                                    WriteLine('L',Cx+ConstStr(' ',78)+
                                                              Acentua('Transporte - Total do D‚bito.:')+' '+
                                                              PushRight(28,EditDouble(TDebitos))+Cf);
                                                    WriteLine('L',Cx+ConstStr(' ',91)+
                                                              Acentua('Total do Cr‚dito:')+' '+
                                                              PushRight(28,EditDouble(TCreditos))+Cf);
                                                    WriteLine('L',' ');
                                                  end;
                                            132 : begin
                                                    WriteLine('L',
                                                              ConstStr(' ',34)+
                                                              PushRight(61,'A Transportar  ')+
                                                              PushRight(18,EditDouble(TDebitos))+' '+
                                                              PushRight(18,EditDouble(TCreditos)));
                                                    HeaderAnualReport;
                                                    WriteLine('L',' ');
                                                    WriteLine('L',
                                                              ConstStr(' ',34)+
                                                              PushRight(61,'Transporte     ')+
                                                              PushRight(18,EditDouble(TDebitos))+' '+
                                                              PushRight(18,EditDouble(TCreditos)));
                                                  end;
                                         end;
                                       end
                                       else HeaderAnualReport;
                                  end;
                               LinhaDiarioReport;
                               NCont := NCont + 1;
                             end
                             else RC := 'S';
                        end;
                   end;
                GoNoGo;
                If TC = #27 then
                   begin
                     RC   := 'N';
                     MesP := M2;
                   end;
              Until RC = 'N';
              If NCont > 0 then
                 begin
                   TC := #13;
                   If ContLin > 54 then HeaderAnualReport;
                   WriteLine('L',' ');
                   If T = 80 then
                      begin
                        WriteLine('L',ConstStr('-',T));
                        WriteLine('L',Cx+ConstStr(' ',93)+
                                  Acentua('Total do D‚bito.:')+' '+
                                  PushRight(26,EditDouble(TDebitos))+Cf);
                        WriteLine('L',Cx+ConstStr(' ',93)+
                                  Acentua('Total do Cr‚dito:')+' '+
                                  PushRight(26,EditDouble(TCreditos))+Cf);
                      end
                      else begin
                             WriteLine('L',ConstStr('-',T));
                             WriteLine('L',ConstStr(' ',34)+
                                         PushRight(61,'Total -------> ')+
                                         PushRight(18,EditDouble(TDebitos))+' '+
                                         PushRight(18,EditDouble(TCreditos)));
                           end;
                   Footer;
                   If DskRpt = 'N' then WriteLine('W',Qp);
                 end;
              Window(1,1,80,25);
              {$I-}
              Close ( LctoFile );
              {$I+}
            end
            else begin
                   Color(Blue,White);
                   GotoXY(1,23); Write(ConstStr(' ',80));
                   ErroMsg := 'N„o h  lan‡amentos em ' + ArrayMesEx[MesP];
                   ErrorMessage;
                 end;
       Until MesP = M2;
       MM := CMstMember.MesAtivo;
       MarkBlue;
       GotoXY(1,23);  Write(' Fim da Impress„o do Di rio');
       TeclaReturn;
       Assign (LctoFile, (XPath + '\' + FileLcto  + AAFx + '.' + MMFx));
       {$I-}
       Reset ( LctoFile );
       {$I+}
       Color(Blue,Cyan);
       GotoXY(1,24); Write(ConstStr(' ',80));
       GotoXY(2,24); Write('Recarregando os lan‡amentos');
       Color(Blue,(White + Blink));
       GotoXY(65,24); Write('Aguarde');
       If Root4 <> NIL then Dispose4 (Root4);
       Root4 := NIL;
       Assign ( IndMFile, (XPath + '\' + FileLcto  + AAFx + '.' + IIFx));
       {$I-}
       Reset ( IndMFile );
       {$I+}
       If IOResult = 0 then LoadLcto
                       else ReWrite ( IndMFile );
       Close ( IndMFile );
       LimpaLn(24,Tfd);
     end;
end;


Procedure LimpaWorkAReport;
begin
  WorkAMember.AtivoValor   := '';
  WorkAMember.AtivoDesc    := '';
end;


Procedure WriteWorkAReport;
begin
  R := FileSize(WorkAFile);
  Seek  ( WorkAFile, R           );
  Write ( WorkAFile, WorkAMember );
end;


Procedure LimpaWorkPReport;
begin
  WorkPMember.PassivoValor := '';
  WorkPMember.PassivoDesc  := '';
end;


Procedure WriteWorkPReport;
begin
  R := FileSize(WorkPFile);
  Seek  ( WorkPFile, R           );
  Write ( WorkPFile, WorkPMember );
end;


Procedure ProcNo09Report;
begin
  PedeLFReport;
  If TC = 'S' then EntryAssinatura;
  If TC = 'S' then
     With ContaMember do
     begin
       CloseFiles;
       Reset ( CMstFile  );
       ReadWrite(#16,'R','N',0);
       Reset ( ContaFile );
       Reset ( SaldFile  );
       GrA   := 'X';
       GrP   := 'X';
       Assign ( WorkAFile, (XPath + '\' + FileWorkA ));
       {$I-}
       Reset ( WorkAFile );
       {$I+}
       If IOResult <> 0 then
          begin
            ReWrite ( WorkAFile );
            Reset   ( WorkAFile );
          end;
       Assign ( WorkPFile, (XPath + '\' + FileWorkP ));
       {$I-}
       Reset ( WorkPFile );
       {$I+}
       If IOResult <> 0 then
          begin
            ReWrite ( WorkPFile );
            Reset   ( WorkPFile );
          end;
       ParaContinua;
       MessageReport;
       LimpaWorkAReport;
       LimpaWorkPReport;
       TAtivo   := '';
       TPassivo := '';
       NCont    := 0;
       ContaNo  := '';
       Repeat
         RC := 'N';
         SearchPos1 ( Root1 );
         If RC = 'S' then
            With SaldMember do
            begin
              ReadWrite(#03,'R','N',ContaNumber);
              ReadWrite(#06,'R','N',ContaNumber);
              If (SaldMember.Status           <> 'C'      ) and
                 (ContaMember.Grupo           in ['A','P']) and
                 (ContaMember.Balanco[Modelo] = 'S'       ) then Sel := 'S'
                                                            else Sel := 'N';
              If (Sel                           = 'S') and
                 (TruncX(SaldMember.SaldoB[MM]) = 0  ) and
                 (Sx                            = 'N') then Sel := 'N';
              If Sel = 'S' then
                 begin
                   NCont := NCont + 1;
                   Writeln(Descricao);
                   If Grupo = 'A' then
                      begin
                        If TruncX(SaldoB[MM]) < 0 then
                           begin
                             SaldoB[MM] := SaldoB[MM] * -1;
                             Sald       := '<' + EditDouble(TruncX(SaldoB[MM] / VMo)) + '>';
                           end
                           else Sald := EditDouble(TruncX(SaldoB[MM] / VMo)) + ' ';
                      end;
                   If Grupo = 'P' then
                      begin
                        If TruncX(SaldoB[MM]) > 0
                           then Sald := '<' + EditDouble(TruncX(SaldoB[MM] / VMo)) + '>'
                           else begin
                                  SaldoB[MM] := SaldoB[MM] * -1;
                                  Sald       := EditDouble(TruncX(SaldoB[MM] / VMo)) + ' ';
                                end;
                      end;
                   If Grau = '1' then
                      begin
                        If Grupo = 'A' then
                           begin
                             TAtivo := Sald;
                             SaldoX := SaldoB[MM];
                           end
                           else TPassivo := Sald;
                        Sald := '';
                      end;
                   If (Grupo = 'A') and
                      (Grau <> '1') then
                      With WorkAMember do
                      begin
                        If Grau <> GrA then
                           begin
                             WriteWorkAReport;
                             LimpaWorkAReport;
                             GrA := Grau;
                           end;
                        AtivoValor := Sald;
                        I := 40 - Length(Descricao);
                        Case Grau of
                             '2' : AtivoDesc := Descricao;
                             '3' : AtivoDesc := ' ' + Descricao;
                             '4' : AtivoDesc := '  ' + Descricao;
                             else  AtivoDesc := '   ' + Descricao;
                        end;
                        If Grau <> '1' then
                           AtivoDesc := AtivoDesc + ConstStr('.',I);
                        WriteWorkAReport;
                        LimpaWorkAReport;
                      end;
                   If (Grupo = 'P') and (Grau <> '1') then
                      With WorkPMember do
                      begin
                        If Grau <> GrP then
                           begin
                             WriteWorkPReport;
                             LimpaWorkPReport;
                             GrP := Grau;
                           end;
                        PassivoValor := Sald;
                        I := 40 - Length(Descricao);
                        Case Grau of
                             '2' : PassivoDesc := Descricao;
                             '3' : PassivoDesc := ' ' + Descricao;
                             '4' : PassivoDesc := '  ' + Descricao;
                             else  PassivoDesc := '   ' + Descricao;
                        end;
                        If Grau <> '1' then
                           PassivoDesc := PassivoDesc + ConstStr('.',I);
                        WriteWorkPReport;
                        LimpaWorkPReport;
                      end;
                 end;
            end;
         GoNoGo;
         If TC = #27 then RC := 'N';
       Until RC = 'N';
       If (NCont > 0) and (TC <> #27) then
          With WorkAMember do
          begin
            I := -1;
            R := -1;
            With WorkPMember do
            Repeat
              I := I + 1;
              {$I-}
              Seek ( WorkAFile, I           );
              Read ( WorkAFile, WorkAMember );
              {$I+}
              If IOResult <> 0 then LimpaWorkAReport;
              R := R + 1;
              {$I-}
              Seek ( WorkPFile, R           );
              Read ( WorkPFile, WorkPMember );
              {$I+}
              If IOResult <> 0 then LimpaWorkPReport;
              If ContLin > 56 then HeaderAnualReport;
              If T = 80
                 then WriteLine('L',Cx+Acentua(AtivoDesc)+
                                ConstStr(' ',45-Length(AtivoDesc))+
                                PushRight(20,AtivoValor)+
                                ConstStr(' ',7)+Acentua(PassivoDesc)+
                                ConstStr(' ',45-Length(PassivoDesc))+
                                PushRight(20,PassivoValor)+Cf)
                 else WriteLine('L',Acentua(AtivoDesc)+
                                ConstStr(' ',41-Length(AtivoDesc))+
                                Nx+PushRight(19,AtivoValor)+Nf+
                                ConstStr(' ',12)+Acentua(PassivoDesc)+
                                ConstStr(' ',41-Length(PassivoDesc))+
                                Nx+PushRight(19,PassivoValor)+Nf);
              GoNoGo;
              If TC = #27 then
                 begin
                   I := 32000;
                   R := 32000;
                 end;
            Until ((I + 1) >= FileSize(WorkAFile)) and
                  ((R + 1) >= FileSize(WorkPFile));
            WriteLine('L',' ');
            If ContLin > 56 then HeaderAnualReport;
            If T = 80 then
               begin
                 WriteLine('L',ConstStr('-',T));
                 WriteLine('L',Cx+ConstStr(' ',45)+PushRight(20,TAtivo)+
                                  ConstStr(' ',52)+PushRight(20,TPassivo)+Cf);
                 WriteLine('L',ConstStr('-',T));
               end
               else begin
                      WriteLine('L',ConstStr('-',T));
                      WriteLine('L',ConstStr(' ',40)+
                                Nx+PushRight(20,TAtivo)+Nf+
                                ConstStr(' ',52)+
                                Nx+PushRight(20,TPassivo)+Nf);
                      WriteLine('L',ConstStr('-',T));
                    end;
            If (TAtivo  = TPassivo) and
               (Assin1 <> ''      ) and
               (XMo     = 'N'     ) then
               begin
                 If ContLin > 50 then HeaderAnualReport;
		 Extenso(55,55,55,EditDouble(SaldoX));
                 If T = 80 then
                    begin
                      WriteLine('L',ConstStr(' ',24)+Cx+
                                Acentua('Reconhecemos a exatid„o do presente balan‡o patrimonial')+Cf);
                      WriteLine('L',ConstStr(' ',24)+Cx+
                                Acentua('somando no Ativo e no Passivo R$ ')+
			        PushRight(23,TAtivo)+Cf);
                      WriteLine('L',ConstStr(' ',24)+Cx+Res1+Cf);
                    end
                    else begin
                           WriteLine('L',ConstStr(' ',38)+
                                     Acentua('Reconhecemos a exatid„o do presente balan‡o patrimonial'));
                           WriteLine('L',ConstStr(' ',38)+
                                     Acentua('somando no Ativo e no Passivo R$ ')+
			             PushRight(23,TAtivo));
                           WriteLine('L',ConstStr(' ',38)+Res1);
                         end;
                 If Res2 <> '' then
                    begin
                      If T = 80
                         then WriteLine('L',ConstStr(' ',24)+Cx+Res2+Cf)
                         else WriteLine('L',ConstStr(' ',38)+Res2);
                    end;
                 If Res3 <> '' then
                    begin
                      If T = 80
                         then WriteLine('L',ConstStr(' ',24)+Cx+Res3+Cf)
                         else WriteLine('L',ConstStr(' ',38)+Res3);
                    end;
                 WriteLine('L',' ');
                 If T = 80
                    then WriteLine('L',ConstStr(' ',28)+Cx+CMstMember.Cidade+', '+
                                   PushLeft(2,EditInteger(TabDia[MM]))+
                                   Acentua(TabMesX[MM])+
                                   PushLeft(2,EditInteger(AA))+Cf)
                    else WriteLine('L',ConstStr(' ',45)+CMstMember.Cidade+', '+
                                   PushLeft(2,EditInteger(TabDia[MM]))+
                                   Acentua(TabMesX[MM])+
                                   PushLeft(2,EditInteger(AA)));
                 If Assin1 <> '' then
                    begin
                      WriteLine('L',' ');
                      WriteLine('L',' ');
                      WriteLine('L',' ');
                      If T = 80 then
                         begin
                           WriteLine('L',ConstStr(' ',14)+Cx+ConstStr('-',40)+
                                         ConstStr(' ',10)+ConstStr('-',40)+Cf);
                           WriteLine('L',ConstStr(' ',14)+Cx+Acentua(Titulo1)+
                                         ConstStr(' ',50-Length(Titulo1))+
                                         Acentua(Titulo2)+Cf);
                           WriteLine('L',ConstStr(' ',14)+Cx+Acentua(Assin1)+
                                         ConstStr(' ',50-Length(Assin1))+
                                         Acentua(Assin2)+Cf);
                         end
                         else begin
                                WriteLine('L',ConstStr(' ',16)+
                                              ConstStr('-',40)+
                                              ConstStr(' ',10)+
                                              ConstStr('-',40));
                                WriteLine('L',ConstStr(' ',16)+
                                              Acentua(Titulo1)+
                                              ConstStr(' ',50-Length(Titulo1))+
                                              Acentua(Titulo2));
                                WriteLine('L',ConstStr(' ',16)+
                                              Acentua(Assin1)+
                                              ConstStr(' ',50-Length(Assin1))+
                                              Acentua(Assin2));
                              end;
                    end;
               end;
            Footer;
            If DskRpt = 'N' then WriteLine('W',Qp);
          end;
       Window(1,1,80,25);
       MarkBlue;
       GotoXY(1,23);  Write(' Total de Contas Impressas: ');
       Color(Blue,White);
       GotoXY(29,23); Write(NCont:3);
       TeclaReturn;
       Close ( CMstFile  );
       Close ( ContaFile );
       Close ( SaldFile  );
       Close ( WorkAFile );
       Close ( WorkPFile );
       Erase ( WorkAFile );
       Erase ( WorkPFile );
       OpenFiles;
     end;
end;


Procedure ProcNo15Report;
Var
  TA,TP     : Real;
begin
  PedeMesPeC;
  If TC = 'S' then
     begin
       ParaContinua;
       MessageReport;
       NCont   := 0;
       ContaNo := '';
       Repeat
         RC := 'N';
         SearchPos1 ( Root1 );
         If RC = 'S' then
            With ContaMember do
            begin
              ReadWrite(#03,'R','N',ContaNumber);
              ReadWrite(#06,'R','N',ContaNumber);
              If (RW                     = 'S') and
                 (ContaMember.Balancete  = 'S') and
                 (SaldMember.Status     <> 'C') and
                 ((SaldMember.Saldo[MP] <> 0 )  or
                  (SaldMember.Saldo[MC] <> 0 )) then
                 With SaldMember do
                 begin
                   If Grau = '1' then
                      Case Grupo of
                           'A' : TA := Saldo[MP];
                           'P' : TP := Saldo[MP];
                      end;
                   NCont := NCont + 1;
                   Writeln(Descricao);
                   If ContLin > 56 then HeaderReport;
                   If ((Grupo = 'A') and (TruncX(Saldo[MP]) < 0)) or
                      ((Grupo = 'D') and (TruncX(Saldo[MP]) < 0)) or
                      ((Grupo = 'T') and (TruncX(Saldo[MP]) < 0)) or
                      ((Grupo = 'P') and (TruncX(Saldo[MP]) > 0)) or
                      ((Grupo = 'R') and (TruncX(Saldo[MP]) > 0))
                      then Sald := '<' + EditDouble(Saldo[MP]) + '>'
                      else Sald := ' ' + EditDouble(Saldo[MP]) + ' ';
                   If ((Grupo = 'A') and (TruncX(Saldo[MC]) < 0)) or
                      ((Grupo = 'D') and (TruncX(Saldo[MC]) < 0)) or
                      ((Grupo = 'T') and (TruncX(Saldo[MC]) < 0)) or
                      ((Grupo = 'P') and (TruncX(Saldo[MC]) > 0)) or
                      ((Grupo = 'R') and (TruncX(Saldo[MC]) > 0))
                      then Abert := '<' + EditDouble(Saldo[MC]) + '>'
                      else Abert := ' ' + EditDouble(Saldo[MC]) + ' ';
                   SaldoX := TruncX(Saldo[MP]) - TruncX(Saldo[MC]);
                   If Saldo[MC] <> 0
                      then Fator := (1 - (Saldo[MP] / Saldo[MC])) * 100
                      else Fator := 0;
                   TotA := Saldo[MP];
                   TotP := Saldo[MC];
                   If TotA < 0 then TotA := TotA * -1;
                   If TotP < 0 then TotP := TotP * -1;
                   If TotA < TotP then
                      begin
                        TAtivo := '<' + EditDouble(SaldoX) + '>';
                        If Fator <> 0
                           then PercH  := '<' + EditDouble(Fator) + '>'
                           else PercH  := ' ' + EditDouble(Fator) + ' ';
                      end
                      else begin
                             TAtivo := ' ' + EditDouble(SaldoX) + ' ';
                             PercH  := ' ' + EditDouble(Fator) + ' ';
                           end;
                   If (Grupo in ['A','P']) and (Grau = '1')
                      then Fator := 100
                      else Case Grupo of
                                'A','D' : If TA <> 0
                                             then Fator := 100 - ((1 - (Saldo[MP] / TA)) * 100)
                                             else Fator := 0;
                                'P','R' : If TP <> 0
                                             then Fator := 100 - ((1 - (Saldo[MP] / TP)) * 100)
                                             else Fator := 0;
                           end;
                   PercV := EditDouble(Fator);
                   If (Tipo    = 'S') and
                      (ContLin > 10 ) then WriteLine('L',' ');
                   If T = 80
                      then WriteLine('L',Cx+PushLeft(19,OrigConta)+
                                     Acentua(Copy(Descricao,1,37))+
                                     ConstStr(' ',38-Length(Copy(Descricao,1,37)))+
                                     PushRight(18,Sald)+' '+
                                     PushRight(18,Abert)+' '+
                                     PushRight(18,TAtivo)+ConstStr(' ',3)+
                                     PushRight(8,PercH)+ConstStr(' ',4)+
                                     PushRight(8,PercV)+Cf)
                      else WriteLine('L',PushLeft(19,OrigConta)+
                                     Acentua(Copy(Descricao,1,37))+
                                     ConstStr(' ',38-Length(Copy(Descricao,1,37)))+
                                     PushRight(18,Sald)+' '+
                                     PushRight(18,Abert)+' '+
                                     PushRight(18,TAtivo)+ConstStr(' ',2)+
                                     PushRight(8,PercH)+' '+
                                     PushRight(8,PercV));
                 end;
            end;
         GoNoGo;
         If TC = #27 then RC := 'N';
       Until RC = 'N';
       If NCont > 0 then
          begin
            TC := #13;
            Footer;
            If DskRpt = 'N' then WriteLine('W',Qp);
          end;
       Window(1,1,80,25);
       MarkBlue;
       GotoXY(1,23);  Write(' Total de Contas Impressas: ');
       Color(Blue,White);
       GotoXY(29,23); Write(NCont:3);
       TeclaReturn;
     end;
end;

end.

