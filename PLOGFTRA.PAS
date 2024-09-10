{$O+,F+}
Unit PlogFtra;

Interface

Uses Crt,Dos,PlogGlbs,PlogBasP,PlogTree,PlogRpt0;


   Procedure Fetransport;
   Procedure FetransportRel;

Implementation

Const
  Zeros        = '000000000000000000000000000000';
Var
  TxtFile      : TEXT;
  SouA         : Char;


Function FReal(I : Real; D,T : Integer) : Str30;
Var
  St1,St2  : String[30];
begin
  Str(I:15:D,St1);
  St1 := LeftAdjust(St1);
  If Length(St1) < T then St2 := Copy(Zeros,1,(T - Length(St1))) + St1
                     else St2 := St1;
  FReal := St2;
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


Procedure PedeFetransport;
begin
  Color(Tfn,Ttx);
  GotoXY(4,11); Write('MM AAAA:');
  GotoXY(4,12); Write('Dias Ut:');
  GotoXY(4,13); Write('Dias Ut:');
  GotoXY(4,14); Write('Vers„o.:');
  DU  := 0;
  DUF := 0;
  Sq  := '1';
  Repeat
    TC := #13;
    K  := 0;
    Repeat
      Case K of
           0  :  PedeDepto(10,'L');
           1  :  begin
                   J := '';
                   InputStr(J,2,13,11,0,'S','N','T','N',Tfn,Utx);
                   If J = '' then M := MM
                             else Val(J,M,E);
                   If (M < 0 ) or (M > 12) then
                      begin
                        ErroMsg := 'Mˆs Inv lido';
                        ErrorMessage;
                        K := K - 1;
                      end
                      else begin
                             GotoXY(13,11); Write(M:2);
                             J := '';
                             InputStr(J,4,16,11,0,'S','N','T','N',Tfn,Utx);
                             If J = '' then A := AA
                                       else Val(J,A,E);
                             If A = 0 then
                                begin
                                  ErroMsg := 'Ano Inv lido';
                                  ErrorMessage;
                                  K := K - 1;
                                end
                                else begin
                                       GotoXY(16,11); Write(A:4);
                                     end;
                           end;
                 end;
           2  :  begin
                   If DU = 0 then J := ''
                             else begin
                                    Str(DU:2,J);
                                    J := LeftAdjust(J);
                                  end;
                   InputStr(J,2,13,12,0,'S','N','T','N',Tfn,Utx);
                   If J = '' then DU := 22
                             else Val(J,DU,E);
                   If DU = 0 then
                      begin
                        ErroMsg := 'Numero de Dias Inv lido';
                        ErrorMessage;
                        K := K - 1;
                      end
                      else begin
                             GotoXY(13,12); Write(DU:2);
                           end;
                 end;
           3  :  begin
                   If DUF = 0 then J := ''
                              else begin
                                     Str(DUF:2,J);
                                     J := LeftAdjust(J);
                                   end;
                   InputStr(J,2,13,13,0,'S','N','T','N',Tfn,Utx);
                   If J = '' then DUF := DU
                             else Val(J,DUF,E);
                   If DUF = 0 then
                      begin
                        ErroMsg := 'N£mero de Dias Inv lido';
                        ErrorMessage;
                        K := K - 1;
                      end
                      else begin
                             GotoXY(13,13); Write(DUF:2);
                           end;
                 end;
           4 : begin
                 J := Sq;
                 InputStr(J,1,13,14,0,'S','N','T','N',Tfn,Utx);
                 GotoXY(13,14);
                 Sq := J[1];
                 Case Sq of
                      '1' : Write('1¦ vers„o');
                      '2' : Write('2¦ vers„o');
                      else begin
                             ErroMsg := 'Informe 1 ou 2 (vers„o)';
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
    Until (K = 5) or (TC = #27);
    If TC <> #27 then Confirma;
  Until TC in [#27,'S'];
end;


Procedure Fetransport;
Var
  Erro,NPass,Linhas,NFun,Tot2  : Integer;
  VTotal,TPass                 : Real;
  RegTxt                       : String[207];
begin
  PedeFetransport;
  If TC = 'S' then
     begin
       QueArquivo;
       If TC = 'S' then
          begin
            Color(Blue,Cyan);
            GotoXY(1,23); Write(' ':80);
            GotoXY(2,23); Write('Este ‚ o primeiro arquivo do Disquete, [Sim ou N„o]');
            Color(Blue,White);
            GotoXY(42,23);  Write('S');
            GotoXY(49,23);  Write('N');
            Color(Red,Cyan);
            GotoXY(1,24); Write(' ':80);
            GotoXY(2,24); Write('Aten‡„o - Um disquete pode conter v rias empresas.');
            Repeat
              SouA := UpCase(ReadKey);
            Until SouA in ['S','N'];
            LimpaLn(23,Tfd);
            LimpaLn(24,Tfd);
            Assign ( TxtFile, (XDisco));
            Repeat
              Case SouA of
                   'N' : begin
                           {$I-}
                           Reset ( TxtFile );
                           {$I+}
                           Erro := IOResult;
                           If Erro = 0 then
                              begin
                                Linhas := 0;
                                While not Eof(TxtFile) do
                                begin
                                  Readln(TxtFile,RegTxt);
                                  Linhas := Linhas + 1;
                                end;
                                Close   ( TxtFile );
                                {$I-}
                                Append ( TxtFile );
                                {$I+}
                                If IOResult <> 0 then
                                   begin
                                     Close   ( TxtFile );
                                     Erase   ( TxtFile );
                                     ReWrite ( TxtFile );
                                     Linhas := 0;
                                     Erro   := 0;
                                   end;
                              end;
                         end;
                   'S' : begin
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
                         end;
              end;
              If Erro = 152 then
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
            TTAC := TTNo;
            LoadIndex6 ('D','A');
            If TC <> #27 then
               begin
                 TC   := 'S';
                 TTNo := AAFx + Copy(MMFx,2,2) + Sq;
                 SearchTree4 ( Root4 );
                 If RC = 'S' then ReadWrite(#03,'R','N',TTNumber)
                             else TC := #27;
               end;
            If TC <> #27 then
               begin
                 ParaContinua;
                 Janela('F');
                 NCont  := 0;
                 NPass  := 0;
                 TPass  := 0;
                 VTotal := 0;
                 NFun   := 0;
                 Tot2   := 0;
                 XXNo   := '';
                 DDAC   := DDNo;
                 If DDNo <> '' then
                    begin
                      RC := 'N';
                      SearchAnt3 ( Root3 );
                      If RC = 'N' then DDNo := '';
                    end;
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
                               ReadWrite(#08,'R','N',XXNumber);
                               If Ex = 'L' then DDNo := EEMember.Depto;
                               If (((Ex             = 'X' ) and
                                    (EEMember.Depto = DDNo) and
                                   (DDMember.Marca = #004)) or
                                   ((Ex             <> 'X') and
                                  (EEMember.Depto = DDNo))) then
                                  begin
                                    If (RW                  = 'S'            ) and
                                       (EEMember.Status in ['A','E','F','V'] ) and
                                       (EEMember.Vinculo[1] <> 'A'           ) and
                                       (EEMember.Vinculo[1] <> 'N'           ) and
                                       (EEMember.VTransporte in ['F','S']    ) then NFun := NFun + 1;
                                  end
                                  else If (EEMember.Depto <> DDNo) and
                                          (Ex              = 'N' ) then RC := 'N';
                             end;
                        Until RC = 'N';
	                If (DDNo = DDAC) or (Ex = 'L') then RC := 'N'
                                                       else RC := 'S';
                      end;
                 Until RC = 'N';
                 If SouA = 'S' then Linhas := 1
                               else Linhas := Linhas + 1;
                 Writeln (TxtFile,QQStr(Linhas,5,'0'),
                                  FString(LimpaChave(CMstMember.CGC),14),
                                  '1       ',
                                  Maiuscula(CMstMember.Descricao,40),
                                  Maiuscula((CMstMember.Endereco+', '+CMstMember.Numero),40),
                                  QQStr(M,2,'0'),
                                  QQStr(A,4,'0'),
                                  QQStr(NFun,5,'0'),
                                  LimpaChave(CMstMember.Cep),
                                  Maiuscula(CMstMember.Bairro,17),
                                  Maiuscula(CMstMember.Cidade,20),
                                  PushLeft(2,CMstMember.Estado),
                                  FString(Copy(CMstMember.CNAE,1,4),4),
                                  FString(CMstMember.DDD,4),
                                  FString(LimpaChave(CMstMember.Telefone),7),
                                  ConstStr('0',4),
                                  ConstStr(' ',25));
                 DDNo := DDAC;
                 If DDNo <> '' then
                    begin
                      RC := 'N';
                      SearchAnt3 ( Root3 );
                      If RC = 'N' then DDNo := '';
                    end;
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
                               ReadWrite(#08,'R','N',XXNumber);
                               If Ex = 'L' then DDNo := EEMember.Depto;
                               If (((Ex             = 'X' ) and
                                    (EEMember.Depto = DDNo) and
                                   (DDMember.Marca = #004)) or
                                   ((Ex             <> 'X') and
                                  (EEMember.Depto = DDNo))) then
                                  begin
                                    If (RW                  = 'S'            ) and
                                       (EEMember.Status in ['A','E','F','V'] ) and
                                       (EEMember.Vinculo[1] <> 'A'           ) and
                                       (EEMember.Vinculo[1] <> 'N'           ) and
                                       (EEMember.VTransporte in ['F','S']    ) then
                                       begin
                                         NCont := NCont + 1;
                                         Writeln(EEMember.Nome);
                                         If EEMember.DiasVT <> 0 then DiasT := EEMember.DiasVT
                                            else begin
                                                   DDNo := EEMember.Depto;
                                                   SearchTree3 ( Root3 );
                                                   If RC = 'S' then
                                                      begin
                                                        ReadWrite(#05,'R','N',DDNumber);
                                                        If (RW             = 'S') and
                                                           (DDMember.Dias2 <> 0 ) then DiasT := DDMember.Dias2
                                                           else If EEMember.VTransporte = 'S' then DiasT := DU
                                                                                              else DiasT := DUF;
                                                      end
                                                      else If EEMember.VTransporte = 'S' then DiasT := DU
                                                                                         else DiasT := DUF;
                                                 end;
                                         For I := 1 to 6
                                         do If EEMember.Passagens[I] <> 0 then
                                               begin
                                                 For K := 1 to EEMember.Passagens[I] do
                                                 begin
                                                   If TTMember.TPass[EEMember.Faixa[I]] = 'F' then
                                                      begin
                                                        TTMember.TPass[EEMember.Faixa[I]] := 'M';
                                                        TPass  := TPass  + 1;
                                                        VTotal := VTotal + TTMember.VPass[EEMember.Faixa[I]];
                                                      end
                                                      else begin
                                                             TPass  := TPass  + DiasT;
                                                             VTotal := VTotal + (TTMember.VPass[EEMember.Faixa[I]] * DiasT);
                                                           end;
                                                   Linhas := Linhas + 1;
                                                   If TTMember.VPass[EEMember.Faixa[I]] > 0 then
                                                      begin
                                                        {$I-}
                                                        If TTMember.TPass[EEMember.Faixa[I]] = 'F'
                                                           then Writeln (TxtFile,QQStr(Linhas,5,'0'),
                                                                         FString(LimpaChave(CMstMember.CGC),14),
                                                                         '2',TTMember.TPass[EEMember.Faixa[I]],
                                                                         QQStr(1,9,'0'),
                                                                         FReal((TTMember.VPass[EEMember.Faixa[I]] * 100),0,8),
                                                                         ConstStr(' ',144),
                                                                         PushLeft(8,EEMember.Matricula),
                                                                         Maiuscula(Copy(EEMember.Nome,1,14),14),
                                                                         FString(Copy(EEMember.Depto,1,3),3))
                                                           else Writeln (TxtFile,QQStr(Linhas,5,'0'),
                                                                        FString(LimpaChave(CMstMember.CGC),14),
                                                                        '2',TTMember.TPass[EEMember.Faixa[I]],
                                                                        QQStr(DiasT,9,'0'),
                                                                        FReal((TTMember.VPass[EEMember.Faixa[I]] * 100),0,8),
                                                                        ConstStr(' ',144),
                                                                        PushLeft(8,EEMember.Matricula),
                                                                        Maiuscula(Copy(EEMember.Nome,1,14),14),
                                                                        FString(Copy(EEMember.Depto,1,3),3));
                                                        {$I+}
                                                        If IOResult <> 0 then
                                                           begin
                                                             Window(1,1,80,25);
                                                             ErroMsg := 'gravando '+XDisco+', vou encerrar.';
                                                             ErrorMessage;
                                                             RC := 'N';
                                                             TC := #27;
                                                             K  := EEMember.Passagens[I];
                                                             I  := 6;
                                                           end
                                                           else Tot2 := Tot2  + 1;
                                                      end
                                                      else begin
                                                             Window(1,1,80,25);
                                                             Color(Blue,Cyan);
                                                             GotoXY(1,23); Write(' ':80);
                                                             GotoXY(2,23); Write('Aten‡„o: Erro no empregado ',
                                                                                  EEMember.Matricula,' - ',EEMember.Nome);
                                                             Color(Red,Cyan);
                                                             GotoXY(1,24); Write(' ':80);
                                                             GotoXY(2,24);
                                                             Write('A tarifa associada esta com o valor ZERADO, ',
                                                                   'estou encerrando, Tecle Enter.');
                                                             Repeat
                                                               TC := ReadKey;
                                                             Until TC = #13;
                                                             K  := EEMember.Passagens[I];
                                                             I  := 6;
                                                             RC := 'N';
                                                             TC := #27;
                                                           end;
                                                 end;
                                               end;
                                       end;
                                  end;
                             end
                             else If (EEMember.Depto <> DDNo) and
                                     (Ex              = 'N' ) then RC := 'N';
                          GoNoGo;
                          If TC = #27 then RC := 'N';
                        Until RC = 'N';
	                If (DDNo = DDAC) or (Ex = 'L') then RC := 'N'
                                                       else RC := 'S';
                      end;
                 Until RC = 'N';
                 Linhas := Linhas + 1;
                 {$I-}
                 Writeln (TxtFile,QQStr(Linhas,5,'0'),
                                  FString(LimpaChave(CMstMember.CGC),14),
                                  '3',
                                  QQStr(Tot2,5,'0'),
                                  FReal(TPass,0,9),
                                  FReal((VTotal * 100),0,15),
                                  ConstStr(' ',158));
                 {$I+}
                 If IOResult <> 0 then
                    begin
                      Window(1,1,80,25);
                      ErroMsg := 'gravando '+XDisco+', vou encerrar.';
                      ErrorMessage;
                    end;
                 Window(1,1,80,25);
                 Color(Blue,Cyan);
                 GotoXY(1,23); Write(' ':80);
                 GotoXY(2,23); Write('Gera o registro final (99999), [Sim ou N„o]');
                 Color(Blue,White);
                 GotoXY(34,23);  Write('S');
                 GotoXY(41,23);  Write('N');
                 Color(Red,Cyan);
                 GotoXY(1,24); Write(' ':80);
                 GotoXY(2,24); Write('Este registro s¢ deve ser gerado para o arquivo da £ltima empresa.');
                 Repeat
                   TC := UpCase(ReadKey);
                 Until TC in ['S','N'];
                 If TC = 'S' then Writeln (TxtFile,ConstStr('9',207));
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
            TTNo := TTAC;
            SearchTree4 ( Root4 );
            If RC = 'S' then ReadWrite(#03,'R','N',TTNumber);
          end;
     end;
end;


Procedure FetransportRel;
Var
   Nome        : String[40];
   CGC         : String[14];
   Telefone    : String[7];
   Vales       : Real;
   Valor       : Real;
   ValesT      : Real;
   ValorT      : Real;
   Tipo2       : Integer;
   Total1      : Integer;
   Total2      : Integer;
   Total3      : Integer;
   TotalS      : Integer;
   RegTxt      : String[207];

begin
  QPorta;
  If TC <> #27 then
     begin
       Color(Blue,White);
       GotoXY(1,23); Write(ConstStr(' ',80));
       GotoXY(2,23); Write('Inforne DRIVE:\PATH\ARQUIVO:');
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
       If TC = 'S' then
          begin
            Assign ( TxtFile, XDisco);
            {$I-}
            Reset ( TxtFile );
            {$I+}
            If IOResult = 0 then
	       begin
                 Vales  := 0;
                 Valor  := 0;
                 ValesT := 0;
                 ValorT := 0;
                 Tipo2  := 0;
                 Total1 := 0;
                 Total2 := 0;
                 Total3 := 0;
                 TotalS := 0;
                 If Laser <> 'N'
                    then WriteLine('L',LaserInit+Nx+
                                   PushLeft(72,'FETRANSPOR - Sistema de Pedido de Vale-Transporte')+Nf+
                                   XDia+'/'+XMes+'/'+XAno)
                    else WriteLine('L',Nx+PushLeft(72,'FETRANSPOR - Sistema de Pedido de Vale-Transporte')+Nf+
                                   XDia+'/'+XMes+'/'+XAno);
                 WriteLine('L',PushLeft(72,'LISTAGEM DE CONTROLE DE REGISTROS')+'Pag. 002');
                 WriteLine('L',' ');
                 WriteLine('L','Informante : '+PushLeft(20,OwnerMember.CGC)+'-  '+
                           Acentua(OwnerMember.RSocial));
                 WriteLine('L',ConstStr('-',80));
                 WriteLine('L',' ');
                 WriteLine('L',PushLeft(15,'CGC')+
                           PushLeft(17,'RAZAO SOCIAL')+
                           PushLeft(15,'TELEFONE')+
                           PushLeft(15,'QTD.VALES')+
                           PushLeft(13,'VALOR TOTAL')+'TIPO2');
                 WriteLine('L',' ');
                 While not Eof(TxtFile) do
                 begin
                   {$I-}
                   Readln(TxtFile,RegTxt);
                   {$I+}
                   If IOResult = 0 then
                      Case RegTxt[20] of
                           '1' : begin
                                   CGC      := Copy(RegTxt,6,14);
                                   Nome     := Copy(RegTxt,28,40);
                                   Telefone := Copy(RegTxt,172,7);
                                   Total1   := Total1 + 1;
                                   TotalS   := TotalS + 1;
                                   Tipo2    := 0;
                                 end;
                           '2' : begin
                                   Total2 := Total2 + 1;
                                   Tipo2  := Tipo2  + 1;
                                 end;
                           '3' : begin
                                   Val(Copy(RegTxt,26,9),Vales,E);
                                   Val(Copy(RegTxt,35,15),Valor,E);
                                   Valor  := Valor / 100;
                                   ValesT := ValesT + Vales;
                                   ValorT := ValorT + Valor;
                                   Total3 := Total3 + 1;
                                   WriteLine('L',PushLeft(15,CGC)+
                                             Acentua(Copy(Nome,1,16))+' '+
                                             PushLeft(13,Telefone)+
                                             PushRight(11,EditNumber(Vales))+
                                             PushRight(17,EditReal(Valor))+
                                             PushRight(7,EditInteger(Tipo2)));
                                 end;
                      end;
                 end;
                 WriteLine('L',' ');
                 WriteLine('L',ConstStr(' ',45)+ConstStr('-',28));
                 WriteLine('L',ConstStr(' ',45)+
                           PushRight(11,EditNumber(ValesT))+
                           PushRight(17,EditReal(ValorT))+
                           PushRight(7,EditInteger(Total2)));
                 WriteLine('L',' ');
                 WriteLine('L',ConstStr('=',80));
                 WriteLine('L',' ');
                 WriteLine('L',ConstStr(' ',20)+'QUANTIDADE DE REGISTROS');
                 WriteLine('L',' ');
                 WriteLine('L','REGISTRO DE IDENTIFICACAO TIPO 1  : '+PushRight(11,EditInteger(Total1)));
                 WriteLine('L',' ');
                 WriteLine('L','REGISTRO DE IDENTIFICACAO TIPO 2  : '+PushRight(11,EditInteger(Total2)));
                 WriteLine('L',' ');
                 WriteLine('L','REGISTRO DE IDENTIFICACAO TIPO 3  : '+PushRight(11,EditInteger(Total3)));
                 WriteLine('L',' ');
                 WriteLine('L','TOTAL DE SUBARQUIVOS              : '+PushRight(11,EditInteger(TotalS)));
                 WriteLine('L',' ');
                 If DskRpt = 'N' then WriteLine('W',Qp);
                 Close ( TxtFile );
               end
               else begin
                      Color(Blue,White);
                      GotoXY(1,23); Write(ConstStr(' ',80));
                      GotoXY(2,23); Write('N„o encontrei o ARQUIVO: '+XDisco);
                      TeclaReturn;
                    end;
            LimpaLn(23,Tfd);
          end;
       Close ( LST );
     end;
end;

end.