Procedure ZeraArray(I : Integer);
begin
  KArray[I]  := '';
  DArray[I]  := '';
  TArray[I]  := ' ';
  H1Array[I] := '';
  M1Array[I] := '';
  VArray[I]  := '';
  AArray[I]  := '';
  PArray[I]  := '';
  XArray[I]  := '';
  BArray[I]  := ' ';
  OArray[I]  := ' ';
end;


Procedure MoveParaArray(X : Char;
                        L : Integer);
begin
  CCNo := YYNo;
  SearchTree1 ( Root1 );
  If RC = 'S' then ReadWrite(#04,'R','N',CCNumber)
     else begin
            CCMember.Descricao := '** NÆo encontrei a Conta **';
            CCMember.Tipo      := '*';
            RC                 := 'S';
          end;
  KArray[L] := YYNo;
  DArray[L] := CCMember.Descricao;
  TArray[L] := CCMember.Tipo;

  Case X of
       'A'     : begin
                   Str(YAddress^.AcAnualH,H1Array[L]);
                   Str(YAddress^.AcAnualM,M1Array[L]);
                   If YAddress^.AcAnualM < 10
                      then M1Array[L] := '0' + M1Array[L];
                   AArray[L] := EditReal(YAddress^.AcAnualV);
                 end;
       'M','R' : begin
                   Str(YAddress^.AcMensalH,H1Array[L]);
                   M1Array[L] := QQStr(YAddress^.AcMensalM,2,'0');
                   VArray[L]  := EditReal(YAddress^.AcMensalV);
                   Str(YAddress^.Parcelas:2,PArray[L]);
                   XArray[L] := EditReal(YAddress^.PerctUsr);
                   BArray[L] := YAddress^.BaseUsr;
                   OArray[L] := YAddress^.Origem;
                 end;
  end;
end;


Procedure ArrayParaArray(D,P : Integer);
begin
  KArray[P]  := KArray[D];
  DArray[P]  := DArray[D];
  TArray[P]  := TArray[D];
  H1Array[P] := H1Array[D];
  M1Array[P] := M1Array[D];
  VArray[P]  := VArray[D];
  AArray[P]  := AArray[D];
  PArray[P]  := PArray[D];
  XArray[P]  := XArray[D];
  BArray[P]  := BArray[D];
  OArray[P]  := OArray[D];
end;


Procedure MontaJanela(X : Char);
begin
  Case X of
       'A'     : Window(11,13,77,20);
       'M','R' : Window(02,13,77,20);
  end;
end;


Procedure ListaConteudo(X : Char);
begin
  For I := 1 to 7 do
  begin
    If I = Sx then Color(Tfn,Utx)
	      else Color(Sfn,Stx);
    GotoXY(1,I);
    If KArray[I] <> '' then
       begin
         Case X of
              'A'     : Writeln(' ',PushLeft(4,KArray[I]),
                                PushLeft(31,DArray[I]),
                                TArray[I],'  ',
                                H1Array[I]:4,':',M1Array[I]:2,' ',
                                AArray[I]:18,' ');
              'M','R' : Writeln(' ',PushLeft(4,KArray[I]),
                                PushLeft(31,DArray[I]),
                                TArray[I],' ',H1Array[I]:4,':',M1Array[I]:2,' ',
                                VArray[I]:14,' ',PArray[I]:2,' ',
                                XArray[I]:6,' ',BArray[I]:1,' ',
                                OArray[I]:1,' ');
         end;
       end
       else Case X of
                 'A'     : Write(ConstStr(' ',66));
                 'M','R' : Write(ConstStr(' ',75));
            end;
  end;
end;


Procedure AlteraConteudo(X : Char);
begin
  I := 1;
  Case X of
       'A' : Repeat
               Case I of
                    1 : begin
                          Str(YAddress^.AcAnualH,J);
                          J := LeftAdjust(J);
                          InputStr(J,4,40,Sx,0,'S','N','T','N',Tfn,Utx);
                          Val(J,YAddress^.AcAnualH,E);
                        end;
                    2 : begin
                          Str(YAddress^.AcAnualM,J);
                          J := LeftAdjust(J);
                          InputStr(J,2,45,Sx,0,'S','N','T','N',Tfn,Utx);
                          Val(J,YAddress^.AcAnualM,E);
                        end;
                    3 : begin
                          Str(YAddress^.AcAnualV:17:2,J);
                          J := LeftAdjust(J);
                          InputStr(J,17,49,Sx,0,'S','N','$','N',Tfn,Utx);
                          Val(J,YAddress^.AcAnualV,E);
                        end;
               end;
               Case TC of
                    #13 : I := I + 1;
                    #24 : If I > 1 then I := I - 1;
               end;
             Until (I = 4) or (TC = #27);
       'M','R' : Repeat
                   Case I of
                    1 : begin
                          Str(YAddress^.AcMensalH,J);
                          J := LeftAdjust(J);
                          InputStr(J,4,39,Sx,0,'S','N','T','N',Tfn,Utx);
                          Val(J,YAddress^.AcMensalH,E);
                        end;
                    2 : begin
                          Str(YAddress^.AcMensalM,J);
                          J := LeftAdjust(J);
                          InputStr(J,2,44,Sx,0,'S','N','T','N',Tfn,Utx);
                          Val(J,YAddress^.AcMensalM,E);
                        end;
                    3 : begin
                          Str(YAddress^.AcMensalV:14:2,J);
                          J := LeftAdjust(J);
                          InputStr(J,14,47,Sx,0,'S','N','$','N',Tfn,Utx);
                          Val(J,YAddress^.AcMensalV,E);
                        end;
                    4 : begin
                          Str(YAddress^.Parcelas,J);
                          J := LeftAdjust(J);
                          InputStr(J,2,62,Sx,0,'S','N','N','N',Tfn,Utx);
                          Val(J,YAddress^.Parcelas,E);
                        end;
                    5 : begin
                          Str(YAddress^.PerctUsr:6:2,J);
                          J := LeftAdjust(J);
                          InputStr(J,6,65,Sx,0,'S','N','$','N',Tfn,Utx);
                          Val(J,YAddress^.PerctUsr,E);
                        end;
                    6 : begin
                          J := YAddress^.BaseUsr;
                          InputStr(J,1,72,Sx,0,'S','N','T','N',Tfn,Utx);
                          If J = '' then YAddress^.BaseUsr := ' '
                                    else YAddress^.BaseUsr := UpCase(J[1]);
                        end;
                    7 : Repeat
                          J := YAddress^.Origem;
                          InputStr(J,1,74,Sx,0,'S','N','T','N',Tfn,Utx);
                          YAddress^.Origem := UpCase(J[1]);
                        Until YAddress^.Origem in ['S','U'];
                   end;
                   Case TC of
                        #13 : I := I + 1;
                        #24 : If I > 1 then I := I - 1;
                   end;
                 Until (I = 8) or (TC = #27);
  end;
end;

Function VerificaS(X,T : Char;L1,L2 : Str3):Boolean;
begin
  CCNo := YYNo;
  SearchTree1 ( Root1 );
  If RC = 'S' then
     begin
       ReadWrite(#04,'R','N',CCNumber);
       If ((T  = 'T') or (CCMember.Tipo = T )) and
          ((X <> 'R') or (CCNo[1]       = X )) and
          ((L1 = '' ) or (CCNo         >= L1)) and
          ((L2 = '' ) or (CCNo         <= L2)) then VerificaS := true
                                               else VerificaS := False;
     end
     else VerificaS := False;
end;

Procedure CarregaPrimeiras(X,T : Char;L1,L2 : Str3);
begin
  For L := 1 to 7 do ZeraArray(L);
  L := 0;
  Repeat
    RC := 'N';
    SearchPosY ( RootY );
    If RC = 'S' then
       begin
         If VerificaS(X,T,L1,L2) = True then
            begin
              L := L + 1;
              MoveParaArray(X,L);
            end
            else RC := 'S';
       end
       else L := 7;
  Until L = 7;
end;


Procedure ScrollMovto(X,T : Char;L1,L2 : Str3);
Var
   ScArrayS       : Array [1..4000] of Char;
begin
  Move(Mem[$B800:0000],ScArrayS[1],4000);
  Color(Blue,White);
  GotoXY(01,23); Write(ConstStr(' ',80));
  GotoXY(02,23); Write(#25);
  GotoXY(04,23); Write('PgDn');
  GotoXY(21,23); Write(#24);
  GotoXY(23,23); Write('PgUp');
  GotoXY(41,23); Write('F1');
  GotoXY(56,23); Write('F3');
  GotoXY(71,23); Write('Esc');
  Color(Blue,Cyan);
  GotoXY(03,23); Write('/');
  GotoXY(09,23); Write(#26,' Pr¢xima');
  GotoXY(22,23); Write('/');
  GotoXY(28,23); Write(#26,' Anterior');
  GotoXY(44,23); Write(#26,' Incluir');
  GotoXY(59,23); Write(#26,' Alterar');
  GotoXY(75,23); Write(#26,' Fim');
  Color(Red,Stx);
  LimpaLn(24,Red);
  Case X of
       'A'     : DrawBox(11,11,76,20,Sfn,'S');
       'M','R' : DrawBox(02,11,76,20,Sfn,'S');
  end;
  Color(Bfn,Btx);
  Case X of
       'A'     : begin
                   GotoXY(11,11);
                   Write(' Cta Descri‡Æo                      T  Hora:Mn    Acumulado Anual ');
                 end;
       'M','R' : begin
                   GotoXY(02,11);
                   Write(' Cta Descri‡Æo                      T Hora:Mn   Valor do Mˆs N§ Perct. B ? ');
                 end;
  end;
  Color(Sfn,Stx);
  YYNo    := '';
  Tkb     := 'L';
  F       := 'N';
  Direcao := 'P';
  L       := 0;
  Sx      := 1;
  CarregaPrimeiras(X,T,L1,L2);
  Repeat
    MontaJanela(X);
    ListaConteudo(X);
    Window(1,1,80,25);
    Cont := ReadKey;
    If (Cont = #0 ) and
       (KeyPressed) then
       begin
         Cont := ReadKey;
         Case Cont of
              #59 : If (XSt = 'A'){ and (Sx > 1)} then
                       begin
                         If Sx < 7 then For I := 7 downto Sx + 1
                                        do ArrayParaArray((I - 1),I);
			 ZeraArray(Sx);
                         MontaJanela(X);
                         ListaConteudo(X);
                         YYNo := '';
			 Repeat
			   J := YYNo;
			   InputStr(J,3,2,Sx,0,'S','N','T','N',Tfn,Utx);
			   YYNo := J;
			   SearchTreeY ( RootY );
			 Until (RC = 'N') or (TC = #27);
                         If (TC <> #27) and (RC = 'N') then
                            begin
                              If VerificaS(X,T,L1,L2) = True then
                                 begin
                                   LoadTreeY ( RootY );
                                   YAddress^.Origem := 'U';
                                   MoveParaArray(X,Sx);
                                   ListaConteudo(X);
                                   AlteraConteudo(X);
                                   MoveParaArray(X,Sx);
                                 end
                                 else TC := #27;
                            end;
                            If TC = #27 then
                               begin
                                 Sx   := 1;
                                 YYNo := KArray[1];
                                 SearchAntY ( RootY );
                                 If RC = 'N' then YYNo := '';
                                 CarregaPrimeiras(X,T,L1,L2);
                                 ListaConteudo(X);
                               end;
                         Window(1,1,80,25);
                         Direcao := 'N';
                         Cont    := #00;
                         TC      := #00;
                       end;
              #61 : If XSt = 'A' then
                       begin
                         YYNo := KArray[Sx];
                         SearchTreeY ( RootY );
                         MontaJanela(X);
                         AlteraConteudo(X);
                         MoveParaArray(X,Sx);
                         Window(1,1,80,25);
                         Direcao := 'N';
                         Cont    := #00;
                         TC      := #00;
                       end;
              #72 : begin
                      Tkb     := 'L';
                      Direcao := 'A';
                      Color(Blue,White);
                      GotoXY(02,23); Write(#25);
                      GotoXY(04,23); Write('PgDn');
                      GotoXY(23,23); Write('PgUp');
                      Color(Blue,(White + Blink));
                      GotoXY(21,23); Write(#24);
                    end;
              #73 : begin
                      Tkb     := 'P';
                      Direcao := 'A';
                      Color(Blue,White);
                      GotoXY(02,23); Write(#25);
                      GotoXY(04,23); Write('PgDn');
                      GotoXY(21,23); Write(#24);
                      Color(Blue,(White + Blink));
                      GotoXY(23,23); Write('PgUp');
                    end;
              #80 : begin
                      Tkb     := 'L';
                      Direcao := 'P';
                      Color(Blue,(White + Blink));
                      GotoXY(02,23); Write(#25);
                      Color(Blue,White);
                      GotoXY(04,23); Write('PgDn');
                      GotoXY(21,23); Write(#24);
                      GotoXY(23,23); Write('PgUp');
                    end;
              #81 : begin
                      Tkb     := 'P';
                      Direcao := 'P';
                      Color(Blue,(White + Blink));
                      GotoXY(04,23); Write('PgDn');
                      Color(Blue,White);
                      GotoXY(02,23); Write(#25);
                      GotoXY(21,23); Write(#24);
                      GotoXY(23,23); Write('PgUp');
                    end;
              #84 : begin
                      OrdemServ;
                      Direcao := 'N';
                      Cont    := #00;
                      TC      := #00;
                    end;
              else Direcao := ' ';
         end;
       end
       else Direcao := 'N';
    LimpaLn(24,Red);
    N := 7;
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
                                YYNo := KArray[1];
                                SearchAntY ( RootY );
                                If RC = 'S' then
                                   begin
                                     If VerificaS(X,T,L1,L2) = True then
                                        begin
                                          For I := 7 downto 2
                                          do ArrayParaArray((I - 1),I);
                                          MoveParaArray(X,1);
                                          F := 'N';
                                          N := N + 1;
                                        end
                                        else begin
                                               RC := 'N';
                                               F  := 'A';
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
                                YYNo := KArray[R];
                                RC   := 'N';
                                SearchPosY ( RootY );
                                If RC = 'S' then
                                   begin
                                     If VerificaS(X,T,L1,L2) = True then
                                        begin
                                          For I := 2 to 7
                                          do ArrayParaArray(I,(I - 1));
                                          MoveParaArray(X,R);
                                          N := N + 1;
                                          F := 'N';
                                        end
                                        else begin
                                               RC := 'N';
                                               F  := 'P';
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
  Move(ScArrayS[1],Mem[$B800:0000],4000);
  Color(Tfn,Utx);
  RC := 'S';
end;


Procedure LCCheque(X,EtaX : Char);
Var
  Pto    : Char;
  Ho     : Str3;
  Xw,Yw  : Integer;
begin
  YYNo := '';
  Repeat
    RC := 'N';
    SearchPosY ( RootY );
    If RC = 'S' then
       begin
         CCNo := YYNo;
         SearchTree1 ( Root1 );
         If RC = 'S' then
            begin
              ReadWrite(#04,'R','N',CCNumber);
              If (CCMember.Tipo               = X                )  and
                 (TruncX(YAddress^.AcMensalV) > 0                )  and
                 ((CCMember.Operacao          = EtaX             )  or
                  ((CCNo                      > '100'           )   and
                   (CMstMember.Etapa          = 'P'             )   and
                   (CCMember.Operacao in ['1','2','3','4','A']  ))) then
                 begin
                   Ho  := '';
                   Mn  := '';
                   Pto := ' ';
                   If (YAddress^.AcMensalH > 0) or
                      (YAddress^.AcMensalM > 0) then
                      begin
                        Pto := ':';
                        Ho  := QQStr(YAddress^.AcMensalH,3,' ');
                        Mn  := QQStr(YAddress^.AcMensalM,2,'0');
                      end;
                   Case CCMember.Tipo of
                        'P' : begin
                                TProv := TProv + TruncX(YAddress^.AcMensalV);
                                Writeln(PushLeft(4,YYNo),CCMember.Descricao,
                                        ' ':31-Length(CCMember.Descricao),
                                        Ho:3,Pto,Mn:2,' ',
                                        EditReal(YAddress^.AcMensalV):14);
                              end;
                        'D' : begin
                                TDesc := TDesc + TruncX(YAddress^.AcMensalV);
                                Writeln(PushLeft(4,YYNo),CCMember.Descricao,
                                        ' ':31-Length(CCMember.Descricao),
                                        Ho:3,Pto,Mn:2,' ':16,
                                        EditReal(YAddress^.AcMensalV):14);
                              end;
                   end;
                   L := L + 1;
                 end;
            end
            else RC := 'S';
       end;
    If L = 14 then
       begin
         RC := 'N';
         SearchPosY ( RootY );
         If RC = 'S' then
            begin
              RC := 'N';
              SearchAntY ( RootY );
              Xw := WhereX;
              Yw := WhereY;
              Window(1,1,80,25);
              Color(Blue,Yellow);
              GotoXY(64,23); Write('Continua.');
              Color(Blue,Cyan);
              GotoXY(73,23); Write('<     >');
              Color(Blue,White);
              GotoXY(74,23); Write('Enter');
              Repeat
                TC := ReadKey;
              Until TC = #13;
              Color(Blue,Yellow);
              GotoXY(64,23); Write(ConstStr(' ',17));
              Window(3,6,74,20);
              Color(Tfn,Utx);
              GotoXY(Xw,Yw);
              L := 0;
            end;
       end;
  Until RC = 'N';
end;

Procedure ContraCheque(EtaX : Char);
Var
  Cvez   : Char;
  Xw,Yw  : Integer;
begin
  Cvez := 'S';
  DrawBox(2,5,74,21,Tfn,'S');
  Color(Bfn,Btx);
  GotoXY(2,5); Write(' C¢d Descri‡Æo da Conta             HHH:MM      ',
                     'Proventos      Descontos ');
  Color(Blue,White);
  GotoXY(01,23); Write(ConstStr(' ',80));
  Color(Red,Cyan);
  GotoXY(01,24); Write(ConstStr(' ',80));
  GotoXY(02,24); Write('Tecle <   > para Terminar ou use as setas <  > ',
                       'para ver o Pr¢ximo ou Anterior');
  Color(Red,White);
  GotoXY(09,24); Write('Esc');
  GotoXY(45,24); Write(#25,#24);
  Move(Mem[$B800:0000],ScArray5[1],4000);
    Repeat
    If Cvez = 'N' then
       begin
         RC := 'N';
         Case TC of
              #72 : SearchAnt5 ( Root5 );
              #80 : SearchPos5 ( Root5 );
         end;
         If RC = 'S' then
            begin
              ReadWrite(#08,'R','N',EENumber);
              Move(ScArray5[1],Mem[$B800:0000],4000);
            end;
       end
       else Cvez := 'N';
    If RC = 'S' then
       begin
         LoadMVDsk(#11);
         Color(Blue,White);
         GotoXY(02,23); Write(EEMember.Matricula,' ',
                              PushLeft(41,EEMember.Nome),
                              '( ',EEMember.Status,' )');
         GotoXY(64,23); Write(ConstStr(' ',17));
         L     := 0;
         TProv := 0;
         TDesc := 0;
         Color(Tfn,Utx);
         Window(3,6,74,20);
         GotoXY(1,1);
         LCCheque('P',EtaX);
         LCCheque('D',EtaX);
         LiberaMVDsk;
         Window(1,1,80,25);
         Color(Red,Yellow);
         GotoXY(02,20); Write(' Proventos & Descontos',' ':21,
                              EditReal(TProv):14,' ',
                              EditReal(TDesc):14,' ');
         Color(Red,White);
         GotoXY(02,21); Write(' L¡quido',' ':50,EditReal(TProv - TDesc):14,' ');
       end
       else If TC in [#72,#80] then
               begin
                 Color(Blue,White);
                 GotoXY(61,23); Write(#26);
                 Color(Blue,Yellow);
                 GotoXY(63,23); Write('Chegou ao final.');
               end;
    Repeat
      TC := ReadKey;
      If (TC = #0) and (KeyPressed) then TC := ReadKey;
    Until TC in [#27,#72,#80];
  Until TC = #27;
end;

Procedure MostraCheque;
Var
   EtaX     : Char;
begin
  TabI[1]  := ' Adiantamento quinzenal  ';
  TabI[2]  := ' Adiantamento 1§Semana   ';
  TabI[3]  := ' Adiantamento 2§Semana   ';
  TabI[4]  := ' Adiantamento 3§Semana   ';
  TabI[5]  := ' Adiantamento 4§Semana   ';
  TabI[6]  := ' Adiantamento 13§Sal rio ';
  TabI[7]  := ' Pagamento               ';
  TabI[8]  := ' Pagamento de 13§Sal rio ';
  TabI[9]  := ' Encerrar fun‡„o         ';
  TabX[1]  := 10;
  TabX[2]  := 10;
  TabX[3]  := 10;
  TabX[4]  := 10;
  TabX[5]  := 10;
  TabX[6]  := 10;
  TabX[7]  := 10;
  TabX[8]  := 10;
  TabX[9]  := 10;
  TabY[1]  := 10;
  TabY[2]  := 11;
  TabY[3]  := 12;
  TabY[4]  := 13;
  TabY[5]  := 14;
  TabY[6]  := 15;
  TabY[7]  := 16;
  TabY[8]  := 17;
  TabY[9]  := 18;
  Move(Mem[$B800:0000],ScArray6[1],4000);
  YY := 1;
  Repeat
    RetMenuAuxiliar(9,9,9,1,1);
    Case YY of
         1..8 : begin
                  Case YY of
                       1 : EtaX := 'A';
                       2 : EtaX := '1';
                       3 : EtaX := '2';
                       4 : EtaX := '3';
                       5 : EtaX := '4';
                       6 : EtaX := 'O';
                       7 : EtaX := 'P';
                       8 : EtaX := 'S';
                  end;
                  ContraCheque(EtaX);
                end;
         9    : Resp := #27;
    end;
  Until Resp = #27;
  Move(ScArray6[1],MemW[$B800:0000],4000);
  Resp := #80;
  TC   := #00;
  RC   := 'S';
end;


Procedure TrocaScreen;
begin
  Color(Red,White);
  For I := 7 to 17 do
  begin
    GotoXY(62,I); Write(' ':16);
  end;
  GotoXY(62,18); Write('F3 ');
  GotoXY(62,19); Write('Esc');
  Color(Red,Yellow);
  GotoXY(66,18); Write('Alterar     ');
  GotoXY(66,19); Write('Abandona    ');
  Shade(3,8,60,21,LightGray,Black);
end;


Procedure TrocaMedias;
begin
  TrocaScreen;
  DrawBox(31,12,67,15,Sfn,'S');
  Color(Sfn,Stx);
  GotoXY(32,13); Write('Horas p/F‚rias 1§per¡odo.: ',
                       PushRight(5,QQStr(EEMember.SomaHF1,5,' ')),':',
                       QQStr(EEMember.SomaMF1,2,'0'));
  GotoXY(32,14); Write('Horas p/F‚rias 2§per¡odo.: ',
                       PushRight(5,QQStr(EEMember.SomaHF2,5,' ')),':',
                       QQStr(EEMember.SomaMF2,2,'0'));
  Repeat
    TC := ReadKey;
    If (TC = #0) and (KeyPressed) then
       begin
         TC := ReadKey;
         If TC = #61 then
            begin
              Repeat
                K := 1;
                Repeat
                  Case K of
                       1 : begin
                             Str(EEMember.SomaHF1,J);
                             J := LeftAdjust(J);
                             InputStr(J,5,59,13,0,'S','N','T','N',Sfn,Stx);
                             Val(J,EEMember.SomaHF1,E);
                             GotoXY(59,13);
                             Write(PushRight(5,QQStr(EEMember.SomaHF1,5,' ')));
                           end;
                       2 : begin
                             Str(EEMember.SomaMF1,J);
                             J := LeftAdjust(J);
                             InputStr(J,2,65,13,0,'S','N','T','N',Sfn,Stx);
                             Val(J,EEMember.SomaMF1,E);
                             GotoXY(65,13); Write(QQStr(EEMember.SomaMF1,2,'0'));
                           end;
                       3 : begin
                             Str(EEMember.SomaHF2,J);
                             J := LeftAdjust(J);
                             InputStr(J,5,59,14,0,'S','N','T','N',Sfn,Stx);
                             Val(J,EEMember.SomaHF2,E);
                             GotoXY(59,14);
                             Write(PushRight(5,QQStr(EEMember.SomaHF2,5,' ')));
                           end;
                       4 : begin
                             Str(EEMember.SomaMF2,J);
                             J := LeftAdjust(J);
                             InputStr(J,2,65,14,0,'S','N','T','N',Sfn,Stx);
                             Val(J,EEMember.SomaMF2,E);
                             GotoXY(65,14); Write(QQStr(EEMember.SomaMF2,2,'0'));
                           end;
                  end;
                  Case TC of
                       #13 : K := K + 1;
                       #24 : If K > 1 then K := K - 1;
                  end;
                Until (TC = #27) or (K = 5);
                If TC <> #27 then Confirma;
              Until TC in ['S',#27];
            end
            else If TC <> #27 then TC := #13;
       end
       else If TC <> #27 then TC := #13;
  Until TC in [#27,'S'];
end;


Procedure TrocaCheque;
begin
  TrocaScreen;
  DrawBox(11,11,56,18,Sfn,'S');
  Color(Bfn,Btx);
  GotoXY(11,11); Write(' Etapa        Bco N§Cheque              Valor ');
  Color(Sfn,Stx);
  GotoXY(12,12); Write('1§Semana');
  GotoXY(12,13); Write('2§Semana');
  GotoXY(12,14); Write('3§Semana');
  GotoXY(12,15); Write('4§Semana');
  GotoXY(12,16); Write('Adiantamento');
  GotoXY(12,17); Write('13§ Sal rio');
  GotoXY(12,18); Write('Pagamento');
  For I := 1 to 7 do
  begin
    GotoXY(25,11+I); Write(PushLeft(4,EEMember.ChBco[I]),
                           PushLeft(9,EEMember.Cheque[I]),
                           PushRight(18,EditReal(EEMember.VChq[I])));
  end;
  Repeat
    TC := ReadKey;
    If (TC = #0) and (KeyPressed) then
       begin
         TC := ReadKey;
         If TC = #61 then
            begin
              Repeat
                K := 1;
                Repeat
                  Case K of
                       1..3   : I := 1;
                       4..6   : I := 2;
                       7..9   : I := 3;
                       10..12 : I := 4;
                       13..15 : I := 5;
                       16..18 : I := 6;
                       19..21 : I := 7;
                  end;
                  Case K of
                       1,4,7,10,13,16,19 : begin
                                             J := EEMember.ChBco[I];
                                             InputStr(J,3,25,11+I,0,'S','N','T','N',Sfn,Stx);
                                             EEMember.ChBco[I] := J;
                                           end;
                       2,5,8,11,14,17,20 : begin
                                             J := EEMember.Cheque[I];
                                             InputStr(J,8,29,11+I,0,'S','N','T','N',Sfn,Stx);
                                             EEMember.Cheque[I] := J;
                                           end;
                       3,6,9,12,15,18,21 : begin
                                            If EEMember.VChq[I] = 0 then J := ''
                                               else begin
                                                      Str(EEMember.VChq[I]:18:2,J);
                                                      J := LeftAdjust(J);
                                                    end;
                                            InputStr(J,18,38,11+I,0,'S','N','$','N',Sfn,Stx);
                                            Val(J,EEMember.VChq[I],E);
                                          end;
                  end;
                  Case TC of
                       #13 : K := K + 1;
                       #24 : If K > 1 then K := K - 1
                                      else K := 21;
                  end;
                Until (TC = #27) or (K = 22);
                If TC <> #27 then Confirma;
              Until TC in [#27,'S'];
            end
            else If TC <> #27 then TC := #13;
       end
       else If TC <> #27 then TC := #13;
  Until TC in [#27,'S'];
end;


Procedure MoveParaArrayH(L : Integer);
begin
  ReadWrite(#10,'R','N',HHNumber);
  If RW = 'S' then
     begin
       KArray[L] := HHNo;
       RArray[L] := HHNumber;
       DArray[L] := HHMember.OrigData;
       TArray[L] := HHMember.Tipo;
       NArray[L] := HHMember.Motivo;
       If HHMember.Tipo = 'S'
          then SArray[L] := EditReal(HHMember.Salario)
          else SArray[L] := '';
     end;
end;


Procedure ArrayParaArrayH(D,P : Integer);
begin
  KArray[P]  := KArray[D];
  RArray[P]  := RArray[D];
  DArray[P]  := DArray[D];
  TArray[P]  := TArray[D];
  NArray[P]  := NArray[D];
  SArray[P]  := SArray[D];
end;

Procedure ListaConteudoH;
begin
  Window(02,13,76,20);
  For I := 1 to 7 do
  begin
    If KArray[I] <> '' then
       begin
         If I = Sx then Color(Tfn,Utx)
                   else Color(Sfn,Stx);
         GotoXY(1,I);
         Writeln(' ',PushLeft(11,DArray[I]),PushLeft(51,NArray[I]),SArray[I]:10,' ');
         Color(Sfn,Stx);
       end;
  end;
  Window(1,1,80,25);
end;


Procedure AlteraConteudoH;
begin
  Window(02,13,75,20);
  J := NArray[Sx];
  InputStr(J,50,13,Sx,0,'S','S','T','N',Tfn,Utx);
  NArray[Sx]      := J;
  HHMember.Motivo := NArray[Sx];
  If TArray[Sx] = 'S' then
     begin
       Str(HHMember.Salario:12:2,J);
       J := LeftAdjust(J);
       InputStr(J,10,64,Sx,0,'S','N','$','N',Tfn,Utx);
       Val(J,HHMember.Salario,E);
       SArray[Sx] := EditReal(HHMember.Salario);
     end;
  Window(1,1,80,25);
end;


Procedure CarregaPrimeirasH;
begin
  Repeat
    RC := 'N';
    SearchPos10 ( Root10 );
    If (RC   = 'S'                      ) and
       (EENo = Copy(HHNo,1,Length(EENo))) then
       begin
         L := L + 1;
         MoveParaArrayH(L);
       end
       else L := 7;
  Until L = 7;
end;


Procedure ScrollHist;
Var
   ScArrayS       : Array [1..4000] of Char;
begin
  Move(Mem[$B800:0000],ScArrayS[1],4000);
  Color(Blue,White);
  GotoXY(01,23); Write(ConstStr(' ',80));
  GotoXY(02,23); Write(#25,' PgDn          ',#24,' PgUp           Esc      F1       F3      F5      F10');
  Color(Blue,Cyan);
  GotoXY(03,23); Write('/');
  GotoXY(08,23); Write(#26,'Pr¢xima');
  GotoXY(19,23); Write('/');
  GotoXY(24,23); Write(#26,'Anterior');
  GotoXY(38,23); Write(#26,'Fim');
  GotoXY(46,23); Write(#26,'Inc.');
  GotoXY(55,23); Write(#26,'Alt.');
  GotoXY(63,23); Write(#26,'Exc.');
  GotoXY(72,23); Write(#26,'Listar');
  Color(Red,Stx);
  LimpaLn(24,Red);
  DrawBox(2,11,75,20,Sfn,'S');
  Color(Bfn,Btx);
  GotoXY(02,11);
  Write(' DD/MM/AAAA Hist¢rico                                         ',
        '    Sal rio ');
  Color(Sfn,Stx);
  HHNo    := EENo + '#';
  Tkb     := 'L';
  F       := 'N';
  Direcao := 'P';
  L       := 0;
  Sx      := 1;
  For I := 1 to 7 do begin
                       KArray[I] := '';
                       RArray[I] := 0;
                       DArray[I] := '';
                       TArray[I] := ' ';
                       NArray[I] := '';
                       SArray[I] := '';
                     end;
  CarregaPrimeirasH;
  Repeat
    ListaConteudoH;
    Cont := ReadKey;
    If (Cont = #0 ) and
       (KeyPressed) then
       begin
         Cont := ReadKey;
         Case Cont of
              #59 : If (XSt = 'A') and (Sx > 0) then
                       begin
                         If Sx < 7 then For I := 7 downto Sx
                                        do ArrayParaArrayH((I - 1),I);
                         KArray[Sx] := 'X';
                         RArray[Sx] := 0;
                         DArray[Sx] := '';
                         TArray[Sx] := 'D';
                         NArray[Sx] := '';
                         SArray[Sx] := '';
                         HHMember.Empregado   := EENo;
                         HHMember.OrigData    := '';
                         HHMember.Tipo        := 'D';
                         HHMember.Salario     := 0;
                         HHMember.Motivo      := '';
                         ListaConteudoH;
                         Window(02,13,76,20);
                         J := '';
                         Repeat
                           InputStr(J,10,2,Sx,0,'S','N','D','S',Tfn,Utx);
                           HHMember.Data := Copy(J,7,4) +
                                            Copy(J,4,2) +
                                            Copy(J,1,2);
                           HHNo := HHMember.Empregado + '#' +
                                   HHMember.Data      + '#' + HHMember.Tipo;
			   SearchTree10 ( Root10 );
			 Until (RC = 'N') or (TC = #27);
                         If (TC <> #27) and (RC = 'N') then
                            begin
                              HHMember.OrigData := J;
                              HHNumber          := FileSize(HHFile);
                              KArray[Sx] := HHNo;
                              RArray[Sx] := HHNumber;
                              DArray[Sx] := J;
                              SArray[Sx] := '';
                              ListaConteudoH;
                              AlteraConteudoH;
                              LoadTree10 ( Root10 );
                              ReadWrite(#10,'W','N',RArray[Sx]);
                              D3 := 'S';
                            end
                            else begin
                                   HHNo := KArray[1];
                                   SearchAnt10 ( Root10 );
                                   If RC = 'N' then HHNo := '';
                                   CarregaPrimeirasH;
                                   ListaConteudoH;
                                 end;
                         Direcao := 'N';
                         Cont    := #00;
                         TC      := #00;
                       end;
              #61 : If XSt = 'A' then
                       begin
                         ReadWrite(#10,'R','N',RArray[Sx]);
                         If RW = 'S' then
                            begin
                              AlteraConteudoH;
                              ReadWrite(#10,'W','N',RArray[Sx]);
                              Direcao := 'N';
                              Cont    := #00;
                              TC      := #00;
                            end;
                       end;
              #63 : If XSt = 'A' then
                       begin
                         ReadWrite(#10,'R','N',RArray[Sx]);
                         If RW = 'S' then
                            begin
                              HHMember.Tipo    := '*';
                              HHMember.Motivo  := '';
                              HHMember.Salario := 0;
                              ReadWrite(#10,'W','N',RArray[Sx]);
                              TArray[Sx] := '*';
                              NArray[Sx] := '';
                              SArray[Sx] := '';
                              ListaConteudoH;
                              Direcao := 'N';
                              Cont    := #00;
                              TC      := #00;
                            end;
                       end;
              #68 : If XSt = 'A' then
                       begin
                         ReadWrite(#10,'R','N',RArray[Sx]);
                         If RW = 'S' then
                            begin
                              QPorta;
			      If TC <> #27 then
				 begin
                                   If Laser = 'S' then WriteLine('W',LaserInit);
				   If HHMember.Tipo = 'S' then
				      begin
                                        WriteLine('L',Cx+'Em '+HHMember.OrigData+
                                                      ' aumentado para '+
                                                      EditReal(HHMember.Salario)+Cf);
                                        WriteLine('L',Cx+Acentua(HHMember.Motivo)+Cf);
                                      end
                                      else begin
                                            WriteLine('L',Cx+'Em '+HHMember.OrigData+Cf);
                                            WriteLine('L',Cx+Acentua(HHMember.Motivo)+Cf);
                                          end;
                                   WriteLine('L',' ');
                                   Close ( LST );
                                 end;
                              LimpaLn(24,Red);
                              Direcao := 'N';
                              Cont    := #00;
                              TC      := #00;
                            end;
                       end;
              #72 : begin
                      Tkb     := 'L';
                      Direcao := 'A';
                      Color(Blue,White);
                      GotoXY(02,23); Write(#25);
                      GotoXY(04,23); Write('PgDn');
                      GotoXY(20,23); Write('PgUp');
                      Color(Blue,(White + Blink));
                      GotoXY(18,23); Write(#24);
                    end;
              #73 : begin
                      Tkb     := 'P';
                      Direcao := 'A';
                      Color(Blue,White);
                      GotoXY(02,23); Write(#25);
                      GotoXY(04,23); Write('PgDn');
                      GotoXY(18,23); Write(#24);
                      Color(Blue,(White + Blink));
                      GotoXY(20,23); Write('PgUp');
                    end;
              #80 : begin
                      Tkb     := 'L';
                      Direcao := 'P';
                      Color(Blue,(White + Blink));
                      GotoXY(02,23); Write(#25);
                      Color(Blue,White);
                      GotoXY(04,23); Write('PgDn');
                      GotoXY(18,23); Write(#24);
                      GotoXY(20,23); Write('PgUp');
                    end;
              #81 : begin
                      Tkb     := 'P';
                      Direcao := 'P';
                      Color(Blue,(White + Blink));
                      GotoXY(04,23); Write('PgDn');
                      Color(Blue,White);
                      GotoXY(02,23); Write(#25);
                      GotoXY(18,23); Write(#24);
                      GotoXY(20,23); Write('PgUp');
                    end;
              else Direcao := ' ';
         end;
       end
       else Direcao := 'N';
    LimpaLn(24,Red);
    N := 7;
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
                                HHNo := KArray[1];
                                SearchAnt10 ( Root10 );
                                If (RC   = 'S'                      ) and
                                   (EENo = Copy(HHNo,1,Length(EENo))) then
                                   begin
                                     For I := 7 downto 2
                                     do ArrayParaArrayH((I - 1),I);
                                     MoveParaArrayH(1);
                                     F := 'N';
                                     N := N + 1;
                                   end
                                   else F := 'A';
                              Until (N = 7) or (RC = 'N') or (F = 'A');
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
                                HHNo := KArray[R];
                                RC   := 'N';
                                SearchPos10 ( Root10 );
                                If (RC   = 'S'                      ) and
                                   (EENo = Copy(HHNo,1,Length(EENo))) then
                                   begin
                                     For I := 2 to 7
                                     do ArrayParaArrayH(I,(I - 1));
                                     MoveParaArrayH(R);
                                     N := N + 1;
                                     F := 'N';
                                   end
                                   else F := 'P';
                              Until (N = 7) or (RC = 'N') or (F = 'P');
                              If Tkb = 'P' then F := 'N';
                            end;
                  end;
    end;
    If ((F <> 'N') or (N < 7)) and (Cont in [#72,#73,#80,#81]) then ScrollFim;
  Until Cont = #27;
  Move(ScArrayS[1],Mem[$B800:0000],4000);
  Color(Tfn,Utx);
  RC := 'S';
end;


