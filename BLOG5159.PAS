PROGRAM BLOG5159;

Uses Crt,Dos;

Type
  CompanyO   = RECORD
                 Chave       : String[2];
                 Descricao   : String[40];
                 Endereco    : String[40];
                 Cidade      : String[20];
                 Estado      : String[2];
                 Cep         : String[5];
                 DDD         : String[4];
                 Telefone    : String[8];
                 CpfCgc      : String[20];
                 IdInscr     : String[20];
                 Password    : String[8];
                 Status      : Char;
                 MesAtivo    : Integer;
                 AnoAtivo    : Integer;
                 NBancos     : Integer;
                 NAgencias   : Integer;
                 NContas     : Integer;
               END;

  Company    = RECORD
                 Chave       : String[3];
                 Descricao   : String[40];
                 Endereco    : String[40];
                 Cidade      : String[20];
                 Estado      : String[2];
                 Cep         : String[5];
                 DDD         : String[4];
                 Telefone    : String[8];
                 CpfCgc      : String[20];
                 IdInscr     : String[20];
                 Password    : String[8];
                 Status      : Char;
                 MesAtivo    : Integer;
                 AnoAtivo    : Integer;
                 NBancos     : Integer;
                 NAgencias   : Integer;
                 NContas     : Integer;
               END;



Var
   CCMember       : CompanyO;
   CCFile         : FILE OF CompanyO;
   CNMember       : Company;
   CNFile         : FILE OF Company;

   U,I,En,R    : Integer;
   XDr,
   Cia         : String[2];

begin
  XDr := '';
  XDr := ParamStr(1);

  If XDr <> '' then
     begin
       Cia := '';
       Cia := ParamStr(2);

       Assign (CCFile, (XDr + '\BLOGDATA\BLOGCMPY.OLD'));

       {$I-}
       Reset ( CCFile );
       {$I+}

       If IOResult <> 0 then
          begin
            Assign (CCFile, (XDr + '\BLOGDATA\BLOGCMPY.DAT'));

            Rename (CCFile, (XDr + '\BLOGDATA\BLOGCMPY.OLD'));

            {$I-}
            Reset ( CCFile );
            {$I+}

            Assign (CNFile, (XDr + '\BLOGDATA\BLOGCMPY.DAT'));

            If IOResult = 0 then
               begin
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
                        CNMember.Chave       := '0' + CCMember.Chave;
                        CNMember.Descricao   := CCMember.Descricao;
                        CNMember.Endereco    := CCMember.Endereco;
                        CNMember.Cidade      := CCMember.Cidade;
                        CNMember.Estado      := CCMember.Estado;
                        CNMember.Cep         := CCMember.Cep;
                        CNMember.DDD         := CCMember.DDD;
                        CNMember.Telefone    := CCMember.Telefone;
                        CNMember.CpfCgc      := CCMember.CpfCgc;
                        CNMember.IdInscr     := CCMember.IdInscr;
                        CNMember.Password    := CCMember.Password;
                        CNmember.Status      := CCMember.Status;
                        CNMember.MesAtivo    := CCMember.MesAtivo;
                        CNMember.AnoAtivo    := CCMember.AnoAtivo;
                        CNMember.NBancos     := CCMember.NBancos;
                        CNMember.NAgencias   := CCMember.NAgencias;
                        CNMember.NContas     := CCMember.NContas;

                        U := FileSize(CNFile);

                        Seek  ( CNFile, U        );
                        Write ( CNFile, CNMember );
                      end;
                 Until (I + 1) = FileSize(CCFile);
                 Close ( CNFile );
               end;

            Close ( CCFile );
          end
          else Close ( CCFile );
     end
     else Writeln('O drive n„o foi informado (Blog5159 C:)');

  Halt;
end.