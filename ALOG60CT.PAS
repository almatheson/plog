PROGRAM ALOG60CT;

Uses Crt,Dos;

Const
  Zeros        = '000000000000000000000000000000';
Type
  Str10        = String[10];

  TabCmpy    = RECORD
                 Chave       : String[3];
                 Descricao   : String[40];
                 Status      : Char;
                 DataBkp     : String[8];
               END;

  GuiaO      = RECORD
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
                 HistoricoC  : String[3];
                 Diario      : Char;
                 Balancete   : Char;
                 Balanco     : Char;
                 Sintetica   : String[18];
               END;

  HistoricoO = RECORD
                 Ocupado     : Char;
                 Descricao   : String[60];
               END;

  Historico  = RECORD
                 CodigoH     : String[3];
                 Descricao   : String[60];
                 Status      : Char;
               END;
Var
   CCMember       : TabCmpy;
   CCFile         : FILE OF TabCmpy;

   C1Member       : GuiaO;
   C1File         : FILE OF GuiaO;
   C2Member       : Guia;
   C2File         : FILE OF Guia;
   E1Member       : HistoricoO;
   E1File         : FILE OF HistoricoO;
   E2Member       : Historico;
   E2File         : FILE OF Historico;

   M,I,En,R,C,L  : Integer;
   XDr           : String[2];
   XDir          : String[20];


Function LeftAdjust (S : Str10) : Str10;
begin
  Repeat
    If S[1] = ' ' then Delete(S,1,1);
  Until S[1] <> ' ';
  LeftAdjust := S;
end;



Function FInteger(I,T : Integer) : Str10;
Var
  St1,St2  : String[10];
begin
  Str(I:5,St1);
  St1 := LeftAdjust(St1);
  St2 := Copy(Zeros,1,(T - Length(St1))) + St1;
  FInteger := St2;
end;

begin
  XDr  := '';
  XDr  := ParamStr(1);
  If XDr  <> '' then
     begin
       ClrScr;
       Assign (CCFile, (XDr + '\ALOGDATA\ALOGCMPY.DAT'));
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
              XDir := XDr + '\ALOGDATA\ALOGM' + CCMember.Chave;
              Writeln('*** Convertendo Cia ',CCMember.Chave);
              Assign (C1File, (XDir + '\ALOGCNTA.OLD'));
              {$I-}
              Reset   ( C1File );
              {$I+}
              If IOResult <> 0 then
                 begin
                   Assign ( C1File, (XDir + '\ALOGCNTA.DAT'));
                   {$I-}
                   Reset ( C1File );
                   {$I+}
                   If IOResult = 0 then
                      begin
                        If FileSize(C1File) > 0 then
                           begin
                             Close  ( C1File );
                             Rename ( C1File, (XDir + '\ALOGCNTA.OLD'));
                             Reset  ( C1File );
                             Assign ( C2File, (XDir + '\ALOGCNTA.DAT'));
                             {$I-}
                             Reset  ( C2File );
                             {$I+}
                             If IOResult <> 0 then
                                begin
                                  ReWrite ( C2File );
                                  Reset   ( C2File );
                                  I := -1;
                                  Repeat
                                    I := I + 1;
                                    Seek  ( C1File, I        );
                                    Read  ( C1File, C1Member );

                                    C2Member.Conta       := C1Member.Conta;
                                    C2Member.OrigConta   := C1Member.OrigConta;
                                    C2Member.Descricao   := C1Member.Descricao;
                                    C2Member.Status      := C1Member.Status;
                                    C2Member.Grupo       := C1Member.Grupo;
                                    C2Member.Grau        := C1Member.Grau;
                                    C2Member.Tipo        := C1Member.Tipo;
                                    C2Member.Aceita      := C1Member.Aceita;
                                    C2Member.Avisa       := C1Member.Avisa;
                                    C2Member.PedeDepto   := C1Member.PedeDepto;
                                    C2Member.GrupoE      := C1Member.GrupoE;
                                    C2Member.Correcao    := C1Member.Correcao;
                                    C2Member.IndiceC     := C1Member.IndiceC;
                                    C2Member.PeriodoC    := C1Member.PeriodoC;
                                    C2Member.CPartidaX   := C1Member.CPartidaX;
                                    C2Member.CPartidaC   := C1Member.CPartidaC;
                                    If C1Member.HistoricoC > 0
                                       then C2Member.HistoricoC := FInteger(C1Member.HistoricoC,3)
                                       else C2Member.HistoricoC := '';
                                    C2Member.Diario      := C1Member.Diario;
                                    C2Member.Balancete   := C1Member.Balancete;
                                    C2Member.Balanco     := C1Member.Balanco;
                                    C2Member.Sintetica   := C1Member.Sintetica;

                                    Seek  ( C2File, I        );
                                    Write ( C2File, C2Member );
                                  Until (I + 1) = FileSize(C1File);
                                  Close ( C2File );
                                end;
                             Close ( C1File );
                             Erase ( C1File );
                           end
                           else Close ( C1File );
                      end;
                 end
                 else Close ( C1File );
            Until (C + 1) = FileSize(CCFile);
            Close ( CCFile );

            Assign (E1File, (XDr + '\ALOGDATA\ALOGHSPD.OLD'));
            {$I-}
            Reset ( E1File );
            {$I+}
            If IOResult <> 0 then
               begin
                 Assign ( E1File, (XDr + '\ALOGDATA\ALOGHSPD.DAT'));
                 {$I-}
                 Reset ( E1File );
                 {$I+}
                 If IOResult = 0 then
                    begin
                      If FileSize(E1File) > 0 then
                         begin
                           Close  ( E1File );
                           Rename ( E1File, (XDr + '\ALOGDATA\ALOGHSPD.OLD'));
                           Reset  ( E1File );
                           Assign ( E2File, (XDr + '\ALOGDATA\ALOGHSPD.DAT'));
                           {$I-}
                           Reset  ( E2File );
                           {$I+}
                           If IOResult <> 0 then
                              begin
                                ReWrite ( E2File );
                                Reset   ( E2File );
                                I := 0;
                                Repeat
                                  I := I + 1;
                                  Seek  ( E1File, I        );
                                  Read  ( E1File, E1Member );
                                  E2Member.CodigoH   := FInteger(I,3);
                                  E2Member.Descricao := E1Member.Descricao;
                                  E2Member.Status    := 'A';
                                  Seek  ( E2File, FileSize(E2File));
                                  Write ( E2File, E2Member        );
                                Until (I + 1) = FileSize(E1File);
                                Close ( E2File );
                              end;
                           Close ( E1File );
                           Erase ( E1File );
                         end
                         else Close ( E1File );
                    end;
               end
               else Close ( E1File );
          end;
     end
     else Writeln('O drive e Ano n„o foram informados (Alog60CT C:)');
  Halt;
end.
