Procedure OpenFiles;
begin
  {$I-}
  Reset ( CMstFile   );
{  Reset ( BlkStaFile ); }
  Reset ( TTFile     );
  Reset ( CCFile     );
  Reset ( DDFile     );
  Reset ( BBFile     );
  Reset ( SSFile     );
  Reset ( EEFile     );
  Reset ( HHFile     );
  Reset ( MMFile     );
  Reset ( OOFile     );
  Reset ( ENFile     );
  {$I+}
end;