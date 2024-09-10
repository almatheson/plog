{$O+,F+}
Unit AlogHsPd;

Interface

Uses Crt,Dos,AlogGlbs,AlogNavg,AlogBasP,AlogDoct;


   Procedure FrameHsPd;
   Procedure TitleHsPd;
   Procedure ScrollHsPd;
   Procedure UpDateHsPd(X : Char);

Implementation

Var
   XavAnt,XavPost : Integer;


Procedure FrameHsPd;
begin
  Color(Tfd,Utx);
  For K := 6 to 23 do LimpaLn(K,Tfd);
  DrawBox(35,6,77,19,Red,'S');
  Color(Bfn,Btx);
  GotoXY(35,6); Write(' ':43);
  GotoXY(36,6); Write(Titulo);
  DrawBox(2,8,65,21,Tfn,'S');
  Color(Tfn,Utx);
end;


Procedure TitleHsPd;
begin
  Color(Tfn,Ttx);
  GotoXY(04,09); Write('C¢digo:');
  GotoXY(40,09); Write('Status:');
  GotoXY(04,11); Write('Descri‡„o');
  Color(Tfn,Utx);
end;


Procedure DataHsPd;
begin
  ReadWrite(#10,'R','N',HHNumber);
  Color(Tfn,Utx);
  GotoXY(12,09); Write(PushLeft(3,HHNo));
  GotoXY(48,09); Case HsPdMember.Status of
                      'A' : Write('Ativo    ');
                      'C' : Write('Cancelado');
                 end;
  GotoXY(04,13); Write(PushLeft(61,HsPdMember.Descricao));
end;


Procedure EntryHsPd;
begin
  Repeat
    K := 1;
    Repeat
      Case K of
           1   : With HsPdMember do
                 begin
                   J := Status;
		   InputStr(J,1,48,09,0,'S','S','T','N',Tfn,Utx);
                   Status := UpCase(J[1]);
                   If (Status <> 'A') and
                      (Status <> 'C') and
                      (TC     <> #27) then
                      begin
                        ErroMsg := 'Informe o Status (A ou C)';
                        ErrorMessage;
                        K := K - 1;
                      end
                      else begin
                             GotoXY(48,09); Case Status of
                                                 'A' : Write('Ativo    ');
                                                 'C' : Write('Cancelado');
                                            end;
                           end;
                 end;
           2   : With HsPdMember do
                 begin
                   J := Descricao;
		   InputStr(J,60,4,13,0,'S','S','T','N',Tfn,Utx);
                   Descricao := J;
                   If (Descricao = '') and (TC <> #27) then
                      begin
                        ErroMsg := 'Informe a Descri‡„o';
                        ErrorMessage;
                      end;
                 end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 3) or (TC = #27);
    If ((TC <> #27) and (Op = 'I')) or (Op = 'A') then Confirma;
  Until TC in ['S',#27];
end;


Procedure IncluiHsPd;
begin
  With HsPdMember do
  begin
    Op        := 'I';
    CodigoH   := HHNo;
    Descricao := '';
    Status    := 'A';
    Color(Tfn,Utx);
    GotoXY(12,09); Write(PushLeft(3,HHNo));
    EntryHsPd;
    Move(ScArray4[1],MemW[$B800:0000],4000);
    If TC = 'S' then
       begin
         LoadTree8 ( Root8 );
         ReadWrite(#10,'W','N',HHNumber);
         MasterMember.NHistorico := MasterMember.NHistorico + 1;
         ReadWrite(#00,'W','N',0);
         Resp := #000;
         Color(Red,Yellow);
         GotoXY(53,7); Write(MasterMember.NHistorico);
         Move(MemW[$B800:0000],ScArray4[1],4000);
       end
       else Resp := #13;
  end;
end;


Procedure ScrollHsPd;
Var
   Cont,Direcao,
   F,Tkb          : Char;
   Sx,R,N,L       : Integer;
   RArray         : Array[1..7] of Integer;
   KArray         : Array[1..7] of Str3;
   NArray         : Array[1..7] of Str80;
   ScArrayS       : Array [1..4000] of Char;
begin
  Move(Mem[$B800:0000],ScArrayS[1],4000);
  FootScroll;
  DrawBox(04,11,69,20,Sfn,'S');
  Color(Bfn,Btx);
  GotoXY(04,11);
  Write(' C¢d ',
        'Descri‡„o                                                    ');
  Color(Sfn,Stx);
  F       := 'N';
  Direcao := 'P';
  L       := 0;
  Sx      := 1;
  For I := 1 to 7 do begin
                       RArray[I] := 0;
                       KArray[I] := '';
                       NArray[I] := '';
                     end;
  RC := 'N';
  SearchAnt8 ( Root8 );
  If RC = 'N' then HHNo := '';
  Repeat
    RC := 'N';
    SearchPos8 ( Root8 );
    If RC = 'S' then
       begin
         ReadWrite(#10,'R','N',HHNumber);
         If RW = 'S' then
            begin
              L := L + 1;
              RArray[L] := HHNumber;
              KArray[L] := HsPdMember.CodigoH;
              NArray[L] := HsPdMember.Descricao;
            end;
       end
       else L := 7;
  Until L = 7;
  Repeat
    Window(04,13,70,20);
    For I := 1 to 7 do begin
                          If KArray[I] <> '' then
                             begin
                               If I = Sx then Color(Tfn,Utx)
                                         else Color(Sfn,Stx);
                               GotoXY(1,I);
                               Writeln(' ',PushLeft(4,KArray[I]),
                                           PushLeft(61,NArray[I]));
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
                                       HHNo := KArray[1];
                                       SearchAnt8 ( Root8 );
                                       If RC = 'S' then
                                          begin
                                            ReadWrite(#10,'R','N',HHNumber);
                                            If RW = 'S' then
                                               begin
                                                 For I := 7 downto 2 do
                                                 begin
                                                   RArray[I] := RArray[I-1];
                                                   KArray[I] := KArray[I-1];
                                                   NArray[I] := NArray[I-1];
                                                 end;
                                                 RArray[1] := HHNumber;
                                                 KArray[1] := HsPdMember.CodigoH;
                                                 NArray[1] := HsPdMember.Descricao;
                                               end;
                                             F := 'N';
                                          end
                                          else F := 'A';
                                     end;
                       'P' : begin
                               Sx := 1;
                               N  := 0;
                               Repeat
                                 RC   := 'N';
                                 HHNo := KArray[1];
                                 SearchAnt8 ( Root8 );
                                 If RC = 'S' then
                                    begin
                                      ReadWrite(#10,'R','N',HHNumber);
                                      If RW = 'S' then
                                         begin
                                           For I := 7 downto 2 do
                                           begin
                                             RArray[I] := RArray[I-1];
                                             KArray[I] := KArray[I-1];
                                             NArray[I] := NArray[I-1];
                                           end;
                                           RArray[1] := HHNumber;
                                           KArray[1] := HsPdMember.CodigoH;
                                           NArray[1] := HsPdMember.Descricao;
                                           N := N + 1;
                                           F := 'N';
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
                                  If KArray[Sx+1] <> '' then
                                     begin
                                       Sx := Sx + 1;
                                       F  := 'N';
                                     end
                                     else F := 'P';
                                end
                                else begin
                                       RC   := 'N';
                                       HHNo := KArray[Sx];
                                       SearchPos8 ( Root8 );
                                       If RC = 'S' then
                                          begin
                                            ReadWrite(#10,'R','N',HHNumber);
                                            If RW = 'S' then
                                               begin
                                                 For I := 2 to 7 do
                                                 begin
                                                   RArray[I-1] := RArray[I];
                                                   KArray[I-1] := KArray[I];
                                                   NArray[I-1] := NArray[I];
                                                 end;
                                                 RArray[7] := HHNumber;
                                                 KArray[7] := HsPdMember.CodigoH;
                                                 NArray[7] := HsPdMember.Descricao;
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
                                 HHNo := KArray[R];
                                 SearchPos8 ( Root8 );
                                 If RC = 'S' then
                                    begin
                                      ReadWrite(#10,'R','N',HHNumber);
                                      If RW = 'S' then
                                         begin
                                           For I := 2 to 7 do
                                           begin
                                             RArray[I-1] := RArray[I];
                                             KArray[I-1] := KArray[I];
                                             NArray[I-1] := NArray[I];
                                           end;
                                           RArray[R] := HHNumber;
                                           KArray[R] := HsPdMember.CodigoH;
                                           NArray[R] := HsPdMember.Descricao;
                                         end;
                                      N := N + 1;
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
       HHAN := RArray[Sx];
       HHAC := KArray[Sx];
     end;
end;


Procedure UpdateHsPd(X : Char);
begin
           Titulo := 'Hist¢rico PadrÆo                       ';
           FrameHsPd;
           Color(Red,White);
           GotoXY(36,07); Write('Total de Regist: ');
           GotoXY(67,08); Write(#27,#217);
           GotoXY(67,10); Write(#24);
           GotoXY(67,11); Write(#25);
           GotoXY(67,13); Write('F1');
           Color(Red,Yellow);
           GotoXY(53,07); Write(MasterMember.NHistorico);
           GotoXY(71,08); Write('C¢digo ');
           GotoXY(71,10); Write('Anter. ');
           GotoXY(71,11); Write('Pr¢ximo');
           GotoXY(71,13); Write('Hist¢r.');
           Shade(3,8,65,21,LightGray,Black);
           VezD := 'S';
           TitleHsPd;
           Move(MemW[$B800:0000],ScArray4[1],4000);
  Repeat
    J := '';
    InputStr(J,3,12,9,0,'S','N','T','N',Tfn,Utx);
    LimpaLn(24,Tfd);
    If TC = #27
       then HHNumber := Limite
       else If TC = #25 then
               begin
                 HHNo := '';
                 RC   := 'N';
                 SearchPos8 ( Root8 );
                 If RC = 'N' then HHNumber := Limite;
               end
               else If (J <> '' ) and
                       (X  = 'M') then
                       begin
                         HHNo := UpCaseStr(J);
                         SearchTree8 ( Root8 );
                         If RC = 'N' then
                            begin
                              HHNumber := FileSize(HsPdFile);
                              IncluiHsPd;
                            end;
                       end
                       else HHNumber := Limite;
    If HHNumber <> Limite then
       begin
         Repeat
           TitleHsPd;
           DataHsPd;
           Repeat
             Resp := ReadKey;
             LimpaLn(24,Tfd);
             If (Resp = #0) and (KeyPressed) then
                begin
                  Resp := ReadKey;
                  Case Resp of
                       #59 : begin
                               HHAN := HHNumber;
                               HHAC := HHNo;
                               ScrollHsPd;
                               HHNumber := HHAN;
                               HHNo     := HHAC;
                               DataHsPd;
                             end;
                       #61 : If X = 'M' then
                                begin
                                  Op := 'A';
                                  EntryHsPd;
                                  If TC = 'S' then ReadWrite(#10,'W','N',HHNumber);
                                end;
                       #72 : begin
                               RC := 'N';
                               SearchAnt8 ( Root8 );
                               If RC = 'N' then AvisoFinal;
                             end;
                       #80 : begin
                               RC := 'N';
                               SearchPos8 ( Root8 );
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

end.

