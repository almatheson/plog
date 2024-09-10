{$O+,F+}
Unit PlogRpt2;

Interface

Uses Crt,Dos,PlogGlbs,PlogBasP,PlogTree,PlogMstr,PlogRpt0,PlogRpt5,PlogYear;


   Procedure ProcNo05Report;
   Procedure ProcNo06Report;
   Procedure ProcNo07Report;



Implementation

Var
  QChq,Agn        : Char;
  ValorT          : Real;
  Array1          : Array[1..11] of Integer;
  Array2          : Array[1..11] of Integer;
  Array3          : Array[1..11] of Integer;

Function ProcNo05VZero : Char;
begin
  TProv := 0;
  TDesc := 0;
  YYNo  := '';
  ProcNo05VZero := 'N';
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
              If (TruncX(YAddress^.AcMensalV) > 0               ) and
                 ((CCMember.Operacao   = Opc                   )  or
                  ((CCNo               > '100'                )   and
                   (Opc                = 'P'                  )   and
                   (CCMember.Operacao in ['1','2','3','4','A']))) then
                 begin
                   Case CCMember.Tipo of
                        'D' : TDesc := TDesc + TruncX(YAddress^.AcMensalV);
                        'P' : TProv := TProv + TruncX(YAddress^.AcMensalV);
                   end;
                   ProcNo05VZero := 'S';
                 end;
            end
            else RC := 'S';
       end;
  Until RC = 'N';
  VLiq := TruncX(TProv-TDesc);
  RC   := 'S';
end;


Procedure PedeProc05;
begin
  Color(Tfn,Ttx);
  GotoXY(4,13); Write('1¦ Mens:');
  GotoXY(4,14); Write('2¦ Mens:');
  GotoXY(4,15); Write('3¦ Mens:');
  GotoXY(4,16); Write('Marca..:');
  Msg1  := '';
  Msg2  := '';
  Msg3  := '';
  Tit   := '';
  QChq  := 'N';
  Repeat
    TC := #13;
    K  := 1;
    Repeat
      Case K of
           1  :  PedeDepto(11,'#');
           2  :  If Ex <> '#' then
                    begin
                      Color(Tfn,Ttx);
                      GotoXY(4,12); Write('Q.Depto:');
                      J := QChq;
                      InputStr(J,1,13,12,0,'S','S','T','N',Tfn,Utx);
                      QChq := UpCase(J[1]);
                      GotoXY(13,12);
                      Case QChq of
                           'N' : Write('NÆo');
                           'S' : Write('Sim');
                           else begin
                                  QChq := 'N';
                                  Write('NÆo');
                                end;
                      end;
                    end
                    else QChq := 'N';
           3  :  begin
                   J := Msg1;
                   InputStr(J,39,13,13,0,'S','S','T','N',Tfn,Utx);
                   Msg1 := J;
                 end;
           4  :  begin
                   J := Msg2;
                   InputStr(J,39,13,14,0,'S','S','T','N',Tfn,Utx);
                   Msg2 := J;
                 end;
           5  :  begin
                   J := Msg3;
                   InputStr(J,39,13,15,0,'S','S','T','N',Tfn,Utx);
                   Msg3 := J;
                 end;
           6  :  begin
                   J := Tit;
                   InputStr(J,40,13,16,0,'S','S','T','N',Tfn,Utx);
                   If J = '' then
                      begin
                        Tit := CMstMember.Descricao;
                        K   := K - 1;
                      end
                      else Tit := J;
                 end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 7) or (TC = #27);
    If TC <> #27 then Confirma;
  Until TC in ['S',#27];
end;


Procedure ProcNo05Report;
Var
  OK       : Char;
begin
  TipoCChq := 'N';
  Opc      := CMstMember.Etapa;
  PedeProc05;
  If TC = 'S' then
     begin
       If QChq = 'N' then LoadIndex6 ('E',Tr)
                     else LoadIndex6 ('D',Tr);
       If TC <> #27 then
          begin
            MsgX := Msg3;
            FormTest('S','T','RCB');
            If TC <> #27 then
               begin
                 ParaContinua;
                 Janela('F');
                 XXNo := '';
                 Repeat
                   RC := 'N';
                   SearchPos6 ( Root6 );
                   If RC = 'S' then
                      begin
                        OK := 'N';
                        If Ex = '#' then
                           begin
                             XXNumber := EENumber;
                             OK       := 'S';
                           end;
                        ReadWrite(#08,'R','N',XXNumber);
                        If (EEMember.Status = 'C') and (Opc = 'S')
                           then EEMember.Status := 'A';
                        If Ex = 'X' then
                           begin
                             DDNo := EEMember.Depto;
                             SearchTree3 ( Root3 );
                             If RC = 'S' then
                                begin
                                  ReadWrite(#05,'R','N',DDNumber);
                                  If DDMember.Marca = #004 then OK := 'S';
                                end
                                else RC := 'S';
                           end
                           else If ((Ex = 'D') and (EEMember.Depto = DDNo)) or
                                   ((Ex = 'N') and (DDNo = ''            )) then OK := 'S';
                        If (OK = 'S') and
                           (EEMember.Status in ['A','E','F','L','T']) and
                           ((Opc in ['O','P','S']         ) or
                            ((Opc = 'A'                  )  and
                             (EEMember.Tipo in ['H','M']))  or
                            ((Opc in ['1','2','3','4']  )   and
                             (EEMember.Tipo = 'S'       ))) then
                           begin
                             EENo := EEMember.Matricula;
                             LoadMVDsk(#11);
                             If ProcNo05VZero = 'S' then
                                begin
                                  Writeln(EEMember.Nome);
                                  NCont := NCont + 1;
                                  Tpr   := 0;
                                  Tds   := 0;
                                  Qx    := 'P';
                                  YYNo  := '';
                                  If MsgX = '' then
                                     begin
                                       Val(EEMember.MMNasc,I,E);
                                       If (I-1) = MM
                                          then Msg3 := '********** Feliz Anivers rio **********'
                                          else If EEMember.PgConta = 'S'
                                                  then Msg3 := 'Depositado na Conta ' + EEMember.ContaPg
                                                  else Msg3 := MsgX;
                                     end;
                                  Repeat
                                    ImprimeTexto('S');
                                  Until Qx = '*';
                                  RC := 'S';
                                end;
                             LiberaMVDsk;
                           end
                           else If Ex = '#' then RC := 'N';
                      end;
                   GoNoGo;
                   If TC = #27 then
                      begin
                        RC   := 'N';
                        DDAC := DDNo;
                      end;
                   If Ex = '#' then RC := 'N';
                 Until RC = 'N';
                 CloseTexto;
                 FuncImpressos;
               end;
          end;
     end;
end;


Procedure ProcNo06Mensagem(X : Char);
begin
  If ContLin > 55 then HeaderReport;
  WriteLine('L',' ');
  Case X of
       'D' : begin
               Case Opc of
                    '1' : WriteLine('L',Acentua('Autorizamos o d‚bito ')+
                            'em nossa Conta/Corrente '+
		            Acentua('n£mero ')+BBMember.Conta1+' pelo valor');
                    '2' : WriteLine('L',Acentua('Autorizamos o d‚bito ')+
                            'em nossa Conta/Corrente '+
		            Acentua('n£mero ')+BBMember.Conta2+' pelo valor');
               end;
               Extenso(53,53,53,EditReal(Valor));
               WriteLine('L','de R$ '+PushLeft(13,EditReal(Valor))+' ('+Nx+Res1+Nf+')');
               If Res2 <> '' then WriteLine('L',ConstStr(' ',19)+' ('+Nx+Res2+Nf+')');
               If Res3 <> '' then WriteLine('L',ConstStr(' ',19)+' ('+Nx+Res3+Nf+')');
             end;
       'P' : begin
               WriteLine('L',ConstStr(' ',61)+ConstStr('-',15));
               WriteLine('L',ConstStr(' ',61)+PushRight(15,EditReal(Valor)));
             end;
  end;
  WriteLine('L',' ');
  WriteLine('L','Atenciosamente,');
  WriteLine('L',' ');
  WriteLine('L',ConstStr(' ',20)+ConstStr('-',Length(CMstMember.Descricao)));
  WriteLine('L',ConstStr(' ',20)+Acentua(CMstMember.Descricao));
end;


Procedure MapaDeTroco;
Var
  Fa        : Integer;
  Resto     : Real;
begin
  For I := 1 to 10 do Array1[I] := 0;
  Fa    := 0;
  Resto := VLiq;
  Repeat
    Fa := Fa + 1;
    If (Resto >= CMstMember.Moedas[Fa]) and
       (CMstMember.Moedas[Fa] > 0     ) then
       begin
         Array1[Fa] := Trunc(TruncX(Resto / CMstMember.Moedas[Fa]));
         Resto      := TruncX(Resto - (CMstMember.Moedas[Fa] * Array1[Fa]));
         Array2[Fa] := Array2[Fa] + Array1[Fa];
         Array3[Fa] := Array3[Fa] + Array1[Fa];
       end;
  Until (Resto = 0) or (Fa = 10);
end;


Procedure ProcNo06MensagemD;
begin
  If ContLin > 55 then HeaderReport;
  Case Opc of
       'N' : begin
               WriteLine('L',ConstStr(' ',49)+ConstStr('-',20));
               WriteLine('L',ConstStr(' ',49)+
                           PushRight(20,EditReal(Valor)));
             end;
       'S' : begin
               WriteLine('L',Cx+ConstStr(' ',68)+
                                ConstStr('-',6)+' '+
                                ConstStr('-',6)+' '+
                                ConstStr('-',6)+' '+
                                ConstStr('-',6)+' '+
                                ConstStr('-',6)+' '+
                                ConstStr('-',6)+' '+
                                ConstStr('-',6)+' '+
                                ConstStr('-',6)+' '+
                                ConstStr('-',6)+' '+
                                ConstStr('-',6)+Cf);
               WriteLine('L',Cx+ConstStr(' ',44)+
                                PushRight(20,EditReal(Valor))+
                                ConstStr(' ',4)+
                                PushRight(6,EditInteger(Array2[01]))+' '+
                                PushRight(6,EditInteger(Array2[02]))+' '+
                                PushRight(6,EditInteger(Array2[03]))+' '+
                                PushRight(6,EditInteger(Array2[04]))+' '+
                                PushRight(6,EditInteger(Array2[05]))+' '+
                                PushRight(6,EditInteger(Array2[06]))+' '+
                                PushRight(6,EditInteger(Array2[07]))+' '+
                                PushRight(6,EditInteger(Array2[08]))+' '+
                                PushRight(6,EditInteger(Array2[09]))+' '+
                                PushRight(6,EditInteger(Array2[10]))+Cf);
               For I := 1 to 10 do Array2[I] := 0;
             end;
       end;
end;

Procedure ProcNo06DouC(X : Char);
begin
  Case X of
       'C' : begin
               Case CMstMember.Etapa of
                    '1' : K := 1;
                    '2' : K := 2;
                    '3' : K := 3;
                    '4' : K := 4;
                    'A','O' : K := 5;
                    'S' : K := 6;
                    'P' : K := 7;
               end;
               Window(1,1,80,25);
               Color(Tfn,Utx);
               GotoXY(13,21); Write(QQStr(Chq,6,'0'));
               ImprimeTexto('S');
               EEMember.ChBco[K]  := Bco;
               EEMember.Cheque[K] := QQStr(Chq,6,'0');
               EEMember.VChq[K]   := VLiq;
               ReadWrite(#08,'W','N',XXNumber);
               Chq := Chq + 1;
               Window(27,12,67,19);
               GotoXY(1,8);
             end;
       'N' : begin
               Valor  := Valor  + TruncX(VLiq);
               ValorT := ValorT + TruncX(VLiq);
               Case Opc of
                    'N' : WriteLine('L',Acentua(EEMember.Nome)+
                                    ConstStr('.',42-Length(EEMember.Nome))+
                                    ConstStr(' ',4)+EENo+
                                    ConstStr(' ',11-Length(EENo))+
                                    PushRight(12,EditReal(TruncX(VLiq))));
                    'S' : begin
                            MapaDeTroco;
                            WriteLine('L',Cx+Acentua(EEMember.Nome)+
                                    ConstStr('.',42-Length(EEMember.Nome))+' '+
                                    PushLeft(9,EENo)+
                                    PushRight(12,EditReal(TruncX(VLiq)))+
                                    ConstStr(' ',4)+
                                    PushRight(6,EditInteger(Array1[01]))+' '+
                                    PushRight(6,EditInteger(Array1[02]))+' '+
                                    PushRight(6,EditInteger(Array1[03]))+' '+
                                    PushRight(6,EditInteger(Array1[04]))+' '+
                                    PushRight(6,EditInteger(Array1[05]))+' '+
                                    PushRight(6,EditInteger(Array1[06]))+' '+
                                    PushRight(6,EditInteger(Array1[07]))+' '+
                                    PushRight(6,EditInteger(Array1[08]))+' '+
                                    PushRight(6,EditInteger(Array1[09]))+' '+
                                    PushRight(6,EditInteger(Array1[10]))+Cf);
                          end;
               end;
             end;
  end;
end;


Procedure ProcNo06CouN(X : Char);
begin
  If Ex = 'L' then LoadIndex6 ('E',Tr)
              else LoadIndex6 ('D',Tr);
  If TC <> #27 then
     begin
       If X = 'C' then FormTest('S','T','CHQ');
       If TC <> #27 then
          begin
            L1 := Nx+'Ref.: Pagamento de Pessoal de '+Nf+
                  ArrayMesEx[MM]+'/'+AAx;
            L3 := '';
            L4 := '';
            If Opc = 'N' then L6 := 'Nome'+ConstStr(' ',42)+
                                    Acentua('Matricula')+ConstStr(' ',9)+'Valor'
                         else L6 := Cx +'Nome'+ConstStr(' ',39)+
                                    Acentua('Matr¡c.')+ConstStr(' ',9)+
                                    'Valor'+ConstStr(' ',4)+
                                    PushRight(6,EditReal(CMstMember.Moedas[01]))+' '+
                                    PushRight(6,EditReal(CMstMember.Moedas[02]))+' '+
                                    PushRight(6,EditReal(CMstMember.Moedas[03]))+' '+
                                    PushRight(6,EditReal(CMstMember.Moedas[04]))+' '+
                                    PushRight(6,EditReal(CMstMember.Moedas[05]))+' '+
                                    PushRight(6,EditReal(CMstMember.Moedas[06]))+' '+
                                    PushRight(6,EditReal(CMstMember.Moedas[07]))+' '+
                                    PushRight(6,EditReal(CMstMember.Moedas[08]))+' '+
                                    PushRight(6,EditReal(CMstMember.Moedas[09]))+' '+
                                    PushRight(6,EditReal(CMstMember.Moedas[10]))+Cf;
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
                             (EEMember.PgConta =  X                    ) and
                             (EEMember.Status  in ['A','E','F','L','C']) then
                             begin
                               If (CMstMember.Etapa in ['O','P','S']       ) or
                                  ((CMstMember.Etapa = 'A'                )  and
                                   (EEMember.Tipo in ['H','M']            )) or
                                  ((CMstMember.Etapa in ['1','2','3','4'] )  and
                                   (EEMember.Tipo = 'S'                   )) then
                                  begin
                                    EENo := EEMember.Matricula;
                                    LoadMVDsk(#11);
                                    YYNo := '030';
                                    SearchTreeY ( RootY );
                                    If RC = 'S' then
                                       begin
                                         VLiq := YAddress^.AcMensalV;
                                         If Tx = 'C' then
                                            begin
                                              YYNo := '031';
                                              SearchTreeY ( RootY );
                                              If RC = 'S' then
                                                 begin
                                                   If YAddress^.AcMensalV < Vliq
                                                      then VLiq := VLiq - YAddress^.AcMensalV
                                                      else VLiq := 0;
                                                 end
                                                 else VLiq := 0;
                                            end;
                                         If VLiq > 0 then
                                            begin
                                              If X = 'N' then
                                                 begin
                                                   If (RecordAnt <> DDNo) or
                                                      (ContLin    > 56  ) then
                                                      begin
                                                        If Ex <> 'L' then
                                                           begin
                                                             If ContLin < 1000 then ProcNo06MensagemD;
                                                             Valor := 0;
                                                             If ContLin > 56 then HeaderReport
                                                                             else WriteLine('L',' ');
                                                             If RecordAnt <> DDNo
                                                                then WriteLine('L',Nx+Acentua(DDMember.Descricao)+
                                                                                   ConstStr(' ',41-Length(DDMember.Descricao))+
                                                                                   Nf+DDNo);
                                                             WriteLine('L',' ');
                                                             RecordAnt := DDNo;
                                                           end
                                                           else If ContLin > 56 then HeaderReport;
                                                      end;
                                                 end;
                                              NCont := NCont + 1;
                                              Writeln(EEMember.Nome);
                                              ProcNo06DouC(X);
                                            end;
                                       end
                                       else RC := 'S';
                                    LiberaMVDsk;
                                  end;
                             end;
                        end;
                     GoNoGo;
                     If TC = #27 then RC := 'N';
                     If Ex = '#' then RC := 'N';
                   Until RC = 'N';
                   If TC = #27 then
                      begin
                        RC   := 'N';
                        DDAC := DDNo;
                      end;
                   If DDNo = DDAC then RC := 'N'
                                  else RC := 'S';
                 end;
            Until RC = 'N';
            If X = 'C' then CloseTexto
               else If NCont > 0 then
                       begin
                         ProcNo06MensagemD;
                         If (Ex <> 'L') and (Opc = 'S') then
                            begin
                              WriteLine('L',Cx+ConstStr(' ',68)+
                                               ConstStr('-',6)+' '+
                                               ConstStr('-',6)+' '+
                                               ConstStr('-',6)+' '+
                                               ConstStr('-',6)+' '+
                                               ConstStr('-',6)+' '+
                                               ConstStr('-',6)+' '+
                                               ConstStr('-',6)+' '+
                                               ConstStr('-',6)+' '+
                                               ConstStr('-',6)+' '+
                                               ConstStr('-',6)+Cf);
                              WriteLine('L',Cx+PushRight(44,'TOTAL GERAL: ')+
                                               PushRight(20,EditReal(ValorT))+
                                               ConstStr(' ',4)+
                                               PushRight(6,EditInteger(Array3[01]))+' '+
                                               PushRight(6,EditInteger(Array3[02]))+' '+
                                               PushRight(6,EditInteger(Array3[03]))+' '+
                                               PushRight(6,EditInteger(Array3[04]))+' '+
                                               PushRight(6,EditInteger(Array3[05]))+' '+
                                               PushRight(6,EditInteger(Array3[06]))+' '+
                                               PushRight(6,EditInteger(Array3[07]))+' '+
                                               PushRight(6,EditInteger(Array3[08]))+' '+
                                               PushRight(6,EditInteger(Array3[09]))+' '+
                                               PushRight(6,EditInteger(Array3[10]))+Cf);
                            end;
                         TC := #13;
                         Footer;
                         If DskRpt = 'N' then WriteLine('W',Qp)
                                         else WriteLine('L',Qp);
                       end;
            FuncImpressos;
          end;
     end;
end;

Procedure QueArquivo;
begin
  Color(Blue,White);
  GotoXY(1,23); Write(ConstStr(' ',80));
  GotoXY(2,23); Write('Entre o PATH e o Nome do ARQUIVO:');
  XDisco := '';
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
           TC := #00;
         end;
  Until TC in [#13,#27];
end;

Procedure ProcNo06B(X : Char);
Var
  Linhas,Erro     : Integer;

  TxtFile         : TEXT;
begin
  LoadIndex6 ('B',Tr);
  If TC <> #27 then
     begin
       L2 := ' ';
       L3 := Nx+'Ref.: Pagamento de Pessoal de '+Nf+ArrayMesEx[MM]+'/'+AAx;
       L4 := '';
       L5 := '';
       Case X of
            'D' : begin
                    L3 := ' ';
                    L4 := 'Conforme demonstrativo abaixo, solicitamos creditar em '+
                          QQStr(D,2,'0')+'/'+QQStr(M,2,'0')+'/'+QQStr(A,4,'0')+' os valores';
                    L5 := 'nas respectivas contas correntes.';
                    L6 := 'Nome'+ConstStr(' ',39)+' Agencia Conta                  Valor';
                  end;
            'P' : begin
                    L4 := ' ';
                    L5 := 'Para pagamento em '+QQStr(D,2,'0')+'/'+QQStr(M,2,'0')+'/'+QQStr(A,4,'0');
                    L6 := 'Nome'+ConstStr(' ',39)+' Matric.  Depart.           Valor';
                  end;
       end;
       ParaContinua;
       Janela('F');
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
              ReadWrite(#06,'R','N',BBNumber);
              L1 := 'Ao '+Nx+BBMember.NomeBanco+'  Agencia '+BBMember.NomeAgencia+Nf;
              XXNo  := 'P#' + Copy(BBMember.BancoC,1,3) + '#';
              Valor := 0;
              Repeat
                RC := 'N';
                SearchPos6 ( Root6 );
                If RC = 'S' then
                   begin
                     ReadWrite(#08,'R','N',XXNumber);
                     If Ex = 'X' then
                        begin
                          DDNo := EEMember.Depto;
                          SearchTree3 ( Root3 );
                          If RC = 'S' then ReadWrite(#05,'R','N',DDNumber);
                        end;
                     If Ex = 'N' then DDNo := EEMember.Depto;
                     If (((Ex              = 'X'  )   and
                          (EEMember.Depto  = DDNo )   and
                          (DDMember.Marca  = #004 ))  or
                         ((Ex              <> 'X' )   and
                          (EEMember.Depto  = DDNo ))) and
                        (EEMember.Status in ['A','E','F','L','C']) and
                        (((Agn = 'T') and (Copy(EEMember.BcoPg,1,3) = Copy(BBMember.OrigBancoC,1,3))) or
                         ((Agn = 'S') and (LimpaChave(EEMember.BcoPg) = LimpaChave(BBMember.OrigBancoC)))) then
                        begin
                          If (CMstMember.Etapa in ['O','P','S']       )  or
                             ((CMstMember.Etapa = 'A'                )   and
                              (EEMember.Tipo in ['H','M']            ))  or
                             ((CMstMember.Etapa in ['1','2','3','4'] )   and
                              (EEMember.Tipo = 'S'                   ))  then
                             begin
                               EENo := EEMember.Matricula;
                               LoadMVDsk(#11);
                               YYNo  := '030';
                               SearchTreeY ( RootY );
                               If RC = 'S' then
                                  begin
                                    VLiq := YAddress^.AcMensalV;
                                    If Tx = 'C' then
                                       begin
                                         YYNo := '031';
                                         SearchTreeY ( RootY );
                                         If RC = 'S' then
                                            begin
                                              If YAddress^.AcMensalV < Vliq
                                                 then VLiq := VLiq - YAddress^.AcMensalV
                                                 else VLiq := 0;
                                            end
                                            else VLiq := 0;
                                       end;
                                       If VLiq > 0 then
                                          begin
                                            NCont := NCont + 1;
                                            Writeln(EEMember.Nome);
                                            If ContLin > 56 then
                                               begin
                                                 If X = 'T' then
                                                    begin
                                                      Window(1,1,80,25);
                                                      QueArquivo;
                                                      If TC = #13 then
                                                         begin
                                                           If XDisco[1] in ['A','B'] then MontaDisco
                                                                                     else TC := #13;
                                                           If TC = #13 then
                                                              begin
                                                                Assign ( TxtFile, (XDisco));
                                                                {$I-}
                                                                Reset ( TxtFile );
                                                                {$I+}
                                                                If IOResult = 0 then
                                                                   begin
                                                                     Close   ( TxtFile );
                                                                     Erase   ( TxtFile );
                                                                     ReWrite ( TxtFile );
                                                                   end
                                                                   else ReWrite ( TxtFile );

                                                                Linhas := 1;
                                                                Writeln (TxtFile,'01REMESSA03CREDITO C/C    ',
                                                                         '004060705001202405  00038',
                                                                         'DISTRIB.DIMARCO LTDA.    237BRADESCO       ',
                                                                         XDia,XMes,Copy(XAno,3,2),
                                                                         '00000BPI',
                                                                         QQStr(D,2,'0'),QQStr(M,2,'0'),
                                                                         QQStr(A-2000,2,'0'),
                                                                         ConstStr(' ',80),
                                                                         QQStr(Linhas,6,'0'));
                                                                ContLin := 0;
                                                              end;
                                                         end;
                                                      Color(Sfn,Stx);
                                                      Window(27,12,67,19);
                                                      GotoXY(1,8);
                                                    end
                                                    else HeaderReport;
                                               end;
                                            Valor := Valor + TruncX(VLiq);
                                            Case X of
                                                 'D' : WriteLine('L',Acentua(EEMember.Nome)+
                                                      ConstStr('.',42-Length(EEMember.Nome))+'  '+
                                                      PushLeft(8,Copy(EEMember.BcoPg,5,6))+
                                                      PushLeft(16,EEMember.ContaPg)+
                                                      PushRight(12,EditReal(TruncX(VLiq))));
                                                 'P' : WriteLine('L',Acentua(EEMember.Nome)+
                                                      ConstStr('.',42-Length(EEMember.Nome))+
                                                      '  '+PushLeft(9,EEMember.Matricula)+
                                                      PushLeft(11,EEMember.Depto)+
                                                      PushRight(12,EditReal(TruncX(VLiq))));
                                                 'T' : begin
                                                         Linhas := Linhas + 1;
                                                         Writeln (TxtFile,'1',ConstStr(' ',61),'0',
                                                                  Copy(EEMember.BcoPg,5,4),
                                                                  '07050','0',
                                                                  Copy(EEMember.ContaPg,1,6),
                                                                  Copy(EEMember.ContaPg,8,1),
                                                                  '  ',
                                                                  Maiuscula(EEMember.Nome,40),
                                                                  FString(Copy(EEMember.Matricula,3,6),6),
                                                                  FReal((VLiq * 100),0,13),
                                                                  '298',
                                                                  ConstStr(' ',50),
                                                                  QQStr(Linhas,6,'0'));
                                                       end;
                                            end;
                                          end;
                                  end
                                  else RC := 'S';
                               LiberaMVDsk;
                             end;
                        end
                        else If Copy(BBMember.OrigBancoC,1,3) <> Copy(EEMember.BcoPg,1,3)
                                then RC := 'N';
                   end;
                GoNoGo;
                If TC = #27 then
                   begin
                     RC   := 'N';
                     BBAC := BBNo;
                   end;
              Until RC = 'N';
              RC := 'S';
              If NCont > 0 then
                 begin
                   If Valor <> 0 then
                      begin
                        If X = 'T' then
                           begin
                             Linhas := Linhas + 1;
                             Writeln (TxtFile,'9',
                                      FReal((Valor * 100),0,13),
                                      ConstStr(' ',180),
                                      QQStr(Linhas,6,'0'));
                             Close ( TxtFile );
                           end
                           else begin
                                  ProcNo06Mensagem(X);
                                  TC := #13;
                                  Footer;
                                  If DskRpt = 'N' then WriteLine('W',Qp)
                                                  else WriteLine('L',Qp);
                                end;
                      end;
                   ContLin := 1000;
                 end;
              If BBNo = BBAC then RC := 'N'
                             else RC := 'S';
            end;
       Until RC = 'N';
       FuncImpressos;
     end;
end;


Procedure PedeProcNo06(X : Char);
begin
  NoMat := 'S';
  BBNo  := '';
  Agn   := 'T';
  Tx    := 'N';
  Opc   := 'S';
  Repeat
    K := 1;
    Repeat
      Case K of
           1  : If CMstMember.Etapa = 'P' then
                   begin
                     Color(Tfn,Ttx);
                     GotoXY(04,12); Write('Q.Folha:');
                     GotoXY(36,12); Write('(Compl. ou Normal)');
                     J := Tx;
                     InputStr(J,1,13,12,0,'S','N','T','N',Tfn,Utx);
                     Tx := UpCase(J[1]);
                     GotoXY(13,12);
                     If TC <> #27 then
                        Case Tx of
                             'C' : Write('Complementar');
                             'N' : Write('Normal      ');
                             else  begin
                                     Tx := 'N';
                                     Write('Normal      ');
                                   end;
                        end;
                   end;
           2  : If X <> 'T' then
                   Case X of
                     'C' : PedeDepto(13,'#');
                     'N' : PedeDepto(13,'L');
                     else  PedeDepto(13,' ');
                   end
                   else begin
                          Ex := 'N';
                          DDNo := '';
                        end;
	   3  : If X in ['B','P','T'] then
                   begin
                     Color(Tfn,Ttx);
                     GotoXY(4,14); Write('Banco..:');
                     Color(Blue,White);
                     GotoXY(1,24); Write(ConstStr(' ',80));
                     GotoXY(2,24); Write('F1');
                     Color(Blue,Cyan);
                     GotoXY(5,24); Write('para pesquisar Bancos');
                     Color(Tfn,Utx);
                     GotoXY(13,14); Write(' ':40);
                     J := BBNo;
	             InputStr(J,10,13,14,0,'S','N','T','N',Tfn,Utx);
                     BBNo := LimpaChave(J);
                     Case TC of
                          #13 : If (J = '') and (X <> 'T') then
                                   begin
                                     Color(Tfn,Utx);
                                     GotoXY(13,14);
                                     Write('Todos os Bancos',' ':25);
                                     BBNo := '';
                                   end
		                   else begin
                                          SearchTree7 ( Root7 );
                                          If RC = 'S' then
                                             With BBMember do
                                             begin
                                               ReadWrite(#06,'R','N',BBNumber);
                                               Color(Tfn,Utx);
                                               GotoXY(13,14);
                                               Write(BBMember.OrigBancoC,' ',
                                                     BBMember.NomeBanco);
                                             end
                                             else begin
                                                    ErroMsg := 'Banco/Ag. nÆo Existe ';
                                                    ErrorMessage;
                                                    K := K - 1;
                                                  end;
                                        end;
                          #21 : begin
                                  BBAC := BBNo;
                                  ScrollBanco;
                                  BBNo := BBAC;
                                end;
                     end;
                     LimpaLn(24,Tfd);
                   end;
	   4  : If X in ['B','P'] then
                   begin
                     Color(Tfn,Ttx);
                     GotoXY(4,15); Write('Agˆncia:');
                     Color(Blue,White);
                     GotoXY(1,24); Write(ConstStr(' ',80));
                     Color(Blue,Cyan);
                     GotoXY(2,24); Write('Todas agˆncias [T] ou s¢ a agˆncia acima [S]');
                     Color(Tfn,Utx);
                     GotoXY(13,15); Write(' ':40);
                     J := Agn;
	             InputStr(J,1,13,15,0,'S','N','T','N',Tfn,Utx);
                     Agn := UpCase(J[1]);
                     Case Agn of
                          'S' : begin
                                  Color(Tfn,Utx);
                                  GotoXY(13,15); Write('S¢ a agˆncia acima');
                                end;
                          'T' : begin
                                  Color(Tfn,Utx);
                                  GotoXY(13,15); Write('Todas as agˆncias ');
                                end;
                          else  begin
                                  ErroMsg := 'Entre T ou S';
                                  ErrorMessage;
                                  K := K - 1;
                                end;
                     end;
                     LimpaLn(24,Tfd);
                   end;
           5  : If X = 'C' then
                   begin
                     Color(Tfn,Ttx);
                     GotoXY(4,15); Write('Banco..:');
                     J := '';
                     InputStr(J,3,13,15,0,'S','N','T','N',Tfn,Utx);
                     If TC <> #27 then
                        begin
                          Bco := J;
                          If J = '' then
                             begin
                               ErroMsg := 'Informe o C¢digo do Banco';
                               ErrorMessage;
                               K := K - 1;
                             end;
                        end;
                   end;
           6  : If X in ['B','C','P','T'] then
                   begin
                     Color(Tfn,Ttx);
                     GotoXY(4,16); Write('Data...:');
                     Color(Tfn,Utx);
                     GotoXY(13,16); Write(' ':40);
                     J := '';
                     InputStr(J,10,13,16,0,'S','N','T','N',Tfn,Utx);
                     If TC <> #27 then
                        begin
                          If J = '' then J := XDia+'/'+XMes+'/'+XAno;
                          J := ChkData(J);
                          If J = '' then
                             begin
                               ErroMsg := 'Data Inv lida';
                               ErrorMessage;
                               K := K - 1;
                             end
                             else begin
                                    Val(Copy(J,1,2),D,E);
                                    Val(Copy(J,4,2),M,E);
                                    Val(Copy(J,7,4),A,E);
                                    GotoXY(13,16); Write(J);
                                  end;
                        end;
                   end;
           7  : If X in ['B'] then
                   begin
                     Color(Tfn,Ttx);
                     GotoXY(4,17); Write('Conta..:');
                     DrawBox(33,15,54,17,Red,'S');
                     Color(Red,Cyan);
                     GotoXY(33,15); Write(' Entre    ou  ,  para ');
                     GotoXY(33,16); Write(' indicar em que conta ');
                     GotoXY(33,17); Write(' ser  feito o d‚bito. ');
                     Color(Red,White);
                     GotoXY(41,15); Write('1');
                     GotoXY(46,15); Write('2');
                     Color(Tfn,Utx);
                     GotoXY(13,21); Write(' ':40);
                     J := '';
                     InputStr(J,1,13,17,0,'S','N','T','N',Tfn,Utx);
                     Opc := UpCase(J[1]);
                     GotoXY(13,17);
                     If (TC  <> #27) and
                        (Opc <> '1') and
	 	        (Opc <> '2') then
                        begin
		          ErroMsg := 'Informe 1 ou 2';
                          ErrorMessage;
                          K := K - 1;
                        end
                        else If TC <> #27 then
                                Case Opc of
                                     '1' : Write('1¦ Conta Banc ria');
                                     '2' : Write('2¦ Conta Banc ria');
                                end;
                   end;
           8  : If X = 'C' then
                   begin
                     Color(Tfn,Ttx);
                     GotoXY(4,17); Write('N§.Chq.:');
                     J := '';
                     InputStr(J,6,13,17,0,'S','N','T','N',Tfn,Utx);
                     If TC <> #27 then
                        begin
                          If J = '' then J := '1';
                          Val(J,Chq,E);
                          GotoXY(13,17); Write(QQStr(Chq,6,'0'));
                        end;
                   end;
           9  : If X = 'N' then
                   begin
                     Color(Tfn,Ttx);
                     GotoXY(4,15); Write('Mapa...:');
                     J := Opc;
                     InputStr(J,1,13,15,0,'S','N','T','N',Tfn,Utx);
                     Opc := UpCase(J[1]);
                     GotoXY(13,15);
                     If (TC  <> #27) and
                        (Opc <> 'S') and
	 	        (Opc <> 'N') then
                        begin
		          ErroMsg := 'Informe S ou N';
                          ErrorMessage;
                          K := K - 1;
                        end
                        else If TC <> #27 then
                                Case Opc of
                                     'S' : Write('Sim emitir mapa de troco');
                                     'N' : Write('NÆo emitir mapa de troco');
                                end;
                   end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : begin
                   If K > 0 then K := K - 1;
                   TC := #13;
                 end;
      end;
    Until (K = 10) or (TC = #27);
    If TC <> #27 then Confirma;
  Until TC in [#27,'S'];
end;


Procedure ProcNo06Report;
begin
  AAx      := QQStr(AA,4,'0');
  TabI[1]  := ' Rela‡Æo Banc ria (dep¢sito ) ';
  TabI[2]  := ' Rela‡Æo Banc ria (pagamento) ';
  TabI[3]  := ' Pagamento em Dinheiro        ';
  TabI[4]  := ' EmissÆo de Cheque            ';
  TabI[5]  := ' Arquivo texto                ';
  TabI[6]  := ' Encerrar a fun‡Æo            ';
  TabX[1]  := 10;
  TabX[2]  := 10;
  TabX[3]  := 10;
  TabX[4]  := 10;
  TabX[5]  := 10;
  TabX[6]  := 10;
  TabY[1]  := 10;
  TabY[2]  := 11;
  TabY[3]  := 12;
  TabY[4]  := 13;
  TabY[5]  := 14;
  TabY[6]  := 15;
  YY       := 1;
  Repeat
    ContLin := 1000;
    ContPag := 0;
    NCont   := 0;
    Valor   := 0;
    ValorT  := 0;
    For I := 1 to 10 do
    begin
      Array2[I] := 0;
      Array3[I] := 0;
    end;
    RetMenuAuxiliar(9,9,6,1,1);
    Move(Mem[$B800:0000],ScArray6[1],4000);
    TC := #13;
    Case YY of
         1 : begin
               Titulo := 'Rela‡Æo Banc ria para Dep¢sito';
               BuildFrame('S');
               Color(Red,Yellow);
               GotoXY(35,07); Write(' Configurado para:');
               Color(Red,White);
               GotoXY(54,07); Write(XPrinter);
               Color(Tfn,Utx);
               UltimaEtapa;
               Shade(3,8,60,21,LightGray,Black);
               PedeProcNo06('B');
               If TC = 'S' then ProcNo06B('D');
             end;
         2 : begin
               Titulo := 'Rela‡Æo Banc ria para Pagamento';
               BuildFrame('S');
               Color(Red,Yellow);
               GotoXY(35,07); Write(' Configurado para:');
               Color(Red,White);
               GotoXY(54,07); Write(XPrinter);
               Color(Tfn,Utx);
               UltimaEtapa;
               Shade(3,8,60,21,LightGray,Black);
               PedeProcNo06('P');
               If TC = 'S' then ProcNo06B('P');
             end;
         3 : begin
               Titulo := 'Rela‡Æo de Pagamento a Dinheiro';
               BuildFrame('S');
               Color(Red,Yellow);
               GotoXY(35,07); Write(' Configurado para:');
               Color(Red,White);
               GotoXY(54,07); Write(XPrinter);
               Color(Tfn,Utx);
               UltimaEtapa;
               Shade(3,8,60,21,LightGray,Black);
               PedeProcNo06('N');
               If TC = 'S' then ProcNo06CouN('N');
             end;
         4 : begin
               Titulo := 'EmissÆo de Cheque';
               BuildFrame('S');
               Color(Red,Yellow);
               GotoXY(35,07); Write(' Configurado para:');
               Color(Red,White);
               GotoXY(54,07); Write(XPrinter);
               Color(Tfn,Utx);
               UltimaEtapa;
               Shade(3,8,60,21,LightGray,Black);
               PedeProcNo06('C');
               If TC = 'S' then
                  begin
                    MM := M;
                    AA := A;
                    ProcNo06CouN('C');
                  end;
             end;
         5 : begin
               Titulo := 'Arquivo Texto                 ';
               BuildFrame('S');
               Color(Tfn,Utx);
               UltimaEtapa;
               Shade(3,9,60,21,LightGray,Black);
               PedeProcNo06('T');
               If TC = 'S' then ProcNo06B('T');
             end;
         6 : begin
               Resp := #27;
               TC   := #27;
             end;
    end;
    If (DskRpt = 'T') and (TC <> #27) then
       begin
         ScrollRpt;
         ReWrite ( LST );
       end;
    Move(ScArray6[1],Mem[$B800:0000],4000);
  Until Resp = #27;
  Resp   := #00;
  TC     := #00;
  DskRpt := 'N';
end;


Procedure PedeSelecao07;
Var
  I,K,N       : Integer;
begin
  Color(Tfn,Ttx);
  GotoXY(04,12); Write('Contas :');
  GotoXY(04,13); Write('Tipo...:');
  GotoXY(04,14); Write('T¡tulo :');
  For I := 1 to 10 do ContaX[I] := '';
  Tit   := '';
  CCAC  := '';
  GG    := 'N';
  Repeat
    K := 1;
    Repeat
      Case K of
           1  :  begin
                   I := 1;
                   Repeat
                     Color(Blue,White);
                     GotoXY(1,24); Write(ConstStr(' ',80));
                     GotoXY(2,24); Write('F1');
                     Color(Blue,Cyan);
                     GotoXY(5,24); Write('para pesquisar Contas (Proventos e Descontos)');
                     J := ContaX[I];
                     InputStr(J,3,(9+(I*4)),12,0,'S','N','T','N',Tfn,Utx);
                     LimpaLn(24,Tfd);
                     ContaX[I] := J;
                     Case TC of
                          #13 : If J = '' then
                                   begin
                                     N := I;
                                     I := 11;
                                   end
                                   else begin
                                          CCNo := ContaX[I];
                                          SearchTree1 ( Root1 );
                                          If RC = 'S' then
                                             begin
                                               ReadWrite(#04,'R','N',CCNumber);
                                               If TC = #24 then
                                                  begin
                                                    If I = 1 then I := I - 1;
                                                  end
                                                  else If I <= 10 then I := I + 1;
                                             end
                                             else begin
                                                    ErroMsg := 'Conta nÆo Existe';
                                                    ErrorMessage;
                                                  end;
                                        end;
                          #21 : begin
                                  CCNo := CCAC;
                                  CCAC := '';
                                  ScrollConta;
                                  If CCAC <> '' then ContaX[I] := CCAC;
                                end;
                          #24 : If I > 1 then I := I - 1;
                     end;
                   Until (TC = #27) or (I = 11);
                 end;
           2  :  begin
                   Move(Mem[$B800:0000],ScArray6[1],4000);
                   DrawBox(36,14,55,21,Red,'S');
                   Color(Red,Cyan);
                   GotoXY(36,15); Write(' Contra-Cheque      ');
                   GotoXY(36,16); Write(' Listagem           ');
                   GotoXY(36,17); Write(' Mapa de Troco      ');
                   GotoXY(36,18); Write(' NÆo totalizado     ');
                   GotoXY(36,19); Write(' Recebido (Assin.)  ');
                   GotoXY(36,20); Write(' Totalizado         ');
                   Color(Red,White);
                   GotoXY(37,15); Write('C');
                   GotoXY(37,16); Write('L');
                   GotoXY(37,17); Write('M');
                   GotoXY(37,18); Write('N');
                   GotoXY(37,19); Write('R');
                   GotoXY(37,20); Write('T');
                   J := GG;
                   InputStr(J,1,13,13,0,'S','N','T','N',Tfn,Utx);
                   If J = '' then GG := 'N'
                             else GG := UpCase(J[1]);
                   If (GG = 'L') and (N > 2) then GG := 'N';
                   If TC <> #27 then
                      begin
                        If (GG <> 'C') and
                           (GG <> 'R') and
                           (GG <> 'T') and
                           (GG <> 'L') and
                           (GG <> 'N') and
                           (GG <> 'M') then GG := 'N';
                        Move(ScArray6[1],Mem[$B800:0000],4000);
                        GotoXY(13,13);
                        Case GG of
                             'C' : Write('C-Cheque     ');
                             'L' : Write('Listagem     ');
                             'M' : Write('Mapa de Troco');
                             'N' : Write('NÆo Totaliz. ');
                             'R' : Write('Recebido     ');
                             'T' : Write('Totalizado   ');
                        end;
                        Case GG of
                             'C' : Tit := CMstMember.Descricao;
                             'L' : Tit := CCMember.Descricao;
                        end;
                      end;
                 end;
           3  :  begin
                   J := Tit;
                   InputStr(J,40,13,14,0,'S','S','T','N',Tfn,Utx);
                   If TC <> #27 then
                      begin
                        If J = '' then
                           begin
                             Tit := 'Sele‡„o de Contas';
                             K   := K - 1;
                           end
                           else Tit := J;
                        GotoXY(13,14); Write(Tit);
                      end;
                 end;
           4  :  PedeDepto(15,'L');
  end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 5) or (TC = #27);
    If TC <> #27 then Confirma;
  Until (TC = 'S') or (TC = #27);
end;

Procedure WriteCM;
begin
  If (EEMember.Status in ['A','E','F','L','T']) and
      ((Opc in ['O','P','S']) or ((Opc = 'A') and
       (EEMember.Tipo in ['H','M']))  or
      ((Opc in ['1','2','3','4']  ) and (EEMember.Tipo = 'S'))) then
     begin
       Val(EEMember.MMNasc,I,E);
       Qx    := 'O';
       TProv := 0;
       TDesc := 0;
       Tpr   := 0;
       Tds   := 0;
       Msg1  := '';
       Msg2  := '';
       If (I-1) = MM
          then Msg3 := '********** Feliz Anivers rio **********'
          else Msg3 := '';
       VLiq := 0;
       I    := 0;
       Repeat
         I := I + 1;
         If ContaX[I] <> '' then
            begin
              YYNo := ContaX[I];
              SearchTreeY ( RootY );
              If RC = 'S' then VLiq := VLiq + TruncX(YAddress^.AcMensalV);
            end;
       Until I = 10;
       If VLiq > 0 then
          begin
            NCont := NCont + 1;
            Writeln(EEMember.Nome);
            Case GG of
                 'C' : begin
                         Lin := 0;
                         ImprimeTexto('S');
                       end;
                 'M' : begin
                         Valor := Valor + TruncX(VLiq);
                         MapaDeTroco;
                         If ContLin > 56 then HeaderReport;
                         If (RecordAnt <> DDNo) and
                            (Ex        <> 'L' ) then
                            begin
                              WriteLine('L',PushLeft(11,DDNo)+
                                            Acentua(DDMember.Descricao));
                              WriteLine('L',' ');
                              RecordAnt := DDNo;
                            end;
                         WriteLine('L',Cx+Acentua(EEMember.Nome)+
                                   ConstStr('.',42-Length(EEMember.Nome))+
                                   ' '+
                                   PushLeft(9,EENo)+
                                   PushRight(12,EditReal(TruncX(VLiq)))+
                                   ConstStr(' ',4)+
                                   PushRight(6,EditInteger(Array1[01]))+' '+
                                   PushRight(6,EditInteger(Array1[02]))+' '+
                                   PushRight(6,EditInteger(Array1[03]))+' '+
                                   PushRight(6,EditInteger(Array1[04]))+' '+
                                   PushRight(6,EditInteger(Array1[05]))+' '+
                                   PushRight(6,EditInteger(Array1[06]))+' '+
                                   PushRight(6,EditInteger(Array1[07]))+' '+
                                   PushRight(6,EditInteger(Array1[08]))+' '+
                                   PushRight(6,EditInteger(Array1[09]))+' '+
                                   PushRight(6,EditInteger(Array1[10]))+Cf);
                       end;
            end;
          end;
       RC := 'S';
     end;
end;

Procedure WriteL;
begin
  I  := 0;
  R1 := 0;
  R2 := 0;
  Repeat
    I    := I + 1;
    YYNo := ContaX[I];
    SearchTreeY ( RootY );
    If RC = 'S' then
       begin
         If YAddress^.AcMensalV > 0 then
            begin
              If ContLin > 56 then HeaderReport;
              If (RecordAnt <> DDNo) and
                 (Ex        <> 'L' ) then
                 begin
                   WriteLine('L',PushLeft(11,DDNo)+
                                 Acentua(DDMember.Descricao));
                   WriteLine('L',' ');
                   RecordAnt := DDNo;
                 end;
              If (R1  =  0 ) and
                 (R2  =  0 ) then
                 begin
                   NCont := NCont + 1;
                   Writeln(EEMember.Nome);
                   If GG <> 'L' then
                      begin
                        WriteLine('L',Nx+
                                  EEMember.Matricula+' '+
                                  Acentua(EEMember.Nome)+Nf);
                        WriteLine('L',' ');
                      end;
                 end;
              CCNo := YYNo;
              SearchTree1 ( Root1 );
              If RC = 'S' then
                 begin
                   ReadWrite(#04,'R','N',CCNumber);
                   If CCMember.Tipo = 'D'
                      then R2 := R2 + TruncX(YAddress^.AcMensalV)
                      else R1 := R1 + TruncX(YAddress^.AcMensalV);
                 end;
              If GG <> 'L'
                 then WriteLine('L',ConstStr(' ',11)+CCNo+' '+
                                Acentua(CCMember.Descricao)+
                                ConstStr(' ',38-Length(CCMember.Descricao))+
                                PushRight(3,QQStr(YAddress^.AcMensalH,3,' '))+
                                ':'+QQStr(YAddress^.AcMensalM,2,'0')+
                                ConstStr(' ',2)+
                                PushRight(16,EditReal(YAddress^.AcMensalV)))
                 else WriteLine('L',PushLeft(9,EEMember.Matricula)+
                                Acentua(EEMember.Nome)+
                                ConstStr(' ',42-Length(EEMember.Nome))+
                                PushRight(3,QQStr(YAddress^.AcMensalH,3,' '))+
                                ':'+QQStr(YAddress^.AcMensalM,2,'0')+
                                ConstStr(' ',2)+
                                PushRight(20,EditReal(YAddress^.AcMensalV)));
            end;
       end;
  Until (I = 10) or (GG = 'L');
  TProv := TProv + (R1 - R2);
  If (GG <> 'L') and ((R1 <> 0) or (R2 <> 0)) then
     begin
       Case GG of
            'R' : begin
                    WriteLine('L',ConstStr(' ',53)+
                              ConstStr('-',25));
                    WriteLine('L',ConstStr(' ',11)+
                              'Recebi. ____________________________'+
                              ' Total   R$ '+Nx+
                              PushRight(18,EditReal(R1-R2))+Nf);
                    WriteLine('L',' ');
                    WriteLine('L',' ');
                  end;
            'T' : begin
                    WriteLine('L',ConstStr(' ',53)+
                              ConstStr('-',25));
                    WriteLine('L',ConstStr(' ',47)+
                              ' Total   R$ '+Nx+
                              PushRight(18,EditReal(R1-R2))+Nf);
                  end;
       end;
       WriteLine('L',' ');
     end;
end;

Procedure ProcNo07Report;
begin
  PedeSelecao07;
  If GG = 'C' then
     begin
       FormTest('S','T','RCB');
       TipoCChq := 'C';
     end;
  If TC = 'S' then
     begin
       If Ex <> 'L' then LoadIndex6 ('D',Tr)
                    else LoadIndex6 ('E',Tr);
       For I := 1 to 10 do
       begin
         Array2[I] := 0;
         Array3[I] := 0;
       end;
       Str(AA:2,AAx);
       L1 := Nx+Tit+Nf;
       Case GG of
            'L' : L6 := 'Matr¡c.  Nome'+ConstStr(' ',38)+
                     ' Horas                 Valor';
            'M' : L6 := Cx +'Nome'+ConstStr(' ',39)+
                        Acentua('Matr¡c.')+ConstStr(' ',9)+
                        'Valor'+ConstStr(' ',4)+
                        PushRight(6,EditReal(CMstMember.Moedas[01]))+' '+
                        PushRight(6,EditReal(CMstMember.Moedas[02]))+' '+
                        PushRight(6,EditReal(CMstMember.Moedas[03]))+' '+
                        PushRight(6,EditReal(CMstMember.Moedas[04]))+' '+
                        PushRight(6,EditReal(CMstMember.Moedas[05]))+' '+
                        PushRight(6,EditReal(CMstMember.Moedas[06]))+' '+
                        PushRight(6,EditReal(CMstMember.Moedas[07]))+' '+
                        PushRight(6,EditReal(CMstMember.Moedas[08]))+' '+
                        PushRight(6,EditReal(CMstMember.Moedas[09]))+' '+
                        PushRight(6,EditReal(CMstMember.Moedas[10]))+Cf;
            else L6 := ConstStr(' ',11)+'Cta Descri‡„o'+
                        ConstStr(' ',29)+' Horas             Valor';
       end;
       ParaContinua;
       Janela('F');
       DDAC := DDNo;
       If DDNo <> '' then
          begin
            RC := 'N';
            SearchAnt3 ( Root3 );
            If RC = 'N' then DDNo := '';
          end;
       RecordAnt := '';
       TProv  := 0;
       TDesc  := 0;
       Valor  := 0;
       XXNo   := '';
       Opc    := CMstMember.Etapa;

       Repeat
         RC := 'N';
         SearchPos3 ( Root3 );
         If RC = 'S' then
            begin
              ReadWrite(#05,'R','N',DDNumber);
              If Ex <> 'L' then XXNo := DDNo + '#'
                           else XXNo := '';
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
                          (Ex             <> 'L') and
                          (EEMember.Depto = DDNo)) or
                         (Ex              = 'L'  )) and
                        ((EEMember.Status <> 'R' ) and
                         (EEMember.Status <> 'X' )) then
                        begin
                          EENo := EEMember.Matricula;
                          LoadMVDsk(#11);
                          If (GG = 'C') or (GG = 'M') then WriteCM
                                                      else WriteL;
                          LiberaMVDsk;
                          RC := 'S';
                        end
                        else If (EEMember.Depto <> DDNo) and
                                (Ex             <> 'L' ) then
                                begin
                                  ContLin := 100;
                                  RC := 'N';
                                end;
                   end;
                GoNoGo;
                If TC = #27 then
                   begin
                     RC   := 'N';
                     DDAC := DDNo;
                   end;
              Until RC = 'N';
              Case GG of
                   'L' : if TProv > 0 then
                            begin
                              WriteLine('L',ConstStr(' ',59)+
                                        '--------------------');
                              WriteLine('L',ConstStr(' ',46)+
                                        'Func. ' +
                                        PushRight(5,EditInteger(NCont)) +
                                        ConstStr(' ',2)+
                                        PushRight(20,EditReal(TProv)));
                            end;
                   'M' : begin
                           WriteLine('L',Cx+ConstStr(' ',68)+
                                     ConstStr('-',6)+' '+
                                     ConstStr('-',6)+' '+
                                     ConstStr('-',6)+' '+
                                     ConstStr('-',6)+' '+
                                     ConstStr('-',6)+' '+
                                     ConstStr('-',6)+' '+
                                     ConstStr('-',6)+' '+
                                     ConstStr('-',6)+' '+
                                     ConstStr('-',6)+' '+
                                     ConstStr('-',6)+Cf);
                           WriteLine('L',Cx+PushRight(44,'TOTAL GERAL: ')+
                                     PushRight(20,EditReal(Valor))+
                                     ConstStr(' ',4)+
                                     PushRight(6,EditInteger(Array3[01]))+' '+
                                     PushRight(6,EditInteger(Array3[02]))+' '+
                                     PushRight(6,EditInteger(Array3[03]))+' '+
                                     PushRight(6,EditInteger(Array3[04]))+' '+
                                     PushRight(6,EditInteger(Array3[05]))+' '+
                                     PushRight(6,EditInteger(Array3[06]))+' '+
                                     PushRight(6,EditInteger(Array3[07]))+' '+
                                     PushRight(6,EditInteger(Array3[08]))+' '+
                                     PushRight(6,EditInteger(Array3[09]))+' '+
                                     PushRight(6,EditInteger(Array3[10]))+Cf);
                    end;
              end;
              If DDNo = DDAC then RC := 'N'
                             else RC := 'S';
              If Ex <> 'L' then TProv := 0;
            end;
         If Ex = 'L' then RC := 'N';
       Until RC = 'N';

       If (NCont > 0) and (GG <> 'C') then
          begin
            TC := #13;
            Footer;
            If DskRpt = 'N' then WriteLine('W',Qp);
          end;
       FuncImpressos;
     end;
end;


end.