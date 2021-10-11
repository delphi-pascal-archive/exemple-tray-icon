object MainForm: TMainForm
  Left = 220
  Top = 128
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Exemple TrayIcon'
  ClientHeight = 553
  ClientWidth = 582
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object InfoLbl: TLabel
    Left = 10
    Top = 529
    Width = 464
    Height = 16
    Caption = 
      'Note : au bout de 1000 evenements, la liste des evenements est r' +
      'emise a zero.'
  end
  object ControlBox: TGroupBox
    Left = 10
    Top = 10
    Width = 277
    Height = 405
    Caption = ' Actions '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object HintLbl: TLabel
      Left = 10
      Top = 30
      Width = 80
      Height = 16
      Caption = 'Bulle d'#39'aide : '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object IconLbl: TLabel
      Left = 10
      Top = 64
      Width = 39
      Height = 16
      Caption = 'Icone :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object IconPicture: TImage
      Left = 59
      Top = 54
      Width = 39
      Height = 40
    end
    object BalloonTitleLbl: TLabel
      Left = 10
      Top = 251
      Width = 91
      Height = 16
      Caption = 'Titre du ballon :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object BalloonMsgLbl: TLabel
      Left = 10
      Top = 281
      Width = 121
      Height = 16
      Caption = 'Message du ballon :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object BalloonIconLbl: TLabel
      Left = 10
      Top = 335
      Width = 97
      Height = 16
      Caption = 'Icone du ballon :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object HintEdit: TEdit
      Left = 89
      Top = 27
      Width = 178
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxLength = 127
      ParentFont = False
      TabOrder = 0
      Text = 'Demonstration TrayIcon'
      OnChange = HintEditChange
    end
    object IconBtn: TButton
      Left = 108
      Top = 59
      Width = 159
      Height = 31
      Caption = 'Ouvrir une icone'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = IconBtnClick
    end
    object AddIcon: TButton
      Left = 10
      Top = 133
      Width = 257
      Height = 31
      Caption = 'Afficher l'#39'icone'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = AddIconClick
    end
    object DeleteBtn: TButton
      Left = 10
      Top = 172
      Width = 257
      Height = 31
      Caption = 'Supprimer l'#39'icone'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = DeleteBtnClick
    end
    object IconList: TComboBox
      Left = 10
      Top = 98
      Width = 257
      Height = 24
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 16
      ItemIndex = 0
      ParentFont = False
      TabOrder = 4
      Text = 'Defaut'
      OnChange = IconListChange
      Items.Strings = (
        'Defaut'
        'Avertissement'
        'Confirmation'
        'Information'
        'Erreur'
        'Personnalisee')
    end
    object BalloonBtn: TButton
      Left = 10
      Top = 212
      Width = 257
      Height = 30
      Caption = 'Ballon d'#39'information'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = BalloonBtnClick
    end
    object BalloonTitle: TEdit
      Left = 103
      Top = 247
      Width = 164
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxLength = 63
      ParentFont = False
      TabOrder = 6
    end
    object BalloonMsg: TEdit
      Left = 10
      Top = 300
      Width = 257
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxLength = 254
      ParentFont = False
      TabOrder = 7
    end
    object BalloonIconList: TComboBox
      Left = 112
      Top = 332
      Width = 156
      Height = 24
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 16
      ItemIndex = 0
      ParentFont = False
      TabOrder = 8
      Text = 'Avertissement'
      Items.Strings = (
        'Avertissement'
        'Information'
        'Erreur'
        'Personnalisee'
        'Aucune')
    end
  end
  object EventBox: TGroupBox
    Left = 295
    Top = 10
    Width = 277
    Height = 405
    Caption = ' Events '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object CountLbl: TLabel
      Left = 10
      Top = 379
      Width = 156
      Height = 16
      Caption = 'Nombre d'#39'evenements : 0.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object EventList: TListBox
      Left = 10
      Top = 20
      Width = 257
      Height = 355
      BevelKind = bkSoft
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 16
      ParentFont = False
      TabOrder = 0
      OnClick = EventListClick
    end
  end
  object EventInfoBox: TGroupBox
    Left = 10
    Top = 423
    Width = 562
    Height = 100
    Caption = ' Event info '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object EventLbl: TLabel
      Left = 10
      Top = 30
      Width = 74
      Height = 16
      Caption = 'Evenement :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object ParamsLbl: TLabel
      Left = 10
      Top = 49
      Width = 76
      Height = 16
      Caption = 'Parametres :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object OthersLbl: TLabel
      Left = 10
      Top = 69
      Width = 44
      Height = 16
      Caption = 'Autres :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
  end
  object CloseBtn: TButton
    Left = 20
    Top = 374
    Width = 257
    Height = 31
    Caption = 'Exit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = QuitBtnClick
  end
  object Tray: TTrayIcon
    OnClick = TrayClick
    OnMove = TrayMove
    OnShow = TrayShow
    OnHide = TrayHide
    OnBalloonClick = TrayBalloonClick
    OnBalloonShow = TrayBalloonShow
    OnBalloonHide = TrayBalloonHide
    IconType = itCustom
    Hint = 'Demonstration TrayIcon'
    Active = False
    PopupMenu = TrayPopup
    Left = 360
    Top = 40
  end
  object TrayPopup: TPopupMenu
    Left = 400
    Top = 40
    object QuitBtn: TMenuItem
      Caption = 'Quitter'
      OnClick = QuitBtnClick
    end
  end
  object OpenDlg: TOpenDialog
    DefaultExt = 'ico'
    Filter = 'Icone (.ico)|*.ico*'
    Title = 'Ouvrir une icone'
    Left = 320
    Top = 40
  end
end
