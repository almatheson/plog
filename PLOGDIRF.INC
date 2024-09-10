Procedure DataDirf1;
begin
  Color(Tfn,Utx);
  GotoXY(12,08); Write(EEMember.Matricula,' ',PushLeft(40,EEMember.Nome));
  Color(Bfn,Btx);
  GotoXY(03,09);
  Write(' MM    Rendimentos Dependent.       PensÆo  IR na Fonte ');
  Color(Tfn,Utx);
  For I := 1 to 12 do begin
                        GotoXY(04,(I + 9));
                        Write(I:2,' ',EditReal(HPMember.RendDirf[I]):14,' ',
                                      EditReal(HPMember.Dependentes[I]):10,' ',
                                      EditReal(HPMember.Pensao[I]):12,' ',
                                      EditReal(HPMember.IRenda[I]):12);
                      end;
end;


Procedure EntryDirf11;
begin
  I := 1;
  Repeat
    Case I of
         1 : begin
               If HPMember.RendDirf[K] = 0 then J := ''
                  else begin
                         Str(HPMember.RendDirf[K]:13:2,J);
                         J := LeftAdjust(J);
                       end;
               InputStr(J,14,7,(K + 9),0,'S','N','$','N',Tfn,Utx);
               Val(J,HPMember.RendDirf[K],E);
             end;
         2 : begin
               If HPMember.Dependentes[K] = 0 then J := ''
                  else begin
                         Str(HPMember.Dependentes[K]:10:2,J);
                         J := LeftAdjust(J);
                       end;
               InputStr(J,10,22,(K + 9),0,'S','N','$','N',Tfn,Utx);
               Val(J,HPMember.Dependentes[K],E);
             end;
         3 : begin
               If HPMember.Pensao[K] = 0 then J := ''
                  else begin
                         Str(HPMember.Pensao[K]:12:2,J);
                         J := LeftAdjust(J);
                       end;
               InputStr(J,12,33,(K + 9),0,'S','N','$','N',Tfn,Utx);
               Val(J,HPMember.Pensao[K],E);
             end;
         4 : begin
               If HPMember.IRenda[K] = 0 then J := ''
                  else begin
                         Str(HPMember.IRenda[K]:12:2,J);
                         J := LeftAdjust(J);
                       end;
               InputStr(J,12,46,(K + 9),0,'S','N','$','N',Tfn,Utx);
               Val(J,HPMember.IRenda[K],E);
             end;
    end;
    Case TC of
         #13 : I := I + 1;
         #24 : I := I - 1;
    end;
  Until (I = 5) or (I = 0) or (TC = #27);
end;


Procedure EntryDirf1;
begin
  Repeat
    K := 1;
    Repeat
      Case K of
           1..12 : EntryDirf11;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 13) or (TC = #27);
    Confirma;
  Until TC in ['S',#27];
end;


Procedure DataDirf2;
begin
  Color(Tfn,Utx);
  GotoXY(12,08); Write(EEMember.Matricula,' ',PushLeft(40,EEMember.Nome));
  Color(Bfn,Btx);
  GotoXY(03,09);
  Write(' MM    Sal rio Fam                    INSS              ');
  Color(Tfn,Utx);
  For I := 1 to 12 do begin
                        GotoXY(04,(I + 9));
                        Write(I:2,' ',EditReal(HPMember.SalarioFaml[I]):14,' ':10,
                                      EditReal(HPMember.ValorInss[I]):14);
                      end;
end;


Procedure EntryDirf22;
begin
  I := 1;
  Repeat
    Case I of
         1 : begin
               If HPMember.SalarioFaml[K] = 0 then J := ''
                  else begin
                         Str(HPMember.SalarioFaml[K]:13:2,J);
                         J := LeftAdjust(J);
                       end;
               InputStr(J,14,7,(K + 9),0,'S','N','$','N',Tfn,Utx);
               Val(J,HPMember.SalarioFaml[K],E);
             end;
         2 : begin
               If HPMember.ValorInss[K] = 0 then J := ''
                  else begin
                         Str(HPMember.ValorInss[K]:13:2,J);
                         J := LeftAdjust(J);
                       end;
               InputStr(J,14,31,(K + 9),0,'S','N','$','N',Tfn,Utx);
               Val(J,HPMember.ValorInss[K],E);
             end;
    end;
    Case TC of
         #13 : I := I + 1;
         #24 : I := I - 1;
    end;
  Until (I = 3) or (I = 0) or (TC = #27);
end;


Procedure EntryDirf2;
begin
  Repeat
    K := 1;
    Repeat
      Case K of
           1..12 : EntryDirf22;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 13) or (TC = #27);
    Confirma;
  Until TC in ['S',#27];
end;


Procedure DataDirf3;
begin
  Color(Tfn,Utx);
  GotoXY(12,08); Write(EEMember.Matricula,' ',PushLeft(40,EEMember.Nome));
  Color(Bfn,Btx);
  GotoXY(03,10);
  Write(' F‚rias        MM    Rendimentos Dependent.     IR.Fonte ');
  Color(Tfn,Utx);
  GotoXY(18,12); Write(HPMember.Ferias_Mes:2,' ',
                       EditReal(HPMember.Ferias_Valor):14,' ',
                       EditReal(HPMember.Ferias_Dep):10,' ',
                       EditReal(HPMember.Ferias_IR):12);
  Color(Bfn,Btx);
  GotoXY(03,15);
  Write(' 13§ Sal rio   MM    Rendimentos Dependent.     IR.Fonte ');
  Color(Tfn,Utx);
  GotoXY(18,17); Write(HPMember.Pg13_Mes:2,' ',
                       EditReal(HPMember.Pg13_ValorD):14,' ',
                       EditReal(HPMember.Pg13_Dep):10,' ',
                       EditReal(HPMember.Pg13_IR):12);
end;


Procedure EntryDirf3;
begin
  Repeat
    K := 1;
    Repeat
      Case K of
         1 : begin
               If HPMember.Ferias_Mes = 0 then J := ''
                  else begin
                         Str(HPMember.Ferias_Mes:2,J);
                         J := LeftAdjust(J);
                       end;
               InputStr(J,2,18,12,0,'S','N','T','N',Tfn,Utx);
               Val(J,HPMember.Ferias_Mes,E);
               GotoXY(18,12); Write(HPMember.Ferias_Mes:2);
             end;
         2 : begin
               If HPMember.Ferias_Valor = 0 then J := ''
                  else begin
                         Str(HPMember.Ferias_Valor:14:2,J);
                         J := LeftAdjust(J);
                       end;
               InputStr(J,14,21,12,0,'S','N','$','N',Tfn,Utx);
               Val(J,HPMember.Ferias_Valor,E);
             end;
         3 : begin
               If HPMember.Ferias_Dep = 0 then J := ''
                  else begin
                         Str(HPMember.Ferias_Dep:10:2,J);
                         J := LeftAdjust(J);
                       end;
               InputStr(J,10,36,12,0,'S','N','$','N',Tfn,Utx);
               Val(J,HPMember.Ferias_Dep,E);
             end;
         4 : begin
               If HPMember.Ferias_IR = 0 then J := ''
                  else begin
                         Str(HPMember.Ferias_IR:12:2,J);
                         J := LeftAdjust(J);
                       end;
               InputStr(J,12,47,12,0,'S','N','$','N',Tfn,Utx);
               Val(J,HPMember.Ferias_IR,E);
             end;
         5 : begin
               If HPMember.Pg13_Mes = 0 then J := ''
                  else begin
                         Str(HPMember.Pg13_Mes:2,J);
                         J := LeftAdjust(J);
                       end;
               InputStr(J,2,18,17,0,'S','N','T','N',Tfn,Utx);
               Val(J,HPMember.Pg13_Mes,E);
               GotoXY(18,17); Write(HPMember.Pg13_Mes:2);
             end;
         6 : begin
               If HPMember.Pg13_ValorD = 0 then J := ''
                  else begin
                         Str(HPMember.Pg13_ValorD:14:2,J);
                         J := LeftAdjust(J);
                       end;
               InputStr(J,14,21,17,0,'S','N','$','N',Tfn,Utx);
               Val(J,HPMember.Pg13_ValorD,E);
             end;
         7 : begin
               If HPMember.Pg13_Dep = 0 then J := ''
                  else begin
                         Str(HPMember.Pg13_Dep:10:2,J);
                         J := LeftAdjust(J);
                       end;
               InputStr(J,10,36,17,0,'S','N','$','N',Tfn,Utx);
               Val(J,HPMember.Pg13_Dep,E);
             end;
         8 : begin
               If HPMember.Pg13_IR = 0 then J := ''
                  else begin
                         Str(HPMember.Pg13_IR:12:2,J);
                         J := LeftAdjust(J);
                       end;
               InputStr(J,12,47,17,0,'S','N','$','N',Tfn,Utx);
               Val(J,HPMember.Pg13_IR,E);
             end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 9) or (TC = #27);
    Confirma;
  Until TC in ['S',#27];
end;


Procedure ProcessDirf;
Var
  Pag,Linhas   : Integer;
  T1,T2,T3     : Real;
  V1,V2,V3     : Str20;
  A1           : Array[1..13] of Real;
  A2           : Array[1..13] of Real;
  A3           : Array[1..13] of Real;
  TM           : Array[1..13] of String[14];

begin
  Confirma;
  If TC = 'S' then
     begin
       QPorta;
       If TC <> #27 then
          begin
            Inicializa(DskRpt);
            LoadRaisDirf;
            ParaContinua;
            Pag    := 0;
            Linhas := 2;
            XXNo   := '';
            TM[01] := 'Janeiro       ';
            TM[02] := 'Fevereiro     ';
            TM[03] := 'Mar‡o         ';
            TM[04] := 'Abril         ';
            TM[05] := 'Maio          ';
            TM[06] := 'Junho         ';
            TM[07] := 'Julho         ';
            TM[08] := 'Agosto        ';
            TM[09] := 'Setembro      ';
            TM[10] := 'Outubro       ';
            TM[11] := 'Novembro      ';
            TM[12] := 'Dezembro      ';
            TM[13] := '13.Sal rio    ';
            Repeat
              RC := 'N';
              SearchPos6 ( Root6 );
              If RC = 'S' then
                 With EEMember do
                 begin
                   ReadWrite(#08,'R','N',XXNumber);
                   ReadWrite(#09,'R','N',XXNumber);
                   For I := 1 to 13 do
                   begin
                     T3 := T3 + TruncX(HPMember.IRenda[I]);
                   end;
                   T3 := T3 +TruncX(HPMember.Pg13_IR);
                   If T3 > 0 then
                      begin
                        T3 := 0;
                        Writeln(Nome);
                        NCont := NCont + 1;
                        If Linhas = 2 then
                           begin
                             If Laser <> 'N' then WriteLine('W',LaserInit)
                                             else If Pag <> 0 then WriteLine('W',Qp);
                             WriteLine('L',ConstStr(' ',3)+
                                      Acentua(CMstMember.Descricao));
                             Pag    := Pag + 1;
                             Linhas := 0;
                             WriteLine('L',' ');
                             WriteLine('L',ConstStr(' ',3)+Acentua(CMstMember.Endereco));
                             WriteLine('L',ConstStr(' ',3)+CMstMember.Cep+', '+
                                      Acentua(CMstMember.Cidade)+', '+
                                      CMstMember.Estado);
                             WriteLine('L',' ');
                             WriteLine('L',ConstStr(' ',3)+'C.G.C...: '+CMstMember.CGC);
                             WriteLine('L',ConstStr(' ',3)+'Ano Base: '+
                                      PushRight(2,EditInteger(CMstMember.AnoAtivo))+
                                      ConstStr(' ',56)+'Pag: '+
                                      PushRight(4,EditInteger(Pag)));
                             WriteLine('L',ConstStr(' ',3)+'No.Func.: '+
                                      PushRight(4,EditInteger(NFu)));
                           end;
                        WriteLine('L',' ');
                        WriteLine('L',' ');
                        WriteLine('L',' ');
                        T1 := 0;
                        T2 := 0;
                        T3 := 0;
                        For I := 1 to 13 do
                        begin
                          A1[I] := 0;
                          A2[I] := 0;
                          A3[I] := 0;
                        end;
                        For I := 1 to 12 do
                        begin
                          A1[I] := TruncX(HPMember.RendDirf[I]);
                          T1    := T1 + A1[I];
                          A2[I] := TruncX(HPMember.Dependentes[I] +
                                          HPMember.ValorInss[I]   +
                                          HPMember.Pensao[I]);
                          T2    := T2 + A2[I];
                          A3[I] := TruncX(HPMember.IRenda[I]);
                          T3    := T3 + A3[I];
                        end;
                        A1[13] := TruncX(HPMember.Pg13_ValorD);
                        T1     := T1 + A1[13];
                        A2[13] := TruncX(HPMember.Pg13_Dep + HPMember.Pg13_Inss);
                        T2     := T2 + A2[13];
                        A3[13] := TruncX(HPMember.Pg13_IR);
                        T3     := T3 + A3[13];
                        If HPMember.Ferias_Mes > 0 then
                           begin
{                            A1[HPMember.Ferias_Mes] := A1[HPMember.Ferias_Mes] + TruncX(HPMember.Ferias_Valor); }
                             A3[HPMember.Ferias_Mes] := A3[HPMember.Ferias_Mes] + TruncX(HPMember.Ferias_IR);
{                            T1 := T1 + TruncX(HPMember.Ferias_Valor); }
                             T3 := T3 + TruncX(HPMember.Ferias_IR);
                           end;
                        WriteLine('L',ConstStr('-',80));
                        WriteLine('L',Nx+PushLeft(16,EEMember.Cpf)+
                                 Acentua(EEMember.Nome)+Nf);
                        WriteLine('L',ConstStr('-',80));
                        WriteLine('L',Acentua('Mˆs         ')+
                                 Acentua('    Rendimentos Brutos')+' '+
                                 Acentua('              Dedu‡”es')+' '+
                                 Acentua('  Imposto Ret.na Fonte'));
                        WriteLine('L',ConstStr('-',80));
                        WriteLine('L',' ');
                        For I := 1 to 04
                        do WriteLine('L',Acentua(TM[I])+
                                              PushRight(20,EditReal(A1[I]))+'   '+
                                              PushRight(20,EditReal(A2[I]))+'   '+
                                              PushRight(20,EditReal(A3[I])));
                        WriteLine('L',' ');
                        For I := 5 to 08
                        do WriteLine('L',Acentua(TM[I])+
                                              PushRight(20,EditReal(A1[I]))+'   '+
                                              PushRight(20,EditReal(A2[I]))+'   '+
                                              PushRight(20,EditReal(A3[I])));
                        WriteLine('L',' ');
                        For I := 9 to 13
                        do WriteLine('L',Acentua(TM[I])+
                                              PushRight(20,EditReal(A1[I]))+'   '+
                                              PushRight(20,EditReal(A2[I]))+'   '+
                                              PushRight(20,EditReal(A3[I])));
                        WriteLine('L',' ');
                        WriteLine('L',Nx+Acentua('Total         ')+
                                              PushRight(20,EditReal(T1))+'   '+
                                              PushRight(20,EditReal(T2))+'   '+
                                              PushRight(20,EditReal(T3))+Nf);
                        Linhas := Linhas + 1;
                      end;
                 end;
              GoNoGo;
              If TC = #27 then RC := 'N';
            Until RC = 'N';
            If NCont <> 0
               then If DskRpt = 'N' then WriteLine('W',Qp);
            Window(1,1,80,25);
            Color(Blue,Black);
            GotoXY(1,23);  Write(ConstStr(' ',80));
            GotoXY(1,23);  Write(' Total de Empregados Impressos: ');
            Color(Blue,White);
            GotoXY(33,23); Write(NCont:5);
            TeclaReturn;
            Dispose6 ( Root6 );
            Root6 := NIL;
            If (DskRpt = 'T') and (TC <> #27) then ScrollRpt
                                              else Close ( LST );
          end;
     end
     else ProcessDirfD;
end;


Procedure InformeRend;
Var
  T401,T402,
  T403,T404,
  T501,T502,
  T503,T504,
  T505,T506,
  T601,T602,
  T603           : Real;
  UouC,IR        : Char;
  DataX          : Str10;
  VStr           : Str15;
  Respons        : Str30;
begin
  Repeat
    EENo := '';
    RecebeCodigo(9,'C','N');
    If TC <> #27 then
       begin
         If EENumber <> Limite then
            begin
              ReadWrite(#08,'R','N',EENumber);
              Color(Tfn,Ttx);
              GotoXY(04,10); Write('Nome..:');
              Color(Tfn,Utx);
              GotoXY(12,09); Write(PushLeft(9,EEMember.Matricula));
              GotoXY(12,10); Write(PushLeft(41,EEMember.Nome));
            end
            else begin
                   GotoXY(12,09); Write('** Todos');
                 end;
         Color(Tfn,Ttx);
         GotoXY(04,12); Write('Data..:');
         GotoXY(04,13); Write('Respon:');
         GotoXY(04,14); Write('IR > 0:    (S=[p/IR > 0],N=[p/todos])');
         Color(Tfn,Utx);
         DataX   := QQStr(TabDia[MM],2,'0') + '/' +
                    QQStr(MM,2,'0')         + '/' +
                    QQStr(AA,4,'0');
         Respons := '';
         IR      := 'N';
         Repeat
           K := 1;
           Repeat
             Case K of
                  1 : begin
                        J := DataX;
                        InputStr(J,10,12,12,0,'S','N','D','S',Tfn,Utx);
                        If TC <> #27 then DataX := J;
                      end;
                  2 : begin
                        J := Respons;
                        InputStr(J,30,12,13,0,'S','N','T','N',Tfn,Utx);
                        If TC <> #27 then
                           begin
                             Respons := J;
                             If Respons = '' then
                                begin
                                  ErroMsg := 'Informe o Respons vel';
                                  ErrorMessage;
                                  K := K - 1;
                                end;
                           end;
                      end;
                  3 : begin
                        J := IR;
                        InputStr(J,1,12,14,0,'S','N','T','N',Tfn,Utx);
                        If TC <> #27 then
                           begin
                             IR := UpCase(J[1]);
                             If IR = '' then IR := 'N';
                           end;
                      end;
             end;
             Case TC of
                  #13 : K := K + 1;
                  #24 : If K > 1 then K := K - 1;
             end;
           Until (K = 4) or (TC = #27);
           If TC <> #27 then Confirma;
         Until TC in ['S',#27];
         If TC = 'S' then
            begin
              QPorta;
              If TC <> #27 then
                 begin
                   Inicializa(DskRpt);
                   ParaContinua;
                   J := EENo;
                   If EENo <> '' then
                      begin
                        RC := 'N';
                        SearchAnt5 ( Root5 );
                        If RC = 'N' then EENo := '';
                      end;
                   Repeat
                     RC := 'N';
                     SearchPos5 ( Root5 );
                     If RC = 'S' then
                        With EEMember do
                        begin
                          ReadWrite(#08,'R','N',EENumber);
                          ReadWrite(#09,'R','N',EENumber);
                          Writeln(Nome);
                          T401 := 0;
                          T402 := 0;
                          T403 := 0;
                          T404 := 0;
                          T501 := 0;
                          T502 := 0;
                          T503 := 0;
                          T504 := 0;
                          T505 := 0;
                          T506 := 0;
                          T601 := 0;
                          T602 := 0;
                          T603 := 0;
                          For I := 1 to 12 do
                          With HPMember do
                          begin
                            T401 := T401 + TruncX(RendDirf[I]);
                            T402 := T402 + TruncX(ValorInss[I]);
                            T403 := T403 + TruncX(Pensao[I]);
                            T404 := T404 + TruncX(IRenda[I]);
                            T501 := T501 + SalarioFaml[I];
                          end;
{                          T401 := T401 + TruncX(HPMember.Ferias_Valor); }
                          T402 := T402 + TruncX(HPMember.Pg13_Inss);
                          T404 := T404 + TruncX(HPMember.Ferias_IR);
                          T601 := T601 + TruncX(HPMember.Pg13_ValorD);
                          CCNo := '068';
                          RC   := 'N';
                          SearchTree1 ( Root1 );
                          If RC = 'S' then
                             begin
                               ReadWrite(#04,'R','N',CCNumber);
                               If (RW                = 'S') and
                                  (CCMember.Bases[5] = 'S') then T404 := T404 + TruncX(HPMember.Pg13_IR);
                             end;
                          RC := 'S';
                          If ((IR = 'S') and (T404 > 0)) or
                             (IR = 'N') then
                             begin
                               If Laser <> 'N' then WriteLine('W',LaserInit)
                                               else If NCont > 0 then WriteLine('W',Qp);
                               NCont := NCont + 1;
                               WriteLine('L',Nx+Acentua('MINISTERIO DA FAZENDA')+Nf+
                                        ConstStr(' ',27)+
                                        'COMPROVANTE DE RENDIMENTOS PAGOS');
                               WriteLine('L',ConstStr(' ',55)+
                                        Acentua('E DE RETENCAO DE'));
                               WriteLine('L',Nx+'SECRETARIA DA RECEITA FEDERAL'+Nf+
                                        ConstStr(' ',21)+
                                        'IMPOSTO DE RENDA NA FONTE');
                               WriteLine('L',' ');
                               WriteLine('L',ConstStr('-',80));
                               WriteLine('L',' ');
                               WriteLine('L',Cx+'1. FONTE PAGADORA PESSOA '+
                                        Acentua('FISICA OU JURIDICA')+
                                        ConstStr(' ',60)+'2. CARIMBO DO C.G.C.'+Cf);
                               WriteLine('L',' ');
                               WriteLine('L',ConstStr(' ',03)+Cx+'CGC/CPF......: '+CMstMember.CGC+Cf);
                               WriteLine('L',ConstStr(' ',03)+Cx+'Telefone.....: '+CMstMember.Telefone+Cf);
                               WriteLine('L',ConstStr(' ',03)+Cx+'R.Social/Nome: '+Acentua(CMstMember.Descricao)+Cf);
                               WriteLine('L',ConstStr(' ',03)+Cx+'Endereco.....: '+Acentua(CMstMember.Endereco)+', '+
                                                                             +Acentua(CMstMember.Numero)+' '+
                                                                             +Acentua(CMstMember.Complemento)+Cf);
                               WriteLine('L',ConstStr(' ',03)+Cx+'Cidade.......: '+Acentua(CMstMember.Cidade)+Cf);
                               WriteLine('L',ConstStr(' ',03)+Cx+'Estado.......: '+CMstMember.Estado+Cf);
                               WriteLine('L',' ');
                               WriteLine('L',Cx+Acentua('3. PESSOA FISICA BENEFICIARIA')+
                                    ' DOS RENDIMENTOS'+Cf);
                               WriteLine('L',' ');
                               WriteLine('L',ConstStr(' ',03)+Cx+'Ano base.....: 19'+
                                        PushRight(2,EditInteger(CMstMember.AnoAtivo))+Cf);
                               WriteLine('L',ConstStr(' ',03)+Cx+'CPF..........: '+EEMember.Cpf+Cf);
                               WriteLine('L',ConstStr(' ',03)+Cx+'Nome completo: '+Acentua(EEMember.Nome)+Cf);
                               WriteLine('L',' ');
                               WriteLine('L',ConstStr(' ',03)+Cx+'Nat.do rendim: '+
                                        Acentua('Rendimentos do trabalho com vinculo empregat¡cio')+Cf);
                               WriteLine('L',' ');
                               WriteLine('L',Cx+
                                        Acentua('4. RENDIMENTOS TRIBUTAVEIS, DEDUCOES ')+
                                        ' E IMPOSTO RETIDO NA FONTE'+Cf);
                               WriteLine('L',' ');
                               WriteLine('L',ConstStr(' ',03)+Cx+
                                        Acentua('01. Total dos rendimentos (inclusive f‚rias).............')+
                                        ConstStr('.',41)+
                                        PushRight(18,EditReal(T401))+Cf);
                               WriteLine('L',ConstStr(' ',03)+Cx+
                                        Acentua('02. Contribui‡„o Previdenci ria Oficial..................')+
                                        ConstStr('.',41)+
                                        PushRight(18,EditReal(T402))+Cf);
                               WriteLine('L',ConstStr(' ',03)+Cx+
                                        Acentua('03. Pens„o alimenticia (informar benefici rio no campo 08)')+
                                        ConstStr('.',40)+
                                        PushRight(18,EditReal(T403))+Cf);
                               WriteLine('L',ConstStr(' ',03)+Cx+
                                        Acentua('04. Imposto retido na Fonte..............................')+
                                        ConstStr('.',41)+
                                        PushRight(18,EditReal(T404))+Cf);
                               WriteLine('L',' ');
                               WriteLine('L',Cx+
                                        Acentua('5. RENDIMENTOS ISENTOS E NAO TRIBUTAVEIS')+Cf);
                               WriteLine('L',' ');
                               WriteLine('L',ConstStr(' ',03)+Cx+
                                        Acentua('01. Sal rio fam¡lia......................................')+
                                        ConstStr('.',41)+
                                        PushRight(18,EditReal(T501))+Cf);
                               WriteLine('L',ConstStr(' ',03)+Cx+
                                        Acentua('02. Parte dos proventos de aposentadoria, Reserva, Reform')+
                                        Acentua('a e Pens„o (65 anos ou mais).............')+
                                        PushRight(18,EditReal(T502))+Cf);
                               WriteLine('L',ConstStr(' ',03)+Cx+
                                        Acentua('03. Di rias e ajuda de custo.............................')+
                                        ConstStr('.',41)+
                                        PushRight(18,EditReal(T503))+Cf);
                               WriteLine('L',ConstStr(' ',03)+Cx+
                                        Acentua('04. Proventos de pens„o, Aposentadoria ou Reforma por mol')+
                                        Acentua('‚stia Grave ou por Invalidez Permanente..')+
                                        PushRight(18,EditReal(T504))+Cf);
                               WriteLine('L',ConstStr(' ',03)+Cx+
                                        Acentua('05. Lucro e dividendo de ') +
                                        PushRight(5,EditInteger(CMstMember.AnoAtivo)) +
                                        ' pago por PJ (lucro real, pr'+
                                        'esumido ou arbitrado)'+ConstStr('.',19)+
                                        PushRight(18,EditReal(T505))+Cf);
                               WriteLine('L',ConstStr(' ',03)+Cx+
                                        Acentua('06. Outros (especificar).................................')+
                                        ConstStr('.',41)+
                                        PushRight(18,EditReal(T506))+Cf);
                               WriteLine('L',' ');
                               WriteLine('L',Cx+
                                        Acentua('6. RENDIMENTOS SUJEITOS A TRIBUTACAO EXCLUSIVA (Rendimento l¡quido)')+Cf);
                               WriteLine('L',' ');
                               WriteLine('L',ConstStr(' ',03)+Cx+
                                        Acentua('01. D‚cimo terceiro Sal rio..............................')+
                                        ConstStr('.',41)+
                                        PushRight(18,EditReal(T601))+Cf);
                               WriteLine('L',ConstStr(' ',03)+Cx+
                                        Acentua('02. Outros...............................................')+
                                        ConstStr('.',41)+
                                        PushRight(18,EditReal(T603))+Cf);
                               WriteLine('L',' ');
                               WriteLine('L',Cx+
                                        Acentua('7. INFORMACOES COMPLEMENTARES')+Cf);
                               WriteLine('L',' ');
                               WriteLine('L',' ');
                               WriteLine('L',' ');
                               WriteLine('L',' ');
                               WriteLine('L',' ');
                               WriteLine('L',' ');
                               WriteLine('L',' ');
                               WriteLine('L',' ');
                               WriteLine('L',' ');
                               WriteLine('L',Cx+
                                        Acentua('8. RESPONSAVEL PELAS INFORMACOES')+Cf);
                               WriteLine('L',' ');
                               WriteLine('L',ConstStr(' ',03)+Cx+
                                        'Nome.........: '+Acentua(Respons)+Cf);
                               WriteLine('L',ConstStr(' ',03)+Cx+
                                        'Data.........: '+DataX+Cf);
                               WriteLine('L',ConstStr(' ',03)+Cx+
                                        'Assinatura...: '+Cf+
                                        ConstStr('_',40));
                             end;
                        end;
                     GoNoGo;
                     If TC = #27 then RC := 'N';
                     If J = EENo then RC := 'N';
                   Until RC = 'N';
                   If NCont <> 0 then If DskRpt = 'N' then WriteLine('W',Qp);
                   Window(1,1,80,25);
                   Color(Blue,Black);
                 end;
            end;
       end;
  Until TC = #27;
end;