PROGRAM PLOGve9T;

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
                 DataLicenca : String[8];
                 Versao      : String[8];
                 Produto     : String[6];
               END;

  TabelasO   = RECORD
                 AnoMesSeq    : String[5];
                 DependenteIR : Real;
                 SalMinimo    : Real;
                 TetoSalContr : Real;
                 Peri         : Array [1..5]  of Real;
                 Insa         : Array [1..5]  of Real;
                 VPass        : Array [1..50] of Real;
                 FaixaIapas   : Array [1..10] of Real;
                 TaxaIapas    : Array [1..10] of Real;
                 TaxaEIapas   : Array [1..10] of Real;
                 FaixaIR      : Array [1..10] of Real;
                 TaxaIR       : Array [1..10] of Real;
                 DeducaoIR    : Array [1..10] of Real;
                 FaixaSF      : Array [1..10] of Real;
                 ValorSF      : Array [1..10] of Real;
               END;

  Tabelas    = RECORD
                 AnoMesSeq    : String[5];
                 DependenteIR : Real;
                 SalMinimo    : Real;
                 TetoSalContr : Real;
                 Peri         : Array [1..5]   of Real;
                 Insa         : Array [1..5]   of Real;
                 VPass        : Array [1..100] of Real;
                 FaixaIapas   : Array [1..10]  of Real;
                 TaxaIapas    : Array [1..10]  of Real;
                 TaxaEIapas   : Array [1..10]  of Real;
                 FaixaIR      : Array [1..10]  of Real;
                 TaxaIR       : Array [1..10]  of Real;
                 DeducaoIR    : Array [1..10]  of Real;
                 FaixaSF      : Array [1..10]  of Real;
                 ValorSF      : Array [1..10]  of Real;
               END;


Var
   OOMember       : Owner;
   OOFile         : FILE OF Owner;
   T1Member       : TabelasO;
   T1File         : FILE OF TabelasO;
   T2Member       : Tabelas;
   T2File         : FILE OF Tabelas;

   M,I,En,R,C,L  : Integer;
   XDr           : String[40];

Procedure ConverteTab;
begin
       Assign (T1File, (XDr + '\PLOGDATA\PLOGTABL.OLD'));

       {$I-}
       Reset   ( T1File );
       {$I+}

       If IOResult <> 0 then
          begin
            Assign ( T1File, (XDr + '\PLOGDATA\PLOGTABL.DAT'));

            {$I-}
            Reset (T1File );
            {$I+}

            If IOResult = 0 then
               begin
                 Close  ( T1File );
                 Rename ( T1File, (XDr + '\PLOGDATA\PLOGTABL.OLD'));
                 Reset  ( T1File );


                 Assign ( T2File, (XDr + '\PLOGDATA\PLOGTABL.DAT'));

                 {$I-}
                 Reset  ( T2File );
                 {$I+}

                 If IOResult <> 0 then
                    begin
                      ReWrite ( T2File );
                      Reset   ( T2File );

                      ClrScr;
                      Writeln('*** Convertendo Tabelas (72 tarifas)');

                      I := -1;
                      Repeat
                        I := I + 1;
                        Seek  ( T1File, I        );
                        Read  ( T1File, T1Member );

                        T2Member.AnoMesSeq       := T1Member.AnoMesSeq;
                        T2Member.DependenteIR := T1Member.DependenteIR;
                        T2Member.SalMinimo    := T1Member.SalMinimo;
                        T2Member.TetoSalContr := T1Member.TetoSalContr;

                        For L := 1 to 5 do
                        begin
                          T2Member.Peri[L] := T1Member.Peri[L];
                          T2Member.Insa[L] := T1Member.Insa[L];
                        end;

                        For L := 1 to 10 do
                        begin
                          T2Member.FaixaIapas[L] := T1Member.FaixaIapas[L];
                          T2Member.TaxaIapas[L]  := T1Member.TaxaIapas[L];
                          T2Member.TaxaEIapas[L] := T1Member.TaxaEIapas[L];
                          T2Member.FaixaIR[L]    := T1Member.FaixaIR[L];
                          T2Member.TaxaIR[L]     := T1Member.TaxaIR[L];
                          T2Member.DeducaoIR[L]  := T1Member.DeducaoIR[L];
                          T2Member.FaixaSF[L]    := T1Member.FaixaSF[L];
                          T2Member.ValorSF[L]    := T1Member.ValorSF[L];
                        end;

                        For L := 1 to 100 do T2Member.VPass[L] := 0;
                        For L := 1 to 50  do T2Member.VPass[L] := T1Member.VPass[L];

                        Seek  ( T2File, I        );
                        Write ( T2File, T2Member );
                      Until (I + 1) = FileSize(T1File);
                      Close ( T2File );
                    end;

                 Close ( T1File );
                 Erase ( T1File );
               end;
          end
          else Close ( T1File );
end;

begin
  XDr  := '';
  XDr  := ParamStr(1);

  If XDr  <> '' then
     begin
       Assign ( OOFile, (XDr + '\PLOGDATA\PLXOWNER.DAT'));
       {$I-}
       Reset ( OOFile );
       {$I+}
       If IOResult = 0 then
          begin
            If FileSize(OOFile) > 0 then
               begin
                 Seek  ( OOFile, 0        );
                 Read  ( OOFile, OOMember );
                 If OOMember.Versao = '9.001/96' then
                    begin
                      OOMember.Versao := '9.103/96';
                      Seek  ( OOFile, 0        );
                      Write ( OOFile, OOMember );
                      Close ( OOFile );
                      ConverteTab;
                    end
                    else begin
                           Close ( OOFile );
                           Writeln('Os dados n„o est„o na vers„o 9.0 de 01/96');
                         end;
               end;
          end;
     end
     else Writeln('O drive n„o foi informado (PlogVE9T C:)');
  Halt;
end.