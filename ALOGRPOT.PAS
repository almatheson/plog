{$O+,F+}
Unit AlogRpot;

Interface

Uses Crt,Dos,AlogGlbs,AlogNavg,AlogBasP,AlogInit,AlogRpt0,AlogRpt1,AlogRpt2,AlogRpt3;


   Procedure SelectReport;


Implementation

Var
  Don,Dof,Con,Cof,Non,Nof : Str10;


Procedure FrameReport;
Var
  I : integer;

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
  For I := 1 to 09 do begin
                        If (TabY4[I] = Y1 ) and
                           (X1        < 45) then Color(Bfn,Btx)
                                            else Color(Tfn,Ttx);
                        GotoXY(2,TabY4[I]);  Write(Tab4[I]);
                      end;
  Color(Tfn,Ttx);
end;


Procedure TitleReport2;
Var
  W : Char;
begin
  For I := 1 to 08 do begin
			If (TabY5[I] = Y1 ) and
			   (X1        > 44) then Color(Bfn,Btx)
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
  GotoXY(2,24); Write('Quer a Marca da Autora no final da p gina a direita?   im ou  „o');
  Color(Red,White);
  GotoXY(56,24); Write('S');
  GotoXY(63,24); Write('N');
  Repeat
    Foot := UpCase(ReadKey);
  Until Foot in ['S','N',#13,#27];
  LimpaLn(24,Tfd);
  If Foot = #13 then Foot := 'S';
end;


Procedure TamanhoReport;
Var
  Tx             : Char;
begin
  BuildFrame('S');
  Color(Red,Yellow);
  GotoXY(35,07); Write(' Configurado para:');
  Color(Red,White);
  GotoXY(54,07); Write(XPrinter);
  Color(Tfn,Utx);
  Color(Red,Cyan);
  GotoXY(1,24); Write(' ':80);
  GotoXY(2,24); Write('Quer listar em  0 ou  32 colunas ?    ');
  Color(Red,White);
  GotoXY(17,24); Write('8');
  GotoXY(23,24); Write('1');
  TC := ' ';
  Repeat
    Tx := ReadKey;
  Until Tx in ['1','8',#13,#27];
  LimpaLn(24,Tfd);
  If Tx = #13 then Tx := '8';
  Don := Dx;
  Dof := Df;
  Con := Cx;
  Cof := Cf;
  Non := Nx;
  Nof := Nf;
  Case Tx of
       '1' : begin
               If Laser = 'S' then
                  begin
                    Dx := Dx;
                    Df := Cx;
                    Cx := Cx;
                    Cf := Cx;
                    Nx := Cx;
                    Nf := Cx;
                  end;
               T         := 132;
               LaserInit := #27+'E'+#27+'&l1O'+#27+'&l8D'+#27+'&u17D';
             end;
       '8' : begin
               T         := 80;
               LaserInit := #27+'E';
             end;
       else  begin
               ProcNo    := 0;
               LaserInit := #27+'E';
             end;
  end;
  If ProcNo <> 0 then
     begin
       Rodape;
       If Foot = #27 then ProcNo := 0;
     end;
  If (ProcNo =  7) or
     (ProcNo =  9) or
     (ProcNo = 10) then
     begin
       XMo := 'N';
       NMo := '';
       VMo := 0;
       Color(Blue,Cyan);
       GotoXY(1,24); Write(' ':80);
       GotoXY(2,24); Write('Nome e valor da moeda estrangeira :                         ');
       Repeat
         K := 1;
         Repeat
           Case K of
                1   : begin
                        J := NMo;
		        InputStr(J,6,38,24,0,'S','S','T','N',Blue,White);
                        If TC <> #27 then
                           begin
                             NMo := J;
                             If NMo = '' then
                                begin
                                  GotoXY(38,24); Write('Em CR$');
                                  XMo := 'N';
                                  VMo := 1;
                                  K   := 2;
                                end;
                           end;
                      end;
                2   : begin
                        If VMo = 0 then J := ''
                                   else begin
                                          Str(VMo:12:2,J);
                                          J := LeftAdjust(J);
                                        end;
                        InputStr(J,12,50,24,0,'S','N','T','N',Blue,Yellow);
                        If TC <> #27 then
                           begin
                             If J = '' then
                                begin
                                  VMo := 1;
                                  NMo := '';
                                  GotoXY(38,24); Write('Em CR$');
                                  XMo := 'N';
                                end
                                else begin
                                       Val(J,VMo,E);
                                       XMo := 'S';
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
       LimpaLn(24,Tfd);
       If TC = #27 then ProcNo := 0;
     end
     else XMo := 'N';
end;


Procedure ProcessReport;
begin
{  LaserInit := #27+'E'; }
  ContLin   := 1000;
  ContPag   := 0;
  Titulo    := '';
  Case ProcNo of
       01 : Titulo := 'Plano de Contas                        ';
       02 : Titulo := 'Hist¢rico Padr„o                       ';
       03 : Titulo := 'Departamentos                          ';
       04 : Titulo := 'Indices Econ“micos                     ';
       05 : Titulo := 'Controle de Lotes                      ';
       06 : Titulo := 'Raz„o Anal¡tico                        ';
       07 : Titulo := 'Balancete                              ';
       08 : Titulo := 'Livro Di rio                           ';
       09 : Titulo := 'Balan‡o                                ';
       10 : Titulo := 'Apura‡„o de Resultados                 ';
       11 : Titulo := 'Or‡amento de Despesas                  ';
       12 : Titulo := 'Follow-Up de Despesas                  ';
       13 : Titulo := 'Movimento de Contas por Departamento   ';
       14 : Titulo := 'Tˆrmo de Abe/Encerr.(Raz„o ou Di rio)  ';
       15 : Titulo := 'Balancete Gerencial                    ';
       16 : Titulo := 'Balancete por Departamento (Rec/Desp)  ';
       17 : Titulo := 'Acompanhamento de Projeto              ';
  end;
  If Titulo <> '' then TamanhoReport;
  If ProcNo <> 0 then
     begin
       QPorta;
       If TC = #27 then ProcNo := 0
                   else Inicializa(DskRpt);
     end;
  Case ProcNo of
       01 : ProcNo01Report;
       02 : ProcNo02Report;
       03 : ProcNo03Report;
       04 : ProcNo04Report;
       05 : ProcNo05Report;
       06 : ProcNo06Report;
       07 : ProcNo07Report;
       08 : ProcNo08Report;
       09 : ProcNo09Report;
       10 : ProcNo10Report;
       11 : ProcNo11Report;
       12 : ProcNo11Report;
       13 : ProcNo13Report;
       14 : ProcNo14Report;
       15 : ProcNo15Report;
       16 : ProcNo11Report;
       17 : ProcNo11Report;
  end;
  LimpaLn(23,Tfd);
  If (DskRpt = 'T') and (TC <> #27) then ScrollRpt
                                    else Close ( LST );
  Resp := #13;
  Move(ScArray2[1],MemW[$B800:0000],4000);
end;



Procedure SelectReport;
begin
  Y1 := 11;
  X1 := 3;
  If VezR = 'S' then
     begin
       VezR := 'N';
       FrameReport;
       TitleReport1;
       TitleReport2;
       Move(MemW[$B800:0000],ScArray2[1],4000);
     end
     else Move(ScArray2[1],MemW[$B800:0000],4000);
  Pg1 := 1;
  Repeat
    Resp   := ReadKey;
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
                                 If Y1 < 11 then Y1 := 19;
                                 TitleReport1;
                               end;
                           2 : begin
                                 If Y1 < 10 then Y1 := 17;
                                 TitleReport2;
                               end;
                      end;
                    end;
              #80 : begin
                      Y1 := Y1 + 1;
                      Case Pg1 of
                           1 : begin
                                 If Y1 > 19 then Y1 := 11;
                                 TitleReport1;
                               end;
                           2 : begin
                                 If Y1 > 17 then Y1 := 10;
                                 TitleReport2;
                               end;
                      end;
                    end;
              #75 : If Pg1 > 1 then
                       begin
                         Pg1 := 1;
                         X1  := 3;
                         Y1  := 11;
                         TitleReport1;
                         TitleReport2;
                       end;
              #77 : If Pg1 = 1 then
                       begin
                         Pg1 := 2;
                         X1  := 47;
                         Y1  := 10;
                         TitleReport1;
                         TitleReport2;
                       end;
         end;
       end
       else begin
              If Resp = #13 then
                 Case Pg1 of
                      1 : ProcNo := Y1 - 10;
                      2 : ProcNo := Y1;
                 end;
              Move(MemW[$B800:0000],ScArray6[1],4000);
              If ProcNo <> 99 then
                 begin
                   ProcessReport;
                   Move(ScArray6[1],MemW[$B800:0000],4000);
                 end;
            end;
  Until Resp = #27;
  TC   := #13;
  Resp := #13;
end;


end.

