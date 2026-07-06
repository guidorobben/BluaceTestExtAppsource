pageextension 83928 "Sales Realizations TPTE" extends "Sales Realizations CBLC"
{
    actions
    {
        addlast(Processing)
        {
            group(TextExtTPTE)
            {
                Caption = 'Test Ext.';

                action(CopyFromPlanningTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Copy from planning';
                    Image = Recalculate;
                    ToolTip = 'Copy from planning.';

                    trigger OnAction()
                    begin
                        SalesRealizationHelperTPTE.CopyFromPlanning(Rec);
                    end;
                }

                action(CreateRealizationTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Create realization';
                    Image = Recalculate;
                    ToolTip = 'Create realization.';

                    trigger OnAction()
                    begin
                        SalesRealizationHelperTPTE.CopyFromPlanning(Rec);
                    end;
                }
                action(CreateRealizationWithTravelTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Create realization with travel';
                    Image = Recalculate;
                    ToolTip = 'Create realization with travel.';

                    trigger OnAction()
                    begin
                        SalesRealizationHelperTPTE.UpdateRealizationWithTravelTPTE(Rec);
                    end;
                }
                action(MinusOneDayTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Work Starting Date: -1D';
                    ToolTip = 'Working Date Time -1 Day.';

                    trigger OnAction()
                    begin
                        SalesRealizationHelperTPTE.StartingDateMinusOneDayTPTE(Rec);
                        CurrPage.Editable := true;
                    end;
                }
                action(ObjectCardTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Object Card';
                    Image = Bank;
                    ToolTip = 'Opens the Object Card.';

                    trigger OnAction()
                    begin
                        SalesRealizationHelperTPTE.OpenObjectCard(Rec);
                    end;
                }
            }
        }

        addlast(Promoted)
        {
            group(TestExtTPTE_Promoted)
            {
                Caption = 'Test Ext.';
                Image = TestReport;

                actionref(CreateRealizationTPTE_Promoted; CreateRealizationTPTE) { }
                actionref(CreateRealizationWithTravelTPTE_Promoted; CreateRealizationWithTravelTPTE) { }
                actionref(CopyFromPlanningTPTE_Promoted; CopyFromPlanningTPTE) { }
                actionref(MinusOneDayTPTE_Promoted; MinusOneDayTPTE) { }
                actionref(ObjectCardTPTE_Promoted; ObjectCardTPTE) { }
            }
        }
    }

    var
        SalesRealizationHelperTPTE: Codeunit "Sales Realization Helper TPTE";

    trigger OnOpenPage()
    begin
        CurrPage.Editable := true;
    end;



    // local procedure CreateSalesRealizationTPTE()
    // var
    //     ResourceGroup: Record "Resource Group";
    //     SalesLine: Record "Sales Line";
    //     SalesPlanLineCBLC: Record "Sales Plan. Line CBLC";
    //     LibrarySalesLIB: Codeunit "Library - Sales LIB";
    //     ResourceGroupNo: Code[20];
    // begin
    //     SalesLine.Get(SalesLine."Document Type"::Order, Rec.GetFilter("Document No."), Rec.GetFilter("Document Line No."));
    //     //SalesPlanLineCBLC.Get(SalesPlanLineCBLC."Document Type"::Order, SalesLine."Document No.", SalesLine."Line No.", ResourceGroupNo);
    //     SalesPlanLineCBLC.SetRange("Document Type", SalesPlanLineCBLC."Document Type"::Order);
    //     SalesPlanLineCBLC.SetRange("Document No.", SalesLine."Document No.");
    //     SalesPlanLineCBLC.SetRange("Document Line No.", SalesLine."Line No.");
    //     SalesPlanLineCBLC.FindFirst();

    //     ResourceGroupNo := SalesPlanLineCBLC."Resource Group No.";
    //     ResourceGroup.Get(ResourceGroupNo);

    //     LibrarySalesLIB.InitSalesRealization(SalesLine, Rec, ResourceGroup);
    //     Rec.Insert(true);

    //     //KM
    //     //        SalesRealizationCBLC.Validate("Travel Distance (km)", LibraryRandom.RandDecInDecimalRange(5, 30, 0));

    //     //Work
    //     Rec.Validate("Work Starting Date Time", SalesPlanLineCBLC."Starting Date Time");
    //     Rec.Validate("Work Ending Date Time", SalesPlanLineCBLC."Ending Date Time");

    //     Rec.Modify(true);
    //     // LibrarySalesLIB.SetSalesRealizationToProcessed(SalesRealizationCBLC);
    // end;





}