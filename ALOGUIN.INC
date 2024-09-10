Procedure InitialScreen(Var SName  : Str6);
begin
  ClrScr;
  Color(Black,Blue);
  MakeBox(1,1,24,80,0,1,1);
  MakeBox(60,2,4,19,0,1,1);
  Color(Red,Cyan);
  GotoXY(61,3); Write(' Data : ');
  Color(Red,White);
  GotoXY(69,3); Write(XDia,'/',XMes,'/',XAno,' ');
  MakeBox(3,2,6,40,0,1,1);
  Color(Black,Red);
  GotoXY(5,3); Write('Paralax Sistemas de Computa‡„o Ltda.');
  GotoXY(5,4); Write('------------------------------------');
  Color(Black,Cyan);
  GotoXY(5,5);  Write('Sistema de Contabilidade Geral');
  Color(Black,Yellow);
  GotoXY(61,5); Write('MS/DOS');
  Color(Black,Cyan);
  GotoXY(68,5); Write('Ver. ',Lo(Ver),'.',Hi(Ver));
  Color(Black,Yellow);
  GotoXY(68,6); Write(SName,'U 5.9');
  Color(Black,Red);
  GotoXY(68,7); Write(Trunc(MemAvail / 1024):3,' KBytes');
  Color(Black,LightGray);
  MakeBox(66,21,23,13,0,1,1);
  Color(Red,White);
  GotoXY(67,22); Write(' Esc =');
  Color(Red,Black);
  GotoXY(73,22); Write(' Fim ');
  Color(Black,LightGray);
end;


Procedure ScreenHeader(Var SName  : Str6;
                           UName  : Str40;
                           AMonth : Str9);
begin
  Color(Black,LightGray);
  ClrScr;
  Color(Black,Blue);
  MakeBox(1,1,3,Length(UName) + 4,0,1,1);
  Color(Red,White);
  GotoXY(2,2); Write(' ',UName,' ');
  Color(Blue,Yellow);
  GotoXY(51,1); Write(' ',SName,'U 5.9 ');
  ShowHeap;
  Color(Blue,Cyan);
  GotoXY(64,1); Write(' Data : ');
  Color(Blue,White);
  GotoXY(72,1); Write(XDia,'/',XMes,'/',XAno,' ');
  Color(Red,Yellow);
  GotoXY(64,2); Write(' MS/DOS          ');
  Color(Red,Cyan);
  GotoXY(72,2); Write('Ver.',Lo(Ver),'.',Hi(Ver));
  Color(Black,Yellow);
  GotoXY(71,4); Write(AMonth:9);
  Color(Black,LightGray);
end;


Procedure Logo;
Var
  I : Integer;

begin
  I := 0;
  Color(Black,Red);
  Repeat
    I := I + 1;
    GotoXY(I + 58,I + 5);  Write('\\\\');
    GotoXY(I + 58,19 - I); Write('////');
  Until I = 6;
  GotoXY(65,12); Write('>>>>');
  Color(Black,Blue);
  GotoXY(10,9);  Write('*******  **       *******   **       ***     **');
  GotoXY(70,9);  Write('****');
  GotoXY(10,10); Write('******** ***      ********  ***      ***     ***');
  GotoXY(69,10); Write('****');
  GotoXY(10,11); Write('***  ***  ***     ***  ***   ***     ***',
                       '      ***');
  GotoXY(68,11); Write('****');
  GotoXY(10,12); Write('******** *****    *** ****  *****    ***',
                       '     *****');
  GotoXY(69,12); Write('**');
  GotoXY(10,13); Write('*******  ******   *** ***   ******   ***',
                       '     ******');
  GotoXY(68,13); Write('****');
  GotoXY(10,14); Write('***          ***  ***  ***      ***  *******',
                       '     ***');
  GotoXY(69,14); Write('****');
  GotoXY(10,15); Write('***           *** ***   ***      *** *******',
                       '      ***');
  GotoXY(70,15); Write('****');
  Color(Black,LightGray);
end;


Procedure Drive;
begin
  MakeBox(3,19,23,40,0,1,1);
  Repeat
    Color(Black,Yellow);
    GotoXY(5,21); Write('Drive');
    Color(Black,Magenta);
    GotoXY(11,21); Write('alocado para Dados :    ');
    J := ParamStr(1);
    J := UpCase(J[1]);
    If J = '' then J := 'C';
    Repeat
      InputStr(J,1,32,21,0,'S',Black,LightGray);
    Until (UpCase(J[1]) = 'A') or (UpCase(J[1]) = 'B') or
          (UpCase(J[1]) = 'C') or (UpCase(J[1]) = 'D') or
          (UpCase(J[1]) = 'E') or (UpCase(J[1]) = 'F') or
          (TC = #27);

    If TC <> #27 then
       begin
         XDrive := UpCase(J[1]) + ':';
         MakeBox(54,2,4,5,0,1,1);
         Color(Black,(White + Blink));
         GotoXY(56,3); Write(XDrive);
         Color(Black,LightGray);
         TC := 'S';
       end;
  Until (TC = 'S') or (TC = #27);
  GotoXY(5,21); Write('':35);
end;


Procedure EntryPassword(P : Char);
Var
  I  : Integer;

begin
  MakeBox(3,19,23,40,0,1,1);
  Color(Black,LightGray);
  GotoXY(5,21);  Write('Entre sua ');
  Color(Black,Yellow);
  GotoXY(15,21); Write('Password : ');
  I := 0;
  With MasterMember do
  begin
    Repeat
      I := I + 1;
      J := '';
      InputStr(J,8,26,21,0,P,Black,LightGray);
      If (P = 'S'       ) or
         (J = 'Morangie') then Password := J;
    Until (J = Password) or (I = 3) or (TC = #27);
    GotoXY(5,21); Write('':35);
    If (I = 3) and (J <> Password) then TC := #27;
  end;
end;


Procedure EntryPswCia;
Var
  I  : Integer;

begin
  MakeBox(3,19,23,40,0,1,1);
  Color(Black,LightGray);
  GotoXY(5,21);  Write('Entre  a  ');
  Color(Black,Yellow);
  GotoXY(15,21); Write('Password : ');
  I := 0;
  With CmpyMember do
  begin
    Repeat
      I := I + 1;
      J := '';
      InputStr(J,8,26,21,0,'N',Black,LightGray);
      If J = 'Morangie' then Password := J;
    Until (J = Password) or (I = 3) or (TC = #27);
    GotoXY(5,21); Write('':35);
    If (I = 3) and (J <> Password) then TC := #27;
  end;
end;


Procedure EntryAno;
begin
  Color(Black,Yellow);
  GotoXY(5,21); Write(' ':35);
  GotoXY(5,21); Write('Ano ');
  Color(Black,Magenta);
  GotoXY(10,21); Write('a ser processado :');
  Repeat
    If AA = 0 then J := ''
              else begin
                     Str(AA:2,J);
                     J := LeftAdjust(J);
                     If Length(J) = 1 then J := '0' + J;
                   end;
    InputStr(J,2,29,21,0,'S',Black,LightGray);
    If TC <> #27 then
       begin
         Val(J,AA,E);
         CmpyMember.AnoAtivo := AA;

         Seek  ( CmpyFile, CmpyNumber );
         Write ( CmpyFile, CmpyMember );

         Str(AA:2,J);
         J := LeftAdjust(J);
         If Length(J) = 1 then J := '0' + J;
         AAFx := J;
         TC   := 'S';
       end;
  Until (TC = #27) or (TC = 'S');

  GotoXY(5,21); Write('':35);
end;


