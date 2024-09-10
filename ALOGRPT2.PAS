{$O+,F+}
Unit AlogRpt2;

Interface

Uses Crt,Dos,AlogGlbs,AlogNavg,AlogBasP,AlogInit,AlogRpt0,AlogDept;


   Procedure ProcNo10Report;
   Procedure ProcNo11Report;
   Procedure ProcNo13Report;
   Procedure ProcNo14Report;


Implementation

Var
  TRec,TRecA,TDesp,TDespA  : Double;
  Sald1,Abert1             : Str40;
  TR,TD                    : Double;


Procedure ProcNo10Linha;
begin
  NCont := NCont + 1;
  Writeln(ContaMember.Descricao);
  If ContLin > 55 then HeaderAnualReport;
  If TruncX(SaldMember.SaldoB[MM]) <> 0 then
     begin
       SaldMember.SaldoB[MM] := SaldMember.SaldoB[MM] * -1;
       If SaldMember.SaldoB[MM] < 0
          then Sald := '-' + EditDouble(TruncX(SaldMember.SaldoB[MM] / VMo)) + ' '
          else Sald := EditDouble(TruncX(SaldMember.SaldoB[MM] / VMo)) + ' ';
       WriteLine('L',ConstStr(' ',Trunc((T-64)/2))+
                 Acentua(ContaMember.Descricao)+
                 ConstStr(' ',44-Length(ContaMember.Descricao))+
                 Nx+PushRight(20,Sald)+Nf);
       Lucro   := Lucro + TruncX(SaldMember.SaldoB[MM] / VMo);
     end;
end;


Procedure ProcNo10Report;
begin
  Tit := '';
  PedeLFReport;
  If TC = 'S' then EntryAssinatura;
  If TC = 'S' then
     begin
       Color(Blue,Cyan);
       GotoXY(1,24);  Write(ConstStr(' ',80));
       GotoXY(2,24);
       Write('Estou criando Indice para Impress„o do ');
       Color(Blue,Yellow);
       GotoXY(41,24); Write('Relat¢rio');
       Color(Blue,(White + Blink));
       GotoXY(65,24); Write('Aguarde');
       If Root6 <> NIL then Dispose6 (Root6);
       Root6 := NIL;
       I     := -1;
       Repeat
         I := I + 1;
         ReadWrite(#03,'R','N',I);
         If (RW                  =  'S'                          ) and
            (ContaMember.GrupoE  in ['0','1','2','3','4','5','6']) then
            begin
              ReadWrite(#06,'R','N',I);
              If (RW                =  'S') and
                 (SaldMember.Status <> 'C') then
                 begin
                   DCVSNumber := I;
                   DCVSNo     := ContaMember.GrupoE;
                   Case ContaMember.Grupo of
                        'R' : DCVSNo := DCVSNo + '0';
                        'D' : DCVSNo := DCVSNo + '1';
                        'A' : DCVSNo := DCVSNo + '2';
                        'P' : DCVSNo := DCVSNo + '3';
                        'O' : DCVSNo := DCVSNo + '4';
                   end;
                   DCVSNo := DCVSNo + ContaMember.Conta;
                   LoadTree6 ( Root6 );
                   ShowHeap;
                   Color(Tfd,Utx);
                 end;
            end;
       Until (I + 1) = FileSize(ContaFile);
       LimpaLn(24,Tfd);
       ParaContinua;
       MessageReport;
       Lucro := 0;
       NCont := 0;
       Fx    := 'X';
       HeaderAnualReport;
       Repeat
         Case Fx of
              'X' : begin
                      Fx    := '0';
                      TCalc := 'Receita Bruta';
                    end;
              '0' : begin
                      Fx    := '1';
                      TCalc := 'Receita L¡quida';
                    end;
              '1' : begin
                      Fx    := '2';
                      TCalc := 'Lucro Operacional';
                    end;
              '2' : begin
                      Fx    := '3';
                      TCalc := 'Lucro antes da Corre‡„o Monet ria';
                    end;
              '3' : begin
                      Fx    := '4';
                      TCalc := 'Lucro antes da Contribui‡„o Social';
                    end;
              '4' : begin
                      Fx    := '5';
                      TCalc := 'Lucro antes da Provis„o para I.R.';
                    end;
              '5' : begin
                      Fx    := '6';
                      TCalc := 'Lucro L¡quido do Exerc¡cio';
                    end;
              else TCalc := '';
         end;
         DCVSNo := Fx;
         Repeat
           RC := 'N';
           SearchPos6 ( Root6 );
           If RC = 'S' then
              begin
                If DCVSNo[1] = Fx then
                   begin
                     ReadWrite(#03,'R','N',DCVSNumber);
                     ReadWrite(#06,'R','N',DCVSNumber);
                     ProcNo10Linha;
                   end
                   else If DCVSNo[1] > Fx then RC := 'N';
              end;
         Until RC = 'N';
         If Lucro <> 0 then
            begin
              WriteLine('L',ConstStr(' ',Trunc((T-64)/2))+Nx+ConstStr('-',40)+
                            ConstStr(' ',4)+ConstStr('-',20)+Nf);
              If Lucro < 0 then Sald := '-' + EditDouble(Lucro) + ' '
                           else Sald := EditDouble(Lucro) + ' ';
              If (Fx    = '5') and
                 (Lucro < 0  ) then
                 begin
                   TCalc := 'Prejuizo do Exerc¡cio';
                   Fx    := '6';
                 end;
              WriteLine('L',ConstStr(' ',Trunc((T-64)/2))+Nx+
                            Acentua(TCalc)+
                            ConstStr(' ',44-Length(TCalc))+
                            PushRight(20,Sald)+Nf);
            end;
         WriteLine('L',' ');
       Until Fx = '6';
       If (Assin1 <> '' ) and
          (XMo     = 'N') then
          begin
            If ContLin > 50 then HeaderAnualReport;
            WriteLine('L',ConstStr(' ',Trunc((T-64)/2))+
                    Acentua('Reconhecemos a exatid„o do presente Demonstrativo de Resultados'));
            WriteLine('L',' ');
            WriteLine('L',' ');
            If T = 80
               then WriteLine('L',ConstStr(' ',28)+Cx+CMstMember.Cidade+', '+
                                  PushLeft(2,EditInteger(TabDia[MM]))+
                                  Acentua(TabMesX[MM])+
                                  PushLeft(2,EditInteger(AA))+Cf)
               else WriteLine('L',ConstStr(' ',45)+CMstMember.Cidade+', '+
                                  PushLeft(2,EditInteger(TabDia[MM]))+
                                  Acentua(TabMesX[MM])+
                                  PushLeft(2,EditInteger(AA)));
            WriteLine('L',' ');
            WriteLine('L',' ');
            WriteLine('L',' ');
            If T = 80 then
               begin
                 WriteLine('L',ConstStr(' ',14)+Cx+ConstStr('-',40)+
                           ConstStr(' ',10)+ConstStr('-',40)+Cf);
                 WriteLine('L',ConstStr(' ',14)+Cx+Acentua(Titulo1)+
                           ConstStr(' ',50-Length(Titulo1))+
                           Acentua(Titulo2)+Cf);
                 WriteLine('L',ConstStr(' ',14)+Cx+Acentua(Assin1)+
                           ConstStr(' ',50-Length(Assin1))+Acentua(Assin2)+Cf);
               end
               else begin
                      WriteLine('L',ConstStr(' ',16)+ConstStr('-',40)+
                                ConstStr(' ',10)+ConstStr('-',40));
                      WriteLine('L',ConstStr(' ',16)+Acentua(Titulo1)+
                                ConstStr(' ',50-Length(Titulo1))+
                                Acentua(Titulo2));
                      WriteLine('L',ConstStr(' ',16)+Acentua(Assin1)+
                                ConstStr(' ',50-Length(Assin1))+
                                Acentua(Assin2));
                    end;
          end;
       TC := #13;
       Footer;
       If DskRpt = 'N' then WriteLine('W',Qp);
       Window(1,1,80,25);
       MarkBlue;
       GotoXY(1,23);  Write(' Total de Contas Impressas: ');
       Color(Blue,White);
       GotoXY(29,23); Write(NCont:3);
       TeclaReturn;
       If Root6 <> NIL then Dispose6 (Root6);
       Root6 := NIL;
     end;
end;


Procedure PedeDepto;
begin
  Color(Tfn,Ttx);
  GotoXY(4,11); Write('1§.Dep:');
  GotoXY(4,12); Write('2§.Dep:');
  DeptI   := '';
  UltDept := '';
  Repeat
    K := 1;
    Repeat
      Case K of
           1   : begin
                   Color(Blue,White);
                   GotoXY(1,24); Write(ConstStr(' ',80));
                   GotoXY(2,24); Write('F1');
                   Color(Blue,Cyan);
                   GotoXY(5,24); Write('para pesquisar Departamentos');
                   J := DeptI;
                   Color(Tfn,Utx);
                   GotoXY(12,11); Write(' ':15);
		   InputStr(J,6,12,11,0,'S','S','T','N',Tfn,Utx);
                   LimpaLn(24,Tfd);
                   If TC <> #27 then
                      Case TC of
                           #13 : If J <> '' then
                                    begin
                                      DeptNo := LimpaChave(J);
                                      SearchTree3 ( Root3 );
                                      If RC = 'S' then DeptI := DeptNo
                                         else begin
                                                ErroMsg := 'Departamento n„o Existe';
                                                ErrorMessage;
                                                K := K - 1;
                                                GotoXY(12,11); Write(' ':15);
                                              end;
                                    end
                                    else begin
                                           GotoXY(12,11); Write('** Todos       ');
                                           GotoXY(12,12); Write(' ':15);
                                           DeptI := '';
                                         end;
                           #21 : begin
                                   DeptAC := LimpaChave(J);
                                   DeptNo := DeptAC;
                                   ScrollDept;
                                   DeptI := DeptAC;
                                 end;
                      end;
                 end;
           2   : begin
                   Color(Blue,White);
                   GotoXY(1,24); Write(ConstStr(' ',80));
                   GotoXY(2,24); Write('F1');
                   Color(Blue,Cyan);
                   GotoXY(5,24); Write('para pesquisar Departamentos');
                   J := UltDept;
                   Color(Tfn,Utx);
                   GotoXY(12,12); Write(' ':15);
		   InputStr(J,6,12,12,0,'S','S','T','N',Tfn,Utx);
                   LimpaLn(24,Tfd);
                   If TC <> #27 then
                      Case TC of
                           #13 : If J <> '' then
                                    begin
                                      DeptNo := LimpaChave(J);
                                      SearchTree3 ( Root3 );
                                      If RC = 'S' then
                                         begin
                                           If DeptNo < DeptI then
                                              begin
                                                ErroMsg := 'Departamento Fim Menor';
                                                ErrorMessage;
                                                K := K - 1;
                                              end
                                              else UltDept := DeptNo;
                                         end
                                         else begin
                                                ErroMsg := 'Departamento n„o Existe';
                                                ErrorMessage;
                                                K := K - 1;
                                              end;
                                    end
                                    else begin
                                           GotoXY(12,12); Write('** At‚ o Fim   ');
                                           UltDept := '999999';
                                         end;
                           #21 : begin
                                   DeptAC := LimpaChave(J);
                                   DeptNo := DeptAC;
                                   ScrollDept;
                                   UltDept := DeptAC;
                                 end;
                      end;
                 end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 3) or (TC = #27);
    If TC <> #27 then Confirma;
  Until (TC = 'S') or (TC = #27);
end;


Procedure Total16;
begin
  If TruncX(TRecA) < 0
     then Abert := '<' + EditDouble(TRecA) + '>'
     else Abert := ' ' + EditDouble(TRecA) + ' ';
  If TruncX(TDespA) < 0
     then Abert1 := '<' + EditDouble(TDespA) + '>'
     else Abert1 := ' ' + EditDouble(TDespA) + ' ';
  If TruncX(TRec) < 0
     then Sald := '<' + EditDouble(TRec) + '>'
     else Sald := ' ' + EditDouble(TRec) + ' ';
  If TruncX(TDesp) < 0
     then Sald1 := '<' + EditDouble(TDesp) + '>'
     else Sald1 := ' ' + EditDouble(TDesp) + ' ';
  If T = 80
     then WriteLine('L',Cx+ConstStr(' ',62)+
                        PushRight(16,'----------------')+' '+
                        PushRight(16,'----------------')+
                        PushRight(17,'----------------')+' '+
                        PushRight(16,'----------------')+Cf)
     else WriteLine('L',ConstStr(' ',62)+
                        PushRight(16,'----------------')+' '+
                        PushRight(16,'----------------')+
                        PushRight(17,'----------------')+' '+
                        PushRight(16,'----------------'));
  If T = 80
     then WriteLine('L',Cx+ConstStr(' ',62)+
                        PushRight(16,Sald)+' '+
                        PushRight(16,Abert)+
                        PushRight(17,Sald1)+' '+
                        PushRight(16,Abert1)+Cf)
     else WriteLine('L',ConstStr(' ',62)+
                        PushRight(16,Sald)+' '+
                        PushRight(16,Abert)+
                        PushRight(17,SAld1)+' '+
                        PushRight(16,Abert1));
  TRec    := 0;
  TRecA   := 0;
  TDesp   := 0;
  TDespA  := 0;
end;


Procedure Total17;
Var
  Resultado  : Double;
  SinalA     : Array[1..3] of Char;

begin
  If TruncX(TRecA) < 0
     then SinalA[1] := '-'
     else SinalA[1] := ' ';
  If TruncX(TDespA) < 0
     then SinalA[2] := '-'
     else SinalA[2] := ' ';
  Resultado := TRecA + TDespA;
  If TruncX(Resultado) < 0
     then SinalA[3] := '-'
     else SinalA[3] := ' ';
  If T = 80  then WriteLine('L',Cx+ConstStr(' ',21)+
                                PushLeft(20,'Total da Receita')+
                                PushRight(12,EditDouble(TRecA))+SinalA[1]+
                                ConstStr(' ',17)+
                                PushLeft(20,'Total da Despesa')+
                                PushRight(12,EditDouble(TDespA))+SinalA[2]+
                                ConstStr(' ',14)+
                                PushLeft(6,'Saldo')+
                                PushRight(12,EditDouble(Resultado))+SinalA[3]+Cf)
             else WriteLine('L',ConstStr(' ',21)+
                                PushLeft(20,'Total da Receita')+
                                PushRight(12,EditDouble(TRecA))+SinalA[1]+
                                ConstStr(' ',17)+
                                PushLeft(20,'Total da Despesa')+
                                PushRight(12,EditDouble(TDespA))+SinalA[2]+
                                ConstStr(' ',14)+
                                PushLeft(6,'Saldo')+
                                PushRight(12,EditDouble(Resultado))+SinalA[3]);
  TRecA   := 0;
  TDespA  := 0;
end;


Procedure ProcNo11Report;
Var
  Achou        : Char;
  Sinal        : Array[1..13] of Char;
begin
  PedeDepto;
  If TC = 'S' then
     begin
       HeaderReportSetUp;
       ParaContinua;
       MessageReport;
       NCont   := 0;
       TRec    := 0;
       TRecA   := 0;
       TDesp   := 0;
       TDespA  := 0;
       If DeptI <> '' then
          begin
            RC     := 'N';
            DeptNo := LimpaChave(DeptI);
            SearchAnt3 ( Root3 );
            If RC = 'N' then DeptNo := '';
          end
          else DeptNo := DeptI;
       DeptAC := '';
       Repeat
         RC := 'N';
         SearchPos3 ( Root3 );
         If RC = 'S' then
            With DeptMember do
            begin
              ReadWrite(#05,'R','N',DeptNumber);
              ExpeNo := DeptNo;
              Achou  := 'N';
              Repeat
                RC := 'N';
                SearchPos5 ( Root5 );
                If (RC     = 'S'                            ) and
                   (DeptNo = Copy(ExpeNo,1,(Length(DeptNo)))) then
                   With ExpeMember do
                   begin
                     ReadWrite(#07,'R','N',ExpeNumber);
                     ContaNo := LimpaChave(ExpeMember.Conta);
                     SearchTree1 ( Root1 );
                     If RC = 'S' then
                        With ContaMember do
                        begin
                          ReadWrite(#03,'R','N',ContaNumber);
                          If (ContLin  > 50    ) or
                             (DeptAC  <> DeptNo) then
                             begin
                               If (DeptAC <> '') and (ProcNo = 16) then Total16;
                               HeaderReport;
                               If DeptAC <> DeptNo then
                                  begin
                                    DeptAC := DeptNo;
                                    NCont  := NCont + 1;
                                    Writeln(NomeDepto);
                                    WriteLine('L',' ');
                                    WriteLine('L',PushLeft(7,OrigChave)+
                                              Nx+Acentua(NomeLocal)+Nf+' / '+
                                              Nx+Acentua(NomeDepto)+Nf);
                                    WriteLine('L',' ');
                                    If ProcNo = 17 then WriteLine('L',Cx+ConstStr('-',137)+Cf);
                                  end;
                             end;
                          Case ProcNo of
                               11 : begin
                                      If Corrigivel = 'S' then
                                         begin
                                           Str(CMstMember.AnoAtivo,XAno);
                                           IINo := XAno + '#' + IndiceX;
                                           SearchTree7 ( Root7 );
                                           If RC = 'S' then
                                              begin
                                                ReadWrite(#12,'R','N',IINumber);
                                                If RW = 'S'
                                                   then Sald := EcoMember.Descricao
                                                   else Sald := '';
                                                If T = 80
                                                   then WriteLine('L',ConstStr(' ',7)+
                                                                  Cx+PushLeft(19,OrigConta)+
                                                                  Acentua(Descricao)+' '+
                                                                  ConstStr('.',42-Length(Descricao))+
                                                                  Acentua(Sald)+
                                                                  ConstStr(' ',8-Length(Sald))+
                                                                  ' Janeiro    '+
                                                                  PushRight(18,EditDouble(ValorO[1]))+Cf)
                                                   else WriteLine('L',ConstStr(' ',7)+
                                                                  PushLeft(19,OrigConta)+
                                                                  Acentua(Descricao)+' '+
                                                                  ConstStr(' ',42-Length(Descricao))+
                                                                  Acentua(Sald)+
                                                                  ConstStr(' ',8-Length(Sald))+
                                                                  ' Janeiro    '+
                                                                  PushRight(18,EditDouble(ValorO[1])));
                                              end
                                              else RC := 'S';
                                         end
                                         else If T = 80
                                                 then WriteLine('L',ConstStr(' ',7)+Cx+
                                                                PushLeft(19,OrigConta)+
                                                                Acentua(Descricao)+' '+
                                                                ConstStr('.',41-Length(Descricao))+
                                                                ' ------   Janeiro    '+
                                                                PushRight(18,EditDouble(ValorO[1]))+Cf)
                                                 else WriteLine('L',ConstStr(' ',7)+
                                                                PushLeft(19,OrigConta)+
                                                                Acentua(Descricao)+' '+
                                                                ConstStr(' ',41-Length(Descricao))+
                                                                ' ------   Janeiro    '+
                                                                PushRight(18,EditDouble(ValorO[1])));
                                      If T = 80
                                         then For I := 2 to 12 do
                                              WriteLine('L',ConstStr(' ',7)+
                                                        Cx+ConstStr(' ',71)+
                                                        Acentua(ArrayMesEX[I])+
                                                        ConstStr(' ',11-Length(ArrayMesEx[I]))+
                                                        PushRight(18,EditDouble(ValorO[I]))+Cf)
                                         else For I := 2 to 12 do
                                              WriteLine('L',ConstStr(' ',78)+
                                                        Acentua(ArrayMesEX[I])+
                                                        ConstStr(' ',11-Length(ArrayMesEx[I]))+
                                                        PushRight(18,EditDouble(ValorO[I])));
                                      WriteLine('L',' ');
                                    end;
                               12 : begin
                                      If (Despesas[MM] > ValorO[MM]) and
                                         (ValorO[MM]   > 0         ) then
                                         begin
                                           Perct := ((Despesas[MM]/ValorO[MM])-1)*100;
                                           If Perct > 999.99
                                              then PerctX := '******'
                                              else PerctX := EditDouble(Perct);
                                           If T = 80
                                              then WriteLine('L',ConstStr(' ',7)+
                                                             Cx+PushLeft(19,OrigConta)+
                                                           Acentua(Descricao)+' '+
                                                           ConstStr('.',41-Length(Descricao))+' '+
                                                           PushRight(18,EditDouble(ValorO[MM]))+' '+
                                                           PushRight(18,EditDouble(Despesas[MM]))+
                                                           ' '+PushRight(6,PerctX)+Cf)
                                              else WriteLine('L',ConstStr(' ',7)+
                                                           PushRight(19,OrigConta)+
                                                           Acentua(Descricao)+' '+
                                                           ConstStr(' ',41-Length(Descricao))+' '+
                                                           PushRight(18,EditDouble(ValorO[MM]))+' '+
                                                           PushRight(18,EditDouble(Despesas[MM]))+' '+
                                                           PushRight(6,PerctX));
                                         end
                                         else If T = 80
                                                 then WriteLine('L',ConstStr(' ',7)+
                                                              Cx+PushLeft(19,OrigConta)+
                                                              Acentua(Descricao)+' '+
                                                              ConstStr('.',41-Length(Descricao))+' '+
                                                              PushRight(18,EditDouble(ValorO[MM]))+' '+
                                                              PushRight(18,EditDouble(Despesas[MM]))+
                                                              ' ------'+Cf)
                                                 else WriteLine('L',ConstStr(' ',7)+
                                                              PushLeft(19,OrigConta)+
                                                              Acentua(Descricao)+' '+
                                                              ConstStr(' ',41-Length(Descricao))+' '+
                                                              PushRight(18,EditDouble(ValorO[MM]))+' '+
                                                              PushRight(18,EditDouble(Despesas[MM]))+
                                                              ' ------');
                                    end;
                               16 : begin
                                      Sald   := '';
                                      Abert  := '';
                                      Lucro  := 0;
                                      For I := 1 to MM do Lucro := Lucro + Despesas[I];
                                      If (TruncX(Lucro)        <> 0) or
                                         (TruncX(Despesas[MM]) <> 0) then
                                         begin
                                           If TruncX(Lucro) < 0
                                              then Abert := '<' + EditDouble(Lucro) + '>'
                                              else Abert := ' ' + EditDouble(Lucro) + ' ';
                                           If TruncX(Despesas[MM]) < 0
                                              then Sald := '<' + EditDouble(Despesas[MM]) + '>'
                                              else Sald := ' ' + EditDouble(Despesas[MM]) + ' ';

                                           Case ContaMember.Grupo of
                                                'D' : begin
                                                        TDesp := TDesp + Despesas[MM];
                                                        TDespA := TDespA + Lucro;
                                                      end;
                                                'R' : begin
                                                        TRec := TRec + Despesas[MM];
                                                        TRecA := TRecA + Lucro;
                                                      end;
                                           end;
                                           If T = 80 then
                                              begin
                                                Case ContaMember.Grupo of
                                                     'D' : WriteLine('L',Cx+PushLeft(19,OrigConta)+
                                                                            Acentua(Descricao)+' '+
                                                                            ConstStr('.',42-Length(Descricao))+
                                                                            PushRight(50,Sald)+' '+
                                                                            PushRight(16,Abert)+Cf);

                                                     'R' : WriteLine('L',Cx+PushLeft(19,OrigConta)+
                                                                            Acentua(Descricao)+' '+
                                                                            ConstStr('.',42-Length(Descricao))+
                                                                            PushRight(16,Sald)+' '+
                                                                            PushRight(16,Abert)+Cf)
                                                end;
                                              end
                                              else begin
                                                     Case ContaMember.Grupo of
                                                          'D' : WriteLine('L',PushLeft(19,OrigConta)+
                                                                              Acentua(Descricao)+
                                                                              ConstStr(' ',42-Length(Descricao))+
                                                                              PushRight(50,Sald)+' '+
                                                                              PushRight(16,Abert));
                                                          'R' : WriteLine('L',PushLeft(19,OrigConta)+
                                                                              Acentua(Descricao)+
                                                                              ConstStr(' ',42-Length(Descricao))+
                                                                              PushRight(16,Sald)+' '+
                                                                              PushRight(16,Abert));
                                                     end;
                                                   end;
                                         end;
                                    end;
                               17 : begin
                                      Lucro := 0;
                                      For I := 1 to 12 do
                                      begin
                                        Lucro := Lucro + Despesas[I];
                                        If Despesas[I] < 0 then Sinal[I] := '-'
                                                           else Sinal[I] := ' ';
                                      end;
                                      If Lucro < 0 then Sinal[13] := '-'
                                                   else Sinal[13] := ' ';
                                      If TruncX(Lucro) <> 0 then
                                         begin
                                           Achou := 'S';
                                           Case ContaMember.Grupo of
                                                'D' : TDespA := TDespA + Lucro;
                                                'R' : TRecA  := TRecA  + Lucro;
                                           end;
                                           If T = 80 then
                                              begin
                                                WriteLine('L',Cx+PushLeft(41,Descricao)+
                                                                 PushRight(12,EditDouble(Despesas[01]))+Sinal[1]+' '+
                                                                 PushRight(12,EditDouble(Despesas[02]))+Sinal[2]+' '+
                                                                 PushRight(12,EditDouble(Despesas[03]))+Sinal[3]+' '+
                                                                 PushRight(12,EditDouble(Despesas[04]))+Sinal[4]+' '+
                                                                 PushRight(12,EditDouble(Despesas[05]))+Sinal[5]+' '+
                                                                 PushRight(12,EditDouble(Despesas[06]))+Sinal[6]+Cf);
                                                WriteLine('L',Cx+PushLeft(41,(' cod: ' + OrigConta))+
                                                                 PushRight(12,EditDouble(Despesas[07]))+Sinal[7]+' '+
                                                                 PushRight(12,EditDouble(Despesas[08]))+Sinal[8]+' '+
                                                                 PushRight(12,EditDouble(Despesas[09]))+Sinal[9]+' '+
                                                                 PushRight(12,EditDouble(Despesas[10]))+Sinal[10]+' '+
                                                                 PushRight(12,EditDouble(Despesas[11]))+Sinal[11]+' '+
                                                                 PushRight(12,EditDouble(Despesas[12]))+Sinal[12]+
                                                                 PushRight(12,EditDouble(Lucro))+Sinal[13]+Cf);
                                                WriteLine('L',Cx+ConstStr('-',137)+Cf);
                                              end
                                              else begin
                                                     WriteLine('L',PushLeft(41,Descricao)+
                                                                   PushRight(12,EditDouble(Despesas[01]))+Sinal[1]+' '+
                                                                   PushRight(12,EditDouble(Despesas[02]))+Sinal[2]+' '+
                                                                   PushRight(12,EditDouble(Despesas[03]))+Sinal[3]+' '+
                                                                   PushRight(12,EditDouble(Despesas[04]))+Sinal[4]+' '+
                                                                   PushRight(12,EditDouble(Despesas[05]))+Sinal[5]+' '+
                                                                   PushRight(12,EditDouble(Despesas[06]))+Sinal[6]);
                                                     WriteLine('L',PushLeft(41,(' cod: ' + OrigConta))+
                                                                   PushRight(12,EditDouble(Despesas[07]))+Sinal[7]+' '+
                                                                   PushRight(12,EditDouble(Despesas[08]))+Sinal[8]+' '+
                                                                   PushRight(12,EditDouble(Despesas[09]))+Sinal[9]+' '+
                                                                   PushRight(12,EditDouble(Despesas[10]))+Sinal[10]+' '+
                                                                   PushRight(12,EditDouble(Despesas[11]))+Sinal[11]+' '+
                                                                   PushRight(12,EditDouble(Despesas[12]))+Sinal[12]+
                                                                   PushRight(12,EditDouble(Lucro))+Sinal[13]);
                                                     WriteLine('L',Cx+ConstStr('-',137)+Cf);
                                                   end;
                                         end;
                                    end;
                          end;
                        end
                        else RC := 'S';
                   end;
                GoNoGo;
                If TC = #27 then RC := 'X';
              Until (RC = 'N') or (RC = 'X');
              If RC = 'X' then RC := 'N'
                          else RC := 'S';
              If UltDept = DeptNo then RC := 'N';
              If (Achou = 'S') and (ProcNo = 17) then Total17;
            end;
       Until RC = 'N';
       If NCont > 0 then
          begin
            If ProcNo = 16 then Total16;
            TC := #13;
            Footer;
            If DskRpt = 'N' then WriteLine('W',Qp);
          end;
       Window(1,1,80,25);
       MarkBlue;
       GotoXY(1,23);  Write(' Total de Departamentos Impressos: ');
       Color(Blue,White);
       GotoXY(36,23); Write(NCont:3);
       TeclaReturn;
     end;
end;


Procedure LinhaDeptoReport;
begin
  If (ContLin  > 55    ) or
     (DeptNo  <> DeptAC) then
     With DeptMember do
     begin
       If ContLin > 55 then HeaderReport;
       WriteLine('L',Nx+PushLeft(7,OrigChave)+
                     Acentua(NomeLocal)+' / '+Acentua(NomeDepto)+Nf);
       Writeline('L',' ');
       DeptAC   := DeptNo;
     end;
  With LctoMember do
  begin
    If Tipo = 'D'
       then TDebitos  := TDebitos  + TruncX(Valor)
       else TCreditos := TCreditos + TruncX(Valor);
    Case T of
         80  : If Tipo = 'D'
                  then WriteLine('L',Cx+Copy(OrigData,1,2)+' '+
                                     PushLeft(19,ContaMember.OrigConta)+
                                     Acentua(HistP)+
                                     ConstStr(' ',62-Length(HistP))+
                                     PushRight(14,EditDouble(Valor))+Cf)
                  else Writeline('L',Cx+Copy(OrigData,1,2)+' '+
                                     PushLeft(19,ContaMember.OrigConta)+
                                     Acentua(HistP)+
                                     ConstStr(' ',77-Length(HistP))+
                                     PushRight(14,EditDouble(Valor))+Cf);
         else  If Tipo = 'D'
                  then WriteLine('L',Copy(OrigData,1,2)+' '+
                                   PushLeft(19,ContaMember.OrigConta)+
                                   Acentua(HistP)+
                                   ConstStr(' ',61-Length(HistP))+
                                   PushRight(16,EditDouble(Valor)))
                  else WriteLine('L',Copy(OrigData,1,2)+' '+
                                   PushLeft(19,ContaMember.OrigConta)+
                                   Acentua(HistP)+
                                   ConstStr(' ',77-Length(HistP))+
                                   PushRight(16,EditDouble(Valor)));
    end;
    Case ContaMember.Grupo of
         'R' : If Tipo = 'D' then TR := TR + Valor
                             else TR := TR - Valor;
         'D' : If Tipo = 'D' then TD := TD + Valor
                             else TD := TD - Valor;
    end;
  end;
end;


Procedure ProcNo13Report;
begin
  PedeDepto;
  If TC = 'S' then
     begin
       If FileSize(LctoFile) > 0 then
          With LctoMember do
          begin
            If DM = 'S' then DescarregaM;
            If Root4 <> NIL then Dispose4 (Root4);
            Root4 := NIL;
            If Root6 <> NIL then Dispose6 (Root6);
            Root6 := NIL;
            Color(Blue,Cyan);
            GotoXY(1,24);  Write(ConstStr(' ',80));
            GotoXY(2,24);
            Write('Estou criando Indice para Impress„o do ');
            Color(Blue,Yellow);
            GotoXY(41,24); Write('Relat¢rio');
            Color(Blue,(White + Blink));
            GotoXY(65,24); Write('Aguarde');
            I := -1;
            Repeat
              I := I + 1;
              ReadWrite(#08,'R','N',I);
              Val(Copy(OrigData,7,2),K,E);
              If (RW                  =  'S') and
                 (Status              =  'A') and
                 (Depto               <> '' ) and
                 (CMstMember.AnoAtivo =  K  ) then
                 begin
                   DCVSNumber := I;
                   DCVSNo     := LimpaChave(Depto)  + '#' +
                                 Copy(OrigData,1,2) + '#' +
                                 Conta              + '#' +
                                 Lote               + '#' +
                                 SeqLote;
                   LoadTree6 ( Root6 );
                   ShowHeap;
                   Color(Tfd,Utx);
                 end;
            Until (I + 1) = FileSize(LctoFile);
            LimpaLn(24,Tfd);
          end
          else begin
                 ErroMsg := 'N„o h  lan‡amentos em ' + ArrayMesEx[MM];
                 ErrorMessage;
                 TC := #27;
               end;
       If TC <> #27 then
          With DeptMember do
          begin
            HeaderReportSetUp;
            ParaContinua;
            MessageReport;
            NCont := 0;
            If DeptI <> '' then
               begin
                 RC     := 'N';
                 DeptNo := LimpaChave(DeptI);
                 SearchAnt3 ( Root3 );
                 If RC = 'N' then DeptNo := '';
               end
               else DeptNo := DeptI;
            DeptAC := '';
            Repeat
              RC := 'N';
              SearchPos3 ( Root3 );
              If RC = 'S' then
                 With DeptMember do
                 begin
                   ReadWrite(#05,'R','N',DeptNumber);
                   Writeln(NomeDepto);
                   DCVSNo    := DeptNo + '#';
                   SaldoX    := 0;
                   TDebitos  := 0;
                   TCreditos := 0;
                   TR        := 0;
                   TD        := 0;
                   Repeat
                     RC := 'N';
                     SearchPos6 ( Root6 );
                     If (RC     = 'S'                          ) and
                        (DeptNo = Copy(DCVSNo,1,Length(DeptNo))) then
                        begin
                          ReadWrite(#08,'R','N',DCVSNumber);
                          ContaNo := LimpaChave(LctoMember.Conta);
                          SearchTree1 ( Root1 );
                          If RC = 'S' then
                             begin
                               ReadWrite(#03,'R','N',ContaNumber);
                               If (ContaMember.Grupo = 'D') or
                                  (ContaMember.Grupo = 'R') then
                                  begin
                                    HistP := ContaMember.Descricao;
                                    NCont := NCont + 1;
                                    LinhaDeptoReport;
                                  end;
                             end
                             else RC := 'S';
                        end
                        else RC := 'N';
                     GoNoGo;
                     If TC = #27 then RC := 'X';
                   Until (RC = 'N') or (RC = 'X');
                   If (TDebitos + TCreditos) > 0 then
                      begin
                        SaldoX := TDebitos - TCreditos;
                        If SaldoX < 0
                           then Sald := '<' + EditDouble(SaldoX) + '>'
                           else Sald := ' ' + EditDouble(SaldoX) + ' ';
                        Case T of
                             80  : begin
                                     WriteLine('L',Cx+ConstStr(' ',84)+
                                                 '-------------- '+
                                                 '-------------- '+
                                                 '------------------');
                                     WriteLine('L',Cx+ConstStr(' ',84)+
                                                 PushRight(14,EditDouble(TDebitos))+' '+
                                                 PushRight(14,EditDouble(TCreditos))+
                                                 PushRight(19,Sald)+Cf);
                                   end;
                             132 : begin
                                     WriteLine('L',ConstStr(' ',83)+
                                                   ConstStr('-',49));
                                     WriteLine('L',ConstStr(' ',83)+
                                                   PushRight(16,EditDouble(TDebitos))+
                                                   PushRight(16,EditDouble(TCreditos))+' '+
                                                   PushRight(16,Sald));
                                   end;
                        end;
                        WriteLine('L',' ');
                        Case T of
                             80  : begin
                                     If TR < 0 then Sald := '<' + EditDouble(TR) + '>'
                                               else Sald := ' ' + EditDouble(TR) + ' ';
                                     WriteLine('L',Cx+ConstStr(' ',96)+
                                               'Total da Receita '+PushRight(19,Sald)+Cf);
                                     If TD < 0 then Sald := '<' + EditDouble(TD) + '>'
                                               else Sald := ' ' + EditDouble(TD) + ' ';
                                     WriteLine('L',Cx+ConstStr(' ',96)+
                                               'Total da Despesa '+PushRight(19,Sald)+Cf);
                                   end;
                             132 : begin
                                     If TR < 0 then Sald := '<' + EditDouble(TR) + '>'
                                               else Sald := ' ' + EditDouble(TR) + ' ';
                                     WriteLine('L',PushRight(116,'Total da Receita ')+
                                                   PushRight(16,Sald));
                                     If TD < 0 then Sald := '<' + EditDouble(TD) + '>'
                                               else Sald := ' ' + EditDouble(TD) + ' ';
                                     WriteLine('L',PushRight(116,'Total da Despesa ')+
                                                   PushRight(16,Sald));
                                   end;
                        end;
                        If T = 80 then WriteLine('L',ConstStr('-',T-3))
                                  else WriteLine('L',ConstStr('-',T));
                        TR      := 0;
                        TD      := 0;
                      end;
                   If RC = 'X' then RC := 'N'
                               else RC := 'S';
                 end;
              If UltDept = DeptNo then RC := 'N';
              GoNoGo;
              If TC = #27 then RC := 'N';
            Until RC = 'N';
            If NCont > 0 then
               begin
                 TC := #13;
                 Footer;
                 If DskRpt = 'N' then WriteLine('W',Qp);
               end;
            Window(1,1,80,25);
            MarkBlue;
            GotoXY(1,23);  Write(' Total de Lan‡amentos Impressos: ');
            Color(Blue,White);
            GotoXY(34,23); Write(NCont:4);
            TeclaReturn;
            If Root6 <> NIL then Dispose6 (Root6);
            Root6 := NIL;
          end;
       Reset ( IndMFile );
       LoadLcto;
       Close ( IndMFile );
     end;
end;


Procedure EntryTermoReport;
begin
  Color(Tfn,Ttx);
  GotoXY(04,10); Write('A ou F:');
  GotoXY(35,10); Write('R ou D:');
  GotoXY(04,11); Write('Ativid:');
  GotoXY(04,12); Write('N§.Fol:');
  GotoXY(04,13); Write('Livro.:');
  GotoXY(04,14); Write('Regist:');
  GotoXY(35,14); Write('Junta.:');
  GotoXY(04,15); Write('Data..:');
  GotoXY(04,16); Write('Cargo.:');
  GotoXY(04,17); Write('Nome..:');
  GotoXY(04,18); Write('Cargo.:');
  GotoXY(04,19); Write('Nome..:');
  GotoXY(04,20); Write('Local.:');
  GotoXY(35,20); Write('Data..:');
  Tipo      := ' ';
  RouD      := ' ';
  Atividade := '';
  NumF      := 0;
  Livro     := 0;
  RegJunta  := '';
  Junta     := '';
  DataDP    := '';
  Titulo1   := '';
  Assin1    := '';
  Titulo2   := '';
  Assin2    := '';
  Local     := '';
  DDD       := ' ';
  MMM       := 0;
  AAA       := '   ';
  Repeat
    K := 1;
    Repeat
    Case K of
         1   : begin
                 J := Tipo;
                 GotoXY(14,10); Write(' ':20);
		 InputStr(J,1,12,10,0,'S','N','T','N',Tfn,Utx);
                 If TC <> #27 then
                    begin
                      Tipo := UpCase(J[1]);
                      GotoXY(12,10); Write(Tipo);
                      GotoXY(14,10);
                      Case Tipo of
                           'A' : begin
                                   Write('Abertura  ');
                                   Folha := 1;
                                 end;
                           'F' : begin
                                   Write('Fechamento');
                                 end;
                           else begin
                                  ErroMsg := 'Tipo pode ser A ou F';
                                  ErrorMessage;
                                  K       := K - 1;
                                end;
                      end;
                    end;
               end;
         2   : begin
                 J := RouD;
		 InputStr(J,1,43,10,0,'S','N','T','N',Tfn,Utx);
                 If TC <> #27 then
                    begin
                      RouD := UpCase(J[1]);
                      If (RouD <> 'D') and
                         (RouD <> 'R') then
                         begin
                           ErroMsg := 'Responda R-Raz„o ou D-Di rio';
                           ErrorMessage;
                           K       := K - 1;
                         end
                         else begin
                                GotoXY(43,10);
                                Case RouD of
                                     'D' : Write('Di rio');
                                     'R' : Write('Raz„o ');
                                end;
                              end;
                    end;
               end;
         3   : begin
                 J := Atividade;
		 InputStr(J,15,12,11,0,'S','S','T','N',Tfn,Utx);
                 If TC <> #27 then
                    begin
                      Atividade := J;
                      If Atividade = '' then
                         begin
                           ErroMsg := 'Atividade Inv lida';
                           ErrorMessage;
                           K       := K - 1;
                         end;
                    end;
               end;
         4   : begin
                 If NumF = 0 then J := ''
                             else begin
                                    Str(NumF:4,J);
                                    J := LeftAdjust(J);
                                  end;
		 InputStr(J,4,12,12,0,'S','N','T','N',Tfn,Utx);
                 If TC <> #27 then
                    begin
                      Val(J,NumF,E);
                      If NumF = 0 then
                         begin
                           ErroMsg := 'N£mero de Folhas Inv lido';
                           ErrorMessage;
                           K       := K - 1;
                         end
                         else begin
                                GotoXY(12,12); Write(NumF:4);
                                If Tipo = 'F' then Folha := NumF;
                              end;
                    end;
               end;
         5   : begin
                 If Livro = 0 then J := ''
                              else begin
                                     Str(Livro:4,J);
                                     J := LeftAdjust(J);
                                   end;
		 InputStr(J,4,12,13,0,'S','N','T','N',Tfn,Utx);
                 If TC <> #27 then
                    begin
                      Val(J,Livro,E);
                      If Livro = 0 then
                         begin
                           ErroMsg := 'N£mero do Livro Inv lido';
                           ErrorMessage;
                           K       := K - 1;
                         end
                         else begin
                                GotoXY(12,13); Write(Livro:4);
                              end;
                    end;
               end;
         6   : begin
                 J := RegJunta;
		 InputStr(J,20,12,14,0,'S','N','T','N',Tfn,Utx);
                 If TC <> #27 then RegJunta := J;
               end;
         7   : begin
                 J := Junta;
		 InputStr(J,10,43,14,0,'S','N','T','N',Tfn,Utx);
                 If TC <> #27 then
                    begin
                      Junta := J;
                      If Junta = '' then
                         begin
                           ErroMsg := 'Nome da Junta Inv lido';
                           ErrorMessage;
                           K       := K - 1;
                         end;
                    end;
               end;
         8   : begin
                 J := DataDP;
		 InputStr(J,10,12,15,0,'S','N','T','N',Tfn,Utx);
                 If (TC <> #27) and
                    (J <> ''  ) then
                    begin
                      DataDP := J;
                      If DataDP = '' then
                         begin
                           ErroMsg := 'Data de Despacho Inv lida';
                           ErrorMessage;
                           K       := K - 1;
                         end;
                    end;
               end;
         9   : begin
                 J := Titulo1;
		 InputStr(J,35,12,16,0,'S','S','T','N',Tfn,Utx);
                 If TC <> #27 then Titulo1 := J;
               end;
         10  : begin
                 J := Assin1;
		 InputStr(J,35,12,17,0,'S','S','T','N',Tfn,Utx);
                 If TC <> #27 then
                    begin
                      Assin1 := J;
                      If Assin1 = '' then
                         begin
                           ErroMsg := 'Nome Inv lido';
                           ErrorMessage;
                           K       := K - 1;
                         end;
                    end;
               end;
         11  : begin
                 J := Titulo2;
		 InputStr(J,35,12,18,0,'S','S','T','N',Tfn,Utx);
                 If TC <> #27 then Titulo2 := J;
               end;
         12  : begin
                 J := Assin2;
		 InputStr(J,35,12,19,0,'S','S','T','N',Tfn,Utx);
                 If TC <> #27 then
                    begin
                      Assin2 := J;
                      If Assin2 = '' then
                         begin
                           ErroMsg := 'Nome Inv lido';
                           ErrorMessage;
                           K       := K - 1;
                         end;
                    end;
               end;
         13  : begin
                 J := Local;
		 InputStr(J,20,12,20,0,'S','S','T','N',Tfn,Utx);
                 If TC <> #27 then
                    begin
                      Local := J;
                      If Local = '' then
                         begin
                           ErroMsg := 'Local Inv lido';
                           ErrorMessage;
                           K       := K - 1;
                         end;
                    end;
               end;
         14  : begin
                 J := DDD;
		 InputStr(J,2,43,20,0,'S','N','T','N',Tfn,Utx);
                 If TC <> #27 then
                    begin
                      DDD := J;
                      If DDD = '' then
                         begin
                           ErroMsg := 'Dia de Assinatura Inv lido';
                           ErrorMessage;
                           K       := K - 1;
                         end;
                    end;
               end;
         15  : begin
                 GotoXY(45,20); Write('/');
                 If MMM = 0 then J := ''
                           else begin
                                  Str(MMM:2,J);
                                  J := LeftAdjust(J);
                                end;
		 InputStr(J,2,46,20,0,'S','N','T','N',Tfn,Utx);
                 If TC <> #27 then
                    begin
                      Val(J,MMM,E);
                      If MMM = 0 then
                         begin
                           ErroMsg := 'Mˆs de Assinatura Inv lido';
                           ErrorMessage;
                           K       := K - 1;
                         end;
                    end;
               end;
         16  : begin
                 GotoXY(45,20); Write('/');
                 GotoXY(48,20); Write('/');
                 J := AAA;
		 InputStr(J,4,49,20,0,'S','N','T','N',Tfn,Utx);
                 If TC <> #27 then
                    begin
                      AAA := J;
                      If AAA = '' then
                         begin
                           ErroMsg := 'Ano de Assinatura Inv lido';
                           ErrorMessage;
                           K       := K - 1;
                         end;
                    end;
               end;
    end;
    Case TC of
         #13 : K := K + 1;
         #24 : If K > 1 then K := K - 1;
    end;
    Until (K = 17) or (TC = #27);
    If TC <> #27 then Confirma;
  Until TC in [#27,'S'];
end;


Procedure ProcNo14Report;
begin
  EntryTermoReport;
  If TC = 'S' then
     begin
       With CMstMember do
       begin
         ContLin := 0;
         If T = 80 then
            begin
              If Laser <> 'N' then WriteLine('W',LaserInit);
              WriteLine('L',Dx+Acentua(Descricao)+Df);
              WriteLine('L',(ConstStr('-',T)));
              WriteLine('L',Cx+Acentua(Endereco)+', '+Acentua(Cidade)+
                           ', '+Estado+'  Cep: '+Cep+'  Tel. '+Telefone+Cf);
              WriteLine('L',ConstStr(' ',T-11)+'Folha: '+Nx+
                        PushRight(4,EditInteger(Folha))+Nf);
              If Tipo = 'A'
                 then WriteLine('L',Nx+'TERMO DE ABERTURA'+Nf)
                 else WriteLine('L',Nx+'TERMO DE ENCERRAMENTO'+Nf);
              WriteLine('L',' ');
              WriteLine('L',(ConstStr('-',T)));
            end
            else begin
                   If Laser <> 'N' then WriteLine('W',LaserInit);
                   WriteLine('L',ConstStr(' ',10)+Dx+Acentua(Descricao)+Df);
                   WriteLine('L',ConstStr(' ',10)+(ConstStr('-',T-10)));
                   WriteLine('L',ConstStr(' ',10)+Cx+Acentua(Endereco)+', '+
                                Acentua(Cidade)+', '+Estado+
                                '  Cep: '+Cep+'  Tel. '+Telefone+Cf);
                   WriteLine('L',ConstStr(' ',10)+ConstStr(' ',T-21)+'Folha: '+Nx+
                                PushRight(4,EditInteger(Folha))+Nf);
                   If Tipo = 'A'
                      then WriteLine('L',ConstStr(' ',10)+
                                      Nx+'TERMO DE ABERTURA'+Nf)
                      else WriteLine('L',ConstStr(' ',10)+
                                      Nx+'TERMO DE ENCERRAMENTO'+Nf);
                   WriteLine('L',' ');
                   WriteLine('L',ConstStr(' ',10)+ConstStr('-',T-10));
                 end;
       end;
       WriteLine('L',' ');
       WriteLine('L',' ');
       WriteLine('L',' ');
       WriteLine('L',' ');
       WriteLine('L',' ');
       WriteLine('L',' ');
       WriteLine('L',ConstStr(' ',Trunc((T-60)/2))+
                    Acentua('Cont‚m  este  livro  ')+
                    PushRight(4,EditInteger(NumF))+
                    '  folhas   eletronicamente');
       Case RouD of
            'D' : begin
                    If Tipo = 'A'
                       then WriteLine('L',ConstStr(' ',Trunc((T-60)/2))+
                                    'numeradas  de 1 a '+
                                    PushRight(4,EditInteger(NumF))+
                                    Acentua(' e  servir  de  livro  di rio'))
                       else WriteLine('L',ConstStr(' ',Trunc((T-60)/2))+
                                    'numeradas  de 1 a '+
                                    PushRight(4,EditInteger(NumF))+
                                    Acentua(' e  serviu  de  livro  di rio'));
                       WriteLine('L',ConstStr(' ',Trunc((T-60)/2))+
                                 Acentua('n£mero ')+
                                 PushRight(4,EditInteger(Livro))+
                                 ' da firma:');
                  end;
            'R' : begin
                    If Tipo = 'A'
                       then WriteLine('L',ConstStr(' ',Trunc((T-60)/2))+
                                      'numeradas  de 1 a '+
                                      PushRight(4,EditInteger(NumF))+
                                      Acentua(' e  servir   de  livro  raz„o'))
                       else WriteLine('L',ConstStr(' ',Trunc((T-60)/2))+
                                      'numeradas  de 1 a '+
                                      PushRight(4,EditInteger(NumF))+
                                      Acentua(' e  serviu  de   livro  raz„o'));
                    WriteLine('L',ConstStr(' ',Trunc((T-60)/2))+
                              Acentua('n£mero ')+
                              PushRight(4,EditInteger(Livro))+
                              ' da firma:');
                  end;
       end;
       WriteLine('L',' ');
       WriteLine('L',ConstStr(' ',Trunc((T-60)/2))+
                     Nx+Acentua(CMstMember.Descricao)+Nf);
       WriteLine('L',' ');
       WriteLine('L',ConstStr(' ',Trunc((T-60)/2))+'estabelecida a ');
       WriteLine('L',' ');
       WriteLine('L',ConstStr(' ',Trunc((T-60)/2))+
                     Acentua(CMstMember.Endereco));
       WriteLine('L',ConstStr(' ',Trunc((T-60)/2))+
                     Acentua(CMstMember.Cidade)+' - '+CMstMember.Estado);
       WriteLine('L',' ');
       WriteLine('L',ConstStr(' ',Trunc((T-60)/2))+
                     'com   atividade   '+Acentua(Atividade)+
                     ConstStr(' ',18-Length(Atividade))+'registrada   na ');
       WriteLine('L',ConstStr(' ',Trunc((T-60)/2))+Junta+
                     ConstStr(' ',13-Length(Junta))+
                     Acentua(' sob n£mero  ')+Acentua(RegJunta)+
                     ConstStr(' ',22-Length(RegJunta))+'por');
       WriteLine('L',ConstStr(' ',Trunc((T-60)/2))+
                     Acentua('despacho  em  sess„o  de ')+DataDP+
                     Acentua(' e no CGC-MF sob'));
       WriteLine('L',ConstStr(' ',Trunc((T-60)/2))+
                     Acentua('n£mero ')+CMstMember.CpfCgc+'.');
       WriteLine('L',' ');
       WriteLine('L',ConstStr(' ',Trunc((T-60)/2))+
                     Acentua('Conforme  o artigo 5 da instru‡„o normativa  n£mero'));
       WriteLine('L',ConstStr(' ',Trunc((T-60)/2))+
                     Acentua('3 de 19/08/1986 do D.N.R.C. declaramos que o presente'));
       WriteLine('L',ConstStr(' ',Trunc((T-60)/2))+
                     'livro encontra-se totalmente escriturado.');
       WriteLine('L',' ');
       WriteLine('L',' ');
       WriteLine('L',' ');
       WriteLine('L',' ');
       WriteLine('L',' ');
       WriteLine('L',ConstStr(' ',Trunc((T-50)/2))+Acentua(Local)+', '+
                     DDD+Acentua(TabMesX[MMM])+AAA);
       WriteLine('L',' ');
       WriteLine('L',' ');
       WriteLine('L',' ');
       WriteLine('L',' ');
       WriteLine('L',' ');
       WriteLine('L',' ');
       WriteLine('L',ConstStr(' ',Trunc((T-50)/2))+ConstStr('-',40));
       WriteLine('L',ConstStr(' ',Trunc((T-50)/2))+Acentua(Titulo1));
       WriteLine('L',ConstStr(' ',Trunc((T-50)/2))+Acentua(Assin1));
       WriteLine('L',' ');
       WriteLine('L',' ');
       WriteLine('L',' ');
       WriteLine('L',' ');
       WriteLine('L',' ');
       WriteLine('L',' ');
       WriteLine('L',' ');
       WriteLine('L',ConstStr(' ',Trunc((T-50)/2))+ConstStr('-',40));
       WriteLine('L',ConstStr(' ',Trunc((T-50)/2))+Acentua(Titulo2));
       WriteLine('L',ConstStr(' ',Trunc((T-50)/2))+Acentua(Assin2));
       Footer;
       If DskRpt = 'N' then WriteLine('W',Qp);
       Color(Blue,Cyan);
       GotoXY(1,23); Write(ConstStr(' ',80));
       TeclaReturn;
     end;
end;


end.
