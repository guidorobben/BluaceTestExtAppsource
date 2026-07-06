codeunit 83874 "Sales Line Helper TPTE"
{
    Permissions =
        tabledata "Sales Line" = R,
        tabledata "Sales Plan. Line CBLC" = RM;

    var
        LibrarySalesLIB: Codeunit "Library - Sales LIB";

    procedure CreateSalesPlanning(var SalesLine: Record "Sales Line")
    var
        SalesPlanLineCBLC: Record "Sales Plan. Line CBLC";
        SalesPlanLineHelper: Codeunit "Sales Plan. Line Helper TPTE";
    begin
        SalesPlanLineCBLC.SetRange("Document Type", SalesLine."Document Type");
        SalesPlanLineCBLC.SetRange("Document No.", SalesLine."Document No.");
        SalesPlanLineCBLC.SetRange("Document Line No.", SalesLine."Line No.");
        SalesPlanLineCBLC.FindFirst();
        SalesPlanLineHelper.AddResourceAndStartTime(SalesPlanLineCBLC);
    end;

    procedure ClearSalesPlanLines(var SalesLine: Record "Sales Line")
    begin

    end;

    procedure ClearSalesPlanLine(var SalesLine: Record "Sales Line")
    var
        SalesPlanLineCBLC: Record "Sales Plan. Line CBLC";
    begin
        if not LibrarySalesLIB.GetSalesPlanLine(SalesPlanLineCBLC, SalesLine) then
            exit;

        if SalesPlanLineCBLC."Starting Date Time" <> 0DT then begin
            SalesPlanLineCBLC.Validate("Starting Date Time", 0DT);
            SalesPlanLineCBLC.Validate("Ending Date Time", 0DT);
            SalesPlanLineCBLC.Modify(false);
        end;
    end;
}