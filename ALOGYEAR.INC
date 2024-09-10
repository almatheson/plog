Procedure SomaTotal;
begin
  Case LctoMember.Tipo of
       'D' : With LoteMember do
             begin
               Debito  := Debito  + TruncX(LctoMember.Valor);
               RDebito := RDebito + 1;
             end;
       'C' : With LoteMember do
             begin
               Credito  := Credito  + TruncX(LctoMember.Valor);
               RCredito := RCredito + 1;
             end;
  end;
end;


Procedure LoteDeConversao;
Var
  Operacao,AouF   : Char;
  Constante       : Real;
begin
  Move(MemW[$B800:0000],ScArray4[1],4000);
  DrawBox(4,09,49,19,Red,'S');
  Color(Red,Yellow);
  GotoXY(4,09); Write('               Lote de Convers„o              ');
  Color(Red,Cyan);
  GotoXY(4,10); Write('               -----------------              ');
  GotoXY(4,11); Write(' Considera todos saldos do mˆs, dividindo ou  ');
  GotoXY(4,12); Write(' multiplicando-os por uma constante lan‡ando  ');
  GotoXY(4,13); Write(' o resultado contra uma Conta qualquer.       ');
  Color(Red,Yellow);
  GotoXY(4,14); Write(' Saldo de Aber/Final(A/F):                    ');
  GotoXY(4,15); Write(' Multiplicar/Dividir(M/D):                    ');
  GotoXY(4,16); Write(' Constante num‚rica......:                    ');
  GotoXY(4,17); Write(' Conta usada na convers„o:                    ');
  Color(Red,Cyan);
  GotoXY(4,19); Write('                      Veja Manual do Usu rio. ');
  AouF      := 'A';
  Operacao  := ' ';
  Constante := 0;
  ContaBL   := '';
  Repeat
    K := 0;
    Repeat
      Case K of
           0   : begin
                   J := AouF;
		   InputStr(J,1,31,14,0,'S','S','T','N',Red,White);
                   AouF := UpCase(J[1]);
                   If (TC   <> #27      ) and
                      (AouF in ['A','F']) then
                      begin
                        GotoXY(31,14);
                        Case AouF of
                             'A' : Write('Abertura');
                             'F' : Write('Final   ');
                        end;
                      end;
                 end;
           1   : begin
                   J := Operacao;
		   InputStr(J,1,31,15,0,'S','S','T','N',Red,White);
                   Operacao := UpCase(J[1]);
                   If (TC       <> #27      ) and
                      (Operacao in ['M','D']) then
                      begin
                        GotoXY(31,15);
                        Case Operacao of
                             'D' : Write('Dividir    ');
                             'M' : Write('Multiplicar');
                        end;
                      end;
                 end;
           2   : begin
                   If Constante = 0 then J := ''
                      else begin
                             Str(Constante:14:5,J);
                             J := LeftAdjust(J)
                           end;
		   InputStr(J,14,31,16,0,'S','S','T','N',Red,White);
                   Val(J,Constante,E);
                   If (TC       <> #27) and
                      (Constante = 0  ) then
                      begin
                        ErroMsg := 'Constante n„o pode ser ZERO';
                        ErrorMessage;
                        K := K - 1;
                      end;
                 end;
           3   : begin
                   Color(Blue,White);
                   GotoXY(1,24); Write(ConstStr(' ',80));
                   GotoXY(2,24); Write('F1');
                   Color(Blue,Cyan);
                   GotoXY(5,24); Write('para pesquisar Contas');
                   Color(Tfn,Utx);
                   J := ContaBL;
		   InputStr(J,18,31,17,0,'S','N','T','N',Red,White);
                   LimpaLn(24,Tfd);
                   Case TC of
                        #13 : If J <> '' then
                                 begin
                                   ContaNo := LimpaChave(J);
                                   SearchTree1 ( Root1 );
                                   If RC = 'S' then
                                      begin
                                        ReadWrite(#03,'R','N',ContaNumber);
                                        ContaBL := ContaMember.OrigConta;
                                        Color(Red,White);
                                        GotoXY(31,17); Write(ContaBL);
                                      end
                                      else begin
                                             ErroMsg   := 'Conta n„o Existe';
                                             ErrorMessage;
                                             K := K - 1;
                                           end;
                                 end
                                 else begin
                                        ErroMsg   := 'Informe a Conta';
                                        ErrorMessage;
                                        K := K - 1;
                                      end;
                        #21 : begin
                                ContaAC := LimpaChave(J);
                                ContaNo := ContaAC;
                                ScrollConta('C');
                                ContaBL := ContaAC;
                              end;
                   end;
                 end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 0 then K := K - 1;
      end;
    Until (K = 4) or (TC = #27);
    If TC <> #27 then Confirma;
  Until TC in ['S',#27];
  If TC = 'S' then
     begin
       Move(ScArray4[1],MemW[$B800:0000],4000);
       LoteNo := '';
       Color(Tfn,Ttx);
       GotoXY(04,10); Write('Lote..:');
       Repeat
         J := LoteNo;
	 InputStr(J,6,12,10,0,'S','S','T','N',Tfn,Utx);
         LoteNo := J;
         If (LoteNo <> '' ) and
            (TC     <> #27) then
            begin
              SearchTree2 ( Root2 );
              If RC = 'S' then
                 begin
                   DrawBox(4,11,49,17,Red,'S');
                   Color(Red,Yellow);
                   GotoXY(4,11); Write('               Leia com Aten‡„o               ');
                   Color(Red,Cyan);
                   GotoXY(4,12); Write('               ----------------               ');
                   GotoXY(4,13); Write(' Este Lote j  existe, em outras palavras esta ');
                   GotoXY(4,14); Write(' fun‡„o esta sendo reprocessada.     Para tal, ');
                   GotoXY(4,15); Write(' exclua este Lote e Indexe, ocasionando sua   ');
                   GotoXY(4,16); Write(' exclus„o f¡sica e volte a executar a fun‡„o. ');
                   GotoXY(4,17); Write('                      Veja Manual do Usu rio. ');
                   Color(Tfn,Utx);
                   TeclaReturn;
                   TC := #27;
                 end
                 else begin
                        Confirma;
                        If TC = 'S' then
                           With LoteMember do
                           begin
                             MesContabil := MM;
                             AnoContabil := CMstMember.AnoAtivo;
                             Descricao   := 'Convers„o Autom. ';
                             Status      := 'A';
                             Tipo        := 'N';
                             For I := 1 to 31 do Dias[I] := '.';
                             LoteMember.Dias[1] := 'S';
                             YMes := QQStr(MM,2,'0');
                             YAno := QQStr(CMstMember.AnoAtivo,2,'0');
                             XDL  := '01';
                             WData       := XDL + '/' + YMes + '/' + YAno;
                             DataAbert   := WData;
                             Chave       := LoteNo;
                             Debito      := 0;
                             RDebito     := 0;
                             Credito     := 0;
                             RCredito    := 0;
                             DL          := 'S';
                             LoteNumber  := FileSize(LoteFile);
                             LoadTree2 ( Root2 );
                           end;
                      end;
            end;
       Until TC in [#27,'S'];
       If TC = 'S' then
          begin
            ContaNo := '';
            DM      := 'S';
            TelaTotalDoLote;
            DrawBox(4,11,80,20,Sfn,'S');
            Color(Bfn,Btx);
            GotoXY(4,11); Write(' Seq. Lote.. DD/MM/AAAA S Conta              D/C                Valor Depto. ');
            Color(Sfn,Stx);
            XLanc   := 0;
            ContaNo := '';
            Repeat
              RC := 'N';
              SearchPos1 ( Root1 );
              If RC = 'S' then
                 begin
                   ContaAC := ContaNo;
                   ContaAN := ContaNumber;
                   ReadWrite(#03,'R','N',ContaNumber);
                   ReadWrite(#06,'R','N',ContaNumber);
                   If (ContaMember.Grupo    <> 'T') and
                      (ContaMember.Tipo      = 'A') and
                      (SaldMember.Status     = 'A') then
                      begin
                        If ((AouF = 'F') and (SaldMember.Saldo[MM]    <> 0)) or
                           ((AouF = 'A') and (SaldMember.Abertura[MM] <> 0)) then
                           begin
                             Case AouF of
                                  'A' : SaldoX := TruncX(SaldMember.Abertura[MM]);
                                  'F' : SaldoX := TruncX(SaldMember.Saldo[MM]);
                             end;
                             XLanc                   := XLanc + 1;
                             LctoMember.Status       := 'A';
                             LctoMember.OrigData     := WData;
                             LctoMember.Conta        := ContaMember.OrigConta;
                             LctoMember.MesLancto    := MM;
                             LctoMember.Depto        := '';
                             Str(Constante:14:5,J);
                             J := LeftAdjust(J);
                             Case Operacao of
                                  'D' : LctoMember.Historico[1] := 'Convers„o Autom tica (dividido por ' + J + ')';
                                  'M' : LctoMember.Historico[1] := 'Convers„o Autom tica (multiplicado por ' + J + ')';
                             end;
                             LctoMember.Historico[2] := '';
                             LctoMember.Historico[3] := '';
                             LctoMember.Lote         := LoteNo;
                             LctoMember.SeqLote      := QQStr(XLanc,4,'0');
                             If SaldoX > 0 then
                                begin
                                  LctoMember.Tipo  := 'C';
                                  LctoMember.Valor := SaldoX;
                                end
                                else begin
                                       LctoMember.Tipo  := 'D';
                                       LctoMember.Valor := SaldoX * -1;
                                     end;
                             SomaTotal;
                             CDVSNo     := ContaNo + '#' + XDL + '#' + LoteNo + '#' +
                                           LctoMember.SeqLote;
                             CDVSNumber := FileSize(LctoFile);
                             LoadTree4 ( Root4 );
                             ReadWrite(#08,'W','N',CDVSNumber);
                             MostraNaTela;
                             ColocaNaConta(LoteMember.Tipo,'I');
                             TotalDoLote;
                             ContaNo := LimpaChave(ContaBL);
                             SearchTree1 ( Root1 );
                             If RC = 'S' then ReadWrite(#03,'R','N',ContaNumber);
                             XLanc                   := XLanc + 1;
                             LctoMember.Conta        := ContaBL;
                             LctoMember.SeqLote      := QQStr(XLanc,4,'0');
                             If SaldoX > 0 then
                                begin
                                  LctoMember.Tipo  := 'D';
                                  LctoMember.Valor := SaldoX;
                                end
                                else begin
                                       LctoMember.Tipo  := 'C';
                                       LctoMember.Valor := SaldoX * -1;
                                     end;
                             SomaTotal;
                             CDVSNo     := ContaNo + '#' + XDL + '#' + LoteNo + '#' +
                                           LctoMember.SeqLote;
                             CDVSNumber := FileSize(LctoFile);
                             LoadTree4 ( Root4 );
                             ReadWrite(#08,'W','N',CDVSNumber);
                             MostraNaTela;
                             ColocaNaConta(LoteMember.Tipo,'I');
                             TotalDoLote;
                             Case Operacao of
                                  'D' : SaldoX := SaldoX / Constante;
                                  'M' : SaldoX := SaldoX * Constante;
                             end;
                             SaldoX      := TruncX(SaldoX);
                             ContaNo     := ContaAC;
                             ContaNumber := ContaAN;
                             ReadWrite(#03,'R','N',ContaNumber);
                             XLanc                   := XLanc + 1;
                             LctoMember.Conta        := ContaMember.OrigConta;
                             LctoMember.SeqLote      := QQStr(XLanc,4,'0');
                             If SaldoX > 0 then
                                begin
                                  LctoMember.Tipo  := 'D';
                                  LctoMember.Valor := SaldoX;
                                end
                                else begin
                                       LctoMember.Tipo  := 'C';
                                       LctoMember.Valor := SaldoX * -1;
                                     end;
                             SomaTotal;
                             CDVSNo     := ContaNo + '#' + XDL + '#' + LoteNo + '#' +
                                           LctoMember.SeqLote;
                             CDVSNumber := FileSize(LctoFile);
                             LoadTree4 ( Root4 );
                             ReadWrite(#08,'W','N',CDVSNumber);
                             MostraNaTela;
                             ColocaNaConta(LoteMember.Tipo,'I');
                             TotalDoLote;
                             ContaNo := LimpaChave(ContaBL);
                             SearchTree1 ( Root1 );
                             If RC = 'S' then ReadWrite(#03,'R','N',ContaNumber);
                             XLanc                   := XLanc + 1;
                             LctoMember.Conta        := ContaBL;
                             LctoMember.SeqLote      := QQStr(XLanc,4,'0');
                             If SaldoX > 0 then
                                begin
                                  LctoMember.Tipo  := 'C';
                                  LctoMember.Valor := SaldoX;
                                end
                                else begin
                                       LctoMember.Tipo  := 'D';
                                       LctoMember.Valor := SaldoX * -1;
                                     end;
                             SomaTotal;
                             CDVSNo     := ContaNo + '#' + XDL + '#' + LoteNo + '#' +
                                           LctoMember.SeqLote;
                             CDVSNumber := FileSize(LctoFile);
                             LoadTree4 ( Root4 );
                             ReadWrite(#08,'W','N',CDVSNumber);
                             MostraNaTela;
                             ColocaNaConta(LoteMember.Tipo,'I');
                             TotalDoLote;
                             ContaNo     := ContaAC;
                             ContaNumber := ContaAN;
                             RC := 'S';
                           end;
                      end;
                 end;
            Until RC = 'N';
            ReadWrite(#16,'W','N',0);
            ReadWrite(#04,'W','N',LoteNumber);
            Color(Blue,Cyan);
            GotoXY(1,23); Write(' ':80);
            GotoXY(2,23);
            Write('O Lote de Convers„o esta gerado.');
            TeclaReturn;
          end;
     end;
end;


