{$O+,F+}
Unit AlogYear;

Interface

Uses Crt,Dos,AlogGlbs,AlogNavg,AlogBasP,AlogInit,AlogCnta,AlogLote,
             AlogReor;


   Procedure Encerramento;
   Procedure LoteDeConversao;
   Procedure Abertura;
   Procedure TransportaSaldo;
   Procedure CorrecaoConta;
   Procedure ExcluiAno;

Implementation

Var
  YDia,YMes : Str2;
  YAno      : Str4;

Procedure MostraNaTela;
begin
  Color(Sfn,Stx);
  Window(5,13,80,20);
  GotoXY(1,8); Writeln(PushLeft(5,LctoMember.SeqLote),
                       Lctomember.Lote:6,' ',
                       LctoMember.OrigData:10,' ',
                       LctoMember.Status,' ',
                       PushLeft(20,LctoMember.Conta),
                       LctoMember.Tipo,' ':2,
                       EditDouble(LctoMember.Valor):20,' ',
                       LctoMember.Depto:6);
  Window(1,1,80,25);
end;


Procedure Encerramento;
Var
  Gera1,Gera2  : Char;
begin
              If MM = 12
                 then Titulo := 'Fechamento Anual                       '
                 else Titulo := 'Fechamento Anual                       ';
              BuildFrame('S');
              Color(Red,White);
              GotoXY(36,7); Write('Total de Contas: ');
              Color(Red,Yellow);
              GotoXY(53,7); Write(CMstMember.NContas);
  Move(MemW[$B800:0000],ScArray4[1],4000);
  DrawBox(4,10,49,19,Red,'S');
  Color(Red,Yellow);
  GotoXY(4,10); Write('               Leia com Aten‡„o               ');
  Color(Red,Cyan);
  GotoXY(4,11); Write('               ----------------               ');
  GotoXY(4,12); Write(' Esta  etapa  causa o Encerramento das contas ');
  GotoXY(4,13); Write(' de  Ativo e Passivo, e da Receita e Despesa. ');
  GotoXY(4,14); Write(' Especifique como encerrar:                   ');
  Color(Red,Yellow);
  GotoXY(4,16); Write(' Encerrar Ativo e Passivo   (S/N):            ');
  GotoXY(4,17); Write(' Encerrar Receita e Despesa (S/N):            ');
  Color(Red,Cyan);
  GotoXY(4,19); Write('                      Veja Manual do Usu rio. ');
  Gera1 := 'S';
  Gera2 := 'S';
  Repeat
    K := 1;
    Repeat
      Case K of
           1   : begin
                   J := Gera1;
		   InputStr(J,1,39,16,0,'S','S','T','N',Red,White);
                   Gera1 := UpCase(J[1]);
                   If (TC    <> #27      ) and
                      (Gera1 in ['N','S']) then
                      begin
                        GotoXY(39,16);
                        Case Gera1 of
                             'N' : Write('N„o');
                             'S' : Write('Sim');
                        end;
                      end;
                 end;
           2   : begin
                   J := Gera2;
		   InputStr(J,1,39,17,0,'S','S','T','N',Red,White);
                   Gera2 := UpCase(J[1]);
                   If (TC    <> #27      ) and
                      (Gera2 in ['N','S']) then
                      begin
                        GotoXY(39,17);
                        Case Gera2 of
                             'N' : Write('N„o');
                             'S' : Write('Sim');
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
                   DrawBox(4,11,49,19,Red,'S');
                   Color(Red,Yellow);
                   GotoXY(4,11); Write('               Leia com Aten‡„o               ');
                   Color(Red,Cyan);
                   GotoXY(4,12); Write('               ----------------               ');
                   GotoXY(4,13); Write(' Este Lote j  existe, em outras palavras este ');
                   GotoXY(4,14); Write(' Encerramento esta sendo reprocessado.   Para ');
                   GotoXY(4,15); Write(' que seja poss¡vel executa-lo, fa‡a o seguin- ');
                   GotoXY(4,16); Write(' te: Exclua o Lote e Indexe.  Isto ocasionar  ');
                   GotoXY(4,17); Write(' a exclus„o f¡sica deste Lote. Terminado este ');
                   GotoXY(4,18); Write(' procedimento, execute o Encerramento.        ');
                   GotoXY(4,19); Write('                      Veja Manual do Usu rio. ');
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
                             If MM = 12
                                then Descricao := 'Enc. de Exerc¡cio'
                                else Case CMstMember.TipoE of
                                          'A','L' : Descricao := 'Enc. de Exerc¡cio';
                                          'M'     : Descricao := 'Enc. de Mensal   ';
                                     end;
                             Status      := 'A';
                             Tipo        := 'E';
                             For I := 1 to 31 do Dias[I] := '.';
                             K                  := TabDia[MM];
                             LoteMember.Dias[K] := 'S';
                             YMes := QQStr(MM,2,'0');
                             YAno := QQStr(CMstMember.AnoAtivo,4,'0');
                             XDL  := QQStr(K,2,'0');
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
            ContaLP := '';
            ContaBL := '';
            DM      := 'S';
            Repeat
              RC := 'N';
              SearchPos1 ( Root1 );
              If RC = 'S' then
                 begin
                   ReadWrite(#03,'R','N',ContaNumber);
                   If (ContaMember.Grupo = 'T') and
                      (ContaMember.Tipo  = 'A') then
                      Case ContaMember.GrupoE of
                           '7' : ContaLP := ContaMember.OrigConta;
                           '8' : ContaBL := ContaMember.OrigConta;
                      end;
                 end;
            Until RC = 'N';
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
                   SaldoX := TruncX(SaldMember.Saldo[MM]);
                   If (ContaMember.Tipo   =  'A') and
                      (SaldoX             <> 0  ) and
                      (((ContaMember.Grupo in ['A','P']) and (Gera1 = 'S'))  or
                       ((ContaMember.Grupo in ['D','R']) and (Gera2 = 'S'))) then
                      begin
                        XLanc                   := XLanc + 1;
                        LctoMember.Status       := 'A';
                        LctoMember.OrigData     := WData;
                        LctoMember.Conta        := ContaMember.OrigConta;
                        LctoMember.MesLancto    := MM;
                        LctoMember.Tipo         := ' ';
                        LctoMember.Valor        := 0;
                        LctoMember.Depto        := '';
                        LctoMember.Historico[1] := '';
                        LctoMember.Historico[2] := '';
                        LctoMember.Historico[3] := '';
                        LctoMember.Lote         := LoteNo;
                        LctoMember.SeqLote      := QQStr(XLanc,4,'0');
                        If ContaMember.Grupo in ['A','P']
                           then LctoMember.Historico[1] := 'Transferˆncia de saldo para balan‡o'
                           else LctoMember.Historico[1] := 'Transferˆncia de saldo para lucros e perdas';
                        If SaldoX > 0 then
                           begin
                             LctoMember.Tipo  := 'C';
                             LctoMember.Valor := SaldoX;
                           end
                           else begin
                                  LctoMember.Tipo  := 'D';
                                  LctoMember.Valor := SaldoX * -1;
                                end;
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
                        ReadWrite(#03,'R','N',ContaNumber);
                        If ContaMember.Grupo in ['A','P'] then
                           begin
                             LctoMember.Conta        := ContaBL;
                             LctoMember.Historico[1] := 'Transf.de saldo de ' +
                                                        ContaMember.Descricao;
                           end
                           else begin
                                  LctoMember.Conta        := ContaLP;
                                  LctoMember.Historico[1] := 'Transf.de saldo de ' +
                                                             ContaMember.Descricao;
                                end;
                        ContaNo := LimpaChave(LctoMember.Conta);
                        SearchTree1 ( Root1 );
                        If RC = 'S' then
                           begin
                             If SaldoX > 0 then
                                begin
                                  LctoMember.Tipo  := 'D';
                                  LctoMember.Valor := SaldoX;
                                end
                                else begin
                                       LctoMember.Tipo  := 'C';
                                       LctoMember.Valor := SaldoX * -1;
                                     end;
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
                             XLanc              := XLanc + 1;
                             LctoMember.SeqLote := QQStr(XLanc,4,'0');
                             ReadWrite(#03,'R','N',ContaNumber);
                             CDVSNo     := ContaNo + '#' + XDL + '#' +
                                           LoteNo  + '#' + LctoMember.SeqLote;
                             CDVSNumber := FileSize(LctoFile);
                             LoadTree4 ( Root4 );
                             ReadWrite(#08,'W','N',CDVSNumber);
                             MostraNaTela;
                             ColocaNaConta(LoteMember.Tipo,'I');
                             TotalDoLote;
                           end
                           else RC := 'S';
                        ContaNo     := ContaAC;
                        ContaNumber := ContaAN;
                      end;
                 end;
            Until RC = 'N';
            ReadWrite(#16,'W','N',0);
            ReadWrite(#04,'W','N',LoteNumber);
            Color(Blue,Cyan);
            GotoXY(1,23); Write(' ':80);
            GotoXY(2,23);
            Write('O Lote de Encerramento esta gerado, imprima seus relat¢rios');
            TeclaReturn;
          end;
     end;
end;


{$I AlogYear.inc }


Procedure GeraLancamentos;
begin
  Color(Blue,Yellow);
  GotoXY(1,24); Write(ConstStr(' ',80));
  GotoXY(2,24);
  Write('Procurando a conta Balan‡o para transportar lan‡amentos              Aguarde');
  ContaNo := '';
  ContaBL := '';
  Repeat
    RC := 'N';
    SearchPos1 ( Root1 );
    If RC = 'S' then
       begin
         ReadWrite(#03,'R','N',ContaNumber);
         If (ContaMember.Grupo  = 'T') and
            (ContaMember.GrupoE = '8') and
            (ContaMember.Tipo   = 'A') then ContaBL := ContaMember.OrigConta;
       end;
  Until RC = 'N';
  LimpaLn(24,Tfd);
  TelaTotalDoLote;
  DrawBox(4,11,80,20,Sfn,'S');
  Color(Bfn,Btx);
  GotoXY(4,11); Write(' Seq. Lote.. DD/MM/AAAA S Conta              D/C                Valor Depto. ');
  Color(Sfn,Stx);
  ContaNo    := '';
  XLanc      := 0;
  DM         := 'S';
  ReadWrite(#04,'R','N',LoteNumber);
  Repeat
    RC := 'N';
    SearchPos1 ( Root1 );
    If RC = 'S' then
       begin
         ContaAC := ContaNo;
         ContaAN := ContaNumber;
         ReadWrite(#03,'R','N',ContaNumber);
         SaldoX := 0;
         If M = 12 then
            begin
              {$I-}
              Seek ( WorkFile4, ContaNumber );
              Read ( WorkFile4, SaldMember  );
              {$I+}
              If IOResult = 0 then SaldoX := SaldMember.SaldoB[M];
            end
            else begin
                   ReadWrite(#06,'R','N',ContaNumber);
                   If RW = 'S' then SaldoX := SaldMember.SaldoB[M];
                 end;
         If (ContaMember.Grupo in ['A','P']) and
            (ContaMember.Tipo  =   'A'     ) and
            (SaldoX            <>   0      ) then
            begin
              XLanc                   := XLanc + 1;
              LctoMember.Status       := 'A';
              LctoMember.OrigData     := WData;
              LctoMember.Conta        := ContaMember.OrigConta;
              LctoMember.MesLancto    := CMstMember.MesAtivo;
              LctoMember.Tipo         := ' ';
              LctoMember.Valor        := 0;
              LctoMember.Depto        := '';
              LctoMember.Historico[1] := '';
              LctoMember.Historico[2] := '';
              LctoMember.Historico[3] := '';
              LctoMember.Lote         := LoteNo;
              LctoMember.SeqLote      := QQStr(XLanc,4,'0');
              LctoMember.Historico[1] := 'Transferˆncia do saldo de balanco';
              If SaldoX > 0 then
                 begin
                   LctoMember.Tipo  := 'D';
                   LctoMember.Valor := TruncX(SaldoX);
                 end
                 else begin
                        LctoMember.Tipo  := 'C';
                        LctoMember.Valor := TruncX(SaldoX) * -1;
                      end;
              Case LctoMember.Tipo of
                   'D' : With LoteMember do
                         begin
                           Debito  := Debito  + LctoMember.Valor;
                           RDebito := RDebito + 1;
                         end;
                   'C' : With LoteMember do
                         begin
                           Credito  := Credito  + LctoMember.Valor;
                           RCredito := RCredito + 1;
                         end;
              end;
              CDVSNo     := ContaNo + '#' + XDL + '#' + LoteNo + '#' +
                            LctoMember.SeqLote;
              CDVSNumber := FileSize(LctoFile);
              LoadTree4 ( Root4 );
              ReadWrite(#08,'W','N',CDVSNumber);
              MostraNaTela;
              ColocaNaConta(LoteMember.Tipo,'I');
              TotalDoLote;
              LctoMember.Conta        := ContaBL;
              LctoMember.Historico[1] := 'Transf.de saldo p/ ' +
                                         ContaMember.Descricao;
              LctoMember.Valor        := 0;
              ContaNo := LimpaChave(LctoMember.Conta);
              SearchTree1 ( Root1 );
              If RC = 'S' then
                 begin
                   ReadWrite(#03,'R','N',ContaNumber);
                   If SaldoX > 0 then
                      begin
                        LctoMember.Tipo  := 'C';
                        LctoMember.Valor := TruncX(SaldoX);
                      end
                      else begin
                             LctoMember.Tipo  := 'D';
                             LctoMember.Valor := TruncX(SaldoX) * -1;
                           end;
                   Case LctoMember.Tipo of
                        'D' : With LoteMember do
                              begin
                                Debito  := Debito  + LctoMember.Valor;
                                RDebito := RDebito + 1;
                              end;
                        'C' : With LoteMember do
                              begin
                                Credito  := Credito  + LctoMember.Valor;
                                RCredito := RCredito + 1;
                              end;
                   end;
                   XLanc              := XLanc + 1;
                   LctoMember.SeqLote := QQStr(XLanc,4,'0');
                   CDVSNo     := ContaNo + '#' + XDL + '#' +
                                 LoteNo  + '#' + LctoMember.SeqLote;
                   CDVSNumber := FileSize(LctoFile);
                   LoadTree4 ( Root4 );
                   ReadWrite(#08,'W','N',CDVSNumber);
                   MostraNaTela;
                   ColocaNaConta(LoteMember.Tipo,'I');
                   TotalDoLote;
                   RC := 'S';
                 end
                 else RC := 'S';
              ContaNo     := ContaAC;
              ContaNumber := ContaAN;
            end;
       end;
  Until RC = 'N';
  ReadWrite(#16,'W','N',0);
  ReadWrite(#04,'W','N',LoteNumber);
  Color(Blue,Cyan);
  GotoXY(1,23); Write(' ':80);
  GotoXY(2,23); Write('O Lote de Abertura esta gerado.');
  TeclaReturn;
  TC := 'S';
end;


Procedure Abertura;
begin
              If MM = 12 then
                 begin
                   Str((AA + 1),XAno);
                   Titulo := 'Abertura Anual  (Janeiro de ' + XAno + ')        ';
                 end
                 else Titulo := 'Abertura Mensal (' + ArrayMesEx[MM + 1] + ')';
              BuildFrame('S');
              Color(Red,White);
              GotoXY(36,7); Write('Total de Contas: ');
              Color(Red,Yellow);
              GotoXY(53,7); Write(CMstMember.NContas);
  Move(MemW[$B800:0000],ScArray4[1],4000);
  If (CMstMember.TipoE    = 'A') and
     (CMstMember.MesAtivo < 12 ) then
     begin
       DrawBox(4,10,49,19,Red,'S');
       Color(Red,Yellow);
       GotoXY(4,10); Write('               Leia com Aten‡„o               ');
       Color(Red,Cyan);
       GotoXY(4,11); Write('               ----------------               ');
       GotoXY(4,12); Write(' A empresa faz encerramento ANUAL, isto ‚: em ');
       GotoXY(4,13); Write(' dezembro, ou seja ao final do exerc¡cio. N„o ');
       GotoXY(4,14); Write(' ‚ poss¡vel executar este procedimento, visto ');
       GotoXY(4,15); Write(' que o tipo de  encerramento adotado por esta ');
       GotoXY(4,16); Write(' empresa ‚ ANUAL.   S¢ ‚  poss¡vel neste caso ');
       GotoXY(4,17); Write(' executar a  abertura de um novo exerc¡cio, a ');
       GotoXY(4,18); Write(' partir de Dezembro.                          ');
       GotoXY(4,19); Write('                      Veja Manual do Usu rio. ');
       Color(Tfn,Utx);
       TeclaReturn;
       TC := #27;
     end
     else begin
            Close ( EcoFile );
            If (CMstMember.MesAtivo = 12     ) and
               (CMstMember.TipoE in ['A','M']) then
               begin
                 DrawBox(4,10,49,19,Red,'S');
                 Color(Red,Yellow);
                 GotoXY(4,10); Write('               Leia com Aten‡„o               ');
                 Color(Red,Cyan);
                 GotoXY(4,11); Write('               ----------------               ');
                 GotoXY(4,12); Write(' Esta  Abertura ‚ ANUAL ou  do 1§ mˆs do ano. ');
                 GotoXY(4,13); Write(' Sua execu‡„o ocasionar  a gera‡„o do Lote de ');
                 GotoXY(4,14); Write(' Abertura  do pr¢ximo ano e a mudan‡a autom - ');
                 GotoXY(4,15); Write(' tica  do processamento para o 1§ mˆs do pr¢- ');
                 GotoXY(4,16); Write(' ximo ano. Estes lan‡amentos reflitir„o todos ');
                 GotoXY(4,17); Write(' os saldos do Ativo e Passivo em 31/12.       ');
                 GotoXY(4,18); Write('                                              ');
                 GotoXY(4,19); Write('                      Veja Manual do Usu rio. ');
                 Color(Tfn,Utx);
               end ;
               Confirma;
               If TC = 'S' then
                  begin
                    If CMstMember.MesAtivo = 12 then
                       begin
                         Color(Red,(White + Blink));
                         GotoXY(01,24); Write(ConstStr(' ',80));
                         GotoXY(73,24); Write('Aguarde ');
                         AA := CMstMember.AnoAtivo;
                         Str(AA,YAno);
                         AA   := AA + 1;
                         AAFx := QQStr(AA,4,'0');
                         TrocaLote;
                       end;
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
                                DrawBox(4,11,49,19,Red,'S');
                                Color(Red,Yellow);
                                GotoXY(4,11); Write('               Leia com Aten‡„o               ');
                                Color(Red,Cyan);
                                GotoXY(4,12); Write('               ----------------               ');
                                GotoXY(4,13); Write(' Este Lote j  existe, em outras palavras esta ');
                                GotoXY(4,14); Write(' Abertura esta sendo  reprocessada.  Para que ');
                                GotoXY(4,15); Write(' seja poss¡vel executa-la, mude o mˆs de pro- ');
                                GotoXY(4,16); Write(' cessamento, exclua o Lote e Indexe, para que ');
                                GotoXY(4,17); Write(' este Lote, seja fisicamente excluido. Termi- ');
                                GotoXY(4,18); Write(' nando,  volte a este mˆs e execute novamente ');
                                GotoXY(4,19); Write(' a abertura.          Veja Manual do Usu rio. ');
                                Color(Tfn,Utx);
                                TeclaReturn;
                                If CMstMember.MesAtivo = 12 then
                                   begin
                                     Color(Red,(White + Blink));
                                     GotoXY(01,24); Write(ConstStr(' ',80));
                                     GotoXY(73,24); Write('Aguarde ');
                                     AAFx := YAno;
                                     AA   := AA - 1;
                                     TrocaLote;
                                   end;
                                TC := #27;
                              end
                              else begin
                                     Confirma;
                                     If TC = 'S' then
                                        With LoteMember do
                                        begin
                                          M := CMstMember.MesAtivo;
                                          If CMstMember.MesAtivo = 12 then
                                             begin
                                               CMstMember.MesAtivo := 1;
                                               CMstMember.AnoAtivo := AA;
                                             end
                                             else CMstMember.MesAtivo := CMstMember.MesAtivo + 1;
                                          MM          := CMstMember.MesAtivo;
                                          MesContabil := CMstMember.MesAtivo;
                                          AnoContabil := CMstMember.AnoAtivo;
                                          Case CMstMember.TipoE of
                                               'A','L' : Descricao   := 'Aber.de Exerc¡cio';
                                               'M'     : Descricao   := 'Aber.de Mˆs      ';
                                          end;
                                          ReadWrite(#16,'W','N',0);
                                          LoteMember.Status := 'A';
                                          LoteMember.Tipo   := 'A';
                                          For I := 1 to 31 do LoteMember.Dias[I] := '.';
                                          K                  := 1;
                                          LoteMember.Dias[K] := 'S';
                                          YMes  := QQStr(CMstMember.MesAtivo,2,'0');
                                          YAno  := QQStr(CMstMember.AnoAtivo,4,'0');
                                          XDL   := QQStr(K,2,'0');
                                          WData := XDL + '/' + YMes + '/' + YAno;
                                          LoteMember.DataAbert   := WData;
                                          LoteMember.Chave       := LoteNo;
                                          LoteMember.Debito      := 0;
                                          LoteMember.RDebito     := 0;
                                          LoteMember.Credito     := 0;
                                          LoteMember.RCredito    := 0;
                                          DL                     := 'S';
                                          LoteNumber := FileSize(LoteFile);
                                          LoadTree2 ( Root2 );
                                          ReadWrite(#04,'W','N',LoteNumber);
                                          MMFx := 'M' + QQStr(MM,2,'0');
                                          IIFx := 'I' + QQStr(MM,2,'0');
                                          If M = 12 then
                                             begin
                                               TrocaSaldo;
                                               TrocaExpe;
                                               Assign( WorkFile4,(XPath + '\' + FileSald  + QQStr(AA-1,2,'0') + '.DAT'));
                                               Reset ( WorkFile4 );
                                             end;
                                          TrocaLcto;
                                          GeraLancamentos;
                                          If M = 12 then Close ( WorkFile4 );
                                        end
                                        else If CMstMember.MesAtivo = 12 then
                                                begin
                                                  AAFx := YAno;
                                                  AA   := AA - 1;
                                                  TrocaLote;
                                                end;
                                   end;
                         end;
                    Until TC in [#27,'S'];
                  end;
            Reset ( EcoFile );
          end;
              If TC = 'S' then
                 begin
                   Vez  := 'S';
                   VezD := 'S';
                   VezR := 'S';
                   If (CMstMember.MesAtivo = 1      ) and
                      (CMstMember.TipoE in ['A','M']) then
                      begin
                        Move(ScArray1[1],MemW[$B800:0000],4000);
                        Titulo := 'Indexa‡Æo Anual dos arquivos           ';
                        BuildFrame('S');
                        Reorganiza;
                      end;
                   Move(ScArray1[1],MemW[$B800:0000],4000);
                   ShowMes;
                   Move(MemW[$B800:0000],ScArray1[1],4000);
                   Color(Tfn,Utx);
                 end;
end;


Procedure TransportaSaldo;
Var
  TpT    : char;
begin
              Titulo := 'Transporte de Saldos (Dez. para Jan.)   ';
              BuildFrame('S');
  If CMstMember.MesAtivo = 12 then
     begin
       TabI[1]  := ' Todas as Contas   ';
       TabI[2]  := ' Ativo e Passivo   ';
       TabI[3]  := ' Receita e Despesa ';
       TabI[4]  := ' Encerrar a Fun‡„o ';
       TabX[1]  := 24;
       TabX[2]  := 24;
       TabX[3]  := 24;
       TabX[4]  := 24;
       TabY[1]  := 15;
       TabY[2]  := 16;
       TabY[3]  := 17;
       TabY[4]  := 18;
       DrawBox(4,10,49,19,Red,'S');
       Color(Red,Yellow);
       GotoXY(4,10); Write('               Leia com Aten‡„o               ');
       Color(Red,Cyan);
       GotoXY(4,11); Write(' -------------------------------------------- ');
       GotoXY(4,12); Write(' Esta fun‡„o transfere o Saldo das contas, de ');
       GotoXY(4,13); Write(' dezembro para janeiro pr¢ximo. Informe quais ');
       GotoXY(4,14); Write(' contas devem ser consideradas nesta opera‡„o ');
       GotoXY(4,15); Write(' de transferˆncia:                            ');
       YY := 1;
       MenuAuxiliar(4,Tfn,Utx,Red,Yellow);
       Repeat
         Resp := ReadKey;
         If (Resp = #0) and (KeyPressed) then
            begin
              Resp := ReadKey;
              Case Resp of
                   #72 : begin
                           YY := YY - 1;
                           If YY < 1 then YY := 4;
                         end;
                   #80 : begin
                           YY := YY + 1;
                           If YY > 4 then YY := 1;
                         end;
              end;
              MenuAuxiliar(4,Tfn,Utx,Red,Yellow);
            end
            else If Resp = #13 then
                    begin
                      Case YY of
                           1 : TpT := 'T';
                           2 : TpT := 'A';
                           3 : TpT := 'D';
                           4 : Resp := #27;
                      end;
                    end
                    else Resp := #13;
       Until (Resp = #27) or (Tpt in ['A','D','T']);
       If Tpt in ['A','D','T'] then
          begin
            Close ( EcoFile );
            Color(Red,(White + Blink));
            GotoXY(01,24); Write(ConstStr(' ',80));
            GotoXY(73,24); Write('Aguarde ');
            Assign( WorkFile4,(XPath + '\' + FileSald  + QQStr(CMstMember.AnoAtivo+1,2,'0') + '.DAT'));
            {$I-}
            Reset ( WorkFile4 );
            {$I+}
            If IOResult <> 0 then ReWrite ( WorkFile4 );
            I := -1;
            Repeat
              I := I + 1;
              ReadWrite(#03,'R','N',I);
              ReadWrite(#06,'R','N',I);
              {$I-}
              Seek ( WorkFile4, I           );
              Read ( WorkFile4, WorkMember4 );
              {$I+}
              If IOResult <> 0 then
                 For K := 1 to 12 do begin
                                       WorkMember4.Abertura[K] := 0;
                                       WorkMember4.Debitos[K]  := 0;
                                       WorkMember4.Creditos[K] := 0;
                                       WorkMember4.Saldo[K]    := 0;
                                       WorkMember4.SaldoB[K]   := 0;
                                       WorkMember4.NLanctos[K] := 0;
                                     end;
              If (TpT = 'T') or
                 ((TpT = 'A') and (ContaMember.Grupo in ['A','P'])) or
                 ((TpT = 'D') and (ContaMember.Grupo in ['D','R'])) then
                 begin
                   WorkMember4.Status      := SaldMember.Status;
                   WorkMember4.Abertura[1] := SaldMember.Saldo[12];
                 end;
              Seek  ( WorkFile4, I           );
              Write ( WorkFile4, WorkMember4 );
            Until (I + 1) = FileSize(SaldFile);
            Close ( WorkFile4 );
            Reset ( EcoFile );
          end;
     end;
end;


Procedure CorrecaoConta;
begin
              Titulo := 'Corre‡Æo de Contas                     ';
              BuildFrame('S');
              Color(Red,White);
              GotoXY(36,7); Write('Total de Contas: ');
              Color(Red,Yellow);
              GotoXY(53,7); Write(CMstMember.NContas);
  Move(MemW[$B800:0000],ScArray4[1],4000);
  DrawBox(4,10,49,19,Red,'S');
  Color(Red,Yellow);
  GotoXY(4,10); Write('               Leia com Aten‡„o               ');
  Color(Red,Cyan);
  GotoXY(4,11); Write('               ----------------               ');
  GotoXY(4,12); Write(' Esta etapa executa a corre‡„o das contas que ');
  GotoXY(4,13); Write(' no Plano de Contas, contenham instru‡”es que ');
  GotoXY(4,14); Write(' direcionem a corre‡„o dos seus saldos.  Esta ');
  GotoXY(4,15); Write(' corre‡„o gera lan‡amentos e contra-partidas, ');
  GotoXY(4,16); Write(' que s„o gerados em um lote, tal como se este ');
  GotoXY(4,17); Write(' f“sse digitado pelo pr¢prio usu rio, podendo ');
  GotoXY(4,18); Write(' ser alterado como um lote normal.            ');
  GotoXY(4,19); Write('                                              ');
  Color(Tfn,Utx);
  Confirma;
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
                   ReadWrite(#04,'R','N',LoteNumber);
                   Case RW of
                        'S' : begin
                                ErroMsg := 'N„o posso regerar este lote';
                                ErrorMessage;
                              end;
                        'N' : begin
                                ErroMsg := 'N„o consigo ler o lote';
                                ErrorMessage;
                              end;
                   end;
                 end
                 else begin
                        Confirma;
                        If TC = 'S' then
                           With LoteMember do
                           begin
                             MesContabil := MM;
                             Descricao   := 'Corre‡„o de Contas';
                             Status      := 'A';
                             Tipo        := 'N';
                             For I := 1 to 31 do Dias[I] := '.';
                             K                   := TabDia[MM];
                             LoteMember.Dias[K]  := 'S';
                             YMes  := QQStr(MM,2,'0');
                             YAno  := QQStr(CMstMember.AnoAtivo,4,'0');
                             XDL   := QQStr(K,2,'0');
                             YDia  := XDL;
                             WData := XDL + '/' + YMes + '/' + YAno;
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
            TelaTotalDoLote;
            DrawBox(4,11,78,20,Sfn,'S');
            Color(Bfn,Btx);
            GotoXY(4,11); Write(' Seq. Lote.. DD/MM/AA S Conta              D/C                Valor Depto. ');
            Color(Sfn,Stx);
            ContaNo := '';
            XLanc   := 0;
            DM      := 'S';
            Str(CMstMember.AnoAtivo,YAno);
            Repeat
              RC := 'N';
              SearchPos1 ( Root1 );
              If RC = 'S' then
                 begin
                   ContaAC := ContaNo;
                   ContaAN := ContaNumber;
                   ReadWrite(#03,'R','N',ContaNumber);
                   ReadWrite(#06,'R','N',ContaNumber);
                   If (RW                      = 'S'  ) and
                      (SaldMember.Saldo[MM]   <> 0    ) and
                      (((ContaMember.Status    = 'A')   and
                        (ContaMember.Correcao <> 'N')   and
                        (ContaMember.PeriodoC  = 'M'))  or
                       ((ContaMember.PeriodoC  = 'A')   and
                        (MM                    = 12 ))) then
                      begin
                        XLanc                   := XLanc + 1;
                        LctoMember.Status       := 'A';
                        LctoMember.OrigData     := WData;
                        LctoMember.MesLancto    := MM;
                        LctoMember.Tipo         := ' ';
                        LctoMember.Valor        := 0;
                        LctoMember.Depto        := '';
                        LctoMember.Historico[1] := '';
                        LctoMember.Historico[2] := '';
                        LctoMember.Historico[3] := '';
                        LctoMember.Lote         := LoteNo;
                        LctoMember.SeqLote      := QQStr(XLanc,4,'0');
                        If ContaMember.Correcao = 'S'
                           then LctoMember.Conta := ContaMember.OrigConta
                           else begin
                                  ContaAN := ContaNumber;
                                  ContaNo := LimpaChave(ContaMember.CPartidaX);
                                  SearchTree1 ( Root1 );
                                  If RC = 'S' then
                                     begin
                                       ReadWrite(#03,'R','N',ContaNumber);
                                       LctoMember.Conta := ContaMember.OrigConta;
                                       ContaNumber      := ContaAN;
                                       ReadWrite(#03,'R','N',ContaNumber);
                                     end
                                     else LctoMember.Conta := '*Sem Contra-P.*';
                                end;
                        If ContaMember.HistoricoC <> '' then
                           begin
                             HHNo := ContaMember.HistoricoC;
                             SearchTree8 ( Root8 );
                             If RC = 'S' then
                                begin
                                  ReadWrite(#10,'R','N',HHNumber);
                                  If RW = 'S'
                                     then LctoMember.Historico[1] := HsPdMember.Descricao
                                     else LctoMember.Historico[1] := '';
                                end;
                           end;
                        IINo := YAno + '#' + ContaMember.IndiceC;
                        SearchTree7 ( Root7 );
                        If RC = 'S' then
                           begin
                             ReadWrite(#12,'R','N',IINumber);
                             If RW = 'S' then
                                begin
                                  If ContaMember.PeriodoC = 'M' then
                                     begin
                                       If LctoMember.Historico[1] = ''
                                          then LctoMember.Historico[1] := 'calculado pela varia‡„o mensal' +
                                                                          ' da(o) ' + EcoMember.Descricao + ' em '   +
                                                                          ArrayMesEx[MM]
                                          else LctoMember.Historico[2] := 'calculado pela varia‡„o mensal' +
                                                                          ' da(o) ' + EcoMember.Descricao + ' em '   +
                                                                          ArrayMesEx[MM];
                                       If MM = 1 then
                                          begin
                                            TotD := EcoMember.Valores[1];
                                            Str((CMstMember.AnoAtivo - 1),YAno);
                                            IINo := YAno + '#' + ContaMember.IndiceC;
                                            SearchTree7 ( Root7 );
                                            If RC = 'S' then
                                               begin
                                                 ReadWrite(#12,'R','N',IINumber);
                                                 If RW = 'S'
                                                    then TotA := EcoMember.Valores[12];
                                               end
                                               else begin
                                                      RC   := 'S';
                                                      TotA := TotD;
                                                    end;
                                            Fator := (TotD / TotA) - 1;
                                            Str(CMstMember.AnoAtivo,YAno);
                                          end
                                          else If EcoMember.Valores[MM - 1] > 0
                                                  then Fator := (EcoMember.Valores[MM] / EcoMember.Valores[MM - 1]) - 1
                                                  else Fator := 1;
                                     end
                                     else begin
                                            If LctoMember.Historico[1] = ''
                                               then LctoMember.Historico[1] := 'calculado pela varia‡„o ' +
                                                                               'anual da(o) ' + EcoMember.Descricao
                                               else LctoMember.Historico[2] := 'calculado pela varia‡„o ' +
                                                                               'anual da(o) ' + EcoMember.Descricao;
                                            If EcoMember.Valores[1] > 0
                                               then Fator := (EcoMember.Valores[MM] / EcoMember.Valores[1]) - 1
                                               else Fator := 1;
                                          end;
                                end;
                           end
                           else begin
                                  RC    := 'S';
                                  Fator := 1;
                                end;
                        LctoMember.Valor := SaldMember.Saldo[MM] * Fator;
                        If LctoMember.Valor > 0
                           then LctoMember.Tipo := 'D'
                           else begin
                                  LctoMember.Tipo  := 'C';
                                  Lctomember.Valor := Lctomember.Valor * -1;
                                end;
                        ContaNo := LimpaChave(LctoMember.Conta);
                        SearchTree1 ( Root1 );
                        If RC = 'S' then
                           begin
                             ReadWrite(#03,'R','N',ContaNumber);
                             CDVSNo     := ContaNo + '#' + XDL + '#' +
                                           LoteNo  + '#' + LctoMember.SeqLote;
                             CDVSNumber := FileSize(LctoFile);
                             LoadTree4 ( Root4 );
                             ReadWrite(#08,'W','N',CDVSNumber);
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
                             MostraNaTela;
                             ColocaNaConta(LoteMember.Tipo,'I');
                             TotalDoLote;
                             ContaNo     := ContaAC;
                             ContaNumber := ContaAN;
                             ReadWrite(#03,'R','N',ContaNumber);
                             ReadWrite(#06,'R','N',ContaNumber);
                           end;
                        ContaNo := LimpaChave(ContaMember.CPartidaC);
                        SearchTree1 ( Root1 );
                        If RC = 'S' then
                           begin
                             ReadWrite(#03,'R','N',ContaNumber);
                             LctoMember.Conta := ContaMember.OrigConta;
                             If Lctomember.Tipo = 'D'
                                then Lctomember.Tipo := 'C'
                                else LctoMember.Tipo := 'D';
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
                             XLanc              := XLanc + 1;
                             LctoMember.SeqLote := QQStr(XLanc,4,'0');
                             MostraNaTela;
                             CDVSNo     := ContaNo + '#' + XDL + '#' +
                                           LoteNo  + '#' + LctoMember.SeqLote;
                             CDVSNumber := FileSize(LctoFile);
                             LoadTree4 ( Root4 );
                             ReadWrite(#08,'W','N',CDVSNumber);
                             ColocaNaConta(LoteMember.Tipo,'I');
                             TotalDoLote;
                             ContaNo     := ContaAC;
                             ContaNumber := ContaAN;
                             RC          := 'S';
                           end;
                      end;
                 end;
            Until RC = 'N';
            ReadWrite(#16,'W','N',0);
            ReadWrite(#04,'W','N',LoteNumber);
            Color(Blue,Cyan);
            GotoXY(1,23); Write(' ':80);
            GotoXY(2,23); Write('O Lote de Corre‡„o de Contas esta gerado.');
            TeclaReturn;
          end;
     end;
end;


Procedure ExcluiAno;
begin
  Move(MemW[$B800:0000],ScArray4[1],4000);
  DrawBox(4,10,49,19,Red,'S');
  Color(Red,Yellow);
  GotoXY(4,10); Write('               Leia com Aten‡„o               ');
  Color(Red,Cyan);
  GotoXY(4,11); Write('               ----------------               ');
  GotoXY(4,12); Write(' Este  procedimento  exclui  fisicamente  dos ');
  GotoXY(4,13); Write(' arquivos do Sistema, todo o ano (Lan‡amentos ');
  GotoXY(4,14); Write(' cont beis).  Por precau‡„o, deve-se fazer um ');
  GotoXY(4,15); Write(' BACKUP, evitando  a perda  de informa‡”es se ');
  GotoXY(4,16); Write(' algo sair errado, ou se por  qualquer raz„o, ');
  GotoXY(4,17); Write(' a exclus„o for indevida.                     ');
  GotoXY(4,18); Write('                                              ');
  GotoXY(4,19); Write('                      Veja Manual do Usu rio. ');
  Color(Tfn,Utx);
  Confirma;
  If TC = 'S' then
     begin
       Move(ScArray4[1],MemW[$B800:0000],4000);
       YAno := '';
       Color(Tfn,Ttx);
       GotoXY(04,10); Write('Ano...:');
       Repeat
         J := YAno;
	 InputStr(J,2,12,10,0,'S','N','T','N',Tfn,Utx);
         YAno := J;
         Val(J,I,E);
         If (I   = CMstMember.AnoAtivo) and
            (TC <> #27                ) then
            begin
              DrawBox(4,12,49,18,Red,'S');
              Color(Red,Yellow);
              GotoXY(4,12); Write('               Leia com Aten‡„o               ');
              Color(Red,Cyan);
              GotoXY(4,13); Write('               ----------------               ');
              GotoXY(4,14); Write(' N„o ‚ poss¡vel prosseguir com esta exclus„o, ');
              GotoXY(4,15); Write(' uma vez que o ano que se deseja excluir esta ');
              GotoXY(4,16); Write(' ativo.  Mude o ano,  de modo  que este fique ');
              GotoXY(4,17); Write(' inativo, e volte a executar a exclus„o.      ');
              GotoXY(4,18); Write('                                              ');
              Color(Tfn,Utx);
              TeclaReturn;
              TC := #27;
            end
            else If TC <> #27 then Confirma;
       Until (TC = #27) or (TC = 'S');
       If TC = 'S' then
          begin
            Color(Blue,Yellow);
            GotoXY(1,23); Write(ConstStr(' ',80));
            GotoXY(2,23);
            Write('Excluindo Lotes, Lan‡amentos, Or‡amentos e Despesas.            Aguarde');
            Close  ( SaldFile );
            Assign ( SaldFile,(XPath + '\' + FileSald  + YAno + '.DAT'));
            {$I-}
            Reset ( SaldFile );
            {$I+}
            If IOResult = 0 then
               begin
                 Close ( SaldFile );
                 Erase ( SaldFile );
               end;
            Assign ( SaldFile,(XPath + '\' + FileSald  + AAFx + '.DAT'));
            Reset  ( SaldFile );
            Close  ( LoteFile );
            Assign ( LoteFile,(XPath + '\' + FileLote  + YAno + '.DAT'));
            {$I-}
            Reset ( LoteFile );
            {$I+}
            If IOResult = 0 then
               begin
                 Close ( LoteFile );
                 Erase ( LoteFile );
               end;
            Assign ( LoteFile,(XPath + '\' + FileLote  + AAFx + '.DAT'));
            Reset  ( LoteFile );
            Assign( IndLFile,(XPath + '\' + FileLote  + YAno + '.IDX'));
            {$I-}
            Reset ( IndLFile );
            {$I+}
            If IOResult = 0 then
               begin
                 Close ( IndLFile );
                 Erase ( IndLFile );
               end;
            Assign( IndLFile,(XPath + '\' + FileLote  + AAFx + '.IDX'));
            Close  ( ExpeFile );
            Assign ( ExpeFile,(XPath + '\' + FileExpe  + YAno + '.DAT'));
            {$I-}
            Reset ( ExpeFile );
            {$I+}
            If IOResult = 0 then
               begin
                 Close ( ExpeFile );
                 Erase ( ExpeFile );
               end;
            Assign ( ExpeFile,(XPath + '\' + FileExpe  + AAFx + '.DAT'));
            Reset  ( ExpeFile );
            Close  ( LctoFile );
            For I := 1 to 12 do
            begin
              Assign ( LctoFile,(XPath + '\' + FileLcto  + YAno + '.M' + QQStr(I,2,'0')));
              {$I-}
              Reset  ( LctoFile );
              {$I+}
              If IOResult = 0 then
                 begin
                   Close ( LctoFile );
                   Erase ( LctoFile );
                 end;
              Assign ( IndMFile,(XPath + '\' + FileLcto  + YAno + '.I' + QQStr(I,2,'0')));
              {$I-}
              Reset  ( IndMFile );
              {$I+}
              If IOResult = 0 then
                 begin
                   Close ( IndMFile );
                   Erase ( IndMFile );
                 end;
            end;
            Assign ( LctoFile,(XPath + '\' + FileLcto  + AAFx + '.' + MMFx ));
            Assign ( IndMFile,(XPath + '\' + FileLcto  + AAFx + '.' + IIFx ));
            Reset  ( LctoFile );
            Color(Blue,Cyan);
            GotoXY(1,23); Write(' ':80);
            GotoXY(2,23);
            Write('O ano de ',YAno,' foi exclu¡do fisicamente dos arquivos.');
            TeclaReturn;
          end;
     end;
end;


end.

