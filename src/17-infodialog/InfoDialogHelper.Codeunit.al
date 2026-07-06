codeunit 83859 "Info Dialog Helper TPTE"
{
    internal procedure ActivateEventCode(InfoDialog: Record "Info Dialog TPTE")
    begin
        OnActivateEventCode(InfoDialog, InfoDialog."Event Code");
    end;

    [IntegrationEvent(false, false)]
    local procedure OnActivateEventCode(InfoDialog: Record "Info Dialog TPTE"; EventCode: Enum "Info Dialog Event Code TPTE")
    begin
    end;
}