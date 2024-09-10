Procedure TitleInss;
begin
  Color(Tfn,Ttx);
  GotoXY(04,09); Write('Matr¡c:');
  Color(Tfn,Utx);
end;


Procedure ScrollInss;
Var
  Cont,F,Direcao    : Char;
  L,Sx              : Integer;

begin
  Color(Blue,White);
  GotoXY(01,23); Write(ConstStr(' ',80));
  GotoXY(04,23); Write(#25);
  GotoXY(20,23); Write(#24);
  GotoXY(38,23); Write('Esc');
  GotoXY(52,23); Write('F3');
  GotoXY(68,23); Write('F5');
  Color(Blue,Cyan);
  GotoXY(06,23); Write(#26,' Pr¢xima');
  GotoXY(22,23); Write(#26,' Anterior');
  GotoXY(42,23); Write(#26,' Fim');
  GotoXY(55,23); Write(#26,' Atualiza');
  GotoXY(71,23); Write(#26,' Apagar');
  LimpaLn(24,Red);
  DrawBox(22,12,67,21,Sfn,'S');
  Color(Bfn,Btx);
  GotoXY(22,12); Write(' MM/AAAA Sal rio Contribui‡Æo    Recolhimento ');
  Color(Sfn,Stx);
  F       := 'N';
  Direcao := 'P';
  L       := 1;
  Sx      := 1;
  Repeat
    Window(22,14,68,21);
    K := 0;
    For I := L to L+6 do begin
                           If I <= 48 then
                              begin
                                K := K + 1;
                                If Sx = K then Color(Tfn,Utx)
                                          else Color(Sfn,Stx);
                                GotoXY(1,K);
                                Writeln(' ',ENMember.MMAA[I]:7,' ',
                                        EditReal(ENMember.SalC[I]):20,' ',
                                        EditReal(ENMember.VRec[I]):15,' ');
                              end;
                         end;
    Window(1,1,80,25);
    Cont := ReadKey;
    If (Cont = #0 ) and
       (KeyPressed) then
       begin
         Cont := ReadKey;
         Case Cont of
              #61 : begin
                      Window(22,14,68,21);
                      K := 1;
                      Repeat
                        Case K of
                             1 : begin
                                   J := ENMember.MMAA[L+Sx-1];
                                   InputStr(J,7,2,Sx,0,'S','N','T','N',Tfn,Utx);
                                   ENMember.MMAA[L+Sx-1] := J;
                                 end;
                             2 : begin
                                   If ENMember.SalC[L+Sx-1] = 0 then J := ''
                                      else begin
                                             Str(ENMember.SalC[L+Sx-1]:20:2,J);
                                             J := LeftAdjust(J);
                                           end;
                                   InputStr(J,18,12,Sx,0,'S','N','$','N',Tfn,Utx);
                                   Val(J,ENMember.SalC[L+Sx-1],E);
                                 end;
                             3 : begin
                                   If ENMember.VRec[L+Sx-1] = 0 then J := ''
                                      else begin
                                             Str(ENMember.VRec[L+Sx-1]:17:2,J);
                                             J := LeftAdjust(J);
                                           end;
                                   InputStr(J,14,32,Sx,0,'S','N','$','N',Tfn,Utx);
                                   Val(J,ENMember.VRec[L+Sx-1],E);
                                 end;
                        end;
                        Case TC of
                             #13 : K := K + 1;
                             #24 : If K > 1 then K := K - 1;
                        end;
                      Until (K = 4) or (TC = #27);
                      Window(1,1,80,25);
                      TC      := #13;
                      Direcao := 'N';
                    end;
              #63 : begin
                      ENMember.MMAA[L+Sx-1] := '';
                      ENMember.SalC[L+Sx-1] := 0;
                      ENMember.VRec[L+Sx-1] := 0;
                    end;
              #72 : begin
                      Color(Blue,White);
                      GotoXY(04,23); Write(#25);
                      Color(Blue,(White + Blink));
                      GotoXY(20,23); Write(#24);
                      Direcao := 'A';
                    end;
              #80 : begin
                      Color(Blue,(White + Blink));
                      GotoXY(04,23); Write(#25);
                      Color(Blue,White);
                      GotoXY(20,23); Write(#24);
                      Direcao := 'P';
                    end;
         end;
       end
       else If Cont = #27 then Direcao := 'N';
    Case Direcao of
         'A' : If F <> 'A' then
                  begin
                    F := 'N';
                    If Sx > 1 then Sx := Sx - 1
                              else If L > 1 then L := L - 1
                                            else F := 'A';
                  end;
         'P' : If F <> 'P' then
                  begin
                    F := 'N';
                    If Sx < 7 then Sx := Sx + 1
                              else If L < 42 then L := L + 1
                                             else F := 'P';
                  end;
    end;
    If F <> 'N' then
       begin
         Color(Red,White);
         GotoXY(1,24);  Write(ConstStr(' ',80));
         GotoXY(1,24);  Write(' Fim da Lista');
         Color(Sfn,Stx);
       end
       else LimpaLn(24,Red);
  Until Cont = #27;
  LimpaLn(23,Tfd);
end;


Procedure ProcessInss;
begin
  TitleInss;
  Move(Mem[$B800:0000],ScArray4[1],4000);
  Repeat
    RecebeCodigo(09,'U','N');
    If EENumber <> Limite then
       begin
         ReadWrite(#08,'R','N',EENumber);
         Color(Tfn,Utx);
         GotoXY(12,09); Write(PushLeft(9,EEMember.Matricula),EEMember.Nome);
         Color(Tfn,Utx);
         ReadWrite(#12,'R','N',EENumber);
         If (RW                 = 'N') or
            (ENMember.Empregado = '' ) then
            begin
              ENMember.Empregado := EENo;
              For I := 1 to 48 do begin
                                    ENMember.MMAA[I] := '';
                                    ENMember.SalC[I] := 0;
                                    ENMember.VRec[I] := 0;
                                  end;
            end;
         ScrollInss;
         Confirma;
         If TC = 'S' then ReadWrite(#12,'W','N',EENumber);
         TC := #13;
         Move(ScArray4[1],MemW[$B800:0000],4000);
       end;
  Until TC = #27;
end;


Procedure SalContribuicao;
begin
  EENo := '';
  Repeat
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
         QPorta;
         If TC <> #27 then
            begin
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
                     ReadWrite(#12,'R','N',EENumber);
                     Writeln(Nome);
                     If NCont = 0
                        then WriteLine('L',ConstStr(' ',05)+Nx+
                                           Acentua('Hist¢rico de contribui‡„o para INSS')+Nf)
                        else WriteLine('L',Qp+ConstStr(' ',05)+Nx+
                                           Acentua('Hist¢rico de contribui‡„o para INSS')+Nf);
                     NCont := NCont + 1;
                     WriteLine('L',ConstStr(' ',05)+ConstStr('-',73));
                     WriteLine('L',' ');
                     WriteLine('L',ConstStr(' ',05)+Cx+'Carimbo padronizado do C.G.C.'+Cf);
                     WriteLine('L',' ');
                     WriteLine('L',ConstStr(' ',35)+Cx+Acentua(CMstMember.Descricao)+Cf);
                     WriteLine('L',ConstStr(' ',35)+Cx+ConstStr('-',40)+Cf);
                     WriteLine('L',ConstStr(' ',35)+Cx+Acentua(CMstMember.Endereco)+Cf);
                     WriteLine('L',ConstStr(' ',35)+Cx+Acentua(CMstMember.Cidade)+' '+
                                   CMstMember.Estado+' '+
                                   CMstMember.Cep+Cf);
                     WriteLine('L',ConstStr(' ',35)+Cx+ConstStr('-',40)+Cf);
                     WriteLine('L',ConstStr(' ',35)+Cx+'C.G.C. '+CMstMember.CGC+Cf);
                     WriteLine('L',ConstStr(' ',35)+Cx+ConstStr('-',40)+Cf);
                     WriteLine('L',' ');
                     WriteLine('L',' ');
                     WriteLine('L',' ');
                     WriteLine('L',ConstStr(' ',05)+ConstStr('-',73));
                     WriteLine('L',ConstStr(' ',05)+Cx+
                                   Acentua('C.P.F                       Nome completo do benefici rio')+Cf);
                     WriteLine('L',ConstStr(' ',05)+ConstStr('-',73));
                     WriteLine('L',' ');
                     WriteLine('L',ConstStr(' ',05)+PushLeft(16,EEMember.Cpf)+
                                   Acentua(EEMember.Nome));
                     WriteLine('L',' ');
                     WriteLine('L',ConstStr(' ',05)+ConstStr('-',73));
                     WriteLine('L',ConstStr(' ',05)+Acentua('MM/AA  Sal rio ')+
                                   'Contr.  Recolhimento   MM/AA  '+
                                   Acentua('Sal rio Contr.  Recolhimento'));
                     WriteLine('L',ConstStr(' ',05)+ConstStr('-',73));
                     WriteLine('L',' ');
                     For I := 1 to 24 do
                     With ENMember do
                     begin
                       If MMAA[I+24] <> ''
                          then WriteLine('L',ConstStr(' ',05)+MMAA[I]+'  '+
                                             PushRight(14,EditReal(SalC[I]))+'  '+
                                             PushRight(12,EditReal(VRec[I]))+'  '+
                                             MMAA[I+24]+'  '+
                                             PushRight(14,EditReal(SalC[I+24]))+'  '+
                                             PushRight(12,EditReal(VRec[I+24])))
                          else If MMAA[I] <> ''
                                then WriteLine('L',ConstStr(' ',05)+MMAA[I]+'  '+
                                                   PushRight(14,EditReal(SalC[I]))+'  '+
                                                   PushRight(12,EditReal(VRec[I])))
                                else WriteLine('L',' ');
                     end;
                     WriteLine('L',' ');
                     WriteLine('L',ConstStr(' ',05)+ConstStr('-',73));
                     WriteLine('L',' ');
                     WriteLine('L',' ');
                     WriteLine('L',' ');
                     WriteLine('L',' ');
                     WriteLine('L',' ');
                     WriteLine('L',' ');
                     WriteLine('L',ConstStr(' ',05)+Cx+Acentua(CMstMember.Cidade)+
                                   ConstStr(' ',35-Length(CMstMember.Cidade))+
                                   XDia+'/'+XMes+'/'+XAno+Cf);
                     WriteLine('L',ConstStr(' ',05)+ConstStr('-',73));
                     WriteLine('L',ConstStr(' ',05)+Cx+'Local'+
                                   ConstStr(' ',30)+'Data    '+
                                   ConstStr(' ',25)+
                                   Acentua('Assinatura do Respons vel')+Cf);
                     GoNoGo;
                     If TC = #27 then RC := 'N';
                     If J = EENo then RC := 'N';
                   end;
              Until RC = 'N';
              If NCont <> 0
                 then If DskRpt = 'N' then WriteLine('W',Qp);
              Close ( LST );
              Window(1,1,80,25);
              Color(Blue,Black);
              GotoXY(1,23);  Write(ConstStr(' ',80));
              GotoXY(1,23);  Write(' Total de Empregados Impressos: ');
              Color(Blue,White);
              GotoXY(33,23); Write(NCont:5);
              TeclaReturn;
            end;
       end;
    Move(ScArray4[1],Mem[$B800:0000],4000);
  Until TC = #27;
end;

