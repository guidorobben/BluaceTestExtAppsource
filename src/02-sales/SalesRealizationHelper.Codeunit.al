codeunit 83863 "Sales Realization Helper TPTE"
{
    Permissions =
        tabledata "Object CBLC" = R,
        tabledata "Resource Group" = R,
        tabledata "Sales Line" = R,
        tabledata "Sales Plan. Line CBLC" = RM,
        tabledata "Sales Realization CBLC" = RIM;

    var
        LibraryRandomTPTE: Codeunit "Library - Random";
        LibrarySalesLIB: Codeunit "Library - Sales LIB";

    procedure OpenObjectCard(var SalesRealizationCBLC: Record "Sales Realization CBLC")
    var
        ObjectCBLC: Record "Object CBLC";
        SalesLine: Record "Sales Line";
        PageManagement: Codeunit "Page Management";
    begin
        GetSalesLine(SalesLine, SalesRealizationCBLC);
        if ObjectCBLC.Get(SalesLine."Object No. CBLC") then begin
            ObjectCBLC.SetRecFilter();
            PageManagement.PageRun(ObjectCBLC);
        end;
    end;

    procedure CopyFromPlanning(var SalesLine: Record "Sales Line")
    var
        SalesRealizationCBLC: Record "Sales Realization CBLC";
    begin
        CreateSalesRealization(SalesLine, SalesRealizationCBLC);
    end;

    procedure CopyFromPlanning(var SalesRealizationCBLC: Record "Sales Realization CBLC")
    var
        SalesLine: Record "Sales Line";
    begin
        GetSalesLine(SalesLine, SalesRealizationCBLC);
        CreateSalesRealization(SalesLine, SalesRealizationCBLC);
    end;

    local procedure GetSalesLine(var SalesLine: Record "Sales Line"; var SalesRealizationCBLC: Record "Sales Realization CBLC")
    var
        DocumentNo: Code[20];
        DocumentLineNo: Integer;
    begin
        DocumentNo := SalesRealizationCBLC.GetFilter("Document No.");
        Evaluate(DocumentLineNo, SalesRealizationCBLC.GetFilter("Document Line No."));
        SalesLine.Get(SalesLine."Document Type"::Order, DocumentNo, DocumentLineNo);
    end;

    procedure CreateSalesRealization(var SalesLine: Record "Sales Line"; var SalesRealizationCBLC: Record "Sales Realization CBLC")
    var
        ResourceGroup: Record "Resource Group";
        SalesPlanLineCBLC: Record "Sales Plan. Line CBLC";
        LibrarySalesLIB: Codeunit "Library - Sales LIB";
        TypeHelper: Codeunit "Type Helper";
        ResourceGroupNo: Code[20];
        WorkEndingDateTime: DateTime;
    begin
        SalesPlanLineCBLC.SetRange("Document Type", SalesPlanLineCBLC."Document Type"::Order);
        SalesPlanLineCBLC.SetRange("Document No.", SalesLine."Document No.");
        SalesPlanLineCBLC.SetRange("Document Line No.", SalesLine."Line No.");
        SalesPlanLineCBLC.FindFirst();

        ResourceGroupNo := SalesPlanLineCBLC."Resource Group No.";
        ResourceGroup.Get(ResourceGroupNo);

        LibrarySalesLIB.InitSalesRealization(SalesLine, SalesRealizationCBLC, ResourceGroup);
        SalesRealizationCBLC.Insert(true);

        //KM
        //        SalesRealizationCBLC.Validate("Travel Distance (km)", LibraryRandom.RandDecInDecimalRange(5, 30, 0));

        //Work
        if SalesRealizationCBLC."Work Starting Date Time" <> 0DT then begin
            SalesRealizationCBLC.Validate("Work Starting Date Time", SalesPlanLineCBLC."Starting Date Time");
            SalesRealizationCBLC.Validate("Work Ending Date Time", SalesPlanLineCBLC."Ending Date Time");
        end else begin
            if SalesPlanLineCBLC."Schedule Starting Date Time" <> 0DT then
                SalesRealizationCBLC.Validate("Work Starting Date Time", SalesPlanLineCBLC."Schedule Starting Date Time")
            else
                SalesRealizationCBLC.Validate("Work Starting Date Time", SalesPlanLineCBLC."Starting Date Time");
            WorkEndingDateTime := TypeHelper.AddHoursToDateTime(SalesRealizationCBLC."Work Starting Date Time", 1);
            SalesRealizationCBLC.Validate("Work Ending Date Time", WorkEndingDateTime);
        end;

        SalesRealizationCBLC.Modify(true);
    end;

    procedure UpdateRealizationWithTravelTPTE(var SalesRealizationCBLC: Record "Sales Realization CBLC")
    var
        EndDateTime, StartDateTime : DateTime;
    begin
        CopyFromPlanning(SalesRealizationCBLC);
        StartDateTime := CreateDateTime(Today(), 060000T);
        EndDateTime := CreateDateTime(Today(), 080000T);

        SalesRealizationCBLC.Validate("Travel Starting Date Time", StartDateTime);
        SalesRealizationCBLC.Validate("Travel Ending Date Time", EndDateTime);
        SalesRealizationCBLC.Validate("Travel Distance (km)", LibraryRandomTPTE.RandDecInDecimalRange(5, 30, 0));

        StartDateTime := CreateDateTime(Today(), 100000T);
        EndDateTime := CreateDateTime(Today(), 130000T);
        SalesRealizationCBLC.Validate("Work Starting Date Time", StartDateTime);
        SalesRealizationCBLC.Validate("Work Ending Date Time", EndDateTime);

        SalesRealizationCBLC.Modify(true);
    end;

    procedure StartingDateMinusOneDayTPTE(var SalesRealizationCBLC: Record "Sales Realization CBLC")
    var
        TypeHelper: Codeunit "Type Helper TPTE";
        NewWorkDateTime: DateTime;
    begin
        NewWorkDateTime := TypeHelper.CalcDateTime('<-1D>', SalesRealizationCBLC."Work Starting Date Time");
        SalesRealizationCBLC.Validate("Work Starting Date Time", NewWorkDateTime);

        NewWorkDateTime := TypeHelper.CalcDateTime('<-1D>', SalesRealizationCBLC."Work Ending Date Time");
        SalesRealizationCBLC.Validate("Work Ending Date Time", NewWorkDateTime);

        SalesRealizationCBLC.Modify(true);
    end;
}