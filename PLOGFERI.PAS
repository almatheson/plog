{$O+,F+}
Unit PlogFeri;

Interface

Uses Crt,Dos,PlogGlbs,PlogBasp,PlogTree,PlogFunc,PlogCalc;

   Procedure FeriasIndividuais;

Implementation

Var
  NDias,NoMes,
  NCta,He,Me        : Integer;
  VTrib,Abono       : Real;
  D13,ABN,P2,Pr,De  : Char;
  DataI,DataF       : Str10;
  SPr,SDe           : Array[1..20] of Char;
  DeF,PrF           : Array[1..20] of Str3;
  Contas            : Array[1..40] of Str3;
  IncINSS           : Array[1..6]  of Str3;


Procedure CalculaLiq(X : Char);
begin
  TProv := 0;
  TDesc := 0;
  For I := 1 to 20 do
  If (PrF[I] <> '') and (SPr[I] = 'S') then
     begin
       YYNo := PrF[I];
       SearchTreeY ( RootY );
       If (RC = 'S') and (YAddress^.AcMensalV > 0)
          then TProv := TProv + TruncX(YAddress^.AcMensalV);
     end;
  For I := 1 to 20 do
  If (DeF[I] <> '') and (SDe[I] = 'S') then
     begin
       YYNo := DeF[I];
       SearchTreeY ( RootY );
       If (RC = 'S') and (YAddress^.AcMensalV > 0)
          then TDesc := TDesc + TruncX(YAddress^.AcMensalV);
     end;
  Valor := TruncX(TProv - TDesc);
  If X = 'S' then
     begin
       Color(Tfn,Utx);
       GotoXY(12,17); Write(EditReal(TProv):15);
       GotoXY(12,18); Write(EditReal(TDesc):15);
       GotoXY(12,20); Write(EditReal(Valor):15);
     end;
end;


Procedure Carrega(X : Char);
Var
  CarrC    : Char;
begin
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
 {             If (CCNo = '019') or (CCNo = '020') or
                 (CCNo = '021') or (CCNo = '022') or
                 (CCNo = '023') or (CCNo = '130') then CarrC := 'S'
                                                  else CarrC := 'N';}
              ReadWrite(#04,'R','N',CCNumber);
              If (CCMember.Tipo     = X  ) and
                 (CCMember.Operacao = 'P') and
                 (((X = 'P') and ((CCMember.Bases[1] = 'F') or (CCMember.Bases[2] = 'F'))) or (X = 'D')) then
                 begin
                   I := I + 1;
                   Case X of
                        'D' : begin
                                DeF[I] := CCNo;
                                SDe[I] := 'N';
                              end;
                        'P' : begin
                                PrF[I] := CCNo;
                                SPr[I] := 'N';
                              end;
                   end;
                 end;
            end
            else RC := 'S';
       end;
  Until RC = 'N';
  Case X of
       'D' : De := 'S';
       'P' : Pr := 'S';
  end;
end;


Procedure ListaConta(X : Char);
Var
  TipF       : Char;
begin
  Case X of
       'D' : If De = 'N' then Carrega(X);
       'P' : If Pr = 'N' then Carrega(X);
  end;
  For I := 1 to 20 do
  begin
    Case X of
         'D' : begin
                 YYNo := DeF[I];
                 TipF := SDe[I];
               end;
         'P' : begin
                 YYNo := PrF[I];
                 TipF := SPr[I];
               end;
    end;
    If YYNo <> '' then
       begin
         SearchTreeY ( RootY );
         If RC = 'S' then
            begin
              CCNo := YYNo;
              SearchTree1 ( Root1 );
              If RC = 'S' then
                 begin
                   ReadWrite(#04,'R','N',CCNumber);
                   GotoXY(9,I + 2);
                   Write(CCNo,' ',PushLeft(31,CCMember.Descricao),
                                  YAddress^.AcMensalH:3,':',
                                  QQStr(YAddress^.AcMensalM,2,'0'),' ',
                                  EditReal(YAddress^.AcMensalV):15,' ',TipF);
                 end;
            end;
       end;
  end;
end;


Procedure EntryKey(X : Char);
Var
  ValorA    : Real;
begin
  Repeat
    K := 1;
    Repeat
      Case K of
           01..20 : If ((X = 'D') and (DeF[K] = '')) or
                       ((X = 'P') and (PrF[K] = '')) then
                       begin
                         Case X of
                              'D' : J := DeF[K];
                              'P' : J := PrF[K];
                         end;
                         InputStr(J,3,9,(K + 2),0,'S','N','T','N',Tfn,Utx);
                         If (TC <> #27) and (J  <> '' ) then
                            begin
                              CCNo := J;
                              SearchTree1 ( Root1 );
                              If RC = 'S' then
                                 begin
                                   ReadWrite(#04,'R','N',CCNumber);
                                   If CCMember.Tipo = X then
                                      begin
                                        Case X of
                                             'D' : begin
                                                     DeF[K] := CCNo;
                                                     SDe[K] := 'N';
                                                   end;
                                             'P' : begin
                                                     PrF[K] := CCNo;
                                                     SPr[K] := 'N';
                                                   end;
                                        end;
                                        GotoXY(9,K + 2);
                                        Write(CCNo,' ',PushLeft(31,CCMember.Descricao));
                                        YYNo := CCNo;
                                        SearchTreeY ( RootY );
                                        If RC = 'N' then LoadTreeY ( RootY );
                                        K := K - 1;
                                      end
                                      else begin
                                             Case X of
                                                  'D' : ErroMsg := 'A Conta n„o ‚ de Desconto';
                                                  'P' : ErroMsg := 'A Conta n„o ‚ de Provento';
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
                              Case X of
                                   'D' : YYNo := DeF[K];
                                   'P' : YYNo := PrF[K];
                              end;
                              SearchTreeY ( RootY );
                              If YAddress^.AcMensalH = 0 then J := ''
                                 else begin
                                        Str(YAddress^.AcMensalH:3,J);
                                        J := LeftAdjust(J);
                                      end;
                              InputStr(J,3,44,(K + 2),0,'S','N','T','N',Tfn,Utx);
                              If not (TC in [#25,#27]) then
                                 begin
                                   Val(J,YAddress^.AcMensalH,E);
                                   GotoXY(44,K+2); Write(YAddress^.AcMensalH:3);
                                   If YAddress^.AcMensalM = 0 then J := ''
                                      else begin
                                             Str(YAddress^.AcMensalM:2,J);
                                             J := LeftAdjust(J);
                                           end;
                                   InputStr(J,2,48,(K + 2),0,'S','N','T','N',Tfn,Utx);
                                   If TC <> #27 then
                                      begin
                                        Val(J,YAddress^.AcMensalM,E);
                                        GotoXY(48,K + 2);
                                        Write(QQStr(YAddress^.AcMensalM,2,'0'));
                                        ValorA := YAddress^.AcMensalV;
                                        ValorA := TruncX(ValorA);
                                        If YAddress^.AcMensalV = 0 then J := ''
                                           else begin
                                                  Str(YAddress^.AcMensalV:14:2,J);
                                                   J := LeftAdjust(J);
                                                end;
                                        InputStr(J,14,52,(K + 2),0,'S','N','$','N',Tfn,Utx);
                                        If TC <> #27 then
                                           begin
                                             Val(J,YAddress^.AcMensalV,E);
                                             If YAddress^.AcMensalV <> ValorA
                                                then YAddress^.Origem := 'U';
                                             Case X of
                                                  'D' : J := SDe[K];
                                                  'P' : J := SPr[K];
                                             end;
                                             InputStr(J,1,67,(K + 2),0,'S','N','T','N',Tfn,Utx);
                                             If TC <> #27 then
                                                Case UpCase(J[1]) of
                                                     'S' : Case X of
                                                                'D' : SDe[K] := 'S';
                                                                'P' : SPr[K] := 'S';
                                                           end;
                                                     'N' : Case X of
                                                                'D' : SDe[K] := 'N';
                                                                'P' : SPr[K] := 'N';
                                                           end;
                                                end;
                                             GotoXY(67,K + 2); Write(UpCase(J[1]));
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
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 21) or (TC = #27);
    If TC <> #27 then Confirma;
  Until TC in ['S',#27];
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


Procedure ListaProv;
begin
  If (YAddress^.AcMensalH > 0) or (YAddress^.AcMensalM > 0)
     then WriteLine('L',YYNo+' '+Acentua(CCMember.Descricao)+
                     ConstStr(' ',31-Length(CCMember.Descricao))+
                     PushRight(3,QQStr(YAddress^.AcMensalH,3,' '))+':'+
                     QQStr(YAddress^.AcMensalM,2,'0')+' '+
                     PushRight(15,EditReal(YAddress^.AcMensalV)))
     else If TruncX(YAddress^.AcMensalV) > 0
             then WriteLine('L',YYNo+' '+Acentua(CCMember.Descricao)+
                                ConstStr(' ',38-Length(CCMember.Descricao))+
                                PushRight(15,EditReal(YAddress^.AcMensalV)));
  R1 := R1 + YAddress^.AcMensalV;
end;


Procedure ListaDesc;
begin
  If (YAddress^.AcMensalH > 0) or (YAddress^.AcMensalM > 0)
     then WriteLine('L',YYNo+' '+Acentua(CCMember.Descricao)+
                     ConstStr(' ',54-Length(CCMember.Descricao))+
                     PushRight(3,QQStr(YAddress^.AcMensalH,3,' '))+':'+
                     QQStr(YAddress^.AcMensalM,2,'0')+' '+
                     PushRight(15,EditReal(YAddress^.AcMensalV)))
     else If TruncX(YAddress^.AcMensalV) > 0
             then WriteLine('L',YYNo+' '+Acentua(CCMember.Descricao)+
                                ConstStr(' ',61-Length(CCMember.Descricao))+
                                PushRight(15,EditReal(YAddress^.AcMensalV)));
  R2 := R2 + YAddress^.AcMensalV;
end;


Procedure Recibo(Y : Integer);
begin
  For R := 1 to Y do
  begin
    If R = 1 then WriteLine('L',Dx+Acentua(CMstMember.Descricao)+Df)
             else WriteLine('L',Qp+Dx+Acentua(CMstMember.Descricao)+Df);
    WriteLine('L',ConstStr('-',80));
    WriteLine('L',Cx+Acentua(CMstMember.Endereco)+', '+
                     CMstMember.Numero+'  '+
                     Acentua(CMstMember.Cidade)+', '+
                     CMstMember.Estado+'  Cep: '+CMstMember.Cep+'   '+
                     'CGC: '+CMstMember.Cgc+Acentua(' Inscri‡„o: ')+
                     CMstMember.Inscricao+Cf);
    WriteLine('L',' ');
    WriteLine('L',Nx+Acentua('Recibo de F‚rias')+Nf);
    WriteLine('L',' ');
    WriteLine('L',ConstStr('-',80));
    WriteLine('L',' ');
    WriteLine('L',Acentua('Nome................: ')+
                  Nx+Acentua(EEMember.Nome)+Nf);
    WriteLine('L',Acentua('Matr¡cula...........: ')+EEMember.Matricula);
    WriteLine('L',Acentua('Cargo...............: '+EEMember.Cargo));
    WriteLine('L',' ');
    WriteLine('L',Acentua('Carteira de Trabalho: ')+
                  EEMember.CTrabN+' '+EEMember.CTrabS+' '+EEMember.CTrabE);
    WriteLIne('L',' ');
    WriteLine('L',Acentua('Endere‡o............: ')+
                  Acentua(EEMember.Endereco));
    WriteLine('L',Acentua('Cidade..............: ')+
                  Acentua(EEMember.Cidade)+' '+EEMember.Estado);
    WriteLine('L',' ');
    WriteLine('L',Acentua('Per¡odo aquisitivo..: ')+
                  Acentua(Tit)+ConstStr(' ',31-Length(Tit))+
                  Acentua('Tipo/Sal. Base...: ')+
                  EEMember.Tipo+' '+EditReal(EEMember.Salario));
    WriteLine('L',Acentua('Per¡odo de F‚rias...: ')+
                  DataI+' a '+DataF);
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
    For I := 1 to 20
    do If (PrF[I] <> '') and (SPr[I] = 'S') then
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
    do If (DeF[I] <> '') and (SDe[I] = 'S') then
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
    WriteLine('L',ConstStr('-',80));
    WriteLine('L','Totais'+ConstStr(' ',36)+
                   PushRight(15,EditReal(R1))+ConstStr(' ',8)+
                   PushRight(15,EditReal(R2)));
    WriteLine('L',ConstStr('-',80));
    YYNo := '057';
    SearchTreeY ( RootY );
    If RC = 'S' then Valor := YAddress^.AcMensalV
                else Valor := 0;
    WriteLine('L',ConstStr(' ',52)+'Adiantamento '+
                  PushRight(15,EditReal(Valor)));
    WriteLine('L',' ');
    If ContLin < 55 then For I := 1 to 5 do WriteLine('L',' ');
    WriteLine('L',' ');
    WriteLine('L',ConstStr(' ',10)+Acentua('Recebi a importƒncia acima.'));
    WriteLine('L',' ');
    WriteLine('L',' ');
    WriteLine('L',' ');
    WriteLine('L',ConstStr(' ',23)+
                  '____/____/____  _______________________________');
    WriteLine('L',ConstStr(' ',42)+Cx+Acentua(EEMember.Nome)+Cf);
  end;
  If DskRpt = 'N' then WriteLine('W',Qp);
end;


Procedure DataFerias(X : Char);
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
  GotoXY(04,15); Write('Maior$:');
  GotoXY(40,15); Write('Dt.Adm:');
  If X = 'F' then
     begin
       GotoXY(04,16); Write('Ad.13§:');
       GotoXY(40,16); Write('Abono.:');
       GotoXY(04,17); Write('T.Prov:');
       GotoXY(40,17); Write('H.Extr:');
       GotoXY(04,18); Write('T.Desc:');
       GotoXY(04,19); Write('        ---------------');
       GotoXY(04,20); Write('L¡quid:');
     end;
  Color(Tfn,Utx);
  GotoXY(12,09); Write(PushLeft(9,EEMember.Matricula));
  GotoXY(12,10); Write(EEMember.Nome);
  GotoXY(12,11); Write(EEMember.Cargo);
  GotoXY(48,11); Case EEMember.Status of
                      'A' : Write('Ativo       ');
                      'P' : Write('Dem.Espont. ');
                      'D' : Write('Demitido    ');
                      'E' : Write('Transf.Entr.');
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
                 end;
  GotoXY(12,12);
  If EEMember.DiaI <> 0 then Write(QQStr(EEMember.DiaI,2,'0'),'/',
                                   QQStr(EEMember.MesI,2,'0'));
  GotoXY(18,12);
  If EEMember.DiaF <> 0 then Write('a ',QQStr(EEMember.DiaF,2,'0'),'/',
                                        QQStr(EEMember.MesF,2,'0'));
  GotoXY(48,12);
  If NDias <> 0 then Write(QQStr(NDias,2,'0'),' dias');
  GotoXY(48,13); Write(EEMember.PeriodoV:2);
  GotoXY(12,14); Write(EEMember.DDFer,'/',EEMember.MMFer,'/',EEMember.AAFer);
  GotoXY(23,14); Write(DiaSemana(EEMember.DDFer+'/'+EEMember.MMFer+'/'+EEMember.AAFer));
  GotoXY(48,15); Write(EEMember.DDPAq,'/',EEMember.MMPAq,'/',EEMember.AAPAq);
  GotoXY(48,14); Case EEMember.Tipo of
                      'M' : Write('Mensalista ');
                      'H' : Write('Horista    ');
                      'S' : Write('Semanalista');
                 end;
  If EEMember.Tipo = 'H' then SalBase := EEMember.Salario * EEMember.HNormais
                         else SalBase := EEMember.Salario;

  YYNo := '016';
  SearchTreeY ( RootY );
  If RC = 'S' then
     begin
       If (YAddress^.PerctUsr <> 0  ) and
          (YAddress^.BaseUsr  =  'S') then
          begin
            Produt              := TruncX((SalBase * YAddress^.PerctUsr)/100);
            YAddress^.AcMensalV := Produt;
          end
          else Produt := YAddress^.AcMensalV;
     end
     else Produt := 0;

  If EEMember.Tipo = 'H'
     then ValorHora1 := (EEMember.Salario * EEMember.HNormais) + Produt
     else ValorHora1 := EEMember.Salario + Produt;
     If EEMember.HNormais > 0 then ValorHora1 := ValorHora1 / EEMember.HNormais
                              else ValorHora1 := ValorHora1 / 220;

  AdNot := 0;
  CCNo  := '009';
  SearchTree1 ( Root1 );
  If RC = 'S' then
     begin
       ReadWrite(#04,'R','N',CCNumber);
       If RW = 'S' then
          begin
            YYNo := CCNo;
            RecuperaConta;
            If (YAddress^.AcMensalH > 0) or
               (YAddress^.AcMensalM > 0) then
               begin
                 AdNot := (YAddress^.AcMensalH * ValorHora1) +
                          ((ValorHora1 / 60)  * YAddress^.AcMensalM);
                 If CCMember.Taxa > 0 then AdNot := AdNot * CCMember.Taxa;
               end;
          end;
     end;

  YYNo := '007';
  RecuperaConta;
  If YAddress^.Origem <> 'U' then
     begin
       VPeri := 0;
       For I := 1 to 5 do
       Case EEMember.Peric[I] of
            'B' : VPeri := VPeri + ((SalBase   + Produt) * TTMember.Peri[I]) / 100;
            'S' : VPeri := VPeri + (TTMember.SalMinimo * TTMember.Peri[I]) / 100;
       end;
       VPeri := TruncX(VPeri);
     end
     else VPeri := YAddress^.AcMensalV;

  YYNo := '008';
  RecuperaConta;
  If YAddress^.Origem <> 'U' then
     begin
       VInsa := 0;
       For I := 1 to 5 do
       Case EEMember.Insalub[I] of
            'B' : VInsa := VInsa + ((SalBase   + Produt) * TTMember.Insa[I]) / 100;
            'S' : VInsa := VInsa + (TTMember.SalMinimo * TTMember.Insa[I]) / 100;
       end;
       VInsa := TruncX(VInsa);
     end
     else VInsa := YAddress^.AcMensalV;

  SalBase := SalBase + Produt + AdNot + VPeri + VInsa;

  If EEMember.PeriodoV > 1 then
    begin
      SalBase := SalBase * 2;
      P2 := 'U';
    end
    else P2 := 'S';
  GotoXY(12,15); Write(EditReal(SalBase):15);
  ValorHora1 := SalBase / EEMember.HNormais;
  D13 := 'S';
  ABN := 'N';
  He  := EEMember.SomaHF1;
  Me  := EEMember.SomaMF1;
end;


Procedure PedeCadastroF(X : Char);
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
                  InputStr(J,2,12,12,0,'S','N','T','N',Tfn,Utx);
                  Val(J,EEMember.DiaI,E);
                  GotoXY(12,12); Write(QQStr(EEMember.DiaI,2,'0'),'/');
                end;
           02 : begin
                  If EEMember.MesI = 0 then J := ''
                                       else begin
                                              Str(EEMember.MesI:2,J);
                                              J := LeftAdjust(J);
                                            end;
                  InputStr(J,2,15,12,0,'S','N','T','N',Tfn,Utx);
                  Val(J,EEMember.MesI,E);
                  If (EEMember.MesI < 1 ) or
                     (EEMember.MesI > 12) then K := K - 1
                     else begin
                            GotoXY(15,12); Write(QQStr(EEMember.MesI,2,'0'));
                            If (MM = 12) or (EEMember.MesI < MM)
                               then Str((AA + 1):4,J)
                               else J := AAFx;
                            DataI := QQStr(EEMember.DiaI,2,'0') + '/' +
                                     QQStr(EEMember.MesI,2,'0') + '/' + J;
                            Val(J,Ano,E);
                            Resto := Ano div 4;
                            If (Ano - (Resto * 4)) = 0
                               then TabDia[2] := 29
                               else TabDia[2] := 28;
                          end;
                end;
           03 : begin
                  If NDias = 0 then J := ''
                               else begin
                                      Str(NDias:2,J);
                                      J := LeftAdjust(J);
                                    end;
                  InputStr(J,2,48,12,0,'S','N','T','N',Tfn,Utx);
                  Val(J,NDias,E);
                  If (NDias = 0 ) or (NDias > 30) then K := K - 1
                     else begin
                            EEMember.DiaF := EEMember.DiaI + NDias - 1;
                            If EEMember.DiaF > TabDia[EEMember.MesI] then
                               begin
                                 EEMember.DiaF := EEMember.DiaF - TabDia[EEMember.MesI];
                                 EEMember.MesF := EEMember.MesI + 1;
                                 If EEMember.MesF = 13 then EEMember.MesF := 1;
                               end
                               else EEMember.MesF := EEMember.MesI;
                            GotoXY(18,12); Write('a ',QQStr(EEMember.DiaF,2,'0'),
                                                 '/',QQStr(EEMember.MesF,2,'0'));
                            GotoXY(48,12); Write(QQStr(NDias,2,'0'),' dias');
                            If EEMember.MesF < EEMember.MesI
                               then Str((AA + 1):4,J)
                               else J := Copy(DataI,7,4);
                            DataF := QQStr(EEMember.DiaF,2,'0') + '/' +
                                     QQStr(EEMember.MesF,2,'0') + '/' + J;
                            If NDias = 20 then ABN := 'S'
                                          else ABN := 'N';
                          end;
                end;
           04 : begin
                  J := Tit;
                  InputStr(J,27,12,13,0,'S','S','T','N',Tfn,Utx);
                  Tit := J;
                  If (TC <> #27) and (Tit = '') then
                     begin
                       ErroMsg := 'Informe o per¡odo aquisitivo relativo as F‚rias.';
                       ErrorMessage;
                       K := K - 1;
                     end;
                end;
           05 : If X = 'F' then
                   begin
                     If EEMember.DDFer = '' then J := ''
                        else J := EEMember.DDFer + '/' +
                                  EEMember.MMFer + '/' +
                                  EEMember.AAFer;
                     InputStr(J,10,12,14,0,'S','N','D','S',Tfn,Utx);
                     If TC <> #27 then
                        begin
                          EEMember.DDFer := Copy(J,1,2);
                          EEMember.MMFer := Copy(J,4,2);
                          EEMember.AAFer := Copy(J,7,2);
                          GotoXY(23,14); Write(DiaSemana(EEMember.DDFer+'/'+EEMember.MMFer+'/'+EEMember.AAFer));
                        end;
                   end;
           06 : If X = 'F' then
                   begin
                     If SalBase = 0 then J := ''
                                    else begin
                                           Str(SalBase:15:2,J);
                                           J := LeftAdjust(J);
                                         end;
                     InputStr(J,14,13,15,0,'S','N','$','N',Tfn,Utx);
                     Val(J,SalBase,E);
                     If (TC <> #27) and (SalBase = 0) then K := K - 1;
                   end;
           07 : If X = 'F' then
                   begin
                     J := D13;
                     InputStr(J,1,12,16,0,'S','N','T','N',Tfn,Utx);
                     If J = ' ' then J := 'N';
                     D13 := UpCase(J[1]);
                     GotoXY(12,16); Case D13 of
                                         'N' : Write('N„o');
                                         'S' : Write('Sim');
                                    end;
                   end;
           08 : If X = 'F' then
                   begin
                     J := ABN;
                     InputStr(J,1,48,16,0,'S','N','T','N',Tfn,Utx);
                     If J = ' ' then J := 'N';
                     ABN := UpCase(J[1]);
                     GotoXY(48,16); Case ABN of
                                         'N' : Write('N„o');
                                         'S' : Write('Sim');
                                    end;
                   end;
           09 : If X = 'F' then
                   begin
                     If He = 0 then J := ''
                               else begin
                                      Str(He:4,J);
                                      J := LeftAdjust(J);
                                    end;
                     InputStr(J,3,48,17,0,'S','N','T','N',Tfn,Utx);
                     Val(J,He,E);
                     GotoXY(48,17); Write(He:3,':');
                     If He > 546 then
                        begin
                          ErroMsg := 'O n£mero de horas esta acima do limite legal.';
                          ErrorMessage;
                        end;
                   end;
           10 : If X = 'F' then
                   begin
                     If Me = 0 then J := ''
                               else begin
                                      Str(Me:2,J);
                                      J := LeftAdjust(J);
                                    end;
                     InputStr(J,2,52,17,0,'S','N','T','N',Tfn,Utx);
                     Val(J,Me,E);
                     GotoXY(52,17); Write(QQStr(Me,2,'0'));
                   end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 11) or (TC = #27);
    If TC <> #27 then Confirma;
  Until TC in ['S',#27];
end;


Procedure MovePX(X : Str3);
begin
  If X <> '061' then
     begin
       YYNo := X;
       SearchTreeY ( RootY );
       If RC = 'S' then
          begin
            PXMember.Empregado := EENo;
            PXMember.Conta     := YYNo;
            PXMember.AcMensalV := YAddress^.AcMensalV;
            PXMember.AcMensalH := YAddress^.AcMensalH;
            PXMember.AcMensalM := YAddress^.AcMensalM;
            Seek ( PXFile, FileSize(PXFile));
            Write( PXFile, PXMember        );
            YAddress^.AcMensalV := 0;
            YAddress^.AcMensalH := 0;
            YAddress^.AcMensalM := 0;
            YAddress^.Origem    := 'S';
          end;
     end
     else YAddress^.Origem := 'S';
end;


Procedure CalculaINSSFerias;
begin
  VBases[1] := 0;
  VBases[2] := 0;
  ConverteHora('022');
  For I := 1 to 20 do
  If (PrF[I] <> '') and (SPr[I] = 'S') then
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
                 If CCMember.Bases[1] = 'F' then
                    begin
                      VBases[1] := VBases[1] + TruncX(YAddress^.AcMensalV);
                      If CCMember.Bases[2] = 'S' then VBases[2] := VBases[2] + TruncX(YAddress^.AcMensalV);
                    end;
               end
               else RC := 'S';
          end;
     end;
  If VBases[2] = 0 then VBases[2] := VBases[1];
  If (VBases[2] > 0) and (EEMember.INSS[2] = 'S') then
     begin
       I := FaixaINSS(VBases[2]);
       If VBases[2] > TTMember.TetoSalContr
          then R1 := TTMember.TetoSalContr * (TTMember.TaxaIapas[I] / 100)
          else R1 := VBases[2] * (TTMember.TaxaIapas[I] / 100);
     end
     else R1 := 0;
  YYNo := '061';
  SearchTreeY ( RootY );
  If RC = 'N' then LoadTreeY ( RootY );
  YAddress^.Origem    := 'S';
  YAddress^.AcMensalV := R1;
  CCNo := YYNo;
  SearchTree1 ( Root1 );
  If RC = 'S' then
     begin
       ReadWrite(#04,'R','N',CCNumber);
       If CCMember.Bases[1] = 'N' then R1 := 0;
     end
     else R1 := 0;
{  R1   := R1 + (TTMember.DependenteIR * EEMember.DepIR); }
  R1   := R1 + (MP202 + (TTMember.DependenteIR * EEMember.DepIR));
  R2   := VBases[1] - R1;
  YYNo := '058';
  SearchTreeY ( RootY );
  If RC = 'N' then LoadTreeY ( RootY );
  YAddress^.Origem := 'S';
  R1 := (R2 * (TTMember.TaxaIR[FaixaIR(R2)] / 100)) - TTMember.DeducaoIR[FaixaIR(R2)];
  If R1 > 0 then YAddress^.AcMensalV := R1
            else YAddress^.AcMensalV := 0;
end;


Procedure SeparaINSS;
begin
  VTrib := (TProv / NDias) * NoMes;
  YYNo  := '088';
  SearchTreeY ( RootY );
  If RC = 'N' then LoadTreeY ( RootY );
  YAddress^.Origem    := P2;
  YAddress^.AcMensalV := VTrib;
  VTrib := TProv - VTrib;
  YYNo  := '089';
  SearchTreeY ( RootY );
  If RC = 'N' then LoadTreeY ( RootY );
  YAddress^.Origem    := P2;
  YAddress^.AcMensalV := VTrib;
end;


Procedure CalculodeFerias;
Var
  XEta                       : Char;
  ValorINSS,Valor21,Valor42  : Real;
begin
  Move(ScArray4[1],Mem[$B800:0000],4000);
  Pr := 'N';
  De := 'N';
  For I := 1 to 20 do begin
                        DeF[I] := '';
                        PrF[I] := '';
                        SPr[I] := ' ';
                        SDe[I] := ' ';
                      end;
  LoadMVDsk(#11);
  If (EEMember.DiaI <> 0) and
     (EEMember.DiaF <> 0) then
     begin
       If EEMember.MesI = EEMember.MesF
          then NDias := EEMember.DiaF - EEMember.DiaI + 1
          else NDias := (TabDia[EEMember.MesI] - EEMember.DiaI) + EEMember.DiaF + 1;
     end
     else NDias := 0;
  DataFerias('F');
  PedeCadastroF('F');
  If TC = 'S' then
     begin
       XEta             := CMstMember.Etapa;
       Eta              := 'P';
       CMstMember.Etapa := 'P';
       TProv            := 0;
       TDesc            := 0;
       Mx               := Copy(MMFx,2,2);
       Ax               := AAFx;

       If ((NDias + EEMember.DiaI) - 1) < TabDia[EEMember.MesI]
          then NoMes := NDias
          else NoMes := (TabDia[EEMember.MesI] - EEMember.DiaI) + 1;

       If (NoMes = 30) or (NoMes = TabDia[EEMember.MesI]) then
          begin
            YYNo := '001';
            SearchTreeY ( RootY );
            If RC = 'S' then
               begin
                 YAddress^.AcMensalV := 0;
                 YAddress^.Origem    := 'U';
               end;
          end;

       YYNo := '022';
       SearchTreeY ( RootY );
       If RC = 'S' then
          begin
            YAddress^.AcMensalV := 0;
            YAddress^.Origem    := 'S';
          end;

       YYNo := '042';
       SearchTreeY ( RootY );
       If RC = 'S' then
          begin
            YAddress^.AcMensalV := 0;
            YAddress^.Origem    := 'S';
          end;

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
            ValorINSS           := YAddress^.AcMensalV;
            YAddress^.AcMensalV := 0;
            YAddress^.Origem    := 'S';
          end;

       YYNo := '088';
       SearchTreeY ( RootY );
       If RC = 'S' then
          begin
            YAddress^.AcMensalV := 0;
            YAddress^.Origem    := 'S';
          end;

       YYNo := '089';
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
       YAddress^.AcMensalV := ((SalBase /30) * NDias) / 3;
       YAddress^.AcAnualV  := 0;

       YYNo := '020';
       SearchTreeY ( RootY );
       If RC = 'N' then LoadTreeY ( RootY );
       If ABN = 'S' then
          begin
            YAddress^.Origem    := 'U';
            YAddress^.AcMensalV := ((SalBase / 30) * 10) * 1.3334;
            YAddress^.AcAnualV  := 0;
          end
          else begin
                 YAddress^.Origem    := 'S';
                 YAddress^.AcMensalV := 0;
                 YAddress^.AcAnualV  := 0;
               end;

       If D13 = 'S' then
          begin
            YYNo := '004';
            SearchTreeY ( RootY );
            If (RC = 'N') or ((RC = 'S') and (YAddress^.AcAnualV = 0)) then
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

       If (He > 0) or (Me > 0) then
          begin
            R1 := He;
            R1 := (R1 * 60)+Me;
            R1 := R1/12;
            Horas(R1);
            YYNo := '022';
            SearchTreeY ( RootY );
            If RC = 'N' then LoadTreeY ( RootY );
            YAddress^.Origem    := 'U';
            YAddress^.AcMensalH := Hora;
            YAddress^.AcMensalM := Minuto;
            ConverteHora('022');
            YYNo := '022';
            SearchTreeY ( RootY );
            If RC = 'S' then
               begin
                 Valor21 := YAddress^.AcMensalV / 3;
                 Valor42 := YAddress^.AcMensalV / 6;
               end;
            YYNo := '021';
            SearchTreeY ( RootY );
            If RC = 'S' then YAddress^.AcMensalV := YAddress^.AcMensalV + Valor21;
            YYNo := '042';
            SearchTreeY ( RootY );
            If RC = 'N' then LoadTreeY ( RootY );
            YAddress^.Origem    := 'U';
            YAddress^.AcMensalV := Valor42;
          end;
          CalculaINSSFerias;
       Repeat
         Move(Mem[$B800:0000],ScArray5[1],4000);
         DrawBox(37,17,56,19,Red,'S');
         Color(Red,Cyan);
         GotoXY(37,17); Write('     Proventos      ');
         GotoXY(37,18); Write('     Descontos      ');
         GotoXY(37,19); Write('     Esc ',#26,' Terminar ');
         Color(Red,White);
         GotoXY(42,17); Write('P');
         GotoXY(42,18); Write('D');
         GotoXY(42,19); Write('Esc');
         Repeat
           TC := UpCase(ReadKey);
           If TC in ['D','P'] then
              begin
                EntryContas(TC);
                CalculaLiq('N');
                SeparaINSS;
                CalculaINSSFerias;
                CalculaLiq('S');
                TC := #00;
              end;
         Until TC = #27;
         Confirma;
       Until TC in ['S',#27];
       If TC = 'S' then
          begin
            LimpaMVDsk;
            If EEMember.MesI = MM then EEMember.Status := 'F';
            If EEMember.PeriodoV > 0 then
               begin
                 EEMember.PeriodoV := EEMember.PeriodoV - 1;
                 If EEMember.PeriodoV = 0 then
                    begin
                      EEMember.SomaHF1  := EEMember.SomaHF2;
                      EEMember.SomaMF1  := EEMember.SomaMF2;
                      EEMember.SomaHF1  := 0;
                      EEMember.SomaMF1  := 0;
                    end;
               end;
            ReadWrite(#08,'W','N',EENumber);
            YYNo := '057';
            SearchTreeY ( RootY );
            If RC = 'N' then LoadTreeY ( RootY );
            YAddress^.Origem    := 'U';
            YAddress^.AcMensalV := Valor;
            HHNo := EENo + '#' + Copy(DataI,7,4) +
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
                 Data      := Copy(DataI,7,4) +
                              Copy(DataI,4,2) + Copy(DataI,1,2);
                 Tipo      := 'V';
                 Salario   := 0;
                 Motivo    := 'F‚rias at‚ ' + DataF + ' relativo: ' + Tit;
                 ReadWrite(#10,'W','N',HHNumber);
                 LoadTree10 ( Root10 );
                 RC := 'S';
               end;
            Color(Blue,Black);
            GotoXY(1,23);  Write(ConstStr(' ',80));
            Color(Red,Cyan);
            GotoXY(1,24);  Write(ConstStr(' ',80));
            GotoXY(2,24);  Write('Quer emitir o recibo de f‚rias ?  Sim/N„o');
            Color(Red,White);
            GotoXY(36,24); Write('S');
            GotoXY(40,24); Write('N');
            Repeat
              TC := UpCase(ReadKey);
            Until TC in ['S','N',#27];
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
                   InputStr(J,1,58,24,0,'S','N','T','N',Red,Yellow);
                   If J = '' then J := '1';
                 Until (J[1] in ['1','2','3','4','5','6','7','8','9']) or
                       (TC = #27);
                 If TC <> #27 then
                    begin
                      Val(J,I,E);
                      QPorta;
                      If TC <> #27 then
                         begin
                           Recibo(I);
                           Close ( LST );
                         end;
                    end;
               end;
            If EEMember.MesI <> MM then
               begin
                 Assign ( PXFile,(XPath + '\' + FileMM + AAFx + '.T' + Copy(MMFx,2,2)));
                 {$I-}
                 Reset ( PXFile );
                 {$I+}
                 If IOResult <> 0 then
                    begin
                      ReWrite ( PXFile );
                      Reset   ( PXFile );
                    end;
                 For I := 1 to 20 do
                 begin
                   If (PrF[I] <> '') and (SPr[I] = 'S') then MovePX(PrF[I]);
                   IF (DeF[I] <> '') and (SDe[I] = 'S') then MovePX(DeF[I]);
                 end;
                 MovePX('057');
                 MovePX('088');
                 MovePX('089');
                 EEMember.Status := 'A';
                 Close ( PXFile );
                 YYNo := '061';
                 SearchTreeY ( RootY );
                 If RC = 'S' then YAddress^.AcMensalV := ValorINSS;
               end
               else UnLoadMVDsk;
          end;
       CMstMember.Etapa := XEta;
     end;
  LiberaMVDsk;
end;


Procedure Aviso(Y : Integer);
begin
  For R := 1 to Y do
  begin
    If R = 1 then WriteLine('L',Dx+Acentua(CMstMember.Descricao)+Df)
             else WriteLine('L',Qp+Dx+Acentua(CMstMember.Descricao)+Df);
    WriteLine('L',ConstStr('-',80));
    WriteLine('L',Cx+Acentua(CMstMember.Endereco)+', '+
                     Acentua(CMstMember.Cidade)+', '+
                     CMstMember.Estado+
                     '  Cep: '+CMstMember.Cep+Cf);
    WriteLine('L',' ');
    WriteLine('L',+ConstStr(' ',19)+#27+Dx+Acentua('Notifica‡„o de F‚rias')+#27+Df);
    WriteLine('L',ConstStr('-',80));
    WriteLine('L',Acentua('Concess„o de f‚rias, conforme discrimina‡„o abaixo:'));
    WriteLine('L',ConstStr('-',80));
    WriteLine('L',' ');
    WriteLine('L',Acentua('Nome................: ')+
                  Nx+Acentua(EEMember.Nome)+Nf);
    WriteLine('L',Acentua('Matr¡cula...........: ')+EEMember.Matricula);
    WriteLine('L',Acentua('Cargo...............: '+EEMember.Cargo));
    WriteLine('L',' ');
    WriteLine('L',Acentua('Carteira de Trabalho: ')+
                  EEMember.CTrabN+' '+EEMember.CTrabS+' '+EEMember.CTrabE);
    WriteLIne('L',' ');
    WriteLine('L',Acentua('Endere‡o............: ')+
                  Acentua(EEMember.Endereco));
    WriteLine('L',Acentua('Cidade..............: ')+
                  Acentua(EEMember.Cidade)+' '+EEMember.Estado);
    WriteLine('L',' ');
    WriteLine('L',Acentua('Dura‡„o.............: ')+
                  PushRight(2,EditInteger(NDias))+' dias.');
    WriteLine('L',Acentua('Per¡odo aquisitivo..: ')+Acentua(Tit));
    WriteLine('L',Acentua('Per¡odo de F‚rias...: ')+DataI+' a '+DataF);
    WriteLine('L',' ');
    WriteLine('L',' ');
    WriteLine('L',ConstStr(' ',10)+Acentua(CMstMember.Cidade)+',');
    WriteLine('L',' ');
    WriteLine('L',' ');
    WriteLine('L',' ');
    WriteLine('L',' ');
    WriteLine('L',Cx+ConstStr(' ',10)+
                  '----/----/----  ----------------------------------------'+
                  ConstStr(' ',5)+
                  '----/----/----  ----------------------------------------'+Cf);
    WriteLine('L',Cx+ConstStr(' ',26)+Acentua(EEMember.Nome)+
                     ConstStr(' ',61-Length(EEMember.Nome))+
                     Acentua(CMstMember.Descricao)+Cf);
  end;
  If DskRpt = 'N' then WriteLine('W',Qp);
end;


Procedure AvisodeFerias;
begin
  Move(ScArray4[1],Mem[$B800:0000],4000);
  If (EEMember.DiaI <> 0) and
     (EEMember.DiaF <> 0) then
     begin
       If EEMember.MesI = EEMember.MesF
          then NDias := EEMember.DiaF - EEMember.DiaI + 1
          else NDias := (TabDia[EEMember.MesI] - EEMember.DiaI) + EEMember.DiaF + 1;
     end
     else NDias := 0;
  DataFerias('A');
  PedeCadastroF('A');
  If TC = 'S' then
     begin
       Color(Blue,Black);
       GotoXY(1,23);  Write(ConstStr(' ',80));
       Color(Red,Cyan);
       GotoXY(1,24);  Write(ConstStr(' ',80));
       GotoXY(2,24);  Write('Informe o n£mero de c¢pias que ser„o impressas (  a  ):      ');
       Color(Red,White);
       GotoXY(50,24); Write('1');
       GotoXY(54,24); Write('9');
       Repeat
         J := '';
         InputStr(J,1,58,24,0,'S','N','T','N',Red,Yellow);
         If J = '' then J := '1';
       Until (J[1] in ['1','2','3','4','5','6','7','8','9']) or (TC = #27);
       If TC <> #27 then
          begin
            Val(J,I,E);
            QPorta;
            If TC <> #27 then
               begin
                 Aviso(I);
                 Close ( LST );
               end;
          end;
     end;
end;


Procedure FeriasIndividuais;
begin
  EENo := '';
  Repeat
    Move(ScArray4[1],Mem[$B800:0000],4000);
    Color(Sfn,Stx);
    GotoXY(35,08); Write(' F‚rias Individuais       ');
    Color(Tfn,Ttx);
    GotoXY(04,09); Write('Matr¡c:');
    Color(Tfn,Utx);
    RecebeCodigo(9,'C','N');
    If EENumber <> Limite then
       begin
         ReadWrite(#08,'R','N',EENumber);
         Color(Tfn,Utx);
         GotoXY(12,09); Write(EEMember.Matricula);
         GotoXY(12,10); Write(EEMember.Nome);
         DrawBox(22,13,44,16,Red,'S');
         Color(Red,Cyan);
         GotoXY(23,14); Write('Aviso de F‚rias      ');
         GotoXY(23,15); Write('C lculo das F‚rias   ');
         Color(Red,Yellow);
         GotoXY(23,14); Write('A');
         GotoXY(23,15); Write('C');
         Color(Tfn,Utx);
         Repeat
           TC := UpCase(ReadKey);
         Until TC in ['A','C',#27];
         Case TC of
              'A' : AvisodeFerias;
              'C' : CalculodeFerias;
         end;
         TC := #13;
       end;
  Until TC = #27;
  Resto := AA div 4;
  If (Ano - (Resto * 4)) = 0 then TabDia[2] := 29
                             else TabDia[2] := 28;
end;

end.

