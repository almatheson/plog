Procedure DataRais;
begin
  Color(Tfn,Utx);
  GotoXY(12,08); Write(EEMember.Matricula,' ',PushLeft(40,EEMember.Nome));
  Color(Bfn,Btx);
  GotoXY(03,09); Write(' Mˆs  Rendimentos ');
  Color(Tfn,Ttx);
  For I := 1 to 12 do begin
                        GotoXY(04,I+9); Write(QQStr(I,2,'0'));
                      end;
  Color(Tfn,Utx);
  For I := 1 to 12 do begin
                        GotoXY(07,I+9);
                        Write(EditReal(HPMember.RendRais[I]):13);
                      end;
  Color(Bfn,Btx);
  GotoXY(20,09); Write(' 13§ Sal rio     Mˆs          Valor     ');
  Color(Tfn,Ttx);
  GotoXY(20,11); Write(' Adiantamento:');
  GotoXY(20,12); Write(' Pagamento...:');
  Color(Tfn,Utx);
  GotoXY(37,11); Write(HPMember.Ad13_Mes:2,'  ',EditReal(HPMember.Ad13_Valor):14);
  GotoXY(37,12); Write(HPMember.Pg13_Mes:2,'  ',EditReal(HPMember.Pg13_Valor):14);
  Color(Bfn,Btx);
  GotoXY(21,13); Write('                             Valor     ');
  Color(Tfn,Ttx);
  GotoXY(20,14); Write(' Aviso previo:');
  Color(Tfn,Utx);
  GotoXY(41,14); Write(EditReal(HPMember.ContrSind):14);
  Color(Bfn,Btx);
  GotoXY(21,15); Write('              Cadastro                 ');
  Color(Tfn,Ttx);
  GotoXY(21,16); Write('Nasc.:              Re/C:              ');
  GotoXY(21,17); Write('Nc/RC:              ChBr:              ');
  GotoXY(21,18); Write('C.Tr.:              Vin.:              ');
  GotoXY(21,19); Write('GI/DF:              CBO.:              ');
  GotoXY(21,20); Write('Adm/T:              PIS.:              ');
  GotoXY(21,21); Write('Op‡Æo:              CPF.:              ');
  Color(Tfn,Utx);
  GotoXY(28,16); Write(EEMember.DDNasc,'/',EEMember.MMNasc,'/',EEMember.AANasc);
  If EEMember.DDResc <> '' then
     begin
       GotoXY(47,16); Write(EEMember.DDResc,'/',EEMember.MMResc,'/',EEMember.AAResc);
       GotoXY(58,16); Write(EEMember.Causa);
     end;
  GotoXY(28,17); Write(EEMember.Nacional);
  GotoXY(31,17); Case EEMember.RacaCor of
                      '1' : Write('1 Indio   ');
                      '2' : Write('2 Branca  ');
                      '4' : Write('4 Preta   ');
                      '6' : Write('6 Amarela ');
                      '8' : Write('8 Parda   ');
                      '9' : Write('9 N.Info. ');
                 end;
  GotoXY(47,17); Write(EEMember.DataChBr);
  GotoXY(28,18); Write(EEMember.CTrabN);
  GotoXY(35,18); Write(EEMember.CTrabS);
  GotoXY(47,18); Write(EEMember.Vinculo);
  GotoXY(28,19); Write(EEMember.Grau);
  GotoXY(31,19); Case EEMember.Deficiente of
                      'S' : Write('Sim');
                      'N' : Write('NÆo');
                 end;
  GotoXY(47,19); Write(EEMember.CBO);
  GotoXY(28,20); Write(EEMember.DDAdm,'/',EEMember.MMAdm,'/',EEMember.AAAdm);
  GotoXY(39,20); Write(EEMember.TipoE);
  GotoXY(47,20); Write(EEMember.PisPasep);
  GotoXY(28,21); Write(EEMember.DataOpcao);
  GotoXY(47,21); Write(EEMember.Cpf);
end;


Procedure EntryRais;
begin
  Repeat
    K := 1;
    Repeat
      Case K of
           1..12 : With HPMember do
                   begin
                     If RendRais[K] = 0 then J := ''
                                        else begin
                                               Str(RendRais[K]:13:2,J);
                                               J := LeftAdjust(J);
                                             end;
                     InputStr(J,13,7,K+9,0,'S','N','$','N',Tfn,Utx);
                     Val(J,RendRais[K],E);
                   end;
           13    : begin
                     If HPMember.Ad13_Mes = 0 then J := ''
                        else begin
                               Str(HPMember.Ad13_Mes:2,J);
                               J := LeftAdjust(J);
                             end;
                     InputStr(J,2,37,11,0,'S','N','T','N',Tfn,Utx);
                     Val(J,HPMember.Ad13_Mes,E);
                     GotoXY(37,11); Write(HPMember.Ad13_Mes:2);
                   end;
           14    : begin
                     If HPMember.Ad13_Valor = 0 then J := ''
                        else begin
                               Str(HPMember.Ad13_Valor:14:2,J);
                               J := LeftAdjust(J);
                             end;
                     InputStr(J,14,41,11,0,'S','N','$','N',Tfn,Utx);
                     Val(J,HPMember.Ad13_Valor,E);
                   end;
           15    : begin
                     If HPMember.Pg13_Mes = 0 then J := ''
                        else begin
                               Str(HPMember.Pg13_Mes:2,J);
                               J := LeftAdjust(J);
                             end;
                     InputStr(J,2,37,12,0,'S','N','T','N',Tfn,Utx);
                     Val(J,HPMember.Pg13_Mes,E);
                     GotoXY(37,12); Write(HPMember.Pg13_Mes:2);
                   end;
           16    : begin
                     If HPMember.Pg13_Valor = 0 then J := ''
                        else begin
                               Str(HPMember.Pg13_Valor:13:2,J);
                               J := LeftAdjust(J);
                             end;
                     InputStr(J,14,41,12,0,'S','N','$','N',Tfn,Utx);
                     Val(J,HPMember.Pg13_Valor,E);
                   end;
           17    : begin
                     If HPMember.ContrSind = 0 then J := ''
                        else begin
                               Str(HPMember.ContrSind:13:2,J);
                               J := LeftAdjust(J);
                             end;
                     InputStr(J,14,41,14,0,'S','N','$','N',Tfn,Utx);
                     Val(J,HPMember.ContrSind,E);
                   end;
           18    : With EEMember do
                   begin
                     If DDNasc = '' then J := ''
                                    else J := DDNasc+'/'+MMNasc+'/'+AANasc;
                     InputStr(J,10,28,16,0,'S','N','D','S',Tfn,Utx);
                     If TC <> #27 then
                        begin
                          DDNasc := Copy(J,1,2);
                          MMNasc := Copy(J,4,2);
                          AANasc := Copy(J,7,4);
                        end;
                   end;
           19    : With EEMember do
                   begin
                     J := Nacional;
                     InputStr(J,2,28,17,0,'S','N','T','N',Tfn,Utx);
                     Nacional := UpCaseStr(J);
                   end;
           20  : With EEMember do
                 begin
                     J := RacaCor;
                     InputStr(J,1,31,17,0,'S','N','T','N',Tfn,Utx);
                     if J = '' then RacaCor := '2'
                               else RacaCor := UpCase(J[1]);
                     If (TC   <> #27) and
                        (RacaCor <> '1') and
                        (RacaCor <> '2') and
                        (RacaCor <> '4') and
                        (RacaCor <> '6') and
                        (RacaCor <> '8') and
                        (RacaCor <> '9') then
                        begin
                          ErroMsg := 'Raca/Cor Inv lida (1,2,4,6,8 ou 9)';
                          ErrorMessage;
                          K := K - 1;
                        end;
                     GotoXY(31,17); Case RacaCor of
                                         '1' : Write('1 Indio   ');
                                         '2' : Write('2 Branca  ');
                                         '4' : Write('4 Preta   ');
                                         '6' : Write('6 Amarela ');
                                         '8' : Write('8 Parda   ');
                                         '9' : Write('9 N.Info. ');
                                    end;
                   end;
           21    : With EEMember do
                   begin
                     J := CtrabN;
                     InputStr(J,6,28,18,0,'S','N','T','N',Tfn,Utx);
                     CtrabN := J;
                     If (TC     <> #27) and
                        (CtrabN =  '' ) then
                        begin
                          ErroMsg := 'Informe o N£mero';
                          ErrorMessage;
                          K := K - 1;
                        end;
                   end;
           22    : With EEMember do
                   begin
                     J := CtrabS;
                     InputStr(J,3,35,18,0,'S','N','T','N',Tfn,Utx);
                     CtrabS := J;
                     If (TC     <> #27) and
                        (CtrabS =  '' ) then
                        begin
                          ErroMsg := 'Informe a S‚rie';
                          ErrorMessage;
                          K := K - 1;
                        end;
                   end;
           23    : With EEMember do
                   begin
                     J := Grau;
                     InputStr(J,1,28,19,0,'S','N','T','N',Tfn,Utx);
                     Grau := J;
                   end;
           24  : With EEMember do
                 begin
                     J := Deficiente;
                     InputStr(J,1,31,19,0,'S','N','T','N',Tfn,Utx);
                     if J = '' then Deficiente := 'N'
                               else Deficiente := UpCase(J[1]);
                     If (Deficiente <> 'S') and (Deficiente <> 'N') and (TC <> #27) then
                        begin
                          ErroMsg := 'Informe S ou N';
                          ErrorMessage;
                          K := K - 1;
                        end
                        else begin
                               GotoXY(31,19); Case Deficiente of
                                                   'S' : Write('Sim');
                                                   'N' : Write('NÆo');
                                              end;
                             end;
                   end;
           25    : With EEMember do
                   begin
                     If DDAdm = '' then J := ''
                                   else J := DDAdm+'/'+MMAdm+'/'+AAAdm;
                     InputStr(J,10,28,20,0,'S','N','D','S',Tfn,Utx);
                     If TC <> #27 then
                        begin
                          DDAdm := Copy(J,1,2);
                          MMAdm := Copy(J,4,2);
                          AAAdm := Copy(J,7,4);
                        end;
                   end;
           26    : With EEMember do
                   begin
                     J := TipoE;
                     InputStr(J,1,39,20,0,'S','N','T','N',Tfn,Utx);
                     TipoE := J[1];
                   end;
           27    : With EEMember do
                   begin
                     J := DataOpcao;
                     InputStr(J,8,28,21,0,'S','N','T','N',Tfn,Utx);
                     If (TC <> #27) and
                        (J  <> '' ) then
                        begin
                          J := ChkData(J);
                          If J = '' then
                             begin
                               ErroMsg := 'Data Invalida';
                               ErrorMessage;
                               K := K - 1;
                             end
                             else If TC <> '' then
                                     begin
                                       DataOpcao := J;
                                       If DataOpcao <> '' then Opcao := 'S'
                                                          else Opcao := 'N';
                                     end;
                        end;
                   end;
           28    : With EEMember do
                   begin
                     If DDResc = '' then J := ''
                                    else J := DDResc+'/'+MMResc+'/'+AAResc;
                     InputStr(J,10,47,16,0,'S','N','T','N',Tfn,Utx);
                     If (TC <> #27) and
                        (J  <> '' ) then
                        begin
                          J := ChkData(J);
                          If J = '' then
                             begin
                               ErroMsg := 'Data Invalida';
                               ErrorMessage;
                               K := K - 1;
                             end
                             else begin
                                    DDResc := Copy(J,1,2);
                                    MMResc := Copy(J,4,2);
                                    AAResc := Copy(J,7,4);
                                  end;
                        end;
                   end;
           29    : With EEMember do
                   begin
                     J := Causa;
                     InputStr(J,2,58,16,0,'S','N','T','N',Tfn,Utx);
                     Causa := J;
                   end;
           30    : With EEMember do
                   begin
                     J := DataChBr;
                     InputStr(J,10,47,17,0,'S','N','T','N',Tfn,Utx);
                     DataChBr := J;
                   end;
           31    : With EEMember do
                   begin
                     J := Vinculo;
                     InputStr(J,2,47,18,0,'S','N','T','N',Tfn,Utx);
                     If J = '' then J := '10';
                     Vinculo := J;
                   end;
           32    : With EEMember do
                   begin
                     J := CBO;
                     InputStr(J,6,47,19,0,'S','N','T','N',Tfn,Utx);
                     CBO := J;
                   end;
           33    : With EEMember do
                   begin
                     J := PisPasep;
                     InputStr(J,11,47,20,0,'S','N','T','N',Tfn,Utx);
                     PisPasep := J;
                   end;
           34    : With EEMember do
                   begin
                     J := Cpf;
                     InputStr(J,12,47,21,0,'S','N','T','N',Tfn,Utx);
                     Cpf := J;
                   end;
      end;
      Case TC of
         #13 : K := K + 1;
         #24 : If K > 1 then K := K - 1
                        else K := 34;
      end;
    Until (K = 35) or (TC = #27);
    Confirma;
  Until TC in ['S',#27];
end;


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


Procedure LoadRaisDirf;
begin
  If FileSize(EEFile) > 0 then
     begin
       Color(Blue,Cyan);
       GotoXY(1,24);  Write(ConstStr(' ',80));
       GotoXY(02,24); Write('Estou carregando funcion rios');
       Color(Blue,White);
       GotoXY(73,24); Write('Aguarde');
       If Root6 <> NIL then Dispose6 ( Root6 );
       Root6 := NIL;
       NFu   := 0;
       I     := -1;
       Repeat
         I := I + 1;
         ReadWrite(#08,'R','N',I);
         XXNo     := EEMember.Nome + '#' + EEMember.Matricula;
         XXNumber := I;
         LoadTree6 ( Root6 );
         NFu := NFu + 1;
       Until (I + 1) = FileSize(EEFile);
       LimpaLn(24,Tfd);
     end;
end;


Procedure PedeParametrosRais1;
begin
  Color(Tfn,Ttx);
  GotoXY(4,12); Write('Recibo ...:');
  GotoXY(4,13); Write('Nome/RSoc.:');
  GotoXY(4,14); Write('CPF.......:');
  GotoXY(4,15); Write('Endere‡o..:');
  GotoXY(4,16); Write('N§ e Compl:');
  GotoXY(4,17); Write('Bair/Cp/UF:');
  GotoXY(4,18); Write('Municipio.:');
  GotoXY(4,19); Write('DDD Tl/Fax:');
  GotoXY(4,20); Write('Retif/Data:');
  Color(Tfn,Utx);
  CausaX  := ' ';
  CGCAnt  := '';
  RaisNeg := 'N';
  Recibo  := '2';
  If CMstMember.Nome = '' then NomeR := OwnerMember.RSocial
                          else NomeR := CMstMember.Nome;
  EndR    := CMstMember.Endereco;
  CpfR    := '';
  NumeroR := CMstMember.Numero;
  ComplR  := CMstMember.Complemento;
  BairroR := CMstMember.Bairro;
  CepR    := CMstMember.Cep;
  UFR     := CMstMember.Estado;
  CMuniR  := '';
  NMuniR  := CMstMember.Municipio;
  DDDR    := CMstMember.DDD;
  TelFaxR := CMstMember.Telefone;
  Ratif   := ' ';
  DRatif  := '';
  Repeat
    K := 1;
    Repeat
      Case K of
           1  :  begin
                   Color(Red,Yellow);
                   GotoXY(1,24); Write(ConstStr(' ',80));
                   GotoXY(2,24); Write('1 = End. do Responsavel / 2 = End. do Estabelecimento');
                   J := Recibo;
                   InputStr(J,1,16,12,0,'S','N','T','N',Tfn,Utx);
                   Recibo := J[1];
                   GotoXY(16,12);
                   Case Recibo of
                        '1' : Write(' - End.do Estabelecimento');
                        '2' : Write(' - End.do Responsavel    ');
                   end;
                   Color(Tfd,Utx);
                   GotoXY(1,24); ClrEol;
                 end;
           7  :  begin
                   J := NomeR;
                   InputStr(J,40,16,13,0,'S','N','T','N',Tfn,Utx);
                   NomeR := J;
                 end;
           8  :  begin
                   J := CpfR;
                   InputStr(J,11,16,14,0,'S','N','T','N',Tfn,Utx);
                   CpfR := J;
                 end;
           9  :  begin
                   J := EndR;
                   InputStr(J,40,16,15,0,'S','N','T','N',Tfn,Utx);
                   EndR := J;
                 end;
           10 :  begin
                   J := NumeroR;
                   InputStr(J,6,16,16,0,'S','N','T','N',Tfn,Utx);
                   NumeroR := J;
                 end;
           11 :  begin
                   J := ComplR;
                   InputStr(J,20,23,16,0,'S','N','T','N',Tfn,Utx);
                   ComplR := J;
                 end;
           12 :  begin
                   J := BairroR;
                   InputStr(J,19,16,17,0,'S','N','T','N',Tfn,Utx);
                   BairroR := J;
                 end;
           13 :  begin
                   J := CepR;
                   InputStr(J,8,37,17,0,'S','N','T','N',Tfn,Utx);
                   CepR := J;
                 end;
           14 :  begin
                   J := UFR;
                   InputStr(J,2,46,17,0,'S','N','T','N',Tfn,Utx);
                   UFR := J;
                 end;
           15 :  begin
                   J := CMuniR;
                   InputStr(J,7,16,18,0,'S','N','T','N',Tfn,Utx);
                   CMuniR := J;
                 end;
           16 :  begin
                   J := NMuniR;
                   InputStr(J,30,24,18,0,'S','N','T','N',Tfn,Utx);
                   NMuniR := J;
                 end;
           17 :  begin
                   J := DDDR;
                   InputStr(J,2,16,19,0,'S','N','T','N',Tfn,Utx);
                   DDDR := J;
                 end;
           18 :  begin
                   J := TelFaxR;
                   InputStr(J,8,23,19,0,'S','N','T','N',Tfn,Utx);
                   TelFaxR := J;
                 end;
           19 :  begin
                   Color(Red,Yellow);
                   GotoXY(1,24); Write(ConstStr(' ',80));
                   GotoXY(2,24); Write('X = Retificacao / Branco = Decl. Normal');
                   J := Ratif;
                   InputStr(J,1,16,20,0,'S','N','T','N',Tfn,Utx);
                   Ratif := J[1];
                   If Ratif <> ' ' then Ratif := 'X';
                   GotoXY(16,20);
                   Case Ratif of
                        ' ' : Write('  - decl. Normal');
                        'X' : Write('X - retifica‡Æo ');
                   end;
                   Color(Tfd,Utx);
                   GotoXY(1,24); ClrEol;
                 end;
           20 :  begin
                   J := DRatif;
                   InputStr(J,8,33,20,0,'S','N','T','N',Tfn,Utx);
                   DRatif := J;
                 end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 21) or (TC = #27);
    If TC <> #27 then Confirma;
  Until TC in ['S',#27];
end;


Procedure PedeParametrosRais2;
begin
  Color(Tfn,Ttx);
  GotoXY(4,09); Write('Porte  (1=Micro,2=Pequena,3=Outros).....:             ');
  GotoXY(4,10); Write('Simples(1=Sim,2=N„o)....................:             ');
  GotoXY(4,11); Write('PAT    (1=Sim,2=N„o)....................:             ');
  GotoXY(4,12); Write('Vinculos PAT at‚ 5 Sal.minimos..........:             ');
  GotoXY(4,13); Write('Vinculos PAT mais que 5 sal.minimos.....:             ');
  GotoXY(4,14); Write('% de servi‡o proprio....................:             ');
  GotoXY(4,15); Write('% de administra‡„o de cozinha...........:             ');
  GotoXY(4,16); Write('% de refei‡„o convenio..................:             ');
  GotoXY(4,17); Write('% de refei‡„o transportadora............:             ');
  GotoXY(4,18); Write('% de cesta alimento.....................:             ');
  GotoXY(4,19); Write('% de alimenta‡„o convenio...............:             ');
  GotoXY(4,20); Write('Encerramento(1=Sim,2=N„o) Data(ddmmaaaa):             ');
  Color(Tfn,Utx);

  Porte          := ' ';
  Simples        := ' ';
  Pat            := ' ';
  Ate5Sal        := 0;
  Mais5Sal       := 0;
  PerctServProp  := 0;
  PerctAdmCoz    := 0;
  PerctRefConv   := 0;
  PerctRefTransp := 0;
  PerctCestaAlim := 0;
  PerctAlimConv  := 0;
  Encerramento   := ' ';
  DataEncerra    := '';

  Repeat
    K := 1;
    Repeat
      Case K of
           1  :  begin
                   J := Porte;
                   InputStr(J,1,46,09,0,'S','N','T','N',Tfn,Utx);
                   If J = '' then Porte := '2'
                             else Porte := J[1];
                   GotoXY(46,09); Write(Porte);
                 end;
           7  :  begin
                   J := Simples;
                   InputStr(J,1,46,10,0,'S','N','T','N',Tfn,Utx);
                   If J = '' then Simples := '2'
                             else Simples := J[1];
                   GotoXY(46,10); Write(Simples);
                 end;
           8  :  begin
                   J := Pat;
                   InputStr(J,1,46,11,0,'S','N','T','N',Tfn,Utx);
                   If J = '' then Pat := '1'
                             else Pat := J[1];
                   GotoXY(46,11); Write(Pat);
                 end;
           9  :  begin
                   If Ate5Sal = 0 then J := ''
                                  else begin
                                         Str(Ate5Sal:6,J);
                                         J := LeftAdjust(J);
                                       end;
                   InputStr(J,6,46,12,0,'S','N','T','N',Tfn,Utx);
                   Val(J,Ate5Sal,E);
                 end;
           10 :  begin
                   If Mais5Sal = 0 then J := ''
                                   else begin
                                          Str(Mais5Sal:6,J);
                                          J := LeftAdjust(J);
                                        end;
                   InputStr(J,6,46,13,0,'S','N','T','N',Tfn,Utx);
                   Val(J,Mais5Sal,E);
                 end;
           11 :  begin
                   If PerctServProp = 0 then J := ''
                                        else begin
                                               Str(PerctServProp:3,J);
                                               J := LeftAdjust(J);
                                             end;
                   InputStr(J,3,46,14,0,'S','N','T','N',Tfn,Utx);
                   Val(J,PerctServProp,E);
                 end;
           12 :  begin
                   If PerctAdmCoz = 0 then J := ''
                                      else begin
                                             Str(PerctAdmCoz:3,J);
                                             J := LeftAdjust(J);
                                           end;
                   InputStr(J,3,46,15,0,'S','N','T','N',Tfn,Utx);
                   Val(J,PerctAdmCoz,E);
                 end;
           13 :  begin
                   If PerctRefConv = 0 then J := ''
                                       else begin
                                              Str(PerctRefConv:3,J);
                                              J := LeftAdjust(J);
                                            end;
                   InputStr(J,3,46,16,0,'S','N','T','N',Tfn,Utx);
                   Val(J,PerctRefConv,E);
                 end;
           14 :  begin
                   If PerctRefTransp = 0 then J := ''
                                         else begin
                                                Str(PerctRefTransp:3,J);
                                                J := LeftAdjust(J);
                                              end;
                   InputStr(J,3,46,17,0,'S','N','T','N',Tfn,Utx);
                   Val(J,PerctRefTransp,E);
                 end;
           15 :  begin
                   If PerctCestaAlim = 0 then J := ''
                                         else begin
                                                Str(PerctCestaAlim:3,J);
                                                J := LeftAdjust(J);
                                              end;
                   InputStr(J,3,46,18,0,'S','N','T','N',Tfn,Utx);
                   Val(J,PerctCestaAlim,E);
                 end;
           16 :  begin
                   If PerctAlimConv = 0 then J := ''
                                        else begin
                                               Str(PerctAlimConv:3,J);
                                               J := LeftAdjust(J);
                                             end;
                   InputStr(J,3,46,19,0,'S','N','T','N',Tfn,Utx);
                   Val(J,PerctAlimConv,E);
                 end;
           17 :  begin
                   J := Encerramento;
                   InputStr(J,1,46,20,0,'S','N','T','N',Tfn,Utx);
                   Encerramento := J[1];
                 end;
           18 :  begin
                   J := DataEncerra;
                   InputStr(J,8,48,20,0,'S','N','T','N',Tfn,Utx);
                   DataEncerra := J;
                 end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 19) or (TC = #27);
    If TC <> #27 then Confirma;
  Until TC in ['S',#27];
end;


Procedure ProcessRais;
begin
  Confirma;
  If TC = 'S' then
     begin
       QPorta;
       If TC <> #27 then
          begin
            Inicializa(DskRpt);
            NCont   := 0;
            ContLin := 1000;
            ContPag := 0;
            LoadRaisDirf;
            DrawBox(26,11,67,21,Sfn,'S');
            Color(Bfn,Btx);
            GotoXY(26,11); Write(' Empregados selecionados                  ');
            Color(Sfn,Stx);
            Window(27,13,67,21);
            GotoXY(1,9);
            XXNo := '';
            Repeat
              RC := 'N';
              SearchPos6 ( Root6 );
              If RC = 'S' then
                 begin
                   ReadWrite(#08,'R','N',XXNumber);
                   If not (EEMember.Vinculo[1] in ['A','N']) and
                      (EEMember.Status <> 'X') then
                      begin
                        ReadWrite(#09,'R','N',XXNumber);
                        Writeln(EEMember.Nome);
                        NCont := NCont + 1;
                        If ContLin > 50 then
                           begin
                             ContPag := ContPag + 1;
                             With CMstMember do
                             begin
                               If Laser <> 'N' then WriteLine('W',LaserInit)
                                               else If ContLin < 1000 then WriteLine('W',Qp);
                               ContLin := 0;
                               WriteLine('L',Dx+Acentua(Descricao)+Df);
                               WriteLine('L',ConstStr('-',80));
                               WriteLine('L',Cx+Acentua(Endereco)+', '+
                                             Acentua(Numero)+' '+
                                             Acentua(Complemento)+'  '+Acentua(Cidade)+' - '+
                                             Estado+'  Cep: '+Cep+Cf);
                             end;
                             Writeline('L',ConstStr(' ',66)+'Pag.: '+
                                           PushRight(8,EditInteger(ContPag)));
                             WriteLine('L',Acentua('Informa‡”es para RAIS')+ConstStr(' ',45)+
                                           'Data: '+XDia+'/'+XMes+'/'+XAno);
                             Writeline('L',' ');
                             WriteLine('L',ConstStr('-',80));
                           end;
                        Writeline('L',' ');
                        WriteLine('L','Nome...........: '+Acentua(EEMember.Nome));
                        WriteLine('L','Pis............: '+EEMember.PisPasep);
                        WriteLine('L','Cart.Trabalho..: '+PushRight(6,EEMember.CtrabN)+'  '+
                                                          PushRight(3,EEMember.CtrabS));
                        WriteLine('L','Data nascimento: '+PushRight(2,EEMember.DDNasc)+'/'+
                                                          PushRight(2,EEMember.MMNasc)+'/'+
                                                          PushRight(2,EEMember.AANasc));
                        WriteLine('L',Acentua('Data admiss„o..: ')+
                                      PushRight(2,EEMember.DDAdm)+'/'+
                                      PushRight(2,EEMember.MMAdm)+'/'+
                                      PushRight(2,EEMember.AAAdm));
                        WriteLine('L','M. trabalhados.: '+PushRight(2,EditInteger(EEMember.MesesT)));
                        WriteLine('L',Acentua('Tipo/Data op‡„o: ')+EEMember.Opcao+' '+EEMember.DataOpcao);
                        WriteLine('L','CBO............: '+EEMember.CBO);
                        WriteLine('L',Acentua('V¡nculo........: ')+EEMember.Vinculo);
                        WriteLine('L',Acentua('Gr.de instru‡„o: ')+EEMember.Grau);
                        WriteLine('L','Nacionalidade..: '+EEMember.Nacional);
                        WriteLine('L','Chegada ao BR..: '+EEMember.DataChBr);
                        WriteLine('L',Acentua('Sal rio e Tipo.: ')+PushLeft(15,EditReal(EEMember.Salario))+' '+EEMember.Tipo);
                        WriteLine('L','Horas normais..: '+PushRight(2,EditInteger(Trunc(EEMember.HNormais / 5))));
                        If EEMember.AAResc <> ''
                           then WriteLine('L',Acentua('Dt/Tp rescis„o.: ')+
                                              EEMember.DDResc+'/'+
                                              EEMember.MMResc+'/'+
                                              EEMember.AAResc+'  '+
                                              EEMember.Causa);
                        WriteLine('L','Jan,Fev,Mar....: '+PushRight(15,EditReal(HPMember.RendRais[1]))+' '+
                                                          PushRight(15,EditReal(HPMember.RendRais[2]))+' '+
                                                          PushRight(15,EditReal(HPMember.RendRais[3])));
                        WriteLine('L','Abr,Mai,Jun....: '+PushRight(15,EditReal(HPMember.RendRais[4]))+' '+
                                                          PushRight(15,EditReal(HPMember.RendRais[5]))+' '+
                                                          PushRight(15,EditReal(HPMember.RendRais[6])));
                        WriteLine('L','Jul,Ago,Set....: '+PushRight(15,EditReal(HPMember.RendRais[7]))+' '+
                                                          PushRight(15,EditReal(HPMember.RendRais[8]))+' '+
                                                          PushRight(15,EditReal(HPMember.RendRais[9])));
                        WriteLine('L','Out,Nov,Dez....: '+PushRight(15,EditReal(HPMember.RendRais[10]))+' '+
                                                          PushRight(15,EditReal(HPMember.RendRais[11]))+' '+
                                                          PushRight(15,EditReal(HPMember.RendRais[12])));
                        WriteLine('L',Acentua('Ad.13 sal rio..: ')+
                                      PushRight(15,EditReal(HPMember.Ad13_Valor))+' '+
                                      EditInteger(HPMember.Ad13_Mes));
                        WriteLine('L',Acentua('Pg.13 sal rio..: ')+
                                      PushRight(15,EditReal(HPMember.Pg13_Valor))+' '+
                                      EditInteger(HPMember.Pg13_Mes));
                        Writeline('L',' ');
                        WriteLine('L',ConstStr('-',80));
                      end;
                 end;
              GoNoGo;
              If TC = #27 then RC := 'N';
            Until RC = 'N';
            If DskRpt = 'N' then WriteLine('W',Qp);
            Window(1,1,80,25);
            Color(Blue,Black);
            GotoXY(1,23);  Write(ConstStr(' ',80));
            GotoXY(1,23);  Write(' Total de Empregados Impressos: ');
            Color(Blue,White);
            GotoXY(33,23); Write(NCont:5);
            TeclaReturn;
            If (DskRpt = 'T') and (TC <> #27) then ScrollRpt
                                              else Close ( LST );
          end;
       Dispose6 ( Root6 );
       Root6 := NIL;
     end;
end;

Procedure PedeParametrosDirf;
begin
  Color(Tfn,Ttx);
  GotoXY(4,12); Write('Resp.CPF..:');
  GotoXY(4,13); Write('Resp.TEL..:');
  GotoXY(4,14); Write('Resp.Ramal:');
  GotoXY(4,15); Write('Resp.FAX..:');
  GotoXY(4,16); Write('Resp.EMail:');
  Color(Tfn,Utx);
  CPFResp   := '';
  DDDResp   := '';
  TELResp   := '';
  RAMALResp := '';
  FAXResp   := '';
  EMAILResp := CMstMember.EMail;
  Repeat
    K := 1;
    Repeat
      Case K of
           1  :  begin
                   J := CPFResp;
                   InputStr(J,11,16,12,0,'S','N','T','N',Tfn,Utx);
                   CPFResp := J;
                 end;
           2  :  begin
                   J := DDDResp;
                   InputStr(J,4,16,13,0,'S','N','T','N',Tfn,Utx);
                   DDDResp := J;
                 end;
           3  :  begin
                   J := TELResp;
                   InputStr(J,8,21,13,0,'S','N','T','N',Tfn,Utx);
                   TELResp := J;
                 end;
           4  :  begin
                   J := RAMALResp;
                   InputStr(J,6,16,14,0,'S','N','T','N',Tfn,Utx);
                   RAMALResp := J;
                 end;
           5  :  begin
                   J := FAXResp;
                   InputStr(J,8,16,15,0,'S','N','T','N',Tfn,Utx);
                   FAXResp := J;
                 end;
           6  :  begin
                   J := EMAILResp;
                   InputStr(J,30,16,16,0,'S','N','T','N',Tfn,Utx);
                   EMAILResp := J;
                 end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 7) or (TC = #27);
    If TC <> #27 then Confirma;
  Until TC in ['S',#27];
end;

