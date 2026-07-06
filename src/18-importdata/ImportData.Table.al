table 83901 "Import Data TPTE"
{
    Caption = 'Import Bluace Data';
    DataClassification = CustomerContent;
    Permissions =
        tabledata "Import Data TPTE" = RIM;

    fields
    {
        field(1; Section; Integer)
        {
            Caption = 'Section';
        }
        field(2; Category; Decimal)
        {
            Caption = 'Category';
            DecimalPlaces = 3 : 5;
        }
        field(10; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(11; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(12; Import; Boolean)
        {
            Caption = 'Import';
        }
        field(13; Value; Text[250])
        {
            Caption = 'Value';
        }
        field(20; Records; Integer)
        {
            Caption = 'Records';
        }
        field(30; Header; Boolean)
        {
            Caption = 'Header';
        }
        field(31; Show; Boolean)
        {
            Caption = 'Show';
        }
        field(40; "Table ID"; Integer)
        {
            Caption = 'Table ID';
        }
        field(41; "Parent Table ID"; Integer)
        {
            Caption = 'Parent Table ID';
        }
        field(50; Warning; Boolean)
        {
            Caption = 'Warning';
        }
    }

    keys
    {
        key(Key1BVE; Section, Category)
        {
            Clustered = true;
        }
    }

    procedure AddSection(SectionName: Integer; Cat: Decimal; SettingName: Text[50]; NewDescription: Text[50]; NewValue: Text[250]; NewShow: Boolean)
    var
        InsertRec: Boolean;
    begin
        if not Rec.Get(SectionName, Cat) then begin
            Rec.Init();
            InsertRec := true;
        end;

        Rec.Section := SectionName;
        Rec.Category := Cat;
        Rec.Name := SettingName;
        Rec.Description := NewDescription;
        Rec.Value := NewValue;
        Rec.Show := NewShow;

        if InsertRec then
            Rec.Insert(false)
        else
            Rec.Modify(false);
    end;
}