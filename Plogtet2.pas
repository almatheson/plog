{$O+,F+}
Unit PlogText;

Interface

Uses Crt,Dos,PlogGlbs,PlogBasP,PlogTree;


{$I LogTxt1.rot }

Function Campo(E,S : Char; C,T1,T2,T3 : Integer; X : Str80) : AnyStr;
Var
  K1,K2   : Integer;
begin
  Campo := '';
  Case E of
       'D' : Case C of
                  01 : Campo := XDia + '/' + XMes + '/' + XAno;
                  02 : Campo := XDia + ' de ' + ArrayMesEx[Mes] + ' de ' + XAno;
                  03 : Campo := QQStr(MM,2,'0') + '/' + QQStr(AA,4,'0');
                  04 : Campo := ArrayMesEx[MM] + ' de ' + QQStr(AA,4,'0');
                  05 : Campo := QQStr(TabDia[MM],2,'0') + '/' +
                                QQStr(MM,2,'0') + '/' + QQStr(AA,4,'0');
                  06 : Campo := QQStr(TabDia[MM],2,'0') + ' de ' +
                                ArrayMesEx[MM] + ' de ' + QQStr(AA,4,'0');
                  07 : Campo := QQStr(TabDia[MM],2,'0');
                  08 : begin
                         K     := Length(ArrayMesEx[MM]);
                         Campo := ArrayMesEx[MM] + ConstStr(' ',(10-K));
                       end;
                  09 : Campo := QQStr(AA,4,'0');
                  10 : Campo := QQStr(AA,4,'0');
                  else Campo := '';
             end;
       'C' : begin
               CCNo := X;
               SearchTree1 ( Root1 );
               If RC = 'S' then
                  begin
                    ReadWrite(#04,'R','N',CCNumber);
                    YYNo := CCNo;
                    SearchTreeY ( RootY );
                    If RC = 'N' then C := 0;
                  end
                  else If X = 'R02' then
                          begin
                            X    := 'R03';
                            CCNo := X;
                            SearchTree1 ( Root1 );
                            If RC = 'S' then
                               begin
                                 ReadWrite(#04,'R','N',CCNumber);
                                 YYNo := CCNo;
                                 SearchTreeY ( RootY );
                                 If RC = 'N' then C := 0;
                               end
                               else C := 0;
                          end
                          else C := 0;
               RC := 'S';
               Case C of
                  01 : Campo := CCMember.Conta;
                  02 : Campo := CCMember.Descricao;
                  03 : Campo := EditReal(YAddress^.AcMensalV);
                  04 : If (YAddress^.AcMensalH <> 0) or
                          (YAddress^.AcMensalM <> 0)
                          then Campo := QQStr(YAddress^.AcMensalH,3,' ') + ':' +
                                        QQStr(YAddress^.AcMensalM,2,'0')
                          else Campo := '      ';
                  05..07 : begin
			     Extenso(T1,T2,T3,EditReal(YAddress^.AcMensalV));
			     Case C of
                                  05 : Campo := Res1;
                                  06 : Campo := Res2;
                             end;
                           end;
                  05 : Campo := QQStr(TabDia[MM],2,'0') + '/' +
                                QQStr(MM,2,'0') + '/' + QQStr(AA,4,'0');
                  06 : Campo := QQStr(TabDia[MM],2,'0') + ' de ' +
                                ArrayMesEx[MM] + ' de ' + QQStr(AA,4,'0');
                  07 : Campo := QQStr(TabDia[MM],2,'0');
                  08 : begin
                         K1    := Length(ArrayMesEx[MM]);
                         Campo := ArrayMesEx[MM] + ConstStr(' ',(10-K1));
                       end;
                  09 : Campo := QQStr(AA,4,'0');
                  10 : Campo := QQStr(AA,4,'0');
                  11 : Campo := QQStr(D,2,'0');
                  12 : begin
                         K1    := Length(ArrayMesEx[M]);
                         Campo := ArrayMesEx[M] + ConstStr(' ',(10-K1));
                       end;
                  13 : Campo := QQStr(A,4,'0');
                  15 : If MM < 12 then Campo := ArrayMesEx[MM+1] + ' de ' + QQStr(AA,4,'0')
                                  else Campo := ArrayMesEx[1] + ' de ' + QQStr(AA+1,4,'0');
               end;
             end;
       'E' : Case C of
                  01 : Campo := CMstMember.Descricao;
                  02 : Campo := CMstMember.Endereco+', '+CMstMember.Numero;
                  03 : Campo := CMstMember.Complemento;
                  04 : Campo := CMstMember.Cidade;
                  05 : Campo := CMstMember.Municipio;
                  06 : Campo := CMstMember.Bairro;
                  07 : Campo := CMstMember.Estado;
                  08 : Campo := CMstMember.Cep;
                  09 : Campo := CMstMember.DDD;
                  10 : Campo := CMstMember.Telefone;
                  11 : Campo := CMstMember.Cgc;
                  12 : Campo := CMstMember.Inscricao;
             end;
       'F' : Case C of
                  01 : Campo := EEMember.Matricula;
                  02 : Campo := EEMember.Nome;
                  03 : Campo := EEMember.Endereco;
                  04 : Campo := EEMember.Bairro;
                  05 : Campo := EEMember.Cidade;
                  06 : Campo := EEMember.Estado;
                  07 : Campo := EEMember.Cep + '-' + EEMember.CepCompl;
                  08 : Campo := EEMember.Telefone;
                  09 : Campo := EEMember.DDNasc + '/' +
                                EEMember.MMNasc + '/' +
                                EEMember.AANasc;
                  10 : If EEMember.Sexo = 'M' then Campo := 'Masculino'
                                              else Campo := 'Feminino';
                  11 : Case EEMember.Eciv of
                            'C' : Campo := 'Casado';
                            'D' : Campo := 'Divorciado';
                            'V' : Campo := 'Vi£vo';
                            'S' : Campo := 'Solteiro';
                            'M' : Campo := 'Marital';
                       end;
                  12 : Campo := EEMember.Nacional;
                  13 : Campo := EEMember.Natural;
                  14 : Campo := EEMember.Naturalz;
                  15 : Campo := EEMember.DataChBr;
                  16 : Campo := EEMember.Cpf;
                  17 : Campo := EEMember.CTrabN + ' ' +
                                EEMember.CTrabS + ' ' +
                                EEMember.CTrabE;
                  18 : Campo := EEMember.PisPasep;
                  19 : Campo := EEMember.Identidade;
                  20 : Campo := EEMember.CertReserv;
                  21 : Campo := EEMember.TitEleitor;
                  22 : Campo := EEMember.Depto;
                  23 : Campo := EEMember.Cargo;
                  24 : Campo := EEMember.CentroC[C];
                  25 : Campo := EEMember.Sindicato;
                  26 : Campo := EEMember.Grau;
                  27 : Campo := EEMember.DDAdm + '/' +
                                EEMember.MMAdm + '/' +
                                EEMember.AAAdm;
                  28 : Campo := EEMember.DDPAq + '/' +
                                EEMember.MMPAq + '/' +
                                EEMember.AAPAq;
                  29 : Case EEMember.TipoE of
                            '1' : Campo := '1 emprego';
                            'R' : Campo := 'Reemprego';
                            'T' : Campo := 'Transferˆncia';
                       end;
                  30 : Campo := EEMember.CBO;
                  31 : Campo := EEMember.NoMTrab;
                  32 : Campo := EEMember.Opcao;
                  33 : Campo := EEMember.DataOpcao;
                  34 : Campo := EEMember.Vinculo;
                  35 : Campo := EEMember.Entrada;
                  36 : Campo := EEMember.Saida;
                  37 : Campo := EEMember.IntRefeicao;
                  38 : Campo := EEMember.RepSemanal;
                  39 : Campo := EEMember.Turno;
                  40 : Campo := EEMember.DDResc + '/' +
                                EEMember.MMResc + '/' +
                                EEMember.AAResc;
                  41 : Campo := EEmember.Causa;
                  42 : begin
                         CCAC := YYNo;
                         YYNo := '016';
                         SearchTreeY ( RootY );
                         If RC = 'N' then YAddress^.AcMensalV := 0;
                         If EEMember.Tipo = 'H'
                            then Campo := EditReal((EEMember.Salario * EEMember.HNormais)
                                          + YAddress^.AcMensalV)
                            else Campo := EditReal(EEMember.Salario + YAddress^.AcMensalV);
                         YYNo := CCAC;
                       end;
                  43 : If EEMember.Tipo = 'H' then Campo := 'por Hora'
                                              else Campo := 'Mensal';
                  44 : Campo := QQStr(EEMember.HNormais,3,'0');
                  45 : Campo := QQStr(EEMember.MesesT,2,'0');
                  46 : Campo := QQStr(EEMember.MesesF,2,'0');
                  47 : Campo := EEMember.BcoPg;
                  48 : Campo := EEMember.ContaPg;
                  49 : Campo := EEMember.BcoFgts;
                  50 : Campo := EEMember.ContaFgts;
                  51 : Campo := EditReal(EEMember.PercAdiant);
                  52 : Campo := QQStr(EEMember.DepIR,2,'0');
                  53 : Campo := QQStr(EEMember.DepSF,2,'0');
                  54 : Campo := EditReal(EEMember.PensaoP);
                  55 : Campo := EEMember.Cartao;
                  56 : Campo := EEMember.DDFer + '/' +
                                EEMember.MMFer + '/' +
                                EEMember.AAFer;
                  57 : Campo := QQStr(EEMember.PeriodoV,2,'0');
                  58 : Campo := QQStr(EEMember.DiaI,2,'0') + '/' + QQStr(EEMember.MesI,2,'0');
                  59 : Campo := QQStr(EEMember.DiaF,2,'0') + '/' + QQStr(EEMember.MesF,2,'0');
                  60 : Campo := QQStr(EEMember.Passagens[C],2,'0');
                  61 : Campo := QQStr(EEMember.Faixa[C],2,'0');
                  62 : Campo := QQStr(EEMember.DiasVT,2,'0');
                  63 : Campo := QQStr(EEMember.FaltasNJ,2,'0');
                  64 : If EEMember.DtNascSF[C] <> '' then Campo := EEMember.DtNascSF[C];
                  65 : If EEMember.FilhosSF[C] <> '' then Campo := EEMember.FilhosSF[C];
                  66 : Campo := EEMember.Sala;
                  67 : Campo := EEMember.Ramal;
                  68 : Campo := EditReal(EEMember.UltSalario);
                  69 : Campo := EEMember.UltData;
                  70 : If EEMember.ChBco[C] <> '' then Campo := EEMember.ChBco[C];
                  71 : If EEMember.ChBco[C] <> '' then Campo := EEMember.Cheque[C];
                  72 : If EEMember.ChBco[C] <> '' then Campo := EditReal(EEMember.VChq[C]);
                  73 : Campo := QQStr(EEMember.SomaHF1,4,' ') + ':' + QQStr(EEMember.SomaMF1,2,'0');
                  74 : Campo := QQStr(EEMember.SomaHF2,4,' ') + ':' + QQStr(EEMember.SomaMF2,2,'0');
                  75 : Campo := EEMember.DataAvp;
                  76 : Campo := EEMember.Uniforme;
                  77 : Campo := EEMember.Calcado;
                  78 : Campo := EEMember.TipoExame;
                  79 : Campo := EEMember.DataExame;
                  80 : Campo := QQStr(EEMember.Pontos,5,'0');
                  81 : Campo := EEMember.Registro;
                  82..84 : begin
                             YYNo := '016';
                             SearchTreeY ( RootY );
                             If EEMember.Tipo = 'H'
                                then Extenso(T1,T2,T3,EditReal((EEMember.Salario * EEMember.HNormais)
                                                               + YAddress^.AcMensalV))
                                else Extenso(T1,T2,T3,EditReal(EEMember.Salario + YAddress^.AcMensalV));
			     Case C of
                                  82 : Campo := Res1;
                                  83 : Campo := Res2;
                                  84 : Campo := Res3;
                             end;
                           end;
                  85..89 : begin
                             Case C of
                                  85,86 : BBNo := LimpaChave(EEMember.BcoPg);
                                  else    BBNo := LimpaChave(EEMember.BcoFgts);
                             end;
                             SearchTree7 ( Root7 );
                             If RC = 'N' then Campo := ''
                                else begin
                                       ReadWrite(#06,'R','N',BBNumber);
                                       Case C of
                                          85,87 : Campo := BBMember.NomeBanco;
                                          86,88 : Campo := BBMember.NomeAgencia;
                                          89    : Campo := Copy(BBMember.OrigBancoC,5,Length(BBMember.OrigBancoC))
                                       end;
                                     end;
                           end;
                  90 : Campo := EEMember.Motivo;
                  91 : Campo := EEMember.CodSaque;
                  92 : Campo := EEMember.DataHomo;
                  93 : Campo := EEMember.Origem;
                  99 : Campo := EEMember.Status;
             end;
       'Q' : begin
               Val(X,K1,K2);
               If (NomeX[K1] <> '') and
                  (K1         >  0) and
                  (K1        <   5) then
                  begin
                    Case C of
                        01 : Campo := Periodo;
                        02 : Campo := MatriculaX[K1];
                        03 : Campo := NomeX[K1];
                        04 : Campo := CartaoX[K1];
                        05 : Campo := CtrabX[K1];
                        06 : Campo := CargoX[K1];
                        07..11 : If TurnoX[K1] = '' then
                                    begin
                                      Case C of
                                           07 : Campo := '';
                                           08 : Campo := 'Entrada: ' + EntradaX[K1];
                                           09 : Campo := 'Intervalo p/Ref: ' + IntRefeicaoX[K1];
                                           10 : Campo := 'Sa¡da..: ' + SaidaX[K1];
                                           11 : Campo := 'Repouso Semanal: ' + RepSemanalX[K1];
                                      end;
                                    end
                                    else begin
                                           Case C of
                                                07 : Campo := TurnoX[K1];
                                                08 : Campo := '**** Turno de:';
                                                09 : Campo := TurnoX[K1];
                                                10 : Campo := '';
                                                11 : Campo := '';
                                           end;
                                         end;
                        12 : Campo := EnderecoX[K1];
                        13 : Campo := BairroX[K1];
                        14 : Campo := CidadeX[K1];
                        15 : Campo := EstadoX[K1];
                        16 : Campo := CepX[K1];
                    end;
                  end;
             end;
       'R' : begin
               If C = 01 then
                  Repeat
                    Case TipoCChq of
                         'N' : begin
                                 RC := 'N';
                                 SearchPosY ( RootY );
                               end;
                         'C' : begin
                                 Lin := Lin + 1;
                                 If Lin < 11 then
                                    begin
                                      If ContaX[Lin] <> '' then
                                         begin
                                           YYNo := ContaX[Lin];
                                           RC   := 'S';
                                           SearchTreeY ( RootY );
                                           If RC = 'N' then RC := 'Z';
                                         end
                                         else RC := 'N';
                                    end
                                    else RC := 'N';
                               end;
                    end;
                    If RC = 'S' then
                       begin
                         CCNo := YYNo;
                         SearchTree1 ( Root1 );
                         If RC = 'S' then
                            begin
                              ReadWrite(#04,'R','N',CCNumber);
                              If (CCMember.Tipo               = Qx              ) and
                                 (TruncX(YAddress^.AcMensalV) > 0               ) and
                                 ((CCMember.Operacao   = Opc                   )  or
                                  ((CCNo               > '100'                )   and
                                   (Opc                = 'P'                  )   and
                                   (CCMember.Operacao in ['1','2','3','4','A']))) then
                                 begin
                                   Case CCMember.Tipo of
                                        'D' : Tds := Tds + TruncX(YAddress^.AcMensalV);
                                        'P' : Tpr := Tpr + TruncX(YAddress^.AcMensalV);
                                        'O' : If TipoCChq = 'C' then Tpr := Tpr + TruncX(YAddress^.AcMensalV);
                                   end;
                                   RC := 'X';
                                 end;
                            end
                            else RC := 'S';
                       end;
                    If RC = 'N' then
                       begin
                         If Qx = 'P' then
                            begin
                              RC   := 'N';
                              Qx   := 'D';
                              YYNo := '';
                            end
                            else begin
                                   Qx := '*';
                                   RC := 'X';
                                 end;
                       end;
                  Until RC = 'X';
               RC := 'S';
               If Qx in ['D','O','P'] then
                  Case C of
                       01 : Campo := CCMember.Conta;
                       02 : Campo := PushLeft(30,CCMember.Descricao);
                       03 : If (YAddress^.AcMensalH <> 0) or
                               (YAddress^.AcMensalM <> 0)
                               then Campo := QQStr(YAddress^.AcMensalH,3,' ') + ':' +
                                             QQStr(YAddress^.AcMensalM,2,'0')
                               else Campo := '      ';
                       04 : If Qx in ['O','P'] then Campo := EditReal(YAddress^.AcMensalV);
                       05 : If (Qx = 'D') and (TipoCChq = 'N') then
                               begin
                                 Campo := EditReal(YAddress^.AcMensalV);
                                 If TruncX(TDesc) = TruncX(Tds) then Qx := '*';
                               end;
                  end;
               Case C of
                    06 : Campo := Tit;
                    07 : Campo := PushLeft(40,Msg1);
                    08 : If Qx = '*' then Campo := PushLeft(40,Msg2);
                    09 : If Qx = '*' then Campo := PushLeft(40,Msg3)
               end;
               Case C of
                    10 : Campo := EditReal(Tpr);
                    11 : If TipoCChq = 'N' then Campo := EditReal(Tds);
                    12 : If Qx = '*' then
                            If TipoCChq = 'N'
                               then Campo := EditReal(VLiq)
                               else Campo := EditReal(Tpr);
                    13 : If (Opc in ['P','S']) and (TipoCChq = 'N') then
                            begin
                              If Qx = '*' then
                                 begin
                                   If Opc = 'P' then YYNo := '081'
                                                else YYNo := '085';
                                   SearchTreeY ( RootY );
                                   If RC = 'S'
                                      then Campo := EditReal(YAddress^.AcMensalV);
                                 end
                                 else Campo := '    [[ Continua ]]';
                            end;
               end;
               If (Qx = '*') and (TipoCChq = 'N') then
                  Case C of
                       14 : If Opc in ['P','S'] then
                               begin
                                 If Opc = 'P' then YYNo := '083'
                                              else YYNo := '087';
                                 SearchTreeY ( RootY );
                                 If RC = 'S'
                                    then Campo := EditReal(YAddress^.AcMensalV);
                               end;
                       15 : If Opc in ['P','S'] then
                               begin
                                 If Opc = 'P' then YYNo := '063'
                                              else YYNo := '072';
                                 SearchTreeY ( RootY );
                                 If RC = 'S'
                                    then Campo := EditReal(YAddress^.AcMensalV);
                               end;
                       16 : If Opc in ['P','S'] then
                               begin
                                 If Opc = 'P' then YYNo := '082'
                                              else YYNo := '086';
                                 SearchTreeY ( RootY );
                                 If RC = 'S'
                                    then Campo := EditReal(YAddress^.AcMensalV);
                               end;
                       17 : If Opc in ['P','S'] then
                               begin
                                 If Opc = 'P' then YYNo := '060'
                                              else YYNo := '068';
                                 SearchTreeY ( RootY );
                                 If RC = 'S'
                                    then Campo := YAddress^.QtdResc
                                    else Campo := '0';
                               end;
                  end;
             end;
  end;
end;


{$I LogTxt2.rot }

end.

