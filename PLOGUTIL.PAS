{$O+,F+}
Unit PlogUtil;

Interface

Uses Crt,Dos,PlogGlbs,PlogBasP,PlogCmpy;

   Procedure FileBackup(X : Char);
   Procedure FileRestore(X : Char);
   Procedure DosShell;

Implementation

Var
   BkT,BkU,BkD    : Char;
   DosEx          : Word;


Procedure Fecha;
begin
  Close ( OwnerFile  );
  Close ( MasterFile );
  Close ( CCFile     );
  Close ( SSFile     );
  Close ( TTFile     );
  Close ( CmpyFile   );
end;

Procedure Abre;
begin
  Reset ( OwnerFile  );
  Reset ( MasterFile );
  Reset ( CCFile     );
  Reset ( SSFile     );
  Reset ( TTFile     );
  Reset ( CmpyFile   );
  ReadWrite(#00,'R','N',0);
end;

Procedure Recarga;
begin
  Root0  := NIL;
  Root1  := NIL;
  Root2  := NIL;
  Root3  := NIL;
  Root4  := NIL;
  Root5  := NIL;
  Root6  := NIL;
  Root7  := NIL;
  Root8  := NIL;
  Root10 := NIL;
  Release (HeapOrg);
  LoadCmpy;
  Reset ( Ind1File );
  LoadIndex1;
  Close ( Ind1File );
end;

{$I BkupRest.rot }

end.
