pageextension 83905 "Job Planning Lines TPTE" extends "Job Planning Lines"
{
    layout
    {
        modify("Job No.")
        {
            Visible = true;
        }
        modify("Work Type Code")
        {
            Visible = true;
        }
        modify("Unit of Measure Code")
        {
            Visible = true;
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = true;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        modify("Planning Date")
        {
            Visible = true;
        }
        modify("Planned Delivery Date")
        {
            Visible = true;
        }
        modify("Qty. Posted")
        {
            Visible = true;
        }
        modify("Line Discount %")
        {
            Visible = true;
        }
    }

    actions
    {
        addlast(processing)
        {
            action(SetRemainingQuantityTPTE)
            {
                ApplicationArea = All;
                Caption = 'Set Remaining Quantity (Test Ext.)';

                trigger OnAction()
                begin
                    JobPlanningLineHelperTPTE.SetRemainingQyt(Rec, 2);
                end;
            }
            action(CreateLineWithPlanningAndRealizationTPTE)
            {
                ApplicationArea = All;
                Caption = 'Create Line with Planning & Realization';

                trigger OnAction()
                begin
                    JobPlanningLineHelperTPTE.CreateLineWithPlanningAndRealization(Rec);
                end;
            }
            // action(SetObjectTPTE)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Set Object';

            //     trigger OnAction()
            //     begin
            //         SetObject();
            //     end;
            // }
            //         action(FindGeoSkillTPTE)
            //         {
            //             ApplicationArea = All;
            //             Caption = 'Find Geo. Skill';
            //             Image = TestReport;

            //             trigger OnAction()
            //             begin
            //                 FindGeograhicSkill();
            //             end;
            //         }
        }
        addlast(navigation)
        {
            action(ObjectTPTE)
            {
                ApplicationArea = All;
                Caption = 'Object';

                trigger OnAction()
                begin
                    JobPlanningLineHelperTPTE.OpenObjectCard(Rec);
                end;
            }
            action(JobPlanningLineInvoiceTPTE)
            {
                ApplicationArea = All;
                Caption = 'Job PlanningLine Invoice';

                trigger OnAction()
                begin
                    JobPlanningLineHelperTPTE.OpenJobPlanningLineInvoice(Rec);
                end;
            }
            action(PostedPurchaseInvoiceTPTE)
            {
                ApplicationArea = All;
                Caption = 'Posted Purchase Invoice';

                trigger OnAction()
                begin
                    JobPlanningLineHelperTPTE.OpenPostedPurchaseInvoice(Rec);
                end;
            }
            action("Plan Lines TPTE")
            {
                ApplicationArea = ServiceCBLC;
                Caption = 'Planning Lines';
                Enabled = Rec."Service CBLC";
                Image = ResourcePlanning;
                RunObject = page "Job Plan. Lines CBLC";
                RunPageLink = "Job No." = field("Job No."), "Job Task No." = field("Job Task No."), "Job Planning Line No." = field("Line No.");
                RunPageMode = Edit;
                Scope = Repeater;
                ToolTip = 'View or edit project plan. lines that determine the resource planning for the project planning line.';
            }
            action(RealizationTPTE)
            {
                ApplicationArea = ServiceCBLC;
                Caption = 'Realization';
                Enabled = Rec."Service CBLC";
                Image = Signature;
                RunObject = page "Job Realizations CBLC";
                RunPageLink = "Job No." = field("Job No."), "Job Task No." = field("Job Task No."), "Job Planning Line No." = field("Line No.");
                RunPageMode = View;
                Scope = Repeater;
                ToolTip = 'View the realizations for the project planning line.';
            }
        }

        addlast(Promoted)
        {
            group(TestExtTPTE)
            {
                Caption = 'Test Ext.';

                actionref(CreateLineWithPlanningAndRealizationTPTE_Promoted; CreateLineWithPlanningAndRealizationTPTE) { }
                actionref(ObjectTPTE_Promoted; ObjectTPTE) { }
                actionref(SetRemainingQuantityTPTE_Promoted; SetRemainingQuantityTPTE) { }
                actionref(JobPlanningLineInvoiceTPTE_Promoted; JobPlanningLineInvoiceTPTE) { }
                actionref(PostedPurchaseInvoiceTPTE_Promoted; PostedPurchaseInvoiceTPTE) { }
                actionref("Plan Lines TPTE_Promoted"; "Plan Lines TPTE") { }

                actionref(RealizationTPTE_Promoted; RealizationTPTE) { }
            }
        }
    }

    // procedure FindGeograhicSkill()
    // var
    //     FindOrgSkillMethodYBLC: Codeunit "Find Org. Skill Method YBLC";
    //     SkillCode: Code[10];
    //     SkillLineHelperCBLC: codeunit "Skill Line Helper CBLC";
    // begin
    //     FindOrgSkillMethodYBLC.FindGeographicSkill(Rec, SkillCode);
    //     if SkillCode <> '' then begin
    //         SkillLineHelperCBLC.DeleteSkillLine(Rec.RecordId.TableNo, Rec.SystemId, Enum::"Skill Type CBLC"::Geography);
    //         SkillLineHelperCBLC.AddSkillLine(Rec.RecordId.TableNo, Rec.SystemId, SkillCode, false);
    //     end;
    // end;

    var
        JobPlanningLineHelperTPTE: Codeunit "Job Planning Line Helper TPTE";
}
