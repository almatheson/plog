PROGRAM SLOG60NF;

Uses Crt,Dos;

Type

  EntradaO   = RECORD
                 Data        : String[6];
                 OrigData    : String[8];
                 Status      : Char;
                 Especie     : String[5];
                 Serie       : String[3];
                 Numero      : String[8];
                 DataNF      : String[8];
                 CGC         : String[16];
                 Estado      : String[2];
                 Nome        : String[20];
                 ValorCont   : Real;
                 CodFiscal   : String[4];
                 Codigo1     : Char;
                 ICMBaseC    : Double;
                 ICMAliquota : Double;
                 ICMImposto  : Double;
                 Codigo2     : Char;
                 IPIBaseC    : Double;
                 IPIImposto  : Double;
                 Codigo3     : Char;
                 IPIBaseC3   : Double;
                 SubTrib     : Double;
                 Obs         : String[15];
                 Depto       : String[6];
                 ClassContab : Array[1..5] of String[18];
                 DebCred     : Array[1..5] of Char;
                 ValorContab : Array[1..5] of Double;
                 Historicos  : Array[1..3] of String[60];
               END;


  Entrada    = RECORD
                 Data        : String[6];
                 OrigData    : String[8];
                 Status      : Char;
                 Especie     : String[5];
                 Serie       : String[3];
                 Numero      : String[8];
                 DataNF      : String[8];
                 CGC         : String[16];
                 Estado      : String[2];
                 Nome        : String[20];
                 ValorCont   : Real;
                 CodFiscal   : String[4];
                 Codigo1     : Char;
                 ICMBaseC    : Double;
                 ICMAliquota : Double;
                 ICMImposto  : Double;
                 Codigo2     : Char;
                 IPIBaseC    : Double;
                 IPIImposto  : Double;
                 Codigo3     : Char;
                 IPIBaseC3   : Double;
                 SubTrib     : Double;
                 Obs         : String[15];
                 Depto       : String[6];
                 ClassContab : Array[1..5] of String[18];
                 DebCred     : Array[1..5] of Char;
                 ValorContab : Array[1..5] of Double;
                 Historicos  : Array[1..3] of String[60];
                 Tipo        : Char;
               END;


Var
   POMember       : EntradaO;
   POFile         : FILE OF EntradaO;
   PNMember       : Entrada;
   PNFile         : FILE OF Entrada;

   Ind,E,Mes,
   U,I,En,R,D,M : Integer;
   XDr,
   Cia,Ano,MM   : String[2];

begin
  XDr := '';
  XDr := ParamStr(1);
  Cia := '';
  Cia := ParamStr(2);
  Ano := '';
  Ano := ParamStr(3);

  If (XDr <> '') and
     (Cia <> '') and
     (Ano <> '') then
     begin
       ClrScr;
       For Mes := 1 to 12 do
       begin
         Str(Mes,MM);
         If Mes < 10 then MM := '0' + MM;

         Assign (POFile, (XDr + '\SLOGDATA\SLOGM0' + Cia + '\SLOGEX' + Ano + '.O' + MM));
         {$I-}
         Reset ( POFile );
         {$I+}
         If IOResult <> 0 then
            begin
              Assign (POFile, (XDr + '\SLOGDATA\SLOGM0' + Cia + '\SLOGEX' + Ano + '.M' + MM));
              {$I-}
              Reset ( POFile );
              {$I+}
              If IOResult = 0 then
                 begin
                   Close ( POFile );
                   Rename (POFile, (XDr + '\SLOGDATA\SLOGM0' + Cia + '\SLOGEX' + Ano + '.O' + MM));
                   {$I-}
                   Reset  ( POFile );
                   {$I+}

                   If IOResult = 0 then
                      begin
                        Assign (PNFile, (XDr + '\SLOGDATA\SLOGM0' + Cia + '\SLOGEX' + Ano + '.M' + MM));

                        ReWrite ( PNFile );
                        Reset   ( PNFile );
                        En := 0;

                        I  := -1;
                        Repeat
                          I := I + 1;
                          {$I-}
                          Seek ( POFile, I        );
                          Read ( POFile, POMember );
                          {$I+}
                          If IOResult = 0 then
                             begin
                               En                   := En + 1;
                               PNMember.Data        := POMember.Data;
                               PNMember.OrigData    := POMember.OrigData;
                               PNMember.Status      := POMember.Status;
                               PNMember.Especie     := POMember.Especie;
                               PNMember.Serie       := POMember.Serie;
                               PNMember.Numero      := POMember.Numero;
                               PNMember.DataNF      := POMember.DataNF;
                               PNMember.CGC         := POMember.CGC;
                               PNMember.Estado      := POMember.Estado;
                               PNMember.Nome        := POMember.Nome;
                               PNMember.ValorCont   := POMember.ValorCont;
                               PNMember.CodFiscal   := POMember.CodFiscal;
                               PNMember.Codigo1     := POMember.Codigo1;
                               PNMember.ICMBaseC    := POMember.ICMBaseC;
                               PNMember.ICMAliquota := POMember.ICMAliquota;
                               PNMember.ICMImposto  := POMember.ICMImposto;
                               PNMember.Codigo2     := POMember.Codigo2;
                               PNMember.IPIBaseC    := POMember.IPIBaseC;
                               PNMember.IPIImposto  := POMember.IPIImposto;
                               PNMember.Codigo3     := POMember.Codigo3;
                               PNMember.IPIBaseC3   := POMember.IPIBaseC3;
                               PNMember.SubTrib     := POMember.SubTrib;
                               PNMember.Obs         := POMember.Obs;
                               PNMember.Depto       := POMember.Depto;
                               PNMember.Tipo        := 'E';


                               For Ind := 1 to 5 do
                               begin
                                 PNMember.ClassContab[Ind] := POMember.ClassContab[Ind];
                                 PNMember.DebCred[Ind]     := POMember.DebCred[Ind];
                                 PNMember.ValorContab[Ind] := POMember.ValorContab[Ind];
                               end;

                               For Ind := 1 to 3
                               do PNMember.Historicos[Ind] := POMember.Historicos[Ind];

                               U := FileSize(PNFile);

                               Seek  ( PNFile, U        );
                               Write ( PNFile, PNMember );

                               GotoXY(1,1);
                               Write('Convertendo N.Fiscais, Lidos: ',(I + 1):4,' Convertidos: ',(U + 1):4);
                             end;
                        Until (I + 1) = FileSize(POFile);
                        Close ( PNFile );
                      end;
                   Close ( POFile );
                 end;
            end;
       end;
     end
     else Writeln('O drive,Cia,Ano n„o foram informados (Slog60NF C: 01 93)');

  Halt;
end.