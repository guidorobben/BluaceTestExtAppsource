pageextension 83946 "Item Card TPTE" extends "Item Card"
{
    layout
    {
        modify("Last Direct Cost")
        {
            Importance = Standard;
        }
        modify(GTIN)
        {
            Importance = Standard;
        }

        addlast(Item)
        {
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = Dimensions;
#pragma warning disable AC0017
                ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
#pragma warning restore AC0017
                // Visible = false;

                trigger OnValidate()
                begin
                    // RefreshPage();
                end;
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = Dimensions;
#pragma warning disable AC0017
                ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
#pragma warning restore AC0017
                // Visible = false;

                trigger OnValidate()
                begin
                    // RefreshPage();
                end;
            }
        }
    }
}
