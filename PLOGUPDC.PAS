{$O+,F+}
Unit PlogUpdC;

Interface

Uses Crt,Dos,PlogGlbs,PlogBasP,PlogTree;

   Procedure AtualizaCadastro;

Implementation

Var
  Mes          : Integer;
  Mx,Ax        : String[2];


Procedure PedeMesAno;
begin
  Color(Blue,Cyan);
  GotoXY(1,23); Write(ConstStr(' ',80));
  GotoXY(2,23); Write('Informe o mˆs e ano a partir do qual o cadastro atual ser  atualizado:   /');
  Mx := '';
  Ax := '';
  Repeat
    K := 1;
    Repeat
      Case K of
           1 : begin
                 J := Mx;
                 InputStr(J,2,73,23,0,'S','N','T','N',Blue,White);
                 If TC <> #27 then
                    begin
                      Val(J,Mes,E);
                      If (Mes < 01) or (Mes > 12) then
                         begin
                           ErroMsg := 'Mˆs invalido';
                           ErrorMessage;
                           K := K - 1;
                         end
                         else Mx := QQStr(Mes,2,'0');
                    end;
               end;
           2 : begin
                 J := Ax;
                 InputStr(J,4,76,23,0,'S','N','T','N',Blue,White);
                 If TC <> #27 then
                    begin
                      If J = '' then Str(AA,J);
                      Ax := J;
                      If Ax = '' then
                         begin
                           ErroMsg := 'Ano inv lido';
                           ErrorMessage;
                           K := K - 1;
                         end;
                    end;
               end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (TC in [#27,'S','N']) or (K = 3);
    If TC <> #27 then Confirma;
  Until TC in [#27,'S'];
end;


Procedure AtualizaCadastro;
Type
  EmpregadoA = RECORD
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
                 AANasc      : String[4];
                 MMNasc      : String[2];
                 DDNasc      : String[2];
                 Sexo        : Char;
                 ECiv        : Char;
                 Nacional    : String[2];
                 Natural     : String[2];
                 Naturalz    : Char;
                 DataChBr    : String[10];
                 Cpf         : String[12];
                 CtrabN      : String[10];
                 CtrabS      : String[6];
                 CtrabE      : String[2];
                 PisPasep    : String[11];
                 Identidade  : String[15];
                 CertReserv  : String[15];
                 TitEleitor  : String[15];
                 Depto       : String[10];
                 Cargo       : String[15];
                 CentroC     : Array[1..5] of String[6];
                 DiasC       : Array[1..5] of Real;
                 Sindicato   : String[2];
                 Grau        : Char;
                 AAAdm       : String[4];
                 MMAdm       : String[2];
                 DDAdm       : String[2];
                 AAPAq       : String[4];
                 MMPAq       : String[2];
                 DDPAq       : String[2];
                 TipoE       : Char;
                 CBO         : String[5];
                 NoMTrab     : String[15];
                 Opcao       : Char;
                 DataOpcao   : String[10];
                 Vinculo     : String[2];
                 ExAnt       : String[2];
                 Entrada     : String[5];
                 Saida       : String[5];
                 IntRefeicao : String[15];
                 RepSemanal  : String[10];
                 Turno       : String[20];
                 AAResc      : String[4];
                 MMResc      : String[2];
                 DDResc      : String[2];
                 DataAvP     : String[10];
                 Causa       : String[2];
                 DataHomo    : String[10];
                 Motivo      : String[25];
                 CodSaque    : String[2];
                 Salario     : Real;
                 Tipo        : Char;
                 TipoP       : Char;
                 HNormais    : Real;
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
                 AAFer       : String[4];
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
                 DtNascSF    : Array[1..5] of String[10];
                 FilhosSF    : Array[1..5] of String[40];
                 Sala        : String[5];
                 Ramal       : String[5];
                 UltSalario  : Real;
                 UltData     : String[10];
                 ChBco       : Array[1..7] of String[3];
                 Cheque      : Array[1..7] of String[8];
                 VChq        : Array[1..7] of Real;
                 SomaHF1     : Integer;
                 SomaMF1     : Integer;
                 SomaHF2     : Integer;
                 SomaMF2     : Integer;
                 INSS        : Array[1..2] of Char;
                 Uniforme    : String[10];
                 Calcado     : String[2];
                 TipoExame   : Char;
                 DataExame   : String[10];
                 Pontos      : Integer;
                 Registro    : String[15];
                 Origem      : String[5];
                 Movimento   : Array[1..9] of Integer;
               END;

Var
  WorkMember : EmpregadoA;
  WorkFile   : FILE of EmpregadoA;

  R,I,L      : Integer;
begin
  PedeMesAno;
  If TC = 'S' then
     begin
       Assign ( WorkFile, (XPath + '\' + FileEE + Ax + '.M' + Mx));
       {$I-}
       Reset ( WorkFile );
       {$I+}
       If IOResult = 0 then
          begin
            If FileSize(WorkFile) > 0 then
               begin
                 Color(Blue,Yellow);
                 GotoXY(1,23); Write(ConstStr(' ',80));
                 GotoXY(2,23); Write('Atualizando cadastro de ',ArrayMesEx[MM],'/',QQStr(AA,2,'0'),
                                ' com dados de ',ArrayMesEx[Mes],'/',Ax,'.');
                 GotoXY(73,23); Write('N§.');
                 Color(Red,White);
                 GotoXY(1,24); Write(ConstStr(' ',80));
                 I := 0;
                 R := -1;
                 Repeat
                   R := R + 1;
                   Seek ( WorkFile, R         );
                   Read ( WorkFile, WorkMember);
                   EENo := WorkMember.Matricula;
                   SearchTree5 ( Root5 );
                   If RC = 'S' then
                      begin
                        I := I + 1;
                        ReadWrite(#08,'R','N',EENumber);
                        EEMember.Endereco    := WorkMember.Endereco;
                        EEMember.Bairro      := WorkMember.Bairro;
                        EEMember.Cidade      := WorkMember.Cidade;
                        EEMember.Estado      := WorkMember.Estado;
                        EEMember.Cep         := WorkMember.Cep;
                        EEMember.CepCompl    := WorkMember.CepCompl;
                        EEMember.Telefone    := WorkMember.Telefone;
                        EEMember.AANasc      := WorkMember.AANasc;
                        EEMember.MMNasc      := WorkMember.MMNasc;
                        EEMember.DDNasc      := WorkMember.DDNasc;
                        EEMember.Sexo        := WorkMember.Sexo;
                        EEMember.ECiv        := WorkMember.Eciv;
                        EEMember.Nacional    := WorkMember.Nacional;
                        EEMember.Natural     := WorkMember.Natural;
                        EEMember.Naturalz    := WorkMember.Naturalz;
                        EEMember.DataChBr    := WorkMember.DataChBr;
                        EEMember.Cpf         := WorkMember.Cpf;
                        EEMember.CtrabN      := WorkMember.CtrabN;
                        EEMember.CtrabS      := WorkMember.CtrabS;
                        EEMember.CtrabE      := WorkMember.CtrabE;
                        EEMember.PisPasep    := WorkMember.PisPasep;
                        EEMember.Identidade  := WorkMember.Identidade;
                        EEMember.CertReserv  := WorkMember.CertReserv;
                        EEMember.TitEleitor  := WorkMember.TitEleitor;
                        EEMember.Depto       := WorkMember.Depto;
                        EEMember.Cargo       := WorkMember.Cargo;
                        For L := 1 to 5 do
                        begin
                          EEMember.Peric[L]    := WorkMember.Peric[L];
                          EEMember.Insalub[L]  := WorkMember.Insalub[L];
                          EEMember.DtNascSF[L] := WorkMember.DtNascSF[L];
                          EEMember.FilhosSF[L] := WorkMember.FilhosSF[L];
                        end;
                        EEMember.Sindicato   := WorkMember.Sindicato;
                        EEMember.Grau        := WorkMember.Grau;
                        EEMember.AAAdm       := WorkMember.AAAdm;
                        EEMember.MMAdm       := WorkMember.MMAdm;
                        EEMember.DDAdm       := WorkMember.DDAdm;
                        EEMember.AAPAq       := WorkMember.AAAdm;
                        EEMember.MMPAq       := WorkMember.MMAdm;
                        EEMember.DDPAq       := WorkMember.DDAdm;
                        EEMember.TipoE       := WorkMember.TipoE;
                        EEMember.CBO         := WorkMember.CBO;
                        EEMember.NoMTrab     := WorkMember.NoMTrab;
                        EEMember.Opcao       := WorkMember.Opcao;
                        EEMember.DataOpcao   := WorkMember.DataOpcao;
                        EEMember.Vinculo     := WorkMember.Vinculo;
                        EEMember.Entrada     := WorkMember.Entrada;
                        EEMember.Saida       := WorkMember.Saida;
                        EEMember.IntRefeicao := WorkMember.IntRefeicao;
                        EEMember.RepSemanal  := WorkMember.RepSemanal;
                        EEMember.Turno       := WorkMember.Turno;
                        EEMember.Tipo        := WorkMember.Tipo;
                        EEMember.TipoP       := WorkMember.TipoP;
                        EEMember.HNormais    := WorkMember.HNormais;
                        EEMember.PgConta     := WorkMember.PgConta;
                        EEMember.BcoPG       := WorkMember.BcoPg;
                        EEMember.ContaPg     := WorkMember.ContaPg;
                        EEMember.BcoFgts     := WorkMember.BcoFgts;
                        EEMember.ContaFgts   := WorkMember.ContaFgts;
                        EEMember.PercAdiant  := WorkMember.PercAdiant;
                        EEMember.VTransporte := WorkMember.VTransporte;
                        EEMember.DepIR       := WorkMember.DepIR;
                        EEMember.DepSF       := WorkMember.DepSF;
                        EEMember.Pensao      := WorkMember.Pensao;
                        EEMember.PensaoP     := WorkMember.PensaoP;
                        EEMember.Cartao      := WorkMember.Cartao;
                        EEMember.AAFer       := WorkMember.AAFer;
                        EEMember.MMFer       := WorkMember.MMFer;
                        EEMember.DDFer       := WorkMember.DDFer;
                        EEMember.INSS[1]     := WorkMember.INSS[1];
                        EEMember.INSS[2]     := WorkMember.INSS[2];
                        EEMember.Sala        := WorkMember.Sala;
                        EEMember.Ramal       := WorkMember.Ramal;
                        EEMember.Uniforme    := WorkMember.Uniforme;
                        EEMember.Calcado     := WorkMember.Calcado;
                        EEMember.TipoExame   := WorkMember.TipoExame;
                        EEMember.DataExame   := WorkMember.DataExame;
                        EEMember.Pontos      := WorkMember.Pontos;
                        EEMember.Registro    := WorkMember.Registro;
                        EEMember.Origem      := WorkMember.Origem;
                        ReadWrite(#08,'W','N',EENumber);
                        Color(Blue,White);
                        GotoXY(76,23); Write(I:4);
                      end;
                 Until (R + 1) = FileSize(WorkFile);
                 Close ( WorkFile );
                 Color(Blue,Yellow);
                 GotoXY(1,23); Write(ConstStr(' ',80));
                 GotoXY(2,23); Write('O cadastro de ',ArrayMesEx[MM],'/',QQStr(AA,2,'0'),
                                     ' foi atualizado com dados de ',ArrayMesEx[Mes],'/',Ax,'.');
                 GotoXY(73,23); Write('N§.');
                 Color(Blue,White);
                 GotoXY(76,23); Write(I:4);
                 TeclaReturn;
               end
               else begin
                      ErroMsg := 'NÆo h  empregados em '+Mx+'/'+Ax;
                      ErrorMessage;
                    end;
          end
          else begin
                 ErroMsg := 'NÆo existe o arquivo de '+Mx+'/'+Ax;
                 ErrorMessage;
               end;
     end;
  EENo := '';
end;


end.

