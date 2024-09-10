{$M 65520,0,153600}

PROGRAM SLOG60MM;

Uses Crt,Dos;

Type
  Str8       = String[8];

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
                 AbertCrs    : Array[1..12] of Real;
                 EntraCrs    : Array[1..12] of Real;
                 SaidaCrs    : Array[1..12] of Real;
                 MesesMedio  : Integer;
                 IPI         : Real;
                 Marca       : Array[1..3] of String[40];
                 Fornecedor  : Array[1..3] of String[20];
                 DataUC      : Array[1..3] of String[8];
                 PrecoUC     : Array[1..3] of Real;
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
                 Fornecedor  : Array[1..3] of String[20];
                 DataUC      : Array[1..3] of String[8];
                 PrecoUC     : Array[1..3] of Real;
                 Inventario  : Char;
               END;

Var
   POMember       : ProdutoO;
   POFile         : FILE OF ProdutoO;
   PNMember       : Produto;
   PNFile         : FILE OF Produto;

   TC,RC        : Char;
   Ind,E,Mes,
   U,I,En,R,D,M : Integer;
   XDr,MM,
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
                 I := -1;
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
                          PNMember.AbertCrs[Ind]    := POMember.AbertCrs[Ind];
                          PNMember.EntraCrs[Ind]    := POMember.EntraCrs[Ind];
                          PNMember.SaidaCrs[Ind]    := POMember.SaidaCrs[Ind];
                        end;

                        PNMember.MesesMedio  := POMember.MesesMedio;
                        PNMember.IPI         := POMember.IPI;

                        For Ind := 1 to 3 do
                        begin
                          PNMember.Marca[Ind]      := POMember.Marca[Ind];
                          PNMember.Fornecedor[Ind] := POMember.Fornecedor[Ind];
                          PNMember.DataUC[Ind]     := POMember.DataUC[Ind];
                          PNMember.PrecoUC[Ind]    := POMember.PrecoUC[Ind];
                        end;
                        PNMember.Inventario := 'S';

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
     else Writeln('O drive,Cia,Ano n„o foram informados (Slog60MM C: 01 93)');
  Halt;
end.