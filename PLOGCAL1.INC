Procedure CalculaRepouso;
Var
  Repouso     : Real;
begin
  Repouso   := 0;
  YYNo      := '';
  Repeat
    RC := 'N';
    SearchPosY ( RootY );
    If RC = 'S' then
       begin
         CCNo := YYNo;
         SearchTree1 ( Root1 );
         If RC = 'S' then
            begin
              ReadWrite(#04,'R','N',CCNumber);
              If (RW                  = 'S'                     ) and
                 ((CCMember.Operacao  = Eta                   )   or
                  ((Eta               = 'P'                   )   and
                   (CCMember.Operacao in ['1','2','3','4','A'])   and
                   (CCNo              > '100'                 ))) then
                 begin
                   Valor := TruncX(YAddress^.AcMensalV);
                   If CCMember.RepousoM = 'S' then
                      Case CCMember.Tipo of
                           'P' : Repouso := Repouso + Valor;
                           'D' : Repouso := Repouso - Valor;
                      end;
                 end;
            end
            else RC := 'S';
       end;
  Until RC = 'N';
  If Eta <> 'S' then
     begin
       YYNo := '040';
       RecuperaConta;
       If (YAddress^.Origem = 'S') and (Repouso > 0) then YAddress^.AcMensalV := TruncX(Repouso / 6);
     end;
end;


