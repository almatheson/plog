Procedure CloseFiles;
begin
  {$I-}
  Close ( CMstFile   );
  Close ( ContaFile  );
  Close ( LoteFile   );
  Close ( DeptFile   );
  Close ( ExpeFile   );
  Close ( SaldFile   );
  Close ( LctoFile   );
  {$I+}
end;