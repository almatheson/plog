{$O+,F+}
Unit PlogRpt0;

Interface

Uses Crt,Dos,PlogText,PlogGlbs,PlogBasP,PlogTree,PlogMstr,PlogFunc;

    Procedure ListaTabelas;
    Procedure ZeraEtiqueta;
    Procedure ParaContinua;
    Procedure GoNoGo;
    Procedure Janela(X : Char);
    Procedure FuncImpressos;
    Procedure PedeDepto(L : Integer;X : Char);
    Procedure PedeBanco(X : Char);
    Procedure PedeCadastro;
    Procedure HeaderReport;
    Procedure AbreTotal;
    Procedure AcumulaTotal;
    Procedure ImprimeTotal;
    Procedure ProcNo04Bases;
    Procedure FormTest(X,Y : Char; Suf : Str3);
    Procedure ImprimeTexto(X : Char);
    Procedure CloseTexto;
    Procedure PedeMesAno;
    Procedure ImprimeAgora;
    Procedure PedeProcXX;
    Procedure PedeProc15;
    Function  PedeData(X,Y : Integer;T : Str10): Str10;


Implementation


Procedure ListaTabelas;
begin
  TTNo := AAFx + Copy(MMFx,2,2) + Sq;
  SearchTree4 ( Root4 );
  If RC = 'S' then
     begin
       ReadWrite(#03,'R','N',TTNumber);
       Val(Copy(MMFx,2,2),I,E);
       WriteLine('L',Dx+'Folha de Pagamento'+Df);
       WriteLine('L',Nx+Acentua('Tabelas & Parƒmetros de ')+
                     Acentua(ArrayMesEx[I])+'/'+PushRight(4,AAFx)+
                     Acentua(' Vers„o ')+Sq+Nf+
                     ConstStr(' ',10-Length(ArrayMesEx[MM]))+
                     ConstStr(' ',16)+'Data: '+
                     XDia+'/'+XMes+'/'+XAno);
       WriteLine('L',' ');
       WriteLine('L',ConstStr('-',80));
       WriteLine('L','I.N.S.S.'+ConstStr(' ',15)+
                     'Faixa          % Empregado            % Empresa');
       WriteLine('L',ConstStr('-',80));
       For I := 1 to 10 do WriteLine('L',ConstStr(' ',8)+
                                     PushRight(20,EditReal(TTMember.FaixaIapas[I]))+' '+
                                     PushRight(20,EditReal(TTMember.TaxaIapas[I]))+' '+
                                     PushRight(20,EditReal(TTMember.TaxaEIapas[I])));
       WriteLine('L',ConstStr('-',80));
       WriteLine('L','I.R.    '+ConstStr(' ',15)+
                  Acentua('Faixa           Percentual              Dedu‡„o'));
       WriteLine('L',ConstStr('-',80));
       For I := 1 to 10 do WriteLine('L',ConstStr(' ',8)+
                                      PushRight(20,EditReal(TTMember.FaixaIR[I]))+' '+
                                      PushRight(20,EditReal(TTMember.TaxaIR[I]))+' '+
                                      PushRight(20,EditReal(TTMember.DeducaoIR[I])));
       WriteLine('L',ConstStr('-',80));
       WriteLine('L','S.FAM.  '+ConstStr(' ',15)+
                      Acentua('Faixa      Sal rio Fam¡lia'));
       WriteLine('L',ConstStr('-',80));
       For I := 1 to 10 do WriteLine('L',ConstStr(' ',8)+
                                      PushRight(20,EditReal(TTMember.FaixaSF[I]))+' '+
                                      PushRight(20,EditReal(TTMember.ValorSF[I])));
       WriteLine('L',ConstStr('-',80));
       WriteLine('L','Fx  Valor da Tarifa Fx  Valor da Tarifa '+
                     'Fx  Valor da Tarifa Fx  Valor da Tarifa');
       WriteLine('L',ConstStr('-',80));
       For I := 1 to 12 do WriteLine('L',PushRight(2,EditInteger(I))+' '+
                                         PushRight(16,EditReal(TTMember.VPass[I]))+' '+
                                         PushRight(2,EditInteger(I+12))+' '+
                                         PushRight(16,EditReal(TTMember.VPass[I+12]))+' '+
                                         PushRight(2,EditInteger(I+24))+' '+
                                         PushRight(16,EditReal(TTMember.VPass[I+24]))+' '+
                                         PushRight(2,EditInteger(I+36))+' '+
                                         PushRight(16,EditReal(TTMember.VPass[I+36])));
       WriteLine('L',ConstStr('-',80));
       Writeline('L','Abatimento por dependente (IR).: '+
                     PushRight(15,EditReal(TTMember.DependenteIR)));
       WriteLine('L',Acentua('Valor do Sal rio M¡nimo........: ')+
                     PushRight(15,EditReal(TTMember.SalMinimo)));
       WriteLine('L',Acentua('Teto do Sal rio de Contribui‡„o: ')+
                     PushRight(15,EditReal(TTMember.TetoSalContr)));
       WriteLine('L','Percentuais de Periculosidade..: '+
                      PushRight(5,EditReal(TTMember.Peri[1]))+' '+
                      PushRight(5,EditReal(TTMember.Peri[2]))+' '+
                      PushRight(5,EditReal(TTMember.Peri[3]))+' '+
                      PushRight(5,EditReal(TTMember.Peri[4]))+' '+
                      PushRight(5,EditReal(TTMember.Peri[5])));
       WriteLine('L','Percentuais de Insalubridade...: '+
                      PushRight(5,EditReal(TTMember.Insa[1]))+' '+
                      PushRight(5,EditReal(TTMember.Insa[2]))+' '+
                      PushRight(5,EditReal(TTMember.Insa[3]))+' '+
                      PushRight(5,EditReal(TTMember.Insa[4]))+' '+
                      PushRight(5,EditReal(TTMember.Insa[5])));
       WriteLine('W',Qp);
     end;
end;


Procedure ZeraEtiqueta;
begin
  For I := 1 to 4 do begin
                       NomeX[I]        := '';
                       MatriculaX[I]   := '';
                       TurnoX[I]       := '';
                       EntradaX[I]     := '';
                       SaidaX[I]       := '';
                       IntRefeicaoX[I] := '';
                       RepSemanalX[I]  := '';
                       CtrabX[I]       := '';
                       CargoX[I]       := '';
                       CartaoX[I]      := '';
                       EnderecoX[I]    := '';
                       BairroX[I]      := '';
                       CidadeX[I]      := '';
                       EstadoX[I]      := '';
                       CepX[I]         := '';
                     end;
end;


Procedure ParaContinua;
begin
  Color(Red,Cyan);
  GotoXY(01,24); Write(ConstStr(' ',80));
  GotoXY(20,24); Write('      ',#026,' Para/Continua          ',#026,' Cancela');
  Color(Red,Yellow);
  GotoXY(20,24); Write('Enter');
  GotoXY(47,24); Write('Esc');
  Color(Tfn,Utx);
end;


Procedure GoNoGo;
begin
  If KeyPressed then
     begin
       TC := ReadKey;
       If TC = #13 then
          Repeat
            TC := ReadKey;
          Until (TC = #13) or (TC = #27);
     end;
end;


Procedure Janela(X : Char);
begin
  DrawBox(26,10,67,19,Sfn,'S');
  Color(Bfn,Btx);
  GotoXY(26,10);
  Case X of
       'B' : Write('                  Bancos                  ');
       'C' : Write('                  Contas                  ');
       'D' : Write('              Departamentos               ');
       'F' : Write('                Empregados                ');
       'S' : Write('               Sindicatos                 ');
  end;
  Color(Sfn,Stx);
  Window(27,12,67,19);
  GotoXY(1,8);
end;


Procedure FuncImpressos;
begin
  Window(1,1,80,25);
  Color(Blue,Cyan);
  GotoXY(1,23);  Write(ConstStr(' ',80));
  GotoXY(1,23);  Write(' Total de Empregados Impressos: ');
  Color(Blue,White);
  GotoXY(33,23); Write(NCont:5);
  TeclaReturn;
end;


Procedure PedeDepto(L : Integer;X : Char);
begin
  Color(Tfn,Ttx);
  GotoXY(4,L); Write('Depto..:');
  Ex    := ' ';
  DDNo  := '';
  Repeat
    With DDMember do
    begin
      Color(Red,Cyan);
      GotoXY(1,23); Write(ConstStr(' ',80));
      GotoXY(2,23);
      Case X of
           ' ' : Write('Enter = Todos');
           '#' : Write('Enter = Todos ou #Matr¡cula para 1 Empregado');
           '@' : Write('Enter = Todos ou #Matr¡cula para 1 Empregado ou L = forma de Listagem');
           'L' : Write('Enter = Todos ou L = forma de Listagem');
           '*' : Write('Enter = Todos ou selecione por parte do C¢digo');
      end;
      Color(Blue,White);
      GotoXY(1,24); Write(ConstStr(' ',80));
      GotoXY(2,24); Write('F1');
      Color(Blue,Cyan);
      GotoXY(5,24); Write('para pesquisar ou ');
      Color(Blue,White);
      GotoXY(23,24); Write('F2');
      Color(Blue,Cyan);
      GotoXY(26,24); Write('para marcar Departamentos');
      Color(Tfn,Utx);
      GotoXY(13,L); Write(' ':40);
      J := DDNo;
      InputStr(J,15,13,L,0,'S','N','T','N',Tfn,Utx);
      LimpaLn(23,Tfd);
      LimpaLn(24,Tfd);
      If J = '' then J := ' ';
      If TC <> #27 then
         Case TC of
              #13 : If J <> '' then
                       begin
                         GotoXY(13,L);
                         Case UpCase(J[1]) of
                              ' ' : begin
                                      DDNo := '';
                                      Write('Todos os Deptos',' ':25);
                                      Ex := 'N';
                                    end;
                              'L' : If X in ['L','@'] then
                                       begin
                                         DDNo := '';
                                         Write('Listagem       ',' ':25);
                                         Ex := 'L';
                                       end;
                              '#' : If X in ['#','@'] then
                                       begin
                                         Delete(J,1,1);
                                         EENo := J;
                                         SearchTree5 ( Root5 );
                                         If RC = 'S' then
                                            begin
                                              ReadWrite(#08,'R','N',EENumber);
                                              Write(EEMember.Nome);
                                              DDNo := EEMember.Depto;
                                              Ex   := '#';
                                            end
                                            else begin
                                                   ErroMsg := 'Empregado nÆo Existe';
                                                   ErrorMessage;
                                                 end;
                                       end;
                              else begin
                                     DDNo := J;
                                     SearchTree3 ( Root3 );
                                     If RC = 'S' then
                                        begin
                                          ReadWrite(#05,'R','N',DDNumber);
                                          Write(DDNo,' ',Descricao);
                                          Ex := 'D';
                                        end
                                        else If X = '*' then
                                                begin
                                                  GotoXY(13,L);
                                                  Write(DDNo,' ','Por parte do c¢digo');
                                                  Ex := '*';
                                                end
                                                else begin
                                                       ErroMsg := 'Departamento nÆo Existe';
                                                       ErrorMessage;
                                                     end;
                                   end;
                         end;
                       end
                       else TC := #13;
              #21 : begin
                      DDAC := LimpaChave(J);
                      DDNo := DDAC;
                      ScrollDept('N');
                      DDNo := DDAC;
                    end;
              #22 : begin
                      DDAC := LimpaChave(J);
                      DDNo := DDAC;
                      ScrollDept('X');
                      GotoXY(13,L); Write('Departamentos Marcados');
                      Ex   := 'X';
                      DDNo := '';
                      DDAC := '';
                      TC   := #13;
                    end;
         end;
      LimpaLn(24,Tfd);
    end;
  Until (TC = #27) or (Ex in ['N','L','#','*','D','X']);
end;


Function PedeData(X,Y : Integer;T : Str10): Str10;
begin
  If T <> '' then
     begin
       Color(Tfn,Ttx);
       GotoXY(X-8,Y); Write(T);
     end;
  J := '';
  Repeat
    InputStr(J,10,X,Y,0,'S','N','D','S',Tfn,Utx);
    If TC <> #27 then PedeData := J;
  Until TC in [#13,#27];
end;


Procedure PedeBanco(X : Char);
begin
  Color(Tfn,Ttx);
  GotoXY(4,11); Write('Banco..:');
  If X <> '3' then
     begin
       GotoXY(4,12); Write('C¢digo.:');
       GotoXY(4,13); Write('Seq....:');
       GotoXY(4,17); Write('Matr¡c.:');
       GotoXY(4,15); Write('Dia Emi:');
     end;
  GotoXY(4,14); Write('C¢digo.:');
  GotoXY(4,16); Write('P,13§,A:');
  NoMat := 'S';
  BBNo  := '';
  Repeat
    K := 1;
    Repeat
      Case K of
	   1  : begin
                  Color(Blue,White);
                  GotoXY(1,24); Write(ConstStr(' ',80));
                  GotoXY(2,24); Write('F1');
                  Color(Blue,Cyan);
                  GotoXY(5,24); Write('para pesquisar Bancos');
                  Color(Tfn,Utx);
                  GotoXY(13,11); Write(' ':40);
                  J := BBNo;
		  InputStr(J,10,13,11,0,'S','N','T','N',Tfn,Utx);
                  BBNo := LimpaChave(J);
                  If TC = #21 then
                     begin
                       BBAC := BBNo;
                       ScrollBanco;
                       BBNo := BBAC;
                     end
                     else If TC <> #27 then
                             begin
                               If J = '' then
                                  begin
                                    Color(Tfn,Ttx);
                                    GotoXY(4,11); Write('Banco..:');
                                    Color(Tfn,Utx);
                                    GotoXY(13,11);
                                    Write('Todos os Bancos',' ':25);
                                    BBNo := '';
                                  end
                                  else begin
                                         SearchTree7 ( Root7 );
                                         If RC = 'S' then
                                            With BBMember do
                                            begin
                                              ReadWrite(#06,'R','N',BBNumber);
                                              Color(Tfn,Ttx);
                                              GotoXY(4,11); Write('Banco..:');
                                              Color(Tfn,Utx);
                                              GotoXY(13,11);
                                              Write(BBMember.OrigBancoC,' ',
                                                    BBMember.NomeBanco);
                                            end
                                            else begin
                                                   ErroMsg := 'Banco/Ag. nÆo Existe ';
                                                   ErrorMessage;
                                                   K := K - 1;
                                                 end;
                                       end;
                             end;
                  LimpaLn(24,Tfd);
                end;
           2  : If X <> '3' then
                   begin
                     J := Copy(CMstMember.Conta,1,4);
                     InputStr(J,5,13,12,0,'S','N','T','N',Tfn,Utx);
                     CodX := J;
                   end;
           3  : If X <> '3' then
                   begin
                     J := Copy(CMstMember.Conta,6,1);
                     InputStr(J,1,20,12,0,'S','N','T','N',Tfn,Utx);
                     DvCX := J[1];
                   end;
           4  : If X <> '3' then
                   begin
                     J := Copy(CMstMember.Conta,8,7);
                     InputStr(J,6,13,13,0,'S','N','T','N',Tfn,Utx);
                     SeqX := J;
                   end;
           5  : If X <> '3' then
                   begin
                     J := Copy(CMstMember.Conta,Length(CMstMember.Conta),1);
                     InputStr(J,1,22,13,0,'S','N','T','N',Tfn,Utx);
                     DvSX := J[1];
                   end;
           6  : begin
                  Color(Tfn,Utx);
                  For I := 16 to 19 do
                  begin
                    GotoXY(33,I); Write(' ':25);
                  end;
                  GotoXY(13,14); Write(' ':40);
                  DrawBox(33,16,54,18,Red,'S');
                  Color(Red,Cyan);
                  GotoXY(33,16); Write(' 1  dep¢sito no prazo ');
                  GotoXY(33,17); Write(' 2  dep¢sito em atraso');
                  GotoXY(33,18); Write(' 3  filantr¢pica      ');
                  Color(Red,White);
                  GotoXY(34,16); Write('1');
                  GotoXY(34,17); Write('2');
                  GotoXY(34,18); Write('3');
                  J := '';
                  InputStr(J,1,13,14,0,'S','N','T','N',Tfn,Utx);
                  GotoXY(33,16); Write(' ':25);
                  GotoXY(33,17); Write(' ':25);
                  GotoXY(33,18); Write(' ':25);
                  GotoXY(33,19); Write(' ':25);
                  Tx := UpCase(J[1]);
                  GotoXY(13,14);
                  If TC <> #27 then
                     Case Tx of
                          '1' : Write('1  no prazo    ');
                          '2' : Write('2  em atraso   ');
                          '3' : Write('3  filantr¢pica');
                          else  begin
                                  Tx := '1';
                                  Write('1  No Prazo    ');
                                end;
                     end;
                end;
           7  : If X <> '3' then
                   begin
                     J := '';
                     InputStr(J,2,13,15,0,'S','N','T','N',Tfn,Utx);
                     Val(J,DiasF,E);
                     GotoXY(13,15); Write(DiasF:2);
                   end;
           8  : begin
                  J := '';
                  InputStr(J,1,13,16,0,'S','N','T','N',Tfn,Utx);
                  Eta := UpCase(J[1]);
                  GotoXY(13,16);
                  If TC <> #27 then
                     Case Eta of
                          'A' : Write('Pag.e 13§Sal rio');
                          'P' : Write('Pagamento       ');
                          '1' : Write('13§ Sal rio     ');
                          else  begin
                                  Eta := 'P';
                                  Write('Pagamento       ');
                                end;
                     end;
                end;
           9  : If X <> '3' then
                   begin
                     Move(MemW[$B800:0000],ScArray6[1],4000);
                     DrawBox(38,14,57,17,Red,'S');
                     Color(Red,Cyan);
                     GotoXY(38,15); Write(' Sim impr.matr¡cula ');
                     GotoXY(38,16); Write(' NÆo impr.matr¡cula ');
                     Color(Red,White);
                     GotoXY(39,15); Write('S');
                     GotoXY(39,16); Write('N');
                     J := NoMat;
                     InputStr(J,1,13,17,0,'S','S','T','N',Tfn,Utx);
                     NoMat := UpCase(J[1]);
                     Move(ScArray6[1],MemW[$B800:0000],4000);
                     GotoXY(13,17);
                     Case NoMat of
                          'N' : Write('NÆo imprime a matr¡cula');
                          'S' : Write('Sim imprime a matr¡cula');
                     end;
                   end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : begin
                   If K > 0 then K := K - 1;
                   TC := #13;
                 end;
      end;
    Until (K = 10) or (TC = #27);
    If TC <> #27 then Confirma;
  Until (TC = 'S') or (TC = #27);
end;


Procedure PedeCadastro;
begin
  Color(Tfn,Ttx);
  GotoXY(4,10); Write('Matr¡c:');
  If ProcNo <> 11 then
     begin
       GotoXY(4,11); Write('Tipo..:');
     end;
  Opc  := 'C';
  EENo := '';
  Repeat
    K := 1;
    Repeat
      Case K of
           1  :  With EEMember do
                 begin
                   Color(Blue,White);
                   GotoXY(1,24); Write(ConstStr(' ',80));
                   GotoXY(2,24); Write('F1');
                   Color(Blue,Cyan);
                   GotoXY(5,24); Write('para pesquisar Empregados');
                   Color(Tfn,Utx);
                   GotoXY(12,10); Write(' ':40);
                   J := EENo;
                   InputStr(J,8,12,10,0,'S','N','T','N',Tfn,Utx);
                   EENo := J;
                   If TC = #21 then
                      begin
                        EEAC := EENo;
                        ScrollFunc;
                        EENo := EEAC;
                      end
                      else If (TC   <> #27) and
                              (EENo <> '' ) then
                              begin
                                SearchTree5 ( Root5 );
                                If RC = 'S' then
                                   With EEMember do
                                   begin
                                     ReadWrite(#08,'R','N',EENumber);
                                     GotoXY(12,10); Write(' ':35);
                                     GotoXY(12,10); Write(EENo,' ',EEMember.Nome);
                                   end
                                   else begin
                                          ErroMsg := 'Empregado nÆo Existe';
                                          ErrorMessage;
                                          K := K - 1;
                                        end;
                                end
                                else If TC <> #27 then
                                        begin
                                          GotoXY(12,10);
                                          Write('********* Todos',' ':25);
                                          EENo := '';
                                        end;;
                   LimpaLn(24,Tfd);
                 end;
           2  :  If ProcNo <> 11 then
                    begin
                      Color(Tfn,Utx);
                      GotoXY(12,11); Write(' ':40);
                      J := Opc;
                      InputStr(J,1,12,11,0,'S','N','T','N',Tfn,Utx);
                      Opc := UpCase(J[1]);
                      GotoXY(12,11);
                      If Opc in ['C','P'] then
                         begin
                           Case Opc of
                                'C' : Write('Cadastro');
                                'P' : Write('Planilha');
                           end;
                         end
                         else begin
                                ErroMsg := 'Informe C ou P';
                                ErrorMessage;
                                K := K - 1;
                              end;
                    end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 3) or (TC = #27);
    If TC <> #27 then Confirma;
  Until TC in ['S',#27];

end;


Procedure HeaderReport;
Var
  Tot          : Integer;
  L            : AnyStr;
begin
  If ContLin < 1000 then Footer;
  ContPag := ContPag + 1;
  With CMstMember do
  begin
    If Laser in ['D','L']
       then WriteLine('W',LaserInit)
       else If ContLin < 1000
               then If Laser = 'N' then WriteLine('W',Qp)
                       else If Laser = 'X' then WriteLine('L',Qp);
    L       := Dx+Acentua(Descricao)+Df;
    ContLin := 0;
    WriteLine('L',L);
    WriteLine('L',ConstStr('-',80));
    WriteLine('L',Cx+Acentua(Endereco)+', '+Acentua(Numero)+' '+
                     Acentua(Complemento)+'  '+Acentua(Cidade)+' - '+
                     Estado+'  Cep: '+Cep+Cf);
  end;
  If NoMat = 'S' then
     begin
       If Laser = 'N' then Tot := 4
                      else Tot := 0;
       Writeline('L',ConstStr(' ',64)+'Pag.: '+
                     PushRight(10,EditInteger(ContPag)));
       WriteLine('L',Acentua(L1)+ConstStr(' ',64-(Length(L1)-Tot))+
                     'Data: '+XDia+'/'+XMes+'/'+XAno);
     end
     else begin
            Writeline('L',' ');
            WriteLine('L',Acentua(L1));
          end;
  If L2 <> '' then WriteLine('L',Acentua(L2));
  If L3 <> '' then WriteLine('L',Acentua(L3));
  If L4 <> '' then WriteLine('L',Acentua(L4));
  If L5 <> '' then WriteLine('L',Acentua(L5));
  WriteLine('L',' ');
  WriteLine('L',ConstStr('-',80));
  If L6 <> ''  then WriteLine('L',Acentua(L6));
  If L7 <> ''  then WriteLine('L',Acentua(L7));
  If L8 <> ''  then WriteLine('L',Acentua(L8));
  If L9 <> ''  then WriteLine('L',Acentua(L9));
  If L10 <> '' then WriteLine('L',Acentua(L10));
  WriteLine('L',ConstStr('-',80));
  WriteLine('L',' ');
end;


Procedure AbreTotal;
begin
  {$I-}
  Reset ( TotFile );
  {$I+}
  If IOResult <> 0 then
     begin
       ReWrite ( TotFile );
       Reset   ( TotFile );
     end
     else begin
            Close   ( TotFile );
            Erase   ( TotFile );
            ReWrite ( TotFile );
            Reset   ( TotFile );
          end;
  For I := 1 to 14 do NoStat[I] := 0;
  TotMember.Ocupado := ' ';
  TotMember.Mensal  := 0;
  TotMember.HoraM   := 0;
  TotMember.MinutoM := 0;
  TotMember.Anual   := 0;
  TotMember.HoraA   := 0;
  TotMember.MinutoA := 0;
  CCNo := '';
  Repeat
    RC := 'N';
    SearchPos1 ( Root1 );
    If RC = 'S' then
       begin
         Seek  ( TotFile, CCNumber  );
         Write ( TotFile, TotMember );
       end
  Until RC = 'N';
  RC    := 'S';
  T3[1] := 0;
  T4[1] := 0;
end;


Procedure AcumulaTotal;
begin
  Seek ( TotFile, CCNumber  );
  Read ( TotFile, TotMember );
  TotMember.Ocupado := '*';
  TotMember.Mensal  := TotMember.Mensal  + TruncX(YAddress^.AcMensalV);
  TotMember.HoraM   := TotMember.HoraM   + YAddress^.AcMensalH;
  TotMember.MinutoM := TotMember.MinutoM + YAddress^.AcMensalM;
  TotMember.Anual   := TotMember.Anual   + TruncX(YAddress^.AcAnualV);
  TotMember.HoraA   := TotMember.HoraA   + YAddress^.AcAnualH;
  TotMember.MinutoA := TotMember.MinutoA + YAddress^.AcAnualM;
  Case CCMember.Tipo of
       'D' : T3[1] := T3[1] + TruncX(YAddress^.AcMensalV);
       'P' : T4[1] := T4[1] + TruncX(YAddress^.AcMensalV);
  end;
  Seek  ( TotFile, CCNumber  );
  Write ( TotFile, TotMember );
end;


Procedure ImprimeTotal;
begin
  CCNo := '';
  Repeat
    RC := 'N';
    SearchPos1 ( Root1 );
    If RC = 'S' then
       begin
         ReadWrite(#04,'R','N',CCNumber);
         {$I-}
         Seek ( TotFile, CCNumber  );
         Read ( TotFile, TotMember );
         {$I+}
         If (IOResult          = 0  ) and
            (TotMember.Ocupado = '*') and
            (CCNo[1]          <> '9') then
            begin
              If ContLin > 56 then HeaderReport;
              If TotMember.MinutoM > 60 then
                 begin
                   Valor             := Trunc(TotMember.MinutoM / 60);
                   TotMember.MinutoM := TotMember.MinutoM - (Valor * 60);
                   TotMember.HoraM   := TotMember.MinutoM + Valor;
                 end
                 else If TotMember.MinutoM = 60 then
                         begin
                           TotMember.MinutoM := 0;
                           TotMember.HoraM   := Totmember.HoraM + 1;
                         end;
              TotMember.MinutoA := TotMember.MinutoA + TotMember.MinutoM;
              TotMember.HoraA   := TotMember.HoraA   + TotMember.HoraM;
              If TotMember.MinutoA > 60 then
                 begin
                   Valor             := Trunc(TotMember.MinutoA / 60);
                   TotMember.MinutoA := TotMember.MinutoA - (Valor * 60);
                   TotMember.HoraA   := TotMember.MinutoA + Valor;
                 end
                 else If TotMember.MinutoA = 60 then
                         begin
                           TotMember.MinutoA := 0;
                           TotMember.HoraA   := TotMember.HoraA + 1;
                         end;
              WriteLine('L',ConstStr(' ',10)+Cx+PushRight(3,CCNo)+' '+
                            Acentua(CCMember.Descricao)+
                            ConstStr(' ',31-Length(CCMember.Descricao))+
                            CCMember.Tipo+' '+
                            QQStr(TotMember.HoraM,5,' ')+':'+
                            QQStr(TotMember.MinutoM,2,'0')+' '+
                            PushRight(18,EditReal(TotMember.Mensal))+' '+
                            QQStr(TotMember.HoraA,6,' ')+':'+
                            QQStr(TotMember.MinutoA,2,'0')+' '+
                            PushRight(22,EditReal(TotMember.Anual))+Cf);
            end;
         TotMember.Ocupado := ' ';
         TotMember.Mensal  := 0;
         TotMember.HoraM   := 0;
         TotMember.MinutoM := 0;
         TotMember.Anual   := 0;
         TotMember.HoraA   := 0;
         TotMember.MinutoA := 0;
         Seek  ( TotFile, CCNumber  );
         Write ( TotFile, TotMember );
       end;
  Until RC = 'N';
  WriteLine('L',ConstStr(' ',10)+Cx+'*** Total de Proventos'+
                ConstStr(' ',20)+PushRight(22,EditReal(T4[1]))+Cf);
  WriteLine('L',ConstStr(' ',10)+Cx+'*** Total de Descontos'+
                ConstStr(' ',20)+PushRight(22,EditReal(T3[1]))+Cf);
  If ContLin > 40 then HeaderReport;
  WriteLine('L',' ');
  WriteLine('L',ConstStr(' ',16)+
                '**********************************************');
  WriteLine('L',ConstStr(' ',26)+Acentua('Situa‡„o dos Empregados'));
  WriteLine('L',ConstStr(' ',16)+
                '**********************************************');
  WriteLine('L',' ');
  WriteLine('L',ConstStr(' ',24)+'Ativos                     '+
                PushRight(4,EditInteger(NoStat[1])));
  WriteLine('L',ConstStr(' ',24)+'Acidentados                '+
                PushRight(4,EditInteger(NoStat[2])));
  WriteLine('L',ConstStr(' ',24)+'Demitidos                  '+
                PushRight(4,EditInteger(NoStat[3])));
  WriteLine('L',ConstStr(' ',24)+'Tranferidos (Entrada)      '+
                PushRight(4,EditInteger(NoStat[4])));
  WriteLine('L',ConstStr(' ',24)+Acentua('F‚rias                     ')+
                PushRight(4,EditInteger(NoStat[5])));
  WriteLine('L',ConstStr(' ',24)+'Demitidos por Justa Causa  '+
                PushRight(4,EditInteger(NoStat[6])));
  WriteLine('L',ConstStr(' ',24)+Acentua('Licen‡a                    ')+
                PushRight(4,EditInteger(NoStat[7])));
  WriteLine('L',ConstStr(' ',24)+'Morte                      '+
                PushRight(4,EditInteger(NoStat[8])));
  WriteLine('L',ConstStr(' ',24)+'Aposentados                '+
                PushRight(4,EditInteger(NoStat[9])));
  WriteLine('L',ConstStr(' ',24)+Acentua('Pediram demiss„o           ')+
                PushRight(4,EditInteger(NoStat[10])));
  WriteLine('L',ConstStr(' ',24)+Acentua('Transferidos (Sa¡da)       ')+
                PushRight(4,EditInteger(NoStat[11])));
  WriteLine('L',ConstStr(' ',24)+Acentua('Aviso Pr‚vio               ')+
                PushRight(4,EditInteger(NoStat[12])));
  WriteLine('L',ConstStr(' ',24)+'Rescindidos                '+
                PushRight(4,EditInteger(NoStat[13])));
  WriteLine('L',ConstStr(' ',24)+Acentua('Marcados para Exclus„o     ')+
                PushRight(4,EditInteger(NoStat[14])));
  WriteLine('L',ConstStr(' ',24)+'                           ----');
  K := 0;
  For I := 1 to 14 do K := K + NoStat[I];
  WriteLine('L',ConstStr(' ',24)+Acentua('Total de Empregados        ')+
            PushRight(4,EditInteger(K)));
  WriteLine('L',' ');
  K := Trunc(R1);
  WriteLine('L',ConstStr(' ',24)+Acentua('Total de Horas Trab.     ')+
            PushRight(6,EditInteger(K)));
end;


Procedure ProcNo04Bases;
begin
  Case Opc of
       'P' : begin
               YYNo := '083';
               SearchTreeY ( RootY );
               If RC = 'S' then R5 := YAddress^.AcMensalV
                           else R5 := 0;
               YYNo := '063';
               SearchTreeY ( RootY );
               If RC = 'S' then R6 := YAddress^.AcMensalV
                           else R6 := 0;
               WriteLine('L',ConstStr(' ',10)+
                         '083 B.Fgts. '+PushRight(13,EditReal(R5))+
                         ConstStr(' ',6)+
                         '063 Fgts... '+PushRight(13,EditReal(R6))+' '+
                         'P.Ven. '+PushRight(6,EditInteger(EEMember.PeriodoV)));
               YYNo := '081';
               SearchTreeY ( RootY );
               If RC = 'S' then R5 := YAddress^.AcMensalV
                           else begin
                                  R5 := 0;
                           {       YYNo := 'R81';
                                  SearchTreeY ( RootY );
                                  If RC = 'S' then R5 := YAddress^.AcMensalV;
                                  YYNo := 'R85';
                                  SearchTreeY ( RootY );
                                  If RC = 'S' then R5 := R5 + YAddress^.AcMensalV; }
                                end;
               YYNo := '082';
               SearchTreeY ( RootY );
               If RC = 'S' then R6 := YAddress^.AcMensalV
                           else begin
                                  YYNo := 'R82';
                                  SearchTreeY ( RootY );
                                  If RC = 'S' then R6 := YAddress^.AcMensalV;
                                end;
               Horas(R2*60);
               WriteLine('L',ConstStr(' ',10)+
                         '081 B.INSS. '+PushRight(13,EditReal(R5))+
                         ConstStr(' ',6)+
                         '082 B.IR... '+PushRight(13,EditReal(R6))+' '+
                         'HTrab.'+PushRight(3,EditInteger(Hora))+':'+
                         QQStr(Minuto,2,'0'));
             end;
       'S' : begin
               YYNo := '087';
               SearchTreeY ( RootY );
               If RC = 'S' then R5 := YAddress^.AcMensalV
                           else R5 := 0;
               YYNo := '072';
               SearchTreeY ( RootY );
               If RC = 'S' then R6 := YAddress^.AcMensalV
                           else R6 := 0;
               WriteLine('L',ConstStr(' ',10)+
                         '087 B.Fgts. '+PushRight(13,EditReal(R5))+
                         ConstStr(' ',6)+
                         '072 Fgts... '+PushRight(13,EditReal(R6)));
               YYNo := '085';
               SearchTreeY ( RootY );
               If RC = 'S' then R5 := YAddress^.AcMensalV
                           else R5 := 0;
               YYNo := '086';
               SearchTreeY ( RootY );
               If RC = 'S' then R6 := YAddress^.AcMensalV
                           else R6 := 0;
               WriteLine('L',ConstStr(' ',10)+
                         '085 B.INSS. '+PushRight(13,EditReal(R5))+
                         ConstStr(' ',6)+
                         '086 B.IR... '+PushRight(13,EditReal(R6)));
             end;
  end;
end;


Procedure FormTest(X,Y : Char; Suf : Str3);
Var
  C1,C2,L1,L2,Xw,Yw   : Byte;
begin
  Xw  := WhereX;
  Yw  := WhereY;
  C1 := 1 + Lo(WindMin);
  L1 := 1 + Hi(WindMin);
  C2 := 1 + Lo(WindMax);
  L2 := 1 + Hi(WindMax);
  Window(1,1,80,25);
  If X = 'S' then
     begin
       Color(Blue,Cyan);
       GotoXY(1,23);  Write(ConstStr(' ',80));
       GotoXY(2,23);
       Write('O formul rio est  posicionado adequadamente ?');
       Color(Red,Cyan);
       GotoXY(1,24);  Write(ConstStr(' ',80));
       GotoXY(2,24);
       Write('Responda [ im ou  Æo]      (<N> ',#26,' Teste de posicionamento do Papel)');
       Color(Red,White);
       GotoXY(12,24); Write('S');
       GotoXY(19,24); Write('N');
       Color(Tfn,Utx);
       Repeat
         TC := UpCase(ReadKey);
       Until (TC = #27) or (TC = 'S') or (TC = 'N');
       If TC = 'N' then
          begin
            Repeat
              Case ProcNo of
                   16 : begin
                          For I := 1 to 8 do WriteLine('L',ConstStr('*',31));
                          WriteLine('L',' ');
                        end;
                   else WriteLine('L','*');
              end;
              Repeat
                TC := UpCase(ReadKey);
              Until TC in [#27,'S','N'];
            Until TC in [#27,'S'];
          end;
       LimpaLn(23,Tfd);
       LimpaLn(24,Tfd);
     end
     else TC := 'S';
  If (TC = 'S') and (Y = 'T') then
     begin
       SelectTxt(Copy(XPath,1,Length(XPath)-4) + 'TEXT',Suf);
       If TxtPath <> '' then
          begin
            Assign ( TxtFile, (TxtPath));
            {$I-}
            Reset ( TxtFile );
            {$I+}
            If IOResult <> 0 then TC := #27
                             else TC := 'S';
          end
          else TC := #27;
     end;
  Window(C1,L1,C2,L2);
  GotoXY(Xw,Yw);
  Color(Sfn,Stx);
end;


Procedure ImprimeTexto(X : Char);
Var
  RegLst,RegTxt : AnyStr;

begin
  If DskRpt = 'N' then If Laser <> 'N' then WriteLine('W',LaserInit);
  While (not Eof(TxtFile)) and (TC <> #27) do
  begin
    {$I-}
    Readln(TxtFile,RegTxt);
    {$I+}
    If IOResult = 0 then
       begin
         TC     := #13;
         RegLst := Substitui(RegTxt);
         Case X of
              'S' : Case TC of
                         #13 : WriteLine('L',Acentua(RegLst));
                         else  WriteLine('W',Acentua(RegLst));
                    end;
              'N' : Case TC of
                         #13 : WriteLine('L',RegLst);
                         else  WriteLine('W',RegLst);
                    end;
         end;
       end;
  end;
  Reset ( TxtFile );
  TC := #13;
end;


Procedure CloseTexto;
begin
  Close ( TxtFile );
end;

Procedure PedeMesAno;
begin
  MMx := '';
  AAx := '';
  Repeat
    K := 1;
    Repeat
      Case K of
           1 : begin
                 J := MMx;
                 InputStr(J,2,12,10,0,'S','N','T','N',Tfn,Utx);
                 If TC <> #27 then
                    begin
                      If J = '' then
                         begin
                           Str(MM,J);
                           J := LeftAdjust(J);
                         end
                         else Val(J,MM,E);
                      If (MM < 01) or (MM > 12) then
                         begin
                           ErroMsg := 'Mˆs invalido';
                           ErrorMessage;
                           K := K - 1;
                         end
                         else begin
                                If Length(J) = 1 then MMx := '0' + J
                                                 else MMx := J;
                                GotoXY(12,10); Write(MMx,' ',PushLeft(15,ArrayMesEx[MM]));
                              end;
                    end;
               end;
           2 : begin
                 J := AAx;
                 InputStr(J,4,12,11,0,'S','N','T','N',Tfn,Utx);
                 If TC <> #27 then
                    begin
                      If J = '' then Str(AA,J);
                      AAx := J;
                      If AAx = '' then
                         begin
                           ErroMsg := 'Ano inv lido';
                           ErrorMessage;
                           K := K - 1;
                         end
                         else begin
                                GotoXY(12,11); Write(AAx);
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


Procedure ImprimeAgora;
Var
  C1,C2,L1,L2,X,Y   : Byte;
begin
  X  := WhereX;
  Y  := WhereY;
  C1 := 1 + Lo(WindMin);
  L1 := 1 + Hi(WindMin);
  C2 := 1 + Lo(WindMax);
  L2 := 1 + Hi(WindMax);
  Window(1,1,80,25);
  Color(Red,Cyan);
  GotoXY(01,24);  Write(ConstStr(' ',80));
  GotoXY(02,24);  Write('Emite agora ou guarda para emissÆo geral? (A/G)');
  Color(Red,White);
  GotoXY(45,24); Write('A');
  GotoXY(47,24); Write('G');
  Repeat
    TC := UpCase(ReadKey);
  Until TC in [#27,'A','G'];
  Window(C1,L1,C2,L2);
  GotoXY(X,Y);
  Color(Sfn,Stx);
end;


Procedure PedeProcXX;
begin
  Color(Tfn,Ttx);
  GotoXY(4,10); Write('Mud.En:');
  GotoXY(4,11); Write('Enc.At:');
  GotoXY(4,12); Write('1¦ Dec:');
  GotoXY(4,13); Write('Corr.D:');
  GotoXY(4,14); Write('Respon:');
  Color(Tfn,Utx);
  Mud  := 'N';
  Enc  := 'N';
  Dec1 := 'N';
  Corr := 'N';
  Repeat
    K := 1;
    Repeat
      Case K of
           1  :  begin
                   J := '';
                   InputStr(J,1,12,10,0,'S','N','T','N',Tfn,Utx);
                   If J  = ''  then J := 'N';
                   If J <> 'N' then J := 'S';
                   Mud := UpCase(J[1]);
                   GotoXY(12,10); Write(Mud);
                 end;
           2  :  begin
                   J := '';
                   InputStr(J,1,12,11,0,'S','N','T','N',Tfn,Utx);
                   If J  = ''  then J := 'N';
                   If J <> 'N' then J := 'S';
                   Enc := UpCase(J[1]);
                   GotoXY(12,11); Write(Enc);
                 end;
           3  :  begin
                   J := '';
                   InputStr(J,1,12,12,0,'S','N','T','N',Tfn,Utx);
                   If J  = ''  then J := 'N';
                   If J <> 'N' then J := 'S';
                   Dec1 := UpCase(J[1]);
                   GotoXY(12,12); Write(Dec1);
                 end;
           4  :  begin
                   J := '';
                   InputStr(J,1,12,13,0,'S','N','T','N',Tfn,Utx);
                   If J  = ''  then J := 'N';
                   If J <> 'N' then J := 'S';
                   Corr := UpCase(J[1]);
                   GotoXY(12,13); Write(Corr);
                 end;
           5  :  begin
                   J := '';
                   InputStr(J,30,12,14,0,'S','S','T','N',Tfn,Utx);
                   Responsavel := J;
                   GotoXY(12,14); Write(Responsavel);
                 end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 6) or (TC = #27);
    If TC <> #27 then Confirma;
  Until (TC = 'S') or (TC = #27);
end;


Procedure PedeProc15;
begin
  Color(Tfn,Ttx);
  GotoXY(4,10); Write('R ou G:');
  GotoXY(4,11); Write('Tipo..:');
  DARFMember.Venc    := '';
  DARFMember.Receita := '';
  Tx                 := 'R';
  Folha              := 'N';
  Repeat
    K := 1;
    Repeat
      Case K of
           1 : begin
                 J := Tx;
                 InputStr(J,1,12,10,0,'S','N','T','N',Tfn,Utx);
                 If TC <> #27 then
                    begin
                      Tx := UpCase(J[1]);
                      If (Tx <> 'G') and (Tx <> 'R') then
                         begin
                           ErroMsg := 'Tipo inv lido';
                           ErrorMessage;
                           K := K - 1;
                         end
                         else begin
                                GotoXY(12,10);
                                Case Tx of
                                     'G' : Write('Guia (DARF) ');
                                     'R' : Write('Relat¢rio   ');
                                end;
                              end;
                    end;
               end;
           2 : begin
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
                 InputStr(J,1,12,11,0,'S','S','T','N',Tfn,Utx);
                 Folha := UpCase(J[1]);
                 Move(ScArray6[1],MemW[$B800:0000],4000);
                 GotoXY(12,11);
                 Case Folha of
                      'N' : Write('Folha de empregados');
                      'A' : Write('Folha de Aut“nomos');
                      'E' : Write('Folha de empregadores');
                      'T' : Write('Todos');
                 end;
               end;
           3 : If Tx = 'G' then
                  begin
                    J := DARFMember.Venc;
                    DARFMember.Venc := PedeData(12,12,'Data..:');
                  end;
           4 : If Tx = 'G' then
                  begin
                    Color(Tfn,Ttx);
                    GotoXY(4,13); Write('Receit:');
                    J := DARFMember.Receita;
                    InputStr(J,20,12,13,0,'S','N','T','N',Tfn,Utx);
                    DARFMember.Receita := J;
                  end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (TC in [#27,'S','N']) or (K = 5);
    If TC <> #27 then Confirma;
  Until TC in [#27,'S'];
end;


end.

