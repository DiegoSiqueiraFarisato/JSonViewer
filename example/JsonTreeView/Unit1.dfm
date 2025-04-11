object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Just Copy and Paste a Valid Json'
  ClientHeight = 441
  ClientWidth = 496
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  OnKeyDown = FormKeyDown
  TextHeight = 15
  object JSONTreeView1: TJSONTreeView
    Left = 0
    Top = 0
    Width = 496
    Height = 441
    Align = alClient
    Indent = 19
    TabOrder = 0
    ExplicitLeft = 8
    ExplicitWidth = 489
  end
  object PopupMenu1: TPopupMenu
    Left = 304
    Top = 216
    object paste1: TMenuItem
      Caption = 'paste'
      ShortCut = 16470
      OnClick = paste1Click
    end
  end
end
