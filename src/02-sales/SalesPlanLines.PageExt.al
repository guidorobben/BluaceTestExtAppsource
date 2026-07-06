pageextension 83901 "Sales Plan. Lines TPTE" extends "Sales Plan. Lines CBLC"
{
    layout
    {
        modify("Orig. Min. Starting Date Time")
        {
            Visible = true;
        }
        modify("Orig. Max. Starting Date Time")
        {
            Visible = true;
        }
    }

    actions
    {
        addlast(Processing)
        {
            group(TextExtTPE)
            {
                Caption = 'Test Ext.';
                Image = TestDatabase;

                action(UpdateResourceTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Add Resource';

                    trigger OnAction()
                    begin
                        AddResourceTPTE();
                    end;
                }
                action(UpdateDateTimeTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Add Start Date Time';

                    trigger OnAction()
                    begin
                        AddStartDateTimeTPTE();
                    end;
                }
                action(UpdateResourceAndStartDateTimeTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Add Resource & Start Date Time';

                    trigger OnAction()
                    begin
                        AddResourceAndStartTimeTPTE();
                    end;
                }
                action(CopyFromMaintenanceTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Copy from Maintenance';

                    trigger OnAction()
                    begin
                        CopyDateTimeFromMaintenanceTPTE();
                    end;
                }
                action(UnblockTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Unblock';

                    trigger OnAction()
                    begin
                        SalesPlanLineHelperTPTE.UnblockForPlanning(Rec);
                    end;
                }
                action(MinusOneDayTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Starting Date: -1D';

                    trigger OnAction()
                    begin
                        SalesPlanLineHelperTPTE.StartingDateMinusOneDay(Rec);
                    end;
                }
                group(SetStatusTPTE)
                {
                    Caption = 'Status';
                    Image = Status;

                    action(SetToNewTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'New';

                        trigger OnAction()
                        begin
                            SalesPlanLineHelperTPTE.SetStatusToNew(Rec);
                        end;
                    }
                    action(SetToPlannedTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'Planned';

                        trigger OnAction()
                        begin
                            SalesPlanLineHelperTPTE.SetStatusToPlanned(Rec);
                        end;
                    }
                    action(SetToOnTheWayTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'On The Way';

                        trigger OnAction()
                        begin
                            SalesPlanLineHelperTPTE.SetStatusToOnTheWay(Rec);
                        end;
                    }
                    action(SetToInProgressTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'In Progress';

                        trigger OnAction()
                        begin
                            SalesPlanLineHelperTPTE.SetStatusToInProgress(Rec);
                        end;
                    }
                    action(SetToReadyTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'Ready';

                        trigger OnAction()
                        begin
                            SalesPlanLineHelperTPTE.SetStatusToReady(Rec);
                        end;
                    }
                }
            }
        }

        addlast(Promoted)
        {
            group(TextExtTPE_Promoted)
            {
                Caption = 'Test Ext.';
                Image = TestDatabase;

                actionref(UpdateResourceTPTE_Promoted; UpdateResourceTPTE) { }
                actionref(UpdateDateTimeTPTE_Promoted; UpdateDateTimeTPTE) { }
                actionref(UpdateResourceAndStartTimeTPTE_Promoted; UpdateResourceAndStartDateTimeTPTE) { }
                actionref(CopyFromMaintenanceTPTE_Promoted; CopyFromMaintenanceTPTE) { }
                actionref(MinusOneDayTPTE_Promoted; MinusOneDayTPTE) { }
                actionref(UnblockTPTE_Promoted; UnblockTPTE) { }

                group(SetStusTPTE_Promoted)
                {
                    Caption = 'Status';
                    Image = Status;

                    actionref(SetToNewTPTE_Promoted; SetToNewTPTE) { }
                    actionref(SetToPlannedTPTE_Promoted; SetToPlannedTPTE) { }
                    actionref(SetToOnTheWayTPTE_Promoted; SetToOnTheWayTPTE) { }
                    actionref(SetToInProgressTPTE_Promoted; SetToInProgressTPTE) { }
                    actionref(SetToReadyTPTE_Promoted; SetToReadyTPTE) { }
                }
            }
        }
    }

    var
        SalesPlanLineHelperTPTE: Codeunit "Sales Plan. Line Helper TPTE";

    local procedure AddResourceTPTE()
    begin
        SalesPlanLineHelperTPTE.AddResource(Rec);
    end;

    local procedure AddResourceAndStartTimeTPTE()
    begin
        SalesPlanLineHelperTPTE.AddResourceAndStartTime(Rec);
    end;

    local procedure AddStartDateTimeTPTE()
    begin
        SalesPlanLineHelperTPTE.AddStartDateTime(Rec);
    end;

    local procedure CopyDateTimeFromMaintenanceTPTE()
    begin
        SalesPlanLineHelperTPTE.CopyDateTimeFromMaintenance(Rec);
    end;
}