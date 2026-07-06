page 83922 "Next Major Build Response TPTE"
{
    ApplicationArea = All;
    Caption = 'Next Major Build Response';
    PageType = List;
    SourceTable = "Next Major Build Response TPTE";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code) { }
                field(Description; Rec.Description) { }
                field("App Id"; Rec."App Id") { }
                field("Validation Date/Time"; Rec."Validation Date/Time") { }
                field("Target Release"; Rec."Target Release") { }
                field(Passed; Rec.Passed) { }
                field(Failed; Rec.Failed)
                {
                    Style = Attention;
                }
                field("Last Date"; Rec."Last Date/Time") { }
                field(Response; Rec.Response)
                {
                    Visible = false;
                }
                field("Error Text"; Rec."Error Text") { }
            }
            part("Next Major Build Resp. Su TPTE"; "Next Major Build Resp. Su TPTE")
            {
                SubPageLink = Code = field(Code);
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GetResponseOne)
            {

                Caption = 'Test One';

                trigger OnAction()
                begin
                    GetReadyForNextMajor(Rec."App Id");
                end;
            }
            action(GetResponseAll)
            {
                Caption = 'Test All';

                trigger OnAction()
                begin
                    if Rec.FindSet() then
                        repeat
                            GetReadyForNextMajor(Rec."App Id");
                        until Rec.Next() = 0;
                    Rec.FindFirst();
                end;
            }

        }

        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(GetResponseAll_Promoted; GetResponseAll) { }
                actionref(GetResponse_Promoted; GetResponseOne) { }
            }
        }
    }

    local procedure GetReadyForNextMajor(AppId: Text[100])
    var
        RestClient: Codeunit "Rest Client";
        // UrlLbl: Label 'https://aka.ms/readyfornextmajor?appid=%1', Comment = '%1=AppId';
        UrlTok: Label 'https://bcprodlatampartner.blob.core.windows.net/partner-results/appsourceappsvalidation/Latest/%1.json', Comment = '%1=AppId', Locked = true;

        ResponseContent: Text;
    begin
        ResponseContent := RestClient.Get(StrSubstNo(UrlTok, AppId)).GetContent().AsText();
        Rec.Response := ResponseContent;
        Rec.Validate("Last Date/Time", CurrentDateTime());
        ProcessResponse(Rec.Response);
        Rec.Modify(true);
    end;

    local procedure ProcessResponse(WebResponce: Text[1024])
    var
        TempJSONBuffer: Record "JSON Buffer" temporary;
        BlobNotFoundTok: Label 'BlobNotFound', Locked = true;
        PropertyValue: Text;
    begin
        if WebResponce.Contains(BlobNotFoundTok) then
            exit;

        TempJSONBuffer.ReadFromText(WebResponce);
        // JSONBuffer.SetRange();
        // page.RunModal(83900, JSONBuffer);

        TempJSONBuffer.GetPropertyValue(PropertyValue, 'Passed');
        Rec.Passed := PropertyValue;

        TempJSONBuffer.GetPropertyValue(PropertyValue, 'Failed');
        Rec.Failed := PropertyValue;

        TempJSONBuffer.GetPropertyValue(PropertyValue, 'TargetRelease');
        Rec."Target Release" := PropertyValue;

        TempJSONBuffer.GetPropertyValue(PropertyValue, 'ValidationDate');
        Rec."Validation Date/Time" := PropertyValue;
    end;
}