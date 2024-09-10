Procedure ScrollLancto;
Var
   Cont,Direcao,
   F,Tkb          : Char;
   Sx,R,N         : Integer;
   KArray         : Array[1..7] of Str30;
   RArray         : Array[1..7] of Integer;
   DArray         : Array[1..7] of Str2;
   TArray         : Array[1..7] of Char;
   VArray         : Array[1..7] of Str20;
   SArray         : Array[1..7] of Char;
   CArray         : Array[1..7] of Str6;
   LArray         : Array[1..7] of Str6;
   NArray         : Array[1..7] of Str4;

begin
  Move(MemW[$B800:0000],ScArray5[1],4000);
  Color(Blue,White);
  GotoXY(01,23); Write(ConstStr(' ',80));
  GotoXY(10,23); Write(#25);
  GotoXY(12,23); Write('PgDn');
  GotoXY(35,23); Write(#24);
  GotoXY(37,23); Write('PgUp');
  GotoXY(61,23); Write('Esc');
  Color(Blue,Cyan);
  GotoXY(11,23); Write('/');
  GotoXY(17,23); Write(#26,' Pr¢xima');
  GotoXY(36,23); Write('/');
  GotoXY(42,23); Write(#26,' Anterior');
  GotoXY(65,23); Write(#26,' Fim');
  Color(Red,White);
  GotoXY(1,24); ClrEol;
  DrawBox(21,12,68,21,Sfn,'S');
  Color(Bfn,Btx);
  GotoXY(21,12);
  Write(' DD T                Valor S Depto. ..LotexLanc ');
  Color(Sfn,Stx);
  F       := 'N';
  Direcao := 'P';
  L       := 0;
  Sx      := 1;
  CDVSNo  := ContaNo + '#';
  For I := 1 to 7 do begin
                       KArray[I] := '';
                       RArray[I] := 0;
                       DArray[I] := '';
                       TArray[I] := ' ';
                       VArray[I] := '';
                       SArray[I] := ' ';
                       CArray[I] := '';
                       LArray[I] := '';
                       NArray[I] := '';
                     end;
  Repeat
    RC := 'N';
    SearchPos4 ( Root4 );
    If RC = 'S' then
       begin
         If ContaNo = Copy(CDVSNo,1,(Length(ContaNo))) then
            begin
              ReadWrite(#08,'R','N',CDVSNumber);
              If RW = 'S' then
                 begin
                   L := L + 1;
                   KArray[L] := CDVSNo;
                   RArray[L] := CDVSNumber;
                   DArray[L] := Copy(LctoMember.OrigData,1,2);
                   TArray[L] := LctoMember.Tipo;
                   VArray[L] := EditDouble(LctoMember.Valor);
                   SArray[L] := LctoMember.Status;
                   CArray[L] := LctoMember.Depto;
                   LArray[L] := LctoMember.Lote;
                   NArray[L] := LctoMember.SeqLote;
                 end;
            end
            else L := 7;
       end
       else L := 7;
  Until L = 7;
  Repeat
    Window(21,14,69,21);
    For I := 1 to 7 do begin
                          If KArray[I] <> '' then
                             begin
                               If I = Sx then Color(Tfn,Utx)
                                         else Color(Sfn,Stx);
                               GotoXY(1,I);
                               Writeln(' ',DArray[I]:2,' ',
                                           TArray[I]:1,' ',
                                           VArray[I]:20,' ',
                                           SArray[I],' ',
                                           CArray[I]:6,' ',
                                           LArray[I]:6,'x',
                                           NArray[I]:4,' ');
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
              #72 : begin
                      Tkb     := 'L';
                      Direcao := 'A';
                      Color(Blue,White);
                      GotoXY(10,23); Write(#25);
                      GotoXY(12,23); Write('PgDn');
                      GotoXY(37,23); Write('PgUp');
                      Color(Blue,(White + Blink));
                      GotoXY(35,23); Write(#24);
                    end;
              #73 : begin
                      Tkb     := 'P';
                      Direcao := 'A';
                      Color(Blue,White);
                      GotoXY(10,23); Write(#25);
                      GotoXY(12,23); Write('PgDn');
                      GotoXY(35,23); Write(#24);
                      Color(Blue,(White + Blink));
                      GotoXY(37,23); Write('PgUp');
                    end;
              #80 : begin
                      Tkb     := 'L';
                      Direcao := 'P';
                      Color(Blue,(White + Blink));
                      GotoXY(10,23); Write(#25);
                      Color(Blue,White);
                      GotoXY(12,23); Write('PgDn');
                      GotoXY(35,23); Write(#24);
                      GotoXY(37,23); Write('PgUp');
                    end;
              #81 : begin
                      Tkb     := 'P';
                      Direcao := 'P';
                      Color(Blue,(White + Blink));
                      GotoXY(12,23); Write('PgDn');
                      Color(Blue,White);
                      GotoXY(10,23); Write(#25);
                      GotoXY(35,23); Write(#24);
                      GotoXY(37,23); Write('PgUp');
                    end;
              else Direcao := ' ';
         end;
       end
       else If (Cont = #13) or (Cont = #27) then Direcao := 'N';
    LimpaLn(24,Red);
    Color(Sfn,Stx);
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
                                       CDVSNo := KArray[1];
                                       SearchAnt4 ( Root4 );
                                       If RC = 'S' then
                                          begin
                                            If ContaNo = Copy(CDVSNo,1,(Length(ContaNo))) then
                                               begin
                                                 ReadWrite(#08,'R','N',CDVSNumber);
                                                 For I := 7 downto 2 do
                                                 begin
                                                   KArray[I] := KArray[I - 1];
                                                   RArray[I] := RArray[I - 1];
                                                   DArray[I] := DArray[I - 1];
                                                   TArray[I] := TArray[I - 1];
                                                   VArray[I] := VArray[I - 1];
                                                   SArray[I] := SArray[I - 1];
                                                   CArray[I] := CArray[I - 1];
                                                   LArray[I] := LArray[I - 1];
                                                   NArray[I] := NArray[I - 1];
                                                 end;
                                                 KArray[1] := CDVSNo;
                                                 RArray[1] := CDVSNumber;
                                                 DArray[1] := Copy(LctoMember.OrigData,1,2);
                                                 TArray[1] := LctoMember.Tipo;
                                                 VArray[1] := EditDouble(LctoMember.Valor);
                                                 SArray[1] := LctoMember.Status;
                                                 CArray[1] := LctoMember.Depto;
                                                 LArray[1] := LctoMember.Lote;
                                                 NArray[1] := LctoMember.SeqLote;
                                                 F := 'N';
                                               end
                                               else F := 'A';
                                          end
                                          else F := 'A';
                                     end;
                       'P' : begin
                               Sx := 1;
                               N  := 0;
                               Repeat
                                 RC     := 'N';
                                 CDVSNo := KArray[1];
                                 SearchAnt4 ( Root4 );
                                 If RC = 'S' then
                                    begin
                                      If ContaNo = Copy(CDVSNo,1,(Length(ContaNo))) then
                                         begin
                                           ReadWrite(#08,'R','N',CDVSNumber);
                                           For I := 7 downto 2 do
                                           begin
                                             KArray[I] := KArray[I - 1];
                                             RArray[I] := RArray[I - 1];
                                             DArray[I] := DArray[I - 1];
                                             TArray[I] := TArray[I - 1];
                                             VArray[I] := VArray[I - 1];
                                             SArray[I] := SArray[I - 1];
                                             CArray[I] := CArray[I - 1];
                                             LArray[I] := LArray[I - 1];
                                             NArray[I] := NArray[I - 1];
                                           end;
                                           KArray[1] := CDVSNo;
                                           RArray[1] := CDVSNumber;
                                           DArray[1] := Copy(LctoMember.OrigData,1,2);
                                           TArray[1] := LctoMember.Tipo;
                                           VArray[1] := EditDouble(LctoMember.Valor);
                                           SArray[1] := LctoMember.Status;
                                           CArray[1] := LctoMember.Depto;
                                           LArray[1] := LctoMember.Lote;
                                           NArray[1] := LctoMember.SeqLote;
                                           F := 'N';
                                           N := N + 1;
                                         end
                                         else F := 'A';
                                    end
                                    else F := 'A';
                               Until (N = 7) or (F = 'A');
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
                                       CDVSNo := KArray[Sx];
                                       SearchPos4 ( Root4 );
                                       If RC = 'S' then
                                          begin
                                            If ContaNo = Copy(CDVSNo,1,(Length(ContaNo))) then
                                               begin
                                                 ReadWrite(#08,'R','N',CDVSNumber);
                                                 For I := 2 to 7 do
                                                 begin
                                                   KArray[I - 1]  := KArray[I];
                                                   RArray[I - 1]  := RArray[I];
                                                   DArray[I - 1]  := DArray[I];
                                                   TArray[I - 1]  := TArray[I];
                                                   VArray[I - 1]  := VArray[I];
                                                   SArray[I - 1]  := SArray[I];
                                                   CArray[I - 1]  := CArray[I];
                                                   LArray[I - 1]  := LArray[I];
                                                   NArray[I - 1]  := NArray[I];
                                                 end;
                                                 KArray[7] := CDVSNo;
                                                 RArray[7] := CDVSNumber;
                                                 DArray[7] := Copy(LctoMember.OrigData,1,2);
                                                 TArray[7] := LctoMember.Tipo;
                                                 VArray[7] := EditDouble(LctoMember.Valor);
                                                 SArray[7] := LctoMember.Status;
                                                 CArray[7] := LctoMember.Depto;
                                                 LArray[7] := LctoMember.Lote;
                                                 NArray[7] := LctoMember.SeqLote;
                                                 F := 'N';
                                               end
                                               else F := 'P';
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
                               CDVSNo := KArray[R];
                               SearchPos4 ( Root4 );
                               If RC = 'S' then
                                  begin
                                    If ContaNo = Copy(CDVSNo,1,(Length(ContaNo))) then
                                       begin
                                         ReadWrite(#08,'R','N',CDVSNumber);
                                         For I := 2 to 7 do
                                         begin
                                           KArray[I - 1]  := KArray[I];
                                           RArray[I - 1]  := RArray[I];
                                           DArray[I - 1]  := DArray[I];
                                           TArray[I - 1]  := TArray[I];
                                           VArray[I - 1]  := VArray[I];
                                           SArray[I - 1]  := SArray[I];
                                           CArray[I - 1]  := CArray[I];
                                           LArray[I - 1]  := LArray[I];
                                           NArray[I - 1]  := NArray[I];
                                         end;
                                         KArray[R] := CDVSNo;
                                         RArray[R] := CDVSNumber;
                                         DArray[R] := Copy(LctoMember.OrigData,1,2);
                                         TArray[R] := LctoMember.Tipo;
                                         VArray[R] := EditDouble(LctoMember.Valor);
                                         SArray[R] := LctoMember.Status;
                                         CArray[R] := LctoMember.Depto;
                                         LArray[R] := LctoMember.Lote;
                                         NArray[R] := LctoMember.SeqLote;
                                         N := N + 1;
                                       end
                                       else RC := 'N';
                                  end;
                             Until (N = 7) or (RC = 'N');
                             F := 'N';
                           end;
                  end;
    end;
    If (F <> 'N') or (N < 7) then
       begin
         Color(Red,White);
         GotoXY(1,24);  Write(ConstStr(' ',80));
         GotoXY(1,24);  Write(' Fim da Lista');
         Color(Sfn,Stx);
       end;
  Until Cont = #27;
  Move(ScArray5[1],MemW[$B800:0000],4000);
  Color(Tfn,Utx);
end;


