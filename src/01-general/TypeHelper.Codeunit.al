codeunit 83851 "Type Helper TPTE"
{
    procedure CalcDateTime(DateExpression: Text; CurrDateTime: DateTime) NewDateTime: DateTime
    var
        CurrentDate: Date;
        CurrentTime: Time;
    begin
        CurrentDate := CurrDateTime.Date();
        CurrentTime := CurrDateTime.Time();
        CurrentDate := CalcDate(DateExpression, CurrentDate);
        NewDateTime := CreateDateTime(CurrentDate, CurrentTime);
    end;

    procedure GetUserID(): Code[50]
    begin
        exit(CopyStr(UserId(), 1, 50));
    end;
}