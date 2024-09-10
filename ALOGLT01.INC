Procedure CabecalhoLote(X : Char);
Var
  L1         : AnyStr;
begin
  With LoteMember do
  begin
    If Laser <> 'N' then WriteLine('W',LaserInit)
                    else If ContLin <> 100 then WriteLine('W',Qp);
    L1      := 'Lote.....: '+Dx+Chave+Df;
    ContLin := 0;
    WriteLine('L',L1);
    WriteLine('L',ConstStr('-',T));
    WriteLine('L','Empresa..: '+CmpyNo+' '+Acentua(CmpyMember.Descricao));
    WriteLine('L','Data Cont: '+Acentua(ArrayMesEx[MesContabil])+' de '+
                   EditInteger(AnoContabil));
    WriteLine('L',Acentua('Descri‡„o: ')+Acentua(Descricao));
    WriteLine('L','Criado em: '+DataAbert);
    Case Status of
         'A' : WriteLine('L','Status...: Ativo    ');
         'C' : WriteLine('L','Status...: Cancelado');
         'E' : WriteLine('L','Status...: Excluido ');
    end;
    WriteLine('L',Acentua('D‚bitos..: ')+
                  PushRight(20,EditDouble(Debito))+'   '+
                  PushRight(4,EditInteger(RDebito))+' Lancamentos');
    WriteLine('L',Acentua('Cr‚ditos.: ')+
                  PushRight(20,EditDouble(Credito))+'   '+
                  PushRight(4,EditInteger(RCredito))+' Lancamentos');
    WriteLine('L',' ');
    WriteLine('L',ConstStr('-',T));
    Case X of
         'L' : If T = 80
                  then WriteLine('L','Item S DD Conta'+
                                      ConstStr(' ',14)+'T '+Cx+
                                      ConstStr(' ',12)+'Valor  Depart '+
                                      Acentua('Hist¢rico')+Cf)
                  else WriteLine('L','Item S DD  Conta'+
                                      ConstStr(' ',14)+'T'+
                                      ConstStr(' ',13)+
                                      'Valor  Depart '+Acentua('Hist¢rico'));
         'T' : WriteLine('L',ConstStr(' ',Trunc((T - 55)/2))+'DD'+
                           ConstStr(' ',14)+
                           Acentua('D‚bitos Reg.')+ConstStr(' ',14)+
                           Acentua('Cr‚ditos Reg.'));
    end;
    WriteLine('L',ConstStr('-',T));
    WriteLine('L',' ');
  end;
end;


Procedure Tamanho;
Var
  Tx       : Char;
begin
  Color(Red,Cyan);
  GotoXY(1,24); Write(' ':80);
  GotoXY(2,24); Write('Quer listar em  0 ou  32 colunas ?    ');
  Color(Red,White);
  GotoXY(17,24); Write('8');
  GotoXY(23,24); Write('1');
  Repeat
    Tx := ReadKey;
  Until Tx in ['1','8'];
  LimpaLn(24,Tfd);
  Case Tx of
       '1' : begin
               T         := 132;
               LaserInit := #27+'E'+#27+'&l1O'+#27+'&l8D';
             end;
       '8' : begin
               T := 80;
               LaserInit := #27+'E';
             end;
  end;
end;


Procedure PrintLote (X : Str2);
begin
  QPorta;
  If TC = #13 then
     begin
       ContLin := 100;
       Color(Blue,Yellow);
       GotoXY(1,23); Write(' ':80);
       GotoXY(2,23); Write('Listagem do Lote.');
       Tamanho;
       ParaContinua;
       CabecalhoLote('L');
       With LoteMember do
       begin
         DCVSNo := LoteNo + '#';
         With LctoMember do
         begin
           Repeat
             RC := 'N';
             SearchPos6 ( Root6 );
             If (RC         = 'S'                            ) and
                (LoteNo+'#' = Copy(DCVSNo,1,Length(LoteNo)+1)) then
                begin
                  ReadWrite(#08,'R','N',DCVSNumber);
                  If (X = ''                           ) or
                     (X = Copy(LctoMember.OrigData,1,2)) then
                     begin
                       If ContLin > 60 then CabecalhoLote('L');
                       If T = 80 then
                          begin
                            WriteLine('L',PushRight(4,SeqLote)+' '+
                                          Status+' '+Copy(OrigData,1,2)+' '+
                                          PushLeft(19,Conta)+
                                          Tipo+' '+Cx+
                                          PushRight(17,EditDouble(Valor))+
                                          ConstStr(' ',2)+
                                          PushRight(6,Depto)+' '+
                                          Acentua(Historico[1])+Cf);
                            If Historico[2] <> '' then
                                  begin
			            WriteLine('L',ConstStr(' ',31)+Cx+
                                                  ConstStr(' ',26)+
                                                  Acentua(Historico[2])+Cf);
                                    If Historico[3] <> ''
                                       then WriteLine('L',ConstStr(' ',31)+Cx+
                                                          ConstStr(' ',26)+
                                                          Acentua(Historico[3])+Cf);
                                  end;
                          end
                          else begin
                                WriteLine('L',PushRight(4,SeqLote)+' '+
                                              Status+' '+Copy(OrigData,1,2)+'  '+
                                              Pushleft(19,Conta)+Tipo+' '+
                                              PushRight(17,EditDouble(Valor))+'  '+
                                              PushRight(6,Depto)+' '+
                                              Acentua(Historico[1]));
                                If Historico[2] <> '' then
                                   begin
                                     WriteLine('L',ConstStr(' ',60)+
                                                   Acentua(Historico[2]));
			             If Historico[3] <> ''
                                        then WriteLine('L',ConstStr(' ',60)+
                                                           Acentua(Historico[3]));
                                   end;
                               end;
                     end;
                end
                else RC := 'N';
             GoNoGo;
             If TC = #27 then RC := 'N';
           Until RC = 'N';
           TC := #13;
           If DskRpt = 'N' then WriteLine('W',Qp);
         end;
       end;
       Close ( LST );
       LimpaLn(23,Tfd);
     end
     else TC := 'N';
end;


Procedure TotalNaoBate(X : Char);
begin
  Color(Red,Cyan);
  GotoXY(01,23);  Write(ConstStr(' ',80));
  GotoXY(02,23);
  Write('O total do        e do         est„o diferentes, o lote n„o esta fechado.');
  Color(Red,Yellow);
  GotoXY(13,23); Write('d‚bito');
  GotoXY(25,23); Write('cr‚dito');
  Color(Blue,Cyan);
  GotoXY(01,24);  Write(ConstStr(' ',80));
  GotoXY(02,24);
  If X <> 'G'
     then Write('Tecle [     ] p/Continuar, [  ] p/        lan‡amentos, [  ] p/Imprimir o Lote ')
     else Write('Tecle [     ] p/Continuar na fun‡„o at‚ acertar os totais do Lote.            ');
  GotoXY(36,24);
  Case X of
       'A' : Write('Incluir');
       'I' : Write('Alterar')
  end;
  Color(Blue,Yellow);
  GotoXY(09,24); Write('Enter');
  If X <> 'G' then
     begin
       GotoXY(30,24); Write('F1');
       GotoXY(58,24); Write('F3');
     end;
  Repeat
    TC := ReadKey;
    If (TC = #00  ) and
       (KeyPressed) and
       (X  <> 'G' ) then
       begin
         TC := ReadKey;
         If TC =  #61 then
            begin
              Move(MemW[$B800:0000],ScArray5[1],4000);
              Color(Blue,Cyan);
              GotoXY(01,23);  Write(ConstStr(' ',80));
              PrintLote(XDL);
              Move(ScArray5[1],MemW[$B800:0000],4000);
              TC := #00;
            end;
       end;
  Until TC in [#13,#59,#117];
  LimpaLn(23,Tfd);
  LimpaLn(24,Tfd);
  Case TC of
       #13 : If X = 'I' then TC := #00
                        else TC := #01;
       #59 : If X = 'I' then TC := #01
                        else TC := #00;
  end;
end;


Procedure IncluiContaE;
begin
  ContaNo := LimpaChave(J);
  SearchTree1 ( Root1 );
  If RC = 'N' then
     begin
       Move(MemW[$B800:0000],ScArray6[1],4000);
       Titulo := 'Plano de Contas (Inclus„o)';
       Move(ScArray3[1],MemW[$B800:0000],4000);
       Color(Bfn,Btx);
       GotoXY(36,6); Write(PushLeft(41,Titulo));
       ShowHeap;
       Color(Red,White);
       GotoXY(36,07); Write('Total de Contas: ');
       Color(Red,Yellow);
       GotoXY(53,07); Write(CMstMember.NContas);
       TitleConta;
       Color(Tfn,Utx);
       GotoXY(12,09); Write(PushLeft(19,J));
       ContaNumber := FileSize(ContaFile);
       KAnt := K;
       IncluiConta('E');
       K := KAnt;
       Move(ScArray6[1],MemW[$B800:0000],4000);
     end
     else begin
            ErroMsg := 'Esta Conta j  existe';
            ErrorMessage;
          end;
  TC := #23;
end;


Procedure EntryLancamento;
begin
  Pv1 := 'N';
  Repeat
    K := 1;
    Repeat
      Case K of
           1   : If Op = 'A' then
                    begin
                      Move(MemW[$B800:0000],ScArray5[1],4000);
                      DrawBox(47,14,57,17,Red,'S');
                      Color(Red,Cyan);
                      GotoXY(49,15); Write('tivo');
                      GotoXY(49,16); Write('ancelado');
                      Color(Red,White);
                      GotoXY(48,15); Write('A');
                      GotoXY(48,16); Write('C');
                      J := LctoMember.Status;
		      InputStr(J,1,12,15,0,'S','N','T','N',Tfn,Utx);
                      LctoMember.Status := UpCase(J[1]);
                      If TC <> #27 then
                         begin
                           If (LctoMember.Status <> 'A') and
                              (LctoMember.Status <> 'C') then
                              begin
                                ErroMsg := 'Status Inv lido (A ou C)';
                                ErrorMessage;
                                K := K - 1;
                              end
                              else If LctoMember.Status = 'C' then K := 9;
                         end;
                      Move(ScArray5[1],MemW[$B800:0000],4000);
                      GotoXY(12,15); Case LctoMember.Status of
                                          'A' : Write('Ativo    ');
                                          'C' : Write('Cancelado');
                                          'R' : Write('Retirado ');
                                     end;
                    end
                    else TC := #13;
           2   : begin
                   Color(Blue,White);
                   GotoXY(01,23); Write(ConstStr(' ',80));
                   GotoXY(02,23); Write('C¢digo Reduzido');
                   GotoXY(30,23); Write('Enter');
                   GotoXY(52,23); Write('C¢digo da Conta');
                   Color(Blue,Cyan);
                   GotoXY(18,23); Write('da Conta ou ');
                   GotoXY(36,23); Write('para Informar o ');
                   Color(Tfn,Utx);
                   GotoXY(12,16); Write(' ':50);
                   J := '';
		   InputStr(J,4,12,16,0,'S','N','T','N',Tfn,Utx);
                   LimpaLn(23,Tfd);
                   If (TC = #13) and (J <> '') then
                      begin
                        Val(J,ContaNumber,E);
                        ReadWrite(#03,'R','N',ContaNumber);
                        If RW = 'S' then
                           begin
                             ReadWrite(#06,'R','N',ContaNumber);
                             ContaDB := ContaMember.OrigConta;
                             If (ContaMember.Tipo  = 'A') and
                                (SaldMember.Status = 'A')then
                                begin
                                  If ((ContaMember.Aceita = 'D') and (ContaMember.Tipo = 'C')) or
                                     ((ContaMember.Aceita = 'C') and (ContaMember.Tipo = 'D')) then
                                     begin
                                       ErroMsg := 'A Conta '+ContaMember.OrigConta+
                                                  ' s¢ aceita '+ContaMember.Aceita;
                                       ErrorMessage;
                                       K := K - 1;
                                     end
                                     else ContaNo := LimpaChave(ContaMember.OrigConta);
                                end
                                else begin
                                       ErroMsg := 'A Conta '+ContaMember.OrigConta+
                                                  ' n„o ‚ anal¡tica ou esta Desativada';
                                       ErrorMessage;
                                       K := K - 1;
                                     end;
                           end
                           else begin
                                  ErroMsg   := 'Conta a d‚bito n„o Existe';
                                  ErrorMessage;
                                  K := K - 1;
                                end;
                      end
                      else begin
                             Color(Tfn,Utx);
                             GotoXY(12,16); Write(' ':50);
                           end;
                 end;
           3   : begin
                   Color(Blue,White);
                   GotoXY(01,23); Write(ConstStr(' ',80));
                   GotoXY(02,23); Write('F1');
                   GotoXY(28,23); Write('F2');
                   Color(Blue,Cyan);
                   GotoXY(05,23); Write('para pesquisar Contas,');
                   GotoXY(31,23); Write('para repetir £ltima Conta.');
                   Color(Red,White);
                   GotoXY(01,24); Write(ConstStr(' ',80));
                   GotoXY(02,24); Write('F3');
                   Color(Red,Cyan);
                   GotoXY(05,24); Write('para incluir Contas');
                   Color(Tfn,Utx);
                   GotoXY(12,16); Write(' ':50);
                   J := ContaDB;
		   InputStr(J,18,12,16,0,'S','N','T','N',Tfn,Utx);
                   If TC = #22 then
                      begin
                        J  := Conta1;
                        TC := #13;
                      end
                      else If J <> '' then ContaDB := J;
                   LimpaLn(23,Tfd);
                   LimpaLn(24,Tfd);
                   Case TC of
                        #13 : If J <> '' then
                                 begin
                                   ContaNo := LimpaChave(J);
                                   SearchTree1 ( Root1 );
                                   If RC = 'S' then
                                      begin
                                        ReadWrite(#03,'R','N',ContaNumber);
                                        ReadWrite(#06,'R','N',ContaNumber);
                                        ContaDB := ContaMember.OrigConta;
                                        If (ContaMember.Tipo  = 'A') and
                                           (SaldMember.Status = 'A')then
                                           begin
                                             If ((ContaMember.Aceita = 'D') and (ContaMember.Tipo = 'C')) or
                                                ((ContaMember.Aceita = 'C') and (ContaMember.Tipo = 'D')) then
                                                begin
                                                  ErroMsg := 'Esta Conta s¢ aceita ' +
                                                             ContaMember.Aceita;
                                                  ErrorMessage;
                                                  K := K - 1;
                                                end
                                                else begin
                                                       Pv1 := ContaMember.PedeDepto;
                                                       GotoXY(12,16);
                                                       Write(ContaDB,' ',
                                                             Copy(ContaMember.Descricao,1,30));
                                                       If Op = 'A' then
                                                          begin
                                                            Color(Tfn,Utx);
                                                            GotoXY(12,17); Write(' ':50);
                                                            ContaCR := '';
                                                          end;
                                                       Conta1 := ContaDB;
                                                     end;
                                           end
                                           else begin
                                                  ErroMsg := 'Ou esta Desativada ou n„o ‚ anal¡tica';
                                                  ErrorMessage;
                                                  K := K - 1;
                                                end;
                                      end
                                      else begin
                                             ErroMsg   := 'Conta a d‚bito n„o Existe';
                                             ErrorMessage;
                                             K := K - 1;
                                           end;
                                 end
                                 else begin
                                        Color(Tfn,Utx);
                                        GotoXY(12,16); Write(' ':50);
                                      end;
                        #21 : begin
                                ContaAC := LimpaChave(J);
                                ContaNo := ContaAC;
                                ScrollConta('C');
                                ContaDB := ContaAC;
                              end;
                        #23 : If J <> '' then IncluiContaE;
                        #27 : If (Op      = 'A') and
                                 (ContaDB = '' ) and
                                 (ContaCR = '' ) then
                                 begin
                                   TC      := #13;
                                   ErroMsg := 'Tem que haver uma Conta ?';
                                   ErrorMessage;
                                   K := K - 1;
                                 end;
                   end;
                 end;
           4   : If (Op  = 'I') or
                    ((Op = 'A') and (ContaDB = '')) then
                    begin
                      Color(Blue,White);
                      GotoXY(01,23); Write(ConstStr(' ',80));
                      GotoXY(02,23); Write('C¢digo Reduzido');
                      GotoXY(30,23); Write('Enter');
                      GotoXY(52,23); Write('C¢digo da Conta');
                      Color(Blue,Cyan);
                      GotoXY(18,23); Write('da Conta ou ');
                      GotoXY(36,23); Write('para Informar o ');
                      Color(Tfn,Utx);
                      GotoXY(12,17); Write(' ':50);
                      J := '';
		      InputStr(J,4,12,17,0,'S','N','T','N',Tfn,Utx);
                      LimpaLn(23,Tfd);
                      If (TC = #13) and (J <> '') then
                         begin
                           Val(J,ContaNumber,E);
                           ReadWrite(#03,'R','N',ContaNumber);
                           If RW = 'S' then
                              begin
                                ReadWrite(#06,'R','N',ContaNumber);
                                ContaCR := ContaMember.OrigConta;
                                If (ContaMember.Tipo  = 'A') and
                                   (SaldMember.Status = 'A')then
                                   begin
                                     If ((ContaMember.Aceita = 'D') and (ContaMember.Tipo = 'C')) or
                                        ((ContaMember.Aceita = 'C') and (ContaMember.Tipo = 'D')) then
                                        begin
                                          ErroMsg := 'A Conta '+ContaMember.OrigConta+
                                                     ' s¢ aceita '+ContaMember.Aceita;
                                          ErrorMessage;
                                          K := K - 1;
                                        end
                                        else ContaNo := LimpaChave(ContaMember.OrigConta);
                                   end
                                   else begin
                                          ErroMsg := 'A Conta '+ContaMember.OrigConta+
                                                     ' n„o ‚ anal¡tica ou esta Desativada';
                                          ErrorMessage;
                                          K := K - 1;
                                        end;
                              end
                              else begin
                                     ErroMsg   := 'Conta a cr‚dito n„o Existe';
                                     ErrorMessage;
                                     K := K - 1;
                                   end;
                         end
                         else begin
                                Color(Tfn,Utx);
                                GotoXY(12,17); Write(' ':50);
                              end;
                 end;
           5   : If (Op  = 'I') or
                    ((Op = 'A') and (ContaDB = '')) then
                    begin
                      Color(Blue,White);
                      GotoXY(01,23); Write(ConstStr(' ',80));
                      GotoXY(02,23); Write('F1');
                      GotoXY(28,23); Write('F2');
                      Color(Blue,Cyan);
                      GotoXY(05,23); Write('para pesquisar Contas,');
                      GotoXY(31,23); Write('para repetir £ltima Conta.');
                      Color(Red,White);
                      GotoXY(01,24); Write(ConstStr(' ',80));
                      GotoXY(02,24); Write('F3');
                      Color(Red,Cyan);
                      GotoXY(05,24); Write('para incluir Contas');
                      Color(Tfn,Utx);
                      GotoXY(12,17); Write(' ':50);
                      J := ContaCR;
		      InputStr(J,18,12,17,0,'S','N','T','N',Tfn,Utx);
                      If TC = #22 then
                         begin
                           J  := Conta2;
                           TC := #13;
                         end
                         else If J <> '' then ContaCR := J;
                      LimpaLn(23,Tfd);
                      LimpaLn(24,Tfd);
                      Case TC of
                           #13 : If J <> '' then
                                    begin
                                      ContaNo := LimpaChave(J);
                                      SearchTree1 ( Root1 );
                                      If RC = 'S' then
                                         begin
                                           ReadWrite(#03,'R','N',ContaNumber);
                                           ReadWrite(#06,'R','N',ContaNumber);
                                           ContaCR := ContaMember.OrigConta;
                                           If (ContaMember.Tipo  = 'A') and
                                              (SaldMember.Status = 'A') then
                                              begin
                                                If ((ContaMember.Aceita = 'D') and (ContaMember.Tipo = 'C')) or
                                                   ((ContaMember.Aceita = 'C') and (ContaMember.Tipo = 'D')) then
                                                   begin
                                                     ErroMsg := 'Esta Conta s¢ aceita ' +
                                                                ContaMember.Aceita;
                                                     ErrorMessage;
                                                     K := K - 1;
                                                   end
                                                   else begin
                                                          Pv2 := ContaMember.PedeDepto;
                                                          GotoXY(12,17);
                                                          Write(ContaCR,' ',
                                                                Copy(ContaMember.Descricao,1,30));
                                                          Conta2 := ContaCR;
                                                        end;
                                              end
                                              else begin
                                                     ErroMsg := 'Ou esta Desativada ou n„o ‚ anal¡tica';
                                                     ErrorMessage;
                                                     K := K - 1;
                                                   end;
                                         end
                                         else begin
                                                ErroMsg   := 'Conta a cr‚dito n„o Existe';
                                                ErrorMessage;
                                                K := K - 1;
                                              end;
                                    end
                                    else begin
                                           Color(Tfn,Utx);
                                           GotoXY(12,17); Write(' ':50);
                                         end;
                           #21 : begin
                                   ContaAC := LimpaChave(J);
                                   ContaNo := ContaAC;
                                   ScrollConta('C');
                                   ContaCR := ContaAC;
                                 end;
                           #23 : If J <> '' then IncluiContaE;
                           #27 : If (Op      = 'A') and
                                    (ContaDB = '' ) and
                                    (ContaCR = '' ) then
                                    begin
                                      TC      := #13;
                                      ErroMsg := 'Tem que haver uma Conta ?';
                                      ErrorMessage;
                                      K := K - 1;
                                    end;
                      end;
                    end
                    else begin
                           Color(Tfn,Utx);
                           GotoXY(12,17); Write(' ':50);
                         end;
           6   : If (ContaDB = '' ) and
                    (ContaCR = '' ) then
                    begin
                      ErroMsg := 'Tem que haver uma Conta ?';
                      ErrorMessage;
                      K  := K - 1;
                      TC := #24;
                    end;
           7   : begin
                   If LctoMember.Valor = 0 then J := ''
                      else begin
                             Str(LctoMember.Valor:11:2,J);
                             J := LeftAdjust(J);
                           end;
                   GotoXY(12,18); Write('                ');
		   InputStr(J,12,12,18,0,'S','N','T','N',Tfn,Utx);
                   If TC <> #27 then
                      begin
                        Val(J,LctoMember.Valor,E);
                        If LctoMember.Valor = 0 then
                           begin
                             ErroMsg := 'Valor do lan‡amento Inv lido';
                             ErrorMessage;
                             K := K - 1;
                           end
                           else begin
                                  GotoXY(12,18);
                                  Write(EditDouble(LctoMember.Valor):14);
                                end;
                      end;
                 end;
           8   : begin
                   Color(Blue,White);
                   GotoXY(1,23); Write(ConstStr(' ',80));
                   GotoXY(2,23); Write('F1');
                   Color(Blue,Cyan);
                   GotoXY(5,23); Write('para pesquisar Departamentos');
                   Color(Red,White);
                   GotoXY(1,24); Write(ConstStr(' ',80));
                   GotoXY(2,24); Write('F3');
                   Color(Red,Cyan);
                   GotoXY(5,24); Write('para incluir Departamentos');
                   J := LctoMember.Depto;
		   InputStr(J,6,48,18,0,'S','N','T','N',Tfn,Utx);
                   LctoMember.Depto := J;
                   LimpaLn(23,Tfd);
                   LimpaLn(24,Tfd);
                   Case TC of
                        #13 : If J <> '' then
                                 begin
                                   DeptNo := LimpaChave(J);
                                   SearchTree3 ( Root3 );
                                   If RC = 'N' then
                                      begin
                                        ErroMsg := 'Departamento n„o Existe';
                                        ErrorMessage;
                                        K := K - 1;
                                      end
                                      else begin
                                             ReadWrite(#05,'R','N',DeptNumber);
                                             If DeptMember.Status = 'D' then
                                                begin
                                                  ErroMsg := 'Departamento est  ' +
                                                             'Desativado';
                                                  ErrorMessage;
                                                  K := K - 1;
                                                end
                                                else begin
                                                       LctoMember.Depto := DeptMember.OrigChave;
                                                       GotoXY(48,18);
                                                       Write(PushLeft(7,LctoMember.Depto));
                                                     end;
                                           end;
                                 end
                                 else If (Pv1 = 'S' ) and
                                         (Pv2 = 'S' ) then
                                         begin
                                           ErroMsg := 'Conta pede Departamento';
                                           ErrorMessage;
                                           K := K - 1;
                                         end;
                        #21 : begin
                                DeptNo := LimpaChave(J);
                                DeptAC := DeptNo;
                                ScrollDept;
                                LctoMember.Depto := DeptAC;
                              end;
                        #23 : begin
                                DeptNo := LimpaChave(J);
                                SearchTree3 ( Root3 );
                                If RC = 'N' then
                                   begin
                                     Move(MemW[$B800:0000],ScArray6[1],4000);
                                     Titulo := 'Departamentos (Inclus„o)               ';
                                     Move(ScArray3[1],MemW[$B800:0000],4000);
                                     Color(Blue,White);
                                     GotoXY(36,6); Write(Titulo);
                                     ShowHeap;
                                     Color(Red,White);
                                     GotoXY(36,7); Write('Total de Deptos: ');
                                     Color(Red,Yellow);
                                     GotoXY(53,7); Write(CMstMember.NDeptos);
                                     TitleDept;
                                     Color(Tfn,Utx);
                                     GotoXY(12,09); Write(PushLeft(7,J));
                                     DeptNumber := FileSize(DeptFile);
                                     KAnt       := K;
                                     IncluiDept('E');
                                     K := KAnt;
                                     Move(ScArray6[1],MemW[$B800:0000],4000);
                                   end
                                   else begin
                                          ErroMsg := 'Este Depto. j  existe';
                                          ErrorMessage;
                                        end;
                                TC := #23;
                              end;
                   end;
                 end;
           9..11   : begin
                       Color(Red,Cyan);
                       GotoXY(1,23);  Write(ConstStr(' ',80));
                       GotoXY(5,23);
                       Write('para pesquisar o Hist¢rico Padr„o ou digite ',
                             'o        e em seguida   .');
                       Color(Red,Yellow);
                       GotoXY(02,23); Write('F1');
                       GotoXY(51,23); Write('C¢digo');
                       GotoXY(71,23); Write('F2');
                       Color(Blue,Cyan);
                       GotoXY(1,24); Write(ConstStr(' ',80));
                       GotoXY(2,24); Write('Para n„o repetir o Hist¢rico anterior ',
                                           'digite <-> (menos).');
                       Color(Blue,White);
                       GotoXY(48,24); Write('-');
                       J  := LctoMember.Historico[K-8];
                       Hl := Length(J);
		       InputStr(J,60,4,(K+10),Hl,'S','S','T','N',Tfn,Utx);
                       LimpaLn(23,Tfd);
                       LimpaLn(24,Tfd);
                       Case TC of
                            #13 : If (J = '') and (HistY[K-8] <> '') then
                                     begin
                                       LctoMember.Historico[K-8] := HistY[K-8];
                                       TC := #000;
                                     end
                                     else begin
                                            If J[1] = '-' then Delete(J,1,1);
                                            LctoMember.Historico[K-8] := J;
                                            HistY[K-8]                := J;
                                          end;
                            #21 : begin
                                    HHNo := '';
                                    HHAC := '';
                                    ScrollHsPd;
                                    HHNo     := HHAC;
                                    HHNumber := HHAN;
                                    If HHAC <> '' then
                                       begin
                                         ReadWrite(#10,'R','N',HHNumber);
                                         If RW = 'S' then
                                            begin
                                              LctoMember.Historico[K-8] := HsPdMember.Descricao;
                                              TC                        := #000;
                                            end;
                                       end;
                                  end;
                            #22 : begin
                                    HHNo := UpCaseStr(J);
                                    SearchTree8 ( Root8 );
                                    If RC = 'S' then
                                       begin
                                         ReadWrite(#10,'R','N',HHNumber);
                                         If RW = 'S'
                                            then LctoMember.Historico[K-8] := HsPdMember.Descricao
                                            else begin
                                                   ErroMsg := 'Hist¢rico Padr„o n„o Existe';
                                                   ErrorMessage;
                                                 end;
                                       end
                                       else begin
                                              ErroMsg := 'Hist¢rico Padr„o n„o Existe';
                                              ErrorMessage;
                                            end;
                                    TC := #000;
                                  end;
                       end;
                       For I := 1 to 2 do
                       begin
                         If LctoMember.Historico[1] = '' then
                            begin
                              LctoMember.Historico[1] := LctoMember.Historico[2];
                              LctoMember.Historico[2] := LctoMember.Historico[3];
                              LctoMember.Historico[3] := '';
                            end
                            else If LctoMember.Historico[2] = '' then
                                    begin
                                      LctoMember.Historico[2] := LctoMember.Historico[3];
                                      LctoMember.Historico[3] := '';
                                    end;
                       end;
                       GotoXY(4,19); Write(PushLeft(61,LctoMember.Historico[1]));
                       GotoXY(4,20); Write(PushLeft(61,LctoMember.Historico[2]));
                       GotoXY(4,21); Write(PushLeft(61,LctoMember.Historico[3]));
                       If TC = #000 then
                          begin
                            TC := #13;
                            K  := K - 1;
                          end;
                     end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 12) or (TC = #27);
    If ((TC <> #27) and (Op = 'I')) or (Op = 'A') then Confirma;
  Until TC in ['S',#27];
end;


Procedure PreparaTelaLancamento;
begin
  FrameHsPd;
  Color(Tfn,Ttx);
  GotoXY(04,09);  Write('Lote..:');
  GotoXY(04,10);  Write('Mˆs...:');
  GotoXY(04,11);  Write('Status:');
  GotoXY(35,11);  Write('Digit.:');
  GotoXY(04,12);  Write('Descr.:');
  GotoXY(35,12);  Write('Dia...:');
  GotoXY(04,14);  Write('N§Lanc:');
  With LoteMember do
  begin
    Color(Tfn,Utx);
    GotoXY(12,09); Write(PushLeft(7,Chave));
    GotoXY(12,10); Write(' ':15);
    GotoXY(12,10);
    If MesContabil < 10
       then Write('0',MesContabil,' (',ArrayMesEx[MesContabil],
                  ' de ',AnoContabil:4,')')
       else Write(MesContabil:2,' (',ArrayMesEx[MesContabil],
                                ' de ',AnoContabil,')');
    GotoXY(12,11); Case Status of
                        'A' : Write('Ativo    ');
                        'C' : Write('Cancelado');
                   end;
    GotoXY(43,11); Write(DataAbert);
    GotoXY(12,12); Write(Descricao);
  end;
  TelaTotalDoLote;
  Color(Tfn,Ttx);
  GotoXY(04,15);  Write('Status:');
  GotoXY(04,16);  Write('D‚bito:');
  GotoXY(04,17);  Write('Cr‚dit:');
  GotoXY(04,18);  Write('Valor.:');
  GotoXY(40,18);  Write('Depto.:');
  Color(Tfn,Utx);
end;


Procedure ScreenLancamento;
begin
  With LctoMember do
  begin
    Color(Tfn,Utx);
    GotoXY(43,12); Write(Copy(OrigData,1,2),' de ',ArrayMesEx[MM]);
    Color(Tfn,Ttx);
    GotoXY(18,14);
    If Op = 'I' then Write(#27,'- Incluindo')
                else Write(#27,'- Alterando');
    Color(Tfn,Utx);
    GotoXY(12,15); Case Status of
                        'A' : Write('Ativo    ');
                        'C' : Write('Cancelado');
                        'R' : Write('Retirado ');
                   end;
    ContaDB := '';
    ContaCR := '';
    Case Tipo of
         'D' : begin
                 GotoXY(12,16);
                 ContaDB := Conta;
               end;
         'C' : begin
                 GotoXY(12,17);
                 ContaCR := Conta;
               end;
    end;
    If Conta <> '' then
       begin
         ContaNo := LimpaChave(Conta);
         SearchTree1 ( Root1 );
         If RC = 'S' then
            begin
              ReadWrite(#03,'R','N',ContaNumber);
              Conta := ContaMember.OrigConta;
              Write(Conta,' ',Copy(ContaMember.Descricao,1,30));
              Case Tipo of
                   'D' : ContaDB := Conta;
                   'C' : ContaCR := Conta;
              end;
            end;
       end;
    GotoXY(12,18);
    If Valor > 0 then Write(EditDouble(Valor):14)
                 else Write(' ':15);
    If Depto <> '' then
       begin
         GotoXY(48,18);
         DeptNo := LimpaChave(Depto);
         SearchTree3 ( Root3 );
         If RC = 'S' then
            With DeptMember do
            begin
              ReadWrite(#05,'R','N',DeptNumber);
              Depto := OrigChave;
              Write(Pushleft(7,Depto));
            end;
       end;
    GotoXY(4,19);  Write(Historico[1]);
    GotoXY(4,20);  Write(Historico[2]);
    GotoXY(4,21);  Write(Historico[3]);
  end;
  TotalDoLote;
end;


