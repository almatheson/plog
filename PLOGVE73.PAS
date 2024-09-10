PROGRAM PLOGVE73;

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


  EmpresaO   = RECORD
                 Chave          : String[3];
                 Descricao      : String[40];
                 Endereco       : String[40];
                 Numero         : String[10];
                 Complemento    : String[15];
                 Cidade         : String[20];
                 Bairro         : String[20];
                 Municipio      : String[20];
                 Estado         : String[2];
                 Cep            : String[9];
                 DDD            : String[4];
                 Telefone       : String[8];
                 Cgc            : String[20];
                 Inscricao      : String[20];
                 Password       : String[8];
                 MesAtivo       : Integer;
                 AnoAtivo       : Integer;
                 Etapa          : Char;
                 NDepto         : Integer;
                 NBancos        : Integer;
                 NFunc          : Integer;
                 FaltaH         : Integer;
                 FaltaM         : Integer;
                 RepousoH       : Integer;
                 RepousoM       : Integer;
                 ContaF         : String[3];
                 ContaA         : String[3];
                 ContaS         : String[3];
                 CAGEGInscInps  : String[20];
                 CAGEGAtEco     : String[4];
                 RAISAtEco      : String[4];
                 RAISPropriet   : Integer;
                 RAISNatureza   : Char;
                 RAISFamiliares : Integer;
                 GRPSTipo       : Char;
                 GRPSIdent      : String[20];
                 GRPSSAT        : String[10];
                 GRPSXSAT       : Real;
                 GRPSFPAS       : String[5];
                 GRPSTER        : String[5];
                 GRPSXTER       : Real;
                 GRPS19         : String[5];
                 GRPS20         : String[5];
                 GRConta        : String[20];
                 GRUnidTrab     : String[10];
                 GRCSCodEstab   : String[20];
                 GRCSIAtiv      : String[8];
                 GRCSAtiv       : String[20];
                 GRCSCodAtiv    : String[5];
                 GRCSSCodAtiv   : String[10];
                 GRCSCodCBO     : String[5];
                 GRCSTipoEstab  : Char;
                 GRCSNoEstab    : Integer;
                 GRCSTipoRef    : Char;
                 GRCSCapSocial  : Real;
               END;

  Empresa    = RECORD
                 Chave          : String[3];
                 Descricao      : String[40];
                 Endereco       : String[40];
                 Numero         : String[10];
                 Complemento    : String[15];
                 Cidade         : String[20];
                 Bairro         : String[20];
                 Municipio      : String[20];
                 Estado         : String[2];
                 Cep            : String[9];
                 DDD            : String[4];
                 Telefone       : String[8];
                 Cgc            : String[20];
                 Inscricao      : String[20];
                 Password       : String[8];
                 MesAtivo       : Integer;
                 AnoAtivo       : Integer;
                 Etapa          : Char;
                 NDepto         : Integer;
                 NBancos        : Integer;
                 NFunc          : Integer;
                 FaltaH         : Integer;
                 FaltaM         : Integer;
                 RepousoH       : Integer;
                 RepousoM       : Integer;
                 ContaF         : String[3];
                 ContaA         : String[3];
                 ContaS         : String[3];
                 CAGEGInscInps  : String[20];
                 CAGEGAtEco     : String[5];
                 RAISAtEco      : String[5];
                 RAISPropriet   : Integer;
                 RAISNatureza   : String[2];
                 RAISDiaPag     : Integer;
                 GRPSTipo       : Char;
                 GRPSIdent      : String[20];
                 GRPSSAT        : String[10];
                 GRPSXSAT       : Real;
                 GRPSFPAS       : String[5];
                 GRPSTER        : String[5];
                 GRPSXTER       : Real;
                 GRPS19         : String[5];
                 GRPS20         : String[5];
                 GRConta        : String[20];
                 GRUnidTrab     : String[10];
                 GRCSCodEstab   : String[20];
                 GRCSIAtiv      : String[8];
                 GRCSAtiv       : String[20];
                 GRCSCodAtiv    : String[5];
                 GRCSSCodAtiv   : String[10];
                 GRCSCodCBO     : String[5];
                 GRCSTipoEstab  : Char;
                 GRCSNoEstab    : Integer;
                 GRCSTipoRef    : Char;
                 GRCSCapSocial  : Real;
               END;

  EmpregadoO = RECORD
                 Status      : Char;
                 Matricula   : String[8];
                 Nome        : String[40];
                 Endereco    : String[40];
                 Bairro      : String[20];
                 Cidade      : String[20];
                 Estado      : String[2];
                 Cep         : String[5];
                 CepCompl    : String[3];
                 Telefone    : String[15];
                 AANasc      : String[2];
                 MMNasc      : String[2];
                 DDNasc      : String[2];
                 Sexo        : Char;
                 ECiv        : Char;
                 Nacional    : String[2];
                 Natural     : String[2];
                 Naturalz    : Char;
                 DataChBr    : String[8];
                 Cpf         : String[12];
                 CtrabN      : String[6];
                 CtrabS      : String[3];
                 CtrabE      : String[2];
                 PisPasep    : String[11];
                 Identidade  : String[15];
                 CertReserv  : String[15];
                 TitEleitor  : String[15];
                 Depto       : String[10];
                 Cargo       : String[15];
                 CentroC     : Array[1..5] of String[6];
                 PerctC      : Array[1..5] of Real;
                 Sindicato   : String[2];
                 Grau        : Char;
                 AAAdm       : String[2];
                 MMAdm       : String[2];
                 DDAdm       : String[2];
                 TipoE       : Char;
                 CBO         : String[5];
                 NoMTrab     : String[15];
                 Opcao       : Char;
                 DataOpcao   : String[8];
                 Vinculo     : Char;
                 UFAnt       : String[2];
                 Entrada     : String[5];
                 Saida       : String[5];
                 IntRefeicao : String[15];
                 RepSemanal  : String[10];
                 Turno       : String[20];
                 AAResc      : String[2];
                 MMResc      : String[2];
                 DDResc      : String[2];
                 Causa       : Char;
                 Situacao    : Char;
                 Salario     : Real;
                 Tipo        : Char;
                 TipoP       : Char;
                 HNormais    : Integer;
                 MesesT      : Integer;
                 MesesF      : Integer;
                 PgConta     : Char;
                 BcoPG       : String[10];
                 ContaPg     : String[15];
                 BcoFgts     : String[10];
                 ContaFgts   : String[15];
                 PercAdiant  : Real;
                 Peric       : Array[1..5] of Char;
                 Insalub     : Array[1..5] of Char;
                 VTransporte : Char;
                 DepIR       : Integer;
                 DepSF       : Integer;
                 Pensao      : Char;
                 PensaoP     : Real;
                 Cartao      : String[4];
                 AAFer       : String[2];
                 MMFer       : String[2];
                 DDFer       : String[2];
                 PeriodoV    : Integer;
                 DiaI        : Integer;
                 MesI        : Integer;
                 DiaF        : Integer;
                 MesF        : Integer;
                 Passagens   : Array[1..6] of Integer;
                 Faixa       : Array[1..6] of Integer;
                 DiasVT      : Integer;
                 FaltasNJ    : Integer;
                 DtNascSF    : Array[1..5] of String[8];
                 FilhosSF    : Array[1..5] of String[40];
                 Sala        : String[5];
                 Ramal       : String[5];
                 UltSalario  : Real;
                 UltData     : String[8];
                 ChBco       : String[3];
                 Cheque      : String[8];
                 VChq        : Real;
                 SomaH13     : Integer;
                 SomaM13     : Integer;
                 SomaHFer    : Integer;
                 SomaMFer    : Integer;
                 DataAvP     : String[8];
                 INSS        : Char;
                 Uniforme    : String[10];
                 Calcado     : String[2];
                 TipoExame   : Char;
                 DataExame   : String[8];
                 Movimento   : Array[1..9] of Integer;
               END;

  Empregado  = RECORD
                 Status      : Char;
                 Matricula   : String[8];
                 Nome        : String[40];
                 Endereco    : String[40];
                 Bairro      : String[20];
                 Cidade      : String[20];
                 Estado      : String[2];
                 Cep         : String[5];
                 CepCompl    : String[3];
                 Telefone    : String[15];
                 AANasc      : String[2];
                 MMNasc      : String[2];
                 DDNasc      : String[2];
                 Sexo        : Char;
                 ECiv        : Char;
                 Nacional    : String[2];
                 Natural     : String[2];
                 Naturalz    : Char;
                 DataChBr    : String[8];
                 Cpf         : String[12];
                 CtrabN      : String[6];
                 CtrabS      : String[3];
                 CtrabE      : String[2];
                 PisPasep    : String[11];
                 Identidade  : String[15];
                 CertReserv  : String[15];
                 TitEleitor  : String[15];
                 Depto       : String[10];
                 Cargo       : String[15];
                 CentroC     : Array[1..5] of String[6];
                 PerctC      : Array[1..5] of Real;
                 Sindicato   : String[2];
                 Grau        : Char;
                 AAAdm       : String[2];
                 MMAdm       : String[2];
                 DDAdm       : String[2];
                 AAPAq       : String[2];
                 MMPAq       : String[2];
                 DDPAq       : String[2];
                 TipoE       : Char;
                 CBO         : String[5];
                 NoMTrab     : String[15];
                 Opcao       : Char;
                 DataOpcao   : String[8];
                 Vinculo     : String[2];
                 UFAnt       : String[2];
                 Entrada     : String[5];
                 Saida       : String[5];
                 IntRefeicao : String[15];
                 RepSemanal  : String[10];
                 Turno       : String[20];
                 AAResc      : String[2];
                 MMResc      : String[2];
                 DDResc      : String[2];
                 Causa       : String[2];
                 Salario     : Real;
                 Tipo        : Char;
                 TipoP       : Char;
                 HNormais    : Integer;
                 MesesT      : Integer;
                 MesesF      : Integer;
                 PgConta     : Char;
                 BcoPG       : String[10];
                 ContaPg     : String[15];
                 BcoFgts     : String[10];
                 ContaFgts   : String[15];
                 PercAdiant  : Real;
                 Peric       : Array[1..5] of Char;
                 Insalub     : Array[1..5] of Char;
                 VTransporte : Char;
                 DepIR       : Integer;
                 DepSF       : Integer;
                 Pensao      : Char;
                 PensaoP     : Real;
                 Cartao      : String[4];
                 AAFer       : String[2];
                 MMFer       : String[2];
                 DDFer       : String[2];
                 PeriodoV    : Integer;
                 DiaI        : Integer;
                 MesI        : Integer;
                 DiaF        : Integer;
                 MesF        : Integer;
                 Passagens   : Array[1..6] of Integer;
                 Faixa       : Array[1..6] of Integer;
                 DiasVT      : Integer;
                 FaltasNJ    : Integer;
                 DtNascSF    : Array[1..5] of String[8];
                 FilhosSF    : Array[1..5] of String[40];
                 Sala        : String[5];
                 Ramal       : String[5];
                 UltSalario  : Real;
                 UltData     : String[8];
                 ChBco       : Array[1..7] of String[3];
                 Cheque      : Array[1..7] of String[8];
                 VChq        : Array[1..7] of Real;
                 SomaH13     : Integer;
                 SomaM13     : Integer;
                 SomaHFer    : Integer;
                 SomaMFer    : Integer;
                 DataAvP     : String[8];
                 INSS        : Char;
                 Uniforme    : String[10];
                 Calcado     : String[2];
                 TipoExame   : Char;
                 DataExame   : String[8];
                 Movimento   : Array[1..9] of Integer;
               END;

  EncargosO  = RECORD
                 Empregado   : Char;
                 MMAA        : Array [1..48] of String[5];
                 SalC        : Array [1..48] of Real;
                 VRec        : Array [1..48] of Real;
               END;


  Encargos   = RECORD
                 Empregado   : String[8];
                 MMAA        : Array [1..48] of String[5];
                 SalC        : Array [1..48] of Real;
                 VRec        : Array [1..48] of Real;
               END;


Var
   OOMember       : Owner;
   OOFile         : FILE OF Owner;
   CCMember       : TabCmpy;
   CCFile         : FILE OF TabCmpy;
   C1Member       : EmpresaO;
   C1File         : FILE OF EmpresaO;
   C2Member       : Empresa;
   C2File         : FILE OF Empresa;
   E1Member       : EmpregadoO;
   E1File         : FILE OF EmpregadoO;
   E2Member       : Empregado;
   E2File         : FILE OF Empregado;
   X1Member       : EncargosO;
   X1File         : FILE OF EncargosO;
   X2Member       : Encargos;
   X2File         : FILE OF Encargos;

   M,I,E,R,C,L,A,Ii,Fn   : Integer;
   Dep,
   XAno,XAnoI,
   XAnoF,XMes            : String[2];
   XDr,
   XDir                  : String[20];


{$I TiraBrco.rot }


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
         Assign (C1File, (XDir + '\PLOGCMST.OLD'));
         {$I-}
         Reset   ( C1File );
         {$I+}
         If IOResult <> 0 then
            begin
              Assign( C1File, (XDir + '\PLOGCMST.DAT'));
              {$I-}
              Reset ( C1File );
              {$I+}
              If IOResult = 0 then
                 begin
                   If FileSize(C1File) > 0 then
                      begin
                        Close  ( C1File );
                        Rename ( C1File, (XDir + '\PLOGCMST.OLD'));
                        Reset  ( C1File );
                        Assign ( C2File, (XDir + '\PLOGCMST.DAT'));
                        {$I-}
                        Reset  ( C2File );
                        {$I+}
                        If IOResult <> 0 then
                           begin
                             ReWrite ( C2File );
                             Reset   ( C2File );
                             Seek  ( C1File, 0        );
                             Read  ( C1File, C1Member );
                             C2Member.Chave           := C1Member.Chave;
                             C2Member.Descricao       := C1Member.Descricao;
                             C2Member.Endereco        := C1Member.Endereco;
                             C2Member.Numero          := C1Member.Numero;
                             C2Member.Complemento     := C1Member.Complemento;
                             C2Member.Cidade          := C1Member.Cidade;
                             C2Member.Bairro          := C1Member.Bairro;
                             C2Member.Municipio       := C1Member.Municipio;
                             C2Member.Estado          := C1Member.Estado;
                             C2Member.Cep             := C1Member.Cep;
                             C2Member.DDD             := C1Member.DDD;
                             C2Member.Telefone        := C1Member.Telefone;
                             C2Member.Cgc             := C1Member.Cgc;
                             C2Member.Inscricao       := C1Member.Inscricao;
                             C2Member.Password        := C1Member.Password;
                             C2Member.MesAtivo        := C1Member.MesAtivo;
                             C2Member.AnoAtivo        := C1Member.AnoAtivo;
                             C2Member.Etapa           := C1Member.Etapa;
                             C2Member.NDepto          := C1Member.NDepto;
                             C2Member.NBancos         := C1Member.NBancos;
                             C2Member.NFunc           := C1Member.NFunc;
                             C2Member.FaltaH          := C1Member.FaltaH;
                             C2Member.FaltaM          := C1Member.FaltaM;
                             C2Member.RepousoH        := C1Member.RepousoH;
                             C2Member.RepousoM        := C1Member.RepousoM;
                             C2Member.ContaF          := C1Member.ContaF;
                             C2Member.ContaA          := C1Member.ContaA;
                             C2Member.ContaS          := C1Member.ContaS;
                             C2Member.CAGEGInscInps   := C1Member.CAGEGInscInps;
                             C2Member.CAGEGAtEco      := C1Member.CAGEGAtEco;
                             C2Member.RAISAtEco       := C1Member.RAISAtEco;
                             C2Member.RAISPropriet    := C1Member.RAISPropriet;
                             C2Member.RAISNatureza    := C1Member.RAISNatureza;
                             C2Member.RAISDiaPag      := C1Member.RAISFamiliares;
                             C2Member.GRPSTipo        := C1Member.GRPSTipo;
                             C2Member.GRPSIdent       := C1Member.GRPSIdent;
                             C2Member.GRPSSAT         := C1Member.GRPSSAT;
                             C2Member.GRPSXSAT        := C1Member.GRPSXSAT;
                             C2Member.GRPSFPAS        := C1Member.GRPSFPAS;
                             C2Member.GRPSTER         := C1Member.GRPSTER;
                             C2Member.GRPSXTER        := C1Member.GRPSXTER;
                             C2Member.GRPS19          := C1Member.GRPS19;
                             C2Member.GRPS20          := C1Member.GRPS20;
                             C2Member.GRUnidTrab      := C1Member.GRUnidTrab;
                             C2Member.GRConta         := C1Member.GRConta;
                             C2Member.GRCSCodEstab    := C1Member.GRCSCodEstab;
                             C2Member.GRCSIAtiv       := C1Member.GRCSIAtiv;
                             C2Member.GRCSAtiv        := C1Member.GRCSAtiv;
                             C2Member.GRCSCodAtiv     := C1Member.GRCSCodAtiv;
                             C2Member.GRCSSCodAtiv    := C1Member.GRCSSCodAtiv;
                             C2Member.GRCSCodCBO      := C1Member.GRCSCodCBO;
                             C2Member.GRCSTipoEstab   := C1Member.GRCSTipoEstab;
                             C2Member.GRCSNoEstab     := C1Member.GRCSNoEstab;
                             C2Member.GRCSTipoRef     := C1Member.GRCSTipoRef;
                             C2Member.GRCSCapSocial   := C1Member.GRCSCapSocial;
                             Seek  ( C2File, 0        );
                             Write ( C2File, C2Member );
                             Close ( C2File );
                           end;
                           Close ( C1File );
                           Erase ( C1File );
                      end
                      else Close ( C1File );
                 end;
            end
            else Close ( C1File );
         Val(XAnoI,Ii,E);
         Val(XAnoF,Fn,E);
         For A := Ii to Fn do
         begin
           Str(A,XAno);
           If A < 10 then XAno := '0' + XAno;
           For M := 1 to 12 do
           begin
             Str(M,XMes);
             If M < 10 then XMes := '0' + XMes;
             Assign (E1File, (XDir + '\PLOGEX' + XAno + '.O' + XMes));
             {$I-}
             Reset   ( E1File );
             {$I+}
             If IOResult <> 0 then
                begin
                  Assign ( E1File, (XDir + '\PLOGEX' + XAno + '.M' + XMes));
                  {$I-}
                  Reset ( E1File );
                  {$I+}
                  If IOResult = 0 then
                     begin
                       If FileSize(E1File) > 0 then
                          begin
                            Close  ( E1File );
                            Rename ( E1File, (XDir + '\PLOGEX' + XAno + '.O' + XMes));
                            Reset  ( E1File );
                            Assign ( E2File, (XDir + '\PLOGEX' + XAno + '.M' + XMes));
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
                                   E2Member.Status      := E1Member.Status;
                                   E2Member.Matricula   := E1Member.Matricula;
                                   E2Member.Nome        := E1Member.Nome;
                                   E2Member.Endereco    := E1Member.Endereco;
                                   E2Member.Bairro      := E1Member.Bairro;
                                   E2Member.Cidade      := E1Member.Cidade;
                                   E2Member.Estado      := E1Member.Estado;
                                   E2Member.Cep         := E1Member.Cep;
                                   E2Member.CepCompl    := E1Member.CepCompl;
                                   E2Member.Telefone    := E1Member.Telefone;
                                   E2Member.AANasc      := E1Member.AANasc;
                                   E2Member.MMNasc      := E1Member.MMNasc;
                                   E2Member.DDNasc      := E1Member.DDNasc;
                                   E2Member.Sexo        := E1Member.Sexo;
                                   E2Member.ECiv        := E1Member.Eciv;
                                   E2Member.Nacional    := E1Member.Nacional;
                                   E2Member.Natural     := E1Member.Natural;
                                   E2Member.Naturalz    := E1Member.Naturalz;
                                   E2Member.DataChBr    := E1Member.DataChBr;
                                   E2Member.Cpf         := E1Member.Cpf;
                                   E2Member.CtrabN      := E1Member.CtrabN;
                                   E2Member.CtrabS      := E1Member.CtrabS;
                                   E2Member.CtrabE      := E1Member.CtrabE;
                                   E2Member.PisPasep    := E1Member.PisPasep;
                                   E2Member.Identidade  := E1Member.Identidade;
                                   E2Member.CertReserv  := E1Member.CertReserv;
                                   E2Member.TitEleitor  := E1Member.TitEleitor;
                                   E2Member.Depto       := E1Member.Depto;
                                   E2Member.Cargo       := E1Member.Cargo;
                                   For L := 1 to 5 do
                                   begin
                                     E2Member.CentroC[L] := TiraBranco(E1Member.CentroC[L]);
                                     E2Member.PerctC[L]  := E1Member.PerctC[L];
                                   end;
                                   E2Member.Sindicato   := E1Member.Sindicato;
                                   E2Member.Grau        := E1Member.Grau;
                                   E2Member.AAAdm       := E1Member.AAAdm;
                                   E2Member.MMAdm       := E1Member.MMAdm;
                                   E2Member.DDAdm       := E1Member.DDAdm;
                                   E2Member.AAPAq       := E1Member.AAAdm;
                                   E2Member.MMPAq       := E1Member.MMAdm;
                                   E2Member.DDPAq       := E1Member.DDAdm;
                                   E2Member.TipoE       := E1Member.TipoE;
                                   E2Member.CBO         := E1Member.CBO;
                                   E2Member.NoMTrab     := E1Member.NoMTrab;
                                   E2Member.Opcao       := E1Member.Opcao;
                                   E2Member.DataOpcao   := E1Member.DataOpcao;
                                   E2Member.Vinculo     := E1Member.Vinculo;
                                   E2Member.UFAnt       := E1Member.UFAnt;
                                   E2Member.Entrada     := E1Member.Entrada;
                                   E2Member.Saida       := E1Member.Saida;
                                   E2Member.IntRefeicao := E1Member.IntRefeicao;
                                   E2Member.RepSemanal  := E1Member.RepSemanal;
                                   E2Member.Turno       := E1Member.Turno;
                                   E2Member.AAResc      := E1Member.AAResc;
                                   E2Member.MMResc      := E1Member.MMResc;
                                   E2Member.DDResc      := E1Member.DDResc;
                                   E2Member.Causa       := E1Member.Causa;
                                   E2Member.Salario     := E1Member.Salario;
                                   E2Member.Tipo        := E1Member.Tipo;
                                   E2Member.TipoP       := E1Member.TipoP;
                                   E2Member.HNormais    := E1Member.HNormais;
                                   E2Member.MesesT      := E1Member.MesesT;
                                   E2Member.MesesF      := E1Member.MesesF;
                                   E2Member.PgConta     := E1Member.PgConta;
                                   E2Member.BcoPG       := E1Member.BcoPg;
                                   E2Member.ContaPg     := E1Member.ContaPg;
                                   E2Member.BcoFgts     := E1Member.BcoFgts;
                                   E2Member.ContaFgts   := E1Member.ContaFgts;
                                   E2Member.PercAdiant  := E1Member.PercAdiant;
                                   For L := 1 to 5 do
                                   begin
                                     E2Member.Peric[L]    := E1Member.Peric[L];
                                     E2Member.Insalub[L]  := E1Member.Insalub[L];
                                     E2Member.DtNascSF[L] := E1Member.DtNascSF[L];
                                     E2Member.FilhosSF[L] := E1Member.FilhosSF[L];
                                     E2Member.PerctC[L]   := E1Member.PerctC[L];
                                   end;
                                   E2Member.VTransporte := E1Member.VTransporte;
                                   E2Member.DepIR       := E1Member.DepIR;
                                   E2Member.DepSF       := E1Member.DepSF;
                                   E2Member.Pensao      := E1Member.Pensao;
                                   E2Member.PensaoP     := E1Member.PensaoP;
                                   E2Member.Cartao      := E1Member.Cartao;
                                   E2Member.AAFer       := E1Member.AAFer;
                                   E2Member.MMFer       := E1Member.MMFer;
                                   E2Member.DDFer       := E1Member.DDFer;
                                   E2Member.PeriodoV    := E1Member.PeriodoV;
                                   E2Member.DiaI        := E1Member.DiaI;
                                   E2Member.MesI        := E1Member.MesI;
                                   E2Member.DiaF        := E1Member.DiaF;
                                   E2Member.MesF        := E1Member.MesF;
                                   E2Member.INSS        := E1Member.INSS;
                                   For L := 1 to 6 do
                                   begin
                                     E2Member.Passagens[L] := E1Member.Passagens[L];
                                     E2Member.Faixa[L]     := E1Member.Faixa[L];
                                     E2Member.ChBco[L]     := '';
                                     E2Member.Cheque[L]    := '';
                                     E2Member.VChq[L]      := 0;
                                   end;
                                   E2Member.FaltasNJ   := E1Member.FaltasNJ;
                                   E2Member.DiasVT     := E1Member.DiasVT;
                                   E2Member.Sala       := E1Member.Sala;
                                   E2Member.Ramal      := E1Member.Ramal;
                                   E2Member.UltSalario := E1Member.UltSalario;
                                   E2Member.UltData    := E1Member.UltData;
                                   E2Member.ChBco[7]   := E1Member.ChBco;
                                   E2Member.Cheque[7]  := E1Member.Cheque;
                                   E2Member.VChq[7]    := E1Member.VChq;
                                   E2Member.SomaH13    := E1Member.SomaH13;
                                   E2Member.SomaM13    := E1Member.SomaM13;
                                   E2Member.SomaHFer   := E1Member.SomaHFer;
                                   E2Member.SomaMFer   := E1Member.SomaMFer;
                                   E2Member.DataAvP    := E1Member.DataAvp;
                                   E2Member.Uniforme   := E1Member.Uniforme;
                                   E2Member.Calcado    := E1Member.Calcado;
                                   E2Member.TipoExame  := ' ';
                                   E2Member.DataExame  := '';
                                   For L := 1 to 9 do E2Member.Movimento[L] := E1Member.Movimento[L];
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
         end;

         Assign (X1File, (XDir + '\PLOGENCA.OLD'));
         {$I-}
         Reset   ( X1File );
         {$I+}
         If IOResult <> 0 then
            begin
              Assign ( X1File, (XDir + '\PLOGENCA.DAT'));
              {$I-}
              Reset ( X1File );
              {$I+}
              If IOResult = 0 then
                 begin
                   Close  ( X1File );
                   Rename ( X1File, (XDir + '\PLOGENCA.OLD'));
                   Reset  ( X1File );
                   Assign ( X2File, (XDir + '\PLOGENCA.DAT'));
                   {$I-}
                   Reset  ( X2File );
                   {$I+}
                   If IOResult <> 0 then
                      begin
                        ReWrite ( X2File );
                        Reset   ( X2File );
                        Reset   ( E2File );
                        I := -1;
                        Repeat
                          I := I + 1;
                          {$I-}
                          Seek  ( X1File, I        );
                          Read  ( X1File, X1Member );
                          {$I+}
                          If IOResult = 0 then
                             begin
                               For L := 1 to 48 do
                               begin
                                 X2Member.MMAA[L] := X1Member.MMAA[L];
                                 X2Member.SalC[L] := X1Member.SalC[L];
                                 X2Member.VRec[L] := X1Member.VRec[L];
                               end;
                             end
                             else begin
                                    For L := 1 to 48 do
                                    begin
                                      X2Member.MMAA[L] := '';
                                      X2Member.SalC[L] := 0;
                                      X2Member.VRec[L] := 0;
                                    end;
                                  end;
                          Seek ( E2File, I        );
                          Read ( E2File, E2Member );
                          X2Member.Empregado := E2Member.Matricula;
                          Seek  ( X2File, I        );
                          Write ( X2File, X2Member );
                        Until (I + 1) = FileSize(E2File);
                        Close ( X2File );
                        Close ( E2File );
                      end;
                   Close ( X1File );
                   Erase ( X1File );
                 end;
            end
            else Close ( X1File );
       Until (C + 1) = FileSize(CCFile);
       Close ( CCFile );
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
                 If OOMember.Versao = '7.212/94' then
                    begin
                      OOMember.Versao := '7.301/95';
                      Seek  ( OOFile, 0        );
                      Write ( OOFile, OOMember );
                      Close ( OOFile );
                      Converte;
                    end
                    else begin
                           Close ( OOFile );
                           Writeln('Os dados j  foram convertidos para a vers„o 7.3 de 01/95');
                         end;
               end;
          end;
     end
     else Writeln('O drive e Ano n„o foram informados (PlogVE73 C: AAi AAf)');
  Halt;
end.