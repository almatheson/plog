{$O+,F+}
Unit PlogRpt1;

Interface

Uses Crt,Dos,PlogGlbs,PlogBasP,PlogTree,PlogRpt0;


   Procedure ProcNo02Report;
   Procedure ProcNo03Report;
   Procedure ProcNo04Report;
   Procedure ProcNoEEReport;


Implementation

Procedure ProcNo02Report;
begin
  PedeCadastro;
  If TC = 'S' then
     begin
       If Opc = 'P' then L1 := Nx+'Planilha de Movimento'+Nf
                    else L1 := Nx+'Ficha Cadastral'+Nf;
       If Opc = 'P' then L6 := 'Periodo:';
       If EENo <> '' then Tr := 'N';
       LoadIndex6 ('E',Tr);
       If TC <> #27 then
          begin
            ParaContinua;
            Janela('F');
            EEAC := EENo;
            XXNo := EENo;
            If XXNo <> '' then
               begin
                 RC := 'N';
                 SearchAnt6 ( Root6 );
                 If RC = 'N' then XXNo := '';
               end;
            Repeat
              RC := 'N';
              SearchPos6 ( Root6 );
              If RC = 'S' then
                 With EEMember do
                 begin
                   NCont := NCont + 1;
                   ReadWrite(#08,'R','N',XXNumber);
                   Writeln(Nome);
                   If Opc = 'C' then
                      begin
                        HeaderReport;
                        WriteLine('L',Nx+EENo+Nf+' '+Acentua(Nome));
                        WriteLine('L',' ');
                        WriteLine('L',ConstStr('.',05)+Acentua('Endere‡o..: ')+
                                      Acentua(Endereco));
                        WriteLine('L',ConstStr(' ',5)+'Bairro....: '+Acentua(Bairro));
                        WriteLine('L',ConstStr(' ',5)+'Cidade....: '+
                                      Acentua(Cidade)+' '+Estado+' '+
                                      Cep+'-'+CepCompl);
                        WriteLine('L',ConstStr(' ',5)+'Telefone..: '+Telefone);
                        WriteLine('L',ConstStr(' ',5)+'Data Nasc.: '+
                                      DDNasc+'/'+MMNasc+'/'+AANasc);
                        WriteLine('L',ConstStr(' ',5)+'Sexo......: '+Sexo);
                        WriteLine('L',ConstStr(' ',5)+'Est.Civil.: '+Eciv);
                        WriteLine('L',ConstStr(' ',5)+'Nacional..: '+Nacional);
                        WriteLine('L',ConstStr(' ',5)+'Natural...: '+Natural);
                        WriteLine('L',ConstStr(' ',5)+'Naturaliz.: '+
                                      Naturalz+' '+DataChBr);
                        WriteLine('L',ConstStr(' ',5)+'CPF.......: '+Cpf);
                        WriteLine('L',ConstStr(' ',5)+'Cart.Trab.: '+
                                      CtrabN+' '+CtrabS+' '+CtrabE);
                        WriteLine('L',ConstStr(' ',5)+'Pis/Pasep.: '+PisPasep);
                        WriteLine('L',ConstStr(' ',5)+'Identidade: '+Identidade);
                        WriteLine('L',ConstStr(' ',5)+'Cert.Reser: '+CertReserv);
                        WriteLine('L',ConstStr(' ',5)+'Tit.Eleit.: '+TitEleitor);
                        WriteLine('L',ConstStr(' ',5)+'Vestu rio.: '+PushLeft(15,Uniforme)+
                                      'Cal‡ado: '+Calcado);
                        WriteLine('L',ConstStr(' ',5)+'Filhos....: '+PushLeft(11,DtNascSF[1])+
                                      Acentua(FilhosSF[1]));
                        For I := 2 to 5 do If DtNascSf[I] <> ''
                        then WriteLine('L',ConstStr(' ',17)+PushLeft(11,DtNascSF[I])+
                                                            Acentua(FilhosSF[I]));
                        WriteLine('L',ConstStr('.',5)+'Departamen: '+Depto);
                        WriteLine('L',ConstStr(' ',5)+'Local/C.C.: '+CentroC[1]);
                        WriteLine('L',ConstStr(' ',5)+'Cargo.....: '+Acentua(Cargo));
                        WriteLine('L',ConstStr(' ',5)+'C.B.O.....: '+CBO);
                        WriteLine('L',ConstStr(' ',5)+'Grau Instr: '+Grau);
                        WriteLine('L',ConstStr(' ',5)+'Vinc.Empr.: '+Vinculo);
                        WriteLine('L',ConstStr(' ',5)+'Dta de Adm: '+
                                      DDAdm+'/'+MMAdm+'/'+AAAdm+
                                      ConstStr(' ',5)+'P.Aquisitivo: '+
                                      DDPAq+'/'+MMPAq+'/'+AAPAq);
                        Case TipoE of
                             '1' : WriteLine('L',ConstStr(' ',5)+'Tipo Empr.: '+
                                                'Primeiro emprego');
                             'R' : WriteLine('L',ConstStr(' ',5)+'Tipo Empr.: '+
                                                'Reemprego');
                             'T' : WriteLine('L',ConstStr(' ',5)+'Tipo Empr.: '+
                                                Acentua('Transferˆncia'));
                        end;
                        WriteLine('L',ConstStr(' ',5)+'Optante...: '+Opcao+' '+
                                      DataOpcao);
                        WriteLine('L',ConstStr(' ',5)+'Reg.M.Trab: '+NoMTrab);
                        WriteLine('L',ConstStr(' ',5)+'Turno.....: '+Acentua(Turno));
                        WriteLine('L',ConstStr(' ',5)+Acentua('Hor rio...: ')+
                                      Entrada+' '+IntRefeicao+' '+
                                      Saida+' '+RepSemanal);
                        WriteLine('L',ConstStr(' ',5)+Acentua('No.Cart„o.: ')+Cartao);
                        If DDResc <> ''
                           then WriteLine('L',ConstStr(' ',5)+'Dta.Demiss: '+
                                              DDResc+'/'+MMResc+'/'+
                                              AAResc+' '+Causa);
                        WriteLine('L',ConstStr(' ',5)+'Sindicato.: '+Sindicato);
                        WriteLine('L',ConstStr('.',05)+Acentua('Sal rio...: ')+
                                      EditReal(Sal)+'  ( '+Tipo+' )   '+
                                      'Horas Norm: '+EditReal(HNormais));
                        WriteLine('L',ConstStr(' ',5)+'Meses Trab: '+PushLeft(5,EditInteger(MesesT))+
                                      Acentua('Meses F‚r.: ')+EditInteger(MesesF));
                        WriteLine('L',ConstStr(' ',5)+'Pag.Conta.: '+PgConta+
                                      '  Bco.Pg..: '+PushLeft(11,BcoPg)+
                                      '  C/Corr..: '+ContaPg);
                        WriteLine('L',ConstStr(' ',5)+'Banco Fgts: '+PushLeft(11,BcoFgts)+
                                      '  Cta.Fgts: '+ContaFgts);
                        Str(PercAdiant:5:2,J);
                        WriteLine('L',ConstStr(' ',5)+'Adiantam..: '+J+'%');
                        WriteLine('L',ConstStr(' ',5)+'Perculosid: '+
                                      Peric[1]+' '+
                                      Peric[2]+' '+
                                      Peric[3]+' '+
                                      Peric[4]+' '+
                                      Peric[5]+
                                      ConstStr(' ',5)+'Insalubrid: '+
                                      Insalub[1]+' '+
                                      Insalub[2]+' '+
                                      Insalub[3]+' '+
                                      Insalub[4]+' '+
                                      Insalub[5]);
                        WriteLine('L',ConstStr(' ',5)+'V.Transp..: '+VTransporte+' '+EditInteger(DiasVt));
                        WriteLine('L',ConstStr(' ',5)+'Dep.P/I.R.: '+PushLeft(5,EditInteger(DepIR))+
                                  'Dep.P/S.F.: '+EditInteger(DepSF));
                        WriteLine('L',ConstStr(' ',5)+'Pens. Alim: '+
                                      Pensao+' '+PushRight(5,EditReal(PensaoP))+'%');
                        WriteLine('L',ConstStr(' ',5)+Acentua('Pr¢x.F‚ria: ')+
                                      DDFer+'/'+MMFer+'/'+AAFer+
                                      ConstStr(' ',5)+'Per.Vencid: '+
                                      EditInteger(PeriodoV));
                        WriteLine('L',ConstStr('.',05)+Acentua('Pai.......: ')+
                                      Acentua(Pai));
                        WriteLine('L',ConstStr('.',05)+Acentua('Mae.......: ')+
                                      Acentua(Mae));
                        LiberaMVDsk;
                        RC := 'S';
                      end;
                   If (Opc     = 'P'                  ) and
                      (Status in ['A','E','F','L','C']) then
                      begin
                        If ContLin > 57 then HeaderReport;
                        WriteLine('L',Cx+PushLeft(9,Matricula)+
                                      Acentua(Nome)+ConstStr(' ',50-Length(Nome))+
                                      ' Conta  -  Valor ou No.de Horas   Conta  -  Valor ou No.de Horas'+Cf);
                        WriteLine('L',Cx+ConstStr(' ',9)+Acentua(Cargo)+Cf);
                        WriteLine('L',Cx+Acentua('Sal rio.....:   ')+
                                      PushRight(20,EditReal(Sal))+' '+
                                      '('+Tipo+')'+ConstStr(' ',17)+
                                      '[_____] - [____________________] [_____] - [____________________]'+Cf);
                        WriteLine('L',' ');
                        WriteLine('L',Cx+Acentua('Novo Sal rio: [_____________________]')+
                                      ConstStr(' ',20)+
                                      '[_____] - [____________________] [_____] - [____________________]'+Cf);
                        WriteLine('L',' ');
                        WriteLine('L',Cx+'V.transporte: [__]-[_____]  [  ]-[_____]  [__]-[_____]   '+
                                      '[_____] - [____________________] [_____] - [____________________]'+Cf);
                        WriteLine('L',Cx+'              [__]-[_____]  [__]-[_____]  [__]-[_____]   '+Cf);
                        Str(DepIR:2,J);
                        WriteLine('L',Cx+'Dep.para I.R: '+J+
                                      '   [____]                                '+
                                      '[_____] - [____________________] [_____] - [____________________]'+Cf);
                        Str(DepSF:2,J);
                        WriteLine('L',Cx+'Dep.para S.F: '+J+
                                      '   [____]   Pericul.: '+Peric[1]+
                                      Peric[2]+Peric[3]+Peric[4]+Peric[5]+
                                      '    [_____]   '+Cf);
                        WriteLine('L',Cx+'Status......: '+Status+
                                      '    [____]   Insal...: '+Insalub[1]+
                                      Insalub[2]+Insalub[3]+Insalub[4]+Insalub[5]+
                                      '    [_____]   '+
                                      '[_____] - [____________________] [_____] - [____________________]'+Cf);
                        WriteLine('L',' ');
                        LiberaMVDsk;
                        RC := 'S';
                      end;
                 end;
              GoNoGo;
              If TC = #27 then RC := 'N'
                 else If EEAC = XXNo then RC := 'N';
            Until RC = 'N';
            If NCont > 0 then
               begin
                 TC := #13;
                 Footer;
                 If DskRpt = 'N' then WriteLine('W',Qp);
               end;
            FuncImpressos;
          end;
     end;
end;


Procedure PedeProc03;
begin
  Color(Tfn,Ttx);
  GotoXY(4,12); Write('Tipo...:');
  Tp := 'R';
  Repeat
    TC := #13;
    K  := 1;
    Repeat
      Case K of
           1  :  PedeDepto(11,'L');
           2  :  begin
                   J := Tp;
                   InputStr(J,1,13,12,0,'S','N','T','N',Tfn,Utx);
                   If J = ' ' then Tp := 'R'
                              else Tp := UpCase(J[1]);
                   If (Tp <> 'R') and
                      (Tp <> 'T') then
                      begin
                        ErroMsg := 'Informe R ou T';
                        ErrorMessage;
                        K := K - 1;
                      end
                      else begin
                             GotoXY(13,12);
                             If Tp = 'R' then Write('Rela‡Æo de Empregados  ')
                                         else Write('Textos diversos        ');
                           end;
                 end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 3) or (TC = #27);
    If TC <> #27 then Confirma;
  Until (TC = 'S') or (TC = #27);
end;


Procedure ProcNo03Report;
begin
  PedeProc03;
  If TC = 'S' then
     begin
       If Ex <> 'L' then LoadIndex6 ('D',Tr)
                    else LoadIndex6 ('E',Tr);
       If TC <> #27 then
          begin
            If Tp = 'T' then FormTest('N','T','TXT')
                        else TC := 'S';
            If TC = 'S' then
               begin
                 Str(AA:2,AAx);
                 L1 := Nx+'Rela‡„o de Empregados em '+
                       Nf+ArrayMesEx[MM]+'/'+AAx;
                 L6 := Cx+'Matr¡cula   Nome'+
                       ConstStr(' ',40)+'Cargo'+ConstStr(' ',14)+
                       'Admiss„o    Sal rio-Hora'+'    T       '+
                       'Sal rio-Base'+Cf;
                 ParaContinua;
                 Janela('F');
                 DDAC := DDNo;
                 If DDNo <> '' then
                    begin
                      RC := 'N';
                      SearchAnt3 ( Root3 );
                      If RC = 'N' then DDNo := '';
                    end;
                 RecordAnt := '';
                 R1        := 0;
                 R2        := 0;
                 I         := 0;
                 R         := 0;
                 Repeat
                   RC := 'N';
                   SearchPos3 ( Root3 );
                   If RC = 'S' then
                      begin
                        ReadWrite(#05,'R','N',DDNumber);
                        If Ex <> 'L' then XXNo := DDNo + '#'
                                     else XXNo := '';
                        Repeat
                          RC := 'N';
                          SearchPos6 ( Root6 );
                          If RC = 'S' then
                             begin
                               ReadWrite(#08,'R','N',XXNumber);
                               If (((Ex             = 'X' ) and
                                    (EEMember.Depto = DDNo) and
                                    (DDMember.Marca = #004)) or
                                   ((Ex             <> 'X') and
                                    (Ex             <> 'L') and
                                    (EEMember.Depto = DDNo)) or
                                   (Ex              = 'L'  )) and
                                  ((EEMember.Status <> 'R' ) and
                                   (EEMember.Status <> 'X' )) then
                                  begin
                                    NCont := NCont + 1;
                                    Writeln(EEMember.Nome);
                                    Case Tp of
                                         'R' : begin
                                                 If ContLin > 56 then HeaderReport;
                                                 If (RecordAnt <> DDNo) and
                                                    (Ex        <> 'L' ) then
                                                    begin
                                                      WriteLine('L',PushLeft(11,DDNo)+
                                                                    Acentua(DDMember.Descricao));
                                                      WriteLine('L',' ');
                                                      RecordAnt := DDNo;
                                                    end;
                                                 EENo    := EEMember.Matricula;
                                                 SalBase := Sal;
                                                 If EEMember.HNormais > 0
                                                    then Valor := SalBase / EEMember.HNormais
                                                    else Valor := 0;
                                                 R1      := R1 + SalBase;
                                                 R2      := R2 + SalBase;
                                                 I       := I  + 1;
                                                 R       := R  + 1;
                                                 J       := EEMember.DDAdm+'/'+
                                                            EEMember.MMAdm+'/'+
                                                            EEMember.AAAdm;
                                                 WriteLine('L',Cx+PushLeft(12,EEMember.Matricula)+
                                                           Acentua(EEMember.Nome)+
                                                           ConstStr(' ',44-Length(EEMember.Nome))+
                                                           Acentua(EEMember.Cargo)+
                                                           ConstStr(' ',19-Length(EEMember.Cargo))+
                                                           J+ConstStr(' ',12-Length(J))+
                                                           PushRight(12,EditReal(Valor))+
                                                           ConstStr(' ',4)+
                                                           EEMember.Tipo+' '+
                                                           PushRight(18,EditReal(SalBase))+Cf);
                                               end;
                                         'T' : begin
                                                 EENo := EEMember.Matricula;
                                                 LoadMVDsk(#11);
                                                 ImprimeTexto('N');
                                               end;
                                    end;
                                    LiberaMVDsk;
                                    RC := 'S';
                                  end
                                  else If EEMember.Depto <> DDNo then RC := 'N';
                             end;
                          GoNoGo;
                          If TC = #27 then
                             begin
                               RC   := 'N';
                               DDAC := DDNo;
                             end;
                        Until RC = 'N';
                        If DDNo = DDAC then RC := 'N'
                                       else RC := 'S';
                      end;
                   If (I   > 0  ) and
                      (Tp  = 'R') and
                      (Ex <> 'L') and
                      (TC <> #27) then
                      begin
                        WriteLine('L',Cx+ConstStr('-',123)+Cf);
                        Str(I:4,J);
                        WriteLine('L',Cx+ConstStr(' ',12)+PushRight(4,J)+
                                      Acentua(' Empregados.')+
                                      ConstStr(' ',77)+
                                      PushRight(18,EditReal(R1))+Cf);
                        WriteLine('L',' ');
                        R1      := 0;
                        I       := 0;
                      end;
                   If Ex = 'L' then RC := 'N';
                 Until RC = 'N';
                 If (NCont <> 0  ) and
                    (Tp     = 'R') and
                    (TC    <> #27) then
                    begin
                      If Ex <> 'L' then
                         begin
                           If ContLin > 57 then HeaderReport;
                           Str(R:4,J);
                           WriteLine('L',Cx+ConstStr(' ',12)+PushRight(4,J)+
                                     Acentua(' Empregados.')+
                                     ConstStr(' ',77)+
                                     PushRight(18,EditReal(R2))+Cf);
                         end;
                      TC := #13;
                      Footer;
                      If DskRpt = 'N' then WriteLine('W',Qp);
                    end
                    else If Tp = 'T' then CloseTexto;
                 FuncImpressos;
               end;
          end;
     end;
end;


Procedure ProcNo04Linha(X : Char);
begin
  If ContLin > 55 then
     begin
       HeaderReport;
       If Ex in ['D','N','X'] then
          begin
            If NoMat = 'S' then WriteLine('L',Nx+Acentua(DDMember.Descricao)+
                                          ConstStr(' ',41-Length(DDMember.Descricao))+
                                          DDNo+Nf);
            WriteLine('L',' ');
          end;
       If NoMat = 'S'
          then WriteLine('L',ConstStr(' ',4)+Nx+
                             PushLeft(9,EEMember.Matricula)+
                             Acentua(EEMember.Nome)+Nf+
                             ConstStr(' ',50-Length(EEMember.Nome))+
                             '(Continua)')
          else WriteLine('L',ConstStr(' ',4)+Nx+
                             Acentua(EEMember.Nome)+Nf+
                             ConstStr(' ',59-Length(EEMember.Nome))+
                             '(Continua)');
       WriteLine('L',' ');
     end;
  Case CCMember.Tipo of
       'P' : If (YAddress^.AcMensalH > 0) or
                (YAddress^.AcMensalM > 0) then
                begin
                  WriteLine('L',ConstStr(' ',10)+Nx+
                                PushLeft(5,YYNo)+Nf+
                                Acentua(CCMember.Descricao)+
                                ConstStr(' ',31-Length(CCMember.Descricao))+
                                QQStr(YAddress^.AcMensalH,4,' ')+':'+
                                QQStr(YAddress^.AcMensalM,2,'0')+
                                PushRight(13,EditReal(YAddress^.AcMensalV)));
                  TProv := TProv + TruncX(YAddress^.AcMensalV);
                end
                else If YAddress^.AcMensalV > 0 then
                        begin
                          WriteLine('L',ConstStr(' ',10)+Nx+
                                        PushLeft(5,YYNo)+Nf+
                                        Acentua(CCMember.Descricao)+
                                        ConstStr(' ',38-Length(CCMember.Descricao))+
                                        PushRight(13,EditReal(YAddress^.AcMensalV)));
                          TProv := TProv + TruncX(YAddress^.AcMensalV);
                        end;
       'D' : If (YAddress^.AcMensalH > 0) or
                (YAddress^.AcMensalM > 0) then
                begin
                  WriteLine('L',ConstStr(' ',10)+Nx+
                                PushLeft(5,YYNo)+Nf+
                                Acentua(CCMember.Descricao)+
                                ConstStr(' ',31-Length(CCMember.Descricao))+
                                QQStr(YAddress^.AcMensalH,4,' ')+':'+
                                QQStr(YAddress^.AcMensalM,2,'0')+' '+
                                ConstStr(' ',13)+
                                PushRight(13,EditReal(YAddress^.AcMensalV)));
                  TDesc := TDesc + TruncX(YAddress^.AcMensalV);
                end
                else If YAddress^.AcMensalV > 0 then
                        begin
                          WriteLine('L',ConstStr(' ',10)+Nx+
                                        PushLeft(5,YYNo)+Nf+
                                        Acentua(CCMember.Descricao)+
                                        ConstStr(' ',52-Length(CCMember.Descricao))+
                                        PushRight(13,EditReal(YAddress^.AcMensalV)));
                          TDesc := TDesc + TruncX(YAddress^.AcMensalV);
                        end;
  end;
  If X = 'S' then AcumulaTotal;
end;


Procedure PedeProc04;
begin
  Color(Tfn,Ttx);
  GotoXY(4,12); Write('Matr¡c.:');
  GotoXY(4,13); Write('Tipo...:');
  NoMat := 'S';
  Folha := 'N';
  Repeat
    TC := #13;
    K  := 1;
    Repeat
      Case K of
           1  :  PedeDepto(11,'L');
           2  :  begin
                   Move(MemW[$B800:0000],ScArray6[1],4000);
                   DrawBox(38,14,57,17,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(38,15); Write(' Sim impr.matr¡cula');
                   GotoXY(38,16); Write(' NÆo impr.matr¡cula');
                   Color(Red,White);
                   GotoXY(39,15); Write('S');
                   GotoXY(39,16); Write('N');
                   Color(Tfn,Utx);
                   GotoXY(13,12); Write(ConstStr(' ',40));
                   J := NoMat;
                   InputStr(J,1,13,12,0,'S','S','T','N',Tfn,Utx);
                   NoMat := UpCase(J[1]);
                   Move(ScArray6[1],MemW[$B800:0000],4000);
                   GotoXY(13,12);
                   Case NoMat of
                        'N' : Write('NÆo imprime a matr¡cula');
                        'S' : Write('Sim imprime a matr¡cula');
                   end;
                 end;
           3  :  begin
                   Move(MemW[$B800:0000],ScArray6[1],4000);
                   DrawBox(28,14,54,19,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(28,15); Write('   - Folha de empregados');
                   GotoXY(28,16); Write('   - Folha de aut“nomos ');
                   GotoXY(28,17); Write('   - Folha de empregadores ');
                   GotoXY(28,18); Write('   - Todos');
                   Color(Red,White);
                   GotoXY(29,15); Write('N');
                   GotoXY(29,16); Write('A');
                   GotoXY(29,17); Write('E');
                   GotoXY(29,18); Write('T');
                   Color(Tfn,Utx);
                   GotoXY(13,13); Write(ConstStr(' ',40));
                   J := Folha;
                   InputStr(J,1,13,13,0,'S','S','T','N',Tfn,Utx);
                   Folha := UpCase(J[1]);
                   Move(ScArray6[1],MemW[$B800:0000],4000);
                   GotoXY(13,13);
                   Case Folha of
                        'N' : Write('Folha de empregados');
                        'A' : Write('Folha de Aut“nomos');
                        'E' : Write('Folha de empregadores');
                        'T' : Write('Todos');
                   end;
                 end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 4) or (TC = #27);
    If TC <> #27 then Confirma;
  Until TC in ['S',#27];
end;


Procedure ProcNo04Folha;
Var
  TFolha,FunSel    : Char;
begin
  Opc := CMstMember.Etapa;
  PedeProc04;
  If TC = 'S' then
     begin
       If Ex = 'L' then LoadIndex6 ('E',Tr)
                   else LoadIndex6 ('D',Tr);
       If TC <> #27 then
          begin
            Close ( SSFile );
            Str(AA:4,AAx);
            ParaContinua;
            Janela('F');
            Tx        := 'X';
            RecordAnt := '';
            DDAC      := DDNo;
            If DDNo <> '' then
               begin
                 RC := 'N';
                 SearchAnt3 ( Root3 );
                 If RC = 'N' then DDNo := '';
               end;
            Case Opc of
                 'O' : L1 := Nx+'Folha de Ad.13 Sal rio em '+Nf+
                             ArrayMesEx[MM]+'/'+AAx;
                 'P' : L1 := Nx+'Folha de Pagamento de '+Nf+
                             ArrayMesEx[MM]+'/'+AAx;
                 'S' : L1 := Nx+'Folha de 13 Sal rio em '+Nf+
                             ArrayMesEx[MM]+'/'+AAx;
                 else  L1 := Nx+'Folha de Adiantamento em '+Nf+
                             ArrayMesEx[MM]+'/'+AAx;
            end;
            L6 := ConstStr(' ',10)+'Cta Descri‡„o'+
                  ConstStr(' ',23)+'  Horas    Proventos     Descontos';
            Repeat
              RC := 'N';
              SearchPos3 ( Root3 );
              If RC = 'S' then
                 begin
                   R1 := 0;
                   ReadWrite(#05,'R','N',DDNumber);
                   If Ex = 'L' then XXNo := ''
                               else XXNo := DDNo + '#';
                   AbreTotal;
                   Repeat
                     RC := 'N';
                     SearchPos6 ( Root6 );
                     If RC = 'S' then
                        begin
                          FunSel := 'N';
                          ReadWrite(#08,'R','N',XXNumber);
                          If Ex = 'L' then DDNo := EEMember.Depto;
                          If (((Ex             = 'X' ) and
                               (EEMember.Depto = DDNo) and
                               (DDMember.Marca = #004)) or
                              ((Ex             <> 'X') and
                               (EEMember.Depto = DDNo))) then
                             begin
                               TFolha := 'S';
                               Case Folha of
                                    'A' : If EEMember.Vinculo <> 'A' then TFolha := 'N';
                                    'E' : If EEMember.Vinculo <> 'N' then TFolha := 'N';
                                    'N' : If (EEMember.Vinculo = 'N') or
                                             (EEMember.Vinculo = 'A') then TFolha := 'N';
                               end;

                               I         := Pos(EEMember.Status,'ACDEFJLMNOPTVRX');
                               NoStat[I] := NoStat[I] + 1;

                               If (TFolha           = 'S'        ) and
                                  (EEMember.Status <> 'R'        ) and
                                  (EEMember.Status <> 'V'        ) and
                                  (EEMember.Status <> 'X'        ) and
                                  ((Opc in ['O','P','S']         ) or
                                   ((Opc = 'A'                  )  and
                                    (EEMember.Tipo in ['H','M']))  or
                                   ((Opc in ['1','2','3','4']  )   and
                                    (EEMember.Tipo = 'S'       ))) then
                                  begin
                                    FunSel := 'S';
                                    NCont  := NCont + 1;
                                    TProv  := 0;
                                    TDesc  := 0;
                                    Valor  := 0;
                                    VLiq   := 0;
                                    R2     := 0;
                                    Writeln(EEMember.Nome);
                                    EENo := EEMember.Matricula;
                                    LoadMVDsk(#11);
                                    If (RecordAnt <> DDNo         ) and
                                       (Ex        in ['D','N','X']) then
                                       begin
                                         HeaderReport;
                                         If NoMat = 'S'
                                            then WriteLine('L',Nx+
                                                          Acentua(DDMember.Descricao)+
                                                          ConstStr(' ',41-Length(DDMember.Descricao))+
                                                          DDNo+Nf);
                                         WriteLine('L',' ');
                                         RecordAnt := DDNo;
                                       end
                                       else If ContLin > 55 then HeaderReport;
                                    If NoMat = 'S'
                                       then WriteLine('L',ConstStr(' ',4)+Nx+
                                                 PushLeft(9,EEMember.Matricula)+
                                                 Acentua(EEMember.Nome)+Nf+
                                                 ConstStr(' ',41-Length(EEMember.Nome))+
                                                 Acentua(EEMember.Cargo)+
                                                 ConstStr(' ',16-Length(EEMember.Cargo))+
                                                 EEMember.DDAdm+'/'+
                                                 EEMember.MMAdm+'/'+
                                                 EEMember.AAAdm)
                                       else WriteLine('L',ConstStr(' ',4)+Nx+
                                                 Acentua(EEMember.Nome)+Nf+
                                                 ConstStr(' ',41-Length(EEMember.Nome))+
                                                 Acentua(EEMember.Cargo)+
                                                 ConstStr(' ',16-Length(EEMember.Cargo))+
                                                 EEMember.DDAdm+'/'+
                                                 EEMember.MMAdm+'/'+
                                                 EEMember.AAAdm);
                                    WriteLine('L',' ');
                                    SalBase := Sal;
                                    R3      := SalBase / EEMember.HNormais;
                                    YYNo := '001';
                                    SearchTreeY ( RootY );
                                    If (RC = 'S') and (R3 > 0) then
                                       begin
                                         R1 := R1 + TruncX(YAddress^.AcMensalV / R3);
                                         R2 := R2 + TruncX(YAddress^.AcMensalV / R3);
                                       end;
                                    YYNo := '';
                                    Repeat
                                      RC := 'N';
                                      SearchPosY ( RootY );
                                      If RC = 'S' then
                                         begin
                                           CCNo := YYNo;
                                           SearchTree1 ( Root1 );
                                           If RC = 'S' then
                                              With CCMember do
                                              begin
                                                ReadWrite(#04,'R','N',CCNumber);
                                                If (CCNo       = '030'                 ) or
                                                   (Operacao   = Opc                   ) or
                                                   ((CCNo      > '100'                )  and
                                                    (Opc       = 'P'                  )  and
                                                    (Operacao in ['1','2','3','4','A']))
                                                   then ProcNo04Linha('S');
                                              end
                                              else begin
                                                     RC := 'S';
                                                     CCMember.Tipo := 'P';
                                                     CCMember.Descricao := '********';
                                                     ProcNo04Linha('S');
                                                   end;
                                           If CCNo = '030'
                                              then VLiq := YAddress^.AcMensalV;
                                         end
                                         else RC := 'N';
                                    Until RC = 'N';
                                    WriteLine('L',ConstStr(' ',53)+ConstStr('-',27));
                                    WriteLine('L',ConstStr(' ',53)+
                                             PushRight(13,EditReal(TProv))+' '+
                                             PushRight(13,EditReal(TDesc)));
                                    WriteLine('L',ConstStr(' ',10)+Acentua('030 L¡quido')+
                                             ConstStr('.',31)+' '+Nx+
                                             PushRight(13,EditReal(VLiq))+Nf);
                                    If Opc in ['P','S'] then
                                       begin
                                         If ContLin > 58 then
                                            begin
                                              HeaderReport;
                                              If Ex in ['D','N','X'] then
                                                 begin
                                                   If NoMat = 'S'
                                                      then WriteLine('L',Nx+Acentua(DDMember.Descricao)+
                                                                        ConstStr(' ',41-Length(DDMember.Descricao))+
                                                                        DDNo+Nf);
                                                   WriteLine('L',' ');
                                                 end;
                                            end;
                                         ProcNo04Bases;
                                       end;
                                    WriteLine('L',' ');
                                    RC := 'S';
                                    LiberaMVDsk;
                                  end;
                             end
                             else If (EEMember.Depto <> DDNo) and
                                     (Ex              = 'N' ) then RC := 'N';
                        end;
                     GoNoGo;
                     If TC = #27 then
                        begin
                          RC   := 'N';
                          DDAC := DDNo;
                        end;
                   Until RC = 'N';
                   If ((RecordAnt = DDNo          ) or
                      (Ex        in ['D','L','N'])) and
                      (FunSel    = 'S'            ) then
                      begin
                        L1 := Nx+'Totaliza‡„o da Folha de Pag. de '+Nf+
                              ArrayMesEx[MM]+'/'+AAx;
                        L6 := ConstStr(' ',10)+Cx+
                              'Cta Descri‡„o                      T'+
                              '  HH(Mˆs)   Acumulado Mensal HH(Anua'+
                              'l)        Acumulado Anual'+Cf;
                        HeaderReport;
                        ImprimeTotal;
                        Case Opc of
                             'P' : L1 := Nx+'Folha de Pagamento de '+Nf+
                                         ArrayMesEx[MM]+'/'+AAx;
                             'S' : L1 := Nx+'Folha de 13 Sal rio em '+Nf+
                                         ArrayMesEx[MM]+'/'+AAx;
                             else  L1 := Nx+'Folha de Adiantamento em '+Nf+
                                         ArrayMesEx[MM]+'/'+AAx;
                        end;
                        L6 := ConstStr(' ',10)+'Cta Descri‡„o'+
                              ConstStr(' ',23)+'  Horas    Proventos     Descontos';
                      end;
                   Close ( TotFile );
                   Erase ( TotFile );
	           If (DDNo = DDAC) or (Ex = 'L') then RC := 'N'
                                                  else RC := 'S';
                 end;
            Until RC = 'N';
            If NCont > 0 then
               begin
                 TC := #13;
                 Footer;
                 If DskRpt = 'N' then WriteLine('W',Qp);
               end;
            FuncImpressos;
            Reset ( SSFile );
          end;
     end;
end;


Procedure ProcNo04Conf;
Var
  Achou   : Char;
begin
  Opc   := CMstMember.Etapa;
  NoMat := 'S';
  Repeat
    PedeDepto(11,'L');
    If TC <> #27 then Confirma;
  Until TC in ['S',#27];
  If TC = 'S' then
     begin
       If Ex = 'L' then LoadIndex6 ('E',Tr)
                   else LoadIndex6 ('D',Tr);
       If TC <> #27 then
          begin
            Str(AA:4,AAx);
            ParaContinua;
            Janela('F');
            Tx        := 'X';
            RecordAnt := '';
            DDAC      := DDNo;
            If DDNo <> '' then
               begin
                 RC := 'N';
                 SearchAnt3 ( Root3 );
                 If RC = 'N' then DDNo := '';
               end;
            L1 := Nx+'Listagem de Conferˆncia de '+Nf+ArrayMesEx[MM]+'/'+AAx;
            L6 := ConstStr(' ',10)+'Cta Descri‡„o'+
                  ConstStr(' ',23)+'  Horas    Proventos     Descontos';
            Repeat
              RC := 'N';
              SearchPos3 ( Root3 );
              If RC = 'S' then
                 begin
                   ReadWrite(#05,'R','N',DDNumber);
                   If Ex = 'L' then XXNo := ''
                               else XXNo := DDNo + '#';
                   Repeat
                     RC := 'N';
                     SearchPos6 ( Root6 );
                     If RC = 'S' then
                        begin
                          Achou := 'S';
                          ReadWrite(#08,'R','N',XXNumber);
                          If Ex = 'L' then DDNo := EEMember.Depto;
                          If (((Ex             = 'X' ) and
                               (EEMember.Depto = DDNo) and
                               (DDMember.Marca = #004)) or
                              ((Ex             <> 'X') and
                               (EEMember.Depto = DDNo))) then
                             begin
                               If (EEMember.Status <> 'R') and
                                  (EEMember.Status <> 'V') and
                                  (EEMember.Status <> 'X') then
                                  begin
                                    NCont  := NCont + 1;
                                    TProv  := 0;
                                    TDesc  := 0;
                                    Valor  := 0;
                                    VLiq   := 0;
                                    R2     := 0;
                                    Writeln(EEMember.Nome);
                                    EENo := EEMember.Matricula;
                                    LoadMVDsk(#11);
                                    If (RecordAnt <> DDNo         ) and
                                       (Ex        in ['D','N','X']) then
                                       begin
                                         HeaderReport;
                                         WriteLine('L',Nx+Acentua(DDMember.Descricao)+
                                                          ConstStr(' ',41-Length(DDMember.Descricao))+
                                                          DDNo+Nf);
                                         WriteLine('L',' ');
                                         RecordAnt := DDNo;
                                         Achou     := 'S';
                                       end
                                       else If ContLin > 56 then HeaderReport;
                                    YYNo := '';
                                    Repeat
                                      RC := 'N';
                                      SearchPosY ( RootY );
                                      If RC = 'S' then
                                         begin
                                           If YAddress^.Origem = 'U' then
                                              begin
                                                If Achou = 'S' then
                                                   begin
                                                     WriteLine('L',' ');
                                                     WriteLine('L',ConstStr(' ',4)+Nx+
                                                                   PushLeft(9,EEMember.Matricula)+
                                                                   Acentua(EEMember.Nome)+Nf+
                                                                   ConstStr(' ',41-Length(EEMember.Nome))+
                                                                   Acentua(EEMember.Cargo));
                                                     WriteLine('L',' ');
                                                     Achou := 'N';
                                                   end;
                                                CCNo := YYNo;
                                                SearchTree1 ( Root1 );
                                                If RC = 'S'
                                                   then ReadWrite(#04,'R','N',CCNumber)
                                                   else begin
                                                          RC := 'S';
                                                          CCMember.Tipo := 'P';
                                                          CCMember.Descricao := '********';
                                                        end;
                                                ProcNo04Linha('N');
                                              end;
                                         end
                                         else RC := 'N';
                                    Until RC = 'N';
                                    RC := 'S';
                                    LiberaMVDsk;
                                  end;
                             end
                             else If (EEMember.Depto <> DDNo) and
                                     (Ex              = 'N' ) then RC := 'N';
                        end;
                     GoNoGo;
                     If TC = #27 then
                        begin
                          RC   := 'N';
                          DDAC := DDNo;
                        end;
                   Until RC = 'N';
	           If (DDNo = DDAC) or (Ex = 'L') then RC := 'N'
                                                  else RC := 'S';
                 end;
            Until RC = 'N';
            If NCont > 0 then
               begin
                 TC := #13;
                 Footer;
                 If DskRpt = 'N' then WriteLine('W',Qp);
               end;
            FuncImpressos;
          end;
     end;
end;


Procedure ProcNo04Report;
Var
   ScArray7       : Array [1..4000] of Char;
begin
  TabI[1]  := ' Folha de Pagamentos     ';
  TabI[2]  := ' Listagem de Conferencia ';
  TabI[3]  := ' Encerrar a fun‡Æo       ';
  TabX[1]  := 10;
  TabX[2]  := 10;
  TabX[3]  := 10;
  TabY[1]  := 10;
  TabY[2]  := 11;
  TabY[3]  := 12;
  YY := 1;
  Repeat
    RetMenuAuxiliar(9,09,3,1,1);
    Move(Mem[$B800:0000],ScArray7[1],4000);
    Case YY of
         1 : begin
               Titulo := 'Folha de Pagamentos';
               BuildFrame('S');
               Color(Red,Yellow);
               GotoXY(35,07); Write(' Configurado para:');
               Color(Red,White);
               GotoXY(54,07); Write(XPrinter);
               Color(Tfn,Utx);
               UltimaEtapa;
               Shade(3,8,60,21,LightGray,Black);
               ContLin := 1000;
               ProcNo04Folha;
             end;
         2 : begin
               Titulo := 'Listagem de Conferˆncia';
               BuildFrame('S');
               Color(Red,Yellow);
               GotoXY(35,07); Write(' Configurado para:');
               Color(Red,White);
               GotoXY(54,07); Write(XPrinter);
               Color(Tfn,Utx);
               UltimaEtapa;
               Shade(3,8,60,21,LightGray,Black);
               ContLin := 1000;
               ProcNo04Conf;
             end;
         3 : begin
               TC   := #27;
               Resp := #27;
             end;
    end;
    If (DskRpt = 'T') and (TC <> #27) then
       begin
         ScrollRpt;
         ReWrite ( LST );
       end;
    Move(ScArray7[1],Mem[$B800:0000],4000);
  Until Resp = #27;
  DskRpt := 'N';
end;


Procedure PedeProcEE;
begin
  Color(Tfn,Ttx);
  GotoXY(4,11); Write('Tipo...:');
  GotoXY(4,12); Write('1..4Col:');
  GotoXY(4,13); Write('Per/Obs:');
  Tp      := ' ';
  Colunas := 0;
  Periodo := '';
  Repeat
    K := 1;
    Repeat
      Case K of
           1  :  PedeDepto(10,'#');
	   2  :  begin
                   DrawBox(33,14,54,18,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(33,15); Write(' Tipo de Etiqueta     ');
                   GotoXY(33,16); Write('     CartÆo de Ponto  ');
                   GotoXY(33,17); Write('     Normal           ');
                   Color(Red,White);
                   GotoXY(38,16); Write('C');
                   GotoXY(38,17); Write('N');
                   J := Tp;
		   InputStr(J,1,13,11,0,'S','S','T','N',Tfn,Utx);
                   Tp := UpCase(J[1]);
                   If TC <> #27 then
                      begin
                        GotoXY(13,11);
                        Case Tp of
                             'C' : Write('CartÆo de Ponto          ');
                             'N' : Write('Normal de correspondˆncia');
                             else begin
                                    Tp := 'C';
                                    Write('CartÆo de Ponto          ');
                                  end;
                        end;
                        Color(Tfn,Utx);
                        GotoXY(33,14); Write(' ':25);
                        GotoXY(33,15); Write(' ':25);
                        GotoXY(33,16); Write(' ':25);
                        GotoXY(33,17); Write(' ':25);
                        GotoXY(33,18); Write(' ':25);
                        GotoXY(33,19); Write(' ':25);
                      end;
                 end;
	   3  :  begin
                   If Colunas = 0 then J := ''
                                  else begin
                                         Str(Colunas:1,J);
                                         J := LeftAdjust(J);
                                       end;
		   InputStr(J,1,13,12,0,'S','N','T','N',Tfn,Utx);
                   Val(J[1],Colunas,E);
                   If (Colunas < 1) or (Colunas > 4) and (TC <> #27) then
                      begin
                        ErroMsg := 'Informe 1 a 4 (colunas)';
                        ErrorMessage;
                        K := K - 1;
                      end;
                 end;
	   4  :  begin
                   J := '';
		   InputStr(J,20,13,13,0,'S','S','T','N',Tfn,Utx);
                   Periodo := J;
                 end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 5) or (TC = #27);
    If TC <> #27 then Confirma;
  Until (TC = 'S') or (TC = #27);
end;


Procedure ProcNoEEReport;
begin
  PedeProcEE;
  If TC = 'S' then
     begin
       FormTest('S','T','ETQ');
       If TC <> #27 then
          begin
            LoadIndex6 ('D',Tr);
            If TC <> #27 then
               begin
                 ParaContinua;
                 Janela('F');
                 DDAC := DDNo;
                 If DDNo <> '' then
                    begin
                      RC := 'N';
                      SearchAnt3 ( Root3 );
                      If RC = 'N' then DDNo := '';
                    end;
                 ZeraEtiqueta;
                 I := 0;
                 Repeat
                   RC := 'N';
                   SearchPos3 ( Root3 );
                   If RC = 'S' then
                      begin
                        ReadWrite(#05,'R','N',DDNumber);
                        XXNo := DDNo + '#';
                        Repeat
                          RC := 'N';
                          SearchPos6 ( Root6 );
                          If RC = 'S' then
                             begin
                               If Ex = '#' then XXNumber := EENumber;
                               ReadWrite(#08,'R','N',XXNumber);
                               If (((Ex             = 'X' ) and
                                    (EEMember.Depto = DDNo) and
                                    (DDMember.Marca = #004)) or
                                   ((EX             <> 'X') and
                                    (EEMember.Depto = DDNo))) and
                                  (RW                = 'S'          ) and
                                  (EEMember.Status in ['A','E','F'] ) and
                                  (((Tp                = 'C'   )  and
                                    (EEMember.Cartao  <> ''    )  and
                                    (EEMember.Vinculo[1] <> 'N')) or
                                   (Tp                 = 'N'   )) then
                                  begin
                                    NCont := NCont + 1;
                                    Writeln(EEMember.Nome);
                                    I := I + 1;
                                    NomeX[I]        := EEMember.Nome;
                                    MatriculaX[I]   := EEMember.Matricula;
                                    TurnoX[I]       := EEMember.Turno;
                                    EntradaX[I]     := EEMember.Entrada;
                                    SaidaX[I]       := EEMember.Saida;
                                    IntRefeicaoX[I] := EEMember.IntRefeicao;
                                    RepSemanalX[I]  := EEMember.RepSemanal;
                                    CtrabX[I]       := EEMember.CtrabN + '/' +
                                                       EEMember.CtrabS + '/' +
                                                       EEMember.CtrabE;
                                    CargoX[I]       := EEMember.Cargo;
                                    CartaoX[I]      := EEMember.Cartao;
                                    EnderecoX[I]    := EEMember.Endereco;
                                    BairroX[I]      := EEMember.Bairro;
                                    CidadeX[I]      := EEMember.Cidade;
                                    EstadoX[I]      := EEMember.Estado;
                                    CepX[I]         := EEMember.Cep + '-' + EEMember.CepCompl;
                                    If I = Colunas then
                                       begin
                                         ImprimeTexto('S');
                                         ZeraEtiqueta;
                                         I := 0;
                                       end;
                                  end
                                  else If EEMember.Depto <> DDNo then RC := 'N';
                             end;
                          GoNoGo;
                          If TC = #27 then
                             begin
                               RC   := 'N';
                               DDAC := DDNo;
                             end;
                          If Ex = '#' then RC := 'N';
                        Until RC = 'N';
                        Case Ex of
                             'N' : RC := 'S';
                             'D' : If DDNo = DDAC then RC := 'N'
                                                  else RC := 'S';
                             'X' : RC := 'S';
                        end;
                      end;
                 Until RC = 'N';
                 If (NCont  > 0) and
                    (I     <> 0) then ImprimeTexto('S');
                 CloseTexto;
                 FuncImpressos;
               end;
          end;
     end;
end;


end.