page 83900 "JSON Buffer TPTE"
{
    ApplicationArea = All;
    Caption = 'JSON Buffer', Locked = true;
    PageType = List;
    SourceTable = "JSON Buffer";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Locked = true;
                }
                field(Path; Rec.Path)
                {
                    ToolTip = 'Specifies the value of the Path field.', Locked = true;
                }
                field(Depth; Rec.Depth)
                {
                    ToolTip = 'Specifies the value of the Depth field.', Locked = true;
                }
                field("Token type"; Rec."Token type")
                {
                    ToolTip = 'Specifies the value of the Token type field.', Locked = true;
                }
                field(Value; Rec."Value")
                {
                    ToolTip = 'Specifies the value of the Value field.', Locked = true;
                }
                // field("Value BLOB"; Rec."Value BLOB")
                // {
                //     ToolTip = 'Specifies the value of the Value BLOB field.', Locked=true;
                // }
                field("Value Type"; Rec."Value Type")
                {
                    ToolTip = 'Specifies the value of the Value Type field.', Locked = true;
                }
            }
        }
    }
}
