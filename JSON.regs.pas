
//---------------------------------------------------------------------------

// This software is Copyright (c) 2011 Embarcadero Technologies, Inc. 
// You may only use this software if you are an authorized licensee
// of Delphi, C++Builder or RAD Studio (Embarcadero Products).
// This software is considered a Redistributable as defined under
// the software license agreement that comes with the Embarcadero Products
// and is subject to that software license agreement.

//---------------------------------------------------------------------------
unit JSON.regs;

// ***********************************************************************
//
//   JSON components desigh-time support
//
//   diego farisato
//   April 2025
//
// ***********************************************************************


interface

{$R jsondoc.dcr}

procedure Register;

implementation

uses
  Classes,
  json.treeviewer;

procedure Register;
begin
  RegisterComponents('JSON', [TJSONTreeView]);
end;

end.
