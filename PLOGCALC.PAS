{$O+,F+}
Unit PlogCalc;

Interface

Uses Crt,Dos,PlogGlbs,PlogBasP,PlogTree;

   Function FaixaINSS(X : Real) : Integer;
   Function FaixaIR(X : Real) : Integer;

   Procedure RecuperaConta;

   Procedure ConverteHora(X : Str3);

   Procedure RecebeAdiantamento(X : Char);
   Procedure RecebePagamento   (X : Char);
   Procedure Recebe13Salario   (X : Char);
   Procedure Adiantamento      (X : Char);
   Procedure CheckUsrMacro;
   Procedure UserMacro(Tempo : Char);
   Procedure CloseUsrMacro;
   Procedure Pagamentos        (X : Char);
   Procedure D13Salario        (X : Char);

   Procedure SelecionaCalculo;


Implementation

Var
  TVtr         : Char;
  Tmp          : Array[1..10] of Real;
  TxtFile      : TEXT;
  TxtMacro     : Char;
  DifData      : Integer;
  ContrSind    : Real;

Function FaixaINSS(X : Real) : Integer;
Var
  I : Integer;
begin
  I := 0;
  Repeat
    I := I + 1;
  Until (X <= TTMember.FaixaIapas[I]) or (I = 10);
  FaixaINSS := I;
end;


Function FaixaIR(X : Real) : Integer;
Var
  I : Integer;
begin
  I := 0;
  Repeat
    I := I + 1;
  Until (X <= TTMember.FaixaIR[I]) or (I = 10);
  FaixaIR := I;
end;


Procedure RecuperaConta;
begin
  SearchTreeY ( RootY );
  If RC = 'N' then
     begin
       LoadTreeY ( RootY );
       YAddress^.Origem := 'S';
     end;
end;


Procedure ConverteHora(X : Str3);
Var
  Vtx     : Real;
begin
  Qx    := 'S';
  YYNo  := X;
  Repeat
    RC := 'N';
    If X = '' then SearchPosY ( RootY )
              else SearchTreeY ( RootY );
    If RC = 'S' then
       begin
         CCNo := YYNo;
         SearchTree1 ( Root1 );
         If RC = 'S' then
            begin
              ReadWrite(#04,'R','N',CCNumber);
              If CCMember.Operacao = Eta then
                 begin
                   If (CCNo            <> '009') and
                      (CCNo            <> '016') then
       {               (YAddress^.Origem = 'S'  ) then }
                      begin
                        If (YAddress^.AcMensalH > 0) or
                           (YAddress^.AcMensalM > 0) then
                           begin
                             Case CCMember.TxConv of
                                  '0' : If EEMember.HNormais > 0 then Vtx := VBases[10] / EEMember.HNormais
                                                                 else Vtx := VBases[10] / 220;
                                  '1' : Vtx := ValorHora1;
                                  '2' : Vtx := ValorHora2;
                                  '6'..'9'  : begin
                                                Val(CCMember.TxConv,I,E);
                                                If EEMember.HNormais > 0 then Vtx := VBases[I] / EEMember.HNormais
                                                                         else Vtx := VBases[I] / 220;
                                              end;
                                  else  Vtx := ValorHora1
                             end;
                             If Vtx > 0 then YAddress^.AcMensalV := (YAddress^.AcMensalH * Vtx) +
                                                                   ((Vtx / 60)  * YAddress^.AcMensalM);
                             If CCMember.Taxa > 0
                                then YAddress^.AcMensalV := YAddress^.AcMensalV *
                                                            CCMember.Taxa;
                             YAddress^.AcMensalV := TruncX(YAddress^.AcMensalV);
                           end
                           else If YAddress^.PerctUsr <> 0 then
                                   Case YAddress^.BaseUsr of
                                        'M' : YAddress^.AcMensalV := TruncX((TTMember.SalMinimo * YAddress^.PerctUsr) / 100);
                                        'S' : YAddress^.AcMensalV := TruncX(((SalBase + Produt) * YAddress^.PerctUsr) / 100);
                                   end;
                      end;
                 end;
            end
            else RC := 'S';
       end;
       If X <> '' then RC := 'N';
  Until RC = 'N';
end;


Procedure CalculoConta(X : Char);
Var
  I,Mult            : Integer;
  V1,V2,V3,H,M,Seis : Real;
  Oper,Adic         : Char;
begin
  Seis := 0;
  Mult := 1;
  DDNo := EEMember.Depto;
  SearchTree3 ( Root3 );
  If RC = 'S' then
     begin
       ReadWrite(#05,'R','N',DDNumber);
       If RW = 'S' then
          begin
            If X = 'A' then Mult := DDMember.DiasQ1
                       else If X = 'P' then Mult := DDMember.DiasQ2;
            Case EEMember.Tipo of
                 'H' : Seis := ((((EEMember.Salario * EEMember.HNormais) + Produt)/30)*Mult) * 0.06;
                 else  Seis := (((EEMember.Salario + Produt)/30)*Mult) * 0.06;
            end;
          end;
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
            begin
              ReadWrite(#04,'R','N',CCNumber);
              CCAC := YYNo;
              CCAN := CCNumber;
              For I := 1 to 2 do
              If CCMember.Resultado[I] <> '' then
                 begin
                   V1 := 0;
                   V2 := 0;
                   V3 := 0;
                   H  := 0;
                   M  := 0;
                   Case CCMember.Conteudo[I] of
                        'V' : V1 := YAddress^.AcMensalV;
                        '$' : V1 := YAddress^.AcAnualV;
                        'A' : begin
                                H  := YAddress^.AcAnualH;
                                M  := YAddress^.AcAnualM;
                                V1 := Trunc((H * 60) + M);
                              end;
                        'H' : begin
                                H  := YAddress^.AcMensalH;
                                M  := YAddress^.AcMensalM;
                                V1 := Trunc((H * 60) + M);
                              end;
                   end;
                   YYNo := CCMember.Resultado[I];
                   RecuperaConta;
                   If YAddress^.Origem = 'S' then
                      begin
                        Oper := CCMember.Operando[I][1];
                        Case Oper of
                             'D' : V2 := Mult;
                             'F' : V2 := EEMember.MesesF;
                             'M' : V2 := EEMember.MesesT;
                             'N' : begin
                                     Delete(CCMember.Operando[I],1,1);
                                     Val(CCMember.Operando[I],V2,E);
                                   end;
                             'P' : V2 := 144 / EEMember.MesesT;
                             'T' : begin
                                     V1 := V1 * Mult;
                                     If V1 > Seis then V1 := Seis;
                                     V2 := 1;
                                   end;
                        end;
                        Case CCMember.Operador[I] of
                             '+' : V3 := V1 + V2;
                             '-' : V3 := V1 - V2;
                             '*' : V3 := V1 * V2;
                             '/' : If V2 > 0 then V3 := V1 / V2
                                             else V3 := 0;
                        end;
                        Adic := CCMember.SubAdic[I];
                        Oper := CCMember.Conteudo[I];
                        YYNo := CCMember.Resultado[I];
                        CCNo := YYNo;
                        SearchTree1 ( Root1 );
                        If RC = 'S' then
                           begin
                             ReadWrite(#04,'R','N',CCNumber);
                             If CCMember.Operacao = X then
                                Case Adic of
                                     'A' : Case Oper of
                                                '$','V' : YAddress^.AcMensalV := TruncX(YAddress^.AcMensalV + V3);
                                                'A','H' : begin
                                                            H  := YAddress^.AcMensalH;
                                                            M  := YAddress^.AcMensalM;
                                                            V3 := V3 + Trunc((H * 60) + M);
                                                            Horas(V3);
                                                            YAddress^.AcMensalH := Hora;
                                                            YAddress^.AcMensalM := Minuto;
                                                            ConverteHora(YYNo);
                                                          end;
                                           end;
                                     'S' : Case Oper of
                                                '$','V' : YAddress^.AcMensalV := V3;
                                                'A','H' : If V3 > 0 then
                                                             begin
                                                               Horas(V3);
                                                               YAddress^.AcMensalH := Hora;
                                                               YAddress^.AcMensalM := Minuto;
                                                               ConverteHora(YYNo);
                                                             end;
                                           end;
                                end;
                           end;
                        ReadWrite(#04,'R','N',CCAN);
                      end;
                   YYNo := CCAC;
                   RecuperaConta;
                 end;
              YYNo := CCAC;
            end;
         RC := 'S';
       end;
  Until RC = 'N';
end;


Procedure CalculaBaseUsr(X : Integer);
begin
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
              If (RW                = 'S'  ) and
                 ((CCMember.Operacao = 'P')  or
                  (CCMember.Operacao = Eta)) then
                 begin
                   Valor := TruncX(YAddress^.AcMensalV);
                   Case CCMember.Tipo of
                        'D' : If CCMember.Bases[X] = 'S' then VBases[X] := VBases[X] - Valor;
                        'P' : If CCMember.Bases[X] = 'S' then VBases[X] := VBases[X] + Valor;
                   end;
                 end;
            end
            else RC := 'S';
       end;
  Until RC = 'N';
end;


Procedure ConverteBaseUsr(X : Integer);
begin
  Valor := VBases[X];
  Qx    := 'S';
  YYNo  := '';
  Repeat
    RC := 'N';
    SearchPosY ( RootY );
    If RC = 'S' then
       begin
         If YAddress^.BaseUsr = '0' then I := 10
                                    else Val(YAddress^.BaseUsr,I,E);
         If I =  X then
            begin
              CCNo := YYNo;
              SearchTree1 ( Root1 );
              If RC = 'S' then
                 begin
                   ReadWrite(#04,'R','N',CCNumber);
                   If (RW                = 'S') and
                      (CCMember.Operacao = Eta) then
                      begin
                        YAddress^.AcMensalV := (Valor * YAddress^.PerctUsr) / 100;
                        If Eta = 'S'
                           then YAddress^.AcMensalV := (YAddress^.AcMensalV / 12) *
                                                       EEMember.MesesT;
                      end;
                 end
                 else RC := 'S';
            end;
       end;
  Until RC = 'N';
end;


Procedure ProcessaBaseUsr;
begin
  For I := 1 to 10 do VBases[I] := 0;
  For K := 6 to 10 do begin
                        CalculaBaseUsr(K);
                        If VBases[K] <> 0 then ConverteBaseUsr(K);
                      end;
end;


Procedure CalculaBases;
begin
  VBases[2] := 0;
  VBases[3] := 0;
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
              If (RW                  = 'S'                     ) and
                 ((CCMember.Operacao  = Eta                   )   or
                  ((Eta               = 'P'                   )   and
                   (CCMember.Operacao in ['1','2','3','4','A'])   and
                   (CCNo              > '100'                 )   and
                   (CCNo              < 'R00'                 ))) then
                 begin
                   Valor := TruncX(YAddress^.AcMensalV);
                   If CCMember.Bases[2] in ['1','S'] then
                      Case CCMember.Tipo of
                           'P' : VBases[2] := VBases[2] + Valor;
                           'D' : VBases[2] := VBases[2] - Valor;
                           'O' : If (Eta            <> 'S'   ) and
                                    ((EEMember.MesI =  MM   )  and
                                     (CCNo          =  '088')) or
                                    ((EEMember.MesF =  MM   )  and
                                     (CCNo          =  '089')) or
                                    (CCNo           =  '095' )
                                    then VBases[2] := VBases[2] + Valor;
                      end;
                   If CCMember.Bases[3] = 'S' then
                      Case CCMember.Tipo of
                           'P' : VBases[3] := VBases[3] + Valor;
                           'D' : VBases[3] := VBases[3] - Valor;
                           'O' : If (Eta            <> 'S'   ) and
                                    ((EEMember.MesI =  MM   )  and
                                     (CCNo          =  '088')) or
                                    ((EEMember.MesF =  MM   )  and
                                     (CCNo          =  '089')) or
                                    (CCNo           =  '095' )
                                    then VBases[3] := VBases[3] + Valor;
                      end;
                 end;
            end
            else RC := 'S';
       end;
  Until RC = 'N';
  If Eta <> 'S' then
     begin
       If EEMember.Vinculo[1] in ['A','N'] then CCNo := '080'
                                           else CCNo := '081';
       YYNo := CCNo;
       RecuperaConta;
       YAddress^.AcMensalV := VBases[2];
       YAddress^.Origem    := 'S';
       YYNo := '083';
       RecuperaConta;
       YAddress^.AcMensalV := VBases[3];
       YAddress^.Origem    := 'S';
     end
     else begin
            YYNo := '085';
            RecuperaConta;
            YAddress^.AcMensalV := VBases[2];
            YAddress^.Origem    := 'S';
            YYNo := '087';
            RecuperaConta;
            YAddress^.AcMensalV := VBases[3];
            YAddress^.Origem    := 'S';
          end;
end;


Procedure CalculaBaseIR;
begin
  VBases[1] := 0;
  VBaseIRF  := 0;
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
              If (RW                  = 'S'                     ) and
                 ((CCMember.Operacao  = Eta                   )   or
                  ((Eta               = 'P'                   )   and
                   (CCMember.Operacao in ['1','2','3','4','A'])   and
                   (CCNo              > '100'                 ))) then
                 begin
                   Valor := TruncX(YAddress^.AcMensalV);
                   Case CCMember.Bases[1] of
                        '1','S' : Case CCMember.Tipo of
                                   'P' : VBases[1] := VBases[1] + Valor;
                                   'D' : VBases[1] := VBases[1] - Valor;
                                   'O' : If CCNo = '095'
                                            then VBases[1] := VBases[1] + Valor;
                                  end;
                        'F' : Case CCMember.Tipo of
                                   'P' : VBaseIRF := VBaseIRF + Valor;
                                   'D' : VBaseIRF := VBaseIRF - Valor;
                              end;
                   end;
                 end;
            end
            else RC := 'S';
       end;
  Until RC = 'N';
  If Eta <> 'S' then YYNo := '082'
                else YYNo := '086';
  RecuperaConta;
  If VBases[1] > 0 then YAddress^.AcMensalV := VBases[1]
                   else YAddress^.AcMensalV := 0;
  YAddress^.Origem    := 'S';
  YYNo := '084';
  RecuperaConta;
  If VBaseIRF > 0 then YAddress^.AcMensalV := VBaseIRF
                  else YAddress^.AcMensalV := 0;
  YAddress^.Origem    := 'S';
end;


Procedure SalarioFamilia;
begin
  YYNo := '003';
  RecuperaConta;
  If YAddress^.Origem = 'S' then
     begin
       I := 0;
       Repeat
         I := I + 1;
       Until VBases[2] <= TTMember.FaixaSF[I];
       YAddress^.AcMensalV := TruncX(TTMember.ValorSF[I] * EEMember.DepSF);
       If EEMember.Status <> 'F'
          then YAddress^.AcMensalV := (YAddress^.AcMensalV / 30) * DiasT;
     end;
  VSalFam := YAddress^.AcMensalV;
end;


Procedure CalculaFgts;
begin
  YYNo := '063';
  RecuperaConta;
  If YAddress^.Origem = 'S' then YAddress^.AcMensalV := TruncX(VBases[3] * 0.085);
  VFgts := YAddress^.AcMensalV;
end;


Procedure CalculaIapas;
Var
  Carne,Piso,Fixo,Busada   : Real;
begin
 { If EEMember.INSS[2] in ['A','C'] then
     begin
       YYNo  := '092';
       RecuperaConta;
       Piso  := YAddress^.AcMensalV;
       YYNo  := '093';
       RecuperaConta;
       Carne := YAddress^.AcMensalV;
     end; }
  VIapas := 0;
  Busada := 0;
  I      := FaixaINSS(VBases[2]);
  Case Eta of
       'S' : YYNo := '064';
       else  YYNo := '061';
  end;
  RecuperaConta;
  If YAddress^.Origem = 'S' then
     begin
{       If (EEMember.Vinculo[1] <> 'A') and
          (EEMember.Vinculo[1] <> 'N') and }
       If EEMember.Vinculo[1] <> 'C' then
          begin
            if EEMember.INSS[2] = 'S' then
            {     'A' ,'C' : begin
                         Busada := VBases[2];
                         If I < 4 then Fixo := Piso
                                  else Fixo := Carne;
                         YAddress^.AcMensalV := TruncX(VBases[2] * 0.15);
                         If YAddress^.AcMensalV > Fixo
                            then YAddress^.AcMensalV := Fixo;
                       end;}
               begin
                         If VBases[2] > TTMember.TetoSalContr then
                            begin
                              YAddress^.AcMensalV := TruncX(TTMember.TetoSalContr *
                                                     (TTMember.TaxaIapas[I]  / 100));
                              Busada := TTMember.TetoSalContr;
                            end
                            else begin
                                   YAddress^.AcMensalV := TruncX(VBases[2] * (TTMember.TaxaIapas[I] /  100));
                                   Busada := VBases[2];
                                 end;
               end
               else YAddress^.AcMensalV := 0;
           { end;}
          end
          else YAddress^.AcMensalV := 0;
     end;

{  If EEMember.Vinculo <> 'N' then }
     begin
       Case Eta of
            'S' : YYNo := '071';
            else  begin
                    VIapas := YAddress^.AcMensalV;
                    YYNo   := '062';
                  end;
       end;
       RecuperaConta;
       If YAddress^.Origem = 'S' then
          begin
            If EEMember.Vinculo <> 'C'
               then YAddress^.AcMensalV := TruncX(VBases[2] * (TTMember.TaxaEIapas[I] / 100))
               else begin
                      Fixo := TTMember.TxEInss[4] * 0.20;
                      YAddress^.AcMensalV := TruncX(VBases[2] * 0.15);
                      if Fixo < YAddress^.AcMensalV then YAddress^.AcMensalV := Fixo;
                    end;
          end;
       YYNo := '090';
       RecuperaConta;
       YAddress^.AcMensalV := Busada;
     end;
end;


Procedure CalculaIR(X : Char);
Var
  BaseI,VINSS   :  Real;
begin
  Case X of
       '1' : YYNo := '068';
       'F' : YYNo := '058';
       'S' : YYNo := '060';
  end;
  RecuperaConta;
  If YAddress^.Origem = 'S' then
     begin
       Case X of
            'F' : begin
                    VINSS := 0;
                    BaseI := 0;
                    YYNo := '088';
                    RecuperaConta;
                    BaseI := YAddress^.AcMensalV;
                    YYNo := '089';
                    RecuperaConta;
                    BaseI := BaseI + YAddress^.AcMensalV;
                    If (BaseI > 0) and (EEMember.INSS[2] = 'S') then
                       begin
                         I := FaixaINSS(BaseI);
                         If BaseI > TTMember.TetoSalContr
                            then VINSS := TTMember.TetoSalContr *
                                          (TTMember.TaxaIapas[I]  / 100)
                            else VINSS := BaseI * (TTMember.TaxaIapas[I] /  100);
                       end
                       else VINSS := 0;
            {*       Valor := VBaseIRF - (VINSS + (TTMember.DependenteIR * EEMember.DepIR));     }
                    Valor := VBaseIRF - (MP202 + VINSS + (TTMember.DependenteIR * EEMember.DepIR));
                    YYNo  := '058';
                    RecuperaConta;
                    I   := FaixaIR(Valor);
                    VIR := TruncX((Valor * (TTMember.TaxaIR[I] / 100)) - TTMember.DeducaoIR[I]);
                    If VIR > 0 then YAddress^.AcMensalV := VIR
                               else YAddress^.AcMensalV := 0;
                  end;
            else  begin
     {               Valor := VBases[1]  - (TTMember.DependenteIR * EEMember.DepIR);  }
                    Valor := VBases[1]  - (MP202 + (TTMember.DependenteIR * EEMember.DepIR));
                    I     := FaixaIR(Valor);
                    VIR   := TruncX((Valor * (TTMember.TaxaIR[I] / 100)) - TTMember.DeducaoIR[I]);
                    YAddress^.AcMensalV := VIR;
                  end;
       end;
       If YAddress^.AcMensalV <= 0 then YAddress^.AcMensalV := 0;
       Str(I:1,YAddress^.QtdResc);
     end;
  VIR := YAddress^.AcMensalV;
end;


Procedure DiferencaFerias;
Var
  NDias,NoMes          : Integer;
  VSal,VAtual,VAnt     : Real;
begin
  YYNo := '028';
  RecuperaConta;
  If YAddress^.Origem = 'S' then
     begin
       YAddress^.AcMensalV := 0;
       If EEMember.Tipo = 'H'
          then VSal := EEMember.Salario * EEMember.HNormais
          else VSal := EEMember.Salario;
       VSal := VSal + Produt;
       If EEMember.MesI = EEMember.MesF
          then NDias := EEMember.DiaF - EEMember.DiaI + 1
          else NDias := (TabDia[EEMember.MesI] - EEMember.DiaI) + EEMember.DiaF;
       If EEMember.MesI = MM then
          begin
            If ((NDias + EEMember.DiaI) - 1) < TabDia[EEMember.MesI]
               then NoMes := NDias
               else NoMes := (TabDia[EEMember.MesI] - EEMember.DiaI) + 1;
          end
          else If EEMember.MesF = MM then NoMes := EEMember.DiaF;
       Valor  := 0;
       VAnt   := 0;
       VAtual := 0;
       YYNo   := '019';
       RecuperaConta;
       If YAddress^.AcMensalV > 0 then Valor := YAddress^.AcMensalV
          else If YAddress^.AcAnualV > 0 then Valor := YAddress^.AcAnualV;
       If Valor > 0 then
          begin
            VAtual := VAtual + TruncX(((VSal / 30) * NDias));
            VAnt   := VAnt + Valor;
          end;
       Valor := 0;
       YYNo  := '020';
       RecuperaConta;
       If YAddress^.AcMensalV > 0 then Valor := YAddress^.AcMensalV
          else If YAddress^.AcAnualV > 0 then Valor := YAddress^.AcAnualV;
       If Valor > 0 then
          begin
            VAtual := VAtual + TruncX(VSal / 3);
            VAnt   := VAnt   + Valor;
          end;
       Valor := 0;
       YYNo  := '021';
       RecuperaConta;
       If YAddress^.AcMensalV > 0 then Valor := YAddress^.AcMensalV
          else If YAddress^.AcAnualV > 0 then Valor := YAddress^.AcAnualV;
       If Valor > 0 then
          begin
            VAtual := VAtual + TruncX(((VSal / 30) * NDias)/3);
            VAnt   := VAnt   + Valor;
          end;
       Valor := VAtual - VAnt;
       If Valor > 0 then
          begin
            YYNo := '028';
            RecuperaConta;
            YAddress^.AcMensalV := TruncX((Valor/30)*NoMes);
            If YAddress^.AcMensalV < 0 then YAddress^.AcMensalV := 0;
          end;
     end;
end;


Procedure CalculaSBase;
begin
  YYNo := '001';
  RecuperaConta;
  If YAddress^.Origem = 'S' then
     begin
       If EEMember.Tipo = 'H'
          then Valor := EEMember.Salario * EEMember.HNormais
          else Valor := EEMember.Salario;
       If (EEMember.Status in ['A','E','C','L','F']) and (Valor > 0) then
          begin
            If (EEMember.MesI = MM) or (EEMember.MesF = MM) then
               begin
                 If EEMember.MesI = MM
                    then YAddress^.AcMensalV := (Valor / 30) *
                                                (EEMember.DiaI - 1)
                    else YAddress^.AcMensalV := 0;
                 If (EEMember.MesF = MM) and
                    (EEMember.DiaF < 31)
                    then YAddress^.AcMensalV := YAddress^.AcMensalV +
                                                ((Valor / 30) *
                                                 (30 - EEMember.DiaF));
               end
               else YAddress^.AcMensalV := Valor;
          end
          else If (EEMember.Status  = 'V') and
                  (EEMember.DataAvp <> '') and
                  (Valor             > 0 ) then
                  begin
                    Val(Copy(EEMember.DataAvp,1,2),I,E);
                    YAddress^.AcMensalV := TruncX((Valor / 30) * I);
                  end
                  else YAddress^.AcMensalV := 0;
       If (AnoA                = AA) and
          (MesA                = MM) and
          (DiaA                > 01) and
          (YAddress^.AcMensalV > 0 )
          then YAddress^.AcMensalV := (YAddress^.AcMensalV/30) * (30-DiaA+1);
     end;
  YAddress^.AcMensalV := TruncX(YAddress^.AcMensalV);
  SalBase             := YAddress^.AcMensalV;
  If YAddress^.AcMensalV > 0 then
     begin
       Case EEMember.Tipo of
            'H' : begin
                    Valor := EEMember.Salario * EEMember.HNormais;
                    Valor := TruncX(Valor / 30);
                  end;
            else  Valor := TruncX(EEMember.Salario / 30);
       end;
       Valor := YAddress^.AcMensalV / Valor;
       If Valor > 29 then DiasT := 30
                     else If Frac(Valor) > 0.5
                             then DiasT := Trunc(Valor + 1)
                             else DiasT := Trunc(Valor);
     end
     else DiasT := 30;
end;


Procedure CalculaProdutividade;
begin
  YYNo := '016';
  RecuperaConta;
  If YAddress^.Origem = 'U' then
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
end;


Procedure CalculaSalario13;
begin
  If EEMember.Tipo = 'H'
     then SalBase13  := EEMember.Salario * EEMember.HNormais
     else SalBase13  := EEMember.Salario;
end;


Procedure CalculaValorHora1;
begin
  If ValorHora1 = 0 then
     begin
       If EEMember.Tipo = 'H'
          then ValorHora1 := (EEMember.Salario * EEMember.HNormais) + Produt
          else ValorHora1 := EEMember.Salario + Produt;
       If EEMember.HNormais > 0 then ValorHora1 := ValorHora1 / EEMember.HNormais
                                else ValorHora1 := ValorHora1 / 220;
     end;
end;


Procedure CalculaValorHora2;
begin
  If ValorHora2 = 0 then
     begin
       If EEMember.Tipo = 'H'
          then ValorHora2 := (EEMember.Salario * EEMember.HNormais) +
                             VPeri + VInsa + AdNot + Produt
          else ValorHora2 := EEMember.Salario + VPeri + VInsa + AdNot + Produt;
       If EEMember.HNormais > 0 then ValorHora2 := ValorHora2 / EEMember.HNormais
                                else ValorHora2 := ValorHora2 / 220;
     end;
end;


Procedure CalculaCSindical;
begin
  YYNo := '050';
  RecuperaConta;
  If YAddress^.Origem = 'S' then
     begin
       If EEMember.Sindicato <> '' then
          begin
            If EEMember.Tipo = 'H'
               then YAddress^.AcMensalV := (EEMember.Salario *
                                           EEMember.HNormais) / 30
               else YAddress^.AcMensalV := EEMember.Salario / 30;
            YAddress^.AcMensalV := TruncX(YAddress^.AcMensalV);
          end
          else YAddress^.AcMensalV := 0;
     end;
  ContrSind := YAddress^.AcMensalV;
end;


Procedure CalculaAdNoturno;
begin
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
                 YAddress^.AcMensalV := (YAddress^.AcMensalH * ValorHora1) +
                                        ((ValorHora1 / 60)  * YAddress^.AcMensalM);
                 If CCMember.Taxa > 0
                    then YAddress^.AcMensalV := YAddress^.AcMensalV * CCMember.Taxa;
                 YAddress^.AcMensalV := TruncX(YAddress^.AcMensalV);
                 AdNot := YAddress^.AcMensalV;
               end;
          end;
     end;
end;


Procedure CalculaPeri(X : Char);
begin
  Case X of
       'P' : YYNo := '007';
       'S' : YYNo := '037';
  end;
  RecuperaConta;
  If YAddress^.Origem <> 'U' then
     begin
       VPeri := 0;
       For I := 1 to 5 do
       Case EEMember.Peric[I] of
            'B' : Case X of
                       'P' : VPeri := VPeri + ((SalBase   + Produt) * TTMember.Peri[I]) / 100;
                       'S' : VPeri := VPeri + ((SalBase13 + Produt) * TTMember.Peri[I]) / 100;
                  end;
            'S' : VPeri := VPeri + (TTMember.SalMinimo * TTMember.Peri[I]) / 100;
       end;
       Case X of
            'P' : VPeri := (VPeri / 30) * DiasT;
            'S' : VPeri := (VPeri / 12) * EEMember.MesesT;
       end;
       YAddress^.AcMensalV := TruncX(VPeri);
     end
     else VPeri := YAddress^.AcMensalV;
end;


Procedure CalculaInsa(X : Char);
begin
  Case X of
       'P' : YYNo := '008';
       'S' : YYNo := '038';
  end;
  RecuperaConta;
  If YAddress^.Origem <> 'U' then
     begin
       VInsa := 0;
       For I := 1 to 5 do
       Case EEMember.Insalub[I] of
            'B' : Case X of
                       'P' : VInsa := VInsa + ((SalBase   + Produt) * TTMember.Insa[I]) / 100;
                       'S' : VInsa := VInsa + ((SalBase13 + Produt) * TTMember.Insa[I]) / 100;
                  end;
            'S' : VInsa := VInsa + (TTMember.SalMinimo * TTMember.Insa[I]) / 100;
       end;
       Case X of
            'P' : VInsa := (VInsa / 30) * DiasT;
            'S' : VInsa := (VInsa / 12) * EEMember.MesesT;
       end;
       YAddress^.AcMensalV := TruncX(VInsa);
     end
     else VInsa := YAddress^.AcMensalV;
end;


Procedure CalculaAd13salario;
Var
  Repro  : Char;
  Pr13   : Real;
begin
  YYNo := '017';
  RecuperaConta;
  If (YAddress^.Origem = 'S') and (YAddress^.PerctUsr <> 0) then
     begin
       Pr13                := TruncX((SalBase13 * YAddress^.PerctUsr)/100);
       YAddress^.AcMensalV := Pr13;
     end
     else Pr13 := YAddress^.AcMensalV;

  YYNo := '081';
  RecuperaConta;
  If YAddress^.AcMensalV = 0 then Repro := 'N'
                             else Repro := 'S';
  YYNo := '004';
  RecuperaConta;
  If YAddress^.Origem = 'S' then
     begin
       If (YAddress^.AcAnualV = 0) and
          (((Repro = 'N') and (EEMember.MesesT > 0)) or
           ((Repro = 'S') and (EEMember.MesesT > 1))) then
          begin
            If Repro = 'N'
               then YAddress^.AcMensalV := (((SalBase13 + Pr13 + AdNot) / 12) * (EEMember.MesesT + 1)) / 2
               else YAddress^.AcMensalV := (((SalBase13 + Pr13 + AdNot) / 12) * EEMember.MesesT) / 2;
          end;
       If SC = 'C' then
          begin
            Str(YAddress^.AcMensalV:12:0,J);
            J := LeftAdjust(J);
            Val(J,YAddress^.AcMensalV,E);
          end;
     end;
  Valor := YAddress^.AcMensalV;
  CCNo  := YYNo;
  SearchTree1 ( Root1 );
  If RC = 'S' then
     begin
       ReadWrite(#04,'R','N',CCNumber);
       If CCMember.Bases[3] = 'S' then
          begin
            YYNo := '072';
            RecuperaConta;
            YAddress^.AcMensalV := Valor * 0.08;
            YAddress^.Origem    := 'S';
            YYNo := '087';
            RecuperaConta;
            YAddress^.AcMensalV := Valor;
            YAddress^.Origem    := 'S';
          end;
     end;
end;


Procedure CalculaLiquido(X : Char);
begin
  Valor := 0;
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
              If (CCMember.Operacao   = Eta                   ) or
                 ((CCNo               > '100'                )  and
                  (Eta                = 'P'                  )  and
                  (CCMember.Operacao in ['1','2','3','4','A'])) then
                 begin
                   If X = 'S' then
                      Case CCMember.Tipo of
                        'D' : TDesc := TDesc + TruncX(YAddress^.AcMensalV);
                        'P' : TProv := TProv + TruncX(YAddress^.AcMensalV);
                      end;
                   Case CCMember.Tipo of
                        'D' : Valor := Valor - TruncX(YAddress^.AcMensalV);
                        'P' : Valor := Valor + TruncX(YAddress^.AcMensalV);
                   end;
                 end;
            end
            else RC := 'S';
       end;
  Until RC = 'N';
  If Eta in ['P','S'] then
     begin
       If (TruncX(Valor) > 0) and (SC <> 'N') and
          (EEMember.Status in ['A','E','C','L','F']) then
          begin
            VLiq := 0;
            Case SC of
                 'C' : If Frac(Valor) <> 0 then VLiq := 1 - Frac(Valor);
                 'D' : begin
                         Str(Valor:15:2,J);
                         J := LeftAdjust(J);
                         I := Length(J) - 4;
                         J := Copy(J,I,5);
                         Val(J,VLiq,E);
                         If VLiq <> 0 then VLiq := 100 - VLiq;
                       end;
            end;
            If VLiq > 0 then
               begin
                 If Eta = 'S' then YYNo := '024'
                              else YYNo := '025';
                 RecuperaConta;
                 If YAddress^.Origem = 'S'
                    then YAddress^.AcMensalV := TruncX(VLiq)
                    else VLiq := YAddress^.AcMensalV;
                 If Eta = 'S' then
                    begin
		      YYNo := '078';
                      RecuperaConta;
                      YAddress^.AcMensalV := TruncX(VLiq);
                      YAddress^.Origem    := 'S';
                      If X = 'S' then TDesc := TDesc + TruncX(VLiq);
                    end;
                 Valor := Valor + TruncX(VLiq);
                 If X = 'S' then TProv := TProv + TruncX(VLiq);
               end;
          end
          else If Valor < 0 then
                  begin
                    YYNo := '015';
                    RecuperaConta;
                    YAddress^.AcMensalV := Valor * -1;
                    YAddress^.Origem    := 'S';
                    If X = 'S' then TProv := TProv + TruncX(YAddress^.AcMensalV);
                  end;
       YYNo := '030';
       RecuperaConta;
       If Valor > 0 then YAddress^.AcMensalV := Valor
                    else YAddress^.AcMensalV := 0;
       YAddress^.Origem := 'S';
     end
     else begin
            YYNo := '030';
            RecuperaConta;
            YAddress^.AcMensalV := Valor;
            YAddress^.Origem    := 'S';
          end;
  VLiq := YAddress^.AcMensalV;
end;


Procedure CalculaPensao(X : Char);
begin
  Case X of
       'N' : begin
               YYNo := '070';
               Valor := SalBase + Produt;
             end;
       'S' : begin
               YYNo := '079';
               Valor := SalBase13 + Produt;
             end;
  end;
  RecuperaConta;
  If YAddress^.Origem = 'S' then
     begin
       Case EEMember.Pensao of
            '1','2','A','B' : Valor := TTMember.SalMinimo * EEMember.PensaoP;
            '3','4','C','D' : Valor := (Valor - ContrSind) *
                                       (EEMember.PensaoP / 100);
            '5','6','E','F' : Valor := (Valor - VIapas) * (EEMember.PensaoP / 100);
       end;
       If EEMember.Pensao in ['1','2','3','4','5','6']
          then Valor := Valor + VSalFam;
       If Valor > 0 then YAddress^.AcMensalV := Valor
                    else YAddress^.AcMensalV := 0;
     end;
  If EEMember.Pensao in ['2','4','6','B','D','F'] then
     begin
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
                   If (CCMember.Bases[1] = 'S') and
                      ((CCMember.Operacao = 'P') and (X = 'N')) or
                      ((CCMember.Operacao = 'S') and (X = 'S')) then
                      Case CCMember.Tipo of
                           'P' : VBases[1] := VBases[1] +
                                              TruncX(YAddress^.AcMensalV);
                           'D' : VBases[1] := VBases[1] -
                                              TruncX(YAddress^.AcMensalV);
                      end;
                 end
                 else RC := 'S';
            end;
       Until RC = 'N';
       Case X of
            'N' : YYNo := '082';
            'S' : YYNo := '086';
       end;
       RecuperaConta;
       If VBases[1] > 0 then YAddress^.AcMensalV := VBases[1]
                        else YAddress^.AcMensalV := 0;
       YAddress^.Origem    := 'S';
       Case X of
            'N' : CalculaIR('S');
            'S' : CalculaIR('1');
       end;
       CalculaLiquido('S');
     end;
end;


Procedure DisplayNome(X : Char);
begin
  If X = 'G' then
     begin
       Color(Sfn,Stx);
       GotoXY(4,20); Write(' ',PushLeft(41,EEMember.Nome));
       Color(Tfn,Utx);
     end;
end;


Procedure Adiantamento(X : Char);
Var
   TemAd     : Char;
begin
  Case Eta of
       'A' : CCNo := '002';
       '1' : CCNo := '010';
       '2' : CCNo := '011';
       '3' : CCNo := '012';
       '4' : CCNo := '013';
  end;
  YYNo := CCNo;
  RecuperaConta;
  If YAddress^.AcMensalV > 0 then TemAd := 'S'
                             else TemAd := 'N';

  If ((EEMember.PercAdiant <> 0                                   )  or
      (TemAd               = 'S'                                  )) and
     (((EEMember.Tipo in ['H','M']) and (Eta = 'A'               ))  or
      ((EEMember.Tipo =   'S'     ) and (Eta in ['1','2','3','4']))) then
     begin
       DisplayNome(X);
       VPeri      := 0;
       AdNot      := 0;
       VInsa      := 0;
       ValorHora1 := 0;
       ValorHora2 := 0;
       Val(EEMember.MMAdm,MesA,E);
       Val(EEMember.AAAdm,AnoA,E);
       Val(EEMember.DDAdm,DiaA,E);
       CalculaSBase;
       CalculaProdutividade;
       CalculaValorHora1;
       CalculaValorHora2;
       CalculaSalario13;
       Case Eta of
            'A' : CCNo := '002';
            '1' : CCNo := '010';
            '2' : CCNo := '011';
            '3' : CCNo := '012';
            '4' : CCNo := '013';
       end;
       YYNo := CCNo;
       RecuperaConta;
       If (YAddress^.Origem    = 'S') and
          (EEMember.PercAdiant > 0) then
          begin
            YAddress^.AcMensalV := ((SalBase + Produt) * EEMember.PercAdiant) / 100;
            Str(YAddress^.AcMensalV:15:0,J);
            J := LeftAdjust(J);
            Case SC of
                 'C' : Val(J,YAddress^.AcMensalV,E);
                 'D' : begin
                         I := Length(J) - 2;
                         J := Copy(J,1,I) + '00';
                         Val(J,VLiq,E);
                         YAddress^.AcMensalV := VLiq;
                       end;
            end;
          end;
       Valor     := YAddress^.AcMensalV;
       VBases[2] := Valor;
       VIapas    := 0;
       CalculoConta(Eta);
       If EEMember.INSS[1] = 'S' then
          begin
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
                           (CCMember.Operacao = Eta) then
                           begin
                             Valor := TruncX(YAddress^.AcMensalV);
                             If CCMember.Bases[2] = 'S' then
                                Case CCMember.Tipo of
                                     'P' : VBases[2] := VBases[2] + Valor;
                                     'D' : VBases[2] := VBases[2] - Valor;
                                end;
                           end;
                      end
                      else RC := 'S';
                 end;
            Until RC = 'N';
            Case Eta of
                 'A' : CCNo := '073';
                 '1' : CCNo := '074';
                 '2' : CCNo := '075';
                 '3' : CCNo := '076';
                 '4' : CCNo := '077';
            end;
            YYNo := CCNo;
            RecuperaConta;
            If (YAddress^.Origem     = 'S') and
               (EEMember.Vinculo[1] <> 'A') and
               (EEMember.Vinculo[1] <> 'N') then
               begin
                 I := FaixaINSS(VBases[2]);
                 If VBases[2] > TTMember.TetoSalContr
                    then YAddress^.AcMensalV := TTMember.TetoSalContr *
                                               (TTMember.TaxaIapas[I]  / 100)
                    else YAddress^.AcMensalV := VBases[2] *
                                               (TTMember.TaxaIapas[I] /  100);
                 VIapas := YAddress^.AcMensalV;
               end
               else If YAddress^.Origem = 'U'
                       then VIapas              := YAddress^.AcMensalV
                       else YAddress^.AcMensalV := 0;
          end;
       If P13 = 'S' then
          begin
            CalculaAd13Salario;
            Valor := Valor + YAddress^.AcMensalV;
          end;
       ConverteHora('');
       CalculaLiquido('S');
       Case Eta of
            'A' : CCNo := '052';
            '1' : CCNo := '053';
            '2' : CCNo := '054';
            '3' : CCNo := '055';
            '4' : CCNo := '056';
       end;
       YYNo := CCNo;
       RecuperaConta;
       YAddress^.AcMensalV := VLiq;
       YAddress^.Origem    := 'S';
       LFolha := LFolha + VLiq;
       NFunc  := NFunc  + 1;
     end;
end;

Procedure DiferencaData;
begin
  DifData := AA - AnoA;
  If MesA > MM then DifData := DifData - 1;
end;

Procedure CheckUsrMacro;
begin
  Assign ( TxtFile, (XPath + '\USRMACRO.CMD'));
  {$I-}
  Reset ( TxtFile );
  {$I+}
  If IOResult = 0 then
     begin
       TxtMacro := 'S';
       Color(Tfd,Black);
       GotoXY(2,7); Write('UserMacro [C]');
       Color(Tfn,Utx);
     end
     else begin
            Assign ( TxtFile, (Copy(XPath,1,Length(XPath) - 4) + 'TEXT\USRMACRO.CMD'));
            {$I-}
            Reset ( TxtFile );
            {$I+}
            If IOResult = 0 then
               begin
                 TxtMacro := 'S';
                 Color(Tfd,Black);
                 GotoXY(2,7); Write('UserMacro [G]');
                 Color(Tfn,Utx);
               end
               else TxtMacro := 'N';
          end;
end;


Procedure UserMacro(Tempo : Char);
Var
  UsrReg               : AnyStr;
  I,Op                 : Integer;
  Acm,Ac1              : Real;
  OpX,ResultX          : Str80;
  Tip,TipX,Cta,ContaX  : Char;
begin
  If TxtMacro = 'S' then
     begin
       Reset ( TxtFile );
       TC := #13;
       While (not Eof(TxtFile)) and (TC <> #27) do
       begin
         {$I-}
         Readln(TxtFile,UsrReg);
         {$I+}
         If IOResult = 0 then
            begin
              If UsrReg[1] = Tempo then
                 begin
                   I   := 1;
                   Op  := 0;
                   Acm := 0;
                   Tip := ' ';
                   Repeat
                     I := I + 1;
                     Case UsrReg[I] of
                          '='     : Op := 0;
                          '(','+' : Op := 1;
                          '-'     : Op := 2;
                          '*'     : Op := 3;
                          '/'     : Op := 4;
                          ')'     : begin
                                      ResultX := OpX;
                                      ContaX  := Cta;
                                      TipX    := Tip;
                                      If UsrReg[I+1] = '[' then
                                         begin
                                           Op := 5;
                                           I  := I + 1;
                                         end
                                         else Op := Length(UsrReg);
                                    end;
                          ']'     : Op := Length(UsrReg);
                     end;
                     If I < Length(UsrReg) then
                        begin
                          I := I + 1;
                          Case UpCase(UsrReg[I]) of
                               'N','T','%' : begin
                                               Tip := UpCase(UsrReg[I]);
                                               OpX := '';
                                               Repeat
                                                 I   := I + 1;
                                                 OpX := OpX + UsrReg[I];
                                               Until UsrReg[I+1] in ['+','-','*','/','=',']'];
                                               Cta := '#';
                                             end;
                               else begin
                                      I   := I + 1;
                                      Tip := UpCase(UsrReg[I]);
                                      If UpCase(UsrReg[I-1]) = 'C' then
                                         begin
                                           Cta := UpCase(UsrReg[I-1]);
                                           I   := I + 1;
                                           OpX := Copy(UsrReg,I,3);
                                           I := I + 2;
                                         end
                                         else Cta := '#';
                                    end;
                          end;
                          Case Tip of
                               'N' : Val(OpX,Ac1,E);
                               'T' : begin
                                       Val(OpX,R,E);
                                       Ac1 := Tmp[R];
                                     end;
                               'A','V','O','H','F','M' : begin
                                                           YYNo := OpX;
                                                           SearchTreeY ( RootY );
                                                           Ac1 := 0;
                                                           If RC = 'S' then
                                                              Case Tip of
                                                                   'A' : Ac1 := YAddress^.AcAnualV;
                                                                   'V' : Ac1 := YAddress^.AcMensalV;
                                                                   'O' : Ac1 := YAddress^.AcAnualH;
                                                                   'H' : Ac1 := YAddress^.AcMensalH;
                                                                   'T' : Ac1 := YAddress^.AcAnualM;
                                                                   'M' : Ac1 := YAddress^.AcMensalM;
                                                              end;
                                                         end;
                               '0' : Ac1 := VBases[10];
                               '1' : Ac1 := ValorHora1;
                               '2' : Ac1 := ValorHora2;
                               '3' : If EEMember.VTransporte = 'S' then Ac1 := DU
                                                                   else Ac1 := DUF;
                               '4' : Ac1 := TabDia[MM];
                               '5' : Ac1 := EEMember.MesesT;
                               '6' : Ac1 := VBases[06];
                               '7' : Ac1 := VBases[07];
                               '8' : Ac1 := VBases[08];
                               '9' : Ac1 := VBases[09];
                               'Y' : Ac1 := DifData;
                               'B' : Ac1 := Trunc(DifData / 2);
                               'E' : Ac1 := Trunc(DifData / 3);
                               'Q' : Ac1 := Trunc(DifData / 5);
                               'D' : Ac1 := Trunc(DifData / 10);
                               'F' : Ac1 := EEmember.MesesF;
                               'P' : Ac1 := EEMember.PeriodoV;
                               'R' : Ac1 := EEMember.HNormais;
                               '%' : begin
                                       Val(OpX,Ac1,E);
                                       Ac1 := TruncX(Ac1 * SalBase);
                                     end;
                          end;
                          Case Op of
                               1 : Acm := Acm + Ac1;
                               2 : Acm := Acm - Ac1;
                               3 : Acm := Acm * Ac1;
                               4 : If Ac1 > 0 then Acm := Acm / Ac1
                                              else Acm := 0;
                               5 : If Acm > Ac1 then Acm := Ac1;
                          end;
                          RC := 'S';
                        end;
                   Until I = Length(UsrReg);
                   Case ContaX of
                        'C' : begin
                                Acm := TruncX(Acm);
                                If Acm > 0 then
                                   begin
                                     YYNo := ResultX;
                                     RecuperaConta;
                                     If YAddress^.Origem = 'S' then
                                        Case TipX of
                                             'V' : YAddress^.AcMensalV := Acm;
                                             'H' : YAddress^.AcMensalH := Trunc(Acm);
                                             'M' : begin
                                                     Hora   := YAddress^.AcMensalH;
                                                     Minuto := YAddress^.AcMensalM + Trunc(Acm);
                                                     HoraMinuto;
                                                     YAddress^.AcMensalH := Hora;
                                                     YAddress^.AcMensalM := Minuto;
                                                   end;
                                        end;
                                   end;
                              end;
                        else Case UpCase(ResultX[1]) of
                                     'T' : begin
                                             Val(ResultX,R,E);
                                             If (R > 0) and (R < 11) then Tmp[R] := Acm;
                                           end;
                                     'V' : Case UpCase(ResultX[3]) of
                                                '1' : ValorHora1 := Acm;
                                                '2' : ValorHora2 := Acm;
                                           end;
                             end;
                   end;
                 end
                 else If UsrReg = '#END' then TC := #27;
            end;
       end;
     end;
end;


Procedure CloseUsrMacro;
begin
  If TxtMacro = 'S' then Close ( TxtFile );
end;


Procedure GuardaINSS;
begin
  ReadWrite(#12,'R','N',EENumber);
  If ENMember.Empregado = '' then
     begin
       ENMember.Empregado := EENo;
       For I := 1 to 48 do begin
                             ENMember.MMAA[I] := '';
                             ENMember.SalC[I] := 0;
                             ENMember.VRec[I] := 0;
                           end;
     end;
  I := 0;
  For P := 1 to 48 do If ENMember.MMAA[P] = (Mx + '/' + Ax) then I := P;
  If I = 0 then
     begin
       I := 49;
       Repeat
         I := I - 1;
         ENMember.MMAA[I] := ENMember.MMAA[I-1];
         ENMember.SalC[I] := ENMember.SalC[I-1];
         ENMember.VRec[I] := ENMember.VRec[I-1];
       Until I = 2;
       I := 1;
     end;
  ENMember.MMAA[I] := Mx + '/' + Ax;
  YYNo := '061';
  RecuperaConta;
  ENMember.VRec[I] := YAddress^.AcMensalV;
  YYNo := '064';
  RecuperaConta;
  ENMember.VRec[I] := ENMember.VRec[I] + YAddress^.AcMensalV;
  YYNo := '081';
  RecuperaConta;
  ENMember.SalC[I] := YAddress^.AcMensalV;
  YYNo := '085';
  RecuperaConta;
  ENMember.SalC[I] := ENMember.SalC[I] + YAddress^.AcMensalV;
  ReadWrite(#12,'W','N',EENumber);
end;


{$I PlogCal1.inc }


Procedure Pagamentos(X : Char);
Var
  NMeses,VtD    : Integer;
begin
  If X <> 'G' then CheckUsrMacro;
  For R := 1 to 10 do Tmp[R] := 0;
  ValorHora1 := 0;
  ValorHora2 := 0;
  ContrSind  := 0;
  DisplayNome(X);
  If FC = 'S' then
     begin
       YYNo := '031';
       RecuperaConta;
       If YAddress^.AcMensalV = 0 then
          begin
            YYNo := '030';
            RecuperaConta;
            Valor := YAddress^.AcMensalV;
            YYNo := '031';
            RecuperaConta;
            YAddress^.AcMensalV := Valor;
          end;
     end;
  YYNo := '015';
  RecuperaConta;
  If (YAddress^.Origem    =  'S') and
     (YAddress^.AcMensalV <> 0  ) then YAddress^.AcMensalV := 0;
  YYNo := '025';
  RecuperaConta;
  If (YAddress^.Origem    =  'S') and
     (YAddress^.AcMensalV <> 0  ) then YAddress^.AcMensalV := 0;
  Val(EEMember.MMAdm,MesA,E);
  Val(EEMember.AAAdm,AnoA,E);
  Val(EEMember.DDAdm,DiaA,E);
  DiferencaData;
  If EEMember.Status in ['A','E','C','F'] then
     begin
       Val(EEMember.AAAdm,I,E);
       If I < AA then EEMember.MesesT := MM
                 else begin
                        Val(EEMember.MMAdm,I,E);
                        EEMember.MesesT := MM - I;
                        Val(EEMember.DDAdm,I,E);
                        If I <= 15 then EEMember.MesesT := EEMember.MesesT + 1;
                      end;
       Val(EEMember.AAPAq,I,E);
       If I < AA then
          begin
            Val(EEMember.MMPAq,I,E);
            EEMember.MesesF := (12-I) + MM;
            Val(EEMember.DDPAq,I,E);
            If I <= 15 then EEMember.MesesF := EEMember.MesesF + 1;
            If (EEMember.MesesF = 13) and
               (EEMember.ExAnt <> Mx) then
               begin
                 EEMember.PeriodoV := EEMember.PeriodoV + 1;
                 EEMember.MesesF := 1;
               end
               else If EEMember.MesesF > 12 then EEMember.MesesF := EEMember.MesesF - 12;;
          end
          else begin
                 Val(EEMember.MMPAq,I,E);
                 EEMember.MesesF := MM - I;
                 Val(EEMember.DDPAq,I,E);
                 If I <= 15 then EEMember.MesesF := EEMember.MesesF + 1;
               end;
     end
     else begin
            If EEMember.MesesT = 0 then EEMember.MesesT := 1;
            If EEMember.MesesF = 0 then EEMember.MesesF := 1;
          end;
  EEMember.ExAnt := Mx;
  YYNo := '070';
  RecuperaConta;
  If (YAddress^.Origem    =  'S') and
     (YAddress^.AcMensalV <> 0  ) then YAddress^.AcMensalV := 0;
  UserMacro('1');
  If ((EEMember.Status    = 'L')  or
      (EEMember.Status    = 'C')) and
     (EEMember.MesI       <> MM ) and
     (EEMember.Vinculo[1] <> 'A') and
     (EEMember.Vinculo[1] <> 'N') then
     begin
       YYNo := '001';
       RecuperaConta;
       If YAddress^.Origem = 'S' then
          begin
            SalBase             := 0;
            YAddress^.AcMensalV := 0;
          end
          else SalBase := YAddress^.AcMensalV;
     end
     else If (EEMember.Vinculo[1] <> 'A') and
             (EEMember.Vinculo[1] <> 'C') and
             (EEMember.Vinculo[1] <> 'N') then CalculaSBase
             else begin
                    If EEMember.Vinculo[1] = 'N' then YYNo := '006'
                                                 else YYNo := '018';
                    RecuperaConta;
                    If YAddress^.Origem <> 'U'
                       then YAddress^.AcMensalV := EEMember.Salario;
                    SalBase := YAddress^.AcMensalV;
                    DiasT   := 30;
                  end;
  CalculaProdutividade;
  CalculaSalario13;
  UserMacro('2');
  DiasF := 0;
  YYNo  := CMstMember.ContaF;
  If (YYNo <> '') and
     ((CMstMember.FaltaH <> 0) or (CMstMember.RepousoH <> 0)) then
     begin
       SearchTreeY ( RootY );
       If RC = 'S' then
          begin
            Case EEMember.Tipo of
                 'H' : DiasF := DiasF + Trunc(YAddress^.AcMensalH / (CMstMember.FaltaH + CMstMember.RepousoH));
                 else  DiasF := DiasF + Trunc(YAddress^.AcMensalH / CMstMember.FaltaH);
            end;
            If (CMstMember.Etapa <> Eta) and
               (Eta               = 'P') then EEMember.FaltasNJ := EEMember.FaltasNJ + DiasF;
          end;
     end;
  CalculaValorHora1;
  CalculaAdNoturno;
  CalculaPeri('P');
  CalculaInsa('P');
  CalculaValorHora2;
  UserMacro('3');
  ConverteHora('');
  CalculoConta('P');
  If EEMember.Status = 'F' then DiferencaFerias;
  ProcessaBaseUsr;
  ConverteHora('');
  UserMacro('4');
  If (CS                   = 'S') and
     (EEMember.Vinculo[1] <> 'A') and
     (EEMember.Vinculo[1] <> 'N') then CalculaCSindical;
  If (EEMember.Status in ['A','E','F','V'] ) and
     (EEMember.Vinculo[1] <> 'A'           ) and
     (EEMember.Vinculo[1] <> 'N'           ) and
     (EEMember.VTransporte in ['F','S']    ) then
     begin
       YYNo := '069';
       RecuperaConta;
       If YAddress^.Origem = 'S' then
          begin
            If EEMember.VTransporte = 'S' then VtD := DU
                                          else VtD := DUF;
            ValeTransp := 0;
            YYNo       := '069';
            RecuperaConta;
            If EEMember.DiasVT <> 0 then K := EEMember.DiasVT
               else begin
                      DDNo := EEMember.Depto;
                      SearchTree3 ( Root3 );
                      If RC = 'S' then
                         begin
                           ReadWrite(#05,'R','N',DDNumber);
                           If (RW             = 'S') and
                              (DDMember.Dias1 <> 0 ) then K := DDMember.Dias1
                                                     else K := VtD;
                         end
                         else K := VtD;
                    end;
            For I := 1 to 6 do
            begin
              If EEMember.Passagens[I] <> 0 then
                 If TTMember.TPass[EEMember.Faixa[I]] = 'F'
                  then ValeTransp := ValeTransp +
                                     TTMember.VPass[EEMember.Faixa[I]] *
                                     EEMember.Passagens[I]
                  else ValeTransp := ValeTransp +
                                     TTMember.VPass[EEMember.Faixa[I]] *
                                     (EEMember.Passagens[I] * K);
            end;
            If TVtr = 'X' then K := 30;
            Case EEMember.Tipo of
                 'H' : YAddress^.AcMensalV := ((((EEMember.Salario * EEMember.HNormais) + Produt)/30)*K) * 0.06;
                 else  YAddress^.AcMensalV := (((EEMember.Salario + Produt)/30)*K) * 0.06;
            end;
            If ValeTransp < YAddress^.AcMensalV
               then YAddress^.AcMensalV := ValeTransp;
            If (VTR = 'S') and (VP2 = 'S') then
               begin
                 ValeTransp := 0;
                 Valor      := 0;
                 If EEMember.DiasVT = 0 then K := (TabDia[MM] - D2T) + 1
                                        else K := EEMember.DiasVT;
                 For I := 1 to 6
                 do If EEMember.Passagens[I] <> 0 then
                       If TTMember.TPass[EEMember.Faixa[I]] = 'F' then
                          begin
                            ValeTransp := ValeTransp +
                                       TTMember.VPass[EEMember.Faixa[I]] *
                                       EEMember.Passagens[I];
                            Valor := Valor + VPass2[EEMember.Faixa[I]] *
                                     EEMember.Passagens[I];
                          end
                          else begin
                                 ValeTransp := ValeTransp +
                                               TTMember.VPass[EEMember.Faixa[I]] *
                                               (EEMember.Passagens[I] * K);
                                 Valor := Valor + VPass2[EEMember.Faixa[I]] *
                                          (EEMember.Passagens[I] * K);
                               end;
                 Valor := Valor - ValeTransp;
                 If Valor > 0 then
                    begin
                      YYNo := '049';
                      RecuperaConta;
                      If YAddress^.Origem = 'S'
                         then YAddress^.AcMensalV := Valor
                         else Valor := YAddress^.AcMensalV;
                    end;
               end;
          end;
     end
     else begin
            YYNo := '069';
            RecuperaConta;
            If (YAddress^.Origem    =  'S') and
               (YAddress^.AcMensalV <> 0  ) then YAddress^.AcMensalV := 0;
          end;
  CalculaRepouso;
  CalculaBases;
  If EEMember.DtNascSF[1] <> '*' then
     begin
       EEMember.DepSF := 0;
       For I := 1 to 5 do
       If EEMember.DtNascSF[I] <> '' then
          begin
            If Copy(EEMember.DtNascSF[I],1,1) = 'D'
               then EEMember.DepSF := EEMember.DepSF + 1
               else begin
                      Val(Copy(EEMember.DtNascSF[I],7,4),A,E);
                      Val(Copy(EEMember.DtNascSF[I],4,2),M,E);
                      B := AA - A - 1;
                      If M <= MM then B := B + 1;
                      If B < 14  then EEMember.DepSF := EEMember.DepSF + 1;
                    end;
          end;
     end;
  If (EEMember.DepSF  <> 0  ) and
     (EEMember.Status <> 'L') then SalarioFamilia;
  CalculaIapas;
  UserMacro('5');
  CalculaBaseIR;
  CalculaIR('S');
  If P13 = 'S' then CalculaAd13Salario;
  If (EEMember.Vinculo[1] <> 'A'                      ) and
     (EEMember.Vinculo[1] <> 'N'                      ) and
     (EEMember.Status in ['A','C','E','F','L','P','V']) then CalculaFgts
     else begin
            YYNo := '063';
            RecuperaConta;
            If YAddress^.Origem = 'S' then YAddress^.AcMensalV := 0;
          end;
  If EEMember.Status = 'F' then CalculaIR('F')
     else begin
            YYNo := '058';
            RecuperaConta;
            If (YAddress^.Origem    = 'S') and
               (YAddress^.AcMensalV <> 0 ) then YAddress^.AcMensalV := 0;
          end;
  UserMacro('6');
  CalculaLiquido('S');
  If EEMember.Pensao <> 'N' then CalculaPensao('N');
  If FC = 'S' then
     begin
       YYNo := '031';
       RecuperaConta;
       If YAddress^.AcMensalV > VLiq then
          begin
            Valor := YAddress^.AcMensalV - VLiq;
            YYNo  := '014';
            RecuperaConta;
            YAddress^.AcMensalV := Valor;
            CalculaLiquido('S');
          end;
     end;
  UserMacro('7');
  If (EEMember.Vinculo[1] <> 'A') and
     (EEMember.Vinculo[1] <> 'N') then
     begin
       YYNo := '097';
       RecuperaConta;
       If YAddress^.Origem = 'S' then
          begin
            YAddress^.AcMensalV := (VBases[2] * 1.33334) * EEMember.PeriodoV;
            YAddress^.AcMensalV := YAddress^.AcMensalV +
                                   (((VBases[2] * 1.33334) / 12) * EEMember.MesesF);
          end;
       YYNo := '098';
       RecuperaConta;
       If YAddress^.Origem = 'S'
          then YAddress^.AcMensalV := (VBases[2] / 12) * EEMember.MesesT;
     end;
  GuardaINSS;
  LFolha := LFolha + VLiq;
  NFunc := NFunc + 1;
  If X <> 'G' then CloseUsrMacro;
end;

{$I PlogCalc.inc }

end.