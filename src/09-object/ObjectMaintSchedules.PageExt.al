pageextension 83929 "Object Maint. Schedules TPTE" extends "Object Maint. Schedules CBLC"
{
    layout
    {
        modify("Last Realization Date")
        {
            Editable = EditModeTPTE;
        }
        modify("Maint. Schedule Template No.")
        {
            Visible = ShowImportanceTPTE;
        }
        modify("Next Planning Date")
        {
            Editable = EditModeTPTE;
        }
        modify("Item Plan Norm Entry No.")
        {
            Visible = true;
        }
        modify("Geography Skill Code")
        {
            Editable = true;
            Visible = ShowImportanceTPTE;
        }
        modify("Organization Skill Code")
        {
            Editable = true;
            Visible = ShowImportanceTPTE;
        }
        modify("Post Code")
        {
            Visible = ShowImportanceTPTE;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Visible = ShowImportanceTPTE;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = ShowImportanceTPTE;
        }
    }

    actions
    {
        addlast(Processing)
        {
            group(TestExtTPTE)
            {
                Caption = 'Test Ext.';
                Image = TestDatabase;

                action(CreateMaintenanceOrdersTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Create Maintenance Orders';
                    Ellipsis = true;
                    Image = Action;

                    trigger OnAction()
                    var
                        ObjectMaintScheduleCBLC: Record "Object Maint. Schedule CBLC";
                        CreateMaintOrdersCBLC: Report "Create Maint. Orders CBLC";
                    begin
                        ObjectMaintScheduleCBLC.SetRange("Object No.", Rec."Object No.");
                        CreateMaintOrdersCBLC.SetTableView(ObjectMaintScheduleCBLC);
                        CreateMaintOrdersCBLC.UseRequestPage(true);
                        CreateMaintOrdersCBLC.Run();
                    end;
                }
                action(UpdateMainScheduleTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Update schema';

                    Image = "1099Form";
                    ToolTip = 'Update Schema.';

                    trigger OnAction()
                    var
                        LibraryMaintenanceLIB: Codeunit "Library - Maintenance LIB";
                    begin
                        LibraryMaintenanceLIB.UpdateObjectMaintSchedules(Rec);
                        CurrPage.Update();
                    end;
                }
                action(NextMainScheduleTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Next schema';
                    Image = "1099Form";
                    ToolTip = 'Get Next Schema Entry No.';

                    trigger OnAction()
                    begin
                        ObjectMaintSchedHlpTPTE.GetNextObjectMaintenanceSchedule(Rec);
                    end;
                }
                action(CreateOrderLineTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Create Order Line';
                    Ellipsis = true;
                    Image = NewOrder;
                    ToolTip = 'Creates a sales order line for the current object.';

                    trigger OnAction()
                    begin
                        ObjectMaintSchedHlpTPTE.CreateSalesOrderLine(Rec);
                    end;
                }
                action(ShowSalesOrderTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Order';
                    Image = Document;
                    ToolTip = 'Show Sales order.';

                    trigger OnAction()
                    begin
                        ObjectMaintSchedHlpTPTE.ShowSalesOrder(Rec);
                    end;
                }
                action(DeleteSalesOrderTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Delete Sales Order';
                    Image = Document;
                    ToolTip = 'Delete Sales order.';

                    trigger OnAction()
                    begin
                        ObjectMaintSchedHlpTPTE.DeleteSalesOrder(Rec);
                        CurrPage.Update();
                    end;
                }
                action(ClearSalesOrderTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Clear Sales Order';
                    Image = Document;
                    ToolTip = 'Clear Sales order.';

                    trigger OnAction()
                    begin
                        // ObjectMaintSchedHlpTPTE.DeleteSalesOrder(Rec);
                        Rec."Sales Order No." := '';
                        Rec."Sales Order Line No." := 0;
                        Rec.Modify(false);
                        CurrPage.Update();
                    end;
                }
                action(ContractTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Contract';
                    Image = Card;
                    RunObject = page "Contract Card CBLC";
                    RunPageLink = "No." = field("Contract No.");
                }
                action(ObjectTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Object';
                    Image = Card;
                    RunObject = page "Object Card CBLC";
                    RunPageLink = "No." = field("Object No.");
                }
                action(TestDelete)
                {
                    ApplicationArea = All;
                    Caption = 'Test Delete';
                    Image = Delete;

                    trigger OnAction()
                    var
                        ObjectCBLC: Record "Object CBLC";
                        LibraryObjectLIB: Codeunit "Library - Object LIB";
                    begin
#pragma warning disable LC0068
                        ObjectCBLC.Get(Rec."Object No.");
                        // ObjectCBLC.TestField("Object Norm Code", '666');
                        LibraryObjectLIB.DeleteObjectMaintenanceSchedules(ObjectCBLC, Rec."Starting Date");
                        // ObjectCBLC.DeleteObjectMaintenanceSchedules(Rec."Starting Date");
#pragma warning restore LC0068
                    end;
                }
                action(ToggelImportanceTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Toggle Importance';
                    Image = ToggleBreakpoint;
                    ToolTip = 'Toggle Importance.';

                    trigger OnAction()
                    begin
                        ShowImportanceTPTE := not ShowImportanceTPTE;
                    end;
                }
                action(ToggleEditModeTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Toggle Edit Mode';
                    Image = ToggleBreakpoint;
                    ToolTip = 'Toggle Edit Mode.';

                    trigger OnAction()
                    begin
                        EditModeTPTE := not EditModeTPTE;
                    end;
                }
            }
        }
        addlast(Promoted)
        {
            group(TestExtTPTE_Promoted)
            {
                Caption = 'Test Ext.';

                actionref(CreateMaintenanceOrdersTPTE_Promoted; CreateMaintenanceOrdersTPTE) { }
                actionref(UpdateMainScheduleTPTE_Promoted; UpdateMainScheduleTPTE) { }
                actionref(NextMainScheduleTPTE_Promoted; NextMainScheduleTPTE) { }
                actionref(CreateOrderLineTPTE_Promoted; CreateOrderLineTPTE) { }
                group(SalesOrderTPTE)
                {
                    ShowAs = SplitButton;
                    actionref(ShowSalesOrderTPTE_Promoted; ShowSalesOrderTPTE) { }
                    actionref(DeleteSalesOrderTPTE_Promoted; DeleteSalesOrderTPTE) { }
                    actionref(ClearSalesOrderTPTE_Promoted; ClearSalesOrderTPTE) { }
                }
                actionref(ContractTPTE_Promoted; ContractTPTE) { }
                actionref(ObjectTPTE_Promoted; ObjectTPTE) { }
                actionref(ToggelImportance_Promoted; ToggelImportanceTPTE) { }
                actionref(EditModeTPTE_Promoted; ToggleEditModeTPTE) { }
            }
        }
    }

    var
        ObjectMaintSchedHlpTPTE: Codeunit "Object Maint. Sched. Hlp. TPTE";
        EditModeTPTE: Boolean;
        ShowImportanceTPTE: Boolean;

    trigger OnOpenPage()
    begin
        ShowImportanceTPTE := false;
        EditModeTPTE := false;
    end;
}