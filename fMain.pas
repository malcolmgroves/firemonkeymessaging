unit fMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Rtti, System.Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs,
  FMX.StdCtrls, FMX.Messages, FMX.Edit, FMX.Layouts, FMX.ListBox;

type
  TTextMessage = class(TMessage)
  private
    FText: string;
  public
    property Text : string read FText;
    constructor Create(const Text : string); virtual;
  end;

  TListboxSelectionChangedMessage = class(TMessage)
  private
    FListbox: TListbox;
  public
    property Listbox : TListbox read FListbox;
    constructor Create(const Listbox : TListbox); virtual;
  end;

  TForm11 = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    ListBox1: TListBox;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    ListBox2: TListBox;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure ListBox1Change(Sender: TObject);
  private
    fMessageBus : TMessageManager;
    fFirstSubscriberID, fSecondSubscriberID, fThirdSubscriberID : Integer;
    function GetMessageBus: TMessageManager;
    { Private declarations }
  public
    { Public declarations }
    property MessageBus : TMessageManager read GetMessageBus;
  end;

var
  Form11: TForm11;

implementation

{$R *.fmx}

{ TForm11 }

procedure TForm11.Button1Click(Sender: TObject);
var
  TextMessageListener : TMessageListener;
begin
  TextMessageListener := procedure(const Sender : TObject; const M : TMessage)
                         begin
                           ListBox1.Items.Add('TTextMessage Received. Text = ' + (M as TTextMessage).Text);
                         end;

  fFirstSubscriberID := MessageBus.SubscribeToMessage(TTextMessage, TextMessageListener);
end;

procedure TForm11.Button2Click(Sender: TObject);
begin
  MessageBus.SendMessage(self, TTextMessage.Create(Edit1.Text));
end;

procedure TForm11.Button3Click(Sender: TObject);
begin
  MessageBus.Unsubscribe(TTextMessage, fFirstSubscriberID);
end;

procedure TForm11.Button4Click(Sender: TObject);
var
  TextMessageListener, SelectionChangedListener : TMessageListener;
begin
  TextMessageListener := procedure(const Sender : TObject; const M : TMessage)
                         begin
                           ListBox2.Items.Add('TTextMessage Received. Text = ' + (M as TTextMessage).Text);
                         end;

  fSecondSubscriberID := MessageBus.SubscribeToMessage(TTextMessage, TextMessageListener);

  SelectionChangedListener :=  procedure(const Sender : TObject; const M : TMessage)
                               begin
                                 ListBox2.Items.Add('TListboxSelectionChangedMessage Received. Item = ' +
                                                    IntToStr((M as TListboxSelectionChangedMessage).Listbox.Selected.Index));
                              end;

  fThirdSubscriberID := MessageBus.SubscribeToMessage(TListboxSelectionChangedMessage, SelectionChangedListener);

end;

procedure TForm11.Button5Click(Sender: TObject);
begin
  MessageBus.Unsubscribe(TTextMessage, fSecondSubscriberID);
  MessageBus.Unsubscribe(TListboxSelectionChangedMessage, fThirdSubscriberID);
end;

procedure TForm11.FormCreate(Sender: TObject);
begin
  MessageBus.RegisterMessageClass(TTextMessage);
  MessageBus.RegisterMessageClass(TListboxSelectionChangedMessage);
end;

procedure TForm11.FormDestroy(Sender: TObject);
begin
  FMessageBus.Free;
end;

function TForm11.GetMessageBus: TMessageManager;
begin
  if not Assigned(fMessageBus) then
    FMessageBus := TMessageManager.Create;
  Result := fMessageBus;
end;

procedure TForm11.ListBox1Change(Sender: TObject);
begin
  MessageBus.SendMessage(self, TListboxSelectionChangedMessage.Create(ListBox1));
end;

{ TTextMessage }

constructor TTextMessage.Create(const Text: string);
begin
  fText := Text;
end;

{ TListboxUpdatedMessage }

constructor TListboxSelectionChangedMessage.Create(const Listbox: TListbox);
begin
  self.FListbox := Listbox;
end;

end.
