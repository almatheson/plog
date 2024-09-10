PROGRAM PLOGVE72;

Uses Crt,Dos;

Type
  Str80      = String[80];

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


  VerbasO    = RECORD
                 Status      : Char;
                 Conta       : String[3];
                 Descricao   : String[30];
                 Tipo        : Char;
                 Tempo       : Char;
                 Operacao    : Char;
                 Aceita      : Char;
                 Media       : Char;
                 Taxa        : Real;
                 TxConv      : Char;
                 Bases       : Array[1..10] of Char;
               END;


  Verbas     = RECORD
                 Status      : Char;
                 Conta       : String[3];
                 Descricao   : String[30];
                 Tipo        : Char;
                 Tempo       : Char;
                 Operacao    : Char;
                 Aceita      : Char;
                 Media       : Char;
                 Taxa        : Real;
                 TxConv      : Char;
                 Bases       : Array[1..10] of Char;
                 Resultado   : Array[1..2]  of String[3];
                 Conteudo    : Array[1..2]  of Char;
                 Operador    : Array[1..2]  of Char;
                 Operando    : Array[1..2]  of String[10];
                 SubAdic     : Array[1..2]  of Char;
               END;


Var
   OOMember       : Owner;
   OOFile         : FILE OF Owner;
   CCMember       : TabCmpy;
   CCFile         : FILE OF TabCmpy;
   V1Member       : VerbasO;
   V1File         : FILE OF VerbasO;
   V2Member       : Verbas;
   V2File         : FILE OF Verbas;

   M,I,E,R,C,L,A,Ii,Fn   : Integer;
   Dep,
   XAno,XAnoI,
   XAnoF,XMes            : String[2];
   XDr,
   XDir                  : String[20];


{$I TiraBrco.rot }


Procedure Converte;
begin
  Assign (V1File, (XDr + '\PLOGDATA\PLOGCNTA.OLD'));
  {$I-}
  Reset   ( V1File );
  {$I+}
  If IOResult <> 0 then
     begin
       Assign ( V1File, (XDr + '\PLOGDATA\PLOGCNTA.DAT'));
       {$I-}
       Reset ( V1File );
       {$I+}
       If IOResult = 0 then
          begin
            If FileSize(V1File) > 0 then
               begin
                 Close  ( V1File );
                 Rename ( V1File, (XDr + '\PLOGDATA\PLOGCNTA.OLD'));
                 Reset  ( V1File );
                 Assign ( V2File, (XDr + '\PLOGDATA\PLOGCNTA.DAT'));
                 {$I-}
                 Reset  ( V2File );
                 {$I+}
                 If IOResult <> 0 then
                    begin
                      ReWrite ( V2File );
                      Reset   ( V2File );
                      I := -1;
                      Repeat
                        I := I + 1;
                        Seek  ( V1File, I        );
                        Read  ( V1File, V1Member );
                        V2Member.Status    := V1Member.Status;
                        V2Member.Conta     := V1Member.Conta;
                        V2Member.Descricao := V1Member.Descricao;
                        V2Member.Tipo      := V1Member.Tipo;
                        V2Member.Tempo     := V1Member.Tempo;
                        V2Member.Operacao  := V1Member.Operacao;
                        V2Member.Aceita    := V1Member.Aceita;
                        V2Member.Media     := V1Member.Media;
                        V2Member.Taxa      := V1Member.Taxa;
                        V2Member.TxConv    := V1Member.TxConv;
                        For L := 1 to 10 do V2Member.Bases[L] := V1Member.Bases[L];
                        For L := 1 to 2 do
                        begin
                          V2Member.Resultado[L] := '';
                          V2Member.Conteudo[L]  := ' ';
                          V2Member.Operador[L]  := ' ';
                          V2Member.Operando[L]  := '';
                          V2Member.SubAdic[L]   := ' ';
                        end;
                        Seek  ( V2File, I        );
                        Write ( V2File, V2Member );
                      Until (I + 1) = FileSize(V1File);
                      Close ( V2File );
                    end;
                 Close ( V1File );
                 Erase ( V1File );
               end
               else Close ( V1File );
          end;
     end
     else Close ( V1File );
end;


begin
  XDr   := '';
  XDr   := ParamStr(1);
  If XDr   <> '' then
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
                 If OOMember.Versao = '7.112/94' then
                    begin
                      OOMember.Versao := '7.212/94';
                      Seek  ( OOFile, 0        );
                      Write ( OOFile, OOMember );
                      Close ( OOFile );
                      Converte;
                    end
                    else begin
                           Close ( OOFile );
                           Writeln('Os dados j  foram convertidos para a vers„o 7.2 de 12/94');
                         end;
               end;
          end;
     end
     else Writeln('O drive e Ano n„o foram informados (PlogVE71 C: AAi AAf)');
  Halt;
end.