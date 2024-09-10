{$O+,F+}
Unit AlogTerm;

Interface

Uses Crt,Dos,AlogGlbs,AlogNavg,AlogBasP;


   Procedure EntryTermoReport;
   Procedure ProcNo05Report;


Implementation


Procedure EntryTermoReport;
begin
  Color(Tfn,Ttx);
  GotoXY(4,10);  Write('A ou F:');
  GotoXY(4,11);  Write('Ativid:');
  GotoXY(4,12);  Write('N§.Fol:');
  GotoXY(4,13);  Write('Livro.:');
  GotoXY(4,14);  Write('Regist:');
  GotoXY(35,14); Write('Junta.:');
  GotoXY(4,15);  Write('Data..:');
  GotoXY(4,16);  Write('Tit-1.:');
  GotoXY(4,17);  Write('Assin1:');
  GotoXY(4,18);  Write('Tit-2.:');
  GotoXY(4,19);  Write('Assin2:');
  GotoXY(4,20);  Write('Local.:');
  GotoXY(35,20); Write('Data..:');
  Tipo      := ' ';
  Atividade := '';
  NumF      := 0;
  Livro     := 0;
  RegJunta  := '';
  Junta     := '';
  DataDP    := '';
  Titulo1   := '';
  Assin1    := '';
  Titulo2   := '';
  Assin2    := '';
  Local     := '';
  DDD       := ' ';
  MMM       := 0;
  AAA       := ' ';
  Repeat
    K := 1;
    Repeat
    Case K of
         1   : begin
                 J := Tipo;
                 GotoXY(14,10); Write(' ':20);
		 InputStr(J,1,12,10,0,'S',Tfn,Utx);
                 If TC <> #27 then
                    begin
                      Tipo := UpCase(J[1]);
                      GotoXY(12,10); Write(Tipo);
                      GotoXY(14,10);
                      Case Tipo of
                           'A' : begin
                                   Write('Abertura  ');
                                   Folha := 1;
                                 end;
                           'F' : begin
                                   Write('Fechamento');
                                 end;
                           else begin
                                  ErroMsg := 'Tipo pode ser A ou F';
                                  ErrorMessage;
                                  K       := K - 1;
                                end;
                      end;
                    end;
               end;
         2   : begin
                 J := Atividade;
		 InputStr(J,15,12,11,0,'S',Tfn,Utx);
                 If TC <> #27 then
                    begin
                      Atividade := J;
                      If Atividade = '' then
                         begin
                           ErroMsg := 'Atividade Inv lida';
                           ErrorMessage;
                           K       := K - 1;
                         end;
                    end;
               end;
         3   : begin
                 If NumF = 0 then J := ''
                             else begin
                                    Str(NumF:4,J);
                                    J := LeftAdjust(J);
                                  end;
		 InputStr(J,4,12,12,0,'S',Tfn,Utx);
                 If TC <> #27 then
                    begin
                      Val(J,NumF,E);
                      If NumF = 0 then
                         begin
                           ErroMsg := 'N£mero de Folhas Inv lido';
                           ErrorMessage;
                           K       := K - 1;
                         end
                         else begin
                                GotoXY(12,12); Write(NumF:4);
                                If Tipo = 'F' then Folha := NumF;
                              end;
                    end;
               end;
         4   : begin
                 If Livro = 0 then J := ''
                              else begin
                                     Str(Livro:4,J);
                                     J := LeftAdjust(J);
                                   end;
		 InputStr(J,4,12,13,0,'S',Tfn,Utx);
                 If TC <> #27 then
                    begin
                      Val(J,Livro,E);
                      If Livro = 0 then
                         begin
                           ErroMsg := 'N£mero do Livro Inv lido';
                           ErrorMessage;
                           K       := K - 1;
                         end
                         else begin
                                GotoXY(12,13); Write(Livro:4);
                              end;
                    end;
               end;
         5   : begin
                 J := RegJunta;
		 InputStr(J,20,12,14,0,'S',Tfn,Utx);
                 If TC <> #27 then
                    begin
                      RegJunta := J;
                      If RegJunta = '' then
                         begin
                           ErroMsg := 'N£mero de Reg.na Junta Inv lido';
                           ErrorMessage;
                           K       := K - 1;
                         end;
                    end;
               end;
         6   : begin
                 J := Junta;
		 InputStr(J,10,43,14,0,'S',Tfn,Utx);
                 If TC <> #27 then
                    begin
                      Junta := J;
                      If Junta = '' then
                         begin
                           ErroMsg := 'Nome da Junta Inv lido';
                           ErrorMessage;
                           K       := K - 1;
                         end;
                    end;
               end;
         7   : begin
                 J := DataDP;
		 InputStr(J,8,12,15,0,'S',Tfn,Utx);
                 If TC <> #27 then
                    begin
                      DataDP := J;
                      If DataDP = '' then
                         begin
                           ErroMsg := 'Data de Despacho Inv lida';
                           ErrorMessage;
                           K       := K - 1;
                         end;
                    end;
               end;
         8   : begin
                 J := Titulo1;
		 InputStr(J,35,12,16,0,'S',Tfn,Utx);
                 If TC <> #27 then Titulo1 := J;
               end;
         9   : begin
                 J := Assin1;
		 InputStr(J,35,12,17,0,'S',Tfn,Utx);
                 If TC <> #27 then
                    begin
                      Assin1 := J;
                      If Assin1 = '' then
                         begin
                           ErroMsg := 'Respons vel 1 Inv lido';
                           ErrorMessage;
                           K       := K - 1;
                         end;
                    end;
               end;
         10  : begin
                 J := Titulo2;
		 InputStr(J,35,12,18,0,'S',Tfn,Utx);
                 If TC <> #27 then Titulo2 := J;
               end;
         11  : begin
                 J := Assin2;
		 InputStr(J,35,12,19,0,'S',Tfn,Utx);
                 If TC <> #27 then
                    begin
                      Assin2 := J;
                      If Assin2 = '' then
                         begin
                           ErroMsg := 'Respons vel 2 Inv lido';
                           ErrorMessage;
                           K       := K - 1;
                         end;
                    end;
               end;
         12  : begin
                 J := Local;
		 InputStr(J,20,12,20,0,'S',Tfn,Utx);
                 If TC <> #27 then
                    begin
                      Local := J;
                      If Local = '' then
                         begin
                           ErroMsg := 'Local Inv lido';
                           ErrorMessage;
                           K       := K - 1;
                         end;
                    end;
               end;
         13  : begin
                 J := DDD;
		 InputStr(J,2,43,20,0,'S',Tfn,Utx);
                 If TC <> #27 then
                    begin
                      DDD := J;
                      If DDD = '' then
                         begin
                           ErroMsg := 'Dia de Assinatura Inv lido';
                           ErrorMessage;
                           K       := K - 1;
                         end;
                    end;
               end;
         14  : begin
                 GotoXY(45,20); Write('/');
                 If MMM = 0 then J := ''
                           else begin
                                  Str(MMM:2,J);
                                  J := LeftAdjust(J);
                                end;
		 InputStr(J,2,46,20,0,'S',Tfn,Utx);
                 If TC <> #27 then
                    begin
                      Val(J,MMM,E);
                      If MMM = 0 then
                         begin
                           ErroMsg := 'Mˆs de Assinatura Inv lido';
                           ErrorMessage;
                           K       := K - 1;
                         end;
                    end;
               end;
         15  : begin
                 GotoXY(45,20); Write('/');
                 GotoXY(48,20); Write('/');
                 J := AAA;
		 InputStr(J,2,49,20,0,'S',Tfn,Utx);
                 If TC <> #27 then
                    begin
                      AAA := J;
                      If AAA = '' then
                         begin
                           ErroMsg := 'Ano de Assinatura Inv lido';
                           ErrorMessage;
                           K       := K - 1;
                         end;
                    end;
               end;
    end;
    Case TC of
         #13 : K := K + 1;
         #24 : If K > 1 then K := K - 1;
    end;
    Until (K = 16) or (TC = #27);
    If TC <> #27 then Confirma;
  Until (Upcase(TC) = 'S') or (TC = #27);
end;


Procedure ProcNo05Report;
begin
  EntryTermoReport;
  If UpCase(TC) = 'S' then
     begin
       With CmpyMember do
       begin
         If T = 80 then
            begin
              Writeln (LST,Dx,Acentua(Descricao),Df);
              Writeln (LST,(ConstStr('-',T)));
              Writeln (LST,Cx,Acentua(Endereco),', ',Acentua(Cidade),
                           ', ',Estado,'  Cep: ',Cep,'  Tel. ',Telefone,Cf);

              Writeln (LST,ConstStr(' ',(T-11)),'Folha: ',#27,Nx,
                           Folha:4,#27,Nf);

              If Tipo = 'A'
                 then Writeln (LST,#27,Nx,'TERMO DE ABERTURA',#27,Nf)
                 else Writeln (LST,#27,Nx,'TERMO DE FECHAMENTO',#27,Nf);

              Writeln (LST);
              Writeln (LST,(ConstStr('-',T)));
            end
            else begin
                   Writeln (LST,' ':10,Dx,Acentua(Descricao),Df);
                   Writeln (LST,' ':10,(ConstStr('-',(T - 10))));
                   Writeln (LST,' ':10,Cx,Acentua(Endereco),', ',
                                Acentua(Cidade),', ',Estado,
                                '  Cep: ',Cep,'  Tel. ',Telefone,Cf);

                   Writeln (LST,' ':10,ConstStr(' ',(T-21)),'Folha: ',#27,Nx,
                                Folha:4,#27,Nf);

                   If Tipo = 'A'
                      then Writeln (LST,' ':10,
                                      #27,Nx,'TERMO DE ABERTURA',#27,Nf)
                      else Writeln (LST,' ':10,
                                      #27,Nx,'TERMO DE FECHAMENTO',#27,Nf);

                   Writeln (LST);
                   Writeln (LST,' ':10,(ConstStr('-',T - 10)));
                 end;
       end;
       Writeln (LST);
       Writeln (LST);
       Writeln (LST);
       Writeln (LST);
       Writeln (LST);
       Writeln (LST);
       Writeln (LST,' ':Trunc((T-60)/2),
                    Acentua('Cont‚m  este  livro  '),NumF:4,
                    '  folhas   eletronicamente');
       If Tipo = 'A'
          then Writeln (LST,' ':Trunc((T-60)/2),
                            'numeradas  de 1 a ',NumF:4,
                            Acentua(' e  servir  de  livro  di rio'))
          else Writeln (LST,' ':Trunc((T-60)/2),
                            'numeradas  de 1 a ',NumF:4,
                            Acentua(' e  serviu  de  livro  di rio'));
       Writeln (LST,' ':Trunc((T-60)/2),
                    Acentua('n£mero '),Livro:4,' da firma:');
       Writeln (LST);
       Writeln (LST,' ':Trunc((T-60)/2),#27,Nx,Acentua(CmpyMember.Descricao),#27,Nf);
       Writeln (LST);
       Writeln (LST,' ':Trunc((T-60)/2),'estabelecida a ');
       Writeln (LST);
       Writeln (LST,' ':Trunc((T-60)/2),Acentua(CmpyMember.Endereco));
       Writeln (LST,' ':Trunc((T-60)/2),Acentua(CmpyMember.Cidade),' - ',CmpyMember.Estado);
       Writeln (LST);
       Writeln (LST,' ':Trunc((T-60)/2),
                     'com   atividade   ',Acentua(Atividade),
                     ' ':18-Length(Atividade),'registrada   na ');
       Writeln (LST,' ':Trunc((T-60)/2),Junta,' ':13-Length(Junta),
                    Acentua(' sob n£mero  '),Acentua(RegJunta),
                    ' ':22-Length(RegJunta),'por');
       Writeln (LST,' ':Trunc((T-60)/2),
                    Acentua('despacho  em  sess„o  de  '),DataDP,
                    Acentua(' e no  CGC-MF sob'));
       Writeln (LST,' ':Trunc((T-60)/2),
                    Acentua('n£mero '),CmpyMember.CpfCgc,'.');
       Writeln (LST);
       Writeln (LST,' ':Trunc((T-60)/2),
             Acentua('Conforme  o artigo 5 da instru‡„o normativa  n£mero'));
       Writeln (LST,' ':Trunc((T-60)/2),
             Acentua('3 de 19/08/86 do D.N.R.C. declaramos que o presente'));
       Writeln (LST,' ':Trunc((T-60)/2),
                    'livro encontra-se totalmente escriturado.');
       Writeln (LST);
       Writeln (LST);
       Writeln (LST);
       Writeln (LST);
       Writeln (LST);
       Writeln (LST,' ':Trunc((T-50)/2),Local,', ',DDD,Acentua(TabMesX[MMM]),
                    AAA);
       Writeln (LST);
       Writeln (LST);
       Writeln (LST);
       Writeln (LST);
       Writeln (LST);
       Writeln (LST);
       Writeln (LST,' ':Trunc((T-50)/2),ConstStr('-',40));
       Writeln (LST,' ':Trunc((T-50)/2),Acentua(Titulo1));
       Writeln (LST,' ':Trunc((T-50)/2),Acentua(Assin1));
       Writeln (LST);
       Writeln (LST);
       Writeln (LST);
       Writeln (LST);
       Writeln (LST);
       Writeln (LST);
       Writeln (LST);
       Writeln (LST,' ':Trunc((T-50)/2),ConstStr('-',40));
       Writeln (LST,' ':Trunc((T-50)/2),Acentua(Titulo2));
       Writeln (LST,' ':Trunc((T-50)/2),Acentua(Assin2));
       ContLin := 58;
       Footer;
       If DskRpt = 'N' then Write (LST,Qp);
       Color(Blue,Cyan);
       GotoXY(1,23); Write(ConstStr(' ',80));
       TeclaReturn;
     end;
end;

end.

