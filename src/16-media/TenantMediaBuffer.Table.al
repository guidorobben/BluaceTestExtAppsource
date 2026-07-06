table 83850 "Tenant Media Buffer TPTE"
{
    Caption = 'Tenant Media';
    DataPerCompany = false;
    Scope = Cloud;

    fields
    {
        field(1; ID; Guid)
        {
            Caption = 'ID';
        }
        field(2; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(3; Content; Blob)
        {
            Caption = 'Content';
            Subtype = Bitmap;
        }
        field(4; "Mime Type"; Text[100])
        {
            Caption = 'Mime Type';
        }
        field(5; Height; Integer)
        {
            Caption = 'Height';
        }
        field(6; Width; Integer)
        {
            Caption = 'Width';
        }
        field(7; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
            TableRelation = System.Environment.Company.Name;
        }
        field(8; "Expiration Date"; DateTime)
        {
            Caption = 'Expiration Date';
        }
        field(10; "Prohibit Cache"; Boolean)
        {
            Caption = 'Prohibit Cache';
        }
        field(11; "File Name"; Text[250])
        {
            Caption = 'File Name';
        }
        field(12; "Security Token"; Text[100])
        {
            Caption = 'Security Token';
        }
        field(13; "Creating User"; Text[50])
        {
            Caption = 'Creating User';
        }
        field(50000; "Where Used"; Text[100])
        {
            Caption = 'Where Used';
        }
    }

    keys
    {
        key(Key1; ID)
        {
            Clustered = true;
        }
        key(Key2; "Security Token") { }
        key(Key3; "Company Name") { }
    }
}