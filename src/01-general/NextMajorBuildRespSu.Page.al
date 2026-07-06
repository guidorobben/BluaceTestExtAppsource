page 83923 "Next Major Build Resp. Su TPTE"
{
    ApplicationArea = All;
    Caption = 'Next Major Build Resp. Su';
    PageType = CardPart;
    SourceTable = "Next Major Build Response TPTE";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field(Response; Rec.Response)
                {
                    MultiLine = true;
                }
                field("Error Text"; Rec."Error Text")
                {
                    MultiLine = true;
                }

            }
        }
    }
}
