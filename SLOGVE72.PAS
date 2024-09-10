PROGRAM SLOGVE72;

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
                 NoSerie     : String[8];
                 Versao      : String[8];
                 Produto     : String[6];
               END;

  EntradasO  = RECORD
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
                 Referencia  : Array[1..20] of String[15];
                 Quantidade  : Array[1..20] of Real;
                 PrecoU      : Array[1..20] of Real;
                 Xlog        : Char;
               END;

  Entradas   = RECORD
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
                 Referencia  : Array[1..20] of String[15];
                 Quantidade  : Array[1..20] of Real;
                 PrecoU      : Array[1..20] of Real;
                 Xlog        : Char;
                 Datavenc    : String[8];
               END;

  TabCmpy    = RECORD
                 Chave       : String[3];
                 Descricao   : String[40];
                 Status      : Char;
                 DataBkp     : String[8];
               END;


Var
   OOMember       : Owner;
   OOFile         : FILE OF Owner;
   EOMember       : EntradasO;
   EOFile         : FILE OF EntradasO;
   ENMember       : Entradas;
   ENFile         : FILE OF Entradas;
   CCMember       : TabCmpy;
   CCFile         : FILE OF TabCmpy;

   I,A,C,R,U,E,Ind,Ii,Fn : Integer;
   XDr,XAno,XAnoI,
   XAnoF                 : String[2];
   XDir                  : String[20];


Procedure ConverteNota;
Var
  Mi      : Integer;
  Mes     : String[2];
begin
  For Mi := 1 to 12 do
  begin
    Str(Mi,Mes);
    If Mi < 10 then Mes := '0' + Mes;
    Assign (EOFile, (XDir + '\SLOGEX' + XAno + '.O' + Mes));
    {$I-}
    Reset ( EOFile );
    {$I+}
    If IOResult <> 0 then
       begin
         Assign (EOFile, (XDir + '\SLOGEX' + XAno + '.M' + Mes));
         {$I-}
         Reset ( EOFile );
         {$I+}
         If IOResult = 0 then
            begin
              Close (EOFile );
              Rename (EOFile, (XDir + '\SLOGEX' + XAno + '.O' + Mes));
              {$I-}
              Reset  ( EOFile );
              {$I+}
              If IOResult = 0 then
                 begin
                   Assign (ENFile, (XDir + '\SLOGEX' + XAno + '.M' + Mes));
                   ReWrite ( ENFile );
                   Reset   ( ENFile );
                   I := -1;
                   Repeat
                     I := I + 1;
                     {$I-}
                     Seek ( EOFile, I        );
                     Read ( EOFile, EOMember );
                     {$I+}
                     If IOResult = 0 then
                        begin
                          ENMember.Data        := EOMember.Data;
                          ENMember.OrigData    := EOMember.OrigData;
                          ENMember.Status      := EOMember.Status;
                          ENMember.Especie     := EOMember.Especie;
                          ENMember.Serie       := EOMember.Serie;
                          ENMember.Numero      := EOMember.Numero;
                          ENMember.DataNF      := EOMember.DataNF;
                          ENMember.CGC         := EOMember.CGC;
                          ENMember.Estado      := EOMember.Estado;
                          ENMember.Nome        := EOMember.Nome;
                          ENMember.ValorCont   := EOMember.ValorCont;
                          ENMember.CodFiscal   := EOMember.CodFiscal;
                          ENMember.Codigo1     := EOMember.Codigo1;
                          ENMember.ICMBaseC    := EOMember.ICMBaseC;
                          ENMember.ICMAliquota := EOMember.ICMAliquota;
                          ENMember.ICMImposto  := EOMember.ICMImposto;
                          ENMember.Codigo2     := EOMember.Codigo2;
                          ENMember.IPIBaseC    := EOMember.IPIBaseC;
                          ENMember.IPIImposto  := EOMember.IPIImposto;
                          ENMember.Codigo3     := EOMember.Codigo3;
                          ENMember.IPIBaseC3   := EOMember.IPIBaseC3;
                          ENMember.SubTrib     := EOMember.SubTrib;
                          ENMember.Obs         := EOMember.Obs;
                          ENMember.Depto       := EOMember.Depto;
                          ENMember.Tipo        := EOMember.Tipo;
                          For Ind := 1 to 5 do
                          begin
                            ENMember.ClassContab[Ind] := EOMember.ClassContab[Ind];
                            ENMember.DebCred[Ind]     := EOMember.DebCred[Ind];
                            ENMember.ValorContab[Ind] := EOMember.ValorContab[Ind];
                          end;
                          For Ind := 1 to 3
                          do ENMember.Historicos[Ind] := EOMember.Historicos[Ind];
                          For Ind := 1 to 20 do
                          begin
                            ENMember.Referencia[Ind] := EOMember.Referencia[Ind];
                            ENMember.Quantidade[Ind] := EOMember.Quantidade[Ind];
                            ENMember.PrecoU[Ind]     := EOMember.PrecoU[Ind];
                          end;
                          ENMember.Xlog     := EOMember.Xlog;
                          ENMember.DataVenc := '';
                          U := FileSize(ENFile);
                          Seek  ( ENFile, U        );
                          Write ( ENFile, ENMember );
                        end;
                   Until (I + 1) = FileSize(EOFile);
                   Close ( ENFile );
                   Close ( EOFile );
                   Erase ( EOFile );
                 end
                 else Close ( EOFile );
            end;
       end
       else Close ( EOFile );
  end;
end;


begin
  XDr   := '';
  XDr   := ParamStr(1);
  XAnoI := '';
  XAnoI := ParamStr(2);
  XAnoF := '';
  XAnoF := ParamStr(3);

  If (XDr   <> '') and
     (XAnoI <> '') and
     (XAnoF <> '') then
     begin
       ClrScr;
       Assign ( OOFile, (XDr + '\SLOGDATA\PLXOWNER.DAT'));
       {$I-}
       Reset ( OOFile );
       {$I+}
       If IOResult = 0 then
          begin
            Seek  ( OOFile, 0        );
            Read  ( OOFile, OOMember );
            If OOMember.Versao = '7.102/95' then
               begin
                 OOMember.Versao := '7.204/95';
                 Seek  ( OOFile, 0        );
                 Write ( OOFile, OOMember );
                 Assign (CCFile, (XDr + '\SLOGDATA\SLOGCMPY.DAT'));
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
                        XDir := XDr + '\SLOGDATA\SLOGM' + CCMember.Chave;
                        Writeln('*** Convertendo Cia ',CCMember.Chave);
                        Val(XAnoI,Ii,E);
                        Val(XAnoF,Fn,E);
                        For A := Ii to Fn do
                        begin
                          Str(A,XAno);
                          If A < 10 then XAno := '0' + XAno;
                          ConverteNota;
                        end;
                      Until (C + 1) = FileSize(CCFile);
                      Close ( CCFile );
                    end;
               end;
            Close ( OOFile );
          end;
     end
     else Writeln('O drive,Cia,Ano n„o foram informados (SlogVE71 C: AnoI AnoF)');
  Halt;
end.
