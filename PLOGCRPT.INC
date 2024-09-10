
Procedure GoNoGo;
begin
  If KeyPressed then
     begin
       TC := ReadKey;
       If TC = #13 then
          Repeat
            TC := ReadKey;
          Until TC in [#13,#27];
     end;
end;


Procedure Header;
Var
  L            : AnyStr;
begin
  If ContLin <> 1000 then Footer;
  ContPag := ContPag + 1;
  With CMstMember do
  begin
    If Laser = 'S' then WriteLine('W',LaserInit)
                   else If ContLin < 1000 then WriteLine('W',Qp);
    L       := Dx+Acentua(Descricao)+Df;
    ContLin := 0;
    WriteLine('L',L);
    WriteLine('L',ConstStr('-',80));
    WriteLine('L',Cx+Acentua(Endereco)+', '+Numero+' '+
                  Acentua(Cidade)+', '+Estado+
                 '  Cep: '+Cep+Cf);
  end;
  Writeline('L',ConstStr(' ',66)+'Pag.: '+PushRight(8,EditInteger(ContPag)));
  WriteLine('L',Acentua(L1)+
                ConstStr(' ',66-(Length(L1)-4))+
                'Data: '+XDia+'/'+XMes+'/'+XAno);
  WriteLine('L',' ');
  WriteLine('L',ConstStr('-',80));
  If L2 <> '' then WriteLine('L',Acentua(L2));
  WriteLine('L',ConstStr('-',80));
  WriteLine('L',' ');
end;



Procedure TabelaCC;
begin
  QPorta;
  If TC <> #27 then
     begin
       L1 := Nx+'TABELA DE CONTABILIZACAO'+Nf;
       L2 := 'Cta Depto. Sq Class.Cont bil     %Valor T S Hist¢ricos';
       L3 := '';
       ParaContinua;
       ContLin := 1000;
       ContPag := 0;
       TCNo    := '';
       Repeat
         RC := 'N';
         SearchPos12 ( Root12 );
         If RC = 'S' then
            begin
              Seek ( TCFile, TCNumber );
              Read ( TCFile, TCMember );
              If ContLin > 60 then Header;
              NCont := NCont + 1;
              If TCMember.Historico[1] <> ''
                 then I := 1
                 else If TCMember.Historico[2] <> '' then I := 2
                                                     else I := 3;
              WriteLine('L',PushLeft(4,TCMember.Conta)+
                            PushLeft(7,TCMember.LocalCC)+
                            PushLeft(3,TCMember.Seq)+
                            PushLeft(19,TCMember.ContaA)+
                            PushRight(6,EditReal(TCMember.Percentual))+
                            PushRight(2,TCMember.Tipo)+
                            PushRight(2,TCMember.Status)+' '+Cx+
                            Acentua(TCMember.Historico[I])+Cf);
              If I < 3 then For I := I+1 to 3 do
                            If TCMember.Historico[I] <> ''
                               then WriteLine('L',ConstStr(' ',44)+
                                                  Cx+Acentua(TCMember.Historico[I])+Cf);
              GoNoGo;
              If TC = #27 then RC := 'N';
            end;
       Until RC = 'N';
       If NCont > 0 then
          begin
            Footer;
            If DskRpt = 'N' then WriteLine('W',Qp);
          end;
       Color(Blue,Black);
       GotoXY(1,23);  Write(ConstStr(' ',80));
       GotoXY(1,23);  Write(' Total de Elementos Impressos: ');
       Color(Blue,White);
       GotoXY(32,23); Write(NCont:5);
       TeclaReturn;
       Close ( LST );
     end;
end;


Procedure RelContabilCC;
begin
  QPorta;
  If TC <> #27 then PedeConstante;
  If TC = 'S' then
     begin
       Close ( BBFile );
       Close ( SSFile );
       Close ( DDFile );
       WData := QQStr(TabDia[MM],2,'0') + '/' +
                QQStr(MM,2,'0')         + '/' +
                QQStr(AA,2,'0');
       TC    := 'S';
       Assign ( MovFile, (XPath + '\PLOGXXXX.WRK'));
       {$I-}
       Reset ( MovFile );
       {$I+}
       If IOResult <> 0 then ReWrite ( MovFile )
          else begin
                 Close   ( MovFile );
                 Erase   ( MovFile );
	         ReWrite ( MovFile );
               end;
       MovMember.Status       := ' ';
       MovMember.OrigData     := '';
       MovMember.Conta        := '';
       MovMember.MesLancto    := 0;
       MovMember.Tipo         := ' ';
       MovMember.Valor        := 0;
       MovMember.Depto        := '';
       MovMember.Historico[1] := '';
       MovMember.Historico[2] := '';
       MovMember.Historico[3] := '';
       MovMember.Lote         := '';
       MovMember.SeqLote      := '';
       Contabiliza;
       L1 := Nx+'CONTABILIZACAO da FOLHA de '+Nf+WData;
       L2 := 'Classif.Cont bil   T Depto.  Valor do Lan‡to. Hist¢ricos';
       ParaContinua;
       ContLin := 1000;
       ContPag := 0;
       K       := -1;
       If FileSize(MovFile) > 0 then
          Repeat
            K := K + 1;
            Seek ( MovFile, K         );
            Read ( MovFile, MovMember );
            If ContLin > 60 then Header;
            NCont := NCont + 1;
            If MovMember.Historico[1] <> ''
               then I := 1
               else If MovMember.Historico[2] <> '' then I := 2
                                                    else I := 3;
            WriteLine('L',PushLeft(19,MovMember.Conta)+
                       PushLeft(2,MovMember.Tipo)+
                       PushLeft(7,MovMember.Depto)+
                       PushRight(17,EditReal(MovMember.Valor))+' '+
                       Cx+Acentua(MovMember.Historico[I])+Cf);
            If I < 3 then For I := I+1 to 3
               do If MovMember.Historico[I] <> ''
                     then WriteLine('L',ConstStr(' ',46)+
                                    Cx+Acentua(MovMember.Historico[I])+Cf);
            GoNoGo;
            If TC = #27 then K := FileSize(MovFile) - 1;
          Until (K + 1) = FileSize(MovFile);
       If NCont > 0 then
          begin
            Footer;
            If DskRpt = 'N' then WriteLine('W',Qp);
          end;
       Color(Blue,Black);
       GotoXY(1,23);  Write(ConstStr(' ',80));
       GotoXY(1,23);  Write(' Total de Lan‡amentos Impressos: ');
       Color(Blue,White);
       GotoXY(34,23); Write(NCont:5);
       TeclaReturn;
       Close ( MovFile );
       Erase ( MovFile );
       Close ( LST );
       Reset ( BBFile );
       Reset ( SSFile );
       Reset ( DDFile );
     end;
end;


Procedure Totaliza;
begin
  Close ( BBFile );
  Close ( SSFile );
  Assign ( CusFile, (XPath + '\PLOGXXXX.WRK'));
  {$I-}
  Reset ( CusFile );
  {$I+}
  If IOResult <> 0 then ReWrite ( CusFile )
     else begin
            Close   ( CusFile );
            Erase   ( CusFile );
	    ReWrite ( CusFile );
          end;
  If Root6 <> NIL then Dispose6 ( Root6 );
  Root6 := NIL;
  Color(Blue,White);
  GotoXY(1,24); Write(ConstStr(' ',80));
  GotoXY(2,24); Write('Estou totalizando, Aguarde');
  EENo := '';
  Repeat
    RC := 'N';
    SearchPos5 ( Root5 );
    If RC = 'S' then
       begin
         ReadWrite(#08,'R','N',EENumber);
         EENo := EEMember.Matricula;
         LoadMVDsk(#11);
         YYNo := '';
         Repeat
           RC := 'N';
           SearchPosY ( RootY );
           If RC = 'S' then
              begin
                CCNo := YYNo;
                SearchTree1 ( Root1 );
                If RC = 'S' then
                   begin
                     ReadWrite(#04,'R','N',CCNumber);
                     If CCMember.Custo = 'S' then
                        begin
                          CusMember.Conta     := CCNo;
                          CusMember.Descricao := CCMember.Descricao;
                          If EEMember.CentroC[1] <> '' then
                             begin
                               BaseD := 0;
                               For I := 1 to 5 do
                               If EEMember.CentroC[I] <> '' then BaseD := BaseD + EEMember.DiasC[I];
                               If BaseD > 0 then
                                  begin
                                    For I := 1 to 5 do
                                    If EEMember.CentroC[I] <> '' then
                                       begin
                                         XXNo := EEMember.CentroC[I] + '#' + CCNo;
                                         SearchTree6 ( Root6 );
                                         If RC = 'N' then
                                            begin
                                              CusMember.Departamento := EEMember.CentroC[I];
                                              CusMember.valor        := 0;
                                              XXNumber := FileSize(CusFile);
                                              LoadTree6 ( Root6 );
                                            end
                                            else begin
                                                   Seek ( CusFile, XXNumber  );
                                                   Read ( CusFile, CusMember );
                                                 end;
                                         CusMember.Valor := CusMember.Valor +
                                         TruncX((YAddress^.AcMensalV/BaseD)*EEMember.DiasC[I]);
                                         Seek ( CusFile, XXNumber  );
                                         Write( CusFile, CusMember );
                                       end;
                                  end;
                             end
                             else begin
                                    XXNo := EEMember.Depto + '#' + CCNo;
                                    SearchTree6 ( Root6 );
                                    If RC = 'N' then
                                       begin
                                         CusMember.Departamento := EEMember.Depto;
                                         CusMember.valor        := 0;
                                         XXNumber := FileSize(CusFile);
                                         LoadTree6 ( Root6 );
                                       end
                                       else begin
                                              Seek ( CusFile, XXNumber  );
                                              Read ( CusFile, CusMember );
                                            end;
                                    CusMember.Valor := CusMember.Valor +
                                                       TruncX(YAddress^.AcMensalV);
                                    Seek ( CusFile, XXNumber  );
                                    Write( CusFile, CusMember );
                                  end;
                          RC := 'S';
                        end;
                   end;
              end;
         Until RC = 'N';
         RC := 'S';
       end;
  Until RC = 'N';
  LimpaLn(23,Tfd);
end;


Procedure RelCusto;
Var
  Total    : Real;
begin
  QPorta;
  If TC <> #27 then
     begin
       Totaliza;
       L1 := Nx+'CUSTO da FOLHA de '+Nf+QQStr(MM,2,'0')+'/'+QQStr(AA,2,'0');
       L2 := '         Conta Descri‡„o                                     Valor';
       ParaContinua;
       DrawBox(26,10,67,19,Sfn,'S');
       Color(Bfn,Btx);
       GotoXY(26,10); Write('              Departamentos               ');
       Color(Sfn,Stx);
       Window(27,12,67,19);
       GotoXY(1,8);
       NCont   := 0;
       ContLin := 1000;
       ContPag := 0;
       Total   := 0;
       DDAC    := '';
       XXNo    := '';
       Repeat
         RC := 'N';
         SearchPos6 ( Root6 );
         If RC = 'S' then
            begin
              NCont := NCont + 1;
              Seek ( CusFile, XXNumber  );
              Read ( CusFile, CusMember );
              If ContLin > 57 then Header;
              If CusMember.Departamento <> DDAC then
                 begin
                    If DDAC <> '' then
                       begin
                         WriteLine('L',ConstStr(' ',46)+ConstStr('-',20));
                         WriteLine('L',ConstStr(' ',46)+PushRight(20,EditReal(Total)));
                         Total := 0;
                       end;
                   DDAC := CusMember.Departamento;
                   WriteLine('L',' ');
                   DDNo := CusMember.Departamento;
                   SearchTree3 ( Root3 );
                   If RC = 'S' then
                      begin
                        ReadWrite(#05,'R','N',DDNumber);
                        WriteLine('L',PushLeft(11,DDNo)+Acentua(DDMember.Descricao));
                        WriteLn(DDMember.Descricao);
                      end
                      else begin
                             WriteLine('L',PushLeft(11,DDNo)+Acentua('** N„o esta definido'));
                             WriteLn('NÆo esta definido');
                           end;
                   WriteLine('L',' ');
                   RC := 'S';
                 end;
              WriteLine('L',ConstStr(' ',9)+PushLeft(6,CusMember.Conta)+
                          Acentua(CusMember.Descricao)+
                          ConstStr(' ',31-Length(CusMember.Descricao))+
                          PushRight(20,EditReal(CusMember.Valor)));
              Total := Total + TruncX(CusMember.Valor);
            end;
         GoNoGo;
         If TC = #27 then RC := 'N';
       Until RC = 'N';
       Window(1,1,80,25);
       If NCont > 0 then
          begin
            If ContLin > 57 then Header;
            WriteLine('L',ConstStr(' ',46)+ConstStr('-',20));
            WriteLine('L',ConstStr(' ',46)+PushRight(20,EditReal(Total)));
            Footer;
            If DskRpt = 'N' then WriteLine('W',Qp);
          end;
       Color(Blue,Black);
       GotoXY(1,23);  Write(ConstStr(' ',80));
       GotoXY(1,23);  Write(' Total de transa‡”es impressas: ');
       Color(Blue,White);
       GotoXY(33,23); Write(NCont:5);
       TeclaReturn;
       Close ( CusFile );
       Erase ( CusFile );
       Close ( LST );
       Reset ( BBFile );
       Reset ( SSFile );
       If Root6 <> NIL then Dispose6 ( Root6 );
       Root6 := NIL;
     end;
end;


Procedure QueArquivo;
begin
  Color(Blue,White);
  GotoXY(1,23); Write(ConstStr(' ',80));
  GotoXY(2,23); Write('Entre o PATH e o Nome do ARQUIVO:');
  XDisco := '';
  Repeat
    K := 1;
    Repeat
      J := XDisco;
      InputStr(J,40,36,23,0,'S','N','T','N',Blue,Yellow);
      XDisco := UpCaseStr(J);
      GotoXY(36,23); Write(XDisco);
      If (XDisco[1] <> 'A') and
         (XDisco[1] <> 'B') and
         (XDisco[1] <> 'C') and
         (XDisco[1] <> 'D') and
         (XDisco[1] <> 'E') and
         (XDisco[1] <> 'F') and
         (TC        <> #27) then
         begin
           ErroMsg := 'Informe o Drive:\Path\Arquivo';
           ErrorMessage;
           TC := #00;
         end;
    Until TC in [#13,#27];
    If TC <> #27 then Confirma;
  Until TC in [#27,'S'];
end;


Procedure MontaDisco;
begin
  Color(Blue,Cyan);
  GotoXY(1,23); Write(' ':80);
  GotoXY(2,23); Write('Monte o disquete no drive ',Copy(XDisco,1,2));
  Color(Red,Cyan);
  GotoXY(01,24);  Write(ConstStr(' ',80));
  GotoXY(66,24);  Write('Tecle <     > ');
  Color(Red,White);
  GotoXY(73,24); Write('Enter');
  Repeat
    TC := ReadKey;
  Until TC in [#13,#27];
  LimpaLn(23,Tfd);
  LimpaLn(24,Tfd);
end;




Procedure ArqCusto;
Var
  Erro      : Integer;
  Regtxt    : AnyStr;
  St1,St2   : String[30];
begin
  QueArquivo;
  If TC = 'S' then
     begin
       If XDisco[1] in ['A','B'] then MontaDisco
                                 else TC := #13;
       If TC = #13 then
          begin
            Assign ( TxtFile, (XDisco));
            Repeat
              {$I-}
              ReWrite ( TxtFile );
              {$I+}
              Erro := IOResult;
              If Erro = 0 then
                 begin
                   Close   ( TxtFile );
                   Erase   ( TxtFile );
                   ReWrite ( TxtFile );
                 end;
              If Erro = 152 then
                 begin
                   ErroMsg := 'Verifique o Drive.';
                   ErrorMessage;
                   TC := 'N';
                 end
                 else If Erro <> 0 then TC := #27
                                   else TC := 'S';
            Until TC in [#27,'S'];
            If TC = 'S' then
               begin
                 Totaliza;
                 DrawBox(26,10,67,19,Sfn,'S');
                 Color(Bfn,Btx);
                 GotoXY(26,10); Write('              Departamentos               ');
                 Color(Sfn,Stx);
                 Window(27,12,67,19);
                 GotoXY(1,8);
                 NCont := 0;
                 XXNo  := '';
                 DDAC  := '';
                 Repeat
                   RC := 'N';
                   SearchPos6 ( Root6 );
                   If RC = 'S' then
                      begin
                        NCont := NCont + 1;
                        Seek ( CusFile, XXNumber  );
                        Read ( CusFile, CusMember );
                        If CusMember.Departamento <> DDAC then
                           begin
                             DDNo := CusMember.Departamento;
                             DDAC := DDNo;
                             SearchTree3 ( Root3 );
                             If RC = 'S' then
                                begin
                                  ReadWrite(#05,'R','N',DDNumber);
                                  WriteLn(DDMember.Descricao);
                                end
                                else begin
                                       WriteLn('Centro de Custo');
                                     end;
                             RC := 'S';
                           end;
                        Str(CusMember.Valor:20:2,St1);
                        St1 := LeftAdjust(St1);
                        If Length(St1) < 20 then St2 := Copy(Zeros,1,(20 - Length(St1))) + St1
                                            else St2 := St1;
                        {$I-}
                        Writeln (TxtFile,CusMember.Departamento,',',
                                  CusMember.Conta,',',
                                  PushLeft(30,CusMember.Descricao),',',St2);
                        {$I+}
                        If IOResult <> 0 then
                           begin
                             Window(1,1,80,25);
                             ErroMsg := 'gravando '+XDisco+', vou encerrar.';
                             ErrorMessage;
                             RC := 'N';
                             TC := #27;
                           end;
                      end;
                 Until RC = 'N';
                 Window(1,1,80,25);
                 Close ( TxtFile );
                 Color(Blue,Black);
                 GotoXY(1,23);  Write(ConstStr(' ',80));
                 GotoXY(1,23);  Write(' Total de transa‡”es impressas: ');
                 Color(Blue,White);
                 GotoXY(33,23); Write(NCont:5);
                 TeclaReturn;
                 Close ( CusFile );
                 Erase ( CusFile );
                 Reset ( BBFile );
                 Reset ( SSFile );
                 If Root6 <> NIL then Dispose6 ( Root6 );
                 Root6 := NIL;
               end;
          end;
     end;
end;

