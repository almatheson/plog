{$O+,F+}
Unit AlogCnta;

Interface

Uses Crt,Dos,AlogGlbs,AlogNavg,AlogBasP,AlogDoct,AlogHsPd,AlogCmpy,
             AlogInit;

   Procedure TitleConta;
   Procedure IncluiConta(X : Char);
   Procedure ScrollConta(X : Char);
   Procedure UpdateConta;
   Procedure TitleSaldo;
   Procedure ConsultaSaldo;
   Procedure CorrecaoOrcamento;
   Procedure ImportaConta;
   Procedure Totaliza;

Implementation

Var
   ContaAtual     : Integer;
   IndiceCW       : Str2;
   HistoricoCW    : Str3;
   OrigContaW,
   CPartidaXW,
   SinteticaW,
   CPartidaCW     : Str20;
   DescricaoW     : Str40;
   Ab,Fe,
   GrupoW,
   GrauW,
   TipoW,
   AceitaW,
   AvisaW,
   StatusW,
   PedeDeptoW,
   GrupoEW,
   CorrecaoW,
   DiarioW,
   PeriodoCW      : Char;
   BalanceteW     : Array[1..5] of Char;
   BalancoW       : Array[1..5] of Char;
   RArray         : Array[1..7] of Integer;
   KArray         : Array[1..7] of Str18;
   NArray         : Array[1..7] of Str40;
   VArray         : Array[1..7] of Str20;
   EArray         : Array[1..7] of Char;
   DArray         : Array[1..7] of Char;



Procedure TitleConta;
begin
  Color(Tfn,Ttx);
  GotoXY(04,09);  Write('Conta.:');
  Color(Sfn,Stx);
  GotoXY(44,09);  Write(' Reduz.: ');
  Color(Tfn,Ttx);
  GotoXY(04,10);  Write('Descr.:');
  GotoXY(04,11);  Write('Grupo.:');
  GotoXY(04,12);  Write('Tipo..:');
  GotoXY(04,13);  Write('Grau..:');
  GotoXY(04,14);  Write('Aceita:');
  GotoXY(04,15);  Write('Avisa.:');
  GotoXY(04,16);  Write('Depto.:');
  GotoXY(04,18);  Write('Apuraá:');
  GotoXY(04,20);  Write('Status:');
  GotoXY(30,12); Write('Correá:');
  GotoXY(30,13); Write('Indice:');
  GotoXY(30,14); Write('Per°od:');
  GotoXY(30,15); Write('Result:');
  GotoXY(30,16); Write('C.Part:');
  GotoXY(30,17); Write('Hist¢r:');
  GotoXY(30,18); Write('Di†rio:');
  GotoXY(30,19); Write('Balcte:');
  GotoXY(30,20); Write('Balaná:');
  Color(Tfn,Utx);
end;


Procedure MostraStatus;
begin
  GotoXY(12,20); Case SaldMember.Status of
                      'A' : Write('Ativa     ');
                      'D' : Write('Desativada');
                      'C' : Write('Cancelada ');
                      'X' : Write('Excluir   ');
                 end;
end;


Procedure DataConta;
begin
  HelpM;
  ReadWrite(#03,'R','N',ContaNumber);
  ReadWrite(#06,'R','N',ContaNumber);
  With ContaMember do
  begin
    ContaNo := Conta;
    ContaAC := Conta;
    ContaAN := ContaNumber;
    Color(Tfn,Utx);
    GotoXY(12,09); Write(PushLeft(30,OrigConta));
    Color(Sfn,Stx);
    GotoXY(53,09); Write(ContaNumber:4,' ');
    Color(Tfn,Utx);
    GotoXY(12,10); Write(PushLeft(41,Descricao));
    GotoXY(12,11); Case Grupo of
                        'A' : Write('Ativo   ');
                        'P' : Write('Passivo ');
                        'R' : Write('Receita ');
                        'D' : Write('Despesa ');
                        'T' : Write('Transit.');
                   end;
    Color(Tfn,Yellow);
    GotoXY(30,11); Write('SintÇt:');
    Color(Tfn,Utx);
    GotoXY(12,12); Case Tipo of
                        'A' : Write('Anal°tica');
                        'S' : Write('SintÇtica');
                        else  Write('         ');
                   end;
    GotoXY(12,13); Write(Grau);
    GotoXY(12,14); Case Aceita of
                        'D' : Write('DÇbito    ');
                        'C' : Write('CrÇdito   ');
                        'A' : Write('Ambos     ');
                        'N' : Write('NÑo aceita');
                   end;
    GotoXY(12,15); Case Avisa of
                        'D' : Write('Devedor  ');
                        'C' : Write('Credor   ');
                        'N' : Write('NÑo avisa');
                   end;
    GotoXY(12,16); Case PedeDepto of
                        'S' : Write('Sim     ');
                        'N' : Write('NÑo pede');
                        else  Write('        ');
                   end;
    GotoXY(12,18); Write(GrupoE);
    GotoXY(14,18); Case GrupoE of
                        '0' : Write('Receita L°quida');
                        '1' : Write('Lucro Bruto    ');
                        '2' : Write('Lucro Operacio.');
                        '3' : Write('Lucro a/Corr.M.');
                        '4' : Write('Lucro a/Cont.S.');
                        '5' : Write('Lucro a/Pr.I.R.');
                        '6' : Write('Lucro L°quido  ');
                        '7' : Write('Ap.de Resultado');
                        '8' : Write('Balanáo        ');
                        'N' : Write('NÑo Considerada');
                   end;
    GotoXY(38,12); Case Correcao of
                        'S' : Write('Sem Cta.Resultado');
                        'C' : Write('Com Cta.Resultado');
                        'N' : Write('NÑo Corrige      ');
                   end;
    If Correcao <> 'N' then
       begin
         Str(CMstMember.AnoAtivo,XAno);
         IINo := XAno + '#' + IndiceC;
         SearchTree7 ( Root7 );
         If RC = 'S' then
            begin
              ReadWrite(#12,'R','N',IINumber);
              If RW = 'S' then
                 begin
                   GotoXY(38,13); Write(IndiceC);
                   GotoXY(41,13); Write(EcoMember.Descricao);
                 end;
            end;
       end;
    GotoXY(38,14); Case PeriodoC of
                        'A' : Write('Anual ');
                        'M' : Write('Mensal');
                        else  Write('      ');
                   end;
    GotoXY(38,15);
    If CPartidaX <> '' then Write(CPartidaX)
                       else Write(' ':15);
    GotoXY(38,16);
    If CPartidaC <> '' then Write(CPartidaC)
                       else Write(' ':15);
    GotoXY(38,17);
    If HistoricoC <> '' then Write(HistoricoC);
    GotoXY(38,18); Case Diario of
                        'S' : Write('Sim');
                        'N' : Write('NÑo');
                   end;
    For I := 1 to 5 do begin
                         GotoXY(37+I,19); Write(Balancete[I]);
                         GotoXY(37+I,20); Write(Balanco[I]);
                       end;
    MostraStatus;
    OrigContaW    := OrigConta;
    DescricaoW    := Descricao;
    GrupoW        := Grupo;
    GrauW         := Grau;
    TipoW         := Tipo;
    AceitaW       := Aceita;
    AvisaW        := Avisa;
    PedeDeptoW    := PedeDepto;
    GrupoEW       := GrupoE;
    CorrecaoW     := Correcao;
    IndiceCW      := IndiceC;
    PeriodoCW     := PeriodoC;
    CPartidaXW    := CPartidaX;
    CPartidaCW    := CPartidaC;
    HistoricoCW   := HistoricoC;
    SinteticaW    := Sintetica;
    DiarioW       := Diario;
    For I := 1 to 5 do begin
                         BalanceteW[I] := Balancete[I];
                         BalancoW[I]   := Balanco[I];
                       end;
    StatusW       := SaldMember.Status;
    GotoXY(38,11); Write(PushLeft(21,Sintetica));
  end;
end;


{$I AlogCt01.inc }


Procedure MoveParaArrayE(L : Integer;
                         X : Char   );
begin
  ReadWrite(#03,'R','N',ContaNumber);
  If RW = 'S' then
     begin
       RArray[L] := ContaNumber;
       KArray[L] := ContaMember.OrigConta;
       NArray[L] := ContaMember.Descricao;
       If X = 'S' then
          begin
            ReadWrite(#06,'R','N',ContaNumber);
            VArray[L] := EditDouble(SaldMember.Saldo[MM]);
            Case ContaMember.Grupo of
                 'A','D','T' : If TruncX(SaldMember.Saldo[MM]) < 0
                                  then VArray[L] := '<' + VArray[L] + '>'
                                  else VArray[L] := ' ' + VArray[L] + ' ';
                 'P','R'     : If TruncX(SaldMember.Saldo[MM]) > 0
                                  then VArray[L] := '<' + VArray[L] + '>'
                                  else VArray[L] := ' ' + VArray[L] + ' ';
            end;
            If ((SaldMember.Saldo[MM] < 0) and (ContaMember.Avisa = 'C')) or
               ((SaldMember.Saldo[MM] > 0) and (ContaMember.Avisa = 'D'))
               then EArray[L] := 'S'
               else EArray[L] := 'N';
          end
          else DArray[L] := ContaMember.Grau;
     end;
end;


Procedure ArrayParaArrayE(D,P : Integer);
begin
  KArray[P]  := KArray[D];
  RArray[P]  := RArray[D];
  NArray[P]  := NArray[D];
  VArray[P]  := VArray[D];
  EArray[P]  := EArray[D];
  DArray[P]  := DArray[D];
end;


Procedure ScrollConta(X : Char);
Var
   Cont,Direcao,
   F,Tkb          : Char;
   Sx,R,N         : Integer;
   ScArrayS       : Array [1..4000] of Char;
begin
  Move(Mem[$B800:0000],ScArrayS[1],4000);
  FootScroll;
  Case X of
       'C' : begin
               DrawBox(6,11,73,20,Sfn,'S');
               Color(Bfn,Btx);
               GotoXY(6,11);
               Write(' Conta',' ':14,'DescriáÑo',' ':32,'ß RDZ. ');
             end;
       'S' : begin
               DrawBox(2,11,77,20,Sfn,'S');
               Color(Bfn,Btx);
               GotoXY(2,11);
               Write(' Conta',' ':14,'DescriáÑo',' ':40,'Saldo  ');
             end;
  end;
  Color(Sfn,Stx);
  F       := 'N';
  Direcao := 'P';
  L       := 0;
  Sx      := 1;
  For I := 1 to 7 do begin
                       KArray[I] := '';
                       RArray[I] := 0;
                       NArray[I] := '';
                       VArray[I] := '';
                       DArray[I] := ' ';
                       EArray[I] := ' ';
                     end;
  RC := 'N';
  SearchAnt1 ( Root1 );
  If RC = 'N' then ContaNo := '';
  Repeat
    RC := 'N';
    SearchPos1 ( Root1 );
    If RC = 'S' then
       begin
         L := L + 1;
         MoveParaArrayE(L,X);
       end
       else L := 7;
  Until L = 7;
  Repeat
    If X = 'C' then Window(6,13,74,20)
               else Window(2,13,78,20);
    For I := 1 to 7 do begin
                          If KArray[I] <> '' then
                             begin
                               If I = Sx then Color(Tfn,Utx)
                                  else If X = 'S' then
                                          begin
                                            If EArray[I] = 'S' then Color(Bfn,Btx)
                                                               else Color(Sfn,Stx);
                                          end
                                          else Color(Sfn,Stx);
                               GotoXY(1,I);
                               Case X of
                                    'C' : Writeln(' ',Pushleft(19,KArray[I]),
                                                      PushLeft(41,NArray[I]),
                                                      DArray[I],' ',
                                                      RArray[I]:4,' ');
                                    'S' : begin
                                            Writeln(' ',PushLeft(19,KArray[I]),
                                                        Pushleft(35,Copy(NArray[I],1,34)),
                                                        VArray[I]:20,' ');
                                          end;
                               end;
                               Color(Sfn,Stx);
                             end;
                       end;
    Window(1,1,80,25);
    Cont := ReadKey;
    If (Cont = #0 ) and
       (KeyPressed) then
       begin
         Cont := ReadKey;
         Case Cont of
              #72,#73 : begin
                          DirScroll(Cont);
                          Direcao := 'A';
                          If Cont = #72 then Tkb := 'L'
                                        else Tkb := 'P';
                        end;
              #80,#81 : begin
                          DirScroll(Cont);
                          Direcao := 'P';
                          If Cont = #80 then Tkb := 'L'
                                        else Tkb := 'P';
                        end;
              else Direcao := ' ';
         end;
       end
       else If (Cont = #13) or (Cont = #27) then Direcao := 'N';
    LimpaLn(24,Red);
    N := 7;
    Case Direcao of
         'A' : If F <> 'A' then
                  begin
                    Case Tkb of
                         'L' : If Sx > 1 then
                                  begin
                                    Sx := Sx - 1;
                                    F  := 'N';
                                  end
                                  else begin
                                         RC      := 'N';
                                         ContaNo := LimpaChave(KArray[1]);
                                         SearchAnt1 ( Root1 );
                                         If RC = 'S' then
                                            begin
                                              For I := 7 downto 2
                                              do ArrayParaArrayE((I-1),I);
                                              MoveParaArrayE(1,X);
                                              F := 'N';
                                            end
                                            else F := 'A';
                                       end;
                         'P' : begin
                                Sx := 1;
                                N  := 0;
                                Repeat
                                  RC      := 'N';
                                  ContaNo := LimpaChave(KArray[1]);
                                  SearchAnt1 ( Root1 );
                                  If RC = 'S' then
                                     begin
                                       For I := 7 downto 2
                                       do ArrayParaArrayE((I-1),I);
                                       MoveParaArrayE(1,X);
                                       N := N + 1;
                                       F := 'N';
                                     end
                                     else F := 'A';
                                Until (N = 7) or (RC = 'N');
                              end;
                    end;
                  end;
         'P' : If F <> 'P' then
                  begin
                    Case Tkb of
                         'L' : If Sx < 7 then
                                  begin
                                    If KArray[Sx+1] <> '' then
                                       begin
                                         Sx := Sx + 1;
                                         F  := 'N';
                                       end
                                       else F := 'P';
                                  end
                                  else begin
                                         RC      := 'N';
                                         ContaNo := LimpaChave(KArray[Sx]);
                                         SearchPos1 ( Root1 );
                                         If RC = 'S' then
                                            begin
                                              For I := 2 to 7
                                              do ArrayParaArrayE(I,(I-1));
                                              MoveParaArrayE(7,X);
                                              F := 'N';
                                            end
                                            else F := 'P';
                                       end;
                         'P' : begin
                                Sx := 1;
                                N  := 0;
                                Repeat
                                  R := 7;
                                  For L := 1 to 7
                                  do If KArray[L] <> '' then R := L;
                                  RC      := 'N';
                                  ContaNo := LimpaChave(KArray[R]);
                                  SearchPos1 ( Root1 );
                                  If RC = 'S' then
                                     begin
                                       For I := 2 to 7
                                       do ArrayParaArrayE(I,(I-1));
                                       MoveParaArrayE(R,X);
                                       N := N + 1;
                                     end;
                                Until (N = 7) or (RC = 'N');
                                F := 'N';
                              end;
                    end;
                  end;
    end;
    If (F <> 'N') or (N < 7) then ScrollFim;
  Until (Cont = #27) or (Cont = #13);
  Move(ScArrayS[1],MemW[$B800:0000],4000);
  Color(Tfn,Utx);
  If Cont = #13 then
     begin
       ContaAN := RArray[Sx];
       ContaAC := KArray[Sx];
     end;
end;


Procedure PesquisaConta;
Var
  NomeX,NomeY     : Str40;
  NPesq,NCont,
  I,B,L           : Integer;
  ScArrayS        : Array [1..4000] of Char;
begin
  Move(Mem[$B800:0000],ScArrayS[1],4000);
  Move(ScArray4[1],MemW[$B800:0000],4000);
  Color(Tfn,Ttx);
  GotoXY(4,08); Write(ConstStr(' ',10));
  GotoXY(4,09); Write('Argum.:');
  GotoXY(4,10); Write(ConstStr(' ',10));
  DrawBox(20,12,56,19,Red,'S');
  Color(Red,Cyan);
  GotoXY(20,12); Write(' O sistema selecionar†  todas Contas ');
  GotoXY(20,13); Write(' pelo      ou parte.  Para pesquisar ');
  GotoXY(20,14); Write(' basta que se digite o nome ou parte ');
  GotoXY(20,15); Write(' podendo esta parte ser  um conjunto ');
  GotoXY(20,16); Write(' de caracteres do nome.      NÑo  se ');
  GotoXY(20,17); Write(' importe com o  formato  das letras, ');
  GotoXY(20,18); Write(' se mai£sculas  ou  min£sculas,  nÑo ');
  GotoXY(20,19); Write(' tem influància na pesquisa.         ');
  Color(Red,Yellow);
  GotoXY(26,13); Write('NOME');
  J := '';
  Repeat
    K := 1;
    Repeat
      Case K of
           1  :  begin
                   InputStr(J,40,12,9,0,'S','S','T','N',Sfn,Stx);
                   If TC <> #27 then
                      begin
                        If J = '' then
                           begin
                             ErroMsg  := 'Campo de pesquisa Inv†lido';
                             ErrorMessage;
                           end
                           else begin
                                  J := UpCaseStr(J);
                                  GotoXY(12,9); Write(PushLeft(41,J));
                                  K := 2;
                                end;
                      end;
                 end;
      end;
    Until (K = 2) or (TC = #27);
    If TC <> #27 then Confirma;
  Until TC in ['S',#27];
  If TC = 'S' then
     begin
       Color(Tfn,Ttx);
       For I := 12 to 20 do begin
                              GotoXY(20,I);  Write(ConstStr(' ',40));
                            end;
       GotoXY(04,11);  Write('C¢digo:');
       GotoXY(04,12);  Write('Descr.:');
       GotoXY(04,13);  Write('Grupo.:');
       GotoXY(30,13);  Write('SintÇt:');
       GotoXY(04,14);  Write('Tipo..:');
       GotoXY(04,15);  Write('Grau..:');
       GotoXY(04,16);  Write('Apuraá:');
       Color(Tfn,Utx);
       Color(Blue,Cyan);
       GotoXY(01,23); Write(ConstStr(' ',80));
       GotoXY(02,23); Write('Encontradas --',#26);
       GotoXY(36,23); Write('Total Pesquisado --',#26);
       Color(Red,Cyan);
       GotoXY(01,24); Write(ConstStr(' ',80));
       GotoXY(02,24);
       Write('[   ] para Cancelar, [     ] retorna a Conta,   [ ] continua a Pesquisar.');
       Color(Red,Yellow);
       GotoXY(03,24); Write('Esc');
       GotoXY(24,24); Write('Enter');
       GotoXY(51,24); Write(#25);
       Color(Tfn,Utx);
       Move(MemW[$B800:0000],ScArray5[1],4000);
       ContaNo  := '';
       NPesq    := 0;
       NCont    := 0;
       Color(Blue,Cyan);
       GotoXY(01,23); Write(ConstStr(' ',80));
       GotoXY(36,23); Write('Total Pesquisado --',#26);
       Repeat
         RC := 'N';
         SearchPos1 ( Root1 );
         If RC = 'S' then
            With ContaMember do
            begin
              ReadWrite(#03,'R','N',ContaNumber);
              NPesq := NPesq + 1;
              NomeY := UpCaseStr(Descricao);
              I     := Length(Descricao);
              B     := Length(J);
              L     := 0;
              TC    := 'N';
              Repeat
                L := L + 1;
                NomeX := Copy(NomeY,L,B);
                If J = NomeX then TC := 'S';
              Until (TC = 'S') or ((L+B) > I);
              If TC = 'S' then
                 begin
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   Color(Tfn,Utx);
                   GotoXY(12,11); Write(PushLeft(19,OrigConta));
                   GotoXY(12,12); Write(PushLeft(41,Descricao));
                   GotoXY(12,13); Case Grupo of
                                       'A' : Write('Ativo      ');
                                       'P' : Write('Passivo    ');
                                       'R' : Write('Receita    ');
                                       'D' : Write('Despesa    ');
                                       'T' : Write('Transit¢ria');
                                  end;
                   GotoXY(38,13); Write(PushLeft(19,Sintetica));
                   GotoXY(12,14); Case Tipo of
                                       'A' : Write('Anal°tica');
                                       'S' : Write('SintÇtica')
                                  end;
                   GotoXY(12,15); Write(Grau);
                   GotoXY(12,16); Case GrupoE of
                                       '0' : Write('Receita L°quida');
                                       '1' : Write('Lucro Bruto    ');
                                       '2' : Write('Lucro Operacio.');
                                       '3' : Write('Lucro a/Corr.M.');
                                       '4' : Write('Lucro a/Cont.S.');
                                       '5' : Write('Lucro a/Pr.I.R.');
                                       '6' : Write('Lucro L°quido  ');
                                       '7' : Write('Lucros & Perdas');
                                       '8' : Write('Balanáo        ');
                                       'N' : Write('NÑo Considerada');
                                  end;
                   NCont := NCont + 1;
                   Color(Blue,Yellow);
                   GotoXY(18,23); Write(NCont:5);
                   GotoXY(57,23); Write(NPesq:5);
                   Color(Tfn,Utx);
                   Repeat
                     TC := ReadKey;
                     If (TC = #00) and (KeyPressed) then TC := ReadKey;
                   Until (TC = #27) or (TC = #13) or (TC = #80);
                   Case TC of
                        #13 : begin
                                RC      := 'N';
                                ContaAC := ContaNo;
                                ContaAN := ContaNumber;
                              end;
                        #27 : RC := 'N';
                   end;
                 end
                 else begin
                        Color(Blue,Yellow);
                        GotoXY(57,23); Write(NPesq:5);
                        Color(Tfn,Utx);
                      end;
            end
            else begin
                   Color(Red,Cyan);
                   GotoXY(01,24); Write(ConstStr(' ',80));
                   GotoXY(02,24);
                   Write('Terminou a pesquisa, o argumento nÑo foi encontrado.            Tecle [     ]');
                   Color(Red,Yellow);
                   GotoXY(73,24); Write('Enter');
                   Color(Tfn,Utx);
                   Repeat
                     TC := ReadKey;
                   Until TC = #13;
                 end;
         If KeyPressed then
            begin
              TC := ReadKey;
              If TC = #27 then RC := 'N';
            end;
       Until RC = 'N';
     end;
  Move(ScArrayS[1],Mem[$B800:0000],4000);
end;



Procedure UpdateConta;
begin
           Titulo := 'Plano de Contas                        ';
           BuildFrame('S');
           Color(Red,White);
           GotoXY(36,07); Write('Total de Contas: ');
           GotoXY(62,08); Write(#27,#217);
           GotoXY(62,10); Write(#24);
           GotoXY(62,11); Write(#25);
           GotoXY(62,13); Write('F1');
           GotoXY(62,14);
           If XSt = 'A' then Write('F3');
           GotoXY(62,15); Write('F5');
           GotoXY(62,17); Write('F7');
           GotoXY(62,18);
           If XSt = 'A' then Write('F9');
           Color(Red,Yellow);
           GotoXY(53,07); Write(CMstMember.NContas);
           GotoXY(66,08); Write('C¢digo  ');
           GotoXY(66,10); Write('Anterior');
           GotoXY(66,11); Write('Pr¢ximo ');
           GotoXY(66,13); Write('Contas  ');
           GotoXY(66,14);
           If XSt = 'A' then Write('Alterar ');
           GotoXY(66,15); Write('Saldos   ');
           GotoXY(66,17); Write('Pesquisar');
           GotoXY(66,18);
           If XSt = 'A' then Write('Editar C¢d.');
           Shade(3,8,60,21,LightGray,Black);
           Color(Tfn,Ttx);
           GotoXY(04,09); Write('Conta.:');
           Move(MemW[$B800:0000],ScArray4[1],4000);
  Repeat
    J := '';
    InputStr(J,18,12,9,0,'S','N','T','N',Tfn,Utx);
    LimpaLn(24,Tfd);
    If TC = #27
       then ContaNumber := Limite
       else If TC = #25 then
               begin
                 ContaNo := '';
                 RC      := 'N';
                 SearchPos1 ( Root1 );
                 If RC = 'N' then ContaNumber := Limite;
               end
               else If J <> '' then
                       begin
                         ContaNo := LimpaChave(J);
                         SearchTree1 ( Root1 );
                         If RC = 'N' then
                            begin
                              If XSt = 'A' then
                                 begin
                                   ContaNumber := FileSize(ContaFile);
                                   IncluiConta('I');
                                 end
                                 else ContaNumber := Limite;
                            end;
                       end
                       else ContaNumber := Limite;
    If ContaNumber <> Limite then
       With ContaMember do
       begin
         Repeat
           TitleConta;
           DataConta;
           Repeat
             Resp := ReadKey;
             LimpaLn(24,Tfd);
             If (Resp = #0) and (KeyPressed) then
                begin
                  Resp := ReadKey;
                  Case Resp of
                       #30,#32,#45,#46 : If XSt = 'A' then
                                            begin
                                              Case Resp of
                                                   #30 : SaldMember.Status := 'A';
                                                   #32 : SaldMember.Status := 'D';
                                                   #45 : SaldMember.Status := 'X';
                                                   #46 : SaldMember.Status := 'C';
                                              end;
                                              ReadWrite(#06,'W','N',ContaNumber);
                                              MostraStatus;
                                            end;
                       #59 : begin
                               ScrollConta('C');
                               ContaNumber := ContaAN;
                               ContaNo     := ContaAC;
                               DataConta;
                             end;
                       #61 : If XSt = 'A' then
                                begin
                                  Op         := 'A';
                                  ContaAtual := ContaNumber;
                                  ContaXX    := ContaNo;
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
                                            Until ((Tipo  = 'S'   )  and
                                                   (Grau  < GrauW )  and
                                                   (Grupo = GrupoW)) or
                                                  (RC     = 'N'    );
                                            If RC = 'S' then SinteticaW := ContaNo;
                                          end
                                          else begin
                                                 SinteticaW := '';
                                                 RC         := 'S';
                                               end;
                                       If RC = 'S' then
                                          begin
                                            ContaNumber := ContaAtual;
                                            ReadWrite(#03,'R','N',ContaNumber);
                                            ContaNo      := ContaXX;
                                            Descricao    := DescricaoW;
                                            Grupo        := GrupoW;
                                            Tipo         := TipoW;
                                            Grau         := GrauW;
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
                                            Diario       := DiarioW;
                                            For I := 1 to 5 do
                                            begin
                                              Balancete[I] := BalanceteW[I];
                                              Balanco[I]   := BalancoW[I];
                                            end;
                                            Sintetica    := SinteticaW;
                                            ReadWrite(#03,'W','N',ContaNumber);
                                            ReadWrite(#06,'R','N',ContaNumber);
                                            If RW = 'N' then
                                               begin
                                                 For I := 1 to 12 do
                                                 begin
                                                   SaldMember.Abertura[I] := 0;
                                                   SaldMember.Debitos[I]  := 0;
                                                   SaldMember.Creditos[I] := 0;
                                                   SaldMember.Saldo[I]    := 0;
                                                   SaldMember.SaldoB[I]   := 0;
                                                   SaldMember.NLanctos[I] := 0;
                                                 end;
                                               end;
                                            SaldMember.Status := StatusW;
                                            ReadWrite(#06,'W','N',ContaNumber);
                                          end
                                          else begin
                                                 ErroMsg := 'NÑo encontrei a SintÇtica';
                                                 ErrorMessage;
                                                 ContaNo     := ContaXX;
                                                 ContaNumber := ContaAtual;
                                               end;
                                     end;
                                end;
                       #63 : begin
                               ScrollConta('S');
                               ContaNumber := ContaAN;
                               ContaNo     := ContaAC;
                               DataConta;
                             end;
                       #65 : begin
                               ContaAC := ContaNo;
                               ContaAN := ContaNumber;
                               PesquisaConta;
                               ContaNo     := ContaAC;
                               ContaNumber := ContaAN;
                               TitleConta;
                               DataConta;
                             end;
                       #67 : begin
                               J := OrigConta;
                               Repeat
                                 InputStr(J,18,12,9,0,'S','N','T','N',Tfn,Utx);
                               Until (ContaNo = LimpaChave(J)) or (TC = #27);
                               If TC <> #27 then
                                  begin
                                    Conta     := ContaNo;
                                    OrigConta := J;
                                    ReadWrite(#03,'W','N',ContaNumber);
                                  end
                                  else begin
                                         Color(Tfn,Utx);
                                         GotoXY(12,9); Write(Pushleft(19,OrigConta));
                                       end;
                             end;
                       #72 : begin
                               RC := 'N';
                               SearchAnt1 ( Root1 );
                               If RC = 'N' then AvisoFinal;
                             end;
                       #80 : begin
                               RC := 'N';
                               SearchPos1 ( Root1 );
                               If RC = 'N' then AvisoFinal;
                             end;
                       #94 : HelpManual;
                  end;
                end;
           Until (Resp = #13)   or
                 (Resp = #27)   or
                 (((Resp = #80) or (Resp = #72)) and (RC <> 'N'));
           Move(ScArray4[1],MemW[$B800:0000],4000);
         Until (Resp = #13) or (Resp = #27);
         TC := Resp;
       end;
  Until TC = #27;
end;


{$I AlogCt02.inc }


Procedure TitleSaldo;
begin
  Color(Tfn,Ttx);
  GotoXY(04,10);  Write('Conta.:');
  Color(Sfn,Stx);
  GotoXY(47,10);  Write(' Reduz.: ');
  Color(Tfn,Ttx);
  GotoXY(04,12);  Write('Descr.:');
  GotoXY(04,16);  Write('Abert.:');
  GotoXY(04,17);  Write('DÇbito:');
  GotoXY(04,18);  Write('CrÇdit:');
  GotoXY(04,20);  Write('Saldo.:');
  Color(Tfn,Utx);
end;


Procedure DataSaldo;
begin
  HelpM;
  With ContaMember do
  begin
    ReadWrite(#03,'R','N',ContaNumber);
    ContaNo := Conta;
    ContaAC := Conta;
    ContaAN := ContaNumber;
    Color(Bfn,Btx);
    GotoXY(47,08); Case Grupo of
                        'A' : Write(' Ativo        ');
                        'P' : Write(' Passivo      ');
                        'R' : Write(' Receitas     ');
                        'D' : Write(' Despesas     ');
                        'T' : Write(' Transit¢rias ');
                   end;
    Color(Sfn,Stx);
    GotoXY(47,09); Case Tipo  of
                        'A' : Write(' Anal°tica    ');
                        'S' : Write(' SintÇtica    ');
                   end;
    Color(Tfn,Utx);
    GotoXY(12,10); Write(Pushleft(19,OrigConta));
    Color(Sfn,Stx);
    GotoXY(56,10); Write(ContaNumber:4,' ');
    Color(Tfn,Utx);
    GotoXY(12,12); Write(PushLeft(41,Descricao));
    ReadWrite(#06,'R','N',ContaNumber);
    If RW = 'S' then
       With SaldMember do
       begin
	 If Tipo = 'A' then
	    begin
	      Color(Tfn,Ttx);
	      GotoXY(4,14);  Write('Lanáam:');
	      Color(Tfn,Utx);
	      GotoXY(12,14); Write(NLanctos[MM]:4);
	    end;
         If (Abertura[MM] <> 0) or
            (Debitos[MM]  <> 0) or
            (Creditos[MM] <> 0) then
            begin
              GotoXY(12,16);
              If ((ContaMember.Grupo = 'A') and (TruncX(Abertura[MM]) < 0)) or
                 ((ContaMember.Grupo = 'D') and (TruncX(Abertura[MM]) < 0)) or
                 ((ContaMember.Grupo = 'T') and (TruncX(Abertura[MM]) < 0)) or
                 ((ContaMember.Grupo = 'P') and (TruncX(Abertura[MM]) > 0)) or
                 ((ContaMember.Grupo = 'R') and (TruncX(Abertura[MM]) > 0))
                 then Write('<',EditDouble(Abertura[MM]):17,'>')
                 else Write(' ',EditDouble(Abertura[MM]):17,' ');
              GotoXY(12,17); Write(' ',EditDouble(Debitos[MM]):17,' ');
              GotoXY(12,18); Write(' ',EditDouble(Creditos[MM]):17,' ');
              GotoXY(13,19); Write(ConstStr('-',17));
              GotoXY(12,20);
              If ((ContaMember.Grupo = 'A') and (TruncX(Saldo[MM]) < 0)) or
                 ((ContaMember.Grupo = 'D') and (TruncX(Saldo[MM]) < 0)) or
                 ((ContaMember.Grupo = 'T') and (TruncX(Saldo[MM]) < 0)) or
                 ((ContaMember.Grupo = 'P') and (TruncX(Saldo[MM]) > 0)) or
                 ((ContaMember.Grupo = 'R') and (TruncX(Saldo[MM]) > 0))
                 then Write('<',EditDouble(Saldo[MM]):17,'>')
                 else Write(' ',EditDouble(Saldo[MM]):17,' ');
            end
            else If SaldMember.NLanctos[MM] = 0 then
                    begin
                      Color(Blue,White);
                      GotoXY(1,23); Write(ConstStr(' ',80));
                      GotoXY(2,23); Write('NÑo tem Movimento neste Màs !');
                      Color(Tfn,Utx);
                    end;
       end
       else begin
	      Color(Blue,White);
              GotoXY(1,23); Write(ConstStr(' ',80));
              GotoXY(2,23); Write('** NÑo consigo ler o registro **');
              Color(Tfn,Utx);
            end;
  end;
end;


Procedure ConsultaSaldo;
begin
           Titulo := 'Saldo/Movimento                        ';
           BuildFrame('S');
           Color(Red,White);
           GotoXY(36,07); Write('Total de Contas: ');
           GotoXY(62,08); Write(#27,#217);
           GotoXY(62,10); Write(#24);
           GotoXY(62,11); Write(#25);
           GotoXY(62,13); Write('F1');
           GotoXY(62,14); Write('F5');
           GotoXY(62,15); Write('F7');
           GotoXY(62,17); Write('F9');
           Color(Red,Yellow);
           GotoXY(53,07); Write(CMstMember.NContas);
           GotoXY(66,08); Write('C¢digo     ');
           GotoXY(66,10); Write('Anterior   ');
           GotoXY(66,11); Write('Pr¢ximo    ');
           GotoXY(66,13); Write('Contas     ');
           GotoXY(66,14); Write('Saldos     ');
           GotoXY(66,15); Write('Lanáamentos');
           GotoXY(66,17); Write('Pesquisar  ');
           Shade(3,8,60,21,LightGray,Black);
           Color(Tfn,Ttx);
           GotoXY(4,10);  Write('Conta.:');
           Move(MemW[$B800:0000],ScArray4[1],4000);
  Repeat
    J := '';
    InputStr(J,18,12,10,0,'S','N','T','N',Tfn,Utx);
    LimpaLn(24,Tfd);
    If TC = #27
       then ContaNumber := Limite
       else If TC = #25 then
               begin
                 ContaNo := '';
                 RC      := 'N';
                 SearchPos1 ( Root1 );
                 If RC = 'N' then ContaNumber := Limite;
               end
               else If J <> '' then
                       begin
                         ContaNo := LimpaChave(J);
                         SearchTree1 ( Root1 );
                         If RC = 'N' then
                            begin
                              ContaNumber := Limite;
                              ErroMsg     := 'Conta nÑo Existe';
                              ErrorMessage;
                            end;
                       end
                       else ContaNumber := Limite;
    If ContaNumber <> Limite then
       With ContaMember do
       begin
         Repeat
           TitleSaldo;
           DataSaldo;
           Repeat
             Resp := ReadKey;
             LimpaLn(24,Tfd);
             If (Resp = #0) and (KeyPressed) then
                begin
                  Resp := ReadKey;
                  Case Resp of
                       #59 : begin
                               ScrollConta('C');
                               ContaNumber := ContaAN;
                               ContaNo     := ContaAC;
                               Move(ScArray4[1],MemW[$B800:0000],4000);
                               TitleSaldo;
                               DataSaldo;
                             end;
                       #63 : begin
                               ScrollConta('S');
                               ContaNumber := ContaAN;
                               ContaNo     := ContaAC;
                               Move(ScArray4[1],MemW[$B800:0000],4000);
                               TitleSaldo;
                               DataSaldo;
                             end;
                       #65 : begin
                               If Tipo = 'S' then
                                  begin
                                    ErroMsg := 'Conta nÑo Ç Analçtica';
                                    ErrorMessage;
                                  end
                                  else With SaldMember do
                                       begin
                                         If NLanctos[MM] = 0 then
                                            begin
                                              ErroMsg := 'Conta nÑo tem ' +
                                                         'Movimento';
                                              ErrorMessage;
                                            end
                                            else ScrollLancto;
                                       end;
                             end;
                       #67 : begin
                               ContaAC := ContaNo;
                               ContaAN := ContaNumber;
                               PesquisaConta;
                               ContaNo     := ContaAC;
                               ContaNumber := ContaAN;
                               Move(ScArray4[1],MemW[$B800:0000],4000);
                               TitleSaldo;
                               DataSaldo;
                             end;
                       #72 : begin
                               RC := 'N';
                               SearchAnt1 ( Root1 );
                               If RC = 'N' then AvisoFinal;
                             end;
                       #80 : begin
                               RC := 'N';
                               SearchPos1 ( Root1 );
                               If RC = 'N' then AvisoFinal;
                             end;
                       #94 : HelpManual;
                  end;
                end;
           Until (Resp   = #13) or (Resp = #27)   or
                 (((Resp = #80) or (Resp = #72)) and (RC <> 'N'));
           Move(ScArray4[1],MemW[$B800:0000],4000);
         Until (Resp = #13) or (Resp = #27);
         TC := Resp;
       end;
  Until TC = #27;
end;


Procedure CorrecaoOrcamento;
Var
  Fator : Real;

begin
              Titulo := 'Correá∆o de Oráamentos                 ';
              BuildFrame('S');
              Color(Red,White);
              GotoXY(36,7); Write('Total de Deptos: ');
              Color(Red,Yellow);
              GotoXY(53,7); Write(CMstMember.NDeptos);
  DrawBox(4,10,49,19,Red,'S');
  Color(Red,Yellow);
  GotoXY(4,10); Write('              Leia com AtenáÑo               ');
  Color(Red,Cyan);
  GotoXY(4,11); Write('              ----------------               ');
  GotoXY(4,12); Write(' Esta  opáÑo causa a correáÑo dos oráamentos ');
  GotoXY(4,13); Write(' de despesas, de acordo com o °ndice estabe- ');
  GotoXY(4,14); Write(' lecido para correáÑo. Esta correáÑo Ç feita ');
  GotoXY(4,15); Write(' baseado na variaáÑo mensal do °ndice, que Ç ');
  GotoXY(4,16); Write(' obtida por comparaáÑo com o màs anterior. O ');
  GotoXY(4,17); Write(' resultado Ç substitu°do pelo oráado.        ');
  GotoXY(4,18); Write('                                             ');
  GotoXY(4,19); Write('                     Veja Manual do Usu†rio. ');
  Color(Tfn,Utx);
  Confirma;
  If TC = 'S' then
     begin
       Str(CMstMember.AnoAtivo,XAno);
       ExpeNo := '';
       Repeat
         RC := 'N';
         SearchPos5 ( Root5 );
         If RC = 'S' then
            With ExpeMember do
            begin
              ReadWrite(#07,'R','N',ExpeNumber);
              If (RW         = 'S') and
                 (Corrigivel = 'S') then
                 With EcoMember do
                 begin
                   IINo := XAno + '#' + IndiceX;
                   SearchTree7 ( Root7 );
                   If RC = 'S' then
                      begin
                        ReadWrite(#12,'R','N',IINumber);
                        If RW = 'S' then
                           begin
                             If Tipo <> 'P' then
                                begin
                                  If MM = 1 then
                                     begin
                                       If Valores[12] > 0
                                          then Fator := Valores[MM] / Valores[12]
                                          else Fator := 1;
                                     end
                                     else If Valores[MM - 1] > 0
                                             then Fator := Valores[MM] / Valores[MM - 1]
                                             else Fator := 1;
                                end
                                else Fator := 1 + (Valores[MM] / 100);
                           end;
                      end
                      else RC := 'S';
                   For I := MM to 12 do ValorO[I] := ValorO[I] * Fator;
                   ReadWrite(#07,'W','N',ExpeNumber);
                 end;
            end;
       Until RC = 'N';
       Color(Blue,Cyan);
       GotoXY(1,23); Write(' ':80);
       GotoXY(2,23); Write('Os Oráamentos de despesa estÑo corrigidos !');
       TeclaReturn;
     end;
end;


Procedure ImportaConta;
begin
  Color(Red,Cyan);
  GotoXY(01,23); Write(ConstStr(' ',80));
  GotoXY(02,23);
  Write('Quer importar o Plano de Contas de outra Empresa?         Sim ou NÑo');
  Color(Red,Yellow);
  GotoXY(60,23); Write('S');
  GotoXY(67,23); Write('N');
  Repeat
    TC := UpCase(ReadKey);
  Until (TC = 'S') or (TC = 'N');
  If TC = 'S' then
     begin
       CmpyNo := '';
       CmpyAC := '';
       Reset ( CmpyFile );
       ScrollCia('N');
       Close ( CmpyFile );
       If CmpyAC <> '' then
          begin
            Close ( DeptFile  );
            Close ( LoteFile  );
            Color(Blue,Yellow);
            GotoXY(01,24); Write(ConstStr(' ',80));
            GotoXY(72,24); Write('Aguarde');
            Color(Blue,Cyan);
            Assign ( WorkFile1, (XDrive + '\ALOGM' + CmpyAC + '\' + FileConta + '.DAT' ));
            {$I-}
            Reset ( WorkFile1 );
            {$I+}
            If IOResult = 0 then
               begin
                 I                  := -1;
                 R                  := 0;
                 D                  := 0;
                 CMstMember.NContas := 0;
                 GotoXY(02,24); Write('Lendo:       .....Gravando:');
                 For K := 1 to 12 do
                 begin
                   SaldMember.Abertura[K] := 0;
                   SaldMember.Debitos[K]  := 0;
                   SaldMember.Creditos[K] := 0;
                   SaldMember.Saldo[K]    := 0;
                   SaldMember.SaldoB[K]   := 0;
                   SaldMember.NLanctos[K] := 0;
                 end;
                 SaldMember.Status := 'A';
                 Repeat
                   I := I + 1;
                   Seek ( WorkFile1, I           );
                   Read ( WorkFile1, ContaMember );
                   Color(Blue,White);
                   GotoXY(9,24); Write((I + 1):4);
                   ContaNo := ContaMember.Conta;
                   SearchTree1 ( Root1 );
                   If RC = 'N' then
                      begin
                        R           := FileSize(ContaFile);
                        ContaNumber := R;
                        LoadTree1 ( Root1 );
                        ReadWrite(#03,'W','N',R);
                        ReadWrite(#06,'W','N',R);
                        CMstMember.NContas := CMstMember.NContas + 1;
                        Color(Blue,White);
                        GotoXY(30,24); Write((R + 1):4);
                        ShowHeap;
                        Color(Tfn,Ttx);
                      end;
                 Until (I + 1) = FileSize(WorkFile1);
                 Close ( WorkFile1 );
                 Close ( SaldFile  );
                 Reset ( SaldFile  );
                 Close ( ContaFile );
                 Reset ( ContaFile );
                 ReadWrite(#16,'W','N',0);
               end;
            Reset ( DeptFile  );
            Reset ( LoteFile  );
            DI := 'S';
          end;
     end;
  CmpyNo := XCia;
  CmpyAC := '';
  SearchTree0 ( Root0 );
  LimpaLn(23,Tfd);
  LimpaLn(24,Tfd);
end;


Procedure Totaliza;
begin
  TotA    := 0;
  TotP    := 0;
  TotR    := 0;
  TotD    := 0;
  ContaNo := '';
  Repeat
    RC := 'N';
    SearchPos1 ( Root1 );
    If RC = 'S' then
       begin
         ReadWrite(#03,'R','N',ContaNumber);
         If RW = 'S' then
            begin
              If (ContaMember.Grau   = '1'              ) and
                 (ContaMember.Grupo in ['A','D','P','R']) then
                 begin
                   ReadWrite(#06,'R','N',ContaNumber);
                   Case ContaMember.Grupo of
                        'A' : TotA := TotA + TruncX(SaldMember.SaldoB[MM]);
                        'D' : TotD := TotD + TruncX(SaldMember.SaldoB[MM]);
                        'P' : TotP := TotP + TruncX(SaldMember.SaldoB[MM]);
                        'R' : TotR := TotR + TruncX(SaldMember.SaldoB[MM]);
                   end;
                 end;
            end;
       end;
  Until RC = 'N';
  Color(Bfn,Btx);
  GotoXY(03,10); Write('        1¶ VerificaáÑo       ');
  Color(Tfn,Ttx);
  GotoXY(03,12); Write(' Ativo                       ');
  GotoXY(03,13); Write(' Pass.                       ');
  GotoXY(03,14); Write('       --------------------  ');
  GotoXY(03,15); Write(' Total                       ');
  GotoXY(03,17); Write(' Rec..                       ');
  GotoXY(03,18); Write(' Desp.                       ');
  GotoXY(03,19); Write('       --------------------  ');
  GotoXY(03,20); Write(' Total                       ');
  Color(Bfn,Btx);
  GotoXY(31,10); Write('       2¶ VerificaáÑo       ');
  Color(Tfn,Ttx);
  GotoXY(31,12); Write(' Ativo                      ');
  GotoXY(31,13); Write(' Desp.                      ');
  GotoXY(31,14); Write('       -------------------- ');
  GotoXY(31,15); Write(' Total                      ');
  GotoXY(31,17); Write(' Pass.                      ');
  GotoXY(31,18); Write(' Rec..                      ');
  GotoXY(31,19); Write('       -------------------- ');
  GotoXY(31,20); Write(' Total                      ');
  Color(Tfn,Utx);
  GotoXY(10,12); Write(EditDouble(TotA):20);
  GotoXY(10,13); Write(EditDouble(TotP):20);
  Color(Tfn,Ttx);
  GotoXY(10,15);
  If (TotA + TotP) < 0
     then Write('<',EditDouble(TruncX(TotA + TotP)):19,'>')
     else Write(EditDouble(TotA + TotP):20);
  Color(Tfn,Utx);
  GotoXY(10,17); Write(EditDouble(TotR):20);
  GotoXY(10,18); Write(EditDouble(TotD):20);
  GotoXY(10,20);
  Color(Tfn,Ttx);
  If (TotR + TotD) < 0
     then Write('<',EditDouble(TruncX(TotR + TotD)):19,'>')
     else Write(EditDouble(TotR + TotD):20);
  Color(Tfn,Utx);
  GotoXY(38,12); Write(EditDouble(TotA):20);
  GotoXY(38,13); Write(EditDouble(TotD):20);
  Color(Tfn,Ttx);
  GotoXY(38,15); Write(EditDouble(TruncX(TotA + TotD)):20);
  Color(Tfn,Utx);
  GotoXY(38,17); Write(EditDouble(TotP):20);
  GotoXY(38,18); Write(EditDouble(TotR):20);
  Color(Tfn,Ttx);
  GotoXY(38,20); Write(EditDouble(TruncX(TotP + TotR)):20);
  TeclaReturn;
end;

end.

