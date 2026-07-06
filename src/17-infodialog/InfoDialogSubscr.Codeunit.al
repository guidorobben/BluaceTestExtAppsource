codeunit 83871 "Info Dialog Subscr. TPTE"
{
    Access = Internal;
    Permissions =
        tabledata "Info Dialog TPTE" = R,
        tabledata "User Setup" = R,
        tabledata Workflow = R;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Info Dialog Helper TPTE", OnActivateEventCode, '', false, false)]
    local procedure OnActivateEventCode(InfoDialog: Record "Info Dialog TPTE"; EventCode: Enum "Info Dialog Event Code TPTE")
    begin
        case EventCode of
            // EventCode::INSTANCEID:
            //     OpenActiveWorkflow(InfoDialog);
            // EventCode::WORKFLOWCODE:
            //     OpenWorkFlow(InfoDialog);
            EventCode::"User Setup":
                OpenUserSetup(InfoDialog);
        end;
    end;

    // local procedure OpenActiveWorkflow(InfoDialog: Record "Info Dialog TPTE")
    // var
    //     WorkflowEditor: Codeunit "Workflow Editor TPTE";
    // begin
    //     WorkflowEditor.OpenActiveWorkflow(InfoDialog.GetValueAsGuid());
    // end;

    // local procedure OpenWorkFlow(InfoDialog: Record "Info Dialog TPTE")
    // var
    //     Workflow: Record Workflow;
    //     PageManagement: Codeunit "Page Management";
    // begin
    //     if Workflow.Get(InfoDialog.Value) then
    //         PageManagement.PageRun(Workflow);
    // end;

    local procedure OpenUserSetup(InfoDialog: Record "Info Dialog TPTE")
    var
        UserSetup: Record "User Setup";
        PageManagement: Codeunit "Page Management";
    begin
        if UserSetup.Get(CopyStr(InfoDialog.Value, 1, MaxStrLen(UserSetup."User ID"))) then
            PageManagement.PageRun(UserSetup);
    end;
}
