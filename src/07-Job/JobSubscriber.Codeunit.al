codeunit 83915 "Job Subscriber TPTE"
{

    [EventSubscriber(ObjectType::Table, Database::"Job Planning Line", OnBeforeDeleteEvent, '', false, false)]
    local procedure OnBeforeDeleteEventJobPlanningLine(var Rec: Record "Job Planning Line"; RunTrigger: Boolean)
    begin
        // if not confirm(Format(Rec)) then
        //     error('Test EXT: Stop');
    end;
}
