unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    TreeView1: TTreeView;
    Button4: TButton;
    Button5: TButton;
    lbl1: TLabel;
    btn1: TButton;
    lst1: TListBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  pTree = ^tTree;
  tTree = record
    data : integer;
    Right, Left, Parent : pTree;
  end;


var
  Form1: TForm1;
  root : pTree;
  TTN : TTreeNode;
  AR : array of pTree;
  wer:Integer;

implementation



{$R *.dfm}

//Функция возвращает максимальное из двух чисел
function Max(Lhs, Rhs : integer):integer;
begin
  if Lhs > Rhs then
    Max:=Lhs
  else Max := Rhs;
end;

//Вставка элемента
procedure InsertNode(Data : integer);
var
  x,current,parent : pTree;
begin
  current:=root;
  parent:=nil;
  while current <> nil do begin
    if Data = current^.data then exit;
    parent:=current;
    if data < current^.data then
      current:=current^.left
    else current:=current^.right;
  end;
  new(x);
  x^.data := data;
  x^.parent:=parent;
  x^.left:=nil;
  x^.right:=nil;
  if parent <> nil then
    if x.data < parent.data then
      parent.left:=x
    else parent.right := x
  else
    root:=x;
end;

//Удаление элемента
procedure DeleteNode(z : pTree);
var
  x,y : pTree;
begin
  if z = nil then exit;
  if (z.Left = nil) and (z.Right = nil) then
    y:=z
  else begin
    if z.Right <> nil then begin
      y:=z.Right;
      while y.Left <> nil do
        y:=y.Left;
    end;
  end;
  if y.Left <> nil then
    x:=y.Left
  else
    x:=y.Right;
  if x<>nil then x.Parent:=y.Parent;
  if y.Parent<>nil then
    if y = y.Parent.Left then
      y.Parent.Left:=x
    else
      y.Parent.Right:=x
  else
    root:=x;
  if y <> z then begin
    y.Left:=z.Left;
    if y.Left<>nil then
      y.Left.Parent:=y;
    y.Right:=z.Right;
    if y.Right <> nil then
      y.Right.Parent:=y;
    y.Parent:=z.Parent;
    if z.Parent <> nil then
      if z = z.Parent.Left then
        z.Parent.Left:=y
      else
        z.Parent.Right:=y
    else
      root:=y;
    dispose(z);
  end
  else
    dispose(y);
end;

//Удаление дерева
procedure DelTree(curr : pTree);
begin
  if curr <> nil then begin
    DelTree(curr^.Left);
    DelTree(curr^.Right);
    dispose(curr);
  end;
end;


//Поиск узла
function findNode(data : integer): pTree;
var
  current : pTree;
begin
  current:=root;
  while current <> nil do
    if data = current.data then begin
      findNode:=current;
      exit;
    end
    else
      if data < current.data then
        current:=current.Left
      else current := current.Right;
    findNode:=nil;
end;

//Вывод дерева
procedure PrintT(Tree:pTree; Pointer:TTreeNode);
var
  CurrPointer:TTreeNode;
begin
    If Tree = nil then Exit;
    CurrPointer:=Form1.TreeView1.Items.AddChild(Pointer,IntToStr(Tree^.data));
    PrintT(Tree^.Left,CurrPointer);
    PrintT(Tree^.Right,CurrPointer);
  end;

procedure TForm1.Button1Click(Sender: TObject);
begin
    InsertNode(StrToInt(Form1.Edit1.Text));
 Form1.Edit1.Text:='';
  Button2Click(Sender);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if Form1.TreeView1.Items.GetFirstNode <> nil then
    Form1.TreeView1.Items[0].Delete;
    PrintT(root,TTN);
  Form1.TreeView1.FullExpand;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
    DeleteNode(findNode(StrToInt(Form1.Edit1.Text)));
  Form1.Edit1.Text:='';
  Button2Click(Sender);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  if root<>nil then
  begin
    DelTree(root);
    root:=nil;
    Button2Click(Sender);
    end
    else
    ShowMessage('Дерево пусто');
end;

procedure BalanceBin(p : pTree);
var
  k:integer;
begin
  if p <> nil then begin
    if p.data < root.data then begin
      Setlength(AR,length(AR)+1);
      AR[length(AR)-1]:=p;
    end;
    BalanceBin(p.Left);
    BalanceBin(p.Right);
  end;
end;


procedure TForm1.Button6Click(Sender: TObject);
var
  k,i : integer;
  current : pTree;
begin

  if root <> nil then begin
  root.data:=root.data*root.data;
  if root <> nil then
    if (root.right <> nil) then begin
        balanceBin(root.Right);
        for i:=length(AR)-1 downto 0 do begin
          k:=AR[i].data;
          DeleteNode(AR[i]);
          InsertNode(K);
        end;

      end;
  end;
    Button2Click(Sender);
end;

procedure Obhod1(curr : pTree);
begin
  if curr <> nil then
  begin
    Form1.Lst1.Items.Add(IntToStr(curr^.data));
    if (curr^.Left=nil) and (curr^.Right=nil) then wer:=wer+curr^.data;;
    Obhod1(curr^.Left);
    Obhod1(curr^.Right);
  end;
end;


procedure TForm1.btn1Click(Sender: TObject);  //    Вывод суммы в листьях
begin
  wer:=0;
     lst1.Clear;
    Obhod1(root);
    ShowMessage('Сумма значений, находящихся в листьях: '+IntToStr(wer));
end;

end.



