page 83907 "Geo. Skill Post Code TPTE"
{
    ApplicationArea = All;
    Caption = 'Postcodes';
    PageType = ListPart;
    SourceTable = "Geo. Skill Post Code YBLC";

    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("Post Code From"; Rec."Post Code From") { }
                field("Post Code To"; Rec."Post Code To") { }
            }
        }
    }
}
