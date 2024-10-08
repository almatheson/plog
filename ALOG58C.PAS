PROGRAM ALOG58C;

Uses Crt,Dos;

Type
  CompanyO   = RECORD
                 ChaveO       : String[2];
                 DescricaoO   : String[40];
                 EnderecoO    : String[40];
                 CidadeO      : String[20];
                 EstadoO      : String[2];
                 CepO         : String[5];
                 DDDO         : String[4];
                 TelefoneO    : String[8];
                 CpfCgcO      : String[20];
                 IdInscrO     : String[20];
                 PasswordO    : String[8];
                 StatusO      : Char;
                 MesAtivoO    : Integer;
                 AnoAtivoO    : Integer;
                 NContasO     : Integer;
                 NLotesO      : Integer;
                 NDeptosO     : Integer;
                 NLanctoMesO  : Array [1..12] of Integer;
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
                 MesAtivo    : Integer;
                 AnoAtivo    : Integer;
                 NContas     : Integer;
                 NLotes      : Integer;
                 NDeptos     : Integer;
                 NLanctoMes  : Array [1..12] of Integer;
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

       If Cia <> '' then
          begin
            Assign (CCFile, (XDr + '\ALOGDATA\ALOGCMPY.OLD'));

            {$I-}
            Reset ( CCFile );
            {$I+}

            If IOResult <> 0 then
               begin
                 Assign (CCFile, (XDr + '\ALOGDATA\ALOGCMPY.DAT'));

                 Rename (CCFile, (XDR + '\ALOGDATA\ALOGCMPY.OLD'));

                 {$I-}
                 Reset ( CCFile );
                 {$I+}

                 Assign (CNFile, (XDr + '\ALOGDATA\ALOGCMPY.DAT'));

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
                             CNMember.Chave       := '0' + CCMember.ChaveO;
                             CNMember.Descricao   := CCMember.DescricaoO;
                             CNMember.Endereco    := CCMember.EnderecoO;
                             CNMember.Cidade      := CCMember.CidadeO;
                             CNMember.Estado      := CCMember.EstadoO;
                             CNMember.Cep         := CCMember.CepO;
                             CNMember.DDD         := CCMember.DDDO;
                             CNMember.Telefone    := CCMember.TelefoneO;
                             CNMember.CpfCgc      := CCMember.CpfCgcO;
                             CNMember.IdInscr     := CCMember.IdInscrO;
                             CNMember.Password    := CCMember.PasswordO;
                             CNMember.MesAtivo    := CCMember.MesAtivoO;
                             CNMember.AnoAtivo    := CCMember.AnoAtivoO;
                             CNMember.NContas     := CCMember.NContasO;
                             CNMember.NLotes      := CCMember.NLotesO;
                             CNMember.NDeptos     := CCMember.NDeptosO;

                             For R := 1 to 12 do CNMember.NLanctoMes[R] := CCMember.NLanctoMesO[R];

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
          else Writeln('A companhia n�o foi informada (Alog58C C: 01)');
     end
     else Writeln('O drive n�o foi informado (Alog58C C: 01)');

  Halt;
end.