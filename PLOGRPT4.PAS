{$O+,F+}
Unit PlogRpt4;

Interface

Uses Crt,Dos,PlogGlbs,PlogBasP,Plogtree,PlogRpt0;


   Procedure ProcNo18Report;
   Procedure ProcNo19Report;
   Procedure ProcNo20Report;
   Procedure ProcNo21Report;



Implementation

Var
  QL     : Char;

Procedure ProcNo18Acumula;
Var
  ContaN  : Integer;
begin
  Val(YYNo,ContaN,E);
  Case ContaN of
       001 : R1 := YAddress^.AcMensalV;
       016 : R1 := R1 + YAddress^.AcMensalV;
       003 : R6 := YAddress^.AcMensalV;
       030 : R7 := YAddress^.AcMensalV;
       060 : R5 := YAddress^.AcMensalV;
       061 : R4 := YAddress^.AcMensalV;
       else begin
              CCNo := YYNo;
              SearchTree1 ( Root1 );
              If RC = 'S' then
                 begin
                   ReadWrite(#04,'R','N',CCNumber);
                   If (RW                = 'S' ) and
                      (CCMember.Status  <> 'C' ) and
                      (CCMember.Operacao = CMstMember.Etapa ) then
                      Case CCMember.Tipo of
                           'D' : R3 := R3 + YAddress^.AcMensalV;
                           'P' : R2 := R2 + YAddress^.AcMensalV;
                      end;
                 end;
            end;
  end;
end;


Procedure ProcNo18Report;
Var
  VTot    : Array[1..7] of Real;
begin
  Repeat
    PedeDepto(11,' ');
    If TC <> #27 then Confirma;
  Until TC in ['S',#27];
  If TC = 'S' then
     begin
       LoadIndex6 ('D',Tr);
       If TC <> #27 then
          begin
            Str(AA:2,AAx);
            L1 := Nx+'Folha Sint‚tica em '+Nf+
                  ArrayMesEx[MM]+'/'+AAx;
            L6 := Cx+'Matric.'+ConstStr(' ',2)+'Nome (apenas 20 car)'+
                  ConstStr(' ',3)+'Sal rio Base'+ConstStr(' ',4)+
                  'Rendimentos'+ConstStr(' ',6)+'Descontos'+
                  ConstStr(' ',7)+'I.N.S.S.'+ConstStr(' ',3)+'Imp.de Renda'+
                  ConstStr(' ',4)+'Sal.Fam¡lia'+ConstStr(' ',3)+
                  'Sal.L¡quido'+Cf;
            ParaContinua;
            Janela('F');
            For I := 1 to 7 do VTot[I] := 0;
            RecordAnt := '';
            DDAC      := DDNo;
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
                   For I := 1 to 7 do VBases[I] := 0;
                   ReadWrite(#05,'R','N',DDNumber);
                   XXNo := DDNo + '#';
                   Repeat
                     RC := 'N';
                     SearchPos6 ( Root6 );
                     If RC = 'S' then
                        begin
                          ReadWrite(#08,'R','N',XXNumber);
                          If (((Ex             = 'X' ) and
                               (EEMember.Depto = DDNo) and
                               (DDMember.Marca = #004)) or
                              ((Ex             <> 'X') and
                               (EEMember.Depto = DDNo))) and
                             (EEMember.Status <> 'R') and
                             (EEMember.Status <> 'V') and
                             (EEMember.Status <> 'X') then
                             begin
                               NCont := NCont + 1;
                               Writeln(EEMember.Nome);
                               EENo := EEMember.Matricula;
                               LoadMVDsk(#11);
                               R1   := 0;
                               R2   := 0;
                               R3   := 0;
                               R4   := 0;
                               R5   := 0;
                               R6   := 0;
                               R7   := 0;
                               YYNo := '';
                               Repeat
                                 RC := 'N';
                                 SearchPosY ( RootY );
                                 If RC = 'S' then ProcNo18Acumula;
                               Until RC = 'N';
                               If (ContLin    > 56  ) or
                                  (RecordAnt <> DDNo) then
                                  begin
                                    If ContLin > 56 then HeaderReport;
                                    WriteLine('L',DDNo+' '+Acentua(DDMember.Descricao));
                                    WriteLine('L',' ');
                                    RecordAnt := DDNo;
                                  end;
                               WriteLine('L',Cx+PushLeft(9,EEMember.Matricula)+
                                             Acentua(Copy(EEMember.Nome,1,20))+
                                             ConstStr(' ',21-Length(Copy(EEMember.Nome,1,20)))+
                                             PushRight(14,EditReal(R1))+' '+
                                             PushRight(14,EditReal(R2))+' '+
                                             PushRight(14,EditReal(R3))+' '+
                                             PushRight(14,EditReal(R4))+' '+
                                             PushRight(14,EditReal(R5))+' '+
                                             PushRight(14,EditReal(R6))+' '+
                                             PushRight(13,EditReal(R7))+Cf);
                               VBases[1] := VBases[1] + TruncX(R1);
                               VBases[2] := VBases[2] + TruncX(R2);
                               VBases[3] := VBases[3] + TruncX(R3);
                               VBases[4] := VBases[4] + TruncX(R4);
                               VBases[5] := VBases[5] + TruncX(R5);
                               VBases[6] := VBases[6] + TruncX(R6);
                               VBases[7] := VBases[7] + TruncX(R7);
                               VTot[1] := VTot[1] + TruncX(R1);
                               VTot[2] := VTot[2] + TruncX(R2);
                               VTot[3] := VTot[3] + TruncX(R3);
                               VTot[4] := VTot[4] + TruncX(R4);
                               VTot[5] := VTot[5] + TruncX(R5);
                               VTot[6] := VTot[6] + TruncX(R6);
                               VTot[7] := VTot[7] + TruncX(R7);
                               LiberaMVDsk;
                               RC := 'S';
                             end
                             else If EEMember.Depto <> DDNo then RC := 'N';
                        end;
                     GoNoGo;
                     If TC = #27 then
                        begin
                          RC   := 'N';
                          DDAC := DDNo;
                        end;
                   Until RC = 'N';
                   If RecordAnt = DDNo then
                      begin
                        WriteLine('L',Cx+ConstStr(' ',30)+
                                      '-------------- '+
                                      '-------------- '+
                                      '-------------- '+
                                      '-------------- '+
                                      '-------------- '+
                                      '-------------- '+
                                      '-------------'+Cf);
                        WriteLine('L',Cx+ConstStr(' ',30)+
                                      PushRight(14,EditReal(VBases[1]))+' '+
                                      PushRight(14,EditReal(VBases[2]))+' '+
                                      PushRight(14,EditReal(VBases[3]))+' '+
                                      PushRight(14,EditReal(VBases[4]))+' '+
                                      PushRight(14,EditReal(VBases[5]))+' '+
                                      PushRight(14,EditReal(VBases[6]))+' '+
                                      PushRight(13,EditReal(VBases[7]))+Cf);
                        WriteLine('L',' ');
                      end;
                   If DDNo = DDAC then RC := 'N'
                                  else RC := 'S';
                 end;
            Until RC = 'N';
            If NCont <> 0 then
               begin
                 TC := #13;
                 WriteLine('L',Cx+ConstStr(' ',30)+
                               PushRight(14,EditReal(VTot[1]))+' '+
                               PushRight(14,EditReal(VTot[2]))+' '+
                               PushRight(14,EditReal(VTot[3]))+' '+
                               PushRight(14,EditReal(VTot[4]))+' '+
                               PushRight(14,EditReal(VTot[5]))+' '+
                               PushRight(14,EditReal(VTot[6]))+' '+
                               PushRight(13,EditReal(VTot[7]))+Cf);
                 Footer;
                 If DskRpt = 'N' then WriteLine('W',Qp);
               end;
            FuncImpressos;
          end;
     end;
end;


Procedure PedeProc1920(X : Char);
begin
  Color(Tfn,Ttx);
  GotoXY(4,11); Write('MM e AA:');
  GotoXY(4,12); Write('Dias Ut:');
  GotoXY(4,13); Write('Dias Ut:');
  GotoXY(4,14); Write('VersÆo.:');
  If X = 'S' then
     begin
       GotoXY(4,15); Write('Q.P gin:');
     end;
  DU   := 0;
  DUF  := 0;
  Sq   := '1';
  QL   := 'N';
  Repeat
    TC := #13;
    K  := 1;
    Repeat
      Case K of
           1  :  If ProcNo = 19 then PedeDepto(10,'@')
                                else PedeDepto(10,'L');
           2  :  begin
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
           3  :  begin
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
           4  :  begin
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
           5 : begin
                 J := Sq;
                 InputStr(J,1,13,14,0,'S','N','T','N',Tfn,Utx);
                 GotoXY(13,14);
                 Sq := J[1];
                 Case Sq of
                      '1' : Write('1¦ VersÆo');
                      '2' : Write('2¦ VersÆo');
                      else begin
                             ErroMsg := 'Informe 1 ou 2 (VersÆo)';
                             ErrorMessage;
                             K := K - 1;
                           end;
                 end;
               end;
           6 : If X = 'S' then
                  begin
                    J := QL;
                    InputStr(J,1,13,15,0,'S','S','T','N',Tfn,Utx);
                    QL := UpCase(J[1]);
                    GotoXY(13,15);
                    Case QL of
                         'N' : Write('NÆo');
                         'S' : Write('Sim');
                         else begin
                                QL := 'N';
                                Write('NÆo');
                              end;
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
end;


Function TipoVale(X : Char):Str6;
begin
  Case X of
       'B' : TipoVale := 'Barca';
       'M' : TipoVale := 'Metr“';
       'O' : TipoVale := 'Onibus';
       'F' : TipoVale := 'Fixo';
       else  TipoVale := '';
  end;
end;


Procedure ProcNo19Relat(X : Char);
Var
  Linhas    : Integer;
begin
  Color(Tfn,Utx);
  For I := 10 to 15 do begin
                         GotoXY(6,I); Write(ConstStr(' ',30));
                       end;
  TTAC := TTNo;
  PedeProc1920('S');
  If TC = 'S' then
     begin
       If Ex = 'L' then LoadIndex6 ('E',Tr)
                   else LoadIndex6 ('D',Tr);
       If TC <> #27 then
          begin
            TC   := 'S';
            TTNo := QQStr(AA,4,'0') + QQStr(MM,2,'0') + Sq;
            SearchTree4 ( Root4 );
            If RC = 'S' then ReadWrite(#03,'R','N',TTNumber)
                        else TC := #27;
          end;
       If TC <> #27 then
          begin
            AAx := QQStr(A,2,'0');
            Case X of
                 '1' : begin
                         L1 := Nx+'Rela‡„o de Vale Transporte de '+Nf+ArrayMesEx[M]+'/'+AAx;
                         L6 := Cx+'Nome'+ConstStr(' ',37)+'Matr¡c.  '+
                               'Qt....Valor Qt....Valor Qt....Valor '+
                               'Qt....Valor Qt....Valor Qt....Valor '+
                               '    Valor Total'+Cf;
                       end;
                 '2' : begin
                         L1 := Nx+'Recibo de Vale Transporte de '+Nf+ArrayMesEx[M]+'/'+AAx;
                         L6 := 'Nome'+ConstStr(' ',37)+'Matr¡cula';
                       end;
                 '3' : begin
                         L1 := Nx+'Recibo de Vale Transporte de '+Nf+ArrayMesEx[M]+'/'+AAx;
                         L2 := ' ';
                         L3 := ' ';
                         L4 := ' ';
                         L5 := ' ';
                         L6 := ' ';
                         L7 := 'O funcion rio  abaixo  identificado  e firmado,  declara pelo presente,  para os';
                         L8 := 'devidos fins legais,  ter recebido os Vales-Transporte nas quantidades e valores';
                         L9 := 'abaixo discriminados da empresa ' + CMstMember.Descricao;
                       end;
            end;
            ParaContinua;
            Janela('F');
            RecordAnt := '';
            DDAC      := DDNo;
            Linhas    := 0;
            If DDNo <> '' then
               begin
                 RC := 'N';
                 SearchAnt3 ( Root3 );
                 If RC = 'N' then DDNo := '';
               end;
            For I := 1 to 72 do begin
                                  T1[I] := 0;
                                  T2[I] := 0;
                                  T3[I] := 0;
                                  T4[I] := 0;
                                end;
            R1 := 0;
            R2 := 0;
            R3 := 0;
            R4 := 0;
            For I := 1 to 10 do VBases[I] := 0;
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
                          If Ex = '#' then XXNumber := EENumber;
                          ReadWrite(#08,'R','N',XXNumber);
                          If Ex = 'L' then
                             begin
                               DDNo := EEMember.Depto;
                               DDAC := DDNo;
                             end;
                          If (((Ex             = 'X' ) and
                               (EEMember.Depto = DDNo) and
                               (DDMember.Marca = #004)) or
                              ((Ex             <> 'X') and
                               (EEMember.Depto = DDNo))) and
                               (EEMember.Status in ['A','E','F','V']) and
                               (EEMember.Vinculo[1] <> 'A'          ) and
                               (EEMember.Vinculo[1] <> 'N'          ) and
                               (EEMember.VTransporte in ['F','S']   ) then
                             begin
                               NCont := NCont + 1;
                               Writeln(EEMember.Nome);
                               Valor := 0;
                               Parc  := 0;
                               If ContLin < 1000 then
                                  Case X of
                                       '1','2' : Linhas := 56;
                                       '3'     : Linhas := ContLin - 1;
                                  end;
                               If (RecordAnt <> DDNo  ) or
                                  (ContLin    > Linhas) then
                                  begin
                                    If (ContLin > Linhas ) or
                                       (QL      = 'S'    ) then
                                       begin
                                         If (Ex in ['N','X']) and (X = '3')
                                            then L5 := Nx+DDNo+' '+DDMember.Descricao+Nf;
                                         HeaderReport;
                                       end;
                                    If (Ex in ['D','N','X']) and (X <> '3') then
                                       begin
                                         WriteLine('L',' ');
                                         WriteLine('L',Nx+DDNo+' '+
                                                       Acentua(DDMember.Descricao)+Nf);
                                         WriteLine('L',' ');
                                       end;
                                    RecordAnt := DDNo;
                                  end;
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
                               If X = '3' then
                                  begin
				    WriteLine('L',ConstStr(' ',6)+Acentua('Matr¡cula: ')+EEMember.Matricula);
				    WriteLine('L',ConstStr(' ',6)+Acentua('Nome.....: ')+Acentua(EEMember.Nome));
				    WriteLine('L',ConstStr(' ',6)+Acentua('C.T.P.S..: ')+EEMember.CTrabN+'/'+EEMember.CTrabS+'-'+EEMember.CtrabE);
				    WriteLine('L',ConstStr(' ',6)+Acentua('Admiss„o.: ')+EEMember.DDAdm+'/'+EEMember.MMAdm+'/'+EEMember.AAAdm);
				    WriteLine('L',ConstStr(' ',6)+Acentua('Endere‡o.: ')+Acentua(EEMember.Endereco));
				    WriteLine('L',ConstStr(' ',6)+Acentua('Bairro...: ')+Acentua(EEMember.Bairro));
				    WriteLine('L',ConstStr(' ',6)+Acentua('Cidade...: ')+Acentua(EEMember.Cidade));
				    WriteLine('L',ConstStr(' ',6)+Acentua('Estado...: ')+Acentua(EEMember.Estado));
                                    WriteLine('L',' ');
                                    WriteLine('L',' ');
                                    WriteLine('L',' ');
				    WriteLine('L',ConstStr(' ',6)+
                                                  Acentua('Condu‡„o')+ConstStr(' ',10)+
                                                  PushLeft(18,'Tarifa')+
                                                  PushLeft(26,'Quantidade')+'Total');
                                    WriteLine('L',ConstStr(' ',6)+ConstStr('-',67));
                                    WriteLine('L',' ');
                                  end;
                               For I := 1 to 6 do
                               begin
                                 If EEMember.Passagens[I] <> 0 then
                                    begin
                                      If TTMember.TPass[EEMember.Faixa[I]] = 'F'
                                         then T1[I] := EEMember.Passagens[I]
                                         else T1[I] := EEMember.Passagens[I] * DiasT;
                                      T3[I] := TTMember.VPass[EEMember.Faixa[I]];
                                      T4[I] := T1[I] * T3[I];
                                      If X = '3'
                                         then WriteLine('L',ConstStr(' ',6)+
                                                         PushLeft(18,TipoVale(TTMember.TPass[EEMember.Faixa[I]]))+
                                                         PushRight(6,EditReal(TTMember.VPass[EEMember.Faixa[I]]))+
                                                         PushRight(22,EditInteger(T1[I]))+
                                                         PushRight(21,EditReal(T4[I])));
                                    end
                                    else begin
                                           T1[I] := 0;
                                           T3[I] := 0;
                                           T4[I] := 0;
                                         end;
                                 Valor := Valor + T4[I];
                                 Parc  := Parc  + T1[I];
                               end;
                               If X = '3' then
                                  begin
                                    WriteLine('L',' ');
                                    WriteLine('L',ConstStr(' ',24)+
                                                         PushRight(28,'---------')+
                                                         PushRight(21,'------------'));
                                    WriteLine('L',ConstStr(' ',6)+
                                                         PushLeft(18,'Total')+
                                                         PushRight(28,EditInteger(Parc))+
                                                         PushRight(21,EditReal(Valor)));
                                    WriteLine('L',' ');
                                    WriteLine('L',' ');
                                    WriteLine('L',' ');
                                    WriteLine('L',' ');
                                    WriteLine('L',ConstStr(' ',7)+
                                                  'Comprometo-me a utilizar o Vale Transporte exclusivamente para os');
                                    WriteLine('L',ConstStr(' ',7)+
                                                  'deslocamentos  Residˆncia-Trabalho-Residˆncia,  bem como a manter');
                                    WriteLine('L',ConstStr(' ',7)+
                                                  'atualizadas minhas informa‡”es,  e  declaro ainda estar ciente da');
                                    WriteLine('L',ConstStr(' ',7)+
                                                  'minha participa‡„o referente ao desconto e percentual que me cabe');
                                    WriteLine('L',ConstStr(' ',7)+
                                                  'apresentado em meu Contra-Cheque,  nos termos da  Lei 7.418 de 16');
                                    WriteLine('L',ConstStr(' ',7)+
                                                  'de dezembro de 1985.');
                                    WriteLine('L',' ');
                                    WriteLine('L',' ');
                                    WriteLine('L',' ');
                                    WriteLine('L',ConstStr(' ',7)+
                                                  Acentua(CMstMember.Cidade)+', '+
                                                  QQStr(TabDia[MM],2,'0')+' de '+
                                                  Acentua(ArrayMesEx[MM])+' de '+QQStr(AA,4,'0'));
                                    WriteLine('L',' ');
                                    WriteLine('L',' ');
                                    WriteLine('L',' ');
                                    WriteLine('L',' ');
                                    WriteLine('L',ConstStr(' ',7)+ConstStr('-',60));
                                  end;
                               EENo    := EEMember.Matricula;
                               SalBase := Sal;
                               R1      := ((SalBase/30)*DiasT) * 0.06;
                               R2      := R2 + Valor;
                               R3      := R3 + Valor;
                               Case X of
                                    '1' : WriteLine('L',Cx+Acentua(EEMember.Nome)+
                                                     ConstStr(' ',41-Length(EEMember.Nome))+
                                                     PushLeft(9,EEMember.Matricula)+
                                                     PushRight(3,EditInteger(T1[01]))+' '+
                                                     PushRight(7,EditReal(T3[01]))+' '+
                                                     PushRight(3,EditInteger(T1[02]))+' '+
                                                     PushRight(7,EditReal(T3[02]))+' '+
                                                     PushRight(3,EditInteger(T1[03]))+' '+
                                                     PushRight(7,EditReal(T3[03]))+' '+
                                                     PushRight(3,EditInteger(T1[04]))+' '+
                                                     PushRight(7,EditReal(T3[04]))+' '+
                                                     PushRight(3,EditInteger(T1[05]))+' '+
                                                     PushRight(7,EditReal(T3[05]))+' '+
                                                     PushRight(3,EditInteger(T1[06]))+
                                                     PushRight(7,EditReal(T3[06]))+' '+
                                                     PushRight(15,EditReal(Valor))+Cf);
                                    '2' : begin
                                            WriteLine('L',Acentua(EEMember.Nome)+
                                                      ConstStr(' ',41-Length(EEMember.Nome))+
                                                      '['+EEMember.Matricula+']');
                                            WriteLine('L',' ');
                                            WriteLine('L',Cx+'Tarifa: '+
                                                      PushRight(10,EditReal(T3[01]))+' '+
                                                      PushRight(10,EditReal(T3[02]))+' '+
                                                      PushRight(10,EditReal(T3[03]))+' '+
                                                      PushRight(10,EditReal(T3[04]))+' '+
                                                      PushRight(10,EditReal(T3[05]))+' '+
                                                      PushRight(10,EditReal(T3[06]))+Cf);
                                            WriteLine('L',Cx+'N.Pass: '+
                                                      PushRight(10,EditInteger(T1[01]))+' '+
                                                      PushRight(10,EditInteger(T1[02]))+' '+
                                                      PushRight(10,EditInteger(T1[03]))+' '+
                                                      PushRight(10,EditInteger(T1[04]))+' '+
                                                      PushRight(10,EditInteger(T1[05]))+' '+
                                                      PushRight(10,EditInteger(T1[06]))+Cf);
                                            WriteLine('L',Cx+ConstStr(' ',8)+
                                                      '---------- '+'---------- '+
                                                      '---------- '+'---------- '+
                                                      '---------- '+'---------- '+
                                                      '----------------------'+
                                                      '----------------------'+
                                                      '------------------'+Cf);
                                            WriteLine('L',Cx+'Total.: '+
                                                      PushRight(10,EditReal(T4[01]))+' '+
                                                      PushRight(10,EditReal(T4[02]))+' '+
                                                      PushRight(10,EditReal(T4[03]))+' '+
                                                      PushRight(10,EditReal(T4[04]))+' '+
                                                      PushRight(10,EditReal(T4[05]))+' '+
                                                      PushRight(10,EditReal(T4[06]))+' '+
                                                      PushRight(13,EditReal(Valor))+' ['+
                                                      PushRight(2,EditInteger(DiasT))+
                                                      ']       '+
                                                      'Assinatura do Empregado'+Cf);
                                            WriteLine('L',Cx+ConstStr(' ',74)+
                                                      PushRight(13,EditReal(R1))+
                                                      ' [6%]'+Cf);
                                          end;
                               end;
                               LiberaMVDsk;
                               RC := 'S';
                             end
                             else If (EEMember.Depto <> DDNo) and
                                     (Ex             =  'N' ) then RC := 'N';
                        end;
                     GoNoGo;
                     If TC = #27 then
                        begin
                          RC   := 'N';
                          DDAC := DDNo;
                        end;
                     If Ex = '#' then RC := 'N';
                   Until RC = 'N';
                   If (Ex in ['N','X']) and (X = '1') and (R2 > 0) then
                      begin
                        WriteLine('L',Cx+ConstStr(' ',121)+ConstStr('-',16)+Cf);
                        WriteLine('L',Cx+ConstStr(' ',121)+PushRight(16,EditReal(R2))+Cf);
                      end;
                   If DDNo = DDAC then RC := 'N'
                                  else RC := 'S';
                   R2 := 0;
                 end;
            Until RC = 'N';
            If NCont <> 0 then
               begin
                 If (X = '1') and (R3 > 0) and (QL = 'N') then
                    begin
                      WriteLine('L',Cx+ConstStr(' ',121)+ConstStr('-',16)+Cf);
                      WriteLine('L',Cx+ConstStr(' ',101)+
                                    PushLeft(20,'Total geral')+
                                    PushRight(16,EditReal(R3))+Cf);
                    end;
                 TC := #13;
                 Footer;
                 If DskRpt = 'N' then WriteLine('W',Qp);
               end;
            FuncImpressos;
          end;
     end;
  TTNo := TTAC;
  SearchTree4 ( Root4 );
  If RC = 'S' then ReadWrite(#03,'R','N',TTNumber);
end;


Procedure ProcNo19Report;
begin
  TabI[1]  := ' Rela‡Æo de Vales           ';
  TabI[2]  := ' Listagem para Recibo       ';
  TabI[3]  := ' Recibo individual          ';
  TabI[4]  := ' Encerrar a fun‡Æo          ';
  TabX[1]  := 7;
  TabX[2]  := 7;
  TabX[3]  := 7;
  TabX[4]  := 7;
  TabY[1]  := 11;
  TabY[2]  := 12;
  TabY[3]  := 13;
  TabY[4]  := 14;
  DrawBox(6,10,35,15,Bfn,'N');
  YY := 1;
  MenuAuxiliar(4,Tfn,Utx,Bfn,Btx);
  Repeat
    Resp := ReadKey;
    If (Resp = #0 ) and
       (KeyPressed) then
       begin
         Resp := ReadKey;
         Case Resp of
              #72 : begin
                      YY := YY - 1;
                      If YY < 1 then YY := 4;
                    end;
              #80 : begin
                      YY := YY + 1;
                      If YY > 4 then YY := 1;
                    end;
         end;
         MenuAuxiliar(4,Tfn,Utx,Bfn,Btx);
       end
       else If Resp = #13 then
               begin
                 Move(Mem[$B800:0000],ScArray4[1],4000);
                 ContLin := 10000;
                 ContPag := 0;
                 NCont   := 0;
                 Case YY of
                      1 : ProcNo19Relat('1');
                      2 : ProcNo19Relat('2');
                      3 : ProcNo19Relat('3');
                      4 : begin
                            TC   := #27;
                            Resp := #27;
                          end;
                 end;
                 If (DskRpt = 'T') and (TC <> #27) then
                    begin
                      ScrollRpt;
                      ReWrite ( LST );
                    end;
                 Move(ScArray4[1],MemW[$B800:0000],4000);
               end
               else Resp := #13;
  Until Resp = #27;
  DskRpt := 'N';
end;


Procedure ProcNo20Report;
Var
  Sw     : Char;
begin
  TTAC := TTNo;
  PedeProc1920('N');
  If TC = 'S' then
     begin
       If Ex = 'L' then LoadIndex6 ('E','N')
                   else LoadIndex6 ('D','N');
       If TC <> #27 then
          begin
            TC   := 'S';
            TTNo := QQStr(AA,4,'0') + QQStr(MM,2,'0') + Sq;
            SearchTree4 ( Root4 );
            If RC = 'S' then ReadWrite(#03,'R','N',TTNumber)
                        else TC := #27;
          end;
       If TC <> #27 then
          begin
            AAx := QQStr(A,4,'0');
            L1 := Nx+'Total de Passagens de '+Nf+ArrayMesEx[M]+'/'+AAx;
            ParaContinua;
            Janela('F');
            NCont := 0;
            DDAC  := DDNo;
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
                   For I := 1 to 72 do begin
                                         T1[I] := 0;
                                         T3[I] := 0;
                                         T4[I] := 0;
                                       end;
                   Sw := 'N';
                   If Ex = 'L' then XXNo := ''
                               else XXNo := DDNo + '#';
                   Repeat
                     RC := 'N';
                     SearchPos6 ( Root6 );
                     If RC = 'S' then
                        begin
                          ReadWrite(#08,'R','N',XXNumber);
                          If Ex = 'L' then
                             begin
                               DDNo := EEMember.Depto;
                               DDAC := DDNo;
                             end;
                          If (((Ex             = 'X' ) and
                               (EEMember.Depto = DDNo) and
                               (DDMember.Marca = #004)) or
                              ((Ex             <> 'X') and
                               (EEMember.Depto = DDNo))) and
                             (RW                  = 'S' ) and
                             (EEMember.Status in ['A','E','F','V'] ) and
                             (EEMember.Vinculo[1] <> 'A'       ) and
                             (EEMember.Vinculo[1] <> 'N'       ) and
                             (EEMember.VTransporte in ['F','S']) then
                             begin
                               Sw    := 'S';
                               NCont := NCont + 1;
                               Writeln(EEMember.Nome);
                               If EEMember.DiasVT <> 0 then DiasT := EEMember.DiasVT
                                  else begin
                                         DDNo   := EEMember.Depto;
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
                               do If EEMember.Passagens[I] > 0 then
                                     If TTMember.TPass[EEMember.Faixa[I]] = 'F'
                                        then T1[EEMember.Faixa[I]] := T1[EEMember.Faixa[I]] +
                                                                      EEMember.Passagens[I]
                                        else T1[EEMember.Faixa[I]] := T1[EEMember.Faixa[I]] +
                                                                      (EEMember.Passagens[I] * DiasT);
                             end;
                        end;
                     GoNoGo;
                     If TC = #27 then
                        begin
                          RC   := 'N';
                          DDAC := DDNo;
                        end;
                   Until RC = 'N';
                   If DDNo = DDAC then RC := 'N'
                                  else RC := 'S';
                   If Sw = 'S' then
                      begin
                        Case Ex of
                             'L' : L6 := Nx+'Todos os Departamentos'+Nf;
                             'D' : L6 := Nx+DDMember.Descricao+Nf;
                             'N','X' : L6 := Nx+DDMember.Descricao+Nf;
                        end;
                        HeaderReport;
                        WriteLine('L',ConstStr(' ',2)+
                                  'N.Pas         Tarifa     Valor total     '+
                                  'N.Pas         Tarifa     Valor total');
                        WriteLine('L',ConstStr(' ',2)+
                                  '------ ------------- ---------------     '+
                                  '------ ------------- ---------------');
                        WriteLine('L',' ');
                        TProv := 0;
                        R1    := 0;
                        R2    := 0;
                        For I := 1 to 36 do
                        begin
                          R2 := R2 + T1[I] + T1[I+36];
                          R1 := T1[I] * TTMember.VPass[I];
                          R3 := T1[I+36] * TTMember.VPass[I+36];
                          WriteLine('L',ConstStr(' ',2)+
                                        PushRight(6,EditInteger(T1[I]))+' '+
                                        PushRight(13,EditReal(TTMember.VPass[I]))+' '+
                                        PushRight(15,EditReal(R1))+
                                        ConstStr(' ',5)+
                                        PushRight(6,EditInteger(T1[I+36]))+' '+
                                        PushRight(13,EditReal(TTMember.VPass[I+36]))+' '+
                                        PushRight(15,EditReal(R3)));
                          TProv   := TProv + R1 + R3;
                        end;
                        WriteLine('L',' ');
                        WriteLine('L',ConstStr(' ',43)+
                                  '------ ------------- ---------------');
                        WriteLine('L',ConstStr(' ',43)+
                                  PushRight(6,EditInteger(Trunc(R2)))+
                                  ConstStr(' ',15)+
                                  PushRight(15,EditReal(TProv)));
                      end;
                 end;
            Until RC = 'N';
            If Sw = 'S' then
               begin
                 TC := #13;
                 Footer;
                 If DskRpt = 'N' then WriteLine('W',Qp);
               end;
          end;
       FuncImpressos;
     end;
  TTNo := TTAC;
  SearchTree4 ( Root4 );
  If RC = 'S' then ReadWrite(#03,'R','N',TTNumber);
end;


Procedure ProcNo21Linha;
begin
  NCont := NCont + 1;
  Writeln(EEMember.Nome);
  If (RecordAnt <> DDNo) or
     (ContLin    > 56  ) then
     begin
       If (ContLin > 56) or (QL = 'S') then HeaderReport;
       If Ex in ['N','X'] then
          begin
            WriteLine('L',' ');
            WriteLine('L',Nx+DDNo+' '+Acentua(DDMember.Descricao)+Nf);
            WriteLine('L',' ');
          end;
       RecordAnt := DDNo;
     end;
  If EEMember.Tipo = 'H' then Valor := EEMember.Salario * EEMember.HNormais
                         else Valor := EEMember.Salario;
  Valor := (Valor * 1.3334) * EEMember.PeriodoV;
  TProv := TProv + Valor;
  WriteLine('L',Cx+Acentua(EEMember.Nome)+
                ConstStr(' ',41-Length(EEMember.Nome))+
                PushLeft(17,EEMember.Matricula)+
                Acentua(EEMember.Cargo)+
                ConstStr(' ',16-Length(EEMember.Cargo))+
                EEMember.DDPAq+'/'+EEMember.MMPAq+'/'+EEMember.AAPAq+' '+
                EEMember.DDFer+'/'+EEMember.MMFer+'/'+EEMember.AAFer+' '+
                PushRight(2,EditInteger(EEMember.MesesF))+' '+
                PushRight(2,EditInteger(EEMember.PeriodoV))+' '+
                PushRight(15,EditReal(Valor))+Cf);
end;


Procedure PedeProc21;
begin
  Color(Tfn,Ttx);
  GotoXY(4,10); Write('V ou P.:');
  Tp  := 'V';
  MMx := '';
  AAx := '';
  QL  := 'N';
  Repeat
    TC := #13;
    K  := 1;
    Repeat
      Case K of
           1  :  PedeDepto(09,'L');
           2  :  begin
                   J := Tp;
                   InputStr(J,1,13,10,0,'S','N','T','N',Tfn,Utx);
                   If J = ' ' then Tp := 'V'
                              else Tp := UpCase(J[1]);
                   If (Tp <> 'V') and
                      (Tp <> 'P') then
                      begin
                        ErroMsg := 'Informe V ou P';
                        ErrorMessage;
                        K := K - 1;
                      end
                      else begin
                             GotoXY(13,10);
                             If Tp = 'V' then Write('Vencidas   ')
                                         else Write('Programadas');
                           end;
                 end;
           3  :  If Tp = 'P' then
                    begin
                      Color(Tfn,Ttx);
                      GotoXY(4,11); Write('Mˆs....:');
                      GotoXY(4,12); Write('Ano....:');
                      Color(Tfn,Utx);
                      GotoXY(13,11); Write(' ':30);
                      J := MMx;
                      InputStr(J,2,13,11,0,'S','N','T','N',Tfn,Utx);
                      If TC <> #27 then
                         begin
                           Val(J,I,E);
                           If (I < 01) or (I > 12) then
                              begin
                                ErroMsg := 'Mˆs invalido';
                                ErrorMessage;
                                K := K - 1;
                              end
                              else begin
                                     GotoXY(13,11); Write(ArrayMesEx[I]);
                                     If Length(J) = 1 then MMx := '0' + J
                                                      else MMx := J;
                                   end;
                         end;
                    end;
           4  :  If Tp = 'P' then
                    begin
                      J := AAx;
                      InputStr(J,4,13,12,0,'S','N','T','N',Tfn,Utx);
                      If TC <> #27 then
                         begin
                           AAx := J;
                           If AAx = '' then
                              begin
                                ErroMsg := 'Ano invalido';
                                ErrorMessage;
                                K := K - 1;
                              end;
                         end;
                    end;
           5  :  If Ex in ['N','X'] then
                    begin
                      Color(Tfn,Ttx);
                      GotoXY(4,13); Write('Q.P g..:');
                      J := QL;
                      InputStr(J,1,13,13,0,'S','N','T','N',Tfn,Utx);
                      If J = ' ' then QL := 'N'
                                 else QL := UpCase(J[1]);
                      If (QL <> 'S') and
                         (QL <> 'N') then
                         begin
                           ErroMsg := 'Informe S ou N';
                           ErrorMessage;
                           K := K - 1;
                         end
                         else begin
                                GotoXY(13,13);
                                If QL = 'S' then Write('Sim quebra p gina')
                                            else Write('NÆo quebra p gina');
                              end;
                    end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 6) or (TC = #27);
    If TC <> #27 then Confirma;
  Until TC in ['S',#27];
end;


Procedure ProcNo21Report;
begin
  PedeProc21;
  If TC = 'S' then
     begin
       If Ex = 'L' then LoadIndex6 ('E',Tr)
                   else LoadIndex6 ('D','N');
       If TC <> #27 then
          begin
            Str(AA:2,J);
            Case Tp of
                 'V' : L1 := Nx+'F‚rias Vencidas em '+Nf+
                             ArrayMesEx[MM]+'/'+J;
                 'P' : begin
                         Val(MMx,I,E);
                         L1 := Nx+'Programa‡„o de F‚rias em '+Nf+
                               ArrayMesEx[I]+'/'+AAx;
                       end;
            end;
            L6 := Cx+'Nome do Empregado'+ConstStr(' ',24)+
                  'Matr¡cula'+ConstStr(' ',8)+'Cargo'+ConstStr(' ',11)+
                  'Admiss„o Pr¢x.Fer Pa Pv    Custo aprox.'+Cf;
            ParaContinua;
            Janela('F');
            RecordAnt := '';
            DDAC      := DDNo;
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
                   TProv := 0;
                   If Ex = 'L' then XXNo := ''
                               else XXNo := DDNo + '#';
                   Repeat
                     RC := 'N';
                     SearchPos6 ( Root6 );
                     If RC = 'S' then
                        begin
                          If Ex = '#' then XXNumber := EENumber;
                          ReadWrite(#08,'R','N',XXNumber);
                          If Ex = 'L' then
                             begin
                               DDNo := EEMember.Depto;
                               DDAC := DDNo;
                             end;
                          If (((Ex             = 'X' ) and
                               (EEMember.Depto = DDNo) and
                               (DDMember.Marca = #004)) or
                              ((Ex             <> 'X') and
                               (EEMember.Depto = DDNo))) and
                             (EEMember.Status in ['A','E','F','L','C']) then
                             begin
                               Case Tp of
                                    'V' : If EEMember.PeriodoV > 0 then ProcNo21Linha;
                                    'P' : If (MMx = EEMember.MMFer) and
                                             (AAx = EEMember.AAFer) then ProcNo21Linha;
                               end;
                             end
                             else If (EEMember.Depto <> DDNo) and
                                     (Ex             =  'N' ) then RC := 'N';
                        end;
                     GoNoGo;
                     If TC = #27 then
                        begin
                          RC   := 'N';
                          DDAC := DDNo;
                          TC   := #13;
                        end;
                     If Ex = '#' then RC := 'N';
                   Until RC = 'N';
                   If TProv > 0 then
                      begin
                        WriteLine('L',Cx+ConstStr(' ',98)+
                                      ConstStr('-',15)+Cf);
                        WriteLine('L',Cx+ConstStr(' ',98)+
                                      PushRight(15,EditReal(TProv))+Cf);
                      end;
                   If DDNo = DDAC then RC := 'N'
                                  else RC := 'S';
                 end;
            Until RC = 'N';
            If NCont <> 0 then
               begin
                 TC := #13;
                 Footer;
                 If DskRpt = 'N' then WriteLine('W',Qp);
               end;
            FuncImpressos;
          end;
     end;
end;


end.