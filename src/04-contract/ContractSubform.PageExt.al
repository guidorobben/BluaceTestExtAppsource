pageextension 83919 "Contract Subform TPTE" extends "Contract Subform CBLC"
{
    actions
    {
        addlast(Processing)
        {
            group(TestGroupTPTE)
            {
                Caption = 'Test Ext.';

                action(ItemCardTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Item Card';
                    Image = Item;
                    RunObject = page "Item Card";
                    RunPageLink = "No." = field("Price Item No.");
                }
                action(ObjectCardTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Object Card';
                    Image = Company;
                    RunObject = page "Object Card CBLC";
                    RunPageLink = "No." = field("Object No.");
                }
            }
        }
    }
}