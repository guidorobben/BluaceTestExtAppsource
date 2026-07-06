table 83855 "Unix Timestamp convertor TPTE"
{
    Caption = 'Unix Timestamp Convertor';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Unix Timestamp"; BigInteger)
        {
            Caption = 'Unix Timestamp';
        }
        field(10; "GMT (Date)"; Date)
        {
            Caption = 'GMT (Date)';
        }
        field(12; "GMT (Time)"; Time)
        {
            Caption = 'GMT (Time)';
        }

        field(11; GMT2; DateTime)
        {
            Caption = 'GMT (Custom)';
        }
        field(20; "My Time Zone"; DateTime)
        {
            Caption = 'My Time Zone (MS)';
        }
        field(30; "My Time Zone (Old)"; Date)
        {
            Caption = '2BA';
        }
        field(40; "My Time Zone (Conv)"; DateTime)
        {
            Caption = 'GMT (incl offset)';
        }
        field(50; "My Time Zone (Custom)"; DateTime)
        {
            Caption = 'My Timie Zone (Custom) ';
        }
        field(60; "Is Daylight Saving"; Boolean)
        {
            Caption = 'Is Daylight Saving';
        }
    }

    keys
    {
        key(PK; "Unix Timestamp")
        {
            Clustered = true;
        }
    }
}