{$M 65520,0,153600}

PROGRAM SLOG60FF;

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
               END;

  EntradaO   = RECORD
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
               END;

  ProdutoEO  = RECORD
                 Data        : String[6];
                 Referencia  : String[15];
                 NumeroNF    : String[6];
                 Descricao   : String[40];
                 OrigData    : String[8];
                 DataNF      : String[8];
                 Quantidade  : Real;
                 PrecoU      : Real;
                 ICM         : Real;
               END;

  SaidaO     = RECORD
                 Numero      : String[8];
                 Data        : String[8];
                 Status      : Char;
                 Depto       : String[10];
                 Obs         : Array[1..4] of String[40];
               END;

  ProdutoSO  = RECORD
                 NumeroRQ    : String[6];
                 Data        : String[8];
                 Referencia  : String[15];
                 Quantidade  : Real;
               END;

  Entrada    = RECORD
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

  Saidas     = RECORD
                 Numero      : String[8];
                 Data        : String[8];
                 Status      : Char;
                 Depto       : String[10];
                 Obs         : Array[1..4]  of String[40];
                 Referencia  : Array[1..20] of String[15];
                 Quantidade  : Array[1..20] of Real;
               END;

  Pointer3  = ^STree3;

  STree3    = RECORD
                Chave3       : Str8;
                RelAddr3     : Integer;
                Left3,Right3 : Pointer3;
                Weight3      : Integer;
              END;


Var
   POMember       : ProdutoO;
   POFile         : FILE OF ProdutoO;
   PNMember       : Produto;
   PNFile         : FILE OF Produto;

   EOMember       : EntradaO;
   EOFile         : FILE OF EntradaO;
   ENMember       : Entrada;
   ENFile         : FILE OF Entrada;

   PEOMember      : ProdutoEO;
   PEOFile        : FILE OF ProdutoEO;

   SOMember       : SaidaO;
   SOFile         : FILE OF SaidaO;
   SNMember       : Saidas;
   SNFile         : FILE OF Saidas;

   PSOMember      : ProdutoSO;
   PSOFile        : FILE OF ProdutoSO;

   TC,RC        : Char;
   Seq,
   Ind,E,Mes,
   EENumber,
   U,I,En,R,D,M : Integer;
   XDr,MM,
   Cia,Ano      : String[2];
   SeqX         : String[3];
   EENo         : String[8];
   Root3        : Pointer3;


Function WtTree3 ( Var Root3 : Pointer3 ) : Integer;
begin
  If Root3 = NIL then WtTree3 := 1
                 else WtTree3 := Root3^.Weight3;
end;


Procedure LftRTree3 ( Var Root3 : Pointer3 );
Var
   Temp : Pointer3;

begin
  Temp           := Root3;
  Root3          := Root3^.Right3;
  Temp^.Right3   := Root3^.Left3;
  Root3^.Left3   := Temp;
  Root3^.Weight3 := Temp^.Weight3;
  Temp^.Weight3  := WtTree3 ( Temp^.Left3 ) + WtTree3 ( Temp^.Right3 );
end;


Procedure RthRTree3 ( Var Root3 : Pointer3 );
Var
   Temp : Pointer3;

begin
  Temp           := Root3;
  Root3          := Root3^.Left3;
  Temp^.Left3    := Root3^.Right3;
  Root3^.Right3  := Temp;
  Root3^.Weight3 := Temp^.Weight3;
  Temp^.Weight3  := WtTree3 ( Temp^.Left3 ) + WtTree3 ( Temp^.Right3 );
end;


Procedure ChkRTree3 ( Var Root3 : Pointer3 );
Var
    Wl,Wr : Integer;

begin
  If Root3 <> NIL then
     begin
       Wl := WtTree3 ( Root3^.Left3  );
       Wr := WtTree3 ( Root3^.Right3 );

       If Wr > Wl then
          begin
            If WtTree3 ( Root3^.Right3^.Right3 ) > Wl then
               begin
                 LftRTree3 ( Root3 );
                 ChkRTree3 ( Root3^.Left3 );
               end
               else If WtTree3 ( Root3^.Right3^.Left3 ) > Wl then
                       begin
                         RthRTree3 ( Root3^.Right3 );
                         LftRTree3 ( Root3 );
                         ChkRTree3 ( Root3^.Left3  );
                         ChkRTree3 ( Root3^.Right3 );
                       end;
          end
          else If Wl > Wr then
                  begin
                    If WtTree3 ( Root3^.Left3^.Left3 ) > Wr then
                       begin
                         RthRTree3 ( Root3 );
                         ChkRTree3 ( Root3^.Right3 );
                       end
                       else If WtTree3 ( Root3^.Left3^.Right3 ) > Wr then
                               begin
                                 LftRTree3 ( Root3^.Left3 );
                                 RthRTree3 ( Root3 );
                                 ChkRTree3 ( Root3^.Left3  );
                                 ChkRTree3 ( Root3^.Right3 );
                               end;
                  end;
     end;
end;


Procedure LoadTree3 ( Var Root3 : Pointer3 );
begin
  If Root3 = NIL then
     begin
       New ( Root3 );
       Root3^.Chave3   := EENo;
       Root3^.RelAddr3 := EENumber;
       Root3^.Left3    := NIL;
       Root3^.Right3   := NIL;
       Root3^.Weight3  := 2;
     end
     else If EENo <> Root3^.Chave3 then
             begin
               If EENo < Root3^.Chave3 then LoadTree3 ( Root3^.Left3  )
                                       else LoadTree3 ( Root3^.Right3 );
               Root3^.Weight3 := WtTree3 ( Root3^.Left3  ) +
                                 WtTree3 ( Root3^.Right3 );
               ChkRTree3 ( Root3 );
             end;
end;


Procedure SearchTree3 ( Var Root3 : Pointer3 );
begin
  If Root3 = NIL then RC := 'N'
     else If EENo < Root3^.Chave3
             then SearchTree3 ( Root3^.Left3 )
             else If EENo > Root3^.Chave3
                     then SearchTree3 ( Root3^.Right3 )
                     else begin
                            RC       := 'S';
                            EENumber := Root3^.RelAddr3;
                          end;
end;


Procedure SearchPos3 ( Var Root3 : Pointer3 );
begin
  If Root3 <> NIL then
     begin
       If (Root3^.Left3  <> NIL          ) and
          (EENo          <  Root3^.Chave3) then SearchPos3 ( Root3^.Left3 );
       If (RC   = 'N'          ) and
          (EENo < Root3^.Chave3) then
          begin
            RC         := 'S';
            EENumber := Root3^.RelAddr3;
            EENo     := Root3^.Chave3;
          end
          else If RC = 'N' then If Root3^.Right3 <> NIL
                                   then SearchPos3 ( Root3^.Right3 );
     end;
end;

Procedure Dispose3 ( Var Root3 : Pointer3 );
begin
  If Root3 <> NIL then
     begin
       If Root3^.Left3  <> NIL then Dispose3 ( Root3^.Left3  );
       If Root3^.Right3 <> NIL then Dispose3 ( Root3^.Right3 );
       Dispose(Root3);
     end;
end;


Procedure CarregaEntradas;
begin
  TC  := 'N';
  Seq := 0;
  Repeat
    Seek ( ENFile, EENumber );
    Read ( ENFile, ENMember );
    Ind := 0;
    Repeat
      Ind := Ind + 1;
    Until (ENMember.Referencia[Ind] = '') or (Ind = 20);
    If ENMember.Referencia[Ind] = '' then
       begin
         ENMember.Referencia[Ind] := PEOMember.Referencia;
         ENMember.Quantidade[Ind] := PEOMember.Quantidade;
         ENMember.PrecoU[Ind]     := PEOMember.PrecoU;
         TC                       := 'S';
         Seek  ( ENFile, EENumber );
         Write ( ENFile, ENMember );
       end
       else begin
              Seq := Seq + 1;
              Str(Seq,SeqX);
              If Seq < 10 then SeqX := '00' + SeqX
                 else If Seq < 100 then SeqX := '0' + SeqX;
              EENo := PEOMember.NumeroNF + SeqX;
              SearchTree3 ( Root3 );
              If RC = 'N' then
                 begin
                   EENumber := FileSize(ENFile );
                   LoadTree3 ( Root3 );
                   ENMember.Numero := EENo;
                   For Ind := 1 to 20 do
                   begin
                     ENMember.Referencia[Ind] := '';
                     ENMember.Quantidade[Ind] := 0;
                     ENMember.PrecoU[Ind]     := 0;
                   end;
                   Seek  ( ENFile, EENumber );
                   Write ( ENFile, ENMember );
                 end;
            end;
  Until TC = 'S';
end;


Procedure CarregaSaidas;
begin
  TC  := 'N';
  Seq := 0;
  Repeat
    Seek ( SNFile, EENumber );
    Read ( SNFile, SNMember );
    Ind := 0;
    Repeat
      Ind := Ind + 1;
    Until (SNMember.Referencia[Ind] = '') or (Ind = 20);
    If SNMember.Referencia[Ind] = '' then
       begin
         SNMember.Referencia[Ind] := PSOMember.Referencia;
         SNMember.Quantidade[Ind] := PSOMember.Quantidade;
         TC                       := 'S';
         Seek  ( SNFile, EENumber );
         Write ( SNFile, SNMember );
       end
       else begin
              Seq := Seq + 1;
              Str(Seq,SeqX);
              If Seq < 10 then SeqX := '00' + SeqX
                 else If Seq < 100 then Seqx := '0' + Seqx;
              EENo := PSOMember.NumeroRQ + SeqX;
              SearchTree3 ( Root3 );
              If RC = 'N' then
                 begin
                   EENumber := FileSize(SNFile );
                   LoadTree3 ( Root3 );
                   SNMember.Numero := EENo;
                   For Ind := 1 to 20 do
                   begin
                     SNMember.Referencia[Ind] := '';
                     SNMember.Quantidade[Ind] := 0;
                   end;
                   Seek  ( SNFile, EENumber );
                   Write ( SNFile, SNMember );
                 end;
            end;
  Until TC = 'S';
end;


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
                          PNMember.Fornecedor[Ind] := '';
                          PNMember.DataUC[Ind]     := '';
                          PNMember.PrecoUC[Ind]    := 0;
                        end;

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


       For Mes := 1 to 12 do
       begin
         Str(Mes,MM);
         If Mes < 10 then MM := '0' + MM;

         Assign (EOFile, (XDr + '\SLOGDATA\SLOGM0' + Cia + '\SLOGEX' + Ano + '.O' + MM));
         {$I-}
         Reset ( EOFile );
         {$I+}
         If IOResult <> 0 then
            begin
              Assign (EOFile, (XDr + '\SLOGDATA\SLOGM0' + Cia + '\SLOGEX' + Ano + '.M' + MM));
              {$I-}
              Reset ( EOFile );
              {$I+}
              If IOResult = 0 then
                 begin
                   If FileSize(EOFile) > 0 then
                      begin
                        Close ( EOFile );
                        Rename (EOFile, (XDr + '\SLOGDATA\SLOGM0' + Cia + '\SLOGEX' + Ano + '.O' + MM));
                        {$I-}
                        Reset  ( EOFile );
                        {$I+}

                        If IOResult = 0 then
                           begin
                             Assign (ENFile, (XDr + '\SLOGDATA\SLOGM0' + Cia + '\SLOGEX' + Ano + '.M' + MM));

                             ReWrite ( ENFile );
                             Reset   ( ENFile );
                             En := 0;

                             Root3 := NIL;
                             Release(HeapOrg);
                             I     := -1;
                             Repeat
                               I := I + 1;
                               {$I-}
                               Seek ( EOFile, I        );
                               Read ( EOFile, EOMember );
                               {$I+}
                               If IOResult = 0 then
                                  begin
                                    En                   := En + 1;
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
                                    ENMember.Tipo        := 'E';


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
                                      ENMember.Referencia[Ind] := '';
                                      ENMember.Quantidade[Ind] := 0;
                                      ENMember.PrecoU[Ind]     := 0;
                                    end;

                                    U := FileSize(ENFile);

                                    Seek  ( ENFile, U        );
                                    Write ( ENFile, ENMember );

                                    EENo     := ENMember.Numero;
                                    EENumber := U;
                                    LoadTree3 ( Root3 );

                                    GotoXY(1,Mes+1);
                                    Write('N.Fiscais (',MM,') in: ',(I + 1):4,' out: ',(U + 1):4);
                                  end;
                             Until (I + 1) = FileSize(EOFile);

                             Assign(PEOFile,(XDr+'\SLOGDATA\SLOGM0'+Cia+'\SLOGEM'+Ano+'.M'+MM));

                             {$I-}
                             Reset ( PEOFile );
                             {$I+}

                             If IOResult = 0 then
                                begin
                                  U   := 0;
                                  I   := -1;
                                  Repeat
                                    I := I + 1;
                                    {$I-}
                                    Seek ( PEOFile, I         );
                                    Read ( PEOFile, PEOMember );
                                    {$I+}
                                    If IOResult = 0 then
                                       begin
                                         EENo := PEOMember.NumeroNF;
                                         SearchTree3 ( Root3 );
                                         If RC = 'S' then
                                            begin
                                              CarregaEntradas;
                                              U := U + 1;
                                            end;
                                         GotoXY(41,Mes+1);
                                         Write('Movimento in: ',(I + 1):4,' out: ',U:4);
                                       end;
                                  Until (I+1) = FileSize(PEOFile);
                                  Close (PEOFile);
                                end;
                             Close ( ENFile );
                           end;
                      end;
                   Close ( EOFile );
                 end;
            end;
       end;

       For Mes := 1 to 12 do
       begin
         Str(Mes,MM);
         If Mes < 10 then MM := '0' + MM;

         Assign (SOFile, (XDr + '\SLOGDATA\SLOGM0' + Cia + '\SLOGSX' + Ano + '.O' + MM));
         {$I-}
         Reset ( SOFile );
         {$I+}
         If IOResult <> 0 then
            begin
              Assign (SOFile, (XDr + '\SLOGDATA\SLOGM0' + Cia + '\SLOGSX' + Ano + '.M' + MM));
              {$I-}
              Reset ( SOFile );
              {$I+}
              If IOResult = 0 then
                 begin
                   If FileSize(SOFile) > 0 then
                      begin
                        Close ( SOFile );
                        Rename (SOFile, (XDr + '\SLOGDATA\SLOGM0' + Cia + '\SLOGSX' + Ano + '.O' + MM));
                        {$I-}
                        Reset  ( SOFile );
                        {$I+}

                        If IOResult = 0 then
                           begin
                             Assign (SNFile, (XDr + '\SLOGDATA\SLOGM0' + Cia + '\SLOGSX' + Ano + '.M' + MM));

                             ReWrite ( SNFile );
                             Reset   ( SNFile );
                             En := 0;

                             Root3 := NIL;
                             Release(HeapOrg);

                             I     := -1;
                             Repeat
                               I := I + 1;
                               {$I-}
                               Seek ( SOFile, I        );
                               Read ( SOFile, SOMember );
                               {$I+}
                               If IOResult = 0 then
                                  begin
                                    En                   := En + 1;
                                    SNMember.Data        := SOMember.Data;
                                    SNMember.Status      := SOMember.Status;
                                    SNMember.Depto       := SOMember.Depto;
                                    SNMember.Numero      := SOMember.Numero;
                                    For Ind := 1 to 4 do
                                    begin
                                      SNMember.Obs[Ind] := SOMember.Obs[Ind];
                                    end;

                                    For Ind := 1 to 20 do
                                    begin
                                      SNMember.Referencia[Ind] := '';
                                      SNMember.Quantidade[Ind] := 0;
                                    end;

                                    U := FileSize(SNFile);

                                    Seek  ( SNFile, U        );
                                    Write ( SNFile, SNMember );

                                    EENo     := SOMember.Numero;
                                    EENumber := U;
                                    LoadTree3 ( Root3 );

                                    GotoXY(1,Mes+13);
                                    Write('Movimento (',MM,') in: ',(I + 1):4,' out: ',(U + 1):4);
                                  end;
                             Until (I + 1) = FileSize(SOFile);

                             Assign(PSOFile,(XDr+'\SLOGDATA\SLOGM0'+Cia+'\SLOGSM'+Ano+'.M'+MM));

                             {$I-}
                             Reset ( PSOFile );
                             {$I+}

                             If IOResult = 0 then
                                begin
                                  U   := 0;
                                  I   := -1;
                                  Seq := 0;
                                  Repeat
                                    I := I + 1;
                                    {$I-}
                                    Seek ( PSOFile, I         );
                                    Read ( PSOFile, PSOMember );
                                    {$I+}
                                    If IOResult = 0 then
                                       begin
                                         EENo := PSOMember.NumeroRQ;
                                         SearchTree3 ( Root3 );
                                         If RC = 'S' then
                                            begin
                                              CarregaSaidas;
                                              U := U + 1;
                                            end;
                                         GotoXY(41,Mes+13);
                                         Write('Movimento in: ',(I + 1):4,' out: ',U:4);
                                       end;
                                  Until (I+1) = FileSize(PSOFile);
                                  Close (PSOFile);
                                end;
                             Close ( SNFile );
                           end;
                      end;
                   Close ( SOFile );
                 end;
            end;
       end;
     end
     else Writeln('O drive,Cia,Ano n„o foram informados (Slog60FF C: 01 93)');

  Halt;
end.