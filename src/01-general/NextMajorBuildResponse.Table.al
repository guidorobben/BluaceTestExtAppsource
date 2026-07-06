table 83907 "Next Major Build Response TPTE"
{
    Caption = 'Next Major Build Response';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Next Major Build Response TPTE";
    LookupPageId = "Next Major Build Response TPTE";

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
            ToolTip = 'Specifies the value of the Code field.';
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the value of the Description field.';
        }
        field(20; "App Id"; Text[100])
        {
            Caption = 'App Id';
            ToolTip = 'Specifies the value of the App Id field.';
        }
        field(30; Passed; Text[100])
        {
            Caption = 'Passed';
            ToolTip = 'Specifies the value of the Passed field.';
        }
        field(40; Failed; Text[100])
        {
            Caption = 'Failed';
            ToolTip = 'Specifies the value of the Failed field.';
        }
        field(50; "Error Text"; Text[1024])
        {
            Caption = 'Error Text';
            ToolTip = 'Specifies the value of the Error Text field.';
        }
        field(60; Response; Text[1024])
        {
            Caption = 'Response';
            ToolTip = 'Specifies the value of the Response field.';
        }
        field(70; "Last Date/Time"; DateTime)
        {
            Caption = 'Last Date/Time';
            ToolTip = 'Specifies the value of the Last Date field.';
        }
        field(80; "Target Release"; Text[30])
        {
            Caption = 'Target Release';
            ToolTip = 'Specifies the value of the Target Release field.';
        }
        field(90; "Validation Date/Time"; Text[30])
        {
            Caption = 'Validation Date/Time';
            ToolTip = 'Specifies the value of the Validation Date/Time field.';
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}
