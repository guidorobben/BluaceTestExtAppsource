page 83870 "Unix Timestamp Convertor TPTE"
{
    ApplicationArea = All;
    Caption = 'Unix Timestamp Convertor (Demo)';
    PageType = Worksheet;
    SourceTable = "Unix Timestamp convertor TPTE";
    SourceTableTemporary = true;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            field(TimestampFrom; TimestampFrom)
            {
                Caption = 'From';
                MinValue = 0;
            }
            field(TimestampTo; TimestampTo)
            {
                Caption = 'To';
                MinValue = 0;
            }
            field(OffsetDuration; OffsetDuration)
            {
                Caption = 'Offset Duration';
            }
            field(TimeZone; TimeZoneOffset)
            {
                Caption = 'Time Zone';
            }
            field(Interval; Interval)
            {
                Caption = 'Interval';
                MinValue = 1;
            }
            field(MaxCalculations; MaxCalculations)
            {
                Caption = 'Max Calculations';
                MinValue = 1;
            }

            repeater(General)
            {
                Editable = false;

                field("Unix Timestamp"; Rec."Unix Timestamp") { }
                field(GMT; Rec."GMT (Date)") { }
                field("GMT (Time)"; Rec."GMT (Time)") { }
                field("My Time Zone"; Rec."My Time Zone") { }

                field(GMT2; Rec.GMT2) { }
                field("Is Daylight Saving"; Rec."Is Daylight Saving") { }
                field("My Time Zone (Custom)"; Rec."My Time Zone (Custom)") { }

                field("My Time Zone (Conv)"; Rec."My Time Zone (Conv)") { }

                field("My Time Zone (Old) "; Rec."My Time Zone (Old)") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ConvertTo)
            {
                Caption = 'Convert to Date';
                Image = DateRange;

                trigger OnAction()
                begin
                    BuildDates();
                end;
            }
            action(test)
            {
                Caption = 'Test';
                // Image = Test;

                trigger OnAction()
                var
                    UnixTimestampConvertorPTE: Codeunit "Unix Timestamp Convertor TPTE";
                    Timestamp: BigInteger;
                    Dur: Duration;
                begin
                    // UnixTimestampConvertorPTE.Guido('1735686000000+0100', Timestamp, Dur);
                    UnixTimestampConvertorPTE.Guido('1656540000000+0100', Timestamp, Dur);

                    TimestampFrom := Timestamp;
                    OffsetDuration := Dur;
                end;
            }
            action(test2)
            {
                Caption = 'Test2';
                // Image = Test;

                trigger OnAction()
                var
                // UnixTimestampConvertorPTE: Codeunit "Unix Timestamp Convertor TPTE";
                // Timestamp: BigInteger;
                // Dur: Duration;
                begin
                    ClearResult();
                    // UnixTimestampConvertorPTE.Guido('1735686000000+0100', Timestamp, Dur);
                    // UnixTimestampConvertorPTE.Guido('1656540000000+0100', Timestamp, Dur);

                    // TimestampFrom := Timestamp;
                    // OffsetDuration := Dur;
                    ConvertToDates(1774749600);
                end;
            }



        }
        area(Promoted)
        {
            actionref(ConvertTo_Promoted; ConvertTo) { }
            actionref(test_Promoted; test2) { }
        }
    }

    var
        TimestampFrom: BigInteger;
        TimestampTo: BigInteger;
        OffsetDuration: Duration;
        Interval, MaxCalculations : Integer;
        TimeZoneOffset: Text[100];

    trigger OnOpenPage()
    begin
        Interval := 3600; //UUR
        MaxCalculations := 1000;
        TimeZoneOffset := 'W. Europe Standard Time';
    end;

    local procedure BuildDates()
    begin
        ClearResult();
        if TimestampTo = 0 then
            ConvertToDates(TimestampFrom)
        else begin
            if TimestampFrom = 0 then begin
                TimestampFrom := 1774652400; // 1780049130 do //1793185530 do
                TimestampTo := 1793185530;// do
            end;

            BuildDatesBuffer();
        end;
    end;

    local procedure BuildDatesBuffer()
    var
        CurrentTimeStamp: BigInteger;
        Counter: Integer;
    begin
        CurrentTimeStamp := TimestampFrom - Interval;
        while CurrentTimeStamp <= TimestampTo do begin
            CurrentTimeStamp += Interval;
            ConvertToDates(CurrentTimeStamp);
            Counter += 1;
            if Counter >= MaxCalculations then
                break;
        end;

        if Rec.FindFirst() then; //Pointer
    end;

    local procedure ClearResult()
    begin
        Rec.DeleteAll(false);
        Commit(); //Empty buffer
    end;

    local procedure ConvertToDates(Timestamp: BigInteger)
    var
        UnixTimeStampConvertor: Codeunit "Unix Timestamp Convertor TPTE";
    // TypeHelper: Codeunit "Type Helper";
    // NDT: DateTime;
    begin
        Rec.Init();
        Rec."Unix Timestamp" := Timestamp;
        UnixTimeStampConvertor.EvaluateUnixTimestampToGMTCustom(Rec."Unix Timestamp", false, Rec."GMT (Date)", Rec."GMT (Time)");
        Rec."Is Daylight Saving" := UnixTimeStampConvertor.IsDaylightSavingTime(Rec."GMT (Date)", Rec."GMT (Time)");

        // Rec.GMT := UnixTimeStampConvertor.EvaluateUnixTimestampToGMT(Rec."Unix Timestamp");
        // NDT := TypeHelper.ConvertDateTimeFromUTCToTimeZone(rec.GMT, 'UTC');
        // Rec."GMT (Text)" := format(rec.GMT, 0, 9);
        // Rec."GMT (Text)" := format(rec.GMT2, 0, 9);
        // Rec."My Time Zone" := UnixTimeStampConvertor.EvaluateUnixTimestampToTimeZone(Rec."Unix Timestamp");
        Rec."My Time Zone (Custom)" := CreateDateTime(Rec."GMT (Date)", Rec."GMT (Time)");

        // Rec."My Time Zone (Old)" := UnixTimeStampConvertor.EvaluateUnixTimestampToTimeZoneOld(Rec."Unix Timestamp");
        // Rec."My Time Zone (Conv)" := UnixTimeStampConvertor.EvaluateUnixTimestamp(Rec."Unix Timestamp", OffsetDuration); //Guido(Rec."My Time Zone");        

        Rec.Insert(false);
    end;

    local procedure Guido(Input: DateTime) output: DateTime
    var
        ConvertDateTimeMethCBLC: Codeunit "Convert DateTime Meth CBLC";
    begin
        ConvertDateTimeMethCBLC.ConvertDateTime(Input, output);
    end;
}