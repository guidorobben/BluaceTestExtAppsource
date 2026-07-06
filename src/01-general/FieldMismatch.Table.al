table 83856 "Field Mismatch TPTE"
{
    Caption = 'Field Mismatch';
    DataClassification = SystemMetadata;
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(10; "Field Id From"; Integer)
        {
            Caption = 'Field Id From';
        }
        field(20; "Field Name From"; Text[50])
        {
            Caption = 'Field Name From';
        }
        field(30; "Field Type From"; Option)
        {
            OptionCaption = 'TableFilter,RecordID,OemText,Date,Time,DateFormula,Decimal,Media,MediaSet,Text,Code,NotSupported_Binary,BLOB,Boolean,Integer,OemCode,Option,BigInteger,Duration,GUID,DateTime';
            OptionMembers = TableFilter,RecordID,OemText,Date,Time,DateFormula,Decimal,Media,MediaSet,Text,Code,Binary,BLOB,Boolean,Integer,OemCode,Option,BigInteger,Duration,GUID,DateTime;
            // This list must stay in sync with NCLOptionMetadataNavTypeField
            // OptionOrdinalValues = 4912, 4988, 11519, 11775, 11776, 11797, 12799, 26207, 26208, 31488, 31489, 33791, 33793, 34047, 34559, 35071, 35583, 36095, 36863, 37119, 37375;
        }
        field(40; "Field Type Name From"; Text[30])
        {
            Caption = 'Type Name From';
        }
        field(50; "Enabled From"; Boolean)
        {
            Caption = 'Enabled';
        }
        field(60; "ObsoleteState From"; Option)
        {
            Caption = 'ObsoleteState';
            OptionMembers = " ",Pending,Removed;
        }
        field(70; "App Package ID From"; Guid) { }
        field(80; "App Name From"; Text[250])
        {
            Caption = 'App Name';
        }
        field(90; "Publisher From"; Text[250])
        {
            Caption = 'Publisher From';
        }

        field(1010; "Field Id To"; Integer)
        {
            BlankZero = true;
            Caption = 'Field Id To';
        }
        field(1020; "Field Name To"; Text[50])
        {
            Caption = 'Field Name To';
        }
        field(1030; "Field Type To"; Option)
        {
            OptionCaption = 'TableFilter,RecordID,OemText,Date,Time,DateFormula,Decimal,Media,MediaSet,Text,Code,NotSupported_Binary,BLOB,Boolean,Integer,OemCode,Option,BigInteger,Duration,GUID,DateTime';
            OptionMembers = TableFilter,RecordID,OemText,Date,Time,DateFormula,Decimal,Media,MediaSet,Text,Code,Binary,BLOB,Boolean,Integer,OemCode,Option,BigInteger,Duration,GUID,DateTime;
            // This list must stay in sync with NCLOptionMetadataNavTypeField
            // OptionOrdinalValues = 4912, 4988, 11519, 11775, 11776, 11797, 12799, 26207, 26208, 31488, 31489, 33791, 33793, 34047, 34559, 35071, 35583, 36095, 36863, 37119, 37375;
        }
        field(1040; "Field Type Name To"; Text[30])
        {
            Caption = 'Type Name To';
        }
        field(1050; "Enabled To"; Boolean)
        {
            Caption = 'Enabled';
        }
        field(1060; "ObsoleteState To"; Option)
        {
            Caption = 'ObsoleteState';
            OptionMembers = " ",Pending,Removed;
        }
        field(1070; "App Package ID To"; Guid) { }
        field(1080; "App Name To"; Text[250])
        {
            Caption = 'App Name';
        }
        field(1090; "Publisher To"; Text[250])
        {
            Caption = 'Publisher To';
        }

        field(3000; Mismatch; Boolean)
        {
            Caption = 'Mismatch';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Mismatch; Mismatch) { }
    }
}