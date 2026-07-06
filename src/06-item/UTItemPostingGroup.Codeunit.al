#pragma warning disable PC0030
codeunit 83932 "UT Item Posting Group TPTE"
{
    Permissions =
        tabledata Customer = R,
        tabledata Item = R,
        tabledata "Item Gen. Bus. Post Group CBLC" = RID,
        tabledata "Job Planning Line" = RM,
        tabledata "Job Task" = R,
        tabledata "Sales Line" = R;
    Subtype = Test;
    TestPermissions = Disabled;

    var
        JobPlanningLine: Record "Job Planning Line";
        SalesOrder: Record "Sales Header";
        Assert: Codeunit Assert;
        LibraryJob: Codeunit "Library - Job";
        LibraryRandomLIB: Codeunit "Library - Random LIB";
        LibrarySales: Codeunit "Library - Sales";
        LibrarySalesLIB: Codeunit "Library - Sales LIB";

    [Test]
    procedure ClearPostingGroups()
    var
        ItemGenBusPostGroupCBLC: Record "Item Gen. Bus. Post Group CBLC";
    begin
        ItemGenBusPostGroupCBLC.DeleteAll(true);
    end;

    [Test]
    procedure CreateNewSalesOrderWithLine()
    var
        Customer: Record Customer;
        Item: Record Item;
        SalesLine: Record "Sales Line";
    begin
        Customer.FindFirst();
        LibrarySalesLIB.CreateSalesOrderForCustomerNo(SalesOrder, Customer."No.");

        Item.Get('1002');
        LibrarySales.CreateSalesLine(SalesLine, SalesOrder, SalesLine.Type::Item, Item."No.", 1);
    end;

    [Test]
    procedure CreateNewJobPlanningLine()
    var
        JobTask: Record "Job Task";
        JobPlanningLineType: Enum "Job Planning Line Line Type";
        JobPlanningType: Enum "Job Planning Line Type";
    begin
        JobTask.Get('JOB00010', '1010');
        LibraryJob.CreateJobPlanningLine(JobPlanningLineType::Billable, JobPlanningType::Item, JobTask, JobPlanningLine);

        JobPlanningLine.Validate("No.", '1002');
        JobPlanningLine.Validate(Description, 'Created for Posting Group Test');
        JobPlanningLine.Validate(Quantity, 1);
        JobPlanningLine.Modify(true);

        JobPlanningLine.TestField("Gen. Bus. Posting Group");
    end;


    [Test]
    procedure CreateItemPostingGroup()
    var
        Item: Record Item;
        ItemGenBusPostGroupCBLC: Record "Item Gen. Bus. Post Group CBLC";
        SalesLine: Record "Sales Line";
        NewPostingGroup: Code[20];
        PostingGroup: Text;
    begin
        Item.Get('1002');
        LibrarySalesLIB.FindFirstSalesLine(SalesLine, SalesOrder);

        ItemGenBusPostGroupCBLC.Init();
        ItemGenBusPostGroupCBLC.Validate("Item No.", Item."No.");
        ItemGenBusPostGroupCBLC.Validate("Orginal Posting Group", SalesLine."Gen. Bus. Posting Group");

        while (PostingGroup = '') or (PostingGroup = SalesLine."Gen. Bus. Posting Group") do
            PostingGroup := LibraryRandomLIB.GetRandomValueByTable(Database::"Gen. Business Posting Group");

        NewPostingGroup := CopyStr(PostingGroup, 1, 20);

        ItemGenBusPostGroupCBLC.Validate("Replacement Posting Group", NewPostingGroup);
        ItemGenBusPostGroupCBLC.Insert(true)
    end;


    [Test]
    procedure CreateSalesLineWithReplacedPostingGroup()
    var
        Item: Record Item;
        ItemGenBusPostGroupCBLC: Record "Item Gen. Bus. Post Group CBLC";
        SalesLine: Record "Sales Line";
        OrgPostingGroup: Code[20];
    begin
        Item.Get('1002');
        LibrarySalesLIB.FindFirstSalesLine(SalesLine, SalesOrder);
        OrgPostingGroup := SalesLine."Gen. Bus. Posting Group";

        ItemGenBusPostGroupCBLC.Get(Item."No.", OrgPostingGroup);
        ItemGenBusPostGroupCBLC.TestField("Replacement Posting Group");

        //New Line
        LibrarySales.CreateSalesLine(SalesLine, SalesOrder, SalesLine.Type::Item, Item."No.", 1);

        //Test
        Assert.AreEqual(SalesLine."Gen. Bus. Posting Group", ItemGenBusPostGroupCBLC."Replacement Posting Group", 'Gen. Bus. Posting Group are not the same.');
    end;

    // local procedure CreateNewJobPlanningLineWithReplacedPostingGroup()
    // var
    //     Item: Record Item;
    //     ItemGenBusPostGroupCBLC: Record "Item Gen. Bus. Post Group CBLC";
    //     JobTask: Record "Job Task";
    //     OrgPostingGroup: Code[20];
    //     JobPlanningLineType: Enum "Job Planning Line Line Type";
    //     JobPlanningType: Enum "Job Planning Line Type";
    // begin
    //     JobTask.Get('JOB00010', '1010');
    //     Item.Get('1002');

    //     OrgPostingGroup := JobPlanningLine."Gen. Bus. Posting Group";
    //     ItemGenBusPostGroupCBLC.Get(Item."No.", OrgPostingGroup);
    //     ItemGenBusPostGroupCBLC.TestField("Replacement Posting Group");

    //     //Create
    //     LibraryJob.CreateJobPlanningLine(JobPlanningLineType::Billable, JobPlanningType::Item, JobTask, JobPlanningLine);

    //     JobPlanningLine.Validate("No.", '1002');
    //     JobPlanningLine.Validate(Description, 'Created for Posting Group Test');
    //     JobPlanningLine.Validate(Quantity, 1);
    //     JobPlanningLine.Modify(true);

    //     //Test
    //     Assert.AreEqual(JobPlanningLine."Gen. Bus. Posting Group", ItemGenBusPostGroupCBLC."Replacement Posting Group", 'Gen. Bus. Posting Group are not the same.');
    // end;
}
#pragma warning restore PC0030