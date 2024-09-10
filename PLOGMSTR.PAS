{$O+,F+}
Unit PlogMstr;

Interface

Uses Crt,Dos,PlogGlbs,PlogBasP,PlogTree,PlogCmpy,PlogDoct;



   Procedure TitleMstr(X : Char);
   Procedure ScrollSind;
   Procedure UpdateSind(X : Char);
   Procedure ScrollBanco;
   Procedure UpdateBanco;
   Procedure ScrollDept(X : Char);
   Procedure UpdateDept;
   Procedure ScrollConta;
   Procedure UpdateConta(X : Char);

   Procedure TrocaChave;

   Procedure OrdemServ;


Implementation


Procedure TitleMstr(X : Char);
begin
  Color(Tfn,Ttx);
  Case X of
       'B' : begin
               GotoXY(4,09);  Write('Bco/Ag:');
               GotoXY(4,10);  Write('Banco.:');
               GotoXY(4,12);  Write('Agenc.:');
               GotoXY(4,14);  Write('1¦ Cta:');
               GotoXY(4,15);  Write('2¦ Cta:');
               GotoXY(4,17);  Write('Status:');
             end;
       'C' : begin
               GotoXY(4,09);  Write('Conta.:');
               GotoXY(4,10);  Write('Descr.:');
               GotoXY(4,11);  Write('Tipo..:');
               GotoXY(40,11); Write('B.Rais:');
               GotoXY(4,12);  Write('Tem/Pe:');
               GotoXY(40,12); Write('B.Dirf:');
               GotoXY(4,13);  Write('Opera.:');
               GotoXY(38,13); Write(#218,' Base06:');
               GotoXY(4,14);  Write('Aceita:');
               GotoXY(38,14); Write(#195,' Base07:');
               GotoXY(4,15);  Write('M‚dia.:');
               GotoXY(30,15); Write('Usu rio ',#195,' Base08:');
               GotoXY(4,16);  Write('Fator.:');
               GotoXY(38,16); Write(#195,' Base09:');
               GotoXY(4,17);  Write('Taxa H:');
               GotoXY(38,17); Write(#192,' Base10:');
               GotoXY(4,18);  Write('B.IRF.:');
               GotoXY(40,18); Write('RepRem:');
               GotoXY(4,19);  Write('B.INSS:');
               GotoXY(40,19); Write('Custo.:');
               GotoXY(4,20);  Write('B.FGTS:');
               GotoXY(40,20); Write('Status:');
             end;
       'D' : begin
               GotoXY(04,09);  Write('Depto.:');
               GotoXY(40,09);  Write('Status:');
               GotoXY(04,10);  Write('Nome..:');
               GotoXY(04,11);  Write('---------------------------------------- Vale transporte');
               GotoXY(04,12);  Write('Dias £teis mˆs corrente:');
               GotoXY(04,13);  Write('Dias £teis pr¢ximo mˆs.:');
               GotoXY(04,14);  Write('Dias £teis 1§ quinzena.:');
               GotoXY(04,15);  Write('Dias £teis 2§ quinzena.:');
               GotoXY(04,16);  Write('--------------------------------------------------- GRPS');
               GotoXY(04,17);  Write('Endere‡o:');
               GotoXY(04,18);  Write('Cidade..:');
               GotoXY(40,18);  Write('Estado..:');
               GotoXY(04,19);  Write('Cep.....:');
               GotoXY(25,19);  Write('DDD.....:');
               GotoXY(40,19);  Write('Telefone:');
               GotoXY(04,20);  Write('Tipo/Id.:');
             end;
       'S' : begin
               GotoXY(4,09); Write('C¢digo:');
               GotoXY(4,10); Write('Nome..:');
               GotoXY(4,12); Write('Ender.:');
               GotoXY(4,13); Write('N£mero:');
               GotoXY(4,14); Write('Compl.:');
               GotoXY(4,15); Write('Bairro:');
               GotoXY(4,16); Write('Cidade:');
               GotoXY(4,17); Write('Estado:');
               GotoXY(4,18); Write('Cep...:');
               GotoXY(4,19); Write('CGC...:');
               GotoXY(4,20); Write('Entid.:');
               GotoXY(4,21); Write('Status:');
             end;
  end;
  Color(Tfn,Utx);
end;


Procedure DataMstr(X : Char);
begin
  HelpM;
  Color(Tfn,Utx);
  Case X of
       'B' : With BBMember do
             begin
               ReadWrite(#06,'R','N',BBNumber);
               GotoXY(12,09); Write(PushLeft(11,OrigBancoC));
               GotoXY(12,10); Write(PushLeft(41,NomeBanco));
               GotoXY(12,12); Write(PushLeft(41,NomeAgencia));
               GotoXY(12,14); Write(PushLeft(15,Conta1));
               GotoXY(12,15); Write(PushLeft(15,Conta2));
               GotoXY(12,17); Case Status of
                                   'A' : Write('Ativo     ');
                                   'C' : Write('Cancelado ');
                              end;
             end;
       'C' : With CCMember do
             begin
               ReadWrite(#04,'R','N',CCNumber);
               CCNo := Conta;
               GotoXY(12,09); Write(Conta);
               GotoXY(12,10); Write(PushLeft(41,Descricao));
               GotoXY(12,11); Case Tipo of
                                   'P' : Write('Provento');
                                   'D' : Write('Desconto');
                                   'O' : Write('Outros  ');
                              end;
               GotoXY(48,11); Case Bases[4] of
                                   'S' : Write('Sim');
                                   'N' : Write('NÆo');
                              end;
               GotoXY(12,12); Case Tempo of
                                   'T' : Write('Tempor ria');
                                   'P' : Write('Permanente');
                              end;
               GotoXY(48,12); Case Bases[5] of
                                   'S' : Write('Sim');
                                   'N' : Write('NÆo');
                              end;
               GotoXY(12,13); Case Operacao of
                                   'A' : Write('Adiantamento');
                                   '1' : Write('1¦ Semana   ');
                                   '2' : Write('2¦ Semana   ');
                                   '3' : Write('3¦ Semana   ');
                                   '4' : Write('4¦ Semana   ');
                                   'O' : Write('Ad.13¦ Sal. ');
                                   'P' : Write('Pagamento   ');
                                   'S' : Write('13§ Sal rio ');
                              end;
               GotoXY(48,13); Case Bases[6] of
                                   'S' : Write('Sim');
                                   'N' : Write('NÆo');
                              end;
               GotoXY(12,14); Case Aceita of
                                   'S' : Write('Sim');
                                   'N' : Write('NÆo');
                              end;
               GotoXY(48,14); Case Bases[7] of
                                   'S' : Write('Sim');
                                   'N' : Write('NÆo');
                              end;
               GotoXY(12,15); Case Media of
                                   'N' : Write('NÆo');
                                   'S' : Write('Sim');
                              end;
               GotoXY(48,15); Case Bases[8] of
                                   'S' : Write('Sim');
                                   'N' : Write('NÆo');
                              end;
               GotoXY(12,16); Write(Taxa:8:4);
               GotoXY(48,16); Case Bases[9] of
                                   'S' : Write('Sim');
                                   'N' : Write('NÆo');
                              end;
               GotoXY(12,17);
               Case TxConv of
                    '1','2'             : Write(TxConv,' Taxa hor ria   ');
                    '0','6','7','8','9' : Write(TxConv,' Base de Usu rio');
                    else                  Write('                 ');
               end;
               GotoXY(48,17); Case Bases[10] of
                                   'S' : Write('Sim');
                                   'N' : Write('NÆo');
                              end;
               GotoXY(12,18); Case Bases[1] of
                                   'S' : Write('Sim    ');
                                   'N' : Write('NÆo    ');
                                   'F' : Write('F‚rias ');
                                   '1' : Write('13§Sal.');
                              end;
               GotoXY(48,18); Case RepousoM of
                                   'S' : Write('Sim');
                                   'N' : Write('NÆo');
                              end;
               GotoXY(12,19); Case Bases[2] of
                                   'S' : Write('Sim    ');
                                   'N' : Write('NÆo    ');
                                   'F' : Write('F‚rias ');
                                   '1' : Write('13§Sal.');
                               end;
               GotoXY(48,19); Case Custo of
                                   'S' : Write('Sim');
                                   'N' : Write('NÆo');
                              end;
               GotoXY(12,20); Case Bases[3] of
                                   'S' : Write('Sim');
                                   'N' : Write('NÆo');
                              end;
               GotoXY(48,20); Case Status of
                                   'A' : Write('Ativa     ');
                                   'D' : Write('Desativada');
                                   'C' : Write('Cancelada ');
                              end;
             end;
       'D' : With DDMember do
             begin
               ReadWrite(#05,'R','N',DDNumber);
               GotoXY(12,09); Write(PushLeft(11,Codigo));
               GotoXY(48,09); Case Status of
                                   'A' : Write('Ativo     ');
                                   'C' : Write('Cancelado ');
                              end;
               GotoXY(12,10); Write(PushLeft(41,Descricao),Marca);
               GotoXY(29,12); Write(Dias1:2);
               GotoXY(29,13); Write(Dias2:2);
               GotoXY(29,14); Write(DiasQ1:2);
               GotoXY(29,15); Write(DiasQ2:2);
               GotoXY(14,17); Write(PushLeft(41,Endereco));
               GotoXY(14,18); Write(PushLeft(21,Cidade));
               GotoXY(50,18); Write(PushLeft(3,Estado));
               GotoXY(14,19); Write(PushLeft(10,Cep));
               GotoXY(35,19); Write(PushLeft(5,DDD));
               GotoXY(50,19); Write(PushLeft(9,Telefone));
               GotoXY(14,20); Write(GRPSTipo);
               GotoXY(16,20); Write(PushLeft(21,GRPSIdent));
             end;
       'S' : With SSMember do
             begin
               ReadWrite(#07,'R','N',SSNumber);
               GotoXY(12,09); Write(Codigo);
               GotoXY(12,10); Write(PushLeft(41,Descricao));
               GotoXY(12,11); Write(PushLeft(41,Descricao2));
               GotoXY(12,12); Write(PushLeft(41,Endereco));
               GotoXY(12,13); Write(PushLeft(11,Numero));
               GotoXY(12,14); Write(PushLeft(16,Complemento));
               GotoXY(12,15); Write(PushLeft(21,Bairro));
               GotoXY(12,16); Write(PushLeft(21,Cidade));
               GotoXY(12,17); Write(Estado);
               GotoXY(12,18); Write(Cep);
               GotoXY(12,19); Write(PushLeft(21,CGC));
               GotoXY(12,20); Write(PushLeft(21,Cod));
               GotoXY(12,21); Case Status of
                                   'A' : Write('Ativo     ');
                                   'C' : Write('Cancelado ');
                              end;
             end;
  end;
end;


Procedure EntrySind;
begin
  Repeat
    K := 1;
    Repeat
      Case K of
           1   : With SSMember do
                 begin
                   J := Descricao;
                   InputStr(J,40,12,10,0,'S','S','T','N',Tfn,Utx);
                   Descricao := J;
                   If (TC        <> #27) and
                      (Descricao =  '' ) then
                      begin
                        ErroMsg := 'Informe o Nome';
                        ErrorMessage;
                        K := K - 1;
                      end;
                 end;
           2   : With SSMember do
                 begin
                   J := Descricao2;
                   InputStr(J,40,12,11,0,'S','S','T','N',Tfn,Utx);
                   Descricao2 := J;
                 end;
           3   : With SSMember do
                 begin
                   J := Endereco;
                   InputStr(J,40,12,12,0,'S','S','T','N',Tfn,Utx);
                   Endereco := J;
                   If (TC       <> #27) and
                      (Endereco =  '' ) then
                      begin
                        ErroMsg := 'Informe o Enderˆ‡o';
                        ErrorMessage;
                        K := K - 1;
                      end;
                 end;
           4   : With SSMember do
                 begin
                   J := Numero;
                   InputStr(J,10,12,13,0,'S','S','T','N',Tfn,Utx);
                   Numero := J;
                   If (TC     <> #27) and
                      (Numero =  '' ) then
                      begin
                        ErroMsg := 'Informe o N£mero';
                        ErrorMessage;
                        K := K - 1;
                      end;
                 end;
           5   : With SSMember do
                 begin
                   J := Complemento;
                   InputStr(J,15,12,14,0,'S','S','T','N',Tfn,Utx);
                   Complemento := J;
                 end;
           6   : With SSMember do
                 begin
                   J := Bairro;
                   InputStr(J,20,12,15,0,'S','S','T','N',Tfn,Utx);
                   Bairro := J;
                   If (TC     <> #27) and
                      (Bairro =  '' ) then
                      begin
                        ErroMsg := 'Informe o Bairro';
                        ErrorMessage;
                        K := K - 1;
                      end;
                 end;
           7   : With SSMember do
                 begin
                   J := Cidade;
                   InputStr(J,20,12,16,0,'S','S','T','N',Tfn,Utx);
                   Cidade := J;
                   If (TC     <> #27) and
                      (Cidade =  '' ) then
                      begin
                        ErroMsg := 'Informe a Cidade';
                        ErrorMessage;
                        K := K - 1;
                      end;
                 end;
           8   : With SSMember do
                 begin
                   J := Estado;
                   InputStr(J,2,12,17,0,'S','N','T','N',Tfn,Utx);
                   Estado := UpCaseStr(J);
                   GotoXY(12,17); Write(Estado);
                   CheckUF(Estado);
                   If (TC <> #27) and
                      (R   = 1  ) then
                      begin
                        ErroMsg := 'Sigla do Estado Inv lida';
                        ErrorMessage;
                        K := K - 1;
                      end;
                 end;
           9   : With SSMember do
                 begin
                   J := Cep;
                   InputStr(J,9,12,18,0,'S','N','T','N',Tfn,Utx);
                   Cep := J;
                 end;
           10  : With SSMember do
                 begin
                   J := CGC;
                   InputStr(J,20,12,19,0,'S','N','T','N',Tfn,Utx);
                   CGC := J;
                 end;
           11  : With SSMember do
                 begin
                   J := Cod;
                   InputStr(J,20,12,20,0,'S','N','T','N',Tfn,Utx);
                   Cod := J;
                 end;
           12  : With SSMember do
                 begin
                   Move(Mem[$B800:0000],ScArray5[1],4000);
                   DrawBox(36,14,55,17,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(36,15); Write('       tivo         ');
                   GotoXY(36,16); Write('       ancelado     ');
                   Color(Red,White);
                   GotoXY(42,15); Write('A');
                   GotoXY(42,16); Write('C');
                   J := Status;
                   InputStr(J,1,12,21,0,'S','N','T','N',Tfn,Utx);
                   Status := UpCase(J[1]);
                   If J = ' ' then Status := 'A';
                   If (TC     <> #27) and
                      (Status <> 'A') and
                      (Status <> 'C') then
                      begin
                        ErroMsg := 'Informe A ou C';
                        ErrorMessage;
                        K := K - 1;
                      end;
                   Op := 'A';
                   Move(ScArray5[1],Mem[$B800:0000],4000);
                   GotoXY(12,21); Case Status of
                                       'A' : Write('Ativo     ');
                                       'C' : Write('Cancelado ');
                                       else  Write(Status);
                                  end;
                 end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K = 1 then K := 12
                          else K := K - 1;
      end;
    Until (K = 13) or (TC = #27);
    If TC <> #27 then Confirma;
  Until (TC = 'S') or (TC = #27);
end;


Procedure IncluiSind;
begin
  With SSMember do
  begin
    Op          := 'I';
    Codigo      := SSNo;
    Descricao   := '';
    Descricao2  := '';
    Endereco    := '';
    Numero      := '';
    Complemento := '';
    Bairro      := '';
    Cidade      := '';
    Estado      := '';
    Cep         := '';
    CGC         := '';
    Cod         := '';
    Status      := 'A';
    EntrySind;
    Move(ScArray4[1],Mem[$B800:0000],4000);
    If TC = 'S' then
       begin
         D1    := 'S';
         NFunc := 0;
         ReadWrite(#07,'W','N',SSNumber);
         LoadTree2 ( Root2 );
         MasterMember.NSind := MasterMember.NSind + 1;
         ReadWrite(#00,'W','N',0);
         ShowHeap;
         Color(Red,Yellow);
         GotoXY(53,7); Write(MasterMember.NSind);
         Move(Mem[$B800:0000],ScArray4[1],4000);
       end
       else begin
              SSNumber := Limite;
              TC       := #13;
            end;
  end;
end;


Procedure MoveParaArrayS(L : Integer);
begin
  ReadWrite(#07,'R','N',SSNumber);
  If RW = 'S' then
     begin
       KArray[L] := SSMember.Codigo;
       RArray[L] := SSNumber;
       NArray[L] := SSMember.Descricao;
     end;
end;


Procedure ArrayParaArrayS(D,P : Integer);
begin
  KArray[P]  := KArray[D];
  RArray[P]  := RArray[D];
  NArray[P]  := NArray[D];
end;


Procedure ScrollSind;
Var
   ScArrayS       : Array [1..4000] of Char;
begin
  Move(Mem[$B800:0000],ScArrayS[1],4000);
  FootScroll;
  DrawBox(10,11,68,20,Sfn,'S');
  Color(Bfn,Btx);
  GotoXY(10,11);
  Write(' Sindicato       Nome                                      ');
  Color(Sfn,Stx);
  SSAC    := SSNo;
  SSAN    := SSNumber;
  Tkb     := 'L';
  F       := 'N';
  Direcao := 'P';
  L       := 0;
  Sx      := 1;
  For I := 1 to 7 do begin
                       KArray[I] := '';
                       RArray[I] := 0;
                       NArray[I] := '';
                     end;
  RC := 'N';
  SearchAnt2 ( Root2 );
  If RC = 'N' then SSNo := '';
  Repeat
    RC := 'N';
    SearchPos2 ( Root2 );
    If RC = 'S' then
       begin
         L := L + 1;
         MoveParaArrayS(L);
       end
       else L := 7;
  Until L = 7;
  Repeat
    Window(10,13,69,20);
    For I := 1 to 7 do begin
                          If KArray[I] <> '' then
                             begin
                               If I = Sx then Color(Tfn,Utx)
                                         else Color(Sfn,Stx);
                               GotoXY(1,I);
                               Writeln(' ',PushLeft(16,KArray[I]),
                                           PushLeft(42,NArray[I]));
                               Color(Sfn,Stx);
                             end;
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
                                RC   := 'N';
                                SSNo := KArray[1];
                                SearchAnt2 ( Root2 );
                                If RC = 'S' then
                                   begin
                                     For I := 7 downto 2
                                     do ArrayParaArrayS((I - 1),I);
                                     MoveParaArrayS(1);
                                     F := 'N';
                                     N := N + 1;
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
                                SSNo := KArray[R];
                                RC   := 'N';
                                SearchPos2 ( Root2 );
                                If RC = 'S' then
                                   begin
                                     For I := 2 to 7
                                     do ArrayParaArrayS(I,(I - 1));
                                     MoveParaArrayS(R);
                                     N := N + 1;
                                     F := 'N';
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
  Move(ScArrayS[1],Mem[$B800:0000],4000);
  Color(Tfn,Utx);
  If Cont = #13 then
     begin
       SSAN := RArray[Sx];
       SSAC := KArray[Sx];
     end;
end;


Procedure UpdateSind(X : Char);
begin
  Repeat
    J := '';
    InputStr(J,2,12,9,0,'S','N','T','N',Tfn,Utx);
    LimpaLn(24,Tfd);
    Case TC of
         #13 : begin
                 SSNo := J;
                 SearchTree2 ( Root2 );
                 If RC = 'N' then
                    begin
                      If X = 'M' then
                         begin
                           SSNumber := FileSize(SSFile);
                           IncluiSind;
                         end
                         else SSNumber := Limite;
                    end;
               end;
         #25 : begin
                 SSNo := '';
                 RC   := 'N';
                 SearchPos2 ( Root2 );
                 If RC = 'N' then SSNumber := Limite;
               end;
         #27 : SSNumber := Limite;
         else  SSNumber := Limite;
    end;
    If SSNumber <> Limite then
       With SSMember do
       begin
         Repeat
           Repeat
             DataMstr('S');
             Resp := ReadKey;
             LimpaLn(24,Tfd);
             If (Resp = #0) and (KeyPressed) then
                begin
                  Resp := ReadKey;
                  Case Resp of
                       #59 : begin
                               SSAC := SSNo;
                               SSAN := SSNumber;
                               ScrollSind;
                               SSNumber := SSAN;
                               SSNo     := SSAC;
                             end;
                       #61 : If X = 'M' then
                                begin
                                  Op := 'A';
                                  EntrySind;
                                  If TC = 'S' then ReadWrite(#07,'W','N',SSNumber);
                                end;
                       #72 : begin
                               RC := 'N';
                               SearchAnt2 ( Root2 );
                               If RC = 'N' then AvisoFinal;
                             end;
                       #80 : begin
                               RC := 'N';
                               SearchPos2 ( Root2 );
                               If RC = 'N' then AvisoFinal;
                             end;
                       #94 : HelpManual;
                  end;
                end;
           Until (Resp in [#13,#27]) or ((Resp in [#72,#80]) and (RC <> 'N'));
           Move(ScArray4[1],Mem[$B800:0000],4000);
         Until Resp in [#13,#27];
         TC := Resp;
       end;
  Until TC = #27;
end;


Procedure EntryBanco;
begin
  Repeat
    K := 1;
    Repeat
      Case K of
           1   : With BBMember do
                 begin
                   J := NomeBanco;
                   InputStr(J,40,12,10,0,'S','S','T','N',Tfn,Utx);
                   NomeBanco := J;
                   If (TC        <> #27) and
                      (NomeBanco =  '' ) then
                      begin
                        ErroMsg := 'Informe o Nome do Banco';
                        ErrorMessage;
                        K := K - 1;
                      end;
                 end;
           2   : With BBMember do
                 begin
                   J := NomeAgencia;
                   InputStr(J,40,12,12,0,'S','S','T','N',Tfn,Utx);
                   NomeAgencia := J;
                   If (TC          <> #27) and
                      (NomeAgencia =  '' ) then
                      begin
                        ErroMsg := 'Informe o Nome da Agencia';
                        ErrorMessage;
                        K := K - 1;
                      end;
                 end;
           3   : With BBMember do
                 begin
                   J := Conta1;
                   InputStr(J,15,12,14,0,'S','N','T','N',Tfn,Utx);
                   Conta1 := J;
                   If (TC     <> #27) and
                      (Conta1 =  '' ) then
                      begin
                        ErroMsg := 'Informe a 1¦ Conta-Banc ria';
                        ErrorMessage;
                        K := K - 1;
                      end;
                 end;
           4   : With BBMember do
                 begin
                   J := Conta2;
                   InputStr(J,15,12,15,0,'S','N','T','N',Tfn,Utx);
                   Conta2 := J;
                 end;
           5   : With BBMember do
                 begin
                   Move(Mem[$B800:0000],ScArray5[1],4000);
                   DrawBox(36,14,55,17,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(36,15); Write('       tivo         ');
                   GotoXY(36,16); Write('       ancelado     ');
                   Color(Red,White);
                   GotoXY(42,15); Write('A');
                   GotoXY(42,16); Write('C');
                   J := Status;
                   InputStr(J,1,12,17,0,'S','N','T','N',Tfn,Utx);
                   Status := UpCase(J[1]);
                   If J = ' ' then Status := 'A';
                   If (TC     <> #27) and
                      (Status <> 'A') and
                      (Status <> 'C') then
                      begin
                        ErroMsg := 'Informe A ou C';
                        ErrorMessage;
                        K := K - 1;
                      end;
                   Op := 'A';
                   Move(ScArray5[1],Mem[$B800:0000],4000);
                   GotoXY(12,17); Case Status of
                                       'A' : Write('Ativo     ');
                                       'C' : Write('Cancelado ');
                                       else  Write(Status);
                                  end;
                 end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K = 1 then K := 5
                          else K := K - 1;
      end;
    Until (K = 6) or (TC = #27);
    If ((TC <> #27) and (Op = 'I')) or (Op = 'A') then Confirma;
  Until (TC = 'S') or (TC = #27);
end;


Procedure IncluiBanco;
begin
  With BBMember do
  begin
    Op          := 'I';
    BancoC      := BBNo;
    Status      := 'A';
    OrigBancoC  := J;
    NomeBanco   := '';
    NomeAgencia := '';
    Conta1      := '';
    Conta2      := '';
    EntryBanco;
    Move(ScArray4[1],Mem[$B800:0000],4000);
    If TC = 'S' then
       begin
         D3 := 'S';
         ReadWrite(#06,'W','N',BBNumber);
         LoadTree7 ( Root7 );
         CMstMember.NBancos := CMstMember.NBancos + 1;
         ReadWrite(#16,'W','N',0);
         ShowHeap;
         Color(Red,Yellow);
         GotoXY(53,7); Write(CMstMember.NBancos);
         Color(Tfn,Utx);
         Move(Mem[$B800:0000],ScArray4[1],4000);
       end
       else begin
              BBNumber := Limite;
              TC       := #13;
            end;
  end;
end;


Procedure MoveParaArrayB(L : Integer);
begin
  ReadWrite(#06,'R','N',BBNumber);
  If RW = 'S' then
     begin
       KArray[L] := BBMember.OrigBancoC;
       RArray[L] := BBNumber;
       NArray[L] := BBMember.NomeBanco;
     end;
end;


Procedure ArrayParaArrayB(D,P : Integer);
begin
  KArray[P]  := KArray[D];
  RArray[P]  := RArray[D];
  NArray[P]  := NArray[D];
end;


Procedure ScrollBanco;
Var
   ScArrayS       : Array [1..4000] of Char;
begin
  Move(Mem[$B800:0000],ScArrayS[1],4000);
  FootScroll;
  DrawBox(10,11,68,20,Sfn,'S');
  Color(Bfn,Btx);
  GotoXY(10,11);
  Write(' Banco           Descri‡Æo                                 ');
  Color(Sfn,Stx);
  BBAC    := BBNo;
  BBAN    := BBNumber;
  Tkb     := 'L';
  F       := 'N';
  Direcao := 'P';
  L       := 0;
  Sx      := 1;
  For I := 1 to 7 do begin
                       KArray[I] := '';
                       RArray[I] := 0;
                       NArray[I] := '';
                     end;
  RC := 'N';
  SearchAnt7 ( Root7 );
  If RC = 'N' then BBNo := '';
  Repeat
    RC := 'N';
    SearchPos7 ( Root7 );
    If RC = 'S' then
       begin
         L := L + 1;
         MoveParaArrayB(L);
       end
       else L := 7;
  Until L = 7;
  Repeat
    Window(10,13,69,21);
    For I := 1 to 7 do begin
                          If KArray[I] <> '' then
                             begin
                               If I = Sx then Color(Tfn,Utx)
                                         else Color(Sfn,Stx);
                               GotoXY(1,I);
                               Writeln(' ',PushLeft(16,KArray[I]),
                                           PushLeft(42,NArray[I]));
                               Color(Sfn,Stx);
                             end;
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
                                RC   := 'N';
                                BBNo := LimpaChave(KArray[1]);
                                SearchAnt7 ( Root7 );
                                If RC = 'S' then
                                   begin
                                     For I := 7 downto 2
                                     do ArrayParaArrayB((I - 1),I);
                                     MoveParaArrayB(1);
                                     F := 'N';
                                     N := N + 1;
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
                                BBNo := LimpaChave(KArray[R]);
                                RC   := 'N';
                                SearchPos7 ( Root7 );
                                If RC = 'S' then
                                   begin
                                     For I := 2 to 7
                                     do ArrayParaArrayB(I,(I - 1));
                                     MoveParaArrayB(R);
                                     N := N + 1;
                                     F := 'N';
                                   end
                                   else F := 'P';
                              Until (N = 7) or (RC = 'N');
                              If Tkb = 'P' then F := 'N';
                            end;
                  end;
    end;
    If ((F <> 'N') or (N < 7)) and (Cont in [#72,#73,#80,#81]) then ScrollFim;
  Until Cont in [#13,#27];
  Move(ScArrayS[1],Mem[$B800:0000],4000);
  Color(Tfn,Utx);
  If Cont = #13 then
     begin
       BBAN := RArray[Sx];
       BBAC := KArray[Sx];
     end;
end;


Procedure UpdateBanco;
begin
  Repeat
    J := '';
    InputStr(J,10,12,9,0,'S','N','T','N',Tfn,Utx);
    LimpaLn(24,Tfd);
    Case TC of
         #13 : begin
                 BBNo := LimpaChave(J);
                 SearchTree7 ( Root7 );
                 If RC = 'N' then
                    begin
                      If XSt = 'A' then
                         begin
                           BBNumber := FileSize(BBFile);
                           IncluiBanco;
                         end
                         else BBNumber := Limite;
                    end;
               end;
         #25 : begin
                 BBNo := '';
                 RC   := 'N';
                 SearchPos7 ( Root7 );
                 If RC = 'N' then BBNumber := Limite;
               end;
         #27 : BBNumber := Limite;
         else  BBNumber := Limite;
    end;
    If BBNumber <> Limite then
       With BBMember do
       begin
         Repeat
           Repeat
             DataMstr('B');
             Resp := ReadKey;
             LimpaLn(24,Tfd);
             If (Resp = #0) and (KeyPressed) then
                begin
                  Resp := ReadKey;
                  Case Resp of
                       #59 : begin
                               BBAC := BBNo;
                               BBAN := BBNumber;
                               ScrollBanco;
                               BBNumber := BBAN;
                               BBNo     := BBAC;
                             end;
                       #61 : If XSt = 'A' then
                                begin
                                  Op := 'A';
                                  EntryBanco;
                                  If TC = 'S' then ReadWrite(#06,'W','N',BBNumber);
                                end;
                       #72 : begin
                               RC := 'N';
                               SearchAnt7 ( Root7 );
                               If RC = 'N' then AvisoFinal;
                             end;
                       #80 : begin
                               RC := 'N';
                               SearchPos7 ( Root7 );
                               If RC = 'N' then AvisoFinal;
                             end;
                       #94 : HelpManual;
                  end;
                end;
           Until (Resp in [#13,#27]) or ((Resp in [#72,#80]) and (RC <> 'N'));
           Move(ScArray4[1],Mem[$B800:0000],4000);
         Until Resp in [#13,#27];
         TC := Resp;
       end;
  Until TC = #27;
end;


Procedure EntryDept;
begin
  Repeat
    K := 1;
    Repeat
      Case K of
           1   : With DDMember do
                 begin
                   Move(Mem[$B800:0000],ScArray5[1],4000);
                   DrawBox(36,14,55,17,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(36,15); Write('       tivo         ');
                   GotoXY(36,16); Write('       ancelado     ');
                   Color(Red,White);
                   GotoXY(42,15); Write('A');
                   GotoXY(42,16); Write('C');
                   J := Status;
                   InputStr(J,1,48,09,0,'S','N','T','N',Tfn,Utx);
                   Status := UpCase(J[1]);
                   If J = ' ' then Status := 'A';
                   If (TC     <> #27) and
                      (Status <> 'A') and
                      (Status <> 'C') then
                      begin
                        ErroMsg := 'Informe A ou C';
                        ErrorMessage;
                        K := K - 1;
                      end;
                   Op := 'A';
                   Move(ScArray5[1],Mem[$B800:0000],4000);
                   GotoXY(48,09); Case Status of
                                       'A' : Write('Ativo     ');
                                       'C' : Write('Cancelado ');
                                       else  Write(Status);
                                  end;
                 end;
           2   : With DDMember do
                 begin
                   J := Descricao;
                   InputStr(J,40,12,10,0,'S','S','T','N',Tfn,Utx);
                   Descricao := J;
                   If (TC        <> #27) and
                      (Descricao =  '' ) then
                      begin
                        ErroMsg := 'Informe o Nome do Departamento';
                        ErrorMessage;
                        K := K - 1;
                      end;
                 end;
           3   : With DDMember do
                 begin
                   Move(Mem[$B800:0000],ScArray5[1],4000);
                   DrawBox(36,14,55,18,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(36,15); Write(' N§ de dias £teis a ');
                   GotoXY(36,16); Write(' considerar no calc.');
                   GotoXY(36,17); Write(' do VT mˆs corrente ');
                   If Dias1 = 0 then J := ''
                                else begin
                                       Str(Dias1:2,J);
                                       J := LeftAdjust(J);
                                     end;
                   InputStr(J,2,29,12,0,'S','S','T','N',Tfn,Utx);
                   Val(J,Dias1,E);
                   Move(ScArray5[1],Mem[$B800:0000],4000);
                   GotoXY(29,12); Write(Dias1:2);
                 end;
           4   : With DDMember do
                 begin
                   Move(Mem[$B800:0000],ScArray5[1],4000);
                   DrawBox(36,14,55,18,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(36,15); Write(' N§ de dias £teis a ');
                   GotoXY(36,16); Write(' considerar no calc.');
                   GotoXY(36,17); Write(' do VT pr¢ximo mˆs. ');
                   If Dias2 = 0 then J := ''
                                else begin
                                       Str(Dias2:2,J);
                                       J := LeftAdjust(J);
                                     end;
                   InputStr(J,2,29,13,0,'S','S','T','N',Tfn,Utx);
                   Val(J,Dias2,E);
                   Move(ScArray5[1],Mem[$B800:0000],4000);
                   GotoXY(29,13); Write(Dias2:2);
                 end;
           5   : With DDMember do
                 begin
                   Move(Mem[$B800:0000],ScArray5[1],4000);
                   DrawBox(36,14,55,18,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(36,15); Write(' N§ de dias £teis a ');
                   GotoXY(36,16); Write(' considerar no calc.');
                   GotoXY(36,17); Write(' do Ad. 1§ quinzena ');
                   If DiasQ1 = 0 then J := ''
                                 else begin
                                        Str(DiasQ1:2,J);
                                        J := LeftAdjust(J);
                                      end;
                   InputStr(J,2,29,14,0,'S','S','T','N',Tfn,Utx);
                   Val(J,DiasQ1,E);
                   Move(ScArray5[1],Mem[$B800:0000],4000);
                   GotoXY(29,14); Write(DiasQ1:2);
                 end;
           6   : With DDMember do
                 begin
                   Move(Mem[$B800:0000],ScArray5[1],4000);
                   DrawBox(36,14,55,18,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(36,15); Write(' N§ de dias £teis a ');
                   GotoXY(36,16); Write(' considerar no calc.');
                   GotoXY(36,17); Write(' do Ad. 2§ quinzena ');
                   If DiasQ2 = 0 then J := ''
                                 else begin
                                        Str(DiasQ2:2,J);
                                        J := LeftAdjust(J);
                                      end;
                   InputStr(J,2,29,15,0,'S','S','T','N',Tfn,Utx);
                   Val(J,DiasQ2,E);
                   Move(ScArray5[1],Mem[$B800:0000],4000);
                   GotoXY(29,15); Write(DiasQ2:2);
                 end;
           7   : With DDMember do
                 begin
                   J := Endereco;
                   InputStr(J,40,14,17,0,'S','S','T','N',Tfn,Utx);
                   Endereco := J;
                 end;
           8   : With DDMember do
                 begin
                   J := Cidade;
                   InputStr(J,20,14,18,0,'S','S','T','N',Tfn,Utx);
                   Cidade := J;
                 end;
           9   : With DDMember do
                 begin
                   J := Estado;
                   InputStr(J,2,50,18,0,'S','N','T','N',Tfn,Utx);
                   Estado := UpCaseStr(J);
                   GotoXY(50,18); Write(Estado);
                   If (Estado <> '') and (TC <> #27) then
                      begin
                        CheckUF(Estado);
                        If R = 1 then
                           begin
                             ErroMsg := 'Sigla do Estado Inv lida';
                             ErrorMessage;
                             K := K - 1;
                           end;
                      end;
                 end;
           10  : With DDMember do
                 begin
                   J := Cep;
                   InputStr(J,9,14,19,0,'S','N','T','N',Tfn,Utx);
                   Cep := J;
                 end;
           11  : With DDMember do
                 begin
                   J := DDD;
                   InputStr(J,4,35,19,0,'S','N','T','N',Tfn,Utx);
                   DDD := J;
                 end;
           12  : With DDMember do
                 begin
                   J := Telefone;
                   InputStr(J,8,50,19,0,'S','N','T','N',Tfn,Utx);
                   Telefone := J;
                 end;
           13  : With DDMember do
                 begin
                   J := GRPSTipo;
                   InputStr(J,1,14,20,0,'S','N','T','N',Tfn,Utx);
                   GRPSTipo := J[1];
                 end;
           14  : With DDMember do
                 begin
                   J := GRPSIdent;
                   InputStr(J,20,16,20,0,'S','N','T','N',Tfn,Utx);
                   GRPSIdent := J;
                 end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1
                          else K := 13;
      end;
    Until (K = 15) or (TC = #27);
    If ((TC <> #27) and (Op = 'I')) or (Op = 'A') then Confirma;
  Until TC in ['S',#27];
end;


Procedure IncluiDept;
begin
  With DDMember do
  begin
    Op          := 'I';
    Codigo      := DDNo;
    Status      := 'A';
    Descricao   := '';
    Dias1       := 0;
    Dias2       := 0;
    DiasQ1      := 0;
    DiasQ2      := 0;
    Endereco    := '';
    Cidade      := '';
    Estado      := '';
    Cep         := '';
    DDD         := '';
    Telefone    := '';
    GRPSTipo    := ' ';
    GRPSIdent   := '';
    Marca       := ' ';
    EntryDept;
    Move(ScArray4[1],Mem[$B800:0000],4000);
    If TC = 'S' then
       begin
         D3 := 'S';
         ReadWrite(#05,'W','N',DDNumber);
         LoadTree3 ( Root3 );
         CMstMember.NDepto := CMstMember.NDepto + 1;
         ReadWrite(#16,'W','N',0);
         ShowHeap;
         Color(Red,Yellow);
         GotoXY(53,7); Write(CMstMember.NDepto);
         Color(Tfn,Utx);
         Move(Mem[$B800:0000],ScArray4[1],4000);
       end
       else begin
              DDNumber := Limite;
              TC       := #13;
            end;
  end;
end;


Procedure MoveParaArrayD(L : Integer);
begin
  ReadWrite(#05,'R','N',DDNumber);
  If RW = 'S' then
     begin
       KArray[L] := DDMember.Codigo;
       RArray[L] := DDNumber;
       NArray[L] := DDMember.Descricao;
       TArray[L] := DDMember.Marca;
     end;
end;


Procedure ArrayParaArrayD(D,P : Integer);
begin
  KArray[P]  := KArray[D];
  RArray[P]  := RArray[D];
  NArray[P]  := NArray[D];
  TArray[P]  := TArray[D];
end;


Procedure ScrollDept(X : Char);
Var
   ScArrayS       : Array [1..4000] of Char;
begin
  Move(Mem[$B800:0000],ScArrayS[1],4000);
  FootScroll;
  Case X of
       'N' : DrawBox(10,11,68,20,Sfn,'S');
       'X' : DrawBox(10,11,69,20,Sfn,'S');
  end;
  Color(Bfn,Btx);
  GotoXY(10,11);
  Case X of
       'N' : Write(' C¢digo          Nome do Departamento                      ');
       'X' : Write(' C¢digo          Nome do Departamento                     ',#25,' ');
  end;
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
                       TArray[I] := ' ';
                     end;
  RC := 'N';
  SearchAnt3 ( Root3 );
  If RC = 'N' then DDNo := '';
  Repeat
    RC := 'N';
    SearchPos3 ( Root3 );
    If RC = 'S' then
       begin
         L := L + 1;
         MoveParaArrayD(L);
       end
       else L := 7;
  Until L = 7;
  Repeat
    Case X of
         'N' : Window(10,13,69,20);
         'X' : Window(10,13,70,20);
    end;
    For I := 1 to 7 do begin
                          If KArray[I] <> '' then
                             begin
                               If I = Sx then Color(Tfn,Utx)
                                         else Color(Sfn,Stx);
                               GotoXY(1,I);
                               Case X of
                                    'N' : Writeln(' ',PushLeft(16,KArray[I]),
                                                      PushLeft(42,NArray[I]));
                                    'X' : Writeln(' ',PushLeft(16,KArray[I]),
                                                      PushLeft(41,NArray[I]),
                                                      PushLeft(2,TArray[I]));
                               end;
                               Color(Sfn,Stx);
                             end;
                       end;
    Window(1,1,80,25);
    Cont := ReadKey;
    If (Cont = #0 ) and
       (KeyPressed) then ScrollDir
       else If (X = 'X') and (Cont = #13) then
               begin
                 Case TArray[Sx] of
                      #004 : TArray[Sx] := ' ';
                      ' '  : TArray[Sx] := #004;
                 end;
                 Cont    := #00;
                 Direcao := 'N';
                 ReadWrite(#05,'R','N',RArray[Sx]);
                 DDMember.Marca := TArray[Sx];
                 ReadWrite(#05,'W','N',RArray[Sx]);
               end
               else If Cont in [#13,#27] then Direcao := 'N';
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
                                RC   := 'N';
                                DDNo := KArray[1];
                                SearchAnt3 ( Root3 );
                                If RC = 'S' then
                                   begin
                                     For I := 7 downto 2
                                     do ArrayParaArrayD((I - 1),I);
                                     MoveParaArrayD(1);
                                     F := 'N';
                                     N := N + 1;
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
                                DDNo := KArray[R];
                                RC   := 'N';
                                SearchPos3 ( Root3 );
                                If RC = 'S' then
                                   begin
                                     For I := 2 to 7
                                     do ArrayParaArrayD(I,(I - 1));
                                     MoveParaArrayD(R);
                                     N := N + 1;
                                     F := 'N';
                                   end
                                   else F := 'P';
                              Until (N = 7) or (RC = 'N');
                              If Tkb = 'P' then F := 'N';
                            end;
                  end;
    end;
    If ((F <> 'N') or (N < 7)) and (Cont in [#72,#73,#80,#81]) then ScrollFim;
  Until Cont in [#13,#27];
  Move(ScArrayS[1],Mem[$B800:0000],4000);
  Color(Tfn,Utx);
  If Cont = #13 then
     begin
       DDAN := RArray[Sx];
       DDAC := KArray[Sx];
     end;
end;


Procedure UpdateDept;
begin
  Repeat
    J := '';
    InputStr(J,10,12,9,0,'S','N','T','N',Tfn,Utx);
    LimpaLn(24,Tfd);
    Case TC of
         #13 : begin
                 DDNo := J;
                 SearchTree3 ( Root3 );
                 If RC = 'N' then
                    begin
                      If XSt = 'A' then
                         begin
                           DDNumber := FileSize(DDFile);
                           IncluiDept;
                         end
                         else DDNumber := Limite;
                    end;
               end;
         #25 : begin
                 DDNo := '';
                 RC   := 'N';
                 SearchPos3 ( Root3 );
                 If RC = 'N' then DDNumber := Limite;
               end;
         #27 : DDNumber := Limite;
         else  DDNumber := Limite;
    end;
    If DDNumber <> Limite then
       With DDMember do
       begin
         Repeat
           Repeat
             DataMstr('D');
             Resp := ReadKey;
             LimpaLn(24,Tfd);
             If (Resp = #0) and (KeyPressed) then
                begin
                  Resp := ReadKey;
                  Case Resp of
                       #59 : begin
                               DDAC := DDNo;
                               DDAN := DDNumber;
                               ScrollDept('N');
                               DDNumber := DDAN;
                               DDNo     := DDAC;
                             end;
                       #61 : If XSt = 'A' then
                                begin
                                  Op := 'A';
                                  EntryDept;
                                  If TC = 'S' then ReadWrite(#05,'W','N',DDNumber);
                                end;
                       #63 : If XSt = 'A' then
                                begin
                                  DDAC := DDNo;
                                  DDAN := DDNumber;
                                  ScrollDept('X');
                                  DDNumber := DDAN;
                                  DDNo     := DDAC;
                                end;
                       #72 : begin
                               RC := 'N';
                               SearchAnt3 ( Root3 );
                               If RC = 'N' then AvisoFinal;
                             end;
                       #80 : begin
                               RC := 'N';
                               SearchPos3 ( Root3 );
                               If RC = 'N' then AvisoFinal;
                             end;
                       #94 : HelpManual;
                  end;
                end;
           Until (Resp in [#13,#27]) or ((Resp in [#72,#80]) and (RC <> 'N'));
           Move(ScArray4[1],Mem[$B800:0000],4000);
         Until Resp in [#13,#27];
         TC := Resp;
       end;
  Until TC = #27;
end;



{$I PlogCnta.inc }


Procedure UpdateConta(X : Char);
begin
  Repeat
    J := '';
    InputStr(J,3,12,9,0,'S','N','T','N',Tfn,Utx);
    LimpaLn(24,Tfd);
    Case TC of
         #13 : begin
                 CCNo := J;
                 SearchTree1 ( Root1 );
                 If RC = 'N' then
                    begin
                      If X = 'M' then
                         begin
                           CCNumber := FileSize(CCFile);
                           IncluiConta;
                         end
                         else CCNumber := Limite;
                    end;
               end;
         #25 : begin
                 CCNo := '';
                 RC   := 'N';
                 SearchPos1 ( Root1 );
                 If RC = 'N' then CCNumber := Limite;
               end;
         #27 : CCNumber := Limite;
         else  CCNumber := Limite;
    end;
    If CCNumber <> Limite then
       With CCMember do
       begin
         Repeat
           Repeat
             DataMstr('C');
             Resp := ReadKey;
             LimpaLn(24,Tfd);
             If (Resp = #0) and (KeyPressed) then
                begin
                  Resp := ReadKey;
                  Case Resp of
                       #59 : begin
                               CCAC := CCNo;
                               CCAN := CCNumber;
                               ScrollConta;
                               CCNumber := CCAN;
                               CCNo     := CCAC;
                             end;
                       #61 : If X = 'M' then
                                begin
                                  Op := 'A';
                                  EntryConta;
                                  If TC = 'S' then ReadWrite(#04,'W','N',CCNumber);
                                end;
                       #63 : If X = 'M' then
                                begin
                                  DataCalculos('S');
                                  Repeat
                                    TC := ReadKey;
                                    If KeyPressed then
                                       begin
                                         TC := ReadKey;
                                         If TC = #61 then
                                            begin
                                              EntryCalculos;
                                              If TC = 'S' then
                                                 begin
                                                   For I := 1 to 2
                                                   do If Resultado[I] = '' then
                                                         begin
                                                           Conteudo[I]  := ' ';
                                                           Operador[I]  := ' ';
                                                           Operando[I]  := '';
                                                           SubAdic[I]   := ' ';
                                                         end;
                                                   ReadWrite(#04,'W','N',CCNumber);
                                                 end
                                                 else ReadWrite(#04,'R','N',CCNumber);
                                            end
                                            else TC := #00;
                                       end
                                       else If TC <> #27 then TC := #00;
                                  Until TC in ['S',#27];
                                  Move(ScArray5[1],Mem[$B800:0000],4000);
                                end
                                else begin
                                       DataCalculos('N');
                                       Repeat
                                         TC := ReadKey;
                                       Until TC = #27;
                                       Move(ScArray5[1],Mem[$B800:0000],4000);
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
           Until (Resp in [#13,#27]) or ((Resp in [#72,#80]) and (RC <> 'N'));
           Move(ScArray4[1],Mem[$B800:0000],4000);
         Until Resp in [#13,#27];
         TC := Resp;
       end;
  Until TC = #27;
end;

Procedure TrocaChave;
Var
  HHAC      : Str20;
  HHAN      : Integer;
begin
  LoadMVDsk(#11);
  EEAC := EENo;
  EEAN := EENumber;
  Repeat
    Color(Red,White);
    GotoXY(01,24);  Write(ConstStr(' ',80));
    GotoXY(02,24);  Write('Troque os meses/anos anteriores tamb‚m !');
    RC := 'S';
    Repeat
      J := EENo;
      InputStr(J,8,12,9,0,'S','N','T','N',Tfn,Utx);
      LimpaLn(24,Tfd);
      If TC <> #27 then
         begin
           EENo := J;
           SearchTree5 ( Root5 );
           If RC = 'S' then
              begin
                ErroMsg := 'Matr¡cula j  Existe';
                ErrorMessage;
              end;
         end;
    Until (TC = #27) or (RC = 'N');
    If TC <> #27 then Confirma;
  Until (TC = #27) or (TC = 'S');
  If TC = 'S' then
     begin
       J        := EENo;
       EENo     := EEAC;
       EENumber := EEAN;
       DelTree5 ( Root5 );
       EENo     := J;
       EENumber := EEAN;
       LoadTree5 ( Root5 );
       EEMember.Matricula := EENo;
       ReadWrite(#08,'W','N',EENumber);
       ReadWrite(#09,'R','N',EENumber);
       HPMember.Empregado := EENo;
       ReadWrite(#09,'W','N',EENumber);
       D2 := 'S';
       UnLoadMVDsk;
       LiberaMVDsk;
       HHNo := EEAC + '#';
       Repeat
         RC := 'N';
         SearchPos10 ( Root10 );
         If (RC   = 'S'                      ) and
            (EEAC = Copy(HHNo,1,Length(EEAC))) then
            begin
              HHAC := HHNo;
              HHAN := HHNumber;
              ReadWrite(#10,'R','N',HHNumber);
              If HHMember.Tipo <> '*' then
                 begin
                   HHMember.Empregado := EENo;
                   HHNo := HHMember.Empregado + '#' +
                           HHMember.Data      + '#' + HHMember.Tipo;
                   HHNumber := FileSize(HHFile);
                   LoadTree10 ( Root10 );
                   ReadWrite(#10,'W','N',HHNumber);
                   ReadWrite(#10,'R','N',HHAN);
                   HHMember.Tipo := '*';
                   ReadWrite(#10,'W','N',HHAN);
                 end;
              HHNo := HHAC;
            end
            else RC := 'N';
       Until RC = 'N';
       D3 := 'S';
     end;
  LimpaLn(24,Tfd);
end;

Procedure MoveParaArrayO(L : Integer);
begin
  ReadWrite(#19,'R','N',OONumber);
  If RW = 'S' then
     begin
       KArray[L] := OOMember.NumeroOS;
       RArray[L] := OONumber;
       VArray[L] := EditReal(OOMember.ValorOS);
       AArray[L] := OOMember.ContaOS;
       NArray[L] := OOMember.DescricaoOS;
     end;
end;


Procedure ArrayParaArrayO(D,P : Integer);
begin
  KArray[P]  := KArray[D];
  RArray[P]  := RArray[D];
  VArray[P]  := VArray[D];
  AArray[P]  := AArray[D];
  NArray[P]  := NArray[D];
end;


Procedure OrdemServ;
Var
   ScArrayS       : Array [1..4000] of Char;
begin
  Move(Mem[$B800:0000],ScArrayS[1],4000);
  FootScroll;
  DrawBox(10,11,57,20,Bfn,'S');
  Color(Sfn,Stx);
  GotoXY(10,11);
  Write(' N£mero          Valor Cta Descri‡„o            ');
  Color(Bfn,Btx);
  Tkb     := 'L';
  F       := 'N';
  Direcao := 'P';
  L       := 0;
  Sx      := 1;
  For I := 1 to 7 do begin
                       KArray[I] := '';
                       RArray[I] := 0;
                       VArray[I] := '';
                       AArray[I] := '';
                       NArray[I] := '';
                     end;
  OONo := EENo;
  Repeat
    RC := 'N';
    SearchPos8 ( Root8 );
    If (RC = 'S') and
       (Copy(OONo,1,Length(EENo)) = EENo) then
       begin
         L := L + 1;
         MoveParaArrayO(L);
       end
       else L := 7;
  Until L = 7;
  Repeat
    Window(10,13,58,20);
    For I := 1 to 7 do begin
                          If KArray[I] <> '' then
                             begin
                               If I = Sx then Color(Tfn,Utx)
                                         else Color(Bfn,Btx);
                               GotoXY(1,I);
                               Writeln(' ',PushLeft(9,KArray[I]),
                                           PushRight(12,VArray[I]),' ',
                                           PushLeft(4,AArray[I]),
                                           PushLeft(21,NArray[I]));
                               Color(Bfn,Btx);
                             end;
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
                                RC   := 'N';
                                OONo := KArray[1];
                                SearchAnt8 ( Root8 );
                                If (RC = 'S') and
                                   (Copy(OONo,1,Length(EENo)) = EENo) then
                                   begin
                                     For I := 7 downto 2
                                     do ArrayParaArrayO((I - 1),I);
                                     MoveParaArrayO(1);
                                     F := 'N';
                                     N := N + 1;
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
                                OONo := KArray[R];
                                RC   := 'N';
                                SearchPos8 ( Root8 );
                                If (RC = 'S') and
                                   (Copy(OONo,1,Length(EENo)) = EENo) then
                                   begin
                                     For I := 2 to 7
                                     do ArrayParaArrayO(I,(I - 1));
                                     MoveParaArrayO(R);
                                     N := N + 1;
                                     F := 'N';
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
  Move(ScArrayS[1],Mem[$B800:0000],4000);
  Color(Tfn,Utx);
  Cont := #00;
  TC := #00;
end;


end.

