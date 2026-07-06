codeunit 83929 "UC Object TPTE"
{
    Permissions =
        tabledata "Object CBLC" = R;

    var
        PageManagement: Codeunit "Page Management";
        UTObjectMaintenance: Codeunit "UT Object Maintenance TPTE";
        UTObject: Codeunit "UT Object TPTE";

    procedure CreateObjectWithPriceAndContact()
    begin
        UTObject.CreateObjectWithPriceAndContact();
        OpenLastObject();
    end;

    procedure CreateObjectWithObjectMaintenanceScheduleLastRealisationDate()
    begin
        UTObjectMaintenance.CreateObjectWithObjectMaintenanceScheduleLastRealisationDate();
        OpenLastObject();
    end;

    procedure CreateObjectWithObjectMaintenanceScheduleStartingDate()
    begin
        UTObjectMaintenance.CreateObjectWithObjectMaintenanceScheduleStartingDate();
        OpenLastObject();
    end;

    local procedure OpenLastObject()
    var
        ObjectCBLC: Record "Object CBLC";
    begin
        if ObjectCBLC.FindLast() then
            PageManagement.PageRun(ObjectCBLC);
    end;
}