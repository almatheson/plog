{$O+,F+}
Unit PlogGFip;

Interface

Uses Crt,Dos,PlogGlbs,PlogBasP,PlogTree;


   Procedure GFip;

Implementation

Const
  Zeros        = '000000000000000000000000000000';

Var
   TxtFile                   : TEXT;

   QueEndereco,
   FGTSNoPrazo,INSSNoPrazo   : Char;
   SalFamilia,
   Remuneracao,
   Dec13Salario,Base13Salario   : Real;
   FGTSDataReco,INSSDataReco : String[8];
   INSSIndice                : String[7];


Function FReal(I : Real; D,T : Integer) : Str30;
Var
  St1,St2  : String[30];
begin
  Str(I:15:D,St1);
  St1 := LeftAdjust(St1);
  If Length(St1) < T then St2 := Copy(Zeros,1,(T - Length(St1))) + St1
                     else St2 := St1;
  FReal := Copy(St2,1,T);
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
  Color(Blue,White);
  GotoXY(1,23); Write(ConstStr(' ',80));
  GotoXY(2,23); Write('Informe DRIVE:\PATH\ARQUIVO:');
  XDisco := '';
  Repeat
    K := 1;
    Repeat
      J := XDisco;
      InputStr(J,40,31,23,0,'S','N','T','N',Blue,Yellow);
      XDisco := UpCaseStr(J);
      GotoXY(31,23); Write(XDisco);
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


Procedure EntryGFip;
begin
  Color(Tfn,Ttx);
  GotoXY(4,09); Write('Que endere‡o(Contador/Empresa)....:');
  GotoXY(4,10); Write('FGTS (1=Prazo/2=Atraso)...........:');
  GotoXY(4,11); Write('FGTS Data recolhimento(DDMMAAAA)..:');
  GotoXY(4,12); Write('INSS (1=Prazo/2=Atraso/3=Sem GRPS):');
  GotoXY(4,13); Write('INSS Data recolhimento(DDMMAAAA)..:');
  GotoXY(4,14); Write('INSS Indice recolhimento..........:');
  QueEndereco  := 'E';
  FGTSNoPrazo  := '1';
  FGTSDataReco := '';
  INSSNoPrazo  := '1';
  INSSDataReco := '';
  INSSIndice   := '';
  Repeat
    TC := #13;
    K  := 0;
    Repeat
      Case K of
           1  :  begin
                   J := QueEndereco;
                   InputStr(J,1,40,09,0,'S','N','T','N',Tfn,Utx);
                   QueEndereco := UpCase(J[1]);
                   If (QueEndereco <> 'C') and (QueEndereco <> 'E') then
                      begin
                        ErroMsg := 'Informe C ou E';
                        ErrorMessage;
                        K := K - 1;
                      end
                      else begin
                             GotoXY(40,09);
                             Case QueEndereco of
                                  'C' : Write('Contador');
                                  'E' : Write('Empresa ');
                             end;
                           end;
                 end;
           2  :  begin
                   J := FGTSNoPrazo;
                   InputStr(J,1,40,10,0,'S','N','T','N',Tfn,Utx);
                   FGTSNoPrazo := UpCase(J[1]);
                   If (FGTSNoPrazo <> '1') and (FGTSNoPrazo <> '2') then
                      begin
                        ErroMsg := 'Informe 1 ou 2';
                        ErrorMessage;
                        K := K - 1;
                      end
                      else begin
                             GotoXY(40,10);
                             Case FGTSNoPrazo of
                                  '1' : Write('No prazo     ');
                                  '2' : Write('Fora do prazo');
                             end;
                           end;
                 end;
           3  :  begin
                   J := FGTSDataReco;
                   InputStr(J,8,40,11,0,'S','N','T','N',Tfn,Utx);
                   FGTSDataReco := J;
                   If FGTSDataReco = '' then
                      begin
                        ErroMsg := 'Informe DDMMAAAA';
                        ErrorMessage;
                        K := K - 1;
                      end;
                 end;
           4  :  begin
                   J := INSSNoPrazo;
                   InputStr(J,1,40,12,0,'S','N','T','N',Tfn,Utx);
                   INSSNoPrazo := UpCase(J[1]);
                   If (INSSNoPrazo <> '1') and (INSSNoPrazo <> '2') and (INSSNoPrazo <> '3') then
                      begin
                        ErroMsg := 'Informe 1,2 ou 3';
                        ErrorMessage;
                        K := K - 1;
                      end
                      else begin
                             GotoXY(40,12);
                             Case INSSNoPrazo of
                                  '1' : Write('No prazo     ');
                                  '2' : Write('Fora do prazo');
                                  '3' : Write('Sem GRPS     ');
                             end;
                           end;
                 end;
           5  :  begin
                   J := INSSDataReco;
                   InputStr(J,8,40,13,0,'S','N','T','N',Tfn,Utx);
                   INSSDataReco := J;
                   If INSSDataReco = '' then
                      begin
                        ErroMsg := 'Informe DDMMAAAA';
                        ErrorMessage;
                        K := K - 1;
                      end;
                 end;
           6  :  begin
                   J := INSSIndice;
                   InputStr(J,7,40,14,0,'S','N','T','N',Tfn,Utx);
                   INSSIndice := J;
                 end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 7) or (TC = #27);
    If TC <> #27 then Confirma;
  Until TC in [#27,'S'];
end;

Procedure GeraGFIP00;
begin
  GotoXY(4,16); Write('Gerando registro 00 - Header do Arquivo');
  Reset ( OwnerFile );
  ReadWrite(#01,'R','N',0);

  Case QueEndereco of
         'C' : Writeln (TxtFile,'00',
                   ConstStr(' ',49),
                   CMstMember.Tipo,
                   PushLeft(14,CMstMember.CGC_CEI),
                   Maiuscula(LimpaChave(PushLeft(30,Copy(CMstMember.Descricao,1,30))),30),
                   Maiuscula(LimpaChave(PushLeft(20,CMstMember.Nome)),20),
                   Maiuscula(LimpaChave(PushLeft(50,OwnerMember.Endereco+', '+OwnerMember.Numero)),50),
                   Maiuscula(LimpaChave(PushLeft(20,OwnerMember.Bairro)),20),
                   Copy(OwnerMember.Cep,1,5) + Copy(OwnerMember.Cep,7,3),
                   Maiuscula(LimpaChave(PushLeft(20,OwnerMember.Cidade)),20),
                   OwnerMember.Estado,
                   PushLeft(4,Copy(OwnerMember.Telefone,1,4)) + PushLeft(8,LimpaChave(Copy(OwnerMember.Telefone,6,8))),
                   PushLeft(60,CMstMember.EMail),
                   '19',AAFx,Copy(MMFx,2,2),
                   CMstMember.Recolhimento,
                   FGTSNoPrazo,
                   PushLeft(8,FGTSDataReco),
                   INSSNoPrazo,
                   PushLeft(8,INSSDataReco),
                   PushLeft(7,INSSIndice),
                   ConstStr(' ',37),
                   '*');
         'E' : Writeln (TxtFile,'00',
                   ConstStr(' ',49),
                   CMstMember.Tipo,
                   PushLeft(14,CMstMember.CGC_CEI),
                   Maiuscula(LimpaChave(PushLeft(30,Copy(CMstMember.Descricao,1,30))),30),
                   Maiuscula(LimpaChave(PushLeft(20,CMstMember.Nome)),20),
                   Maiuscula(LimpaChave(PushLeft(50,CMstMember.Endereco+', '+CMstMember.Numero)),50),
                   Maiuscula(LimpaChave(PushLeft(20,CMstMember.Bairro)),20),
                   Copy(CMstMember.Cep,1,5) + Copy(CMstMember.Cep,7,3),
                   Maiuscula(LimpaChave(PushLeft(20,CMstMember.Cidade)),20),
                   CMstMember.Estado,
                   PushLeft(4,CMstMember.DDD) + PushLeft(8,LimpaChave(CMstMember.Telefone)),
                   PushLeft(60,CMstMember.EMail),
                   '19',AAFx,Copy(MMFx,2,2),
                   CMstMember.Recolhimento,
                   FGTSNoPrazo,
                   PushLeft(8,FGTSDataReco),
                   INSSNoPrazo,
                   PushLeft(8,INSSDataReco),
                   PushLeft(7,INSSIndice),
                   ConstStr(' ',37),
                   '*');
  end;
  Close ( OwnerFile );
end;

Procedure GeraGFip10;
begin
  GotoXY(4,17); Write('Gerando registro 10 - Header da Empresa');

  Writeln (TxtFile,'10',
                   CMstMember.Tipo,
                   CMstMember.CGC_CEI,
                   ConstStr('0',34),
                   Maiuscula(LimpaChave(PushLeft(40,Copy(CMstMember.Descricao,1,30))),40),
                   Maiuscula(LimpaChave(PushLeft(50,CMstMember.Endereco+', '+CMstMember.Numero)),50),
                   Maiuscula(LimpaChave(PushLeft(20,CMstMember.Bairro)),20),
                   Copy(CMstMember.Cep,1,5) + Copy(CMstMember.Cep,7,3),
                   Maiuscula(LimpaChave(PushLeft(20,CMstMember.Cidade)),20),
                   CMstMember.Estado,
                   PushLeft(4,CMstMember.DDD) + PushLeft(8,LimpaChave(CMstMember.Telefone)),
                   CMstMember.Alt_End,
                   Copy(CMstMember.CNAE,1,5),
                   CMstMember.Alt_CNAE,
                   FReal((CMstMember.Alq_SAT * 100),0,2),
                   CMstMember.Centralizado,
                   ConstStr('0',14),
                   CMstMember.Simples,
                   Copy(CMstMember.Cod_FPAS,1,3),
                   Copy(CMstMember.Terceiros,1,4),
                   FReal((SalFamilia * 100),0,17),
                   ConstStr('0',3),
                   ConstStr('0',4),
                   ConstStr('0',9),
                   ConstStr(' ',91),
                   '*');
end;

Procedure GeraGFip13(Alteracao : Str3; Conteudo : Str40);
begin
  GotoXY(4,18); Write('Gerando registro 13 - Altera‡„o Cad. Trabalhador');

  Writeln (TxtFile,'13',
                   CMstMember.Tipo,
                   CMstMember.CGC_CEI,
                   ConstStr('0',34),
                   FString(LimpaChave(EEMember.PisPasep),11),
                   EEMember.DDAdm + EEMember.MMAdm + '19' + EEMember.AAAdm,
                   ConstStr('0',11),
                   FString(EEMember.CTrabN,7),
                   FString(EEMember.CTrabS,5),
                   Maiuscula(LimpaChave(Copy(EEMember.Nome,1,40)),40),
                   '01',
                   CMstMember.Cod_Caixa,
                   FString(EEMember.ContaFgts,11),
                   Alteracao,
                   PushLeft(40,Conteudo),
                   ConstStr(' ',156),
                   '*');
end;

Procedure GeraGFip14;
begin
  GotoXY(4,19); Write('Gerando registro 14 - InclusÆo/Altera‡„o End. Trabalhador');

  Writeln (TxtFile,'14',
                   CMstMember.Tipo,
                   CMstMember.CGC_CEI,
                   ConstStr('0',34),
                   FString(LimpaChave(EEMember.PisPasep),11),
                   EEMember.DDAdm + EEMember.MMAdm + '19' + EEMember.AAAdm,
                   Maiuscula(LimpaChave(Copy(EEMember.Nome,1,40)),40),
                   '01',
                   FString(EEMember.CTrabN,7),
                   FString(EEMember.CTrabS,5),
                   Maiuscula(LimpaChave(PushLeft(50,EEMember.Endereco)),50),
                   Maiuscula(PushLeft(20,EEMember.Bairro),20),
                   EEMember.Cep + EEMember.CepCompl,
                   Maiuscula(PushLeft(20,EEMember.Cidade),20),
                   EEMember.Estado,
                   ConstStr(' ',135),
                   '*');
end;

Procedure GeraGFip30;
begin
  GotoXY(4,20); Write('Gerando registro 30 - Registro do Trabalhador');

  Writeln (TxtFile,'30',
                   CMstMember.Tipo,
                   CMstMember.CGC_CEI,
                   ConstStr(' ',15),
                   FString(LimpaChave(EEMember.PisPasep),11),
                   EEMember.DDAdm + EEMember.MMAdm + '19' + EEMember.AAAdm,
                   ConstStr('0',15),
                   Maiuscula(LimpaChave(Copy(EEMember.Nome,1,40)),40),
                   ConstStr('0',11),
                   FString(EEMember.CTrabN,7),
                   FString(EEMember.CTrabS,5),
                   Copy(EEMember.DataOpcao,1,2) + Copy(EEMember.DataOpcao,4,2) + '19' + Copy(EEMember.DataOpcao,7,2),
                   EEMember.DDAdm + EEMember.MMAdm + '19' + EEMember.AAAdm,
                   FReal((Remuneracao * 100),0,15),
                   FReal((Dec13Salario * 100),0,15),
                   '00',
                   '01',
                   '00',
                   ConstStr(' ',15),
                   FReal((Base13Salario * 100),0,15),
                   ConstStr(' ',148),
                   '*');
end;

Procedure GeraGFip32(Cod : Str2; S : Char; Dias : Str2);
begin
  GotoXY(4,21); Write('Gerando registro 32 - Movimenta‡„o do Trabalhador');

  Writeln (TxtFile,'32',
                   CMstMember.Tipo,
                   CMstMember.CGC_CEI,
                   ConstStr(' ',15),
                   FString(LimpaChave(EEMember.PisPasep),11),
                   EEMember.DDAdm + EEMember.MMAdm + '19' + EEMember.AAAdm,
                   Cod,
                   EEMember.DDResc + EEMember.MMResc + '19' + EEMember.AAResc,
                   S,
                   Dias,
                   ConstStr(' ',200),
                   ConstStr(' ',95),
                   '*');
end;

Procedure GFip;
Var
  Erro,
  Mes,Ano,I       : Integer;
begin
 EntryGFip;
 If TC = 'S' then
     begin
       QueArquivo;
       If TC = 'S' then
          begin
            LimpaLn(23,Tfd);
            LimpaLn(24,Tfd);
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
                 end
                 else If Erro = 152 then
                         begin
                           ErroMsg := 'Verifique o Drive.';
                           ErrorMessage;
                           TC := 'N';
                         end
                         else If Erro <> 0 then
                                 begin
                                   ErroMsg := 'Arquivo '+XDisco+' n„o existe.';
                                   ErrorMessage;
                                   TC := #27;
                                 end
                                 else TC := 'S';
            Until TC in [#27,'S'];
          end;
       If TC = 'S' then
          begin
            GeraGFip00;

            SalFamilia := 0;

            LoadIndex6 ('E','P');
            If TC <> #27 then
               begin
                 NCont  := 0;
                 XXNo   := '';
                 Repeat
                   RC := 'N';
                   SearchPos6 ( Root6 );
                   If RC = 'S' then
                      begin
                        ReadWrite(#08,'R','N',XXNumber);
                        If (RW                  = 'S'            ) and
                           (EEMember.Status in ['A','E','F','V'] ) and
                           (EEMember.Vinculo[1] <> 'A'           ) and
                           (EEMember.Vinculo[1] <> 'N'           ) then
                           begin
                             EENo := EEMember.Matricula;
                             LoadMVDsk(#11);
                             YYNo := '003';
                             SearchTreeY ( RootY );
                             If RC = 'S' then SalFamilia := SalFamilia + YAddress^.AcMensalV;
                             NCont := NCont + 1;
                           end;
                      end;
                   If TC = #27 then RC := 'N';
                 Until RC = 'N';
                 GeraGFip10;

                 XXNo   := '';
                 Repeat
                   RC := 'N';
                   SearchPos6 ( Root6 );
                   If RC = 'S' then
                      begin
                        ReadWrite(#08,'R','N',XXNumber);
                        If (RW                  = 'S'            ) and
                           (EEMember.Vinculo[1] <> 'A'           ) and
                           (EEMember.Vinculo[1] <> 'N'           ) then
                           begin
                             If EEMember.Status in ['A','E','F','V'] then
                                begin
                                  If EEMember.Alt_CTrab = 'S'
                                     then GeraGFip13('403',FString(EEMember.CTrabN,7) + FString(EEMember.CTrabS,5));

                                  If EEMember.Alt_Nome  = 'S'
                                     then GeraGFip13('404',Maiuscula(Copy(EEMember.Nome,1,40),40));

                                  If EEMember.Alt_Pis   = 'S'
                                     then GeraGFip13('405',FString(LimpaChave(EEMember.PisPasep),11));

                                  If EEMember.Alt_Adm   = 'S'
                                     then GeraGFip13('408',EEMember.DDAdm + EEMember.MMAdm + '19' +
                                                           EEMember.AAAdm);

                                  If EEMember.Alt_Nasc  = 'S'
                                     then GeraGFip13('428',EEMember.DDNasc + EEMember.MMNasc + '19' +
                                                           EEMember.AANasc);

                                  Val(EEMember.MMAdm,Mes,E);
                                  Val(EEMember.AAAdm,Ano,E);

                                  If (EEMember.Alt_Ende  = 'S') or ((Mes = MM) and (Ano = AA)) then GeraGFip14;
                                end;
                           end;
                      end;
                   If TC = #27 then RC := 'N';
                 Until RC = 'N';

                 XXNo   := '';
                 Repeat
                   RC := 'N';
                   SearchPos6 ( Root6 );
                   If RC = 'S' then
                      begin
                        ReadWrite(#08,'R','N',XXNumber);
                        If (RW                  = 'S'            ) and
                           (EEMember.Vinculo[1] <> 'A'           ) and
                           (EEMember.Vinculo[1] <> 'N'           ) then
                           begin
                             EENo := EEMember.Matricula;
                             LoadMVDsk(#11);

                             YYNo := '005';
                             SearchTreeY ( RootY );
                             If RC = 'S' then Dec13Salario := YAddress^.AcMensalV;

                             YYNo := '081';
                             SearchTreeY ( RootY );
                             If RC = 'S' then Remuneracao := YAddress^.AcMensalV;

                             GeraGFip30;
                           end;
                      end;
                   If TC = #27 then RC := 'N';
                 Until RC = 'N';

                 XXNo   := '';
                 Repeat
                   RC := 'N';
                   SearchPos6 ( Root6 );
                   If RC = 'S' then
                      begin
                        ReadWrite(#08,'R','N',XXNumber);
                        If (RW                  = 'S'            ) and
                           (EEMember.Vinculo[1] <> 'A'           ) and
                           (EEMember.Vinculo[1] <> 'N'           ) then
                           begin
                             Case EEMember.Status of
                                  'D' : GeraGFip32('I ','S','00');
                                  'J' : begin
                                          Val(EEMember.AAResc,I,E);
                                          If I < AA then GeraGFip32('H ',' ','00')
                                                    else GeraGFip32('K ',' ','00');
                                        end;
                                  'L' : begin
                                          If EEMember.MesI < MM then GeraGFip32('P1',' ','15')
                                             else begin
                                                    GeraGFip32('P1',' ',QQStr(30 - EEMember.DiaI,2,'0'));
                                                  end;
                                        end;
                                  'M' : GeraGFip32('S ','S','00');
                                  'N' : GeraGFip32('L ','S','00');
                                  'O' : GeraGFip32('U2','S','00');
                                  'P' : GeraGFip32('J ','S','00');
                             end;
                           end;
                      end;
                   If TC = #27 then RC := 'N';
                 Until RC = 'N';

                 Writeln (TxtFile,'90',
                                  ConstStr('9',49),
                                  ConstStr(' ',200),
                                  ConstStr(' ',108),
                                  '*');

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

end.