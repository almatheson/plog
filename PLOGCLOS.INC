Procedure CloseFiles;
begin
  {$I-}
  Close ( CMstFile   );
  Close ( DDFile     );
  Close ( BBFile     );
  Close ( EEFile     );
  Close ( HHFile     );
  Close ( MMFile     );
  Close ( OOFile     );
  Close ( ENFile     );
  {$I+}
end;