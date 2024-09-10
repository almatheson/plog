Procedure FrameHsPd;
Var
  I : integer;
begin
  Color(Blue,White);
  GotoXY(36,5); Write('':44);
  GotoXY(37,5); Write(Titulo);
  Color(Black,Blue);
  GotoXY(35,6); Write(#201,ConstStr(#205,44),#187);
  GotoXY(35,7); Write(#186,'':44,#186);
  MakeBox(1,8,21,66,Tfn,1,0);
  Color(Black,Blue);
  For I := 8 to 18 do begin
                        GotoXY(80,I); Write(#186);
                      end;
  GotoXY(67,19); Write(ConstStr(#205,13),#188);
end;


