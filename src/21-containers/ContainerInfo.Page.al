page 83952 "Container Info TPTE"
{
    ApplicationArea = All;
    Caption = 'Container Info';
    PageType = CardPart;
    SourceTable = "Container CBLC";

    layout
    {
        area(Content)
        {
            group(General)
            {
                ShowCaption = false;

                group(Container)
                {
                    Caption = 'Container';

                    field("Container Item No."; Rec."Container Item No.") { }
                    field("Container Serial No."; Rec."Container Serial No.") { }
                    field("Container Item Category Code"; Rec."Container Item Category Code") { }
                    field("Location Code"; Rec."Location Code") { }
                    field("Empty Weight"; Rec."Empty Weight") { }
                }
                group(ContentInfo)
                {
                    Caption = 'Content';

                    field("Content Item No."; Rec."Content Item No.") { }
                    field("Content Item Category Code"; Rec."Content Item Category Code") { }
                    field("Content Quantity"; Rec."Content Quantity") { }
                }
            }
        }
    }
}