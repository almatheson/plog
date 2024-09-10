PROGRAM BLOG59RD;

Uses Crt,Dos;

Type
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

  TabCmpy    = RECORD
                 Chave       : String[3];
                 Descricao   : String[40];
                 Status      : Char;
                 DataBkp     : String[8];
               END;

  Master     = RECORD
                 Password    : String[8];
                 NEmpresas   : Integer;
                 NTipos      : Integer;
                 Don         : Char;
                 Dof         : Char;
                 Con         : Char;
                 Cof         : Char;
                 Non         : Char;
                 Nof         : Char;
                 Qpa         : Char;
               END;

  MasterN    = RECORD
                 Password    : String[8];
                 NEmpresas   : Integer;
                 NTipos      : Integer;
                 Don         : Char;
                 Dof         : Char;
                 Con         : Char;
                 Cof         : Char;
                 Non         : Char;
                 Nof         : Char;
                 Qpa         : Char;
                 DataBkp     : String[8];
               END;


Var
   CCMember       : Company;
   CCFile         : FILE OF Company;

   CTMember       : TabCmpy;
   CTFile         : FILE OF TabCmpy;

   CMFile         : FILE OF Company;

   MMMember       : Master;
   MMFile         : FILE OF Master;

   MNMember       : MasterN;
   MNFile         : FILE OF MasterN;

   U,I,En,R    : Integer;
   XDr         : String[2];
   XDir        : String[20];

begin
  XDr := '';
  XDr := ParamStr(1);

  If XDr <> '' then
     begin
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

	    Assign (CTFile, (XDr + '\BLOGDATA\BLOGCMPY.DAT'));

            If IOResult = 0 then
               begin
                 {$I-}
                 Reset   ( CTFile );
                 {$I+}

                 If IOResult = 0 then
                    begin
                      Close ( CTFile );
                      Erase ( CTFile );
                    end;

                 ReWrite ( CTFile );
                 Reset   ( CTFile );

                 If FileSize(CCFile) > 0 then
                    begin
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
                             En                 := En + 1;
                             CTMember.Chave     := CCMember.Chave;
                             CTMember.Descricao := CCMember.Descricao;
                             CTMember.Status    := 'I';
                             CTMember.DataBkp   := '';

                             U := FileSize(CTFile);

                             Seek  ( CTFile, U        );
                             Write ( CTFile, CTMember );

			     XDir := XDr + '\BLOGDATA\BLOGM' + CCMember.Chave;

                             {$I-}
                             MkDir ( XDir );
                             {$I+}

                             If IOResult >= 0 then
                                begin
				  Assign (CMFile, (XDir + '\BLOGCMST.DAT'));

                                  {$I-}
                                  Reset   ( CMFile );
                                  {$I+}

                                  If IOResult = 0 then
                                     begin
                                       Close ( CMFile );
                                       Erase ( CMFile );
                                     end;

                                  ReWrite ( CMFile );
                                  Reset   ( CMFile );

                                  Seek  ( CMFile, 0        );
                                  Write ( CMFile, CCMember );

                                  Close ( CMFile );
                                end;
                           end;
                      Until (I + 1) = FileSize(CCFile);
                    end;

                 Close ( CTFile );
               end;
          end;

       Close ( CCFile );



       Assign (MMFile, (XDr + '\BLOGDATA\BLOGMAST.OLD'));

       {$I-}
       Reset ( MMFile );
       {$I+}

       If IOResult <> 0 then
          begin
	    Assign (MMFile, (XDr + '\BLOGDATA\BLOGMAST.DAT'));

	    Rename (MMFile, (XDr + '\BLOGDATA\BLOGMAST.OLD'));

            {$I-}
            Reset ( MMFile );
            {$I+}

	    Assign (MNFile, (XDr + '\BLOGDATA\BLOGMAST.DAT'));

            If IOResult = 0 then
               begin
                 {$I-}
                 Reset   ( MNFile );
                 {$I+}

                 If IOResult = 0 then
                    begin
                      Close ( MNFile );
                      Erase ( MNFile );
                    end;

                 ReWrite ( MNFile );
                 Reset   ( MNFile );

                 {$I-}
                 Seek ( MMFile, 0        );
                 Read ( MMFile, MMMember );
                 {$I+}

                 If IOResult = 0 then
                    begin
                      MNMember.Password   := MMMember.Password;
                      MNMember.NEmpresas  := MMMember.NEmpresas;
		      MNMember.NTipos     := MMMember.NTipos;
                      MNMember.Don        := MMMember.Don;
                      MNMember.Dof        := MMMember.Dof;
                      MNMember.Con        := MMMember.Con;
                      MNMember.Cof        := MMMember.Cof;
                      MNMember.Non        := MMMember.Non;
                      MNMember.Nof        := MMMember.Nof;
                      MNMember.Qpa        := MMMember.Qpa;
                      MNMember.DataBkp    := '';

                      Seek  ( MNFile, 0        );
                      Write ( MNFile, MNMember );
                    end;

                 Close ( MNFile );
               end;
          end;

       Close ( MMFile );
     end
     else Writeln('O drive n„o foi informado (Blog59RD C:)');

  Halt;
end.