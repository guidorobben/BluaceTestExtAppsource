pageextension 83914 "Object Card TPTE" extends "Object Card CBLC"
{

    layout
    {
        modify("Maint. Schedule Updated")
        {
            Visible = true;
        }
        modify("Maint. Schedule Updated At")
        {
            Visible = true;
        }
        modify("Object Template No.")
        {
            Editable = true;
        }
    }

    actions
    {
        addlast(Navigation)
        {
            group(TestExtTPTE)
            {
                Caption = 'Test Ext.';

                action(ContractsTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Contracts';
                    RunObject = page "Contract Lines CBLC";
                    RunPageLink = "Object No." = field("No.");
                }
                action(CreateAndLinkObjectNormTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Create and link object norm';

                    trigger OnAction()
                    var
                        ObjectHelperTPTE: Codeunit "Object Helper TPTE";
                    begin
                        ObjectHelperTPTE.CreateAndLinkObjectNorm(Rec);
                    end;
                }
                action(CreateMaintenanceNormForObjectNormTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Create Maintenance Norm (Object Norm).';

                    trigger OnAction()
                    var
                        ObjectHelperTPTE: Codeunit "Object Helper TPTE";
                    begin
                        ObjectHelperTPTE.CreateMaintenanceNormForObjectNorm(Rec)
                    end;
                }
                action(CreateMaintenanceNormForObjectNormAllContractsTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Create Maintenance Norm (Object Norm/All Contracts).';

                    trigger OnAction()
                    var
                        ObjectHelperTPTE: Codeunit "Object Helper TPTE";
                    begin
                        ObjectHelperTPTE.CreateMaintenanceNormForObjectNormAllContractss(Rec)
                    end;
                }
            }
        }

        addlast(Promoted)
        {
            actionref(CreateContractTPTE_Promoted; CreateContract) { }
            actionref(CreateOrderLineTPTE_Promoted; CreateOrderLine) { }
            actionref(MaintenanceSchedulesTPTE_Promoted; MaintenanceSchedules) { }
            actionref(CreateMaintenanceScheduleTPTE_Promoted; CreateMaintenanceSchedule) { }

            group(ObjectTPTE_Promoted)
            {
                Caption = 'Object';

                actionref(ContactsTPTE_Promoted; Contacts) { }
                actionref(PropertiesTPTE_Promoted; Properties) { }
                actionref(DimensionsTPTE_Promoted; Dimensions) { }
                actionref(ItemPlanningNormsTPTE_Promoted; ItemPlanningNorms) { }
                actionref(ItemUsagesNormsTPTE_Promoted; ItemUsagesNorms) { }
                actionref(MainObjectTPTE_Promoted; MainObject) { }
                actionref(BillOfMaterialsTPTE_Promoted; BillOfMaterials) { }
                actionref(AvailabilityTPTE_Promoted; Availability) { }
                actionref(SkillsTPTE_Promoted; Skills) { }
                actionref(CommentsTPTE_Promoted; Comments) { }
                actionref(StatusChangesTPTE_Promoted; StatusChanges) { }
            }
            group(TestExtTPTE_Promoted)
            {
                Caption = 'Test Ext.';

                actionref(ContractsTPTE_Promoted; ContractsTPTE) { }
                actionref(CreateAndLinkObjectNormTPTE_Promoted; CreateAndLinkObjectNormTPTE) { }
                actionref(CreateMaintenanceNormForObjectNormTPTE_Promoted; CreateMaintenanceNormForObjectNormTPTE) { }
                actionref(CreateMaintenanceNormForObjectNormAllContractsTPTE_Promoted; CreateMaintenanceNormForObjectNormAllContractsTPTE) { }
            }
        }
    }
}
