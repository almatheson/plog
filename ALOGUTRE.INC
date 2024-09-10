Procedure UnloadIndex;
begin
  If XR = 28 then
     With IndXMember do
     begin
       I := FileSize(IndXFile);
       ReadWrite(#13,'W','N',I);
       For XR := 1 to 28 do begin
                              TipoX[XR]    := 'X';
                              ChaveX[XR]   := '';
                              RelAddrX[XR] := 0;
                            end;
       XR := 0;
     end;
end;


Procedure UnloadIndexL;
begin
  If XR = 64 then
     With IndLMember do
     begin
       I := FileSize(IndLFile);
       ReadWrite(#14,'W','N',I);
       For XR := 1 to 64 do begin
                              ChaveX[XR]   := '';
                              RelAddrX[XR] := 0;
                            end;
       XR := 0;
     end;
end;


Procedure LoadTree0 ( Var Root0 : Pointer0 );
begin
  If Root0 = NIL then
     begin
       New ( Root0 );
       Root0^.Chave0   := CmpyNo;
       Root0^.RelAddr0 := CmpyNumber;
       Root0^.Left0    := NIL;
       Root0^.Right0   := NIL;
     end
     else If CmpyNo <> Root0^.Chave0 then
             begin
               If CmpyNo < Root0^.Chave0 then LoadTree0 ( Root0^.Left0  )
                                         else LoadTree0 ( Root0^.Right0 );
             end;
end;


Procedure SearchTree0 ( Var Root0 : Pointer0 );
begin
  If Root0 = NIL then RC := 'N'
     else If CmpyNo < Root0^.Chave0
             then SearchTree0 ( Root0^.Left0 )
             else If CmpyNo > Root0^.Chave0
                     then SearchTree0 ( Root0^.Right0 )
                     else begin
                            RC         := 'S';
                            CmpyNumber := Root0^.RelAddr0;
                          end;
end;


Procedure SearchAnt0 ( Var Root0 : Pointer0 );
begin
  If Root0 <> NIL then
     begin
       If (Root0^.Right0 <> NIL          ) and
          (CmpyNo         > Root0^.Chave0) then SearchAnt0 ( Root0^.Right0 );
       If (RC     = 'N'          ) and
          (CmpyNo > Root0^.Chave0) then
          begin
            RC         := 'S';
            CmpyNumber := Root0^.RelAddr0;
            CmpyNo     := Root0^.Chave0;
          end
          else If RC = 'N' then If Root0^.Left0  <> NIL
                                   then SearchAnt0 ( Root0^.Left0  );
     end;
end;


Procedure SearchPos0 ( Var Root0 : Pointer0 );
begin
  If Root0 <> NIL then
     begin
       If (Root0^.Left0  <> NIL          ) and
          (CmpyNo        <  Root0^.Chave0) then SearchPos0 ( Root0^.Left0  );
       If (RC     = 'N'          ) and
          (CmpyNo < Root0^.Chave0) then
          begin
            RC         := 'S';
            CmpyNumber := Root0^.RelAddr0;
            CmpyNo     := Root0^.Chave0;
          end
          else If RC = 'N' then If Root0^.Right0 <> NIL
                                   then SearchPos0 ( Root0^.Right0 );
     end;
end;


Procedure LoadTree1 ( Var Root1 : Pointer1 );
begin
  If Root1 = NIL then
     begin
       New ( Root1 );
       Root1^.Chave1   := ContaNo;
       Root1^.RelAddr1 := ContaNumber;
       Root1^.Left1    := NIL;
       Root1^.Right1   := NIL;
     end
     else If ContaNo <> Root1^.Chave1 then
             begin
               If ContaNo < Root1^.Chave1 then LoadTree1 ( Root1^.Left1  )
                                          else LoadTree1 ( Root1^.Right1 );
             end;
end;


Procedure SearchTree1 ( Var Root1 : Pointer1 );
begin
  If Root1 = NIL then RC := 'N'
     else If ContaNo < Root1^.Chave1
             then SearchTree1 ( Root1^.Left1 )
             else If ContaNo > Root1^.Chave1
                     then SearchTree1 ( Root1^.Right1 )
                     else begin
                            RC          := 'S';
                            ContaNumber := Root1^.RelAddr1;
                          end;
end;


Procedure SearchAnt1 ( Var Root1 : Pointer1 );
begin
  If Root1 <> NIL then
     begin
       If (Root1^.Right1 <> NIL          ) and
          (ContaNo        > Root1^.Chave1) then SearchAnt1 ( Root1^.Right1 );
       If (RC      = 'N'          ) and
          (ContaNo > Root1^.Chave1) then
          begin
            RC          := 'S';
            ContaNumber := Root1^.RelAddr1;
            ContaNo     := Root1^.Chave1;
          end
          else If RC = 'N' then If Root1^.Left1 <> NIL
                                   then SearchAnt1 ( Root1^.Left1  );
     end;
end;


Procedure SearchPos1 ( Var Root1 : Pointer1 );
begin
  If Root1 <> NIL then
     begin
       If (Root1^.Left1   <> NIL          ) and
          (ContaNo        <  Root1^.Chave1) then SearchPos1 ( Root1^.Left1  );
       If (RC      = 'N'          ) and
          (ContaNo < Root1^.Chave1) then
          begin
            RC          := 'S';
            ContaNumber := Root1^.RelAddr1;
            ContaNo     := Root1^.Chave1;
          end
          else If RC = 'N' then If Root1^.Right1 <> NIL
                                   then SearchPos1 ( Root1^.Right1 );
     end;
end;


Procedure Dispose1 ( Var Root1 : Pointer1 );
begin
  If Root1 <> NIL then
     begin
       If Root1^.Left1  <> NIL then Dispose1 ( Root1^.Left1  );
       If Root1^.Right1 <> NIL then Dispose1 ( Root1^.Right1 );
       Dispose(Root1);
     end;
end;


Procedure UnLoadTree1 ( Var Root1 : Pointer1 );
begin
  If Root1 <> NIL then
     begin
       XR                      := XR + 1;
       IndXMember.TipoX[XR]    := '1';
       IndXMember.ChaveX[XR]   := Root1^.Chave1;
       IndXMember.RelAddrX[XR] := Root1^.RelAddr1;
       UnloadIndex;
       If Root1^.Left1  <> NIL then UnLoadTree1 ( Root1^.Left1  );
       If Root1^.Right1 <> NIL then UnLoadTree1 ( Root1^.Right1 );
     end;
end;


Procedure LoadTree2 ( Var Root2 : Pointer2 );
begin
  If Root2 = NIL then
     begin
       New ( Root2 );
       Root2^.Chave2   := LoteNo;
       Root2^.RelAddr2 := LoteNumber;
       Root2^.Left2    := NIL;
       Root2^.Right2   := NIL;
     end
     else If LoteNo <> Root2^.Chave2 then
             begin
               If LoteNo < Root2^.Chave2 then LoadTree2 ( Root2^.Left2  )
                                         else LoadTree2 ( Root2^.Right2 );
             end;
end;


Procedure SearchTree2 ( Var Root2 : Pointer2 );
begin
  If Root2 = NIL then RC := 'N'
     else If LoteNo < Root2^.Chave2
             then SearchTree2 ( Root2^.Left2 )
             else If LoteNo > Root2^.Chave2
                     then SearchTree2 ( Root2^.Right2 )
                     else begin
                            RC         := 'S';
                            LoteNumber := Root2^.RelAddr2;
                          end;
end;


Procedure SearchAnt2 ( Var Root2 : Pointer2 );
begin
  If Root2 <> NIL then
     begin
       If (Root2^.Right2 <> NIL   ) and
          (LoteNo         > Root2^.Chave2) then SearchAnt2 ( Root2^.Right2 );
       If (RC     = 'N'          ) and
          (LoteNo > Root2^.Chave2) then
          begin
            RC         := 'S';
            LoteNumber := Root2^.RelAddr2;
            LoteNo     := Root2^.Chave2;
          end
          else If RC = 'N' then If Root2^.Left2 <> NIL
                                   then SearchAnt2 ( Root2^.Left2  );
     end;
end;


Procedure SearchPos2 ( Var Root2 : Pointer2 );
begin
  If Root2 <> NIL then
     begin
       If (Root2^.Left2  <> NIL   ) and
          (LoteNo        <  Root2^.Chave2) then SearchPos2 ( Root2^.Left2  );
       If (RC     = 'N'          ) and
          (LoteNo < Root2^.Chave2) then
          begin
            RC         := 'S';
            LoteNumber := Root2^.RelAddr2;
            LoteNo     := Root2^.Chave2;
          end
          else If RC = 'N' then If Root2^.Right2 <> NIL
                                   then SearchPos2 ( Root2^.Right2 );
     end;
end;


Procedure Dispose2 ( Var Root2 : Pointer2 );
begin
  If Root2 <> NIL then
     begin
       If Root2^.Left2  <> NIL then Dispose2 ( Root2^.Left2  );
       If Root2^.Right2 <> NIL then Dispose2 ( Root2^.Right2 );
       Dispose(Root2);
     end;
end;


Procedure UnLoadTree2 ( Var Root2 : Pointer2 );
begin
  If Root2 <> NIL then
     begin
       XR                      := XR + 1;
       IndLMember.ChaveX[XR]   := Root2^.Chave2;
       IndLMember.RelAddrX[XR] := Root2^.RelAddr2;
       UnloadIndexL;
       If Root2^.Left2  <> NIL then UnLoadTree2 ( Root2^.Left2  );
       If Root2^.Right2 <> NIL then UnLoadTree2 ( Root2^.Right2 );
     end;
end;


Procedure LoadTree3 ( Var Root3 : Pointer3 );
begin
  If Root3 = NIL then
     begin
       New ( Root3 );
       Root3^.Chave3   := DeptNo;
       Root3^.RelAddr3 := DeptNumber;
       Root3^.Left3    := NIL;
       Root3^.Right3   := NIL;
     end
     else If DeptNo <> Root3^.Chave3 then
             begin
               If DeptNo < Root3^.Chave3 then LoadTree3 ( Root3^.Left3  )
                                         else LoadTree3 ( Root3^.Right3 );
             end;
end;


Procedure SearchTree3 ( Var Root3 : Pointer3 );
begin
  If Root3 = NIL then RC := 'N'
     else If DeptNo < Root3^.Chave3
             then SearchTree3 ( Root3^.Left3 )
             else If DeptNo > Root3^.Chave3
                     then SearchTree3 ( Root3^.Right3 )
                     else begin
                            RC         := 'S';
                            DeptNumber := Root3^.RelAddr3;
                          end;
end;


Procedure SearchAnt3 ( Var Root3 : Pointer3 );
begin
  If Root3 <> NIL then
     begin
       If (Root3^.Right3 <> NIL          ) and
          (DeptNo         > Root3^.Chave3) then SearchAnt3 ( Root3^.Right3 );
       If (RC     = 'N'          ) and
          (DeptNo > Root3^.Chave3) then
          begin
            RC         := 'S';
            DeptNumber := Root3^.RelAddr3;
            DeptNo     := Root3^.Chave3;
          end
          else If RC = 'N' then If Root3^.Left3 <> NIL
                                   then SearchAnt3 ( Root3^.Left3  );
     end;
end;


Procedure SearchPos3 ( Var Root3 : Pointer3 );
begin
  If Root3 <> NIL then
     begin
       If (Root3^.Left3  <> NIL          ) and
          (DeptNo        <  Root3^.Chave3) then SearchPos3 ( Root3^.Left3  );
       If (RC     = 'N'          ) and
          (DeptNo < Root3^.Chave3) then
          begin
            RC         := 'S';
            DeptNumber := Root3^.RelAddr3;
            DeptNo     := Root3^.Chave3;
          end
          else If RC = 'N' then If Root3^.Right3 <> NIL
                                   then SearchPos3 ( Root3^.Right3 );
     end;
end;


Procedure Dispose3 ( Var Root3 : Pointer3 );
begin
  If Root3 <> NIL then
     begin
       If Root3^.Left3  <> NIL then Dispose3 ( Root3^.Left3  );
       If Root3^.Right3 <> NIL then Dispose3 ( Root3^.Right3 );
       Dispose(Root3);
     end;
end;


Procedure UnLoadTree3 ( Var Root3 : Pointer3 );
begin
  If Root3 <> NIL then
     begin
       XR                      := XR + 1;
       IndXMember.TipoX[XR]    := '3';
       IndXMember.ChaveX[XR]   := Root3^.Chave3;
       IndXMember.RelAddrX[XR] := Root3^.RelAddr3;
       UnloadIndex;
       If Root3^.Left3  <> NIL then UnLoadTree3 ( Root3^.Left3  );
       If Root3^.Right3 <> NIL then UnLoadTree3 ( Root3^.Right3 );
     end;
end;


Procedure LoadTree7 ( Var Root7 : Pointer7 );
begin
  If Root7 = NIL then
     begin
       New ( Root7 );
       Root7^.Chave7   := IINo;
       Root7^.RelAddr7 := IINumber;
       Root7^.Left7    := NIL;
       Root7^.Right7   := NIL;
     end
     else If IINo <> Root7^.Chave7 then
             begin
               If IINo < Root7^.Chave7 then LoadTree7 ( Root7^.Left7  )
                                       else LoadTree7 ( Root7^.Right7 );
             end;
end;


Procedure SearchTree7 ( Var Root7 : Pointer7 );
begin
  If Root7 = NIL then RC := 'N'
     else If IINo < Root7^.Chave7 then SearchTree7 ( Root7^.Left7 )
             else If IINo > Root7^.Chave7
                     then SearchTree7 ( Root7^.Right7 )
                     else begin
                            RC       := 'S';
                            IINumber := Root7^.RelAddr7;
                          end;
end;


Procedure SearchAnt7 ( Var Root7 : Pointer7 );
begin
  If Root7 <> NIL then
     begin
       If (Root7^.Right7 <> NIL          ) and
          (IINo           > Root7^.Chave7) then SearchAnt7 ( Root7^.Right7 );
       If (RC   = 'N'          ) and
          (IINo > Root7^.Chave7) then
          begin
            RC       := 'S';
            IINumber := Root7^.RelAddr7;
            IINo     := Root7^.Chave7;
          end
          else If RC = 'N' then If Root7^.Left7 <> NIL
                                   then SearchAnt7 ( Root7^.Left7 );
     end;
end;


Procedure SearchPos7 ( Var Root7 : Pointer7 );
begin
  If Root7 <> NIL then
     begin
       If (Root7^.Left7  <> NIL          ) and
          (IINo          <  Root7^.Chave7) then SearchPos7 ( Root7^.Left7 );
       If (RC   = 'N'          ) and
          (IINo < Root7^.Chave7) then
          begin
            RC       := 'S';
            IINumber := Root7^.RelAddr7;
            IINo     := Root7^.Chave7;
          end
          else If RC = 'N' then If Root7^.Right7 <> NIL
                                   then SearchPos7 ( Root7^.Right7 );
     end;
end;


Procedure Dispose7 ( Var Root7 : Pointer7 );
begin
  If Root7 <> NIL then
     begin
       If Root7^.Left7  <> NIL then Dispose7 ( Root7^.Left7  );
       If Root7^.Right7 <> NIL then Dispose7 ( Root7^.Right7 );
       Dispose(Root7);
     end;
end;


Procedure UnLoadTree7 ( Var Root7 : Pointer7 );
begin
  If Root7 <> NIL then
     begin
       XR                      := XR + 1;
       IndXMember.TipoX[XR]    := '7';
       IndXMember.ChaveX[XR]   := Root7^.Chave7;
       IndXMember.RelAddrX[XR] := Root7^.RelAddr7;
       UnloadIndex;
       If Root7^.Left7  <> NIL then UnLoadTree7 ( Root7^.Left7  );
       If Root7^.Right7 <> NIL then UnLoadTree7 ( Root7^.Right7 );
     end;
end;




