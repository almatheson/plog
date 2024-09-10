Unit AlogGlbs;

Interface

Const
   FileMaster  = 'ALOGMAST.DAT';
   FileOwner   = 'PLXOWNER.DAT';
   FileBlkSta  = 'ALOGBLOK.DAT';
   FileConta   = 'ALOGCNTA';
   FileLote    = 'ALLX';
   FileDept    = 'ALOGDPTO';
   FileSald    = 'ALSX';
   FileExpe    = 'ALXX';
   FileLcto    = 'ALMX';
   FileCmpy    = 'ALOGCMPY.DAT';
   FileCMst    = 'ALOGCMST.DAT';
   FileHsPd    = 'ALOGHSPD';
   FileEco     = 'ALOGECOI';
   FileIndx    = 'ALOGINDX.IDX';
   FileWorkA   = 'WORKFILA.DAT';
   FileWorkP   = 'WORKFILP.DAT';

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
  Str14      = String[14];
  Str15      = String[15];
  Str18      = String[18];
  Str20      = String[20];
  Str21      = String[21];
  Str22      = String[22];
  Str25      = String[25];
  Str30      = String[30];
  Str31      = String[31];
  Str32      = String[32];
  Str33      = String[33];
  Str34      = String[34];
  Str35      = String[35];
  Str36      = String[36];
  Str40      = String[40];
  Str44      = String[44];
  Str45      = String[45];
  Str50      = String[50];
  Str60      = String[60];
  Str80      = String[80];
  Str132     = String[132];
  AnyStr     = String[255];


{---------------------------------------------------------------------}
{*****************************  ARVORES ******************************}
{---------------------------------------------------------------------}
{ #00 - Empresas                                           CmpyNo  03 }
{ #01 - Contas                                             ContaNo 18 }
{ #02 - Lotes                                              LoteNo  06 }
{ #03 - Departamento                                       DeptNo  06 }
{ #04 - Lancamento (Conta  # Data  # Lote  # SeqLote  )    CDVSNo  33 }
{ #05 - Despesas   (Depto  # Conta                    )    ExpeNo  25 }
{ #06 - Di†rio     (Data   # Conta # Lote  # SeqLote  )    DCVSNo  33 }
{ #07 - Indice Eco (Ano    # Indice                   )    IINo    07 }
{ #08 - Historico Padr∆o                                   HHNo    03 }
{---------------------------------------------------------------------}

  PointerB  = ^STreeB;

  STreeB    = RECORD
                ChaveB       : Str9;
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
                Chave1       : Str18;
                RelAddr1     : Integer;
                Left1,Right1 : Pointer1;
                Weight1      : Integer;
              END;

  Pointer2  = ^STree2;

  STree2    = RECORD
                Chave2       : Str6;
                RelAddr2     : Integer;
                Left2,Right2 : Pointer2;
                Weight2      : Integer;
              END;

  Pointer3  = ^STree3;

  STree3    = RECORD
                Chave3       : Str6;
                RelAddr3     : Integer;
                Left3,Right3 : Pointer3;
                Weight3      : Integer;
              END;

  Pointer4  = ^STree4;

  STree4    = RECORD
                Chave4       : Str33;
                RelAddr4     : Integer;
                Left4,Right4 : Pointer4;
                Weight4      : Integer;
              END;

  Pointer5  = ^STree5;

  STree5    = RECORD
                Chave5       : Str25;
                RelAddr5     : Integer;
                Left5,Right5 : Pointer5;
                Weight5      : Integer;
              END;

  Pointer6  = ^STree6;

  STree6    = RECORD
                Chave6       : Str33;
                RelAddr6     : Integer;
                Left6,Right6 : Pointer6;
                Weight6      : Integer;
              END;

  Pointer7  = ^STree7;

  STree7    = RECORD
                Chave7       : Str7;
                RelAddr7     : Integer;
                Left7,Right7 : Pointer7;
                Weight7      : Integer;
              END;

  Pointer8  = ^STree8;

  STree8    = RECORD
                Chave8       : Str3;
                RelAddr8     : Integer;
                Left8,Right8 : Pointer8;
                Weight8      : Integer;
              END;


{$I Owner.inc    }
{$I AlogFile.inc }

  WorkRecordA = RECORD
                  AtivoDesc    : String[40];
                  AtivoValor   : String[20];
                END;

  WorkRecordP = RECORD
                  PassivoDesc  : String[40];
                  PassivoValor : String[20];
                END;

Var
   MasterMember   : Master;
   MasterFile     : FILE OF Master;
   BlkStaMember   : BlkSta;
   BlkStaFile     : FILE OF BlkSta;
   OwnerMember    : Owner;
   OwnerFile      : FILE OF Owner;
   ContaMember    : Guia;
   ContaFile      : FILE OF Guia;
   LoteMember     : Lote;
   LoteFile       : FILE OF Lote;
   DeptMember     : Departamento;
   DeptFile       : FILE OF Departamento;
   SaldMember     : Saldos;
   SaldFile       : FILE OF Saldos;
   ExpeMember     : Expenses;
   ExpeFile       : FILE OF Expenses;
   LctoMember     : Lancamento;
   LctoFile       : FILE OF Lancamento;
   CmpyMember     : TabCmpy;
   CmpyFile       : FILE OF TabCmpy;
   CMstMember     : Company;
   CMstFile       : FILE OF Company;
   HsPdMember     : Historico;
   HsPdFile       : FILE OF Historico;
   EcoMember      : Indices;
   EcoFile        : FILE OF Indices;
   IndxMember     : Xtree;
   IndxFile       : FILE OF Xtree;
   IndLMember     : Ltree;
   IndLFile       : FILE OF Ltree;
   IndMMember     : Mtree;
   IndMFile       : FILE OF Mtree;

   WorkFileX      : FILE OF TabCmpy;
   WorkFile1      : FILE OF Guia;
   WorkFile2      : FILE OF Lote;
   WorkFile3      : FILE OF Departamento;
   WorkMember4    : Saldos;
   WorkFile4      : FILE OF Saldos;
   WorkFile5      : FILE OF Lancamento;
   WorkFile6      : FILE OF Historico;

   LST            : TEXT;

   WorkAMember    : WorkRecordA;
   WorkAFile      : FILE OF WorkRecordA;
   WorkPMember    : WorkRecordP;
   WorkPFile      : FILE OF WorkRecordP;

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

   Tfd,
   Bfn,Btx,
   Tfn,Ttx,
   Sfn,Stx,
   Utx            : Byte;

   XMo,
   Avs,
   Op,
   Op1,
   Fx,
   Sx,
   Sel,
   Gra,
   Grp,
   Opc,
   Vez,
   VezD,
   VezR,
   Resp,
   TipR,
   Erro,
   Tipo,
   DI,
   DL,
   DM,
   Ut,
   MF,
   MacoI,
   Foot,
   PrimeiraVez,
   ImpC,Mudou,
   DskRpt,Laser,
   Stl,Direcao,
   XSt,XStAnt,
   F,Tkb,
   RouD,OpMn,
   Pv1,Pv2,
   Sv1,Sv2,Mch,
   TC,RC,RW       : Char;

   LivroD,
   NCont,
   Pg1,
   X1,Y1,
   ProcNo,
   NBaseC,
   NCia,
   XLanc,
   D,M,A,
   XR,B,X,Y,Pg,
   MM,AA,DD,Hl,
   DLote,
   Folha,
   NumF,
   Livro,
   MMM,
   T,
   U,
   K,
   E,
   R,
   L,
   I,
   P,
   RecordNumber,
   HHNumber,
   HHAN,
   CmpyNumber,
   CmpyAN,
   BlkNumber,
   BlkAN,
   LoteNumber,
   LoteAN,
   ContaNumber,
   ContaAN,
   DeptNumber,
   DeptAN,
   ContaMNumber,
   DCVSNumber,
   DCVSAN,
   CDVSNumber,
   CDVSAN,
   ExpeNumber,
   IINumber,
   ContPag,
   ContLin,
   Kant,
   Modelo,
   Tam,YY,YYAnt,
   MP,MC,
   M1,M2,
   Limite         : Integer;

   Dia,
   Mes,
   Ano,
   Ver,
   DiaSema        : Word;

   VMo,
   TotA,
   TotD,
   TotP,
   TotR,
   Perct,
   SaldoX,
   Lucro,
   TDebitos,
   TCreditos,
   Fator,
   ValorAnt       : Double;

   XDL,
   DDD,
   AAA,
   DiaQ,
   DiaXX,
   Sta,
   XDia,
   XMes           : Str2;

   XCia,
   IIFx,
   HHNo,
   HHAC,
   LastCia,
   MMFx           : Str3;

   AAFx,
   XAno,
   SeqXX          : Str4;

   IINo           : Str5;

   NMo,
   XLot,
   LoteNo,
   LoteAC,
   LoteXX,
   PerctX,
   UltDept,
   DeptI,
   XSystem        : Str6;

   MPass,
   XCondicional,
   PassW,
   PercH,
   PercV,
   BlkNo,
   BlkAC          : Str9;

   XVersao,
   DataDP,
   DataA,
   DataX,
   WData,
   Dx,
   Df,
   Cx,
   Cf,
   Nx,
   Nf,
   QP             : Str10;

   XPrinter       : Str15;

   XMarca,
   Junta,
   Atividade,
   Seq,
   Deb,
   Cred,
   CmpyNo,
   CmpyAC,
   DeptNo,
   DeptAC         : Str15;

   PrConta,
   UltConta,
   ContaS,
   ContaI,
   ContaNo,
   ContaXX,
   ContaAC,
   ContaAX,
   ContaLP,
   ContaBL,
   ContaDB,
   ContaCR        : Str18;

   Local,
   RegJunta,
   Abert,
   Sald,
   TAtivo,
   TPassivo,
   Xuser          : Str20;

   ExpeNo         : Str25;

   XDisco,
   DCVSNo,
   DCVSAC,
   CDVSAX,
   CDVSNo         : Str33;

   XPathV,
   XDriveP,
   XDrive,
   XPath,
   XDir,
   LaserInit,
   TCalc,
   Titulo1,
   Assin1,
   Titulo2,
   Assin2,
   Titulo         : Str40;

   DescrConta     : Str44;

   Tit            : Str45;

   ErroMsg        : Str60;

   HistP,
   Res1,
   Res2,
   Res3           : Str80;

   Res,J          : AnyStr;

   ArrayIndice    : Array [0..5]    of Real;
   ArrayBase      : Array [0..5]    of Str6;
   ArrayMesEx     : Array [1..12]   of Str9;
   TabMesX        : Array [1..12]   of Str20;

   TabI           : Array [1..12]   of Str35;
   TabX           : Array [1..12]   of Integer;
   TabY           : Array [1..12]   of Integer;

   Tab1           : Array [1..8]    of Str34;
   Tab2           : Array [1..4]    of Str21;
   Tab3           : Array [1..8]    of Str30;
   Tab4           : Array [1..9]    of Str44;
   Tab5           : Array [1..8]    of Str35;
   TabY1          : Array [1..8]    of Integer;
   TabY2          : Array [1..4]    of Integer;
   TabY3          : Array [1..8]    of Integer;
   TabY4          : Array [1..9]    of Integer;
   TabY5          : Array [1..8]    of Integer;

   TabDia         : Array [1..12]   of Integer;

   ScArray1       : Array [1..4000] of Char;
   ScArray2       : Array [1..4000] of Char;
   ScArray3       : Array [1..4000] of Char;
   ScArray4       : Array [1..4000] of Char;
   ScArray5       : Array [1..4000] of Char;
   ScArray6       : Array [1..4000] of Char;
   ScArrayM       : Array [1..4000] of Char;

Implementation

begin
   ArrayMesEx[1]  := 'Janeiro';
   ArrayMesEx[2]  := 'Fevereiro';
   ArrayMesEx[3]  := 'Maráo';
   ArrayMesEx[4]  := 'Abril';
   ArrayMesEx[5]  := 'Maio';
   ArrayMesEx[6]  := 'Junho';
   ArrayMesEx[7]  := 'Julho';
   ArrayMesEx[8]  := 'Agosto';
   ArrayMesEx[9]  := 'Setembro';
   ArrayMesEx[10] := 'Outubro';
   ArrayMesEx[11] := 'Novembro';
   ArrayMesEx[12] := 'Dezembro';

   XDisco   := 'C';

   Tab1[1]  := '  Lotes ( Lanáamentos )           ';
   Tab1[2]  := '  Saldo/Movimento                 ';
   Tab1[3]  := '  Oráamento de Despesas           ';
   Tab1[4]  := '  Correá∆o  de Contas             ';
   Tab1[5]  := '  Correá∆o  de Oráamentos         ';
   Tab1[6]  := '  Troca o Màs de Processamento    ';
   Tab1[7]  := '  Relat¢rios                      ';
   Tab1[8]  := '  Encerrar o Processamento        ';

   Tab2[1] := ' Plano de Contas     ';
   Tab2[2] := ' Departamentos       ';
   Tab2[3] := ' Indice Econìmicos   ';
   Tab2[4] := ' Hist¢rico Padr∆o    ';

   Tab3[1]  := '  Empresas                   ';
   Tab3[2]  := '  Lista Empresas             ';
   Tab3[3]  := '  Set-Up de Cìr              ';
   Tab3[4]  := '  Configuraá∆o de Impressora ';
   Tab3[5]  := '  Ultimo Backup              ';
   Tab3[6]  := '  Indices Econìmicos         ';
   Tab3[7]  := '  Hist¢rico Padr∆o           ';
   Tab3[8]  := '  Encerrar a funá∆o          ';

   Tab4[1] := '  Plano de Contas                          ';
   Tab4[2] := '  Hist¢rico Padr∆o                         ';
   Tab4[3] := '  Departamentos                            ';
   Tab4[4] := '  Indices Econìmicos                       ';
   Tab4[5] := '  Controle de Lotes                        ';
   Tab4[6] := '  Raz∆o Anal°tico                          ';
   Tab4[7] := '  Balancete                                ';
   Tab4[8] := '  Livro Di†rio                             ';
   Tab4[9] := '  Balanáo                                  ';

   Tab5[1] := ' Apuraá∆o de Resultados          ';
   Tab5[2] := ' Oráamento de Despesas           ';
   Tab5[3] := ' Follow-Up de Despesas           ';
   Tab5[4] := ' Movimento por Departamento      ';
   Tab5[5] := ' Tàrmo Ab/Enc.(Raz∆o ou Di†rio)  ';
   Tab5[6] := ' Balancete Gerencial             ';
   Tab5[7] := ' Balancete por Departamento      ';
   Tab5[8] := ' Acompanhamento de Projetos      ';

   TabY1[1]  := 12;
   TabY1[2]  := 13;
   TabY1[3]  := 14;
   TabY1[4]  := 15;
   TabY1[5]  := 16;
   TabY1[6]  := 17;
   TabY1[7]  := 18;
   TabY1[8]  := 19;

   TabY2[1] := 10;
   TabY2[2] := 11;
   TabY2[3] := 12;
   TabY2[4] := 13;

   TabY3[1]  := 12;
   TabY3[2]  := 13;
   TabY3[3]  := 14;
   TabY3[4]  := 15;
   TabY3[5]  := 16;
   TabY3[6]  := 17;
   TabY3[7]  := 18;
   TabY3[8]  := 19;

   TabY4[1] := 11;
   TabY4[2] := 12;
   TabY4[3] := 13;
   TabY4[4] := 14;
   TabY4[5] := 15;
   TabY4[6] := 16;
   TabY4[7] := 17;
   TabY4[8] := 18;
   TabY4[9] := 19;

   TabY5[1] := 10;
   TabY5[2] := 11;
   TabY5[3] := 12;
   TabY5[4] := 13;
   TabY5[5] := 14;
   TabY5[6] := 15;
   TabY5[7] := 16;
   TabY5[8] := 17;

   Bfn := 14;
   Btx := 0;
   Tfn := 0;
   Ttx := 14;
   Sfn := 1;
   Stx := 14;
   Utx := 7;

   TabMesX[1]  := ' de Janeiro  de  ';
   TabMesX[2]  := ' de Fevereiro de ';
   TabMesX[3]  := ' de Maráo   de   ';
   TabMesX[4]  := ' de Abril   de   ';
   TabMesX[5]  := ' de Maio    de   ';
   TabMesX[6]  := ' de Junho   de   ';
   TabMesX[7]  := ' de Julho   de   ';
   TabMesX[8]  := ' de Agosto   de  ';
   TabMesX[9]  := ' de Setembro  de ';
   TabMesX[10] := ' de Outubro  de  ';
   TabMesX[11] := ' de Novembro  de ';
   TabMesX[12] := ' de Dezembro  de ';
end.


