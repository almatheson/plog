PROGRAM SLOGDELA;

Uses Crt,Dos;

Type

  ProdutoO   = RECORD
                 Status      : Char;
                 Referencia  : String[15];
                 Familia     : String[3];
                 Descricao   : String[40];
                 Unidade     : String[3];
                 Decimais    : Integer;
                 Peso        : Real;
                 Precos      : Array[1..10] of Real;
                 QAbertura   : Array[1..12] of Real;
                 QEntrada    : Array[1..12] of Real;
                 QSaida      : Array[1..24] of Real;
                 Saldo       : Array[1..12] of Real;
                 EMinimo     : Array[1..12] of Real;
                 QMedia      : Array[1..12] of Real;
                 CMedio      : Array[1..12] of Real;
                 MesesMedio  : Integer;
                 IPI         : Real;
                 Marca       : Array[1..3] of String[40];
               END;


  Produto    = RECORD
                 Status      : Char;
                 Referencia  : String[15];
                 Familia     : String[3];
                 Descricao   : String[40];
                 Unidade     : String[3];
                 Decimais    : Integer;
                 Peso        : Real;
                 Precos      : Array[1..10] of Real;
                 QAbertura   : Array[1..12] of Real;
                 QEntrada    : Array[1..12] of Real;
                 QSaida      : Array[1..24] of Real;
                 Saldo       : Array[1..12] of Real;
                 EMinimo     : Array[1..12] of Real;
                 QMedia      : Array[1..12] of Real;
                 CMedio      : Array[1..12] of Real;
                 AbertCrs    : Array[1..12] of Real;
                 EntraCrs    : Array[1..12] of Real;
                 SaidaCrs    : Array[1..12] of Real;
                 MesesMedio  : Integer;
                 IPI         : Real;
                 Marca       : Array[1..3] of String[40];
               END;


Var
   POMember       : ProdutoO;
   POFile         : FILE OF ProdutoO;
   PNMember       : Produto;
   PNFile         : FILE OF Produto;

   Ind,E,
   U,I,En,R,D,M : Integer;
   XDr,
   Cia,Ano      : String[2];

begin
  XDr := '';
  XDr := ParamStr(1);
  Cia := '';
  Cia := ParamStr(2);
  Ano := '';
  Ano := ParamStr(3);

  If (XDr <> '') and
     (Cia <> '') and
     (Ano <> '') then
     begin
       ClrScr;
       Assign (POFile, (XDr + '\SLOGDATA\SLOGM0' + Cia + '\SLOGPX' + Ano + '.OLD'));

       {$I-}
       Reset ( POFile );
       {$I+}

       If IOResult <> 0 then
          begin
            Assign (POFile, (XDr + '\SLOGDATA\SLOGM0' + Cia + '\SLOGPX' + Ano + '.DAT'));

            Rename (POFile, (XDr + '\SLOGDATA\SLOGM0' + Cia + '\SLOGPX' + Ano + '.OLD'));
            {$I-}
            Reset  ( POFile );
            {$I+}

            If IOResult = 0 then
               begin
                 Assign (PNFile, (XDr + '\SLOGDATA\SLOGM0' + Cia + '\SLOGPX' + Ano + '.DAT'));

                 ReWrite ( PNFile );
                 Reset   ( PNFile );
                 En := 0;

                 I  := -1;
                 Repeat
                   I := I + 1;
                   {$I-}
                   Seek ( POFile, I        );
                   Read ( POFile, POMember );
                   {$I+}
                   If IOResult = 0 then
                      begin
                        En                   := En + 1;
                        PNMember.Status      := POMember.Status;
                        PNMember.Referencia  := POMember.Referencia;
                        PNMember.Familia     := POMember.Familia;
                        PNMember.Descricao   := POMember.Descricao;
                        PNMember.Unidade     := POMember.Unidade;
                        PNMember.Decimais    := POMember.Decimais;
                        PNMember.Peso        := POMember.Peso;

                        For Ind := 1 to 10
                        do PNMember.Precos[Ind] := POMember.Precos[Ind];

                        For Ind := 1 to 12 do
                        begin
                          PNMember.QAbertura[Ind]   := POMember.QAbertura[Ind];
                          PNMember.QEntrada[Ind]    := POMember.QEntrada[Ind];
                          PNMember.QSaida[Ind]      := POMember.QSaida[Ind];
                          PNMember.QSaida[Ind+12]   := POMember.QSaida[Ind+12];
                          PNMember.Saldo[Ind]       := POMember.Saldo[Ind];
                          PNMember.EMinimo[Ind]     := POMember.EMinimo[Ind];
                          PNMember.QMedia[Ind]      := POMember.QMedia[Ind];
                          PNMember.CMedio[Ind]      := POMember.CMedio[Ind];
                          PNMember.AbertCrs[Ind]    := 0;
                          PNMember.EntraCrs[Ind]    := 0;
                          PNMember.SaidaCrs[Ind]    := 0;
                        end;

                        PNMember.MesesMedio  := POMember.MesesMedio;
                        PNMember.IPI         := POMember.IPI;

                        For Ind := 1 to 3
                        do PNMember.Marca[Ind] := POMember.Marca[Ind];

                        U := FileSize(PNFile);

                        Seek  ( PNFile, U        );
                        Write ( PNFile, PNMember );

                        GotoXY(1,1);
                        Write('Convertendo Produtos Lidos: ',(I + 1):4,' Convertidos: ',(U + 1):4);
                      end;
                 Until (I + 1) = FileSize(POFile);
                 Close ( PNFile );
               end;
          end;

       Close ( POFile );
     end
     else Writeln('O drive,Cia,Ano n„o foram informados (SlogDela C: 01 93)');

  Halt;
end.