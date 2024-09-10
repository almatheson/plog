
Unit AlogNavg;

Interface

Uses Crt,Dos,AlogGlbs,AlogBasp;


   Procedure ReadWrite (Fl,Op,Ms : Char;
                        No       : Integer);
   Procedure UnloadIndex;
   Procedure UnloadIndexL;
   Procedure UnloadIndexM;
   Procedure LoadTreeB   (Var RootB : PointerB);
   Procedure SearchTreeB (Var RootB : PointerB);
   Procedure SearchPosB  (Var RootB : PointerB);
   Procedure SearchAntB  (Var RootB : PointerB);
   Procedure LoadTree0   (Var Root0 : Pointer0);
   Procedure SearchTree0 (Var Root0 : Pointer0);
   Procedure SearchPos0  (Var Root0 : Pointer0);
   Procedure SearchAnt0  (Var Root0 : Pointer0);
   Procedure LoadTree1   (Var Root1 : Pointer1);
   Procedure SearchTree1 (Var Root1 : Pointer1);
   Procedure SearchAnt1  (Var Root1 : Pointer1);
   Procedure SearchPos1  (Var Root1 : Pointer1);
   Procedure Dispose1    (Var Root1 : Pointer1);
   Procedure UnLoadTree1 (Var Root1 : Pointer1);
   Procedure LoadTree2   (Var Root2 : Pointer2);
   Procedure SearchTree2 (Var Root2 : Pointer2);
   Procedure SearchAnt2  (Var Root2 : Pointer2);
   Procedure SearchPos2  (Var Root2 : Pointer2);
   Procedure Dispose2    (Var Root2 : Pointer2);
   Procedure UnLoadTree2 (Var Root2 : Pointer2);
   Procedure LoadTree3   (Var Root3 : Pointer3);
   Procedure SearchTree3 (Var Root3 : Pointer3);
   Procedure SearchAnt3  (Var Root3 : Pointer3);
   Procedure SearchPos3  (Var Root3 : Pointer3);
   Procedure Dispose3    (Var Root3 : Pointer3);
   Procedure UnLoadTree3 (Var Root3 : Pointer3);
   Procedure DelTree4    (Var Root4 : Pointer4);
   Procedure LoadTree4   (Var Root4 : Pointer4);
   Procedure SearchTree4 (Var Root4 : Pointer4);
   Procedure SearchAnt4  (Var Root4 : Pointer4);
   Procedure SearchPos4  (Var Root4 : Pointer4);
   Procedure Dispose4    (Var Root4 : Pointer4);
   Procedure UnLoadTree4 (Var Root4 : Pointer4);
   Procedure LoadTree5   (Var Root5 : Pointer5);
   Procedure SearchTree5 (Var Root5 : Pointer5);
   Procedure SearchAnt5  (Var Root5 : Pointer5);
   Procedure SearchPos5  (Var Root5 : Pointer5);
   Procedure Dispose5    (Var Root5 : Pointer5);
   Procedure DelTree6    (Var Root6 : Pointer6);
   Procedure LoadTree6   (Var Root6 : Pointer6);
   Procedure SearchTree6 (Var Root6 : Pointer6);
   Procedure SearchAnt6  (Var Root6 : Pointer6);
   Procedure SearchPos6  (Var Root6 : Pointer6);
   Procedure Dispose6    (Var Root6 : Pointer6);
   Procedure LoadTree7   (Var Root7 : Pointer7);
   Procedure SearchTree7 (Var Root7 : Pointer7);
   Procedure SearchAnt7  (Var Root7 : Pointer7);
   Procedure SearchPos7  (Var Root7 : Pointer7);
   Procedure DelTree8    (Var Root8 : Pointer8);
   Procedure LoadTree8   (Var Root8 : Pointer8);
   Procedure SearchTree8 (Var Root8 : Pointer8);
   Procedure SearchAnt8  (Var Root8 : Pointer8);
   Procedure SearchPos8  (Var Root8 : Pointer8);


Implementation
Var
  Resto   : Real;

{$I AlogTree.inc }



Procedure ReadWrite (Fl,Op,Ms : Char;
                     No       : Integer);
Var
  Arq        : Str15;
begin
   {$I-}
   Case Fl of
        #00 : begin
                Seek ( MasterFile, No );
                If Op = 'R' then Read  ( MasterFile, MasterMember )
                            else Write ( MasterFile, MasterMember );
                Arq := 'MASTER';
              end;
        #01 : begin
                Seek ( OwnerFile, No );
                If Op = 'R' then Read  ( OwnerFile, OwnerMember )
                            else Write ( OwnerFile, OwnerMember );
                Arq := 'OWNER';
              end;
        #02 : begin
                Seek ( CmpyFile, No );
                If Op = 'R' then Read  ( CmpyFile, CmpyMember )
                            else Write ( CmpyFile, CmpyMember );
                Arq := 'TAB_CIA';
              end;
        #03 : begin
                Seek ( ContaFile, No );
                If Op = 'R' then Read  ( ContaFile, ContaMember )
                            else Write ( ContaFile, ContaMember );
                Arq := 'CONTA';
              end;
        #04 : begin
                Seek ( LoteFile, No );
                If Op = 'R' then Read  ( LoteFile, LoteMember )
                            else Write ( LoteFile, LoteMember );
                Arq := 'LOTE';
              end;
        #05 : begin
                Seek ( DeptFile, No );
                If Op = 'R' then Read  ( DeptFile, DeptMember )
                            else Write ( DeptFile, DeptMember );
                Arq := 'DEPTO.';
              end;
        #06 : begin
                Seek ( SaldFile, No );
                If Op = 'R' then Read  ( SaldFile, SaldMember )
                            else Write ( SaldFile, SaldMember );
                Arq := 'SALDOS';
              end;
        #07 : begin
                Seek ( ExpeFile, No );
                If Op = 'R' then Read  ( ExpeFile, ExpeMember )
                            else Write ( ExpeFile, ExpeMember );
                Arq := 'DESPESAS';
              end;
        #08 : begin
                Seek ( LctoFile, No );
                If Op = 'R' then Read  ( LctoFile, LctoMember )
                            else Write ( LctoFile, LctoMember );
                Arq := 'MOVIMENTO';
              end;
        #10 : begin
                Seek ( HsPdFile, No );
                If Op = 'R' then Read  ( HsPdFile, HsPdMember )
                            else Write ( HsPdFile, HsPdMember );
                Arq := 'H_PADRAO';
              end;
        #12 : begin
                Seek ( EcoFile, No );
                If Op = 'R' then Read  ( EcoFile, EcoMember )
                            else Write ( EcoFile, EcoMember );
                Arq := 'IND_ECO';
              end;
        #13 : begin
                Seek ( IndXFile, No );
                If Op = 'R' then Read  ( IndXFile, IndXMember )
                            else Write ( IndXFile, IndXMember );
                Arq := 'IND_X';
              end;
        #14 : begin
                Seek ( IndLFile, No );
                If Op = 'R' then Read  ( IndLFile, IndLMember )
                            else Write ( IndLFile, IndLMember );
                Arq := 'IND_L';
              end;
        #15 : begin
                Seek ( IndMFile, No );
                If Op = 'R' then Read  ( IndMFile, IndMMember )
                            else Write ( IndMFile, IndMMember );
                Arq := 'IND_M';
              end;
        #16 : begin
                Seek ( CMstFile, No );
                If Op = 'R' then Read  ( CMstFile, CMstMember )
                            else Write ( CMstFile, CMstMember );
                Arq := 'CIA';
              end;
        #17 : begin
                Seek ( BlkStaFile, No );
                If Op = 'R' then Read  ( BlkStaFile, BlkStaMember )
                            else Write ( BlkStaFile, BlkStaMember );
                Arq := 'BLOK_FILE';
              end;
   end;
   {$I+}
   If IOResult = 0 then RW := 'S'
      else If Ms = 'S' then
              begin
                Color(Tfd,Utx);
                ClrScr;
                DrawBox(20,10,60,14,Red,'S');
                Color(Red,White);
                GotoXY(21,11);
                Case Op of
                     'R' : Write('Erro lendo arquivo: ',Arq);
                     'W' : Write('Erro gravando arquivo: ',Arq);
                end;
                Color(Red,Yellow);
                GotoXY(21,13); Write('N„o h  como prosseguir, Tecle <Enter>');
                Color(Red,White);
                GotoXY(52,13); Write('Enter');
                Repeat
                  TC := ReadKey;
                Until TC = #13;
                Color(Black,LightGray);
                ClrScr;
                Halt;
              end;
end;

begin
  Dia := 0;
  Mes := 0;
  Ano := 0;
  DiaSema := 0;
  GetDate(Ano,Mes,Dia,DiaSema);
  Str(Dia,XDia);
  If Dia < 10 then XDia := '0' + XDia;
  Str(Mes,XMes);
  If Mes < 10 then XMes := '0' + XMes;
  Str(Ano,XAno);
  Ver := DosVersion;
  TabDia[1]  := 31;
  TabDia[2]  := 28;
  TabDia[3]  := 31;
  TabDia[4]  := 30;
  TabDia[5]  := 31;
  TabDia[6]  := 30;
  TabDia[7]  := 31;
  TabDia[8]  := 31;
  TabDia[9]  := 30;
  TabDia[10] := 31;
  TabDia[11] := 30;
  TabDia[12] := 31;
  Resto := Ano div 4;
  If (Ano - (Resto * 4)) = 0 then TabDia[2] := 29;
  MM := Mes;
  WData := XDia + '/' + XMes + '/' + XAno;

end.

