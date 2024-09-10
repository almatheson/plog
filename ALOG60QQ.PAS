PROGRAM ALOG60QQ;

Uses Crt,Dos;

Const
  Zeros        = '000000000000000000000000000000';
Type
  Str10        = String[10];
  AnyStr       = String[255];

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
                 HistoricoC  : String[3];
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
                 Balancete   : Array[1..5] of Char;
                 Balanco     : Array[1..5] of Char;
                 Sintetica   : String[18];
               END;
Var
   CCMember       : TabCmpy;
   CCFile         : FILE OF TabCmpy;

   C1Member       : GuiaO;
   C1File         : FILE OF GuiaO;
   C2Member       : Guia;
   C2File         : FILE OF Guia;

   M,I,En,R,C,L  : Integer;
   XDr           : String[2];
   XDir          : String[20];

{$I ConstStr.rot }

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

                                    C2Member.Conta       := ConstStr(' ',18);
                                    C2Member.OrigConta   := ConstStr(' ',18);
                                    C2Member.Descricao   := ConstStr(' ',40);
                                    C2Member.IndiceC     := ConstStr(' ',2);
                                    C2Member.CPartidaX   := ConstStr(' ',18);
                                    C2Member.CPartidaC   := ConstStr(' ',18);
                                    C2Member.HistoricoC  := ConstStr(' ',3);
                                    C2Member.Sintetica   := ConstStr(' ',18);

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
                                    C2Member.HistoricoC  := C1Member.HistoricoC;
                                    C2Member.Diario      := C1Member.Diario;
                                    C2Member.Balancete[1] := C1Member.Balancete;
                                    C2Member.Balancete[2] := 'N';
                                    C2Member.Balancete[3] := 'N';
                                    C2Member.Balancete[4] := 'N';
                                    C2Member.Balancete[5] := 'N';
                                    C2Member.Balanco[1]   := C1Member.Balanco;
                                    C2Member.Balanco[2]   := 'N';
                                    C2Member.Balanco[3]   := 'N';
                                    C2Member.Balanco[4]   := 'N';
                                    C2Member.Balanco[5]   := 'N';
                                    C2Member.Sintetica   := C1Member.Sintetica;

                                    Seek  ( C2File, I        );
                                    Write ( C2File, C2Member );
                                  Until (I + 1) = FileSize(C1File);
                                  Close ( C2File );
                                end;
                             Close ( C1File );
                           end
                           else Close ( C1File );
                      end;
                 end
                 else Close ( C1File );
            Until (C + 1) = FileSize(CCFile);
            Close ( CCFile );
          end;
     end
     else Writeln('O drive n„o foi informado (Alog60QQ C:)');
  Halt;
end.
