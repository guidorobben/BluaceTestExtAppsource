pageextension 83917 "Contract Card TPTE" extends "Contract Card CBLC"
{
    actions
    {
        addlast(Processing)
        {
            group(TestExtGroupTPTE)
            {
                Caption = 'Test Ext.';

                action(RemoveContractLinesTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Remove Contract Lines';
                    Ellipsis = true;
                    Image = Delete;

                    trigger OnAction()
                    var
                        ContractLineCBLC: Record "Contract Line CBLC";
                    begin
                        ContractLineCBLC.SetRange("Contract No.", Rec."No.");
                        Report.Run(Report::"Remove Contr. Lines CBLC", true, true, ContractLineCBLC);
                    end;
                }
            }
        }

        addlast(Promoted)
        {
            group(Contract_Promoted)
            {
                Caption = 'Contract';

                actionref(DimensionsTPTE_Promoted; Dimensions) { }
                actionref(UnitsOfMeasureTPTE_Promoted; UnitsOfMeasure) { }
                actionref(ServicesTPTE_Promoted; Services) { }
                actionref(ShipmentLinesTPTE_Promoted; ShipmentLines) { }
                actionref(PlanningNormsTPTE_Promoted; ItemPlanningNorms) { }
                actionref(UsageNormsTPTE_Promoted; ItemUsageNorms) { }
                actionref(MaintenanceSchedulesTPTE_Promoted; MaintenanceSchedules) { }
                actionref(SkillsTPTE_Promoted; Skills) { }
                actionref(PrioritiesTPTE_Promoted; Priorities) { }
                actionref(CommentsTPTE_Promoted; Comments) { }
                actionref(ArchiveTPTE_Promoted; Archive) { }
            }

            group(TestExtGroupTPTE_Propmoted)
            {
                Caption = 'Test Ext.';

                actionref(RemoveContractLinesTPTE_Promoted; RemoveContractLinesTPTE) { }
            }
        }
    }
}
