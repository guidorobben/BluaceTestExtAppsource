pageextension 83964 "Desktop TM TPTE" extends "Bluace Desktop LIB"
{

    layout
    {
        addfirst(Content)
        {
            // part("Run Object History Part TPTE"; "Run Object History Part TPTE")
            // {
            //     ApplicationArea = All;
            // }
            group(RunObjectPTE)
            {
                Caption = 'Run Object';

                group(ObjectOnePTE)
                {
                    Caption = 'Object 1';

                    field(RunObjectTypeControl1; RunObjectType1)
                    {
                        ApplicationArea = All;
                        Caption = 'Run Object Type';
                    }
                    field(RunObjectNoControl1; RunObjectNo1)
                    {
                        ApplicationArea = All;
                        Caption = 'Run Object No';

                        trigger OnAssistEdit()
                        var
                            DesktopHelper: Codeunit "Desktop Helper TPTE";
                        begin
                            DesktopHelper.StartupObject(1, true);
                        end;
                    }
                }
                group(ObjectTwoPTE)
                {
                    Caption = 'Object 2';

                    field(RunObjectTypeControl2; RunObjectType2)
                    {
                        ApplicationArea = All;
                        Caption = 'Run Object Type';
                    }
                    field(RunObjectNoControl2; RunObjectNo2)
                    {
                        ApplicationArea = All;
                        Caption = 'Run Object No';

                        trigger OnAssistEdit()
                        var
                            DesktopHelper: Codeunit "Desktop Helper TPTE";
                        begin
                            DesktopHelper.StartupObject(2, true);
                        end;
                    }
                }
            }
        }
    }

    actions
    {
        addfirst(Processing)
        {
            #region Sales
            group(SalesOrderGroupTPTE)
            {
                Caption = 'Sales';

                group(SalesCreateGroupTPTE)
                {
                    Caption = 'Create';
                    Image = New;

                    action(CreateSalesOrderWithLinePlanningRealizationTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'Create Sales Order with Line, Planning & Realization';

                        trigger OnAction()
                        var
                            CreateSales: Codeunit "Create Sales TPTE";
                        begin
                            CreateSales.CreateSalesOrderWithLinePlanningRealization();
                            OpenLastSalesOrder();
                        end;
                    }
                    action(CreateSalesOrderWithLinesPlanningRealizationTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'Create Sales Order with Lines, Planning & Realization';

                        trigger OnAction()
                        var
                            CreateSales: Codeunit "Create Sales TPTE";
                        begin
                            CreateSales.CreateSalesOrderWithLinesPlanningRealization();
                            OpenLastSalesOrder();
                        end;
                    }
                    action(CreateSalesOrderWithLinesPlanningTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'Create Sales Order with Line, Planning';

                        trigger OnAction()
                        var
                            CreateSales: Codeunit "Create Sales TPTE";
                        begin
                            CreateSales.CreateSalesOrderWithLinePlanning();
                            OpenLastSalesOrder();
                        end;
                    }
                }
                group(SalesSegmentingTPTE)
                {
                    Caption = 'Sales Segmenting';
                    Image = Segment;

                    action(SalesSegmentSetupTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'Sales Segment Setup';
                        Image = Setup;
                        RunObject = page "Sales Segment Setup CBLC";
                    }
                    action(SalesSegmentsTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'Sales Segments';
                        Image = Segment;
                        RunObject = page "Sales Segments CBLC";
                    }
                }

                group(CustomersTPTE)
                {
                    Caption = 'Customers';
                    Image = Customer;

                    action(TestPostingDatesTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'Test Update Posting Dates';
                        RunObject = codeunit "UT Upd. Posting Dates TPTE";
                    }
                }

                action(TestSalesOrderTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Test Sales Order';
                    RunObject = codeunit "UT Sales Order TPTE";
                }

                action(TestLogisticDatesTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Test Logistic dates';
                    RunObject = codeunit "UT Upd. Logistic Dates TPTE";
                }

                action(TestSalesJobNormTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Test Sales/Job Norm';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"UT Sales/Job Norm TPTE");
                    end;
                }
                // action(UpdateLogisticDatesTPTE)
                // {
                //     ApplicationArea = All;
                //     Caption = 'Update Logistic Dates';
                //     Ellipsis = true;
                //     // RunObject = report "Update Logistic Dates CBLC";
                // }

                action(OpenSalesOrdersTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Orders';

                    trigger OnAction()
                    begin
#pragma warning disable LC0003
                        Page.Run(9305);
#pragma warning restore LC0003
                    end;
                }
                action(OpenLastSalesOrdersTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Open last Sales Order';

                    trigger OnAction()
                    var
                        SupportFunctions: Codeunit "Support Functions TPTE";
                    begin
                        SupportFunctions.OpenLastSalesOrderWithFilter();
                    end;
                }
                action(OpenSalesInvoicesTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Invoices';

                    trigger OnAction()
                    begin
                        Page.Run(Page::"Sales Invoice List");
                    end;
                }
                action(OpenLastSalesInvoiceTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Open last Sales Invoice';

                    trigger OnAction()
                    var
                        LibrarySalesLIB: Codeunit "Library - Sales LIB";
                    begin
                        LibrarySalesLIB.OpenLastSalesInvoice();
                    end;
                }
                action(OpenPostedSalesInvoicesTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Posted Sales Invoices';
                    RunObject = page "Posted Sales Invoices";
                    RunPageView = sorting("No.") order(descending);
                }
                action(OpenSalesQuotesTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Quotes';

                    trigger OnAction()
                    begin
                        Page.Run(Page::"Sales Quotes");
                    end;
                }
                action(OpenLastSalesCreditMemoTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Open last Sales Credit Memo';

                    trigger OnAction()
                    var
                        LibrarySalesLIB: Codeunit "Library - Sales LIB";
                    begin
                        LibrarySalesLIB.OpenLastSalesCreditMemo();
                    end;
                }
                action(OpenSalesReturnOrdersTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Return Orders';
                    RunObject = page "Sales Return Order List";
                }
                action(SalesRealizationsTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Realizations';
                    RunObject = page "Sales Realizations CBLC";
                }
                action(OpenSalesPlanLinesTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Plan Lines';
                    RunObject = page "Sales Plan. Lines CBLC";
                }
                // action(TestJobPlanningTPTE)
                // {
                //     ApplicationArea = All;
                //     Caption = 'Test Job Planning';
                //     RunObject = codeunit "Job Realization Test";
                // }
                action(OpenJobsTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Jobs';
                    RunObject = page "Job List";
                }
                action(OpenJobPlanLinesTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Job Plan. Lines';
                    RunObject = page "Job Plan. Lines CBLC";
                }
                action(OpenTimeSheetsTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Time Sheets';

                    trigger OnAction()
                    begin
                        Page.Run(Page::"Time Sheet List");
                    end;
                }
            }
            #endregion Sales

            group(TestItemGroupTPTE)
            {
                Caption = 'Item';

                group(ItemTestsTPTE)
                {
                    Caption = 'Tests';
                    Image = TestDatabase;

                    action(TestItemTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'Test Item';
                        RunObject = codeunit "UT Item TPTE";
                    }
                    // action(TestItemExtDocTPTE)
                    // {
                    //     ApplicationArea = All;
                    //     Caption = 'Test Item Ext. Documents';
                    //     RunObject = codeunit "Item Ext. Doc Text Test TPTE";
                    // }
                }
                // action(TestItemNormTPTE)
                // {
                //     ApplicationArea = All;
                //     Caption = 'Test Item Norm';
                //     RunObject = codeunit "Item Norm Test TPTE";
                // }

                action(ItemListTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Item List';
                    Image = Item;
                    RunObject = page "Item List";
                }
                // action(DetailedDescriptionsTPTE)
                // {
                //     ApplicationArea = All;
                //     Caption = 'Detailed Descriptions';
                //     RunObject = page "Detailed Description TPTE";
                // }
                action(ContainerListTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Container List';
                    Image = ItemGroup;
                    RunObject = page "Container List CBLC";
                }
                action(TransferOrdersTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Transfer Orders';
                    Image = TransferOrder;
                    RunObject = page "Transfer Orders";
                    RunPageView = sorting("No.") order(descending);
                }
            }

            #region Purchase
            group(PurchaseGroupTPTE)
            {
                Caption = 'Purchase';

                action(PurchaseOrdersTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Orders';
                    RunObject = page "Purchase Order List";
                }
                action(PurchaseInvoicesTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Invoices';
                    RunObject = page "Purchase Invoices";
                }
                action(PostedPurchaseInvoicesTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Posted Purchase Invoices';
                    RunObject = page "Posted Purchase Invoices";
                }
                action(PurchaseCreditMemosTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Credit Memos';
                    RunObject = page "Purchase Credit Memos";
                }
                action(PurchaseReturnOrderListTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Return Order List';
                    RunObject = page "Purchase Return Order List";
                }
                action(ReqWorkSheetTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Requisition Worksheets';
                    RunObject = page "Req. Worksheet";
                }
            }
            #endregion Purchase

            #region Jobs
            group(JobGroupTPTE)
            {
                Caption = 'Job';

                action(JobTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Jobs';
                    Image = Job;
                    RunObject = page "Job List";
                }
                action(OpenJobJournalTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Job Journal';
                    RunObject = page "Job Journal";
                    ToolTip = 'Show job journal.';
                }
            }
            #endregion Jobs
        }

        addlast(AdministrationGroup)
        {
            action(FieldMismatchAnalyzer)
            {
                ApplicationArea = All;
                Caption = 'Field Mismatch';
                Image = Warning;
                RunObject = page "Field Mismatch TPTE";
            }
        }

        addfirst(Promoted)
        {
            group(SalesOrderGroupTPTE_PromotedTPTE)
            {
                Caption = 'Sales';
                Image = Sales;

                group(SalesOrderTestPromotedTPTE)
                {
                    Caption = 'Tests';
                    Image = TestDatabase;

                    actionref(TestSalesOrder_Promoted; TestSalesOrderTPTE) { }
                    actionref(TestLogisticDates_Promoted; TestLogisticDatesTPTE) { }
                    actionref(TestSalesJobNorm_Promoted; TestSalesJobNormTPTE) { }
                }
                group(SalesCreateGroupTPTE_PromotedTPTE)
                {
                    Caption = 'Create';
                    Image = New;

                    actionref(CreateSalesOrderWithLinePlanningRealizationTPTE_Promoted; CreateSalesOrderWithLinePlanningRealizationTPTE) { }
                    actionref(CreateSalesOrderWithLinesPlanningRealizationTPTE_Promoted; CreateSalesOrderWithLinesPlanningRealizationTPTE) { }
                    actionref(CreateSalesOrderWithLinesPlanningTPTE_Promoted; CreateSalesOrderWithLinesPlanningTPTE) { }
                }
                group(SalesSegmentingTPTE_PromotedTPTE)
                {
                    Caption = 'Sales Segmenting';
                    Image = Segment;

                    actionref(SalesSegmentSetupTPTE_Promoted; SalesSegmentSetupTPTE) { }
                    actionref(SalesSegmentsTPTE_Promoted; SalesSegmentsTPTE) { }
                }
                group(CustomersTPTE_PromotedTPTE)
                {
                    Caption = 'Customers';
                    Image = Customer;

                    actionref(TestPostingDatesTPTE_Promoted; TestPostingDatesTPTE) { }
                }
                actionref(OpenSalesOrders_Promoted; OpenSalesOrdersTPTE) { }
                actionref(OpenLastSalesOrdersTPTE_Propmoted; OpenLastSalesOrdersTPTE) { }
                actionref(OpenSalesInvoices_Promoted; OpenSalesInvoicesTPTE) { }
                actionref(OpenLastSalesInvoiceTPTE_Promoted; OpenLastSalesInvoiceTPTE) { }
                actionref(OpenPostedSalesInvoicesTPTE_Promoted; OpenPostedSalesInvoicesTPTE) { }
                actionref(OpenSalesQuotesTPTE_Promoted; OpenSalesQuotesTPTE) { }
                actionref(OpenLastSalesCreditMemoTPTE_Promoted; OpenLastSalesCreditMemoTPTE) { }
                actionref(OpenSalesReturnOrdersTPTE_Promoted; OpenSalesReturnOrdersTPTE) { }
                actionref(SalesRealizations_Promoted; SalesRealizationsTPTE) { }
                actionref(OpenSalesPlanLines_Promoted; OpenSalesPlanLinesTPTE) { }
                actionref(OpenJobs_Promoted; OpenJobsTPTE) { }
                actionref(OpenJobPlanLines_Promoted; OpenJobPlanLinesTPTE) { }
                actionref(OpenTimeSheets_Promoted; OpenTimeSheetsTPTE) { }
            }

            group(ItemTestGroupTPTE_PromotedTPTE)
            {
                Caption = 'Item';
                Image = Item;

                group(ItemTestsTPTE_PromotedTPTE)
                {
                    Caption = 'Tests';
                    Image = TestDatabase;

                    actionref(TestItemTPTE_Promoted; TestItemTPTE) { }
                    // actionref(TestItemExtDocTPTE_Propmoted; TestItemExtDoc) { }
                }
                actionref(ItemListTPTE_Promoted; ItemListTPTE) { }
                actionref(ContainerListTPTE_Promoted; ContainerListTPTE) { }
                actionref(TransferOrdersTPTE_Promoted; TransferOrdersTPTE) { }
                // actionref(DetailedDescriptionsTPTE_Promoted; DetailedDescriptionsTPTE) { }
            }

            group(PurchaseGroupTPTE_PromotedTPTE)
            {
                Caption = 'Purchase';
                Image = Purchase;

                actionref(PurchaseOrdersTPTE_Promoted; PurchaseOrdersTPTE) { }
                actionref(PurchaseInvoicesTPTE_Promoted; PurchaseInvoicesTPTE) { }
                actionref(PostedPurchaseInvoicesTPTE_Promoted; PostedPurchaseInvoicesTPTE) { }
                actionref(PurchaseCreditMemosTPTE_Promoted; PurchaseCreditMemosTPTE) { }
                actionref(PurchaseReturnOrderListTPTE_Promoted; PurchaseReturnOrderListTPTE) { }
                actionref(ReqWorkSheetTPTE_Promoted; ReqWorkSheetTPTE) { }
            }

            #region Jobs
            group(JobsGroupTPTE_PromotedTPTE)
            {
                Caption = 'Jobs';
                Image = Job;

                actionref(JobTPTE_Promoted; JobTPTE) { }
                actionref(OpenJobJournalTPTE_Promoted; OpenJobJournalTPTE) { }
            }
            #endregion Jobs
        }

        addlast(Administration_Promoted)
        {
            actionref(FieldMismatchAnalyzer_Promoted; FieldMismatchAnalyzer) { }
        }
    }

    var
        RunObjectType: array[5] of Enum "Object Type TPTE";
        RunObjectType1, RunObjectType2 : Enum "Object Type TPTE";
        RunObjectNo: array[5] of Integer;
        RunObjectNo1, RunObjectNo2 : Integer;

    trigger OnOpenPage()
    begin
        InitRunObjectFields();
    end;

    local procedure InitRunObjectFields()
    var
        TestExtSetup: Record "Test Ext. Setup TPTE";
    begin
        TestExtSetup.GetStartupObjects(RunObjectNo, RunObjectType);
        RunObjectType1 := RunObjectType[1];
        RunObjectNo1 := RunObjectNo[1];

        RunObjectType2 := RunObjectType[2];
        RunObjectNo2 := RunObjectNo[2];

    end;

    local procedure OpenLastSalesOrder()
    var
        LibrarySalesLIB: Codeunit "Library - Sales LIB";
    begin
        LibrarySalesLIB.OpenLastSalesOrder();
    end;
}