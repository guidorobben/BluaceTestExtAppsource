codeunit 83867 "Object Maint. Sched. Hlp. TPTE"
{
    Permissions =
        tabledata "Object Maint. Schedule CBLC" = R,
        tabledata "Object CBLC" = R,
        tabledata "Sales Header" = RD;

    procedure ShowSalesOrder(ObjectMaintScheduleCBLC: Record "Object Maint. Schedule CBLC")
    var
        SalesHeader: Record "Sales Header";
        PageManagement: Codeunit "Page Management";
    begin
        if SalesHeader.Get(SalesHeader."Document Type"::Order, ObjectMaintScheduleCBLC."Sales Order No.") then
            PageManagement.PageRun(SalesHeader);
    end;

    procedure DeleteSalesOrder(ObjectMaintScheduleCBLC: Record "Object Maint. Schedule CBLC")
    var
        SalesHeader: Record "Sales Header";
    begin
        if SalesHeader.Get(SalesHeader."Document Type"::Order, ObjectMaintScheduleCBLC."Sales Order No.") then
            SalesHeader.Delete(true);
    end;

    procedure GetNextObjectMaintenanceSchedule(ObjectMaintScheduleCBLC: Record "Object Maint. Schedule CBLC")
    var
        NextObjectMaintSchedule: Record "Object Maint. Schedule CBLC";
        ObjectCBLC: Record "Object CBLC";
        LibraryObjectLIB: Codeunit "Library - Object LIB";
    begin
        ObjectCBLC.Get(ObjectMaintScheduleCBLC."Object No.");
        LibraryObjectLIB.GetNextObjectMaintenanceSchedule(ObjectCBLC, NextObjectMaintSchedule);
        // Object.GetNextObjectMaintenanceSchedule(NextObjectMaintSchedule);
        Message('%1', NextObjectMaintSchedule."Entry No.");
    end;

    procedure CreateSalesOrderLine(ObjectMaintScheduleCBLC: Record "Object Maint. Schedule CBLC")
    var
        ObjectCBLC: Record "Object CBLC";
        LibraryObjectLIB: Codeunit "Library - Object LIB";
    begin
        ObjectCBLC.Get(ObjectMaintScheduleCBLC."Object No.");
        ObjectCBLC.SetRecFilter();
        LibraryObjectLIB.CreateSalesOrderLine(ObjectCBLC, Today());
    end;
}