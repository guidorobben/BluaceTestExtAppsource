codeunit 83878 "Report Management Subscr. TPTE"
{
    Access = Internal;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, OnGetFilename, '', false, false)]
    local procedure OnGetFilename(ReportID: Integer; Caption: Text[250]; FileExtension: Text[30]; ReportRecordRef: RecordRef; var Filename: Text; var Success: Boolean)
    begin
        case ReportID of
            Report::"Standard Sales - Invoice":
                begin
                    Filename := Format(ReportRecordRef.RecordId()) + '_' + Caption + '.' + FileExtension;
                    Success := true;
                end;
        end;
    end;
}