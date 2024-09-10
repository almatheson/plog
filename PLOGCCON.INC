Procedure GeraVoucher;
Var
  FErro   : Integer;
begin
  PedeConstante;
  Move(MemW[$B800:0000],ScArray6[1],4000);
  If TC = 'S' then
     begin
       XDisco := '';
       Repeat
         Color(Red,Cyan);
         GotoXY(01,24); Write(ConstStr(' ',80));
         GotoXY(02,24); Write('Path e Arquivo (             ):');
         Color(Red,White);
         GotoXY(18,24); Write('A:Arquivo.Ext');
         J := XDisco;
         InputStr(J,30,34,24,0,'S','N','T','N',Red,Yellow);
         XDisco := UpCaseStr(J);
         GotoXY(34,24); Write(XDisco);
         If (XDisco[1] in ['A','B','C','D','E','F']) and
            (TC        <> #27                      ) then Confirma
            else If TC <> #27 then
                    begin
                      ErroMsg := 'Informe A,B,C,D,E ou F';
                      ErrorMessage;
                    end;
       Until TC in [#27,'S'];
     end;
  Move(ScArray6[1],MemW[$B800:0000],4000);
  If TC = 'S' then
     begin
       TC    := 'N';
       WData := QQStr(TabDia[MM],2,'0') + '/' +
                QQStr(MM,2,'0')         + '/' +
                QQStr(AA,2,'0');
       If XDisco[1] in ['A','B'] then
          begin
            Color(Blue,White);
            GotoXY(01,23); Write(' ':80);
            GotoXY(02,23); Write('Monte o Disquete no drive ',Copy(XDisco,1,2));
            TeclaReturn;
            LimpaLn(23,Tfd);
          end
          else TC := #13;
       If TC = #13 then
          begin
            TC := 'S';
            Close ( BBFile );
            Close ( SSFile );
            Assign ( MovFile, XDisco );
            {$I-}
            Reset ( MovFile );
            {$I+}
            FErro := IOResult;
            If FErro = 0 then
	       begin
                 Close   ( MovFile );
                 Erase   ( MovFile );
	         ReWrite ( MovFile );
               end
               else If FErro = 2 then ReWrite ( MovFile )
                                 else TC := #27;
            If TC = #27 then
               begin
                 Color(Blue,Yellow);
                 GotoXY(1,23); Write(' ':80);
                 GotoXY(2,23);
                 Write('NÆo consegui abrir o arquivo ',XDisco,' verifique.');
                 TeclaReturn;
                 TC := #27;
               end;
            If TC <> #27 then
               begin
                 MovMember.Status       := ' ';
                 MovMember.OrigData     := '';
                 MovMember.Conta        := '';
                 MovMember.MesLancto    := 0;
                 MovMember.Tipo         := ' ';
                 MovMember.Valor        := 0;
                 MovMember.Depto        := '';
                 MovMember.Historico[1] := '';
                 MovMember.Historico[2] := '';
                 MovMember.Historico[3] := '';
                 MovMember.Lote         := '';
                 MovMember.SeqLote      := '';
                 Contabiliza;
                 Close ( MovFile   );
                 Color(Blue,White);
                 GotoXY(01,23); Write(' ':80);
                 GotoXY(02,23);
                 Write('O Lote de Contabiliza‡Æo de ',ArrayMesEx[MM],' de ',AA,' esta gerado.');
                 TeclaReturn;
               end;
            Reset ( BBFile );
            Reset ( SSFile );
          end;
     end;
  Resp := #13;
end;

