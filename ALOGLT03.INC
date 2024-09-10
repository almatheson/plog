Procedure PrintTotal;
Var
  DiaA          : Str2;
  N1,N2,NG1,NG2 : Integer;
  T1,T2,TG1,TG2 : Double;
begin
  QPorta;
  If TC = #13 then
     begin
       Color(Blue,Yellow);
       GotoXY(1,23); Write(' ':80);
       GotoXY(2,23); Write('Relat¢rio de totais di rios do Lote.');
       Tamanho;
       ContLin := 100;
       DiaA    := '';
       T1      := 0;
       T2      := 0;
       TG1     := 0;
       TG2     := 0;
       N1      := 0;
       N2      := 0;
       NG1     := 0;
       NG2     := 0;
       CabecalhoLote('T');
       DCVSNo := LoteNo + '#';
       Repeat
         RC := 'N';
         SearchPos6 ( Root6 );
         If (RC     = 'S'                          ) and
            (LoteNo = Copy(DCVSNo,1,Length(LoteNo))) then
            begin
              ReadWrite(#08,'R','N',DCVSNumber);
              If RW = 'S' then
                 begin
                   If DiaA = '' then DiaA := Copy(LctoMember.OrigData,1,2);
                   If DiaA <> Copy(LctoMember.OrigData,1,2) then
                      begin
                        If TruncX(T1) <> TruncX(T2)
                           then WriteLine('L',ConstStr(' ',Trunc((T - 55)/2))+
                                              PushRight(2,DiaA)+' '+
                                              PushRight(20,EditDouble(T1))+' '+
                                              PushRight(4,EditInteger(N1))+
                                              ConstStr(' ',2)+
                                              PushRight(20,EditDouble(T2))+' '+
                                              PushRight(4,EditInteger(N2))+'   *****')
                           else WriteLine('L',ConstStr(' ',Trunc((T - 55)/2))+
                                              PushRight(2,DiaA)+' '+
                                              PushRight(20,EditDouble(T1))+' '+
                                              PushRight(4,EditInteger(N1))+
                                              ConstStr(' ',2)+
                                              PushRight(20,EditDouble(T2))+' '+
                                              PushRight(4,EditInteger(N2)));
                        N1   := 0;
                        N2   := 0;
                        T1   := 0;
                        T2   := 0;
                        DiaA := Copy(LctoMember.OrigData,1,2);
                      end;
                   Case LctoMember.Tipo of
                        'D' : If LctoMember.Status = 'A' then
                                 begin
                                   T1  := T1  + TruncX(LctoMember.Valor);
                                   N1  := N1  + 1;
                                   TG1 := TG1 + TruncX(LctoMember.Valor);
                                   NG1 := NG1 + 1;
                                 end;
                        'C' : If LctoMember.Status = 'A' then
                                 begin
                                   T2  := T2  + TruncX(LctoMember.Valor);
                                   N2  := N2  + 1;
                                   TG2 := TG2 + TruncX(LctoMember.Valor);
                                   NG2 := NG2 + 1;
                                 end;
                   end;
                 end
                 else If RW = 'N' then
                         begin
                           ErroMsg := 'Erro de leitura  - Vou abortar';
                           ErrorMessage;
                           RC := 'N';
                         end;
            end;
         GoNoGo;
         If TC = #27 then RC := 'N';
       Until RC = 'N';
       If TruncX(T1) <> TruncX(T2)
          then WriteLine('L',ConstStr(' ',Trunc((T - 55)/2))+
                             PushRight(2,DiaA)+' '+
                             PushRight(20,EditDouble(T1))+' '+
                             PushRight(4,EditInteger(N1))+
                             ConstStr(' ',2)+
                             PushRight(20,EditDouble(T2))+' '+
                             PushRight(4,EditInteger(N2))+'   *****')
          else WriteLine('L',ConstStr(' ',Trunc((T - 55)/2))+
                             PushRight(2,DiaA)+' '+
                             PushRight(20,EditDouble(T1))+' '+
                             PushRight(4,EditInteger(N1))+
                             ConstStr(' ',2)+
                             PushRight(20,EditDouble(T2))+' '+
                             PushRight(4,EditInteger(N2)));
       WriteLine('L',' ');
       WriteLine('L',ConstStr(' ',Trunc((T - 55)/2))+
                     ConstStr(' ',3)+
                     ConstStr('-',20)+' ----'+ConstStr(' ',2)+
                     ConstStr('-',20)+' ----');
       WriteLine('L',ConstStr(' ',Trunc((T - 55)/2))+ConstStr(' ',3)+
                     PushRight(20,EditDouble(TG1))+' '+
                     PushRight(4,EditInteger(NG1))+ConstStr(' ',2)+
                     PushRight(20,EditDouble(TG2))+' '+
                     PushRight(4,EditInteger(NG2)));
       TC := #13;
       If DskRpt = 'N' then WriteLine('W',Qp);
       Close ( LST );
     end
     else TC := 'N';
  LimpaLn(23,Tfd);
end;


Procedure MoveParaArray(L : Integer);
begin
  KArray[L] := DCVSNo;
  RArray[L] := DCVSNumber;
  LArray[L] := LctoMember.Lote;
  SArray[L] := LctoMember.SeqLote;
  DArray[L] := LctoMember.OrigData;
  XArray[L] := LctoMember.Status;
  CArray[L] := LctoMember.Conta;
  TArray[L] := LctoMember.Tipo;
  VArray[L] := EditDouble(LctoMember.Valor);
  PArray[L] := LctoMember.Depto;
end;


Procedure ArrayParaArray(D,P : Integer);
begin
  KArray[P] := KArray[D];
  RArray[P] := RArray[D];
  LArray[P] := LArray[D];
  SArray[P] := SArray[D];
  DArray[P] := DArray[D];
  XArray[P] := XArray[D];
  CArray[P] := CArray[D];
  TArray[P] := TArray[D];
  VArray[P] := VArray[D];
  PArray[P] := PArray[D];
end;


Procedure ScrollLancamento(X : Char);
Var
   Cont,Direcao,
   F,Tkb          : Char;
   Sx,N,R         : Integer;
   DataO          : Str10;
   ScArrayS       : Array [1..4000] of Char;
begin
  Move(Mem[$B800:0000],ScArrayS[1],4000);
  TelaTotalDoLote;
  TotalDoLote;
  Color(Blue,White);
  GotoXY(01,23); Write(ConstStr(' ',80));
  GotoXY(04,23); Write(#25);
  GotoXY(06,23); Write('PgDn');
  GotoXY(21,23); Write(#24);
  GotoXY(23,23); Write('PgUp');
  GotoXY(40,23); Write('Esc');
  Case X of
       'D' : begin
               GotoXY(50,23); Write('Enter');
               GotoXY(68,23); Write('F3');
               Color(Blue,Cyan);
               GotoXY(55,23); Write(#26,'Seleciona');
               GotoXY(70,23); Write(#26,'Alterar');
             end;
       'G' : begin
               GotoXY(50,23); Write('F3');
               GotoXY(69,23); Write('Shift F2');
               Color(Blue,Cyan);
               GotoXY(52,23); Write(#26,'Alterar');
               GotoXY(62,23); Write('[Op‡„o');
               GotoXY(77,23); Write(']');
             end;
  end;
  GotoXY(05,23); Write('/');
  GotoXY(10,23); Write(#26,'Pr¢ximo');
  GotoXY(22,23); Write('/');
  GotoXY(27,23); Write(#26,'Anterior');
  GotoXY(43,23); Write(#26,'Fim');
  LimpaLn(24,Red);
  DrawBox(2,11,71,20,Sfn,'S');
  Color(Bfn,Btx);
  GotoXY(2,11);
  Write(' Seq. DD/MM/AAAA S Conta              D/C                Valor Depto. ');
  Color(Sfn,Stx);
  F       := 'N';
  Direcao := 'P';
  L       := 0;
  Sx      := 1;
  For I := 1 to 7 do begin
                       KArray[I] := '';
                       RArray[I] := 0;
                       LArray[I] := '';
                       SArray[I] := '';
                       DArray[I] := '';
                       XArray[I] := ' ';
                       CArray[I] := '';
                       TArray[I] := ' ';
                       VArray[I] := '';
                       PArray[I] := '';
                     end;
  If X = 'G' then DCVSNo := LoteNo + '#';
  Repeat
    RC := 'N';
    SearchPos6 ( Root6 );
    If (RC = 'S') and (LoteNo+'#' = Copy(DCVSNo,1,Length(LoteNo)+1)) then
       begin
         ReadWrite(#08,'R','N',DCVSNumber);
         If (RW      = 'S'                           ) and
            ((XDL    = Copy(LctoMember.OrigData,1,2))  and
             (X      = 'D'                          )) or
            (X       = 'G'                           ) then
            begin
              L := L + 1;
              MoveParaArray(L);
            end;
       end
       else begin
              RC := 'N';
              L  := 7;
            end;
  Until L = 7;
  Repeat
    Window(2,13,72,20);
    For I := 1 to 7 do begin
                          If KArray[I] <> '' then
                             begin
                               If I = Sx then Color(Tfn,Utx)
                                         else Color(Sfn,Stx);
                               GotoXY(1,I);
                               Writeln(' ',PushLeft(5,SArray[I]),
                                       DArray[I]:10,' ',XArray[I],' ',
                                       Pushleft(20,CArray[I]),
                                       TArray[I],' ':2,VArray[I]:20,' ',
                                       PArray[I]:6,' ');
                               Color(Sfn,Stx);
                             end
                             else begin
                                    Color(Sfn,Stx);
                                    GotoXY(1,I); Writeln(ConstStr(' ',70));
                                  end;
                       end;
    Window(1,1,80,25);
    Cont := ReadKey;
    If (Cont = #00) and (KeyPressed) then
       begin
         Cont := ReadKey;
         Case Cont of
              #61 : begin
                      ReadWrite(#08,'R','N',RArray[Sx]);
                      If RW = 'S' then
                         begin
                           ContaNo := LimpaChave(LctoMember.Conta);
                           ContaAC  := ContaNo;
                           DataO    := LctoMember.OrigData;
                           Val(Copy(LctoMember.OrigData,1,2),I,E);
                           SearchTree1 ( Root1 );
                           If (RC                  = 'S') and
                              (LoteMember.Dias[I] <> 'C') then
                              begin
                                ReadWrite(#03,'R','N',ContaNumber);
                                If LctoMember.Status  = 'A' then
                                   begin
                                     Case LctoMember.Tipo of
                                          'D' : LoteMember.Debito  :=
                                                LoteMember.Debito   -
                                                TruncX(LctoMember.Valor);
                                          'C' : LoteMember.Credito :=
                                                LoteMember.Credito  -
                                                TruncX(LctoMember.Valor);
                                     end;
                                     If (Length(LctoMember.Depto)  <> 0) and
                                        (ContaMember.Grupo in ['D','R'])
                                        then RetiraDaDespesa;
                                     RetiraDaConta(LoteMember.Tipo,'E');
                                   end;
                                Window(2,13,70,20);
                                N := 1;
                                Repeat
                                  Case N of
                                       1 : Repeat
                                             J := Copy(LctoMember.OrigData,1,2);
                                             InputStr(J,2,7,Sx,0,'S','N','T','N',Tfn,Utx);
                                             If Length(J) = 1 then J := '0' + J;
                                             Val(J,I,E);
                                             If (I > 0          ) and
                                                (I <= TabDia[MM]) then
                                                begin
                                                  LctoMember.OrigData := J + Copy(LctoMember.OrigData,3,8);
                                                  DArray[Sx]          := LctoMember.OrigData;
                                                  RC                  := 'S';
                                                end
                                                else RC := 'N';
                                           Until RC = 'S';
                                       2 : Repeat
                                             J := LctoMember.Status;
                                             InputStr(J,1,18,Sx,0,'S','N','T','N',Tfn,Utx);
                                             LctoMember.Status := UpCase(J[1]);
                                             XArray[Sx]        := LctoMember.Status;
                                           Until LctoMember.Status in ['A','C'];
                                       3 : Repeat
                                             RC := 'N';
                                             J  := LctoMember.Conta;
                                             InputStr(J,18,20,Sx,0,'S','N','T','N',Tfn,Utx);
                                             If J <> '' then ContaNo := LimpaChave(J)
                                                        else ContaNo := ContaAC;
                                             If ContaAC <> ContaNo then
                                                begin
                                                  SearchTree1 ( Root1 );
                                                  If RC = 'S' then
                                                     begin
                                                       ReadWrite(#03,'R','N',ContaNumber);
                                                       LctoMember.Conta := ContaMember.OrigConta;
                                                     end;
                                                end
                                                else RC := 'S';
                                             CArray[Sx] := LctoMember.Conta;
                                           Until RC = 'S';
                                       4 : Repeat
                                             J := LctoMember.Tipo;
                                             InputStr(J,1,40,Sx,0,'S','N','T','N',Tfn,Utx);
                                             LctoMember.Tipo := UpCase(J[1]);
                                             TArray[Sx]      := LctoMember.Tipo;
                                           Until LctoMember.Tipo in ['C','D'];
                                       5 : begin
                                             Str(LctoMember.Valor:15:2,J);
                                             J := LeftAdjust(J);
                                             InputStr(J,20,43,Sx,0,'S','N','$','N',Tfn,Utx);
                                             Val(J,LctoMember.Valor,E);
                                             VArray[Sx] := EditDouble(LctoMember.Valor);
                                           end;
                                       6 : begin
                                             J := LctoMember.Depto;
                                             InputStr(J,6,64,Sx,0,'S','N','T','N',Tfn,Utx);
                                             LctoMember.Depto := J;
                                             PArray[Sx]       := LctoMember.Depto;
                                           end;
                                  end;
                                  Case TC of
                                       #13 : N := N + 1;
                                       #24 : If N > 1 then N := N - 1
                                                      else N := 6;
                                  end;
                                Until (N = 7) or (TC = #27);
                                Window(1,1,80,25);
                                ReadWrite(#08,'W','N',RArray[Sx]);
                                Case LctoMember.Status of
                                     'A' : begin
                                             Case LctoMember.Tipo of
                                                  'D' : LoteMember.Debito  := LoteMember.Debito   +
                                                                              TruncX(LctoMember.Valor);
                                                  'C' : LoteMember.Credito := LoteMember.Credito  +
                                                                              TruncX(LctoMember.Valor);
                                             end;
                                             ContaNo := LimpaChave(CArray[Sx]);
                                             If (ContaAC <> ContaNo            ) or
                                                (DataO   <> LctoMember.OrigData) then
                                                begin
                                                  DCVSNo := KArray[Sx];
                                                  DelTree6 ( Root6 );
                                                  KArray[Sx] := LoteNo                        + '#' +
                                                                Copy(LctoMember.OrigData,1,2) + '#' +
                                                                LctoMember.SeqLote            + '#' +
                                                                ContaNo;
                                                  DCVSNo     := KArray[Sx];
                                                  DCVSNumber := RArray[Sx];
                                                  LoadTree6 ( Root6 );
                                                  Val(Copy(LctoMember.OrigData,1,2),I,E);
                                                  LoteMember.Dias[I] := 'S';
                                                  DM := 'S';
                                                end;
                                             If (Length(LctoMember.Depto)  <> 0 ) and
                                                (ContaMember.Grupo in ['D','R'] )
                                                then ColocaNaDespesa;
                                             ColocaNaConta(LoteMember.Tipo,'I');
                                           end;
                                     'C' : begin
                                             Case LctoMember.Tipo of
                                                  'D' : LoteMember.RDebito  := LoteMember.RDebito  - 1;
                                                  'C' : LoteMember.RCredito := LoteMember.RCredito - 1;
                                             end;
                                             DCVSNo := KArray[Sx];
                                             DelTree6 ( Root6 );
                                             LctoMember.Status   := '*';
                                             LctoMember.OrigData := '';
                                             LctoMember.Conta    := '';
                                             LctoMember.Lote     := '';
                                             ReadWrite(#08,'W','N',RArray[Sx]);
                                             For I := Sx to 6 do
                                             begin
                                               ArrayParaArray((I + 1),I);
                                               If KArray[I] <> '' then DCVSNo := KArray[I];
                                             end;
                                             KArray[7] := '';
                                             RArray[7] := 0;
                                             LArray[7] := '';
                                             SArray[7] := '';
                                             DArray[7] := '';
                                             XArray[7] := ' ';
                                             CArray[7] := '';
                                             TArray[7] := ' ';
                                             VArray[7] := '';
                                             PArray[7] := '';
                                             RC := 'N';
                                             SearchPos6 ( Root6 );
                                             If (RC     = 'S'                          ) and
                                                (LoteNo = Copy(DCVSNo,1,Length(LoteNo))) then
                                                begin
                                                  ReadWrite(#08,'R','N',DCVSNumber);
                                                  If (RW      = 'S'                           ) and
                                                     ((XDL    = Copy(LctoMember.OrigData,1,2))  and
                                                      (X      = 'D'                          )) or
                                                     (X       = 'G'                           ) then
                                                     begin
                                                       I := Sx;
                                                       Repeat
                                                         I := I + 1;
                                                         If KArray[I] = '' then
                                                            begin
                                                              MoveParaArray(I);
                                                              I := 7;
                                                            end;
                                                       Until I = 7;
                                                     end;
                                                  F := 'N';
                                                end
                                                else F := 'P';
                                             Repeat
                                               If (KArray[Sx] = '') and
                                                  (Sx         > 1 ) then Sx := Sx - 1;
                                             Until (KArray[Sx] <> '') or (Sx = 1);
                                             DM := 'S';
                                           end;
                                end;
                                TotalDoLote;
                                ReadWrite(#04,'W','N',LoteNumber);
                              end;
                           Direcao := 'N';
                           Cont    := #00;
                           TC      := #00;
                         end;
                    end;
              #72 : begin
                      Tkb     := 'L';
                      Direcao := 'A';
                      Color(Blue,White);
                      GotoXY(04,23); Write(#25);
                      GotoXY(06,23); Write('PgDn');
                      GotoXY(23,23); Write('PgUp');
                      Color(Blue,(White + Blink));
                      GotoXY(21,23); Write(#24);
                    end;
              #73 : begin
                      Tkb     := 'P';
                      Direcao := 'A';
                      Color(Blue,White);
                      GotoXY(04,23); Write(#25);
                      GotoXY(06,23); Write('PgDn');
                      GotoXY(21,23); Write(#24);
                      Color(Blue,(White + Blink));
                      GotoXY(23,23); Write('PgUp');
                    end;
              #80 : begin
                      Tkb     := 'L';
                      Direcao := 'P';
                      Color(Blue,(White + Blink));
                      GotoXY(04,23); Write(#25);
                      Color(Blue,White);
                      GotoXY(06,23); Write('PgDn');
                      GotoXY(21,23); Write(#24);
                      GotoXY(23,23); Write('PgUp');
                    end;
              #81 : begin
                      Tkb     := 'P';
                      Direcao := 'P';
                      Color(Blue,(White + Blink));
                      GotoXY(06,23); Write('PgDn');
                      Color(Blue,White);
                      GotoXY(04,23); Write(#25);
                      GotoXY(21,23); Write(#24);
                      GotoXY(23,23); Write('PgUp');
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
                                       DCVSNo := KArray[1];
                                       RC     := 'N';
                                       SearchAnt6 ( Root6 );
                                       If (RC         = 'S'                            ) and
                                          (LoteNo+'#' = Copy(DCVSNo,1,Length(LoteNo)+1)) then
                                          begin
                                            ReadWrite(#08,'R','N',DCVSNumber);
                                            If (RW   = 'S'                           ) and
                                               ((XDL = Copy(LctoMember.OrigData,1,2))  and
                                                (X   = 'D'                          )) or
                                               (X    = 'G'                           ) then
                                               begin
                                                 For I := 7 downto 2
                                                 do ArrayParaArray((I - 1),I);
                                                 MoveParaArray(1);
                                               end;
                                            F := 'N';
                                          end
                                          else begin
                                                 F  := 'A';
                                                 RC := 'N';
                                               end;
                                     end;
                       'P' : begin
                               Sx := 1;
                               N  := 0;
                               Repeat
                                 DCVSNo := KArray[1];
                                 RC     := 'N';
                                 SearchAnt6 ( Root6 );
                                 If (RC         = 'S'                            ) and
                                    (LoteNo+'#' = Copy(DCVSNo,1,Length(LoteNo)+1)) then
                                    begin
                                      ReadWrite(#08,'R','N',DCVSNumber);
                                      If (RW   = 'S'                           ) and
                                         ((XDL = Copy(LctoMember.OrigData,1,2))  and
                                          (X   = 'D'                          )) or
                                         (X    = 'G'                           ) then
                                         begin
                                           For I := 7 downto 2
                                           do ArrayParaArray((I - 1),I);
                                           MoveParaArray(1);
                                           N := N + 1;
                                           F := 'N';
                                         end
                                         else F := 'A';
                                    end
                                    else begin
                                           F  := 'A';
                                           RC := 'N';
                                         end;
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
                                       DCVSNo := KArray[Sx];
                                       RC     := 'N';
                                       SearchPos6 ( Root6 );
                                       If (RC         = 'S'                            ) and
                                          (LoteNo+'#' = Copy(DCVSNo,1,Length(LoteNo)+1)) then
                                          begin
                                            ReadWrite(#08,'R','N',DCVSNumber);
                                            If (RW      = 'S'                           ) and
                                               ((XDL    = Copy(LctoMember.OrigData,1,2))  and
                                                (X      = 'D'                          )) or
                                               (X       = 'G'                           ) then
                                               begin
                                                 For I := 2 to 7
                                                 do ArrayParaArray(I,(I - 1));
                                                 MoveParaArray(7);
                                               end;
                                            F := 'N';
                                          end
                                          else begin
                                                 F  := 'P';
                                                 RC := 'N';
                                               end;
                                     end;
                       'P' : begin
                               Sx := 1;
                               N  := 0;
                               Repeat
                                 R := 7;
                                 For L := 1 to 7
                                 do If KArray[L] <> '' then R := L;
                                 DCVSNo := KArray[R];
                                 RC     := 'N';
                                 SearchPos6 ( Root6 );
                                 If (RC         = 'S'                            ) and
                                    (LoteNo+'#' = Copy(DCVSNo,1,Length(LoteNo)+1)) then
                                    begin
                                      ReadWrite(#08,'R','N',DCVSNumber);
                                      If (RW      = 'S'                           ) and
                                         ((XDL    = Copy(LctoMember.OrigData,1,2))  and
                                          (X      = 'D'                          )) or
                                         (X       = 'G'                           ) then
                                         begin
                                           For I := 2 to 7
                                           do ArrayParaArray(I,(I - 1));
                                           MoveParaArray(R);
                                           N := N + 1;
                                         end
                                         else RC := 'N';
                                    end
                                    else RC := 'N';
                               Until (N = 7) or (RC = 'N');
                               F := 'N';
                             end;
                  end;
    end;
    If (F <> 'N') or (N < 7) then ScrollFim;
  Until (Cont = #27) or ((Cont = #13) and (X = 'D'));
  Move(ScArrayS[1],Mem[$B800:0000],4000);
  Color(Tfn,Utx);
  If Cont = #13 then
     begin
       DCVSAN := RArray[Sx];
       DCVSAC := KArray[Sx];
     end
     else DCVSAC := '';
end;


Procedure Renumera;
begin
  Color(Blue,White);
  GotoXY(01,23); Write(ConstStr(' ',80));
  GotoXY(02,23); Write('Renumerando Lan‡amentos ');
  XLanc  := 0;
  DCVSNo := LoteNo + '#';
  For I := 1 to 31 do If LoteMember.Dias[I] <> 'C' then LoteMember.Dias[I] := '.';
  Repeat
    RC := 'N';
    SearchPos6 ( Root6 );
    If (RC         = 'S'                            ) and
       (LoteNo+'#' = Copy(DCVSNo,1,Length(LoteNo)+1)) then
       begin
         ReadWrite(#08,'R','N',DCVSNumber);
         ContaNo            := LimpaChave(LctoMember.Conta);
         XLanc              := XLanc + 1;
         LctoMember.SeqLote := QQStr(XLanc,4,'0');
         ReadWrite(#08,'W','N',DCVSNumber);
         CDVSNo := LoteNo                        + '#' +
                   Copy(LctoMember.Origdata,1,2) + '#' +
                   LctoMember.SeqLote            + '#' +
                   ContaNo;
         CDVSNumber := DCVSNumber;
         LoadTree4 ( Root4 );
         GotoXY(24,23); Write(XLanc:4);
         DelTree6 ( Root6 );
         RC := 'S';
       end;
  Until RC = 'N';
  TelaLote('S');
  Color(Blue,White);
  GotoXY(02,23); Write('Conferindo Lan‡amentos  ');
  CDVSNo := '';
  Repeat
    RC := 'N';
    SearchPos4 ( Root4 );
    If RC = 'S' then
       begin
         DCVSNo     := CDVSNo;
         DCVSNumber := CDVSNumber;
         LoadTree6 ( Root6 );
         ReadWrite(#08,'R','N',DCVSNumber);
         LinhaLote;
         TotalizaLote;
         TotalDoLote;
         Color(Blue,White);
         GotoXY(26,23); Write(XLanc:4);
         RC := 'S';
       end;
  Until RC = 'N';
  ReadWrite(#04,'W','N',LoteNumber);
  If Root4 <> NIL then Dispose4 ( Root4 );
  Root4  := NIL;
  TeclaReturn;
  Color(Tfn,Utx);
  DM := 'S';
  RC := 'S';
end;


Procedure InterfaceLote(X : Char);
Var
  Imprime                 : Char;
  Lidos,Grav,Aband,Erro   : Integer;
begin
  Close ( EcoFile );
  Color(Blue,Cyan);
  GotoXY(01,23); Write(ConstStr(' ',80));
  If X = 'M' then
     begin
       GotoXY(02,23); Write('Importar/Exportar o Lote (I/E):');
       Color(Blue,White);
       GotoXY(28,23); Write('I');
       GotoXY(30,23); Write('E');
       J := '';
       Repeat
         InputStr(J,1,34,23,0,'S','N','T','N',Blue,White);
         If (TC <> #27) and (UpCase(J[1]) in ['E','I']) then
            begin
              Opc := UpCase(J[1]);
              Color(Blue,Yellow);
              GotoXY(34,23);
              Case Opc of
                   'E' : Write('Exportar                               ');
                   'I' : Write('Importar (Abandonar Lan‡amentos iguais)');
              end;
            end;
       Until TC in [#13,#27];
     end
     else begin
            Color(Blue,White);
            GotoXY(02,23); Write('Exportando todo o movimento do Mˆs.');
            Opc := 'E';
            TC  := #13;
          end;
  If TC = #13 then
     begin
       J := '';
       Repeat
         Color(Red,Cyan);
         GotoXY(01,24); Write(ConstStr(' ',80));
         GotoXY(02,24); Write('Path e Arquivo (             ):');
         Color(Red,White);
         GotoXY(18,24); Write('A:Arquivo.Ext');
         InputStr(J,30,34,24,0,'S','N','T','N',Red,Yellow);
         If (TC <> #27) and
            (J  <> '' ) then
            begin
              Assign( WorkFile5, J);
              {$I-}
              Reset ( WorkFile5 );
              {$I+}
              Case IOResult of
                   0 : Case Opc of
                            'E' : begin
                                    Close ( WorkFile5 );
                                    Erase ( WorkFile5 );
                                    ReWrite ( WorkFile5 );
                                  end;
                            'I' : TC := #13;
                       end;
                   152 : begin
                           ErroMsg := 'A unidade n„o esta pronta.';
                           ErrorMessage;
                           TC := #00;
                         end;
                   else Case Opc of
                           'E' : ReWrite ( WorkFile5 );
                           'I' : begin
                                   ErroMsg := J + ' n„o existe';
                                   ErrorMessage;
                                   TC := #00;
                                 end;
                        end;
              end;
            end
            else If TC <> #27 then TC := #00;
       Until TC in [#13,#27];
       If TC = #13 then
          begin
            TelaTotalDoLote;
            TotalDoLote;
            DrawBox(2,11,71,20,Sfn,'S');
            Color(Bfn,Btx);
            GotoXY(2,11);
            Write(' DD/MM/AAAA Seq. S Conta              D/C                Valor Depto. ');
            Color(Sfn,Stx);
            Lidos := 0;
            Grav  := 0;
            Case Opc of
                 'I' : begin
                         QPorta;
                         If TC = #13 then
                            begin
                              Tamanho;
                              Imprime := 'S';
                              ContLin := 0;
                            end
                            else Imprime := 'N';
                         LimpaLn(24,Red);
                         DDD := QQStr(MM,2,'0');
                         Str(CMstMember.AnoAtivo,AAA);
                         Val(Copy(LctoMember.OrigData,1,2),K,E);
                         XLanc  := 0;
                         XDL    := QQStr(K,2,'0');
                         DCVSNo := LoteNo + '#99#9999#999999999999999999';
                         RC     := 'N';
                         SearchAnt6 ( Root6 );
                         If (RC         = 'S'                            ) and
                            (LoteNo+'#' = Copy(DCVSNo,1,Length(LoteNo)+1)) then
                            begin
                              ReadWrite(#08,'R','N',DCVSNumber);
                              Val(LctoMember.SeqLote,XLanc,E);
                            end
                            else XLanc := LoteMember.RDebito + LoteMember.RCredito;
                         L     := -1;
                         Aband := 0;
                         Repeat
                           L := L + 1;
                           {$I-}
                           Seek ( WorkFile5, L          );
                           Read ( WorkFile5, LctoMember );
                           {$I+}
                           If IOResult = 0 then
                              begin
                                Lidos := Lidos +1;
                                If LctoMember.Status = 'A' then
                                   begin
                                     ContaNo := LimpaChave(LctoMember.Conta);
                                     ContaAC := ContaNo;
                                     SearchTree1 ( Root1 );
                                     If RC = 'S' then
                                        begin
                                          Val(Copy(LctoMember.OrigData,1,2),K,E);
                                          XDL    := QQStr(K,2,'0');
                                          DCVSNo := LoteNo + '#' + XDL + '#' +
                                                    QQStr((XLanc+1),4,'0') + '#' +
                                                    ContaNo;
                                          SearchTree6 ( Root6 );
                                          If RC = 'N' then
                                             begin
                                               LctoMember.OrigData := Copy(LctoMember.OrigData,1,3) +
                                                                      DDD + '/' + AAA;
                                               ReadWrite(#03,'R','N',ContaNumber);
                                               ContaAN            := ContaNumber;
                                               LctoMember.Lote    := LoteNo;
                                               XLanc              := XLanc + 1;
                                               LctoMember.SeqLote := QQStr(XLanc,4,'0');
                                               Window(3,13,71,20);
                                               Color(Sfn,Stx);
                                               GotoXY(1,8);
                                               Writeln(LctoMember.OrigData:10,' ',
                                                       Pushleft(5,LctoMember.SeqLote),
                                                       LctoMember.Status,' ',
                                                       PushLeft(20,LctoMember.Conta),
                                                       LctoMember.Tipo,' ':2,
                                                       EditDouble(LctoMember.Valor):20,' ',
                                                       LctoMember.Depto:6);
                                               Window(1,1,80,25);
                                               Case LctoMember.Tipo of
                                                    'D' : begin
                                                            LoteMember.Debito  := LoteMember.Debito  +
                                                                                  TruncX(LctoMember.Valor);
                                                            LoteMember.RDebito := LoteMember.RDebito + 1;
                                                          end;
                                                    'C' : begin
                                                            LoteMember.Credito  := LoteMember.Credito  +
                                                                                   TruncX(LctoMember.Valor);
                                                            LoteMember.RCredito := LoteMember.RCredito + 1;
                                                          end;
                                               end;
                                               LoteMember.Dias[K] := 'S';
                                               DCVSNo := LoteNo + '#' + XDL + '#' +
                                                         LctoMember.SeqLote + '#' +
                                                         ContaNo;
                                               DCVSNumber := FileSize(LctoFile);
                                               LoadTree6 ( Root6 );
                                               If (Length(LctoMember.Depto)  <> 0) and
                                                  (ContaMember.Grupo in ['D','R']) then
                                                  begin
                                                    ContaNo     := ContaAC;
                                                    ContaNumber := ContaAN;
                                                    ColocaNaDespesa;
                                                  end;
                                               ReadWrite(#08,'W','N',DCVSNumber);
                                               ContaNo     := ContaAC;
                                               ContaNumber := ContaAN;
                                               ColocaNaConta(LoteMember.Tipo,'I');
                                               TotalDoLote;
                                             end
                                             else begin
                                                    Aband := Aband + 1;
                                                    If Imprime = 'S' then
                                                       begin
                                                         If ContLin = 55 then WriteLine('L',Qp);
                                                         WriteLine('L',Cx+'* LCTO.JA EXISTE * '+
                                                                      PushLeft(19,LctoMember.Conta)+
                                                                      LctoMember.Tipo+' '+
                                                                      PushRight(17,EditDouble(LctoMember.Valor))+' '+
                                                                      Acentua(LctoMember.Historico[1])+Cf);
                                                       end;
                                                  end;
                                        end
                                        else begin
                                               Aband := Aband + 1;
                                               If Imprime = 'S' then
                                                  begin
                                                    If ContLin = 55 then WriteLine('L',Qp);
                                                    WriteLine('L',Cx+'* CONTA NAO EXISTE * '+
                                                                  PushLeft(19,LctoMember.Conta)+
                                                                  LctoMember.Tipo+' '+
                                                                  PushRight(17,EditDouble(LctoMember.Valor))+' '+
                                                                  Acentua(LctoMember.Historico[1])+Cf);
                                                  end;
                                             end;
                                   end
                                   else Aband := Aband + 1;
                              end
                              else Aband := Aband + 1;
                         Until (L + 1) = FileSize(WorkFile5);
                         ReadWrite(#04,'W','N',LoteNumber);
                         DM := 'S';
                         RC := 'S';
                         Color(Blue,Cyan);
                         GotoXY(01,23); Write(ConstStr(' ',80));
                         GotoXY(02,23); Write('Lidos: ',Lidos:4,'    Abandonados: ',Aband:4);
                         If Imprime = 'S' then
                            begin
                              WriteLine('L',Qp);
                              Close ( LST );
                            end;
                       end;
                 'E' : begin
                         LoteMember.Debito   := 0;
                         LoteMember.RDebito  := 0;
                         LoteMember.Credito  := 0;
                         LoteMember.RCredito := 0;
                         If X = 'M' then DCVSNo := LoteNo + '#'
                                    else DCVSNo := '';
                         Repeat
                           RC := 'N';
                           SearchPos6 (Root6);
                           If (RC = 'S') and
                              (((LoteNo+'#' = Copy(DCVSNo,1,Length(LoteNo)+1)) and (X = 'M')) or
                              (X = 'A')) then
                              begin
                                ReadWrite(#08,'R','N',DCVSNumber);
                                If (RW = 'S') and (LctoMember.Status = 'A') then
                                   begin
                                     Lidos := Lidos +1;
                                     Grav  := Grav + 1;
                                     L     := FileSize(WorkFile5);
                                     {$I-}
                                     Seek  ( WorkFile5, L          );
                                     Write ( WorkFile5, LctoMember );
                                     {$I+}
                                     Erro := IOResult;
                                     If Erro = 0 then
                                        begin
                                          ContaNo := LimpaChave(LctoMember.Conta);
                                          SearchTree1 ( Root1 );
                                          If RC = 'S' then
                                             begin
                                               ReadWrite(#03,'R','N',ContaNumber);
                                               Window(3,13,71,20);
                                               Color(Sfn,Stx);
                                               GotoXY(1,8);
                                               Writeln(LctoMember.OrigData:10,' ',
                                                       PushLeft(5,LctoMember.SeqLote),
                                                       LctoMember.Status,' ',
                                                       Pushleft(20,LctoMember.Conta),
                                                       LctoMember.Tipo,' ':2,
                                                       EditDouble(LctoMember.Valor):20,' ',
                                                       LctoMember.Depto:6);
                                               Window(1,1,80,25);
                                               Case LctoMember.Tipo of
                                                    'D' : begin
                                                            LoteMember.Debito  := LoteMember.Debito  +
                                                                                  TruncX(LctoMember.Valor);
                                                            LoteMember.RDebito := LoteMember.RDebito + 1;
                                                          end;
                                                     'C' : begin
                                                             LoteMember.Credito  := LoteMember.Credito  +
                                                                                    TruncX(LctoMember.Valor);
                                                             LoteMember.RCredito := LoteMember.RCredito + 1;
                                                           end;
                                               end;
                                               TotalDoLote;
                                             end;
                                          RC := 'S';
                                        end
                                        else begin
                                               Color(Blue,Yellow);
                                               GotoXY(1,23); Write(ConstStr(' ',80));
                                               GotoXY(2,23);
                                               Case Erro of
                                                    101 : Write('Erro de grava‡„o no Disco.');
                                                    150 : Write('Erro, Disco esta protegido.');
                                                    152 : Write('Erro, o drive n„o esta pronto.');
                                                    156 : Write('Erro de seek no disco.');
                                                    158 : Write('Erro, sector n„o encontrado.');
                                                    else  Write('Erro, n„o consigo acessar o disco.');
                                               end;
                                               RC := 'N';
                                             end;
                                   end;
                              end
                              else RC := 'N';
                         Until RC = 'N';
                         RC := 'S';
                         If Erro = 0 then
                            begin
                              Color(Blue,White);
                              GotoXY(01,23); Write(ConstStr(' ',80));
                              GotoXY(02,23); Write('Movimento do Mˆs Exportado, Total: ',L+1:4);
                            end;
                         ReadWrite(#04,'R','N',LoteNumber);
                       end;
            end;
            Color(Tfn,Utx);
            {$I-}
            Close ( WorkFile5 );
            {$I+}
            Erro := IOResult;
            If Erro <> 0 then
               begin
                 Color(Blue,Yellow);
                 GotoXY(1,23); Write(ConstStr(' ',80));
                 GotoXY(2,23);
                 Case I of
                      101 : Write('Erro de grava‡„o no Disco.');
                      150 : Write('Erro, Disco esta protegido.');
                      152 : Write('Erro, o drive n„o esta pronto.');
                      156 : Write('Erro de seek no disco.');
                      158 : Write('Erro, sector n„o encontrado.');
                      else  Write('Erro, n„o consigo acessar o disco.');
                 end;
               end;
            TeclaReturn;
            LimpaLn(23,Tfd);
          end;
     end;
  Reset ( EcoFile );
end;



