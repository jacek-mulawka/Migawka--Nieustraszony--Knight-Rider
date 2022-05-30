object LED_Test_Form: TLED_Test_Form
  Left = 0
  Top = 0
  Caption = 'LED test'
  ClientHeight = 462
  ClientWidth = 1184
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Dół_Panel: TPanel
    Left = 0
    Top = 402
    Width = 1184
    Height = 60
    Align = alBottom
    TabOrder = 0
    object JvLED1: TJvLED
      Left = 15
      Top = 10
      ColorOn = clRed
      ColorOff = clMaroon
    end
    object JvLED2: TJvLED
      Left = 85
      Top = 10
      ColorOn = clRed
      ColorOff = clMaroon
      Status = False
    end
    object JvLED3: TJvLED
      Left = 30
      Top = 10
      ColorOn = 160
      ColorOff = clMaroon
    end
    object Prędkość_Etykieta_Label: TLabel
      Left = 130
      Top = 35
      Width = 43
      Height = 13
      Caption = 'Pr'#281'dko'#347#263
    end
    object Opóźnienie_Zmiany_Etykieta_Label: TLabel
      Left = 260
      Top = 35
      Width = 89
      Height = 13
      Caption = 'Op'#243#378'nienie zmiany'
    end
    object Elementy_Ilość__Etykieta_Label: TLabel
      Left = 435
      Top = 35
      Width = 67
      Height = 13
      Caption = 'Elementy ilo'#347#263
    end
    object Prędkość_SpinEdit: TSpinEdit
      Left = 185
      Top = 35
      Width = 60
      Height = 22
      Hint = 'Enter - aktualizuj.'
      MaxValue = 0
      MinValue = 0
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      Value = 100
      OnKeyDown = Prędkość_SpinEditKeyDown
    end
    object Migawka_RadioButton: TRadioButton
      Left = 130
      Top = 10
      Width = 90
      Height = 17
      Caption = 'Migawka LED'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object Migawka_Prostokat_RadioButton: TRadioButton
      Left = 230
      Top = 10
      Width = 70
      Height = 17
      Caption = 'Prostok'#261't'
      TabOrder = 1
      TabStop = True
    end
    object Migawka_Prostokat_Tabela_RadioButton: TRadioButton
      Left = 311
      Top = 10
      Width = 60
      Height = 17
      Caption = 'Tabela'
      TabOrder = 2
      TabStop = True
    end
    object Utwórz_Zwolnij_Button: TButton
      Left = 605
      Top = 10
      Width = 100
      Height = 25
      Caption = 'Utw'#243'rz / Zwolnij'
      TabOrder = 8
      OnClick = Utwórz_Zwolnij_ButtonClick
    end
    object Opóźnienie_Zmiany_SpinEdit: TSpinEdit
      Left = 360
      Top = 35
      Width = 60
      Height = 22
      Hint = 'Enter - aktualizuj.'
      MaxValue = 0
      MinValue = 0
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      Value = 0
      OnKeyDown = Opóźnienie_Zmiany_SpinEditKeyDown
    end
    object Migawka_Prostokat_Tabela_2_RadioButton: TRadioButton
      Left = 380
      Top = 10
      Width = 70
      Height = 17
      Caption = 'Tabela 2'
      TabOrder = 3
      TabStop = True
    end
    object Klasa_RadioButton: TRadioButton
      Left = 460
      Top = 10
      Width = 60
      Height = 17
      Caption = 'Klasa'
      TabOrder = 4
      TabStop = True
    end
    object Elementy_Ilość_SpinEdit: TSpinEdit
      Left = 515
      Top = 35
      Width = 60
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 7
      Value = 10
    end
    object Tryb_RadioGroup: TRadioGroup
      Left = 760
      Top = 5
      Width = 185
      Height = 50
      Caption = 'Tryb'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'Migaj'
        'Mignij'
        'Wy'#322#261'cz'
        'Za'#347'wie'#263)
      TabOrder = 9
      OnClick = Tryb_RadioGroupClick
    end
    object Tryb_Ustaw_Button: TButton
      Left = 970
      Top = 10
      Width = 75
      Height = 25
      Hint = 'Tryb ustaw.'
      Caption = 'Tryb ustaw'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 10
      OnClick = Tryb_RadioGroupClick
    end
  end
end
