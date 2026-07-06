page 83927 "CSV Buffer TPTE"
{
    ApplicationArea = All;
    Caption = 'CSV Buffer';
    PageType = List;
    SourceTable = "CSV Buffer";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("Field No."; Rec."Field No.")
                {
                    ToolTip = 'Specifies the value of the Field No. field.';
                }
                field(Value; Rec."Value")
                {
                    ToolTip = 'Specifies the value of the Value field.';
                }
            }
        }
    }
}
