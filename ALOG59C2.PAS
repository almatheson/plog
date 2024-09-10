PROGRAM ALOG59C2;

Uses Crt,Dos;

Type
  GuiaO      = RECORD
                 Conta       : String[15];
                 OrigConta   : String[15];
                 Descricao   : String[40];
                 Status      : Char;
                 Grupo       : Char;
                 Grau        : Char;
                 Tipo        : Char;
                 Aceita      : Char;
                 Avisa       : Char;
                 PedeDepto   : Char;
                 GrupoE      : Char;
                 Correcao    : Char;
                 IndiceC     : String[2];
                 PeriodoC    : Char;
                 CPartidaX   : String[15];
                 CPartidaC   : String[15];
                 HistoricoC  : Integer;
                 Diario      : Char;
                 Balancete   : Char;
                 Balanco     : Char;
                 Sintetica   : String[15];
               END;

  Guia       = RECORD
                 Conta       : String[18];
                 OrigConta   : String[18];
                 Descricao   : String[40];
                 Status      : Char;
                 Grupo       : Char;
                 Grau        : Char;
                 Tipo        : Char;
                 Aceita      : Char;
                 Avisa       : Char;
                 PedeDepto   : Char;
                 GrupoE      : Char;
                 Correcao    : Char;
                 IndiceC     : String[2];
                 PeriodoC    : Char;
                 CPartidaX   : String[18];
                 CPartidaC   : String[18];
                 HistoricoC  : Integer;
                 Diario      : Char;
                 Balancete   : Char;
                 Balanco     : Char;
                 Sintetica   : String[18];
               END;


  ExpensesO   = RECORD
                  Conta      : String[15];
                  Depto      : String[6];
                  Corrigivel : Char;
                  IndiceX    : String[2];
                  ValorO     : Array[1..12] of Real;
                  Despesas   : Array[1..12] of Real;
                END;



  Expenses    = RECORD
                  Conta      : String[18];
                  Depto      : String[6];
                  Corrigivel : Char;
                  IndiceX    : String[2];
                  ValorO     : Array[1..12] of Real;
                  Despesas   : Array[1..12] of Real;
                END;

  LancamentoO = RECORD
                 Status       : Char;
                 OrigData     : String[8];
                 Conta        : String[15];
                 MesLancto    : Integer;
                 Tipo         : Char;
                 Valor        : Real;
                 Depto        : String[6];
                 Historico    : Array[1..3] of String[60];
                 Lote         : String[6];
                 SeqLote      : String[4];
               END;

  Lancamento = RECORD
                 Status       : Char;
                 OrigData     : String[8];
                 Conta        : String[18];
                 MesLancto    : Integer;
                 Tipo         : Char;
                 Valor        : Real;
                 Depto        : String[6];
                 Historico    : Array[1..3] of String[60];
                 Lote         : String[6];
                 SeqLote      : String[4];
               END;

Var
   CCMember       : GuiaO;
   CCFile         : FILE OF GuiaO;
   CNMember       : Guia;
   CNFile         : FILE OF Guia;
   ECMember       : ExpensesO;
   ECFile         : FILE OF ExpensesO;
   ENMember       : Expenses;
   ENFile         : FILE OF Expenses;
   MCMember       : LancamentoO;
   MCFile         : FILE OF LancamentoO;
   MNMember       : Lancamento;
   MNFile         : FILE OF Lancamento;

   U,I,En,R,D,M : Integer;
   XDr,
   Cia,Ano,XMes : String[2];

begin
  XDr := '';
  XDr := ParamStr(1);
  Ano := '';
  Ano := ParamStr(2);
  Cia := '';
  Cia := ParamStr(3);

  If (XDr <> '') and
     (Cia <> '') and
     (Ano <> '') then
     begin
       ClrScr;
       Assign (CCFile, (XDr + '\ALOGDATA\ALOGM0' + Cia + '\ALOGCNTA.OLD'));

       {$I-}
       Reset ( CCFile );
       {$I+}

       If IOResult <> 0 then
          begin
            Assign (CCFile, (XDr + '\ALOGDATA\ALOGM0' + Cia + '\ALOGCNTA.DAT'));
            {$I-}
            Rename (CCFile, (XDr + '\ALOGDATA\ALOGM0' + Cia + '\ALOGCNTA.OLD'));
            {$I+}

            If IOResult = 0 then
               begin
                 Reset ( CCFile );

                 If FileSize(CCFile) > 0 then
                    begin
                      Assign (CNFile, (XDr + '\ALOGDATA\ALOGM0' + Cia + '\ALOGCNTA.DAT'));

                      ReWrite ( CNFile );
                      Reset   ( CNFile );
                      En := 0;

                      I  := -1;
                      Repeat
                        I := I + 1;
                        {$I-}
                        Seek ( CCFile, I        );
                        Read ( CCFile, CCMember );
                        {$I+}
                        If IOResult = 0 then
                           begin
                             En                   := En + 1;
                             CNMember.Conta       := CCMember.Conta;
                             CNMember.OrigConta   := CCMember.OrigConta;
                             CNMember.Descricao   := CCMember.Descricao;
                             CNMember.Status      := CCMember.Status;
                             CNMember.Grupo       := CCMember.Grupo;
                             CNMember.Grau        := CCMember.Grau;
                             CNMember.Tipo        := CCMember.Tipo;
                             CNMember.Aceita      := CCMember.Aceita;
                             CNMember.Avisa       := CCMember.Avisa;
                             CNMember.PedeDepto   := CCMember.PedeDepto;
                             CNMember.GrupoE      := CCMember.GrupoE;
                             CNMember.Correcao    := CCMember.Correcao;
                             CNMember.IndiceC     := CCMember.IndiceC;
                             CNMember.PeriodoC    := CCMember.PeriodoC;
                             CNMember.CPartidaX   := CCMember.CPartidaX;
                             CNMember.CPartidaC   := CCMember.CPartidaC;
                             CNMember.HistoricoC  := CCMember.HistoricoC;
                             CNMember.Diario      := CCMember.Diario;
                             CNMember.Balancete   := CCMember.Balancete;
                             CNMember.Balanco     := CCMember.Balanco;
                             CNMember.Sintetica   := CCMember.Sintetica;

                             U := FileSize(CNFile);

                             Seek  ( CNFile, U        );
                             Write ( CNFile, CNMember );

                             GotoXY(1,1);
                             Write('Convertendo Contas  Lidos: ',(I + 1):4,' Convertidos: ',(U + 1):4);
                           end;
                      Until (I + 1) = FileSize(CCFile);
                      Close ( CNFile );
                    end;
               end;
          end;

       Close ( CCFile );



       Assign (ECFile, (XDr + '\ALOGDATA\ALOGM0' + Cia + '\ALOGXX' + Ano + '.OLD'));

       {$I-}
       Reset ( ECFile );
       {$I+}

       If IOResult <> 0 then
          begin
            Assign (ECFile, (XDr + '\ALOGDATA\ALOGM0' + Cia + '\ALOGXX' + Ano + '.DAT'));

            {$I-}
            Rename (ECFile, (XDr + '\ALOGDATA\ALOGM0' + Cia + '\ALOGXX' + Ano + '.OLD'));
            {$I+}

            If IOResult = 0 then
               begin
                 Reset ( ECFile );

                 If FileSize(ECFile) > 0 then
                    begin
                      Assign (ENFile, (XDr + '\ALOGDATA\ALOGM0' + Cia + '\ALOGXX' + Ano + '.DAT'));

                      ReWrite ( ENFile );
                      Reset   ( ENFile );
                      En := 0;

                      I  := -1;
                      Repeat
                        I := I + 1;
                        {$I-}
                        Seek ( ECFile, I        );
                        Read ( ECFile, ECMember );
                        {$I+}
                        If IOResult = 0 then
                           begin
                             En                   := En + 1;

                             ENMember.Conta       := ECMember.Conta;
                             ENMember.Depto       := ECMember.Depto;
                             ENMember.IndiceX     := ECMember.IndiceX;
                             For D := 1 to 12 do
                             begin
                               ENMember.ValorO[D]   := ECMember.ValorO[D];
                               ENMember.Despesas[D] := ECMember.Despesas[D];
                             end;

                             U := FileSize(ENFile);

                             Seek  ( ENFile, U        );
                             Write ( ENFile, ENMember );

                             GotoXY(1,5);
                             Write('Convertendo Desp.   Lidos: ',(I + 1):4,' Convertidos: ',(U + 1):4);
                           end;
                      Until (I + 1) = FileSize(ECFile);
                      Close ( ENFile );
                    end;
               end;
          end
          else Close ( ECFile );

       For M := 1 to 12 do
       begin
         Str(M,XMes);
         If M < 10 then XMes := '0' + XMes;

         Assign (MCFile, (XDr + '\ALOGDATA\ALOGM0' + Cia + '\ALOGMX' + Ano + '.O' + XMes));

         {$I-}
         Reset ( MCFile );
         {$I+}

         If IOResult <> 0 then
            begin
              Assign (MCFile, (XDr + '\ALOGDATA\ALOGM0' + Cia + '\ALOGMX' + Ano + '.M' + XMes));

              {$I-}
              Rename (MCFile, (XDr + '\ALOGDATA\ALOGM0' + Cia + '\ALOGMX' + Ano + '.O' + XMes));
              {$I+}

              If IOResult = 0 then
                 begin
                   Reset ( MCFile );

                   If FileSize(MCFile) > 0 then
                      begin
                        Assign (MNFile, (XDr + '\ALOGDATA\ALOGM0' + Cia + '\ALOGMX' + Ano + '.M' + XMes));

                        ReWrite ( MNFile );
                        Reset   ( MNFile );
                        En := 0;
                        I  := -1;
                        Repeat
                          I := I + 1;
                          {$I-}
                          Seek ( MCFile, I        );
                          Read ( MCFile, MCMember );
                          {$I+}
                          If IOResult = 0 then
                             begin
                               En := En + 1;

                               MNMember.Status       := MCMember.Status;
                               MNMember.OrigData     := MCMember.OrigData;
                               MNMember.Conta        := MCMember.Conta;
                               MNMember.MesLancto    := MCMember.MesLancto;
                               MNMember.Tipo         := MCMember.Tipo;
                               MNMember.Valor        := MCMember.Valor;
                               MNMember.Depto        := MCMember.Depto;
                               MNMember.Historico[1] := MCMember.Historico[1];
                               MNMember.Historico[2] := MCMember.Historico[2];
                               MNMember.Historico[3] := MCMember.Historico[3];
                               MNMember.Lote         := MCMember.Lote;
                               MNMember.SeqLote      := MCMember.SeqLote;

                               U := FileSize(MNFile);

                               Seek  ( MNFile, U        );
                               Write ( MNFile, MNMember );

                               GotoXY(1,(M + 10));
                               Write('Convertendo mˆs ',Xmes,' Lidos: ',(I + 1):4,' Convertidos: ',(U + 1):4);
                             end;
                        Until (I + 1) = FileSize(MCFile);
                        Close ( MNFile );
                      end;
                 end;
            end
            else Close ( MCFile );
       end;
     end
     else Writeln('O drive Ano e Cia n„o foram informados (Alog59C2 C: 92 01)');

  Halt;
end.