{$APPTYPE GUI}
{$mode delphi}
{$R-}
uses
  Windows, SysUtils;

const
  BYTES_PER_LINE=16; {Это критично!!! Не менять никогл и не при к ких обстоятельств х}

var
  MainWnd: HWND;
  BtnDump: HWND;

  F:File;
  Buf:array[0..BYTES_PER_LINE-1] of Byte;
  w:byte;
  Count,I{,Offset}:Integer;
  InName,OutName:string;
  T:text;
  Offset:Int64;

  FilterFF15: Boolean = False; { ? Їырцюъ Їшы№ЄЁрЎшш }

procedure WriteHexLine;
begin
  Write(T,Format('%.8X |',[Offset]));
  For I:=0 to Count-1 do begin
                         Write(T,Format('%.2X ',[Buf[I]]));
                         end;
  For I:=Count to BYTES_PER_LINE-1 do begin
                                          Write(T,' ');
                                          end;
  Write(T,'|');
  For I:=0 to Count-1 do begin
                         If (Buf[I]>=32) and (Buf[I]<=126) then
                                                                Write(T,Chr(Buf[i]))
                         else Write(T,' ');
                         end;
  Writeln(T,'|');
end;

procedure RunDumper;
var j: Integer;
    HasFF: Boolean;
begin
  {Writeln('Hello World!');}
  OutName:='CPU_chec_list_open_1.DMP.txt';
  InName:='CPU_chec_list_open_1.DMP';
  Assign(F,InName);
  FileMode:=0;//read-only
  Reset(F,1);//1=untyped, byte-level
  Assign(T,OutName);
  Rewrite(T);
  Offset:=0;
  repeat
    BlockRead(F,Buf,SizeOf(Buf),Count);
    if Count>0 then begin

                    { ---- ─╬╧.╙╤╦╬┬╚┼ ─╦▀ ┬╥╬╨╬╔ ╩═╬╧╩╚ ---- }
                    if FilterFF15 then
                    begin
                      HasFF := False;
                      for j := 0 to Count-2 do
                        if (Buf[j] = $FF) and (Buf[j+1] = $15) then
                        begin
                          HasFF := True;
                          Break;
                        end;

                      if not HasFF then
                      begin
                        Inc(Offset,Count);
                        Continue;
                      end;
                    end;
                    { ---------------------------------------- }

                    WriteHexLine;
                    Inc(Offset,Count);
                    end;
    until Count=0;
    Close(F);
    writeln(T,'+');
    Close(T);
  MessageBox(MainWnd, '─рья уюЄют', 'Info', MB_OK);
end;

function WndProc(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  case Msg of
    WM_COMMAND:
      begin
        if (LOWORD(wParam) = 1001) then
        begin
          FilterFF15 := False; { юс√ўэ√щ фрья }
          RunDumper;
        end;

        if (LOWORD(wParam) = 1002) then
        begin
          FilterFF15 := True; { фрья ё FF 15 }
          RunDumper;
        end;
      end;

    WM_DESTROY:
      begin
        PostQuitMessage(0);
        Result := 0;
        Exit;
      end;
  end;

  Result := DefWindowProc(hWnd, Msg, wParam, lParam);
end;

procedure CreateMainWindow;
var
  wc: WNDCLASS;
begin
  FillChar(wc, SizeOf(wc), 0);
  wc.lpfnWndProc := @WndProc;
  wc.hInstance := hInstance;
  wc.lpszClassName := 'ProcWin';

  RegisterClass(wc);

  MainWnd := CreateWindowEx(
    0, 'ProcWin', '╠ющ фрьяхЁ',
    WS_OVERLAPPEDWINDOW,
    CW_USEDEFAULT, CW_USEDEFAULT,
    500, 300,
    0, 0, hInstance, nil);

  BtnDump := CreateWindowEx(
    0, 'BUTTON', '╤фхырЄ№ фрья',
    WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON,
    20, 20, 150, 30,
    MainWnd, HMENU(1001), hInstance, nil);

  CreateWindowEx(
    0, 'BUTTON', '─рья FF15',
    WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON,
    20, 60, 150, 30,
    MainWnd, HMENU(1002), hInstance, nil);

  ShowWindow(MainWnd, SW_SHOW);
  UpdateWindow(MainWnd);
end;

var
  Msg: TMsg;

begin
  CreateMainWindow;

  while GetMessage(Msg, 0, 0, 0) do
  begin
    TranslateMessage(Msg);
    DispatchMessage(Msg);
  end;
end.
