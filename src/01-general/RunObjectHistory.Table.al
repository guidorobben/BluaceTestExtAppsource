table 83902 "Run Object History TPTE"
{
    Caption = 'Run Object History';
    Permissions =;

    fields
    {
        field(1; "User ID"; Code[50])
        {
            AllowInCustomizations = AsReadWrite;
            Caption = 'User ID';
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(2; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Table Data,Table,Form,Report,Dataport,Codeunit,XMLport,MenuSuite,Page,Query,System,Fieldnumber';
            OptionMembers = TableData,"Table",Form,"Report",Dataport,"Codeunit","XMLport",MenuSuite,"Page","Query",System,FieldNumber;
        }
        field(3; ID; Integer)
        {
            Caption = 'ID';
        }
        field(10; "Object Caption"; Text[249])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = field(Type), "Object ID" = field(ID)));
            Caption = 'Caption';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Last Run"; Date)
        {
            Caption = 'Last Run';
        }
    }

    keys
    {
        key(PK; "User ID", Type, ID)
        {
            Clustered = true;
        }
        key(LastRun; "Last Run") { }
    }
}