PROGRAM SLOGVE71;

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

  EntradasO  = RECORD
                 Data        : String[6];
                 OrigData    : String[8];
                 Status      : Char;
                 Especie     : String[5];
                 Serie       : String[3];
                 Numero      : String[8];
                 DataNF      : String[8];
                 CGC         : String[16];
                 Estado      : String[2];
                 Nome        : String[20];
                 ValorCont   : Real;
                 CodFiscal   : String[4];
                 Codigo1     : Char;
                 ICMBaseC    : Double;
                 ICMAliquota : Double;
                 ICMImposto  : Double;
                 Codigo2     : Char;
                 IPIBaseC    : Double;
                 IPIImposto  : Double;
                 Codigo3     : Char;
                 IPIBaseC3   : Double;
                 SubTrib     : Double;
                 Obs         : String[15];
                 Depto       : String[6];
                 ClassContab : Array[1..5] of String[18];
                 DebCred     : Array[1..5] of Char;
                 ValorContab : Array[1..5] of Double;
                 Historicos  : Array[1..3] of String[60];
                 Tipo        : Char;
                 Referencia  : Array[1..20] of String[15];
                 Quantidade  : Array[1..20] of Real;
                 PrecoU      : Array[1..20] of Real;
               END;

  Entradas   = RECORD
                 Data        : String[6];
                 OrigData    : String[8];
                 Status      : Char;
                 Especie     : String[5];
                 Serie       : String[3];
                 Numero      : String[8];
                 DataNF      : String[8];
                 CGC         : String[16];
                 Estado      : String[2];
                 Nome        : String[20];
                 ValorCont   : Real;
                 CodFiscal   : String[4];
                 Codigo1     : Char;
                 ICMBaseC    : Double;
                 ICMAliquota : Double;
                 ICMImposto  : Double;
                 Codigo2     : Char;
                 IPIBaseC    : Double;
                 IPIImposto  : Double;
                 Codigo3     : Char;
                 IPIBaseC3   : Double;
                 SubTrib     : Double;
                 Obs         : String[15];
                 Depto       : String[6];
                 ClassContab : Array[1..5] of String[18];
                 DebCred     : Array[1..5] of Char;
                 ValorContab : Array[1..5] of Double;
                 Historicos  : Array[1..3] of String[60];
                 Tipo        : Char;
                 Referencia  : Array[1..20] of String[15];
                 Quantidade  : Array[1..20] of Real;
                 PrecoU      : Array[1..20] of Real;
                 Xlog        : Char;
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
   EOMember       : EntradasO;
   EOFile         : FILE OF EntradasO;
   ENMember       : Entradas;
   ENFile         : FILE OF Entradas;
   CCMember       : TabCmpy;
   CCFile         : FILE OF TabCmpy;

   I,A,C,R,U,E,Ind,Ii,Fn : Integer;
   XDr,XAno,XAnoI,
   XAnoF                 : String[2];
   XDir                  : String[20];


Procedure ConverteNota;
Var
  Mi      : Integer;
  Mes     : String[2];
begin
  For Mi := 1 to 12 do
  begin
    Str(Mi,Mes);
    If Mi < 10 then Mes := '0' + Mes;
    Assign (EOFile, (XDir + '\SLOGEX' + XAno + '.O' + Mes));
    {$I-}
    Reset ( EOFile );
    {$I+}
    If IOResult <> 0 then
       begin
         Assign (EOFile, (XDir + '\SLOGEX' + XAno + '.M' + Mes));
         {$I-}
         Reset ( EOFile );
         {$I+}
         If IOResult = 0 then
            begin
              Close (EOFile );
              Rename (EOFile, (XDir + '\SLOGEX' + XAno + '.O' + Mes));
              {$I-}
              Reset  ( EOFile );
              {$I+}
              If IOResult = 0 then
                 begin
                   Assign (ENFile, (XDir + '\SLOGEX' + XAno + '.M' + Mes));
                   ReWrite ( ENFile );
                   Reset   ( ENFile );
                   I := -1;
                   Repeat
                     I := I + 1;
                     {$I-}
                     Seek ( EOFile, I        );
                     Read ( EOFile, EOMember );
                     {$I+}
                     If IOResult = 0 then
                        begin
                          ENMember.Data        := EOMember.Data;
                          ENMember.OrigData    := EOMember.OrigData;
                          ENMember.Status      := EOMember.Status;
                          ENMember.Especie     := EOMember.Especie;
                          ENMember.Serie       := EOMember.Serie;
                          ENMember.Numero      := EOMember.Numero;
                          ENMember.DataNF      := EOMember.DataNF;
                          ENMember.CGC         := EOMember.CGC;
                          ENMember.Estado      := EOMember.Estado;
                          ENMember.Nome        := EOMember.Nome;
                          ENMember.ValorCont   := EOMember.ValorCont;
                          ENMember.CodFiscal   := EOMember.CodFiscal;
                          ENMember.Codigo1     := EOMember.Codigo1;
                          ENMember.ICMBaseC    := EOMember.ICMBaseC;
                          ENMember.ICMAliquota := EOMember.ICMAliquota;
                          ENMember.ICMImposto  := EOMember.ICMImposto;
                          ENMember.Codigo2     := EOMember.Codigo2;
                          ENMember.IPIBaseC    := EOMember.IPIBaseC;
                          ENMember.IPIImposto  := EOMember.IPIImposto;
                          ENMember.Codigo3     := EOMember.Codigo3;
                          ENMember.IPIBaseC3   := EOMember.IPIBaseC3;
                          ENMember.SubTrib     := EOMember.SubTrib;
                          ENMember.Obs         := EOMember.Obs;
                          ENMember.Depto       := EOMember.Depto;
                          ENMember.Tipo        := EOMember.Tipo;
                          For Ind := 1 to 5 do
                          begin
                            ENMember.ClassContab[Ind] := EOMember.ClassContab[Ind];
                            ENMember.DebCred[Ind]     := EOMember.DebCred[Ind];
                            ENMember.ValorContab[Ind] := EOMember.ValorContab[Ind];
                          end;
                          For Ind := 1 to 3
                          do ENMember.Historicos[Ind] := EOMember.Historicos[Ind];
                          For Ind := 1 to 20 do
                          begin
                            ENMember.Referencia[Ind] := EOMember.Referencia[Ind];
                            ENMember.Quantidade[Ind] := EOMember.Quantidade[Ind];
                            ENMember.PrecoU[Ind]     := EOMember.PrecoU[Ind];
                          end;
                          ENMember.Xlog := 'S';
                          U := FileSize(ENFile);
                          Seek  ( ENFile, U        );
                          Write ( ENFile, ENMember );
                        end;
                   Until (I + 1) = FileSize(EOFile);
                   Close ( ENFile );
                   Close ( EOFile );
                   Erase ( EOFile );
                 end
                 else Close ( EOFile );
            end;
       end
       else Close ( EOFile );
  end;
end;


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
                          PNMember.EMaximo[Ind]     := 0;
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
                        PNMember.Inventario := POMember.Inventario;
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
            If OOMember.Versao = '7.012/94' then
               begin
                 OOMember.Versao := '7.102/95';
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
                          ConverteNota;
                        end;
                      Until (C + 1) = FileSize(CCFile);
                      Close ( CCFile );
                    end;
               end;
            Close ( OOFile );
          end;
     end
     else Writeln('O drive,Cia,Ano n„o foram informados (SlogVE71 C: AnoI AnoF)');
  Halt;
end.
