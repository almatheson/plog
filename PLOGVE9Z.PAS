PROGRAM PLOGVE9Z;

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

  TabCmpy    = RECORD
                 Chave       : String[3];
                 Descricao   : String[40];
                 Status      : Char;
                 DataBkp     : String[8];
               END;

  HistPagO   = RECORD
                 Empregado    : String[8];
                 RendRais     : Array [1..12] of Real;
                 RendDirf     : Array [1..12] of Real;
                 Dependentes  : Array [1..12] of Real;
                 Pensao       : Array [1..12] of Real;
                 IRenda       : Array [1..12] of Real;
                 SalarioFaml  : Array [1..12] of Real;
                 ValorInss    : Array [1..12] of Real;
                 Ferias_Valor : Real;
                 Ferias_Dep   : Real;
                 Ferias_IR    : Real;
                 Ferias_Mes   : Integer;
                 Ad13_Valor   : Real;
                 Ad13_Mes     : Integer;
                 Pg13_Valor   : Real;
                 Pg13_ValorD  : Real;
                 Pg13_IR      : Real;
                 Pg13_Dep     : Real;
                 Pg13_Mes     : Integer;
                 ContrSind    : Real;
               END;

  HistPag    = RECORD
                 Empregado    : String[8];
                 RendRais     : Array [1..12] of Real;
                 RendDirf     : Array [1..12] of Real;
                 Dependentes  : Array [1..12] of Real;
                 Pensao       : Array [1..12] of Real;
                 IRenda       : Array [1..12] of Real;
                 SalarioFaml  : Array [1..12] of Real;
                 ValorInss    : Array [1..12] of Real;
                 Ferias_Valor : Real;
                 Ferias_Dep   : Real;
                 Ferias_IR    : Real;
                 Ferias_Mes   : Integer;
                 Ad13_Valor   : Real;
                 Ad13_Mes     : Integer;
                 Pg13_Valor   : Real;
                 Pg13_ValorD  : Real;
                 Pg13_IR      : Real;
                 Pg13_Inss    : Real;
                 Pg13_Dep     : Real;
                 Pg13_Mes     : Integer;
                 ContrSind    : Real;
               END;


Var
   OOMember       : Owner;
   OOFile         : FILE OF Owner;
   CCMember       : TabCmpy;
   CCFile         : FILE OF TabCmpy;
   E1Member       : HistPagO;
   E1File         : FILE OF HistPagO;
   E2Member       : HistPag;
   E2File         : FILE OF HistPag;


   M,I,E,R,C,L,A,Ii,Fn   : Integer;
   Dep,
   XAno,XAnoI,
   XAnoF,XMes            : String[2];
   XDr,XDir              : String[40];



Procedure Converte;
begin
  Assign (CCFile, (XDr + '\PLOGDATA\PLOGCMPY.DAT'));
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
         XDir := XDr + '\PLOGDATA\PLOGM' + CCMember.Chave;
         Writeln('*** Convertendo Cia ',CCMember.Chave);
         Val(XAnoI,Ii,E);
         Val(XAnoF,Fn,E);
         For A := Ii to Fn do
         begin
           Str(A,XAno);
           If A < 10 then XAno := '0' + XAno;
             Assign (E1File, (XDir + '\PLOGPX' + XAno + '.OLD'));
             {$I-}
             Reset   ( E1File );
             {$I+}
             If IOResult <> 0 then
                begin
                  Assign ( E1File, (XDir + '\PLOGPX' + XAno + '.DAT'));
                  {$I-}
                  Reset ( E1File );
                  {$I+}
                  If IOResult = 0 then
                     begin
                       If FileSize(E1File) > 0 then
                          begin
                            Close  ( E1File );
                            Rename ( E1File, (XDir + '\PLOGPX' + XAno + '.OLD'));
                            Reset  ( E1File );
                            Assign ( E2File, (XDir + '\PLOGPX' + XAno + '.DAT'));
                            {$I-}
                            Reset  ( E2File );
                            {$I+}
                            If IOResult <> 0 then
                               begin
                                 ReWrite ( E2File );
                                 Reset   ( E2File );
                                 I := -1;
                                 Repeat
                                   I := I + 1;
                                   Seek  ( E1File, I        );
                                   Read  ( E1File, E1Member );
                                   E2Member.Empregado   := E1Member.Empregado;
                                   For L := 1 to 12 do
                                   begin
                                     E2Member.RendRais[L]     := E1Member.RendRais[L];
                                     E2Member.RendDirf[L]     := E1Member.RendDirf[L];
                                     E2Member.Dependentes[L]  := E1Member.Dependentes[L];
                                     E2Member.Pensao[L]       := E1Member.Pensao[L];
                                     E2Member.IRenda[L]       := E1Member.IRenda[L];
                                     E2Member.SalarioFaml[L]  := E1Member.SalarioFaml[L];
                                     E2Member.ValorInss[L]    := E1Member.ValorInss[L];
                                   end;
                                   E2Member.Ferias_Valor := E1Member.Ferias_Valor;
                                   E2Member.Ferias_Dep   := E1Member.Ferias_Dep;
                                   E2Member.Ferias_IR    := E1Member.Ferias_IR;
                                   E2Member.Ferias_Mes   := E1Member.Ferias_Mes;
                                   E2Member.Ad13_Valor   := E1Member.Ad13_Valor;
                                   E2Member.Ad13_Mes     := E1Member.Ad13_Mes;
                                   E2Member.Pg13_Valor   := E1Member.Pg13_Valor;
                                   E2Member.Pg13_ValorD  := E1Member.Pg13_ValorD;
                                   E2Member.Pg13_IR      := E1Member.Pg13_IR;
                                   E2Member.Pg13_Inss    := 0;
                                   E2Member.Pg13_Dep     := E1Member.Pg13_Dep;
                                   E2Member.Pg13_Mes     := E1Member.Pg13_Mes;
                                   E2Member.ContrSind    := E1Member.ContrSind;
                                   Seek  ( E2File, I        );
                                   Write ( E2File, E2Member );
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
       Until (C + 1) = FileSize(CCFile);
       Close ( CCFile );
     end;
end;


begin
  XDr   := '';
  XDr   := ParamStr(1);
  XAnoI := '89';
  XAnoF := '96';

  If (XDr   <> '') and
     (XAnoI <> '') and
     (XAnoF <> '') then
     begin
       ClrScr;
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
                 If OOMember.Versao = '9.303/96' then
                    begin
                      OOMember.Versao := '9.403/96';
                      Seek  ( OOFile, 0        );
                      Write ( OOFile, OOMember );
                      Close ( OOFile );
                      Converte;
                    end
                    else begin
                           Close ( OOFile );
                           Writeln('Os dados n„o est„o na vers„o 9.3 de 03/96');
                         end;
               end;
          end;
     end
     else Writeln('O drive (Path), n„o foi informado (PlogVE9H C:\USR\FOLHA)');
  Halt;
end.