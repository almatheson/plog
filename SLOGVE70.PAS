PROGRAM SLOGVE70;

Uses Crt,Dos;

Type
  OwnerO     = RECORD
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
                 BfnO        : Byte;
                 BtxO        : Byte;
                 TfnO        : Byte;
                 TtxO        : Byte;
                 SfnO        : Byte;
                 StxO        : Byte;
                 UtxO        : Byte;
               END;

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

  MasterO    = RECORD
                 Password    : String[8];
                 NEmpresas   : Integer;
                 Don         : Char;
                 Dof         : Char;
                 Con         : Char;
                 Cof         : Char;
                 Non         : Char;
                 Nof         : Char;
                 Qpa         : Char;
                 DataBkp     : String[8];
               END;

  Master     = RECORD
                 Password    : String[8];
                 NEmpresas   : Integer;
                 Don         : String[10];
                 Dof         : String[10];
                 Con         : String[10];
                 Cof         : String[10];
                 Non         : String[10];
                 Nof         : String[10];
                 Qpa         : String[10];
                 LJet        : Char;
                 TipoImpr    : String[15];
                 DataBkp     : String[8];
                 BfnO        : Byte;
                 BtxO        : Byte;
                 TfnO        : Byte;
                 TtxO        : Byte;
                 SfnO        : Byte;
                 StxO        : Byte;
                 UtxO        : Byte;
                 TfdO        : Byte;
               END;


Var
   O1Member       : OwnerO;
   O1File         : FILE OF OwnerO;
   O2Member       : Owner;
   O2File         : FILE OF Owner;
   A1Member       : MasterO;
   A1File         : FILE OF MasterO;
   A2Member       : Master;
   A2File         : FILE OF Master;

   M,I,E,R,C,L,A,Ii,Fn   : Integer;
   Dep,
   XDr,XAno,XAnoI,
   XAnoF,XMes            : String[2];
   XDir                  : String[20];
   Bfn1                  : Byte;
   Btx1                  : Byte;
   Tfn1                  : Byte;
   Ttx1                  : Byte;
   Sfn1                  : Byte;
   Stx1                  : Byte;
   Utx1                  : Byte;

begin
  XDr   := '';
  XDr   := ParamStr(1);
  If XDr <> '' then
     begin
       ClrScr;
       Assign (O1File, (XDr + '\SLOGDATA\PLXOWNER.OLD'));
       {$I-}
       Reset   ( O1File );
       {$I+}
       If IOResult <> 0 then
          begin
            Assign ( O1File, (XDr + '\SLOGDATA\PLXOWNER.DAT'));
            {$I-}
            Reset ( O1File );
            {$I+}
            If IOResult = 0 then
               begin
                 If FileSize(O1File) > 0 then
                    begin
                      Close  ( O1File );
                      Rename ( O1File, (XDr + '\SLOGDATA\PLXOWNER.OLD'));
                      Reset  ( O1File );
                      Assign ( O2File, (XDr + '\SLOGDATA\PLXOWNER.DAT'));
                      {$I-}
                      Reset  ( O2File );
                      {$I+}
                      If IOResult <> 0 then
                         begin
                           ReWrite ( O2File );
                           Reset   ( O2File );
                           Seek  ( O1File, 0        );
                           Read  ( O1File, O1Member );
                           O2Member.Marca       := O1Member.Marca;
                           O2Member.RSocial     := O1Member.RSocial;
                           O2Member.Endereco    := O1Member.Endereco;
                           O2Member.Cidade      := O1Member.Cidade;
                           O2Member.Estado      := O1Member.Estado;
                           O2Member.Cep         := O1Member.Cep;
                           O2Member.Telefone    := O1Member.Telefone;
                           O2Member.Cgc         := O1Member.Cgc;
                           O2Member.Inscricao   := O1Member.Inscricao;
                           O2Member.NBase       := O1Member.NBase;
                           O2Member.DataLicenca := O1Member.DataLicenca;
                           O2Member.Versao      := '7.012/94';
                           O2Member.Produto     := O1Member.Produto;
                           Bfn1                 := O1Member.BfnO;
                           Btx1                 := O1Member.BtxO;
                           Tfn1                 := O1Member.TfnO;
                           Ttx1                 := O1Member.TtxO;
                           Sfn1                 := O1Member.SfnO;
                           Stx1                 := O1Member.StxO;
                           Utx1                 := O1Member.UtxO;
                           Seek  ( O2File, 0        );
                           Write ( O2File, O2Member );
                           Close ( O2File );
                         end;
                      Close ( O1File );
                      Erase ( O1File );
                    end
                    else Close ( O1File );
               end;
          end
          else Close ( O1File );
       Assign (A1File, (XDr + '\SLOGDATA\SLOGMAST.OLD'));
       {$I-}
       Reset   ( A1File );
       {$I+}
       If IOResult <> 0 then
          begin
            Assign ( A1File, (XDr + '\SLOGDATA\SLOGMAST.DAT'));
            {$I-}
            Reset ( A1File );
            {$I+}
            If IOResult = 0 then
               begin
                 If FileSize(A1File) > 0 then
                    begin
                      Close  ( A1File );
                      Rename ( A1File, (XDr + '\SLOGDATA\SLOGMAST.OLD'));
                      Reset  ( A1File );
                      Assign ( A2File, (XDr + '\SLOGDATA\SLOGMAST.DAT'));
                      {$I-}
                      Reset  ( A2File );
                      {$I+}
                      If IOResult <> 0 then
                         begin
                           ReWrite ( A2File );
                           Reset   ( A2File );
                           Seek  ( A1File, 0        );
                           Read  ( A1File, A1Member );
                           A2Member.Password    := A1Member.Password;
                           A2Member.NEmpresas   := A1Member.NEmpresas;
                           A2Member.Don         := A1Member.Don;
                           A2Member.Dof         := A1Member.Dof;
                           A2Member.Con         := A1Member.Con;
                           A2Member.Cof         := A1Member.Cof;
                           A2Member.Non         := A1Member.Non;
                           A2Member.Nof         := A1Member.Nof;
                           A2Member.Qpa         := A1Member.Qpa;
                           A2Member.DataBkp     := A1Member.DataBkp;
                           A2Member.LJet        := 'N';
                           A2Member.TipoImpr    := 'EPSON';
                           A2Member.BfnO        := Bfn1;
                           A2Member.BtxO        := Btx1;
                           A2Member.TfnO        := Tfn1;
                           A2Member.TtxO        := Ttx1;
                           A2Member.SfnO        := Sfn1;
                           A2Member.StxO        := Stx1;
                           A2Member.UtxO        := Utx1;
                           A2Member.TfdO        := 7;
                           Seek  ( A2File, 0        );
                           Write ( A2File, A2Member );
                           Close ( A2File );
                         end;
                      Close ( A1File );
                      Erase ( A1File );
                    end
                    else Close ( A1File );
               end;
          end
          else Close ( A1File );
     end;
  Halt;
end.
