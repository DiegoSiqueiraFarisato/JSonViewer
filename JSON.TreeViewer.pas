
//---------------------------------------------------------------------------

// This software is Copyright (c) 2011 Embarcadero Technologies, Inc.
// You may only use this software if you are an authorized licensee
// of Delphi, C++Builder or RAD Studio (Embarcadero Products).
// This software is considered a Redistributable as defined under
// the software license agreement that comes with the Embarcadero Products
// and is subject to that software license agreement.

//---------------------------------------------------------------------------
unit JSON.TreeViewer;

// ***********************************************************************
//
//   JSON View VCL Component
//
//   diego farisato
//   March 2025
//
// ***********************************************************************

interface

uses
  Classes, VCL.ComCtrls, JsonDataObjects;

type
  TJSONTreeView = class(TTreeView)
  private
    FJSONData: string;
    procedure SetJSONDocument(const Value: string);
    procedure LoadJSONToTreeView(JSONValue: TJsonBaseObject; ParentNode: TTreeNode);
//    procedure LoadJSONFileToTreeView(const JSONFilePath: string);//
    procedure LoadJSONStringToTreeView(const JSONString: string);
  public
    constructor Create(AOwner: TComponent); override;
    procedure ClearAll;
    procedure LoadJson;
    property JSONData: string read FJSONData write SetJSONDocument;
  end;


implementation

uses
  SysUtils;

{ TJSONTreeView }

constructor TJSONTreeView.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TJSONTreeView.ClearAll;
begin
  Items.Clear;
end;

procedure TJSONTreeView.LoadJson;
begin
  ClearAll;
  // Load the stream directly into the TJsonTreeView
  Items.Clear;
  LoadJSONStringToTreeView(JSONData);
  FullExpand;

end;

procedure TJSONTreeView.SetJSONDocument(const Value: string);
begin
  if FJSONData <> Value then
  begin
    FJSONData := Value;
    ClearAll;
    if FJSONData <> '' then
    begin
      LoadJson;
    end;
  end;
end;

procedure TJSONTreeView.LoadJSONToTreeView(JSONValue: TJsonBaseObject; ParentNode: TTreeNode);
var
  JSONObject: TJsonObject;
  JSONArray: TJsonArray;
  I: Integer;
  Node: TTreeNode;
  KeyStr, ValueStr: string;
begin
  // Handle different JSON value types
  if JSONValue is TJsonObject then
  begin
    JSONObject := TJsonObject(JSONValue);

    // Process each pair in the JSON object
    for I := 0 to JSONObject.Count - 1 do
    begin
      KeyStr := JSONObject.Names[I];

      // Create a node for this key
      if ParentNode = nil then
        Node := Items.Add(nil, KeyStr)
      else
        Node := Items.AddChild(ParentNode, KeyStr);

      // Recursively process the value
      if JSONObject.Types[KeyStr] in [jdtArray] then
        LoadJSONToTreeView(JSONObject.A[KeyStr], Node)
      else
      if JSONObject.Types[KeyStr] in [jdtObject] then
        LoadJSONToTreeView(JSONObject.O[KeyStr], Node)
      else
      begin
        // Handle primitive values directly
        case JSONObject.Types[KeyStr] of
          jdtString:   ValueStr := '"' + JSONObject.S[KeyStr] + '"';
          jdtInt:      ValueStr := IntToStr(JSONObject.I[KeyStr]);
          jdtFloat:    ValueStr := FloatToStr(JSONObject.F[KeyStr]);
          jdtBool:     ValueStr := LowerCase(BoolToStr(JSONObject.B[KeyStr], True));
          //jdtNull:   ValueStr := 'null';
          jdtDateTime: ValueStr := DateTimeToStr(JSONObject.D[KeyStr]);
        end;

        // Update the node's text to include the value
        if ValueStr <> '' then
          Node.Text := Node.Text + ': ' + ValueStr;
      end;
    end;
  end
  else if JSONValue is TJsonArray then
  begin
    JSONArray := TJsonArray(JSONValue);

    // Process each element in the array
    for I := 0 to JSONArray.Count - 1 do
    begin
      // Create a node for the array index
      if ParentNode = nil then
        Node := Items.Add(nil, '[' + IntToStr(I) + ']')
      else
        Node := Items.AddChild(ParentNode, '[' + IntToStr(I) + ']');

      // Recursively process the array element
      if JSONArray.Types[I] in [jdtObject] then
        LoadJSONToTreeView(JSONArray.O[I], Node)
      else
      if JSONArray.Types[I] in [jdtArray] then
        LoadJSONToTreeView(JSONArray.A[I], Node)
      else
      begin
        // Handle primitive values directly
        case JSONArray.Types[I] of
          jdtString: ValueStr := '"' + JSONArray.S[I] + '"';
          jdtInt:    ValueStr := IntToStr(JSONArray.I[I]);
          jdtFloat:  ValueStr := FloatToStr(JSONArray.F[I]);
          jdtBool:   ValueStr := LowerCase(BoolToStr(JSONArray.B[I], True));
//          jdtNull:   ValueStr := 'null';
          jdtDateTime: ValueStr := DateTimeToStr(JSONArray.D[I]);
        end;

        // Update the node's text to include the value
        if ValueStr <> '' then
          Node.Text := Node.Text + ': ' + ValueStr;
      end;
    end;
  end;
end;

// Main procedure to load JSON from a file
{
procedure TJSONTreeView.LoadJSONFileToTreeView(const JSONFilePath: string);
var
  JSONValue: TJsonBaseObject;
begin
  Items.Clear;

  try
    // Load and parse JSON file directly using JsonDataObjects
    try
      JSONValue := TJsonObject.ParseFromFile(JSONFilePath) as TJsonBaseObject;
    except
      // If parsing as object fails, try as array
      JSONValue := TJsonArray.ParseFromFile(JSONFilePath) as TJsonBaseObject;
    end;

    if JSONValue <> nil then
    try
      // Start recursive loading
      LoadJSONToTreeView(JSONValue, nil);

      // Expand the root to show the first level
      if Items.Count > 0 then
        Items[0].Expand(False);
    finally
      JSONValue.Free;
    end;
  except
//    on E: Exception do
//      ShowMessage('Error loading JSON: ' + E.Message);
  end;
end;
//}

// Alternative procedure that accepts a JSON string directly
procedure TJSONTreeView.LoadJSONStringToTreeView(const JSONString: string);
var
  JSONValue: TJsonBaseObject;
begin
  Items.Clear;

  try
    // Try parsing the string as a JSON object first
    try
      JSONValue := TJsonObject.Parse(JSONString) as TJsonBaseObject;
    except
      // If that fails, try parsing as a JSON array
      JSONValue := TJsonArray.Parse(JSONString) as TJsonBaseObject;
    end;

    if JSONValue <> nil then
    try
      // Start recursive loading
      LoadJSONToTreeView(JSONValue, nil);

      // Expand the root to show the first level
      if Items.Count > 0 then
        Items[0].Expand(False);
    finally
      JSONValue.Free;
    end;
  except
//    on E: Exception do
//      ShowMessage('Error parsing JSON: ' + E.Message);
  end;
end;


end.
