pageextension 83932 "Sales Order TPTE" extends "Sales Order"
{
    layout
    {
        modify("Blocked for Planning CBLC")
        {
            Importance = Standard;
        }
        modify("Blocked for Invoicing CBLC")
        {
            Importance = Standard;
        }
        modify("Document Date")
        {
            Importance = Standard;
        }
        modify("Posting Description")
        {
            Visible = true;
        }
        modify("Transaction Type")
        {
            Visible = true;
        }
        modify("Shipment Date")
        {
            Visible = true;
        }

        addafter("Due Date")
        {
            field("Shipment Date TPTE"; Rec."Shipment Date")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addlast("O&rder")
        {
            action(ArchivesTPTE)
            {
                ApplicationArea = All;
                Caption = 'Archives';
                Image = Archive;
                RunObject = page "Sales Order Archives";
                RunPageLink = "Document Type" = field("Document Type"), "No." = field("No.");
                ToolTip = 'Show Archives.';
            }
        }
        addlast("F&unctions")
        {
            action(UnblockTPTE)
            {
                ApplicationArea = All;
                Caption = 'Unblock (Test Ext.)';

                trigger OnAction()
                begin
                    SalesHeaderHelperTPTE.UblockForPlanning(Rec);
                end;
            }
        }

        addlast(Category_Category8)
        {
            actionref(ArchivesTPTE_Promoted; ArchivesTPTE) { }
        }

        addlast(BlockUnblock_Promoted_CBLC)
        {
            actionref(UnblockTPTE_Promoted; UnblockTPTE) { }
        }
    }

    var
        SalesHeaderHelperTPTE: Codeunit "Sales Header Helper TPTE";
}
