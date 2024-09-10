Procedure ReorganizaT;
begin
  Confirma;
  If TC = 'S' then
     begin
       Color(Bfn,Btx);
       GotoXY(3,10); Write(' Entidade           Lidos    Excl.   Reorg. ');
       Color(Tfn,Ttx);
       {$I-}
       ChDir ( XPath );
       {$I+}
       If IOResult =  0 then
          begin
            Dispose12 (Root12);
            Root12 := NIL;
            ShowHeap;
            Color(Tfn,Ttx);
            If FileSize(TCFile) > 0 then
               begin
	         Close  ( TCFile );
	         Assign ( WorkFileT, (XPath + '\PLOGTBLC.WRK'));
                 {$I-}
                 Reset  ( WorkFileT );
                 {$I+}
                 If IOResult = 0 then
                    begin
                      Close ( WorkFileT );
                      Erase ( WorkFileT );
                    end;
                 Assign ( WorkFileT, (XPath + '\' + FileTC ));
	         Rename ( WorkFileT, ('PLOGTBLC.WRK'));
                 {$I-}
                 Reset   ( WorkFileT );
                 {$I+}
                 If IOResult = 0 then
                    begin
		      Assign ( TCFile, (XPath + '\' + FileTC ));
                      {$I-}
		      Reset  ( TCFile );
                      {$I+}
                      If IOResult <> 0 then
                         begin
		           Rewrite ( TCFile );
		           Reset   ( TCFile );
                         end;
                      GotoXY(4,12); Write('Tab.de Contabil.');
                      I := -1;
                      R := 0;
                      D := 0;
                      Repeat
                        I := I + 1;
                        GotoXY(24,12); Write((I + 1):4);
                        Seek ( WorkFileT, I        );
		        Read ( WorkFileT, TCMember );
		        If TCMember.Status <> 'C' then
                           begin
			     TCNo := TCMember.Conta   + '#' +
				     TCMember.LocalCC + '#' +
				     TCMember.Seq;
                             SearchTree12 ( Root12 );
                             If RC = 'N' then
                                begin
			          R := FileSize(TCFile);
                                  GotoXY(41,12); Write((R + 1):4);
			          TCNumber := R;
			          LoadTree12 ( Root12 );
			          Seek  ( TCFile, R        );
			          Write ( TCFile, TCMember );
                                  ShowHeap;
                                  Color(Tfn,Ttx);
                                end;
                           end
                           else begin
                                  D := D + 1;
                                  GotoXY(32,12); Write(D:4);
                                end;
                      Until (I + 1) = FileSize(WorkFileT);
                      Close ( WorkFileT );
                      Erase ( WorkFileT );
                    end;
               end;
          end;
       Color(Blue,White);
       GotoXY(1,23); Write(ConstStr(' ',80));
       GotoXY(2,23); Write('A Tabela de Contabiliza‡Æo est  reorganizada');
       TeclaReturn;
     end;
end;

