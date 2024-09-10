  Master     = RECORD
                 Password    : String[8];
                 NEmpresas   : Integer;
                 NIndices    : Integer;
                 NHistorico  : Integer;
                 Don         : String[10];
                 Dof         : String[10];
                 Con         : String[10];
                 Cof         : String[10];
                 Non         : String[10];
                 Nof         : String[10];
                 Qpa         : String[10];
                 LJet        : Char;
                 TipoImpr    : String[15];
                 DataBkp     : String[10];
                 BfnO        : Byte;
                 BtxO        : Byte;
                 TfnO        : Byte;
                 TtxO        : Byte;
                 SfnO        : Byte;
                 StxO        : Byte;
                 UtxO        : Byte;
                 TfdO        : Byte;
                 BlkPssword  : String[8];
               END;

  TabCmpy    = RECORD
                 Chave       : String[3];
                 Descricao   : String[40];
                 Status      : Char;
                 DataBkp     : String[10];
               END;

  BlkSta     = RECORD
                 Cia         : String[3];
                 MesAno      : String[7];
                 BlkStatus   : Char;
               END;

  Company    = RECORD
                 Chave       : String[3];
                 Descricao   : String[40];
                 Endereco    : String[40];
                 Cidade      : String[20];
                 Estado      : String[2];
                 Cep         : String[9];
                 DDD         : String[4];
                 Telefone    : String[8];
                 CpfCgc      : String[20];
                 IdInscr     : String[20];
                 Password    : String[8];
                 TipoE       : Char;
                 MesAtivo    : Integer;
                 AnoAtivo    : Integer;
                 NContas     : Integer;
                 NDeptos     : Integer;
               END;

  Guia       = RECORD
                 Conta       : String[18];
                 OrigConta   : String[18];
                 Descricao   : String[40];
                 Status      : Char;
                 Grupo       : Char;
                 Grau        : Char;
                 Tipo        : Char;
                 Aceita      : Char;
                 Avisa       : Char;
                 PedeDepto   : Char;
                 GrupoE      : Char;
                 Correcao    : Char;
                 IndiceC     : String[2];
                 PeriodoC    : Char;
                 CPartidaX   : String[18];
                 CPartidaC   : String[18];
                 HistoricoC  : String[3];
                 Diario      : Char;
                 Balancete   : Array[1..5] of Char;
                 Balanco     : Array[1..5] of Char;
                 Sintetica   : String[18];
               END;

  Saldos     = RECORD
                 Status      : Char;
                 Abertura    : Array [1..12] of Double;
                 Debitos     : Array [1..12] of Double;
                 Creditos    : Array [1..12] of Double;
                 Saldo       : Array [1..12] of Double;
                 SaldoB      : Array [1..12] of Double;
                 NLanctos    : Array [1..12] of Integer;
               END;

  Lote       = RECORD
                 Chave        : String[6];
                 MesContabil  : Integer;
                 AnoContabil  : Integer;
                 Status       : Char;
                 Debito       : Double;
                 Credito      : Double;
                 RDebito      : Integer;
                 RCredito     : Integer;
                 DataAbert    : String[10];
                 Tipo         : Char;
                 Descricao    : String[20];
                 Dias         : Array[1..31] of Char;
               END;

  Departamento = RECORD
                   Chave      : String[6];
                   OrigChave  : String[6];
                   NomeLocal  : String[30];
                   NomeDepto  : String[30];
                   Status     : Char;
                 END;

  Expenses    = RECORD
                  Conta      : String[18];
                  Depto      : String[6];
                  Corrigivel : Char;
                  IndiceX    : String[2];
                  ValorO     : Array[1..12] of Real;
                  Despesas   : Array[1..12] of Real;
                END;

  Lancamento = RECORD
                 Status       : Char;
                 OrigData     : String[10];
                 Conta        : String[18];
                 MesLancto    : Integer;
                 Tipo         : Char;
                 Valor        : Real;
                 Depto        : String[6];
                 Historico    : Array[1..3] of String[60];
                 Lote         : String[6];
                 SeqLote      : String[4];
               END;

  Historico  = RECORD
                 CodigoH     : String[3];
                 Descricao   : String[60];
                 Status      : Char;
               END;

  Indices    = RECORD
                 Ano        : String[4];
                 Chave      : String[2];
                 Tipo       : Char;
                 Descricao  : String[6];
                 Valores    : Array[1..12] of Real;
               END;

  XTree      = RECORD
                 TipoX      : Array [1..23] of Char;
                 ChaveX     : Array [1..23] of String[18];
                 RelAddrX   : Array [1..23] of Integer;
               END;


  MTree      = RECORD
                 ChaveX     : Array [1..14] of String[33];
                 RelAddrX   : Array [1..14] of Integer;
               END;

  LTree      = RECORD
                 ChaveX     : Array [1..64] of String[6];
                 RelAddrX   : Array [1..64] of Integer;
               END;

