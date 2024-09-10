{$O+,F+}
Unit AlogRpt1;

Interface

Uses Crt,Dos,AlogGlbs,AlogNavg,AlogBasP,AlogInit,AlogRpt0;


   Procedure ProcNo01Report;
   Procedure ProcNo02Report;
   Procedure ProcNo03Report;
   Procedure ProcNo04Report;
   Procedure ProcNo05Report;
   Procedure ProcNo06Report;
   Procedure ProcNo07Report;


Implementation

Var
  MesP       : Integer;
  Ordem      : Array[1..4] of Char;

Procedure ProcNo01Report;
Var
  Mov           : Char;
  Gr1,Gr2       : Str9;
begin
  PedeLFReport;
  If TC = 'S' then
     begin
       NCont   := 0;
       ContaNo := '';
       Color(Blue,Cyan);
       GotoXY(1,23); Write(ConstStr(' ',80));
       GotoXY(2,23); Write('Imprime s¢ as contas que tem movimento? (S/N)');
       Repeat
         Mov := UpCase(ReadKey);
       Until Mov in ['N','S'];
       LimpaLn(23,Tfd);
       ParaContinua;
       MessageReport;
       Repeat
         RC := 'N';
         SearchPos1 ( Root1 );
         If RC = 'S' then
            With ContaMember do
            begin
              ReadWrite(#06,'R','N',ContaNumber);
              ReadWrite(#03,'R','N',ContaNumber);
              If (RW                       = 'S') and
                 (Mov                      = 'N') or
                 ((Mov                     = 'S') and
                  (SaldMember.Abertura[MM] <> 0 ) or
                  (SaldMember.Debitos[MM]  <> 0 ) or
                  (SaldMember.Creditos[MM] <> 0 )) then
                 begin
                   NCont := NCont + 1;
                   Writeln(Descricao);
                   If ContLin > 56 then HeaderAnualReport;
                   If Length(Descricao) = 40
                      then DescrConta := Descricao
                      else begin
                             I := 39 - Length(Descricao);
                             DescrConta := Descricao + ' ' + ConstStr('.',I);
                           end;
                   Val(Grau,I,E);
                   Gr1 := ConstStr(' ',I);
                   I   := 9 - I;
                   If I > 0 then Gr2 := ConstStr('.',I)
                            else Gr2 := '';
                   ReadWrite(#06,'R','N',ContaNumber);
                   If T = 80
                      then WriteLine('L',Cx+PushLeft(18,OrigConta)+Gr1+
                                     Acentua(DescrConta)+Gr2+' '+Grupo+
                                     Tipo+Grau+Aceita+Avisa+
                                     PedeDepto+GrupoE+Correcao+
                                     PeriodoC+' '+PushRight(2,IndiceC)+' '+
                                     PushLeft(21,CPartidaC)+
                                     PushLeft(21,CPartidaX)+
                                     PushLeft(4,HistoricoC)+
                                     PushLeft(2,SaldMember.Status)+
                                     QQStr(ContaNumber,4,' ')+Cf)
                      else WriteLine('L',PushLeft(18,OrigConta)+Gr1+
                                     Acentua(DescrConta)+Gr2+' '+Grupo+Tipo+
                                     Grau+Aceita+Avisa+PedeDepto+
                                     GrupoE+Correcao+PeriodoC+' '+
                                     PushRight(2,IndiceC)+' '+
                                     PushLeft(19,CPartidaC)+
                                     PushLeft(19,CPartidaX)+
                                     PushLeft(4,HistoricoC)+
                                     Pushleft(2,SaldMember.Status)+
                                     PushLeft(5,QQStr(ContaNumber,4,' ')));
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


Procedure ProcNo02Report;
begin
  Confirma;
  If TC = 'S' then
     begin
       HeaderReportSetUp;
       ParaContinua;
       MessageReport;
       If FileSize(HsPdFile) > 0 then
          With HsPdMember do
          begin
            NCont := 0;
            HHNo  := '';
            Repeat
              RC := 'N';
              SearchPos8 ( Root8 );
              If RC = 'S' then
                 begin
                   ReadWrite(#10,'R','N',HHNumber);
                   If RW = 'S' then
                      begin
                        NCont := NCont + 1;
                        Writeln(Descricao);
                        If ContLin > 56 then HeaderReport;
                        WriteLine('L',PushLeft(7,HHNo)+Acentua(Descricao));
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
            GotoXY(1,23);  Write(' Total de Hist¢ricos Impressos: ');
            Color(Blue,White);
            GotoXY(33,23); Write(NCont:3);
            TeclaReturn;
          end;
     end;
end;


Procedure ProcNo03Report;
begin
  Confirma;
  If TC = 'S' then
     With DeptMember do
     begin
       HeaderReportSetUp;
       ParaContinua;
       MessageReport;
       NCont  := 0;
       DeptNo := '';
       Repeat
         RC := 'N';
         SearchPos3 ( Root3 );
         If RC = 'S' then
            begin
              ReadWrite(#05,'R','N',DeptNumber);
              If RW = 'S' then
                 begin
                   NCont := NCont + 1;
                   Writeln(NomeDepto);
                   If ContLin > 56 then HeaderReport;
                   WriteLine('L',PushLeft(9,OrigChave)+Nx+
                                 Acentua(NomeLocal)+Nf+
                                 ConstStr(' ',33-Length(NomeLocal))+
                                 Acentua(NomeDepto)+
                                 ConstStr(' ',34-Length(NomeDepto))+Status);
                 end;
            GoNoGo;
            If TC = #27 then RC := 'N';
         end;
       Until RC = 'N';
       If NCont > 0 then
          begin
            TC := #13;
            Footer;
            If DskRpt = 'N' then WriteLine('W',Qp);
          end;
       Window(1,1,80,25);
       MarkBlue;
       GotoXY(1,23);  Write(' Total de Departamentos Impressos: ');
       Color(Blue,White);
       GotoXY(36,23); Write(NCont:3);
       TeclaReturn;
     end;
end;


Procedure ProcNo04Report;
begin
  Confirma;
  If TC = 'S' then
     With EcoMember do
     begin
       HeaderReportSetUp;
       ParaContinua;
       MessageReport;
       NCont := 0;
       IINo  := '';
       Repeat
         RC := 'N';
         SearchPos7 ( Root7 );
         If RC = 'S' then
            begin
              ReadWrite(#12,'R','N',IINumber);
              If RW = 'S' then
                 begin
                   NCont := NCont + 1;
                   Writeln(Descricao);
                   If ContLin > 56 then HeaderReport;
                   If T = 80 then
                      begin
                        WriteLine('L',PushRight(2,Chave)+' '+
                                  Nx+Acentua(Descricao)+Nf+
                                  ConstStr(' ',7-Length(Descricao))+
                                  Tipo+' '+
                                  PushRight(10,EditDouble(Valores[1]))+' '+
                                  PushRight(10,EditDouble(Valores[2]))+' '+
                                  PushRight(10,EditDouble(Valores[3]))+' '+
                                  PushRight(10,EditDouble(Valores[4]))+' '+
                                  PushRight(10,EditDouble(Valores[5]))+' '+
                                  PushRight(10,EditDouble(Valores[6])));
                        WriteLine('L',ConstStr(' ',12)+
                                  PushRight(10,EditDouble(Valores[07]))+' '+
                                  PushRight(10,EditDouble(Valores[08]))+' '+
                                  PushRight(10,EditDouble(Valores[09]))+' '+
                                  PushRight(10,EditDouble(Valores[10]))+' '+
                                  PushRight(10,EditDouble(Valores[11]))+' '+
                                  PushRight(10,EditDouble(Valores[12])));
                      end
                      else begin
                             WriteLine('L',ConstStr(' ',2)+
                                       PushRight(2,Chave)+ConstStr(' ',4)+
                                       Nx+Acentua(Descricao)+Nf+
                                       ConstStr(' ',10-Length(Descricao))+
                                       Tipo+ConstStr(' ',6)+
                                       PushRight(10,EditDouble(Valores[1]))+ConstStr(' ',7)+
                                       PushRight(10,EditDouble(Valores[2]))+ConstStr(' ',7)+
                                       PushRight(10,EditDouble(Valores[3]))+ConstStr(' ',7)+
                                       PushRight(10,EditDouble(Valores[4]))+ConstStr(' ',7)+
                                       PushRight(10,EditDouble(Valores[5]))+ConstStr(' ',7)+
                                       PushRight(10,EditDouble(Valores[6])));
                             WriteLine('L',ConstStr(' ',25)+
                                       PushRight(10,EditDouble(Valores[07]))+ConstStr(' ',7)+
                                       PushRight(10,EditDouble(Valores[08]))+ConstStr(' ',7)+
                                       PushRight(10,EditDouble(Valores[09]))+ConstStr(' ',7)+
                                       PushRight(10,EditDouble(Valores[10]))+ConstStr(' ',7)+
                                       PushRight(10,EditDouble(Valores[11]))+ConstStr(' ',7)+
                                       PushRight(10,EditDouble(Valores[12])));
                           end;
                   WriteLine('L',' ');
                 end;
              GoNoGo;
              If TC = #27 then RC := 'N';
            end;
       Until RC = 'N';
       If NCont > 0 then
          begin
            TC := #13;
            Footer;
            If DskRpt = 'N' then WriteLine('W',Qp);
          end;
       Window(1,1,80,25);
       MarkBlue;
       GotoXY(1,23);  Write(' Total de Indices Impressos: ');
       Color(Blue,White);
       GotoXY(30,23); Write(NCont:3);
       TeclaReturn;
     end;
end;


Procedure ProcNo05Report;
begin
  Confirma;
  If TC = 'S' then
     With LoteMember do
     begin
       HeaderReportSetUp;
       ParaContinua;
       MessageReport;
       NCont  := 0;
       LoteNo := '';
       Repeat
         RC     := 'N';
         SearchPos2 ( Root2 );
         If RC = 'S' then
            begin
              ReadWrite(#04,'R','N',LoteNumber);
              If (RW = 'S'        ) and
                 (MM = MesContabil) then
                 begin
                   NCont := NCont + 1;
                   Writeln(Chave);
                   If ContLin > 56 then HeaderReport;
                   If TruncX(Debito) = TruncX(Credito) then J := ''
                                                       else J := 'Erro';
                   If T = 80
                      then WriteLine('L',Nx+PushLeft(10,Chave)+Nf+
                                     Tipo+ConstStr(' ',3)+Status+
                                     ConstStr(' ',3)+
                                     DataAbert+ConstStr(' ',2)+
                                     PushRight(4,EditInteger(RDebito))+' '+
                                     PushRight(18,EditDouble(Debito))+' '+
                                     PushRight(4,EditInteger(RCredito))+' '+
                                     PushRight(18,EditDouble(Credito))+' '+J)
                      else WriteLine('L',ConstStr(' ',26)+Nx+
                                     PushLeft(10,Chave)+Nf+
                                     Tipo+ConstStr(' ',3)+Status+
                                     ConstStr(' ',3)+
                                     DataAbert+ConstStr(' ',2)+
                                     PushRight(4,EditInteger(RDebito))+' '+
                                     PushRight(18,EditDouble(Debito))+' '+
                                     PushRight(4,EditInteger(RCredito))+' '+
                                     PushRight(18,EditDouble(Credito))+' '+J);
                 end;
              GoNoGo;
              If TC = #27 then RC := 'N';
            end;
       Until RC = 'N';
       If NCont > 0 then
          begin
            TC := #13;
            Footer;
            If DskRpt = 'N' then WriteLine('W',Qp);
          end;
       Window(1,1,80,25);
       MarkBlue;
       GotoXY(1,23);  Write(' Total de Lotes Impressos: ');
       Color(Blue,White);
       GotoXY(28,23); Write(NCont:3);
       TeclaReturn;
     end;
end;


Procedure ContaRazaoReport(X : Char);
begin
  Abert := '';
  If ((ContaMember.Grupo in ['A','D','T']) and (TruncX(SaldoX) < 0)) or
     ((ContaMember.Grupo in ['P','R'    ]) and (TruncX(SaldoX) > 0))
     then Abert := '<' + EditDouble(SaldoX) + '>'
     else Abert := ' ' + EditDouble(SaldoX) + ' ';
  If TruncX(SaldoX) = 0 then Abert := '';
  If (ContLin + 3) > 55 then HeaderAnualReport;
  If X = 'A' then
     begin
       WriteLine('L',Acentua(ArrayMesEx[MM])+'/'+QQStr(AA,2,'0'));
       WriteLine('L',ConstStr('-',T));
     end;
  WriteLine('L',' ');
  If T = 80
     then WriteLine('L',Nx+PushLeft(19,ContaMember.OrigConta)+
                      Acentua(ContaMember.Descricao)+
                      ConstStr(' ',47-Length(ContaMember.Descricao))+Nf+
                      Cx+PushRight(22,Abert)+Cf)
     else WriteLine('L',Nx+PushLeft(19,ContaMember.OrigConta)+
                      Acentua(ContaMember.Descricao)+
                      ConstStr(' ',95-Length(ContaMember.Descricao))+Nf+
                      PushRight(18,Abert));
  WriteLine('L',' ');
end;


Procedure ImprimeLRazao;
begin
  With LctoMember do
  begin
    If ((Historico[2] <> '') or (Historico[3] <> '')) then
       begin
         Case T of
              80  : WriteLine('L',Cx+ConstStr(' ',6)+
                                  PushLeft(2,Copy(OrigData,1,2))+'   '+
                                  PushLeft(6,Lote)+'x'+
                                  PushLeft(5,SeqLote)+
                                  Acentua(Historico[1])+Cf);
              else  WriteLine('L',PushLeft(2,Copy(OrigData,1,2))+' '+
                                  PushLeft(6,Lote)+'x'+
                                  PushLeft(5,SeqLote)+
                                  Acentua(Historico[1]));
         end;
         If ((Historico[2] <> '') and (Historico[3] <> '')) then
            Case T of
                 80  : WriteLine('L',Cx+ConstStr(' ',23)+Acentua(Historico[2])+Cf);
                 else  WriteLine('L',ConstStr(' ',15)+Acentua(Historico[2]));
            end;
         If Historico[3] <> '' then HistP := Historico[3]
                               else HistP := Historico[2];
         Case T of
              80  : If Tipo = 'D'
                       then WriteLine('L',Cx+ConstStr(' ',23)+Acentua(HistP)+
                                          ConstStr(' ',61-Length(HistP))+
                                          PushRight(14,EditDouble(Valor))+
                                          ConstStr(' ',15)+
                                          PushRight(19,Sald)+Cf)
                       else WriteLine('L',Cx+ConstStr(' ',23)+Acentua(HistP)+
                                          ConstStr(' ',76-Length(HistP))+
                                          PushRight(14,EditDouble(Valor))+' '+
                                          PushRight(18,Sald)+Cf);
              else  If Tipo = 'D'
                       then WriteLine('L',ConstStr(' ',15)+Acentua(HistP)+
                                          ConstStr(' ',61-Length(HistP))+
                                          PushRight(18,EditDouble(Valor))+
                                          ConstStr(' ',20)+
                                          PushRight(18,Sald))
                       else WriteLine('L',ConstStr(' ',15)+Acentua(HistP)+
                                          ConstStr(' ',80-Length(HistP))+
                                          PushRight(18,EditDouble(Valor))+' '+
                                          PushRight(18,Sald));
         end;
       end
       else Case T of
                 80  : If Tipo = 'D'
                          then WriteLine('L',Cx+ConstStr(' ',6)+
                                               Copy(OrigData,1,2)+'   '+
                                               PushLeft(6,Lote)+'x'+
                                               PushLeft(5,SeqLote)+
                                               Acentua(Historico[1])+
                                               ConstStr(' ',61-Length(Historico[1]))+
                                               PushRight(14,EditDouble(Valor))+
                                               ConstStr(' ',15)+
                                               PushRight(19,Sald)+Cf)
                          else WriteLine('L',Cx+ConstStr(' ',6)+
                                               Copy(OrigData,1,2)+'   '+
                                               PushLeft(6,Lote)+'x'+
                                               PushLeft(5,SeqLote)+
                                               Acentua(Historico[1])+
                                               ConstStr(' ',76-Length(Historico[1]))+
                                               PushRight(14,EditDouble(Valor))+
                                               ' '+PushRight(18,Sald)+Cf);
                 else  If Tipo = 'D'
                          then WriteLine('L',Copy(OrigData,1,2)+' '+
                                             PushLeft(6,Lote)+'x'+
                                             PushLeft(5,SeqLote)+
                                             Acentua(Historico[1])+
                                             ConstStr(' ',61-Length(Historico[1]))+
                                             PushRight(18,EditDouble(Valor))+
                                             ConstStr(' ',20)+
                                             PushRight(18,Sald))
                          else WriteLine('L',Copy(OrigData,1,2)+' '+
                                             PushLeft(6,Lote)+'x'+
                                             PushLeft(5,SeqLote)+
                                             Acentua(Historico[1])+
                                             ConstStr(' ',80-Length(Historico[1]))+
                                             PushRight(18,EditDouble(Valor))+' '+
                                             PushRight(18,Sald));
            end;
  end;
end;


Procedure LinhaRazaoReport;
begin
  With LctoMember do
  begin
    Case Tipo of
         'C' : begin
                 SaldoX    := SaldoX    - TruncX(Valor);
                 TCreditos := TCreditos + TruncX(Valor);
               end;
         'D' : begin
                 SaldoX   := SaldoX   + TruncX(Valor);
                 TDebitos := TDebitos + TruncX(Valor);
               end;
    end;
    CDVSAX := CDVSNo;
    RC     := 'N';
    SearchPos4 ( Root4 );
    If RC = 'S' then
       begin
         ReadWrite(#08,'R','N',CDVSNumber);
         If DiaQ <> Copy(OrigData,1,2) then
            begin
              DiaQ := Copy(OrigData,1,2);
              If ((ContaMember.Grupo in ['A','D','T']) and (TruncX(SaldoX) < 0)) or
                 ((ContaMember.Grupo in ['P','R']    ) and (TruncX(SaldoX) > 0))
                 then Sald := '<' + EditDouble(SaldoX) + '>'
                 else Sald := ' ' + EditDouble(SaldoX) + ' ';
            end
            else Sald := '';
       end
       else Sald := '';
    CDVSNo := CDVSAX;
    SearchTree4 ( Root4 );
    ReadWrite(#08,'R','N',CDVSNumber);
    HistP := '';
    ImprimeLRazao;
  end;
end;


Procedure ImprimeContaRazao;
begin
  ReadWrite(#03,'R','N',ContaNumber);
  ReadWrite(#06,'R','N',ContaNumber);
  If (RW                       = 'S') and
     (SaldMember.Status       <> 'C') and
     (ContaMember.Tipo         = 'A') and
     (SaldMember.NLanctos[MM] <> 0  ) then
     begin
       NCont := NCont + 1;
       Writeln(ContaMember.Descricao);
       CDVSNo    := ContaNo + '#';
       DiaQ      := 'XX';
       TDebitos  := 0;
       TCreditos := 0;
       SaldoX    := SaldMember.Abertura[MM];
       If ContLin > 55 then HeaderAnualReport;
       ContaRazaoReport(TipR);
       Repeat
         RC := 'N';
         SearchPos4 ( Root4 );
         If (RC      = 'S') and
            (ContaNo = Copy(CDVSNo,1,Length(ContaNo))) then
            begin
              If ContLin > 55 then
                 begin
                   HeaderAnualReport;
                   ContaRazaoReport(TipR);
                 end;
                 ReadWrite(#08,'R','N',CDVSNumber);
                 If LctoMember.Status = 'A' then
                    begin
                      If DiaQ = 'XX' then DiaQ := Copy(LctoMember.OrigData,1,2);
                      LinhaRazaoReport;
                    end;
            end
            else RC := 'N';
         GoNoGo;
         If TC = #27 then RC := 'X';
       Until (RC = 'N') or (RC = 'X');
       If (ContLin + 4) > 55 then
          begin
            HeaderAnualReport;
            ContaRazaoReport(TipR);
          end;
       If T = 80
          then WriteLine('L',Cx+ConstStr(' ',84)+
                             '-------------- '+
                             '-------------- '+
                             '------------------')
          else WriteLine('L',ConstStr(' ',76)+
                             ConstStr('-',18)+' '+
                             ConstStr('-',18)+' '+
                             ConstStr('-',18));
       If ((ContaMember.Grupo in ['A','D','T']) and (TruncX(SaldoX) < 0)) or
          ((ContaMember.Grupo in ['P','R']    ) and (TruncX(SaldoX) > 0))
          then Sald := '<' + EditDouble(SaldoX) + '>'
          else Sald := ' ' + EditDouble(SaldoX) + ' ';
       If T = 80 then WriteLine('L',Cx+ConstStr(' ',84)+
                                    PushRight(14,EditDouble(TDebitos))+' '+
                                    PushRight(14,EditDouble(TCreditos))+
                                    PushRight(19,Sald)+Cf)
                 else WriteLine('L',ConstStr(' ',76)+
                                    PushRight(18,EditDouble(TDebitos))+' '+
                                    PushRight(18,EditDouble(TCreditos))+' '+
                                    PushRight(18,Sald));
       WriteLine('L',' ');
       WriteLine('L',ConstStr('-',T));
       If RC = 'X' then RC := 'N'
                   else RC := 'S';
     end;
end;




Procedure CarregaRazao;
begin
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
            GotoXY(1,24); Write(ConstStr(' ',80));
            GotoXY(2,24); Write('Estou carregando o Indice para ImpressÑo do           de ',
            ArrayMesEx[MesP]);
            Color(Blue,Yellow);
            GotoXY(46,24); Write('Relat¢rio');
            If Root4 <> NIL then Dispose4 (Root4);
            Root4 := NIL;
            Assign ( IndMFile, (XPath + '\' + FileLcto  + AAFx + '.I' + QQStr(MesP,2,'0')));
            {$I-}
            Reset ( IndMFile );
            {$I+}
            If IOResult = 0 then LoadLcto
                            else ReWrite ( IndMFile );
            Close ( IndMFile );
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
                 TC := 'N';
               end;
     end
     else TC := 'N';
end;


Procedure ImprimeTodosMesesRazao;
begin
  MesP := M1 - 1;
  Repeat
    MesP := MesP + 1;
    CarregaRazao;
    If TC = 'S' then
       begin
         ParaContinua;
         MessageReport;
         MM := MesP;
         ImprimeContaRazao;
         Window(1,1,80,25);
         {$I-}
         Close ( LctoFile );
         {$I+}
       end;
  Until MesP = M2;
end;


Procedure ProcNo06Report;
begin
  PedeLFReport;
  If TC = 'S' then PedeContaRazao;
  If TC = 'S' then
     begin
       {$I-}
       Close ( LctoFile );
       {$I+}
       Case TipR of
            'M' : begin
                    MesP := M1 - 1;
                    Repeat
                      MesP := MesP + 1;
                      CarregaRazao;
                      If TC = 'S' then
                         begin
                           ParaContinua;
                           MessageReport;
                           NCont   := 0;
                           ContLin := 1000;
                           MM      := MesP;
                           If ContaI <> '' then
                              begin
                                RC      := 'N';
                                ContaNo := LimpaChave(ContaI);
                                SearchAnt1 ( Root1 );
                                If RC = 'N' then ContaNo := '';
                              end
                              else ContaNo := '';
                           Repeat
                             RC := 'N';
                             SearchPos1 ( Root1 );
                             If RC = 'S' then ImprimeContaRazao;
                             If UltConta = ContaNo then RC := 'N';
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
                           {$I-}
                           Close ( LctoFile );
                           {$I+}
                         end;
                    Until MesP = M2;
                  end;
            'A' : begin
                    NCont   := 0;
                    ContLin := 1000;
                    MM      := MesP;
                    If ContaI <> '' then
                       begin
                         RC      := 'N';
                         ContaNo := LimpaChave(ContaI);
                         SearchAnt1 ( Root1 );
                         If RC = 'N' then ContaNo := '';
                       end
                       else ContaNo := '';
                    Repeat
                      RC := 'N';
                      SearchPos1 ( Root1 );
                      If RC = 'S' then
                         begin
                           ImprimeTodosMesesRazao;
                           RC := 'S';
                         end;
                      If UltConta = ContaNo then RC := 'N';
                      GoNoGo;
                      If TC = #27 then RC := 'N';
                    Until RC = 'N';
                    If NCont > 0 then
                       begin
                         TC := #13;
                         Footer;
                         If DskRpt = 'N' then WriteLine('W',Qp);
                       end;
                  end;
       end;
       MarkBlue;
       GotoXY(2,23);  Write('Fim da ImpressÑo do RazÑo');
       TeclaReturn;
       MM := CMstMember.MesAtivo;
       Assign (LctoFile, (XPath + '\' + FileLcto  + AAFx + '.' + MMFx));
       {$I-}
       Reset ( LctoFile );
       {$I+}
       Color(Blue,Cyan);
       GotoXY(1,24); Write(ConstStr(' ',80));
       GotoXY(2,24); Write('Recarregando os lanáamentos');
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


Procedure PedeProcNo07;
begin
  Color(Tfn,Ttx);
  GotoXY(4,12); Write('Ativo..:');
  GotoXY(4,13); Write('Passivo:');
  GotoXY(4,14); Write('Receita:');
  GotoXY(4,15); Write('Despesa:');
  GotoXY(4,17); Write('Modàlo.:');
  Color(Tfn,Utx);
  Ordem[1] := ' ';
  Ordem[2] := ' ';
  Ordem[3] := ' ';
  Ordem[4] := ' ';
  Modelo   := 0;
  DrawBox(23,15,57,19,Red,'S');
  Repeat
    K := 1;
    Repeat
      Case K of
           1..4   : begin
                      Color(Red,Cyan);
                      GotoXY(23,15); Write(' Ordem de ImpressÑo, use um digito ');
                      GotoXY(23,16); Write(' de 1 a 4 ou uma letra de A a C.   ');
                      GotoXY(23,17); Write(' Exemplo:  Coloca-se 1 na conta de ');
                      GotoXY(23,18); Write('           despesa fazendo com que ');
                      GotoXY(23,19); Write('           apareáa primeiro.       ');
                      Color(Red,White);
                      GotoXY(27,16); Write('1');
                      GotoXY(31,16); Write('4');
                      GotoXY(49,16); Write('A');
                      GotoXY(53,16); Write('C');
                      Color(Tfn,Utx);
                      J := Ordem[K];
                      InputStr(J,1,13,(11+K),0,'S','N','T','N',Tfn,Utx);
                      If TC <> #27 then Ordem[K] := J[1];
                 end;
           5   : begin
                   Color(Red,Cyan);
                   GotoXY(23,15); Write(' de 1 a 5 de acordo com o definido ');
                   GotoXY(23,16); Write(' no Plano de Contas no campo Balan ');
                   GotoXY(23,17); Write(' -cete. ê poss°vel ter atÇ 5 tipos ');
                   GotoXY(23,18); Write(' diferentes de Balancetes,   basta ');
                   GotoXY(23,19); Write(' especificar no Plano de Contas.   ');
                   Color(Tfn,Utx);
                   If Modelo = 0 then J := '1'
                                 else begin
                                        Str(Modelo:1,J);
                                        J := LeftAdjust(J);
                                      end;
		   InputStr(J,1,13,17,0,'S','N','T','N',Tfn,Utx);
                   If TC <> #27 then
                      begin
                        If J[1] in ['1','2','3','4','5'] then
                           begin
                             Val(J[1],Modelo,E);
                             GotoXY(13,17); Write(Modelo);
                           end
                           else begin
                                  ErroMsg := 'Responda de 1 atÇ 5';
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
    Until (K = 6) or (TC = #27);
    If TC <> #27 then Confirma;
  Until TC in ['S',#27];
end;


Procedure ProcNo07Report;
begin
  PedeLFReport;
  If TC = 'S' then PedeProcNo07;
  If TC = 'S' then
     begin
       If DI = 'S' then DescarregaI;
       If Root1 <> NIL then Dispose1 (Root1);
       Root1 := NIL;
       If Root3 <> NIL then Dispose3 (Root3);
       Root3 := NIL;
       If Root4 <> NIL then Dispose4 (Root4);
       Root4 := NIL;
       If Root6 <> NIL then Dispose6 (Root6);
       Root6 := NIL;
       Color(Blue,Cyan);
       GotoXY(01,24); Write(ConstStr(' ',80));
       GotoXY(02,24); Write('Estou criando Indice para ImpressÑo do ');
       Color(Blue,Yellow);
       GotoXY(41,24); Write('Relat¢rio');
       Color(Blue,(White + Blink));
       GotoXY(65,24); Write('Aguarde');
       ShowHeap;
       Color(Tfd,Utx);
       I := -1;
       Repeat
         I := I + 1;
         ReadWrite(#03,'R','N',I);
         If (RW                            = 'S') and
            (ContaMember.Balancete[Modelo] = 'S') then
            begin
              Case ContaMember.Grupo of
                   'A' : K := 1;
                   'P' : K := 2;
                   'R' : K := 3;
                   'D' : K := 4;
              end;
              DCVSNumber := I;
              DCVSNo     := Ordem[K] + '#' + ContaMember.Conta;
              LoadTree6 ( Root6 );
              ShowHeap;
              Color(Tfd,Utx);
            end;
       Until (I + 1) = FileSize(ContaFile);
       LimpaLn(24,Tfd);
       ParaContinua;
       MessageReport;
       TotA    := 0;
       TotD    := 0;
       TotP    := 0;
       TotR    := 0;
       NCont   := 0;
       DCVSNo  := '';
       Repeat
         RC := 'N';
         SearchPos6 ( Root6 );
         If RC = 'S' then
            With ContaMember do
            begin
              ReadWrite(#06,'R','N',DCVSNumber);
              If (RW                     = 'S') and
                 (SaldMember.Status     <> 'C') then
                 With SaldMember do
                 begin
                   ReadWrite(#03,'R','N',DCVSNumber);
                   NCont := NCont + 1;
                   Writeln(Descricao);
                   If Grau = '1' then
                      Case Grupo of
                           'A' : TotA := TotA + TruncX(Saldo[MM]);
                           'D' : TotD := TotD + TruncX(Saldo[MM]);
                           'P' : TotP := TotP + TruncX(Saldo[MM]);
                           'R' : TotR := TotR + TruncX(Saldo[MM]);
                      end;
                   If (Abertura[MM] <> 0) or
                      (Debitos[MM]  <> 0) or
                      (Creditos[MM] <> 0) then
                      begin
                        If ContLin > 56 then HeaderAnualReport;
                        If ((Grupo in ['A','D','T']) and (TruncX(Abertura[MM]) < 0)) or
                           ((Grupo in ['P','R']    ) and (TruncX(Abertura[MM]) > 0))
                           then Abert := '<' + EditDouble(TruncX(Abertura[MM] / VMo)) + '>'
                           else Abert := EditDouble(TruncX(Abertura[MM] / VMo)) + ' ';
                        If ((Grupo in ['A','D','T']) and (TruncX(Saldo[MM]) < 0)) or
                           ((Grupo in ['P','R']    ) and (TruncX(Saldo[MM]) > 0))
                           then Sald := '<' + EditDouble(TruncX(Saldo[MM] / VMo)) + '>'
                           else Sald := EditDouble(TruncX(Saldo[MM] / VMo)) + ' ';
                        If ((Avisa = 'D') and (TruncX(Saldo[MM]) > 0)) or
                           ((Avisa = 'C') and (TruncX(Saldo[MM]) < 0))
                           then Avs := '*'
                           else Avs := ' ';
                        If (Tipo    = 'S') and
                           (ContLin > 10 ) then WriteLine('L',' ');
                        If T = 80
                           then WriteLine('L',Cx+PushLeft(19,OrigConta)+
                                          Acentua(Descricao)+
                                          ConstStr(' ',41-Length(Descricao))+
                                          PushRight(18,Abert)+
                                          PushRight(18,EditDouble(TruncX(Debitos[MM] / VMo)))+' '+
                                          PushRight(18,EditDouble(TruncX(Creditos[MM] / VMo)))+' '+
                                          PushRight(18,Sald)+' '+Avs+Cf)
                           else WriteLine('L',PushLeft(19,OrigConta)+
                                          Acentua(Descricao)+
                                          Conststr(' ',41-Length(Descricao))+
                                          PushRight(18,Abert)+' '+
                                          PushRight(16,EditDouble(TruncX(Debitos[MM] / VMo)))+' '+
                                          PushRight(16,EditDouble(TruncX(Creditos[MM] / VMo)))+
                                          ' '+PushRight(18,Sald)+Avs);
                      end;
                 end;
            end;
         GoNoGo;
         If TC = #27 then RC := 'N';
       Until RC = 'N';
       If NCont > 0 then
          begin
            TC := #13;
            If ContLin > 48 then HeaderAnualReport;
            WriteLine('L',' ');
            If T = 80 then
               begin
                 WriteLine('L',Cx+ConstStr(' ',69)+'Ativo    '+
                           PushRight(20,EditDouble(TruncX(TotA / VMo)))+
                           ConstStr(' ',6)+'Ativo    '+
                           PushRight(20,EditDouble(TruncX(TotA / VMo)))+Cf);
                 WriteLine('L',Cx+ConstStr(' ',69)+'Despesa  '+
                           PushRight(20,EditDouble(TruncX(TotD / VMo)))+
                           ConstStr(' ',6)+'Passivo  '+
                           PushRight(20,EditDouble(TruncX(TotP / VMo)))+Cf);
                 WriteLine('L',Cx+ConstStr(' ',78)+'--------------------'+
                                  ConstStr(' ',15)+'--------------------'+Cf);
                 If (TotA + TotD) < 0
                    then J := '<' + EditDouble(TruncX((TotA + TotD) / VMo)) + '>'
                    else J := EditDouble(TruncX((TotA + TotD) / VMo)) + ' ';
                 If (TotA + TotP) < 0
                    then Sald := '<' + EditDouble(TruncX((TotA + TotP) / VMo)) + '>'
                    else Sald := EditDouble(TruncX((TotA + TotP) / VMo)) + ' ';
                 WriteLine('L',Cx+ConstStr(' ',78)+PushRight(21,J)+
                               ConstStr(' ',14)+PushRight(21,Sald)+Cf);
               end
               else begin
                      WriteLine('L',ConstStr(' ',66)+'Ativo    '+
                                PushRight(20,EditDouble(TruncX(TotA / VMo)))+
                                ConstStr(' ',6)+'Ativo    '+
                                PushRight(20,EditDouble(TruncX(TotA / VMo))));
                      Writeline('L',ConstStr(' ',66)+'Despesa  '+
                                PushRight(20,EditDouble(TruncX(TotD / VMo)))+
                                ConstStr(' ',6)+'Passivo  '+
                                PushRight(20,EditDouble(TruncX(TotP / VMo))));
                      Writeline('L',ConstStr(' ',75)+
                                '--------------------'+
                                ConstStr(' ',15)+
                                '--------------------');
                      If (TotA + TotD) < 0
                         then J := '<' + EditDouble(TruncX((TotA + TotD) / VMo)) + '>'
                         else J := EditDouble(TruncX((TotA + TotD) / VMo)) + ' ';
                      If (TotA + TotP) < 0
                         then Sald := '<' + EditDouble(TruncX((TotA + TotP) / VMo)) + '>'
                         else Sald := EditDouble(TruncX((TotA + TotP) / VMo)) + ' ';
                      WriteLine('L',ConstStr(' ',75)+
                                PushRight(21,J)+ConstStr(' ',14)+
                                PushRight(21,Sald));
                    end;
            WriteLine('L',' ');
            If T = 80 then
               begin
                 WriteLine('L',Cx+ConstStr(' ',69)+'Passivo  '+
                           PushRight(20,EditDouble(TruncX(TotP / VMo)))+
                           ConstStr(' ',6)+'Receita  '+
                           PushRight(20,EditDouble(TruncX(TotR / VMo)))+Cf);
                 WriteLine('L',Cx+ConstStr(' ',69)+'Receita  '+
                           PushRight(20,EditDouble(TruncX(TotR / VMo)))+
                           ConstStr(' ',6)+'Despesa  '+
                           PushRight(20,EditDouble(TruncX(TotD / VMo)))+Cf);
                 WriteLine('L',Cx+ConstStr(' ',78)+'--------------------'+
                                  ConstStr(' ',15)+'--------------------'+Cf);
                 If (TotP + TotR) < 0
                    then J := '<' + EditDouble(TruncX((TotP + TotR) / VMo)) + '>'
                    else J := EditDouble(TruncX((TotP + TotR) / VMo)) + ' ';
                 If (TotR + TotD) < 0
                    then Sald := '<' + EditDouble(TruncX((TotR + TotD) / VMo)) + '>'
                    else Sald := EditDouble(TruncX((TotR + TotD) / VMo)) + ' ';
                 WriteLine('L',Cx+ConstStr(' ',78)+PushRight(21,J)+
                           ConstStr(' ',14)+PushRight(21,Sald)+Cf);
               end
               else begin
                      WriteLine('L',ConstStr(' ',66)+'Passivo  '+
                                PushRight(20,EditDouble(TruncX(TotP / VMo)))+
                                ConstStr(' ',6)+'Receita  '+
                                PushRight(20,EditDouble(TruncX(TotR / VMo))));
                      WriteLine('L',ConstStr(' ',66)+'Receita  '+
                                PushRight(20,EditDouble(TruncX(TotR / VMo)))+
                                ConstStr(' ',6)+'Despesa  '+
                                PushRight(20,EditDouble(TruncX(TotD / VMo)))+Nf);
                      WriteLine('L',ConstStr(' ',75)+
                                '--------------------'+ConstStr(' ',15)+
                                '--------------------');
                      If (TotP + TotR) < 0
                         then J := '<' + EditDouble(TruncX((TotP + TotR) / VMo)) + '>'
                         else J := EditDouble(TruncX((TotP + TotR) / VMo)) + ' ';
                      If (TotR + TotD) < 0
                         then Sald := '<' + EditDouble(TruncX((TotR + TotD) / VMo)) + '>'
                         else Sald := EditDouble(TruncX((TotR + TotD) / VMo)) + ' ';
                      WriteLine('L',ConstStr(' ',75)+
                                Nx+PushRight(21,J)+ConstStr(' ',14)+
                                PushRight(21,Sald));
                    end;
            Footer;
            If DskRpt = 'N' then WriteLine('W',Qp);
          end;
       Window(1,1,80,25);
       MarkBlue;
       GotoXY(01,23); Write(' Total de Contas Impressas: ');
       Color(Blue,White);
       GotoXY(29,23); Write(NCont:3);
       Color(Red,White);
       GotoXY(01,24); Write(ConstStr(' ',80));
       GotoXY(02,24); Write('Recarregando os lanáamentos');
       Color(Red,(White + Blink));
       GotoXY(65,24); Write('Aguarde');
       If Root6 <> NIL then Dispose6 (Root6);
       Root6 := NIL;
       {$I-}
       Reset ( IndMFile );
       {$I+}
       If IOResult = 0 then LoadLcto
                       else ReWrite ( IndMFile );
       Close ( IndMFile );
       {$I-}
       Reset ( IndxFile );
       {$I+}
       If IOResult = 0 then LoadIndex
                       else ReWrite ( IndxFile );
       Close  ( IndxFile );
       TeclaReturn;
     end;
end;


end.
