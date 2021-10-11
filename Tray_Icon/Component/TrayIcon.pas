{   TrayIcon

Author : Bacterius.

This unit contains one component, TTrayIcon. This component allows you to easily
manage one or more icons in the notification area (near the system clock).
The component handles it's own window procedure, so you don't near to add it to
a windowed control to make it work. You can create a balloon hint associated with
your tray icon, you just have to specify a title, a balloon information, an icon
type and a timeout (in seconds). You do not have to worry about balloon hint
queuing, if you send a balloon hint while one (of your tray icon !) is already
in use, the old will be replaced immediately by the new one. However you cannot
hide manually your balloons. Events are managed inside the component, so you can
use the OnClick, OnMove, OnShow, OnHide, OnBalloonShow, OnBalloonClick,
OnBalloonHide events as you want. The OnBalloonHide event comes with a special
parameter, HideType : it will allow you to know if the balloon hint was hidden
because of elapsed timeout or because the user clicked on it. The properties are
very easy to use : Active specifies whether the icon is shown or not, Icon contains
the icon to be put in the tray, Hint is the tooltip associated with your tray icon,
IconType is the icon type : you can choose through 5 predefined types, or use your
own icon. PopupMenu will be shown each time the user right-clicks on the tray icon.
Your icon will only show at runtime, but you can modify all the properties in
design-time.
Thanks for using my component, feel free to upgrade it. You can contact me at :
thomas.beneteau@yahoo.fr

}

unit TrayIcon;

interface

{$WARN SYMBOL_DEPRECATED OFF}

{ The preceding compilation directive tells our stupid compilator to stop arguing
about AllocateHWND and DeallocateHWND (deprecated, he says ...) }

uses
  Windows, SysUtils, Messages, Classes, Graphics, Menus, ShellAPI;

const
  WM_TRAYICON = WM_USER + 77; // Message sent to component from system about our tray icon.

  {$EXTERNALSYM NIN_BALLOONSHOW}
  NIN_BALLOONSHOW       = WM_USER + 2;                      
  {$EXTERNALSYM NIN_BALLOONHIDE}
  NIN_BALLOONHIDE       = WM_USER + 3;
  {$EXTERNALSYM NIN_BALLOONTIMEOUT}
  NIN_BALLOONTIMEOUT    = WM_USER + 4;
  {$EXTERNALSYM NIN_BALLOONUSERCLICK}
  NIN_BALLOONUSERCLICK  = WM_USER + 5;

  {$EXTERNALSYM NIF_INFO}
  NIF_INFO       = $00000010;
  {$EXTERNALSYM NIIF_NONE}
  NIIF_NONE      = $00000000;
  {$EXTERNALSYM NIIF_INFO}
  NIIF_INFO      = $00000001;
  {$EXTERNALSYM NIIF_WARNING}
  NIIF_WARNING   = $00000002;
  {$EXTERNALSYM NIIF_ERROR}
  NIIF_ERROR     = $00000003;
  {$EXTERNALSYM NIIF_USER}
  NIIF_USER      = $00000004;
  {$EXTERNALSYM NIIF_ICON_MASK}
  NIIF_ICON_MASK = $0000000F;
  {$EXTERNALSYM NIIF_NOSOUND}
  NIIF_NOSOUND   = $00000010;

type
  PNotifyIconDataA = ^TNotifyIconDataA;
  PNotifyIconData = PNotifyIconDataA;
  {$EXTERNALSYM _NOTIFYICONDATAA}
  _NOTIFYICONDATAA = record // Recent NotifyIconData structure (XP) - allows balloon hints
    cbSize: DWORD; // In bytes, size of the structure (Windows works out the structure version with it)
    Wnd: HWND; // Handle to which the tray messages should be sent
    uID: UINT; // Icon ID - allows applications to have more than 1 icon by handle
    uFlags: UINT; // Icon flags (NIF_TIP, NIF_ICON, NIF_MESSAGE, NIF_INFO)
    uCallbackMessage: UINT; // Tray message to be sent to Wnd
    hIcon: HICON; // Handle of the icon to send to notification area
    szTip: array [0..127] of AnsiChar; // Tooltip text
    dwState: DWORD; // ??
    dwStateMask: DWORD; // ??
    szInfo: array [0..255] of AnsiChar; // Balloon hint text
    case Integer of
      0: (
        uTimeout: UINT; // Balloon hint timeout, in milliseconds
        szInfoTitle : array [0..63] of AnsiChar; // Balloon hint title
        dwInfoFlags: DWORD; // Balloon hint flags (icon type, for instance)
        guidItem: TGUID); // ??
      1: (
        uVersion: UINT); // ??
  end;
  {$EXTERNALSYM _NOTIFYICONDATA}
  _NOTIFYICONDATA = _NOTIFYICONDATAA;
  TNotifyIconDataA = _NOTIFYICONDATAA;
  TNotifyIconData = TNotifyIconDataA;
  {$EXTERNALSYM NOTIFYICONDATAA}
  NOTIFYICONDATAA = _NOTIFYICONDATAA;
  {$EXTERNALSYM NOTIFYICONDATA}
  NOTIFYICONDATA = NOTIFYICONDATAA;

type
  { Other types }
  { TIconType is used in the IconType property. All icons are in User32.dll }
  TIconType = (itDefault, itWarning, itConfirmation, itError, itInformation, itCustom);
  TBalloonIcon = (biNone, biInfo, biWarning, biError, biCustom);    // Balloon hint icon types
  TMouseButton = (mbLeft, mbRight);                                 // Mouse button clicked
  THideType = (htClosed, htTimeout);                                // Balloon hint hide type

  { Event method types }
  TIconClickEvent = procedure (Sender: TObject; Button: TMouseButton; X, Y: Integer) of Object;
  TIconMoveEvent = procedure (Sender: TObject; X, Y: Integer) of Object;
  TBalloonHideEvent = procedure (Sender: TObject; HideType: THideType) of Object;

  { TrayIcon component }
  TTrayIcon = class(TComponent)
  private
    { Private declarations }
    FDestroying: Boolean;                     // Indicates whether the component is destroying
    FActive: Boolean;                         // Defines whether the icon is active
    FData: TNotifyIconData;                   // Contains notify icon data to send to shell
    FIcon: TIcon;                             // Contains the Delphi icon to add to tray
    FIconType: TIconType;                     // Indicates what type of icon is to be used
    FPopupMenu: TPopupMenu;                   // Stocks the popupmenu who is to be used
    FHandle: HWND;                            // Contains the component handle for tray messages
    FHint: String;                            // Contains the tray icon tooltip
    FOnClick: TIconClickEvent;                // When user clicks on the icon
    FOnMove: TIconMoveEvent;                  // When user moves mouse on the icon
    FOnShow: TNotifyEvent;                    // When icon is shown in notification area
    FOnHide: TNotifyEvent;                    // When icon is hidden from notification area
    FOnBalloonShow: TNotifyEvent;             // When balloon hint is shown
    FOnBalloonClick: TNotifyEvent;            // When user clicked on balloon hint, not including cross
    FOnBalloonHide: TBalloonHideEvent;        // When balloon hint is hidden
    procedure SetIcon(Value: TIcon);          // Icon setter
    procedure SetIconType(Value: TIconType);  // IconType setter
    procedure SetHint(Value: String);         // Hint setter
    procedure SetActive(Value: Boolean);      // Active setter
    function IsRuntime: Boolean;              // Returns True is component is in runtime
    function ShowIcon: Boolean;               // Adds icon to notification area
    function HideIcon: Boolean;               // Hides icon from notification area
    function UpdateIcon: Boolean;             // Modifies the icon if it is in notification area
  protected
    { Protected declarations }
    function GetUser32Icons(Icon: TIconType): HICON;  // Extracts icon from Shell32.dll
    procedure WMTrayIcon(var Message: TMessage);       // Used to control tray icon messages
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;  // Mainly used to allocate window handle
    destructor Destroy; override;                      // Mainly used to deallocate handle
    procedure BalloonHint(                             // Shows a balloon hint :
              Title: String;                           // The title of the balloon hint
              Hint: String;                            // The text of the balloon hint
              Timeout: Byte;                           // The timeout of the balloon, in seconds
              Icon: TBalloonIcon);                     // The icon type
  published
    { Published declarations }
    property OnClick: TIconClickEvent         read FOnClick             write FOnClick;
    property OnMove: TIconMoveEvent           read FOnMove              write FOnMove;
    property OnShow: TNotifyEvent             read FOnShow              write FOnShow;
    property OnHide: TNotifyEvent             read FOnHide              write FOnHide;
    property OnBalloonClick: TNotifyEvent     read FOnBalloonClick      write FOnBalloonClick;
    property OnBalloonShow: TNotifyEvent      read FOnBalloonShow       write FOnBalloonShow;
    property OnBalloonHide: TBalloonHideEvent read FOnBalloonHide       write FOnBalloonHide;
    property Icon: TIcon                      read FIcon                write SetIcon;
    property IconType: TIconType              read FIconType            write SetIconType;
    property Hint: String                     read FHint                write SetHint;
    property Active: Boolean                  read FActive              write SetActive;
    property PopupMenu: TPopupMenu            read FPopupMenu           write FPopupMenu;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Système', [TTrayIcon]);
end;

function TTrayIcon.IsRuntime: Boolean;
begin
 Result := not (csDesigning in ComponentState);
end;

function TTrayIcon.GetUser32Icons(Icon: TIconType): HICON;
const
  IconTypes: array [TIconType] of SmallInt = (0, 1, 2, 3, 4, -1);
begin
 { We are going to extract the icons from user32.dll }
 Result := ExtractIcon(HInstance, '%SystemRoot%\system32\User32.dll', IconTypes[Icon]);
end;

constructor TTrayIcon.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);                  // Creates the component : always first
 FHandle := AllocateHWND(WMTrayIcon);       // Allocates a window (and a handle, therefore) for the component
 FHint := 'My Tray Icon';                   // Sets hint to default
 FillMemory(@FData, SizeOf(FData), 0);      // Initializes notification icon structure
 FData.cbSize := SizeOf(FData);             // Sets structure size     -|
 FData.uCallbackMessage := WM_TRAYICON;     // Sets callback message    | These 4 values never change,
 FData.Wnd := FHandle;                      // Sets callback handle     | so we initialize them here.
 FData.uID := 1;                            // Sets icon ID            -|
 FIconType := itCustom;                     // Sets IconType to diCustom as default value
 FIcon := TIcon.Create;                     // Creates Delphi icon structure
end;

destructor TTrayIcon.Destroy;
begin
 FDestroying := True;                   // Indicates that component is now destroying
 HideIcon;                              // Hides the icon
 FIcon.Free;                            // Frees Delphi icon structure
 DeallocateHWND(FHandle);               // Deallocates our component handle
 inherited Destroy;                     // Destroys the component : always last
end;

procedure TTrayIcon.WMTrayIcon(var Message: TMessage);
Var
 Pos: TPoint; 
begin
 if FDestroying then Exit; // If the component is destroying, no more message handling !

 if Message.Msg <> WM_TRAYICON then Exit; // If received message is not a tray message, then exit.
 GetCursorPos(Pos);                       // Retreive cursor position for popup or event information.

 case Message.lParam of                   // Depending on tray message (stocked in lParam)
  NIN_BALLOONSHOW: if Assigned(FOnBalloonShow) then FOnBalloonShow(self);
        // The balloon was drawed by the system - we call the OnBalloonShow event
  NIN_BALLOONHIDE: if Assigned(FOnBalloonHide) then FOnBalloonHide(self, htClosed);
        // The balloon was erased by the system - we call the OnBalloonHide event
  NIN_BALLOONTIMEOUT: if Assigned(FOnBalloonHide) then FOnBalloonHide(self, htTimeOut);
        // The balloon timeout elapsed - we call the OnBalloonHide event
  NIN_BALLOONUSERCLICK: begin
                         if Assigned(FOnBalloonClick) then FOnBalloonClick(self);
                         if Assigned(FOnBalloonHide) then FOnBalloonHide(self, htClosed);
                        end;
        // The user clicked on the balloon - we call OnBalloonClick, then OnBalloonHide
  WM_LBUTTONUP: if Assigned(FOnClick) then FOnClick(self, mbLeft, Pos.X, Pos.Y);
        // The user clicked on icon with left mouse button - we call OnClick
  WM_RBUTTONUP: begin
                  if Assigned(FOnClick) then FOnClick(self, mbRight, Pos.X, Pos.Y);
                  if Assigned(FPopupMenu) then FPopupMenu.Popup(Pos.X, Pos.Y);
                 end;
        // The user clicked on icon with right mouse button - we call OnClick
  WM_MOUSEMOVE: if Assigned(FOnMove) then FOnMove(self, Pos.X, Pos.Y);
        // The user moved the mouse over the icon - we call OnMove
  end;
end;

function TTrayIcon.ShowIcon: Boolean;
begin
 Result := False;
 if (not FActive) and (IsRuntime) then                     // If it is runtime and if no icon is active ...
  begin
   Result := Shell_NotifyIcon(NIM_ADD, @FData);            // We add the icon
   if (Assigned(FOnShow)) and (Result) and (not FDestroying) then FOnShow(self); // We call the OnShow event
  end;
end;

function TTrayIcon.HideIcon: Boolean;
begin
 Result := False;
 if (FActive) and (IsRuntime) then                         // If it is runtime and if an icon is active ...
  begin
   Result := Shell_NotifyIcon(NIM_DELETE, @FData);         // We delete the icon
   if (Assigned(FOnHide)) and (Result) and (not FDestroying) then FOnHide(self); // We call the OnHide event
  end;
end;

function TTrayIcon.UpdateIcon: Boolean;
begin
 Result := False;
 if Assigned(FIcon) then FData.hIcon := FIcon.Handle else FData.hIcon := 0;
 StrPLCopy(FData.szTip, FHint, 127);                                     // We set szTip to the Hint property
 FData.uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP;                     // We set the appropriate flags
 if (FActive) and (IsRuntime) then Result := Shell_NotifyIcon(NIM_MODIFY, @FData); // We modify the icon
end;

procedure TTrayIcon.SetIcon(Value: TIcon);
begin
 if Value <> FIcon then                                 // If the icon is different ...
  begin
   FIcon.Assign(Value);                                 // We stock the new icon in the component
   UpdateIcon;                                          // We update the icon
  end;
end;

procedure TTrayIcon.SetIconType(Value: TIconType);
begin
 if Value <> FIconType then                            // If the icon type is different ...
  begin
   if FIcon.Handle <> 0 then FIcon.ReleaseHandle;      // We release the precent icon's handle
   if Value <> itCustom then FIcon.Handle := GetUser32Icons(Value); // We load the predefined icon
   FIconType := Value;                                              // We update property
   UpdateIcon;                                                      // We update the icon
  end;
end;

procedure TTrayIcon.SetHint(Value: String);
begin
 if Value <> '' then                                    // If the hint is not empty
  begin
   FHint := Value;                                      // We stock the new hint in the component
   UpdateIcon;                                          // And we update the icon
  end;
end;


procedure TTrayIcon.SetActive(Value: Boolean);
const
 ShellError = 'Icon operation error.';
Var
 Success: Boolean;                               // Error-checking variable
begin
 if Value <> FActive then                        // If the icon state is different ...
  begin
   Success := False;                             // Initialize error-checking variable
   case Value of                                 // Depending on new value ...
    False: Success := HideIcon;                  // We hide the icon if Value is False
    True: Success := ShowIcon;                   // We show the icon if Value is True
   end;
   if not IsRuntime then Success := True;        // However, if we are not in runtime, no error-checking
   if Success then FActive := Value else         // Finally, we stock the new state
    raise Exception.Create(ShellError);
   { However, if an error occurs, we send an error message. }
  end;
end;

procedure TTrayIcon.BalloonHint(Title: String; Hint: String; Timeout: Byte; Icon: TBalloonIcon);
const
 IconTypes: array[TBalloonIcon] of Byte =
  (NIIF_NONE, NIIF_INFO, NIIF_WARNING, NIIF_ERROR, NIIF_USER);
begin
 if (IsRuntime) and (FActive) then             // If we are in runtime, and if our icon is active ...
  begin
   FData.uFlags := NIF_MESSAGE or NIF_TIP or NIF_ICON or NIF_INFO; // We add a flag, NIF_INFO
   StrPLCopy(FData.szInfoTitle, Title, 63);                        // We set the balloon hint title
   StrPLCopy(FData.szInfo, '', 255);                               // We clear text for deleting
   Shell_NotifyIcon(NIM_MODIFY, @FData);                           // We modify the icon
   StrPLCopy(FData.szInfo, Hint, 255);                             // We set the balloon hint text
   FData.uTimeout := Timeout * 1000;                               // We set the timeout (ms)
   FData.dwInfoFlags := IconTypes[Icon];                           // We set the icon
   Shell_NotifyIcon(NIM_MODIFY, @FData);                           // We modify the icon again !
   UpdateIcon;                                                     // We set structure back to normal
  end;
end;

end.
