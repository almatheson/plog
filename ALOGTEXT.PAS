{$O+,F+}
Unit AlogText;

Interface

Uses Crt,Dos,AlogGlbs,AlogNavg,AlogBasP;


{$I LogTxt1.rot }


Function FReal(I : Real; D,T : Integer) : Str30;
Const
  Zeros    = '000000000000000000000000000000';
Var
  Compl    : Char;
  St1,St2  : String[30];
begin
  If I < 0 then
     begin
       Compl := '-';
       I     := I * -1;
     end
     else Compl := '0';
  Str(I:15:D,St1);
  St1 := LeftAdjust(St1);
  If Length(St1) < T then St2 := Copy(Zeros,1,(T - Length(St1))) + St1
                     else St2 := St1;
  St2[1] := Compl;
  FReal  := St2;
end;


Function Campo(E,S : Char; C,T1,T2,T3 : Integer; X : Str80) : AnyStr;
begin
  Case E of
       'D' : Case C of
                  01 : Campo := XDia + '/' + XMes + '/' + XAno;
                  02 : Campo := XDia + ' de ' + ArrayMesEx[Mes] + ' de ' + XAno;
                  03 : Campo := QQStr(MM,2,'0') + '/' + QQStr(AA,4,'0');
                  04 : Campo := ArrayMesEx[MM] + ' de 19' + QQStr(AA,4,'0');
                  05 : Campo := QQStr(TabDia[MM],2,'0') + '/' +
                                QQStr(MM,2,'0') + '/' + QQStr(AA,4,'0');
                  06 : Campo := QQStr(TabDia[MM],2,'0') + ' de ' +
                                ArrayMesEx[MM] + ' de ' + QQStr(AA,4,'0');
                  07 : Campo := QQStr(TabDia[MM],2,'0');
                  08 : begin
                         K     := Length(ArrayMesEx[MM]);
                         Campo := ArrayMesEx[MM] + ConstStr(' ',(10-K));
                       end;
                  09 : Campo := QQStr(AA,4,'0');
                  10 : Campo := QQStr(AA,2,'0');
                  else Campo := '';
             end;
       'E' : Case C of
                  01 : Campo := CMstMember.Descricao;
                  02 : Campo := CMstMember.Endereco;
                  03 : Campo := CMstMember.Cidade;
                  03 : Campo := CMstMember.Estado;
                  04 : Campo := CMstMember.Cep;
                  05 : Campo := CMstMember.DDD;
                  06 : Campo := CMstMember.Telefone;
                  07 : Campo := CMstMember.CpfCgc;
                  08 : Campo := CMstMember.IdInscr;
                  else Campo := '';
             end;
       'C' : begin
               ContaNo := LimpaChave(X);
               SearchTree1 ( Root1 );
               If RC = 'S' then
                  begin
                    ReadWrite(#03,'R','N',ContaNumber);
                    ReadWrite(#06,'R','N',ContaNumber);
                  end
                  else C := 00;
               Case C of
                  01 : Campo := ContaMember.OrigConta;
                  02 : If Length(ContaMember.Descricao) = 40
                          then Campo := ContaMember.Descricao
                          else Campo := ContaMember.Descricao +
                                        ConstStr(' ',(40-Length(ContaMember.Descricao)));
                  03 : If (S                      = '+') and
                          (SaldMember.SaldoB[MM] >= 0  )
                          then Campo := '<' + EditDouble(SaldMember.SaldoB[MM]) + '>'
                          else If (S                     = '-') and
                                  (SaldMember.SaldoB[MM] < 0  )
                                  then Campo := '<' + EditDouble(SaldMember.SaldoB[MM]) + '>'
                                  else Campo := ' ' + EditDouble(SaldMember.SaldoB[MM]) + ' ';
                  04..06 : begin
			     Extenso(T1,T2,T3,EditDouble(SaldMember.SaldoB[MM]));
			     Case C of
                                  04 : Campo := Res1;
                                  05 : Campo := Res2;
                                  06 : Campo := Res3;
                             end;
                           end;
                  else Campo := '';
               end;
             end;
       'S' : Case C of
                  01 : Campo := ContaMember.OrigConta;
                  02 : Campo := ContaMember.Descricao;
                  03 : If SaldMember.SaldoB[MM] >= 0
                          then Campo := EditDouble(SaldMember.SaldoB[MM])
                          else If SaldMember.SaldoB[MM] < 0
                                  then Campo := '-' + EditDouble(SaldMember.SaldoB[MM]);
                  04 : Campo := FReal(SaldMember.SaldoB[MM],2,T1);
             end;
  end;
end;

{$I LogTxt2.rot }

end.

