{$O+,F+}
Unit PlogResc;

Interface

Uses Crt,Dos,PlogGlbs,PlogBasp,PlogTree,PlogFunc,PlogCalc,PlogRpt0;

   Procedure QueRecibo(X : Char);
   Procedure Rescisao;

Implementation

Var
  AvP           : Char;


Function Meses(D1d,D1m,D1a,D2d,D2m,D2a : Str2): Integer;
Var
 D1,M1,A1,D2,M2,A2   : Integer;
 ND1,ND2             : Real;
begin
  Val(D1d,D1,E);
  Val(D1m,M1,E);
  Val(D1a,A1,E);
  Val(D2d,D2,E);
  Val(D2m,M2,E);
  Val(D2a,A2,E);
  ND1 := (A1 * 365) + (M1 * 30);
  ND2 := (A2 * 365) + (M2 * 30) + D2;
  M1  := Trunc(ND2 - ND1);
  M2  := Trunc(M1 / 30);
  If D1 > 14 then Meses := M2 - 1;
  If D2 < 15 then Meses := M2 - 1;
  Meses := M2;
end;


Procedure AcertaMeses;
Var
  Mr      : Integer;
begin
  Val(EEMember.MMResc,Mr,E);
  Val(EEMember.DDResc,DiasT,E);
  If (DiasT > 30) or (DiasT = TabDia[Mr]) then DiasT := 30;
  If EEMember.AAAdm < EEMember.AAResc then
     begin
       EEMember.MesesT := Meses('01','01',EEMember.AAResc,
                                EEMember.DDResc,EEMember.MMResc,EEMember.AAResc);
     end
     else EEMember.MesesT := Meses(EEMember.DDAdm,EEMember.MMAdm,EEMember.AAAdm,
                                   EEMember.DDResc,EEMember.MMResc,EEMember.AAResc);
  If EEMember.AAPAq < EEMember.AAResc then
     begin
       Val(EEMember.AAResc,I,E);
       I := I - 1;
       EEMember.MesesF := Meses(EEMember.DDPAq,EEMember.MMPAq,QQStr(I,2,'0'),
                                EEMember.DDResc,EEMember.MMResc,EEMember.AAResc);
       If EEMember.MesesF > 12 then EEMember.MesesF := EEMember.MesesF - 12;
     end
     else EEMember.MesesF := Meses(EEMember.DDPAq,EEMember.MMPAq,EEMember.AAPAq,
                                   EEMember.DDResc,EEMember.MMResc,EEMember.AAResc);
  If Avp = 'I' then
     begin
       EEMember.MesesF := EEMember.MesesF + 1;
       If EEMember.MesesF > 12 then
          begin
            EEMember.MesesF := 12;
            EEMember.PeriodoV := EEMember.PeriodoV + 1;
          end;
       EEMember.MesesT := EEMember.MesesT + 1;
       If EEMember.MesesT > 12 then EEMember.MesesT := 12;
     end;
  GotoXY(45,17); Write(EEMember.MesesF:2,'/12');
  GotoXY(12,18); Write(EEMember.MesesT:2,'/12');
end;


Procedure PedeCadastroD;
begin
  Repeat
    K := 01;
    Repeat
      Case K of
           01 : begin
                  Move(Mem[$B800:0000],ScArray6[1],4000);
                  DrawBox(35,11,57,20,Red,'S');
                  Color(Red,Cyan);
                  GotoXY(36,12); Write(' DemissÆo Espontƒnea ');
                  GotoXY(36,13); Write(' Demitido            ');
                  GotoXY(36,14); Write(' Justa Causa         ');
                  GotoXY(36,15); Write(' T‚rm.de Contrato(E) ');
                  GotoXY(36,16); Write(' T‚rm.de Contrato(F) ');
                  GotoXY(36,17); Write(' Aposentado          ');
                  GotoXY(36,18); Write(' Transferˆncia       ');
                  GotoXY(36,19); Write(' Morte               ');
                  Color(Red,White);
                  GotoXY(48,12); Write('p');
                  GotoXY(37,13); Write('D');
                  GotoXY(37,14); Write('J');
                  GotoXY(53,15); Write('E');
                  GotoXY(53,16); Write('F');
                  GotoXY(39,17); Write('o');
                  GotoXY(37,18); Write('T');
                  GotoXY(37,19); Write('M');
                  J := EEMember.Status;
                  InputStr(J,1,12,14,0,'S','N','T','N',Tfn,Utx);
                  Move(ScArray6[1],Mem[$B800:0000],4000);
                  EEMember.Status := UpCase(J[1]);
                  If TC <> #27 then
                     begin
                       GotoXY(12,14);
                       Case EEMember.Status of
                            'P' : Write('DemissÆo Espontƒnea');
                            'D' : Write('Demitido           ');
                            'J' : Write('Justa Causa        ');
                            'E' : Write('T‚rm.de Contrato(E)');
                            'F' : Write('T‚rm.de Contrato(F)');
                            'O' : Write('Aposentado         ');
                            'T' : Write('Transferˆncia      ');
                            'M' : Write('Morte              ');
                            else begin
                                   ErroMsg := 'Informe P,D,J,E,F,O,T ou M';
                                   ErrorMessage;
                                   K := K - 1;
                                 end;
                       end;
                       Case EEMember.Status of
                            'D' : EEMember.Motivo := 'Dispensa S/J.Causa';
                            'J' : EEMember.Motivo := 'Dispensa por J.Causa';
                            'M' : EEMember.Motivo := 'Morte';
                            'E' : EEMember.Motivo := 'Term.de Contrato(E)';
                            'F' : EEMember.Motivo := 'Term.de Contrato(F)';
                            'O' : EEMember.Motivo := 'Aposentadoria';
                            'P' : EEMember.Motivo := 'Pediu demissÆo';
                            'T' : EEMember.Motivo := 'Transferencia';
                            else  EEMember.Motivo := '';
                       end;
                       GotoXY(12,19); Write(PushLeft(28,EEMember.Motivo));
                     end;
                end;
           02 : begin
                  Move(Mem[$B800:0000],ScArray6[1],4000);
                  DrawBox(35,15,46,19,Red,'S');
                  Color(Red,Cyan);
                  GotoXY(36,16); Write('Indenizado');
                  GotoXY(36,17); Write('Trabalhado');
                  GotoXY(36,18); Write('NÆo tem   ');
                  Color(Red,White);
                  GotoXY(36,16); Write('I');
                  GotoXY(36,17); Write('T');
                  GotoXY(36,18); Write('N');
                  Color(Tfn,Utx);
                  GotoXY(12,15); Write(ConstStr(' ',15));
                  J := '';
                  InputStr(J,1,12,15,0,'S','N','T','N',Tfn,Utx);
                  Move(ScArray6[1],Mem[$B800:0000],4000);
                  If TC <> #27 then
                     begin
                       If J = '' then AvP := 'N'
                                 else AvP := UpCase(J[1]);
                       GotoXY(12,15);
                       Case Avp of
                            'I' : Write('Indenizado');
                            'N' : begin
                                    Write('NÆo       ');
                                    EEMember.DataAvp := '';
                                  end;
                            'T' : Write('Trabalhado');
                            else  K := K - 1;
                       end;
                     end;
                end;
           03 : If Avp in ['I','T'] then
                   begin
                     Color(Tfn,Ttx);
                     GotoXY(37,15); Write('D.AvP.:');
                     J := EEMember.DataAvP;
                     InputStr(J,10,45,15,0,'S','N','T','N',Tfn,Utx);
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
                                    EEMember.DataAvP := J;
                                    GotoXY(45,15); Write(J,' ',DiaSemana(J));
                                  end;
                        end;
                   end
                   else begin
                          GotoXY(37,15); Write(ConstStr(' ',21));
                        end;
           04 : begin
                  If EEMember.DDResc = '' then J := ''
                                          else J := EEMember.DDResc + '/' +
                                                    EEMember.MMResc + '/' +
                                                    EEMember.AAResc;
                  InputStr(J,10,12,16,0,'S','N','D','S',Tfn,Utx);
                  If TC <> #27 then
                     begin
                       EEMember.DDResc := Copy(J,1,2);
                       EEMember.MMResc := Copy(J,4,2);
                       EEMember.AAResc := Copy(J,7,4);
                       GotoXY(23,16); Write(DiaSemana(J));
                       AcertaMeses;
                     end;
                end;
           05 : begin
                  If DiasT = 0 then J := ''
                     else begin
                            Str(DiasT:2,J);
                            J := LeftAdjust(J);
                          end;
                  InputStr(J,2,45,16,0,'S','N','T','N',Tfn,Utx);
                  If TC <> #27 then
                     begin
                       Val(J,DiasT,E);
                       GotoXY(45,16); Write(DiasT:2);
                     end;
                end;
           06 : begin
                  If EEMember.PeriodoV = 0 then J := ''
                     else begin
                            Str(EEMember.PeriodoV:2,J);
                            J := LeftAdjust(J);
                          end;
                  Color(Tfn,Utx);
                  GotoXY(12,17); Write('       ');
                  InputStr(J,1,12,17,0,'S','N','T','N',Tfn,Utx);
                  If TC <> #27 then
                     begin
                       Val(J,EEMember.PeriodoV,E);
                       GotoXY(12,17);
                       If EEMember.PeriodoV = 0
                          then Write('NÆo tem')
                          else Write(EEMember.PeriodoV:2);
                     end;
                end;
           07 : begin
                  If EEMember.MesesF = 0 then J := ''
                     else begin
                            Str(EEMember.MesesF:2,J);
                            J := LeftAdjust(J);
                          end;
                  InputStr(J,2,45,17,0,'S','N','T','N',Tfn,Utx);
                  If TC <> #27 then
                     begin
                       Val(J,EEMember.MesesF,E);
                       GotoXY(45,17); Write(EEMember.MesesF:2,'/12');
                     end;
                end;
           08 : begin
                  If EEMember.MesesT = 0 then J := ''
                     else begin
                            Str(EEMember.MesesT:2,J);
                            J := LeftAdjust(J);
                          end;
                  InputStr(J,2,12,18,0,'S','N','T','N',Tfn,Utx);
                  If TC <> #27 then
                     begin
                       Val(J,EEMember.MesesT,E);
                       GotoXY(12,18); Write(EEMember.MesesT:2,'/12');
                     end;
                end;
           09 : begin
                  J := EEMember.Motivo;
                  InputStr(J,25,12,19,0,'S','N','T','N',Tfn,Utx);
                  EEMember.Motivo := J;
                  GotoXY(12,19); Write(PushLeft(26,EEMember.Motivo));
                end;
           10 : begin
                  J := EEMember.CodSaque;
                  InputStr(J,2,12,20,0,'S','N','T','N',Tfn,Utx);
                  EEMember.CodSaque := J;
                  GotoXY(12,20); Write(EEMember.CodSaque);
                end;
           11 : begin
                     J := EEMember.DataHomo;
                     InputStr(J,10,12,21,0,'S','N','T','S',Tfn,Utx);
                     If (TC <> #27) and (J <> '') then
                        begin
                          J := ChkData(J);
                          If J = '' then
                             begin
                               ErroMsg := 'Data Inv lida';
                               ErrorMessage;
                               K := K - 1;
                             end
                             else begin
                                    EEMember.DataHomo := J;
                                    GotoXY(12,21); Write(EEMember.DataHomo);
                                  end;
                        end;
                end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 12) or (TC = #27);
    If TC <> #27 then Confirma;
  Until TC in [#27,'S'];
  If TC = 'S' then
     begin
       if EEMember.Status in ['E','F'] then EEMember.Status := 'N';
       Case EEMember.Status of
          'D' : EEMember.Causa := '11';
          'J' : EEMember.Causa := '10';
          'P' : EEMember.Causa := '21';
          'O' : EEMember.Causa := '72';
          'T' : EEMember.Causa := '30';
          'M' : EEMember.Causa := '60';
          'N' : EEMember.Causa := '12';
       end;
     end;
end;


Procedure Recibo(Y : Integer);
Var
  MaiorR    : Real;
  Mov       : Array[1..20] of AnyStr;
begin
  BBNo := LimpaChave(EEMember.BcoFgts);
  SearchTree7 ( Root7 );
  If RC = 'S' then ReadWrite(#06,'R','N',BBNumber);
  YYNo := 'R00';
  SearchTreeY ( RootY );
  If RC = 'S' then MaiorR := YAddress^.AcMensalV
              else MaiorR := 0;
  For I := 1 to 20 do Mov[I] := '';
  R1   := 0;
  R2   := 0;
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
              If (CCMember.Operacao   = 'P') and
                 (CCMember.Tipo       = 'P') and
                 (YAddress^.AcMensalV > 0  ) and
                 (YYNo[1]             = 'R') then
                 begin
                   I := I + 1;
                   Mov[I] := Acentua(CCMember.Descricao)+
                             ConstStr(' ',31-Length(CCMember.Descricao))+
                             PushRight(5,YAddress^.QtdResc)+' '+
                             PushRight(15,EditReal(YAddress^.AcMensalV));
                   R1 := R1 + YAddress^.AcMensalV;
                 end;
            end
            else RC := 'S';
       end;
  Until RC = 'N';
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
              If (CCMember.Operacao   = 'P') and
                 (CCMember.Tipo       = 'D') and
                 (YAddress^.AcMensalV > 0  ) and
                 (YYNo[1]             = 'R') then
                 begin
                   I := I + 1;
                   Mov[I] := Mov[I] + ConstStr(' ',20) +
                             Acentua(CCMember.Descricao)+
                             ConstStr(' ',31-Length(CCMember.Descricao))+
                             PushRight(5,YAddress^.QtdResc)+' '+
                             PushRight(15,EditReal(YAddress^.AcMensalV));
                   R2 := R2 + YAddress^.AcMensalV;
                 end;
            end
            else RC := 'S';
       end;
  Until RC = 'N';
  YYNo := 'R70';
  SearchTreeY ( RootY );
  If RC = 'S' then Valor := YAddress^.AcMensalV
              else Valor := 0;
  For R := 1 to Y do
  begin
    If Laser in ['D','L']
       then WriteLine('W',LaserInit)
       else If I > 1
               then If Laser = 'N' then WriteLine('W',Qp)
                       else If Laser = 'X' then WriteLine('L',Qp);
    WriteLine('L',ConstStr(' ',20)+Nx+Acentua('TERMO DE RESCISAO DE CONTRATO DE TRABALHO')+Nf);
    WriteLine('L',Cx+ConstStr('_',124)+Cf);
    WriteLine('L',Cx+'Empregador'+Cf+ConstStr(' ',51)+Cx+' Carimbo padronizado do CGC'+Cf);
    WriteLine('L',Acentua(CMstMember.Descricao));
    WriteLine('L',Cx+Acentua('Enderˆ‡o')+Cf);
    WriteLine('L',Acentua(CMstMember.Endereco)+', '+
                  CMstMember.Numero+' '+CMstMember.Complemento);
    WriteLine('L',Cx+'Cep'+Cf+ConstStr(' ',8)+Cx+
                  ' Bairro'+Cf+ConstStr(' ',17)+Cx+
                  Acentua('Munic¡pio ')+Cf+ConstStr(' ',17)+Cx+' UF'+Cf);
    WriteLine('L',PushLeft(10,CMstMember.Cep)+
                  Acentua(CMstMember.Bairro)+
                  ConstStr(' ',21-Length(CMstMember.Bairro))+
                  Acentua(CMstMember.Municipio)+
                  ConstStr(' ',23-Length(CMstMember.Municipio))+
                  CMstMember.Estado);
    WriteLine('L',Cx+'Banco'+Cf);
    WriteLine('L',Acentua(BBMember.NomeBanco));
    WriteLine('L',Cx+Acentua('Agˆncia')+Cf);
    WriteLine('L',Acentua(BBMember.NomeAgencia));
    WriteLine('L',Cx+'Empregado '+Cf+ConstStr(' ',36)+Cx+PushLeft(10,'N.CTPS')+
                  Acentua('S‚rie')+ConstStr(' ',6)+'UF'+Cf);
    WriteLine('L',Acentua(EEMember.Nome)+
                  ConstStr(' ',42-Length(EEMember.Nome))+
                  PushLeft(11,EEMember.CTrabN)+
                  PushLeft(7,EEMember.CTrabS)+EEMember.CTrabE+
                  ConstStr(' ',1)+Cx+ConstStr('_',26)+Cf);
    WriteLine('L',Cx+'PIS/PASEP   '+Cf+ConstStr(' ',5)+Cx+
                  'Conta do FGTS'+Cf+ConstStr(' ',8)+Cx+
                  ' Dt.Nascimento '+Cf+ConstStr(' ',3)+Cx+
                  Acentua('Dt.Admiss„o ')+Cf+ConstStr(' ',4)+Cx+
                  Acentua('Dt.Op‡„o FGTS')+Cf+ConstStr(' ',3)+Cx+
                  'Dt.Afastamento'+Cf);
    WriteLine('L',PushLeft(12,EEMember.PisPasep)+
                  PushLeft(16,EEMember.ContaFgts)+
                  EEMember.DDNasc+'/'+EEMember.MMNAsc+'/'+EEMember.AANAsc+
                  ConstStr(' ',1)+
                  EEMember.DDAdm+'/'+EEMember.MMAdm+'/'+EEMember.AAAdm+
                  ConstStr(' ',1)+PushLeft(11,EEMember.DataOpcao)+
                  EEMember.DDResc+'/'+EEMember.MMResc+'/'+EEMember.AAResc);
    WriteLine('L',Cx+Acentua('Maior Remunera‡„o')+Cf+ConstStr(' ',5)+Cx+
                  Acentua('Aviso Pr‚vio ')+Cf+ConstStr(' ',3)+Cx+
                  'Pens.Alimento  '+Cf+ConstStr(' ',3)+Cx+
                  'Causa do Afastamento'+Cf+ConstStr(' ',15)+Cx+
                  'Cod.Saque'+Cf);
    WriteLine('L',PushLeft(15,EditReal(MaiorR))+
                  PushLeft(22,EEMember.DataAvP)+
                  Acentua(EEMember.Motivo)+ConstStr(' ',27-Length(EEMember.Motivo))+EEMember.CodSaque);
    WriteLine('L',Cx+'Proventos '+ConstStr('_',45)+' DEMOSTRATIVO '+
                  ConstStr('_',45)+' Descontos'+Cf);
    WriteLine('L',Cx+Acentua('Descri‡„o')+ConstStr(' ',22)+'Quant'+
                  ConstStr(' ',11)+'Valor'+ConstStr(' ',20)+
                  Acentua('Descri‡„o')+ConstStr(' ',22)+'Quant'+
                  ConstStr(' ',11)+'Valor'+Cf);
    WriteLine('L',Cx+ConstStr('_',124)+Cf);
    For I := 1 to 20 do If Mov[I] <> ''
                           then WriteLine('L',Cx+Mov[I]+Cf)
                           else WriteLine('L',' ');
    WriteLine('L',Cx+PushLeft(37,'Total dos proventos')+
                     PushRight(15,EditReal(R1))+
                     ConstStr(' ',20)+PushLeft(37,'Total dos Descontos')+
                     PushRight(15,EditReal(R2))+Cf);
    WriteLine('L',Cx+ConstStr(' ',72)+Acentua('L¡quido')+
                  ConstStr(' ',30)+PushRight(15,EditReal(Valor))+Cf);
    WriteLine('L',Cx+ConstStr(' ',72)+ConstStr('_',52)+Cf);
    WriteLine('L',Cx+Acentua('Data Homologa‡„o')+ConstStr(' ',10)+
                     'Carimbo e assinatura do empregador/preposto'+
                     ConstStr(' ',10)+Acentua('Impress„o digital')+
                     ConstStr(' ',11)+Acentua('Impress„o digital')+Cf);
    WriteLine('L',PushLeft(10,EEMember.DataHomo)+
                  Cx+ConstStr(' ',62)+Acentua('do empregado     ')+
                  ConstStr(' ',11)+Acentua('respons vel legal')+Cf);
    WriteLine('L',' ');
    WriteLine('L',Cx+Acentua('Assinatura do empregado')+
                     ConstStr(' ',12)+Acentua('Assinatura do respons vel legal')+Cf);
    WriteLine('L',' ');
    WriteLine('L',' ');
    WriteLine('L',Cx+'RECIBO DO FGTS  Carimbo e assinatura autorizada da Empresa'+
                  ConstStr(' ',17)+Acentua('Data da recep‡„o pelo Banco')+Cf);
    WriteLine('L',' ');
    WriteLine('L',' ');
    WriteLine('L',Cx+'Sacador-Nome'+ConstStr(' ',63)+
                  Acentua('Carimbo da Agˆncia (Norma CSA/CIEF-47/74)')+Cf);
    WriteLine('L',Acentua(EEMember.Nome));
    WriteLine('L',Cx+Acentua('Valor saque-dep¢sitos')+
                  ConstStr(' ',14)+Acentua('Juros e Corre‡„o Monet ria')+
                  ConstStr(' ',14)+Acentua('Total do Saque')+Cf);
    WriteLine('L',' ');
    WriteLine('L',Cx+Acentua('Impress„o digital    ')+ConstStr(' ',14)+
                  Acentua('Impress„o digital         ')+
                  ConstStr(' ',14)+'Assinatura do Sacador  '+
                  Acentua('Assinatura do respons vel ')+Cf);
    WriteLine('L',Cx+'do Sacador           '+
                  ConstStr(' ',14)+Acentua('respons vel legal')+Cf);
  end;
  If DskRpt = 'N' then WriteLine('W',Qp);
end;


Procedure PegaConta(X   : Str3   ;
                    L,C : Integer;
                    Vl  : Real   ;
                    Q   : Str5);
begin
  GotoXY(C+17,L); Write(Q);
  YYNo := X;
  SearchTreeY ( RootY );
  If RC = 'N' then
     begin
       LoadTreeY ( RootY );
       YAddress^.Origem := 'S';
     end;
  If YAddress^.AcMensalV = 0 then
     begin
       If Vl > 0 then
          begin
            Str(Vl:16:2,J);
            J := LeftAdjust(J);
          end
          else J := ''
     end
     else begin
            Str(YAddress^.AcMensalV:16:2,J);
            J := LeftAdjust(J);
          end;
  InputStr(J,16,C,L,0,'S','N','$','N',Sfn,Stx);
  If TC <> #27 then Val(J,YAddress^.AcMensalV,E);
  YAddress^.QtdResc := Q;
end;

Procedure CalculaInsaPeri;
begin
  VPeri := 0;
  For I := 1 to 5 do
  Case EEMember.Peric[I] of
       'B' : VPeri := VPeri + (SalBase  * TTMember.Peri[I]) / 100;
       'S' : VPeri := VPeri + (TTMember.SalMinimo * TTMember.Peri[I]) / 100;
  end;
  VPeri := (VPeri / 30) * DiasT;
  VInsa := 0;
  For I := 1 to 5 do
  Case EEMember.Insalub[I] of
       'B' : VInsa := VInsa + (SalBase * TTMember.Insa[I]) / 100;
       'S' : VInsa := VInsa + (TTMember.SalMinimo * TTMember.Insa[I]) / 100;
  end;
  VInsa := (VInsa / 30) * DiasT;
end;

Procedure RecebeValores;
Var
  Qtr              : Str5;
  OutrosP,OutrosD  : Real;
begin
  Move(Mem[$B800:0000],ScArray6[1],4000);
  DrawBox(02,05,77,21,Sfn,'S');
  Color(Bfn,Btx);
  GotoXY(02,05); Write(ConstStr(' ',76));
  GotoXY(03,05); Write(PushLeft(41,EEMember.Nome),'[Status = ',EEMember.Status,']',
                       ConstStr(' ',1),'C lculo da RescisÆo');
  Color(Sfn,Stx);
  GotoXY(03,06); Write('R00-Maior Remun');
  GotoXY(03,07); Write('R01-Indeniza‡Æo');
  GotoXY(03,08); Case Avp of
                      'I' : Write('R02-Av.Pr‚vio I');
                      'T' : Write('R03-Av.Pr‚vio T');
                      else  Write('               ');
                 end;
  GotoXY(03,09); Write('R04-13§ Sal rio');
  GotoXY(03,10); Case Avp of
                      'I' : Write('R05-13§ Sal.Ind');
                      else  Write('               ');
                 end;
  GotoXY(03,11); Write('R06-Sal.Fam¡lia');
  GotoXY(03,12); Write('R07-F‚rias Venc');
  GotoXY(03,13); Write('R08-F‚rias Prop');
  GotoXY(03,14); Write('R09-1/3 Sal rio');
  GotoXY(03,15); Write('R10-Sal.Matern.');
  GotoXY(03,16); Write('R11-Saldo Sal..');
  GotoXY(03,17); Write('R12-Comiss”es..');
  GotoXY(03,18); Write('R13-Horas Extr.');
  GotoXY(03,19); Write('R14-Gratifica‡.');
  GotoXY(03,20); Write('R15-Insa/Peric.');
  GotoXY(03,21); Write('R16-Adic.Notur.');
  GotoXY(42,06); Write('R17 a R27......');
  Color(Tfn,Utx);
  GotoXY(42,07); Write('R49-Total Prov.                 ');
  Color(Tfn,Utx);
  GotoXY(42,11); Write('Descontos                       ');
  Color(Sfn,Stx);
  GotoXY(42,12); Write('R50-Previdˆncia');
  GotoXY(42,13); Write('R51-Prev.13§Sal');
  GotoXY(42,14); Write('R52-Adiantament');
  GotoXY(42,15); Write('R53-IR.s/Ferias');
  GotoXY(42,16); Write('R54-I.Renda....');
  GotoXY(42,17); Write('R55-IR.s/13§Sal');
  GotoXY(42,18); Write('R56 a R66......');
  Color(Tfn,Utx);
  GotoXY(42,19); Write('R69-Total  Desc                 ');
  Color(Red,Yellow);
  GotoXY(42,21); Write('R70-L¡quido....                 ');
  Color(Sfn,Stx);
  CalculaInsaPeri;
  Repeat
    K := 6;
    Repeat
      Case K of
           6      : begin
                      PegaConta('R00',K,19,SalBase+VInsa+VPeri,'');
                      SalBase := YAddress^.AcMensalV;
                    end;
           7      : begin
                      YYNo := 'R01';
                      SearchTreeY ( RootY );
                      If RC = 'N' then LoadTreeY ( RootY );
                      YAddress^.Origem := 'S';
                      Qtr := YAddress^.QtdResc;
                      PegaConta('R01',K,19,0,Qtr);
                      J := YAddress^.QtdResc;
                      InputStr(J,3,36,K,0,'S','N','T','N',Sfn,Stx);
                      YAddress^.QtdResc := J;
                    end;
           8      : Case AvP of
                         'I' : begin
                                 YYNo := 'R03';
                                 SearchTreeY ( RootY );
                                 If RC = 'N' then LoadTreeY ( RootY );
                                 YAddress^.Origem    := 'S';
                                 YAddress^.AcMensalV := 0;
                                 PegaConta('R02',K,19,SalBase,'');
                               end;
                         'N' : begin
                                 YYNo := 'R02';
                                 SearchTreeY ( RootY );
                                 If RC = 'N' then LoadTreeY ( RootY );
                                 YAddress^.Origem    := 'S';
                                 YAddress^.AcMensalV := 0;
                                 YYNo := 'R03';
                                 SearchTreeY ( RootY );
                                 If RC = 'N' then LoadTreeY ( RootY );
                                 YAddress^.Origem    := 'S';
                                 YAddress^.AcMensalV := 0;
                               end;
                         'T' : begin
                                 YYNo := 'R02';
                                 SearchTreeY ( RootY );
                                 If RC = 'N' then LoadTreeY ( RootY );
                                 YAddress^.Origem    := 'S';
                                 YAddress^.AcMensalV := 0;
                                 PegaConta('R03',K,19,SalBase,'');
                               end;
                    end;
           9      : begin
                      If EEMember.MesesT > 0 then
                         begin
                           YYNo := '004';
                           SearchTreeY ( RootY );
                           If (RC = 'S') and (YAddress^.AcAnualV > 0)
                              then R2 := YAddress^.AcAnualV
                              else R2 := 0;
                           R1  := ((SalBase / 12) * EEMember.MesesT) - R2;
                           Qtr := QQStr(EEMember.MesesT,2,'0') + '/12';
                         end
                         else begin
                                Qtr := '';
                                R1  := 0;
                              end;
                      PegaConta('R04',K,19,R1,Qtr);
                    end;
           10     : If Avp = 'I' then PegaConta('R05',K,19,(SalBase / 12),'')
                                 else begin
                                        YYNo := 'R05';
                                        SearchTreeY ( RootY );
                                        If RC = 'N' then LoadTreeY ( RootY );
                                        YAddress^.Origem    := 'S';
                                        YAddress^.AcMensalV := 0;
                                      end;
           11     : begin
                      I := 0;
                      Repeat
                        I := I + 1;
                      Until SalBase <= TTMember.FaixaSF[I];
                      R1 := ((TTMember.ValorSF[I] * EEMember.DepSF)/30)*DiasT;
                      If R1 > 0 then Qtr := QQStr(DiasT,2,'0') + '/30'
                                else Qtr := '';
                      PegaConta('R06',K,19,R1,Qtr);
                    end;
           12     : begin
                      Case EEMember.PeriodoV of
                           0 : R1 := 0;
                           1 : R1 := SalBase;
                           2 : R1 := SalBase * 3;
                      end;
                      Qtr := QQStr(EEMember.PeriodoV,2,' ') + ' P.';
                      PegaConta('R07',K,19,R1,Qtr);
                    end;
           13     : begin
                      If EEMember.MesesF > 0 then Qtr := QQStr(EEMember.MesesF,2,'0') + '/12'
                                             else Qtr := '';
                      PegaConta('R08',K,19,((SalBase / 12) * EEMember.MesesF),Qtr);
                    end;
           14     : begin
                    {  YYNo := 'R07';
                      SearchTreeY ( RootY );
                      If (RC                  = 'S') and
                         (YAddress^.AcMensalV > 0  )
                         then R2 := YAddress^.AcMensalV / 3
                         else R2 := 0;
                     }
                      R1 := (SalBase / 36) * EEMember.MesesF;
                      Case EEMember.PeriodoV of
                           1 : R1 := R1 + (SalBase / 3);
                           2 : R1 := R1 + ((SalBase / 3) * 3);
                      end;
                      PegaConta('R09',K,19,R1,'');
                    end;
           15     : PegaConta('R10',K,19,0,'');
           16     : begin
                      Qtr := QQStr(DiasT,2,'0') + '/30';
                      PegaConta('R11',K,19,((SalBase / 30)*DiasT),Qtr);
                    end;
           17     : PegaConta('R12',K,19,0,'');
           18     : PegaConta('R13',K,19,0,'');
           19     : PegaConta('R14',K,19,0,'');
           20     : begin
                      CalculaInsaPeri;
                      PegaConta('R15',K,19,(VPeri + VInsa),'');
                    end;
           21     : begin
                      YYNo := '009';
                      SearchTreeY ( RootY );
                      If (RC                  = 'S') and
                         (YAddress^.AcMensalH > 0  ) or
                         (YAddress^.AcMensalM > 0  ) then
                         begin
                           Valor := SalBase / EEMember.HNormais;
                           R1 := (YAddress^.AcMensalH * Valor) +
                                 ((Valor / 60)  * YAddress^.AcMensalM);
                         end
                         else R1 := 0;
                      PegaConta('R16',K,19,R1,'');
                    end;
           22     : begin
                      ScrollMovto('R','P','R17','R27');
                      OutrosP := 0;
                      YYNo    := 'R16';
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
                                  If (RW                  = 'S'  ) and
                                     (CCMember.Tipo       = 'P'  ) and
                                     (YYNo               >= 'R17') and
                                     (YYNo               <= 'R27') and
                                     (YAddress^.AcMensalV >  0   ) then
                                     begin
                                       OutrosP := OutrosP + YAddress^.AcMensalV;
                                     end;
                                end
                                else RC := 'S';
                           end;
                      Until (RC = 'N') or (YYNo >= 'R27');
                      Color(Sfn,Stx);
                      GotoXY(58,6); Write(PushRight(16,EditReal(OutrosP)));
                      TC := #13;
                    end;
           23     : begin
                      TProv := 0;
                      YYNo  := '';
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
                                  If (RW            = 'S') and
                                     (YYNo[1]       = 'R') and
                                     (CCMember.Tipo = 'P')
                                     then TProv := TProv + TruncX(YAddress^.AcMensalV);
                                end
                                else RC := 'S';
                           end;
                      Until RC = 'N';
                      Color(Tfn,Utx);
                      GotoXY(58,K-16); Write(EditReal(TProv):16);
                      Color(Sfn,Stx);
                      YYNo := 'R49';
                      SearchTreeY ( RootY );
                      If RC = 'N' then LoadTreeY ( RootY );
                      YAddress^.Origem    := 'S';
                      YAddress^.AcMensalV := TProv;
                    end;
           24     : begin
                      VBases[2] := 0;
                      YYNo      := '';
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
                                  If (RW                = 'S') and
                                     (YYNo[1]           = 'R') and
                                     (CCMember.Operacao = 'P') and
                                     (CCMember.Bases[2] = 'S') then
                                     begin
                                       Valor := TruncX(YAddress^.AcMensalV);
                                       Case CCMember.Tipo of
                                            'P' : VBases[2] := VBases[2] + Valor;
                                            'D' : VBases[2] := VBases[2] - Valor;
                                       end;
                                     end;
                                end
                                else RC := 'S';
                           end;
                      Until RC = 'N';
                      R1 := 0;
                      R2 := 0;
                      I  := FaixaINSS(VBases[2]);
                      If VBases[2] > TTMember.TetoSalContr then
                         begin
                           R1 := TTMember.TetoSalContr * (TTMember.TaxaIapas[I]  / 100);
                           R2 := TTMember.TetoSalContr;
                         end
                         else begin
                                R1 := VBases[2] * (TTMember.TaxaIapas[I] /  100);
                                R2 := VBases[2];
                              end;
                      YYNo := 'R72';
                      SearchTreeY ( RootY );
                      If RC = 'N' then LoadTreeY ( RootY );
                      YAddress^.Origem    := 'S';
                      YAddress^.AcMensalV := VBases[2] * (TTMember.TaxaEIapas[I] / 100);
                      YYNo := 'R81';
                      SearchTreeY ( RootY );
                      If RC = 'N' then LoadTreeY ( RootY );
                      YAddress^.Origem    := 'S';
                      YAddress^.AcMensalV := VBases[2];
                      YYNo := 'R90';
                      SearchTreeY ( RootY );
                      If RC = 'N' then LoadTreeY ( RootY );
                      YAddress^.Origem    := 'S';
                      YAddress^.AcMensalV := R2;
                      PegaConta('R50',K-12,58,R1,'');
                    end;
           25     : begin
                      VBases[2] := 0;
                      YYNo      := '';
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
                                  If (RW                 = 'S'  ) and
                                     (YYNo[1]            = 'R'  ) and
                                     (CCMember.Operacao  = 'P'  ) then
                                     begin
                                       Valor := TruncX(YAddress^.AcMensalV);
                                       If CCMember.Bases[2] = '1' then
                                          Case CCMember.Tipo of
                                               'P' : VBases[2] := VBases[2] + Valor;
                                               'D' : VBases[2] := VBases[2] - Valor;
                                          end;
                                     end;
                                end
                                else RC := 'S';
                           end;
                      Until RC = 'N';
                      R1 := 0;
                      R2 := 0;
                      I  := FaixaINSS(VBases[2]);
                      If VBases[2] > TTMember.TetoSalContr then
                         begin
                           R1 := TTMember.TetoSalContr * (TTMember.TaxaIapas[I]  / 100);
                           R2 := TTMember.TetoSalContr;
                         end
                         else begin
                                R1 := VBases[2] * (TTMember.TaxaIapas[I] /  100);
                                R2 := VBases[2];
                              end;
                      YYNo := 'R71';
                      SearchTreeY ( RootY );
                      If RC = 'N' then LoadTreeY ( RootY );
                      YAddress^.Origem    := 'S';
                      YAddress^.AcMensalV := VBases[2] * (TTMember.TaxaEIapas[I] / 100);
                      YYNo := 'R85';
                      SearchTreeY ( RootY );
                      If RC = 'N' then LoadTreeY ( RootY );
                      YAddress^.Origem    := 'S';
                      YAddress^.AcMensalV := VBases[2];
                      YYNo := 'R91';
                      SearchTreeY ( RootY );
                      If RC = 'N' then LoadTreeY ( RootY );
                      YAddress^.Origem    := 'S';
                      YAddress^.AcMensalV := R2;
                      PegaConta('R51',K-12,58,R1,'');
                    end;
           26     : begin
                      R1   := 0;
                      YYNo := '052';
                      SearchTreeY ( RootY );
                      If RC = 'S' then R1 := YAddress^.AcMensalV;
                      PegaConta('R52',K-12,58,R1,'');
                    end;
           27     : begin
                      R1   := 0;
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
                                  If (RW                = 'S'   ) and
                                     (YYNo[1]           = 'R'   ) and
                                     (CCMember.Bases[1] = 'F'   ) then
                                     begin
                                       Valor := TruncX(YAddress^.AcMensalV);
                                       Case CCMember.Tipo of
                                            'P' : R1 := R1 + Valor;
                                            'D' : R1 := R1 - Valor;
                                       end;
                                     end;
                                end
                                else RC := 'S';
                           end;
                      Until RC = 'N';
                      YYNo := 'R50';
                      RC := 'N';
                      SearchTreeY ( RootY );
                      If RC = 'S' then
                         begin
                           CCNo := YYNo;
                           SearchTree1 ( Root1 );
                           If RC = 'S' then
                              begin
                                ReadWrite(#04,'R','N',CCNumber);
                                If (RW                = 'S'   ) and
                                   (CCMember.Bases[1] = 'S'   ) then
                                   begin
                                     Valor := TruncX(YAddress^.AcMensalV);
                                     Case CCMember.Tipo of
                                          'P' : R1 := R1 + Valor;
                                          'D' : R1 := R1 - Valor;
                                     end;
                                   end;
                              end;
                         end;
                      Valor := R1  - (TTMember.DependenteIR * EEMember.DepIR);
                      I     := FaixaIR(Valor);
                      VIR   := (Valor * (TTMember.TaxaIR[I] / 100)) -
                               TTMember.DeducaoIR[I];
                      If VIR < 0 then VIR := 0;
                      PegaConta('R53',K-12,58,VIR,'');
                    end;
           28     : begin
                      UserMacro('5');
                      VBases[1] := 0;
                      YYNo      := '';
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
                                  If (RW                = 'S'   ) and
                                     (YYNo[1]           = 'R'   ) and
                                     (CCMember.Bases[1] = 'S'   ) then
                                     begin
                                       Valor := TruncX(YAddress^.AcMensalV);
                                       Case CCMember.Tipo of
                                            'P' : VBases[1] := VBases[1] + Valor;
                                            'D' : VBases[1] := VBases[1] - Valor;
                                       end;
                                     end;
                                end
                                else RC := 'S';
                           end;
                      Until RC = 'N';
                      UserMacro('6');
                   {   Valor := VBases[1]  - (TTMember.DependenteIR * EEMember.DepIR); }
                      Valor := VBases[1]  - (MP202 + (TTMember.DependenteIR * EEMember.DepIR));
                      I     := FaixaIR(Valor);
                      VIR   := (Valor * (TTMember.TaxaIR[I] / 100)) -
                               TTMember.DeducaoIR[I];
                      If VIR < 0 then VIR := 0;
                      YYNo := 'R82';
                      SearchTreeY ( RootY );
                      If RC = 'N' then LoadTreeY ( RootY );
                      YAddress^.Origem    := 'S';
                      YAddress^.AcMensalV := VBases[1];
                      PegaConta('R54',K-12,58,VIR,'');
                    end;
           29     : begin
                      R1   := 0;
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
                                  If (RW                = 'S'   ) and
                                     (YYNo[1]           = 'R'   ) and
                                     (CCMember.Bases[1] = '1'   ) then
                                     begin
                                       Valor := TruncX(YAddress^.AcMensalV);
                                       Case CCMember.Tipo of
                                            'P' : R1 := R1 + Valor;
                                            'D' : R1 := R1 - Valor;
                                       end;
                                     end;
                                end
                                else RC := 'S';
                           end;
                      Until RC = 'N';
                {      Valor := R1  - (TTMember.DependenteIR * EEMember.DepIR);   }
                      Valor := R1  - (MP202 + (TTMember.DependenteIR * EEMember.DepIR));
                      I     := FaixaIR(Valor);
                      VIR   := (Valor * (TTMember.TaxaIR[I] / 100)) -
                               TTMember.DeducaoIR[I];
                      If VIR < 0 then VIR := 0;
                      PegaConta('R55',K-12,58,VIR,'');
                    end;
           30     : begin
                      ScrollMovto('R','D','R56','R66');
                      OutrosD := 0;
                      YYNo    := 'R55';
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
                                  If (RW                  = 'S'  ) and
                                     (CCMember.Tipo       = 'D'  ) and
                                     (YYNo               >= 'R56') and
                                     (YYNo               <= 'R66') and
                                     (YAddress^.AcMensalV >  0   ) then
                                     begin
                                       OutrosD := OutrosD + YAddress^.AcMensalV;
                                     end;
                                end
                                else RC := 'S';
                           end;
                      Until (RC = 'N') or (YYNo >= 'R66');
                      Color(Sfn,Stx);
                      GotoXY(58,18); Write(PushRight(16,EditReal(OutrosD)));
                      TC := #13;
                    end;
           31     : begin
                      TDesc := 0;
                      YYNo  := '';
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
                                  If (RW            = 'S') and
                                     (YYNo[1]       = 'R') and
                                     (CCMember.Tipo = 'D')
                                     then TDesc := TDesc + TruncX(YAddress^.AcMensalV);
                                end
                                else RC := 'S';
                           end;
                      Until RC = 'N';
                      Color(Tfn,Utx);
                      GotoXY(58,19); Write(EditReal(TDesc):16);
                      Color(Red,Yellow);
                      GotoXY(58,21); Write(EditReal(TProv-TDesc):16);
                      Color(Sfn,Stx);
                      YYNo := 'R69';
                      SearchTreeY ( RootY );
                      If RC = 'N' then LoadTreeY ( RootY );
                      YAddress^.Origem    := 'S';
                      YAddress^.AcMensalV := TDesc;
                      YYNo := 'R70';
                      SearchTreeY ( RootY );
                      If RC = 'N' then LoadTreeY ( RootY );
                      YAddress^.Origem    := 'S';
                      YAddress^.AcMensalV := TProv - TDesc;
                      TC := #13;
                    end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 6 then K := K - 1;
      end;
    Until (K = 32) or (TC = #27);
    If TC <> #27 then Confirma;
  Until TC in ['S',#27];
  Move(ScArray6[1],Mem[$B800:0000],4000);
  If TC = 'S' then
     begin
       YYNo  := '';
       Repeat
         RC := 'N';
         SearchPosY ( RootY );
         If (RC = 'S') and (YYNo[1] <> 'R') then YAddress^.AcMensalV := 0;
       Until RC = 'N';
     end;
end;


Procedure EmiteRecibo;
begin
  Color(Red,Cyan);
  GotoXY(1,24);  Write(ConstStr(' ',80));
  GotoXY(2,24);  Write('Informe o n£mero de c¢pias a serem impressas   (  a  ):      ');
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
       Recibo(I);
     end;
end;


Procedure QueRecibo(X : Char);
begin
  If X = 'I' then QPorta
             else TC := 'S';
  If TC <> #27 then
     begin
       Inicializa(DskRpt);
       Color(Blue,Cyan);
       GotoXY(1,23);  Write(ConstStr(' ',80));
       Color(Red,Cyan);
       GotoXY(1,24);  Write(ConstStr(' ',80));
       GotoXY(2,24);  Write('Papel Comum ou Pr‚-Impresso');
       Color(Red,White);
       GotoXY(08,24); Write('C');
       GotoXY(17,24); Write('P');
       Repeat
         TC := UpCase(ReadKey);
       Until TC in ['C','P',#27];
       Case TC of
            'C' : begin
                    EmiteRecibo;
                    If X = 'I' then Close ( LST );
                  end;
            'P' : begin
                    FormTest('S','T','RES');
                    If TC = 'S' then
                       begin
                         ImprimeTexto('S');
                         CloseTexto;
                       end;
                  end;
       end;
       If (DskRpt = 'T') and (TC <> #27) then ScrollRpt
                                         else Close ( LST );
     end;
end;


Procedure Rescisao;
begin
  EENo    := '';
  CheckUsrMacro;
  Repeat
    TProv    := 0;
    TDesc    := 0;
    Valor    := 0;
    RecebeCodigo(9,'C','N');
    If EENumber <> Limite then
       With EEMember do
       begin
         ReadWrite(#08,'R','N',EENumber);
         Color(Tfn,Ttx);
         GotoXY(04,09); Write('Matr¡c:');
         GotoXY(04,10); Write('Nome..:');
         GotoXY(04,11); Write('Cargo.:');
         GotoXY(04,12); Write('Admiss:');
         GotoXY(04,14); Write('Status:');
         GotoXY(04,15); Write('A.Pr‚v:');
         GotoXY(04,16); Write('Data..:');
         GotoXY(37,16); Write('D.Trab:');
         GotoXY(04,17); Write('F.Venc:');
         GotoXY(37,17); Write('F.Prop:');
         GotoXY(04,18); Write('13§Sal:');
         GotoXY(04,19); Write('Causa.:');
         GotoXY(04,20); Write('C.Saq.:');
         GotoXY(04,21); Write('D.Homo:');
         Color(Tfn,Utx);
         GotoXY(12,09); Write(PushLeft(9,EEMember.Matricula));
         GotoXY(12,10); Write(EEMember.Nome);
         GotoXY(12,11); Write(EEMember.Cargo);
         GotoXY(12,12); Write(EEMember.DDAdm,'/',EEMember.MMAdm,'/',EEMember.AAAdm);
         GotoXY(21,12); Write(DiaSemana(EEMember.DDAdm+'/'+EEMember.MMAdm+'/'+EEMember.AAAdm));
         PedeCadastroD;
         If TC = 'S' then
            begin
              LoadMVDsk(#11);
              If EEMember.Tipo = 'H'
                 then SalBase := EEMember.Salario * EEMember.HNormais
                 else SalBase := EEMember.Salario;
              YYNo := '016';
              SearchTreeY ( RootY );
              If RC = 'S' then
                 begin
                   If YAddress^.Origem = 'U' then
                      begin
                        If (YAddress^.PerctUsr <> 0  ) and
                           (YAddress^.BaseUsr  =  'S')
                           then Produt := TruncX((SalBase * YAddress^.PerctUsr)/100)
                           else Produt := 0;
                      end
                      else Produt := 0;
                 end
                 else Produt := 0;
              SalBase := TruncX(SalBase + Produt);
              YYNo    := 'R22';
              SearchTreeY ( RootY );
              If RC = 'S' then YAddress^.AcMensalV := 0;
              YYNo    := 'R56';
              SearchTreeY ( RootY );
              If RC = 'S' then YAddress^.AcMensalV := 0;
              YYNo    := 'R99';
              SearchTreeY ( RootY );
              If RC = 'S' then YAddress^.AcMensalV := 0;
              Move(Mem[$B800:0000],ScArray5[1],4000);
              RecebeValores;
              Move(ScArray5[1],Mem[$B800:0000],4000);
              Color(Tfn,Ttx);
              GotoXY(37,18); Write('T.Prov:');
              GotoXY(37,19); Write('T.Desc:');
              GotoXY(37,20); Write('        -------------');
              GotoXY(37,21); Write('L¡quid:');
              Color(Tfn,Utx);
              GotoXY(45,18); Write(EditReal(TProv):13);
              GotoXY(45,19); Write(EditReal(TDesc):13);
              GotoXY(45,21); Write(EditReal(TProv - TDesc):13);
              If TC = 'S' then
                 begin
                   Color(Blue,Cyan);
                   GotoXY(1,23);  Write(ConstStr(' ',80));
                   Color(Red,Cyan);
                   GotoXY(1,24);  Write(ConstStr(' ',80));
                   GotoXY(2,24);  Write('Quer emitir o recibo de RescisÆo?  im ou  Æo');
                   Color(Red,White);
                   GotoXY(36,24); Write('S');
                   GotoXY(43,24); Write('N');
                   Repeat
                     TC := UpCase(ReadKey);
                   Until TC in ['S','N',#27];
                   If TC = 'S' then QueRecibo('I');
                   YYNo := 'R99';
                   SearchTreeY ( RootY );
                   If RC = 'N' then LoadTreeY ( RootY );
                   YAddress^.Origem    := 'S';
                   YAddress^.AcMensalV := TruncX(TProv - TDesc);
                   UnLoadMVDsk;
                 end
                 else LiberaMVDsk;
            end;
         TC := #13;
         Move(ScArray4[1],Mem[$B800:0000],4000);
       end;
  Until TC = #27;
  CloseUsrMacro;
end;


end.

