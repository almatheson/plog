{$O+,F+}

Unit AlogBasP;

Interface

Uses Crt,Dos,AlogGlbs;


   Function ConstStr   (C : Char; N : Integer) : AnyStr;
   Function UpCaseStr  (S : Str80 ) : Str80;
   Function LeftAdjust (S : Str80 ) : Str80;
   Function RightAdjust(T : Integer; S : Str80 ) : Str80;
   Function Trim       (S : Str80 ) : Str80;
   Function EditDouble (V : Double) : Str80;
   Function EditInteger(V : Integer): Str80;
   Function TruncX     (V : Double) : Double;
   Function Acentua    (S : AnyStr) : AnyStr;
   Function LimpaChave (S : Str80 ) : Str80;
   Function QQStr      (X : Real; I : Integer; F : Char) : Str80;
   Function PushLeft   (I : Integer; X : AnyStr) : AnyStr;
   Function PushRight  (I : Integer; X : AnyStr) : AnyStr;
   Function ChkData    (S : Str10 ) : Str10;
   Procedure InputStr  (var S         : AnyStr;
                            L, X, Y,P : Integer;
			    B,H,C,E   : Char;
			    F,T       : Byte);

   Procedure SetCursor ( n : Integer );
   Procedure Color (Back : Byte;
                    Txto : Byte);
   Procedure Limpaln(L : Integer; C : Byte);
   Procedure ShowHeap;
   Procedure ShowMes;
   Procedure Shade(L,T,R,B : Integer;
                   CT,CB   : byte    );
   Procedure DrawBox(Esq,Top,Dir,Bot : Integer;
                     Fundo           : Byte   ;
                     Sbra            : char   );
   Procedure ScreenFrame;
   Procedure CheckUF ( Uf : Str2);
   Procedure ErrorMessage;
   Procedure Confirma;
   Procedure AvisoFinal;
   Procedure Extenso(Tm1,Tm2,Tm3 : Integer; VStr : Str80  );
   Procedure GoNoGo;
   Procedure FootScroll;
   Procedure DirScroll(X : Char);
   Procedure ScrollFim;
   Procedure TestaImpressora(X : Char; Y : Str40);
   Procedure WriteLine(T : Char; L : AnyStr);
   Procedure QPorta;
   Procedure ScrollRpt;
   Procedure Footer;
   Procedure HelpM;
   Procedure ParaContinua;
   Procedure TeclaReturn;
   Procedure Inicializa(X : Char);
   Procedure MenuAuxiliar(T : Integer; Bf,Bt,Nf,Nt : Byte);
   Procedure RetMenuAuxiliar(C,L,N,P1,P2 : Integer);


Implementation
Var
  Resto   : Real;

{$I ConstStr.rot }
{$I UpCaseSt.rot }
{$I LeftAdjt.rot }
{$I RightAdj.rot }
{$I Trim.rot     }
{$I EditIntg.rot }
{$I TruncD.rot   }
{$I Acentua.rot  }
{$I QQStr.rot    }
{$I PushLeft.rot }
{$I PushRigh.rot }
{$I SetCurso.rot }
{$I Color.rot    }
{$I LimpaLn.rot  }
{$I ShowHeap.rot }
{$I ShowMes.rot  }
{$I ChkData.rot  }
{$I InputStr.rot }
{$I DrawBox.rot  }
{$I Frame.rot    }
{$I CheckUF.rot  }
{$I ErroMsg.rot  }
{$I Confirma.rot }
{$I AvisoFin.rot }
{$I LimpaChv.rot }
{$I Extenso.rot  }
{$I QPorta.rot   }
{$I Footer.rot   }
{$I TeclaR.rot   }


Function EditDouble (V : Double) : Str80;
var
   S       : string[80];
begin
  V := Abs(TruncX(V));
  Str(V:0:2,S);
  S[Length(S) - 2] := ',';
  If Length(S) > 6  then Insert('.',S,(Length(S) -  5));
  If Length(S) > 10 then Insert('.',S,(Length(S) -  9));
  If Length(S) > 14 then Insert('.',S,(Length(S) - 13));
  EditDouble := S;
end;


Procedure GoNoGo;
begin
  If KeyPressed then
     begin
       TC := ReadKey;
       If TC = #13 then
          Repeat
            TC := ReadKey;
          Until (TC = #13) or (TC = #27);
     end;
end;


Procedure FootScroll;
begin
  Color(Blue,White);
  GotoXY(01,23); Write(ConstStr(' ',80));
  GotoXY(04,23); Write(#25);
  GotoXY(06,23); Write('PgDn');
  GotoXY(25,23); Write(#24);
  GotoXY(27,23); Write('PgUp');
  GotoXY(47,23); Write('Esc');
  GotoXY(61,23); Write('Enter');
  Color(Blue,Cyan);
  GotoXY(05,23); Write('/');
  GotoXY(11,23); Write(#26,' Pr¢xima');
  GotoXY(26,23); Write('/');
  GotoXY(32,23); Write(#26,' Anterior');
  GotoXY(51,23); Write(#26,' Fim');
  GotoXY(67,23); Write(#26,' Seleciona');
  LimpaLn(24,Red);
end;


Procedure DirScroll(X : Char);
begin
  Case X of
       #72 : begin
               Color(Blue,White);
               GotoXY(04,23); Write(#25);
               GotoXY(06,23); Write('PgDn');
               GotoXY(27,23); Write('PgUp');
               Color(Blue,(White + Blink));
               GotoXY(25,23); Write(#24);
             end;
       #73 : begin
               Color(Blue,White);
               GotoXY(04,23); Write(#25);
               GotoXY(06,23); Write('PgDn');
               GotoXY(25,23); Write(#24);
               Color(Blue,(White + Blink));
               GotoXY(27,23); Write('PgUp');
             end;
       #80 : begin
               Color(Blue,(White + Blink));
               GotoXY(04,23); Write(#25);
               Color(Blue,White);
               GotoXY(06,23); Write('PgDn');
               GotoXY(25,23); Write(#24);
               GotoXY(27,23); Write('PgUp');
             end;
       #81 : begin
               Color(Blue,(White + Blink));
               GotoXY(06,23); Write('PgDn');
               Color(Blue,White);
               GotoXY(04,23); Write(#25);
               GotoXY(25,23); Write(#24);
               GotoXY(27,23); Write('PgUp');
             end;
  end;
end;


Procedure ScrollFim;
begin
  Color(Red,White);
  GotoXY(1,24);  Write(ConstStr(' ',80));
  GotoXY(1,24);  Write(' Fim da Lista');
  Color(Sfn,Stx);
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


Procedure ParaContinua;
begin
  Color(Red,Cyan);
  GotoXY(01,24); Write(ConstStr(' ',80));
  GotoXY(20,24); Write('      ',#026,' Para/Continua          ',#026,' Cancela');
  Color(Red,White);
  GotoXY(20,24); Write('Enter');
  GotoXY(47,24); Write('Esc');
  Color(Tfn,Utx);
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


Procedure Reseta;
begin
  Vez     := 'S';
  VezD    := 'S';
  VezR    := 'S';
  DI      := 'N';
  DL      := 'N';
  DM      := 'N';
  Limite  := 32000;
  XDir    := '';
  MF      := 'N';
  XSt     := '*';
  OpMn    := 'N';
end;


end.

