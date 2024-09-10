{$O+,F+}
Unit PlogFunc;

Interface

Uses Crt,Dos,PlogGlbs,PlogBasP,PlogTree,PlogCmpy,
             PlogDoct,PlogText,PlogMstr,PlogCalc;


   Procedure ScrollFunc;
   Procedure ScrollMovto(X,T : Char;L1,L2 : Str3);
   Procedure RecebeCodigo(L : Integer;X,T : Char);
   Procedure UpdateFunc;


Implementation


Procedure PesquisaFunc(Y : Integer;X : Char);
Var
  NomeX,NomeY         : Str40;
  NPesq,NCont,I,B,L   : Integer;
  ScArrayP            : Array [1..4000] of Char;
begin
  Move(ScArray4[1],Mem[$B800:0000],4000);
  Color(Tfn,Ttx);
  GotoXY(4,Y);   Write(ConstStr(' ',20));
  GotoXY(4,Y+1); Write('Argum.:');
  DrawBox(12,12,48,19,Red,'S');
  Color(Red,Cyan);
  Case X of
       'N' : begin
               GotoXY(12,13); Write(' Os Empregados  serÆo  selecionados ');
               GotoXY(12,14); Write(' pelo     .  Para pesquisar informe ');
               GotoXY(12,15); Write(' um conjunto de caracteres que fa‡a ');
               GotoXY(12,16); Write(' parte do nome.  As letras na forma ');
               GotoXY(12,17); Write(' mai£scula ou min£scula nÆo fazem a ');
               GotoXY(12,18); Write(' menor diferen‡a na pesquisa.       ');
               Color(Red,Yellow);
               GotoXY(18,14); Write('NOME');
             end;
       'P' : begin
               GotoXY(12,13); Write(' Os Empregados  serÆo  selecionados ');
               GotoXY(12,14); Write(' pelo    .   Para pesquisar informe ');
               GotoXY(12,15); Write(' um conjunto de caracteres que fa‡a ');
               GotoXY(12,16); Write(' parte do PIS. Todos que contiverem ');
               GotoXY(12,17); Write(' este grupo de caracteres no c¢digo ');
               GotoXY(12,18); Write(' do PIS ser„o selecionados.         ');
               Color(Red,Yellow);
               GotoXY(18,14); Write('PIS');
             end;
  end;
  J := '';
  Repeat
    K := 1;
    Repeat
      Case K of
           1  :  begin
                   InputStr(J,40,12,Y+1,0,'S','S','T','N',Sfn,Stx);
                   If TC <> #27 then
                      begin
                        If J = '' then
                           begin
                             ErroMsg  := 'Informe o argumento de pesquisa.';
                             ErrorMessage;
                           end
                           else begin
                                  J := UpCaseStr(J);
                                  GotoXY(12,Y+1); Write(PushLeft(41,J));
                                  K := 2;
                                end;
                      end;
                 end;
      end;
    Until (K = 2) or (TC = #27);
    If TC <> #27 then Confirma;
  Until TC in ['S',#27];
  If TC = 'S' then
     begin
       Color(Tfn,Ttx);
       For I := 12 to 20 do begin
                              GotoXY(12,I); Write(ConstStr(' ',40));
                            end;
       GotoXY(04,12);  Write('Matr¡c:');
       GotoXY(04,13);  Write('Nome..:');
       Case X of
            'N' : begin
                    GotoXY(04,14);  Write('Cargo.:');
                    GotoXY(04,15);  Write('Depto.:');
                  end;
            'P' : begin
                    GotoXY(04,15);  Write('PIS...:');
                  end;
       end;
       Color(Tfn,Utx);
       Move(Mem[$B800:0000],ScArrayP[1],4000);
       EENo  := '';
       NPesq := 0;
       NCont := 0;
       Color(Blue,Cyan);
       GotoXY(01,23); Write(ConstStr(' ',80));
       GotoXY(36,23); Write('Total Pesquisado --',#26);
       Repeat
         RC := 'N';
         SearchPos5 ( Root5 );
         If RC = 'S' then
            With EEMember do
            begin
              ReadWrite(#08,'R','N',EENumber);
              NPesq := NPesq + 1;
              Case X of
                   'N' : begin
                           NomeY := UpCaseStr(Nome);
                           I     := Length(Nome);
                         end;
                   'P' : begin
                           NomeY := UpCaseStr(PisPasep);
                           I     := Length(PisPasep);
                         end;
              end;
              B     := Length(J);
              L     := 0;
              TC    := 'N';
              Repeat
                L := L + 1;
                NomeX := Copy(NomeY,L,B);
                If J = NomeX then TC := 'S';
              Until (TC = 'S') or ((L+B) > I);
              If TC = 'S' then
                 begin
                   Move(ScArrayP[1],Mem[$B800:0000],4000);
                   Color(Tfn,Utx);
                   GotoXY(12,12); Write(PushLeft(9,Matricula));
                   GotoXY(12,13); Write(PushLeft(41,Nome));
                   Case X of
                        'N' : begin
                                GotoXY(12,14); Write(PushLeft(16,Cargo));
                                GotoXY(12,15); Write(PushLeft(11,Depto));
                              end;
                        'P' : begin
                                GotoXY(12,15); Write(PushLeft(21,PisPasep));
                              end;
                   end;
                   NCont := NCont + 1;
                   Color(Blue,Cyan);
                   GotoXY(01,23); Write(ConstStr(' ',80));
                   GotoXY(02,23); Write('Encontradas ',#26);
                   GotoXY(36,23); Write('Total pesquisado ',#26);
                   Color(Blue,White);
                   GotoXY(17,23); Write(NCont:5);
                   GotoXY(55,23); Write(NPesq:5);
                   Color(Red,Cyan);
                   GotoXY(01,24); Write(ConstStr(' ',80));
                   GotoXY(02,24);
                   Write('[ ] continua at‚ o Pr¢ximo,  [     ] seleciona o Empregado,  [   ] Cancela.');
                   Color(Red,Yellow);
                   GotoXY(03,24); Write(#25);
                   GotoXY(32,24); Write('Enter');
                   GotoXY(64,24); Write('Esc');
                   Color(Tfn,Utx);
                   Repeat
                     TC := ReadKey;
                     If (TC = #00) and (KeyPressed) then TC := ReadKey;
                   Until TC in [#13,#27,#80];
                   Case TC of
                        #13 : begin
                                RC   := 'N';
                                EEAC := EENo;
                                EEAN := EENumber;
                              end;
                        #27 : RC := 'N';
                   end;
                 end
                 else begin
                        Color(Blue,Yellow);
                        GotoXY(57,23); Write(NPesq:5);
                        Color(Tfn,Utx);
                      end;
            end
            else begin
                   Color(Red,Cyan);
                   GotoXY(01,24); Write(ConstStr(' ',80));
                   GotoXY(02,24); Write('Fim de Arquivo');
                   GotoXY(66,24); Write('Tecle [     ]');
                   Color(Red,Yellow);
                   GotoXY(73,24); Write('Enter');
                   Color(Tfn,Utx);
                   Repeat
                     TC := ReadKey;
                   Until TC = #13;
                 end;
         If KeyPressed then
            begin
              TC := ReadKey;
              If TC = #27 then RC := 'N';
            end;
       Until RC = 'N';
     end;
end;

Procedure MatNome;
begin
  Color(Tfn,Ttx);
  GotoXY(04,08); Write('Matr¡c:');
  GotoXY(04,09); Write('Pai...:');
  GotoXY(04,10); Write('Mae...:');
  Color(Tfn,Utx);
  GotoXY(12,08); Write(PushLeft(9,EEMember.Matricula));
end;

Procedure TitleFunc(X : Char);
begin
  Move(ScArray4[1],Mem[$B800:0000],4000);
  HelpM;
  MatNome;
  Color(Bfn,Btx);
  Case X of
       'B' : begin
               GotoXY(36,6); Write(PushLeft(41,Titulo + ' (Info. Pessoais)'));
               Color(Tfn,Ttx);
               GotoXY(04,11); Write('Endere:');
               GotoXY(04,12); Write('B/C/Es:');
               GotoXY(04,13); Write('Cep...:');
               GotoXY(04,14); Write('Telef.:');
               GotoXY(04,15); Write('DtNasc:');
               GotoXY(04,16); Write('Sexo..:');
               GotoXY(04,17); Write('Ra/Cor:');
               GotoXY(23,17); Write('Def-Fi:');
               GotoXY(04,18); Write('ECivil:');
               GotoXY(04,19); Write('Nacion:');
               GotoXY(23,19); Write('Natura:');
               GotoXY(04,20); Write('Nat/Dt:');
               GotoXY(04,21); Write('C.P.F.:');
               GotoXY(32,13); Write('C.Trab:');
               GotoXY(32,14); Write('N§ PIS:');
               GotoXY(32,15); Write('C.Iden:');
               GotoXY(35,16); Write('Reserv:');
               GotoXY(35,17); Write('Tit.El:');
               GotoXY(35,18); Write('Maneq.:');
               GotoXY(35,19); Write('Sapato:');
               GotoXY(35,20); Write('Origem:');
               GotoXY(35,21); Write('Status:');
             end;
       'F' : begin
               GotoXY(36,6); Write(PushLeft(41,Titulo + ' (Info. Funcionais)'));
               Color(Tfn,Ttx);
               GotoXY(04,11); Write('Depto.:');
               GotoXY(04,12); Write('Sindic:');
               GotoXY(04,13); Write('Dep(C):');
               GotoXY(04,14); Write('Cargo.:');
               GotoXY(04,15); Write('Escol.:');
               GotoXY(04,16); Write('DtAdm.:');
               GotoXY(04,17); Write('Tipo-E:');
               GotoXY(04,18); Write('C.B.O.:');
               GotoXY(04,19); Write('NMTrab:');
               GotoXY(04,20); Write('Opt/Dt:');
               GotoXY(04,21); Write('Vincul:');
               GotoXY(28,13); Write('T/Data:            ',ConstStr(#196,6),#191,' p/val');
               GotoXY(28,14); Write('N§.Reg:                 ',#196,#217,' exame');
               GotoXY(28,15); Write('Turno.:');
               GotoXY(28,16); Write('HorEnt:');
               GotoXY(42,16); Write('HorSai:');
               GotoXY(28,17); Write('IntRef:');
               GotoXY(28,18); Write('RepSem:');
               GotoXY(28,19); Write('Av/R/C:');
               GotoXY(28,20); Write('Pontos:       Sal/R:');
               GotoXY(28,21); Write('Status:');
             end;
       'P' : begin
               GotoXY(36,6); Write(PushLeft(41,Titulo + ' (Info.de Pagamento)'));
               Color(Tfn,Ttx);
               GotoXY(04,11); Write('Sal r.:');
               GotoXY(35,11); Write('Tp/Pag:');
               GotoXY(04,12); Write('HorNor:');
               GotoXY(04,13); Write('MesTrb:');
               GotoXY(19,13); Write('MesFer:');
               GotoXY(04,14); Write('Pg/Bco:');
               GotoXY(04,15); Write('CtaPag:');
               GotoXY(04,16); Write('BcFgts:');
               GotoXY(04,17); Write('CtFgts:');
               GotoXY(04,18); Write('%Adian:');
               GotoXY(04,19); Write('Peric.:');
               GotoXY(04,20); Write('Insal.:');
               GotoXY(04,21); Write('VT/N§D:');
               GotoXY(35,12); Write('CartÆo:');
               GotoXY(35,13); Write('DepIR.:');
               GotoXY(35,14); Write('DepSF.:');
               GotoXY(35,15); Write('Pens.A:');
               GotoXY(35,16); Write('%Pens.:');
               GotoXY(35,17); Write('Pr¢x.F:');
               GotoXY(54,17); Write('PV:');
               GotoXY(35,18); Write('D/M(?):');
               GotoXY(35,19); Write('P.Aqui:');
               GotoXY(35,20); Write('INSS..:          Fx:');
               GotoXY(35,21); Write('Status:');
             end;
  end;
  Color(Tfn,Utx);
end;


Procedure WriteStatus;
begin
  Case EEMember.Status of
       'A' : Write('Ativo       ');
       'P' : Write('Dem.Espont. ');
       'D' : Write('Demitido    ');
       'E' : Write('Entr.Tranf. ');
       'J' : Write('Justa Causa ');
       'N' : Write('T‚rm.Contr. ');
       'R' : Write('Rescindido  ');
       'F' : Write('F‚rias      ');
       'L' : Write('Licen‡a     ');
       'C' : Write('Acidentado  ');
       'M' : Write('Morte       ');
       'T' : Write('Transf.Saida');
       'V' : Write('Aviso Pr‚vio');
       'O' : Write('Aposentado  ');
       'X' : Write('Excluir Reg ');
       else  Write(EEMember.Status);
  end;
end;


Procedure DataFunc(X : Char);
begin
  With EEMember do
  begin
    Color(Tfn,Utx);
    GotoXY(12,08); Write(PushLeft(9,Matricula));
    GotoXY(21,08); Write(PushLeft(40,Nome));
    GotoXY(12,09); Write(PushLeft(41,Pai));
    GotoXY(12,10); Write(PushLeft(41,Mae));
    Case X of
         'B' : begin
                 GotoXY(12,11); Write(PushLeft(41,Endereco));
                 GotoXY(12,12); Write(PushLeft(21,Bairro));
                 GotoXY(33,12); Write(PushLeft(21,Cidade));
                 GotoXY(54,12); Write(Estado);
                 GotoXY(12,13); Write(Cep,'-',CepCompl);
                 GotoXY(12,14); Write(PushLeft(16,Telefone));
                 GotoXY(12,15); Write(DDNasc,'/',MMNasc,'/',AANasc);
                 GotoXY(23,15); Write(DiaSemana(DDNasc+'/'+MMNasc+'/'+AANasc));
                 GotoXY(12,16); Case Sexo of
                                     'F' : Write('Feminino   ',#12);
                                     'M' : Write('Masculino  ',#11);
                                end;
                 GotoXY(12,17); Case RacaCor of
                                         '1' : Write('1 Indigena');
                                         '2' : Write('2 Branca  ');
                                         '4' : Write('4 Preta   ');
                                         '6' : Write('6 Amarela ');
                                         '8' : Write('8 Parda   ');
                                         '9' : Write('9 N.Info. ');
                                end;
                 GotoXY(31,17); Case Deficiente of
                                     'N' : Write('N„o');
                                     'S' : Write('Sim');
                                end;
                 GotoXY(12,18); Case ECiv of
                                     'C'  : Write('Casado    ');
                                     'S'  : Write('Solteiro  ');
                                     'M'  : Write('Marital   ');
                                     'D'  : Write('Divorciado');
                                     'V'  : Write('Vi£vo     ');
                                     'Q'  : Write('Desquitado');
                                     else   Write(ECiv        );
                                end;
                 GotoXY(12,19); Write(Nacional);
                 GotoXY(31,19); Write(Natural);
                 GotoXY(12,20); Write(Naturalz);
                 GotoXY(16,20); Write(DataChBr);
                 GotoXY(12,21); Write(Cpf);
                 GotoXY(40,13); Write(CtrabN);
                 GotoXY(51,13); Write(CtrabS);
                 GotoXY(58,13); Write(CtrabE);
                 GotoXY(40,14); Write(PisPasep);
                 GotoXY(40,15); Write(Identidade);
                 GotoXY(43,16); Write(CertReserv);
                 GotoXY(43,17); Write(TitEleitor);
                 GotoXY(43,18); Write(Uniforme);
                 GotoXY(43,19); Write(Calcado);
                 GotoXY(43,20); Write(Origem);
                 GotoXY(43,21);
               end;
         'F' : begin
                 GotoXY(12,11); Write(Depto);
                 CDepto := Depto;
                 DDNo   := Depto;
                 SearchTree3 ( Root3 );
                 If RC = 'S' then
                    With DDMember do
                    begin
                      ReadWrite(#05,'R','N',DDNumber);
                      GotoXY(12,11); Write(Depto,' ',PushLeft(31,Copy(Descricao,1,30)));
                    end;
                 GotoXY(12,12); Write(Sindicato);
                 CSind := Sindicato;
                 SSNo  := Sindicato;
                 SearchTree2 ( Root2 );
                 If RC = 'S' then
                    With SSMember do
                    begin
                      ReadWrite(#07,'R','N',SSNumber);
                      GotoXY(15,12); Write(PushLeft(41,Descricao));
                    end;
                 GotoXY(12,13); Write(PushLeft(7,CentroC[1]));
                 GotoXY(19,13); Write(EditReal(DiasC[1]):6);
                 GotoXY(12,14); Write(PushLeft(16,Cargo));
                 GotoXY(12,15); Write(Grau);
                 GotoXY(12,16); If DDAdm <> '' then
                                   begin
                                     Write(DDAdm,'/',MMAdm,'/',AAAdm);
                                     GotoXY(23,16);
                                     Write(DiaSemana(DDAdm+'/'+MMAdm+'/'+AAAdm));
                                   end;
                 GotoXY(12,17); Case TipoE of
                                     '1' : Write('1§ Emprego   ');
                                     'R' : Write('Reemprego    ');
                                     'T' : Write('Transferˆncia');
                                     'O' : Write('Outros       ');
                                end;
                 GotoXY(12,18); Write(CBO);
                 GotoXY(12,19); Write(NoMTrab);
                 GotoXY(12,20); Case Opcao of
                                     'N' : Write('N„o');
                                     'S' : Write('Sim');
                                end;
                 GotoXY(16,20); Write(DataOpcao);
                 GotoXY(12,21); Write(Vinculo);
                 GotoXY(36,13); Write(TipoExame,' ',DataExame);
                 GotoXY(36,14); Write(Registro);
                 GotoXY(36,15); Write(Turno);
                 GotoXY(36,16); Write(Entrada);
                 GotoXY(50,16); Write(Saida);
                 GotoXY(36,17); Write(IntRefeicao);
                 GotoXY(36,18); Write(RepSemanal);
                 GotoXY(36,19); Write(DataAvp);
                 GotoXY(45,19); If DDResc <> '' then Write(DDResc,'/',
                                                           MMResc,'/',AAResc);
                 GotoXY(54,19); Write(Causa);
                 GotoXY(36,20); Write(Pontos:5);
                 GotoXY(49,20); Write(Sala);
                 GotoXY(55,20); Write(Ramal);
                 GotoXY(36,21);
               end;
         'P' : begin
                 GotoXY(12,11); Write(EditReal(Salario):12);
                 GotoXY(43,11); Case Tipo of
                                     'H' : Write('Hor/');
                                     'M' : Write('Men/');
                                     'S' : Write('Sem/');
                                     else  Write(Tipo);
                                end;
                 GotoXY(47,11); Case TipoP of
                                     'M' : Write('Mˆs   ');
                                     'S' : Write('Semana');
                                end;
                 GotoXY(12,12); Write(EditReal(HNormais):6);
                 GotoXY(12,13); Write(MesesT);
                 GotoXY(27,13); Write(MesesF);
                 CPgConta := PgConta;
                 GotoXY(12,14); Case PgConta of
                                     'C' : Write('Cheque  ');
                                     'N' : Write('Dinheiro');
                                     'S' : Write('Sim     ');
                                end;
                 CBPg := BcoPg;
                 GotoXY(16,14); Write(BcoPg);
                 GotoXY(12,15); Write(ContaPg);
                 CBFgts := BcoFgts;
                 GotoXY(12,16); Write(BcoFgts);
                 GotoXY(12,17); Write(ContaFgts);
                 GotoXY(12,18); Write(PercAdiant:5:2);
                 For I := 1 to 5 do begin
                                      GotoXY((11 + I),19); Write(Peric[I]);
                                      GotoXY((11 + I),20); Write(Insalub[I]);
                                    end;
                 GotoXY(12,21); Write(VTransporte,' ',DiasVT:2);
                 GotoXY(43,12); Write(Cartao);
                 GotoXY(43,13); Write(DepIr);
                 GotoXY(43,14); Write(DepSf);
                 GotoXY(43,15); Write(Pensao);
                 GotoXY(43,16); Write(PensaoP:5:2);
                 GotoXY(43,17); If DDFer <> '' then Write(DDFer,'/',
                                                          MMFer,'/',
                                                          AAFer);
                 GotoXY(58,17); Write(PeriodoV);
                 GotoXY(43,18); If DiaI > 0 then Write(QQStr(DiaI,2,'0'),'/',
                                                       QQStr(MesI,2,'0'));
                 GotoXY(49,18); If DiaF > 0 then Write('a ',QQStr(DiaF,2,'0'),'/',
                                                       QQStr(MesF,2,'0'));
                 GotoXY(43,19); Write(DDPAq,'/',MMPAq,'/',AAPAq);
                 GotoXY(55,19); Write(DiaSemana(DDPAq+'/'+MMPAq+'/'+AAPAq));
                 GotoXY(43,20); If INSS[1] = 'N' then Write('N„o')
                                                 else Write('Sim');
                 GotoXY(56,20); If FxINSS > 0 then Write(FxINSS:2);
                 GotoXY(47,20);
                 Case INSS[2] of
                      'C' : Write('Coop.');
                      'N' : Write('NÆo  ');
                      'S' : Write('Sim  ');
                 end;
                 GotoXY(43,21);
               end;
    end;
    WriteStatus;
  end;
end;

{$I PlogBasi.Inc }
{$I PlogFunc.Inc }
{$I PlogPagt.Inc }


Procedure IncluiFunc;
begin
  With EEMember do
  begin
    Op          := 'I';
    Status      := 'A';
    Matricula   := EEno;
    Nome        := '';
    Pai         := '';
    Mae         := '';
    Endereco    := '';
    Cidade      := '';
    Bairro      := '';
    Estado      := '';
    Cep         := '';
    CepCompl    := '';
    Telefone    := '';
    AANasc      := '';
    MMNasc      := '';
    DDNasc      := '';
    Sexo        := ' ';
    Eciv        := ' ';
    Nacional    := '';
    Natural     := '';
    Naturalz    := ' ';
    DataChBr    := '';
    Cpf         := '';
    CtrabN      := '';
    CTrabS      := '';
    CTrabE      := '';
    PisPasep    := '';
    Identidade  := '';
    CertReserv  := '';
    TitEleitor  := '';
    Sindicato   := '';
    Depto       := '';
    Cargo       := '';
    CBO         := '';
    ExAnt       := '**';
    Grau        := '';
    Vinculo     := '';
    AAAdm       := '';
    MMAdm       := '';
    DDAdm       := '';
    AAPAq       := '';
    MMPAq       := '';
    DDPAq       := '';
    TipoE       := ' ';
    Opcao       := 'S';
    DataOpcao   := '';
    NoMTrab     := '';
    Entrada     := '';
    IntRefeicao := '';
    Saida       := '';
    RepSemanal  := '';
    Turno       := '';
    AAResc      := '';
    MMResc      := '';
    DDResc      := '';
    DataAvP     := '';
    DataHomo    := '';
    Causa       := '';
    Motivo      := '';
    CodSaque    := '';
    Salario     := 0;
    Tipo        := ' ';
    TipoP       := 'M';
    HNormais    := 0;
    MesesT      := 0;
    MesesF      := 0;
    PgConta     := 'S';
    BcoPg       := '';
    ContaPg     := '';
    BcoFgts     := '';
    ContaFgts   := '';
    PercAdiant  := 0;
    For I := 1 to 5 do begin
                         Peric[I]    := 'N';
                         Insalub[I]  := 'N';
                         DtNascSF[I] := '';
                         FilhosSF[I] := '';
                         CentroC[I]  := '';
                         DiasC[I]    := 0;
                       end;
    For I := 1 to 6 do begin
                         Passagens[I] := 0;
                         Faixa[I]     := 0;
                       end;
    DiasVT      := 0;
    VTransporte := 'N';
    DepIR       := 0;
    DepSF       := 0;
    Pensao      := ' ';
    PensaoP     := 0;
    AAFer       := '';
    MMFer       := '';
    DDFer       := '';
    Cartao      := '';
    PeriodoV    := 0;
    DiaI        := 0;
    MesI        := 0;
    DiaF        := 0;
    MesF        := 0;
    FaltasNJ    := 0;
    Sala        := '';
    Ramal       := '';
    UltSalario  := 0;
    UltData     := '';
    For I := 1 to 7 do begin
                         ChBco[I]  := '';
                         Cheque[I] := '';
                         VChq[I]   := 0;
                       end;
    SomaHF1     := 0;
    SomaMF1     := 0;
    SomaHF2     := 0;
    SomaMF2     := 0;
    INSS[1]     := 'N';
    INSS[2]     := 'S';
    FxINSS      := 0;
    Uniforme    := '';
    Calcado     := '';
    TipoExame   := ' ';
    DataExame   := '';
    Pontos      := 0;
    RacaCor     := '2';
    Deficiente  := ' ';
    Registro    := '';
    Origem      := '';
    For I := 1 to 9 do Movimento[I] := Limite;
    Tl          := 'N';
    Op          := 'I';
    K           := 1;
    Repeat
      Case K of
           1 : EntryPFunc;
           2 : EntryFFunc;
           3 : EntryAFunc;
      end;
    Until (K = 1000) or (TC = #27);
    If TC = 'S' then
       begin
         Color(Blue,White);
         GotoXY(1,24); Write(ConstStr(' ',80));
         GotoXY(2,24); Write('Desconta Contribui‡„o Sindical (S ou N)?');
         Color(Blue,Yellow);
         GotoXY(34,24); Write('S');
         GotoXY(39,24); Write('N');
         Repeat
           TC := UpCase(ReadKey);
         Until TC in [#27,'S','N'];
         If TC = 'S' then
            begin
              LiberaMVDsk;
              YYNo := '050';
              SearchTreeY ( RootY );
              If RC = 'N' then LoadTreeY ( RootY );
              YAddress^.Origem := 'U';
              If EEMember.Tipo = 'H'
                 then YAddress^.AcMensalV := (EEMember.Salario * EEMember.HNormais) / 30
                 else YAddress^.AcMensalV := EEMember.Salario / 30;
              UnLoadMVDsk;
              LiberaMVDsk;
              RC := 'S';
            end;
         LimpaLn(24,Tfd);
         TC := 'S';
       end;
    Move(ScArray4[1],Mem[$B800:0000],4000);
    If TC = 'S' then
       With EEMember do
       begin
         D2 := 'S';
         ReadWrite(#08,'W','N',EENumber);
         ENMember.Empregado := EENo;
         For I := 1 to 48 do begin
                               ENMember.MMAA[I] := '';
                               ENMember.SalC[I] := 0;
                               ENMember.VRec[I] := 0;
                             end;
         ReadWrite(#12,'W','N',EENumber);
         LoadTree5 ( Root5 );
         CMstMember.NFunc := CMstMember.NFunc + 1;
         ReadWrite(#16,'W','N',0);
         ShowHeap;
         Color(Red,Yellow);
         GotoXY(53,07); Write(CMstMember.NFunc);
         Color(Tfn,Utx);
         Move(Mem[$B800:0000],ScArray4[1],4000);
         Opt  := 'P';
         Resp := #59;
       end
       else begin
              EENumber := Limite;
              TC       := #13;
            end;
  end;
end;


Procedure MoveParaArrayE(L : Integer);
begin
  ReadWrite(#08,'R','N',EENumber);
  KArray[L] := EEMember.Matricula;
  RArray[L] := EENumber;
  NArray[L] := PushLeft(41,EEMember.Nome) + EEMember.Status;
end;


Procedure ArrayParaArrayE(D,P : Integer);
begin
  KArray[P] := KArray[D];
  RArray[P] := RArray[D];
  NArray[P] := NArray[D];
end;


Procedure ScrollFunc;
Var
   ScArrayS       : Array [1..4000] of Char;
begin
  Move(Mem[$B800:0000],ScArrayS[1],4000);
  FootScroll;
  DrawBox(16,11,69,20,Sfn,'S');
  Color(Bfn,Btx);
  GotoXY(16,11); Write(' Matr¡cula Nome                                     ? ');
  Color(Sfn,Stx);
  EEAN    := EENumber;
  EEAC    := EENo;
  Tkb     := 'L';
  F       := 'N';
  Direcao := 'P';
  L       := 0;
  Sx      := 1;
  For I := 1 to 7 do begin
                       KArray[I] := '';
                       RArray[I] := 0;
                       NArray[I] := '';
                     end;
  RC := 'N';
  SearchAnt5 ( Root5 );
  If RC = 'N' then EENo := '';
  Repeat
    RC := 'N';
    SearchPos5 ( Root5 );
    If RC = 'S' then
       begin
         L := L + 1;
         MoveParaArrayE(L);
       end
       else L := 7;
  Until L = 7;
  Repeat
    Window(16,13,70,20);
    For I := 1 to 7 do If KArray[I] <> '' then
                          begin
                            If I = Sx then Color(Tfn,Utx)
                                      else Color(Sfn,Stx);
                            GotoXY(1,I);
                            Writeln(' ',PushLeft(10,KArray[I]),
                                        PushLeft(43,NArray[I]));
                            Color(Sfn,Stx);
                          end;
    Window(1,1,80,25);
    Cont := ReadKey;
    If (Cont  = #0) and
       (KeyPressed) then ScrollDir
                    else Direcao := 'N';
    Case Direcao of
         'A' : If F <> 'A' then
                  begin
                    If (Tkb = 'L') and (Sx > 1 ) then
                       begin
                         Sx := Sx - 1;
                         F  := 'N';
                       end
                       else begin
                              Case Tkb of
                                   'L' : N := 6;
                                   'P' : N := 0;
                              end;
                              Sx := 1;
                              Repeat
                                RC   := 'N';
                                EENo := KArray[1];
                                SearchAnt5 ( Root5 );
                                If RC = 'S' then
                                   begin
                                     For I := 7 downto 2
                                     do ArrayParaArrayE((I - 1),I);
                                     MoveParaArrayE(1);
                                     F := 'N';
                                     N := N + 1;
                                   end
                                   else F := 'A';
                              Until (N = 7) or (RC = 'N');
                            end;
                  end;
         'P' : If F <> 'P' then
                  begin
                    If (Tkb = 'L') and (Sx < 7) then
                       begin
                         If KArray[Sx + 1] <> '' then
                            begin
                              Sx := Sx + 1;
                              F  := 'N';
                            end
                            else F := 'P';
                       end
                       else begin
                              Case Tkb of
                                   'L' : begin
                                           N := 6;
                                           R := 7;
                                         end;
                                   'P' : begin
                                           Sx := 1;
                                           N  := 0;
                                           R  := 7;
                                           For L := 1 to 7
                                           do If KArray[L] <> '' then R := L;
                                         end;
                              end;
                              Repeat
                                EENo := KArray[R];
                                RC   := 'N';
                                SearchPos5 ( Root5 );
                                If RC = 'S' then
                                   begin
                                     For I := 2 to 7
                                     do ArrayParaArrayE(I,(I - 1));
                                     MoveParaArrayE(R);
                                     N := N + 1;
                                     F := 'N';
                                   end
                                   else F := 'P';
                              Until (N = 7) or (RC = 'N');
                              If Tkb = 'P' then F := 'N';
                            end;
                  end;
    end;
    If ((F <> 'N') or (N < 7)) and (Cont in [#72,#73,#80,#81]) then ScrollFim;
  Until Cont in [#13,#27];
  Move(ScArrayS[1],Mem[$B800:0000],4000);
  Color(Tfn,Utx);
  If Cont = #13 then
     begin
       EEAN := RArray[Sx];
       EEAC := KArray[Sx];
     end;
  RC := 'S';
end;


{$I PlogMovt.inc }


Procedure ImprimeH;
Var
  L     : AnyStr;
begin
  If Laser = 'S' then WriteLine('W',LaserInit);
  ContPag := 0;
  ContLin := 1000;
  HHNo    := EENo + '#';
  Repeat
    RC := 'N';
    SearchPos10 ( Root10 );
    If (RC   = 'S'                      ) and
       (EENo = Copy(HHNo,1,Length(EENo))) then
       begin
         ReadWrite(#10,'R','N',HHNumber);
         If (RW             = 'S') and
            (HHMember.Tipo <> '*') then
            begin
              If ContLin > 56 then
                 begin
                   ContPag := ContPag + 1;
                   With CMstMember do
                   begin
                     If Laser = 'S' then WriteLine('W',LaserInit)
                                    else If ContLin < 1000 then WriteLine('W',Qp);
                     L       := Dx+Acentua(Descricao)+Df;
                     ContLin := 0;
                     WriteLine('L',L);
                     WriteLine('L',ConstStr('-',80));
                     WriteLIne('L',Cx+Acentua(Endereco)+', '+Numero+' '+
                                   Acentua(Cidade)+', '+Estado+
                                   '  Cep: '+Cep+Cf);
                   end;
                   WriteLine('L',ConstStr(' ',66)+'Pag.: '+
                                 PushRight(8,EditInteger(Contpag)));
                   WriteLine('L',Nx+'Historicos Pessoais  '+Nf+
                                 ConstStr(' ',45)+'Data: '+
                                 XDia+'/'+XMes+'/'+XAno);
                   WriteLine('L',' ');
                   WriteLine('L',Acentua('Matr¡cula.........: ')+EEMember.Matricula);
                   WriteLine('L','Nome..............: '+Acentua(EEMember.Nome));
                   WriteLine('L',Acentua('Data de Admiss„o..: ')+
                                 EEMember.DDAdm+'/'+
                                 EEMember.MMAdm+'/'+
                                 EEmember.AAAdm);
                   WriteLine('L','Cargo.............: '+Acentua(EEMember.Cargo));
                   WriteLine('L','Departamento......: '+EEMember.Depto);
                   WriteLine('L',' ');
                   WriteLine('L',ConstStr('-',80));
                   WriteLine('L','--Data-- '+Acentua('Descri‡„o')+
                                 ConstStr(' ',50)+Acentua('Novo Sal rio'));
                   WriteLine('L',ConstStr('-',80));
                   WriteLine('L',' ');
                 end;
              If HHMember.Tipo = 'S'
                 then WriteLine('L',HHMember.OrigData+' '+
                                    Acentua(HHMember.Motivo)+
                                    ConstStr(' ',51-Length(HHMember.Motivo))+
                                    PushRight(20,EditReal(HHMember.Salario)))
                 else WriteLine('L',HHMember.OrigData+' '+Acentua(HHMember.Motivo));
            end;
       end
       else RC := 'N';
    If KeyPressed then
       begin
         TC := ReadKey;
         If TC = #13 then
            Repeat
              TC := ReadKey;
            Until TC in [#13,#27];
       end;
  Until (RC = 'N') or (TC = #27);
  If ContLin <> 1000 then If DskRpt = 'N' then WriteLine('W',Qp);
end;


Procedure RecebeCodigo(L : Integer;X,T : Char);
Var
  ScArray7      : Array [1..4000] of Char;
begin
  Color(Blue,White);
  GotoXY(1,23); Write(ConstStr(' ',80));
  GotoXY(2,23); Write('F1');
  Color(Blue,Cyan);
  GotoXY(5,23); Write('para selecionar Empregados via Janela.');
  Color(Red,Yellow);
  GotoXY(1,24); Write(ConstStr(' ',80));
  GotoXY(2,24); Write('F2');
  Color(Red,Cyan);
  GotoXY(5,24); Write('para selecionar Empregados pelo Nome.');
  If T = 'P' then
     begin
       GotoXY(42,24); Write('ou    para selecionar pelo PIS.');
       Color(Red,Yellow);
       GotoXY(45,24); Write('F3');
     end;
  J := EENo;
  InputStr(J,8,12,L,0,'S','N','T','N',Tfn,Utx);
  LimpaLn(23,Tfd);
  LimpaLn(24,Tfd);
  Case TC of
       #13 : If J <> '' then
                begin
                  EENo := J;
                  SearchTree5 ( Root5 );
                  If RC = 'N' then
                     begin
                       EENumber := Limite;
                       If X = 'C' then
                          begin
                            ErroMsg  := 'Empregado NÆo existe';
                            ErrorMessage;
                          end
                          else Resp := 'I';
                     end
                     else Resp := #72;
                end
                else begin
                       EENumber := Limite;
                       Resp     := #00;
                     end;
       #21 : begin
               EENo := J;
               EEAC := '';
               ScrollFunc;
               If EEAC <> '' then
                  begin
                    EENo := EEAC;
                    SearchTree5 ( Root5 );
                    If RC = 'N' then EENumber := Limite
                                else Resp     := #72;
                  end
                  else EENumber := Limite;
             end;
       #22,#23 : begin
                   Move(Mem[$B800:0000],ScArray7[1],4000);
                   EEAC := '';
                   Case TC of
                        #22 : PesquisaFunc(L,'N');
                        #23 : If T = 'P' then PesquisaFunc(L,'P');
                   end;
                   If EEAC <> '' then
                      begin
                        EENo := EEAC;
                        SearchTree5 ( Root5 );
                        If RC = 'N' then EENumber := Limite
                                    else Resp     := #72;
                      end
                      else EENumber := Limite;
                   Move(ScArray7[1],MemW[$B800:0000],4000);
                 end;
       #24: begin
               EENo := '99999999';
               RC   := 'N';
               SearchAnt5 ( Root5 );
               If RC = 'N' then EENumber := Limite
                           else Resp     := #72;
             end;
       #25 : begin
               EENo := '';
               RC   := 'N';
               SearchPos5 ( Root5 );
               If RC = 'N' then EENumber := Limite
                           else Resp     := #72;
             end;
       #27 : begin
               EENumber := Limite;
               Resp     := ' ';
             end;
  end;
end;

Function TipoVale(X : Char):Str6;
begin
  Case X of
       'B' : TipoVale := 'Barca';
       'M' : TipoVale := 'Metr“';
       'O' : TipoVale := 'Onibus';
       'F' : TipoVale := 'Fixo';
       else  TipoVale := '';
  end;
end;

Procedure MostraFaixaVale(X : Char);
begin
  If I < 4 then GotoXY(18,(13+I))
           else GotoXY(43,(10+I));
  Write(EEMember.Faixa[I]:2,' ',
        PushLeft(7,TipoVale(TTMember.TPass[EEMember.Faixa[I]])),
        EditReal(TTMember.VPass[EEMember.Faixa[I]]):8);
  If X = 'S' then
     begin
       If I < 4 then GotoXY(37,(13+I))
                else GotoXY(62,(10+I));
       Write(EEMember.Passagens[I]:4);
     end;
end;

Procedure ValeTransp;
Var
  Tipo    : Str6;
begin
  Move(Mem[$B800:0000],ScArray5[1],4000);
  LimpaLn(23,Tfd);
  DrawBox(16,11,67,17,Bfn,'S');
  Color(Bfn,Btx);
  GotoXY(25,11); Write('   Quantidade di ria de Passagens');
  Color(Sfn,Stx);
  GotoXY(17,12); Write(' Fx Tipo   V.Tarifa  N§.  Fx Tipo   V.Tarifa  N§. ');
  Color(Bfn,Btx);
  For I := 1 to 6 do If EEMember.Faixa[I] <> 0 then MostraFaixaVale('S');
  If XSt = 'A' then
     begin
       Repeat
         I := 1;
         Repeat
           If EEMember.Faixa[I] = 0 then J := ''
                                    else begin
                                           Str(EEMember.Faixa[I]:2,J);
                                           J := LeftAdjust(J);
                                         end;
           If I < 4 then InputStr(J,2,18,(13+I),0,'S','N','T','N',Bfn,Btx)
                    else InputStr(J,2,43,(10+I),0,'S','N','T','N',Bfn,Btx);
           If J <> '' then
              begin
                Val(J,EEMember.Faixa[I],E);
                If (TC                 = #13) and
                   (EEMember.Faixa[I] <> 0  ) then
                   begin
                     MostraFaixaVale('N');
                     If EEMember.Passagens[I] = 0 then J := ''
                        else begin
                               Str(EEMember.Passagens[I]:4,J);
                               J := LeftAdjust(J);
                             end;
                     If I < 4 then InputStr(J,4,37,(13+I),0,'S','N','T','N',Bfn,Btx)
                              else InputStr(J,4,62,(10+I),0,'S','N','T','N',Bfn,Btx);
                     If J = '' then EEMember.Passagens[I] := 0
                               else Val(J,EEMember.Passagens[I],E);
                     MostraFaixaVale('S');
                   end;
              end
              else begin
                     EEMember.Faixa[I]     := 0;
                     EEMember.Passagens[I] := 0;
                     If I < 4 then GotoXY(29,(13+I))
                              else GotoXY(49,(10+I));
                     Write(' ':18);
                     I  := 6;
                     TC := #13;
                   end;
           Case TC of
                #13 : I := I + 1;
                #24 : If I > 1 then I := I - 1;
           end;
         Until (I = 7) or (TC = #27);
         Confirma;
       Until (TC = 'S') or (TC = #27);
       If TC = 'S' then
          begin
            T := 0;
            For I := 1 to 6 do T := T + EEMember.Passagens[I];
            If T = 0 then
               begin
                 EEMember.VTransporte := 'N';
                 EEMember.DiasVT      := 0;
               end;
            ReadWrite(#08,'W','N',EENumber);
          end
          else TC := #13;
     end
     else TeclaReturn;
  Move(ScArray5[1],Mem[$B800:0000],4000);
end;


Procedure UpdateFunc;
begin
  Opt  := 'B';
  EENo := '';
  Repeat
    Move(ScArray4[1],Mem[$B800:0000],4000);
    RecebeCodigo(8,'U','N');
    If (EENumber = Limite) and (XSt = 'A') and (Resp = 'I') then
       begin
         EENumber := FileSize(EEFile);
         IncluiFunc;
       end;
    If EENumber <> Limite then
       begin
         Repeat
           If (Resp in [#59,#64,#65,#66,#72,#80,#84]) and (RC = 'S') then
              begin
                ReadWrite(#08,'R','N',EENumber);
                TitleFunc(Opt);
                DataFunc(Opt);
              end;
           Resp := ReadKey;
           LimpaLn(24,Tfd);
           If (Resp = #0) and (KeyPressed) then
              begin
                Resp := ReadKey;
                Case Resp of
                     #59 : begin
                             EEAC := EENo;
                             EEAN := EENumber;
                             ScrollFunc;
                             EENumber := EEAN;
                             EENo     := EEAC;
                           end;
                     #60 : begin
                             Move(Mem[$B800:0000],ScArray5[1],4000);
                             TrocaMedias;
                             Move(ScArray5[1],Mem[$B800:0000],4000);
                             If TC = 'S' then ReadWrite(#08,'W','N',EENumber);
                           end;
                     #61 : If XSt = 'A' then
                              begin
                                Op := 'A';
                                Tl := 'S';
                                Case Opt of
                                     'B' : EntryPFunc;
                                     'F' : EntryFFunc;
                                     'P' : EntryAFunc;
                                end;
                                If TC = 'S' then ReadWrite(#08,'W','N',EENumber);
                              end;
                     #62,#63 : begin
                                 If RootY = NIL then LoadMVDsk(#11);
                                 If RootY <> NIL then
                                    begin
                                      Case Resp of
                                           #62 : ScrollMovto('A','T','','');
                                           #63 : ScrollMovto('M','T','','');
                                      end;
                                      UnLoadMVDsk;
                                      RC := 'S';
                                    end
                                    else begin
                                           Color(Blue,White);
                                           GotoXY(1,23); Write(ConstStr(' ',80));
                                           GotoXY(2,23); Write('NÆo h  lan‡amentos');
                                           Color(Sfn,Stx);
                                           TeclaReturn;
                                           LimpaLn(23,Tfd);
                                           RC := 'S';
                                         end;
                               end;
                     #64 : begin
                             Opt := 'B';
                             RC  := 'S';
                           end;
                     #65 : begin
                             Opt := 'F';
                             RC  := 'S';
                           end;
                     #66 : begin
                             Opt := 'P';
                             RC  := 'S';
                           end;
                     #67 : begin
                             HHNo := EENo + '#';
                             RC   := 'N';
                             SearchPos10 ( Root10 );
                             If (RC   = 'S'                      ) and
                                (EENo = Copy(HHNo,1,Length(EENo)))
                                then ScrollHist
                                else begin
                                       Color(Blue,White);
                                       GotoXY(1,23); Write(ConstStr(' ',80));
                                       GotoXY(2,23); Write('NÆo h  hist¢ricos');
                                       Color(Sfn,Stx);
                                       TeclaReturn;
                                       LimpaLn(23,Tfd);
                                       RC := 'S';
                                     end;
                           end;
                     #68 : ValeTransp;
                     #72,#80 : begin
                                 RC := 'N';
                                 Case Resp of
                                      #72 : SearchAnt5 ( Root5 );
                                      #80 : SearchPos5 ( Root5 );
                                 end;
                                 If RC = 'N' then AvisoFinal;
                               end;
                     #84 : OrdemServ;
                     #85 : If EEMember.Status in ['A','C','E','F','L','T','V'] then
                              begin
                                Eta := CMstMember.Etapa;
                                Case Eta of
                                  '1','2','3','4','A' : RecebeAdiantamento('U');
                                  'P'                 : RecebePagamento   ('U');
                                  'S','O'             : Recebe13Salario   ('U');
                                end;
                                If TC = 'S' then
                                   begin
				     TProv := 0;
                                     TDesc := 0;
                                     Mx    := Copy(MMFx,2,2);
                                     Ax    := AAFx;
                                     Color(Bfn,Btx);
                                     GotoXY(01,23); Write(ConstStr(' ',80));
                                     GotoXY(02,23); Write('Refazendo os c lculos,        .');
                                     GotoXY(57,23); Write('(              )');
                                     Color(Bfn,Yellow);
                                     GotoXY(25,23); Write('Aguarde');
                                     Color(Bfn,White);
                                     GotoXY(59,23);
                                     Case Eta of
                                       '1','2','3','4','A' : Write('Adiantamento');
                                       'P'                 : Write('Pagamento   ');
                                       'S','O'             : Write('13§ Sal rio ');
                                     end;
                                     LoadMVDsk(#11);
                                     Case Eta of
                                       '1','2','3','4','A' : Adiantamento('U');
                                       'P'                 : Pagamentos  ('U');
                                       'S','O'             : If (EEMember.Vinculo[1] <> 'A') and
                                                                (EEMember.Vinculo[1] <> 'N') then D13Salario  ('U');
                                     end;
                                     UnLoadMVDsk;
                                   end;
                                LimpaLn(23,Tfd);
                                RC := 'S';
                              end;
                     #86 : begin
                             MostraCheque;
                             Move(ScArray4[1],Mem[$B800:0000],4000);
                           end;
                     #87 : begin
                             LoadMVDsk(#11);
                             PrintText('TXT');
                             LiberaMVDsk;
                             RC := 'S';
                           end;
                     #88 : begin
                             QPorta;
                             If TC <> #27 then
                                begin
                                  TestaImpressora('I','Hist¢ricos');
                                  ImprimeH;
                                  Close ( LST );
                                end;
                             LimpaLn(24,Tfd);
                             RC := 'S';
                             TC := 'S';
                           end;
                     #89 : begin
                             Move(Mem[$B800:0000],ScArray5[1],4000);
                             DrawBox(10,15,57,17,Red,'S');
                             Color(Red,Yellow);
                             GotoXY(11,16);
                             Write('Ult.Sal.:');
                             GotoXY(35,16); Write('Valido ate ');
                             Color(Red,White);
                             GotoXY(21,16); Write(EditReal(EEMember.UltSalario));
                             GotoXY(47,16); Write(EEMember.UltData);
                             TeclaReturn;
                             Move(ScArray5[1],Mem[$B800:0000],4000);
                           end;
                     #90 : TrocaChave;
                     #91 : begin
                             Move(Mem[$B800:0000],ScArray5[1],4000);
                             TrocaCheque;
                             If TC = 'S' then ReadWrite(#08,'W','N',EENumber);
                             Move(ScArray5[1],Mem[$B800:0000],4000);
                           end;
                     #94 : HelpManual;
                end;
              end
              else If Resp = '?' then
                      begin
                        Color(Red,White);
                        GotoXY(01,24); Write(ConstStr(' ',80));
                        GotoXY(02,24); Write('Shift+');
                        GotoXY(10,24); Write(#26);
                        GotoXY(19,24); Write(#26);
                        GotoXY(33,24); Write(#26);
                        GotoXY(43,24); Write(#26);
                        GotoXY(57,24); Write(#26);
                        GotoXY(71,24); Write(#26);
                        Color(Red,Yellow);
                        GotoXY(08,24); Write('F1');
                        GotoXY(17,24); Write('F2');
                        GotoXY(31,24); Write('F3');
                        GotoXY(41,24); Write('F4');
                        GotoXY(55,24); Write('F5');
                        GotoXY(69,24); Write('F6');
                        Color(Red,LightGray);
                        GotoXY(11,24); Write('O.S.');
                        GotoXY(20,24); Write('Recalcular');
                        GotoXY(34,24); Write('Recibo');
                        GotoXY(44,24); Write('Impr.Texto');
                        GotoXY(58,24); Write('Impr.Hist.');
                        GotoXY(72,24); Write('Ult.Sal.');
                      end
                      else TC := #27;
         Until (TC = #27);
       end
       else Resp := #27;
  Until Resp = #27;
end;

end.