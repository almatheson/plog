{$O+,F+}
Unit PlogRpt8;

Interface

Uses Crt,Dos,PlogGlbs,PlogBasP,PlogTree,PlogRpt0;


   Procedure ProcNo01Report;


Implementation


Procedure ProcNo01Contas;
begin
  Confirma;
  If TC = 'S' then
     begin
       ContLin := 10000;
       ContPag := 0;
       NCont   := 0;
       L1  := Nx+'Proventos & Descontos'+Nf;
       L6  := ConstStr(' ',36)+'T T O A M'+ConstStr(' ',10)+'T I I F R D B B B B B   S';
       L7  := ConstStr(' ',36)+'i e p c e'+ConstStr(' ',10)+'a R N G A I a a a a a   T';
       L8  := ConstStr(' ',36)+'p m e e d'+ConstStr(' ',10)+'x R S T I R s s s s s   A';
       L9  := ConstStr(' ',36)+'o p r i i'+ConstStr(' ',10)+'a F S S S F e e e e e   T';
       L10 := 'Cta Descri‡„o'+ConstStr(' ',23)+'. o a t a ...Fator H . . . . . 6 7 8 9 0   .';
       ParaContinua;
       Janela('C');
       CCNo := '';
       Repeat
         RC := 'N';
         SearchPos1 ( Root1 );
         If RC = 'S' then
            With CCMember do
            begin
              ReadWrite(#04,'R','N',CCNumber);
              Writeln(Descricao);
              NCont := NCont + 1;
              If ContLin > 57 then HeaderReport;
              Str(Taxa:8:3,J);
              WriteLine('L',CCNo+' '+Acentua(Descricao)+
                            ConstStr('.',(31-Length(Descricao)))+' '+
                            Tipo+' '+Tempo+' '+Operacao+' '+
                            Aceita+' '+Media+' '+PushRight(8,J)+' '+TxConv+' '+
                            Bases[1]+' '+Bases[2]+' '+Bases[3]+' '+
                            Bases[4]+' '+Bases[5]+' '+Bases[6]+' '+
                            Bases[7]+' '+Bases[8]+' '+Bases[9]+' '+
                            Bases[10]+'   '+Status);
              GoNoGo;
              If TC = #27 then RC := 'N';
            end;
       Until RC = 'N';
       Window(1,1,80,25);
       If NCont > 0 then
          begin
            TC := #13;
            Footer;
            If DskRpt = 'N' then WriteLine('W',Qp);
          end;
       Window(1,1,80,25);
       Color(Blue,Cyan);
       GotoXY(1,23);  Write(ConstStr(' ',80));
       GotoXY(2,23);  Write('Total de Contas Impressas: ');
       Color(Blue,White);
       GotoXY(29,23); Write(NCont:5);
       TeclaReturn;
     end;
end;


Procedure ProcNo01Sindicatos;
begin
  Confirma;
  If TC = 'S' then
     begin
       ContLin := 10000;
       ContPag := 0;
       NCont   := 0;
       L1  := Nx+'Sindicatos'+Nf;
       L6  := 'No Descri‡„o';
       L7  := '';
       L8  := '';
       L9  := '';
       L10 := '';
       ParaContinua;
       Janela('S');
       SSNo := '';
       Repeat
         RC := 'N';
         SearchPos2 ( Root2 );
         If RC = 'S' then
            With SSMember do
            begin
              ReadWrite(#07,'R','N',SSNumber);
              Writeln(Descricao);
              NCont := NCont + 1;
              If ContLin > 57 then HeaderReport;
              WriteLine('L',PushLeft(3,SSNo)+Acentua(Descricao)+
                            ConstStr('.',(31-Length(Descricao))));
              GoNoGo;
              If TC = #27 then RC := 'N';
            end;
       Until RC = 'N';
       Window(1,1,80,25);
       If NCont > 0 then
          begin
            TC := #13;
            Footer;
            If DskRpt = 'N' then WriteLine('W',Qp);
          end;
       Window(1,1,80,25);
       Color(Blue,Cyan);
       GotoXY(1,23);  Write(ConstStr(' ',80));
       GotoXY(2,23);  Write('Total de Sindicatos Impressos: ');
       Color(Blue,White);
       GotoXY(33,23); Write(NCont:5);
       TeclaReturn;
     end;
end;


Procedure ProcNo01Departamentos;
begin
  Confirma;
  If TC = 'S' then
     begin
       ContLin := 10000;
       ContPag := 0;
       NCont   := 0;
       L1  := Nx+'Departamentos'+Nf;
       L6  := 'C¢digo     Descri‡„o';
       L7  := '';
       L8  := '';
       L9  := '';
       L10 := '';
       ParaContinua;
       Janela('D');
       DDNo := '';
       Repeat
         RC := 'N';
         SearchPos3 ( Root3 );
         If RC = 'S' then
            With DDMember do
            begin
              ReadWrite(#05,'R','N',DDNumber);
              Writeln(Descricao);
              NCont := NCont + 1;
              If ContLin > 57 then HeaderReport;
              WriteLine('L',PushLeft(11,DDNo)+Acentua(Descricao));
              GoNoGo;
              If TC = #27 then RC := 'N';
            end;
       Until RC = 'N';
       Window(1,1,80,25);
       If NCont > 0 then
          begin
            TC := #13;
            Footer;
            If DskRpt = 'N' then WriteLine('W',Qp);
          end;
       Window(1,1,80,25);
       Color(Blue,Cyan);
       GotoXY(1,23);  Write(ConstStr(' ',80));
       GotoXY(2,23);  Write('Total de Departamentos Impressos: ');
       Color(Blue,White);
       GotoXY(36,23); Write(NCont:5);
       TeclaReturn;
     end;
end;


Procedure ProcNo01Empregados;
Var
  Stx     :  Char;
begin
  Color(Tfn,Ttx);
  GotoXY(4,19); Write('Status:');
  Stx := 'A';
  Repeat
    J := Stx;
    InputStr(J,1,12,19,0,'S','N','T','N',Tfn,Utx);
    If TC <> #27 then
       begin
         Stx := UpCase(J[1]);
         GotoXY(12,19);
         Case Stx of
              'A' : Write('Ativo       ');
              'P' : Write('Dem.Espont. ');
              'D' : Write('Demitido    ');
              'E' : Write('Entr.Tranf. ');
              'J' : Write('Justa Causa ');
              'R' : Write('Rescindido  ');
              'F' : Write('F‚rias      ');
              'L' : Write('Licen‡a     ');
              'C' : Write('Acidentado  ');
              'M' : Write('Morte       ');
              'T' : Write('Transf.Saida');
              'V' : Write('Aviso Pr‚vio');
              'O' : Write('Aposentado  ');
              'X' : Write('Excluir Reg ');
              else  Stx := ' ';
         end;
         If Stx <> ' ' then Confirma;
       end;
  Until TC in [#27,'S'];
  If TC = 'S' then
     begin
       ContLin := 10000;
       ContPag := 0;
       NCont   := 0;
       L1  := Nx+'Empregados'+Nf;
       L6 := Cx+'Matr¡cula Nome'+ConstStr(' ',37)+
                'Cargo           Admiss„o Dt-Nasc. S Cpf.'+Cf;
       L7  := '';
       L8  := '';
       L9  := '';
       L10 := '';
       LoadIndex6 ('E',Tr);
       If TC <> #27 then
          begin
            ParaContinua;
            Janela('F');
            XXNo := '';
            Repeat
              RC := 'N';
              SearchPos6 ( Root6 );
              If RC = 'S' then
                 With EEMember do
                 begin
                   ReadWrite(#08,'R','N',XXNumber);
                   If EEMember.Status = Stx then
                      begin
                        NCont := NCont + 1;
                        Writeln(Nome);
                        If ContLin > 57 then HeaderReport;
                        WriteLine('L',Cx+PushLeft(10,EEMember.Matricula)+
                                    Acentua(EEMember.Nome)+
                                    ConstStr(' ',41-Length(EEMember.Nome))+
                                    Acentua(EEMember.Cargo)+
                                    ConstStr(' ',16-Length(EEMember.Cargo))+Cx+
                                    PushRight(2,EEMember.DDAdm)+'/'+
                                    PushRight(2,EEMember.MMAdm)+'/'+
                                    PushRight(4,EEMember.AAAdm)+' '+
                                    PushRight(2,EEMember.DDNasc)+'/'+
                                    PushRight(2,EEMember.MMNasc)+'/'+
                                    PushRight(4,EEMember.AANasc)+' '+
                                    PushLeft(1,EEMember.Status)+
                                    EEMember.Cpf+Cf);
                      end;
                 end;
              GoNoGo;
              If TC = #27 then RC := 'N';
            Until RC = 'N';
            If NCont > 0 then
               begin
                 TC := #13;
                 Footer;
                 If DskRpt = 'N' then WriteLine('W',Qp);
               end;
            FuncImpressos;
          end;
     end;
end;


Procedure ProcNo01Report;
begin
  TabI[1]  := ' Tabela de Contas        ';
  TabI[2]  := ' Tabela de Sindicatos    ';
  TabI[3]  := ' Tabela de Departamentos ';
  TabI[4]  := ' Tabela de Empregados    ';
  TabI[5]  := ' Encerrar a fun‡„o       ';
  TabX[1]  := 7;
  TabX[2]  := 7;
  TabX[3]  := 7;
  TabX[4]  := 7;
  TabX[5]  := 7;
  TabY[1]  := 11;
  TabY[2]  := 12;
  TabY[3]  := 13;
  TabY[4]  := 14;
  TabY[5]  := 15;
  DrawBox(6,10,32,16,Bfn,'N');
  YY := 1;
  MenuAuxiliar(5,Tfn,Utx,Bfn,Btx);
  Repeat
    Resp := ReadKey;
    If (Resp = #0 ) and
       (KeyPressed) then
       begin
         Resp := ReadKey;
         Case Resp of
              #72 : begin
                      YY := YY - 1;
                      If YY < 1 then YY := 5;
                    end;
              #80 : begin
                      YY := YY + 1;
                      If YY > 5 then YY := 1;
                    end;
         end;
         MenuAuxiliar(5,Tfn,Utx,Bfn,Btx);
       end
       else If Resp = #13 then
               begin
                 Move(Mem[$B800:0000],ScArray4[1],4000);
                 ContLin := 10000;
                 ContPag := 0;
                 Case YY of
                      1 : ProcNo01Contas;
                      2 : ProcNo01Sindicatos;
                      3 : ProcNo01Departamentos;
                      4 : ProcNo01Empregados;
                      5 : begin
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


end.