page 83867 "Reservation Entry TPTE"
{
    ApplicationArea = All;
    Caption = 'Reservation Entry';
    PageType = List;
    SourceTable = "Reservation Entry";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.") { }
                field("Source Batch Name"; Rec."Source Batch Name") { }
                field("Source Type"; Rec."Source Type") { }
                field("Source Subtype"; Rec."Source Subtype") { }
                field("Source Ref. No."; Rec."Source Ref. No.") { }
                field("Source ID"; Rec."Source ID") { }
                field("Source Prod. Order Line"; Rec."Source Prod. Order Line") { }
                field("Item No."; Rec."Item No.") { }
                field(Description; Rec.Description) { }
                field("Item Tracking"; Rec."Item Tracking") { }
                field("Serial No."; Rec."Serial No.") { }
                field("Action Message Adjustment"; Rec."Action Message Adjustment") { }
                field("Appl.-from Item Entry"; Rec."Appl.-from Item Entry") { }
                field("Appl.-to Item Entry"; Rec."Appl.-to Item Entry") { }
                field(Binding; Rec.Binding) { }
                field(Correction; Rec.Correction) { }
                field("Creation Date"; Rec."Creation Date") { }
                field("Disallow Cancellation"; Rec."Disallow Cancellation") { }
                field("Expected Receipt Date"; Rec."Expected Receipt Date") { }
                field("Expiration Date"; Rec."Expiration Date") { }
                field("Item Ledger Entry No."; Rec."Item Ledger Entry No.") { }
                field("Location Code"; Rec."Location Code") { }
                field("Lot No."; Rec."Lot No.") { }
                field("New Expiration Date"; Rec."New Expiration Date") { }
                field("New Lot No."; Rec."New Lot No.") { }
                field("New Package No."; Rec."New Package No.") { }
                field("New Serial No."; Rec."New Serial No.") { }
                field("Package No."; Rec."Package No.") { }
                field("Planning Flexibility"; Rec."Planning Flexibility") { }
                field(Positive; Rec.Positive) { }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure") { }
                field("Qty. to Handle (Base)"; Rec."Qty. to Handle (Base)") { }
                field("Qty. to Invoice (Base)"; Rec."Qty. to Invoice (Base)") { }
                field(Quantity; Rec.Quantity) { }
                field("Quantity (Base)"; Rec."Quantity (Base)") { }
                field("Quantity Invoiced (Base)"; Rec."Quantity Invoiced (Base)") { }
                field("Reservation Status"; Rec."Reservation Status") { }
                field("Shipment Date"; Rec."Shipment Date") { }
                field("Suppressed Action Msg."; Rec."Suppressed Action Msg.") { }
                field(SystemCreatedAt; Rec.SystemCreatedAt) { }
                field(SystemCreatedBy; Rec.SystemCreatedBy) { }
                field(SystemId; Rec.SystemId) { }
                field(SystemModifiedAt; Rec.SystemModifiedAt) { }
                field(SystemModifiedBy; Rec.SystemModifiedBy) { }
                field("Transferred from Entry No."; Rec."Transferred from Entry No.") { }
                field("Untracked Surplus"; Rec."Untracked Surplus") { }
                field("Variant Code"; Rec."Variant Code") { }
                field("Warranty Date"; Rec."Warranty Date") { }
            }
        }
    }
}