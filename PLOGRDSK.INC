Function FReal(I : Real; D,T : Integer) : Str30;
Var
  St1,St2  : String[30];
begin
  if I > 0 then
     begin
       Str(I:15:D,St1);
       St1 := LeftAdjust(St1);
       If Length(St1) < T then St2 := Copy(Zeros,1,(T - Length(St1))) + St1
                          else St2 := St1;
       FReal := St2;
     end
     else FReal := Copy(Zeros,1,T);
end;


Function FString(St1 : Str80; T : Integer) : Str80;
Var
  St2  : String[80];
begin
  If Length(St1) < T then
     begin
       St1 := LeftAdjust(St1);
       St2 := Copy(Zeros,1,(T - Length(St1))) + St1;
     end
     else St2 := St1;
  FString := St2;
end;


Function Maiuscula(S : Str80; I : Integer) : Str80;
Var
   P : Integer;
begin
  If Length(S) > 0 then
     For P := 1 to Length(S) do
     Case S[P] of
          #128,#135           : S[P] := 'C';
          #131,#132,#133,#160 : S[P] := 'A';
          #130,#136,#144      : S[P] := 'E';
          #147,#148,#162      : S[P] := 'O';
          #161                : S[P] := 'I';
          #163                : S[P] := 'U';
          else                  S[P] := UpCase(S[P]);
     end;
  For P := (Length(S) + 1) to 80 do S[P] := ' ';
  S[0]  := Chr(I);
  Maiuscula := S;
end;


Procedure QueArquivo;
begin
  DrawBox(34,09,74,16,Red,'S');
  Color(Red,White);
  GotoXY(34,09); Write('            Leia com Atená∆o             ');
  Color(Red,Cyan);
  GotoXY(34,10); Write(' GeraáÑo de arquivo para o  GDRAIS',QQStr(AA,4,'0'),', ');
  GotoXY(34,11); Write(' ou para a DIRF, fornecida pelo governo. ');
  GotoXY(34,12); Write(' Submeta o arquivo gerado ao Analisador, ');
  GotoXY(34,13); Write(' acerte os erros e repita o processo atÇ ');
  GotoXY(34,14); Write(' que n∆o acuse mais erro algum.          ');
  GotoXY(34,15); Write(' Informe o PATH e o ARQUIVO, no formato: ');
  Color(Red,Yellow);
  GotoXY(34,16); Write('                     Disco:\Path\Arquivo ');
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
           K := K - 1;
         end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 2) or (TC = #27);
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


Procedure ProcessRaisD;
Var
  Erro          : Integer;
  AvisoPrevio   : Real;
  DefFi         : Char;
  Sexo          : Char;
  Regtxt        : AnyStr;
begin
  PedeParametrosRais1;
  If TC = 'S' then PedeParametrosRais2;
  If TC = 'S' then
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
                      else If Erro <> 0 then
                              begin
                                ErroMsg := 'Arquivo '+XDisco+' n∆o existe.';
                                ErrorMessage;
                                TC := #27;
                              end
                              else TC := 'S';
                 Until TC in [#27,'S'];
               end;
            If TC = 'S' then
               begin
                 LoadRaisDirf;
                 Linhas := 1;

                 Writeln (TxtFile,QQStr(Linhas,6,'0'),
                                  FString(LimpaChave(CMstMember.CGC),14),
                                  '00',
                                  '0',
                                  Recibo,
                                  FString(CpfR,14),
                                  '4',
                                  Maiuscula(Copy(NomeR,1,40),40),
                                  Maiuscula(EndR,40),
                                  FString(NumeroR,6),
                                  PushLeft(21,ComplR),
                                  Maiuscula(BairroR,19),
                                  FString(LimpaChave(CepR),8),
                                  FString(CMuniR,7),
                                  Maiuscula(NMuniR,30),
                                  FString(UFR,2),
                                  PushLeft(2,DDDR),
                                  PushLeft(8,TelFaxR),
                                  Ratif,
                                  FString(DRatif,8),
                                  XDia,XMes,XAno,
                                  PushLeft(45,CMstMember.EMail),
                                  ConstStr(' ',239));

                 Linhas := Linhas + 1;

                 If RaisNeg = 'S' then RaisNeg := '1'
                                  else RaisNeg := '0';

{                 AnoBase := QQStr(AA,4,'0');}
                 AnoBase := '01';

                 Writeln (TxtFile,QQStr(Linhas,6,'0'),
                                  FString(LimpaChave(CMstMember.CGC),14),
                                  '00',
                                  '1',
                                  Maiuscula(CMstMember.Descricao,52),
                                  Maiuscula(CMstMember.Endereco,40),
                                  FString(Copy(CMstMember.Numero,1,6),6),
                                  PushLeft(21,CMstMember.Complemento),
                                  Maiuscula(Copy(CMstMember.Bairro,1,19),19),
                                  FString(Copy(LimpaChave(CMstMember.Cep),1,8),8),
                                  FString(CMstMember.Cod_Municipio,7),
                                  Maiuscula(CMstMember.Municipio,30),
                                  FString(CMstMember.Estado,2),
                                  PushLeft(2,CMstMember.DDD),
                                  PushLeft(8,CMstmember.Telefone),
                                  PushLeft(45,CMstMember.EMail),
                                  FString(CMstMember.CNAE,5),
                                  FString(CMstMember.Natureza,4),
                                  QQStr(CMstMember.Proprietarios,2,'0'),
                                  AnoBase,
                                  CMstMember.Tipo,
                                  RaisNeg,
                                  '00',
                                  '000000000000',
                                  '2005',
                                  Porte,
                                  Simples,
                                  Pat,
                                  QQStr(Ate5Sal,6,'0'),
                                  QQStr(Mais5Sal,6,'0'),
                                  QQStr(PerctServProp,3,'0'),
                                  QQStr(PerctAdmCoz,3,'0'),
                                  QQStr(PerctRefConv,3,'0'),
                                  QQStr(PerctRefTransp,3,'0'),
                                  QQStr(PerctCestaAlim,3,'0'),
                                  QQStr(PerctAlimConv,3,'0'),
                                  Encerramento,
                                  FString(DataEncerra,8),
                                  ConstStr('0',14),
                                  ConstStr('0',8),
                                  ConstStr('0',14),
                                  ConstStr('0',8),
                                  ConstStr('0',14),
                                  ConstStr('0',8),
                                  ConstStr('0',14),
                                  ConstStr('0',8),
                                  '1',
                                  ConstStr(' ',89),
                                  ConstStr(' ',12));

                 NCont := 0;
                 DrawBox(26,11,67,21,Sfn,'S');
                 Color(Bfn,Btx);
                 GotoXY(26,11); Write(' Empregados selecionados                  ');
                 Color(Sfn,Stx);
                 Window(27,13,67,21);
                 GotoXY(1,9);
                 If RaisNeg = '0' then
                    begin
                      XXNo := '';
                      Repeat
                        RC := 'N';
                        SearchPos6 ( Root6 );
                        If RC = 'S' then
                           begin
                             ReadWrite(#08,'R','N',XXNumber);
                             If (EEMember.Vinculo[1] <> 'N') and
                                (EEMember.Vinculo[1] <> 'A') and
                                (EEMember.Status     <> 'X') then
                                begin
                                  GotoXY(1,23);
                                  Writeln(EEMember.Nome);
                                  NCont := NCont + 1;
                                  ReadWrite(#09,'R','N',XXNumber);
                                  Linhas   := Linhas + 1;

                                  Case EEMember.TipoE of
                                       '1' : TipoEmpreg := '1';
                                       'R' : TipoEmpreg := '2';
                                       'T' : TipoEmpreg := '3';
                                       'O' : TipoEmpreg := '4';
                                       else  TipoEmpreg := '2';
                                  end;
                                  If EEMember.Opcao = 'S' then
                                     begin
                                       Opcao := '1';
                                       If EEMember.DataOpcao <> ''
                                          then MesAnoOpcao := Copy(EEMember.DataOpcao,4,2) +
                                                              Copy(EEMember.DataOpcao,7,2)
                                          else MesAnoOpcao := '0000';
                                     end
                                     else begin
                                            Opcao       := '2';
                                            MesAnoOpcao := '0000';
                                          end;
                                  If EEMember.DataChBr <> ''
                                     then Chegada := Copy(EEMember.DataChBr,7,4)
                                     else Chegada := '0000';
                                  Case EEMember.Tipo of
                                       'M' : TipoSal := '1';
                                       'S' : TipoSal := '3';
                                       'H' : TipoSal := '5';
                                       else  TipoSal := '7';
                                  end;
                                  If EEMember.DDResc <> '' then
                                     begin
                                       RescDiaMes := EEMember.DDResc + EEMember.MMResc;
                                       RescCausa  := FString(Trim(EEMember.Causa),2);
                                     end
                                     else begin
                                            RescDiaMes := '0000';
                                            RescCausa  := '00';
                                          end;
                                  if EEMember.Deficiente = 'S' then DefFi := '1'
                                                               else DefFi := '2';
                                  if EEMember.Sexo = 'M' then Sexo := '1'
                                                         else Sexo := '2';
                                  UsoEmpresa2  := PushRight(12,EEMember.Matricula);
                                  {$I-}
                                  Writeln (TxtFile,QQStr(Linhas,6,'0'),
                                                   FString(LimpaChave(CMstMember.CGC),14),
                                                   '00',
                                                   '2',
                                                   FString(LimpaChave(EEMember.PisPasep),11),
                                                   Maiuscula(Copy(EEMember.Nome,1,30),30),
                                                   EEMember.DDNasc +
                                                   EEMember.MMNasc +
                                                   EEMember.AANasc,
                                                   FString(Trim(EEMember.Nacional),2),
                                                   Chegada,
                                                   EEMember.Grau[1],
                                                   FString(LimpaChave(Trim(EEMember.Cpf)),11),
                                                   FString(Copy(EEMember.CTrabN,1,6) + Copy(EEMember.CTrabS,1,5),11),
                                                   EEMember.DDAdm +
                                                   EEMember.MMAdm +
                                                   EEMember.AAAdm,
                                                   TipoEmpreg,
                                                   FReal((EEMember.Salario * 100),0,9),
                                                   TipoSal,
                                                   QQStr(Trunc(EEMember.HNormais / 5),2,'0'),
                                                   FString(Trim(EEMember.CBO),6),
                                                   FString(Trim(EEMember.Vinculo),2),
                                                   RescCausa,
                                                   RescDiaMes,
                                                   FReal((HPMember.RendRais[1] * 100),0,9),
                                                   FReal((HPMember.RendRais[2] * 100),0,9),
                                                   FReal((HPMember.RendRais[3] * 100),0,9),
                                                   FReal((HPMember.RendRais[4] * 100),0,9),
                                                   FReal((HPMember.RendRais[5] * 100),0,9),
                                                   FReal((HPMember.RendRais[6] * 100),0,9),
                                                   FReal((HPMember.RendRais[7] * 100),0,9),
                                                   FReal((HPMember.RendRais[8] * 100),0,9),
                                                   FReal((HPMember.RendRais[9] * 100),0,9),
                                                   FReal((HPMember.RendRais[10] * 100),0,9),
                                                   FReal((HPMember.RendRais[11] * 100),0,9),
                                                   FReal((HPMember.RendRais[12] * 100),0,9),
                                                   FReal((HPMember.Ad13_Valor * 100),0,9),
                                                   QQStr(HPMember.Ad13_Mes,2,'0'),
                                                   FReal((HPMember.Pg13_Valor * 100),0,9),
                                                   QQStr(HPMember.Pg13_Mes,2,'0'),
                                                   EEMember.RacaCor,
                                                   DefFi,
                                                   '2',
                                                   FReal((HPMember.ContrSind * 100),0,9),
                                                   Sexo,
                                                   ConstStr('0',189),
                                                   ConstStr('0',7),
                                                   ConstStr('0',35),
                                                   UsoEmpresa2);
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
                           end;
                      Until RC = 'N';
                    end
                    else begin
                           Writeln('Rais Negativa');
                           NCont  := 1;
                           Linhas :=  Linhas + 1;
                           UsoEmpresa2  := PushRight(15,'Rais negativa');
                           Writeln (TxtFile,QQStr(Linhas,6,'0'),
                                            FString(LimpaChave(CMstMember.CGC),14),
                                            '00',
                                            '2',
                                            ConstStr('0',11),
                                            ConstStr(' ',30),
                                            ConstStr('0',8),
                                            ConstStr('0',2),
                                            '0000',
                                            '0',
                                            ConstStr('0',11),
                                            ConstStr('0',6),
                                            ConstStr('0',5),
                                            ConstStr('0',8),
                                            '0',
                                            ConstStr('0',12),
                                            '0',
                                            '00',
                                            ConstStr('0',5),
                                            ConstStr('0',2),
                                            '00',
                                            '0000',
                                            ConstStr('0',9),
                                            ConstStr('0',9),
                                            ConstStr('0',9),
                                            ConstStr('0',9),
                                            ConstStr('0',9),
                                            ConstStr('0',9),
                                            ConstStr('0',9),
                                            ConstStr('0',9),
                                            ConstStr('0',9),
                                            ConstStr('0',9),
                                            ConstStr('0',9),
                                            ConstStr('0',9),
                                            ConstStr('0',12),
                                            '00',
                                            ConstStr('0',12),
                                            '00',
                                            UsoEmpresa2);
                         end;
                 If TC <> #27 then
                    begin
                      Linhas := Linhas + 1;
                      Writeln (TxtFile,QQStr(Linhas,6,'0'),
                                       FString(LimpaChave(CMstMember.CGC),14),
                                       '00',
                                       '9',
                                       '000001',
                                       QQStr(NCont,6,'0'),
                                       ConstStr(' ',244),
                                       ConstStr(' ',244));
                      Window(1,1,80,25);
                      Close ( TxtFile );
                      Color(Blue,Black);
                      GotoXY(1,23);  Write(ConstStr(' ',80));
                      GotoXY(1,23);  Write(' Total de Empregados gerados..: ');
                      Color(Blue,White);
                      GotoXY(33,23); Write(NCont:5);
                      TeclaReturn;
                    end;
                 Dispose6 ( Root6 );
                 Root6 := NIL;
               end;
          end;
     end;
end;

Procedure ProcessDirfD;
Var
  Erro      : Integer;
  Regtxt    : AnyStr;
  Pg13Dirf,
  Ded13Dirf,
  IR13Dirf,
  TemIR     : Real;
  RDirf     : Array[1..12] of Real;
  DDirf     : Array[1..12] of Real;
  IDirf     : Array[1..12] of Real;
begin
  PedeParametrosDirf;
  If TC = 'S' then
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
                      else If Erro <> 0 then
                              begin
                                ErroMsg := 'Arquivo '+XDisco+' n∆o existe.';
                                ErrorMessage;
                                TC := #27;
                              end
                              else TC := 'S';
                 Until TC in [#27,'S'];
               end;
            If TC = 'S' then
               begin
                 LoadRaisDirf;

                 Linhas := 1;
                 Writeln (TxtFile,QQStr(Linhas,8,'0'),
                                  '1',
                                  FString(LimpaChave(CMstMember.CGC),14),
                                  'DIRF',
                                  '98',
                                  'O',
                                  '1',
                                  '2',
                                  ' ',
                                  ConstStr(' ',9),
                                  Maiuscula(CMstMember.Descricao,60),
                                  ConstStr(' ',48),
                                  ConstStr('0',14),
                                  Maiuscula(CMstMember.Endereco,40),
                                  FString(CMstMember.Numero,6),
                                  PushLeft(20,CMstMember.Complemento),
                                  Maiuscula(CMstMember.Bairro,20),
                                  FString(LimpaChave(CMstMember.Cep),8),
                                  '00000',
                                  Maiuscula(CMstMember.Municipio,40),
                                  Maiuscula(CMstMember.Estado,2),
                                  PushLeft(30,'BRASIL'),
                                  '0021',
                                  FString(CMstMember.Telefone,8),
                                  ConstStr('0',8),
                                  ConstStr(' ',50),
                                  FString(CPFResp,11),
                                  PushLeft(60,CMstMember.Nome),
                                  FString(DDDResp,4),
                                  FString(TELResp,8),
                                  FString(RAMALResp,6),
                                  FString(FAXResp,8),
                                  PushLeft(50,EMAILResp),
                                  ConstStr(' ',165),
                                  ConstStr('x',13));

                 NCont := 0;

                 For I := 1 to 12 do
                 begin
                   RDirf[I] := 0;
                   DDirf[I] := 0;
                   IDirf[I] := 0;
                 end;
                 Pg13Dirf  := 0;
                 Ded13Dirf := 0;
                 IR13Dirf  := 0;
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
                        If (EEMember.Vinculo[1] <> 'N') and
                           (EEMember.Vinculo[1] <> 'A') and
                           (EEMember.Status     <> 'X') then
                           begin
                             ReadWrite(#09,'R','N',XXNumber);
                             TemIR := 0;
                             For I := 1 to 12 do
                             begin
                               TemIR := TemIR + HPMember.IRenda[I];
                             end;
                             TemIR := TemIR + HPMember.Pg13_IR;
                             If TemIR > 0 then
                                begin
                                  Writeln(EEMember.Nome);
                                  NCont := NCont + 1;

                                  For I := 1 to 12 do
                                  begin
                                    RDirf[I] := RDirf[I] + HPMember.RendDirf[I];
                                    DDirf[I] := DDirf[I] + (HPMember.Dependentes[I] +
                                                            HPMember.ValorInss[I]   +
                                                            HPMember.Pensao[I]);
                                    IDirf[I] := IDirf[I] + HPMember.IRenda[I];
                                  end;

                                  Pg13Dirf  := Pg13Dirf + HPMember.Pg13_ValorD;
                                  Ded13Dirf := Ded13Dirf + (HPMember.Pg13_Dep + HPMember.Pg13_Inss);
                                  IR13Dirf  := IR13Dirf + HPMember.Pg13_IR;

                                  Linhas   := Linhas + 1;
                                  {$I-}
                                  Writeln (TxtFile,QQStr(Linhas,8,'0'),
                                                   '2',
                                                   FString(LimpaChave(CMstMember.CGC),14),
                                                   '0561',
                                                   '1',
                                                   FString(LimpaChave(Trim(EEMember.Cpf)),14),
                                                   Maiuscula(EEMember.Nome,60),
                                                   FReal((HPMember.RendDirf[1] * 100),0,15),
                                                   FReal(((HPMember.Dependentes[1] +
                                                           HPMember.ValorInss[1]   +
                                                           HPMember.Pensao[1]) * 100),0,15),
                                                   FReal((HPMember.IRenda[1] * 100),0,15),
                                                   FReal((HPMember.RendDirf[2] * 100),0,15),
                                                   FReal(((HPMember.Dependentes[2] +
                                                           HPMember.ValorInss[2]   +
                                                           HPMember.Pensao[2]) * 100),0,15),
                                                   FReal((HPMember.IRenda[2] * 100),0,15),
                                                   FReal((HPMember.RendDirf[3] * 100),0,15),
                                                   FReal(((HPMember.Dependentes[3] +
                                                           HPMember.ValorInss[3]   +
                                                           HPMember.Pensao[3]) * 100),0,15),
                                                   FReal((HPMember.IRenda[3] * 100),0,15),
                                                   FReal((HPMember.RendDirf[4] * 100),0,15),
                                                   FReal(((HPMember.Dependentes[4] +
                                                           HPMember.ValorInss[4]   +
                                                           HPMember.Pensao[4]) * 100),0,15),
                                                   FReal((HPMember.IRenda[4] * 100),0,15),
                                                   FReal((HPMember.RendDirf[5] * 100),0,15),
                                                   FReal(((HPMember.Dependentes[5] +
                                                           HPMember.ValorInss[5]   +
                                                           HPMember.Pensao[5]) * 100),0,15),
                                                   FReal((HPMember.IRenda[5] * 100),0,15),
                                                   FReal((HPMember.RendDirf[6] * 100),0,15),
                                                   FReal(((HPMember.Dependentes[6] +
                                                           HPMember.ValorInss[6]   +
                                                           HPMember.Pensao[6]) * 100),0,15),
                                                   FReal((HPMember.IRenda[6] * 100),0,15),
                                                   FReal((HPMember.RendDirf[7] * 100),0,15),
                                                   FReal(((HPMember.Dependentes[7] +
                                                           HPMember.ValorInss[7]   +
                                                           HPMember.Pensao[7]) * 100),0,15),
                                                   FReal((HPMember.IRenda[7] * 100),0,15),
                                                   FReal((HPMember.RendDirf[8] * 100),0,15),
                                                   FReal(((HPMember.Dependentes[8] +
                                                           HPMember.ValorInss[8]   +
                                                           HPMember.Pensao[8]) * 100),0,15),
                                                   FReal((HPMember.IRenda[8] * 100),0,15),
                                                   FReal((HPMember.RendDirf[9] * 100),0,15),
                                                   FReal(((HPMember.Dependentes[9] +
                                                           HPMember.ValorInss[9]   +
                                                           HPMember.Pensao[9]) * 100),0,15),
                                                   FReal((HPMember.IRenda[9] * 100),0,15),
                                                   FReal((HPMember.RendDirf[10] * 100),0,15),
                                                   FReal(((HPMember.Dependentes[10] +
                                                           HPMember.ValorInss[10]   +
                                                           HPMember.Pensao[10]) * 100),0,15),
                                                   FReal((HPMember.IRenda[10] * 100),0,15),
                                                   FReal((HPMember.RendDirf[11] * 100),0,15),
                                                   FReal(((HPMember.Dependentes[11] +
                                                           HPMember.ValorInss[11]   +
                                                           HPMember.Pensao[11]) * 100),0,15),
                                                   FReal((HPMember.IRenda[11] * 100),0,15),
                                                   FReal((HPMember.RendDirf[12] * 100),0,15),
                                                   FReal(((HPMember.Dependentes[12] +
                                                           HPMember.ValorInss[12]   +
                                                           HPMember.Pensao[12]) * 100),0,15),
                                                   FReal((HPMember.IRenda[12] * 100),0,15),
                                                   FReal((HPMember.Pg13_ValorD * 100),0,15),
                                                   FReal(((HPMember.Pg13_Dep + HPMember.Pg13_Inss) * 100),0,15),
                                                   FReal((HPMember.Pg13_IR * 100),0,15),
                                                   ConstStr(' ',30),
                                                   ConstStr('x',13));
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
                           end;
                      end;
                 Until RC = 'N';
                 If TC <> #27 then
                    begin
                      Linhas := Linhas + 1;
                      Writeln (TxtFile,QQStr(Linhas,8,'0'),
                                       '3',
                                       FString(LimpaChave(CMstMember.CGC),14),
                                       '0561',
                                       FReal(NCont,0,8),
                                       ConstStr(' ',67),
                                       FReal((RDirf[1] * 100),0,15),
                                       FReal((DDirf[1] * 100),0,15),
                                       FReal((IDirf[1] * 100),0,15),
                                       FReal((RDirf[2] * 100),0,15),
                                       FReal((DDirf[2] * 100),0,15),
                                       FReal((IDirf[2] * 100),0,15),
                                       FReal((RDirf[3] * 100),0,15),
                                       FReal((DDirf[3] * 100),0,15),
                                       FReal((IDirf[3] * 100),0,15),
                                       FReal((RDirf[4] * 100),0,15),
                                       FReal((DDirf[4] * 100),0,15),
                                       FReal((IDirf[4] * 100),0,15),
                                       FReal((RDirf[5] * 100),0,15),
                                       FReal((DDirf[5] * 100),0,15),
                                       FReal((IDirf[5] * 100),0,15),
                                       FReal((RDirf[6] * 100),0,15),
                                       FReal((DDirf[6] * 100),0,15),
                                       FReal((IDirf[6] * 100),0,15),
                                       FReal((RDirf[7] * 100),0,15),
                                       FReal((DDirf[7] * 100),0,15),
                                       FReal((IDirf[7] * 100),0,15),
                                       FReal((RDirf[8] * 100),0,15),
                                       FReal((DDirf[8] * 100),0,15),
                                       FReal((IDirf[8] * 100),0,15),
                                       FReal((RDirf[9] * 100),0,15),
                                       FReal((DDirf[9] * 100),0,15),
                                       FReal((IDirf[9] * 100),0,15),
                                       FReal((RDirf[10] * 100),0,15),
                                       FReal((DDirf[10] * 100),0,15),
                                       FReal((IDirf[10] * 100),0,15),
                                       FReal((RDirf[11] * 100),0,15),
                                       FReal((DDirf[11] * 100),0,15),
                                       FReal((IDirf[11] * 100),0,15),
                                       FReal((RDirf[12] * 100),0,15),
                                       FReal((DDirf[12] * 100),0,15),
                                       FReal((IDirf[12] * 100),0,15),
                                       FReal((Pg13Dirf * 100),0,15),
                                       FReal((Ded13Dirf * 100),0,15),
                                       FReal((IR13Dirf * 100),0,15),
                                       ConstStr(' ',30),
                                       ConstStr('x',13));
                      Window(1,1,80,25);
                      Close ( TxtFile );
                      Color(Blue,Black);
                      GotoXY(1,23);  Write(ConstStr(' ',80));
                      GotoXY(1,23);  Write(' Total de Empregados gerados..: ');
                      Color(Blue,White);
                      GotoXY(33,23); Write(NCont:5);
                      TeclaReturn;
                    end;
                 Dispose6 ( Root6 );
                 Root6 := NIL;
               end;
          end;
     end;
end;
