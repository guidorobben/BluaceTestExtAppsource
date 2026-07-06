pageextension 83900 "Contract List TPTE" extends "Contract List CBLC"
{
    layout
    {
        addlast(General)
        {
            field("Contract Norm Code TPTE"; Rec."Contract Norm Code")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
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
        }
    }
}