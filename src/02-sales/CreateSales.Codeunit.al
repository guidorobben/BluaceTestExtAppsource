codeunit 83937 "Create Sales TPTE"
{
    procedure CreateSalesOrderWithLinePlanningRealization()
    var
        UTSalesOrder: Codeunit "UT Sales Order TPTE";
    begin
        UTSalesOrder.CreateSalesOrderWithLinePlanningRealization();
    end;

    procedure CreateSalesOrderWithLinesPlanningRealization()
    var
        UTSalesOrder: Codeunit "UT Sales Order TPTE";
    begin
        UTSalesOrder.CreateSalesOrderWithLinesPlanningRealization();
    end;

    procedure CreateSalesOrderWithLinePlanning()
    var
        UTSalesOrder: Codeunit "UT Sales Order TPTE";
    begin
        UTSalesOrder.CreateSalesOrderWithLinePlanning();
    end;
}