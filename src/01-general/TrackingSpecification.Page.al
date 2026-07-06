page 83868 "Tracking Specification TPTE"
{
    ApplicationArea = All;
    Caption = 'Tracking Specification';
    PageType = List;
    SourceTable = "Tracking Specification";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.") { }
                field("Item No."; Rec."Item No.") { }
                field("Source Type"; Rec."Source Type") { }
                field("Source Subtype"; Rec."Source Subtype") { }
                field("Source ID"; Rec."Source ID") { }
                field("Source Ref. No."; Rec."Source Ref. No.") { }
                field("Serial No."; Rec."Serial No.") { }
                field("Qty. Rounding Precision (Base)"; Rec."Qty. Rounding Precision (Base)") { }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure") { }
                field("Qty. to Handle"; Rec."Qty. to Handle") { }
                field("Qty. to Handle (Base)"; Rec."Qty. to Handle (Base)") { }
                field("Qty. to Invoice"; Rec."Qty. to Invoice") { }
                field("Qty. to Invoice (Base)"; Rec."Qty. to Invoice (Base)") { }
                field("Quantity (Base)"; Rec."Quantity (Base)") { }
                field("Quantity Handled (Base)"; Rec."Quantity Handled (Base)") { }
                field("Quantity Invoiced (Base)"; Rec."Quantity Invoiced (Base)") { }
                field("Quantity actual Handled (Base)"; Rec."Quantity actual Handled (Base)") { }
                field("Source Batch Name"; Rec."Source Batch Name") { }
                field("Source Prod. Order Line"; Rec."Source Prod. Order Line") { }
                field("Appl.-from Item Entry"; Rec."Appl.-from Item Entry") { }
                field("Appl.-to Item Entry"; Rec."Appl.-to Item Entry") { }
                field("Bin Code"; Rec."Bin Code") { }
                field("Buffer Status"; Rec."Buffer Status") { }
                field("Buffer Status2"; Rec."Buffer Status2") { }
                field("Buffer Value1"; Rec."Buffer Value1") { }
                field("Buffer Value2"; Rec."Buffer Value2") { }
                field("Buffer Value3"; Rec."Buffer Value3") { }
                field("Buffer Value4"; Rec."Buffer Value4") { }
                field("Buffer Value5"; Rec."Buffer Value5") { }
                field(Correction; Rec.Correction) { }
                field("Creation Date"; Rec."Creation Date") { }
                field(Description; Rec.Description) { }
                field("Expiration Date"; Rec."Expiration Date") { }
                field("Item Ledger Entry No."; Rec."Item Ledger Entry No.") { }
                field("Location Code"; Rec."Location Code") { }
                field("Lot No."; Rec."Lot No.") { }
                field("New Expiration Date"; Rec."New Expiration Date") { }
                field("New Lot No."; Rec."New Lot No.") { }
                field("New Package No."; Rec."New Package No.") { }
                field("New Serial No."; Rec."New Serial No.") { }
                field("Package No."; Rec."Package No.") { }
                field(Positive; Rec.Positive) { }
                field("Prohibit Cancellation"; Rec."Prohibit Cancellation") { }
                field("Transfer Item Entry No."; Rec."Transfer Item Entry No.") { }
                field("Variant Code"; Rec."Variant Code") { }
                field("Warranty Date"; Rec."Warranty Date") { }
            }
        }
    }
}