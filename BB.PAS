{$M 65520,0,204800}

PROGRAM BB;

Uses
  Crt,Dos,Printer,BBGlbs,BBBasp,BBLict,BBAdiE,BBList;

           (************************************)
           (*  B & B Software e Servi‡os Ltda. *)
           (*                                  *)
           (*      Copyright, 1989   B&B       *)
           (*                                  *)
           (*            Vers„o 7.0            *)
           (*                                  *)
           (*        <<  Monitora‡„o >>        *)
           (*                                  *)
           (************************************)


Procedure Processo;
begin
  Case ProcNo of
    1  : Licenciamento;
    2  : Adiciona;
    3  : Lista;
  end;
  Resp := #00;
end;


begin
  Laser  := 'N';
  Mch    := 'A';
  I      := 0;
  Repeat
    I := I + 1;
    If ParamCount >= I then
     begin
       J := ParamStr(I);
       J := UpCaseStr(J);
       Case J[1] of
            'H' : If J[3] in ['A','X'] then Mch := J[3]
                                       else Mch := 'A';
            'M' : If J[3] in ['B','C','M'] then
                     begin
                       Case J[3] of
                            'B' : TextMode(2);
                            'C' : TextMode(3);
                            'M' : TextMode(7);
                       end;
                       DirectVideo := True;
                       CheckSnow   := True;
                     end;
       end;
     end;
  Until ParamCount = I;
  CheckBreak := False;
  SetCursor(0);
  XDir    := '';
  ScreenHeader;
  DrawBox(3,7,37,12,Tfn,'S');
  ShowHeap;
  X  := 3;
  Y  := 8;
  MainScreenTitle1;
  Move(Mem[$B800:0000],ScArray1[1],4000);
  Pg := 1;
  Repeat
    Resp   := ReadKey;
    ProcNo := 99;
    If (Resp = #0 ) and
       (KeyPressed) then
       begin
         Resp := ReadKey;
         Case Resp of
              #72 : begin
                      Y := Y - 1;
                      If Y < 8 then Y := 11;
                      MainScreenTitle1;
                    end;
              #80 : begin
                      Y := Y + 1;
                      If Y > 11 then Y := 8;
                      MainScreenTitle1;
                    end;
         end;
       end
       else If Resp = #13 then
               begin
                 Case Y of
                      08 : ProcNo := 1;
                      09 : ProcNo := 2;
                      10 : ProcNo := 3;
                      11 : Resp   := #27;
                 end;
                 If ProcNo <> 99 then
                    begin
                      Move(Mem[$B800:0000],ScArray1[1],4000);
                      DrawBox(2,15,77,21,Tfn,'S');
                      Processo;
                      Move(ScArray1[1],Mem[$B800:0000],4000);
                      ShowHeap;
                    end;
               end
               else Resp := #13;
  Until Resp = #27;
  Color(Black,White);
  ClrScr;
  SetCursor(1);
  Halt(0);
end.

