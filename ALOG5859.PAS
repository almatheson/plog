PROGRAM ALOG5859;

Uses Crt,Dos;

Type
  Saldos     = RECORD
                 Status      : Char;
                 Abertura    : Array [1..12] of Double;
                 Debitos     : Array [1..12] of Double;
                 Creditos    : Array [1..12] of Double;
                 Saldo       : Array [1..12] of Double;
                 SaldoB      : Array [1..12] of Double;
                 NLanctos    : Array [1..12] of Integer;
               END;

Var
   SSMember       : Saldos;
   SSFile         : FILE OF Saldos;

   U,I,En,X,E     : Integer;

   Cia,A,Disco    : String[2];

begin
    ClrScr;
    Disco := ParamStr(1);
    GotoXY(1,04); Write('Drive ....................: ',Disco);

    If Disco <> '' then
       begin
         A := ParamStr(2);
         GotoXY(1,05); Write('Ano cont bil .............: ',A:2);

         If A <> '' then
            begin
              Cia := ParamStr(3);
              GotoXY(1,06); Write('Cia ......................: ',Cia);

              If Cia <> '' then
                 begin
                   GotoXY(1,10); Write('Lancamentos Lidos   : ');


                   Assign (SSFile, (Disco + '\ALOGDATA\ALOGM0' + Cia + '\ALOGSX' + A + '.DAT'));

                   Reset ( SSFile );

                   If (IOResult         = 0) and
                      (FileSize(SSFile) > 0) then
                      begin
                        I  := -1;
                        Repeat
                          I := I + 1;

                          {$I-}
                          Seek ( SSFile, I        );
                          Read ( SSFile, SSMember );
                          {$I+}

                          If IOResult = 0 then
                             begin
                               En              := En + 1;

                               SSMember.Status := 'A';

                               Seek  ( SSFile, I        );
                               Write ( SSFile, SSMember );

                               GotoXY(23,10); Write((I + 1):5);
                             end;
                        Until (I + 1) = FileSize(SSFile);
                      end;

                   Close ( SSFile );
                 end;
            end;
       end;

  ClrScr;
  Halt;
end.