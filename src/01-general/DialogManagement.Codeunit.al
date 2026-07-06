codeunit 83911 "Dialog Management TPTE"
{
    trigger OnRun()
    begin
    end;

    var
        BluaceFunctions: Codeunit "Bluace Functions TPTE";
        Status: Dialog;
        MaxStatus: Integer;
        MaxStatus2: Integer;
        VarCounter: Integer;
        VarCounter2: Integer;

    procedure OpenStatusWindow(VarText: Text[1024]; VarMax: Integer)
    begin
        Status.Open(VarText + '  @1@@@@@@@@@'); //Extra spaties tbv Afkappen tekst
        MaxStatus := VarMax;
        VarCounter := 0;
    end;

    procedure OpenStatusWindow2(HeaderText1: Text[1024]; HeaderText2: Text[1024]; HeaderText3: Text[1024]; VarMax: Integer; VarMax2: Integer; StatusText: Text[1024])
    var
        VarLenLoc: Integer;
    begin
        VarLenLoc := StrLen(HeaderText1);
        if StrLen(HeaderText2) > VarLenLoc then
            VarLenLoc := StrLen(HeaderText2);

        if StrLen(HeaderText3) > VarLenLoc then
            VarLenLoc := StrLen(HeaderText3);

        if HeaderText1 <> '' then
            HeaderText1 := CopyStr(BluaceFunctions.PADSTRBV(HeaderText1, VarLenLoc, ' ', false), 1, 1024);
        if HeaderText2 <> '' then
            HeaderText2 := BluaceFunctions.PADSTRBV(HeaderText2, VarLenLoc, ' ', false);
        if HeaderText3 <> '' then
            HeaderText3 := BluaceFunctions.PADSTRBV(HeaderText3, VarLenLoc, ' ', false);

        if VarMax2 > 0 then begin
            if HeaderText3 <> '' then
                Status.Open(HeaderText3 + '#3########\\' +
                            HeaderText1 + '@1@@@@@@@@\\' +
                            HeaderText2 + '@2@@@@@@@@')
            else
                Status.Open(StatusText +
                            HeaderText1 + '@1@@@@@@@@\\' +
                            HeaderText2 + '@2@@@@@@@@');
        end else
            if HeaderText3 <> '' then
                Status.Open(HeaderText3 + '#3########\\' +
                            HeaderText1 + '@1@@@@@@@@')
            else
                Status.Open(HeaderText1 + '@1@@@@@@@@');

        MaxStatus := VarMax;
        MaxStatus2 := VarMax2;
        VarCounter := 0;
        VarCounter2 := 0;
    end;

    procedure OpenStatusWindow3(VarText: Text[1024]; VarMax: Integer)
    // var
    // Text1000: Label 'Automatic Dataconversion:\';
    begin
        Status.Open(VarText);
        MaxStatus := VarMax;
        VarCounter := 0;
    end;

    procedure OpenStatusWindowHeaderSub(HeaderText: Text[1024]; SubText: Text[100]; MaxHeader: Integer; MaxSub: Integer)
    // var
    // Text1000: Label 'Automatic Dataconversion:\';
    begin
        //A458
        Status.Open(HeaderText + '  @1@@@@@@@@\\' +
                    SubText + '  @2@@@@@@@@');
        MaxStatus := MaxHeader;
        MaxStatus2 := MaxSub;
        VarCounter := 0;
        VarCounter2 := 0;
    end;

    procedure UpdateStatusWindow()
    begin
        UpdateStatusWindowCounter(1);
    end;

    procedure UpdateStatusWindow2(VarType: Integer)
    begin
        UpdateStatusWindowCounter2(VarType, 1);
    end;

    procedure UpdateStatusWindowCounter(AddCount: Integer)
    begin
        //De counter wordt met het meegegeven aantal verhoogd
        VarCounter += AddCount;
        if MaxStatus <> 0 then
            Status.Update(1, Round(VarCounter / MaxStatus * 10000, 1));
    end;

    procedure UpdateStatusWindowCounter2(VarType: Integer; AddCount: Integer)
    begin
        if MaxStatus <> 0 then begin
            if VarType = 1 then begin
                VarCounter += AddCount;

                if MaxStatus = 0 then //A458
                    exit;               //A458

                Status.Update(VarType, Round(VarCounter / MaxStatus * 10000, 1));
            end;

            if VarType = 2 then begin
                VarCounter2 += AddCount;

                if MaxStatus2 = 0 then //A458
                    exit;                //A458

                Status.Update(VarType, Round(VarCounter2 / MaxStatus2 * 10000, 1));
            end;
        end;
    end;

    procedure UpdateStatusWindowText(VarText: Text[50])
    begin
        Status.Update(3, VarText);
    end;

    procedure ResetStatusWindow(VarIndex: Integer)
    begin
        Status.Update(VarIndex, 0);
    end;

    procedure CloseStatusWindow()
    begin
        Status.Close();
    end;

    procedure SetMax(VarMax1: Integer; VarMax2: Integer)
    begin
        if VarMax1 > 0 then
            MaxStatus := VarMax1;

        if VarMax2 > 0 then
            MaxStatus2 := VarMax2;
    end;

    procedure ClearCounter(VarType: Integer)
    begin
        if VarType = 1 then
            VarCounter := 0;

        if VarType = 2 then
            VarCounter2 := 0;
    end;
}

