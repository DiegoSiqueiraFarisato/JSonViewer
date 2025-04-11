unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, json.treeviewer, Vcl.Menus;

type
  TForm1 = class(TForm)
    PopupMenu1: TPopupMenu;
    paste1: TMenuItem;
    JSONTreeView1: TJSONTreeView;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure paste1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  clipbrd,
  JsonDataObjects;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // Check if Ctrl+V was pressed
  if (ssCtrl in Shift) and (Key = Ord('V')) then
  begin
    // If an edit control or memo has focus, paste into it
    if (ActiveControl is TForm1) or (ActiveControl is TJsonTreeView) then
    begin
      if ActiveControl is TJSONTreeView then
      begin
        JSONTreeView1.JSONData := clipboard.AsText;
        JSONTreeView1.LoadJson;
      end;
    end
  end;
end;

procedure TForm1.paste1Click(Sender: TObject);
begin
  JSONTreeView1.JSONData := clipboard.AsText;
  JSONTreeView1.LoadJson;
end;

end.
