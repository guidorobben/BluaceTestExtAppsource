page 83906 "Standard Dialog TPTE"
{
    ApplicationArea = All;
    Caption = 'Standard Dialog';
    PageType = StandardDialog;

    layout
    {
        area(Content)
        {
            field(PostCode; PostCode)
            {
                Caption = 'Post Code';
                ToolTip = 'Specifies what postcode to test.';
            }
        }
    }

    var
        PostCode: Text[20];

    procedure GetPostCode(): Text[20]
    begin
        exit(PostCode);
    end;
}

