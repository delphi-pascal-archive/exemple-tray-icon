unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, TrayIcon, Menus, StdCtrls, ExtCtrls;

const
  ReservedMsg: array [0..1] of ShortString = (
  'Le ballon a été effacé à cause d''un clic de l''utilisateur ou d''une autre raison système.',
  'Le ballon a dépassé le temps qui lui était imparti.');

  ReservedMsg2: array [0..1] of ShortString = (
  'L''utilisateur a cliqué sur l''icône avec le bouton gauche.',
  'L''utilisateur a cliqué sur l''icône avec le bouton droit.');

  EventName: array [0..6] of ShortString = (
  'OnBalloonClick',
  'OnBalloonHide',
  'OnBalloonShow',
  'OnClick',
  'OnHide',
  'OnMove',
  'OnShow');

  EventMsg: array [0..6] of ShortString = (
   'L''utilisateur a cliqué sur le ballon.',
   'Le ballon a été effacé.',
   'Le ballon a été affiché.',
   'L''utilisateur a cliqué sur l''icône.',
   'L''icône a été effacée.',
   'L''utilisateur a bougé la souris sur l''icône.',
   'L''icône a été affichée.');

type
  TEvent = class     // 1 + 4 + 1 + 4 = 10 bytes !
   EventType: Byte;     // 1 byte
   X, Y: Integer;       // 4 bytes
   Reserved: Byte;      // 1 byte
   TimeStamp: Longword; // 4 bytes
  end;

  TMainForm = class(TForm)
    Tray: TTrayIcon;
    TrayPopup: TPopupMenu;
    QuitBtn: TMenuItem;
    ControlBox: TGroupBox;
    EventBox: TGroupBox;
    EventInfoBox: TGroupBox;
    HintLbl: TLabel;
    HintEdit: TEdit;
    IconLbl: TLabel;
    IconPicture: TImage;
    IconBtn: TButton;
    AddIcon: TButton;
    DeleteBtn: TButton;
    IconList: TComboBox;
    CloseBtn: TButton;
    BalloonBtn: TButton;
    EventList: TListBox;
    BalloonTitleLbl: TLabel;
    BalloonTitle: TEdit;
    BalloonMsgLbl: TLabel;
    BalloonMsg: TEdit;
    BalloonIconLbl: TLabel;
    BalloonIconList: TComboBox;
    OpenDlg: TOpenDialog;
    EventLbl: TLabel;
    ParamsLbl: TLabel;
    OthersLbl: TLabel;
    InfoLbl: TLabel;
    CountLbl: TLabel;
    procedure QuitBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BalloonBtnClick(Sender: TObject);
    procedure IconBtnClick(Sender: TObject);
    procedure AddIconClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure HintEditChange(Sender: TObject);
    procedure IconListChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TrayBalloonClick(Sender: TObject);
    procedure TrayBalloonHide(Sender: TObject; HideType: THideType);
    procedure TrayBalloonShow(Sender: TObject);
    procedure TrayClick(Sender: TObject; Button: TMouseButton; X,
      Y: Integer);
    procedure TrayHide(Sender: TObject);
    procedure TrayMove(Sender: TObject; X, Y: Integer);
    procedure TrayShow(Sender: TObject);
    procedure EventListClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure AddEvent(EventType: Byte; X, Y: Integer; Reserved: Byte);
    procedure UpdateList;
  end;

var
  MainForm: TMainForm;
  Events: TList;
  Time: Longword;

implementation

{$R *.dfm}

procedure TMainForm.UpdateList;
Var
 I: Integer;
begin
 EventList.Items.BeginUpdate;
 try
  EventList.Clear;
  for I := 0 to Events.Count - 1 do
   with TEvent(Events.Items[I]) do
    EventList.Items.Add(EventName[EventType] + ' [T + ' + IntToStr(TimeStamp div 1000) + ']');
 finally
  EventList.Items.EndUpdate;
 end;
 CountLbl.Caption := Format('Nombre d''événements : %d.', [Events.Count]);
end;

procedure TMainForm.AddEvent(EventType: Byte; X, Y: Integer; Reserved: Byte);
Var
 Event: TEvent;
begin
 if Events.Count > 1000 then Events.Clear;
 Event := TEvent.Create;
 Event.EventType := EventType;
 Event.X := X;
 Event.Y := Y;
 Event.Reserved := Reserved;
 Event.TimeStamp := GetTickCount - Time;
 Events.Add(Event);
 UpdateList;
end;

procedure TMainForm.QuitBtnClick(Sender: TObject);
begin
 Close;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
 Time := GetTickCount;
 Events := TList.Create;
 DoubleBuffered := True;
 ControlBox.DoubleBuffered := True;
 EventBox.DoubleBuffered := True;
 EventInfoBox.DoubleBuffered := True;
 EventList.DoubleBuffered := True;
 IconList.OnChange(self);
end;

procedure TMainForm.BalloonBtnClick(Sender: TObject);
const
 BalloonIcons: array [0..4] of TBalloonIcon = (biWarning, biInfo, biError, biCustom, biNone);
begin
 Tray.BalloonHint(BalloonTitle.Text, BalloonMsg.Text, 10, BalloonIcons[BalloonIconList.ItemIndex]);
end;

procedure TMainForm.IconBtnClick(Sender: TObject);
begin
 if OpenDlg.Execute then
  begin
   IconPicture.Picture.Icon.LoadFromFile(OpenDlg.FileName);
   Tray.IconType := itCustom;
   IconList.ItemIndex := 5;
   Tray.Icon := IconPicture.Picture.Icon;
  end;
end;

procedure TMainForm.AddIconClick(Sender: TObject);
begin
 Tray.Active := True;
end;

procedure TMainForm.DeleteBtnClick(Sender: TObject);
begin
 Tray.Active := False;
end;

procedure TMainForm.HintEditChange(Sender: TObject);
begin
 Tray.Hint := HintEdit.Text;
end;

procedure TMainForm.IconListChange(Sender: TObject);
begin
 case IconList.ItemIndex of
  0: Tray.IconType := itDefault;
  1: Tray.IconType := itWarning;
  2: Tray.IconType := itConfirmation;
  3: Tray.IconType := itInformation;
  4: Tray.IconType := itError;
  5: Tray.IconType := itCustom;
 end;
 if IconList.ItemIndex = 5 then IconBtnClick(self);
 IconPicture.Picture.Icon.Assign(Tray.Icon);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Events.Free;
end;

procedure TMainForm.TrayBalloonClick(Sender: TObject);
begin
 AddEvent(0, -1, -1, 255);
end;

procedure TMainForm.TrayBalloonHide(Sender: TObject; HideType: THideType);
begin
 case HideType of
  htClosed: AddEvent(1, -1, -1, 0);
  htTimeOut: AddEvent(1, -1, -1, 1);
 end;
end;

procedure TMainForm.TrayBalloonShow(Sender: TObject);
begin
 AddEvent(2, -1, -1, 255);
end;

procedure TMainForm.TrayClick(Sender: TObject; Button: TMouseButton; X,
  Y: Integer);
begin
 case Button of
  mbLeft: AddEvent(3, X, Y, 0);
  mbRight: AddEvent(3, X, Y, 1);
 end;
end;

procedure TMainForm.TrayHide(Sender: TObject);
begin
 AddEvent(4, -1, -1, 255);
end;

procedure TMainForm.TrayMove(Sender: TObject; X, Y: Integer);
begin
 AddEvent(5, X, Y, 255);
end;

procedure TMainForm.TrayShow(Sender: TObject);
begin
 AddEvent(6, -1, -1, 255);
end;

procedure TMainForm.EventListClick(Sender: TObject);
begin
 with TEvent(Events.Items[EventList.ItemIndex]) do
  begin
   EventLbl.Caption := 'Evénement : ' + EventMsg[EventType];
   if X <> -1 then ParamsLbl.Caption := Format('Paramètres : [X = %d] [Y = %d]', [X, Y])
    else ParamsLbl.Caption := 'Paramètres : [Aucun]';
   if Reserved = 255 then OthersLbl.Caption := 'Autres : [Aucun]' else
    case EventType of
     1: OthersLbl.Caption := 'Autres : ' + ReservedMsg[Reserved];
     3: OthersLbl.Caption := 'Autres : ' + ReservedMsg2[Reserved];
    end;
  end;
end;

end.
