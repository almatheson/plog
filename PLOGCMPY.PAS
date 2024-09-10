{$O+,F+}
Unit PlogCmpy;

Interface

Uses Crt,Dos,PlogGlbs,PlogBasP,PlogTree,PlogGera,PlogDoct;

   Procedure FootScroll;
   Procedure ScrollDir;
   Procedure ScrollFim;
   Procedure TitleCia;
   Procedure TitleCiaX;
   Procedure DataCia(X : Char);
   Procedure DataCiaX;
   Procedure ScrollCia(X : Char);
   Procedure UpdateCia;
   Procedure EntryCodCia;
   Procedure ListaEmpresas;

Implementation

Var
   RArray         : Array[1..7] of Integer;
   KArray         : Array[1..7] of Str11;
   NArray         : Array[1..7] of Str40;
   SArray         : Array[1..7] of Str9;


Procedure FootScroll;
begin
  Color(Blue,White);
  GotoXY(01,23); Write(ConstStr(' ',80));
  GotoXY(04,23); Write(#25);
  GotoXY(06,23); Write('PgDn');
  GotoXY(25,23); Write(#24);
  GotoXY(27,23); Write('PgUp');
  GotoXY(47,23); Write('Esc');
  GotoXY(61,23); Write('Enter');
  Color(Blue,Cyan);
  GotoXY(05,23); Write('/');
  GotoXY(11,23); Write(#26,' Pr¢xima');
  GotoXY(26,23); Write('/');
  GotoXY(32,23); Write(#26,' Anterior');
  GotoXY(51,23); Write(#26,' Fim');
  GotoXY(67,23); Write(#26,' Seleciona');
  LimpaLn(24,Red);
end;


Procedure ScrollDir;
begin
  Cont := ReadKey;
  Case Cont of
       #72 : begin
               Tkb     := 'L';
               Direcao := 'A';
               Color(Blue,White);
               GotoXY(04,23); Write(#25);
               GotoXY(06,23); Write('PgDn');
               GotoXY(27,23); Write('PgUp');
               Color(Blue,(White + Blink));
               GotoXY(25,23); Write(#24);
             end;
       #73 : begin
               Tkb     := 'P';
               Direcao := 'A';
               Color(Blue,White);
               GotoXY(04,23); Write(#25);
               GotoXY(06,23); Write('PgDn');
               GotoXY(25,23); Write(#24);
               Color(Blue,(White + Blink));
               GotoXY(27,23); Write('PgUp');
             end;
       #80 : begin
               Tkb     := 'L';
               Direcao := 'P';
               Color(Blue,(White + Blink));
               GotoXY(04,23); Write(#25);
               Color(Blue,White);
               GotoXY(06,23); Write('PgDn');
               GotoXY(25,23); Write(#24);
               GotoXY(27,23); Write('PgUp');
             end;
       #81 : begin
               Tkb     := 'P';
               Direcao := 'P';
               Color(Blue,(White + Blink));
               GotoXY(06,23); Write('PgDn');
               Color(Blue,White);
               GotoXY(04,23); Write(#25);
               GotoXY(25,23); Write(#24);
               GotoXY(27,23); Write('PgUp');
             end;
       else Direcao := ' ';
  end;
  LimpaLn(24,Red);
  Color(Sfn,Stx);
  N := 7;
end;


Procedure ScrollFim;
begin
  Color(Red,White);
  GotoXY(1,24);  Write(ConstStr(' ',80));
  GotoXY(2,24);  Write('Chegou ao final.');
  Color(Sfn,Stx);
end;


Procedure TitleCia;
begin
  Color(Tfn,Ttx);
  GotoXY(04,08); Write('C¢digo:');
  GotoXY(04,09); Write('R-Socl:');
  GotoXY(04,10); Write('Ender.:');
  GotoXY(04,11); Write('N£mero:');
  GotoXY(30,11); Write('Compl.:');
  GotoXY(04,12); Write('Bairro:');
  GotoXY(04,13); Write('Munic.:');
  GotoXY(04,14); Write('Cidade:');
  GotoXY(04,15); Write('Estado:');
  GotoXY(17,15); Write('Cep:');
  GotoXY(04,16); Write('DDD...:');
  GotoXY(17,16); Write('Tel:');
  GotoXY(04,17); Write('Cgc...:');
  GotoXY(04,18); Write('Inscr.:');
  GotoXY(04,19); Write('N.S‚r.:');
  GotoXY(30,19); Write('MM/AA.:');
  GotoXY(04,20); Write('Moedas:');
  DrawBox(33,12,56,17,Sfn,'S');
  Color(Bfn,Btx);
  GotoXY(33,12); Write(' Processos Autom ticos  ');
  Color(Sfn,Stx);
  GotoXY(34,13); Write('Expediente..:');
  GotoXY(34,14); Write('Repouso.....:');
  GotoXY(34,15); Write('Cta.de Falta:');
  GotoXY(34,16); Write('Cta.de Atras:');
  GotoXY(34,17); Write('Cta.de Saida:');
  Color(Tfn,Utx);
end;


Procedure TitleCiaX;
begin
  Color(Tfn,Ttx);
  GotoXY(04,08); Write('C¢digo:');
  GotoXY(04,09); Write('R-Socl:');
  Color(Tfn,Utx);
end;


Procedure DataCia(X : Char);
begin
  ReadWrite(#16,'R','N',0);
  With CMstMember do
  begin
    Color(Tfn,Utx);
    GotoXY(12,08); Write(Chave);
    GotoXY(12,09); Write(Descricao);
    GotoXY(12,10); Write(Endereco);
    GotoXY(12,11); Write(Numero);
    GotoXY(38,11); Write(Complemento);
    GotoXY(12,12); Write(Bairro);
    GotoXY(12,13); Write(Municipio);
    GotoXY(12,14); Write(Cidade);
    GotoXY(12,15); Write(Estado);
    GotoXY(22,15); Write(Cep);
    GotoXY(12,16); Write(DDD);
    GotoXY(22,16); Write(Telefone);
    GotoXY(12,17); Write(Cgc);
    GotoXY(12,18); Write(Inscricao);
    GotoXY(38,19); Write(MesAtivo);
    GotoXY(40,19); Write('/');
    GotoXY(41,19); Write(AnoAtivo);
    Color(Tfn,Ttx);
    GotoXY(45,19); Case X of
                        'S' : Write(' na implanta‡Æo');
                        'N' : Write(' Processando   ');
                   end;
    Color(Tfn,Utx);
    GotoXY(12,20); Write(PushRight(6,EditReal(Moedas[1])),' ',
                         PushRight(6,EditReal(Moedas[2])),' ',
                         PushRight(6,EditReal(Moedas[3])),' ',
                         PushRight(6,EditReal(Moedas[4])),' ',
                         PushRight(6,EditReal(Moedas[5])));
    GotoXY(12,21); Write(PushRight(6,EditReal(Moedas[6])),' ',
                         PushRight(6,EditReal(Moedas[7])),' ',
                         PushRight(6,EditReal(Moedas[8])),' ',
                         PushRight(6,EditReal(Moedas[9])),' ',
                         PushRight(6,EditReal(Moedas[10])));
    Color(Sfn,Stx);
    GotoXY(48,13); Write(FaltaH:2,':',QQStr(FaltaM,2,'0'));
    GotoXY(48,14); Write(RepousoH:2,':',QQStr(RepousoM,2,'0'));
    GotoXY(48,15); Write(ContaF:3);
    GotoXY(48,16); Write(ContaA:3);
    GotoXY(48,17); Write(ContaS:3);
    Color(Tfn,Utx);
  end;
end;


Procedure DataCiaX;
begin
  ReadWrite(#02,'R','N',CmpyNumber);
  HelpM;
  Color(Tfn,Utx);
  GotoXY(12,08);  Write(CmpyMember.Chave);
  GotoXY(12,09);  Write(PushLeft(41,CmpyMember.Descricao),'[',CmpyMember.Status,']');
end;


Procedure MoveParaArray(L : Integer);
begin
  KArray[L] := CmpyMember.Chave;
  RArray[L] := CmpyNumber;
  NArray[L] := CmpyMember.Descricao;
  SArray[L] := CmpyMember.Status;
end;


Procedure ArrayParaArray(D,P : Integer);
begin
  KArray[P] := KArray[D];
  RArray[P] := RArray[D];
  NArray[P] := NArray[D];
  SArray[P] := SArray[D];
end;


Procedure ScrollCia(X : Char);
Var
   ScArrayS       : Array [1..4000] of Char;
begin
  Move(Mem[$B800:0000],ScArrayS[1],4000);
  Color(Tfd,White);
  If X <> 'S' then For I := 20 to 23 do begin
                                          GotoXY(66,I); Write(ConstStr('Ä',14));
                                        end;
  FootScroll;
  DrawBox(3,10,53,19,Sfn,'S');
  Color(Bfn,Btx);
  GotoXY(03,10);
  Write(' C¢d    Nome                                     ',#25,' ');
  Color(Sfn,Stx);
  Tkb     := 'L';
  F       := 'N';
  Direcao := 'P';
  L       := 0;
  Sx      := 1;
  For I := 1 to 7 do begin
                       KArray[I] := '';
                       RArray[I] := 0;
                       NArray[I] := '';
                       SArray[I] := ' ';
                     end;
  RC := 'N';
  SearchAnt0 ( Root0 );
  If RC = 'N' then CmpyNo := '';
  Repeat
    RC := 'N';
    SearchPos0 ( Root0 );
    If RC = 'S' then
       begin
         ReadWrite(#02,'R','N',CmpyNumber);
         If RW = 'S' then
            begin
              If (CmpyMember.Status <> 'X' ) or
                 ((CmpyMember.Status = 'X')  and
                  (X                 = 'S')) then
                 begin
                   L := L + 1;
                   MoveParaArray(L);
                 end;
            end;
       end
       else L := 7;
  Until L = 7;
  Repeat
    Window(03,12,54,19);
    For I := 1 to 7 do If KArray[I] <> '' then
                          begin
                            If I = Sx then Color(Tfn,Utx)
                                      else Color(Sfn,Stx);
                            GotoXY(1,I);
                            Writeln(' ',PushLeft(7,KArray[I]),
                                        PushLeft(41,NArray[I]),
                                        SArray[I],' ');
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
                                RC     := 'N';
                                CmpyNo := KArray[1];
                                SearchAnt0 ( Root0 );
                                If RC = 'S' then
                                   begin
                                     ReadWrite(#02,'R','N',CmpyNumber);
                                     If RW = 'S' then
                                        begin
                                          If (CmpyMember.Status <> 'X' ) or
                                             ((CmpyMember.Status = 'X')  and
                                              (X                 = 'S')) then
                                             begin
                                               For I := 7 downto 2
                                               do ArrayParaArray((I - 1),I);
                                               MoveParaArray(1);
                                               F := 'N';
                                               N := N + 1;
                                             end;
                                        end;
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
                                CmpyNo := KArray[R];
                                RC     := 'N';
                                SearchPos0 ( Root0 );
                                If RC = 'S' then
                                   begin
                                     ReadWrite(#02,'R','N',CmpyNumber);
                                     If RW = 'S' then
                                        begin
                                          If (CmpyMember.Status <> 'X' ) or
                                             ((CmpyMember.Status = 'X')  and
                                              (X                 = 'S')) then
                                             begin
                                               For I := 2 to 7
                                               do ArrayParaArray(I,(I - 1));
                                               MoveParaArray(R);
                                               N := N + 1;
                                               F := 'N';
                                             end;
                                        end;
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
  Move(ScArrayS[1],MemW[$B800:0000],4000);
  Color(Tfn,Utx);
  If Cont = #13 then
     begin
       CmpyAN := RArray[Sx];
       CmpyAC := KArray[Sx];
     end;
end;


Procedure EntryCiaNova;
begin
  With CmpyMember do
  begin
    I := 0;
    Repeat
      K := 1;
      Repeat
        Case K of
             1   : begin
                     If FileSize(CmpyFile) = 0 then J := OwnerMember.RSocial
                                               else J := Descricao;
                     InputStr(J,40,12,09,0,'S','S','T','N',Tfn,Utx);
                     Descricao := J;
                     If (Descricao = '') and (TC <> #27) then
                        begin
                          Descricao := OwnerMember.RSocial;
                          K := K - 1;
                        end;
                   end;
             2   : If Descricao = OwnerMember.RSocial then
                      begin
                        Color(Blue,Cyan);
                        GotoXY(1,23); Write(' ':80);
                        GotoXY(2,23); Write('Chave de autoriza‡Æo para inclusÆo:');
                        If I = 0 then J := ''
                                 else begin
                                        Str(I:5,J);
                                        J := LeftAdjust(J);
                                      end;
                        InputStr(J,5,38,23,0,'S','N','T','N',Blue,White);
                        Val(J,I,E);
                        LimpaLn(23,Tfd);
                        CalculoBase(XSystem,Descricao);
                        If NBaseC <> (30000 - I) then TC := #27;
                      end;
        end;
        Case TC of
             #13 : K := K + 1;
             #24 : If K > 1 then K := K - 1;
        end;
      Until (K = 3) or (TC = #27);
      If TC <> #27 then Confirma;
    Until TC in ['S',#27];
  end;
end;


Procedure EntryPass;
begin
  Color(Tfn,Ttx);
  GotoXY(04,19); Write('Psword:');
  Repeat
    J := CMstMember.Password;
    InputStr(J,8,12,19,0,'S','S','T','N',Tfn,Utx);
    CMstMember.Password := J;
    If (CMstMember.Password = '') and (TC <> #27) then
       begin
         ErroMsg := 'Informe a Password';
         ErrorMessage;
       end;
  Until (TC = #27) or (CMstMember.Password <> '');
  Color(Tfn,Ttx);
  GotoXY(04,19); Write('N.S‚r.:         ');
  TC := #13;
end;


Procedure EntryCia;
begin
  With CMstMember do
  begin
    Repeat
      K := 1;
      Repeat
        Case K of
             1   : begin
                     J := Endereco;
                     InputStr(J,40,12,10,0,'S','S','T','N',Tfn,Utx);
                     Endereco := J;
                     If (Endereco = '') and (TC <> #27) then
                        begin
                          ErroMsg := 'Informe o Endere‡o';
                          ErrorMessage;
                          K := K - 1;
                        end;
                   end;
             2   : begin
                     J := Numero;
                     InputStr(J,10,12,11,0,'S','S','T','N',Tfn,Utx);
                     Numero := J;
                     If (Numero = '') and (TC <> #27) then
                        begin
                          ErroMsg := 'Informe o N£mero';
                          ErrorMessage;
                          K := K - 1;
                        end;
                   end;
             3   : begin
                     J := Complemento;
                     InputStr(J,15,38,11,0,'S','S','T','N',Tfn,Utx);
                     Complemento := J;
                   end;
             4   : begin
                     J := Bairro;
                     InputStr(J,20,12,12,0,'S','S','T','N',Tfn,Utx);
                     Bairro := J;
                     If (Bairro = '') and (TC <> #27) then
                        begin
                          ErroMsg := 'Informe o Bairro';
                          ErrorMessage;
                          K := K - 1;
                        end;
                   end;
             5   : begin
                     J := Municipio;
                     InputStr(J,20,12,13,0,'S','S','T','N',Tfn,Utx);
                     Municipio := J;
                     If (Municipio = '') and (TC <> #27) then
                        begin
                          ErroMsg := 'Informe o Munic¡pio';
                          ErrorMessage;
                          K := K - 1;
                        end;
                   end;
             6   : begin
                     J := Cidade;
                     InputStr(J,20,12,14,0,'S','S','T','N',Tfn,Utx);
                     Cidade := J;
                     If (Cidade = '') and (TC <> #27) then
                        begin
                          ErroMsg := 'Informe a Cidade';
                          ErrorMessage;
                          K := K - 1;
                        end;
                   end;
             7   : begin
                     J := Estado;
                     InputStr(J,2,12,15,0,'S','N','T','N',Tfn,Utx);
                     Estado := UpCaseStr(J);
                     GotoXY(12,15); Write(Estado);
                     CheckUF(Estado);
                     If (R = 1) and (TC <> #27) then
                        begin
                          ErroMsg := 'Sigla do Estado Inv lida';
                          ErrorMessage;
                          K := K - 1;
                        end;
                   end;
             8   : begin
                     J := Cep;
                     InputStr(J,9,22,15,0,'S','N','T','N',Tfn,Utx);
                     Cep := J;
                   end;
             9   : begin
                     J := DDD;
                     InputStr(J,4,12,16,0,'S','N','T','N',Tfn,Utx);
                     DDD := J;
                   end;
             10  : begin
                     J := Telefone;
                     InputStr(J,8,22,16,0,'S','N','T','N',Tfn,Utx);
                     Telefone := J;
                   end;
             11  : begin
                     J := Cgc;
                     InputStr(J,16,12,17,0,'S','N','T','N',Tfn,Utx);
                     Cgc := J;
                     If (Cgc = '') and (TC <> #27) then
                        begin
                          ErroMsg := 'Informe o CGC';
                          ErrorMessage;
                          K := K - 1;
                        end;
                   end;
             12  : begin
                     J := Inscricao;
                     InputStr(J,13,12,18,0,'S','N','T','N',Tfn,Utx);
                     Inscricao := J;
                   end;
             13  : begin
                     J := '';
                     InputStr(J,8,12,19,0,'N','S','T','N',Tfn,Utx);
                     If UpCaseStr(J) = OwnerMember.NoSerie then EntryPass;
                   end;
             14  : begin
                     If MesAtivo = 0 then J := ''
                                     else begin
                                            Str(MesAtivo:2,J);
                                            J := LeftAdjust(J);
                                          end;
                     InputStr(J,2,38,19,0,'S','N','T','N',Tfn,Utx);
                     Val(J,MesAtivo,E);
                     If (MesAtivo < 1) or (MesAtivo > 12) then
                        begin
                          ErroMsg := 'Mˆs Inv lido';
                          ErrorMessage;
                          K := K - 1;
                        end;
                   end;
             15  : begin
                     If AnoAtivo = 0 then J := ''
                                     else begin
                                            Str(AnoAtivo:4,J);
                                            J := LeftAdjust(J);
                                          end;
                     Color(Tfn,Utx);
                     GotoXY(40,19); Write('/');
                     InputStr(J,4,41,19,0,'S','N','T','N',Tfn,Utx);
                     Val(J,AnoAtivo,E);
                     If AnoAtivo = 0 then
                        begin
                          ErroMsg := 'Ano Inv lido';
                          ErrorMessage;
                          K := K - 1;
                        end;
                   end;
             16..20  : begin
                         If Moedas[K-15] = 0 then J := ''
                                             else begin
                                                    Str(Moedas[K-15]:6:2,J);
                                                    J := LeftAdjust(J);
                                                  end;
                         Case K of
                              16 : InputStr(J,6,12,20,0,'S','N','$','N',Tfn,Utx);
                              17 : InputStr(J,6,19,20,0,'S','N','$','N',Tfn,Utx);
                              18 : InputStr(J,6,26,20,0,'S','N','$','N',Tfn,Utx);
                              19 : InputStr(J,6,33,20,0,'S','N','$','N',Tfn,Utx);
                              20 : InputStr(J,6,40,20,0,'S','N','$','N',Tfn,Utx);
                         end;
                         Val(J,Moedas[K-15],E);
                   end;
             20..25  : begin
                         If Moedas[K-15] = 0 then J := ''
                                             else begin
                                                    Str(Moedas[K-15]:6:2,J);
                                                    J := LeftAdjust(J);
                                                  end;
                         Case K of
                              21 : InputStr(J,6,12,21,0,'S','N','$','N',Tfn,Utx);
                              22 : InputStr(J,6,19,21,0,'S','N','$','N',Tfn,Utx);
                              23 : InputStr(J,6,26,21,0,'S','N','$','N',Tfn,Utx);
                              24 : InputStr(J,6,33,21,0,'S','N','$','N',Tfn,Utx);
                              25 : InputStr(J,6,40,21,0,'S','N','$','N',Tfn,Utx);
                         end;
                         Val(J,Moedas[K-15],E);
                   end;
             26  : begin
                     If FaltaH = 0 then J := ''
                                   else begin
                                          Str(FaltaH:2,J);
                                          J := LeftAdjust(J);
                                        end;
                     InputStr(J,2,48,13,0,'S','N','T','N',Sfn,Stx);
                     Val(J,FaltaH,E);
                     GotoXY(48,13); Write(FaltaH:2,':');
                   end;
             27  : begin
                     If FaltaM = 0 then J := ''
                                   else begin
                                          Str(FaltaM:2,J);
                                          J := LeftAdjust(J);
                                        end;
                     InputStr(J,2,51,13,0,'S','N','T','N',Sfn,Stx);
                     Val(J,FaltaM,E);
                     GotoXY(51,13); Write(QQStr(FaltaM,2,'0'));
                   end;
             28  : begin
                     If RepousoH = 0 then J := ''
                                     else begin
                                            Str(RepousoH:2,J);
                                            J := LeftAdjust(J);
                                          end;
                     InputStr(J,2,48,14,0,'S','N','T','N',Sfn,Stx);
                     Val(J,RepousoH,E);
                     GotoXY(48,14); Write(RepousoH:2,':');
                   end;
             29  : begin
                     If RepousoM = 0 then J := ''
                                     else begin
                                            Str(RepousoM:2,J);
                                            J := LeftAdjust(J);
                                          end;
                     InputStr(J,2,51,14,0,'S','N','T','N',Sfn,Stx);
                     Val(J,RepousoM,E);
                     GotoXY(51,14); Write(QQStr(RepousoM,2,'0'));
                   end;
             30  : begin
                     J := ContaF;
                     InputStr(J,3,48,15,0,'S','N','T','N',Sfn,Stx);
                     ContaF := J;
                   end;
             31  : begin
                     J := ContaA;
                     InputStr(J,3,48,16,0,'S','N','T','N',Sfn,Stx);
                     ContaA := J;
                   end;
             32  : begin
                     J := ContaS;
                     InputStr(J,3,48,17,0,'S','N','T','N',Sfn,Stx);
                     ContaS := J;
                     Op := 'A';
                   end;
        end;
        Case TC of
             #13 : K := K + 1;
             #24 : If K > 1 then K := K - 1
                            else K := 32;
        end;
      Until (K = 33) or (TC = #27);
      If Op = 'A' then Confirma;
    Until TC in ['S',#27]
  end;
end;

Procedure TitleCompl;
begin
  Color(Tfn,Ttx);
  GotoXY(04,10); Write('Cod.Mu:');
  GotoXY(04,11); Write('CNAE..:');
  GotoXY(04,12); Write('Propr.:');
  GotoXY(04,13); Write('D.Base:');
  GotoXY(04,14); Write('Natur.:');
  GotoXY(04,15); Write('Tp/Ide:');
  GotoXY(04,16); Write('FPAS..:');
  GotoXY(04,17); Write('SAT./%:');
  GotoXY(04,18); Write('TER./%:');
  GotoXY(04,19); Write('Cod.19:');
  GotoXY(04,20); Write('Cod.20:');

  GotoXY(30,10); Write('Estab.:');
  GotoXY(30,11); Write('In¡cio:');
  GotoXY(30,12); Write('Ativid:');
  GotoXY(30,13); Write('C¢d/Sb:');
  GotoXY(30,14); Write('CBO/Tp:');
  GotoXY(30,15); Write('N§/Ref:');
  GotoXY(30,16); Write('Conta.:');
  GotoXY(30,17); Write('Unid.T:');
  GotoXY(30,18); Write('Recolh:');
  GotoXY(30,19); Write('Simple:');
  GotoXY(30,20); Write('Centra:');
end;

Procedure DataCompl;
begin
  Color(Tfn,Utx);
  GotoXY(12,10); Write(PushLeft(10,CMStMember.Cod_Municipio));
  GotoXY(12,11); Write(PushLeft(6,CMStMember.CNAE));
  GotoXY(12,12); Write(CMStMember.Proprietarios:2);
  GotoXY(12,13); Write(CMStMember.DataBase:2);
  GotoXY(12,14); Write(CMStMember.Natureza);
  GotoXY(12,15); Write(CMstMember.Tipo);
  GotoXY(14,15); Write(PushLeft(14,CMstMember.CGC_CEI));
  GotoXY(12,16); Write(PushLeft(6,CMstMember.Cod_FPAS));
  GotoXY(12,17); Write(PushLeft(11,CMstMember.Cod_SAT));
  GotoXY(18,17); Write(CMstMember.Alq_SAT:5:2);
  GotoXY(12,18); Write(PushLeft(6,CMstMember.Terceiros));
  GotoXY(18,18); Write(CMstMember.Alq_Terceiros:5:2);
  GotoXY(12,19); Write(PushLeft(6,CMstMember.Cod_19));
  GotoXY(12,20); Write(PushLeft(6,CMstMember.Cod_20));

  GotoXY(38,10); Write(PushLeft(21,CMstMember.Cod_Estab));
  GotoXY(38,11); Write(CMstMember.Inicio);
  GotoXY(38,12); Write(PushLeft(21,CMstMember.Atividade));
  GotoXY(38,13); Write(PushLeft(6,CMstMember.Codigo));
  GotoXY(44,13); Write(PushLeft(11,CMstMember.Sub_Codigo));
  GotoXY(38,14); Write(PushLeft(6,CMstMember.CBO));
  GotoXY(44,14); Write(CMstMember.CBO_Tipo);
  GotoXY(38,15); Write(CMstMember.Numero_Estab:3);
  GotoXY(42,15); Write(CMstMember.Referencia);
  GotoXY(38,16); Write(Pushleft(21,CMstMember.Conta));
  GotoXY(38,17); Write(PushLeft(11,CMstMember.Unid_Trab));
  GotoXY(38,18); Write(CMstMember.Recolhimento);
  GotoXY(38,19); Write(CMstMember.Simples);
  GotoXY(38,20); Write(CMstMember.Centralizado);
end;

Procedure TitleOutros;
begin
  Color(Tfn,Ttx);
  GotoXY(04,10); Write('Capit.:');
  GotoXY(04,11); Write('Caixa.:');
  GotoXY(04,12); Write('Resp..:');
  GotoXY(04,13); Write('EMail.:');
  GotoXY(04,14); Write('Ender.:');
end;

Procedure DataOutros;
begin
  Color(Tfn,Utx);
  GotoXY(12,10); Write(EditReal(CMstMember.Capital):15);
  GotoXY(12,11); Write(CMstMember.Cod_Caixa);
  GotoXY(12,12); Write(CMstMember.Nome);
  GotoXY(12,13); Write(CMstMember.EMail);
  GotoXY(12,14); Write(CMstMember.Que_Endereco);
end;

Procedure EntryCompl;
begin
  With CMstMember do
  begin
    Repeat
      K := 0;
      Repeat
        Case K of
             0   : begin
                     J := Cod_Municipio;
                     InputStr(J,7,12,10,0,'S','N','T','N',Tfn,Utx);
                     Cod_Municipio := J;
                   end;
             1   : begin
                     J := CNAE;
                     InputStr(J,5,12,11,0,'S','N','T','N',Tfn,Utx);
                     CNAE := J;
                   end;
             2   : begin
                     If Proprietarios = 0 then J := ''
                                          else begin
                                                 Str(Proprietarios:2,J);
                                                 J := LeftAdjust(J);
                                               end;
                     InputStr(J,2,12,12,0,'S','N','T','N',Tfn,Utx);
                     Val(J,Proprietarios,E);
                     GotoXY(12,12); Write(Proprietarios:2);
                   end;
             3   : begin
                     If DataBase = 0 then J := ''
                                     else begin
                                            Str(DataBase:2,J);
                                            J := LeftAdjust(J);
                                          end;
                     InputStr(J,2,12,13,0,'S','N','T','N',Tfn,Utx);
                     Val(J,DataBase,E);
                     GotoXY(12,13); Write(DataBase:2);
                   end;
             4   : begin
                     J := Natureza;
                     InputStr(J,4,12,14,0,'S','N','T','N',Tfn,Utx);
                     Natureza := J;
                   end;
             5   : begin
                     J := Tipo;
                     InputStr(J,1,12,15,0,'S','N','T','N',Tfn,Utx);
                     Tipo := J[1];
                   end;
             6   : begin
                     J := CGC_CEI;
                     InputStr(J,14,14,15,0,'S','N','T','N',Tfn,Utx);
                     CGC_CEI := J;
                   end;
             7   : begin
                     J := Cod_FPAS;
                     InputStr(J,5,12,16,0,'S','N','T','N',Tfn,Utx);
                     Cod_FPAS := J;
                   end;
             8   : begin
                     J := Cod_SAT;
                     InputStr(J,5,12,17,0,'S','N','T','N',Tfn,Utx);
                     Cod_SAT := J;
                   end;
             9   : begin
                     If Alq_SAT = 0 then J := ''
                                    else begin
                                           Str(Alq_SAT:5:2,J);
                                           J := LeftAdjust(J);
                                         end;
                     InputStr(J,5,18,17,0,'S','N','T','N',Tfn,Utx);
                     Val(J,Alq_SAT,E);
                     GotoXY(18,17); Write(Alq_SAT:5:2);
                   end;
             10  : begin
                     J := Terceiros;
                     InputStr(J,5,12,18,0,'S','N','T','N',Tfn,Utx);
                     Terceiros := J;
                   end;
             11  : begin
                     If Alq_terceiros = 0 then J := ''
                                          else begin
                                                 Str(Alq_Terceiros:5:2,J);
                                                 J := LeftAdjust(J);
                                               end;
                     InputStr(J,5,18,18,0,'S','N','T','N',Tfn,Utx);
                     Val(J,Alq_Terceiros,E);
                     GotoXY(18,18); Write(Alq_Terceiros:5:2);
                   end;
             12  : begin
                     J := Cod_19;
                     InputStr(J,5,12,19,0,'S','N','T','N',Tfn,Utx);
                     Cod_19 := J;
                   end;
             13  : begin
                     J := Cod_20;
                     InputStr(J,5,12,20,0,'S','N','T','N',Tfn,Utx);
                     Cod_20 := J;
                   end;
             14  : begin
                     J := Cod_Estab;
                     InputStr(J,20,38,10,0,'S','N','T','N',Tfn,Utx);
                     Cod_Estab := J;
                   end;
             15  : begin
                     J := Inicio;
                     InputStr(J,8,38,11,0,'S','N','T','N',Tfn,Utx);
                     Inicio := J;
                   end;
             16  : begin
                     J := Atividade;
                     InputStr(J,20,38,12,0,'S','N','T','N',Tfn,Utx);
                     Atividade := J;
                   end;
             17  : begin
                     J := Codigo;
                     InputStr(J,5,38,13,0,'S','N','T','N',Tfn,Utx);
                     Codigo := J;
                   end;
             18  : begin
                     J := Sub_Codigo;
                     InputStr(J,10,44,13,0,'S','N','T','N',Tfn,Utx);
                     Sub_Codigo := J;
                   end;
             19  : begin
                     J := CBO;
                     InputStr(J,5,38,14,0,'S','N','T','N',Tfn,Utx);
                     CBO := J;
                   end;
             20  : begin
                     J := CBO_Tipo;
                     InputStr(J,1,44,14,0,'S','N','T','N',Tfn,Utx);
                     CBO_Tipo := J[1];
                   end;
             21  : begin
                     If Numero_Estab = 0 then J := ''
                                         else begin
                                                Str(Numero_Estab:3,J);
                                                J := LeftAdjust(J);
                                              end;
                     InputStr(J,3,38,15,0,'S','N','T','N',Tfn,Utx);
                     Val(J,Numero_Estab,E);
                     GotoXY(38,15); Write(Numero_Estab:3);
                   end;
             22  : begin
                     J := Referencia;
                     InputStr(J,1,44,15,0,'S','N','T','N',Tfn,Utx);
                     Referencia := J[1];
                   end;
             23  : begin
                     J := Conta;
                     InputStr(J,20,38,16,0,'S','N','T','N',Tfn,Utx);
                     Conta := J;
                   end;
             24  : begin
                     J := Unid_Trab;
                     InputStr(J,10,38,17,0,'S','N','T','N',Tfn,Utx);
                     Unid_Trab := J;
                   end;
             25  : begin
                     J := Recolhimento;
                     InputStr(J,3,38,18,0,'S','N','T','N',Tfn,Utx);
                     Recolhimento := J;
                   end;
             26  : begin
                     J := Simples;
                     InputStr(J,1,38,19,0,'S','N','T','N',Tfn,Utx);
                     Simples := J[1];
                   end;
             27  : begin
                     J := Centralizado;
                     InputStr(J,1,38,20,0,'S','N','T','N',Tfn,Utx);
                     Centralizado := J[1];
                   end;
        end;
        Case TC of
             #13 : K := K + 1;
             #24 : If K > 0 then K := K - 1
                            else K := 27;
        end;
      Until (K = 28) or (TC = #27);
      If TC <> #27 then Confirma;
    Until TC in ['S',#27];
  end;
end;


Procedure EntryOutros;
begin
  With CMstMember do
  begin
    Repeat
      K := 1;
      Repeat
        Case K of
             1   : begin
                     If Capital = 0 then J := ''
                                    else begin
                                           Str(Capital:14:2,J);
                                           J := LeftAdjust(J);
                                         end;
                     InputStr(J,15,12,10,0,'S','N','$','N',Tfn,Utx);
                     Val(J,Capital,E);
                   end;
             2   : begin
                     J := Cod_Caixa;
                     InputStr(J,14,12,11,0,'S','N','T','N',Tfn,Utx);
                     Cod_Caixa := J;
                   end;
             3   : begin
                     J := Nome;
                     InputStr(J,20,12,12,0,'S','N','T','N',Tfn,Utx);
                     Nome := J;
                   end;
             4   : begin
                     J := EMail;
                     InputStr(J,40,12,13,0,'S','N','T','N',Tfn,Utx);
                     EMail := J;
                   end;
             5   : begin
                     J := Que_Endereco;
                     InputStr(J,1,12,14,0,'S','N','T','N',Tfn,Utx);
                     Que_Endereco := J[1];
                   end;
        end;
        Case TC of
             #13 : K := K + 1;
             #24 : If K > 1 then K := K - 1
                            else K := 5;
        end;
      Until (K = 6) or (TC = #27);
      If TC <> #27 then Confirma;
    Until TC in ['S',#27];
  end;
end;


Procedure IncluiCia;
Var
  MM1,AA1   : Integer;
begin
  Op                    := 'I';
  CmpyMember.Chave      := CmpyNo;
  CmpyMember.Descricao  := '';
  CmpyMember.Status     := 'I';
  CmpyMember.DataBkp    := '';
  EntryCiaNova;
  If TC = 'S' then
     begin
       CMstMember.Chave           := CmpyMember.Chave;
       CMstMember.Descricao       := CmpyMember.Descricao;
       CMstMember.Endereco        := '';
       CMstMember.Numero          := '';
       CMstMember.Complemento     := '';
       CMstMember.Cidade          := '';
       CMstMember.Bairro          := '';
       CMstMember.Municipio       := '';
       CMstMember.Estado          := '';
       CMstMember.Cep             := '';
       CMstMember.DDD             := '';
       CMstMember.Telefone        := '';
       CMstMember.Cgc             := '';
       CMstMember.Inscricao       := '';
       CMstMember.Password        := '*';
       CMstMember.MesAtivo        := 0;
       CMstMember.AnoAtivo        := 0;
       CMstMember.Etapa           := 'X';
       CMstMember.NDepto          := 0;
       CMstMember.NBancos         := 0;
       CMstMember.NFunc           := 0;
       CMstMember.FaltaH          := 0;
       CMstMember.FaltaM          := 0;
       CMstMember.RepousoH        := 0;
       CMstMember.RepousoM        := 0;
       CMstMember.ContaF          := '';
       CMstMember.ContaA          := '';
       CMstMember.ContaS          := '';
       For I := 1 to 10 do CMstMember.Moedas[I] := 0;
       CMstMember.Cod_Municipio   := '';
       CMstMember.CNAE            := '';
       CMstMember.Proprietarios   := 0;
       CMstMember.Natureza        := '';
       CMstMember.DataBase        := 0;
       CMstMember.Tipo            := ' ';
       CMstMember.CGC_CEI         := '';
       CMstMember.Cod_SAT         := '';
       CMstMember.Alq_SAT         := 0;
       CMstMember.Cod_FPAS        := '';
       CMstMember.Terceiros       := '';
       CMstMember.Alq_terceiros   := 0;
       CMstMember.Cod_19          := '';
       CMstMember.Cod_20          := '';
       CMstMember.Unid_Trab       := '';
       CMstMember.Conta           := '';
       CMstMember.Cod_Estab       := '';
       CMstMember.Inicio          := '';
       CMstMember.Atividade       := '';
       CMstMember.Codigo          := '';
       CMstMember.Sub_Codigo      := '';
       CMstMember.CBO             := '';
       CMstMember.CBO_Tipo        := ' ';
       CMstMember.Numero_Estab    := 0;
       CMstMember.Referencia      := ' ';
       CMstMember.Capital         := 0;
       CMstMember.Nome            := '';
       CMstMember.EMail           := '';
       CMstMember.Que_Endereco    := 'N';
       CMstMember.Alt_CNAE        := 'N';
       CMstMember.Alt_End         := 'N';

       EntryCia;
       If TC = 'S' then
          begin
            XPath := XDrive + '\PLOGM' + CmpyNo;
            {$I-}
            MkDir ( XPath );
            {$I+}
            Assign( CMstFile, (XPath + '\' + FileCMst));
            {$I-}
            Reset ( CMstFile );
            {$I+}
            If IOResult <> 0 then
               begin
                 ReWrite ( CMstFile );
                 Reset   ( CMstFile );
               end;
            MM  := CMstMember.MesAtivo;
            AA  := CMstMember.AnoAtivo;
            ReadWrite(#02,'W','N',CmpyNumber);
            LoadTree0 ( Root0 );
            ReadWrite(#16,'W','N',0);
            MasterMember.NEmpresas := MasterMember.NEmpresas + 1;
            ReadWrite(#00,'W','N',0);
            Close ( CMstFile );
            If OwnerMember.NoSerie = '*Condic*' then
               begin
                 MM1 := MM + 1;
                 AA1 := AA;
                 If MM = 12 then
                    begin
                      MM1 := 1;
                      AA1 := AA + 1;
                    end;
                 OwnerMember.NoSerie := QQStr(MM,2,'0')  + QQStr(AA,2,'0') +
                                        QQStr(MM1,2,'0') + QQStr(AA1,2,'0');
                 ReadWrite(#01,'W','N',0);
               end;
          end;
       end;
end;

Procedure MoveParaArrayB(L : Integer);
begin
  KArray[L] := BlkStaMember.Cia + '#' + BlkStaMember.MesAno;
  RArray[L] := BlkNumber;
  NArray[L] := BlkStaMember.MesAno;
  Case BlkStaMember.BlkStatus of
       'B' : SArray[L] := 'Bloqueado';
       'L' : SArray[L] := 'Liberado';
  end;
end;

Procedure ScrollBlk;
Var
   ScArrayB       : Array [1..4000] of Char;
begin
  Move(Mem[$B800:0000],ScArrayB[1],4000);
  Color(Tfd,White);
  FootScroll;
  DrawBox(38,10,56,19,Sfn,'S');
  Color(Bfn,Btx);
  GotoXY(38,10); Write(' AAAA/MM Status    ');
  Color(Sfn,Stx);
  Tkb     := 'L';
  F       := 'N';
  Direcao := 'P';
  L       := 0;
  Sx      := 1;
  For I := 1 to 7 do begin
                       KArray[I] := '';
                       RArray[I] := 0;
                       NArray[I] := '';
                       SArray[I] := '';
                     end;
  RC    := 'N';
  BlkNo := '';
  Repeat
    RC := 'N';
    SearchPosB ( RootB );
    If RC = 'S' then
       begin
         If Copy(BlkNo,1,3) = CmpyNo then
            begin
              ReadWrite(#18,'R','N',BlkNumber);
              If RW = 'S' then
                 begin
                   L := L + 1;
                   MoveParaArrayB(L);
                 end;
            end;
       end
       else L := 7;
  Until L = 7;
  Repeat
    Window(38,12,57,19);
    For I := 1 to 7 do If KArray[I] <> '' then
                          begin
                            If I = Sx then Color(Tfn,Utx)
                                      else Color(Sfn,Stx);
                            GotoXY(1,I);
                            Writeln(' ',PushLeft(8,NArray[I]),
                                        PushLeft(10,SArray[I]));
                            Color(Sfn,Stx);
                          end;
    Window(1,1,80,25);
    Cont := ReadKey;
    Case Cont of
         #0  : If KeyPressed then ScrollDir;
         #13 : begin
                 BlkNumber := RArray[Sx];
                 ReadWrite(#18,'R','N',BlkNumber);
                 If SArray[Sx] = 'Bloqueado' then
                    begin
                      BlkStaMember.BlkStatus := 'L';
                      SArray[Sx]             := 'Liberado';
                    end
                    else begin
                           BlkStaMember.BlkStatus := 'B';
                           SArray[Sx]             := 'Bloqueado';
                         end;
                 ReadWrite(#18,'W','N',BlkNumber);
                 Direcao := 'N';
               end;
         else Direcao := 'N';
    end;
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
                                RC    := 'N';
                                BlkNo := KArray[1];
                                SearchAntB ( RootB );
                                If RC = 'S' then
                                   begin
                                     If Copy(BlkNo,1,3) = CmpyNo then
                                        begin
                                          ReadWrite(#18,'R','N',BlkNumber);
                                          If RW = 'S' then
                                             begin
                                               For I := 7 downto 2
                                               do ArrayParaArray((I - 1),I);
                                               MoveParaArrayB(1);
                                               F := 'N';
                                               N := N + 1;
                                             end;
                                        end
                                        else RC := 'N';
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
                                BlkNo := KArray[R];
                                RC    := 'N';
                                SearchPosB ( RootB );
                                If RC = 'S' then
                                   begin
                                     ReadWrite(#18,'R','N',BlkNumber);
                                     If RW = 'S' then
                                        begin
                                          If Copy(BlkNo,1,3) = CmpyNo then
                                             begin
                                               For I := 2 to 7
                                               do ArrayParaArray(I,(I - 1));
                                               MoveParaArrayB(R);
                                               N := N + 1;
                                               F := 'N';
                                             end
                                             else RC := 'N';
                                        end;
                                   end
                                   else F := 'P';
                              Until (N = 7) or (RC = 'N');
                              If Tkb = 'P' then F := 'N';
                            end;
                  end;
    end;
    If ((F <> 'N') or (N < 7)) and (Cont in [#72,#73,#80,#81]) then ScrollFim;
  Until Cont = #27;
  Window(1,1,80,25);
  Move(ScArrayB[1],MemW[$B800:0000],4000);
  Color(Tfn,Utx);
end;

Procedure MesAno;
Var
  MesB,AnoB  : Str2;
begin
  ReadWrite(#16,'R','N',0);
  MesB := '';
  AnoB := '';
  Repeat
    K := 1;
    Repeat
      Case K of
           1  : begin
                  J := MesB;
                  InputStr(J,2,38,23,0,'S','N','T','N',Blue,White);
                  If Length(J) = 1 then MesB := '0' + J
                                   else MesB := J;
                  If (TC <> #27) and ((MesB < '01') or (MesB > '12')) then
                     begin
                       ErroMsg := 'Mˆs Inv lido';
                       ErrorMessage;
                       K := K - 1;
                     end;
                end;
           2  : begin
                  J := AnoB;
                  Color(Blue,LightGray);
                  GotoXY(40,23); Write('/');
                  InputStr(J,4,41,23,0,'S','N','T','N',Blue,White);
                  AnoB := J;
                  If (TC <> #27) and (AnoB = '') then
                     begin
                       ErroMsg := 'Ano Inv lido';
                       ErrorMessage;
                       K := K - 1;
                     end;
                end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1
                          else K := 1;
      end;
    Until (K = 3) or (TC = #27);
    If TC <> #27 then Confirma;
  Until TC in ['S',#27];
  If TC = 'S' then
     begin
       BlkNumber              := FileSize( BlkStaFile );
       BlkStaMember.Cia       := CmpyNo;
       BlkStaMember.MesAno    := AnoB + '/' + MesB;
       BlkStaMember.BlkStatus := 'B';
       ReadWrite(#18,'W','N',BlkNumber);
       BlkNo := CmpyNo + '#'+ AnoB + '/' + MesB;
       LoadTreeB ( RootB );
     end;
end;

Procedure UpdateCia;
Var
  YYAnt  : Integer;
  MPass  : Str8;
begin
  Repeat
    J := '';
    InputStr(J,3,12,8,0,'S','N','T','N',Tfn,Utx);
    LimpaLn(24,Tfd);
    If TC = #27 then CmpyNumber := Limite
       else If TC = #25 then
               begin
                 CmpyNo := '';
                 RC     := 'N';
                 SearchPos0 ( Root0 );
                 If RC = 'N' then CmpyNumber := Limite;
               end
               else If J <> '' then
                       begin
                         Case Length(J) of
                              1 : J := '00' + J;
                              2 : J := '0'  + J;
                         end;
                         CmpyNo := J;
                         SearchTree0 ( Root0 );
                         If RC = 'N' then
                            begin
                              CmpyNumber := FileSize(CmpyFile);
                              TitleCia;
                              IncluiCia;
                              If TC = #27 then CmpyNumber := Limite;
                            end;
                         Move(ScArray4[1],MemW[$B800:0000],4000);
                       end
                       else CmpyNumber := Limite;
    If CmpyNumber <> Limite then
       With CmpyMember do
       begin
         Repeat
           TitleCiaX;
           DataCiaX;
           Repeat
             Resp := ReadKey;
             LimpaLn(24,Tfd);
             If (Resp = #0) and (KeyPressed) then
                begin
                  Resp := ReadKey;
                  Case Resp of
                       #59 : begin
                               CmpyAN := CmpyNumber;
                               CmpyAC := CmpyNo;
                               ScrollCia('S');
                               CmpyNumber := CmpyAN;
                               CmpyNo     := CmpyAC;
                               DataCiaX;
                             end;
                       #60 : begin
                               XPath := XDrive + '\PLOGM' + CmpyNo;
                               {$I-}
                               ChDir ( XPath );
                               {$I+}
                               If IOResult = 0 then
                                  begin
                                    Assign( CMstFile, (XPath + '\' + FileCMst));
                                    {$I-}
                                    Reset ( CMstFile );
                                    {$I+}
                                    If IOResult = 0 then
                                       begin
                                         EntryCiaNova;
                                         If TC = 'S' then
                                            begin
                                              ReadWrite(#02,'W','N',CmpyNumber);
                                              ReadWrite(#16,'R','N',0);
                                              CMstMember.Descricao := CmpyMember.Descricao;
                                              ReadWrite(#16,'W','N',0);
                                            end;
                                         Close ( CMstFile );
                                       end
                                       else begin
                                              ErroMsg := 'A empresa nÆo foi Criada';
                                              ErrorMessage;
                                            end;
                                  end
                                  else begin
                                         ErroMsg := 'A empresa nÆo foi Criada';
                                         ErrorMessage;
                                       end;
                               Move(ScArray4[1],MemW[$B800:0000],4000);
                               TitleCiaX;
                               DataCiaX;
                             end;
                       #61,#62,#63 : begin
                                       XPath := XDrive + '\PLOGM' + CmpyNo;
                                       {$I-}
                                       ChDir ( XPath );
                                       {$I+}
                                       If IOResult = 0 then
                                          begin
                                            Assign( CMstFile, (XPath + '\' + FileCMst));
                                            {$I-}
                                            Reset ( CMstFile );
                                            {$I+}
                                            If IOResult = 0 then
                                               begin
                                                 ReadWrite(#16,'R','N',0);
                                                 Case Resp of
                                                      #61 : begin
                                                              TitleCia;
                                                              DataCia('S');
                                                              Op := 'A';
                                                              EntryCia;
                                                            end;
                                                      #62 : begin
                                                              TitleCompl;
                                                              DataCompl;
                                                              EntryCompl;
                                                            end;
                                                      #63 : begin
                                                              TitleOutros;
                                                              DataOutros;
                                                              EntryOutros;
                                                            end;
                                                 end;
                                                 If TC = 'S' then ReadWrite(#16,'W','N',0);
                                                 Close ( CMstFile );
                                               end
                                               else begin
                                                      ErroMsg := 'A empresa nÆo foi Criada';
                                                      ErrorMessage;
                                                    end;
                                          end
                                          else begin
                                                 ErroMsg := 'A empresa nÆo foi Criada';
                                                 ErrorMessage;
                                               end;
                                       Move(ScArray4[1],MemW[$B800:0000],4000);
                                       TitleCiaX;
                                       DataCiaX;
                                     end;
                       #64 : If CmpyMember.Status <> 'I' then
                                begin
                                  CmpyMember.Status := 'I';
                                  ReadWrite(#02,'W','N',CmpyNumber);
                                  DataCiaX;
                                end;
                       #65 : If CmpyMember.Status <> 'M' then
                                begin
                                  Move(Mem[$B800:0000],ScArray4[1],4000);
                                  Color(Blue,Yellow);
                                  GotoXY(1,24); Write(ConstStr(' ',80));
                                  GotoXY(2,24); Write('Entre com a senha para BLOQUEIO:');
                                  MPass := UpCaseStr(MasterMember.BlkPssword);
                                  Repeat
                                    J := '';
                                    InputStr(J,8,35,24,0,'N','S','T','N',Blue,White);
                                    J := UpCaseStr(J);
                                  Until (J = MPass) or (TC = #27);
                                  Color(Tfd,Utx);
                                  GotoXY(1,24); Write(ConstStr(' ',80));
                                  If J = MPass then
                                     begin
                                       YYAnt := 1;
                                       Repeat
                                         Color(Tfn,Utx);
                                         TabI[1]  := ' Novo Bloqueio      ';
                                         TabI[2]  := ' Alterar condi‡Æo   ';
                                         TabI[3]  := ' Encerrar fun‡Æo    ';
                                         TabX[1]  := 15;
                                         TabX[2]  := 15;
                                         TabX[3]  := 15;
                                         TabY[1]  := 15;
                                         TabY[2]  := 16;
                                         TabY[3]  := 17;
                                         YY       := YYAnt;
                                         RetMenuAuxiliar(14,14,3,1,1);
                                         YYAnt := YY;
                                         Resp  := #00;
                                         Move(Mem[$B800:0000],ScArray5[1],4000);
                                         Case YY of
                                              1   : begin
                                                      Color(Blue,Yellow);
                                                      GotoXY(1,23); Write(ConstStr(' ',80));
                                                      GotoXY(2,23); Write('Entre o mˆs e o ano a ser bloquedo:');
                                                      Color(Red,Yellow);
                                                      GotoXY(1,24); Write(ConstStr(' ',80));
                                                      MesAno;
                                                    end;
                                              2   : ScrollBlk;
                                              3   : Resp := #27;
                                         end;
                                         Move(ScArray5[1],Mem[$B800:0000],4000);
                                       Until Resp = #27;
                                       Resp := #00;
                                     end;
                                  Move(ScArray4[1],Mem[$B800:0000],4000);
                                end;
                       #67 : If CmpyMember.Status <> 'M' then
                                begin
                                  CmpyMember.Status := 'M';
                                  ReadWrite(#02,'W','N',CmpyNumber);
                                  DataCiaX;
                                end;
                       #68 : begin
                               DrawBox(4,11,49,19,Red,'S');
                               Color(Red,Yellow);
                               GotoXY(4,11); Write('               Leia com Aten‡Æo               ');
                               Color(Red,Cyan);
                               GotoXY(4,12); Write('               ----------------               ');
                               GotoXY(4,13); Write(' Ser   feito uma  exclusÆo l¢gica da empresa, ');
                               GotoXY(4,14); Write(' que nÆo excluir   fisicamente os arquivos do ');
                               GotoXY(4,15); Write(' Banco de Dados. No entanto esta empresa ter  ');
                               GotoXY(4,16); Write(' seu acesso  restrito enquanto  perdurar esta ');
                               GotoXY(4,17); Write(' situa‡Æo de Exclu¡da, que pode ser revertida ');
                               GotoXY(4,18); Write(' atrav‚s das fun‡”es normais de monitora‡Æo.  ');
                               GotoXY(4,19); Write('                    Veja o Manual do Usu rio. ');
                               Color(Tfn,Utx);
                               Confirma;
                               If TC = 'S' then
                                  begin
                                    CmpyMember.Status := 'X';
                                    ReadWrite(#02,'W','N',CmpyNumber);
                                  end;
                               Move(ScArray4[1],MemW[$B800:0000],4000);
                               TitleCiaX;
                               DataCiaX;
                             end;
                       #72 : begin
                               RC := 'N';
                               SearchAnt0 ( Root0 );
                               If RC = 'N' then AvisoFinal;
                             end;
                       #80 : begin
                               RC := 'N';
                               SearchPos0 ( Root0 );
                               If RC = 'N' then AvisoFinal;
                             end;
                       #94 : HelpManual;
                  end;
                end;
           Until (Resp in [#13,#27]) or ((Resp in [#72,#80]) and (RC <> 'N'));
           Move(ScArray4[1],MemW[$B800:0000],4000);
         Until Resp in [#13,#27];
         TC := Resp;
       end;
  Until TC = #27;
end;


Procedure ErroCia(X : Char);
begin
  DrawBox(3,14,50,17,Red,'S');
  Color(Red,White);
  GotoXY(4,15);
  Case X of
       '1' : Write('NÆo encontrei o Subdiret¢rio da Empresa.');
       '2' : Write('A Empresa esta bloqueada pelo MASTER.   ');
       '3' : Write('VersÆo de Demonstra‡Æo c/prazo esgotado.');
  end;
  Color(Red,Yellow);
  GotoXY(38,17); Write('Tecle ENTER ');
  Repeat
    TC := ReadKey;
  Until TC = #13;
  Color(Tfd,White);
  GotoXY(3,14); Write(ConstStr('Ä',44));
  GotoXY(3,15); Write(ConstStr('Ä',44));
  GotoXY(3,16); Write(ConstStr('Ä',44));
  GotoXY(3,17); Write(ConstStr('Ä',44));
  GotoXY(3,18); Write(ConstStr('Ä',44));
  TC := #27;
end;


Procedure EntryCodCia;
begin
  Repeat
    CmpyNo := LastCia;
    CmpyAC := '';
    J      := '';
    ScrollCia('N');
    If CmpyAC = '' then TC := #27
                   else J  := CmpyAC;
    If (TC <> #27) and
       (J  <> '' ) then
       begin
         Case Length(J) of
              1 : J := '00' + J;
              2 : J := '0'  + J;
         end;
         XCia   := J;
         CmpyNo := J;
         SearchTree0 ( Root0 );
         If RC = 'S' then
            begin
              ReadWrite(#02,'R','N',CmpyNumber);
              If CmpyMember.Status in ['A','I'] then
                 begin
                   DrawBox(3,17,48,17,Red,'S');
                   Color(Red,Yellow);
                   GotoXY(4,17); Write(CmpyNo,' ',CmpyMember.Descricao);
                   Color(Tfd,LightGray);
                   TC    := 'S';
                   XPath := XDrive + '\PLOGM' + XCia;
                   {$I-}
                   ChDir ( XPath );
                   {$I+}
                   If IOResult = 0 then
                      begin
                        Assign( CMstFile, (XPath + '\' + FileCMst));
                        {$I-}
                        Reset ( CMstFile );
                        {$I+}
                        If IOResult <> 0 then ErroCia('1')
                           else begin
                                  ReadWrite(#16,'R','N',0);
                                  XStAnt := CmpyMember.Status;
                                  If CmpyMember.Status = 'I' then
                                     begin
                                       CmpyMember.Status := 'A';
                                       ReadWrite(#02,'W','N',CmpyNumber);
                                       BlkNo := CmpyNo + '#'+
                                                QQStr(CMstMember.AnoAtivo,4,'0') + '/' +
                                                QQStr(CMstmember.MesAtivo,2,'0');
                                       SearchTreeB ( RootB );
                                       If RC = 'S' then
                                          begin
                                            ReadWrite(#18,'R','N',BlkNumber);
                                            If BlkStaMember.BlkStatus = 'B' then XSt := 'B'
                                                                            else XSt := 'A';
                                          end
                                          else XSt := 'A';
                                     end
                                     else XSt := 'B';
                                  If OwnerMember.NoSerie[1] <> '#' then
                                     begin
                                       J := QQStr(CMstMember.AnoAtivo,4,'0') +
                                            QQStr(CMstmember.MesAtivo,2,'0');
                                       If (J <> Copy(OwnerMember.NoSerie,1,4)) and
                                          (J <> Copy(OwnerMember.NoSerie,5,4)) then ErroCia('3');
                                     end;
                                  XCondicional := OwnerMember.NoSerie;
                                end;
                      end
                      else ErroCia('1');
                 end
                 else ErroCia('2');
            end
            else TC := #27;
       end;
  Until TC in [#27,'S'];
end;


Procedure ListaEmpresas;
Var
  L1   : Str80;
begin
  QPorta;
  If TC = #13 then
     begin
       ContLin := 1000;
       CmpyNo  := '';
       NCont   := 0;
       Repeat
         RC := 'N';
         SearchPos0 ( Root0 );
         If RC = 'S' then
            begin
              ReadWrite(#02,'R','N',CmpyNumber);
              NCont := NCont + 1;
              If ContLin > 55 then
                 With OwnerMember do
                 begin
                   If Laser <> 'N' then WriteLine('W',LaserInit)
                                   else If ContLin < 1000 then WriteLine('W',Qp);
                   L1      := Dx+Acentua(RSocial)+Df;
                   ContLin := 0;
                   WriteLine('L',L1);
                   WriteLine('L',ConstStr('-',80));
                   WriteLine('L',ConstStr(' ',3)+Acentua(Endereco));
                   WriteLine('L',ConstStr(' ',3)+Acentua(Cidade)+' '+Estado);
                   WriteLine('L',ConstStr(' ',3)+'Cep. '+Cep+'  Tel. '+Telefone);
                   WriteLine('L',ConstStr(' ',3)+'CGC. '+Cgc+' Inscr. '+Inscricao);
                   WriteLine('L',ConstStr(' ',3)+XSystem+Acentua(' vers„o ')+
                               Copy(Versao,1,3)+' de '+Copy(Versao,4,5)+
                               ' Licenciado para uso por tempo indeterminado.');
                   WriteLine('L',ConstStr('-',80));
                   WriteLine('L','Ultimo Backup Total em '+MasterMember.DataBkp);
                   WriteLine('L',ConstStr('-',80));
                   WriteLine('L',' ');
                 end;
              CalculoBase(XSystem,CmpyMember.Descricao);
              I := 30000 - NBaseC;
              WriteLine('L',PushLeft(5,CmpyNo)+
                            Acentua(CmpyMember.Descricao)+
                            ConstStr(' ',46-Length(CmpyMember.descricao))+
                            ' Chave: '+PushRight(5,EditInteger(I)));
            end;
       Until RC = 'N';
       WriteLine('L',' ');
       WriteLine('L','Total de empresas licenciadas: '+
                     PushRight(3,EditInteger(NCont)));
       If DskRpt = 'N' then WriteLine('W',Qp);
       Color(Blue,Cyan);
       GotoXY(1,23);  Write(ConstStr(' ',80));
       GotoXY(1,23);  Write(' Total de Empresas Impressas: ');
       Color(Blue,White);
       GotoXY(31,23); Write(NCont:5);
       TeclaReturn;
       CmpyNo := XCia;
       SearchTree0 ( Root0 );
       If RC = 'S' then ReadWrite(#02,'R','N',CmpyNumber);
       Close ( LST );
     end;
end;

end.

