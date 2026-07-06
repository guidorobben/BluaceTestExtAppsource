codeunit 83862 "Sales Plan. Line Helper TPTE"
{
    Permissions =
        tabledata "Sales Plan. Line CBLC" = RM;

    var
        LibraryRandomLIB: Codeunit "Library - Random LIB";

    procedure UnblockForPlanning(var SalesPlanLineCBLC: Record "Sales Plan. Line CBLC")
    begin
        SalesPlanLineCBLC."Blocked for Planning" := false;
        SalesPlanLineCBLC.Modify(true);
    end;

    procedure AddResource(var SalesPlanLineCBLC: Record "Sales Plan. Line CBLC")
    var
        ResourceNo: Code[20];
    begin
        if SalesPlanLineCBLC."Resource Group No." = '' then
            exit;

        ResourceNo := LibraryRandomLIB.FindResourceRandom(SalesPlanLineCBLC."Resource Group No.");
        if ResourceNo <> '' then begin
            SalesPlanLineCBLC.Validate("Resource No.", ResourceNo);
            SalesPlanLineCBLC.Modify(true);
        end;
    end;

    procedure AddResourceAndStartTime(var SalesPlanLineCBLC: Record "Sales Plan. Line CBLC")
    var
        StartDateTime: DateTime;
    begin
        if SalesPlanLineCBLC."Resource Group No." = '' then
            exit;

        AddResource(SalesPlanLineCBLC);

        StartDateTime := CreateDateTime(Today(), 090000T);
        SalesPlanLineCBLC.Validate("Starting Date Time", StartDateTime);
        SalesPlanLineCBLC.Modify(true);
    end;

    procedure StartingDateMinusOneDay(var SalesPlanLineCBLC: Record "Sales Plan. Line CBLC")
    var
        TypeHelper: Codeunit "Type Helper TPTE";
        NewStartingDateTime: DateTime;
    begin
        NewStartingDateTime := TypeHelper.CalcDateTime('<-1D>', SalesPlanLineCBLC."Starting Date Time");
        SalesPlanLineCBLC.Validate("Starting Date Time", NewStartingDateTime);
        SalesPlanLineCBLC.Modify(true);
    end;

    procedure AddStartDateTime(var SalesPlanLineCBLC: Record "Sales Plan. Line CBLC")
    var
        StartDateTime: DateTime;
    begin
        if SalesPlanLineCBLC."Resource Group No." = '' then
            exit;

        StartDateTime := CreateDateTime(Today(), 090000T);
        SalesPlanLineCBLC.Validate("Starting Date Time", StartDateTime);
        SalesPlanLineCBLC.Modify(true);
    end;

    procedure CopyDateTimeFromMaintenance(var SalesPlanLineCBLC: Record "Sales Plan. Line CBLC")
    begin
        if SalesPlanLineCBLC."Resource Group No." = '' then
            exit;

        AddResource(SalesPlanLineCBLC);

        SalesPlanLineCBLC.Validate("Starting Date Time", SalesPlanLineCBLC."Schedule Starting Date Time");
        SalesPlanLineCBLC.Modify(true);
    end;

    procedure SetStatusToNew(var SalesPlanLineCBLC: Record "Sales Plan. Line CBLC")
    begin
        SetStatusTo(SalesPlanLineCBLC, SalesPlanLineCBLC.Status::New);
    end;

    procedure SetStatusToPlanned(var SalesPlanLineCBLC: Record "Sales Plan. Line CBLC")
    begin
        SetStatusTo(SalesPlanLineCBLC, SalesPlanLineCBLC.Status::Planned);
    end;

    procedure SetStatusToOnTheWay(var SalesPlanLineCBLC: Record "Sales Plan. Line CBLC")
    begin
        SetStatusTo(SalesPlanLineCBLC, SalesPlanLineCBLC.Status::"On The Way");
    end;

    procedure SetStatusToInProgress(var SalesPlanLineCBLC: Record "Sales Plan. Line CBLC")
    begin
        SetStatusTo(SalesPlanLineCBLC, SalesPlanLineCBLC.Status::"In Progress");
    end;

    procedure SetStatusToReady(var SalesPlanLineCBLC: Record "Sales Plan. Line CBLC")
    begin
        SetStatusTo(SalesPlanLineCBLC, SalesPlanLineCBLC.Status::Ready);
    end;

    procedure SetStatusTo(var SalesPlanLineCBLC: Record "Sales Plan. Line CBLC"; NewStatus: Enum "Sales Plan. Line Status CBLC")
    begin
        SalesPlanLineCBLC.Status := NewStatus;
        SalesPlanLineCBLC.Modify(false);
    end;
}