{$O+,F+}
Unit PlogDmFi;

Interface

Uses Crt,Dos,PlogGlbs,PlogBasp,PlogFunc,PlogCalc;

   Procedure Rescisao;
   Procedure FeriasIndividuais;

Implementation

Var
  NDias,NoMes,
  NCta              : Integer;
  VTrib             : Real;
  AvP,D13,ABN,TF    : Char;
  DataI,DataF       : Str8;
  DeF,PrF           : Array[1..40] of Str3;
  Contas            : Array[1..40] of Str3;


Procedure CalculaLiq;
begin
  TProv := 0;
  TDesc := 0;

  YYNo  := '';
  Repeat
    RC := 'N';
    SearchPosY ( RootY );

    If RC = 'S' then
       begin
         NCta := NCta + 1;

         If YAddress^.AcMensalV > 0 then
            begin
              CCNo := YYNo;
              SearchTree1 ( Root1 );

              If RC = 'S' then
                 begin
                   ReadWrite(#04,'R','N',CCNumber);
                   Case CCMember.Tipo of
                        'P' : For I := 1 to 40
                              do If PrF[I] = CCNo then
                                    TProv := TProv + TruncX(YAddress^.AcMensalV);
                        'D' : For I := 1 to 40
                              do If DeF[I] = CCNo then
                                    TDesc := TDesc + TruncX(YAddress^.AcMensalV);
                   end;
                 end
                 else RC := 'S';
            end;
       end;
  Until RC = 'N';

  Valor := TruncX(TProv - TDesc);

  Color(Tfn,Utx);
  GotoXY(12,17); Write(EditReal(TProv):15);
  GotoXY(12,18); Write(EditReal(TDesc):15);
  GotoXY(12,20); Write(EditReal(Valor):15);
end;


Procedure ListaConta(X : Char);
begin
  For I := 1 to 40 do Contas[I] := '';

  I    := 0;
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

              If CCMember.Tipo = X then
                 begin
                   I         := I + 1;
                   Contas[I] := CCNo;

                   Case X of
                        'D' : If DeF[I] = CCNo then TF := 'S'
                                               else TF := 'N';
                        'P' : If PrF[I] = CCNo then TF := 'S'
                                               else TF := 'N';
                   end;

                   GotoXY(9,I + 2);

                   Write(CCNo,' ',CCMember.Descricao,
                              ' ':31-Length(CCMember.Descricao),
                              YAddress^.AcMensalH:3,':',
                              YAddress^.AcMensalM:2,' ',
                              EditReal(YAddress^.AcMensalV):15,' ',TF);
                 end;
            end
            else RC := 'S';
       end;
  Until RC = 'N';
end;


Procedure EntryKey(X : Char);
Var
  ValorA    : Real;

begin
  Repeat
    K := 01;
    Repeat
      Case K of
           01..20 : begin
                      If Contas[K] = '' then
                         begin
                           J := Contas[K];
                           InputStr(J,3,9,(K + 2),0,'S','N',Tfn,Utx);
                           If (TC <> #27) and
                              (J  <> '' ) then
                              begin
                                CCNo := J;
                                SearchTree1 ( Root1 );
                                If RC = 'S' then
                                   begin
                                     ReadWrite(#04,'R','N',CCNumber);
                                     If CCMember.Tipo = X then
                                        begin
                                          Contas[K] := CCNo;

                                          GotoXY(13,K + 2);
                                          Write(CCNo,' ',CCMember.Descricao);

                                          YYNo := CCNo;
                                          SearchTreeY ( RootY );
                                          If RC = 'N' then LoadTreeY ( RootY );

                                          K := K - 1;
                                        end
                                        else begin
                                               Case X of
                                                    'D' : ErroMsg := 'Conta n„o ‚ de Desconto';
                                                    'P' : ErroMsg := 'Conta n„o ‚ de Provento';
                                               end;

                                               ErrorMessage;
                                               K := K - 1;
                                             end;
                                   end
                                   else begin
                                          ErroMsg := 'Conta n„o Existe';
                                          ErrorMessage;
                                          K := K - 1;
                                        end;
                              end;
                         end
                         else begin
                                YYNo := Contas[K];
                                SearchTreeY ( RootY );
                                If YAddress^.AcMensalH = 0 then J := ''
                                   else begin
                                          Str(YAddress^.AcMensalH:3,J);
                                          J := LeftAdjust(J);
                                        end;
                                InputStr(J,3,44,(K + 2),0,'S','N',Tfn,Utx);

                                If (TC <> #27) and
                                   (TC <> #25) then
                                   begin
                                     Val(J,YAddress^.AcMensalH,E);
                                     GotoXY(44,K + 2);
                                     Write(YAddress^.AcMensalH:3);

                                     SearchTreeY ( RootY );
                                     If YAddress^.AcMensalM = 0 then J := ''
                                        else begin
                                               Str(YAddress^.AcMensalM:2,J);
                                               J := LeftAdjust(J);
                                             end;
                                     InputStr(J,2,48,(K + 2),0,'S','N',Tfn,Utx);

                                     If TC <> #27 then
                                        begin
                                          Val(J,YAddress^.AcMensalM,E);
                                          GotoXY(48,K + 2);
                                          Write(YAddress^.AcMensalM:2);

                                          SearchTreeY ( RootY );

                                          ValorA := YAddress^.AcMensalV;
                                          ValorA := TruncX(ValorA);
                                          If YAddress^.AcMensalV = 0 then J := ''
                                             else begin
                                                    Str(YAddress^.AcMensalV:15:2,J);
                                                    J := LeftAdjust(J);
                                                  end;
                                          InputStr(J,15,51,(K + 2),0,'S','N',Tfn,Utx);

                                          If TC <> #27 then
                                             begin
                                               Val(J,YAddress^.AcMensalV,E);
                                               GotoXY(51,K + 2);
                                               Write(EditReal(YAddress^.AcMensalV):15);
                                               If YAddress^.AcMensalV <> ValorA
                                                  then YAddress^.Origem := 'U';

                                               Case X of
                                                    'D' : If DeF[K] = YYNo then J := 'S'
                                                                           else J := 'N';
                                                    'P' : If PrF[K] = YYNo then J := 'S'
                                                                           else J := 'N';
                                               end;

                                               InputStr(J,1,67,(K + 2),0,'S','N',Tfn,Utx);

                                               If TC <> #27 then
                                                  begin
                                                    If UpCase(J[1]) = 'S' then
                                                       begin
                                                         Case X of
                                                              'D' : DeF[K] := YYNo;
                                                              'P' : PrF[K] := YYNo;
                                                         end;
                                                       end
                                                       else Case X of
                                                                 'D' : DeF[K] := '';
                                                                 'P' : PrF[K] := '';
                                                            end;

                                                    GotoXY(67,K + 2);
                                                    Write(UpCase(J[1]));
                                                  end;
                                             end;
                                        end;
                                   end
                                   else If TC = #25 then
                                           begin
                                             GotoXY(44,K + 2);
                                             Write(YAddress^.AcMensalH:3);
                                             TC := #13;
                                           end;
                              end;
                    end;
      end;

      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 21) or (TC = #27);
    If TC <> #27 then Confirma;
  Until (TC = 'S') or (TC = #27);
end;


Procedure EntryContas(X : Char);
begin
  Move(Mem[$B800:0000],ScArray5[1],4000);
  DrawBox(8,2,68,22,Tfn,'S');
  Color(Bfn,Btx);
  GotoXY(8,02); Write('':52);
  GotoXY(8,02);
  Case X of
       'D' : Write('                    Descontos de F‚rias                    ',#25,' ');
       'P' : Write('                    Proventos de F‚rias                    ',#25,' ');
  end;
  Color(Tfn,Utx);
  ListaConta(X);
  EntryKey(X);
  Move(ScArray5[1],Mem[$B800:0000],4000);
  TC := #13;
end;


Procedure PedeCadastroD;
begin
  Repeat
    K := 01;
    Repeat
      Case K of
           01 : begin
                  Move(Mem[$B800:0000],ScArray6[1],4000);
                  DrawBox(35,11,57,19,Red,'S');
                  Color(Red,Cyan);
                  GotoXY(36,12); Write(' Demiss„o Espontƒnea ');
                  GotoXY(36,13); Write(' Demitido            ');
                  GotoXY(36,14); Write(' Justa Causa         ');
                  GotoXY(36,15); Write(' T‚rmino de Contrato ');
                  GotoXY(36,16); Write(' Aposentado          ');
                  GotoXY(36,17); Write(' Transferˆncia       ');
                  GotoXY(36,18); Write(' Morte               ');
                  Color(Red,White);
                  GotoXY(48,12); Write('p');
                  GotoXY(37,13); Write('D');
                  GotoXY(37,14); Write('J');
                  GotoXY(50,15); Write('n');
                  GotoXY(39,16); Write('o');
                  GotoXY(37,17); Write('T');
                  GotoXY(37,18); Write('M');

                  J := EEMember.Status;
                  InputStr(J,1,12,13,0,'S','N',Tfn,Utx);
                  Move(ScArray6[1],Mem[$B800:0000],4000);
                  EEMember.Status := UpCase(J[1]);
                  If TC <> #27 then
                     begin
                       GotoXY(12,13);
                       Case EEMember.Status of
                            'P' : Write('Demiss„o Espontƒnea');
                            'D' : Write('Demitido           ');
                            'J' : Write('Justa Causa        ');
                            'N' : Write('T‚rmino de Contrato');
                            'O' : Write('Aposentado         ');
                            'T' : Write('Transferˆncia      ');
                            'M' : Write('Morte              ');
                            else begin
                                   ErroMsg := 'Status Inv lido';
                                   ErrorMessage;
                                   K := K - 1;
                                 end;
                       end;
                     end;
                end;
           02 : begin
                  J := '';
                  InputStr(J,1,45,13,0,'S','N',Tfn,Utx);
                  If TC <> #27 then
                     begin
                       If J = '' then AvP := 'N'
                                 else AvP := UpCase(J[1]);
                       GotoXY(45,13);
                       Case Avp of
                            'N' : Write('N„o');
                            'S' : Write('Sim');
                       end;
                     end;
                end;
           03 : begin
                  If EEMember.DDResc = '' then J := ''
                                          else J := EEMember.DDResc + '/' +
                                                    EEMember.MMResc + '/' +
                                                    EEMember.AAResc;
                  InputStr(J,8,12,14,0,'S','N',Tfn,Utx);
                  If TC <> #27 then
                     begin
                       J := ChkData(J);
                       If J = '' then
                          begin
                            ErroMsg := 'Data de Rescis„o Inv lida';
                            ErrorMessage;
                            K := K - 1;
                          end
                          else begin
                                 EEMember.DDResc := Copy(J,1,2);
                                 EEMember.MMResc := Copy(J,4,2);
                                 EEMember.AAResc := Copy(J,7,2);
                                 GotoXY(12,14); Write(J);
                                 Val(EEMember.DDResc,I,E);

                                 GotoXY(45,14);
                                 If EEMember.PeriodoV = 0
                                    then Write('N„o tem')
                                    else Write(EEMember.PeriodoV:2);

                                 GotoXY(12,15);
                                 If I > 14 then EEMember.MesesF := EEmember.MesesF + 1;
                                 Write(EEMember.MesesF:2,'/12');

                                 GotoXY(45,15);
                                 If (I               > 14) and
                                    (EEMember.MesesT < 12)
                                    then EEMember.MesesT := EEMember.MesesT + 1;
                                 Write(EEMember.MesesT:2,'/12');
                               end;
                     end;
                end;
           04 : begin
                  If EEMember.PeriodoV = 0 then J := ''
                     else begin
                            Str(EEMember.PeriodoV:2,J);
                            J := LeftAdjust(J);
                          end;
                  Color(Tfn,Utx);
                  GotoXY(45,14); Write('       ');
                  InputStr(J,1,45,14,0,'S','N',Tfn,Utx);
                  If TC <> #27 then
                     begin
                       Val(J,EEMember.PeriodoV,E);
                       GotoXY(45,14);
                       If EEMember.PeriodoV = 0
                          then Write('N„o tem')
                          else Write(EEMember.PeriodoV:2);
                     end;
                end;
           05 : begin
                  If EEMember.MesesF = 0 then J := ''
                     else begin
                            Str(EEMember.MesesF:2,J);
                            J := LeftAdjust(J);
                          end;
                  InputStr(J,2,12,15,0,'S','N',Tfn,Utx);
                  If TC <> #27 then
                     begin
                       Val(J,EEMember.MesesF,E);
                       GotoXY(12,15); Write(EEMember.MesesF:2,'/12');
                     end;
                end;
           06 : begin
                  If EEMember.MesesT = 0 then J := ''
                     else begin
                            Str(EEMember.MesesT:2,J);
                            J := LeftAdjust(J);
                          end;
                  InputStr(J,2,45,15,0,'S','N',Tfn,Utx);
                  If TC <> #27 then
                     begin
                       Val(J,EEMember.MesesT,E);
                       GotoXY(45,15); Write(EEMember.MesesT:2,'/12');
                     end;
                end;
      end;

      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 7) or (TC = #27);
    If TC <> #27 then Confirma;
  Until (TC = 'S') or (TC = #27);

  If TC = 'S' then
     Case EEMember.Status of
          'D' : EEMember.Causa := '2';
          'J' : EEMember.Causa := '1';
          'P' : EEMember.Causa := '4';
          'N' : EEMember.Causa := '2';
          'O' : EEMember.Causa := '7';
          'T' : EEMember.Causa := '6';
          'M' : EEMember.Causa := '8';
     end;
end;


Procedure ListaProv;
begin
  If (YAddress^.AcMensalH > 0) or
     (YAddress^.AcMensalM > 0) then
     begin
       Str(YAddress^.AcMensalM,Mn);
       If YAddress^.AcMensalM < 10 then Mn := '0' + Mn;

       WriteLine('L',YYNo+' '+Acentua(CCMember.Descricao)+
                     ConstStr(' ',31-Length(CCMember.Descricao))+
                     PushRight(3,EditInteger(YAddress^.AcMensalH))+':'+
                     PushRight(2,Mn)+' '+
                     PushRight(15,EditReal(YAddress^.AcMensalV)));
     end
     else If TruncX(YAddress^.AcMensalV) > 0
             then WriteLine('L',YYNo+' '+Acentua(CCMember.Descricao)+
                                ConstStr(' ',38-Length(CCMember.Descricao))+
                                PushRight(15,EditReal(YAddress^.AcMensalV)));
  R1 := R1 + YAddress^.AcMensalV;
end;


Procedure ListaDesc;
begin
  If (YAddress^.AcMensalH > 0) or
     (YAddress^.AcMensalM > 0) then
     begin
       Str(YAddress^.AcMensalM,Mn);
       If YAddress^.AcMensalM < 10 then Mn := '0' + Mn;

       WriteLine('L',YYNo+' '+Acentua(CCMember.Descricao)+
                     ConstStr(' ',54-Length(CCMember.Descricao))+
                     PushRight(3,EditInteger(YAddress^.AcMensalH))+':'+
                     PushRight(2,Mn)+' '+
                     PushRight(15,EditReal(YAddress^.AcMensalV)));
     end
     else If TruncX(YAddress^.AcMensalV) > 0
             then WriteLine('L',YYNo+' '+Acentua(CCMember.Descricao)+
                                ConstStr(' ',61-Length(CCMember.Descricao))+
                                PushRight(15,EditReal(YAddress^.AcMensalV)));
  R2 := R2 + YAddress^.AcMensalV;
end;


Procedure Recibo(X : Char;
                 Y : Integer);
begin
  For R := 1 to Y do
  begin
    Case X of
         'F' : If R = 1 then WriteLine('L',ConstStr(' ',24)+#27+Dx+Acentua('Recibo de F‚rias')+#27+Df)
                        else WriteLine('L',Qp+ConstStr(' ',24)+#27+Dx+Acentua('Recibo de F‚rias')+#27+Df);
         'R' : If R = 1 then WriteLine('L',ConstStr(' ',9)+#27+Dx+Acentua('Rescis„o de Contrato de Trabalho')+#27+Df)
                        else WriteLine('L',Qp+ConstStr(' ',9)+#27+Dx+Acentua('Rescis„o de Contrato de Trabalho')+#27+Df);
    end;

    WriteLine('L',ConstStr('-',80));
    WriteLine('L',' ');
    WriteLine('L',Acentua('Nome................: ')+
                  #27+Nx+Acentua(EEMember.Nome)+#27+Nf);
    WriteLine('L',Acentua('Matr¡cula...........: ')+EEMember.Matricula);
    WriteLine('L',' ');
    WriteLine('L',Acentua('Carteira de Trabalho: ')+
                  EEMember.CTrabN+' '+EEMember.CTrabS+' '+EEMember.CTrabE);
    WriteLIne('L',' ');
    WriteLine('L',Acentua('Endere‡o............: ')+
                  Acentua(EEMember.Endereco));
    WriteLine('L',Acentua('Cidade..............: ')+
                  Acentua(EEMember.Cidade)+' '+EEMember.Estado);
    WriteLine('L',' ');
    Case X of
         'F' : WriteLine('L',Acentua('Per¡odo aquisitivo..: ')+
                             Acentua(Tit)+ConstStr(' ',21-Length(Tit))+
                             Acentua('Tipo/Sal rio Base...: ')+
                             EEMember.Tipo+' '+EditReal(EEMember.Salario));
         'R' : WriteLine('L',Acentua('Data de Admiss„o....: ')+
                             EEMember.AAResc+'/'+EEMember.MMAdm+'/'+
                             EEMember.AAAdm+ConstStr(' ',13)+
                             Acentua('Tipo/Sal rio Base...: ')+
                             EEMember.Tipo+' '+EditReal(EEMember.Salario));
    end;
    Case X of
         'F' : WriteLine('L',Acentua('Per¡odo de F‚rias...: ')+
                             DataI+' a '+DataF);
         'R' : WriteLine('L',Acentua('Data de Rescis„o....: ')+
                             EEMember.DDResc+'/'+
                             EEMember.MMResc+'/'+
                             EEMember.AAResc+
                             ConstStr(' ',13)+
                             Acentua('Data de Op‡„o.......: ')+
                             EEMember.DataOpcao);
    end;

    WriteLine('L',' ');
    WriteLine('L',ConstStr('-',80));
    WriteLine('L',ConstStr(' ',36)+
                  '===== Proventos =====  ===== Descontos =====');
    WriteLine('L',Acentua('C¢d Descri‡„o')+
                  ConstStr(' ',23)+'Horas'+ConstStr(' ',9)+
                  'Valores'+ConstStr(' ',2)+'Horas'+
                  ConstStr(' ',9)+'Valores');
    WriteLine('L',ConstStr('-',80));
    WriteLine('L',' ');

    R1 := 0;
    R2 := 0;

    Case X of
         'F' : begin
                 For I := 1 to 20
                 do If PrF[I] <> '' then
                       begin
                         YYNo := PrF[I];
                         SearchTreeY ( RootY );
                         If RC = 'S' then
                            begin
                              CCNo := YYNo;
                              SearchTree1 ( Root1 );
                              If RC = 'S' then
                                 begin
                                   ReadWrite(#04,'R','N',CCNumber);
                                   ListaProv;
                                 end;
                            end;
                       end;

                 For I := 1 to 20
                 do If DeF[I] <> '' then
                       begin
                         YYNo := DeF[I];
                         SearchTreeY ( RootY );
                         If RC = 'S' then
                            begin
                              CCNo := YYNo;
                              SearchTree1 ( Root1 );
                              If RC = 'S' then
                                 begin
                                   ReadWrite(#04,'R','N',CCNumber);
                                   ListaDesc;
                                 end;
                            end;
                       end;
               end;
         'R' : begin
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
                             If (CCMember.Operacao   = 'P') and
                                (CCMember.Tipo       = 'P') and
                                (YAddress^.AcMensalV > 0  ) then ListaProv;
                           end
                           else RC := 'S';
                      end;
                 Until RC = 'N';

                 YYNo := '';
                 Repeat
                   RC := 'N';
                   SearchPosY ( RootY );
                   If RC = 'S' then
                      begin
                        CCNo := YYNo;
                        SearchTree1 ( Root1 );
                        If (RC    = 'S'  ) and
                           (CCNo <> '099') then
                           begin
                             ReadWrite(#04,'R','N',CCNumber);
                             If (CCMember.Operacao   = 'P') and
                                (CCMember.Tipo       = 'D') and
                                (YAddress^.AcMensalV > 0  ) then ListaDesc;
                           end
                           else RC := 'S';
                      end;
                 Until RC = 'N';
               end;
    end;

    WriteLine('L',ConstStr('-',80));
    WriteLine('L','Totais'+ConstStr(' ',36)+
                  PushRight(15,EditReal(R1))+ConstStr(' ',8)+
                  PushRight(15,EditReal(R2)));
    WriteLine('L',ConstStr('-',80));

    If X = 'F' then YYNo := '057'
               else YYNo := '099';
    SearchTreeY ( RootY );
    If RC = 'S' then Valor := YAddress^.AcMensalV
                else Valor := 0;

    Case X of
         'F' : WriteLine('L',ConstStr(' ',52)+'Adiantamento '+
                             PushRight(15,EditReal(Valor)));
         'R' : WriteLine('L',ConstStr(' ',52)+'     Liquido '+
                             PushRight(15,EditReal(Valor)));
    end;

    WriteLine('L',' ');

    If ContLin < 55 then For I := 1 to 5 do WriteLine('L',' ');

    WriteLine('L',' ');
    WriteLine('L',ConstStr(' ',10)+Acentua('Recebi a importƒncia acima.'));
    WriteLine('L',' ');
    WriteLine('L',' ');
    WriteLine('L',' ');
    WriteLine('L',ConstStr(' ',23)+
                  '----/----/----  -------------------------------');
    WriteLine('L',ConstStr(' ',42)+Cx+Acentua(EEMember.Nome)+Cf);
  end;
  If DskRpt = 'N' then WriteLine('W',Qp);
end;


Procedure Rescisao;
begin
  EENo := '';
  Repeat
    TProv    := 0;
    TDesc    := 0;
    Valor    := 0;
    RecebeCodigo('C');
    If EENumber <> Limite then
       With EEMember do
       begin
         ReadWrite(#08,'R','N',EENumber);
         Color(Tfn,Ttx);
         GotoXY(04,09); Write('Matr¡c:');
         GotoXY(04,10); Write('Nome..:');
         GotoXY(04,11); Write('Cargo.:');
         GotoXY(04,13); Write('Status:');
         GotoXY(37,13); Write('A.Pr‚v:');
         GotoXY(04,14); Write('Data..:');
         GotoXY(37,14); Write('F.Venc:');
         GotoXY(04,15); Write('F.Prop:');
         GotoXY(37,15); Write('13§.Pr:');
         GotoXY(04,17); Write('Prov..:');
         GotoXY(04,18); Write('Desc..:');
         GotoXY(04,19); Write('        ---------------');
         GotoXY(04,20); Write('L¡quid:');
         Color(Tfn,Utx);
         GotoXY(12,09); Write(EEMember.Matricula,' ':9-Length(EEMember.Matricula));
         GotoXY(12,10); Write(EEMember.Nome);
         GotoXY(12,11); Write(EEMember.Cargo);

         PedeCadastroD;

         If TC = 'S' then
            begin
              SalBase := Sal;
              YYNo := '015';
              SearchTreeY ( RootY );
              If RC = 'S' then YAddress^.AcMensalV := 0;

              YYNo := '018';
              SearchTreeY ( RootY );
              If RC = 'N' then LoadTreeY ( RootY );

              YAddress^.Origem    := 'U';
              YAddress^.AcMensalV := ((SalBase / 12) * EEMember.MesesF) +
                                     (SalBase * EEMember.PeriodoV);

              YYNo := '029';
              SearchTreeY ( RootY );
              If RC = 'N' then LoadTreeY ( RootY );

              YAddress^.Origem    := 'U';
              YAddress^.AcMensalV := ((SalBase / 3) * EEMember.PeriodoV) +
                                     (((SalBase / 3) / 12) * EEMember.MesesF);

              If EEMember.MesesT <> 0 then
                 begin
                   YYNo := '004';
                   SearchTreeY ( RootY );
                   If RC = 'S' then R1 := YAddress^.AcAnualV
                               else R1 := 0;
                   YYNo := '040';
                   SearchTreeY ( RootY );
                   If RC = 'N' then LoadTreeY ( RootY );

                   YAddress^.Origem    := 'U';
                   YAddress^.AcMensalV := ((SalBase / 12) * EEMember.MesesT) -
                                          R1;
                 end;

              If Avp = 'S' then
                 begin
                   YYNo := '041';
                   SearchTreeY ( RootY );
                   If RC = 'N' then LoadTreeY ( RootY );
                   YAddress^.Origem    := 'U';
                   YAddress^.AcMensalV := SalBase;
                 end;

              YYNo := '099';
              SearchTreeY ( RootY );
              If RC = 'S' then
                 begin
                   YAddress^.Origem    := 'S';
                   YAddress^.AcMensalV := 0;
                 end;

              Eta := 'P';

              RecebePagamento('U');

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
                   GotoXY(59,23); Write('Pagamento   ');
                   Pagamentos  ('U');
                   LimpaLn(23,Tfd);
                   CMstMember.Etapa := 'P';
                   RC               := 'S';
                 end;

              Repeat
                Move(Mem[$B800:0000],ScArray5[1],4000);
                DrawBox(37,16,56,19,Red,'S');
                Color(Red,Cyan);
                GotoXY(42,17); Write('Movimento');
                GotoXY(42,18); Write('Esc ',#26,' Termina');
                Color(Red,White);
                GotoXY(42,17); Write('M');
                GotoXY(42,18); Write('Esc');

                Repeat
                  Color(Tfn,Utx);
                  GotoXY(12,17); Write(EditReal(TProv):15);
                  GotoXY(12,18); Write(EditReal(TDesc):15);
                  GotoXY(12,20); Write(EditReal(TProv - TDesc):15);
                  TC := UpCase(ReadKey);
                  If TC = 'M' then
                     begin
                       ScrollMovto('M');
                       TProv := 0;
                       TDesc := 0;
                       Pagamentos('U');
                     end;
                Until TC = #27;
                Move(ScArray5[1],Mem[$B800:0000],4000);
                Color(Tfn,Utx);
                GotoXY(12,17); Write(EditReal(TProv):15);
                GotoXY(12,18); Write(EditReal(TDesc):15);
                GotoXY(12,20); Write(EditReal(TProv - TDesc):15);
                Confirma;
              Until (TC = 'S') or (TC = #27);

              If TC = 'S' then
                 begin
                   ReadWrite(#08,'W','N',EENumber);

                   YYNo := '099';
                   SearchTreeY ( RootY );
                   If RC = 'N' then LoadTreeY ( RootY );

                   YAddress^.Origem    := 'U';
                   YAddress^.AcMensalV := TruncX(TProv - TDesc);

                   Color(Bfn,Btx);
                   GotoXY(01,23); Write(ConstStr(' ',80));
                   GotoXY(02,23); Write('Refazendo os c lculos,        .');
                   GotoXY(57,23); Write('(              )');
                   Color(Bfn,Yellow);
                   GotoXY(25,23); Write('Aguarde');
                   Color(Bfn,White);
                   GotoXY(59,23); Write('Pagamento   ');

                   Pagamentos  ('U');

                   Color(Blue,Cyan);
                   GotoXY(1,23);  Write(ConstStr(' ',80));
                   Color(Red,Cyan);
                   GotoXY(1,24);  Write(ConstStr(' ',80));
                   GotoXY(2,24);  Write('Quer emitir o recibo de Rescis„o?  im ou  „o');
                   Color(Red,White);
                   GotoXY(36,24); Write('S');
                   GotoXY(43,24); Write('N');

                   Repeat
                     TC := UpCase(ReadKey);
                   Until (TC = 'S') or (TC = 'N') or (TC = #27);

                   If TC = 'S' then
                      begin
                        Color(Red,Cyan);
                        GotoXY(1,24);  Write(ConstStr(' ',80));
                        GotoXY(2,24);  Write('Informe o n£mero de c¢pias que ser„o impressas (  a  ):      ');
                        Color(Red,White);
                        GotoXY(50,24); Write('1');
                        GotoXY(54,24); Write('9');

                        Repeat
                          J := '';
                          InputStr(J,1,58,24,0,'S','N',Red,Yellow);
                          If J = '' then J := '1';
                        Until (J[1] in ['1','2','3','4','5','6','7','8','9']) or
                              (TC = #27);

                        If TC <> #27 then
                           begin
                             Val(J,I,E);
                             QPorta('A');
                             If TC <> #27 then
                                begin
                                  Recibo('R',I);
                                  Close ( LST );
                                end;
                           end;
                      end;

                   UnLoadMVDsk;
                 end
                 else LiberaMVDsk;
            end;
         TC := #13;
         Move(ScArray4[1],Mem[$B800:0000],4000);
       end;
  Until TC = #27;
end;


Procedure DataFerias;
begin
  Color(Tfn,Ttx);
  GotoXY(04,09); Write('Matr¡c:');
  GotoXY(04,10); Write('Nome..:');
  GotoXY(04,11); Write('Cargo.:');
  GotoXY(40,11); Write('Status:');
  GotoXY(04,12); Write('DD/MM.:');
  GotoXY(40,12); Write('N§Dias:');
  GotoXY(04,13); Write('Per.Aq:');
  GotoXY(40,13); Write('Per.Ve:');
  GotoXY(04,14); Write('Pr¢x.F:');
  GotoXY(40,14); Write('Tipo..:');
  GotoXY(04,15); Write('Sal r.:');
  GotoXY(40,15); Write('Dt.Adm:');
  GotoXY(04,16); Write('Ad.13§:');
  GotoXY(40,16); Write('Abono.:');

  GotoXY(04,17); Write('Prov..:');
  GotoXY(04,18); Write('Desc..:');
  GotoXY(04,19); Write('        ---------------');
  GotoXY(04,20); Write('L¡quid:');

  Color(Tfn,Utx);
  GotoXY(12,09); Write(EEMember.Matricula,' ':9-Length(EEMember.Matricula));
  GotoXY(12,10); Write(EEMember.Nome);
  GotoXY(12,11); Write(EEMember.Cargo);

  GotoXY(48,11);
  Case EEMember.Status of
       'A' : Write('Ativo      ');
       'P' : Write('Dem.Espont.');
       'D' : Write('Demitido   ');
       'J' : Write('Justa Causa');
       'N' : Write('T‚rm.Contr.');
       'R' : Write('Rescindido ');
       'F' : Write('F‚rias     ');
       'L' : Write('Licen‡a    ');
       'C' : Write('Acidentado ');
       'M' : Write('Morte      ');
       'T' : Write('Transferido');
       'O' : Write('Aposentado ');
       'X' : Write('Excluir Reg');
  end;

  GotoXY(12,12);
  If EEMember.DiaI <> 0 then Write(EEMember.DiaI:2,'/',EEMember.MesI:2);

  GotoXY(18,12);
  If EEMember.DiaF <> 0 then Write('a ',EEMember.DiaF:2,'/',EEMember.MesF:2);

  GotoXY(48,12);
  If NDias <> 0 then Write(Ndias:2,' dias');

  GotoXY(48,13); Write(EEMember.PeriodoV:2);
  GotoXY(12,14); Write(EEMember.DDFer,'/',EEMember.MMFer,'/',EEMember.AAFer);
  GotoXY(48,15); Write(EEMember.DDAdm,'/',EEMember.MMAdm,'/',EEMember.AAAdm);

  GotoXY(48,14);
  Case EEMember.Tipo of
       'M' : Write('Mensalista ');
       'H' : Write('Horista    ');
       'S' : Write('Semanalista');
  end;
  GotoXY(12,15); Write(EditReal(SalBase):13);
  ValorHora1 := SalBase / EEMember.HNormais;
  D13 := 'S';
  ABN := 'N';
end;


Procedure PedeCadastroF;
begin
  Tit := '';
  Repeat
    K := 01;
    Repeat
      Case K of
           01 : begin
                  If EEMember.DiaI = 0 then J := ''
                                       else begin
                                              Str(EEMember.DiaI:2,J);
                                              J := LeftAdjust(J);
                                            end;
                  InputStr(J,2,12,12,0,'S','N',Tfn,Utx);
                  If Length(J) = 1 then J := '0' + J;
                  Val(J,EEMember.DiaI,E);
                  GotoXY(12,12); Write(J:2,'/');
                  DataI := J + '/';
                end;
           02 : begin
                  If EEMember.MesI = 0 then J := ''
                                       else begin
                                              Str(EEMember.MesI:2,J);
                                              J := LeftAdjust(J);
                                            end;
                  InputStr(J,2,15,12,0,'S','N',Tfn,Utx);
                  If Length(J) = 1 then J := '0' + J;
                  Val(J,EEMember.MesI,E);
                  If (EEMember.MesI < 1 ) or
                     (EEMember.MesI > 12) then K := K - 1
                     else begin
                            GotoXY(15,12); Write(J:2);
                            DataI := Copy(DataI,1,3) + J + '/';
                            If (MM = 12) and (EEMember.MesI < MM)
                               then Str((AA + 1):2,J)
                               else J := AAFx;
                            DataI := DataI + J;
                          end;
                end;
           03 : begin
                  If NDias = 0 then J := ''
                               else begin
                                      Str(NDias:2,J);
                                      J := LeftAdjust(J);
                                    end;
                  InputStr(J,2,48,12,0,'S','N',Tfn,Utx);
                  Val(J,NDias,E);
                  If (NDias = 0 ) or
                     (NDias > 30) then K := K - 1
                     else begin
                            EEMember.DiaF := EEMember.DiaI + NDias - 1;

                            If EEMember.DiaF > TabDia[EEMember.MesI] then
                               begin
                                 EEMember.DiaF := EEMember.DiaF - TabDia[EEMember.MesI];
                                 EEMember.MesF := EEMember.MesI + 1;
                                 If EEMember.MesF = 13 then EEMember.MesF := 1;
                               end
                               else EEMember.MesF := EEMember.MesI;

                            Str(EEMember.DiaF,J);
                            If Length(J) = 1 then J := '0' + J;
                            GotoXY(18,12); Write('a ',J:2,'/');
                            DataF := J + '/';
                            Str(EEMember.MesF,J);
                            If Length(J) = 1 then J := '0' + J;
                            GotoXY(23,12); Write(J:2);
                            GotoXY(48,12); Write(NDias:2,' dias');
                            DataF := DataF + J + '/';
                            If EEMember.MesF < EEMember.MesI
                               then Str((AA + 1):2,J)
                               else J := Copy(DataI,7,2);
                            DataF := DataF + J;
                          end;
                end;
           04 : begin
                  J := Tit;
                  InputStr(J,20,12,13,0,'S','S',Tfn,Utx);
                  Tit := J;
                end;
           05 : begin
                  If EEMember.PeriodoV = 0 then J := ''
                                           else begin
                                                  Str(EEMember.PeriodoV:2,J);
                                                  J := LeftAdjust(J);
                                                end;
                  InputStr(J,2,48,13,0,'S','N',Tfn,Utx);
                  Val(J,EEMember.PeriodoV,E);
                  GotoXY(48,13); Write(EEMember.PeriodoV:2);
                end;
           06 : begin
                  If EEMember.DDFer = '' then J := ''
                                         else J := EEMember.DDFer + '/' +
                                                   EEMember.MMFer + '/' +
                                                   EEMember.AAFer;
                  InputStr(J,8,12,14,0,'S','N',Tfn,Utx);
                  EEMember.DDFer := J;
                  J              := ChkData(J);
                  If J = '' then
                     begin
                       ErroMsg := 'Data Invalida';
                       ErrorMessage;
                       K := K - 1;
                     end
                     else begin
                            EEMember.DDFer := Copy(J,1,2);
                            EEMember.MMFer := Copy(J,4,2);
                            EEMember.AAFer := Copy(J,7,2);
                            GotoXY(12,14); Write(J);
                          end;
                end;
           07 : begin
                  J := D13;
                  InputStr(J,1,12,16,0,'S','N',Tfn,Utx);
                  If J = ' ' then J := 'N';
                  D13 := UpCase(J[1]);
                  GotoXY(12,16);
                  Case D13 of
                       'N' : Write('N„o');
                       'S' : Write('Sim');
                  end;
                end;
           08 : begin
                  J := ABN;
                  InputStr(J,1,48,16,0,'S','N',Tfn,Utx);
                  If J = ' ' then J := 'N';
                  ABN := UpCase(J[1]);
                  GotoXY(48,16);
                  Case ABN of
                       'N' : Write('N„o');
                       'S' : Write('Sim');
                  end;
                end;
      end;

      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 09) or (TC = #27);
    If TC <> #27 then Confirma;
  Until (TC = 'S') or (TC = #27);
end;


Procedure CalculodeFerias;
begin
  Move(ScArray4[1],Mem[$B800:0000],4000);
  For I := 1 to 20 do begin
                        DeF[I] := '';
                        PrF[I] := '';
                      end;

  If (EEMember.DiaI <> 0) and
     (EEMember.DiaF <> 0) then
     begin
       If EEMember.MesI = EEMember.MesF
          then NDias := EEMember.DiaF - EEMember.DiaI + 1
          else NDias := (TabDia[EEMember.MesI] - EEMember.DiaI) + EEMember.DiaF + 1;
     end
     else NDias := 0;

  SalBase := Sal;
  DataFerias;
  PedeCadastroF;

  If TC = 'S' then
     begin
       YYNo := '057';
       SearchTreeY ( RootY );
       If RC = 'S' then
          begin
            YAddress^.AcMensalV := 0;
            YAddress^.Origem    := 'S';
          end;

       YYNo := '058';
       SearchTreeY ( RootY );
       If RC = 'S' then
          begin
            YAddress^.AcMensalV := 0;
            YAddress^.Origem    := 'S';
          end;

       YYNo := '061';
       SearchTreeY ( RootY );
       If RC = 'S' then
          begin
            YAddress^.AcMensalV := 0;
            YAddress^.Origem    := 'S';
          end;

       YYNo := '019';
       SearchTreeY ( RootY );
       If RC = 'N' then LoadTreeY ( RootY );

       YAddress^.Origem    := 'U';
       YAddress^.AcMensalV := (SalBase / 30) * NDias;
       YAddress^.AcAnualV  := 0;

       YYNo := '021';
       SearchTreeY ( RootY );
       If RC = 'N' then LoadTreeY ( RootY );

       YAddress^.Origem    := 'U';
       YAddress^.AcMensalV := SalBase / 3;
       YAddress^.AcAnualV  := 0;

       If ABN = 'S' then
          begin
            YYNo := '020';
            SearchTreeY ( RootY );
            If RC = 'N' then LoadTreeY ( RootY );

            YAddress^.Origem    := 'U';
            YAddress^.AcMensalV := (SalBase / 30) * 10;
            YAddress^.AcAnualV  := 0;
          end
          else begin
                 YYNo := '020';
                 SearchTreeY ( RootY );
                 If RC = 'S' then
                    begin
                      YAddress^.Origem    := 'S';
                      YAddress^.AcMensalV := 0;
                      YAddress^.AcAnualV  := 0;
                    end;
               end;

       If D13 = 'S' then
          begin
            YYNo := '004';
            SearchTreeY ( RootY );
            If RC = 'N' then
               begin
                 YYNo := '023';
                 SearchTreeY ( RootY );
                 If RC = 'N' then LoadTreeY ( RootY );

                 YAddress^.Origem    := 'U';
                 YAddress^.AcMensalV := SalBase / 2;
                 YAddress^.AcAnualV  := 0;

                 YYNo := '004';
                 SearchTreeY ( RootY );
                 If RC = 'N' then LoadTreeY ( RootY );

                 YAddress^.Origem   := 'U';
                 YAddress^.AcAnualV := SalBase / 2;
               end
               else If YAddress^.AcAnualV = 0 then
                       begin
                         YYNo := '023';
                         SearchTreeY ( RootY );
                         If RC = 'N' then LoadTreeY ( RootY );

                         YAddress^.Origem    := 'U';
                         YAddress^.AcMensalV := SalBase / 2;
                         YAddress^.AcAnualV  := 0;

                         YYNo := '004';
                         SearchTreeY ( RootY );
                         If RC = 'N' then LoadTreeY ( RootY );

                         YAddress^.Origem   := 'U';
                         YAddress^.AcAnualV := SalBase / 2;
                       end;
          end
          else begin
                 YYNo := '023';
                 SearchTreeY ( RootY );
                 If RC = 'S' then
                    begin
                      YAddress^.Origem    := 'S';
                      YAddress^.AcMensalV := 0;
                      YAddress^.AcAnualV  := 0;
                    end;
               end;

       Eta := 'P';

       RecebePagamento('U');

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
            GotoXY(59,23); Write('Pagamento   ');

            EEMember.Status := 'F';

            Pagamentos  ('U');
            LimpaLn(23,Tfd);
            RC := 'S';
          end;

       Repeat
         Move(Mem[$B800:0000],ScArray5[1],4000);

         DrawBox(37,17,56,19,Red,'S');
         Color(Red,Cyan);
         GotoXY(37,17); Write('     Proventos      ');
         GotoXY(37,18); Write('     Descontos      ');
         GotoXY(37,19); Write('     Esc ',#26,' Termina  ');
         Color(Red,White);
         GotoXY(42,17); Write('P');
         GotoXY(42,18); Write('D');
         GotoXY(42,19); Write('Esc');

         Repeat
           TC := UpCase(ReadKey);
           If TC in ['D','P'] then
              begin
                EntryContas(TC);
                CalculaLiq;
              end;
         Until TC = #27;

         Confirma;

       Until (TC = 'S') or (TC = #27);

       If TC = 'S' then
          begin
            EEMember.Status := 'F';
            ReadWrite(#08,'W','N',EENumber);

            YYNo := '057';
            SearchTreeY ( RootY );
            If RC = 'N' then LoadTreeY ( RootY );

            YAddress^.Origem    := 'U';
            YAddress^.AcMensalV := Valor;

            If ((NDias + EEMember.DiaI) - 1) < TabDia[EEMember.MesI]
               then NoMes := NDias
               else NoMes := (TabDia[EEMember.MesI] - EEMember.DiaI) + 1;

            VTrib := (TProv / NDias) * NoMes;

            YYNo := '088';
            SearchTreeY ( RootY );
            If RC = 'N' then LoadTreeY ( RootY );
            YAddress^.Origem    := 'S';
            YAddress^.AcMensalV := VTrib;

            VTrib := TProv - VTrib;

            YYNo := '089';
            SearchTreeY ( RootY );
            If RC = 'N' then LoadTreeY ( RootY );
            YAddress^.Origem    := 'S';
            YAddress^.AcMensalV := VTrib;

            Pagamentos  ('U');

            If D13 = 'S' then
               begin
                 YYNo := '004';
                 SearchTreeY ( RootY );
                 If RC = 'S' then
                    begin
                      ReadWrite(#09,'R','N',EENumber);
                      HPMember.Ad13Rais    := YAddress^.AcAnualV;
                      HPMember.Ad13MesRais := MM;
                      ReadWrite(#09,'W','N',EENumber);
                    end;
               end;

            HHNo := EENo + '#' + Copy(DataI,7,2) +
                                 Copy(DataI,4,2) +
                                 Copy(DataI,1,2) + '#V';

            SearchTree10 ( Root10 );
            If RC = 'N' then
               With HHMember do
               begin
                 D3        := 'S';
                 HHNumber  := FileSize(HHFile);
                 Empregado := EENo;
                 OrigData  := DataI;
                 Data      := Copy(DataI,7,2) +
                              Copy(DataI,4,2) + Copy(DataI,1,2);
                 Tipo      := 'V';
                 Salario   := 0;
                 Motivo    := 'F‚rias at‚ ' + DataF +
                              ' relativo: ' + Tit;

                 ReadWrite(#10,'W','N',HHNumber);
                 LoadTree10 ( Root10 );
                 RC := 'S';
               end;

            Color(Blue,Black);
            GotoXY(1,23);  Write(ConstStr(' ',80));
            Color(Red,Cyan);
            GotoXY(1,24);  Write(ConstStr(' ',80));
            GotoXY(2,24);  Write('Quer emitir o recibo de f‚rias ?   im ou  „o');
            Color(Red,White);
            GotoXY(36,24); Write('S');
            GotoXY(43,24); Write('N');

            Repeat
              TC := UpCase(ReadKey);
            Until (TC = 'S') or (TC = 'N') or (TC = #27);

            If TC = 'S' then
               begin
                 Color(Red,Cyan);
                 GotoXY(1,24);  Write(ConstStr(' ',80));
                 GotoXY(2,24);  Write('Informe o n£mero de c¢pias que ser„o impressas (  a  ):      ');
                 Color(Red,White);
                 GotoXY(50,24); Write('1');
                 GotoXY(54,24); Write('9');

                 Repeat
                   J := '';
                   InputStr(J,1,58,24,0,'S','N',Red,Yellow);
                   If J = '' then J := '1';
                 Until (J[1] in ['1','2','3','4','5','6','7','8','9']) or
                       (TC = #27);

                 If TC <> #27 then
                    begin
                      Val(J,I,E);
                      QPorta('A');
                      If TC <> #27 then
                         begin
                           Recibo('F',I);
                           Close ( LST );
                         end;
                    end;
               end;
            UnLoadMVDsk;
          end;
     end;
  LiberaMVDsk;
end;

Procedure AvisodeFerias;
begin
end;

Procedure FeriasIndividuais;
begin
  EENo := '';
  Repeat
    RecebeCodigo('C');
    If EENumber <> Limite then
       begin
         ReadWrite(#08,'R','N',EENumber);
         Color(Tfn,Utx);
         GotoXY(12,09); Write(EEMember.Matricula);
         GotoXY(12,10); Write(EEMember.Nome);
         DrawBox(22,13,44,16,Red,'S');
         Color(Red,Cyan);
         GotoXY(23,14); Write('C lculo das F‚rias   ');
         GotoXY(23,15); Write('Aviso de F‚rias      ');
         Color(Red,Yellow);
         GotoXY(23,14); Write('C');
         GotoXY(23,15); Write('A');
         Color(Tfn,Utx);
         Repeat
           TC := UpCase(ReadKey);
         Until (TC in ['A','C']) or (TC = #27);
         Case TC of
              'A' : AvisodeFerias;
              'C' : CalculodeFerias;
         end;
         TC := #13;
         Move(ScArray4[1],Mem[$B800:0000],4000);
       end;
  Until TC = #27;
end;

end.

