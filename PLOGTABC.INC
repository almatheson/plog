Procedure TitleTabC;
begin
  Color(Tfn,Ttx);
  GotoXY(04,10);  Write('Conta.:');
  GotoXY(04,11);  Write('Depto.:');
  GotoXY(04,12);  Write('Seq...:');
  GotoXY(04,14);  Write('C.Cont:');
  GotoXY(04,15);  Write('%Valor:');
  GotoXY(35,15);  Write('Tipo..:');
  Color(Sfn,Stx);
  GotoXY(21,16);  Write('       Hist¢rico        ');
  Color(Tfn,Ttx);
  GotoXY(04,21);  Write('Status:');
  Color(Tfn,Utx);
end;


Procedure DataTabC;
begin
  Color(Tfn,Utx);
  Seek ( TCFile, TCNumber );
  Read ( TCFile, TCMember );
  CCNo := TCMember.Conta;
  SearchTree1 ( Root1 );
  If RC = 'S' then
     begin
       Seek ( CCFile, CCNumber );
       Read ( CCFile, CCMember );
     end
     else begin
            CCMember.Conta     := TCMember.Conta;
            CCMember.Descricao := '** Conta nÆo Existe **';
          end;
  TCAC := TCNo;
  TCAN := TCNumber;
  GotoXY(12,10); Write(PushLeft(4,CCMember.Conta),
                       PushLeft(41,CCMember.Descricao));
  GotoXY(12,11);
  If TCMember.LocalCC = '      '
     then Write('** Todos **')
     else Write(PushLeft(20,TCMember.LocalCC));
  GotoXY(12,12); Write(TCMember.Seq);
  GotoXY(12,14);
  If Alog = 'N' then Write(TCMember.ContaA)
     else begin
            AlogNo := LimpaChave(TCMember.ContaA);
            SearchTree13 ( Root13 );
            If RC = 'S' then
               begin
                 Seek ( AlogFile, AlogNumber );
                 Read ( AlogFile, AlogMember );
                 Write(PushLeft(19,AlogMember.OrigConta),
                       Copy(AlogMember.Descricao,1,30),
                       ' ':30-Length(Copy(AlogMember.Descricao,1,30)));
               end
               else Write(PushLeft(45,TCMember.ContaA));
          end;
  GotoXY(12,15); Write(TCMember.Percentual:6:2);
  GotoXY(44,15); Case TCMember.Tipo of
                      'D' : Write('D‚bito ');
                      'C' : Write('Cr‚dito');
                 end;
  GotoXY(04,17); Write(TCMember.Historico[1]);
  GotoXY(04,18); Write(TCMember.Historico[2]);
  GotoXY(04,19); Write(TCMember.Historico[3]);
  GotoXY(12,21); Case TCMember.Status of
                      'A' : Write('Ativo     ');
                      'D' : Write('Desativado');
                      'C' : Write('Cancelado ');
                 end;
end;


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


Procedure DirScroll(X : Char);
begin
  Case X of
       #72 : begin
               Color(Blue,White);
               GotoXY(04,23); Write(#25);
               GotoXY(06,23); Write('PgDn');
               GotoXY(27,23); Write('PgUp');
               Color(Blue,(White + Blink));
               GotoXY(25,23); Write(#24);
             end;
       #73 : begin
               Color(Blue,White);
               GotoXY(04,23); Write(#25);
               GotoXY(06,23); Write('PgDn');
               GotoXY(25,23); Write(#24);
               Color(Blue,(White + Blink));
               GotoXY(27,23); Write('PgUp');
             end;
       #80 : begin
               Color(Blue,(White + Blink));
               GotoXY(04,23); Write(#25);
               Color(Blue,White);
               GotoXY(06,23); Write('PgDn');
               GotoXY(25,23); Write(#24);
               GotoXY(27,23); Write('PgUp');
             end;
       #81 : begin
               Color(Blue,(White + Blink));
               GotoXY(06,23); Write('PgDn');
               Color(Blue,White);
               GotoXY(04,23); Write(#25);
               GotoXY(25,23); Write(#24);
               GotoXY(27,23); Write('PgUp');
             end;
  end;
end;


Procedure ScrollFim;
begin
  Color(Red,White);
  GotoXY(1,24);  Write(ConstStr(' ',80));
  GotoXY(1,24);  Write(' Fim da Lista');
  Color(Sfn,Stx);
end;


Procedure ScrollConta;
Var
   Cont,Direcao,
   F,Tkb          : Char;
   Sx,R,N         : Integer;
   RArray         : Array[1..7] of Integer;
   KArray         : Array[1..7] of Str18;
   NArray         : Array[1..7] of Str40;
   ScArrayX       : Array [1..4000] of Char;

begin
  Move(MemW[$B800:0000],ScArrayX[1],4000);
  FootScroll;
  DrawBox(6,11,66,20,Sfn,'S');
  Color(Bfn,Btx);
  GotoXY(6,11);
  Write(' Conta              Descri‡Æo                                ');
  Color(Sfn,Stx);
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
  SearchAnt13 ( Root13 );
  If RC = 'N' then AlogNo := '';
  Repeat
    RC := 'N';
    SearchPos13 ( Root13 );
    If RC = 'S' then
       begin
         {$I-}
         Seek ( AlogFile, AlogNumber );
         Read ( AlogFile, AlogMember );
         {$I+}
         If IOResult = 0 then
            begin
              L := L + 1;
              KArray[L] := AlogMember.OrigConta;
              RArray[L] := AlogNumber;
              NArray[L] := AlogMember.Descricao;
            end;
       end
       else L := 7;
  Until L = 7;
  Repeat
    Window(6,13,67,20);
    For I := 1 to 7 do begin
                          If KArray[I] <> '' then
                             begin
                               If I = Sx then Color(Tfn,Utx)
                                         else Color(Sfn,Stx);
                               GotoXY(1,I);
                               Writeln(' ',PushLeft(19,KArray[I]),
                                           PushLeft(41,NArray[I]));
                               Color(Sfn,Stx);
                             end;
                       end;
    Window(1,1,80,25);
    Cont := ReadKey;
    If (Cont = #0 ) and (KeyPressed) then
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
       else If Cont in [#13,#27] then Direcao := 'N';
    LimpaLn(24,Red);
    N := 7;
    Case Direcao of
         'A' : If F <> 'A' then
                    Case Tkb of
                         'L' : If Sx > 1 then
                                  begin
                                    Sx := Sx - 1;
                                    F  := 'N';
                                  end
                                  else begin
                                         RC     := 'N';
                                         AlogNo := LimpaChave(KArray[1]);
                                         SearchAnt13 ( Root13 );
                                         If RC = 'S' then
                                            begin
                                              {$I-}
                                              Seek ( AlogFile, AlogNumber );
                                              Read ( AlogFile, AlogMember );
                                              {$I+}
                                              If IOResult = 0 then
                                                 begin
                                                   For I := 7 downto 2 do
                                                   begin
                                                     KArray[I] := KArray[I - 1];
                                                     RArray[I] := RArray[I - 1];
                                                     NArray[I] := NArray[I - 1];
                                                   end;
                                                   KArray[1] := AlogMember.OrigConta;
                                                   RArray[1] := AlogNumber;
                                                   NArray[1] := AlogMember.Descricao;
                                                   F := 'N';
                                                 end;
                                            end
                                            else F := 'A';
                                       end;
                         'P' : begin
                                Sx := 1;
                                N  := 0;
                                Repeat
                                  RC     := 'N';
                                  AlogNo := LimpaChave(KArray[1]);
                                  SearchAnt13 ( Root13 );
                                  If RC = 'S' then
                                     begin
                                       {$I-}
                                       Seek ( AlogFile, AlogNumber );
                                       Read ( AlogFile, AlogMember );
                                       {$I+}
                                       If IOResult = 0 then
                                          begin
                                            For I := 7 downto 2 do
                                            begin
                                              KArray[I] := KArray[I - 1];
                                              RArray[I] := RArray[I - 1];
                                              NArray[I] := NArray[I - 1];
                                            end;
                                            KArray[1] := AlogMember.OrigConta;
                                            RArray[1] := AlogNumber;
                                            NArray[1] := AlogMember.Descricao;
                                            F := 'N';
                                            N := N + 1;
                                          end;
                                     end
                                     else F := 'A';
                                Until (N = 7) or (RC = 'N');
                              end;
                    end;
         'P' : If F <> 'P' then
                    Case Tkb of
                         'L' : If Sx < 7 then
                                  begin
                                    If KArray[Sx + 1] <> '' then
                                       begin
                                         Sx := Sx + 1;
                                         F  := 'N';
                                       end
                                       else F := 'P';
                                  end
                                  else begin
                                         RC     := 'N';
                                         AlogNo := LimpaChave(KArray[Sx]);
                                         SearchPos13 ( Root13 );
                                         If RC = 'S' then
                                            begin
                                              {$I-}
                                              Seek ( AlogFile, AlogNumber );
                                              Read ( AlogFile, AlogMember );
                                              {$I+}
                                              If IOResult = 0 then
                                                 begin
                                                   For I := 2 to 7 do
                                                   begin
                                                     KArray[I - 1] := KArray[I];
                                                     RArray[I - 1] := RArray[I];
                                                     NArray[I - 1] := NArray[I];
                                                   end;
                                                   KArray[7] := AlogMember.OrigConta;
                                                   RArray[7] := AlogNumber;
                                                   NArray[7] := AlogMember.Descricao;
                                                 end;
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
                                  RC     := 'N';
                                  AlogNo := LimpaChave(KArray[R]);
                                  SearchPos13 ( Root13 );
                                  If RC = 'S' then
                                     begin
                                       {$I-}
                                       Seek ( AlogFile, AlogNumber );
                                       Read ( AlogFile, AlogMember );
                                       {$I+}
                                       If IOResult = 0 then
                                          begin
                                            For I := 2 to 7 do
                                            begin
                                              KArray[I - 1] := KArray[I];
                                              RArray[I - 1] := RArray[I];
                                              NArray[I - 1] := NArray[I];
                                            end;
                                            KArray[R] := AlogMember.OrigConta;
                                            RArray[R] := AlogNumber;
                                            NArray[R] := AlogMember.Descricao;
                                            N := N + 1;
                                          end
                                          else RC := 'N';
                                     end;
                                Until (N = 7) or (RC = 'N');
                                F := 'N';
                              end;
                    end;
    end;
    If (F <> 'N') or (N < 7) then ScrollFim;
  Until Cont in [#13,#27];
  Move(ScArrayX[1],Mem[$B800:0000],4000);
  Color(Tfn,Utx);
  If Cont = #13 then AlogAC := KArray[Sx];
end;


Procedure ScrollTabC;
Var
   Cont,Direcao,
   F,Tkb          : Char;
   Sx,R,N         : Integer;
   RArray         : Array[1..7] of Integer;
   KArray         : Array[1..7] of Str18;
   CArray         : Array[1..7] of Str3;
   DArray         : Array[1..7] of Str6;
   SArray         : Array[1..7] of Str2;
   AArray         : Array[1..7] of Str18;
   VArray         : Array[1..7] of Str6;
   TArray         : Array[1..7] of Char;
   ScArrayX       : Array [1..4000] of Char;

begin
  Move(MemW[$B800:0000],ScArrayX[1],4000);
  FootScroll;
  DrawBox(23,11,67,20,Sfn,'S');
  Color(Bfn,Btx);
  GotoXY(23,11); Write(' Cta Depto. Sq Classific.Cont bil %Valor D/C ');
  Color(Sfn,Stx);
  F       := 'N';
  Direcao := 'P';
  L       := 0;
  Sx      := 1;
  For I := 1 to 7 do begin
                       KArray[I] := '';
                       RArray[I] := 0;
                       CArray[I] := '';
                       DArray[I] := '';
                       SArray[I] := '';
                       AArray[I] := '';
                       VArray[I] := '';
                       TArray[I] := ' ';
                     end;
  RC := 'N';
  SearchAnt12 ( Root12 );
  If RC = 'N' then TCNo := '';
  Repeat
    RC := 'N';
    SearchPos12 ( Root12 );
    If RC = 'S' then
       begin
         {$I-}
         Seek ( TCFile, TCNumber );
         Read ( TCFile, TCMember );
         {$I+}
         If IOResult = 0 then
            begin
              L := L + 1;
              KArray[L] := TCNo;
              RArray[L] := TCNumber;
              CArray[L] := TCMember.Conta;
              DArray[L] := TCMember.LocalCC;
              SArray[L] := TCMember.Seq;
              AArray[L] := TCMember.ContaA;
              Str(TCMember.Percentual:6:2,VArray[L]);
              TArray[L] := TCMember.Tipo;
            end;
       end
       else L := 7;
  Until L = 7;
  Repeat
    Window(23,13,68,20);
    For I := 1 to 7 do begin
                          If KArray[I] <> '' then
                             begin
                               If I = Sx then Color(Tfn,Utx)
                                         else Color(Sfn,Stx);
                               GotoXY(1,I);
                               Writeln(' ',PushLeft(4,CArray[I]),
                                           PushLeft(7,DArray[I]),
                                           PushLeft(3,SArray[I]),
                                           PushLeft(19,AArray[I]),
                                           PushLeft(8,VArray[I]),
                                           PushLeft(3,TArray[I]));
                               Color(Sfn,Stx);
                             end;
                       end;
    Window(1,1,80,25);
    Cont := ReadKey;
    If (Cont = #0 ) and (KeyPressed) then
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
       else If Cont in [#13,#27] then Direcao := 'N';
    LimpaLn(24,Red);
    N := 7;
    Case Direcao of
         'A' : If F <> 'A' then
                    Case Tkb of
                         'L' : If Sx > 1 then
                                  begin
                                    Sx := Sx - 1;
                                    F  := 'N';
                                  end
                                  else begin
                                         RC   := 'N';
                                         TCNo := KArray[1];
                                         SearchAnt12 ( Root12 );
                                         If RC = 'S' then
                                            begin
                                              {$I-}
                                              Seek ( TCFile, TCNumber );
                                              Read ( TCFile, TCMember );
                                              {$I+}
                                              If IOResult = 0 then
                                                 begin
                                                   For I := 7 downto 2 do
                                                   begin
                                                     KArray[I] := KArray[I - 1];
                                                     RArray[I] := RArray[I - 1];
                                                     CArray[I] := CArray[I - 1];
                                                     DArray[I] := DArray[I - 1];
                                                     SArray[I] := SArray[I - 1];
                                                     AArray[I] := AArray[I - 1];
                                                     VArray[I] := VArray[I - 1];
                                                     TArray[I] := TArray[I - 1];
                                                   end;
                                                   KArray[1] := TCNo;
                                                   RArray[1] := TCNumber;
                                                   CArray[1] := TCMember.Conta;
                                                   DArray[1] := TCMember.LocalCC;
                                                   SArray[1] := TCMember.Seq;
                                                   AArray[1] := TCMember.ContaA;
                                                   Str(TCMember.Percentual:6:2,VArray[1]);
                                                   TArray[1] := TCMember.Tipo;
                                                   F := 'N';
                                                 end;
                                            end
                                            else F := 'A';
                                       end;
                         'P' : begin
                                Sx := 1;
                                N  := 0;
                                Repeat
                                  RC   := 'N';
                                  TCNo := KArray[1];
                                  SearchAnt12 ( Root12 );
                                  If RC = 'S' then
                                     begin
                                       {$I-}
                                       Seek ( TCFile, TCNumber );
                                       Read ( TCFile, TCMember );
                                       {$I+}
                                       If IOResult = 0 then
                                          begin
                                            For I := 7 downto 2 do
                                            begin
                                              KArray[I] := KArray[I - 1];
                                              RArray[I] := RArray[I - 1];
                                              CArray[I] := CArray[I - 1];
                                              DArray[I] := DArray[I - 1];
                                              SArray[I] := SArray[I - 1];
                                              AArray[I] := AArray[I - 1];
                                              VArray[I] := VArray[I - 1];
                                              TArray[I] := TArray[I - 1];
                                            end;
                                            KArray[1] := TCNo;
                                            RArray[1] := TCNumber;
                                            CArray[1] := TCMember.Conta;
                                            DArray[1] := TCMember.LocalCC;
                                            SArray[1] := TCMember.Seq;
                                            AArray[1] := TCMember.ContaA;
                                            Str(TCMember.Percentual:6:2,VArray[1]);
                                            TArray[1] := TCMember.Tipo;
                                            F := 'N';
                                            N := N + 1;
                                          end;
                                     end
                                     else F := 'A';
                                Until (N = 7) or (RC = 'N');
                              end;
                    end;
         'P' : If F <> 'P' then
                    Case Tkb of
                         'L' : If Sx < 7 then
                                  begin
                                    If KArray[Sx + 1] <> '' then
                                       begin
                                         Sx := Sx + 1;
                                         F  := 'N';
                                       end
                                       else F := 'P';
                                  end
                                  else begin
                                         RC   := 'N';
                                         TCNo := KArray[Sx];
                                         SearchPos12 ( Root12 );
                                         If RC = 'S' then
                                            begin
                                              {$I-}
                                              Seek ( TCFile, TCNumber );
                                              Read ( TCFile, TCMember );
                                              {$I+}
                                              If IOResult = 0 then
                                                 begin
                                                   For I := 2 to 7 do
                                                   begin
                                                     KArray[I - 1] := KArray[I];
                                                     RArray[I - 1] := RArray[I];
                                                     CArray[I - 1] := CArray[I];
                                                     DArray[I - 1] := DArray[I];
                                                     SArray[I - 1] := SArray[I];
                                                     AArray[I - 1] := AArray[I];
                                                     VArray[I - 1] := VArray[I];
                                                     TArray[I - 1] := TArray[I];
                                                   end;
                                                 KArray[7] := TCNo;
                                                 RArray[7] := TCNumber;
                                                 CArray[7] := TCMember.Conta;
                                                 DArray[7] := TCMember.LocalCC;
                                                 SArray[7] := TCMember.Seq;
                                                 AArray[7] := TCMember.ContaA;
                                                 Str(TCMember.Percentual:6:2,VArray[7]);
                                                 TArray[7] := TCMember.Tipo;
                                                 end;
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
                                  RC   := 'N';
                                  TCNo := KArray[R];
                                  SearchPos12 ( Root12 );
                                  If RC = 'S' then
                                     begin
                                       {$I-}
                                       Seek ( TCFile, TCNumber );
                                       Read ( TCFile, TCMember );
                                       {$I+}
                                       If IOResult = 0 then
                                          begin
                                            For I := 2 to 7 do
                                            begin
                                              KArray[I - 1] := KArray[I];
                                              RArray[I - 1] := RArray[I];
                                              CArray[I - 1] := CArray[I];
                                              DArray[I - 1] := DArray[I];
                                              SArray[I - 1] := SArray[I];
                                              AArray[I - 1] := AArray[I];
                                              VArray[I - 1] := VArray[I];
                                              TArray[I - 1] := TArray[I];
                                            end;
                                            KArray[R] := TCNo;
                                            RArray[R] := TCNumber;
                                            CArray[R] := TCMember.Conta;
                                            DArray[R] := TCMember.LocalCC;
                                            SArray[R] := TCMember.Seq;
                                            AArray[R] := TCMember.ContaA;
                                            Str(TCMember.Percentual:6:2,VArray[R]);
                                            TArray[R] := TCMember.Tipo;
                                            N := N + 1;
                                          end
                                          else RC := 'N';
                                     end;
                                Until (N = 7) or (RC = 'N');
                                F := 'N';
                              end;
                    end;
    end;
    If (F <> 'N') or (N < 7) then ScrollFim;
  Until Cont in [#13,#27];
  Move(ScArrayX[1],Mem[$B800:0000],4000);
  Color(Tfn,Utx);
  If Cont = #13 then
     begin
       TCAC := KArray[Sx];
       TCAN := RArray[Sx];
     end;
end;


Procedure HelpHist;
begin
  DrawBox(38,9,57,14,Red,'S');
  Color(Red,Cyan);
  GotoXY(38,10); Write('   na 1§ posi‡Æo do ');
  GotoXY(38,11); Write(' hist¢rico  causa a ');
  GotoXY(38,12); Write(' substitui‡Æo  pelo ');
  GotoXY(38,13); Write(' nome do          . ');
  Color(Red,Yellow);
  GotoXY(39,10); Write('#');
  GotoXY(47,13); Write('Empregado');
end;


Procedure EntryTabC;
begin
  Repeat
    R := 1;
    Repeat
      Case R of
           1   : begin
                   Move(MemW[$B800:0000],ScArray6[1],4000);
                   DrawBox(38,10,57,13,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(38,11); Write(' C¢digo da Conta do ');
                   GotoXY(38,12); Write(' Sistema Cont bil.. ');
                   If Alog = 'S' then
                      begin
                        Color(Blue,White);
                        GotoXY(1,23); Write(ConstStr(' ',80));
                        GotoXY(2,23); Write('F1');
                        Color(Blue,Cyan);
                        GotoXY(5,23); Write('para pesquisar Contas');
                      end;
                   J := TCMember.ContaA;
                   InputStr(J,18,12,14,0,'S','N','T','N',Tfn,Utx);
                   TCMember.ContaA := J;
                   If TC <> #27 then
                      begin
                        If TC = #21 then
                           begin
                             AlogNo := LimpaChave(J);
                             AlogAC := AlogNo;
                             AlogAN := 0;
                             ScrollConta;
                             TCMember.ContaA := AlogAC;
                             RC              := 'N';
                           end
                           else If (Alog             = 'S') and
                                   (TCMember.ContaA <> '' ) then
                                   begin
                                     AlogNo := LimpaChave(J);
                                     SearchTree13 ( Root13 );
                                     If RC = 'S' then
                                        begin
                                          Seek ( AlogFile, AlogNumber );
                                          Read ( AlogFile, AlogMember );
                                          TCMember.ContaA := AlogMember.OrigConta;
                                        end
                                        else begin
                                               ErroMsg := 'Conta nÆo Existe';
                                               ErrorMessage;
                                               K  := K - 1;
                                               RC := 'N';
                                             end;
                                   end
                                   else If TCMember.ContaA = '' then
                                           begin
                                             ErroMsg := 'Informe a Conta';
                                             ErrorMessage;
                                             K := K - 1;
                                           end;
                      end;
                   Move(ScArray6[1],MemW[$B800:0000],4000);
                   GotoXY(12,14);
                   If (Alog = 'N') or (RC = 'N')
                      then Write(PushLeft(45,TCMember.ContaA))
                      else If RC = 'S'
                              then Write(PushLeft(19,AlogMember.OrigConta),
                                         Copy(AlogMember.Descricao,1,30),
                                         ' ':30-Length(Copy(AlogMember.Descricao,1,30)));
                 end;
           2   : begin
                   If TCMember.Percentual = 0 then J := ''
                                              else begin
                                                     Str(TCMember.Percentual:6:2,J);
                                                     J := LeftAdjust(J);
                                                   end;
                   InputStr(J,6,12,15,0,'S','N','$','N',Tfn,Utx);
                   Val(J,TCMember.Percentual,E);
                   If (TCMember.Percentual = 0 ) or
                      (J                   = '') then TCMember.Percentual := 100;
                 end;
           3   : begin
                   Move(MemW[$B800:0000],ScArray6[1],4000);
                   DrawBox(48,10,56,13,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(48,11); Write('  ‚bito  ');
                   GotoXY(48,12); Write('  r‚dito ');
                   Color(Red,Yellow);
                   GotoXY(49,11); Write('D');
                   GotoXY(49,12); Write('C');
                   J := TCMember.Tipo;
                   InputStr(J,1,44,15,0,'S','N','T','N',Tfn,Utx);
                   If J = ' ' then TCMember.Tipo := 'D'
                              else TCMember.Tipo := UpCase(J[1]);
                   If (TC            <> #27) and
                      (TCMember.Tipo <> 'D') and
                      (TCMember.Tipo <> 'C') then
                      begin
                        ErroMsg := 'Tipo Inv lido';
                        ErrorMessage;
                        K := K - 1;
                      end;
                   Move(ScArray6[1],MemW[$B800:0000],4000);
                   GotoXY(44,15); Case TCMember.Tipo of
                                       'D' : Write('D‚bito ');
                                       'C' : Write('Cr‚dito');
                                       else  Write('       ');
                                  end;
                 end;
           4..6   : begin
                      Move(MemW[$B800:0000],ScArray6[1],4000);
                      HelpHist;
                      J := TCMember.Historico[R-3];
                      InputStr(J,55,4,13+R,0,'S','N','T','N',Tfn,Utx);
                      TCMember.Historico[R-3] := J;
                      Move(ScArray6[1],MemW[$B800:0000],4000);
                      GotoXY(4,13+R);
                      Write(PushLeft(56,TCMember.Historico[R-3]));
                    end;
           7   : begin
                   Move(MemW[$B800:0000],ScArray6[1],4000);
                   DrawBox(45,14,56,18,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(45,15); Write('  tiva      ');
                   GotoXY(45,16); Write('  esativada ');
                   GotoXY(45,17); Write('  ancelada  ');
                   Color(Red,Yellow);
                   GotoXY(46,15); Write('A');
                   GotoXY(46,16); Write('D');
                   GotoXY(46,17); Write('C');
                   J := TCMember.Status;
                   InputStr(J,1,12,21,0,'S','N','T','N',Tfn,Utx);
                   If J = ' ' then TCMember.Status := 'A'
                              else TCMember.Status := UpCase(J[1]);
                   If (TC              <> #27) and
                      (TCMember.Status <> 'A') and
                      (TCMember.Status <> 'D') and
                      (TCMember.Status <> 'C') then
                      begin
                        ErroMsg := 'Informe A,D ou C';
                        ErrorMessage;
                        K := K - 1;
                      end;
                   Move(ScArray6[1],MemW[$B800:0000],4000);
                   GotoXY(12,21); Case TCMember.Status of
                                       'A' : Write('Ativo     ');
                                       'D' : Write('Desativado');
                                       'C' : Write('Cancelado ');
                                  end;
                 end;
      end;
      Case TC of
           #13 : R := R + 1;
           #24 : If R > 1 then R := R - 1;
      end;
    Until (R = 8) or (TC = #27);
    If ((TC <> #27) and (Op = 'I')) or (Op = 'A') then Confirma;
  Until TC in ['S',#27];
end;


Procedure IncluiTabC;
Var
  Bu   : Char;
begin
  Bu := 'N';
  K  := 1;
  Repeat
    Case K of
         1 : begin
               J := '';
               InputStr(J,6,12,11,0,'S','N','T','N',Tfn,Utx);
               If TC <> #27 then
                  begin
                    TCMember.LocalCC := J;
                    GotoXY(12,11);
                    If J = '' then
                       begin
                         TCMember.LocalCC := '      ';
                         Write('** Todos **');
                       end
                       else Write(PushLeft(12,TCMember.LocalCC));
                  end;
             end;
         2 : begin
               J := '';
               If Bu = 'N' then InputStr(J,2,12,12,0,'S','N','T','N',Tfn,Utx);
               If TC <> #27 then
                  begin
                    If J = '' then
                       begin
                         Sq := Sq + 1;
                         Str(Sq:2,J);
                         J := LeftAdjust(J);
                         Bu := 'S';
                       end;
                    Val(J,Sq,E);
                    TCMember.Seq := QQStr(Sq,2,'0');
                    GotoXY(12,12); Write(TCMember.Seq);
                    TCNo := TCMember.Conta   + '#' +
                            TCMember.LocalCC + '#' +
                            TCMember.Seq;
                    SearchTree12 ( Root12 );
                    If RC = 'N' then
                       begin
                         TCNumber := FileSize(TCFile);
                         Op       := 'I';
                         EntryTabC;
                         If TC = 'S' then
                            begin
                              LoadTree12 ( Root12 );
                              Seek ( TCFile, TCNumber );
                              Write( TCFile, TCMember );
                            end;
                       end
                       else If Bu = 'N' then
                               begin
                                 ErroMsg  := 'Elemento j  Existe';
                                 ErrorMessage;
                                 TC := #27;
                               end
                               else TC := #00;
                  end;
             end;
    end;
    Case TC of
         #13 : K := K + 1;
         #24 : If K > 1 then K := K - 1;
    end;
  Until TC in [#27,'S'];
end;


Procedure InseriTabc;
begin
  Move(MemW[$B800:0000],ScArray5[1],4000);
  Color(Tfn,Utx);
  GotoXY(12,11); Write(ConstStr(' ',20));
  GotoXY(12,12); Write('  ');
  GotoXY(12,14); Write(ConstStr(' ',49));
  GotoXY(12,15); Write(ConstStr(' ',6));
  GotoXY(44,15); Write(ConstStr(' ',10));
  GotoXY(04,17); Write(ConstStr(' ',56));
  GotoXY(04,18); Write(ConstStr(' ',56));
  GotoXY(04,19); Write(ConstStr(' ',56));
  GotoXY(12,21); Write(ConstStr(' ',20));
  TCAN := TCNumber;
  TCAC := TCNo;
  TCMember.Conta        := CCNo;
  TCMember.LocalCC      := '';
  TCMember.Seq          := '';
  TCMember.ContaA       := '';
  TCMember.Percentual   := 0;
  TCMember.Tipo         := ' ';
  TCMember.Historico[1] := '';
  TCMember.Historico[2] := '';
  TCMember.Historico[3] := '';
  TCMember.Status       := 'A';
  Sq                    := 0;
  IncluiTabC;
  If TC = #27 then
     begin
       TCNumber := TCAN;
       TCNo     := TCAC;
       Move(ScArray5[1],MemW[$B800:0000],4000);
     end;
end;


Procedure UpdateTabC;
begin
  Color(Tfn,Utx);
  Repeat
    J := '';
    InputStr(J,3,12,10,0,'S','N','T','N',Tfn,Utx);
    LimpaLn(24,Tfd);
    Case TC of
         #13 : If J <> '' then
                  begin
                    CCNo := J;
                    SearchTree1( Root1 );
                    If RC = 'N' then
                       begin
                         CCNumber := Limite;
                         ErroMsg  := 'Conta nÆo Existe';
                         ErrorMessage;
                       end
                       else begin
                              Seek ( CCFile, CCNumber );
                              Read ( CCFile, CCMember );
                              GotoXY(12,10);
                              Write(PushLeft(4,CCMember.Conta),
                                    PushLeft(41,CCMember.Descricao));
                            end;
                  end
                  else CCNumber := Limite;
         #25 : begin
                 CCNo := '';
                 RC   := 'N';
                 SearchPos1 ( Root1 );
                 If RC = 'N' then CCNumber := Limite;
               end;
         #27 : CCNumber := Limite;
    end;
    If CCNumber <> Limite then
       begin
         TCNo := CCNo + '#';
         RC   := 'N';
         SearchPos12 ( Root12 );
         If (RC = 'S') and (CCNo = Copy(TCNo,1,Length(CCNo))) then
            begin
              Repeat
                DataTabC;
                Repeat
                  Resp := ReadKey;
                  LimpaLn(24,Tfd);
                  If (Resp = #0) and (KeyPressed) then
                     begin
                       Resp := ReadKey;
                       Case Resp of
                            #80 : begin
                                    RC := 'N';
                                    SearchPos12 ( Root12 );
                                    If RC = 'N' then AvisoFinal;
                                  end;
                            #72 : begin
                                    RC := 'N';
                                    SearchAnt12 ( Root12 );
                                    If RC = 'N' then AvisoFinal;
                                  end;
                            #59 : begin
                                    TCAN := TCNumber;
                                    TCAC := TCNo;
                                    ScrollTabC;
                                    TCNumber := TCAN;
                                    TCNo     := TCAC;
                                    DatatabC;
                                  end;
                            #61 : begin
                                    Op := 'A';
                                    EntryTabC;
                                    If TC = 'S' then
                                       begin
                                         Seek ( TCFile, TCNumber );
                                         Write( TCFile, TCMember );
                                       end;
                                  end;
                            #63 : begin
                                    InseriTabC;
                                    Resp := #00;
                                  end;
                       end;
                     end;
                Until (Resp in [#13,#27]) or ((Resp in [#72,#80]) and (RC <> 'N'));
                Move(ScArray4[1],MemW[$B800:0000],4000);
              Until Resp in [#13,#27];
            end
            else InseriTabc;
         Move(ScArray4[1],MemW[$B800:0000],4000);
         TC := #13;
       end;
  Until TC = #27;
  Resp := #13;
end;

