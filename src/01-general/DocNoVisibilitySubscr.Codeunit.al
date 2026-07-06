codeunit 83925 "DocNoVisibility Subscr. TPTE"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::DocumentNoVisibility, OnBeforeSalesDocumentNoIsVisible, '', false, false)]
    local procedure OnBeforeSalesDocumentNoIsVisible(DocType: Option; DocNo: Code[20]; var IsVisible: Boolean; var IsHandled: Boolean)
    begin
        IsVisible := true;
        IsHandled := true;
    end;
}