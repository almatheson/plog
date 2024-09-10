{$O+,F+}
Unit AlogUtil;

Interface

Uses Crt,Dos,AlogGlbs,AlogNavg,AlogBasP,AlogCmpy;

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
  Close ( HsPdFile   );
  Close ( EcoFile    );
  Close ( CmpyFile   );
end;


Procedure Abre;
begin
  Reset ( OwnerFile  );
  Reset ( MasterFile );
  Reset ( HsPdFile   );
  Reset ( EcoFile    );
  Reset ( CmpyFile   );
  ReadWrite(#00,'R','N',0);
end;

Procedure Recarga;
begin
  Root0 := NIL;
  Root1 := NIL;
  Root2 := NIL;
  Root3 := NIL;
  Root4 := NIL;
  Root5 := NIL;
  Root6 := NIL;
  Root7 := NIL;
  Release (HeapOrg);
  LoadCmpy;
  LoadEcoI;
end;


{$I BkupRest.rot }

end.

