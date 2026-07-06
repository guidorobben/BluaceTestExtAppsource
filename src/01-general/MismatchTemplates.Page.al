page 83871 "Mismatch Templates TPTE"
{
    ApplicationArea = All;
    Caption = 'Mismatch Templates';
    PageType = List;
    SourceTable = "Mismatch Template TPTE";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Table ID From"; Rec."Table ID From") { }
                field("Table ID To"; Rec."Table ID To") { }
                field("Table Name From"; Rec."Table Name From") { }
                field("Table Name To"; Rec."Table Name To") { }
            }
        }
    }
}