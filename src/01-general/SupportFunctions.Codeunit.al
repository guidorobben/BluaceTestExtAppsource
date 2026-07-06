codeunit 83881 "Support Functions TPTE"
{
    Permissions =
        tabledata "Sales Header" = R,
        tabledata "Test Ext. Setup TPTE" = R;

    procedure OpenLastSalesOrder()
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        OpenSalesDocument(SalesHeader);
    end;

    procedure OpenLastSalesOrderWithFilter()
    var
        SalesHeader: Record "Sales Header";
        TestExtSetup: Record "Test Ext. Setup TPTE";
    begin
        TestExtSetup.SetLoadFields("Last Sales Order Filter");
        if TestExtSetup.Get() then
            if TestExtSetup."Last Sales Order Filter" <> '' then
                SalesHeader.SetFilter("No.", TestExtSetup."Last Sales Order Filter");

        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        OpenSalesDocument(SalesHeader);
    end;

    procedure GetLastSalesOrder(var SalesHeader: Record "Sales Header")
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.FindLast();
    end;

    procedure OpenLastSalesInvoice()
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
        OpenSalesDocument(SalesHeader);
    end;

    procedure OpenLastSalesCreditMemo()
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Credit Memo");
        OpenSalesDocument(SalesHeader);
    end;

    procedure OpenSalesDocument(var SalesHeader: Record "Sales Header")
    var
        PageManagement: Codeunit "Page Management";
    begin
        if SalesHeader.FindLast() then; //Focus
        PageManagement.PageRun(SalesHeader);
    end;

}