PROGRAM BLOG59C2;

Uses Crt,Dos;

Type
  TabCmpy    = RECORD
                 Chave       : String[3];
                 Descricao   : String[40];
                 Status      : Char;
                 DataBkp     : String[8];
               END;


  ContasO    = RECORD
                 Banco        : String[3];
                 Agencia      : String[10];
                 Conta        : String[10];
                 ClassifC     : String[15];
                 Obs          : String[30];
                 AberturaC    : Array[1..12] of Double;
                 DebitoC      : Array[1..12] of Double;
                 CreditoC     : Array[1..12] of Double;
                 NTransacoes  : Array[1..12] of Integer;
                 Status       : Char;
               END;


  Contas     = RECORD
                 Banco        : String[3];
                 Agencia      : String[10];
                 Conta        : String[10];
                 ClassifC     : String[18];
                 Obs          : String[30];
                 AberturaC    : Array[1..12] of Double;
                 DebitoC      : Array[1..12] of Double;
                 CreditoC     : Array[1..12] of Double;
                 NTransacoes  : Array[1..12] of Integer;
                 Status       : Char;
               END;


  ContraPartO = RECORD
                 Banco       : String[3];
                 Agencia     : String[10];
                 Conta       : String[10];
                 Numero      : String[10];
                 Seq         : String[2];
                 Mes         : Integer;
                 ClassifC    : String[18];
		 Depto       : String[6];
                 Data        : String[6];
                 OrigData    : String[8];
                 Valor       : Real;
                 Status      : Char;
               END;


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

   E1Member       : ContasO;
   E1File         : FILE OF ContasO;

   E2Member       : Contas;
   E2File         : FILE OF Contas;

   M1Member       : ContraPartO;
   M1File         : FILE OF ContraPartO;

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
              GotoXY(1,1); Write('*** BLOG59C3 *** DouC');
              GotoXY(1,3); Write('*** Convertendo Cia ',CCMember.Chave);

              Assign (E1File, (XDir + '\BLOGCT' + XAno + '.OLD'));

              {$I-}
              Reset   ( E1File );
              {$I+}

              If IOResult <> 0 then
                 begin
                   Assign ( E1File, (XDir + '\BLOGCT' + XAno + '.DAT'));

                   {$I-}
                   Reset ( E1File );
                   {$I+}

                   If IOResult = 0 then
                      begin
                        If FileSize(E1File) > 0 then
                           begin
                             Close  ( E1File );
                             Rename ( E1File, (XDir + '\BLOGCT' + XAno + '.OLD'));
                             Reset  ( E1File );


                             Assign ( E2File, (XDir + '\BLOGCT' + XAno + '.DAT'));

                             ReWrite ( E2File );
                             Reset   ( E2File );


                             I := -1;
                             Repeat
                               I := I + 1;
                               Seek  ( E1File, I        );
                               Read  ( E1File, E1Member );

                               GotoXY(1,5); Write('Convertendo Contas   Lidos: ',(I + 1):5);

                               E2Member.Status   := E1Member.Status;
                               E2Member.Banco    := E1Member.Banco;
                               E2Member.Agencia  := E1Member.Agencia;
                               E2Member.Conta    := E1Member.Conta;
                               E2Member.ClassifC := E1Member.ClassifC;
                               E2Member.Obs      := E1Member.Obs;

                               For L := 1 to 12 do
                               begin
                                 E2Member.AberturaC[L]   := E1Member.AberturaC[L];
                                 E2Member.DebitoC[L]     := E1Member.DebitoC[L];
                                 E2Member.CreditoC[L]    := E1Member.CreditoC[L];
                                 E2Member.NTransacoes[L] := E1Member.NTransacoes[L];
                               end;

                               Seek  ( E2File, I        );
                               Write ( E2File, E2Member );
                               GotoXY(45,5); Write('Gravados: ',(I + 1):5);
                             Until (I + 1) = FileSize(E1File);
                             Close ( E2File );

                             Close ( E1File );
                             Erase ( E1File );
                           end
                           else Close ( E1File );
                      end;
                 end
                 else Close ( E1File );


              GotoXY(1,07);
              Write('--------------------------------------------------------------------------------');
              GotoXY(52,08); Write('... Contra-P....');
              GotoXY(52,09); Write('Lidos   Gravados');
              GotoXY(1,10);
              Write('--------------------------------------------------------------------------------');

              For M := 1 to 12 do
              begin
                Str(M,XMes);
                If M < 10 then XMes := '0' + XMes;

                GotoXY(1,(M + 10)); Write('Convertendo mˆs ',XMes);



                Assign (M1File, (XDir + '\BLOGCP' + XAno + '.O' + XMes));

                {$I-}
                Reset ( M1File );
                {$I+}

                If IOResult <> 0 then
                   begin
                     Assign (M1File, (XDir + '\BLOGCP' + XAno + '.M' + XMes));

                     {$I-}
                     Reset ( M1File );
                     {$I+}

                     If IOResult = 0 then
                        begin
                          If FileSize(M1File) > 0 then
                             begin
                               Close ( M1File );

                               Rename ( M1File, (XDir + '\BLOGCP' + XAno + '.O' + XMes));
                               Reset  ( M1File );

                               Assign ( M2File, (XDir + '\BLOGCP' + XAno + '.M' + XMes));

                               ReWrite ( M2File );
                               Reset   ( M2File );

                               I := -1;
                               R := 0;
                               Repeat
                                 I := I + 1;
                                 Seek ( M1File, I        );
                                 Read ( M1File, M1Member );

                                 GotoXY(52,(M + 10)); Write((I + 1):5);

                                 M2Member.Banco       := M1Member.Banco;
                                 M2Member.Agencia     := M1Member.Agencia;
                                 M2Member.Conta       := M1Member.Conta;
                                 M2Member.Numero      := M1Member.Numero;
                                 M2Member.Seq         := M1Member.Seq;
                                 M2Member.Mes         := M1Member.Mes;
                                 M2Member.ClassifC    := M1Member.ClassifC;
                                 M2Member.DouC        := 'C';
                                 M2Member.Depto       := M1Member.Depto;
                                 M2Member.Data        := M1Member.Data;
                                 M2Member.OrigData    := M1Member.OrigData;
                                 M2Member.Valor       := M1Member.Valor;
                                 M2Member.Status      := M1Member.Status;

                                 R := FileSize(M2File);

                                 Seek  ( M2File, R        );
                                 Write ( M2File, M2Member );

                                 GotoXY(63,(M + 10)); Write((R + 1):5);
                               Until (I + 1) = FileSize(M1File);
                               Close ( M2File );

                               Close ( M1File );
                               Erase ( M1File );
                             end
                             else Close ( M1File );
                        end;
                   end
                   else Close ( M1File );
              end;

              GotoXY(1,24); Write('*** Tecle Enter');
              Repeat
                TC := ReadKey;
              Until TC = #13;
            Until (C + 1) = FileSize(CCFile);
            Close ( CCFile );
          end;
     end
     else Writeln('O drive e Ano n„o foram informados (Blog59C2 C: AA)');

  Halt;
end.