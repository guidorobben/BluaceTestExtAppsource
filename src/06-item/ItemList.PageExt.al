pageextension 83908 "Item List TPTE" extends "Item List"
{
    layout
    {
        modify("Item Category Code")
        {
            Visible = true;
        }
        addlast(Control1)
        {
            field("Global Dimension 1 Code TPTE"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = Dimensions;
                // Visible = false;
            }
            field("Global Dimension 2 Code TPTE"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = Dimensions;
                // Visible = false;
            }
        }
    }

    views
    {
        addlast
        {
            view(ServiceTPTE)
            {
                Caption = 'Service';
                Filters = where(Type = filter(Service));
                SharedLayout = true;
            }
        }
    }
}