Procedure RetiraDaConta(X,Y : Char);
begin
  Repeat
    SearchTree1 ( Root1 );
    If RC = 'S' then
       begin
         ReadWrite(#03,'R','N',ContaNumber);
         ReadWrite(#06,'R','N',ContaNumber);
         Case LctoMember.Tipo of
              'D' : SaldMember.Debitos[MM]  := SaldMember.Debitos[MM]  -
                                               TruncX(LctoMember.Valor);
              'C' : SaldMember.Creditos[MM] := SaldMember.Creditos[MM] -
                                               TruncX(LctoMember.Valor);
         end;
         SaldMember.Saldo[MM]  := SaldMember.Abertura[MM] +
                                  SaldMember.Debitos[MM]  -
                                  SaldMember.Creditos[MM];
         If X <> 'E' then SaldMember.SaldoB[MM] := SaldMember.Saldo[MM];
         If Y = 'E' then
            begin
	      SaldMember.NLanctos[MM] := SaldMember.NLanctos[MM] - 1;
              Y                       := 'N';
            end;
         If (MM               <  12 ) and
            ((CMstMember.TipoE <> 'M') or
             ((CMstMember.TipoE = 'M') and (ContaMember.Grupo in ['A','P']))) then
            With SaldMember do
            begin
              For I := MM to 12 do
              begin
                If I > 1 then Abertura[I] := Saldo[I-1];
                Saldo[I]  := Abertura[I] + Debitos[I] - Creditos[I];
                If X <> 'E' then SaldoB[I] := Saldo[I];
              end;
            end;
         ReadWrite(#06,'W','N',ContaNumber);
         ContaNo := ContaMember.Sintetica;
       end;
  Until (RC = 'N') or (ContaMember.Grau = '1');
end;


Procedure ColocaNaConta(X,Y : Char);
begin
  Repeat
    SearchTree1 ( Root1 );
    If RC = 'S' then
       begin
         ReadWrite(#03,'R','N',ContaNumber);
         If RW = 'S' then
            begin
              ReadWrite(#06,'R','N',ContaNumber);
              If RW = 'S' then
                 begin
                   Case LctoMember.Tipo of
                        'D' : SaldMember.Debitos[MM]  := SaldMember.Debitos[MM]  +
                                                         TruncX(LctoMember.Valor);
                        'C' : SaldMember.Creditos[MM] := SaldMember.Creditos[MM] +
                                                         TruncX(LctoMember.Valor);
                   end;
                   SaldMember.Saldo[MM] := SaldMember.Abertura[MM] +
                                           SaldMember.Debitos[MM]  -
                                           SaldMember.Creditos[MM];
                   If X <> 'E' then SaldMember.SaldoB[MM] := SaldMember.Saldo[MM];
                   If Y = 'I' then
                      begin
	                SaldMember.NLanctos[MM] := SaldMember.NLanctos[MM] + 1;
                        Y                       := 'N';
                      end;
                   If (MM               <  12 ) and
                      ((CMstMember.TipoE <> 'M') or
                       ((CMstMember.TipoE = 'M') and (ContaMember.Grupo in ['A','P']))) then
                      With SaldMember do
                      begin
                        For I := MM to 12 do
                        begin
                          If I > 1 then Abertura[I] := Saldo[I-1];
                          Saldo[I] := Abertura[I] + Debitos[I] - Creditos[I];
                          If X <> 'E' then SaldoB[I] := Saldo[I];
                        end;
                      end;
                   ReadWrite(#06,'W','N',ContaNumber);
                   ContaNo := ContaMember.Sintetica;
                 end
                 else RC := 'N';
            end
            else RC := 'N';
       end;
  Until (RC = 'N') or (ContaMember.Grau = '1');
end;


Procedure RetiraDaDespesa;
begin
  ExpeNo := LimpaChave(LctoMember.Depto) + '#' + ContaNo;
  SearchTree5 ( Root5 );
  If RC = 'S' then
     begin
       ReadWrite(#07,'R','N',ExpeNumber);
       Case LctoMember.Tipo of
            'D' : ExpeMember.Despesas[MM] := ExpeMember.Despesas[MM] -
                                             TruncX(LctoMember.Valor);
            'C' : ExpeMember.Despesas[MM] := ExpeMember.Despesas[MM] +
                                             TruncX(LctoMember.Valor);
       end;
       ReadWrite(#07,'W','N',ExpeNumber);
     end;
end;


Procedure ColocaNaDespesa;
begin
  ExpeNo := LimpaChave(LctoMember.Depto) + '#' + ContaNo;
  SearchTree5 ( Root5 );
  If RC = 'S' then
     begin
       ReadWrite(#07,'R','N',ExpeNumber);
       Case LctoMember.Tipo of
            'D' : ExpeMember.Despesas[MM] := ExpeMember.Despesas[MM] +
                                             TruncX(LctoMember.Valor);
            'C' : ExpeMember.Despesas[MM] := ExpeMember.Despesas[MM] -
                                             TruncX(LctoMember.Valor);
       end;
       ReadWrite(#07,'W','N',ExpeNumber);
     end
     else With ExpeMember do
          begin
            ExpeMember.Depto      := Lctomember.Depto;
            ExpeMember.Conta      := LctoMember.Conta;
            ExpeMember.Corrigivel := ' ';
            ExpeMember.IndiceX    := '';
            ExpeNumber            := FileSize(ExpeFile);
            For I := 1 to 12 do begin
                                  ExpeMember.ValorO[I]   := 0;
                                  ExpeMember.Despesas[I] := 0;
                                end;
            Case LctoMember.Tipo of
                 'D' : ExpeMember.Despesas[MM] := ExpeMember.Despesas[MM] +
                                                  TruncX(LctoMember.Valor);
                 'C' : ExpeMember.Despesas[MM] := ExpeMember.Despesas[MM] -
                                                  TruncX(LctoMember.Valor);
            end;
            ReadWrite(#07,'W','N',ExpeNumber);
            LoadTree5 ( Root5 );
          end;
end;


Procedure AtualizaLancamento;
begin
  PreparaTelaLancamento;
  SearchTree6 ( Root6 );
  If RC = 'S' then
     begin
       ReadWrite(#08,'R','N',DCVSNumber);
       If RW = 'S' then
          begin
            Val(LctoMember.SeqLote,XLanc,E);
            GotoXY(12,14); Write(XLanc);
            Op := 'A';
            ScreenLancamento;
            If LctoMember.Status  = 'A' then
               Case LctoMember.Tipo of
                    'D' : LoteMember.Debito  := LoteMember.Debito   -
                                                TruncX(LctoMember.Valor);
                    'C' : LoteMember.Credito := LoteMember.Credito  -
                                                TruncX(LctoMember.Valor);
               end;
            ContaNo  := LimpaChave(LctoMember.Conta);
            ContaAC  := ContaNo;
            ContaAX  := ContaNo;
            SearchTree1 ( Root1 );
            If RC = 'S' then
               begin
                 ReadWrite(#03,'R','N',ContaNumber);
                 ContaAN := ContaNumber;
                 If LctoMember.Status = 'A' then
                    begin
                      If (Length(LctoMember.Depto)  <> 0) and
                         (ContaMember.Grupo in ['D','R']) then RetiraDaDespesa;
                      RetiraDaConta(LoteMember.Tipo,'E');
                    end;
                 EntryLancamento;
                 If TC = 'S' then
                    With LoteMember do
                    begin
                      If ContaDB <> '' then
                         begin
                           LctoMember.Tipo  := 'D';
                           LctoMember.Conta := ContaDB;
                         end
                         else begin
                                LctoMember.Tipo  := 'C';
                                LctoMember.Conta := ContaCR;
                              end;
                      ContaNo := LimpaChave(LctoMember.Conta);
                      Case LctoMember.Status of
                           'A' : begin
                                   Case LctoMember.Tipo of
                                        'D' : Debito  := Debito   + TruncX(LctoMember.Valor);
                                        'C' : Credito := Credito  + TruncX(LctoMember.Valor);
                                   end;
                                   If (Length(LctoMember.Depto)  <> 0 ) and
                                      (ContaMember.Grupo in ['D','R'] )
                                      then ColocaNaDespesa;
                                   ReadWrite(#08,'W','N',DCVSNumber);
                                   If ContaAX <> ContaNo then
                                      begin
                                        CDVSNumber := DCVSNumber;
                                        DelTree6 ( Root6 );
                                        DCVSNo := LoteNo                        + '#' +
                                                  Copy(LctoMember.OrigData,1,2) + '#' +
                                                  LctoMember.SeqLote            + '#' +
                                                  ContaNo;
                                        DCVSNumber := CDVSNumber;
                                        LoadTree6 ( Root6 );
                                        DM := 'S';
                                      end;
                                   ColocaNaConta(LoteMember.Tipo,'I');
                                 end;
                           'C' : begin
                                   LctoMember.Status   := '*';
                                   LctoMember.OrigData := '';
                                   LctoMember.Conta    := '';
                                   LctoMember.Lote     := '';
                                   ReadWrite(#08,'W','N',DCVSNumber);
                                   DelTree6 ( Root6 );
                                   Case LctoMember.Tipo of
                                        'D' : LoteMember.RDebito  := LoteMember.RDebito - 1;
                                        'C' : LoteMember.RCredito := LoteMember.RCredito  - 1;
                                   end;
                                   DM := 'S';
                                 end;
                      end;
                      ReadWrite(#04,'W','N',LoteNumber);
                    end
                    else With LoteMember do
                         begin
                           ReadWrite(#08,'R','N',DCVSNumber);
                           If LctoMember.Status = 'A' then
                              begin
                                Case LctoMember.Tipo of
                                   'D' : Debito  := Debito   +
                                                    TruncX(LctoMember.Valor);
                                   'C' : Credito := Credito  +
                                                    TruncX(LctoMember.Valor);
                                end;
                                ContaNo := LimpaChave(LctoMember.Conta);
                                SearchTree1 ( Root1 );
                                If RC = 'S' then ReadWrite(#03,'R','N',ContaNumber);
                                If (Length(LctoMember.Depto)  <> 0) and
                                   (ContaMember.Grupo in ['D','R']) then ColocaNaDespesa;
                                ColocaNaConta(LoteMember.Tipo,'I');
                              end;
                           ReadWrite(#04,'W','N',LoteNumber);
                         end;
               end;
          end;
     end;
  TotalDoLote;
end;


Procedure IncluiLancamento;
begin
  Avs   := 'N';
  XLanc  := 0;
  DCVSNo := LoteNo + '#';
  Repeat
    RC := 'N';
    SearchPos6 ( Root6 );
    If (RC         = 'S'                            ) and
       (LoteNo+'#' = Copy(DCVSNo,1,Length(LoteNo)+1))
       then XLanc := XLanc + 1
       else RC := 'N';
  Until RC = 'N';
  XLanc := XLanc + 1;
  PreparaTelaLancamento;
  Repeat
    LctoMember.Status       := 'A';
    LctoMember.OrigData     := WData;
    LctoMember.Conta        := '';
    LctoMember.MesLancto    := MM;
    LctoMember.Tipo         := ' ';
    LctoMember.Valor        := 0;
    LctoMember.Depto        := '';
    LctoMember.Historico[1] := '';
    LctoMember.Historico[2] := '';
    LctoMember.Historico[3] := '';
    LctoMember.Lote         := LoteNo;
    LctoMember.SeqLote      := QQStr(XLanc,4,'0');
    GotoXY(12,14); Write(XLanc);
    Op := 'I';
    ScreenLancamento;
    EntryLancamento;
    If TC = 'S' then
       With LoteMember do
       begin
         Avs := 'S';
         If ContaDB <> '' then
            begin
              LctoMember.Tipo  := 'D';
              LctoMember.Conta := ContaDB;
              ContaNo := LimpaChave(LctoMember.Conta);
              SearchTree1 ( Root1 );
              If RC = 'S' then
                 begin
                   ReadWrite(#03,'R','N',ContaNumber);
                   DCVSNo     := LoteNo + '#' + XDL + '#' +
                                 LctoMember.SeqLote + '#' + ContaNo;
                   DCVSNumber := FileSize(LctoFile);
                   LoadTree6 ( Root6 );
                   ReadWrite(#08,'W','N',DCVSNumber);
                   Debito  := Debito  + TruncX(LctoMember.Valor);
                   RDebito := RDebito + 1;
                   If (Length(LctoMember.Depto)  <> 0) and
                      (ContaMember.Grupo in ['D','R']) then ColocaNaDespesa;
                   ColocaNaConta(LoteMember.Tipo,'I');
                   DM    := 'S';
                   XLanc := XLanc + 1;
                 end;
            end;
         If ContaCR <> '' then
            begin
              LctoMember.Tipo    := 'C';
              LctoMember.Conta   := ContaCR;
              LctoMember.SeqLote := QQStr(XLanc,4,'0');
              ContaNo            := LimpaChave(LctoMember.Conta);
              SearchTree1 ( Root1 );
              If RC = 'S' then
                 begin
                   ReadWrite(#03,'R','N',ContaNumber);
                   DCVSNo     := LoteNo + '#' + XDL + '#' +
                                 LctoMember.SeqLote + '#' + ContaNo;
                   DCVSNumber := FileSize(LctoFile);
                   LoadTree6 ( Root6 );
                   Credito  := Credito  + TruncX(LctoMember.Valor);
                   RCredito := RCredito + 1;
                   ReadWrite(#08,'W','N',DCVSNumber);
                   If (Length(LctoMember.Depto)  <> 0) and
                      (ContaMember.Grupo in ['D','R']) then ColocaNaDespesa;
                   ColocaNaConta(LoteMember.Tipo,'I');
                   DM    := 'S';
                   XLanc := XLanc + 1;
                 end;
            end;
         GotoXY(12,15);  Write(ConstStr(' ',10));
         GotoXY(12,16);  Write(ConstStr(' ',50));
         GotoXY(12,17);  Write(ConstStr(' ',50));
         GotoXY(12,18);  Write(ConstStr(' ',15));
         GotoXY(48,18);  Write(ConstStr(' ',07));
         GotoXY(04,19);  Write(ConstStr(' ',60));
         GotoXY(04,20);  Write(ConstStr(' ',60));
         GotoXY(04,21);  Write(ConstStr(' ',60));
       end
       else If Avs = 'S' then ReadWrite(#04,'W','N',LoteNumber);
  Until TC = #27;
  TotalDoLote;
end;


Procedure TelaLote(X : Char);
begin
  Move(MemW[$B800:0000],ScArray5[1],4000);
  TelaTotalDoLote;
  If X in ['C','N','S'] then
     begin
       LoteMember.Debito   := 0;
       LoteMember.RDebito  := 0;
       LoteMember.Credito  := 0;
       LoteMember.RCredito := 0;
     end;
  TotalDoLote;
  Color(Blue,White);
  GotoXY(01,23); Write(ConstStr(' ',80));
  GotoXY(02,23); Case X of
                      'C' : Write('Reativando o Lote');
                      'N' : Write('Recalculando os Totais do Lote');
                      'R' : Write('Cancelando o Lote');
                      'S' : Write('Renumerando os lancamentos');
                 end;
  DrawBox(2,11,71,20,Sfn,'S');
  Color(Bfn,Btx);
  GotoXY(2,11);
  Write(' DD/MM/AAAA Seq. S Conta              D/C                Valor Depto. ');
  Color(Sfn,Stx);
end;


Procedure LinhaLote;
begin
  Window(3,13,71,20);
  Color(Sfn,Stx);
  GotoXY(1,8);
  Writeln(LctoMember.OrigData:10,' ',
          PushLeft(5,LctoMember.SeqLote),
          LctoMember.Status,' ',
          PushLeft(20,LctoMember.Conta),
          LctoMember.Tipo,' ':2,
          EditDouble(LctoMember.Valor):20,' ',
          LctoMember.Depto:6);
  Window(1,1,80,25);
end;


Procedure TotalizaLote;
begin
  Case LctoMember.Tipo of
       'D' : begin
               If LctoMember.Status = 'A'
                  then LoteMember.Debito := LoteMember.Debito   +
                                            TruncX(LctoMember.Valor);
               LoteMember.RDebito := LoteMember.RDebito  + 1;
             end;
       'C' : begin
               If LctoMember.Status = 'A'
                  then LoteMember.Credito := LoteMember.Credito  +
                                             TruncX(LctoMember.Valor);
               LoteMember.RCredito := LoteMember.RCredito + 1;
             end;
  end;
  Val(Copy(LctoMember.OrigData,1,2),I,E);
  If LoteMember.Dias[I] <> 'C' then LoteMember.Dias[I] := 'S';
end;


Procedure ReCalculaTotalLote;
begin
  TelaLote('N');
  For I := 1 to 31 do If LoteMember.Dias[I] <> 'C' then LoteMember.Dias[I] := '.';
  DCVSNo := LoteNo + '#';
  Repeat
    RC := 'N';
    SearchPos6 ( Root6 );
    If (RC         = 'S'                            ) and
       (LoteNo+'#' = Copy(DCVSNo,1,Length(LoteNo)+1)) then
       begin
         ReadWrite(#08,'R','N',DCVSNumber);
         If RW = 'S' then
            begin
              LinhaLote;
              TotalizaLote;
              TotalDoLote;
            end;
       end;
  Until RC = 'N';
  ReadWrite(#04,'W','N',LoteNumber);
  Window(1,1,80,25);
  Color(Blue,White);
  GotoXY(01,23); Write(ConstStr(' ',80));
  GotoXY(02,23); Write('Total do Lote Recalculado ');
  TeclaReturn;
  Color(Tfn,Utx);
  Move(ScArray5[1],MemW[$B800:0000],4000);
  RC := 'S';
end;


Procedure RetiraColocaLote(X : Char);
begin
  TelaLote(X);
  DCVSNo := LoteNo + '#';
  Repeat
    RC := 'N';
    SearchPos6 ( Root6 );
    If (RC         = 'S'                            ) and
       (LoteNo+'#' = Copy(DCVSNo,1,Length(LoteNo)+1)) then
       begin
         ReadWrite(#08,'R','N',DCVSNumber);
         If RW = 'S' then
            begin
              LinhaLote;
              If ((X = 'C') and (LctoMember.Status = 'R')) or
                 ((X = 'R') and (LctoMember.Status = 'A')) then
                 begin
                   Case X of
                        'C' : LctoMember.Status := 'A';
                        'R' : LctoMember.Status := 'R';
                   end;
                   Case LctoMember.Tipo of
                        'D' : Case X of
                                   'C' : begin
                                           LoteMember.Debito   := LoteMember.Debito   +
                                                                  TruncX(LctoMember.Valor);
                                           LoteMember.RDebito  := LoteMember.RDebito  + 1;
                                         end;
                                   'R' : begin
                                           LoteMember.Debito   := LoteMember.Debito   -
                                                                  TruncX(LctoMember.Valor);
                                           LoteMember.RDebito  := LoteMember.RDebito  - 1;
                                         end;
                              end;
                        'C' : Case X of
                                   'C' : begin
                                           LoteMember.Credito  := LoteMember.Credito  +
                                                                  TruncX(LctoMember.Valor);
                                           LoteMember.RCredito := LoteMember.RCredito + 1;
                                         end;
                                   'R' : begin
                                           LoteMember.Credito  := LoteMember.Credito  -
                                                                  TruncX(LctoMember.Valor);
                                           LoteMember.RCredito := LoteMember.RCredito - 1;
                                         end;
                               end;
                   end;
                   ContaNo := LimpaChave(LctoMember.Conta);
                   SearchTree1 ( Root1 );
                   If RC = 'S' then
                      begin
                        ReadWrite(#03,'R','N',ContaNumber);
                        Case X of
                             'C' : begin
                                     If (Length(LctoMember.Depto)  <> 0) and
                                        (ContaMember.Grupo in ['D','R'])
                                        then ColocaNaDespesa;
                                        ColocaNaConta(LoteMember.Tipo,'N');
                                   end;
                             'R' : begin
                                     If (Length(LctoMember.Depto)  <> 0) and
                                        (ContaMember.Grupo in ['D','R'])
                                        then RetiraDaDespesa;
                                        RetiraDaConta(LoteMember.tipo,'N');
                                   end;
                        end;
                        TotalDoLote;
                        If X = 'C' then
                           begin
                             XDL := Copy(LctoMember.OrigData,1,2);
                             Val(XDL,I,E);
                             LoteMember.Dias[I] := 'S';
                           end;
                      end
                      else RC := 'N';
                   ReadWrite(#08,'W','N',DCVSNumber);
                 end
                 else begin
                        Case LctoMember.Tipo of
                             'D' : Case X of
                                        'C' : LoteMember.RDebito := LoteMember.RDebito  + 1;
                                        'R' : LoteMember.RDebito := LoteMember.RDebito  - 1;
                                   end;
                             'C' : Case X of
                                        'C' : LoteMember.RCredito := LoteMember.RCredito + 1;
                                        'R' : LoteMember.RCredito := LoteMember.RCredito - 1;
                                   end;
                        end;
                      end;
            end;
       end;
  Until RC = 'N';
  For I := 1 to 31 do If LoteMember.Dias[I] = 'C' then LoteMember.Dias[I] := 'S';
  ReadWrite(#04,'W','N',LoteNumber);
  Move(ScArray5[1],MemW[$B800:0000],4000);
  Color(Tfn,Utx);
  RC := 'S';
end;


Procedure RetiraColocaDia(X : Char);
begin
  Move(MemW[$B800:0000],ScArray5[1],4000);
  TelaTotalDoLote;
  TotalDoLote;
  Color(Blue,White);
  GotoXY(01,23); Write(ConstStr(' ',80));
  GotoXY(02,23);
  If X = 'C' then Write('Reativando o dia ',XDL)
             else begin
                    Write('Cancelando o dia ',XDL);
                    P := 0;
                  end;
  DrawBox(2,11,71,20,Sfn,'S');
  Color(Bfn,Btx);
  GotoXY(2,11);
  Write(' DD/MM/AAAA Seq. S Conta              D/C                Valor Depto. ');
  Color(Sfn,Stx);
  DCVSNo := LoteNo + '#' + XDL + '#';
  Repeat
    RC := 'N';
    SearchPos6 ( Root6 );
    If (RC         = 'S'                            ) and
       (LoteNo+'#' = Copy(DCVSNo,1,Length(LoteNo)+1)) then
       begin
         ReadWrite(#08,'R','N',DCVSNumber);
         If (RW     = 'S'                          ) and
            (XDL    = Copy(LctoMember.OrigData,1,2)) then
            begin
              LinhaLote;
              If ((X = 'C') and (LctoMember.Status = 'R')) or
                 ((X = 'R') and (LctoMember.Status = 'A')) then
                 begin
                   P := P + 1;
                   Case X of
                        'C' : LctoMember.Status := 'A';
                        'R' : LctoMember.Status := 'R';
                   end;
                   Case LctoMember.Tipo of
                        'D' : Case X of
                                   'C' : LoteMember.Debito := LoteMember.Debito   +
                                                              TruncX(LctoMember.Valor);
                                   'R' : LoteMember.Debito := LoteMember.Debito   -
                                                              TruncX(LctoMember.Valor);
                              end;
                        'C' : Case X of
                                   'C' : LoteMember.Credito := LoteMember.Credito  +
                                                               TruncX(LctoMember.Valor);
                                   'R' : LoteMember.Credito := LoteMember.Credito  -
                                                               TruncX(LctoMember.Valor);
                               end;
                   end;
                   ContaNo := LimpaChave(LctoMember.Conta);
                   SearchTree1 ( Root1 );
                   If RC = 'S' then
                      begin
                        ReadWrite(#03,'R','N',ContaNumber);
                        Case X of
                             'C' : begin
                                     If (Length(LctoMember.Depto)  <> 0) and
                                        (ContaMember.Grupo in ['D','R'])
                                        then ColocaNaDespesa;
                                     ColocaNaConta(LoteMember.Tipo,'N');
                                   end;
                             'R' : begin
                                     If (Length(LctoMember.Depto)  <> 0) and
                                        (ContaMember.Grupo in ['D','R'])
                                        then RetiraDaDespesa;
                                     RetiraDaConta(LoteMember.Tipo,'N');
                                   end;
                        end;
                        TotalDoLote;
                      end
                      else RC := 'N';
                   ReadWrite(#08,'W','N',DCVSNumber);
                 end;
            end;
       end;
  Until RC = 'N';
  Val(XDL,I,E);
  If P = 0 then LoteMember.Dias[I] := '.'
     else Case X of
            'C' : LoteMember.Dias[I] := 'S';
            'R' : LoteMember.Dias[I] := 'C';
          end;
  ReadWrite(#04,'W','N',LoteNumber);
  Move(ScArray5[1],MemW[$B800:0000],4000);
  Color(Tfn,Utx);
  RC := 'S';
end;


