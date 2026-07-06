pageextension 83937 "Posted Sales Invoice Sub TPTE" extends "Posted Sales Invoice Subform"
{
    layout
    {
        modify("Contract Reference Date CBLC")
        {
            Visible = true;
        }
        modify("Vendor No. CBLC")
        {
            Visible = true;
        }
    }

    actions
    {
        addlast(processing)
        {
            group(TestExt)
            {
                Caption = 'Test Ext.';
                Image = TestDatabase;

                action(ItemCardTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Item Card';
                    Image = Item;
                    RunObject = page "Item Card";
                    RunPageLink = "No." = field("No.");
                }
                action(ObjectCardTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Object Card';
                    Image = Bank;
                    RunObject = page "Object Card CBLC";
                    RunPageLink = "No." = field("Object No. CBLC");
                }
                action(ContractCardTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Contract Card';
                    Image = ContractPayment;
                    RunObject = page "Contract Card CBLC";
                    RunPageLink = "No." = field("Contract No. CBLC");
                }
            }
        }
    }
}
