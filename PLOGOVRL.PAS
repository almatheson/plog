Unit PlogOvrl;

Interface

Uses Overlay,Crt;

Implementation
Var
  KB      : Char;


Procedure MsgOvr(No : Integer;
                 St : Char);
begin
  GotoXY(1,24);
  Case No of
       1 : Write('N„o encontrei o arquivo PLOG.OVR, vou cancelar !                        <Enter>');
       2 : Write('Erro no Overlay Manager, vou cancelar !                                 <Enter>');
       3 : Write('Erro de I/O no Overlay, vou Cancelar !                                  <Enter>');
  end;
  KB := ReadKey;
  If St = 'S' then Halt(1);
end;

begin
  TextColor(White);
  TextBackGround(Black);
  ClrScr;
  GotoXY(32,12); Write('Carregando...');
  OvrInit ('PLOG.OVR');
  If OvrResult = OvrNotFound
     then MsgOvr(1,'S')
     else If OvrResult <> OvrOK then MsgOvr(2,'S');
  OvrInitEMS;
  If (OvrResult <> OvrOK     ) and
     (OvrResult =  OvrIOError) then MsgOvr(3,'S');
end.