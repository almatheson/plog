{$O+,F+}
Unit PlogRpt6;

Interface

Uses Crt,Dos,PlogGlbs,PlogBasP,PlogTree,PlogResc,PlogRpt0;


   Procedure ProcNo22Report;


Implementation

Type
  ESalarial  = RECORD
                 Matricula   : String[8];
                 Salario     : Array[1..12] of Real;
                 Tipo        : Array[1..12] of Char;
                 HNormais    : Array[1..12] of Real;
               END;

Var
  ESMember   : ESalarial;
  ESFile     : FILE OF ESalarial;

  TF,TP,DiaI,DiaF  : Integer;
  TEx,Etq          : Char;
  DiaIX,DiaFX,
  MMEx,AAEx        : String[4];
  OrigemW          : String[5];
  Nome             : Array[1..2]  of String[40];
  Mat              : Array[1..2]  of String[8];
  Sala,Ramal       : Array[1..2]  of String[5];
  Tel              : Array[1..2]  of String[15];


Function DeltaDias(Dtx : Str8): Integer;
Var
  D1,M1,A1,ND1,ND2 : Integer;
begin
  Val(Copy(Dtx,1,4),A1,E);
  Val(Copy(Dtx,5,2),M1,E);
  Val(Copy(Dtx,7,2),D1,E);
  ND1 := (A1 * 365) + (M1 * 30) + D1;
  ND2 := (AA * 365) + (MM * 30) + TabDia[MM];
  DeltaDias := ND2 - ND1;
end;

Function NovaData(Atual : String;Dias : Integer) : String;
var
  Dia,Mes,Ano,SomaDias  : integer;
  DiaSx,MesSx           : String[2];
  AnoSx                 : String[4];
begin
  Val(Copy(Atual,1,2),Dia,E);
  Val(Copy(Atual,4,2),Mes,E);
  Val(Copy(Atual,7,4),Ano,E);
  SomaDias := Dia + Dias;
  While SomaDias > TabDia[Mes] do
  begin
    Dia := SomaDias - TabDia[Mes];
    Mes := Mes + 1;
    If Mes > 12 then
       begin
         Mes := 1;
         Ano := Ano + 1;
       end;
    SomaDias := Dia;
  end;
  Str(Dia,DiaSx);
  If Dia < 10 then DiaSx := '0' + DiaSx;
  Str(Mes,MesSx);
  If Mes < 10 then MesSx := '0' + MesSx;
  Str(Ano,AnoSx);
  If Ano < 10 then AnoSx := '0' + AnoSx;
  NovaData :=  DiaSx + '/' + MesSx + '/' + AnoSx;
end;

Procedure ListaFones(X : Integer);
begin
  Case X of
       4 : WriteLine('L',Cx+Acentua(Nome[1])+
                         ConstStr(' ',41-Length(Nome[1]))+
                         PushLeft(9,Mat[1])+
                         PushRight(5,Sala[1])+' '+
                         PushRight(5,Ramal[1])+
                         ConstStr(' ',10)+
                         Acentua(Nome[2])+
                         ConstStr(' ',41-Length(Nome[2]))+
                         PushLeft(9,Mat[2])+
                         PushRight(5,Sala[2])+' '+
                         PushRight(5,Ramal[2])+Cf);
       5 : WriteLine('L',Cx+Acentua(Nome[1])+
                         ConstStr(' ',41-Length(Nome[1]))+
                         PushLeft(9,Mat[1])+
                         PushLeft(21,Tel[1])+
                         Acentua(Nome[2])+
                         ConstStr(' ',41-Length(Nome[2]))+
                         PushLeft(9,Mat[2])+
                         PushLeft(15,Tel[2])+Cf);
  end;
end;


Procedure ZeraFones;
begin
  For I := 1 to 2 do begin
                       Mat[I]   := '';
                       Nome[I]  := '';
                       Sala[I]  := '';
                       Ramal[I] := '';
                       Tel[I]   := '';
                     end;
  I := 0;
end;


Procedure PedeProc22;
begin
  Color(Tfn,Ttx);
  Case YY of
       1   : begin
               GotoXY(04,09); Write('Dias...:');
               GotoXY(23,09); Write('Mˆs....:');
               GotoXY(40,09); Write('Rel/Etq:');
             end;
       2   : begin
               GotoXY(04,09); Write('Dias...:');
             end;
       3   : begin
               GotoXY(4,09); Write('N§Meses:');
             end;
       7   : begin
               GotoXY(4,09); Write('Etapa..:');
             end;
       11  : begin
               GotoXY(4,09); Write('Dia....:');
             end;
       15  : begin
               GotoXY(04,09); Write('Tipo...:');
               GotoXY(40,09); Write('MM e AA:');
             end;
       16  : begin
               GotoXY(4,09); Write('Origem.:');
             end;
       17  : begin
               GotoXY(04,09); Write('Dia In.:');
               GotoXY(20,09); Write('Dia Fin:');
               GotoXY(40,09); Write('MM e AA:');
             end;
  end;
  Etq     := 'R';
  MMx     := '';
  AAx     := '';
  TP      := 0;
  OrigemW := '';
  Repeat
    TC := #13;
    K  := 0;
    Repeat
      Case K of
           0  : If YY = 17 then PedeDepto(08,'#')
                           else PedeDepto(08,'L');
           1  : If YY = 15 then
                begin
                  J := '';
                  Color(Tfn,Utx);
                  GotoXY(13,09); Write('     ');
                  InputStr(J,1,13,09,0,'S','N','T','N',Tfn,Utx);
                  If TC <> #27 then
                     begin
                       If J = '' then
                          begin
                            TEx := #00;
                            GotoXY(13,09); Write('Todos');
                          end
                          else begin
                                 TEx := UpCase(J[1]);
                                 GotoXY(13,09); Write(TEx);
                               end;
                     end;
                end;
           2  :  If (YY = 1) or (YY = 2) or (YY = 11) or (YY = 17) then
                    begin
                      J := '';
                      InputStr(J,2,13,09,0,'S','N','T','N',Tfn,Utx);
                      If TC <> #27 then
                         begin
                           Val(J,DiaI,E);
                           GotoXY(13,09); Write(DiaI:2);
                           J := '';
                           Case YY of
                                1  : InputStr(J,2,16,09,0,'S','N','T','N',Tfn,Utx);
                                17 : InputStr(J,2,28,09,0,'S','N','T','N',Tfn,Utx);
                           end;
                           If (TC <> #27) and ((YY = 1) or (YY = 17)) then
                              begin
                                Val(J,DiaF,A);
                                If YY = 1 then GotoXY(16,09)
                                          else GotoXY(28,09);
                                Write(DiaF:2);
                              end
                              else If YY = 2 then DiaF := DiaI;
                         end;
                    end;
           3  :  If (YY = 1) or (YY = 15) or (YY = 17) then
                    begin
                      J := '';
                      If YY = 1 then InputStr(J,2,32,09,0,'S','N','T','N',Tfn,Utx)
                                else InputStr(J,2,49,09,0,'S','N','T','N',Tfn,Utx);
                      If TC <> #27 then
                         begin
                           If J = '' then M := MM
                                     else Val(J,M,E);
                           If (M < 0 ) or (M > 12) then
                               begin
                                 ErroMsg := 'Mˆs Inv lido';
                                 ErrorMessage;
                                 K := K - 1;
                               end
                               else begin
                                      MMEx := QQStr(M,2,'0');
                                      If YY = 1 then GotoXY(32,09)
                                                else GotoXY(49,09);
                                      Write(M:2);
                                      If YY = 1 then
                                         begin
                                           J := 'R';
                                           InputStr(J,1,49,09,0,'S','N','T','N',Tfn,Utx);
                                           If TC <> #27 then
                                              begin
                                                Etq := UpCase(J[1]);
                                                GotoXY(49,09);
                                                Case Etq of
                                                     'R' : Write('Rel.       ');
                                                     'E' : begin
                                                             Write('Etq. 1 Col.');
                                                             J := '1';
                                                             InputStr(J,1,54,09,0,'S','N','T','N',Tfn,Utx);
                                                             Val(J,Colunas,E)
                                                           end;
                                                end;
                                              end;
                                         end;
                                    end;
                         end;
                    end;
           4  :  If YY = 3 then
                    begin
                      J := '';
                      InputStr(J,2,13,09,0,'S','N','T','N',Tfn,Utx);
                      If TC <> #27 then
                         begin
                           Val(J,DiaI,E);
                           If (DiaI < 1) or (DiaI > 12) then
                              begin
                                ErroMsg := 'N§ de Meses Inv lido';
                                ErrorMessage;
                                K := K - 1;
                              end;
                         end;
                    end;
           5  :  If (YY = 15) or (YY = 17) then
                    begin
                      J := '';
                      InputStr(J,4,52,09,0,'S','N','T','N',Tfn,Utx);
                      If (TC <> #27) and (J = '') then
                         begin
                           ErroMsg := 'Ano Inv lido';
                           ErrorMessage;
                           K := K - 1;
                         end
                         else AAEx := J;
                    end;
           6  :  If YY = 7 then
                    begin
                      Color(Blue,Cyan);
                      GotoXY(01,23); Write(ConstStr(' ',80));
                      GotoXY(02,23); Write('Informe a Etapa: 1,2,3,4§ Semana, Adiantamento Pagamento ou 13§ Sal rio');
                      Color(Blue,White);
                      GotoXY(19,23); Write('1');
                      GotoXY(21,23); Write('2');
                      GotoXY(23,23); Write('3');
                      GotoXY(25,23); Write('4');
                      GotoXY(36,23); Write('A');
                      GotoXY(49,23); Write('P');
                      GotoXY(66,23); Write('S');
                      J := '';
                      InputStr(J,1,13,09,0,'S','N','T','N',Tfn,Utx);
                      LimpaLn(23,Tfd);
                      If TC <> #27 then
                         begin
                           If UpCase(J[1]) in ['1','2','3','4','A','P','S'] then
                              begin
                                GotoXY(13,09);
                                Case UpCase(J[1]) of
                                     '1' : begin
                                             Write('1§ Semana   ');
                                             TP := 1;
                                           end;
                                     '2' : begin
                                             Write('2§ Semana   ');
                                             TP := 2;
                                           end;
                                     '3' : begin
                                             Write('3§ Semana   ');
                                             TP := 3;
                                           end;
                                     '4' : begin
                                             Write('4§ Semana   ');
                                             TP := 4;
                                           end;
                                     'A' : begin
                                             Write('Adiantamento');
                                             TP := 5;
                                           end;
                                     'S' : begin
                                             Write('13§ Sal rio ');
                                             TP := 6;
                                           end;
                                     'P' : begin
                                             Write('Pagamento   ');
                                             TP := 7;
                                           end;
                                end;
                              end
                              else begin
                                     ErroMsg := 'Etapa Inv lida (1,2,3,4,A,P,S)';
                                     ErrorMessage;
                                     K := K - 1;
                                   end;
                         end;
                    end;
           7  : If YY = 16 then
                begin
                  J := OrigemW;
                  Color(Tfn,Utx);
                  GotoXY(13,09); Write('     ');
                  InputStr(J,5,13,09,0,'S','N','T','N',Tfn,Utx);
                  If TC <> #27 then
                     begin
                       If J = '' then
                          begin
                            GotoXY(13,09); Write('Todos');
                            OrigemW := '*****';
                          end
                          else begin
                                 OrigemW := UpCaseStr(J);
                                 GotoXY(13,09); Write(OrigemW);
                               end;
                     end;
                end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : begin
                   If K > 1 then K := K - 1;
                   TC := #13;
                 end;
      end;
    Until (K = 8) or (TC = #27);
    If TC <> #27 then Confirma;
  Until TC in ['S',#27];
end;


Procedure Proc22Header;
begin
  If (RecordAnt <> DDNo) or
     (ContLin    > 56  ) then
     begin
       If ContLin > 56 then HeaderReport;
       If (not (Ex in ['L','#'])) and (YY <> 17) then
          begin
            WriteLine('L',' ');
            WriteLine('L',Nx+DDNo+' '+Acentua(DDMember.Descricao)+Nf);
            WriteLine('L',' ');
          end;
       RecordAnt := DDNo;
     end;
end;


Procedure ProcNo22Rel10;
begin
  Color(Blue,White);
  GotoXY(01,23); Write(ConstStr(' ',80));
  GotoXY(02,23);
  Write('Estou recuperando as informa‡”es salariais dos Empregados.            Aguarde');
  Color(Red,Yellow);
  GotoXY(01,24);  Write(ConstStr(' ',80));
  Assign ( ESFile, (XPath + '\HISTOSAL.DAT'));
  {$I-}
  Reset ( ESFile );
  {$I+}
  If IOResult = 0 then
     begin
       Close ( ESFile );
       Erase ( ESFile );
     end;
  ReWrite ( ESFile );
  For I := 1 to 12 do begin
                        ESMember.Matricula   := '';
                        ESMember.Salario[I]  := 0;
                        ESMember.Tipo[I]     := ' ';
                        ESMember.HNormais[I] := 0;
                      end;
  EENo := '';
  Repeat
    RC := 'N';
    SearchPos5 ( Root5 );
    If RC = 'S' then
       begin
         ReadWrite(#08,'R','N',EENumber);
         ESMember.Matricula := EEMember.Matricula;
         If EEMember.Tipo = 'H'
            then ESMember.Salario[MM] := EEMember.Salario * EEMember.HNormais
            else ESMember.Salario[MM] := EEMember.Salario;
         ESMember.Tipo[MM]     := EEMember.Tipo;
         ESMember.HNormais[MM] := EEMember.HNormais;
         Seek  ( ESFile, EENumber );
         Write ( ESFile, ESMember );
       end;
  Until RC = 'N';
  Close ( EEFile );
  For I := 1 to MM-1 do
  begin
    GotoXY(2,24); Write(Pushleft(20,ArrayMesEx[I]+' de '+AAFx));
    Assign ( EEFile, (XPath + '\' + FileEE + AAFx + '.M' + QQStr(I,2,'0')));
    {$I-}
    Reset ( EEFile );
    {$I+}
    If IOResult = 0 then
       begin
         R := -1;
         Repeat
           R := R + 1;
           ReadWrite(#08,'R','N',R);
           EENo := EEMember.Matricula;
           SearchTree5 ( Root5 );
           If RC = 'S' then
              begin
                Seek ( ESFile, EENumber );
                Read ( ESFile, ESMember );
                ESMember.Matricula := EEMember.Matricula;
                If EEMember.Tipo = 'H'
                   then ESMember.Salario[I] := EEMember.Salario * EEMember.HNormais
                   else ESMember.Salario[I] := EEMember.Salario;
                ESMember.Tipo[I]     := EEMember.Tipo;
                ESMember.HNormais[I] := EEMember.HNormais;
                Seek  ( ESFile, EENumber );
                Write ( ESFile, ESMember );
              end;
         Until (R + 1) = FileSize(EEFile);
         Close ( EEFile );
       end;
  end;
  Assign ( EEFile, (XPath + '\' + FileEE + AAFx + '.' + MMFx));
  Reset  ( EEFile );
  Limpaln(23,Tfn);
  Limpaln(24,Tfn);
end;


Procedure ProcessaProc22;
Var
  Coln       : Integer;
  Filhos     : Array[1..5] of Char;
begin
  If Ex = 'L' then LoadIndex6 ('E',Tr)
              else LoadIndex6 ('D',Tr);
  If TC <> #27 then
     begin
       ContLin := 10000;
       ContPag := 0;
       NCont   := 0;
       AAx     := QQStr(AA,2,'0');
       Case YY of
            1  : begin
                   L1 := Nx+'Aniversariantes em '+Nf+ArrayMesEx[M]+'/'+AAx;
                   L6 := 'Nome'+ConstStr(' ',37)+'Cargo               Dia';
                   DiaIX := QQStr(DiaI,2,'0');
                   DiaFX := QQStr(DiaF,2,'0');
                   If Etq = 'E'then
                      If Laser in ['D','L'] then FormTest('N','T','ETQ')
                                            else FormTest('S','T','ETQ');
                 end;
            2  : begin
                   L1 := Nx+'Empregados em Experiˆncia '+Nf+ArrayMesEx[MM]+'/'+AAx;
                   L6 := 'Matr¡cula Nome'+ConstStr(' ',37)+
                         'Admiss„o DD T‚rmino  Cargo';
                 end;
            3  : begin
                   L1 := Nx+'Exame m‚dico a vencer em '+Nf+ArrayMesEx[MM]+'/'+AAx;
                   L6 := 'Matr¡cula Nome'+ConstStr(' ',37)+
                         'Admiss„o Nascimen';
                 end;
            4  : begin
                   L1 := Nx+'Lista telef“nica de '+Nf+ArrayMesEx[MM]+'/'+AAx;
                   L6 := Cx+'Nome'+ConstStr(' ',37)+
                         'Matr¡c.  Sala  Ramal           Nome'+
                         ConstStr(' ',37)+'Matr¡c.  Sala  Ramal'+Cf;
                 end;
            5  : begin
                   L1 := Nx+'Telefones residenciais em '+Nf+ArrayMesEx[MM]+'/'+AAx;
                   L6 := Cx+'Nome'+ConstStr(' ',37)+
                         'Matr¡c.  Telefone             Nome'+
                         ConstStr(' ',37)+'Matr¡c.  Telefone'+Cf;
                 end;
            6  : begin
                   L1 := Nx+'Altera‡”es salariais em '+Nf+ArrayMesEx[MM]+'/'+AAx;
                   L6 := Cx+'Matr¡cula Nome'+ConstStr(' ',37)+
                         'T Sal rio         Alter.em Novo sal rio'+Cf;
                 end;
            7  : begin
                   Case TP of
                        1 : L1 := Nx+'Cheques pag. de Ad.Semana 1 em '+Nf+ArrayMesEx[MM]+'/'+AAx;
                        2 : L1 := Nx+'Cheques pag. de Ad.Semana 2 em '+Nf+ArrayMesEx[MM]+'/'+AAx;
                        3 : L1 := Nx+'Cheques pag. de Ad.Semana 3 em '+Nf+ArrayMesEx[MM]+'/'+AAx;
                        4 : L1 := Nx+'Cheques pag. de Ad.Semana 4 em'+Nf+ArrayMesEx[MM]+'/'+AAx;
                        5 : L1 := Nx+'Cheques pag. de Adiantamento em '+Nf+ArrayMesEx[MM]+'/'+AAx;
                        6 : L1 := Nx+'Cheques pag. de 13 Sal rio em '+Nf+ArrayMesEx[MM]+'/'+AAx;
                        7 : L1 := Nx+'Cheques de Pagamento em '+Nf+ArrayMesEx[MM]+'/'+AAx;
                   end;
                   L6 := 'Matr¡cula Nome'+ConstStr(' ',37)+Cx+
                         'Bco Cheque              Valor'+Cf;
                 end;
            8  : begin
                   L1 := Nx+'Indice de Empregados em '+Nf+ArrayMesEx[MM]+'/'+AAx;
                   L6 := Cx+'Matr¡cula Nome'+ConstStr(' ',37)+
                         'Cargo           Admiss„o   Dt-Nasc.    Cpf.         PIS         C.Trabalho'+Cf;
                 end;
            9  : begin
                   L1 := Nx+'Acumulado de horas para F‚rias em '+Nf+
                         ArrayMesEx[MM]+'/'+AAx;
                   L6 := 'Matr¡cula Nome'+ConstStr(' ',37)+Cx+
                         'Admiss„o  1o.Per.  2o.Per.'+Cf;
                 end;
            10 : begin
                   L1 := Nx+'Evolu‡„o Salarial em '+AAx+Nf;
                   L6 := 'Matr¡cula Nome'+ConstStr(' ',37)+Cx+
                         'Admiss„o T Hrs        Sal rio mˆs'+Cf;
                 end;
            11 : begin
                   L1 := Nx+'Simula‡„o de Rescis”es em '+Nf+QQStr(DiaI,2,'0')+' '+
                         ArrayMesEx[MM]+'/'+AAx;
                   L6 := 'Nome'+ConstStr(' ',37)+
                         'Admiss„o Tr F‚  Saldo de Sal.   F‚rias Prop.   '+
                         '13o. Propor.          Total';
                 end;
            12 : L1 := Dx+'Declara‡„o de Sal rio - Fam¡lia'+Df;
            13 : begin
                   L1 := Nx+'Vestu rio em '+Nf+ArrayMesEx[MM]+'/'+AAx;
                   L6 := 'Matr¡cula Nome'+ConstStr(' ',37)+
                         'Admiss„o   Manequim   Cal‡ado';
                 end;
            14 : begin
                   L1 := Nx+'Centros de Custo em '+Nf+ArrayMesEx[MM]+'/'+AAx;
                   L6 := Cx+'Matr¡cula Nome'+ConstStr(' ',37)+
                         'CCusto  Dias  '+
                         'CCusto  Dias  '+
                         'CCusto  Dias  '+
                         'CCusto  Dias  '+
                         'CCusto  Dias  '+Cf;
                 end;
            15 : begin
                   L1 := Nx+'Exames a Vencer em '+Nf+ArrayMesEx[M]+'/'+AAEx;
                   L6 := Cx+'Matr¡cula Nome'+ConstStr(' ',37)+
                         'Cargo'+ConstStr(' ',11)+
                         'Registro        Tipo   Vencim.'+Cf;
                 end;
            16 : begin
                   If OrigemW = '*****' then L1 := Nx+'Origem dos Empregados em '+Nf+ArrayMesEx[MM]+'/'+AAx
                                        else L1 := Nx+'Empregados oriundos de '+OrigemW+' em '+Nf+ArrayMesEx[MM]+'/'+AAx;
                   L6 := Cx+'Matr¡cula Nome'+ConstStr(' ',37)+
                         'Depart.'+ConstStr(' ',4)+
                         'Cargo           Admiss„o     Sal rio T Origem'+Cf;
                 end;
            17 : begin
                   L1 := Nx+'Folha de Ponto de '+Nf+ArrayMesEx[M]+'/'+AAEx;
                   L6 := '';
                 end;
       end;
       Color(Tfn,Ttx);
       GotoXY(04,21); Write('Pesq..:');
       ParaContinua;
       Janela('F');
       ZeraFones;
       RecordAnt := '';
       DDAC      := DDNo;
       If DDNo <> '' then
          begin
            RC := 'N';
            SearchAnt3 ( Root3 );
            If RC = 'N' then DDNo := '';
          end;
       R1 := 0;
       R2 := 0;
       R3 := 0;
       R4 := 0;
       R5 := 0;
       R6 := 0;
       R7 := 0;
       TF := 0;
       Coln  := 0;
       If Etq = 'E' then ZeraEtiqueta;
       Repeat
         RC := 'N';
         SearchPos3 ( Root3 );
         If RC = 'S' then
            begin
              ReadWrite(#05,'R','N',DDNumber);
              If Ex = 'L' then XXNo := ''
                          else XXNo := DDNo + '#';
              R := 0;
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
                        (RW               = 'S' ) and
                        (EEMember.Status <> 'R' ) and
                        (EEMember.Status <> 'X' ) then
                        begin
                          R := R + 1;
                          Window(1,1,80,25);
                          Color(Tfn,Utx);
                          GotoXY(12,21); Write(R:4);
                          Color(Sfn,Stx);
                          Window(27,12,67,19);
                          GotoXY(1,8);
                          Case YY of
                             1   : If (EEMember.MMNasc  = MMEx ) and
                                      (EEMember.DDNasc >= DiaIX) and
                                      (EEMember.DDNasc <= DiaFX) then
                                      begin
                                        NCont := NCont + 1;
                                        Writeln(EEMember.Nome);
                                        Case Etq of
                                             'R' : begin
                                                     Proc22Header;
                                                     WriteLine('L',Acentua(EEMember.Nome)+
                                                                   ConstStr(' ',41-Length(EEMember.Nome))+
                                                                   PushLeft(20,EEMember.Cargo)+
                                                                   EEMember.DDNasc);
                                                   end;
                                             'E' : begin
                                                     Coln := Coln + 1;
                                                     NomeX[Coln]        := EEMember.Nome;
                                                     MatriculaX[Coln]   := EEMember.Matricula;
                                                     TurnoX[Coln]       := EEMember.Turno;
                                                     EntradaX[Coln]     := EEMember.Entrada;
                                                     SaidaX[Coln]       := EEMember.Saida;
                                                     IntRefeicaoX[Coln] := EEMember.IntRefeicao;
                                                     RepSemanalX[Coln]  := EEMember.RepSemanal;
                                                     CtrabX[Coln]       := EEMember.CtrabN + '/' +
                                                                           EEMember.CtrabS + '/' +
                                                                           EEMember.CtrabE;
                                                     CargoX[Coln]       := EEMember.Cargo;
                                                     CartaoX[Coln]      := EEMember.Cartao;
                                                     EnderecoX[Coln]    := EEMember.Endereco;
                                                     BairroX[Coln]      := EEMember.Bairro;
                                                     CidadeX[Coln]      := EEMember.Cidade;
                                                     EstadoX[Coln]      := EEMember.Estado;
                                                     CepX[Coln]         := EEMember.Cep + '-' + EEMember.CepCompl;
                                                     If Coln = Colunas then
                                                        begin
                                                          ImprimeTexto('S');
                                                          ZeraEtiqueta;
                                                          Coln := 0;
                                                        end;
                                                   end;
                                        end;
                                      end;
                             2   : begin
                                     K := DeltaDias(EEMember.AAAdm+EEMember.MMAdm+EEMember.DDAdm);
                                     If (K > 0 ) and (K <= DiaF) then
                                        begin
                                          NCont := NCont + 1;
                                          Writeln(EEMember.Nome);
                                          Proc22Header;
                                          WriteLine('L',PushLeft(10,EEMember.Matricula)+
                                                 Acentua(EEMember.Nome)+
                                                 ConstStr(' ',41-Length(EEMember.Nome))+
                                                 EEMember.DDAdm+'/'+
                                                 EEMember.MMAdm+'/'+
                                                 EEMember.AAAdm+' '+
                                                 PushRight(2,EditInteger(K))+' '+
                                                 NovaData(EEMember.DDAdm+'/'+
                                                          EEMember.MMAdm+'/'+
                                                          EEMember.AAAdm,DiaF)+' '+Cx+
                                                 PushLeft(16,EEMember.Cargo)+Cf);
                                        end;
                                   end;
                             3   : begin
                                     Val(EEMember.MMAdm,K,E);
                                     If MM > K then K := MM - K
                                               else K := (12 - K) + MM;
                                     If K = DiaI then
                                        begin
                                          NCont := NCont + 1;
                                          Writeln(EEMember.Nome);
                                          Proc22Header;
                                          WriteLine('L',PushLeft(10,EEMember.Matricula)+
                                                 Acentua(EEMember.Nome)+
                                                 ConstStr(' ',41-Length(EEMember.Nome))+
                                                 EEMember.DDAdm+'/'+
                                                 EEMember.MMAdm+'/'+
                                                 EEMember.AAAdm+' '+
                                                 EEMember.DDNasc+'/'+
                                                 EEMember.MMNAsc+'/'+
                                                 EEMember.AANasc);
                                          end;
                                   end;
                             4,5 : If (YY = 4) and (EEMember.Ramal    <> '') or
                                      (YY = 5) and (EEMember.Telefone <> '') then
                                      begin
                                        NCont := NCont + 1;
                                        Writeln(EEMember.Nome);
                                        Proc22Header;
                                        If I = 2 then
                                           begin
                                             ListaFones(YY);
                                             ZeraFones;
                                           end;
                                        I := I + 1;
                                        Nome[I]  := EEMember.Nome;
                                        Mat[I]   := EEMember.Matricula;
                                        Sala[I]  := EEMember.Sala;
                                        Ramal[I] := EEMember.Ramal;
                                        Tel[I]   := EEMember.Telefone;
                                      end;
                             6   : begin
                                     NCont := NCont + 1;
                                     Writeln(EEMember.Nome);
                                     Proc22Header;
                                     WriteLine('L',Cx+PushLeft(10,EEMember.Matricula)+
                                                   Acentua(EEMember.Nome)+
                                                   ConstStr(' ',41-Length(EEMember.Nome))+
                                                   EEMember.Tipo+' '+
                                                   PushRight(15,EditReal(EEMember.UltSalario))+' '+
                                                   PushRight(8,EEMember.UltData)+' '+
                                                   PushRight(15,EditReal(EEMember.Salario))+Cf);
                                   end;
                             7   : If EEMember.ChBco[TP] <> '' then
                                      begin
                                        NCont := NCont + 1;
                                        Writeln(EEMember.Nome);
                                        Proc22Header;
                                        WriteLine('L',PushLeft(10,EEMember.Matricula)+
                                               Acentua(EEMember.Nome)+
                                               ConstStr(' ',41-Length(EEMember.Nome))+Cx+
                                               EEMember.ChBco[TP]+' '+
                                               EEMember.Cheque[TP]+' '+
                                               PushRight(18,EditReal(EEMember.VChq[TP]))+Cf);
                                        R1 := R1 + TruncX(EEMember.VChq[TP]);
                                        R2 := R2 + TruncX(EEMember.VChq[TP]);
                                      end;
                             8   : begin
                                     NCont := NCont + 1;
                                     Writeln(EEMember.Nome);
                                     Proc22Header;
                                     WriteLine('L',Cx+PushLeft(10,EEMember.Matricula)+
                                               Acentua(EEMember.Nome)+
                                               ConstStr(' ',41-Length(EEMember.Nome))+
                                               Acentua(EEMember.Cargo)+
                                               ConstStr(' ',16-Length(EEMember.Cargo))+Cx+
                                               PushRight(2,EEMember.DDAdm)+'/'+
                                               PushRight(2,EEMember.MMAdm)+'/'+
                                               PushRight(2,EEMember.AAAdm)+' '+
                                               PushRight(2,EEMember.DDNasc)+'/'+
                                               PushRight(2,EEMember.MMNasc)+'/'+
                                               PushRight(2,EEMember.AANasc)+' '+
                                               PushLeft(13,EEMember.Cpf)+
                                               PushLeft(13,EEMember.PisPasep)+
                                               PushLeft(11,EEMember.CTrabN)+
                                               PushLeft(7,EEMember.CTrabS)+
                                               EEMember.CTrabE+Cf);
                                   end;
                             9   : If (EEMember.SomaHF1 > 0) or
                                      (EEMember.SomaHF2 > 0) then
                                      begin
                                        NCont := NCont + 1;
                                        Writeln(EEMember.Nome);
                                        Proc22Header;
                                        WriteLine('L',PushLeft(10,EEMember.Matricula)+
                                               Acentua(EEMember.Nome)+
                                               ConstStr(' ',41-Length(EEMember.Nome))+Cx+
                                               PushRight(2,EEMember.DDPAq)+'/'+
                                               PushRight(2,EEMember.MMPAq)+'/'+
                                               PushRight(2,EEMember.AAPAq)+' '+
                                               QQStr(EEMember.SomaHF1,5,' ')+':'+
                                               QQStr(EEMember.SomaMF1,2,'0')+' '+
                                               QQStr(EEMember.SomaHF2,5,' ')+':'+
                                               QQStr(EEMember.SomaMF2,2,'0')+Cf);
                                      end;
                             10  : begin
                                     {$I-}
                                     Seek ( ESFile, XXNumber );
                                     Read ( ESFile, ESMember );
                                     {$I+}
                                     If IOResult = 0 then
                                        begin
                                          NCont := NCont + 1;
                                          Writeln(EEMember.Nome);
                                          L := 0;
                                          Repeat
                                            L := L + 1;
                                          Until ESMember.Salario[L] <> 0;
                                          Proc22Header;
                                          WriteLine('L',PushLeft(10,EEMember.Matricula)+
                                                        Acentua(EEMember.Nome)+
                                                        ConstStr(' ',41-Length(EEMember.Nome))+Cx+
                                                        PushRight(2,EEMember.DDAdm)+'/'+
                                                        PushRight(2,EEMember.MMAdm)+'/'+
                                                        PushRight(2,EEMember.AAAdm)+' '+
                                                        ESMember.Tipo[L]+' '+
                                                        QQStr(ESMember.HNormais[L],3,' ')+' '+
                                                        PushRight(14,EditReal(ESMember.Salario[L]))+
                                                        ' '+Acentua(ArrayMesEx[L])+Cf);
                                          I := L;
                                          For L := I+1 to MM
                                          do If ESMember.Salario[L] <> 0 then
                                                begin
                                                  Proc22Header;
                                                  WriteLine('L',ConstStr(' ',51)+Cx+
                                                                ConstStr(' ',9)+
                                                                ESMember.Tipo[L]+' '+
                                                                QQStr(ESMember.HNormais[L],3,' ')+' '+
                                                                PushRight(14,EditReal(ESMember.Salario[L]))+
                                                                ' '+Acentua(ArrayMesEx[L])+Cf);
                                                end;
                                          WriteLine('L',ConstStr('-',80));
                                        end;
                                   end;
                             11  : If EEMember.Status in ['A','F'] then
                                      begin
                                        NCont := NCont + 1;
                                        Writeln(EEMember.Nome);
                                        EENo := EEMember.Matricula;
                                        LoadMVDsk(#11);
                                        Proc22Header;
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
                                        R1 := TruncX((SalBase / 30) * DiaI);
                                        R2 := TruncX((SalBase / 12) * EEMember.MesesF);
                                        If R2 > 0 then R2 := R2 + TruncX(R2 / 3);
                                        Case EEMember.PeriodoV of
                                             1 : R2 := R2 + TruncX(SalBase / 3);
                                             2 : R2 := R2 + SalBase;
                                        end;
                                        If EEMember.MesesT > 0 then
                                           begin
                                             YYNo := '004';
                                             SearchTreeY ( RootY );
                                             If (RC = 'S') and (YAddress^.AcAnualV > 0)
                                                then Valor := YAddress^.AcAnualV
                                                else Valor := 0;
                                             R3 := TruncX(((SalBase / 12) * EEMember.MesesT) - Valor);
                                           end;
                                        WriteLine('L',Cx+Acentua(EEMember.Nome)+
                                                      ConstStr(' ',41-Length(EEMember.Nome))+
                                                      PushRight(2,EEMember.DDAdm)+'/'+
                                                      PushRight(2,EEMember.MMAdm)+'/'+
                                                      PushRight(2,EEMember.AAAdm)+' '+
                                                      PushLeft(3,EditInteger(EEMember.MesesT))+
                                                      PushLeft(3,EditInteger(EEMember.MesesF))+
                                                      PushRight(14,EditReal(R1))+' '+
                                                      PushRight(14,EditReal(R2))+' '+
                                                      PushRight(14,EditReal(R3))+' '+
                                                      PushRight(14,EditReal(R1+R2+R3))+Cf);
                                        R4 := R4 + R1;
                                        R5 := R5 + R2;
                                        R6 := R6 + R3;
                                        R7 := R7 + TruncX(R1 + R2 + R3);
                                        LiberaMVDsk;
                                      end;
                             12  : If EEMember.DepSF > 0 then
                                      begin
                                        NCont := NCont + 1;
                                        Writeln(EEMember.Nome);
                                        For I := 1 to 5 do
                                        begin
                                          Filhos[I] := 'N';
                                          If EEMember.FilhosSF[I] <> '' then
                                             begin
                                               If Copy(EEMember.DtNascSF[I],1,1) = 'D'
                                                  then Filhos[I] := 'S'
                                                  else begin
                                                         Val(Copy(EEMember.DtNascSF[I],7,2),A,E);
                                                         Val(Copy(EEMember.DtNascSF[I],4,2),M,E);
                                                         K := AA - A - 1;
                                                         If M <= MM then K := K + 1;
                                                         If K < 14 then Filhos[I] := 'S';
                                                       end;
                                             end;
                                        end;
                                        K := 0;
                                        For I := 1 to 5 do If Filhos[I] = 'S' then K := 1;
                                        If K = 1 then
                                           begin
                                             If ContLin = 10000 then WriteLine('L',ConstStr(' ',9)+Acentua(L1))
                                                                else WriteLine('L',Qp+ConstStr(' ',9)+Acentua(L1));
                                             WriteLine('L',' ');
                                             WriteLine('L',ConstStr(' ',25)+Nx+'TERMO DE RESPONSABILIDADE'+Nf);
                                             WriteLine('L',' ');
                                             WriteLine('L',ConstStr(' ',20)+Cx+
                                                           Acentua('(Concess„o de Sal rio-Fam¡lia')+
                                                           '  -  Portaria No. MPAS-3.040/82)'+Cf);
                                             WriteLine('L',' ');
                                             WriteLine('L',ConstStr('_',80));
                                             WriteLine('L',' ');
                                             WriteLine('L','Empresa...........: '+
                                                           Acentua(CMstMember.Descricao));
                                             WriteLine('L',' ');
                                             WriteLine('L','Nome do Segurado..: '+Acentua(EEMember.Nome));
                                             WriteLine('L',' ');
                                             WriteLine('L','Cart.de Trabalho..: '+EEMember.CTrabN+' '+
                                                                                  EEMember.CTrabS+' '+
                                                                                  EEMember.CTrabE);
                                             WriteLine('L','Cart.de Identidade: '+EEMember.Identidade);
                                             WriteLine('L',ConstStr('_',80));
                                             WriteLine('L',' ');
                                             WriteLine('L',Acentua('Benefici rios: ')+
                                                           'Nome do Filho'+
                                                           ConstStr(' ',29)+
                                                           'Data de Nascimento');
                                             WriteLine('L',' ');
                                             K := 0;
                                             For I := 1 to 5 do
                                             If Filhos[I] = 'S' then
                                                begin
                                                  K := K + 1;
                                                  WriteLine('L',ConstStr(' ',5)+
                                                            PushLeft(10,EditInteger(K))+
                                                            Acentua(EEMember.FilhosSF[I])+
                                                            ConstStr(' ',47-Length(EEMember.FilhosSF[I]))+
                                                            EEMember.DtNascSF[I]);
                                                end;
                                             For I := K+1 to 10 do
                                             WriteLine('L',ConstStr(' ',5)+EditInteger(I));
                                             WriteLine('L',ConstStr('_',80));
                                             WriteLine('L',' ');
                                             WriteLine('L',ConstStr(' ',5)+
                                                           'Pelo presente TERMO DE RESPONSABILIDADE '+
                                                           'declaro estar ciente de que deverei');
                                             WriteLine('L',Acentua('comunicar  de  imediato a  ocorrˆncia ')+
                                                           Acentua('dos  seguintes  fatos  ou  ocorrˆncias que'));
                                             WriteLine('L',Acentua('determinam a perda do direito ao Sal rio-fam¡lia:'));
                                             WriteLine('L',' ');
                                             WriteLine('L',ConstStr(' ',16)+
                                                           '- OBITO DE FILHO.');
                                             WriteLine('L',ConstStr(' ',16)+
                                                           '- CESSACAO DA INVALIDEZ DE FILHO INVALIDO.');
                                             WriteLine('L',ConstStr(' ',16)+
                                                           '- SENTENCA JUDICIAL QUE DETERMINE O PAGAMENTO A OUTREM.');
                                             WriteLine('L',ConstStr(' ',18)+Cx+
                                                           Acentua('(casos de desquite ou separa‡„o, ')+
                                                           Acentua('abandono de filho ou perda do p trio poder).')+Cf);
                                             WriteLine('L',' ');
                                             WriteLine('L',ConstStr(' ',5)+
                                                           'Estou ciente,  ainda,  de  que a  falta de  '+
                                                           'cumprimento  do compromisso ora');
                                             WriteLine('L',Acentua('assumido, al‚m de obrigar … devolu‡„o ')+
                                                           Acentua('das  importƒncias recebidas indevidamente,'));
                                             WriteLine('L',Acentua('sujeitar-me-  …s  penalidades previstas ')+
                                                           Acentua('no art. 171 do C¢digo Penal e … rescis„o'));
                                             WriteLine('L','do contrato de  trabalho, por justa causa nos '+
                                                           Acentua('termos do art. 482 da Consolida‡„o'));
                                             WriteLine('L','das Leis do Trabalho.');
                                             WriteLine('L',' ');
                                             WriteLine('L',Acentua('Obs. '+Cx+'(Anota‡”es da perda do benef¡cio)')+Cf);
                                             WriteLine('L',' ');
                                             WriteLine('L',ConstStr(' ',5)+
                                                           ConstStr('_',68));
                                             WriteLine('L',' ');
                                             WriteLine('L',ConstStr(' ',5)+
                                                           ConstStr('_',68));
                                             WriteLine('L',' ');
                                             WriteLine('L',ConstStr(' ',56)+
                                                           Acentua('Impress„o digital'));
                                             WriteLine('L','Local e Data: '+
                                                           ConstStr('_',36));
                                             WriteLine('L',' ');
                                             WriteLine('L',' ');
                                             WriteLine('L','Assinatura..: '+
                                                           ConstStr('_',36));
                                           end;
                                      end;
                             13  : If EEMember.Uniforme <> '' then
                                      begin
                                        NCont := NCont + 1;
                                        Writeln(EEMember.Nome);
                                        Proc22Header;
                                        WriteLine('L',PushLeft(10,EEMember.Matricula)+
                                               Acentua(EEMember.Nome)+
                                               ConstStr(' ',41-Length(EEMember.Nome))+
                                               PushRight(2,EEMember.DDAdm)+'/'+
                                               PushRight(2,EEMember.MMAdm)+'/'+
                                               PushRight(2,EEMember.AAAdm)+
                                               ConstStr(' ',3)+
                                               Acentua(EEMember.Uniforme)+
                                               ConstStr(' ',13-Length(EEMember.Uniforme))+
                                               EEMember.Calcado);
                                      end;
                             14  : If (EEMember.CentroC[1] <> '') or
                                      (EEMember.CentroC[2] <> '') or
                                      (EEMember.CentroC[3] <> '') or
                                      (EEMember.CentroC[4] <> '') or
                                      (EEMember.CentroC[5] <> '') then
                                      begin
                                        NCont := NCont + 1;
                                        Writeln(EEMember.Nome);
                                        Proc22Header;
                                        WriteLine('L',Cx+PushLeft(10,EEMember.Matricula)+
                                               Acentua(EEMember.Nome)+
                                               ConstStr(' ',41-Length(EEMember.Nome))+
                                               PushLeft(7,EEMember.CentroC[1])+
                                               PushRight(6,EditReal(EEMember.DiasC[1]))+' '+
                                               PushLeft(7,EEMember.CentroC[2])+
                                               PushRight(6,EditReal(EEMember.DiasC[2]))+' '+
                                               PushLeft(7,EEMember.CentroC[3])+
                                               PushRight(6,EditReal(EEMember.DiasC[3]))+' '+
                                               PushLeft(7,EEMember.CentroC[4])+
                                               PushRight(6,EditReal(EEMember.DiasC[4]))+' '+
                                               PushLeft(7,EEMember.CentroC[5])+
                                               PushRight(6,EditReal(EEMember.DiasC[5]))+Cf);
                                      end;
                             15  : If ((TEx = #00) or (EEMember.TipoExame = TEx)) and
                                      (MMEx = Copy(EEMember.DataExame,4,2)) and
                                      (AAEx = Copy(EEMember.DataExame,7,2)) then
                                      begin
                                        NCont := NCont + 1;
                                        Writeln(EEMember.Nome);
                                        Proc22Header;
                                        WriteLine('L',Cx+PushLeft(10,EEMember.Matricula)+
                                               Acentua(EEMember.Nome)+
                                               ConstStr(' ',41-Length(EEMember.Nome))+
                                               Acentua(EEMember.Cargo)+
                                               ConstStr(' ',16-Length(EEMember.Cargo))+
                                               PushLeft(17,EEMember.Registro)+
                                               PushLeft(5,EEMember.TipoExame)+
                                               EEMember.DataExame+Cf);
                                      end;
                             16  : If ((OrigemW = '*****') and (EEMember.Origem <> '')) or
                                      (OrigemW = UpCaseStr(EEMember.Origem)) then
                                      begin
                                        If EEMember.Tipo = 'H' then R2 := EEMember.Salario * EEMember.HNormais
                                                               else R2 := EEMember.Salario;
                                        NCont := NCont + 1;
                                        Writeln(EEMember.Nome);
                                        Proc22Header;
                                        WriteLine('L',Cx+PushLeft(10,EEMember.Matricula)+
                                               Acentua(EEMember.Nome)+
                                               ConstStr(' ',41-Length(EEMember.Nome))+
                                               PushLeft(11,EEMember.Depto)+
                                               Acentua(EEMember.Cargo)+
                                               ConstStr(' ',16-Length(EEMember.Cargo))+
                                               EEMember.DDAdm+'/'+EEMember.MMAdm+'/'+EEMember.AAAdm+
                                               PushRight(10,EditReal(R2))+' '+
                                               PushLeft(2,EEMember.Tipo)+
                                               UpCaseStr(EEMember.Origem)+Cf);
                                        R1 := R1 + TruncX(R2);
                                      end;
                             17  : If (UpCase(EEMember.Cartao[1]) = 'F') and
                                      (EEMember.Status            = 'A') then
                                      begin
                                        Writeln(EEMember.Nome);
                                        NCont   := NCont + 1;
                                        ContPag := ContPag + 1;
                                        With CMstMember do
                                        begin
                                          If Laser <> 'N'
                                             then WriteLine('L',LaserInit+Dx+Acentua(Descricao)+Df)
                                             else If ContLin < 10000 then WriteLine('L',Qp+Dx+Acentua(Descricao)+Df)
                                                     else begin
                                                            ContLin := 0;
                                                            WriteLine('L',Dx+Acentua(Descricao)+Df);
                                                          end;
                                          WriteLine('L',ConstStr('-',80));
                                          WriteLine('L',Cx+Acentua(Endereco)+', '+Acentua(Numero)+' '+
                                                    Acentua(Complemento)+'  '+Acentua(Cidade)+' - '+
                                                    Estado+'  Cep: '+Cep+Cf);
                                        end;
                                        Writeline('L',' ');
                                        If Laser = 'N'
                                           then WriteLine('L',Acentua(L1)+ConstStr(' ',66-(Length(L1)-4))+
                                                          'Data: '+XDia+'/'+XMes+'/'+XAno)
                                           else WriteLine('L',Acentua(L1)+ConstStr(' ',66-Length(L1))+
                                                          'Data: '+XDia+'/'+XMes+'/'+XAno);
                                        WriteLine('L',' ');
                                        WriteLine('L',Acentua('Matr¡cula: ')+PushLeft(16,EEMember.Matricula)+
                                                  'Nome.....: '+Acentua(EEMember.Nome));
                                        WriteLine('L','Cargo....: '+Acentua(EEMember.Cargo)+
                                                  ConstStr(' ',16-Length(EEMember.Cargo))+
                                                  'No.Regist: '+EEMember.NoMTrab);
                                        WriteLine('L','Cart.Trab: '+PushLeft(11,EEMember.CTrabN)+
                                                  PushLeft(6,EEMember.CTrabS)+
                                                  PushLeft(3,EEMember.CTrabE)+
                                                  'Departam.: '+Acentua(DDMember.Descricao));
                                        If EEMember.Turno = '' then
                                           begin
                                             WriteLine('L','Entrada..: '+PushLeft(16,EEMember.Entrada)+
                                                          Acentua('Refei‡„o.: ')+EEMember.IntRefeicao);
                                             WriteLine('L',Acentua('Sa¡da....: ')+PushLeft(16,EEMember.Saida)+
                                                          'Rep.Seman: '+Acentua(EEMember.RepSemanal));
                                           end
                                           else WriteLine('L','Turno....: '+Acentua(EEMember.Turno));
                                        WriteLine('L','+'+ConstStr('-',77)+'+');
                                        WriteLine('L','| Data  | Sem. | Entrada |'+
                                                  Acentua(' Refei‡„o |  Sa¡da  ')+
                                                  '| Hora extra |      Visto       |');
                                        WriteLine('L','+'+ConstStr('-',77)+'+');
                                        WriteLine('L','|       |______|_________|'+
                                                      '__________|_________|'+
                                                      '____________|__________________|');
                                        If DiaI > DiaF then
                                           begin
                                             For I := DiaI to TabDia[MM] do
                                             begin
                                               WriteLine('L','| '+QQStr(I,2,'0')+'/'+QQStr(MM,2,'0')+' | '+
                                                         DiaSemana(QQStr(I,2,'0')+'/'+QQStr(MM,2,'0')+'/'+QQStr(AA,4,'0'))+
                                                         ' |_________|__________|_________|'+
                                                         '____________|__________________|');

                                             end;
                                             K := MM + 1;
                                             A := AA;
                                             If K = 13 then
                                                begin
                                                  K := 1;
                                                  A := AA + 1;
                                                end;
                                             For I := 1 to DiaF
                                             do WriteLine('L','| '+QQStr(I,2,'0')+'/'+QQStr(K,2,'0')+' | '+
                                                         DiaSemana(QQStr(I,2,'0')+'/'+QQStr(K,2,'0')+'/'+QQStr(A,4,'0'))+
                                                         ' |_________|__________|_________|'+
                                                         '____________|__________________|');
                                           end
                                           else For I := DiaI to DiaF do
                                                begin
                                                  WriteLine('L','| '+QQStr(I,2,'0')+'/'+QQStr(MM,2,'0')+' | '+
                                                         DiaSemana(QQStr(I,2,'0')+'/'+QQStr(MM,2,'0')+'/'+QQStr(AA,2,'0'))+
                                                         ' |_________|__________|_________|'+
                                                         '____________|__________________|');
                                                end;
                                        WriteLine('L','+'+ConstStr('-',77)+'+');
                                        WriteLine('L',' ');
                                        WriteLine('L',' ');
                                        WriteLine('L',' ');
                                        WriteLine('L',ConstStr(' ',39)+ConstStr('_',40));
                                        WriteLine('L',ConstStr(' ',39)+Acentua(EEMember.Nome));
                                        Footer;
                                      end;
                          end;
                        end
                        else If EEMember.Depto <> DDNo then RC := 'N';
                   end;
                GoNoGo;
                If TC = #27 then
                   begin
                     RC   := 'N';
                     DDAC := DDNo;
                   end;
                If Ex = '#' then RC := 'N';
              Until RC = 'N';
              TC := #13;
              If NCont > 0 then
                 begin
                   If YY in [4,5] then
                      begin
                        If I > 0 then
                           begin
                             ListaFones(YY);
                             ZeraFones;
                           end;
                      end
                      else If (YY <> 1) and (YY <> 12) and (YY <> 17) then
                              begin
                                If YY = 7 then
                                   begin
                                     WriteLine('L',ConstStr(' ',51)+Cx+
                                                   ConstStr(' ',11)+
                                                   ConstStr('-',18)+Cf);
                                     WriteLine('L',ConstStr(' ',51)+Cx+
                                                   ConstStr(' ',11)+
                                                   PushRight(18,EditReal(R1))+Cf);
                                     R1 := 0;
                                   end;
                                If YY = 11 then
                                   begin
                                      WriteLine('L',Cx+ConstStr(' ',56)+
                                                    ConstStr('-',14)+' '+
                                                    ConstStr('-',14)+' '+
                                                    ConstStr('-',14)+' '+
                                                    ConstStr('-',14)+Cf);
                                      WriteLine('L',Cx+ConstStr(' ',56)+
                                                    PushRight(14,EditReal(R4))+' '+
                                                    PushRight(14,EditReal(R5))+' '+
                                                    PushRight(14,EditReal(R6))+' '+
                                                    PushRight(14,EditReal(R7))+Cf);
                                      R4 := 0;
                                      R5 := 0;
                                      R6 := 0;
                                      R7 := 0;
                                   end;
                                If (YY = 16) and (Ex = 'L') then
                                   begin
                                        WriteLine('L',Cx+ConstStr(' ',86)+
                                                      ConstStr('-',12)+Cf);
                                        WriteLine('L',Cx+ConstStr(' ',86)+
                                                      PushRight(12,EditReal(R1))+Cf);
                                   end;
                                If Ex <> '#' then
                                   begin
                                     WriteLine('L',' ');
                                     WriteLine('L',Nx+'** Total '+
                                                   PushRight(4,EditInteger(NCont))+Nf);
                                   end;
                              end
                              else If (YY <>  1) and
                                      (YY <> 11) and
                                      (YY <> 12) and
                                      (YY <> 17) then CloseTexto;
                   TF    := TF + NCont;
                   NCont := 0;
                 end;
              If DDNo = DDAC then RC := 'N'
                             else RC := 'S';
            end;
       Until RC = 'N';
       If TF > 0 then
          begin
            If (Etq = 'E') and (YY = 1) then
               begin
                 If I > 0 then ImprimeTexto('S');
                 CloseTexto;
               end;
            TC := #13;
            If (YY = 7) and (Ex <> 'L') then
               begin
                 Proc22Header;
                 WriteLine('L',ConstStr(' ',51)+Cx+
                               ConstStr(' ',11)+
                               ConstStr('-',18)+Cf);
                 WriteLine('L',ConstStr(' ',51)+Cx+
                               ConstStr(' ',11)+
                               PushRight(18,EditReal(R2))+Cf);
               end;
            If YY = 10 then
               begin
                 Close ( ESFile );
                 Erase ( ESFile );
               end;
            Footer;
            If DskRpt = 'N' then WriteLine('W',Qp);
            NCont := TF;
          end;
       FuncImpressos;
     end;
end;


Procedure ProcNo22Report;
begin
  TabI[1]  := ' Aniversariantes/Etiq..  ';
  TabI[2]  := ' Em experiˆncia          ';
  TabI[3]  := ' Exame m‚dico            ';
  TabI[4]  := ' Lista telef“nica        ';
  TabI[5]  := ' Telefones residenciais  ';
  TabI[6]  := ' Altera‡”es de sal rios  ';
  TabI[7]  := ' Cheques emitidos        ';
  TabI[8]  := ' Indice de Empregados    ';
  TabI[9]  := ' Ac.de Horas para F‚rias ';
  TabI[10] := ' Evolu‡Æo Salarial       ';
  TabI[11] := ' Simula‡Æo de Rescis”es  ';
  TabI[12] := ' Decl.de Sal rio fam¡lia ';
  TabI[13] := ' Vestu rio (Uniformes)   ';
  TabI[14] := ' Centros de Custo/Dias   ';
  TabI[15] := ' Exames a vencer em      ';
  TabI[16] := ' Origem dos Empregados   ';
  TabI[17] := ' Folha de Ponto          ';
  TabI[18] := ' Encerrar a fun‡Æo       ';
  TabX[1]  := 7;
  TabX[2]  := 7;
  TabX[3]  := 7;
  TabX[4]  := 7;
  TabX[5]  := 7;
  TabX[6]  := 7;
  TabX[7]  := 7;
  TabX[8]  := 7;
  TabX[9]  := 7;
  TabX[10] := 31;
  TabX[11] := 31;
  TabX[12] := 31;
  TabX[13] := 31;
  TabX[14] := 31;
  TabX[15] := 31;
  TabX[16] := 31;
  TabX[17] := 31;
  TabX[18] := 31;
  TabY[1]  := 11;
  TabY[2]  := 12;
  TabY[3]  := 13;
  TabY[4]  := 14;
  TabY[5]  := 15;
  TabY[6]  := 16;
  TabY[7]  := 17;
  TabY[8]  := 18;
  TabY[9]  := 19;
  TabY[10] := 11;
  TabY[11] := 12;
  TabY[12] := 13;
  TabY[13] := 14;
  TabY[14] := 15;
  TabY[15] := 16;
  TabY[16] := 17;
  TabY[17] := 18;
  TabY[18] := 19;
  DrawBox(6,10,56,20,Bfn,'N');
  YY := 1;
  MenuAuxiliar(18,Tfn,Utx,Bfn,Btx);
  Repeat
    Resp := ReadKey;
    If (Resp = #0 ) and
       (KeyPressed) then
       begin
         Resp := ReadKey;
         Case Resp of
              #72 : begin
                      YY := YY - 1;
                      If YY < 1 then YY := 18;
                    end;
              #75 : YY := 1;
              #77 : YY := 10;
              #80 : begin
                      YY := YY + 1;
                      If YY > 18 then YY := 1;
                    end;
         end;
         MenuAuxiliar(18,Tfn,Utx,Bfn,Btx);
       end
       else If Resp = #13 then
               begin
                 Move(Mem[$B800:0000],ScArray4[1],4000);
                 ContLin := 1000;
                 ContPag := 0;
                 Case YY of
                      1,2,3,7,11,15,16,17 : PedeProc22;
                      4,5,6,8,9  : Repeat
                                     PedeDepto(8,'L');
                                     If TC <> #27 then Confirma;
                                   Until TC in ['S',#27];
                      10    : begin
                                ProcNo22Rel10;
                                Repeat
                                  PedeDepto(8,'@');
                                  If TC <> #27 then Confirma;
                                Until TC in ['S',#27];
                              end;
                      12    : Repeat
                                PedeDepto(8,'#');
                                If TC <> #27 then Confirma;
                              Until TC in ['S',#27];
                      13,14 : Repeat
                                PedeDepto(8,' ');
                                If TC <> #27 then Confirma;
                              Until TC in ['S',#27];
                      18    : begin
                                TC   := #27;
                                Resp := #27;
                              end;
                 end;
                 If TC = 'S' then ProcessaProc22;
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


end.