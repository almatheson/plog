{$O+,F+}
Unit AlogDept;

Interface

Uses Crt,Dos,AlogGlbs,AlogNavg,AlogBasP,AlogDoct,AlogCnta,AlogInit;

   Procedure TitleDept;
   Procedure IncluiDept(X : Char);
   Procedure ScrollDept;
   Procedure UpdateDept;
   Procedure TitleOrcamentoDept;
   Procedure OrcamentoDept;

Implementation


Procedure TitleDept;
begin
  Color(Tfn,Ttx);
  GotoXY(4,09);  Write('Depto.:');
  GotoXY(4,10);  Write('Local.:');
  GotoXY(4,11);  Write('Nome..:');
  GotoXY(4,13);  Write('Status:');
  Color(Tfn,Utx);
end;


Procedure DataDept;
begin
  HelpM;
  ReadWrite(#05,'R','N',DeptNumber);
  With DeptMember do
  begin
    DeptNo := Chave;
    DeptAC := Chave;
    DeptAN := DeptNumber;
    Color(Tfn,Utx);
    GotoXY(12,09); Write(PushLeft(8,OrigChave));
    GotoXY(12,10); Write(PushLeft(31,NomeLocal));
    GotoXY(12,11); Write(PushLeft(31,NomeDepto));
    GotoXY(12,13); Case Status of
                        'A' : Write('Ativo     ');
                        'D' : Write('Desativado');
                        'C' : Write('Cancelado ');
                   end;
  end;
end;


Procedure EntryDept;
begin
  With DeptMember do
  Repeat
    K := 1;
    Repeat
      Case K of
           1   : With DeptMember do
                 begin
                   Move(MemW[$B800:0000],ScArray5[1],4000);
                   DrawBox(38,14,57,18,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(39,15); Write('      ao qual est†');
                   GotoXY(39,16); Write('subordinado,  o/os');
                   GotoXY(39,17); Write('Departamento(s).');
                   Color(Red,White);
                   GotoXY(39,15); Write('Local');
                   J := NomeLocal;
		   InputStr(J,30,12,10,0,'S','S','T','N',Tfn,Utx);
                   NomeLocal := J;
                   If (TC <> #27) then
                      If NomeLocal = '' then
                         begin
                           ErroMsg := 'Nome do Local Inv†lido';
                           ErrorMessage;
                           K := K - 1;
                         end;
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(12,10); Write(PushLeft(31,NomeLocal));
                 end;
           2   : With DeptMember do
                 begin
                   Move(MemW[$B800:0000],ScArray5[1],4000);
                   DrawBox(38,14,57,18,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(40,16); Write('subordinado   ao');
                   GotoXY(40,17); Write('Local informado.');
                   Color(Red,White);
                   GotoXY(40,15); Write('Departamento(s)');
                   J := NomeDepto;
		   InputStr(J,30,12,11,0,'S','S','T','N',Tfn,Utx);
                   NomeDepto := J;
                   If (TC <> #27) then
                      If NomeDepto = '' then
                         begin
                           ErroMsg := 'Nome do Departamento Inv†lido';
                           ErrorMessage;
                           K := K - 1;
                         end;
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(12,11); Write(PushLeft(31,NomeDepto));
                 end;
           3   : With DeptMember do
                 begin
                   Move(MemW[$B800:0000],ScArray5[1],4000);
                   DrawBox(42,14,53,18,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(44,15); Write('tivo');
                   GotoXY(44,16); Write('esativado');
                   GotoXY(44,17); Write('ancelado');
                   Color(Red,White);
                   GotoXY(43,15); Write('A');
                   GotoXY(43,16); Write('D');
                   GotoXY(43,17); Write('C');
                   J := Status;
		   InputStr(J,1,12,13,0,'S','N','T','N',Tfn,Utx);
                   Status := UpCase(J[1]);
                   If (TC <> #27) then
                      If (Status <> 'A') and
                         (Status <> 'D') and
                         (Status <> 'C') then
                         begin
                           ErroMsg := 'Status Inv†lido';
                           ErrorMessage;
                           K := K - 1;
                         end;
                   Move(ScArray5[1],MemW[$B800:0000],4000);
                   GotoXY(12,13);
                   Case Status of
                        'A' : Write('Ativo     ');
                        'D' : Write('Desativado');
                        'C' : Write('Cancelado ');
                   end;
                 end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 4) or (TC = #27);
    If ((TC <> #27) and (Op = 'I')) or (Op = 'A') then Confirma;
  Until (TC = 'S') or (TC = #27);
end;


Procedure IncluiDept(X : Char);
begin
  With DeptMember do
  begin
    Status    := 'A';
    Chave     := DeptNo;
    OrigChave := J;
    NomeLocal := '';
    NomeDepto := '';
    Op        := 'I';
    EntryDept;
    If X = 'I' then Move(ScArray4[1],MemW[$B800:0000],4000);
    If TC = 'S' then
       begin
         DI := 'S';
         ReadWrite(#05,'W','N',DeptNumber);
         LoadTree3 ( Root3 );
         CMstMember.NDeptos := CMstMember.NDeptos + 1;
         ReadWrite(#16,'W','N',0);
         Resp := #000;
         If X = 'I' then
            begin
              Color(Red,Yellow);
              GotoXY(53,7); Write(CMstMember.NDeptos);
              Move(MemW[$B800:0000],ScArray4[1],4000);
            end;
       end
       else DeptNumber := Limite;
    TC := #13;
  end;
end;


Procedure ScrollDept;
Var
   Cont,Direcao,
   F,Tkb          : Char;
   Sx,R,N         : Integer;
   RArray         : Array[1..7] of Integer;
   KArray         : Array[1..7] of Str6;
   NArray         : Array[1..7] of Str40;
   ScArrayS       : Array [1..4000] of Char;
begin
  Move(Mem[$B800:0000],ScArrayS[1],4000);
  FootScroll;
  DrawBox(23,11,71,20,Sfn,'S');
  Color(Bfn,Btx);
  GotoXY(23,11); Write(' Depto. Nome                                     ');
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
  SearchAnt3 ( Root3 );
  If RC = 'N' then DeptNo := '';
  Repeat
    RC := 'N';
    SearchPos3 ( Root3 );
    If RC = 'S' then
       begin
         ReadWrite(#05,'R','N',DeptNumber);
         If RW = 'S' then
            begin
              L         := L + 1;
              KArray[L] := DeptMember.OrigChave;
              RArray[L] := DeptNumber;
              NArray[L] := DeptMember.NomeDepto;
            end;
       end
       else L := 7;
  Until L = 7;
  Repeat
    Window(23,13,72,20);
    For I := 1 to 7 do begin
                          If KArray[I] <> '' then
                             begin
                               If I = Sx then Color(Tfn,Utx)
                                         else Color(Sfn,Stx);
                               GotoXY(1,I);
                               Writeln(' ',PushLeft(7,KArray[I]),
                                           PushLeft(41,NArray[I]));
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
                                       RC     := 'N';
                                       DeptNo := LimpaChave(KArray[1]);
                                       SearchAnt3 ( Root3 );
                                       If RC = 'S' then
                                          begin
                                            ReadWrite(#05,'R','N',DeptNumber);
                                            If RW = 'S' then
                                               begin
                                                 For I := 7 downto 2 do
                                                 begin
                                                   KArray[I] := KArray[I - 1];
                                                   RArray[I] := RArray[I - 1];
                                                   NArray[I] := NArray[I - 1];
                                                 end;
                                                 KArray[1] := DeptMember.OrigChave;
                                                 RArray[1] := DeptNumber;
                                                 NArray[1] := DeptMember.NomeDepto;
                                               end;
                                            F := 'N';
                                          end
                                          else F := 'A';
                                     end;
                       'P' : begin
                               Sx := 1;
                               N  := 0;
                               Repeat
                                 RC     := 'N';
                                 DeptNo := LimpaChave(KArray[1]);
                                 SearchAnt3 ( Root3 );
                                 If RC = 'S' then
                                    begin
                                      ReadWrite(#05,'R','N',DeptNumber);
                                      If RW = 'S' then
                                         begin
                                           For I := 7 downto 2 do
                                           begin
                                             KArray[I] := KArray[I - 1];
                                             RArray[I] := RArray[I - 1];
                                             NArray[I] := NArray[I - 1];
                                           end;
                                           KArray[1] := DeptMember.OrigChave;
                                           RArray[1] := DeptNumber;
                                           NArray[1] := DeptMember.NomeDepto;
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
                                       RC     := 'N';
                                       DeptNo := LimpaChave(KArray[Sx]);
                                       SearchPos3 ( Root3 );
                                       If RC = 'S' then
                                          begin
                                            ReadWrite(#05,'R','N',DeptNumber);
                                            If RW = 'S' then
                                               begin
                                                 For I := 2 to 7 do
                                                 begin
                                                   KArray[I - 1] := KArray[I];
                                                   RArray[I - 1] := RArray[I];
                                                   NArray[I - 1] := NArray[I];
                                                 end;
                                                 KArray[7] := DeptMember.OrigChave;
                                                 RArray[7] := DeptNumber;
                                                 NArray[7] := DeptMember.NomeDepto;
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
                                 DeptNo := LimpaChave(KArray[R]);
                                 SearchPos3 ( Root3 );
                                 If RC = 'S' then
                                    begin
                                      ReadWrite(#05,'R','N',DeptNumber);
                                      If RW = 'S' then
                                         begin
                                           For I := 2 to 7 do
                                           begin
                                             KArray[I - 1] := KArray[I];
                                             RArray[I - 1] := RArray[I];
                                             NArray[I - 1] := NArray[I];
                                           end;
                                           KArray[R] := DeptMember.OrigChave;
                                           RArray[R] := DeptNumber;
                                           NArray[R] := DeptMember.NomeDepto;
                                           N := N + 1;
                                         end;
                                    end;
                               Until (N = 7) or (RC = 'N');
                               F := 'N';
                             end;
                  end;
    end;
    If (F <> 'N') or (N < 7) then ScrollFim;
  Until (Cont = #27) or (Cont = #13);
  Window(1,1,80,25);
  Move(ScArrayS[1],Mem[$B800:0000],4000);
  Color(Tfn,Utx);
  If Cont = #13 then
     begin
       DeptAN := RArray[Sx];
       DeptAC := KArray[Sx];
     end;
end;


Procedure DespesaDept;
begin
  ContaNo := LimpaChave(ExpeMember.Conta);
  SearchTree1 ( Root1 );
  If RC = 'S' then ReadWrite(#03,'R','N',ContaNumber);
  Color(Bfn,Btx);
  GotoXY(03,12);
  Write(ContaMember.OrigConta,' ',#26,' ',ContaMember.Descricao);
  If ExpeMember.Corrigivel = 'S' then
     begin
       IINo := XAno + '#' + ExpeMember.IndiceX;
       SearchTree7 ( Root7 );
       If RC = 'S' then
          begin
            ReadWrite(#12,'R','N',IINumber);
            If RW = 'S' then
               begin
                 GotoXY(34,13);
                 Write('Corrigido pela variaáÑo do ',EcoMember.Descricao);
               end;
          end
          else RC := 'S';
     end;
  Color(Sfn,Stx);
  For I := 1 to 6 do
  begin
    Color(Sfn,Stx);
    GotoXY(07,(I+14)); Write(EditDouble(ExpeMember.ValorO[I]):13);
    If TruncX(ExpeMember.Despesas[I]) < 0 then Color(Bfn,Btx)
                                          else Color(Sfn,Stx);
    GotoXY(21,(I+14)); Write(EditDouble(ExpeMember.Despesas[I]):15);
    Color(Sfn,Stx);
    GotoXY(42,(I+14)); Write(EditDouble(ExpeMember.ValorO[I+6]):13);
    If TruncX(ExpeMember.Despesas[I+6]) < 0 then Color(Bfn,Btx)
                                            else Color(Sfn,Stx);
    GotoXY(56,(I+14)); Write(EditDouble(ExpeMember.Despesas[I+6]):15);
  end;
end;


Procedure ShowDespDept;
Var
   Cont     : Char;
   XavExpe  : Str30;

begin
  Move(MemW[$B800:0000],ScArray5[1],4000);
  Color(Blue,White);
  GotoXY(1,23);  Write(ConstStr(' ',80));
  GotoXY(17,23); Write(#25);
  GotoXY(39,23); Write(#24);
  GotoXY(59,23); Write('Esc');
  Color(Blue,Cyan);
  GotoXY(19,23); Write(#26,' Pr¢xima');
  GotoXY(41,23); Write(#26,' Anterior');
  GotoXY(63,23); Write(#26,' Fim');
  DrawBox(02,12,71,20,Sfn,'S');
  Color(Bfn,Btx);
  GotoXY(02,12); Write(ConstStr(' ',70));
  GotoXY(02,13); Write(ConstStr(' ',70));
  Color(Tfn,Ttx);
  GotoXY(02,14);
  Write(' Màs      Estimado           Gasto ',
        ' Màs      Estimado           Gasto ');
  Color(Sfn,Stx);
  GotoXY(03,15); Write('Jan');
  GotoXY(03,16); Write('Fev');
  GotoXY(03,17); Write('Mar');
  GotoXY(03,18); Write('Abr');
  GotoXY(03,19); Write('Mai');
  GotoXY(03,20); Write('Jun');
  GotoXY(38,15); Write('Jul');
  GotoXY(38,16); Write('Ago');
  GotoXY(38,17); Write('Set');
  GotoXY(38,18); Write('Out');
  GotoXY(38,19); Write('Nov');
  GotoXY(38,20); Write('Dez');
  Color(Red,White);
  GotoXY(1,24); ClrEol;
  Move(MemW[$B800:0000],ScArray6[1],4000);
  RC     := 'N';
  Cont   := #80;
  ExpeNo := LimpaChave(DeptMember.OrigChave);
  XavExpe := ExpeNo;
  Repeat
    With DeptMember  do
    begin
      RC     := 'N';
      ExpeNo := XavExpe;
      Case Cont of
           #80 : SearchPos5 ( Root5 );
           #72 : SearchAnt5 ( Root5 );
      end;
      J := LimpaChave(OrigChave);
      If (RC = 'S'                       ) and
         (J  = Copy(ExpeNo,1,(Length(J)))) then
         begin
           XavExpe := ExpeNo;
           Move(ScArray6[1],MemW[$B800:0000],4000);
           ReadWrite(#07,'R','N',ExpeNumber);
           Case Cont of
                #72 : begin
                        Color(Blue,White);
                        GotoXY(17,23); Write(#25);
                        Color(Blue,(White + Blink));
                        GotoXY(39,23); Write(#24);
                      end;
                #80 : begin
                        Color(Blue,(White + Blink));
                        GotoXY(17,23); Write(#25);
                        Color(Blue,White);
                        GotoXY(39,23); Write(#24);
                      end;
           end;
           Color(Sfn,Stx);
           DespesaDept;
         end
         else begin
                Color(Red,White);
                GotoXY(1,24);  Write(ConstStr(' ',80));
                GotoXY(1,24);  Write(' Fim da Lista');
                Color(Sfn,Stx);
              end;
      Repeat
        Cont := ReadKey;
        If (Cont = #0) and KeyPressed then Cont := ReadKey;
      Until (Cont = #80) or (Cont = #72) or (Cont = #27);
    end;
  Until Cont = #27;
  Move(ScArray5[1],MemW[$B800:0000],4000);
  Color(Tfn,Utx);
end;


Procedure UpdateDept;
begin
           Titulo := 'Departamentos                               ';
           BuildFrame('S');
           Color(Red,White);
           GotoXY(36,07); Write('Total de Deptos: ');
           GotoXY(62,08); Write(#27,#217);
           GotoXY(62,10); Write(#24);
           GotoXY(62,11); Write(#25);
           GotoXY(62,13); Write('F1');
           GotoXY(62,15);
           If XSt = 'A' then Write('F3');
           GotoXY(62,17); Write('F5');
           Color(Red,Yellow);
           GotoXY(53,07); Write(CMstMember.NDeptos);
           GotoXY(66,8);  Write('C¢digo  ');
           GotoXY(66,10); Write('Anterior');
           GotoXY(66,11); Write('Pr¢ximo ');
           GotoXY(66,13); Write('Deptos. ');
           GotoXY(66,15);
           If XSt = 'A' then Write('Alterar ');
           GotoXY(66,17); Write('Despesas');
           Shade(3,8,60,21,LightGray,Black);
           TitleDept;
           Move(MemW[$B800:0000],ScArray4[1],4000);
  Str(CMstMember.AnoAtivo,XAno);
  Repeat
    J := '';
    InputStr(J,6,12,9,0,'S','N','T','N',Tfn,Utx);
    LimpaLn(24,Tfd);
    If TC = #27
       then DeptNumber := Limite
       else If TC = #25 then
               begin
                 DeptNo := '';
                 RC     := 'N';
                 SearchPos3 ( Root3 );
                 If RC = 'N' then DeptNumber := Limite;
               end
               else If J <> '' then
                       begin
                         DeptNo := LimpaChave(J);
                         SearchTree3 ( Root3 );
                         If RC = 'N' then
                            begin
                              If XSt = 'A' then
                                 begin
                                   DeptNumber := FileSize(DeptFile);
                                   IncluiDept('I');
                                 end
                                 else DeptNumber := Limite;
                            end;
                       end
                       else DeptNumber := Limite;
    If DeptNumber <> Limite then
       With DeptMember do
       begin
         Repeat
           DataDept;
           Repeat
             Resp := ReadKey;
             LimpaLn(24,Tfd);
             If (Resp = #0) and (KeyPressed) then
                begin
                  Resp := ReadKey;
                  Case Resp of
                       #59 : begin
                               ScrollDept;
                               DeptNumber := DeptAN;
                               DeptNo     := DeptAC;
                               DataDept;
                             end;
                       #61 : If XSt = 'A' then
                                begin
                                  Op := 'A';
                                  EntryDept;
                                  If TC = 'S' then ReadWrite(#05,'W','N',DeptNumber);
                                end;
                       #63 : begin
                               ShowDespDept;
                               DeptNumber := DeptAN;
                               DeptNo     := DeptAC;
                               DataDept;
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
           Move(ScArray4[1],MemW[$B800:0000],4000);
         Until Resp in [#13,#27];
         TC := Resp;
       end;
  Until TC = #27;
end;


Procedure TitleOrcamentoDept;
begin
  Color(Tfn,Ttx);
  GotoXY(4,09);  Write('Depto.:');
  GotoXY(4,10);  Write('Local.:');
  GotoXY(4,11);  Write('Nome..:');
  GotoXY(4,12);  Write('Conta.:');
  GotoXY(4,13);  Write('Descr.:');
  GotoXY(4,14);  Write('Corrig:');
  GotoXY(30,14); Write('Indice:');
  GotoXY(4,16);  Write('Janeir:');
  GotoXY(4,17);  Write('Fever.:');
  GotoXY(4,18);  Write('Maráo.:');
  GotoXY(4,19);  Write('Abril.:');
  GotoXY(4,20);  Write('Maio..:');
  GotoXY(4,21);  Write('Junho.:');
  GotoXY(30,16); Write('Julho.:');
  GotoXY(30,17); Write('Agosto:');
  GotoXY(30,18); Write('Setemb:');
  GotoXY(30,19); Write('Outubr:');
  GotoXY(30,20); Write('Novemb:');
  GotoXY(30,21); Write('Dezemb:');
  Color(Tfn,Utx);
end;


Procedure DataOrcamentoDept;
begin
              Titulo := 'Oráamento de Despesas                  ';
              BuildFrame('S');
              Shade(3,8,60,21,LightGray,Black);
              Color(Red,White);
              GotoXY(36,7); Write('Total de Deptos: ');
              Color(Red,Yellow);
              GotoXY(53,7); Write(CMstMember.NDeptos);
              TitleOrcamentoDept;
              Move(MemW[$B800:0000],ScArray4[1],4000);
  With ExpeMember do
  begin
    Color(Tfn,Utx);
    GotoXY(12,14); Case Corrigivel of
                        'S' : Write('Sim');
                        'N' : Write('NÑo');
                   end;
    If IndiceX <> '' then
       begin
         IINo := XAno + '#' + ExpeMember.IndiceX;
         SearchTree7 ( Root7 );
         If RC = 'S' then
            begin
              ReadWrite(#12,'R','N',IINumber);
              If RW = 'S' then
                 begin
                   GotoXY(38,14); Write(IndiceX:2,'  ',EcoMember.Descricao);
                 end;
            end
            else RC := 'S';
       end;
    For I := 1 to 6 do begin
                         GotoXY(12,(I + 15)); Write(EditDouble(ValorO[I]):13);
                         GotoXY(38,(I + 15)); Write(EditDouble(ValorO[I + 6]):13);
                       end;
  end;
end;


Procedure EntryOrcamentoDept;
begin
  Repeat
    K := 1;
    Repeat
      Case K of
           1     : With ExpeMember do
                   begin
                     J := Corrigivel;
		     InputStr(J,1,12,14,0,'S','N','T','N',Tfn,Utx);
                     If TC <> #27 then
                        begin
                          If J = '' then Corrigivel := 'N'
                                    else Corrigivel := UpCase(J[1]);
                          If Corrigivel in ['S','N'] then
                             begin
                               GotoXY(12,14);
                               If Corrigivel = 'S' then Write('Sim')
                                                   else Write('NÑo');
                             end
                             else begin
                                    ErroMsg := 'Informe S ou N';
                                    ErrorMessage;
                                    K := K - 1;
                                  end;
                       end;
                   end;
           2     : With ExpeMember do
                   begin
                     J := IndiceX;
		     InputStr(J,2,38,14,0,'S','N','T','N',Tfn,Utx);
                     If TC <> #27 then
                        begin
                          If J <> '' then
                             With EcoMember do
                             begin
                               IndiceX := UpCaseStr(J);
                               IINo    := QQStr(AA,2,'0') + '#' + IndiceX;
                               SearchTree7 ( Root7 );
                               If RC = 'S' then
                                  begin
                                    ReadWrite(#12,'R','N',IINumber);
                                    If RW = 'S' then
                                       begin
                                         GotoXY(38,14);
                                         Write(IndiceX:2,'  ',Descricao);
                                       end
                                       else begin
                                              ErroMsg := 'Indice nÑo existe para ' + QQStr(AA,2,'0');
                                              ErrorMessage;
                                              K := K - 1;
                                            end;
                                  end
                                  else begin
                                         ErroMsg := 'Indice nÑo existe para ' + QQStr(AA,2,'0');
                                         ErrorMessage;
                                         K := K - 1;
                                       end;
                             end
                             else begin
                                    ErroMsg := 'Informe o Indice';
                                    ErrorMessage;
                                    K := K - 1;
                                  end;
                        end;
                   end;
           3..8  : With ExpeMember do
                   begin
                     If ValorO[K - 2] = 0 then J := ''
                                          else begin
                                                 Str(ValorO[K - 2]:13:2,J);
                                                 J := LeftAdjust(J);
                                               end;
		     InputStr(J,13,12,(K + 13),0,'S','N','T','N',Tfn,Utx);
                     If TC <> #27 then
                        begin
                          If J = '' then ValorO[K - 2] := 0
                                    else Val(J,ValorO[K - 2],E);
                        end;
                     GotoXY(12,(K + 13)); Write(EditDouble(ValorO[K - 2]):13);
                   end;
           9..14 : With ExpeMember do
                   begin
                     If ValorO[K - 2] = 0 then J := ''
                                          else begin
                                                 Str(ValorO[K - 2]:13:2,J);
                                                 J := LeftAdjust(J);
                                               end;
		     InputStr(J,13,38,(K + 7),0,'S','N','T','N',Tfn,Utx);
                     If TC <> #27 then
                        begin
                          If J = '' then ValorO[K - 2] := 0
                                    else Val(J,ValorO[K - 2],E);
                        end;
                     GotoXY(38,(K + 7)); Write(EditDouble(ValorO[K - 2]):13);
                   end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 15) or (TC = #27);
    If ((TC <> #27) and (Op = 'I')) or (Op = 'A') then Confirma;
  Until TC in ['S',#27];
end;


Procedure AtualizaOrcamentoDept;
begin
  With ExpeMember do
  begin
    ExpeNo := LimpaChave(DeptMember.OrigChave) + '#' +
              LimpaChave(ContaMember.OrigConta);
    SearchTree5 ( Root5 );
    If RC = 'S' then
       begin
         ReadWrite(#07,'R','N',ExpeNumber);
         Op := 'A';
         DataOrcamentoDept;
         EntryOrcamentoDept;
         If TC = 'S' then ReadWrite(#07,'W','N',ExpeNumber);
       end
       else With ExpeMember do
            begin
              Op         := 'I';
              Depto      := DeptMember.OrigChave;
              Conta      := ContaMember.OrigConta;
              Corrigivel := 'S';
              IndiceX    := '';
              For I := 1 to 12 do ValorO[I]   := 0;
              For I := 1 to 12 do Despesas[I] := 0;
              EntryOrcamentoDept;
              If TC = 'S' then
                 begin
                   ExpeNumber := FileSize(ExpeFile);
                   ReadWrite(#07,'W','N',ExpeNumber);
                   LoadTree5 ( Root5 );
                 end;
            end;
  end;
end;


Procedure RecebeContaDept;
begin
  DrawBox(38,14,57,18,Red,'S');
  Color(Red,Cyan);
  GotoXY(39,15); Write('NÑo  Ç  necess†rio ');
  GotoXY(39,16); Write('entrar  com o   ou ');
  GotoXY(39,17); Write('caract.  especiais ');
  Color(Red,White);
  GotoXY(53,16); Write('.');
  J  := '';
  TC := ' ';
  Repeat
    Color(Blue,White);
    GotoXY(1,24); Write(ConstStr(' ',80));
    GotoXY(2,24); Write('F1');
    Color(Blue,Cyan);
    GotoXY(5,24); Write('para pesquisar Contas');
    InputStr(J,18,12,12,0,'S','N','T','N',Tfn,Utx);
    If TC = #22 then
       begin
         ContaNo := LimpaChave(J);
         ContaAC := ContaNo;
         ScrollConta('C');
         ContaNo := LimpaChave(ContaAC);
         SearchTree1 ( Root1 );
         Color(Tfn,Utx);
       end
       else If (TC = #27) or (J = '') then RC := 'X'
                                      else begin
                                             ContaNo := LimpaChave(J);
                                             SearchTree1 ( Root1 );
                                           end;
    If RC = 'S' then
       With ContaMember do
       begin
         LimpaLn(24,Tfd);
         ReadWrite(#03,'R','N',ContaNumber);
         GotoXY(12,12); Write(PushLeft(19,OrigConta));
         If Status <> 'A' then
            begin
              ErroMsg := 'Conta est† Desativada';
              ErrorMessage;
            end
            else If Tipo <> 'A' then
                    begin
                      ErroMsg := 'Conta nÑo Ç Analçtica';
                      ErrorMessage;
                    end
                    else If Grupo <> 'D' then
                            begin
                              ErroMsg := 'Conta nÑo Ç de Despesa';
                              ErrorMessage;
                            end
                            else If PedeDepto <> 'S' then
                                    begin
                                      ErroMsg := 'Conta nÑo pede Departamento';
                                      ErrorMessage;
                                    end
                                    else begin
                                           GotoXY(12,13); Write(Descricao);
                                           Confirma;
                                         end;
       end
       else If RC = 'N' then
               begin
                 ErroMsg := 'Conta nÑo Existe';
                 ErrorMessage;
               end;
  Until (TC = #27) or (TC = 'S');
end;


Procedure OrcamentoDept;
begin
  Str(CMstMember.AnoAtivo,XAno);
  Repeat
    DrawBox(38,10,57,14,Red,'S');
    Color(Red,Cyan);
    GotoXY(39,11); Write('NÑo  Ç  necess†rio');
    GotoXY(39,12); Write('entrar  com a   ou');
    GotoXY(39,13); Write('caract.  especiais');
    Color(Red,White);
    GotoXY(53,12); Write('/');
    J := '';
    InputStr(J,6,12,9,0,'S','N','T','N',Tfn,Utx);
    If (TC = #27) or (J = '') then RC := 'X'
       else With DeptMember do
            begin
              DeptNo := LimpaChave(J);
              SearchTree3 ( Root3 );
              If RC = 'S' then
                 begin
                   ReadWrite(#05,'R','N',DeptNumber);
                   If Status <> 'A' then
                      begin
                        ErroMsg := 'Departamento nÑo esta ativo';
                        ErrorMessage;
                        RC := 'X';
                      end;
                 end;
            end;
    If RC = 'S' then
       With DeptMember do
       begin
         Move(ScArray4[1],MemW[$B800:0000],4000);
         Color(Tfn,Utx);
         GotoXY(12,09); Write(PushLeft(7,OrigChave));
         GotoXY(12,10); Write(PushLeft(41,NomeLocal));
         GotoXY(12,11); Write(PushLeft(41,NomeDepto));
         Move(MemW[$B800:0000],ScArray6[1],4000);
         Repeat
           RecebeContaDept;
           Move(ScArray6[1],MemW[$B800:0000],4000);
           If TC = 'S' then
              With ContaMember do
              begin
                GotoXY(12,12); Write(PushLeft(19,OrigConta));
                GotoXY(12,13); Write(Descricao);
                AtualizaOrcamentoDept;
                Move(ScArray6[1],MemW[$B800:0000],4000);
                TC := #13;
              end;
         Until TC = #27;
         TC := #13;
         Move(ScArray4[1],MemW[$B800:0000],4000);
         ShowHeap;
         Color(Tfn,Utx);
         Move(MemW[$B800:0000],ScArray4[1],4000);
       end
       else If RC = 'N' then
               begin
                 ErroMsg := 'Departamento nÑo Existe';
                 ErrorMessage;
                 TC := #13;
               end;
  Until TC = #27;
end;

end.

