{$O+,F+}
Unit PlogRpot;

Interface

Uses Crt,Dos,PlogGlbs,PlogBasP,PlogTree,PlogRpt0,PlogRpt1,
             PlogRpt2,PlogRpt3,PlogRpt4,PlogRpt5,PlogRpt6,
             PlogRpt7,PlogRpt8;


   Procedure SelectReport;


Implementation

Procedure FrameReport;
Var
  I  : integer;
begin
  Color(Tfd,Utx);
  For I := 6 to 24 do LimpaLn(I,Tfd);
  DrawBox(36,8,77,20,Tfn,'S');
  DrawBox(2,9,44,21,Tfn,'S');
  DrawBox(64,23,78,23,Red,'N');
  Color(Red,White);
  GotoXY(64,23); Write('  Esc          ');
  Color(Red,Yellow);
  GotoXY(70,23); Write(#26,' Retorna ');
  Color(Bfn,Btx);
  GotoXY(2,7);  Write(' Relat¢rios ',#26' ',XPrinter,' ');
  Color(Tfn,Utx);
end;


Procedure TitleReport1;
begin
  For I := 1 to 11 do begin
                        If (TabY4[I] = Y1 ) and
                           (X1        < 45) then Color(Sfn,Stx)
                                            else Color(Tfn,Ttx);
                        GotoXY(2,TabY4[I]);  Write(Tab4[I]);
                      end;
  Color(Tfn,Ttx);
end;


Procedure TitleReport2;
Var
  W : Char;
begin
  For I := 1 to 11 do begin
			If (TabY5[I] = Y1 ) and
			   (X1        > 44) then Color(Sfn,Stx)
					    else Color(Tfn,Ttx);
			GotoXY(45,TabY5[I]);  Write(Tab5[I]);
                        If ((TabY5[I] <> Y1) or (X1 < 45)) and (TabY5[I] > 9) then
                           begin
                             Color(Black,LightGray);
                             Move(Mem[$B800:((TabY5[I]-1)*160)+88],W,1);
                             GotoXY(45,TabY5[I]); Write(W);
                             Move(Mem[$B800:((TabY5[I]-1)*160)+90],W,1);
                             GotoXY(46,TabY5[I]); Write(W);
                           end;
		      end;
  Color(Tfn,Ttx);
end;


Procedure Rodape;
begin
  Color(Red,Cyan);
  GotoXY(1,24); Write(' ':80);
  GotoXY(2,24); Write('Quer a Marca da Autora no final da p gina a direita?   im ou  Æo');
  Color(Red,White);
  GotoXY(56,24); Write('S');
  GotoXY(63,24); Write('N');
  Repeat
    Foot := UpCase(ReadKey);
  Until Foot in ['S','N',#13,#27];
  If Foot = #13 then Foot := 'N';
  LimpaLn(24,Tfd);
end;


Procedure OrdemReport;
begin
  Color(Red,Cyan);
  GotoXY(1,24); Write(' ':80);
  GotoXY(2,24); Write('Listar em ordem  lfab‚tica ou  um‚rica?');
  Color(Red,White);
  GotoXY(18,24); Write('A');
  GotoXY(32,24); Write('N');
  Repeat
    Tr := UpCase(ReadKey);
  Until Tr in ['A','N',#13,#27];
  If Tr = #13 then Tr := 'A';
  LimpaLn(24,Tfd);
end;


Procedure ProcessReport;
Var
  EtapaAnt        : Char;
begin
  ContLin   := 10000;
  ContPag   := 0;
  Titulo    := '';
  Case ProcNo of
       01 : Titulo := 'Tabelas                                ';
       02 : Titulo := 'Cadastro/Planilha de Movimento         ';
       03 : Titulo := 'Rela‡Æo de Empregados/Textos diversos  ';
       04 : Titulo := 'Folha de Pagamentos/List.de Conferˆncia';
       05 : Titulo := 'Recibo de Pagamento (Contra-Cheque)    ';
       06 : Titulo := 'Rel.Banc ria/Dinheiro/EmissÆo de Cheque';
       07 : Titulo := 'Sele‡Æo de Contas                      ';
       08 : Titulo := 'Rela‡Æo de I.N.S.S.                    ';
       09 : Titulo := 'Contribui‡Æo Sindical/GRCS             ';
       10 : Titulo := 'Admitidos e Demitidos no Mˆs (CAGED)   ';
       11 : Titulo := 'Ficha Financeira (Mens./Acumulado)     ';
       12 : Titulo := 'Totaliza‡Æo da Folha de Pagamentos     ';
       13 : Titulo := 'Guia de Recolhimento (G.R.P.S.)        ';
       14 : Titulo := 'Relat¢rio FGTS (GFip) ou Guia (GR)     ';
       15 : Titulo := 'I.R.F. (Imp.de Renda na Fonte)/DARF    ';
       16 : Titulo := 'Etiquetas (CartÆo de Ponto/Correspond) ';
       17 : Titulo := 'Quadro de Hor rio de Trabalho          ';
       18 : Titulo := 'Folha de Pagamento Sint‚tica           ';
       19 : Titulo := 'Rela‡Æo/Recibo de Vale transporte      ';
       20 : Titulo := 'Totaliza‡Æo de Vale Transporte         ';
       21 : Titulo := 'F‚rias Vencidas/Programa‡Æo de F‚rias  ';
       22 : Titulo := 'Relat¢rios Auxiliares (Use as setas '+#24+#25+')';
  end;
  If Titulo <> '' then
     begin
       BuildFrame('S');
       Color(Red,Yellow);
       GotoXY(35,07); Write(' Configurado para:');
       Color(Red,White);
       GotoXY(54,07); Write(XPrinter);
       Color(Tfn,Utx);
       T := 80;
       If CMstMember.Etapa = 'X' then
          begin
            EtapaAnt         := CMstMember.Etapa;
            CMstMember.Etapa := 'P';
          end
          else EtapaAnt := ' ';
       UltimaEtapa;
       If (ProcNo <> 05) and
          (ProcNo <> 10) and
          (ProcNo <> 13) and
          (ProcNo <> 14) and
          (ProcNo <> 16) then
          begin
            Rodape;
            If Foot = #27 then
               begin
                 ProcNo := 0;
                 TC     := #27;
               end;
          end
          else Foot := 'N';
       If (ProcNo = 01) or
          (ProcNo = 02) or
          (ProcNo = 03) or
          (ProcNo = 04) or
          (ProcNo = 05) or
          (ProcNo = 06) or
          (ProcNo = 07) or
          (ProcNo = 09) or
          (ProcNo = 14) or
          (ProcNo = 16) or
          (ProcNo = 17) or
	  (ProcNo = 18) or
	  (ProcNo = 19) or
          (ProcNo = 21) or
	  (ProcNo = 22) then
          begin
            OrdemReport;
            If Tr = #27 then
               begin
                 ProcNo := 0;
                 TC     := #27;
               end;
          end
          else Tr := 'N';
       If ProcNo <> 0 then
          begin
            QPorta;
            If TC = #27 then ProcNo := 0
                        else Inicializa(DskRpt);
          end;
       L1  := '';
       L2  := '';
       L3  := '';
       L4  := '';
       L5  := '';
       L6  := '';
       L7  := '';
       L8  := '';
       L9  := '';
       L10 := '';
       NCont := 0;
       NoMat := 'S';
       Case ProcNo of
            01     : ProcNo01Report;
            02     : ProcNo02Report;
            03     : ProcNo03Report;
            04     : ProcNo04Report;
            05     : ProcNo05Report;
            06     : ProcNo06Report;
            07     : ProcNo07Report;
            08     : ProcNoXXReport('N');
            09     : ProcNo09Report;
            10     : begin
                       Color(Red,Cyan);
                       GotoXY(1,24); Write(' ':80);
                       GotoXY(2,24); Write('Imprimir ou gerar Disco do CAGED');
                       Color(Red,White);
                       GotoXY(02,24); Write('I');
                       GotoXY(20,24); Write('D');
                       TC := ' ';
                       Repeat
                         TC := UpCase(ReadKey);
                       Until TC in ['I','D',#27];
                       LimpaLn(24,Tfd);
                       Case TC of
                            'I' : ProcNoXXReport('N');
                            'D' : ProcNoXXReport('S');
                       end;
                     end;
            11..12 : ProcNoXXReport('N');
            13     : ProcNo13Report;
            14     : begin
                       Color(Red,Cyan);
                       GotoXY(1,24); Write(' ':80);
                       GotoXY(2,24); Write('Relat¢rio do FGTS (GFip) ou Guia');
                       Color(Red,White);
                       GotoXY(15,24); Write('F');
                       GotoXY(30,24); Write('G');
                       TC := ' ';
                       Repeat
                         TC := UpCase(ReadKey);
                       Until TC in ['F','G',#27];
                       LimpaLn(24,Tfd);
                       Case TC of
                            'F' : ProcNo14Report('1');
                            'G' : ProcNo14Report('2');
                       end;
                     end;
            15     : ProcNoXXReport('N');
            16     : ProcNoEEReport;
            17     : ProcNo17Report;
            18     : ProcNo18Report;
	    19     : ProcNo19Report;
	    20     : ProcNo20Report;
	    21     : ProcNo21Report;
            22     : ProcNo22Report;
       end;
       LimpaLn(23,Tfd);
       If (DskRpt = 'T') and (TC <> #27) then ScrollRpt
                                         else If ProcNo <> 0 then Close ( LST );
       If EtapaAnt <> ' ' then CMstMember.Etapa := EtapaAnt;
       If Root6 <> NIL then Dispose6 ( Root6 );
       Root6 := NIL;
     end;
  Resp := #13;
  Move(ScArray2[1],Mem[$B800:0000],4000);
end;


Procedure SelectReport;
begin
  Y1 := 10;
  X1 := 3;
  If VezR = 'S' then
     begin
       VezR := 'N';
       FrameReport;
       TitleReport1;
       TitleReport2;
       Move(Mem[$B800:0000],ScArray2[1],4000);
     end
     else Move(ScArray2[1],Mem[$B800:0000],4000);
  Pg1 := 1;
  Repeat
    Resp   := UpCase(ReadKey);
    ProcNo := 99;
    If (Resp = #0 ) and
       (KeyPressed) then
       begin
         Resp := ReadKey;
         Case Resp of
              #72 : begin
                      Y1 := Y1 - 1;
                      Case Pg1 of
                           1 : begin
                                 If Y1 < 10 then Y1 := 20;
                                 TitleReport1;
                               end;
                           2 : begin
				 If Y1 < 09 then Y1 := 19;
                                 TitleReport2;
                               end;
                      end;
                    end;
              #80 : begin
                      Y1 := Y1 + 1;
                      Case Pg1 of
                           1 : begin
                                 If Y1 > 20 then Y1 := 10;
                                 TitleReport1;
                               end;
                           2 : begin
				 If Y1 > 19 then Y1 := 09;
                                 TitleReport2;
                               end;
                      end;
                    end;
              #75 : If Pg1 > 1 then
                       begin
                         Pg1 := 1;
                         X1  := 3;
                         Y1  := 10;
                         TitleReport1;
                         TitleReport2;
                       end;
              #77 : If Pg1 = 1 then
                       begin
                         Pg1 := 2;
                         X1  := 46;
                         Y1  := 09;
                         TitleReport1;
                         TitleReport2;
                       end;
         end;
       end
       else begin
              Case Resp of
                   #13 : begin
                           Case Pg1 of
                                1 : ProcNo := Y1 - 9;
                                2 : ProcNo := Y1 + 3;
                           end;
                           Move(MemW[$B800:0000],ScArray5[1],4000);
                           If ProcNo <> 99 then
                              begin
                                ProcessReport;
                                Move(ScArray5[1],MemW[$B800:0000],4000);
                              end;
                           TC := #00;
                         end;
                   #27 : TC := #27;
              end;
            end;
  Until TC = #27;
  TC   := #13;
  Resp := #13;
end;

end.