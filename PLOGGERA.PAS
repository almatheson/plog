{$O+,F+}
Unit PlogGera;

Interface


Uses Crt,Dos,PlogGlbs,PlogBasP;


   Procedure ColorSetUp;
   Procedure ConfigPrinter;
   Procedure InitialScreen(Var SName  : Str6;
                               X      : Char);
   Procedure ScreenHeader (Var SName  : Str6;
                               UName  : Str40;
                               X      : Char);

   Procedure MainScreenFrame(X1,X2 : Str80);

   Procedure MainScreenTitle1(T : Integer);
   Procedure MainScreenTitle2(T : Integer);
   Procedure MainScreenTitle3(T : Integer);

   Procedure EntryPassword(P : Char);
   Procedure EntryPswCia;
   Procedure Drive;
   Procedure CalculoBase (Prodt : Str6;
                          Campo : Str80);
   Procedure ShowLicenciamento;
   Procedure EntryOwner;
   Procedure EntryOwnerMarca;


Implementation

{$I ColorSet.rot }
{$I ConfigPr.rot }
{$I Base.rot     }
{$I Login.rot    }
{$I ShowLic.rot  }

Procedure EntryOwner;
begin
  With OwnerMember do
  begin
    Repeat
      K := 1;
      Repeat
        Case K of
             1   : begin
                     J := Endereco;
                     InputStr(J,40,12,17,0,'S','N','T','N',Tfn,Utx);
                     Endereco := J;
                   end;
             2   : begin
                     J := Cidade;
                     InputStr(J,20,12,18,0,'S','N','T','N',Tfn,Utx);
                     Cidade := J;
                   end;
             4   : begin
                     J := Estado;
                     InputStr(J,2,41,18,0,'S','N','T','N',Tfn,Utx);
                     Estado := UpCaseStr(J);
                     GotoXY(41,18); Write(Estado);
                   end;
             5   : begin
                     J := Cep;
                     InputStr(J,9,44,18,0,'S','N','T','N',Tfn,Utx);
                     Cep := J;
                   end;
             6   : begin
                     J := CGC;
                     InputStr(J,20,12,19,0,'S','N','T','N',Tfn,Utx);
                     CGC := J;
                   end;
             7   : begin
                     J := Telefone;
                     InputStr(J,15,41,19,0,'S','N','T','N',Tfn,Utx);
                     Telefone := J;
                   end;
             8   : begin
                     J := Inscricao;
                     InputStr(J,20,12,20,0,'S','N','T','N',Tfn,Utx);
                     Inscricao := J;
                   end;
        end;
        Case TC of
             #13 : K := K + 1;
             #24 : If K > 1 then K := K - 1
                            else K := 8;
        end;
      Until (K = 9) or (TC = #27);
      If TC <> #27 then Confirma;
    Until TC in ['S',#27];
    If UpCase(TC) = 'S' then ReadWrite(#01,'W','N',0);
  end;
end;

Procedure EntryOwnerMarca;
begin
  With OwnerMember do
  begin
    Repeat
      Repeat
        J := Marca;
        InputStr(J,15,62,10,0,'S','N','T','N',Red,Yellow);
        Marca := J;
      Until TC in [#13,#27];
      If TC <> #27 then Confirma;
    Until TC in ['S',#27];
    If UpCase(TC) = 'S' then ReadWrite(#01,'W','N',0);
  end;
end;


end.
