{$O+,F+}
Unit AlogLote;

Interface

Uses Crt,Dos,AlogGlbs,AlogNavg,AlogBasP,AlogDoct,AlogCnta,AlogDept,
             AlogHspd,AlogInit;

   Procedure LoadLancamentos(X,Y : Char);
   Procedure TitleLote;
   Procedure TelaTotalDoLote;
   Procedure TotalDoLote;
   Procedure ColocaNaConta(X,Y : Char);
   Procedure ColocaNaDespesa;
   Procedure UpdateLote;
   Procedure RecalculaSaldo;

Implementation

Var
   Car            : Char;
   Conta1,Conta2  : Str18;
   HistY          : Array[1..3] of Str60;
   RArray         : Array[1..7] of Integer;
   KArray         : Array[1..7] of Str33;
   LArray         : Array[1..7] of Str6;
   SArray         : Array[1..7] of Str4;
   DArray         : Array[1..7] of Str10;
   XArray         : Array[1..7] of Char;
   CArray         : Array[1..7] of Str20;
   TArray         : Array[1..7] of Char;
   VArray         : Array[1..7] of Str20;
   PArray         : Array[1..7] of Str6;


Function ScanCodigo(X : Str80;N : Integer) : Str80;
Var
  P,C   : Integer;
  S     : Str80;
begin
  P := 0;
  C := 0;
  S := '';
  Repeat
    P := P + 1;
    If X[P] = '#' then C := C + 1
                  else If C+1 = N then S := S + X[P];
  Until (C = N) or (P = Length(X));
  ScanCodigo := S;
end;


Procedure TitleLote;
begin
  Color(Tfn,Ttx);
  GotoXY(04,09);  Write('Lote..:');
  GotoXY(04,10);  Write('Mˆs...:');
  GotoXY(04,11);  Write('Status:');
  GotoXY(35,11);  Write('Digit.:');
  GotoXY(04,12);  Write('Descr.:');
  GotoXY(04,16);  Write('Dias de Lancamento');
  Color(Tfn,Utx);
  GotoXY(25,15);  Write('0........1.........2.........3.');
  GotoXY(25,16);  Write('1234567890123456789012345678901');
  Color(Tfn,Ttx);
  GotoXY(04,19);  Write('D‚bito:');
  GotoXY(04,20);  Write('Cr‚dit:');
  Color(Tfn,Utx);
end;


Procedure DataLote;
begin
  HelpM;
  ReadWrite(#04,'R','N',LoteNumber);
  With LoteMember do
  begin
    LoteNo := Chave;
    LoteAC := Chave;
    LoteAN := LoteNumber;
    Color(Tfn,Utx);
    GotoXY(12,09); Write(PushLeft(7,Chave));
    GotoXY(12,10); Write(' ':15);
    GotoXY(12,10); Write(QQStr(MesContabil,2,'0'),' (',
                         ArrayMesEx[MesContabil],
                         ' de ',AnoContabil,')');
    GotoXY(12,11); Case Status of
                        'A' : Write('Ativo    ');
                        'C' : Write('Cancelado');
                        'E' : Write('Excluido ');
                   end;
    GotoXY(43,11); Write(DataAbert);
    GotoXY(12,12); Write(Descricao);
    For I := 1 to 31 do begin
                          If Dias[I] in ['C','S'] then Color(Bfn,Btx)
                                                  else Color(Tfn,Utx);
                          GotoXY(24+I,14); Write(' ');
                          Move(Mem[$B800:(14*160)+((23+I)*2)],Car,1);
                          GotoXY(24+I,15); Write(Car);
                          Move(Mem[$B800:(15*160)+((23+I)*2)],Car,1);
                          GotoXY(24+I,16); Write(Car);
                          GotoXY(24+I,17); Write(' ');
                        end;
    Color(Tfn,Utx);
    GotoXY(12,19); Write(EditDouble(Debito):20,' ',RDebito:4,' Lanc.');
    GotoXY(12,20); Write(EditDouble(Credito):20,' ',RCredito:4,' Lanc.');
  end;
  HistY[1] := '';
  HistY[2] := '';
  HistY[3] := '';
end;


Procedure EntryLote;
begin
  Repeat
    K := 1;
    Repeat
      Case K of
           1   : With LoteMember do
                 begin
                   Move(MemW[$B800:0000],ScArray5[1],4000);
                   DrawBox(43,14,53,18,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(45,15); Write('tivo');
                   GotoXY(45,16); Write('ancelado');
                   GotoXY(45,17); Write('xcluido ');
                   Color(Red,White);
                   GotoXY(44,15); Write('A');
                   GotoXY(44,16); Write('C');
                   GotoXY(44,17); Write('E');
                   J := Status;
		   InputStr(J,1,12,11,0,'S','N','T','N',Tfn,Utx);
                   If TC <> #27 then
                      begin
                        Status := UpCase(J[1]);
                        If Status in ['A','C','E'] then
                           begin
                             If (Status      =  'A'                ) and
                                (AnoContabil <> CMstMember.AnoAtivo) then
                                begin
                                  ErroMsg := 'Lote n„o pertence a este Ano!';
                                  ErrorMessage;
                                  K := K - 1;
                                end;
                           end
                           else begin
                                  ErroMsg := 'Status Inv lido';
                                  ErrorMessage;
                                  K := K - 1;
                                end;
                      end;
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(12,11); Case Status of
                                       'A' : Write('Ativo    ');
                                       'C' : Write('Cancelado');
                                       'E' : Write('Excluido ');
                                  end;
                 end;
           2   : With LoteMember do
                 begin
                   J := Descricao;
		   InputStr(J,20,12,12,0,'S','S','T','N',Tfn,Utx);
                   Descricao := J;
                 end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 3) or (TC = #27);
    If ((TC <> #27) and (Op = 'I')) or (Op = 'A') then Confirma;
  Until (TC = 'S') or (TC = #27);
end;


Procedure WriteDia;
begin
  GotoXY(24+K,14); Write(Sv1);
  Move(Mem[$B800:(14*160)+((23+K)*2)],Car,1);
  GotoXY(24+K,15); Write(Car);
  Move(Mem[$B800:(15*160)+((23+K)*2)],Car,1);
  GotoXY(24+K,16); Write(Car);
  GotoXY(24+K,17); Write(Sv2);
end;


Procedure EntryDia;
begin
  Sv1 := #25;
  Sv2 := #24;
  K   := 1;
  Color(Sfn,Stx);
  WriteDia;
  Repeat
    TC := ReadKey;
    If (TC = #0   ) and
       (KeyPressed) then
       begin
         TC  := ReadKey;
         Sv1 := ' ';
         Sv2 := ' ';
         Case TC of
            #75 : begin
                    If LoteMember.Dias[K] in ['C','S'] then Color(Bfn,Btx)
                                                       else Color(Tfn,Utx);
                    WriteDia;
                    If K > 1 then K := K - 1
                             else K := 31;
                    Color(Sfn,Stx);
                    Sv1 := #25;
                    Sv2 := #24;
                    WriteDia;
                  end;
            #77 : begin
                    If LoteMember.Dias[K] in ['C','S'] then Color(Bfn,Btx)
                                                       else Color(Tfn,Utx);
                    WriteDia;
                    If K < 31 then K := K + 1
                              else K := 1;
                    Color(Sfn,Stx);
                    Sv1 := #25;
                    Sv2 := #24;
                    WriteDia;
                  end;
         end;
       end;
    If TC = #13 then
       begin
         If K  > TabDia[MM] then
            begin
              ErroMsg := 'Dia inv lido para o mˆs';
              ErrorMessage;
              TC := #00;
            end
            else begin
                   If LoteMember.Dias[K] in ['C','S'] then Color(Bfn,Btx)
                                                      else Color(Tfn,Utx);
                   Sv1 := ' ';
                   Sv2 := ' ';
                   WriteDia;
                 end;
       end;
  Until TC in [#13,#27];
  If TC = #13 then
     begin
       Color(Sfn,Stx);
       WriteDia;
       Color(Tfn,Utx);
       If LoteMember.Dias[K] = '.' then LoteMember.Dias[K] := 'S';
       DLote := K;
       Str(CMstMember.AnoAtivo,XAno);
       XDL   := QQStr(DLote,2,'0');
       WData := XDL + '/' + QQStr(MM,2,'0') + '/' + XAno;
       TC    := 'S';
     end
     else begin
            If LoteMember.Dias[K] in ['C','S'] then Color(Bfn,Btx)
                                               else Color(Tfn,Utx);
            Sv1 := ' ';
            Sv2 := ' ';
            WriteDia;
          end;
end;


Procedure IncluiLote;
begin
  With LoteMember do
  begin
    Op          := 'I';
    MesContabil := MM;
    AnoContabil := CMstMember.AnoAtivo;
    Descricao   := '';
    Status      := 'A';
    DataAbert   := XDia + '/' + XMes + '/' + XAno;
    Tipo        := 'N';
    For I := 1 to 31 do Dias[I] := '.';
    Color(Tfn,Utx);
    GotoXY(12,09); Write(LoteNo);
    GotoXY(12,10); Write(QQStr(MesContabil,2,'0'),' (',
                         ArrayMesEx[MesContabil],
                         ' de ',AnoContabil,')');
    GotoXY(43,11); Write(DataAbert);
    GotoXY(12,11); Case Status of
                        'A' : Write('Ativo    ');
                        'C' : Write('Cancelado');
                   end;
    EntryLote;
    Move(ScArray4[1],MemW[$B800:0000],4000);
    If TC = 'S' then
       begin
         DL          := 'S';
         Chave       := LoteNo;
         Debito      := 0;
         RDebito     := 0;
         Credito     := 0;
         RCredito    := 0;
         ReadWrite(#04,'W','N',LoteNumber);
         LoadTree2 ( Root2 );
         ReadWrite(#16,'W','N',0);
       end
       else begin
              LoteNumber := Limite;
              RC         := 'N';
            end;
    TC  := #13;
  end;
end;


Procedure ScrollLote;
Var
   Cont,Direcao,
   F,Tkb          : Char;
   Sx,R,N         : Integer;
   RArray         : Array[1..7] of Integer;
   KArray         : Array[1..7] of Str6;
   SArray         : Array[1..7] of Char;
   MArray         : Array[1..7] of Str2;
   XArray         : Array[1..7] of Str31;
   DArray         : Array[1..7] of Integer;
   CArray         : Array[1..7] of Integer;
   VArray         : Array[1..7] of Str20;
   ScArrayS       : Array [1..4000] of Char;
begin
  Move(Mem[$B800:0000],ScArrayS[1],4000);
  FootScroll;
  DrawBox(2,11,76,21,Sfn,'S');
  Color(Bfn,Btx);
  GotoXY(2,11);
  Write('             Dias.....1.........2.........3.                               ');
  GotoXY(2,12);
  Write(' Lote.. S MM 1234567890123456789012345678901 D‚b. Cr‚.               Saldo ');
  Color(Sfn,Stx);
  F       := 'N';
  Direcao := 'P';
  L       := 0;
  Sx      := 1;
  For I := 1 to 7 do begin
                       KArray[I] := '';
                       RArray[I] := 0;
                       SArray[I] := ' ';
                       MArray[I] := '';
                       XArray[I] := '';
                       DArray[I] := 0;
                       CArray[I] := 0;
                       VArray[I] := '';
                     end;
  RC := 'N';
  SearchAnt2 ( Root2 );
  If RC = 'N' then LoteNo := '';
  Repeat
    RC := 'N';
    SearchPos2 ( Root2 );
    If RC = 'S' then
       begin
         ReadWrite(#04,'R','N',LoteNumber);
         If RW = 'S' then
            begin
              L := L + 1;
              KArray[L] := LoteNo;
              RArray[L] := LoteNumber;
              SArray[L] := LoteMember.Status;
              MArray[L] := QQStr(LoteMember.MesContabil,2,'0');
              XArray[L] := '';
              For R := 1 to 31 do XArray[L] := XArray[L] + LoteMember.Dias[R];
              DArray[L] := LoteMember.RDebito;
              CArray[L] := LoteMember.RCredito;
              VArray[L] := EditDouble(LoteMember.Credito);
            end;
       end
       else L := 7;
  Until L = 7;
  Repeat
    Window(2,14,77,21);
    For I := 1 to 7 do begin
                          If KArray[I] <> '' then
                             begin
                               If I = Sx then Color(Tfn,Utx)
                                         else Color(Sfn,Stx);
                               GotoXY(1,I);
                               Writeln(' ',PushLeft(7,KArray[I]),
                                           SArray[I],' ',MArray[I]:2,' ',
                                           XArray[I],' ',DArray[I]:4,' ',
                                           CArray[I]:4,' ',VArray[I]:19,' ');
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
                  Case Tkb of
                       'L' : If Sx > 1 then
                                begin
                                  Sx := Sx - 1;
                                  F  := 'N';
                                end
                                else begin
                                       LoteNo := KArray[1];
                                       RC     := 'N';
                                       SearchAnt2 ( Root2 );
                                       If RC = 'S' then
                                          begin
                                            ReadWrite(#04,'R','N',LoteNumber);
                                            If RW = 'S' then
                                               begin
                                                 For I := 7 downto 2 do
                                                 begin
                                                   KArray[I] := KArray[I - 1];
                                                   RArray[I] := RArray[I - 1];
                                                   SArray[I] := SArray[I - 1];
                                                   MArray[I] := MArray[I - 1];
                                                   XArray[I] := XArray[I - 1];
                                                   DArray[I] := DArray[I - 1];
                                                   CArray[I] := CArray[I - 1];
                                                   VArray[I] := VArray[I - 1];
                                                 end;
                                                 KArray[1] := LoteNo;
                                                 RArray[1] := LoteNumber;
                                                 SArray[1] := LoteMember.Status;
                                                 MArray[1] := QQStr(LoteMember.MesContabil,2,'0');
                                                 XArray[1] := '';
                                                 For R := 1 to 31
                                                 do XArray[1] := XArray[1] + LoteMember.Dias[R];
                                                 DArray[1] := LoteMember.RDebito;
                                                 CArray[1] := LoteMember.RCredito;
                                                 VArray[1] := EditDouble(LoteMember.Credito);
                                               end;
                                            F := 'N';
                                          end
                                          else F := 'A';
                                     end;
                       'P' : begin
                               Sx := 1;
                               N  := 0;
                               Repeat
                                 LoteNo := KArray[1];
                                 RC     := 'N';
                                 SearchAnt2 ( Root2 );
                                 If RC = 'S' then
                                    begin
                                      ReadWrite(#04,'R','N',LoteNumber);
                                      If RW = 'S' then
                                         begin
                                           For I := 7 downto 2 do
                                           begin
                                             KArray[I] := KArray[I - 1];
                                             RArray[I] := RArray[I - 1];
                                             SArray[I] := SArray[I - 1];
                                             MArray[I] := MArray[I - 1];
                                             XArray[I] := XArray[I - 1];
                                             DArray[I] := DArray[I - 1];
                                             CArray[I] := CArray[I - 1];
                                             VArray[I] := VArray[I - 1];
                                           end;
                                           KArray[1] := LoteNo;
                                           RArray[1] := LoteNumber;
                                           SArray[1] := LoteMember.Status;
                                           MArray[1] := QQStr(LoteMember.MesContabil,2,'0');
                                           XArray[1] := '';
                                           For R := 1 to 31
                                           do XArray[1] := XArray[1] + LoteMember.Dias[R];
                                           DArray[1] := LoteMember.RDebito;
                                           CArray[1] := LoteMember.RCredito;
                                           VArray[1] := EditDouble(LoteMember.Credito);
                                           N := N + 1;
                                         end;
                                      F := 'N';
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
                                       LoteNo := KArray[Sx];
                                       RC     := 'N';
                                       SearchPos2 ( Root2 );
                                       If RC = 'S' then
                                          begin
                                            ReadWrite(#04,'R','N',LoteNumber);
                                            If RW = 'S' then
                                               begin
                                                 For I := 2 to 7 do
                                                 begin
                                                   KArray[I - 1] := KArray[I];
                                                   RArray[I - 1] := RArray[I];
                                                   SArray[I - 1] := SArray[I];
                                                   MArray[I - 1] := MArray[I];
                                                   XArray[I - 1] := XArray[I];
                                                   DArray[I - 1] := DArray[I];
                                                   CArray[I - 1] := CArray[I];
                                                   VArray[I - 1] := VArray[I];
                                                 end;
                                                 KArray[7] := LoteNo;
                                                 RArray[7] := LoteNumber;
                                                 SArray[7] := LoteMember.Status;
                                                 MArray[7] := QQStr(LoteMember.MesContabil,2,'0');
                                                 XArray[7] := '';
                                                 For R := 1 to 31
                                                 do XArray[7] := XArray[7] + LoteMember.Dias[R];
                                                 DArray[7] := LoteMember.RDebito;
                                                 CArray[7] := LoteMember.RCredito;
                                                 VArray[7] := EditDouble(LoteMember.Credito);
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
                                 LoteNo := KArray[R];
                                 RC     := 'N';
                                 SearchPos2 ( Root2 );
                                 If RC = 'S' then
                                    begin
                                      ReadWrite(#04,'R','N',LoteNumber);
                                      If RW = 'S' then
                                         begin
                                           For I := 2 to 7 do
                                           begin
                                             KArray[I - 1] := KArray[I];
                                             RArray[I - 1] := RArray[I];
                                             SArray[I - 1] := SArray[I];
                                             MArray[I - 1] := MArray[I];
                                             XArray[I - 1] := XArray[I];
                                             DArray[I - 1] := DArray[I];
                                             CArray[I - 1] := CArray[I];
                                             VArray[I - 1] := VArray[I];
                                           end;
                                           KArray[7] := LoteNo;
                                           RArray[7] := LoteNumber;
                                           SArray[7] := LoteMember.Status;
                                           MArray[7] := QQStr(LoteMember.MesContabil,2,'0');
                                           XArray[7] := '';
                                           For R := 1 to 31
                                           do XArray[7] := XArray[7] + LoteMember.Dias[R];
                                           DArray[7] := LoteMember.RDebito;
                                           CArray[7] := LoteMember.RCredito;
                                           VArray[7] := EditDouble(LoteMember.Credito);
                                           N := N + 1;
                                         end;
                                    end;
                               Until (N = 7) or (RC = 'N');
                               F := 'N';
                             end;
                  end;
    end;
    If (F <> 'N') or (N < 7) then ScrollFim;
  Until Cont in [#13,#27];
  Move(ScArrayS[1],Mem[$B800:0000],4000);
  Color(Tfn,Utx);
  If Cont = #13 then
     begin
       LoteAN := RArray[Sx];
       LoteAC := KArray[Sx];
     end;
end;


Procedure LoadLancamentos(X,Y : Char);
Var
  DDx      : Str2;
  SSx      : Str4;
  LLx      : Str6;
  CCx      : Str18;
begin
  If X = 'S' then
     begin
       Color(Red,White);
       GotoXY(01,24); Write(ConstStr(' ',80));
       GotoXY(02,24);
       Case Y of
            '4' : begin
                    Write('Recarregando o indice de Lan‡amentos.');
                    If Root4 <> NIL then Dispose4 ( Root4 );
                    Root4  := NIL;
                  end;
            '6' : begin
                    Write('Carregando o indice de Lan‡amentos por Lote. ');
                    If Root6 <> NIL then Dispose6 ( Root6 );
                    Root6  := NIL;
                  end;
       end;
     end;
  CDVSNo := '';
  DCVSNo := '';
  Repeat
    RC := 'N';
    Case Y of
         '6' : SearchPos4 ( Root4 );
         '4' : SearchPos6 ( Root6 );
    end;
    If RC = 'S' then
       begin
         DDx := '';
         SSx := '';
         LLx := '';
         CCx := '';
         Case Y of
              '4' : begin
                      LLx := ScanCodigo(DCVSNo,1);
                      DDx := ScanCodigo(DCVSNo,2);
                      SSx := ScanCodigo(DCVSNo,3);
                      CCx := ScanCodigo(DCVSNo,4);
                      CDVSNo     := CCx + '#' + DDx + '#' + LLx + '#' + SSx;
                      CDVSNumber := DCVSNumber;
                      LoadTree4 ( Root4 );
                      DelTree6  ( Root6 );
                    end;
              '6' : begin
                      CCx := ScanCodigo(CDVSNo,1);
                      DDx := ScanCodigo(CDVSNo,2);
                      LLx := ScanCodigo(CDVSNo,3);
                      SSx := ScanCodigo(CDVSNo,4);
                      DCVSNo     := LLx + '#' + DDx + '#' + SSx + '#' + CCx;
                      DCVSNumber := CDVSNumber;
                      LoadTree6 ( Root6 );
                      DelTree4  ( Root4 );
                    end;
         end;
         RC := 'S';
       end;
  Until RC = 'N';
  If X = 'S' then LimpaLn(24,Tfd);
  Case Y of
       '4' : begin
               If Root6 <> NIL then Dispose6 ( Root6 );
               Root6 := NIL;
             end;
       '6' : begin
               If Root4 <> NIL then Dispose4 ( Root4 );
               Root4 := NIL;
             end;
  end;
end;


Procedure TelaTotalDoLote;
begin
  DrawBox(47,06,77,09,Sfn,'S');
  Color(Tfn,Ttx);
  GotoXY(47,06); Write('        Totais do Lote         ');
  Color(Sfn,Stx);
  GotoXY(48,07); Write('Db:');
  GotoXY(48,08); Write('Cr:');
  GotoXY(48,09); Write('Df:');
  Color(Tfn,Ttx);
end;


Procedure TotalDoLote;
Var
  Dif       : Double;
begin
  Color(Sfn,Stx);
  GotoXY(52,07); Write(EditDouble(LoteMember.Debito):20,' ',LoteMember.RDebito:4);
  Dif := LoteMember.Debito - LoteMember.Credito;
  GotoXY(52,08); Write(EditDouble(LoteMember.Credito):20,' ',LoteMember.RCredito:4);
  GotoXY(52,09);
  If Dif = 0 then Write(EditDouble(Dif):20,'     ')
             else If Dif < 0 then Write(EditDouble(Dif):20,'   Db')
                             else Write(EditDouble(Dif):20,'   Cr');
  Color(Tfn,Utx);
end;


{$I AlogLt01.inc }
{$I AlogLt02.inc }
{$I AlogLt03.inc }


Procedure RecebeNumero;
begin
  Color(Blue,Cyan);
  GotoXY(01,23);  Write(ConstStr(' ',80));
  GotoXY(02,23);  Write('Entre com o n£mero do Lan‡amento ou Tecle [     ] ');
  Color(Blue,Yellow);
  GotoXY(45,23); Write('Enter');
  Color(Red,Cyan);
  GotoXY(01,24);  Write(ConstStr(' ',80));
  GotoXY(02,24);  Write('Informado o n§ do lan‡amento ele ser  posicionado na 1¦ linha da janela.');
  J := '';
  Repeat
    InputStr(J,4,55,23,0,'S','N','T','N',Blue,LightGray);
  Until TC = #13;
  If J <> '' then Val(J,XLanc,E)
             else XLanc := 0;
  LimpaLn(23,Tfd);
  LimpaLn(24,Tfd);
end;


Procedure UpdateLote;
begin
           Titulo := 'Lotes ( Lan‡amentos )                  ';
           BuildFrame('S');
           Color(Red,White);
           GotoXY(62,07); Write(#27,#217);
           GotoXY(62,08); Write(#24);
           GotoXY(62,09); Write(#25);
           GotoXY(62,10); Write('F1');
           If XSt = 'A' then
              begin
                GotoXY(62,11); Write('F2');
                GotoXY(62,12); Write('F3');
                GotoXY(62,13); Write('F4');
                GotoXY(62,14); Write('F5');
                GotoXY(62,15); Write('F6');
                GotoXY(62,16); Write('F7');
                GotoXY(62,17); Write('F8');
                GotoXY(62,18); Write('F9');
              end;
           GotoXY(62,19); Write('F10');
           Color(Red,Yellow);
           GotoXY(66,07); Write('C¢digo  ');
           GotoXY(66,08); Write('Anterior');
           GotoXY(66,09); Write('Pr¢ximo ');
           GotoXY(66,10); Write('Lotes   ');
           If XSt = 'A' then
              begin
                GotoXY(66,11); Write('Renumerar   ');
                GotoXY(66,12); Write('Alterar     ');
                GotoXY(66,13); Write('Recalcular  ');
                GotoXY(66,14); Write('Incluir Lanc');
                GotoXY(66,15); Write('Imp.Exportar');
                GotoXY(66,16); Write('Alterar Lanc');
                GotoXY(66,17); Write('Cancelar Dia');
                GotoXY(66,18); Write('Reativar Dia');
              end;
           GotoXY(66,19); Write('Imprimir ');
           Shade(3,8,60,21,LightGray,Black);
           LoadLancamentos('S','6');
           TitleLote;
           Move(MemW[$B800:0000],ScArray4[1],4000);
  Conta1 := '';
  Conta2 := '';
  Repeat
    J := '';
    InputStr(J,6,12,9,0,'S','S','T','N',Tfn,Utx);
    LimpaLn(24,Tfd);
    If TC = #27
       then LoteNumber := Limite
       else If TC = #25 then
               begin
                 LoteNo := '';
                 RC     := 'N';
                 SearchPos2 ( Root2 );
                 If RC = 'N' then LoteNumber := Limite;
               end
               else If J <> '' then
                       begin
                         LoteNo := J;
                         SearchTree2 ( Root2 );
                         If RC = 'N' then
                            begin
                              If XSt = 'A' then
                                 begin
                                   LoteNumber := FileSize(LoteFile);
                                   WData      := XDia + '/' +
                                                 XMes + '/' + XAno;
                                   IncluiLote;
                                 end
                                 else LoteNumber := Limite;
                            end;
                       end
                       else LoteNumber := Limite;
    If LoteNumber <> Limite then
       With LoteMember do
       begin
         Repeat
           DataLote;
           Repeat
             Resp := ReadKey;
             LimpaLn(24,Tfd);
             If (Resp = #0) and (KeyPressed) then
                begin
                  Resp := ReadKey;
                  Case Resp of
                       #59 : begin
                               ScrollLote;
                               Move(ScArray4[1],MemW[$B800:0000],4000);
                               LoteNumber := LoteAN;
                               LoteNo     := LoteAC;
                               DataLote;
			     end;
                       #61 : If (MesContabil = MM ) and
                                (XSt         = 'A') then
                                begin
                                  Op  := 'A';
                                  Hl  := 0;
                                  Stl := LoteMember.Status;
                                  EntryLote;
                                  If TC = 'S' then
                                     begin
                                       ReadWrite(#04,'W','N',LoteNumber);
                                       Case LoteMember.Status of
                                            'A' : If Stl in ['E','C'] then RetiraColocaLote('C');
                                            else  If Stl = 'A' then RetiraColocaLote('R');
                                       end;
                                     end;
                                  Move(ScArray4[1],MemW[$B800:0000],4000);
                                  ShowHeap;
                                  DataLote;
                                end
                                else If XSt = 'A' then
                                        begin
                                          ErroMsg := 'O Mˆs n„o esta carregado!';
                                          ErrorMessage;
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
		       else  If (MesContabil = MM ) and
                                (Status      = 'A') and
                                (XSt         = 'A') then
				begin
				  Case Resp of
                                       #60 : begin
				               Renumera;
                                               Move(ScArray4[1],MemW[$B800:0000],4000);
                                               ShowHeap;
                                               DataLote;
                                             end;
                                       #62 : begin
                                               ReCalculaTotalLote;
                                               Move(ScArray4[1],MemW[$B800:0000],4000);
                                               ShowHeap;
                                               DataLote;
                                             end;
                                       #63 : begin
                                               EntryDia;
                                               If (TC                 = 'S') and
                                                  (LoteMember.Dias[K] = 'S') then
                                                  begin
                                                    DCVSNo     := '';
				                    DCVSNumber := Limite;
				                    TC         := #00;
                                                    Repeat
                                                      Case TC of
                                                           #00 : begin
                                                                   IncluiLancamento;
                                                                   If TruncX(Debito) <> TruncX(Credito)
                                                                      then TotalNaoBate('I')
                                                                      else TC := #27;
                                                                 end;
                                                           #01 : begin
                                                                   DCVSNo := LoteNo + '#';
                                                                   ScrollLancamento('D');
                                                                   If DCVSAC <> '' then
                                                                      begin
                                                                        DCVSNo := DCVSAC;
                                                                        AtualizaLancamento;
                                                                      end;
                                                                   If TruncX(Debito) <> TruncX(Credito)
                                                                      then TotalNaoBate('A')
                                                                      else TC := #27;
                                                                 end;
                                                      end;
                                                      Move(ScArray4[1],MemW[$B800:0000],4000);
                                                      ShowHeap;
                                                      DataLote;
                                                    Until (TC = #117) or
                                                          ((TC = #27) and (TruncX(Debito) = TruncX(Credito)));
                                                  end
                                                  else If TC = 'S' then
                                                          begin
                                                            ErroMsg := 'O dia esta Cancelado - Reative antes';
                                                            ErrorMessage;
                                                          end;
                                             end;
                                       #64 : begin
                                               DCVSNo     := '';
				               DCVSNumber := Limite;
                                               InterfaceLote('M');
                                               Move(ScArray4[1],MemW[$B800:0000],4000);
                                               ShowHeap;
                                               DataLote;
                                             end;
                                       #65 : begin
                                               EntryDia;
                                               If (TC                 = 'S') and
                                                  (LoteMember.Dias[K] = 'S') then
                                                  begin
                                                    DCVSNo     := '';
				                    DCVSNumber := Limite;
                                                    RecebeNumero;
                                                    If XLanc > 0 then DCVSNo := LoteNo + '#' + XDL + '#' + QQStr(XLanc,4,'0')
                                                                 else DCVSNo := LoteNo + '#' + XDL + '#';
                                                    TC := #01;
                                                    Repeat
                                                      Case TC of
                                                           #00 : begin
                                                                   IncluiLancamento;
                                                                   If TruncX(Debito) <> TruncX(Credito)
                                                                      then TotalNaoBate('I')
                                                                      else TC := #27;
                                                                 end;
                                                           #01 : begin
                                                                   DCVSAC := DCVSNo;
                                                                   DCVSAN := DCVSNumber;
                                                                   ScrollLancamento('D');
                                                                   If DCVSAC <> '' then
                                                                      begin
                                                                        DCVSNo := DCVSAC;
                                                                        AtualizaLancamento;
                                                                      end;
                                                                   If TruncX(Debito) <> TruncX(Credito) then
                                                                      begin
                                                                        TotalNaoBate('A');
							                DCVSNo := LoteNo + '#' + XDL + '#';
                                                                      end
                                                                      else TC := #27;
                                                                 end;
                                                      end;
                                                      Move(ScArray4[1],MemW[$B800:0000],4000);
                                                      ShowHeap;
                                                      DataLote;
                                                    Until (TC = #117) or
                                                          ((TC = #27) and (TruncX(Debito) = TruncX(Credito)));
                                                  end
                                                  else If TC = 'S' then
                                                          begin
                                                            ErroMsg := 'O dia esta Cancelado - Reative antes';
                                                            ErrorMessage;
                                                            DataLote;
                                                          end;
                                             end;
                                       #66 : begin
                                               EntryDia;
                                               If (TC = 'S') and (LoteMember.Dias[K] = 'S') then
                                                  begin
                                                    RetiraColocaDia('R');
                                                    Move(ScArray4[1],MemW[$B800:0000],4000);
                                                    ShowHeap;
                                                    DataLote;
                                                  end
                                                  else If TC = 'S' then
                                                          begin
                                                            ErroMsg := 'O dia j  esta Cancelado';
                                                            ErrorMessage;
                                                            DataLote;
                                                          end;
                                             end;
                                       #67 : begin
                                               EntryDia;
                                               If (TC = 'S') and (LoteMember.Dias[K] = 'C') then
                                                  begin
                                                    RetiraColocaDia('C');
                                                    Move(ScArray4[1],MemW[$B800:0000],4000);
                                                    ShowHeap;
                                                    DataLote;
                                                  end
                                                  else If TC = 'S' then
                                                          begin
                                                            ErroMsg := 'O dia j  esta Ativo';
                                                            ErrorMessage;
                                                            DataLote;
                                                          end;
                                             end;
                                       #68 : PrintLote('');
                                       #84 : PrintTotal;
                                       #85 : begin
                                               DCVSNo     := '';
				               DCVSNumber := Limite;
                                               TC         := #01;
                                               Repeat
                                                 ScrollLancamento('G');
                                                 If TruncX(Debito) <> TruncX(Credito) then
                                                    begin
                                                      TotalNaoBate('G');
                                                      DCVSNo := LoteNo + '#' + XDL + '#';
                                                    end
                                                    else TC := #27;
                                                 Move(ScArray4[1],MemW[$B800:0000],4000);
                                                 ShowHeap;
                                                 DataLote;
                                               Until (TC = #117) or
                                                     ((TC = #27) and (TruncX(Debito) = TruncX(Credito)));
                                             end;
                                       #86 : begin
                                               DCVSNo     := '';
				               DCVSNumber := Limite;
                                               InterfaceLote('A');
                                               Move(ScArray4[1],MemW[$B800:0000],4000);
                                               ShowHeap;
                                               DataLote;
                                             end;
                                  end;
                                end
                                else If XSt = 'A' then
                                        begin
                                          ErroMsg := 'O Lote n„o ‚ do mˆs ou esta cancelado';
                                          ErrorMessage;
                                        end;
                  end;
                end
                else If Resp = '?' then
                        begin
                          Color(Red,White);
                          GotoXY(01,24); Write(ConstStr(' ',80));
                          GotoXY(02,24); Write('Shift+');
                          GotoXY(28,24); Write('Shift+');
                          GotoXY(53,24); Write('Shift+');
                          Color(Red,Yellow);
                          GotoXY(08,24); Write('F1');
                          GotoXY(34,24); Write('F2');
                          GotoXY(59,24); Write('F3');
                          Color(Red,Cyan);
                          GotoXY(10,24); Write(#26);
                          GotoXY(36,24); Write(#26);
                          GotoXY(61,24); Write(#26);
                          Color(Red,LightGray);
                          GotoXY(11,24); Write('Totais di rios');
                          GotoXY(37,24); Write('Acesso direto');
                          GotoXY(62,24); Write('Exporta movimento');
                        end;
           Until (Resp in [#13,#27]) or ((Resp in [#72,#80]) and (RC <> 'N'));
           Move(ScArray4[1],MemW[$B800:0000],4000);
         Until (Resp = #13) or (Resp = #27);
         TC := Resp;
       end;
  Until TC = #27;
  ReadWrite(#16,'W','N',0);
  LoadLancamentos('S','4');
end;


Procedure RecalculaSaldo;
begin
  DrawBox(30,15,57,18,Bfn,'S');
  Color(Bfn,Btx);
  GotoXY(31,16); Write('Aguarde um instante, estou');
  GotoXY(31,17); Write('zerando  os Saldos do Mˆs.');
  Color(Tfn,Utx);
  ContaNo := '';
  Repeat
    RC := 'N';
    SearchPos1 ( Root1 );
    If RC = 'S' then
       With SaldMember do
       begin
         ReadWrite(#03,'R','N',ContaNumber);
         ReadWrite(#06,'R','N',ContaNumber);
         Debitos[MM]  := 0;
         Creditos[MM] := 0;
         Saldo[MM]    := 0;
         SaldoB[MM]   := 0;
         NLanctos[MM] := 0;
         For I := MM to 12 do
         begin
           If (I >  1) and
              ((CMstMember.TipoE <> 'M') or
               ((CMstMember.TipoE = 'M') and
                (ContaMember.Grupo in ['A','P'])))
              then Abertura[I] := Saldo[I-1];
           If ((CMstMember.TipoE <> 'M') or
               ((CMstMember.TipoE = 'M') and
                (ContaMember.Grupo in ['A','P']))) then
              begin
                Saldo[I]  := Abertura[I] + Debitos[I] - Creditos[I];
                SaldoB[I] := Saldo[I];
              end;
         end;
         ReadWrite(#06,'W','N',ContaNumber);
       end;
  Until RC = 'N';
  ExpeNo := '';
  Repeat
    RC := 'N';
    SearchPos5 ( Root5 );
    If RC = 'S' then
       begin
         ReadWrite(#07,'R','N',ExpeNumber);
         ExpeMember.Despesas[MM] := 0;
         ReadWrite(#07,'W','N',ExpeNumber);
       end;
  Until RC = 'N';
  Color(Tfn,Ttx);
  GotoXY(04,09); Write('Lan‡amentos processados:');
  Color(Tfn,Utx);
  XLanc := 0;
  If FileSize(LctoFile) <> 0 then
     begin
       DrawBox(2,10,70,19,Sfn,'S');
       Color(Bfn,Btx);
       GotoXY(2,10);
       Write(' Lote   Seq. DD S Conta              D/C                Valor Depto. ');
       Color(Sfn,Stx);
       CDVSNo := '';
       Repeat
         RC := 'N';
         SearchPos4 ( Root4 );
         If RC = 'S' then
            begin
              ReadWrite(#08,'R','N',CDVSNumber);
              If (RW                  = 'S') and
                 (LctoMember.Status   = 'A') then
                 begin
                   ContaNo := LimpaChave(LctoMember.Conta);
                   SearchTree1 ( Root1 );
                   If RC = 'S' then
                      begin
                        ReadWrite(#03,'R','N',ContaNumber);
                        Color(Sfn,Stx);
                        Window(3,12,70,19);
                        GotoXY(1,8);
                        Writeln(PushLeft(7,LctoMember.Lote),
                                PushLeft(5,LctoMember.SeqLote),
                                Copy(LctoMember.OrigData,1,2),' ',
                                LctoMember.Status,' ',
                                PushLeft(20,ContaMember.OrigConta),
                                LctoMember.Tipo,' ':2,
                                EditDouble(LctoMember.Valor):20,' ',
                                LctoMember.Depto:6);
                        If (ContaMember.Grupo in ['D','R']) and
                           (LctoMember.Depto  <> ''       ) then
                           begin
                             DeptNo := LimpaChave(LctoMember.Depto);
                             SearchTree3 ( Root3 );
                             If RC = 'S' then
                                begin
                                  ReadWrite(#05,'R','N',DeptNumber);
                                  ColocaNaDespesa;
                                end;
                           end;
                        LoteNo := LctoMember.Lote;
                        SearchTree2 ( Root2 );
                        If RC = 'S' then
                           begin
                             ReadWrite(#04,'R','N',LoteNumber);
                             If RW = 'S' then ColocaNaConta(LoteMember.Tipo,'I');
                           end;
                        Window(1,1,80,25);
                        XLanc := XLanc + 1;
                        Color(Tfn,Utx);
                        GotoXY(29,09); Write(XLanc:5);
                      end
                      else RC := 'S';
                 end
                 else If LctoMember.Status <> 'A' then
                         begin
                           ContaNo := LimpaChave(LctoMember.Conta);
                           SearchTree1 ( Root1 );
                           If RC = 'S' then
                              begin
                                ReadWrite(#06,'R','N',ContaNumber);
	                        SaldMember.NLanctos[MM] := SaldMember.NLanctos[MM]   + 1;
                                XLanc                   := XLanc + 1;
                                ReadWrite(#06,'W','N',ContaNumber);
                                Window(1,1,80,25);
                                Color(Tfn,Utx);
                                GotoXY(29,09); Write(XLanc:5);
                              end;
                         end;
              RC := 'S';
            end;
       Until RC = 'N';
     end;
  ReadWrite(#16,'W','N',0);
  Color(Blue,Cyan);
  GotoXY(1,23); Write(' ':80);
  GotoXY(2,23); Write('O saldo de todas as contas no mˆs foram recalculados');
  TeclaReturn;
end;

end.

