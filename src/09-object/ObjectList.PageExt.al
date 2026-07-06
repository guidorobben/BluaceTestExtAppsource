pageextension 83918 "Object List TPTE" extends "Object List CBLC"
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

        addlast(General)
        {
            field("Object Norm Codem TPTE"; Rec."Object Norm Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the object norm code of the object.';
            }
            field("Main Object No. TPTE"; Rec."Main Object No.")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addlast(Promoted)
        {
            actionref(MaintenanceSchedules_Promoted; MaintenanceSchedules) { }

            group(ObjectTPTE_Promoted)
            {
                Caption = 'Object';

                actionref(ContactsTPTE_Promoted; Contacts) { }
                actionref(PropertiesTPTE_Promoted; Properties) { }
                group(DimensionsTPTE_Promoted)
                {
                    Caption = 'Dimensions';
                    ShowAs = SplitButton;

                    actionref(DimensionsMultipleTPTE_Promoted; "Dimensions-&Multiple") { }
                    actionref(DimensionsSingleTPTE_Promoted; "Dimensions-Single") { }
                }
                actionref(ItemPlanningNormsTPTE_Promoted; ItemPlanningNorms) { }
                actionref(ItemUsagesNormsTPTE_Promoted; ItemUsagesNorms) { }
                actionref(MainObjectTPTE_Promoted; MainObject) { }
                actionref(BillOfMaterialsTPTE_Promoted; BillOfMaterials) { }
                actionref(AvailabilityTPTE_Promoted; Availability) { }
                actionref(SkillsTPTE_Promoted; Skills) { }
                actionref(CommentsTPTE_Promoted; Comments) { }
                actionref(StatusChangesTPTE_Promoted; StatusChanges) { }
            }
        }
    }

    views
    {
        addlast
        {
            view(FixedAssetsTPTE)
            {
                Caption = 'Fixed Assets';
                Filters = where("Fixed Asset No." = filter(<> ''));
            }
        }
    }
}