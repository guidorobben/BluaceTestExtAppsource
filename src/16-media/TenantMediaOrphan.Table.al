table 83851 "Tenant Media Orphan TPTE"
{
    Caption = 'Tenant Media Orphan';
    Scope = Cloud;

    fields
    {
        field(1; MediaID; Guid)
        {
            Caption = 'ID';
            DataClassification = CustomerContent;
            TableRelation = "Tenant Media";
            ToolTip = 'Specifies the value of the ID field.';
        }
        field(2; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Description field.';
        }
        field(3; Content; Blob)
        {
            Caption = 'Content';
            DataClassification = CustomerContent;
            Subtype = Bitmap;
        }
        field(4; "Mime Type"; Text[100])
        {
            Caption = 'Mime Type';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Mime Type field.';
        }
        field(5; Height; Integer)
        {
            Caption = 'Height';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Height field.';
        }
        field(6; Width; Integer)
        {
            Caption = 'Width';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Width field.';
        }
        field(7; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
            DataClassification = CustomerContent;
            TableRelation = Company.Name;
            ToolTip = 'Specifies the value of the Company Name field.';
        }
        field(8; "Expiration Date"; DateTime)
        {
            Caption = 'Expiration Date';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Expiration Date field.';
        }
        field(10; "Prohibit Cache"; Boolean)
        {
            Caption = 'Prohibit Cache';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Prohibit Cache field.';
        }
        field(11; "File Name"; Text[250])
        {
            Caption = 'File Name';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the File Name field.';
        }
        field(12; "Security Token"; Text[100])
        {
            Caption = 'Security Token';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Security Token field.';
        }
        field(13; "Creating User"; Text[50])
        {
            Caption = 'Creating User';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Creating User field.';
        }
        field(100; Select; Boolean)
        {
            Caption = 'Select';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies whether the record is selected for deletion.';
        }
        field(101; Length; Integer)
        {
            Caption = 'Length';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the length field.';
        }
    }

    keys
    {
        key(Key1; MediaID)
        {
            Clustered = true;
        }
    }

}