PROGRAM BLOGtest;

Uses Crt,Dos;

Type
  TabCmpy    = RECORD
                 Chave       : String[3];
                 Descricao   : String[40];
                 Status      : Char;
                 DataBkp     : String[8];
               END;



{  ContraPartO = RECORD
                 Banco       : String[3];
                 Agencia     : String[10];
                 Conta       : String[10];
                 Numero      : String[10];
                 Seq         : String[2];
                 Mes         : Integer;
                 ClassifC    : String[15];
		 Depto       : String[6];
                 Data        : String[6];
                 OrigData    : String[8];
                 Valor       : Real;
                 Status      : Char;
               END;
        }

  ContraPart = RECORD
                 Banco       : String[3];
                 Agencia     : String[10];
                 Conta       : String[10];
                 Numero      : String[10];
                 Seq         : String[2];
                 Mes         : Integer;
                 ClassifC    : String[18];
                 DouC        : Char;
		 Depto       : String[6];
                 Data        : String[6];
                 OrigData    : String[8];
                 Valor       : Real;
                 Status      : Char;
               END;


Var
   CCMember       : TabCmpy;
   CCFile         : FILE OF TabCmpy;

{   M1Member       : ContraPartO;
   M1File         : FILE OF ContraPartO;  }

   M2Member       : ContraPart;
   M2File         : FILE OF ContraPart;

   M,I,En,R,C,L  : Integer;
   TC            : Char;
   XDr,XAno,XMes : String[2];
   XDir          : String[20];

begin
  XDr  := '';
  XDr  := ParamStr(1);
  XAno := '';
  XAno := ParamStr(2);

  If (XDr  <> '') and
     (XAno <> '') then
     begin
       ClrScr;

       Assign (CCFile, (XDr + '\BLOGDATA\BLOGCMPY.DAT'));

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

              XDir := XDr + '\BLOGDATA\BLOGM' + CCMember.Chave;

              ClrScr;
              GotoXY(1,1); Write('*** BLOG59C2 ***');
              GotoXY(1,3); Write('*** Convertendo Cia ',CCMember.Chave);


                               Assign ( M2File, (XDir + '\BLOGCP' + XAno + '.M10'));

                               Reset   ( M2File );

                               I := -1;
                               R := 0;
                               Repeat
                                 I := I + 1;
                                 Seek ( M2File, I        );
                                 Read ( M2File, M2Member );

                                 GotoXY(10,08); Write(M2Member.Conta);
                                 GotoXY(10,09); Write(M2Member.Numero);
                                 GotoXY(10,10); Write(M2Member.Seq);
                                 GotoXY(10,11); Write(M2Member.ClassifC);
                                 GotoXY(10,12); Write(M2Member.Depto);
                                 GotoXY(10,13); Write(M2Member.OrigData);
                                 GotoXY(10,14); Write(M2Member.Status);
                                 TC := ReadKey;
                               Until TC = #27;
                               Close ( M2File );

            Until TC = #27;
            Close ( CCFile );
          end;
     end
     else Writeln('O drive e Ano n„o foram informados (Blog59C2 C: AA)');

  Halt;
end.