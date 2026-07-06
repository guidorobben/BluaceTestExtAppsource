page 83857 "Info Dialog TPTE"
{
    AnalysisModeEnabled = false;
    ApplicationArea = All;
    Caption = 'Info';
    Editable = false;
    PageType = List;
    SourceTable = "Info Dialog TPTE";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    Visible = false;
                }
                field(Name; Rec.Name)
                {
                    Style = Strong;
                    StyleExpr = Rec.Header;
                }
                field(Value; Rec."Value")
                {
                    trigger OnAssistEdit()
                    begin
                        Rec.ActivateEventCode();
                    end;
                }
                field("Event Code"; Rec."Event Code")
                {
                    trigger OnDrillDown()
                    begin
                        Rec.ActivateEventCode();
                    end;
                }
                field(Header; Rec.Header)
                {
                    Visible = false;
                }
            }
        }
    }
}