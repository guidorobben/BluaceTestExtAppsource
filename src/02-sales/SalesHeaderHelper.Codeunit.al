codeunit 83861 "Sales Header Helper TPTE"
{
    Permissions =
        tabledata "Sales Header" = RMD,
        tabledata "Sales Line" = R;

    procedure UblockForPlanning(var SalesHeader: Record "Sales Header")
    begin
#pragma warning disable PC0037
        SalesHeader."Blocked for Planning CBLC" := false;
#pragma warning restore PC0037
        SalesHeader.Modify(true);
    end;

    procedure DeleteSelected(var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        SalesLineHelperTPTE: Codeunit "Sales Line Helper TPTE";
    begin
        if SalesHeader.FindSet() then
            repeat
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetRange("Service CBLC", true);
                if SalesLine.FindSet() then
                    repeat
                        SalesLineHelperTPTE.ClearSalesPlanLine(SalesLine);
                    until SalesLine.Next() = 0;

                if not SalesHeader.Delete(true) then; //IGNORE
                Commit(); //Save progress
            until SalesHeader.Next() = 0;
    end;
}
