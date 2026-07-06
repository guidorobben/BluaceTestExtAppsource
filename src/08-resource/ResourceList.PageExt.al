pageextension 83907 "Resource List TPTE" extends "Resource List"
{
    layout
    {
        modify("Resource Group No.")
        {
            Visible = true;
        }
        moveafter(Type; "Resource Group No.")

        // modify("Geography Skill Code CBLC")
        // {
        //     Visible = true;
        // }
        // modify("Organization Skill Code CBLC")
        // {
        //     Visible = true;
        // }
    }

    actions
    {
        addafter("Units of Measure")
        {
            // action(SkillsTPTE)
            // {
            //     ApplicationArea = Basic, Suite;
            //     Caption = 'S&kills (Test Ext.)';
            //     Image = Skills;
            //     RunObject = page "Resource Skills";
            //     RunPageLink = Type = const(Resource), "No." = field("No.");
            //     ToolTip = 'View the assignment of skills to the resource. You can use skill codes to allocate skilled resources to service items or items that need special skills for servicing.';
            // }
            action(ResourceLocationsTPTE)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Resource L&ocations';
                Image = Resource;
                RunObject = page "Resource Locations";
                RunPageLink = "Resource No." = field("No.");
                RunPageView = sorting("Resource No.");
                ToolTip = 'View where resources are located or assign resources to locations.';
            }
        }

        addafter("Units of Measure_Promoted")
        {
            // actionref("SkillsTPTE_Promoted"; SkillsTPTE) { }
            actionref(ResourceLocationsTPTE_Promoted; ResourceLocationsTPTE) { }
        }
    }
}
