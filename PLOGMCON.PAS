{$O+,F+}
Unit PlogMCon;

Interface

Uses Crt,Dos,PlogGlbs,PlogBasP,PlogTree;

   Procedure ModuloC;

Implementation

Const
   FileTC      = 'PLOGTBLC.DAT';
   FileAlog    = 'ALOGCNTA.DAT';
   Zeros       = '000000000000000000000000000000';

Type
  Pointer12  = ^STree12;

  STree12   = RECORD
		Chave12        : Str13;
                RelAddr12      : Integer;
                Left12,Right12 : Pointer12;
                Weight12     : Integer;
              END;

  Pointer13 = ^STree13;

  STree13   = RECORD
                Chave13        : Str18;
                RelAddr13      : Integer;
                Left13,Right13 : Pointer13;
                Weight13     : Integer;
              END;


  Contabil   = RECORD
                 Conta       : String[3];
                 LocalCC     : String[6];
                 Seq         : String[2];
                 ContaA      : String[18];
                 Percentual  : Real;
                 Tipo        : Char;
                 Historico   : Array[1..3] of String[60];
                 Status      : Char;
               END;

  Guia       = RECORD
                 Conta       : String[18];
                 OrigConta   : String[18];
                 Descricao   : String[40];
                 Status      : Char;
                 Grupo       : Char;
                 Grau        : Char;
                 Tipo        : Char;
                 Aceita      : Char;
                 Avisa       : Char;
                 PedeDepto   : Char;
                 GrupoE      : Char;
                 Correcao    : Char;
                 IndiceC     : String[2];
                 PeriodoC    : Char;
                 CPartidaX   : String[18];
                 CPartidaC   : String[18];
                 HistoricoC  : String[3];
                 Diario      : Char;
                 Balancete   : Array[1..5] of Char;
                 Balanco     : Array[1..5] of Char;
                 Sintetica   : String[18];
               END;

  MovimentoC = RECORD
                 Status       : Char;
                 OrigData     : String[10];
                 Conta        : String[18];
                 MesLancto    : Integer;
                 Tipo         : Char;
                 Valor        : Real;
                 Depto        : String[6];
                 Historico    : Array[1..3] of String[60];
                 Lote         : String[6];
                 SeqLote      : String[4];
               END;

  Custo      = RECORD
                 Departamento : String[10];
                 Conta        : String[3];
                 Descricao    : String[30];
                 Valor        : Real;
               END;


Var
  TCMember       : Contabil;
  TCFile         : FILE OF Contabil;
  AlogMember     : Guia;
  AlogFile       : FILE OF Guia;
  MovMember      : MovimentoC;
  MovFile        : FILE OF MovimentoC;
  CusMember      : Custo;
  CusFile        : FILE OF Custo;
  TxtFile        : TEXT;

  WorkFileT      : FILE OF Contabil;
  WorkFileM      : FILE OF MovimentoC;

  Root12         : Pointer12;
  Root13         : Pointer13;

  DouM,
  Alog           : Char;
  Sq,
  IndC,
  AlogNumber,
  AlogAN,
  TCAN,
  TCNumber,
  RDebito,
  RCredito       : Integer;
  BaseD,
  ValorM,
  ConstN,
  Debito,
  Credito        : Real;
  TCAC,
  TCNo           : Str13;
  AlogAC,
  AlogNo        : Str18;


Function WtTree12 ( Var Root12 : Pointer12 ) : Integer;
begin
  If Root12 = NIL then WtTree12 := 1
                  else WtTree12 := Root12^.Weight12;
end;


Procedure LftRTree12 ( Var Root12 : Pointer12 );
Var
   Temp : Pointer12;

begin
  Temp             := Root12;
  Root12           := Root12^.Right12;
  Temp^.Right12    := Root12^.Left12;
  Root12^.Left12   := Temp;
  Root12^.Weight12 := Temp^.Weight12;
  Temp^.Weight12   := WtTree12 ( Temp^.Left12 ) + WtTree12 ( Temp^.Right12 );
end;


Procedure RthRTree12 ( Var Root12 : Pointer12 );
Var
   Temp : Pointer12;

begin
  Temp             := Root12;
  Root12           := Root12^.Left12;
  Temp^.Left12     := Root12^.Right12;
  Root12^.Right12  := Temp;
  Root12^.Weight12 := Temp^.Weight12;
  Temp^.Weight12   := WtTree12 ( Temp^.Left12 ) + WtTree12 ( Temp^.Right12 );
end;


Procedure ChkRTree12 ( Var Root12 : Pointer12 );
Var
    Wl,Wr : Integer;

begin
  If Root12 <> NIL then
     begin
       Wl := WtTree12 ( Root12^.Left12  );
       Wr := WtTree12 ( Root12^.Right12 );

       If Wr > Wl then
          begin
            If WtTree12 ( Root12^.Right12^.Right12 ) > Wl then
               begin
                 LftRTree12 ( Root12 );
                 ChkRTree12 ( Root12^.Left12 );
               end
               else If WtTree12 ( Root12^.Right12^.Left12 ) > Wl then
                       begin
                         RthRTree12 ( Root12^.Right12 );
                         LftRTree12 ( Root12 );
                         ChkRTree12 ( Root12^.Left12  );
                         ChkRTree12 ( Root12^.Right12 );
                       end;
          end
          else If Wl > Wr then
                  begin
                    If WtTree12 ( Root12^.Left12^.Left12 ) > Wr then
                       begin
                         RthRTree12 ( Root12 );
                         ChkRTree12 ( Root12^.Right12 );
                       end
                       else If WtTree12 ( Root12^.Left12^.Right12 ) > Wr then
                               begin
                                 LftRTree12 ( Root12^.Left12 );
                                 RthRTree12 ( Root12 );
                                 ChkRTree12 ( Root12^.Left12  );
                                 ChkRTree12 ( Root12^.Right12 );
                               end;
                  end;
     end;
end;


Procedure LoadTree12 ( Var Root12 : Pointer12 );
begin
  If Root12 = NIL then
     begin
       New ( Root12 );
       Root12^.Chave12   := TCNo;
       Root12^.RelAddr12 := TCNumber;
       Root12^.Left12    := NIL;
       Root12^.Right12   := NIL;
       Root12^.Weight12  := 2;
     end
     else If TCNo <> Root12^.Chave12 then
             begin
               If TCNo < Root12^.Chave12 then LoadTree12 ( Root12^.Left12  )
                                         else LoadTree12 ( Root12^.Right12 );
               Root12^.Weight12 := WtTree12 ( Root12^.Left12  ) +
                                   WtTree12 ( Root12^.Right12 );
               ChkRTree12 ( Root12 );
             end;
end;


Procedure SearchTree12 ( Var Root12 : Pointer12 );
begin
  If Root12 = NIL then RC := 'N'
     else If TCNo < Root12^.Chave12
             then SearchTree12 ( Root12^.Left12 )
             else If TCNo > Root12^.Chave12
                     then SearchTree12 ( Root12^.Right12 )
                     else begin
                            RC       := 'S';
                            TCNumber := Root12^.RelAddr12;
                          end;
end;


Procedure SearchAnt12 ( Var Root12 : Pointer12 );
begin
  If Root12 <> NIL then
     begin
       If (Root12^.Right12 <> NIL            ) and
          (TCNo             > Root12^.Chave12) then SearchAnt12 ( Root12^.Right12 );
       If (RC   = 'N'            ) and
          (TCNo > Root12^.Chave12) then
          begin
            RC       := 'S';
            TCNumber := Root12^.RelAddr12;
            TCNo     := Root12^.Chave12;
          end
          else If RC = 'N' then If Root12^.Left12  <> NIL
                                   then SearchAnt12 ( Root12^.Left12  );
     end;
end;


Procedure SearchPos12 ( Var Root12 : Pointer12 );
begin
  If Root12 <> NIL then
     begin
       If (Root12^.Left12  <> NIL            ) and
          (TCNo            <  Root12^.Chave12) then SearchPos12 ( Root12^.Left12  );
       If (RC   = 'N'            ) and
          (TCNo < Root12^.Chave12) then
          begin
            RC       := 'S';
            TCNumber := Root12^.RelAddr12;
            TCNo     := Root12^.Chave12;
          end
          else If RC = 'N' then If Root12^.Right12 <> NIL
                                   then SearchPos12 ( Root12^.Right12 );
     end;
end;


Procedure Dispose12 ( Var Root12 : Pointer12 );
begin
  If Root12 <> NIL then
     begin
       If Root12^.Left12  <> NIL then Dispose12 ( Root12^.Left12  );
       If Root12^.Right12 <> NIL then Dispose12 ( Root12^.Right12 );
       Dispose(Root12);
     end;
end;


Function WtTree13 ( Var Root13 : Pointer13 ) : Integer;
begin
  If Root13 = NIL then WtTree13 := 1
                  else WtTree13 := Root13^.Weight13;
end;


Procedure LftRTree13 ( Var Root13 : Pointer13 );
Var
   Temp : Pointer13;

begin
  Temp             := Root13;
  Root13           := Root13^.Right13;
  Temp^.Right13    := Root13^.Left13;
  Root13^.Left13   := Temp;
  Root13^.Weight13 := Temp^.Weight13;
  Temp^.Weight13   := WtTree13 ( Temp^.Left13 ) + WtTree13 ( Temp^.Right13 );
end;


Procedure RthRTree13 ( Var Root13 : Pointer13 );
Var
   Temp : Pointer13;

begin
  Temp             := Root13;
  Root13           := Root13^.Left13;
  Temp^.Left13     := Root13^.Right13;
  Root13^.Right13  := Temp;
  Root13^.Weight13 := Temp^.Weight13;
  Temp^.Weight13   := WtTree13 ( Temp^.Left13 ) + WtTree13 ( Temp^.Right13 );
end;


Procedure ChkRTree13 ( Var Root13 : Pointer13 );
Var
    Wl,Wr : Integer;

begin
  If Root13 <> NIL then
     begin
       Wl := WtTree13 ( Root13^.Left13  );
       Wr := WtTree13 ( Root13^.Right13 );

       If Wr > Wl then
          begin
            If WtTree13 ( Root13^.Right13^.Right13 ) > Wl then
               begin
                 LftRTree13 ( Root13 );
                 ChkRTree13 ( Root13^.Left13 );
               end
               else If WtTree13 ( Root13^.Right13^.Left13 ) > Wl then
                       begin
                         RthRTree13 ( Root13^.Right13 );
                         LftRTree13 ( Root13 );
                         ChkRTree13 ( Root13^.Left13  );
                         ChkRTree13 ( Root13^.Right13 );
                       end;
          end
          else If Wl > Wr then
                  begin
                    If WtTree13 ( Root13^.Left13^.Left13 ) > Wr then
                       begin
                         RthRTree13 ( Root13 );
                         ChkRTree13 ( Root13^.Right13 );
                       end
                       else If WtTree13 ( Root13^.Left13^.Right13 ) > Wr then
                               begin
                                 LftRTree13 ( Root13^.Left13 );
                                 RthRTree13 ( Root13 );
                                 ChkRTree13 ( Root13^.Left13  );
                                 ChkRTree13 ( Root13^.Right13 );
                               end;
                  end;
     end;
end;


Procedure LoadTree13 ( Var Root13 : Pointer13 );
begin
  If Root13 = NIL then
     begin
       New ( Root13 );
       Root13^.Chave13   := AlogNo;
       Root13^.RelAddr13 := AlogNumber;
       Root13^.Left13    := NIL;
       Root13^.Right13   := NIL;
       Root13^.Weight13  := 2;
     end
     else If AlogNo <> Root13^.Chave13 then
             begin
               If AlogNo < Root13^.Chave13 then LoadTree13 ( Root13^.Left13  )
                                           else LoadTree13 ( Root13^.Right13 );
               Root13^.Weight13 := WtTree13 ( Root13^.Left13  ) +
                                   WtTree13 ( Root13^.Right13 );
               ChkRTree13 ( Root13 );
             end;
end;


Procedure SearchTree13 ( Var Root13 : Pointer13 );
begin
  If Root13 = NIL then RC := 'N'
     else If AlogNo < Root13^.Chave13
             then SearchTree13 ( Root13^.Left13 )
             else If AlogNo > Root13^.Chave13
                     then SearchTree13 ( Root13^.Right13 )
                     else begin
                            RC         := 'S';
                            AlogNumber := Root13^.RelAddr13;
                          end;
end;


Procedure SearchAnt13 ( Var Root13 : Pointer13 );
begin
  If Root13 <> NIL then
     begin
       If (Root13^.Right13 <> NIL            ) and
          (AlogNo           > Root13^.Chave13) then SearchAnt13 ( Root13^.Right13 );
       If (RC     = 'N'            ) and
          (AlogNo > Root13^.Chave13) then
          begin
            RC         := 'S';
            AlogNumber := Root13^.RelAddr13;
            AlogNo     := Root13^.Chave13;
          end
          else If RC = 'N' then If Root13^.Left13 <> NIL
                                   then SearchAnt13 ( Root13^.Left13 );
     end;
end;


Procedure SearchPos13 ( Var Root13 : Pointer13 );
begin
  If Root13 <> NIL then
     begin
       If (Root13^.Left13   <> NIL            ) and
          (AlogNo           <  Root13^.Chave13) then SearchPos13 ( Root13^.Left13 );
       If (RC     = 'N'            ) and
          (AlogNo < Root13^.Chave13) then
          begin
            RC         := 'S';
            AlogNumber := Root13^.RelAddr13;
            AlogNo     := Root13^.Chave13;
          end
          else If RC = 'N' then If Root13^.Right13 <> NIL
                                   then SearchPos13 ( Root13^.Right13 );
     end;
end;


Procedure Dispose13 ( Var Root13 : Pointer13 );
begin
  If Root13 <> NIL then
     begin
       If Root13^.Left13  <> NIL then Dispose13 ( Root13^.Left13  );
       If Root13^.Right13 <> NIL then Dispose13 ( Root13^.Right13 );
       Dispose(Root13);
     end;
end;


Procedure ParaContinua;
begin
  Color(Bfn,Btx);
  GotoXY(01,24); Write(ConstStr(' ',80));
  GotoXY(20,24); Write('      ',#026,' Para/Continua          ',#026,' Cancela');
  Color(Bfn,Yellow);
  GotoXY(20,24); Write('Enter');
  GotoXY(47,24); Write('Esc');
  Color(Tfn,Utx);
  NCont := 0;
end;


Procedure PedeConstante;
begin
  Color(Tfn,Ttx);
  GotoXY(4,19); Write('Const.:                       (Constante Num‚rica     )');
  GotoXY(4,20); Write('D ou M:                       (Dividir/Multiplicar por)');
  DouM   := 'D';
  ConstN := 1;
  Repeat
    K := 1;
    Repeat
      Case K of
           1 : begin
                 If ConstN = 0 then J := ''
                               else begin
                                      Str(ConstN:15:4,J);
                                      J := LeftAdjust(J);
                                    end;
                 InputStr(J,15,12,19,0,'S','N','T','N',Tfn,Utx);
                 Val(J,ConstN,E);
                 GotoXY(12,19); Write(ConstN:15:4);
                 If (TC <> #27) and (ConstN = 0) then
                    begin
                      ErroMsg := 'Constante num‚rica n„o pode ser ZERO';
                      ErrorMessage;
                      K := K - 1;
                    end;
               end;
           2 : begin
                 J := DouM;
                 InputStr(J,1,12,20,0,'S','N','T','N',Tfn,Utx);
                 If J[1] = ' ' then DouM := 'D'
                               else DouM := UpCase(J[1]);
                 If DouM <> 'D' then DouM := 'M';
                 GotoXY(12,20); Case DouM of
                                     'D' : Write('Dividir    ');
                                     'M' : Write('Multiplicar');
                                end;
               end;
      end;
      Case TC of
           #13 : K := K + 1;
           #24 : If K > 1 then K := K - 1;
      end;
    Until (K = 3) or (TC = #27);
    If TC <> #27 then Confirma;
  Until TC in ['S',#27];
end;


Procedure Desmembra;
Var
  XStr      : String[80];
begin
  Sq   := 1;
  XStr := Copy(TCNo,1,(Length(TCNo)-2));
  Repeat
    Seek ( TCFile, TCNumber );
    Read ( TCFile, TCMember );
    Seek ( WorkFileM, TCNumber  );
    Read ( WorkFileM, MovMember );
    K                  := K + 1;
    MovMember.Status   := 'A';
    MovMember.OrigData := WData;
    MovMember.Conta    := TCMember.ContaA;
    Val(Copy(WData,3,2),MovMember.MesLancto,E);
    MovMember.Tipo     := TCMember.Tipo;
    ValorM             := 0;
    If IndC = 0
       then ValorM := (YAddress^.AcMensalV * TCMember.Percentual)/100
       else If EEMember.DiasC[IndC] = 0
               then ValorM := (YAddress^.AcMensalV * TCMember.Percentual)/100
               else ValorM := ((YAddress^.AcMensalV/BaseD) * EEMember.DiasC[IndC])/100;
    MovMember.Valor := MovMember.Valor + ValorM;
    If IndC > 0 then
       begin
         If Alog = 'S' then
            begin
              AlogNo := LimpaChave(TCMember.ContaA);
              SearchTree13 ( Root13 );
              If RC = 'S' then
                 begin
                   Seek ( AlogFile, AlogNumber );
                   Read ( AlogFile, AlogMember );
                   If AlogMember.PedeDepto = 'S'
                      then MovMember.Depto := EEMember.CentroC[IndC]
                      else MovMember.Depto := '';
                 end;
            end
            else MovMember.Depto := '';
       end
       else MovMember.Depto := '';
    For I := 1 to 3 do MovMember.Historico[I] := TCMember.Historico[I];
    Seek  ( WorkFileM, TCNumber  );
    Write ( WorkFileM, MovMember );
    Sq   := Sq + 1;
    TCNo := XStr + QQStr(Sq,2,'0');
    SearchTree12 ( Root12 );
  Until RC = 'N';
end;


Procedure Contabiliza;
begin
  Color(Bfn,Btx);
  GotoXY(02,08); Write(ConstStr(' ',59));
  GotoXY(03,08); Write('Folha de Pagamentos de ',ArrayMesEx[MM],' de ',AA);
  Color(Tfn,Utx);
  Assign ( WorkFileM, (XPath + '\CONTAB.DAT'));
  {$I-}
  Reset ( WorkFileM );
  {$I+}
  If IOResult <> 0 then ReWrite ( WorkFileM )
     else begin
            Close   ( WorkFileM );
            Erase   ( WorkFileM );
	    ReWrite ( WorkFileM );
          end;
  MovMember.Status       := ' ';
  MovMember.OrigData     := '';
  MovMember.Conta        := '';
  MovMember.MesLancto    := 0;
  MovMember.Tipo         := ' ';
  MovMember.Valor        := 0;
  MovMember.Depto        := '';
  MovMember.Historico[1] := '';
  MovMember.Historico[2] := '';
  MovMember.Historico[3] := '';
  MovMember.Lote         := '';
  MovMember.SeqLote      := '';
  TCNo := '';
  Repeat
    RC := 'N';
    SearchPos12 ( Root12 );
    If RC = 'S' then
       begin
         Seek  ( WorkFileM, TCNumber  );
         Write ( WorkFileM, MovMember );
       end;
  Until RC = 'N';
  DrawBox(26,11,67,21,Sfn,'S');
  Color(Bfn,Btx);
  GotoXY(26,11); Write(' Empregados                               ');
  Color(Sfn,Stx);
  Window(27,13,67,21);
  Color(Sfn,Stx);
  GotoXY(1,8);
  Debito   := 0;
  Credito  := 0;
  RDebito  := 0;
  RCredito := 0;
  R        := 0;
  K        := 0;
  I        := -1;
  EENo     := '';
  Repeat
    RC := 'N';
    SearchPos5 ( Root5 );
    If RC = 'S' then
       begin
         ReadWrite(#08,'R','N',EENumber);
         If (EEMember.Status <> 'X') and
            (EEMember.Status <> 'R') then
            begin
              Writeln(EEMember.Nome);
              R := R + 1;
              LoadMVDsk(#11);
              YYNo := '';
              Repeat
                RC := 'N';
                SearchPosY ( RootY );
                If RC = 'S' then
                   begin
                     If YAddress^.AcMensalV > 0 then
                        begin
                          IndC  := 0;
                          BaseD := 0;
                          For I := 1 to 5 do If EEMember.CentroC[I] <> ''
                                                then BaseD := BaseD + EEMember.DiasC[I];
                          Repeat
                            IndC := IndC + 1;
                            TCNo := YYNo + '#' + EEMember.CentroC[IndC] + '#01';
                            SearchTree12 ( Root12 );
                            If RC = 'S' then Desmembra;
                          Until (RC = 'N') or (IndC = 5);
                          If IndC = 1 then
                             begin
                               IndC := 0;
                               TCNo := YYNo + '#      #01';
                               SearchTree12 ( Root12 );
                               If RC = 'S' then Desmembra;
                             end;
                          RC := 'S';
                        end;
                   end;
              Until RC = 'N';
              If RootY <> NIL then DisposeY ( RootY );
              RootY := NIL;
              RC    := 'S';
            end;
       end;
  Until RC = 'N';
  Window(1,1,80,25);
  Color(Tfn,Ttx);
  GotoXY(4,17); Write('N§Empregados:');
  Color(Tfn,Utx);
  GotoXY(18,17); Write(R:4);
  DrawBox(5,12,32,14,Red,'S');
  Color(Red,White);
  GotoXY(5,12); Write('   Total dos lan‡amentos    ');
  Color(Red,Cyan);
  GotoXY(5,13); Write(' Db:                        ');
  GotoXY(5,14); Write(' Cr:                        ');
  Color(Red,White);
  TCNo := '';
  Repeat
    RC := 'N';
    SearchPos12 ( Root12 );
    If RC = 'S' then
       begin
         Seek ( WorkFileM, TCNumber  );
         Read ( WorkFileM, MovMember );
         If MovMember.Status = 'A' then
            begin
              Case DouM of
                   'D' : MovMember.Valor := TruncX(MovMember.Valor / ConstN);
                   'M' : MovMember.Valor := TruncX(MovMember.Valor * ConstN);
              end;
              Seek  ( MovFile, FileSize(MovFile));
              Write ( MovFile, MovMember        );
              Case MovMember.Tipo of
                   'D' : begin
                           Debito  := Debito  + MovMember.Valor;
                           RDebito := RDebito + 1;
                         end;
                   'C' : begin
                           Credito  := Credito  + MovMember.Valor;
                           RCredito := RCredito + 1;
                         end;
              end;
            end;
         GotoXY(10,13); Write(EditReal(Debito):17,' ',RDebito:4);
         GotoXY(10,14); Write(EditReal(Credito):17,' ',RCredito:4);
       end;
  Until RC = 'N';
  {$I-}
  Close ( WorkFileM );
  Erase ( WorkFileM );
  {$I+}
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
  If Foot = #13 then Foot := 'S';
  LimpaLn(24,Tfd);
end;


{$I PlogTabC.inc }
{$I PlogReor.inc }
{$I PlogCCon.inc }
{$I PlogCRpt.inc }


Procedure ModuloC;
Var
  ScArrayM       : Array [1..4000] of Char;

begin
  Root12 := NIL;
  Root13 := NIL;
  Assign ( TCFile, (XPath + '\' + FileTC ));
  {$I-}
  Reset ( TCFile  );
  {$I+}
  If IOResult <> 0 then
     begin
       ReWrite ( TCFile );
       Reset   ( TCFile );
     end
     else If Filesize(TCFile) <> 0 then
             begin
               Color(Blue,Yellow);
               GotoXY(01,24); Write(ConstStr(' ',80));
               GotoXY(02,24); Write('Tabela de Contabiliza‡„o');
               GotoXY(73,24); Write('Aguarde ');
               I := -1;
               Repeat
                 I := I + 1;
                 {$I-}
                 Seek ( TCFile, I        );
                 Read ( TCFile, TCMember );
                 {$I+}
                 If IOResult = 0 then
                    With TCMember do
                    begin
                      TCNumber := I;
                      TCNo     := Conta + '#' + LocalCC + '#' + Seq;
                      LoadTree12 ( Root12 );
                      ShowHeap;
                    end;
               Until (I + 1) = Filesize(TCFile);
               LimpaLn(24,Tfd);
             end;
  Assign ( AlogFile,(Copy(XDrive,1,Length(XDrive)-9)+'\ALOGDATA\ALOGM'+XCia+'\'+FileAlog));
  {$I-}
  Reset ( AlogFile );
  {$I+}
  If IOResult = 0 then
     begin
       Color(Blue,Yellow);
       GotoXY(01,24); Write(ConstStr(' ',80));
       GotoXY(02,24); Write('Interface com a Contabilidade');
       GotoXY(73,24); Write('Aguarde ');
       I := -1;
       Repeat
         I := I + 1;
         {$I-}
         Seek ( AlogFile, I          );
         Read ( AlogFile, AlogMember );
         {$I+}
         If IOResult = 0 then
            With AlogMember do
            begin
              If Status <> 'C' then
                 begin
                   AlogNo := AlogMember.Conta;
                   AlogNumber := I;
                   LoadTree13 ( Root13 );
                   ShowHeap;
                 end;
            end;
       Until (I + 1) = Filesize(AlogFile);
       Alog := 'S';
       LimpaLn(24,Tfd);
     end
     else Alog := 'N';
  Color(Tfn,Utx);
  TabI[1] := ' Tabela de Contabiliza‡„o       ';
  TabI[2] := ' Lista Tabela de Contabiliza‡„o ';
  TabI[3] := ' Relat¢rio de Contabiliza‡„o    ';
  TabI[4] := ' Relat¢rio de Custo             ';
  TabI[5] := ' Exporta‡„o do Custo da Folha   ';
  TabI[6] := ' Lote de Contabiliza‡„o         ';
  TabI[7] := ' Indexa‡„o da Tabela            ';
  TabI[8] := ' Encerrar a fun‡„o              ';
  TabX[1]  := 10;
  TabX[2]  := 10;
  TabX[3]  := 10;
  TabX[4]  := 10;
  TabX[5]  := 10;
  TabX[6]  := 10;
  TabX[7]  := 10;
  TabX[8]  := 10;
  TabY[1]  := 11;
  TabY[2]  := 12;
  TabY[3]  := 13;
  TabY[4]  := 14;
  TabY[5]  := 15;
  TabY[6]  := 16;
  TabY[7]  := 17;
  TabY[8]  := 18;
  YY := 1;
  Repeat
    RetMenuAuxiliar(9,10,8,1,1);
    Move(Mem[$B800:0000],ScArrayM[1],4000);
    Case YY of
         1  : begin
                Titulo := 'Atualiza‡„o da Tab.de Contabiliza‡„o';
                BuildFrame('S');
                Color(Red,White);
                GotoXY(62,08); Write(#27,#217);
                GotoXY(62,10); Write(#24);
                GotoXY(62,11); Write(#25);
                GotoXY(62,13); Write('F1 ');
                GotoXY(62,15); Write('F3 ');
                GotoXY(62,17); Write('F5 ');
                Color(Red,Yellow);
                GotoXY(66,08); Write('C¢digo     ');
                GotoXY(66,10); Write('Anterior   ');
                GotoXY(66,11); Write('Pr¢ximo    ');
                GotoXY(66,13); Write('Tabela     ');
                GotoXY(66,15); Write('Altera‡„o  ');
                GotoXY(66,17); Write('Inclus„o   ');
                Shade(3,8,60,21,LightGray,Black);
                TitleTabC;
                Move(Mem[$B800:0000],ScArray4[1],4000);
                UpDateTabC;
              end;
         2  : begin
                Titulo := 'Lista Tabela de Contabiliza‡„o';
                BuildFrame('S');
                TabelaCC;
              end;
         3  : begin
                Titulo := 'Relat¢rio de Contabiliza‡„o da Folha';
                BuildFrame('S');
                Rodape;
                If TC <> #27 then RelContabilCC;
              end;
         4  : begin
                Titulo := 'Relat¢rio de Custo da Folha';
                BuildFrame('S');
                Rodape;
                If TC <> #27 then RelCusto;
              end;
         5  : begin
                Titulo := 'Exporta‡„o do Custo da Folha';
                BuildFrame('S');
                ArqCusto;
              end;
         6  : begin
                Titulo := 'Gera‡„o do Lote de Contabiliza‡„o';
                BuildFrame('S');
                GeraVoucher;
              end;
         7  : begin
	        Titulo := 'Indexa‡„o da tabela de Contabiliza‡„o';
                BuildFrame('S');
	        ReorganizaT;
              end;
         8  : Resp := #27;
    end;
    Move(ScArrayM[1],MemW[$B800:0000],4000);
  Until Resp = #27;
  Close ( TCFile );
  If Alog = 'S' then Close ( AlogFile );
  Dispose12 ( Root12 );
  Dispose13 ( Root13 );
  Root12 := NIL;
  Root13 := NIL;
  Resp   := #00;
  TC     := #13;
end;

end.

