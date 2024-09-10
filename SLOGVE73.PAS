PROGRAM SLOGVE73;

Uses Crt,Dos;

Type
  Owner      = RECORD
                 Marca       : String[15];
                 RSocial     : String[40];
                 Endereco    : String[40];
                 Cidade      : String[20];
                 Estado      : String[2];
                 Cep         : String[9];
                 Telefone    : String[15];
                 Cgc         : String[20];
                 Inscricao   : String[20];
                 NBase       : Integer;
                 NoSerie     : String[8];
                 Versao      : String[8];
                 Produto     : String[6];
               END;

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
                 EMaximo     : Array[1..12] of Real;
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

  Produto    = RECORD
                 Status      : Char;
                 Referencia  : String[15];
                 Familia     : String[3];
                 Descricao   : String[40];
                 Unidade     : String[3];
                 Decimais    : Integer;
                 Peso        : Real;
                 QMediaAb    : Real;
                 CMedioAb    : Real;
                 Precos      : Array[1..10] of Real;
                 QAbertura   : Array[1..12] of Real;
                 QEntrada    : Array[1..12] of Real;
                 QSaida      : Array[1..24] of Real;
                 Saldo       : Array[1..12] of Real;
                 EMinimo     : Array[1..12] of Real;
                 EMaximo     : Array[1..12] of Real;
                 QMedia      : Array[1..12] of Real;
                 CMedio      : Array[1..12] of Real;
                 CustoX      : Array[1..12] of Char;
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

  TabCmpy    = RECORD
                 Chave       : String[3];
                 Descricao   : String[40];
                 Status      : Char;
                 DataBkp     : String[8];
               END;


Var
   OOMember       : Owner;
   OOFile         : FILE OF Owner;
   POMember       : ProdutoO;
   POFile         : FILE OF ProdutoO;
   PNMember       : Produto;
   PNFile         : FILE OF Produto;
   CCMember       : TabCmpy;
   CCFile         : FILE OF TabCmpy;

   I,A,C,R,U,E,Ind,Ii,Fn : Integer;
   XDr,XAno,XAnoI,
   XAnoF                 : String[2];
   XDir                  : String[20];


Procedure Converte;
begin
  Assign (POFile, (XDir + '\SLOGPX' + XAno + '.OLD'));
  {$I-}
  Reset ( POFile );
  {$I+}
  If IOResult <> 0 then
     begin
       Assign (POFile, (XDir + '\SLOGPX' + XAno + '.DAT'));
       {$I-}
       Reset ( POFile );
       {$I+}
       If IOResult = 0 then
          begin
            Close (POFile );
            Rename (POFile, (XDir + '\SLOGPX' + XAno + '.OLD'));
            {$I-}
            Reset  ( POFile );
            {$I+}
            If IOResult = 0 then
               begin
                 Assign (PNFile, (XDir + '\SLOGPX' + XAno + '.DAT'));
                 ReWrite ( PNFile );
                 Reset   ( PNFile );
                 I := -1;
                 Repeat
                   I := I + 1;
                   {$I-}
                   Seek ( POFile, I        );
                   Read ( POFile, POMember );
                   {$I+}
                   If IOResult = 0 then
                      begin
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
                          PNMember.EMaximo[Ind]     := POMember.EMaximo[Ind];
                          PNMember.QMedia[Ind]      := POMember.QMedia[Ind];
                          PNMember.CMedio[Ind]      := POMember.CMedio[Ind];
                          PNMember.CustoX[Ind]      := 'S';
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
                        PNMember.Inventario := POMember.Inventario;
                        PNMember.QMediaAb   := POMember.QMedia[1];
                        PNMember.CMedioAb   := POMember.CMedio[1];
                        U := FileSize(PNFile);
                        Seek  ( PNFile, U        );
                        Write ( PNFile, PNMember );
                      end;
                 Until (I + 1) = FileSize(POFile);
                 Writeln('          Produtos Convertidos: ',(U + 1):4);
                 Close ( PNFile );
                 Close ( POFile );
                 Erase ( POFile );
               end
               else Close ( POFile );
          end;
     end
     else Close ( POFile );
end;


begin
  XDr   := '';
  XDr   := ParamStr(1);
  XAnoI := '';
  XAnoI := ParamStr(2);
  XAnoF := '';
  XAnoF := ParamStr(3);

  If (XDr   <> '') and
     (XAnoI <> '') and
     (XAnoF <> '') then
     begin
       ClrScr;
       Assign ( OOFile, (XDr + '\SLOGDATA\PLXOWNER.DAT'));
       {$I-}
       Reset ( OOFile );
       {$I+}
       If IOResult = 0 then
          begin
            Seek  ( OOFile, 0        );
            Read  ( OOFile, OOMember );
            If OOMember.Versao = '7.204/95' then
               begin
                 OOMember.Versao := '7.306/95';
                 Seek  ( OOFile, 0        );
                 Write ( OOFile, OOMember );
                 Assign (CCFile, (XDr + '\SLOGDATA\SLOGCMPY.DAT'));
                 {$I-}
                 Reset ( CCFile );
                 {$I+}
                 If IOResult = 0 then
                    begin
                      C := -1;
                      Repeat
                        C := C + 1;
                        Seek ( CCFile, C        );
                        Read ( CCFile, CCMember );
                        XDir := XDr + '\SLOGDATA\SLOGM' + CCMember.Chave;
                        Writeln('*** Convertendo Cia ',CCMember.Chave);
                        Val(XAnoI,Ii,E);
                        Val(XAnoF,Fn,E);
                        For A := Ii to Fn do
                        begin
                          Str(A,XAno);
                          If A < 10 then XAno := '0' + XAno;
                          Converte;
                        end;
                      Until (C + 1) = FileSize(CCFile);
                      Close ( CCFile );
                    end;
               end;
            Close ( OOFile );
          end;
     end
     else Writeln('O drive,Cia,Ano n„o foram informados (SlogVE73 C: AnoI AnoF)');
  Halt;
end.
