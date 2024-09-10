PROGRAM ALOG59CN;

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
                 IndiceC     : Integer;
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


  ExpensesO   = RECORD
                  Conta      : String[15];
                  Depto      : String[6];
                  Corrigivel : Char;
                  IndiceX    : Integer;
                  ValorO     : Array[1..12] of Real;
                  Despesas   : Array[1..12] of Real;
                END;



  Expenses    = RECORD
                  Conta      : String[15];
                  Depto      : String[6];
                  Corrigivel : Char;
                  IndiceX    : String[2];
                  ValorO     : Array[1..12] of Real;
                  Despesas   : Array[1..12] of Real;
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

   U,I,En,R,D  : Integer;
   XDr,
   Cia,Ano     : String[2];

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
                      {$I-}
                      Reset   ( CNFile );
                      {$I+}
                      If IOResult = 0 then
                         begin
                           Close ( CNFile );
                           Erase ( CNFile );
                         end;

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
                             CNMember.IndiceC     := '';
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

                      If IOResult = 0 then
                         begin
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
                             Seek ( ECFile, I        );
                             Read ( ECFile, ECMember );
                             {$I+}
                             If IOResult = 0 then
                                begin
                                  En                   := En + 1;

                                  ENMember.Conta       := ECMember.Conta;
                                  ENMember.Depto       := ECMember.Depto;
                                  ENMember.IndiceX     := '';
                                  For D := 1 to 12 do
                                  begin
                                    ENMember.ValorO[D]   := ECMember.ValorO[D];
                                    ENMember.Despesas[D] := ECMember.Despesas[D];
                                  end;

                                  U := FileSize(ENFile);

                                  Seek  ( ENFile, U        );
                                  Write ( ENFile, ENMember );
                                end;
                           Until (I + 1) = FileSize(ECFile);
                           Close ( ENFile );
                         end;
                    end;
               end;
          end;

       Close ( ECFile );
     end
     else Writeln('O drive e Cia n„o foram informados (Alog59CN C: 92 01)');

  Halt;
end.