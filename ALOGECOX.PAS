{$O+,F+}
Unit AlogEcoX;

Interface

Uses Crt,Dos,AlogGlbs,AlogNavg,AlogBasP,AlogDoct,AlogInit;

   Procedure TitleEco;
   Procedure UpdateEco(X : Char);

Implementation


Procedure TitleEco;
begin
  Color(Tfn,Ttx);
  GotoXY(4,09);  Write('C¢digo:    Ano:');
  GotoXY(04,10); Write('Nome..:');
  GotoXY(04,12); Write('P/V/I :');
  GotoXY(04,14); Write('Janeir:');
  GotoXY(35,14); Write('Julho.:');
  GotoXY(04,15); Write('Fevere:');
  GotoXY(35,15); Write('Agosto:');
  GotoXY(04,16); Write('Mar‡o.:');
  GotoXY(35,16); Write('Setemb:');
  GotoXY(04,17); Write('Abril.:');
  GotoXY(35,17); Write('Outubr:');
  GotoXY(04,18); Write('Maio..:');
  GotoXY(35,18); Write('Novemb:');
  GotoXY(04,19); Write('Junho.:');
  GotoXY(35,19); Write('Dezemb:');
  Color(Tfn,Utx);
end;


Procedure DataEco;
begin
  HelpM;
  ReadWrite(#12,'R','N',IINumber);
  If RW = 'S' then
     With EcoMember do
     begin
       Color(Tfn,Utx);
       GotoXY(12,09); Write(Chave:2);
       GotoXY(20,09); Write(Ano:4);
       GotoXY(12,10); Write(Pushleft(7,Descricao));
       GotoXY(12,12);
       Case Tipo of
            'P' : Write('Percentual');
            'V' : Write('Valor     ');
            'I' : Write('Indice    ');
       end;
       For K := 1 to 6 do begin
                            GotoXY(12,(K + 13)); Write(Valores[K]:10:4);
                            GotoXY(43,(K + 13)); Write(Valores[K + 6]:10:4);
                          end;
     end;
end;


Procedure EntryEco;
begin
  With EcoMember do
  Repeat
    K := 1;
    Repeat
      Case K of
           1      : With EcoMember do
                    begin
                      J := Descricao;
		      InputStr(J,6,12,10,0,'S','S','T','N',Tfn,Utx);
                      Descricao := J;
                      If (Descricao = '') and (TC <> #27) then
                         begin
                           ErroMsg := 'Nome Inv lido';
                           ErrorMessage;
                         end
                         else K := 2;
                    end;
           2      : With EcoMember do
                    begin
                      Move(MemW[$B800:0000],ScArray5[1],4000);
                      DrawBox(38,14,57,18,Red,'S');
                      Color(Red,Cyan);
                      GotoXY(44,15); Write('ercentual');
                      GotoXY(44,16); Write('alor');
                      GotoXY(44,17); Write('ndice');
                      Color(Red,White);
                      GotoXY(43,15); Write('P');
                      GotoXY(43,16); Write('V');
                      GotoXY(43,17); Write('I');
                      J := Tipo;
		      InputStr(J,1,12,12,0,'S','N','T','N',Tfn,Utx);
                      Tipo := UpCase(J[1]);
                      If (Tipo <> 'P') and
                         (Tipo <> 'V') and
                         (Tipo <> 'I') and
                         (TC <> #27) then
                         begin
                           ErroMsg := 'Tipo Inv lido ( P, V ou I )';
                           ErrorMessage;
                         end
                         else If TC = #24 then K := 1
                                          else K := 3;
                      Move(ScArray5[1],MemW[$B800:0000],4000);
                      GotoXY(12,12);
                      Case Tipo of
                           'P' : Write('Percentual');
                           'V' : Write('Valor     ');
                           'I' : Write('Indice    ');
                      end;
                    end;
           3..14  : With EcoMember do
                    begin
                      If Valores[K - 2] = 0 then J := ''
                         else begin
                                Str(Valores[K - 2]:10:4,J);
                                J := LeftAdjust(J);
                              end;
		      If K < 9 then InputStr(J,10,12,(K + 11),0,'S','N','T','N',Tfn,Utx)
			       else InputStr(J,10,43,(K + 5),0,'S','N','T','N',Tfn,Utx);
                      Val(J,Valores[K - 2],E);
                      If K < 9 then GotoXY(12,(K + 11))
                               else GotoXY(43,(K + 5));
                      Write(Valores[K - 2]:10:4);
                      If TC <> #27 then If TC = #24 then K := K - 1
                                                    else K := K + 1;
                    end;
      end;
    Until (K = 15) or (TC = #27);
    If ((TC <> #27) and (Op = 'I')) or (Op = 'A') then Confirma;
  Until TC in ['S',#27];
end;


Procedure IncluiEco;
begin
  With EcoMember do
  begin
    Op          := 'I';
    Descricao   := '';
    Tipo        := ' ';
    For I := 1 to 12 do Valores[I] := 0;
    Color(Tfn,Utx);
    GotoXY(12,09); Write(Chave:2);
    GotoXY(20,09); Write(Ano:4);
    EntryEco;
    Move(ScArray4[1],MemW[$B800:0000],4000);
    If TC = 'S' then
       begin
         LoadTree7 ( Root7 );
         ReadWrite(#12,'W','N',IINumber);
         MasterMember.NIndices := MasterMember.NIndices + 1;
         ReadWrite(#00,'W','N',0);
         R    := MasterMember.NIndices;
         Resp := #000;
         Color(Red,Yellow);
         GotoXY(54,7); Write(MasterMember.NIndices);
         Move(MemW[$B800:0000],ScArray4[1],4000);
         DI := 'S';
       end
       else begin
              TC       := #13;
              IINumber := Limite;
            end;
  end;
end;


Procedure UpdateEco(X : Char);
begin
           Titulo := 'Indices Econ“micos                          ';
           BuildFrame('S');
           Color(Red,White);
           GotoXY(36,07); Write('Total de Indice: ');
           GotoXY(62,08); Write(#27,#217);
           GotoXY(62,10); Write(#24);
           GotoXY(62,11); Write(#25);
           Color(Red,Yellow);
           GotoXY(53,07); Write(MasterMember.NIndices);
           GotoXY(66,08); Write('C¢digo  ');
           GotoXY(66,10); Write('Anterior');
           GotoXY(66,11); Write('Pr¢ximo ');
           Shade(3,8,60,21,LightGray,Black);
           TitleEco;
           Move(MemW[$B800:0000],ScArray4[1],4000);
  Repeat
    J := '';
    InputStr(J,2,12,9,0,'S','N','T','N',Tfn,Utx);
    LimpaLn(24,Tfd);
    If TC = #27
       then IINumber := Limite
       else If TC = #25 then
               begin
                 IINo := '';
                 RC   := 'N';
                 SearchPos7 ( Root7 );
                 If RC = 'N' then IINumber := Limite;
               end
               else If J <> '' then
                       begin
                         EcoMember.Chave := UpCaseStr(J);
                         J := '';
                         InputStr(J,2,20,9,0,'S','N','T','N',Tfn,Utx);
                         If TC = #13 then
                            begin
                              EcoMember.Ano := J;
                              IINo          := EcoMember.Ano + '#' +
                                               EcoMember.Chave;
                              SearchTree7 ( Root7 );
                              If RC = 'N' then
                                 begin
                                   If X = 'M' then
                                      begin
                                        IINumber := FileSize(EcoFile);
                                        IncluiEco;
                                      end
                                      else IINumber := Limite;
                                 end;
                            end
                            else IINumber := Limite;
                       end
                       else IINumber := Limite;
    If IINumber <> Limite then
       With EcoMember do
       begin
         Repeat
           DataEco;
           Repeat
             Resp := ReadKey;
             LimpaLn(24,Tfd);
             If (Resp = #0) and (KeyPressed) then
                begin
                  Resp := ReadKey;
                  Case Resp of
                       #80 : begin
                               RC := 'N';
                               SearchPos7 ( Root7 );
                               If RC = 'N' then AvisoFinal;
                             end;
                       #72 : begin
                               RC := 'N';
                               SearchAnt7 ( Root7 );
                               If RC = 'N' then AvisoFinal;
                             end;
                       #61  : If X = 'M' then
                                 begin
                                   Op := 'A';
                                   EntryEco;
                                   If TC = 'S'
                                      then ReadWrite(#12,'W','N',IINumber);
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

end.

