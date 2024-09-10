PROGRAM ALOG56R;

Uses Crt,Dos;

Type
  LancamentoO = RECORD
                 Data         : String[6];
                 OrigData     : String[8];
                 Conta        : String[15];
                 MesLancto    : Integer;
                 Tipo         : Char;
                 Valor        : Real;
                 LocalCCusto  : String[6];
                 Historico    : Array[1..3] of String[60];
                 Lote         : String[6];
                 SeqLote      : String[3];
                 Origem       : String[10];
               END;

  Lancamento = RECORD
                 Status       : Char;
                 OrigData     : String[8];
                 Conta        : String[15];
                 MesLancto    : Integer;
                 Tipo         : Char;
                 Valor        : Real;
                 LocalCCusto  : String[6];
                 Historico    : Array[1..3] of String[60];
                 Lote         : String[6];
                 SeqLote      : String[4];
               END;

Var
   EEMember       : LancamentoO;
   EEFile         : FILE OF LancamentoO;
   ENMember       : Lancamento;
   ENFile         : FILE OF Lancamento;

   U,I,En      : Integer;
   Cia,MMM     : String[2];

begin
  Repeat
    ClrScr;
    Cia := '';
    GotoXY(1,05); Write('Cia no Formato (01).......: ');
    Readln (Cia);

    If Cia <> '' then
       Repeat
         MMM := '';

         GotoXY(1,06); Write('Mˆs no Formato (01).......: ');
         Readln (MMM);

         GotoXY(1,10); Write('Lancamentos Lidos   : ');
         GotoXY(1,12); Write('            Gravados: ');


         Assign (EEFile, ('C:\ALOGDATA\ALOGM' + Cia + '\ALOGMV' + Cia + '.M' + MMM));

         {$I-}
         Rename ( EEFile, ('C:\ALOGDATA\ALOGM' + Cia + '\ALOGMM55.OLD'));
         {$I+}

         If IOResult = 0 then
            begin
              {$I-}
              Reset ( EEFile );
              {$I+}

              If IOResult = 0 then
                 begin
                   Assign (ENFile, ('C:\ALOGDATA\ALOGM' + Cia + '\ALOGMV' + Cia  + '.M' + MMM));

                   {$I-}
                   Reset   ( ENFile );
                   {$I+}

                   If IOResult = 0 then
                      begin
                        Close ( ENFile );
                        Erase ( ENFile );
                      end;

                   ReWrite ( ENFile );
                   Reset   ( ENFile );

                   En := 0;

                   I  := -1;
                   Repeat
                     I := I + 1;

                     {$I-}
                     Seek ( EEFile, I        );
                     Read ( EEFile, EEMember );
                     {$I+}

                     If IOResult = 0 then
                        begin
                          En                    := En + 1;

                          If EEMember.Data <> '' then
                             begin
                               ENMember.Status       := 'A';
                               ENMember.OrigData     := EEMember.OrigData;
                               ENMember.Conta        := EEMember.Conta;
                               ENMember.MesLancto    := EEMember.MesLancto;
                               ENMember.Tipo         := EEMember.Tipo;
                               ENMember.Valor        := EEMember.Valor;
                               ENMember.LocalCCusto  := EEMember.LocalCCusto;
                               ENMember.Historico[1] := EEMember.Historico[1];
                               ENMember.Historico[2] := EEMember.Historico[2];
                               ENMember.Historico[3] := EEMember.Historico[3];
                               ENMember.Lote         := EEMember.Lote;
                               ENMember.SeqLote      := EEMember.SeqLote;
                               If Length(ENMember.SeqLote) < 4
                                  then ENMember.SeqLote := '0' + ENMember.SeqLote;

                               U := FileSize(ENFile);

                               Seek  ( ENFile, U        );
                               Write ( ENFile, ENMember );
                             end;

                          GotoXY(23,10); Write(En:5);
                          GotoXY(23,12); Write((U + 1):5);
                        end;
                   Until (I + 1) = FileSize(EEFile);

                   Close ( ENFile );
                 end;

              Close ( EEFile );
              Erase ( EEFile );
            end;

       Until MMM = '';

  Until Cia = '';

  Halt;
end.