{$O+,F+}
Unit PlogRpt7;

Interface

Uses Crt,Dos,PlogGlbs,PlogBasP,PlogTree,PlogRpt0,PlogRpt5;


   Procedure ProcNoXXReport(X : Char);


Implementation

Const
  Zeros        = '000000000000000000000000000000';

Type
  CAGED   = RECORD
              Convenio       : String[7];
              Respons        : String[30];
            END;
Var
   CagMember   : CAGED;
   CagFile     : FILE OF CAGED;

  IdDep,CodAlt : Char;
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


Procedure Total10;
begin
  WriteLine('L',ConstStr('-',80));
  WriteLine('L',' 29-'+Acentua(CMstMember.Descricao));
  WriteLine('L',' 30-'+Acentua(CMstMember.Endereco)+
                ConstStr(' ',41-Length(CMstMember.Endereco))+
               '31-'+Acentua(CMstMember.Bairro));
  WriteLine('L',' 32-'+Acentua(CMstMember.Cidade)+
                ConstStr(' ',31-Length(CMstMember.Cidade))+
                '33-'+CMstMember.Estado);
  WriteLine('L',' 34-'+Acentua(Responsavel));
  WriteLine('L',' 35-'+ConstStr(' ',70)+
                '36-'+PushLeft(6,CMstMember.DDD)+
                '37-'+PushLeft(10,CMstMember.Telefone));
end;


Procedure Detalhe10;
begin
  If EEMember.Tipo = 'H'
     then Valor := EEMember.Salario * EEMember.HNormais
     else Valor := EEMember.Salario;
  WriteLine('L',' '+PushLeft(13,EEMember.PisPasep)+
                    PushLeft(8,EEMember.Sexo)+
                    Pushleft(12,EEMember.Grau)+
                    PushLeft(7,EEMember.CBO)+Cx+
                    Acentua(EEMember.Nome)+Cf);
  WriteLine('L',' '+PushLeft(11,EEMember.CTrabN)+
                    PushLeft(6,Copy(EEMember.CTrabS,1,3))+
                    PushLeft(3,EEMember.CTrabE)+
                    Pushleft(9,EEMember.DDNasc+'/'+EEMember.MMNasc+'/'+EEMember.AANasc)+
                    PushLeft(08,EditReal(Valor))+
                    PushLeft(9,EditInteger(((Trunc(EEMember.HNormais/30) * 6))))+
                    PushLeft(11,EEMember.DDAdm+'/'+EEMember.MMAdm+'/'+EEMember.AAAdm)+
                    PushLeft(12,EEMember.DDResc)+XX);
  If ContLin = 12 then Total10
                  else WriteLine('L',' ');
end;


Procedure PedeCAGED(X : Char);
begin
  Assign ( CagFile, (XPath + '\PLOGCAGD.DAT'));
  {$I-}
  Reset ( CagFile );
  {$I+}
  If IOResult <> 0 then
     begin
       ReWrite ( CagFile );
       Reset   ( CagFile );

       CagMember.Convenio  := '';
       CagMember.Respons   := '';
     end
     else begin
            Seek  ( CagFile, 0        );
            Read  ( CagFile,CagMember );
          end;
  Color(Tfn,Ttx);
  GotoXY(4,10); Write('Mud.End:');
  GotoXY(4,11); Write('Enc.Ati:');
  GotoXY(4,12); Write('1¦ Decl:');
  GotoXY(4,13); Write('Corr.De:');
  GotoXY(4,14); If X = 'S' then Write('N§Conv.:')
                           else Write('Respons:');
  Color(Tfn,Utx);
  Mud  := 'N';
  Enc  := 'N';
  Dec1 := 'N';
  Corr := 'N';
  Repeat
    K := 1;
    Repeat
      Case K of
           1  :  begin
                   J := '';
                   InputStr(J,1,13,10,0,'S','N','T','N',Tfn,Utx);
                   If J  = ''  then J := 'N';
                   If J <> 'N' then J := 'S';
                   Mud := UpCase(J[1]);
                   GotoXY(13,10); Write(Mud);
                 end;
           2  :  begin
                   J := '';
                   InputStr(J,1,13,11,0,'S','N','T','N',Tfn,Utx);
                   If J  = ''  then J := 'N';
                   If J <> 'N' then J := 'S';
                   Enc := UpCase(J[1]);
                   GotoXY(13,11); Write(Enc);
                 end;
           3  :  begin
                   J := '';
                   InputStr(J,1,13,12,0,'S','N','T','N',Tfn,Utx);
                   If J  = ''  then J := 'N';
                   If J <> 'N' then J := 'S';
                   Dec1 := UpCase(J[1]);
                   GotoXY(13,12); Write(Dec1);
                 end;
           4  :  begin
                   J := '';
                   InputStr(J,1,13,13,0,'S','N','T','N',Tfn,Utx);
                   If J  = ''  then J := 'N';
                   If J <> 'N' then J := 'S';
                   Corr := UpCase(J[1]);
                   GotoXY(13,13); Write(Corr);
                 end;
           5  :  If X = 'N' then
                    begin
                      J := CagMember.Respons;
                      InputStr(J,30,13,14,0,'S','S','T','N',Tfn,Utx);
                      CagMember.Respons := J;
                      Responsavel       := J;
                      GotoXY(13,14); Write(Responsavel);
                    end;
           6  :  If X = 'S' then
                    begin
                      J := CagMember.Convenio;
                      InputStr(J,7,13,14,0,'S','S','T','N',Tfn,Utx);
                      CagMember.Convenio := J;
                      GotoXY(13,14); Write(CagMember.Convenio);
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
     begin
       Seek  ( CagFile, 0         );
       Write ( CagFile, CagMember );
     end;
end;


Procedure ProcNoXXReport(X : Char);
Var
  GrauI,
  XEnc,
  XDec1,
  XMud,
  XSexo,
  TFolha               : Char;
  Linhas,Tot30,Horas   : Integer;
begin
  Case ProcNo of
       10 : PedeCAGED(X);
       11 : PedeCadastro;
       12 : begin
              Repeat
                PedeDepto(11,'*');
                If TC <> #27 then Confirma;
              Until TC in [#27,'S'];
            end;
       15 : begin
              DARFMember.Cia      := CmpyNo;
              DARFMember.Venc     := '';
              DARFMember.Receita  := '';
              DARFMember.VGuia    := 0;
              PedeProc15;
            end;
       else Confirma;
  end;
  If TC = 'S' then
     begin
       AAx := QQStr(AA,4,'0');
       MMx := QQStr(MM,2,'0');
       Case ProcNo of
            08 : begin
                   L1 := Nx+'Rela‡„o de INSS  de '+Nf+
                         ArrayMesEx[MM]+'/'+AAx;
                   L6 := 'Matr¡cula  Nome do Empregado'+ConstStr(' ',10)+
                         'Sal.Contrib.       Desconto      P/Empresa';
                   R1   := 0;
                   R2   := 0;
                   R3   := 0;
                 end;
            10 : begin
                   L1 := Nx+'Admitidos & Demitidos em '++Nf+
                         ArrayMesEx[MM]+'/'+AAx;
                   L6 := 'Matr¡cula       Nome do Empregado'+
                         ConstStr(' ',26)+'Admiss„o     Rescis„o';
                   FF   := 0;
                   A1   := 0;
                   Ar   := 0;
                   At   := 0;
                   DD   := 0;
                   Dj   := 0;
                   Dp   := 0;
                   Da   := 0;
                   Dm   := 0;
                   Dt   := 0;
                   Dc   := 0;
                   Tot30 := 0;
                   EENo  := '';
                   Mx := QQStr(CMstMember.MesAtivo,2,'0');
                   Ax := QQStr(CMstMember.AnoAtivo,4,'0');
                   Repeat
                     RC := 'N';
                     SearchPos5 ( Root5 );
                     If RC = 'S' then
                        With EEMember do
                        begin
                          ReadWrite(#08,'R','N',EENumber);
                          If (Status     <> 'R') and
                             (Status     <> 'X') and
                             (Vinculo[1] <> 'A') and
                             (Vinculo[1] <> 'N') then
                             begin
                               If ((AAAdm = Ax)  and
                                   (MMAdm = Mx)) or
                                  (Status = 'E') then
                                  begin
                                    Case TipoE of
                                         '1' : A1 := A1 + 1;
                                         'R' : Ar := Ar + 1;
                                         'T' : At := At + 1;
                                    end;
                                  end
                                  else FF := FF + 1;
                               If (AAResc = Ax) and
                                  (MMResc = Mx) then
                                  Case Status of
                                         'D' : DD := DD + 1;
                                         'J' : Dj := Dj + 1;
                                         'P' : Dp := Dp + 1;
                                         'O' : Da := Da + 1;
                                         'N' : Dc := Dc + 1;
                                         'M' : Dm := Dm + 1;
                                         'T' : Dt := Dt + 1;
                               end;
                             end;
                        end;
                   Until RC = 'N';
                   Adm     := A1 + Ar + At;
                   Dem     := DD + Dj + Dp + Da + Dm + Dt;
                   If X = 'S' then
                      begin
                        If Enc = 'N' then XEnc := '2'
                                     else XEnc := '1';
                        If Dec1 = 'N' then XDec1 := '2'
                                      else XDec1 := '1';
                        If Mud = 'N' then XMud := '2'
                                     else XMud := '1';
                        Linhas := 1;
                        Writeln (LST,'10',
                                 FString(CagMember.Convenio,7),
                                 CMstMember.Tipo,
                                 FString(LimpaChave(CMstMember.CGC),14),
                                 QQStr(Linhas,6,'0'),
                                 Mx,Ax,
                                 '9',
                                 XEnc,
                                 XDec1,
                                 XMud,
                                 LimpaChave(CMstMember.Cep),
                                 '0',
                                 Maiuscula(CMstMember.Descricao,40),
                                 Maiuscula(CMstMember.Endereco,20),
                                 Maiuscula(CMstMember.Numero,5),
                                 Maiuscula(CMstMember.Bairro,16),
                                 Maiuscula(CMstMember.Cidade,16),
                                 FString(CMstMember.Estado,2),
                                 ConstStr(' ',4));

                        Linhas := Linhas + 1;
                        Writeln (LST,'20',
                                 FString(CagMember.Convenio,7),
                                 CMstMember.Tipo,
                                 FString(LimpaChave(CMstMember.CGC),14),
                                 QQStr(Linhas,6,'0'),
                                 Mx,Ax,
                                 '9',
                                 XEnc,
                                 XDec1,
                                 XMud,
                                 LimpaChave(CMstMember.Cep),
                                 FString(LimpaChave(CMstMember.CNAE),5),
                                 Maiuscula(CMstMember.Descricao,40),
                                 Maiuscula(CMstMember.Endereco,20),
                                 Maiuscula(CMstMember.Numero,5),
                                 Maiuscula(CMstMember.Bairro,16),
                                 Maiuscula(CMstMember.Cidade,16),
                                 FString(CMstMember.Estado,2));
                      end
                      else begin
                             ContLin := 20;
                             ContPag := 0;
                           end;
                 end;
            11 : begin
                  L1 := Nx+'Ficha Financeira em '+Nf+
                        ArrayMesEx[MM]+'/'+AAx;
                  L6 := ' Cta Descri‡„o'+ConstStr(' ',22)+'T  Acumulado'+
                        '   Mensal       Acumulado  Anual';
                 end;
            12 : begin
                   L1 := Nx+'Totaliza‡„o da Folha de Pag. de '+Nf+
                         ArrayMesEx[MM]+'/'+AAx;
                   L4 := ' ';
                   Case Ex of
                        'D' : L5 := 'Departamento '+DDNo;
                        'N' : L5 := 'Totaliza‡„o Geral';
                        'X' : L5 := 'Departamentos Marcados';
                   end;
                   L6 := ConstStr(' ',10)+Cx+
                         'Cta Descri‡„o                      T'+
                         '  HH(Mˆs)   Acumulado Mensal HH(Anua'+
                         'l)        Acumulado Anual'+Cf;
                   Close ( SSFile );
                   AbreTotal;
                   R1 := 0;
                   Tx := '*';
                 end;
            15 : begin
                   Case Folha of
                        'N': begin
                               L1 := Nx+'Imposto de Renda na Fonte de '+Nf+
                                     ArrayMesEx[MM]+'/'+AAx+'(Empregados)';
                               L6 := 'Matr¡cula      Nome do Empregado'+
                                     ConstStr(' ',17)+'Base de C lculo        Desconto';
                             end;
                        'A': begin
                               L1 := Nx+'Imposto de Renda na Fonte de '+Nf+
                                     ArrayMesEx[MM]+'/'+AAx+'(Aut“nomos)';
                               L6 := 'Matr¡cula      Nome'+
                                     ConstStr(' ',30)+'Base de C lculo        Desconto';
                             end;
                        'E': begin
                               L1 := Nx+'Imposto de Renda na Fonte de '+Nf+
                                     ArrayMesEx[MM]+'/'+AAx+'(Empregadores)';
                               L6 := 'Matr¡cula      Nome do Empregador'+
                                     ConstStr(' ',16)+'Base de C lculo        Desconto';
                             end;
                        'T': begin
                               L1 := Nx+'Imposto de Renda na Fonte de '+Nf+
                                     ArrayMesEx[MM]+'/'+AAx;
                               L6 := 'Matr¡cula      Nome do Empregado'+
                                     ConstStr(' ',17)+'Base de C lculo        Desconto';
                             end;
                   end;
                 end;
       end;
       ParaContinua;
       Janela('F');
       TProv  := 0;
       TDesc  := 0;
       Valor  := 0;
       If (ProcNo = 11) and (EENo <> '') then
          begin
            EEAC := EENo;
            RC   := 'N';
            SearchAnt5 ( Root5 );
            If RC = 'N' then EENo := '';
          end
          else begin
                 EENo := '';
                 EEAC := '';
               end;
       Repeat
         RC := 'N';
         SearchPos5 ( Root5 );
         If RC = 'S' then
            begin
              ReadWrite(#08,'R','N',EENumber);
              LoadMVDsk(#11);
              Case ProcNo of
                   08 : If (EEMember.Status <> 'R') and
                           (EEMember.Status <> 'X') then
                           begin
                             R1 := 0;
                             R2 := 0;
                             R3 := 0;
                             NCont := NCont + 1;
                             Writeln(EEMember.Nome);
                             If ContLin > 56 then HeaderReport;
                             YYNo := '061';
                             SearchTreeY ( RootY );
                             If RC = 'S' then R1 := YAddress^.AcMensalV;
                             YYNo := '064';
                             SearchTreeY ( RootY );
                             If RC = 'S' then R1 := R1 + YAddress^.AcMensalV;
                             YYNo := 'R50';
                             SearchTreeY ( RootY );
                             If RC = 'S' then R1 := R1 + YAddress^.AcMensalV;
                             YYNo := 'R51';
                             SearchTreeY ( RootY );
                             If RC = 'S' then R1 := R1 + YAddress^.AcMensalV;
                             YYNo := '062';
                             SearchTreeY ( RootY );
                             If RC = 'S' then R2 := YAddress^.AcMensalV;
                             YYNo := '071';
                             SearchTreeY ( RootY );
                             If RC = 'S' then R2 := R2 + YAddress^.AcMensalV;
                             YYNo := 'R71';
                             SearchTreeY ( RootY );
                             If RC = 'S' then R2 := R2 + YAddress^.AcMensalV;
                             YYNo := 'R72';
                             SearchTreeY ( RootY );
                             If RC = 'S' then R2 := R2 + YAddress^.AcMensalV;
                             YYNo := '081';
                             SearchTreeY ( RootY );
                             If RC = 'S' then R3 := YAddress^.AcMensalV;
                             YYNo := '085';
                             SearchTreeY ( RootY );
                             If RC = 'S' then R3 := R3 + YAddress^.AcMensalV;
                             YYNo := 'R81';
                             SearchTreeY ( RootY );
                             If RC = 'S' then R3 := R3 + YAddress^.AcMensalV;
                             YYNo := 'R85';
                             SearchTreeY ( RootY );
                             If RC = 'S' then R3 := R3 + YAddress^.AcMensalV;
                             TDesc := TDesc + TruncX(R1);
                             Valor := Valor + TruncX(R2);
                             TProv := TProv + TruncX(R3);
                             WriteLine('L',PushLeft(11,EEMember.Matricula)+
                                           Cx+Acentua(EEMember.Nome)+
                                           ConstStr(' ',41-Length(EEMember.Nome))+Cf+
                                           PushRight(14,EditReal(R3))+' '+
                                           PushRight(14,EditReal(R1))+' '+
                                           PushRight(14,EditReal(R2)));
                           end;
                   10 : If (EEMember.Status     <> 'R' ) and
                           (EEMember.Status     <> 'X' ) and
                           (EEMember.Vinculo[1] <> 'A' ) and
                           (EEMember.Vinculo[1] <> 'N' ) and
                           (((Ax = EEMember.AAAdm   )    and
                             (Mx = EEMember.MMAdm   ))   or
                            ((Ax = EEMember.AAResc   )   and
                             (Mx = EEMember.MMResc   ))) then
                           begin
                             NCont   := NCont + 1;
                             Writeln(EEMember.Nome);
                             If (ContLin > 12) and (X = 'N') then
                                begin
                                  ContPag := ContPag + 1;
                                  If ContPag = 1
                                     then WriteLine('L',ConstStr('-',80))
                                     else WriteLine('L',Qp+ConstStr('-',80));
                                  WriteLine('L',' 1-C.G.C.       2-C.E.I.(INSS)  3-Folhas 4-E.Folha 5-Mes/Ano');
                                  I := Trunc((Adm + Dem)/12);
                                  If ((Adm + Dem)/12) > I then I := I + 1;
                                  WriteLine('L',' '+PushLeft(15,LimpaChave(CMstMember.CGC))+
                                                    PushLeft(16,CMstMember.CGC_CEI)+
                                                    PushLeft(9,EditInteger(I))+
                                                    PushLeft(10,EditInteger(ContPag))+
                                                    Mx+'/'+Ax);
                                  WriteLine('L',' ');
                                  WriteLine('L',' 6-Cep     7-Ativ.Econ. 8-1a.Decl. 9-Enc.de Ativ.');
                                  WriteLine('L',' '+PushLeft(10,CMstMember.Cep)+
                                                    PushLeft(13,CMstMember.CNAE)+
                                                    PushLeft(11,Dec1)+Enc);
                                  WriteLine('L',' ');
                                  WriteLine('L',' 10-Mudou End. 11-Mud.Ativ.Econ. 12-Corr.Anterior                   '+
                                                '13-1.Dia');
                                  WriteLine('L',' '+PushLeft(14,Mud)+
                                                    PushLeft(18, 'N')+
                                                    PushLeft(35,Corr)+
                                                    PushLeft(5,EditInteger(FF)));
                                  WriteLine('L',' ');
                                  WriteLine('L',' 14-Admissoes no mes informado');
                                  WriteLine('L','   1o.Empr. + Reempr. + Transf. + Reintegr.                       = Total');
                                  WriteLine('L','   '+PushLeft(11,EditInteger(A1))+
                                                      PushLeft(10,EditInteger(Ar))+
                                                      PushLeft(10,EditInteger(At))+
                                                      PushLeft(34,'0')+
                                                      EditInteger(Adm));
                                  WriteLine('L',' ');
                                  WriteLine('L',' 15-Deslig.no mes informado');
                                  WriteLine('L','   s/J.C. + J.causa + pedido + apos. + morte + transf. + t.contr. = total');
                                  WriteLine('L','   '+PushLeft(9,EditInteger(DD))+
                                                      PushLeft(10,EditInteger(Dj))+
                                                      PushLeft(9,EditInteger(Dp))+
                                                      PushLeft(8,EditInteger(Da))+
                                                      PushLeft(8,EditInteger(Dm))+
                                                      PushLeft(10,EditInteger(Dt))+
                                                      PushLeft(11,EditInteger(Dc))+
                                                      EditInteger(Dem));
                                  WriteLine('L',' ');
                                  WriteLine('L',' 16-Total de empregados no ultimo dia do mes informado');
                                  WriteLine('L',ConstStr(' ',68)+
                                                EditInteger(FF + Adm - Dem));

                                  WriteLine('L',' ');
                                  WriteLine('L',ConstStr('-',80));
                                  WriteLine('L',' 17-Pis/Pasep 18-Sexo 19-Gr.Inst. 20-CBO 21-Nome completo');
                                  WriteLine('L',' 22-Cart.trab.  23-Nasc. 24-Remun. 25-Horas 26-Admis. 27-D.Deslig. 28-Tipo');
                                  WriteLine('L',ConstStr('-',80));
                                  WriteLine('L',' ');
                                  ContLin := 1;
                                end;
                             Str(NCont:2,J);
                             J := LeftAdjust(J);
                             If NCont < 10 then J := '0' + J;
                             If ((Ax = EEMember.AAAdm)  and
                                 (Mx = EEMember.MMAdm)) or
                                (EEMember.Status = 'E') then
                                begin
                                  Case EEMember.TipoE of
                                       '1' : XX := '10';
                                       'R' : XX := '20';
                                       'T' : XX := '70';
                                  end;
                                  If X = 'N' then Detalhe10;
                                 end;
                             If (Ax = EEMember.AAResc) and
                                (Mx = EEMember.MMResc) then
                                begin
                                  Case EEMember.Status of
                                       'D' : XX := '31';
                                       'J' : XX := '32';
                                       'P' : XX := '40';
                                       'O' : XX := '50';
                                       'M' : XX := '60';
                                       'N' : XX := '33';
                                       'T' : XX := '80';
                                  end;
                                  If X = 'N' then Detalhe10;
                                end;
                             If X = 'S' then
                                begin
                                  If EEMember.Tipo = 'H'
                                     then Valor := EEMember.Salario * EEMember.HNormais
                                     else Valor := EEMember.Salario;
                                  Horas  := 40;
                                  Tot30  := Tot30  + 1;
                                  Linhas := Linhas + 1;
                                  Case EEMember.Sexo of
                                       'F' : XSexo := '2';
                                       'M' : XSexo := '1';
                                  end;
                                  Case EEMember.Grau[1] of
                                       '1' : GrauI := '1';
                                       '2' : If EEMember.Grau[2] = '0' then GrauI := '2'
                                                                       else GrauI := '3';
                                       '3' : If EEMember.Grau[2] = '0' then GrauI := '4'
                                                                       else GrauI := '5';
                                       '4' : If EEMember.Grau[2] = '0' then GrauI := '6'
                                                                       else GrauI := '7';
                                       '5' : If EEMember.Grau[2] = '0' then GrauI := '8'
                                                                       else GrauI := '9';
                                       '6','7' : GrauI := '9';
                                       else      GrauI := ' ';
                                  end;
                                  If EEMember.DDResc = '' then EEMember.DDResc := '99';
                                  Writeln (LST,'30',
                                           FString(CagMember.Convenio,7),
                                           CMstMember.Tipo,
                                           FString(LimpaChave(CMstMember.CGC),14),
                                           QQStr(Linhas,6,'0'),
                                           Mx,Ax,
                                           '9',
                                           FString(EEMember.PisPasep,11),
                                           XSexo,
                                           EEMember.DDNasc,EEMember.MMNasc,EEMember.AANasc,
                                           GrauI,
                                           FString(EEMember.CBO,5),
                                           FReal((Valor * 100),0,8),
                                           QQStr(Horas,2,'0'),
                                           EEMember.DDAdm,EEMember.MMAdm,EEMember.AAAdm,
                                           XX,
                                           FString(EEMember.DDResc,2),
                                           Maiuscula(EEMember.Nome,40),
                                           FString(EEMember.CTrabN,10),
                                           Copy(EEMember.CTrabS,1,6),
                                           FString(EEMember.CTrabE,2),
                                           ConstStr(' ',19));
                                end;
                           end;
                   11 : If (EEMember.Status <> 'R') and
                           (EEMember.Status <> 'X') then
                           begin
                             NCont := NCont + 1;
                             Writeln(EEMember.Nome);
                             If ContLin > 56 then HeaderReport;
                             WriteLine('L',Nx+EEMember.Matricula+' '+
                                          Acentua(EEMember.Nome)+Nf);
                             WriteLine('L',' ');
                             YYNo := '';
                             Repeat
                               RC := 'N';
                               SearchPosY ( RootY );
                               If RC = 'S' then
                                  begin
                                    If ContLin > 56 then
                                       begin
                                         HeaderReport;
                                         WriteLine('L',Nx+EEMember.Matricula+' '+
                                                       Acentua(EEMember.Nome)+Nf);
                                         WriteLine('L',' ');
                                       end;
                                    CCNo := YYNo;
                                    SearchTree1 ( Root1 );
                                    If RC = 'S'
                                       then ReadWrite(#04,'R','N',CCNumber)
                                       else begin
                                              CCMember.Descricao := ConstStr('*',30);
                                              CCMember.Tipo      := '*';
                                              RC := 'S';
                                            end;
                                    WriteLine('L',' '+CCNo+' '+
                                             Acentua(CCMember.Descricao)+
                                             ConstStr(' ',31-Length(CCMember.Descricao))+
                                             CCMember.Tipo+' '+
                                             PushRight(3,QQStr(YAddress^.AcMensalH,3,' '))+
                                             ':'+QQStr(YAddress^.AcMensalM,2,'0')+' '+
                                             PushRight(12,EditReal(YAddress^.AcMensalV))+' '+
                                             PushRight(4,EditInteger(YAddress^.AcAnualH))+':'+
                                             QQStr(YAddress^.AcAnualM,2,'0')+' '+
                                             PushRight(14,EditReal(YAddress^.AcAnualV)));
                                  end;
                             Until RC = 'N';
                             WriteLine('L',' ');
                           end;
                   12 : begin
                          If Ex = 'X' then
                             begin
                               DDNo := EEMember.Depto;;
                               SearchTree3 ( Root3 );
                               If RC = 'S' then ReadWrite(#05,'R','N',DDNumber);
                             end;
                          If ((Ex             = 'X' ) and
                               (EEMember.Depto = DDNo) and
                               (DDMember.Marca = #004)) or
                              ((Ex             <> 'X') and
                               (DDNo = Copy(EEMember.Depto,1,Length(DDNo)))) or
                              (DDNo = '') then
                             begin
                               I         := Pos(EEMember.Status,'ACDEFJLMNOPTVRX');
                               NoStat[I] := NoStat[I]  + 1;
                               If (EEMember.Status <> 'R'                      ) and
                                  (EEMember.Status <> 'V'                      ) and
                                  (EEMember.Status <> 'X'                      ) and
                                   ((CMstMember.Etapa in ['O','P','S']         ) or
                                    ((CMstMember.Etapa = 'A'                  )  and
                                     (EEMember.Tipo in ['H','M']             ))  or
                                     ((CMstMember.Etapa in ['1','2','3','4'] )   and
                                      (EEMember.Tipo = 'S'                   ))) then
                                  begin
                                    Writeln(EEMember.Nome);
                                    NCont := NCont + 1;
                                    If EEMember.Tipo = 'H'
                                       then R2 := EEMember.Salario * EEMember.HNormais
                                       else R2 := EEMember.Salario;
                                    EENo    := EEMember.Matricula;
                                    SalBase := Sal;
                                    R2 := SalBase / EEMember.HNormais;
                                    If R2 > 0 then
                                       begin
                                         YYNo := '001';
                                         SearchTreeY ( RootY );
                                         If RC = 'S' then R1 := R1 + (YAddress^.AcMensalV / R2);
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
                                              With CCMember do
                                              begin
                                                ReadWrite(#04,'R','N',CCNumber);
                                                If (Operacao = CMstMember.Etapa        ) or
                                                   ((CCNo             > '100'         )  and
                                                    (CMstMember.Etapa = 'P'           )  and
                                                    (Operacao in ['1','2','3','4','A']))
                                                   then AcumulaTotal;
                                              end
                                              else RC := 'S';
                                         end;
                                    Until RC = 'N';
                                  end;
                             end;
                        end;
                   15 : If (EEMember.Status <> 'R') and
                           (EEMember.Status <> 'V') and
                           (EEMember.Status <> 'X') then
                           begin
                             TFolha := 'S';
                             Case Folha of
                                  'A' : If EEMember.Vinculo <> 'A' then TFolha := 'N';
                                  'E' : If EEMember.Vinculo <> 'N' then TFolha := 'N';
                                  'N' : If (EEMember.Vinculo = 'N') or
                                           (EEMember.Vinculo = 'A') then TFolha := 'N';
                             end;
                             If TFolha = 'S'then
                                begin
                                  NCont := NCont + 1;
                                  Writeln(EEMember.Nome);
                                  Case CMstMember.Etapa of
                                       'P' : YYNo := '060';
                                       'S' : YYNo := '068';
                                  end;
                                  SearchTreeY ( RootY );
                                  If RC = 'S' then R1 := YAddress^.AcMensalV
                                              else R1 := 0;
                                  Case CMstMember.Etapa of
                                       'P' : YYNo := '082';
                                       'S' : YYNo := '086';
                                  end;
                                  SearchTreeY ( RootY );
                                  If RC = 'S' then R2 := YAddress^.AcMensalV
                                              else R2 := 0;
                                  DARFMember.VGuia := DARFMember.VGuia + TruncX(R1);
                                  TProv            := TProv + TruncX(R2);
                                  If Tx = 'R' then
                                     begin
                                       If ContLin > 56 then HeaderReport;
                                       WriteLine('L',PushLeft(15,EEMember.Matricula)+
                                                 Cx+Acentua(EEMember.Nome)+
                                                 ConstStr(' ',42-Length(EEMember.Nome))+Cf+
                                                 PushRight(24,EditReal(R2))+' '+
                                                 PushRight(15,EditReal(R1)));
                                     end;
                                end;
                           end;
              end;
              LiberaMVDsk;
              If EENo = EEAC then RC := 'N'
                             else RC := 'S';
            end;
         GoNoGo;
         If TC = #27 then RC := 'N';
       Until RC = 'N';
       Case ProcNo of
            08 : begin
                   If ContLin > 56 then HeaderReport;
                   WriteLine('L',ConstStr(' ',11)+Cx+
                                 ConstStr(' ',41)+Cf+
                                 ConstStr('-',14)+' '+
                                 ConstStr('-',14)+' '+
                                 ConstStr('-',14));
                   WriteLine('L',ConstStr(' ',11)+Cx+
                                 ConstStr(' ',41)+Cf+
                                 PushRight(14,EditReal(TProv))+' '+
                                 PushRight(14,EditReal(TDesc))+' '+
                                 PushRight(14,EditReal(Valor)));
                   WriteLine('L',' ');
                   WriteLine('L',ConstStr(' ',11)+Cx+
                                 ConstStr(' ',41)+Cf+
                                 ConstStr(' ',8)+
                                 '*** Total a Recolher '+
                                 Nx+PushRight(15,EditReal(TDesc + Valor))+Nf);
                 end;
            10 : If (ContLin < 12) and (X = 'N') then Total10
                    else If X = 'S' then
                            begin
                              Linhas := Linhas + 1;
                              Writeln (LST,'40',
                                       FString(CagMember.Convenio,7),
                                       CMstMember.Tipo,
                                       FString(LimpaChave(CMstMember.CGC),14),
                                       QQStr(Linhas,6,'0'),
                                       Mx,Ax,
                                       '9',
                                       '0',
                                       QQStr(FF,5,'0'),
                                       QQStr(A1,4,'0'),
                                       QQStr(AR,4,'0'),
                                       QQStr(AT,4,'0'),
                                       QQStr(0,4,'0'),
                                       QQStr(A1+AR+AT,5,'0'),
                                       QQStr(Dd,4,'0'),
                                       QQStr(Dj,4,'0'),
                                       QQStr(Dp,4,'0'),
                                       QQStr(Da,3,'0'),
                                       QQStr(Dm,3,'0'),
                                       QQStr(Dt,4,'0'),
                                       QQStr(0,4,'0'),
                                       QQStr(Dd+Dj+Dp+Da+Dm+Dt,5,'0'),
                                       QQStr(FF+Adm-Dem,5,'0'),
                                       ConstStr(' ',52));
                              Linhas := Linhas + 1;
                              Writeln (LST,'50',
                                           FString(CagMember.Convenio,7),
                                           ConstStr('0',15),
                                           QQStr(Linhas,6,'0'),
                                           Mx,Ax,
                                           QQStr(1,4,'0'),
                                           QQStr(Tot30,5,'0'),
                                           QQStr(1,5,'0'),
                                           ConstStr(' ',102));
                              Close ( CagFile );
                            end;
            12 : begin
                   ImprimeTotal;
                   Close ( TotFile );
                   Erase ( TotFile );
                   Reset ( SSFile );
                 end;
            15 : If (Tx = 'R') and (NCont > 0) then
                    begin
                      If ContLin > 56 then HeaderReport;
                      WriteLine('L',ConstStr(' ',15)+Cx+
                                    ConstStr(' ',42)+Cf+
                                    ConstStr(' ',25)+
                                    ConstStr('-',15));
                      WriteLine('L',ConstStr(' ',15)+Cx+
                                    ConstStr(' ',42)+Cf+
                                    ConstStr(' ',4)+
                                    '*** Total a Recolher '+Nx+
                                    PushRight(15,EditReal(DARFMember.VGuia))+Nf);
                    end
                    else If NCont > 0 then
                            begin
                              DARFMember.Total := DARFMember.VGuia;
                              Case DskRpt of
                                   'D' : TC := 'S';
                                   'N' : ImprimeAgora;
                              end;
                              Case TC of
                                   'A','S' : begin
                                               If TC = 'A' then FormTest('S','N','***')
                                                           else TC := 'S';
                                               If TC = 'S' then ImprimeDARF;
                                             end;
                                   'G'     : begin
                                               Assign ( DARFFile, (XDrive + '\DARF__'+AAx+'.M'+MMx));
                                               {$I-}
                                               Reset ( DARFFile );
                                               {$I+}
                                               If IOResult <> 0 then
                                                  begin
                                                    ReWrite ( DARFFile );
                                                    Reset   ( DARFFile );
                                               end;
                                               Seek  ( DARFFile, FileSize(DARFFile));
                                               Write ( DARFFile, DARFMember        );
                                               Close ( DARFFile );
                                             end;
                              end;
                            end;
       end;
       If NCont > 0 then
          begin
            TC := #13;
            If (ProcNo <> 10 ) and
               (ProcNo <> 16 ) and
               (Tx     <> 'G') then Footer;
            If (DskRpt = 'N') and (Tx <> 'G') then WriteLine('W',Qp);
          end;
       FuncImpressos;
     end;
end;


end.