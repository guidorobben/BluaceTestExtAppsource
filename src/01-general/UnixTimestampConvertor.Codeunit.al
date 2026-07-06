codeunit 83882 "Unix Timestamp Convertor TPTE"
{
    procedure EvaluateUnixTimestampToTimeZoneOld(Timestamp: BigInteger) ResultDate: Date
    var
        CalculatedBigInteger: BigInteger;
    begin
        ResultDate := 19700101D;
        Timestamp := CreateBigInteger(Format(Timestamp));

        //vervangen door div
        repeat
            CalculatedBigInteger += 86400;
            ResultDate := CalcDate('<1D>', ResultDate);
        until CalculatedBigInteger >= Timestamp;

        if (Timestamp - CalculatedBigInteger) > 43200 then
            ResultDate := CalcDate('<-1D>', ResultDate);

        exit(ResultDate);
    end;

    local procedure CreateBigInteger(TextValue: Text) Result: BigInteger
    var
        i: Integer;
        SingleDigit: Integer;
    begin
        for i := 1 to StrLen(TextValue) do begin
            Evaluate(SingleDigit, CopyStr(TextValue, i, 1));
            Result := (Result * 10) + SingleDigit;
        end;
    end;

    procedure EvaluateUnixTimestampToTimeZone(OldValue: Text) NewDateTime: DateTime
    var
        TypeHelper: Codeunit "Type Helper";
        TempBinteger: BigInteger;
    begin
        Evaluate(TempBinteger, OldValue);
        NewDateTime := TypeHelper.EvaluateUnixTimestamp(TempBinteger);
    end;

    procedure EvaluateUnixTimestampToTimeZone(Timestamp: BigInteger) NewDateTime: DateTime
    var
        TypeHelper: Codeunit "Type Helper";
    begin
        NewDateTime := TypeHelper.EvaluateUnixTimestamp(Timestamp);
    end;


    procedure EvaluateUnixTimestamp(Timestamp: BigInteger): DateTime
    var
        TimestampInMilliseconds: BigInteger;
        EpochDateTime: DateTime;
        ResultDateTime: DateTime;
        TimezoneOffset: Duration;
    begin
        // if not GetUserTimezoneOffset(TimezoneOffset) then
        //     TimezoneOffset := 0;

        EpochDateTime := CreateDateTime(DMY2Date(1, 1, 1970), 0T);

        TimestampInMilliseconds := Timestamp * 1000;

        ResultDateTime := EpochDateTime + TimestampInMilliseconds + TimezoneOffset;

        exit(ResultDateTime);
    end;

    procedure EvaluateUnixTimestampToGMTCustom(Timestamp: BigInteger; UserTimeZone: Boolean; var ResultDate: Date; var ResultTime: Time)
    var
        TimeZone: Codeunit "Time Zone";
        TypeHelper: Codeunit "Type Helper";
        days, seconds : BigInteger;
        TimestampInMilliseconds: BigInteger;
        EpochStart: Date;
        targetdate: Date;
        EpochDateTime: DateTime;
        ResultDateTime: DateTime;
        TimezoneOffset: Duration;
        targettime: Time;
    begin
        if UserTimeZone then
            if not TypeHelper.GetUserTimezoneOffset(TimezoneOffset) then
                TimezoneOffset := 0;

        // TypeHelper.


        EpochStart := DMY2Date(1, 1, 1970);
        // if UserTimeZone then
        //     Timestamp += TimezoneOffset;

        Timestamp += TimezoneOffset;

        days := Timestamp div 86400;
        seconds := Timestamp mod 86400;

        // TimestampInMilliseconds := Timestamp * 1000;
        targetdate := EpochStart + days;
        targettime := 000000T + (seconds * 1000);
        // ResultDateTime := EpochDateTime + TimestampInMilliseconds; // + TimezoneOffset;
        // ResultDateTime := CreateDateTime(targetdate, targettime); //Including DST        

        // ResultDateTime := TypeHelper.ConvertDateTimeFromUTCToTimeZone(ResultDateTime, 'UTC');
        // if TimeZone.IsDaylightSavingTime(ResultDateTime, GetUserTimezone()) then
        //     ResultDateTime -= 3600000; //Omzetten naar uur
        ResultDate := targetdate;
        ResultTime := targettime;

        if UserTimeZone then begin
            ResultDateTime += TimezoneOffset;

            // if TimeZone.IsDaylightSavingTime(ResultDateTime, GetUserTimezone()) then
            //     ResultDateTime += TimezoneOffset; //Omzetten naar uur
        end;
    end;

    procedure EvaluateUnixTimestamp(Timestamp: BigInteger; TimezoneOffset: Duration) DT: DateTime
    var
        TypeHelper: Codeunit "Type Helper";
        TimestampInMilliseconds: BigInteger;
        EpochDateTime: DateTime;
        ResultDateTime: DateTime;
    begin
        // if not GetUserTimezoneOffset(TimezoneOffset) then
        // TimezoneOffset := 0;
        // TypeHelper.GetTimezoneOffset(TimezoneOffset, TimezoneOffsetID);

        // EpochDateTime := CreateDateTime(DMY2Date(1, 1, 1970), 0T);

        // TimestampInMilliseconds := Timestamp * 1000;

        // ResultDateTime := EpochDateTime + TimestampInMilliseconds + TimezoneOffset;

        // ResultDateTime := EvaluateUnixTimestampToGMTCustom(Timestamp, false) + TimezoneOffset;
        exit(ResultDateTime);
    end;

    // local procedure GetUserTimezoneOffset(var Duration: Duration): Boolean
    // var
    //     UserPersonalization: Record "User Personalization";
    //     TimeZoneInfo: DotNet TimeZoneInfo;
    //     TimeZone: Text;
    // begin
    //     if not UserPersonalization.Get(UserSecurityId()) then
    //         exit(false);

    //     TimeZone := UserPersonalization."Time Zone";

    //     if TimeZone = '' then
    //         exit(false);

    //     TimeZoneInfo := TimeZoneInfo.FindSystemTimeZoneById(TimeZone);
    //     Duration := TimeZoneInfo.BaseUtcOffset;
    //     exit(true);
    // end;

    // 1735686000000+0100
    // 1656540000

    procedure Guido(Complete: Text; var Timestamp: BigInteger; var Offsett: Duration)
    var
        GG, Hours, Minutes : Integer;
        Pos: Integer;
        OffsetText: Text;
        TimestampText: Text;
    begin
        TimestampText := CopyStr(Complete, 1, 10);
        Evaluate(Timestamp, TimestampText);

        Pos := StrPos(Complete, '+');
        if Pos > 0 then begin
            GG := 1;
            OffsetText := CopyStr(Complete, Pos + 1, 4);
        end;

        Pos := StrPos(Complete, '-');
        if Pos > 0 then begin
            GG := -1;
            OffsetText := CopyStr(Complete, Pos + 1, 4);
        end;

        if OffsetText <> '' then begin
            Hours := 1;
            Minutes := 0;
            Offsett := Hours * 3600000;
        end;
    end;

    procedure GetUserTimezone() TimeZone: Text
    var
        UserPersonalization: Record "User Personalization";
    // TimeZoneInfo: DotNet TimeZoneInfo;
    // TimeZone: Text;
    begin
        UserPersonalization.SetLoadFields("Time Zone");
        if not UserPersonalization.Get(UserSecurityId()) then
            exit;

        TimeZone := UserPersonalization."Time Zone";

        // if TimeZone = '' then
        //     exit(false);

        // TimeZoneInfo := TimeZoneInfo.FindSystemTimeZoneById(TimeZone);
        // Duration := TimeZoneInfo.BaseUtcOffset;
        // exit(true);
    end;

    procedure IsDaylightSavingTime(DateTimeToCheck: DateTime): Boolean
    var
        // ResultDateTime: DateTime;
        TimeZone: Codeunit "Time Zone";
    begin
        exit(TimeZone.IsDaylightSavingTime(DateTimeToCheck, GetUserTimezone()));
    end;

    procedure IsDaylightSavingTime(DateToCheck: Date; TimeToCheck: Time): Boolean
    var
        DateTimeToCheck: DateTime;
    begin
        DateTimeToCheck := CreateDateTime(DateToCheck, TimeToCheck);
        exit(IsDaylightSavingTime(DateTimeToCheck));
    end;

}