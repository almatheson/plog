Unit PlogBasP;

Interface

Uses Crt,Dos,PlogGlbs,PlogTree;


   Function ConstStr   (C : Char; N : Integer) : AnyStr;
   Function UpCaseStr  (S : Str80 ) : Str80;
   Function LeftAdjust (S : Str80 ) : Str80;
   Function Trim       (S : Str80 ) : Str80;
   Function EditReal   (V : Real)   : Str80;
   Function EditInteger(V : Integer): Str80;
   Function EditNumber (V : Real  ) : Str80;
   Function TruncX     (V : Real  ) : Real;
   Function Acentua    (S : AnyStr) : AnyStr;
   Function ChkData    (S : Str10 ) : Str10;
   Function Diasemana  (Data : Str10) : Str4;
   Function LimpaChave (S : Str80 ) : Str80;
   Function TiraBranco (S : Str80 ) : Str80;
   Function QQStr      (X : Real; I : Integer; F : Char) : Str80;
   Function PushLeft   (I : Integer; X : AnyStr) : AnyStr;
   Function PushRight  (I : Integer; X : AnyStr) : AnyStr;
   Function Sal : Real;

   Procedure SetCursor ( n : Integer );
   Procedure Color(Back : Byte;Txto : Byte);
   Procedure Limpaln(L : Integer; C : Byte);
   Procedure ShowHeap;
   Procedure ShowMes;
   Procedure Shade(L,T,R,B : Integer;
                   CT,CB   : byte    );
   Procedure DrawBox(Esq,Top,Dir,Bot : Integer;
                     Fundo           : Byte   ;
                     Sbra            : char   );
   Procedure ScreenFrame;
   Procedure ReadWrite (Fl,Op,Ms : Char;
                        No       : Integer);
   Procedure CheckUF ( Uf : Str2);
   Procedure ErrorMessage;
   Procedure Confirma;
   Procedure AvisoFinal;
   Procedure InputStr  (var S         : AnyStr;
                            L, X, Y,P : Integer;
                            B,H,C,E   : Char;
                            F,T       : Byte);
   Procedure BuildFrame(X : Char);
   Procedure Extenso(Tm1,Tm2,Tm3 : Integer; VStr : Str80  );
   Procedure TeclaReturn;
   Procedure OpenFiles;
   Procedure CloseFiles;

   Procedure UltimaEtapa;
   Procedure TrocaTabela;
   Procedure MostraMes;
   Procedure TrocaMesAno;
   Procedure Horas(M : Real);
   Procedure HoraMinuto;
   Procedure TestaImpressora(X : Char; Y : Str40);
   Procedure WriteLine(T : Char; L : AnyStr);
   Procedure QPorta;

   Procedure ScrollRpt;
   Procedure Footer;
   Procedure HelpM;
   Procedure MenuAuxiliar(T : Integer; Bf,Bt,Nf,Nt : Byte);
   Procedure RetMenuAuxiliar(C,L,N,P1,P2 : Integer);

   Procedure LoadCmpy;
   Procedure LoadBlkSta;
   Procedure LoadIndex1;
   Procedure LoadIndex2;
   Procedure LoadIndex3;
   Procedure LoadIndex6(X,Y : Char);

   Procedure Descarrega1;
   Procedure Descarrega2;
   Procedure Descarrega3;

   Procedure LoadMVDsk(X : Char);
   Procedure LiberaMVDsk;
   Procedure LimpaMVDsk;
   Procedure UnLoadMVDsk;

   Procedure Inicializa(X : Char);
   Procedure HelpStatus;


Implementation

{$I ConstStr.rot }
{$I UpCaseSt.rot }
{$I LeftAdjt.rot }
{$I Trim.rot     }
{$I QQStr.rot    }
{$I PushLeft.rot }
{$I PushRigh.rot }
{$I TruncX.rot   }
{$I Acentua.rot  }
{$I DesAcent.rot }
{$I SetCurso.rot }
{$I Color.rot    }
{$I LimpaLn.rot  }
{$I TiraBrco.rot }
{$I EditReal.rot }
{$I EditIntg.rot }
{$I EditNum.rot  }
{$I ShowHeap.rot }
{$I ShowMes.rot  }
{$I ChkData.rot  }
{$I DiaSema.rot  }
{$I DrawBox.rot  }
{$I Frame.rot    }
{$I CheckUF.rot  }
{$I ErroMsg.rot  }
{$I Confirma.rot }
{$I AvisoFin.rot }
{$I InputStr.rot }
{$I BuildFra.rot }
{$I Extenso.rot  }
{$I LimpaChv.rot }
{$I TeclaR.rot   }
{$I QPorta.rot   }
{$I Footer.rot   }
{$I PlogOpen.inc }
{$I PlogClos.inc }


Procedure ReadWrite (Fl,Op,Ms : Char;
                     No       : Integer);
Var
  Arq        : Str15;
begin
   RW := 'N';
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
                Seek ( TTFile, No );
                If Op = 'R' then Read  ( TTFile, TTMember )
                            else Write ( TTFile, TTMember );
                Arq := 'TABELAS';
              end;
        #04 : begin
                Seek ( CCFile, No );
                If Op = 'R' then Read  ( CCFile, CCMember )
                            else Write ( CCFile, CCMember );
                Arq := 'CONTAS';
              end;
        #05 : begin
                Seek ( DDFile, No );
                If Op = 'R' then Read  ( DDFile, DDMember )
                            else Write ( DDFile, DDMember );
                Arq := 'DEPARTAMENTOS';
              end;
        #06 : begin
                Seek ( BBFile, No );
                If Op = 'R' then Read  ( BBFile, BBMember )
                            else Write ( BBFile, BBMember );
                Arq := 'BANCOS';
              end;
        #07 : begin
                Seek ( SSFile, No );
                If Op = 'R' then Read  ( SSFile, SSMember )
                            else Write ( SSFile, SSMember );
                Arq := 'SINDICATOS';
              end;
        #08 : begin
                Seek ( EEFile, No );
                If Op = 'R' then Read  ( EEFile, EEMember )
                            else Write ( EEFile, EEMember );
                Arq := 'EMPREGADOS';
              end;
        #09 : begin
                Seek ( HPFile, No );
                If Op = 'R' then Read  ( HPFile, HPMember )
                            else Write ( HPFile, HPMember );
                Arq := 'HIST_PAG.';
              end;
        #10 : begin
                Seek ( HHFile, No );
                If Op = 'R' then Read  ( HHFile, HHMember )
                            else Write ( HHFile, HHMember );
                Arq := 'HISTORICO';
              end;
        #11 : begin
                Seek ( MMFile, No );
                If Op = 'R' then Read  ( MMFile, MMMember )
                            else Write ( MMFile, MMMember );
                Arq := 'MOVIMENTO';
              end;
        #12 : begin
                Seek ( ENFile, No );
                If Op = 'R' then Read  ( ENFile, ENMember )
                            else Write ( ENFile, ENMember );
                Arq := 'ENCARGOS';
              end;
        #13 : begin
                Seek ( Ind1File, No );
                If Op = 'R' then Read  ( Ind1File, Ind1Member )
                            else Write ( Ind1File, Ind1Member );
                Arq := 'INDICE_1';
              end;
        #14 : begin
                Seek ( Ind2File, No );
                If Op = 'R' then Read  ( Ind2File, Ind2Member )
                            else Write ( Ind2File, Ind2Member );
                Arq := 'INDICE_2';
              end;
        #15 : begin
                Seek ( Ind3File, No );
                If Op = 'R' then Read  ( Ind3File, Ind3Member )
                            else Write ( Ind3File, Ind3Member );
                Arq := 'INDICE_3';
              end;
        #16 : begin
                Seek ( CMstFile, No );
                If Op = 'R' then Read  ( CMstFile, CMstMember )
                            else Write ( CMstFile, CMstMember );
                Arq := 'CAD_CIA';
              end;
        #17 : begin
                Seek ( WorkFile5, No );
                If Op = 'R' then Read  ( WorkFile5, MMMember )
                            else Write ( WorkFile5, MMMember );
                Arq := 'WRK_5';
              end;
        #18 : begin
                Seek ( BlkStaFile, No );
                If Op = 'R' then Read  ( BlkStaFile, BlkStaMember )
                            else Write ( BlkStaFile, BlkStaMember );
                Arq := 'BLOK_FILE';
              end;
        #19 : begin
                Seek ( OOFile, No );
                If Op = 'R' then Read  ( OOFile, OOMember )
                            else Write ( OOFile, OOMember );
                Arq := 'OSERVICO';
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
                GotoXY(21,13); Write('N∆o h† como prosseguir, Tecle <Enter>');
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


Procedure UltimaEtapa;
begin
  Color(Red,White);
  GotoXY(61,11); Write('Ultima execuá∆o  ');
  Color(Red,Yellow);
  GotoXY(61,14);
  Case CMstMember.Etapa of
       'O' : Write(' Ad. 13ß Sal†rio ');
       'P' : Write('   Pagamento     ');
       'A' : Write(' Adiantamento    ');
       'S' : Write(' 13ß Sal†rio     ');
       '1' : Write('   1ß Semana     ');
       '2' : Write('   2ß Semana     ');
       '3' : Write('   3ß Semana     ');
       '4' : Write('   4ß Semana     ');
       'X' : Write('    Nenhuma      ');
  end;
  Shade(3,8,60,21,LightGray,Black);
end;


Procedure TrocaTabela;
begin
  TTNo := AAFx + Copy(MMFx,2,2) + '2';
  SearchTree4 ( Root4 );
  If RC = 'S' then
     begin
       ReadWrite(#03,'R','N',TTNumber);
       VP2 := 'S';
       For I := 1 to 50 do VPass2[I] := TTMember.VPass[I];
     end
     else VP2 := 'N';
  TTNo := AAFx + Copy(MMFx,2,2) + '1';
  SearchTree4 ( Root4 );
  If RC = 'S' then ReadWrite(#03,'R','N',TTNumber);
end;


Procedure TrocaMovimento;
begin
  Close  ( EEFile );
  Assign ( EEFile, (XPath + '\' + FileEE + AAFn + '.' + MMFn ));
  {$I-}
  Reset ( EEFile );
  {$I+}
  If IOResult <> 0 then
     begin
       Color(Blue,White);
       GotoXY(1,23); Write(' ':80);
       GotoXY(2,23); Write('O màs de ',ArrayMesEx[M],' de ',A:2,' ainda n∆o foi Aberto');
       TeclaReturn;
       Assign ( EEFile, (XPath + '\' + FileEE + AAFx + '.' + MMFx));
       Reset  ( EEFile );
       Opc := 'N';
     end
     else begin
            Close  ( MMFile );
            Assign ( MMFile,   (XPath + '\' + FileMM + AAFn + '.' + MMFn ));
            {$I-}
            Reset ( MMFile );
            {$I+}
            If IOResult <> 0 then
               begin
                 Color(Blue,White);
                 GotoXY(1,23); Write(' ':80);
                 GotoXY(2,23); Write('O màs de ',ArrayMesEx[M],' de ',A:2,
                                     ' ainda n∆o foi Aberto');
                 TeclaReturn;
                 Close  ( EEFile );
                 Assign ( EEFile, (XPath + '\' + FileEE + AAFx + '.' + MMFx));
                 Reset  ( EEFile );
                 Assign ( MMFile, (XPath + '\' + FileMM + AAFx + '.' + MMFx));
                 Reset  ( MMFile );
                 Opc := 'N';
               end
               else begin
                      If Root5 <> NIL then Dispose5 ( Root5 );
                      Root5 := NIL;
                      Assign ( Ind2File, (XPath + '\' + FileInd2 + AAFn + '.' + IIFn ));
                      {$I-}
                      Reset ( Ind2File );
                      {$I+}
                      If IOResult <> 0 then
                         begin
                           ReWrite ( Ind2File );
                           Reset   ( Ind2File );
                           Color(Blue,White);
                           GotoXY(1,23); Write(' ':80);
                           GotoXY(2,23); Write('N∆o h† °ndice para ',ArrayMesEx[M],' de ',A:2,' Indexe (Opá∆o I)');
                           TeclaReturn;
                         end
                         else LoadIndex2;
                      Close ( Ind2File );
                    end;
          end;
end;


Procedure TrocaMesScreen;
begin
  For I := 1 to 12 do begin
                        If I = M then Color(Bfn,Btx)
                                 else Color(Sfn,Stx);
                        GotoXY(32,(I+6)); Write(' ',PushLeft(10,ArrayMesEx[I]));
                      end;
  Color(Tfn,Ttx);
end;


Procedure MostraMes;
begin
  DrawBox(20,15,59,17,Red,'S');
  Color(Red,Yellow);
  GotoXY(21,16); Write('Processando o màs de ');
  Color(Red,White);
  GotoXY(42,16);
  Write(ArrayMesEx[CMstMember.MesAtivo],' de ',CMstMember.AnoAtivo);
  Delay(3000);
  Move(ScArray1[1],Mem[$B800:0000],4000);
end;


Procedure TrocaMesAno;
begin
  M  := MM;
  A  := AA;
  DrawBox(32,6,42,18,Sfn,'S');
  Color(Tfn,Ttx);
  GotoXY(32,6);  Write('    Màs    ');
  TrocaMesScreen;
  Repeat
    Repeat
      TC := ReadKey;
      If (TC = #0   ) and
         (KeyPressed) then
         begin
           TC := ReadKey;
           Case TC of
                #72 : begin
                        M := M - 1;
                        If M < 1 then M := 12;
                        TrocaMesScreen;
                      end;
                #80 : begin
                        M := M + 1;
                        If M > 12 then M := 1;
                        TrocaMesScreen;
                      end;
           end;
         end;
    Until TC in [#13,#27];
    If TC = #13 then Confirma;
  Until TC in [#27,'S'];
  If TC = 'S' then
     begin
       DrawBox(50,10,62,12,Sfn,'S');
       Color(Sfn,Stx);
       GotoXY(51,11); Write('Ano..:');
       Repeat
         Repeat
           If A = 0 then J := ''
                    else begin
                           Str(A:4,J);
                           J := LeftAdjust(J);
                         end;
           InputStr(J,4,58,11,0,'S','N','T','N',Sfn,Stx);
           If TC <> #27 then Val(J,A,E);
         Until TC in [#13,#27];
         If TC = #13 then Confirma;
       Until TC in [#27,'S'];
       If XCondicional[1] <> '#' then
          begin
            J := QQStr(M,2,'0') + QQStr(A,4,'0');
            If (J <> Copy(XCondicional,1,4)) and
               (J <> Copy(XCondicional,5,4)) then TC := #27;
          end;
       If (TC                   = 'S' ) and
          ((CMstMember.MesAtivo <> M )  or
           (CMstMember.AnoAtivo <> A )) then
          begin
            MMFn := 'M' + QQStr(M,2,'0');
            IIFn := 'I' + QQStr(M,2,'0');
            AAFn := QQStr(A,4,'0');
            Color(Bfn,(White + Blink));
            GotoXY(01,24); Write(' Aguarde ');
            Opc := 'S';
            TrocaMovimento;
            If Opc = 'S' then
               begin
                 CMstMember.MesAtivo := M;
                 CMstMember.AnoAtivo := A;
                 ReadWrite(#16,'W','N',0);
                 MM   := M;
                 AA   := A;
                 Vez  := 'S';
                 VezD := 'S';
                 VezR := 'S';
                 AAFx := AAFn;
                 MMFx := MMFn;
                 IIFx := IIFn;
                 TrocaTabela;
                 Resto := AA div 4;
                 If (AA - (Resto * 4)) = 0 then TabDia[2] := 29
                                           else TabDia[2] := 28;
                 Move(ScArray1[1],Mem[$B800:0000],4000);
                 ShowMes;
                 Move(Mem[$B800:0000],ScArray1[1],4000);
                 MostraMes;
                 Color(Tfn,Utx);
{                                       ReadWrite(#02,'W','N',CmpyNumber);}
                 BlkNo := CmpyNo + '#'+
                 QQStr(CMstMember.AnoAtivo,4,'0') + '/' +
                 QQStr(CMstmember.MesAtivo,2,'0');
                 SearchTreeB ( RootB );
                 If RC = 'S' then
                    begin
                      ReadWrite(#18,'R','N',BlkNumber);
                      If BlkStaMember.BlkStatus = 'B' then XSt := 'B'
                                                      else XSt := 'A';
                    end
                    else XSt := 'A';
               end;
          end;
     end;
end;


Procedure Horas(M : Real);
begin
  Hora   := Trunc(M / 60);
  Minuto := Trunc(M - (Hora * 60));
end;


Procedure HoraMinuto;
begin
  If Minuto > 60 then
     begin
       I := Trunc(Minuto / 60);
       Minuto := Minuto - (I * 60);
       Hora   := Hora   + I;
     end
     else If Minuto = 60 then
             begin
               Minuto := 0;
               Hora   := Hora + 1;
             end;
end;


Procedure HelpM;
begin
  Color(Red,White);
  GotoXY(64,22); Write(' Ctrl');
  GotoXY(72,22); Write(#26);
  Color(Red,Yellow);
  GotoXY(70,22); Write('F1');
  Color(Red,Cyan);
  GotoXY(69,22); Write('+');
  GotoXY(73,22); Write('Manual ');
end;


Procedure MenuAuxiliar(T : Integer; Bf,Bt,Nf,Nt : Byte);
begin
  For I := 1 to T do begin
                       If I = YY then Color(Bf,Bt)
                                 else Color(Nf,Nt);
                       GotoXY(TabX[I],TabY[I]); Write(TabI[I]);
                     end;
  Color(Tfn,Utx);
end;


Procedure RetMenuAuxiliar(C,L,N,P1,P2 : Integer);
Var
  Ta,La : Integer;
begin
  If P1 <> P2 then
     begin
       Ta := (Length(TabI[1])*2)+2+C;
       La := Trunc(N/2)+L+1;
     end
     else begin
            Ta := Length(TabI[1])+1+C;
            La := L+N+1;
          end;
  DrawBox(C,L,Ta,La,Sfn,'S');
  MenuAuxiliar(N,Tfn,Utx,Sfn,Stx);
  Repeat
    Resp := ReadKey;
    If (Resp = #0 ) and
       (KeyPressed) then
       begin
         Resp := ReadKey;
         Case Resp of
              #72 : begin
                      YY := YY - 1;
                      If YY < 1 then YY := N;
                    end;
              #75 : YY := P1;
              #77 : YY := P2;
              #80 : begin
                      YY := YY + 1;
                      If YY > N then YY := 1;
                    end;
         end;
         MenuAuxiliar(N,Tfn,Utx,Sfn,Stx);
       end;
  Until Resp = #13;
end;


Function Sal : Real;
Var
  X : Real;
begin
  If EEMember.Tipo = 'H' then X := EEMember.Salario * EEMember.HNormais
                         else X := EEMember.Salario;
  LoadMVDsk(#11);
  YYNo := '016';
  SearchTreeY ( RootY );
  If RC = 'S' then X := TruncX(X + YAddress^.AcMensalV);
  RC  := 'S';
  Sal := X;
end;


Procedure LoadCmpy;
begin
  MasterMember.NEmpresas := 0;
  I                      := -1;
  If FileSize(CmpyFile) > 0 then
     begin
       Repeat
         I := I + 1;
         ReadWrite(#02,'R','N',I);
         If RW = 'S' then
            begin
              CmpyNo     := CmpyMember.Chave;
              CmpyNumber := I;
              LoadTree0 ( Root0 );
              MasterMember.NEmpresas := MasterMember.NEmpresas + 1;
            end;
       Until (I + 1) = FileSize(CmpyFile);
     end;
  ReadWrite(#00,'W','N',0);
end;


Procedure LoadBlkSta;
begin
  I := -1;
  If FileSize(BlkStaFile) > 0 then
     begin
       Repeat
         I := I + 1;
         ReadWrite(#18,'R','N',I);
         If RW = 'S' then
            begin
              BlkNo     := BlkStaMember.Cia + '#' + BlkStaMember.MesAno;
              BlkNumber := I;
              LoadTreeB ( RootB );
            end;
       Until (I + 1) = FileSize(BlkStaFile);
     end;
end;


Procedure LoadIndex1;
begin
  If FileSize(Ind1File) > 0 then
     With Ind1Member do
     begin
       I  := -1;
       Repeat
         I := I + 1;
         ReadWrite(#13,'R','N',I);
         If RW = 'S' then
            begin
              XR := 0;
              Repeat
                XR := XR + 1;
                Case TipoX[XR] of
                     '1' : begin
                             CCNo     := ChaveX[XR];
                             CCNumber := RelAddrX[XR];
                             LoadTree1 ( Root1 );
                           end;
                     '2' : begin
                             SSNo     := ChaveX[XR];
                             SSNumber := RelAddrX[XR];
                             LoadTree2 ( Root2 );
                           end;
                     '4' : begin
                             TTNo     := ChaveX[XR];
                             TTNumber := RelAddrX[XR];
                             LoadTree4 ( Root4 );
                           end;
                end;
              Until XR = 56;
            end;
       Until (I + 1) = FileSize(Ind1File);
     end;
end;


Procedure LoadIndex2;
begin
  If FileSize(Ind2File) > 0 then
     begin
       I := -1;
       Repeat
         I := I + 1;
         ReadWrite(#14,'R','N',I);
         If RW = 'S' then
            begin
              XR := 0;
              Repeat
                XR := XR + 1;
                If Ind2Member.ChaveX[XR] <> '' then
                   begin
                     EENo     := Ind2Member.ChaveX[XR];
                     EENumber := Ind2Member.RelAddrX[XR];
                     LoadTree5 ( Root5 );
                   end;
              Until XR = 42;
            end;
       Until (I + 1) = FileSize(Ind2File);
     end;
end;


Procedure LoadIndex3;
begin
  If FileSize(Ind3File) > 0 then
     With Ind3Member do
     begin
       I  := -1;
       Repeat
         I := I + 1;
         ReadWrite(#15,'R','N',I);
         If RW = 'S' then
            begin
              XR := 0;
              Repeat
                XR := XR + 1;
                Case TipoX[XR] of
                     '0' : begin
                             HHNo     := ChaveX[XR];
                             HHNumber := RelAddrX[XR];
                             LoadTree10 ( Root10 );
                           end;
                     '3' : begin
                             DDNo     := ChaveX[XR];
                             DDNumber := RelAddrX[XR];
                             LoadTree3 ( Root3 );
                           end;
                     '7' : begin
                             BBNo     := ChaveX[XR];
                             BBNumber := RelAddrX[XR];
                             LoadTree7 ( Root7 );
                           end;
                     '8' : begin
                             OONo     := ChaveX[XR];
                             OONumber := RelAddrX[XR];
                             LoadTree8 ( Root8 );
                           end;
                end;
              Until XR = 24;
            end;
       Until (I + 1) = FileSize(Ind3File);
     end;
end;


Procedure LoadIndex6 (X,Y : Char);
begin
  If FileSize(EEFile) > 0 then
     With EEMember do
     begin
       Color(Blue,Cyan);
       GotoXY(1,24);  Write(ConstStr(' ',80));
       GotoXY(2,24);
       Write('Estou criando Indice para Impress∆o do ');
       Color(Blue,Yellow);
       GotoXY(41,24); Write('Relat¢rio');
       Color(Blue,(White + Blink));
       GotoXY(65,24); Write('Aguarde');
       Color(Black,Utx);
       If Root6 <> NIL then Dispose6 ( Root6 );
       Root6 := NIL;
       I := -1;
       Repeat
         I := I + 1;
         ReadWrite(#08,'R','N',I);
         Case X of
              'B' : If EEMember.PgConta = 'S' then
                       begin
                         Case Y of
                              'A' : XXNo := 'P#' + Copy(EEMember.BcoPG,1,3) + '#' +
                                            UpCaseStr(Copy(DesAcentua(EEMember.Nome),1,29))   + '#' +
                                            EEMember.Matricula;
                              'N' : XXNo := 'P#' + Copy(EEMember.BcoPG,1,3) + '#' +
                                            EEMember.Matricula;
                         end;
                         XXNumber := I;
                         LoadTree6 ( Root6 );
                       end;
              'D' : begin
                      Case Y of
                           'A' : XXNo := EEMember.Depto           + '#' +
                                         UpCaseStr(Copy(DesAcentua(EEMember.Nome),1,37)) + '#' +
                                         EEMember.Matricula;
                           'N' : XXNo := EEMember.Depto + '#' +
                                         EEMember.Matricula;
                      end;
                      XXNumber := I;
                      LoadTree6 ( Root6 );
                    end;
              'E' : begin
                      XXNumber := I;
                      Case Y of
                           'A' : begin
                                   XXNo := UpCaseStr(DesAcentua(EEMember.Nome)) + '#' +
                                           EEMember.Matricula;
                                   LoadTree6 ( Root6 );
                                 end;
                           'N' : begin
                                   XXNo := EEMember.Matricula;
                                   LoadTree6 ( Root6 );
                                 end;
                           'C' : For R := 1 to 5
                                 do If (EEMember.CentroC[R] <> '') and
                                       (EEMember.DiasC[R]   <> 0 ) then
                                       begin
                                         XXNo := EEMember.Matricula + '#' +
                                                 EEMember.CentroC[R];
                                         LoadTree6 ( Root6 );
                                       end;
                           'P' : begin
                                   XXNo := EEMember.PisPasep;
                                   LoadTree6 ( Root6 );
                                 end;
                      end;
                    end;
              'F' : begin
                      Case Y of
                           'A' : XXNo := 'F#'                         +
                                         LimpaChave(EEMember.BcoFgts) + '#' +
                                         UpCaseStr(Copy(DesAcentua(EEMember.Nome),1,29))     + '#' +
                                         EEMember.Matricula;
                           'N' : XXNo := 'F#'                         +
                                         LimpaChave(EEMember.BcoFgts) + '#' +
                                         EEMember.CTrabN;
                           'P' : XXNo := 'F#'                         +
                                         LimpaChave(EEMember.BcoFgts) + '#' +
                                         EEMember.PisPasep            + '#' +
                                         EEMember.Matricula;
                      end;
                      XXNumber := I;
                      LoadTree6 ( Root6 );
                    end;
              'S' : begin
                      Case Y of
                           'A' : XXNo := EEMember.Sindicato       + '#' +
                                         UpCaseStr(Copy(DesAcentua(EEMember.Nome),1,37)) + '#' +
                                         EEMember.Matricula;
                           'N' : XXNo := EEMember.Sindicato + '#' +
                                         EEMember.Matricula;
                      end;
                      XXNumber := I;
                      LoadTree6 ( Root6 );
                    end;
         end;
         ShowHeap;
       Until (I + 1) = FileSize(EEFile);
       LimpaLn(24,Tfd);
       TC := #13;
     end
     else begin
            ErroMsg := 'N∆o h† empregados em ' + ArrayMesEx[MM];
            ErrorMessage;
            TC := #27;
          end;
end;


Procedure Descarrega1;
begin
  If D1 = 'S' then
     begin
       {$I-}
       Erase ( Ind1File );
       {$I+}
       If IOResult = 0 then ReWrite ( Ind1File );
       {$I-}
       Reset   ( Ind1File );
       {$I+}
       If IOResult = 0 then
          begin
            Color(Blue,White);
            ClrScr;
            GotoXY(17,12);
            Write('Descarregando Arquivo Indice (( 1 ))  Aguarde');
            Color(Tfn,Utx);
            For XR := 1 to 56 do begin
                                   Ind1Member.TipoX[XR]    := 'X';
                                   Ind1Member.ChaveX[XR]   := '';
                                   Ind1Member.RelAddrX[XR] := 0;
                                 end;
            XR := 0;
            UnLoadTree1 ( Root1 );
            UnLoadTree2 ( Root2 );
            UnLoadTree4 ( Root4 );
            If XR > 0 then
               begin
                 XR := 56;
                 UnloadIndex1;
               end;
            Close ( Ind1File );
            D1 := 'N';
          end
          else begin
                 Color(Blue,Cyan);
                 GotoXY(01,23);  Write(ConstStr(' ',80));
                 GotoXY(02,23);  Write('N∆o estou conseguindo descarregar o Indice (( 1 ))');
                 TeclaReturn;
                 LimpaLn(23,Black);
               end;
     end;
end;


Procedure Descarrega2;
begin
  If D2 = 'S' then
     begin
       {$I-}
       Erase ( Ind2File );
       {$I+}
       If IOResult = 0 then ReWrite ( Ind2File );
       {$I-}
       Reset   ( Ind2File );
       {$I+}
       If IOResult = 0 then
          begin
            Color(Red,White);
            ClrScr;
            GotoXY(17,12);
            Write('Descarregando Arquivo Indice (( 2 ))  Aguarde');
            Color(Tfn,Utx);
            For XR := 1 to 42 do begin
                                   Ind2Member.ChaveX[XR]    := '';
                                   Ind2Member.RelAddrX[XR]  := 0;
                                 end;
            XR := 0;
            UnLoadTree5 ( Root5 );
            If XR > 0 then
               begin
                 XR := 42;
                 UnloadIndex2;
               end;
            Close ( Ind2File );
            D2 := 'N';
          end
          else begin
                 Color(Blue,Cyan);
                 GotoXY(01,23);  Write(ConstStr(' ',80));
                 GotoXY(02,23);  Write('N∆o estou conseguindo descarregar o Indice (( 2 ))');
                 TeclaReturn;
                 LimpaLn(23,Black);
               end;
     end;
end;


Procedure Descarrega3;
begin
  If D3 = 'S' then
     begin
       {$I-}
       Erase ( Ind3File );
       {$I+}
       If IOResult = 0 then ReWrite ( Ind3File );
       {$I-}
       Reset   ( Ind3File );
       {$I+}
       If IOResult = 0 then
          begin
            Color(Green,White);
            ClrScr;
            GotoXY(17,12);
            Write('Descarregando Arquivo Indice (( 3 ))  Aguarde');
            Color(Tfn,Utx);
            For XR := 1 to 24 do begin
                                   Ind3Member.TipoX[XR]    := 'X';
                                   Ind3Member.ChaveX[XR]   := '';
                                   Ind3Member.RelAddrX[XR] := 0;
                                 end;
            XR := 0;
            UnLoadTree3  ( Root3  );
            UnLoadTree7  ( Root7  );
            UnLoadTree8  ( Root8  );
            UnLoadTree10 ( Root10 );
            If XR > 0 then
               begin
                 XR := 24;
                 UnloadIndex3;
               end;
            Close ( Ind3File );
            D3 := 'N';
          end
          else begin
                 Color(Blue,Cyan);
                 GotoXY(01,23);  Write(ConstStr(' ',80));
                 GotoXY(02,23);  Write('N∆o estou conseguindo descarregar o Indice (( 3 ))');
                 TeclaReturn;
                 LimpaLn(23,Black);
                 Color(Tfn,Utx);
               end;
     end;
end;


Procedure LoadMVDsk(X : Char);
Var
  I,S    : Integer;
  Sq     : String[1];
begin
  I := 0;
  S := 0;
  Repeat
    S := S + 1;
    If EEMember.Movimento[S] <> Limite then
       begin
         ReadWrite(X,'R','N',EEMember.Movimento[S]);
         If RW = 'S' then
            For I := 1 to 10
            do If MMMember.Conta[I] <> '' then
                  begin
                    YYNo := MMMember.Conta[I];
                    LoadTreeY ( RootY );
                    YAddress^.Origem    := MMMember.Origem[I];
                    YAddress^.AcMensalV := MMMember.AcMensalV[I];
                    YAddress^.AcMensalH := MMMember.AcMensalH[I];
                    YAddress^.AcMensalM := MMMember.AcMensalM[I];
                    YAddress^.AcAnualV  := MMMember.AcAnualV[I];
                    YAddress^.AcAnualH  := MMMember.AcAnualH[I];
                    YAddress^.AcAnualM  := MMMember.AcAnualM[I];
                    YAddress^.QtdResc   := MMMember.QtdResc[I];
                    YAddress^.Parcelas  := MMMember.Parcelas[I];
                    YAddress^.BaseUsr   := MMMember.BaseUsr[I];
                    YAddress^.PerctUsr  := MMMember.PerctUsr[I];
                  end;
       end
       else RW := 'N';
  Until (RW = 'N') or (S = 9);
end;


Procedure LiberaMVDsk;
begin
  If RootY <> NIL then DisposeY ( RootY );
  RootY := NIL;
end;


Procedure LimpaMVDsk;
begin
  YYNo := '';
  Repeat
    RC := 'N';
    SearchPosY ( RootY );
    If RC = 'S' then If (YAddress^.Origem    = 'S') and
                        (YAddress^.AcMensalV = 0  ) and
                        (YAddress^.AcMensalH = 0  ) and
                        (YAddress^.AcMensalM = 0  ) and
                        (YAddress^.AcAnualV  = 0  ) and
                        (YAddress^.AcAnualH  = 0  ) and
                        (YAddress^.AcAnualM  = 0  ) then DelTreeY ( RootY );
  Until RC = 'N';
end;


Procedure ZeraConta;
Var
  I  : Integer;
begin
  For I := 1 to 10 do
  begin
    MMMember.Conta[I]       := '';
    MMMember.Origem[I]      := ' ';
    MMMember.AcMensalV[I]   := 0;
    MMMember.AcMensalH[I]   := 0;
    MMMember.AcMensalM[I]   := 0;
    MMMember.AcAnualV[I]    := 0;
    MMMember.AcAnualH[I]    := 0;
    MMMember.AcAnualM[I]    := 0;
    MMMember.QtdResc[I]     := '';
    MMMember.Parcelas[I]    := 0;
    MMMember.BaseUsr[I]     := ' ';
    MMMember.PerctUsr[I]    := 0;
  end;
end;


Procedure UnLoadMVDsk;
Var
  I,S    : Integer;
  Sq     : String[1];
begin
  If RootY <> NIL then
     begin
       S    := 0;
       YYNo := '';
       Repeat
         ZeraConta;
         I := 0;
         Repeat
           RC := 'N';
           SearchPosY ( RootY );
           If RC = 'S' then
              begin
                If (YYNo                = '030') or
                   (YAddress^.Origem    = 'U'  ) or
                   (YAddress^.AcMensalV > 0    ) or
                   (YAddress^.AcMensalH > 0    ) or
                   (YAddress^.AcMensalM > 0    ) or
                   (YAddress^.AcAnualV  > 0    ) or
                   (YAddress^.AcAnualH  > 0    ) or
                   (YAddress^.AcAnualM  > 0    ) then
                   begin
                     I := I + 1;
                     MMMember.Conta[I]     := YYNo;
                     MMMember.Origem[I]    := YAddress^.Origem;
                     MMMember.AcMensalV[I] := YAddress^.AcMensalV;
                     MMMember.AcMensalH[I] := YAddress^.AcMensalH;
                     MMMember.AcMensalM[I] := YAddress^.AcMensalM;
                     MMMember.AcAnualV[I]  := YAddress^.AcAnualV;
                     MMMember.AcAnualH[I]  := YAddress^.AcAnualH;
                     MMMember.AcAnualM[I]  := YAddress^.AcAnualM;
                     MMMember.QtdResc[I]   := YAddress^.QtdResc;
                     MMMember.Parcelas[I]  := YAddress^.Parcelas;
                     MMMember.BaseUsr[I]   := YAddress^.BaseUsr;
                     MMMember.PerctUsr[I]  := YAddress^.PerctUsr;
                   end;
              end;
         Until (I = 10) or (RC = 'N');
         S := S + 1;
         MMMember.Empregado := EENo;
         If EEMember.Movimento[S] = Limite then
            begin
              If I > 0 then
                 begin
                   EEMember.Movimento[S] := FileSize(MMFile);
                   ReadWrite(#11,'W','N',EEMember.Movimento[S]);
                 end;
            end
            else If I = 0 then
                    begin
                      ZeraConta;
                      MMMember.Empregado := '';
                      ReadWrite(#11,'W','N',EEMember.Movimento[S]);
                      EEMember.Movimento[S] := Limite;
                    end
                    else ReadWrite(#11,'W','N',EEMember.Movimento[S]);
       Until RC = 'N';
       If S < 9 then For I := S+1 to 9 do
                     begin
                       If EEMember.Movimento[I] <> Limite then
                          begin
                            ReadWrite(#11,'R','N',EEMember.Movimento[I]);
                            MMMember.Empregado := '';
                            ReadWrite(#11,'W','N',EEMember.Movimento[I]);
                            EEMember.Movimento[I] := Limite;
                          end;
                     end;
       ReadWrite(#08,'W','N',EENumber);
       LiberaMVDsk;
     end;
end;

Procedure Inicializa(X : Char);
begin
  Laser    := MasterMember.LJet;
  XPrinter := MasterMember.TipoImpr;
  If X <> 'T'then
     begin
       Dx   := MasterMember.Don;
       Df   := MasterMember.Dof;
       Cx   := MasterMember.Con;
       Cf   := MasterMember.Cof;
       Nx   := MasterMember.Non;
       Nf   := MasterMember.Nof;
       QP   := MasterMember.Qpa;
     end
     else begin
            Dx    := '';
            Df    := '';
            Cx    := '';
            Cf    := '';
            Nx    := '';
            Nf    := '';
            QP    := '';
            Laser := 'X';
          end;
end;

Procedure HelpStatus;
begin
  Move(Mem[$B800:0000],ScArray5[1],4000);
  DrawBox(06,05,21,19,Red,'S');
  Color(Red,Cyan);
  GotoXY(07,05); Write(' tivo         ');
  GotoXY(07,06); Write('Dem.Es ontanea');
  GotoXY(07,07); Write(' emitido      ');
  GotoXY(07,08); Write('Entr.Transf.  ');
  GotoXY(07,09); Write(' usta Causa   ');
  GotoXY(07,10); Write('TÇrm.Contrato ');
  GotoXY(07,11); Write(' escindido    ');
  GotoXY(07,12); Write(' Çrias        ');
  GotoXY(07,13); Write(' icenáa       ');
  GotoXY(07,14); Write('A identado    ');
  GotoXY(07,15); Write(' orte         ');
  GotoXY(07,16); Write(' ransferido   ');
  GotoXY(07,17); Write('A iso PrÇvio  ');
  GotoXY(07,18); Write('Ap sentado    ');
  GotoXY(07,19); Write('E cluir Reg.  ');
  Color(Red,White);
  GotoXY(07,05); Write('A');
  GotoXY(13,06); Write('p');
  GotoXY(07,07); Write('D');
  GotoXY(07,08); Write('E');
  GotoXY(07,09); Write('J');
  GotoXY(14,10); Write('n');
  GotoXY(07,11); Write('R');
  GotoXY(07,12); Write('F');
  GotoXY(07,13); Write('L');
  GotoXY(08,14); Write('c');
  GotoXY(07,15); Write('M');
  GotoXY(07,16); Write('T');
  GotoXY(08,17); Write('v');
  GotoXY(09,18); Write('o');
  GotoXY(08,19); Write('x');
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
{  AA := Ano - 1900;}
end.

