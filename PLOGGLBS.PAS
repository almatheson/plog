Unit PlogGlbs;

Interface

Const
   FileMaster  = 'PLOGMAST.DAT';
   FileOwner   = 'PLXOWNER.DAT';
   FileCmpy    = 'PLOGCMPY.DAT';
   FileBlkSta  = 'PLOGBLOK.DAT';
   FileCMst    = 'PLOGCMST.DAT';

   FileTT      = 'PLOGTABL';
   FileCC      = 'PLOGCNTA';
   FileDD      = 'PLOGDEPT';
   FileBB      = 'PLOGBNCO';
   FileSS      = 'PLOGSIND';
   FileHH      = 'PLOGHIST';

   FileEE      = 'PLEX';
   FileHP      = 'PLPX';
   FileMM      = 'PLMX';
   FileOS      = 'PLOX';
   FileEN      = 'PLOGENCA';
   FileGFip    = 'PLGF';

   FileInd1    = 'PLOGIND1.IDX';
   FileInd2    = 'PLIX';
   FileInd3    = 'PLOGIND3.IDX';


Type
  Str2       = String[2];
  Str3       = String[3];
  Str4       = String[4];
  Str5       = String[5];
  Str6       = String[6];
  Str7       = String[7];
  Str8       = String[8];
  Str9       = String[9];
  Str10      = String[10];
  Str11      = String[11];
  Str13      = String[13];
  Str14      = String[14];
  Str15      = String[15];
  Str17      = String[17];
  Str18      = String[18];
  Str19      = String[19];
  Str20      = String[20];
  Str21      = String[21];
  Str22      = String[22];
  Str23      = String[23];
  Str24      = String[24];
  Str25      = String[25];
  Str30      = String[30];
  Str31      = String[31];
  Str34      = String[34];
  Str35      = String[35];
  Str36      = String[36];
  Str38      = String[38];
  Str39      = String[39];
  Str40      = String[40];
  Str44      = String[44];
  Str45      = String[45];
  Str49      = String[49];
  Str50      = String[50];
  Str80      = String[80];
  Str132     = String[132];
  AnyStr     = String[255];

{-----------------------------------------------------------------------}
{***************************** ARVORES *********************************}
{-----------------------------------------------------------------------}
{ #BB --> BlkStatus                                         11   BlkNo  }
{ #00 --> Companhia                                         03   CmpyNo }
{ #01 --> Conta                                             03   CCNo   }
{ #02 --> Sindicato                                         02   SSNo   }
{ #03 --> Departamento                                      10   DDNo   }
{ #04 --> Tabelas                                           07   TTNo   }
{ #05 --> Empregado                                         08   EENo   }
{ #06 --> Departamento  + # + Empregado                                 }
{     --> Empregado     + # + Matricula                                 }
{     --> Identificador + # + Banco     + # + Empregado                 }
{     --> Sindicato     + # + Empregado                     49   XXNo   }
{ #07 --> Banco/Ag                                          15   BBNo   }
{ #08 --> Ordem de Servico                                  17   OONo   }
{ #10 --> Empregado     + # + Data      + # + Tipo          24   HHNo   }
{ #YY --> Conta         (Tempor ria por Empregado)          03   YYNo   }
{-----------------------------------------------------------------------}

  PointerB  = ^STreeB;

  STreeB    = RECORD
                ChaveB       : Str11;
                RelAddrB     : Integer;
                LeftB,RightB : PointerB;
                WeightB      : Integer;
              END;

  Pointer0  = ^STree0;

  STree0    = RECORD
                Chave0       : Str3;
                RelAddr0     : Integer;
                Left0,Right0 : Pointer0;
                Weight0      : Integer;
              END;

  Pointer1  = ^STree1;

  STree1    = RECORD
                Chave1       : Str3;
                RelAddr1     : Integer;
                Left1,Right1 : Pointer1;
                Weight1      : Integer;
              END;

  Pointer2  = ^STree2;

  STree2    = RECORD
                Chave2       : Str2 ;
                RelAddr2     : Integer;
                Left2,Right2 : Pointer2;
                Weight2      : Integer;
              END;

  Pointer3  = ^STree3;

  STree3    = RECORD
		Chave3       : Str10;
                RelAddr3     : Integer;
                Left3,Right3 : Pointer3;
                Weight3      : Integer;
              END;

  Pointer4  = ^STree4;

  STree4    = RECORD
		Chave4       : Str7;
                RelAddr4     : Integer;
                Left4,Right4 : Pointer4;
                Weight4      : Integer;
              END;

  Pointer5  = ^STree5;

  STree5    = RECORD
		Chave5       : Str8;
                RelAddr5     : Integer;
                Left5,Right5 : Pointer5;
                Weight5      : Integer;
              END;

  Pointer6  = ^STree6;

  STree6    = RECORD
		Chave6       : Str49;
                RelAddr6     : Integer;
                Left6,Right6 : Pointer6;
                Weight6      : Integer;
              END;

  Pointer7  = ^STree7;

  STree7    = RECORD
		Chave7       : Str15;
                RelAddr7     : Integer;
                Left7,Right7 : Pointer7;
                Weight7      : Integer;
              END;

  Pointer8  = ^STree8;

  STree8    = RECORD
		Chave8       : Str17;
                RelAddr8     : Integer;
                Left8,Right8 : Pointer8;
                Weight8      : Integer;
              END;

  Pointer10 = ^STree10;

  STree10   = RECORD
		Chave10        : Str24;
                RelAddr10      : Integer;
                Left10,Right10 : Pointer10;
                Weight10     : Integer;
              END;

  PointerY = ^STreeY;

  STreeY   = RECORD
		ChaveY         : Str3;
                LeftY,RightY   : PointerY;
                WeightY        : Integer;
                Origem         : Char;
                AcMensalV      : Real;
                AcMensalH      : Integer;
                AcMensalM      : Integer;
                AcAnualV       : Real;
                AcAnualH       : Integer;
                AcAnualM       : Integer;
                QtdResc        : String[5];
                Parcelas       : Integer;
                BaseUsr        : Char;
                PerctUsr       : Real;
              END;


{$I Owner.inc    }
{$I PlogFile.inc }

  Total = RECORD
             Ocupado      : Char;
             Mensal       : Real;
             HoraM        : Real;
             MinutoM      : Real;
             Anual        : Real;
             HoraA        : Real;
             MinutoA      : Real;
          END;

  MovProx    = RECORD
                 Empregado   : String[8];
                 Conta       : String[3];
                 AcMensalV   : Real;
                 AcMensalH   : Integer;
                 AcMensalM   : Integer;
               END;

  GRPS    = RECORD
              Cia            : String[3];
              VGuia          : Array[1..15] of Real;
              Total          : Real;
              Endereco       : String[40];
              Cidade         : String[20];
              Estado         : String[2];
              Cep            : String[9];
              DDD            : String[4];
              GRPSTipo       : Char;
              GRPSIdent      : String[20];
            END;

  GRCS    = RECORD
              Cia            : String[3];
              VGuia          : Array[1..2] of Real;
              Func           : Integer;
              NFunc          : Integer;
              Tipo           : Char;
              Descricao      : String[40];
              Descricao2     : String[40];
              Endereco       : String[40];
              Numero         : String[10];
              Complemento    : String[15];
              Bairro         : String[20];
              Cidade         : String[20];
              Estado         : String[2];
              Cep            : String[9];
              Cgc            : String[20];
              Cod            : String[20];
            END;

  GR      = RECORD
              Cia            : String[3];
              VGuia          : Array[1..2] of Real;
              Total          : Real;
              Func           : Integer;
              Tipo           : Char;
              NomeBanco      : String[40];
              NomeAgencia    : String[40];
            END;

  DARF    = RECORD
              Cia            : String[3];
              Venc           : String[8];
              Receita        : String[20];
              VGuia          : Real;
              Total          : Real;
            END;


Var
   BlkStaMember   : BlkSta;
   BlkStaFile     : FILE OF BlkSta;
   MasterMember   : Master;
   MasterFile     : FILE OF Master;
   OwnerMember    : Owner;
   OwnerFile      : FILE OF Owner;
   CmpyMember     : TabCmpy;
   CmpyFile       : FILE OF TabCmpy;
   CMstMember     : Company;
   CMstFile       : FILE OF Company;
   TTMember       : Tabelas;
   TTFile         : FILE OF Tabelas;
   CCMember       : Verbas;
   CCFile         : FILE OF Verbas;
   DDMember       : Estrutura;
   DDFile         : FILE OF Estrutura;
   BBMember       : BancoAg;
   BBFile         : FILE OF BancoAg;
   SSMember       : Sindical;
   SSFile         : FILE OF Sindical;
   EEMember       : Empregado;
   EEFile         : FILE OF Empregado;
   HPMember       : HistPag;
   HPFile         : FILE OF HistPag;
   HHMember       : Historico;
   HHFile         : FILE OF Historico;
   MMMember       : Movimento;
   MMFile         : FILE OF Movimento;
   OOMember       : OServico;
   OOFile         : FILE OF OServico;
   ENMember       : Encargos;
   ENFile         : FILE OF Encargos;
   Ind1Member     : Indice1;
   Ind1File       : FILE OF Indice1;
   Ind2Member     : Indice2;
   Ind2File       : FILE OF Indice2;
   Ind3Member     : Indice3;
   Ind3File       : FILE OF Indice3;
   TotMember      : Total;
   TotFile        : FILE OF Total;
   PXMember       : MovProx;
   PXFile         : FILE OF MovProx;
   GuiaMember     : GRPS;
   GuiaFile       : FILE OF GRPS;
   GRCSMember     : GRCS;
   GRCSFile       : FILE OF GRCS;
   GrMember       : GR;
   GrFile         : FILE OF GR;
   DARFMember     : DARF;
   DARFFile       : FILE OF DARF;

   WorkFileX      : FILE OF TabCmpy;
   WorkFile0      : FILE OF Tabelas;
   WorkFile1      : FILE OF Verbas;
   WorkFile2      : FILE OF Sindical;
   WorkFile3      : FILE OF Estrutura;
   WorkFile4      : FILE OF Empregado;
   WorkFile5      : FILE OF Movimento;
   WorkFile6      : FILE OF BancoAg;
   WorkFile7      : FILE OF HistPag;
   WorkFile8      : FILE OF Encargos;
   WorkFile9      : FILE OF Historico;
{   WorkFile10     : FILE OF OServico; }

   LST            : TEXT;

   RootB          : PointerB;
   Root0          : Pointer0;
   Root1          : Pointer1;
   Root2          : Pointer2;
   Root3          : Pointer3;
   Root4          : Pointer4;
   Root5          : Pointer5;
   Root6          : Pointer6;
   Root7          : Pointer7;
   Root8          : Pointer8;
   Root10         : Pointer10;
   RootY          : PointerY;
   YAddress       : PointerY;

   Tfd,
   Bfn,Btx,
   Tfn,Ttx,
   Sfn,Stx,
   Utx            : Byte;

   Qx,
   AD,
   SC,
   CS,
   P13,
   Eta,
   GG,
   Ex,
   Op,
   Op1,
   Opc,
   Opc1,
   XSt,XStAnt,
   CPgConta,
   MF,
   Vez,
   VezD,
   VezR,
   Resp,
   Erro,
   D1,
   D2,
   D3,
   Ut,
   Mud,
   Enc,
   Dec1,
   EtapaAnt,
   PrimeiraVez,
   Corr,XC,Mudou,
   Cont,Direcao,
   F,Tkb,VTR,
   Foot,TipoCChq,
   DvCX,DvSX,
   DskRpt,Laser,
   Tl,Opt,NoMat,
   OpMn,Folha,
   OpH,OpV,OpX,
   QB,Sq,VP2,FC,
   Tp,Tr,Tx,Mch,
   TC,RC,RW       : Char;

   De,
   Pr,
   DU,
   DUF,
   NFunc,
   MesA,
   AnoA,
   DiaA,
   ProcNo,
   RecordNumber,
   CmpyNumber,
   CmpyAN,
   CmpyAX,
   CCNumber,
   CCAN,
   EENumber,
   EEAN,
   BlkNumber,
   BlkAN,
   BBNumber,
   BBAN,
   SSNumber,
   SSAN,
   OONumber,
   OOAN,
   XXNumber,
   BENumber,
   BEAN,
   DDNumber,
   DDAN,
   HHNumber,
   TTAN,
   TTNumber,
   Limite,
   NBaseC,
   ContLin,
   ContPag,
   NCont,
   NCia,
   Tam,
   D,M,A,
   XR,B,
   Parc,
   Hora,Minuto,
   Adm,Dem,
   DiasT,DiasF,
   Pg,X,Y,
   Pg1,X1,Y1,
   FF,A1,Ar,At,
   Dj,Dp,Da,Dc,
   Dm,Dt,D2T,
   Colunas,
   Sx,N,Lin,
   MM,AA,DD,T,YY,
   YYAnt,
   U,K,E,R,L,I,P  : Integer;
   Dia,
   Mes,
   Ano,
   Ver,
   DiaSema        : Word;
   VBaseIRF,
   VIapas,
   VFgts,
   SalBase,
   SalBase13,
   ValorHora1,
   ValorHora2,
   Produt,
   AdNot,
   Valor,
   VLiq,
   VIR,
   ValeTransp,
   VSalFam,
   VPeri,
   VInsa,
   LFolha,
   R1,R2,R3,R4,
   R5,R6,R7,
   Tpr,Tds,Chq,
   TotalH,TProv,
   Resto,
   MP202,
   TDesc           : Real;
   MMx,
   Mx,
   Mn,Ma,
   SSNo,
   SSAC,
   Sta,
   XX,
   XDia,
   XMes,
   CSind          : Str2;
   Bco,
   YYNo,
   LastCia,
   CmpyNo,
   CmpyAC,
   CmpyNX,
   XCia,
   MMFx,
   MMFn,
   IIFx,
   IIFn,
   CCNo,
   CCAC,
   CDepto         : Str3;
   Ax,
   AAx,
   XAno,
   AAFx,
   AAFn           : Str4;
   CodX,
   SeqX,
   XSystem        : Str6;
   TTAC,
   TTNo,
   MMAA           : Str7;
   XData,
   XCondicional,
   PassW,
   EENo,
   EEAC           : Str8;
   XVersao,
   DMA,
   IData,
   FData,
   WData,
   Dx,
   Df,
   Cx,
   Cf,
   Nx,
   Nf,
   QP,
   RecordAnt,
   DDNo,
   DDAC,
   CBPg,
   CBFgts         : Str10;
   BlkNo,
   BlkAC          : Str11;
   XPrinter,
   XMarca,
   BBNo,
   BBAC           : Str15;
   OONo,
   OOAC           : Str17;
   Xuser          : Str20;
   HHNo           : Str24;
   Responsavel    : Str30;
   Periodo,
   Msg1,
   Msg2,
   Msg3,
   MsgX           : Str39;
   XDriveP,
   XDrive,
   XPath,
   XDir,
   LaserInit,
   XDisco,
   Tit,
   Titulo         : Str40;
   ErroMsg        : Str50;
   XXNo           : Str49;
   Res1,
   Res2,
   Res3           : Str80;
   L1,L2,L3,L4,L5,
   L6,L7,L8,L9,L10,
   Res,
   J              : AnyStr;
   KArray         : Array [1..7]    of Str24;
   DArray         : Array [1..7]    of Str40;
   RArray         : Array [1..7]    of Integer;
   R1Array        : Array [1..7]    of Integer;
   TArray         : Array [1..7]    of Char;
   H1Array        : Array [1..7]    of Str4;
   M1Array        : Array [1..7]    of Str2;
   HFArray        : Array [1..7]    of Str4;
   MFArray        : Array [1..7]    of Str2;
   A1Array        : Array [1..7]    of Str3;
   D1Array        : Array [1..7]    of Str2;
   AFArray        : Array [1..7]    of Str3;
   DFArray        : Array [1..7]    of Str2;
   VArray         : Array [1..7]    of Str15;
   AArray         : Array [1..7]    of Str18;
   PArray         : Array [1..7]    of Str2;
   XArray         : Array [1..7]    of Str6;
   BArray         : Array [1..7]    of Char;
   OArray         : Array [1..7]    of Char;
   NArray         : Array [1..7]    of Str50;
   SArray         : Array [1..7]    of Str15;

   NoStat         : Array [1..15]   of Integer;

   T1             : Array [1..72]   of Integer;
   T2,T3,T4       : Array [1..72]   of Real;
   VBases         : Array [1..10]   of Real;
   VPass2         : Array [1..50]   of Real;

   ContaX         : Array [1..10]   of Str3;
   ArrayMesEx     : Array [1..12]   of Str9;

   Tab1           : Array [1..9]    of Str34;
   Tab2           : Array [1..9]    of Str21;
   Tab3           : Array [1..10]   of Str30;
   Tab4           : Array [1..11]   of Str44;
   Tab5           : Array [1..11]   of Str35;
   TabI           : Array [1..20]   of Str35;
   TabX           : Array [1..20]   of Integer;
   TabY           : Array [1..20]   of Integer;

   TabY1          : Array [1..9]    of Integer;
   TabY2          : Array [1..9]    of Integer;
   TabY3          : Array [1..10]   of Integer;
   TabY4          : Array [1..11]   of Integer;
   TabY5          : Array [1..11]   of Integer;

   TabDia         : Array [1..12]   of Integer;

   ScArray1       : Array [1..4000] of Char;
   ScArray2       : Array [1..4000] of Char;
   ScArray3       : Array [1..4000] of Char;
   ScArray4       : Array [1..4000] of Char;
   ScArray5       : Array [1..4000] of Char;
   ScArray6       : Array [1..4000] of Char;
   ScArrayM       : Array [1..4000] of Char;

   NomeX          : Array [1..4] of Str40;
   MatriculaX     : Array [1..4] of Str15;
   TurnoX         : Array [1..4] of Str20;
   EntradaX       : Array [1..4] of Str5;
   SaidaX         : Array [1..4] of Str5;
   IntRefeicaoX   : Array [1..4] of Str15;
   RepSemanalX    : Array [1..4] of Str10;
   CtrabX         : Array [1..4] of Str20;
   CargoX         : Array [1..4] of Str15;
   CartaoX        : Array [1..4] of Str4;
   EnderecoX      : Array [1..4] of Str40;
   BairroX        : Array [1..4] of Str20;
   CidadeX        : Array [1..4] of Str20;
   EstadoX        : Array [1..4] of Str2;
   CepX           : Array [1..4] of Str9;

Implementation

begin
   ArrayMesEx[1]  := 'Janeiro';
   ArrayMesEx[2]  := 'Fevereiro';
   ArrayMesEx[3]  := 'Mar‡o';
   ArrayMesEx[4]  := 'Abril';
   ArrayMesEx[5]  := 'Maio';
   ArrayMesEx[6]  := 'Junho';
   ArrayMesEx[7]  := 'Julho';
   ArrayMesEx[8]  := 'Agosto';
   ArrayMesEx[9]  := 'Setembro';
   ArrayMesEx[10] := 'Outubro';
   ArrayMesEx[11] := 'Novembro';
   ArrayMesEx[12] := 'Dezembro';

   XDisco := 'A';

   Tab1[1] := '  Empregados                      ';
   Tab1[2] := '  Altera‡äes de Sal rio           ';
   Tab1[3] := '  Movimento (Lan‡amentos)         ';
   Tab1[4] := '  C lculos                        ';
   Tab1[5] := '  Rescisäes                       ';
   Tab1[6] := '  F‚rias                          ';
   Tab1[7] := '  Relat¢rios                      ';
   Tab1[8] := '  Troca o Mˆs de Processamento    ';
   Tab1[9] := '  Encerrar o Processamento        ';

   Tab2[1] := ' Tabela de I.N.S.S.   ';
   Tab2[2] := ' Tabela de I.Renda    ';
   Tab2[3] := ' Tabela de S.Fam¡lia  ';
   Tab2[4] := ' Tabela de V.Transp.  ';
   Tab2[5] := ' Parƒmetros           ';
   Tab2[6] := ' Tabela de Contas     ';
   Tab2[7] := ' Tabela de Sindicatos ';
   Tab2[8] := ' Tabela de Departam.  ';
   Tab2[9] := ' Tabela de Bancos     ';

   Tab3[1]  := '  Empresas                   ';
   Tab3[2]  := '  Listagens (V.T./Empresa)   ';
   Tab3[3]  := '  Set-Up de Cor              ';
   Tab3[4]  := '  Configura‡Æo de Impressora ';
   Tab3[5]  := '  Ultimo Backup              ';
   Tab3[6]  := '  Tabelas e Parƒmetros       ';
   Tab3[7]  := '  Tabela de Contas           ';
   Tab3[8]  := '  Tabela de Sindicatos       ';
   Tab3[9]  := '  ImpressÆo (Guias)          ';
   Tab3[10] := '  Encerrar a fun‡Æo          ';

   Tab4[1]  := '  Tabelas diversas                         ';
   Tab4[2]  := '  Cadastro/Planilha de Movimento           ';
   Tab4[3]  := '  Rela‡Æo de Empregados/Textos diversos    ';
   Tab4[4]  := '  Folha de Pagamentos/List.de Conferˆncia  ';
   Tab4[5]  := '  Recibo de Pagamento (Contra-Cheque)      ';
   Tab4[6]  := '  Rel.Banc ria/Dinheiro/EmissÆo de Cheque  ';
   Tab4[7]  := '  Sele‡Æo de Contas                        ';
   Tab4[8]  := '  Rela‡Æo de I.N.S.S.                      ';
   Tab4[9]  := '  Contribui‡Æo Sindical/GRCS               ';
   Tab4[10] := '  Admitidos e Demitidos (CAGED)            ';
   Tab4[11] := '  Ficha Financeira (Mens./Acum.)           ';

   Tab5[1]  := ' Totaliza‡Æo da Folha de Pagto.  ';
   Tab5[2]  := ' Guia de Recolhimento (GRPS)     ';
   Tab5[3]  := ' Rel.do FGTS (GFip) ou Guia (GR) ';
   Tab5[4]  := ' I.R.F.(Imp.de Renda)/DARF       ';
   Tab5[5]  := ' Etiquetas (CartÆo/Correspond.)  ';
   Tab5[6]  := ' Quadro de Hor rio de Trabalho   ';
   Tab5[7]  := ' Folha de Pagamento Sint‚tica    ';
   Tab5[8]  := ' Rela‡Æo/Recibo de Vale Transp.  ';
   Tab5[9]  := ' Totaliza‡Æo de Vale Transporte  ';
   Tab5[10] := ' F‚rias Vencidas/Programa‡Æo     ';
   Tab5[11] := ' Relat¢rios Auxiliares           ';

   TabY1[1]  := 12;
   TabY1[2]  := 13;
   TabY1[3]  := 14;
   TabY1[4]  := 15;
   TabY1[5]  := 16;
   TabY1[6]  := 17;
   TabY1[7]  := 18;
   TabY1[8]  := 19;
   TabY1[9]  := 20;

   TabY2[1] := 10;
   TabY2[2] := 11;
   TabY2[3] := 12;
   TabY2[4] := 13;
   TabY2[5] := 14;
   TabY2[6] := 15;
   TabY2[7] := 16;
   TabY2[8] := 17;
   TabY2[9] := 18;

   TabY3[1]  := 12;
   TabY3[2]  := 13;
   TabY3[3]  := 14;
   TabY3[4]  := 15;
   TabY3[5]  := 16;
   TabY3[6]  := 17;
   TabY3[7]  := 18;
   TabY3[8]  := 19;
   TabY3[9]  := 20;
   TabY3[10] := 21;

   TabY4[1]  := 10;
   TabY4[2]  := 11;
   TabY4[3]  := 12;
   TabY4[4]  := 13;
   TabY4[5]  := 14;
   TabY4[6]  := 15;
   TabY4[7]  := 16;
   TabY4[8]  := 17;
   TabY4[9]  := 18;
   TabY4[10] := 19;
   TabY4[11] := 20;

   TabY5[1]  := 09;
   TabY5[2]  := 10;
   TabY5[3]  := 11;
   TabY5[4]  := 12;
   TabY5[5]  := 13;
   TabY5[6]  := 14;
   TabY5[7]  := 15;
   TabY5[8]  := 16;
   TabY5[9]  := 17;
   TabY5[10] := 18;
   TabY5[11] := 19;

   Tfd := 1;
   Bfn := 14;
   Btx := 0;
   Tfn := 0;
   Ttx := 14;
   Sfn := 1;
   Stx := 14;
   Utx := 7;

   MP202 := 0;
end.

