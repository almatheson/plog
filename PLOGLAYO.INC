  Empregado  = RECORD
                 Status      : Char;
                 Matricula   : String[15];
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
                 LocalCC     : String[6];
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
               END;

