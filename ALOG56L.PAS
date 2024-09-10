PROGRAM ALOG56L;

Uses Crt,Dos;

Type
  Maco       = RECORD
                 Ocupado      : Char;
                 MesContabil  : Integer;
                 Voucher      : String[6];
                 Status       : Char;
                 Debito       : Real;
                 Credito      : Real;
                 RDebito      : Integer;
                 RCredito     : Integer;
                 DataAbert    : String[8];
                 DiscoVol     : Integer;
                 Posicao      : Char;
                 Reabertura   : Integer;
                 TipoVch      : Char;
               END;


  Lote       = RECORD
                 Chave        : String[6];
                 MesContabil  : Integer;
                 Status       : Char;
                 Debito       : Double;
                 Credito      : Double;
                 RDebito      : Integer;
                 RCredito     : Integer;
                 DataAbert    : String[8];
                 Tipo         : Char;
                 Descricao    : String[20];
                 Dias         : Array[1..31] of Char;
               END;

Var
   MMMember       : Maco;
   MMFile         : FILE OF Maco;
   LLMember       : Lote;
   LLFile         : FILE OF Lote;

   U,I,En,X    : Integer;
   Cia,MMM     : String[2];

begin
  Repeat
    ClrScr;
    Cia := '';
    GotoXY(1,05); Write('Cia no Formato (01).......: ');
    Readln (Cia);

    If Cia <> '' then
       begin
         GotoXY(1,10); Write('Lancamentos Lidos   : ');
         GotoXY(1,12); Write('            Gravados: ');


         Assign (MMFile, ('C:\ALOGDATA\ALOGM' + Cia + '\ALOGVC' + Cia + '.DAT'));

         {$I-}
         Rename ( MMFile, ('C:\ALOGDATA\ALOGM' + Cia + '\ALOGVV55.OLD'));
         {$I+}

         If IOResult = 0 then
            begin
              {$I-}
              Reset ( MMFile );
              {$I+}

              If (IOResult         = 0) and
                 (FileSize(MMFile) > 0) then
                 begin
                   Assign (LLFile, ('C:\ALOGDATA\ALOGM' + Cia + '\ALOGLT' + Cia  + '.DAT'));

                   {$I-}
                   Reset   ( LLFile );
                   {$I+}

                   If IOResult = 0 then
                      begin
                        Close ( LLFile );
                        Erase ( LLFile );
                      end;

                   ReWrite ( LLFile );
                   Reset   ( LLFile );

                   En := 0;

                   I  := -1;
                   Repeat
                     I := I + 1;

                     {$I-}
                     Seek ( MMFile, I        );
                     Read ( MMFile, MMMember );
                     {$I+}

                     If IOResult = 0 then
                        begin
                          En                    := En + 1;

                          LLMember.Chave        := MMMember.Voucher;
                          LLMember.MesContabil  := MMMember.MesContabil;
                          LLMember.Status       := MMMember.Status;
                          LLMember.Debito       := MMMember.Debito;
                          LLMember.Credito      := MMMember.Credito;
                          LLMember.RDebito      := MMMember.RDebito;
                          LLMember.RCredito     := MMMember.RCredito;
                          LLMember.DataAbert    := MMMember.DataAbert;
                          LLMember.Tipo         := 'N';
                          LLMember.Descricao    := '';
                          For X := 1 to 31 do LLMember.Dias[X] := '.';

                          U := FileSize(LLFile);

                          Seek  ( LLFile, U        );
                          Write ( LLFile, LLMember );

                          GotoXY(23,10); Write(En:5);
                          GotoXY(23,12); Write((U + 1):5);
                        end;
                   Until (I + 1) = FileSize(MMFile);

                   Close ( LLFile );
                 end;

              Close ( MMFile );
              Erase ( MMFile );
            end;
       end;

  Until Cia = '';

  Halt;
end.