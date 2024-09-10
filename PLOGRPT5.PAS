{$O+,F+}
Unit PlogRpt5;

Interface

Uses Crt,Dos,PlogGlbs,PlogBasP,PlogTree,PlogRpt0,PlogMstr;


   Procedure ProcNo14Report(X : Char);
   Procedure ImprimeGRPS;
   Procedure ImprimeGRCS;
   Procedure ImprimeDARF;
   Procedure GeralGRPS;
   Procedure GeralGR;
   Procedure GeralGRCS;
   Procedure GeralDARF;


Implementation

Const
  Zeros        = '000000000000000000000000000000';

Type
  REMAG   = RECORD
              Classe         : String[2];
              DescrC         : String[18];
              Domicilio      : String[8];
              Codigo         : String[14];
              Categoria      : String[2];
              Responsavel    : String[20];
            END;
Var
   RmgMember   : REMAG;
   RmgFile     : FILE OF REMAG;

  IdDep        : String[3];
  DataRec      : String[8];


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


Procedure ProcNo14Header(X : Char);
Var
  L        : AnyStr;
  Npr,Fpr  : Char;
begin
  If ContLin < 1000 then Footer;
  ContPag := ContPag + 1;
  If ContLin = 1000
     then L := Dx+'RE'+Df+
          Acentua(' - Rela‡„o de Empregados do mˆs de ')+
                            Acentua(ArrayMesEx[MM])+' de '+
                            PushRight(4,EditInteger(AA))+
                            ConstStr(' ',3)+Dx+'FGTS - GFIP'+Df
     else L := Qp+Dx+'RE'+Df+
  Acentua(' - Rela‡„o de Empregados do mˆs de ')+
          Acentua(ArrayMesEx[MM])+' de '+
          PushRight(4,EditInteger(AA))+
          ConstStr(' ',3)+Dx+'FGTS - GFIP'+Df;
  ContLin := 0;
  WriteLine('L',L);
  WriteLine('L',ConstStr('-',80));
  WriteLine('L',Cx+ConstStr(' ',61)+Acentua('C¢digo Seq..  CGC')+Cf);
  WriteLine('L',Cx+ConstStr(' ',61)+PushLeft(7,CodX)+
            PushLeft(7,SeqX)+CMstMember.CGC+Cf);
  WriteLine('L',Cx+'Bco Nome'+ConstStr(' ',53)+
            Acentua(CMstMember.Descricao)+Cf);
  WriteLine('L',Cx+PushLeft(4,Copy(BBMember.OrigBancoC,1,3))+
            Acentua(BBMember.NomeBanco)+
            ConstStr(' ',57-Length(BBMember.NomeBanco))+
            Acentua(CMstMember.Endereco+', '+CMStMember.Numero+' '+CMstmember.Complemento)+
            ConstStr(' ',41-Length(CMstMember.Endereco+', '+CMstMember.Numero+' '+CMstmember.Complemento))+
            PushRight(5,CMstMember.Cep)+
            Acentua(' C¢digo de Atividade: ')+
            PushRight(4,CMstMember.CNAE)+Cf);
  J := Copy(BBMember.OrigBancoC,5,(Length(BBMember.OrigBancoC)));
  WriteLine('L',Cx+J+ConstStr(' ',7-Length(J))+
            Acentua(BBMember.NomeAgencia)+
            ConstStr(' ',54-Length(BBMember.NomeAgencia))+
            Acentua(CMstMember.Bairro)+
            ConstStr(' ',21-Length(CMstMember.Bairro))+
            Acentua(CMstMember.Cidade)+
            ConstStr(' ',21-Length(CMstMember.Cidade))+
            CMstMember.Estado+'     Comp.: '+
            PushRight(2,EditInteger(MM))+'/'+
            PushRight(4,EditInteger(AA))+' '+
            PushRight(3,EditInteger(ContPag))+'/'+
            PushRight(3,EditInteger(R))+Cf);
  Case Tx of
       '1' : J := 'No Prazo     ';
       '2' : J := 'Fora do Prazo';
  end;
  WriteLine('L',Cx+Acentua(CMstMember.Bairro)+
            ConstStr(' ',35-Length(CMstMember.Bairro))+
            CMstMember.Estado+ConstStr(' ',24)+J+Cf);
  WriteLine('L',ConstStr('-',80));
  WriteLine('L',Cx+ConstStr(' ',3)+
            Acentua('N£mero da Conta Admiss„o    Cart.Trab. PIS')+
            Acentua('         Remunera‡„o   13 Sal rio Op‡„o      ')+
            Acentua('Nome do empregado                        Rescis„o Mot.')+Cf);
  WriteLine('L',ConstStr('-',80));
end;


Procedure ProcNo14Total(X : Char);
begin
  If ContLin <> 1000 then
     Case X of
          '1' : begin
                  If GrMember.Func < 14 then
                     begin
                       GrMember.Func := 14 - GrMember.Func;
                       For I := 1 to GrMember.Func do
                       begin
                         WriteLine('L',' ');
                         WriteLine('L',' ');
                       end;
                     end;
                  WriteLine('L',' ');
                  WriteLine('L',PushRight(2,EditInteger(DiasF))+' '+
                                QQStr(MM,2,'0')+' '+
                                PushRight(4,EditInteger(AA))+
                                ConstStr(' ',38)+
                                PushRight(14,EditReal(GrMember.VGuia[2])));
                  WriteLine('L',' ');
                  WriteLine('L',' ');
                  WriteLine('L',' ');
                  WriteLine('L',' ');
                  WriteLine('L',' ');
                  WriteLine('L',' ');
                  WriteLine('L',' ');
                  WriteLine('L',' ');
                end;
       '2' : begin
               WriteLine('L',Cx+ConstStr(' ',49)+'--------------'+Cf);
               WriteLine('L',Cx+ConstStr(' ',30)+'Total desta Folha  '+
                             PushRight(14,EditReal(GrMember.VGuia[2]))+Cf);
               WriteLine('L',' ');
               WriteLine('L',' ');
               WriteLine('L',' ');
               WriteLine('L',Cx+PushRight(20,Acentua(CMstMember.Cidade))+', '+
                             PushRight(2,EditInteger(DiasF))+' de '+
                             Acentua(ArrayMesEx[MM])+' de '+
                             PushRight(4,EditInteger(AA))+
                             '     ----------------------------------------'+Cf);
               WriteLine('L',Cx+ConstStr(' ',41)+
                             ConstStr(' ',Length(ArrayMesEx[MM]))+
                             Acentua(CMstMember.Descricao)+Cf);
             end;
     end;
end;


Procedure ProcNo14Calc(X : Char);
Var
  LPag     : Integer;
begin
  Case X of
       '1' : LPag := 14;
       '2' : LPag := 19;
  end;
  R := 0;
  Repeat
    RC := 'N';
    SearchPos6 ( Root6 );
    If (RC             = 'S') and
       (Copy(XXNo,1,1) = 'F') then
       begin
         ReadWrite(#08,'R','N',XXNumber);
         If (EEMember.BcoFgts  = BBMember.OrigBancoC) and
            (EEMember.Status     <> 'R'             ) and
            (EEMember.Status     <> 'V'             ) and
            (EEMember.Status     <> 'X'             ) and
            (EEMember.Vinculo[1] <> 'A'             ) and
            (EEMember.Vinculo[1] <> 'N'             ) then
            begin
              Case Ex of
                   'D' : If EEMember.Depto = DDNo then R := R + 1;
                   'X' : begin
                           DDNo := EEMember.Depto;
                           SearchTree3 ( Root3 );
                           If RC = 'S' then ReadWrite(#05,'R','N',DDNumber)
                                       else RC := 'S';
                           If (EEMember.Depto = DDNo) and
                              (DDMember.Marca = #004) then R := R + 1;
                         end;
                   'N' : If DDNo = '' then R := R + 1;
                   '*' : If (EEMember.Depto = DDNo) or
                            (DDNo           = Copy(EEMember.Depto,1,Length(DDNo))) then R := R + 1;
              end;
            end
            else If BBMember.OrigBancoC <> EEMember.BcoFgts then RC := 'N';
       end;
  Until RC = 'N';
  If R > LPag then
     begin
       If Frac(R / LPag) <> 0 then I := 1
                              else I := 0;
       R := Trunc(R / LPag) + I;
     end
     else R := 1;
end;


Procedure ImprimeFgts(X : Char);
Var
  Valor,Valor13  : Real;
begin
  Valor := 0;
  YYNo  := '083';
  SearchTreeY ( RootY );
  If RC = 'S' then Valor := YAddress^.AcMensalV;
  Valor13 := 0;
  YYNo := '087';
  SearchTreeY ( RootY );
  If RC = 'S' then Valor13 := YAddress^.AcMensalV;

  If (ContLin >= 1000) or (GrMember.Func = 19) then
     begin
       If ContLin < 1000 then
          begin
            ProcNo14Total(X);
            GrMember.VGuia[2] := 0;
            GrMember.Func     := 0;
          end;
       ProcNo14Header(X);
     end;
  GrMember.VGuia[2] := GrMember.VGuia[2] + TruncX(Valor);
  GrMember.Func     := GrMember.Func     + 1;
  If EEMember.DDResc = ''
     then WriteLine('L',Cx+ConstStr(' ',3)+
                        PushLeft(16,EEMember.ContaFgts)+
                        EEMember.DDAdm+'/'+
                        EEMember.MMAdm+'/'+
                        EEMember.AAAdm+' '+
                        PushRight(11,EEMember.CtrabN)+'/'+
                        PushRight(6,EEMember.CtrabS)+' '+
                        PushLeft(12,EEMember.PisPasep)+
                        PushRight(12,EditReal(Valor))+' '+
                        PushRight(12,EditReal(Valor13))+' '+
                        EEMember.DataOpcao+' '+
                        Acentua(EEMember.Nome)+Cf)
     else WriteLine('L',Cx+ConstStr(' ',3)+
                        PushLeft(16,EEMember.ContaFgts)+
                        EEMember.DDAdm+'/'+
                        EEMember.MMAdm+'/'+
                        EEMember.AAAdm+' '+
                        PushRight(11,EEMember.CtrabN)+'/'+
                        PushRight(6,EEMember.CtrabS)+' '+
                        PushLeft(12,EEMember.PisPasep)+
                        PushRight(12,EditReal(Valor))+' '+
                        PushRight(12,EditReal(Valor13))+' '+
                        EEMember.DataOpcao+' '+
                        Acentua(EEMember.Nome)+
                        ConstStr(' ',41-Length(EEMember.Nome))+
                        PushLeft(2,EEMember.DDResc)+'/'+
                        PushLeft(2,EEMember.MMResc)+'/'+
                        PushLeft(4,EEMember.AAResc)+
                        EEMember.Causa+Cf);
end;


Procedure ImprimeGR;
begin
  For K := 1 to 4 do WriteLine('L',' ');
  WriteLine('L',ConstStr(' ',3)+Acentua(CMstMember.Descricao));
  WriteLine('L',' ');
  WriteLine('L',ConstStr(' ',3)+Cx+Acentua(CMstMember.Endereco)+', '+
                                   Acentua(CMstMember.Numero)+' '+
                                   Acentua(CMstMember.Complemento)+Cf);
  WriteLine('L',' ');
  WriteLine('L',ConstStr(' ',3)+Cx+PushLeft(14,CMstMember.Cep)+
                                   Acentua(CMstMember.Bairro)+
                                   ConstStr(' ',30-Length(CMstMember.Bairro))+
                                   Acentua(CMstMember.Municipio)+
                                   ConstStr(' ',30-Length(CMstMember.Municipio))+
                                   CMstMember.Estado+Cf);
  WriteLine('L',' ');
  WriteLine('L',ConstStr(' ',3)+Cx+Acentua(GRMember.NomeBanco)+
                                   ConstStr(' ',55-Length(GRMember.NomeBanco))+
                                   PushRight(20,EditReal(GrMember.VGuia[2]))+Cf);
  WriteLine('L',' ');
  WriteLine('L',ConstStr(' ',3)+Cx+Acentua(GRMember.NomeAgencia)+
                                   ConstStr(' ',40-Length(GRMember.NomeAgencia))+
                                   PushLeft(29,CMstMember.Conta)+
                                   PushLeft(23,CMstMember.Unid_Trab)+
                                   PushRight(18,EditReal(GrMember.VGuia[1]))+Cf);
  WriteLine('L',' ');
  Case GrMember.Tipo of
       '1' : WriteLine('L',ConstStr(' ',3)+Cx+Acentua('Dep¢sito no Prazo            ')+
                           ConstStr(' ',28)+'116'+
                           PushRight(15,EditInteger(GrMember.Func))+Cf);
       '2' : WriteLine('L',ConstStr(' ',3)+Cx+Acentua('Dep¢sito em Atraso           ')+
                           ConstStr(' ',28)+'108'+
                           PushRight(15,EditInteger(GrMember.Func))+Cf);
       '3' : WriteLine('L',ConstStr(' ',3)+Cx+Acentua('Recolhimentos de Filantr¢pica')+
                           ConstStr(' ',28)+'604'+
                           PushRight(15,EditInteger(GrMember.Func))+Cf);
  end;
  WriteLine('L',' ');
  WriteLine('L',ConstStr(' ',31)+Cx+ConstStr(' ',3)+MMx+'/'+AAx+
                ConstStr(' ',8)+Acentua(ArrayMesEx[MM])+Cf);
  WriteLine('L',' ');
  If GrMember.Total = 0 then WriteLine('L',' ')
     else WriteLine('L',ConstStr(' ',3)+Cx+ConstStr(' ',92)+
                        PushRight(18,EditReal(GrMember.Total))+Cf);
  For K := 1 to 5 do WriteLine('L',' ');
end;


Procedure ProcNo14Report(X : Char);
Var
  Linhas,Tipo2,Opt,NOpt         : Integer;
  VOpt,VNOpt,Valor13,
  VTotal,VTotal13               : Real;
  Sel,Tot,CausaR,TipoOpt        : Char;
  TipoVin                       : String[2];
  DataXX                        : String[6];
begin
  PedeDepto(10,'*');
  If TC <> #27 then PedeBanco(X);
  If (X = '2') and (TC = 'S') then
     begin
       Color(Tfn,Ttx);
       GotoXY(4,17); Write('Tot.S/N:');
       Tot := 'S';
       Repeat
         J := Tot;
         InputStr(J,1,13,17,0,'S','N','T','N',Tfn,Utx);
         Tot := UpCase(J[1]);
         GotoXY(13,17);
         If TC <> #27 then
            Case Tot of
                 'N' : Write('NÆo     (deixar Total em branco)');
                 'S' : Write('Sim     (imprimir o Total)      ');
                 else begin
                        ErroMsg := 'Imprimir o Total, informe S ou N';
                        ErrorMessage;
                        K := K - 1;
                      end;
            end;
         If TC <> #27 then Confirma;
       Until TC in [#27,'S'];
     end;
  If TC = 'S' then
     begin
       LoadIndex6 ('F',Tr);
       If TC <> #27 then
          begin
            MMx := QQStr(MM,2,'0');
            AAx := QQStr(AA,4,'0');
            Linhas := 0;
            ParaContinua;
            Janela('F');
            Linhas   := 1;
            Tipo2    := 0;
            Opt      := 0;
            NOpt     := 0;
            VOpt     := 0;
            VNOpt    := 0;
            VTotal   := 0;
            VTotal13 := 0;

            BBAC := BBNo;
            If BBNo <> '' then
               begin
                 RC := 'N';
                 SearchAnt7 ( Root7 );
                 If RC = 'N' then BBNo := '';
               end;
            Repeat
              RC := 'N';
              SearchPos7 ( Root7 );
              If RC = 'S' then
                 begin
                   ContPag := 0;
                   ReadWrite(#06,'R','N',BBNumber);
                   If X <> '3' then
                      begin
                        XXNo := 'F#' + BBNo + '#';
                        ProcNo14Calc(X);
                      end;
                   GrMember.Cia         := CmpyNo;
                   GrMember.Func        := 0;
                   GrMember.VGuia[1]    := 0;
                   GrMember.VGuia[2]    := 0;
                   GrMember.Tipo        := Tx;
                   GrMember.NomeBanco   := BBMember.NomeBanco;
                   GrMember.NomeAgencia := BBMember.NomeAgencia;
                   XXNo  := 'F#' + BBNo + '#';
                   Repeat
                     RC := 'N';
                     SearchPos6 ( Root6 );
                     If (RC             = 'S') and
                        (Copy(XXNo,1,1) = 'F') then
                        begin
                          Sel := 'N';
                          ReadWrite(#08,'R','N',XXNumber);
                          If (EEMember.BcoFgts     = BBMember.OrigBancoC) and
                             (EEMember.Status     <> 'R'                ) and
                             (EEMember.Status     <> 'V'                ) and
                             (EEMember.Status     <> 'X'                ) and
                             (EEMember.Vinculo[1] <> 'A'                ) and
                             (EEMember.Vinculo[1] <> 'N'                ) then
                             begin
                               Case Ex of
                                    'D' : If EEMember.Depto = DDNo then Sel := 'S';
                                    'X' : begin
                                            DDNo := EEMember.Depto;
                                            SearchTree3 ( Root3 );
                                            If RC = 'S' then ReadWrite(#05,'R','N',DDNumber)
                                               else RC := 'S';
                                            If (EEMember.Depto = DDNo) and
                                               (DDMember.Marca = #004) then Sel := 'S';
                                          end;
                                    'N' : If DDNo = '' then Sel := 'S';
                                    '*' : If (EEMember.Depto = DDNo) or
                                             (DDNo           = Copy(EEMember.Depto,1,Length(DDNo))) then Sel := 'S';
                               end;
                             end;
                          If Sel = 'S' then
                             begin
                               Writeln(EEMember.Nome);
                               EENo := EEMember.Matricula;
                               LoadMVDsk(#11);
                               NCont := NCont + 1;
                               If X = '1' then ImprimeFgts(X)
                                  else begin
                                         GrMember.Func     := GrMember.Func + 1;
                                         GrMember.VGuia[1] := GrMember.VGuia[1] + Valor;
                                         Case Eta of
                                              'A','P' : YYNo := '083';
                                              '1'     : YYNo := '087';
                                         end;
                                         SearchTreeY ( RootY );
                                         If RC = 'S'
                                            then GrMember.VGuia[2] := GrMember.VGuia[2] +
                                                                      YAddress^.AcMensalV;
                                         If Eta = 'A' then
                                            begin
                                              YYNo := '087';
                                              SearchTreeY ( RootY );
                                              If RC = 'S'
                                                 then GrMember.VGuia[2] := GrMember.VGuia[2] + YAddress^.AcMensalV;
                                            end;
                                       end;
                               RC := 'S';
                               LiberaMVDsk;
                             end
                             else If BBMember.OrigBancoC <> EEMember.BcoFgts
                                     then RC := 'N';
                        end;
                     GoNoGo;
                     If TC = #27 then RC := 'N';
                   Until RC = 'N';
                   If GrMember.Func > 0 then
                      begin
                        If X = '1' then
                           begin
                             ProcNo14Total(X);
                             If X = '2' then Footer;
                             ContLin := 2000;
                           end
                           else begin
                                  Case Tot of
                                       'N' : GrMember.Total := 0;
                                       'S' : GrMember.Total := GrMember.VGuia[1];
                                  end;
                                  Case DskRpt of
                                       'D' : TC := 'S';
                                       'N' : ImprimeAgora;
                                  end;
                                  Case TC of
                                       'A','S' : begin
                                                   If TC = 'A' then FormTest('S','N','***')
                                                               else TC := 'S';
                                                   If TC = 'S' then ImprimeGR;
                                                 end;
                                       'G' : begin
                                               Assign ( GRFile, (XDrive + '\GR____'+AAx+'.M'+MMx));
                                               {$I-}
                                               Reset ( GRFile );
                                               {$I+}
                                               If IOResult <> 0 then
                                                  begin
                                                    ReWrite ( GRFile );
                                                    Reset   ( GRFile );
                                                  end;
                                               Seek  ( GRFile, FileSize(GRFile));
                                               Write ( GRFile, GRMember        );
                                               Close ( GRFile );
                                             end;
                                  end;
                                end;
                      end;
	           If BBNo = BBAC then RC := 'N'
                                  else RC := 'S';
                 end;
            Until RC = 'N';
            If (NCont > 0) and (X in ['1','2']) then WriteLine('W',Qp);
            FuncImpressos;
          end;
     end;
end;


Procedure AlocaCia(X : Str3);
begin
  TC := 'S';
  Assign( CMstFile, (XDrive + '\PLOGM' + X + '\' + FileCMst));
  {$I-}
  Reset ( CMstFile );
  {$I+}
  If IOResult = 0 then ReadWrite(#16,'R','N',0)
                  else RW := 'N';
  If RW = 'S' then
     begin
       Color(Bfn,Btx);
       GotoXY(4,19); Write(PushLeft(41,CMstMember.Descricao));
       Color(Sfn,Stx);
     end
     else begin
            Color(Blue,White);
            GotoXY(01,23); Write(ConstStr(' ',80));
            GotoXY(02,23); Write('NÆo consigo acessar o arquivo da Empresa ' + X + ', vou cancelar!');
            TeclaReturn;
            TC := #27;
          end;
end;


Procedure ImprimeGRPS;
begin
  WriteLine('L',' ');
  WriteLine('L',' ');
  WriteLine('L',ConstStr(' ',42)+GuiaMember.GRPSTipo+ConstStr(' ',13)+
                                 GuiaMember.GRPSIdent);
  WriteLine('L',' ');
  WriteLine('L',ConstStr(' ',42)+CMstMember.Cod_Fpas);
  WriteLine('L',' ');
  WriteLine('L',ConstStr(' ',42)+MMx[1]+'  '+MMx[2]+'  '+AAx[1]+'  '+AAx[2]);
  WriteLine('L',' ');
  WriteLine('L',' ');
  WriteLine('L',ConstStr(' ',61)+PushRight(16,EditReal(GuiaMember.VGuia[5])));
  WriteLine('L',' ');
  WriteLine('L',ConstStr(' ',61)+PushRight(16,EditReal(TruncX(GuiaMember.VGuia[4]+GuiaMember.VGuia[6]))));
  WriteLine('L',' '+Cx+Acentua(CMstMember.Descricao)+Cf);
  WriteLine('L',ConstStr(' ',55)+PushLeft(6,CMstMember.Terceiros)+
                                 PushRight(16,EditReal(GuiaMember.VGuia[7])));
  WriteLine('L',' ');
  If GuiaMember.VGuia[8] > 0 then WriteLine('L',ConstStr(' ',43)+Acentua('Espec¡fico')+'  '+
                                                PushLeft(6,CMstMember.Cod_19)+
                                                PushRight(16,EditReal(GuiaMember.VGuia[8])))
                             else WriteLine('L',' ');
  WriteLine('L',' '+Cx+Acentua(GuiaMember.Endereco)+Cf);
  If GuiaMember.VGuia[9] > 0 then WriteLine('L',ConstStr(' ',43)+Acentua('Espec¡fico')+'  '+
                                                PushLeft(6,CMstMember.Cod_20)+
                                                PushRight(16,EditReal(GuiaMember.VGuia[9])))
                             else WriteLine('L',' ');
  WriteLine('L',ConstStr(' ',31)+Cx+CMstMember.Telefone+Cf);
  WriteLine('L',ConstStr(' ',61)+PushRight(16,EditReal(GuiaMember.VGuia[10])));
  WriteLine('L',PushLeft(11,GuiaMember.Cep)+
                Acentua(GuiaMember.Cidade)+
                ConstStr(' ',24-Length(GuiaMember.Cidade))+
                GuiaMember.Estado);
  WriteLine('L',ConstStr(' ',61)+PushRight(16,EditReal(GuiaMember.VGuia[14])));
  WriteLine('L',ConstStr(' ',31)+PushRight(5,EditInteger(Trunc(GuiaMember.VGuia[1]))));
  WriteLine('L',' ');
  WriteLine('L',ConstStr(' ',18)+PushRight(18,EditReal(GuiaMember.VGuia[2])));
  WriteLine('L',' ');
  WriteLine('L',ConstStr(' ',18)+PushRight(18,EditReal(GuiaMember.VGuia[3])));
  If GuiaMember.Total = 0 then WriteLine('L',' ')
     else WriteLine('L',ConstStr(' ',61)+PushRight(16,EditReal(GuiaMember.VGuia[14])));
  WriteLine('L',ConstStr(' ',8)+PushLeft(12,CMstMember.Cod_Sat)+
                                PushRight(16,EditReal(GuiaMember.VGuia[4])));
  For K := 1 to 7 do WriteLine('L',' ');
end;


Procedure GeralGRPS;
begin
  QPorta;
  If TC <> #27 then
     begin
       Assign ( GuiaFile, (XDrive + '\GRPS__'+AAx+'.M'+MMx));
       {$I-}
       Reset ( GuiaFile );
       {$I+}
       If IOResult = 0 then
          begin
            FormTest('S','N','***');
            If TC = 'S' then
               begin
                 I := -1;
                 Repeat
                   I := I + 1;
                   {$I-}
                   Seek ( GuiaFile, I          );
                   Read ( GuiaFile, GuiaMember );
                   {$I+}
                   If IOResult = 0 then
                      begin
                        AlocaCia(GuiaMember.Cia);
                        If TC = 'S' then
                           begin
                             ImprimeGRPS;
                             Close ( CMstFile );
                           end;
                      end
                      else begin
                             Color(Blue,White);
                             GotoXY(01,23);  Write(ConstStr(' ',80));
                             GotoXY(02,23);  Write('NÆo consigo acessar o arquivo, vou cancelar!');
                             TeclaReturn;
                             I  := FileSize(GuiaFile) - 1;
                             TC := 'S';
                           end;
                 Until (I+1) = FileSize(GuiaFile);
                 Close ( GuiaFile );
               end;
          end;
       Close ( LST );
     end;
end;


Procedure GeralGR;
begin
  QPorta;
  If TC <> #27 then
     begin
       Assign ( GRFile, (XDrive + '\GR____'+AAx+'.M'+MMx));
       {$I-}
       Reset ( GRFile );
       {$I+}
       If IOResult = 0 then
          begin
            FormTest('S','N','***');
            If TC = 'S' then
               begin
                 I := -1;
                 Repeat
                   I := I + 1;
                   {$I-}
                   Seek ( GRFile, I          );
                   Read ( GRFile, GRMember );
                   {$I+}
                   If IOResult = 0 then
                      begin
                        AlocaCia(GRMember.Cia);
                        If TC = 'S' then
                           begin
                             ImprimeGR;
                             Close ( CMstFile );
                           end;
                      end
                      else begin
                             Color(Blue,White);
                             GotoXY(01,23);  Write(ConstStr(' ',80));
                             GotoXY(02,23);  Write('NÆo consigo acessar o arquivo, vou cancelar!');
                             TeclaReturn;
                             TC := #27;
                           end;
                 Until ((I+1) = FileSize(GRFile)) or (TC = #27);
                 Close ( GRFile );
               end;
          end;
       Close ( LST );
     end;
end;


Procedure ImprimeGRCS;
Var
  TipoEs        : Str80;
begin
  TipoEs := GRCSMember.Descricao + GRCSMember.Descricao2;
  WriteLine('L',Acentua(Copy(TipoEs,1,70))+
                ConstStr(' ',75-Length(Copy(TipoEs,1,70)))+
                GRCSMember.Cod);
  WriteLine('L',' ');
  WriteLine('L',Acentua(GRCSMember.Endereco)+
                ConstStr(' ',42-Length(GRCSMember.Endereco))+', '+
                PushLeft(11,GRCSMember.Numero)+' '+
                PushLeft(18,GRCSMember.Complemento)+
                GRCSMember.Cod);
  WriteLine('L',' ');
  WriteLine('L',Acentua(GRCSMember.Bairro)+
                ConstStr(' ',38-Length(GRCSMember.Bairro))+
                PushLeft(15,GRCSMember.Cep)+
                Acentua(GRCSMember.Cidade)+
                ConstStr(' ',36-Length(GRCSMember.Cidade))+
                GRCSMember.Estado);
  WriteLine('L',' ');
  WriteLine('L',' ');
  WriteLine('L',Acentua(CMstMember.Descricao)+
                ConstStr(' ',75-Length(CMstMember.Descricao))+
                CMstMember.Cod_Estab);
  WriteLine('L',' ');
  WriteLine('L',Acentua(CMstMember.Endereco)+
                ConstStr(' ',42-Length(CMstMember.Endereco))+
                PushLeft(11,CMstMember.Numero)+
                PushLeft(21,CMstMember.Complemento)+
                CMstMember.Inicio);
  WriteLine('L',' ');
  WriteLine('L',PushLeft(17,CMstMember.Cep)+
                Acentua(CMstMember.Cidade)+
                ConstStr(' ',36-Length(CMstMember.Cidade))+
                Acentua(CMstMember.Bairro)+
                ConstStr(' ',36-Length(CMstMember.Bairro))+
                CMstMember.Estado);
  WriteLine('L',' ');
  Case CMstMember.CBO_Tipo of
       '1' : TipoEs := 'x                     ';
       '2' : TipoEs := '       x              ';
       '3' : TipoEs := '              x       ';
       '4' : TipoEs := '                     x';
  end;
  WriteLine('L',Acentua(CMstMember.Atividade)+
                ConstStr(' ',26-Length(CMstMember.Atividade))+
                PushLeft(8,CMstMember.Codigo)+
                PushLeft(13,CMstMember.Sub_Codigo)+
                PushLeft(10,CMstMember.CBO)+
                PushLeft(31,TipoEs)+
                EditInteger(CMstMember.Numero_Estab));
  WriteLine('L',' ');
  WriteLine('L',' ');
  Case GRCSMember.Tipo of
       '1' : TipoEs := 'x           x                 x';
       '2' : TipoEs := '            x                  ';
       '3' : TipoEs := '                              x';
  end;
  WriteLine('L',ConstStr(' ',2)+PushLeft(71,TipoEs)+PushRight(17,EditReal(GRCSMember.VGuia[1])));
  WriteLine('L',' ');
  WriteLine('L',ConstStr(' ',41)+EditInteger(GRCSMember.Func));
  WriteLine('L',' ');
  WriteLine('L',ConstStr(' ',41)+EditReal(GRCSMember.VGuia[2]));
  WriteLine('L',' ');
  WriteLine('L',ConstStr(' ',41)+EditInteger(GRCSMember.Func + GRCSMember.NFunc));
  WriteLine('L',' ');
  WriteLine('L',ConstStr(' ',41)+EditInteger(GRCSMember.NFunc));
  WriteLine('L',' ');
  WriteLine('L',' ');
  WriteLine('L',' ');
  WriteLine('L',PushLeft(30,CMstMember.Cidade)+
                EditInteger(TabDia[MM])+'/'+MMx+'/'+AAx);
  For K := 1 to 14 do WriteLine('L',' ');
end;


Procedure GeralGRCS;
begin
  QPorta;
  If TC <> #27 then
     begin
       Assign ( GRCSFile, (XDrive + '\GRCS__'+AAx+'.DAT'));
       {$I-}
       Reset ( GRCSFile );
       {$I+}
       If IOResult = 0 then
          begin
            FormTest('S','N','***');
            If TC = 'S' then
               begin
                 I := -1;
                 Repeat
                   I := I + 1;
                   {$I-}
                   Seek ( GRCSFile, I          );
                   Read ( GRCSFile, GRCSMember );
                   {$I+}
                   If IOResult = 0 then
                      begin
                        AlocaCia(GRCSMember.Cia);
                        If TC = 'S' then
                           begin
                             ImprimeGRCS;
                             Close ( CMstFile );
                           end;
                      end
                      else begin
                             Color(Blue,White);
                             GotoXY(01,23);  Write(ConstStr(' ',80));
                             GotoXY(02,23);  Write('NÆo consigo acessar o arquivo, vou cancelar!');
                             TeclaReturn;
                             TC := #27;
                           end;
                 Until ((I+1) = FileSize(GRCSFile)) or (TC = #27);
                 Close ( GRCSFile );
               end;
          end;
       Close ( LST );
     end;
end;


Procedure ImprimeDARF;
Var
  TipoDarf    : String[10];
begin
  Case CMstMember.Etapa of
       'P' : TipoDarf := '(Pag.)';
       'S' : TipoDarf := '(13o.)';
  end;
  WriteLine('L',ConstStr(' ',60)+Acentua(DARFMember.Venc));
  WriteLine('L',' ');
  WriteLine('L',ConstStr(' ',60)+CMstMember.Cgc);
  WriteLine('L',' ');
  WriteLine('L',ConstStr(' ',56)+Acentua(DARFMember.Receita));
  For K := 1 to 5 do WriteLine('L',' ');
  WriteLine('L',Acentua(CMstMember.Descricao)+
                ConstStr(' ',42-Length(CMstMember.Descricao))+
                PushLeft(13,CMstMember.Telefone)+
                PushRight(20,EditReal(DARFMember.VGuia)));
  WriteLine('L',' ');
  WriteLine('L',' ');
  WriteLine('L',Acentua('Imposto de renda na Fonte, mˆs de'));
  WriteLine('L',Acentua('competˆncia '+ArrayMesEx[MM]+' ')+AAx+ ' '+TipoDarf);
  WriteLine('L',' ');
  If DARFMember.Total = 0 then WriteLine('L',' ')
     else WriteLine('L',ConstStr(' ',55)+PushRight(20,EditReal(DARFMember.Total)));
  For K := 1 to 7 do WriteLine('L',' ');
end;


Procedure GeralDARF;
begin
  QPorta;
  If TC <> #27 then
     begin
       Assign ( DARFFile, (XDrive + '\DARF__'+AAx+'.M'+MMx));
       {$I-}
       Reset ( DARFFile );
       {$I+}
       If IOResult = 0 then
          begin
            FormTest('S','N','***');
            If TC = 'S' then
               begin
                 I := -1;
                 Repeat
                   I := I + 1;
                   {$I-}
                   Seek ( DARFFile, I          );
                   Read ( DARFFile, DARFMember );
                   {$I+}
                   If IOResult = 0 then
                      begin
                        AlocaCia(DARFMember.Cia);
                        If TC = 'S' then
                           begin
                             ImprimeDARF;
                             Close ( CMstFile );
                           end;
                      end
                      else begin
                             Color(Blue,White);
                             GotoXY(01,23);  Write(ConstStr(' ',80));
                             GotoXY(02,23);  Write('NÆo consigo acessar o arquivo, vou cancelar!');
                             TeclaReturn;
                             TC := #27;
                           end;
                 Until ((I+1) = FileSize(DARFFile)) or (TC = #27);
                 Close ( DARFFile );
               end;
          end;
       Close ( LST );
     end;
end;


end.

