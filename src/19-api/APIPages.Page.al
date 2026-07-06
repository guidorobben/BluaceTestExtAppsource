page 83862 "API Pages TPTE"
{
    ApplicationArea = All;
    Caption = 'API Pages';
    Editable = false;
    PageType = List;
    SourceTable = "Page Metadata";
    SourceTableView = where(PageType = const(API));
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(APIPublisher; Rec.APIPublisher)
                {
                    ToolTip = 'Specifies the value of the APIPublisher field.', Comment = '%';
                }
                field(APIGroup; Rec.APIGroup)
                {
                    ToolTip = 'Specifies the value of the APIGroup field.', Comment = '%';
                }
                field(APIVersion; Rec.APIVersion)
                {
                    ToolTip = 'Specifies the value of the APIVersion field.', Comment = '%';
                }
                field(ID; Rec.ID)
                {
                    ToolTip = 'Specifies the value of the ID field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the page name.';
                }
                field(Caption; Rec.Caption)
                {
                    ToolTip = 'Specifies the value of the Caption field.', Comment = '%';
                }
                field(EntityName; Rec.EntityName)
                {
                    ToolTip = 'Specifies the value of the EntityName field.', Comment = '%';
                }
                field(EntitySetName; Rec.EntitySetName)
                {
                    ToolTip = 'Specifies the value of the EntitySetName field.', Comment = '%';
                }
                field("App ID"; Rec."App ID")
                {
                    ToolTip = 'Specifies the value of the App ID field.', Comment = '%';
                }
                field(AutoSplitKey; Rec.AutoSplitKey)
                {
                    ToolTip = 'Specifies the value of the AutoSplitKey field.', Comment = '%';
                }
                field(ChangeTrackingAllowed; Rec.ChangeTrackingAllowed)
                {
                    ToolTip = 'Specifies the value of the ChangeTrackingAllowed field.', Comment = '%';
                }
                field(DelayedInsert; Rec.DelayedInsert)
                {
                    ToolTip = 'Specifies the value of the DelayedInsert field.', Comment = '%';
                }
                field(DeleteAllowed; Rec.DeleteAllowed)
                {
                    ToolTip = 'Specifies the value of the DeleteAllowed field.', Comment = '%';
                }
                field(Editable; Rec.Editable)
                {
                    ToolTip = 'Specifies the value of the Editable field.', Comment = '%';
                }
                field(InherentEntitlements; Rec.InherentEntitlements)
                {
                    ToolTip = 'Specifies the value of the InherentEntitlements field.', Comment = '%';
                }
                field(InherentPermissions; Rec.InherentPermissions)
                {
                    ToolTip = 'Specifies the value of the InherentPermissions field.', Comment = '%';
                }
                field(InsertAllowed; Rec.InsertAllowed)
                {
                    ToolTip = 'Specifies the value of the InsertAllowed field.', Comment = '%';
                }
                field(LinksAllowed; Rec.LinksAllowed)
                {
                    ToolTip = 'Specifies the value of the LinksAllowed field.', Comment = '%';
                }
                field(ModifyAllowed; Rec.ModifyAllowed)
                {
                    ToolTip = 'Specifies the value of the ModifyAllowed field.', Comment = '%';
                }
                field(MultipleNewLines; Rec.MultipleNewLines)
                {
                    ToolTip = 'Specifies the value of the MultipleNewLines field.', Comment = '%';
                }
                field(PageType; Rec.PageType)
                {
                    ToolTip = 'Specifies the page type.';
                }
                field(PopulateAllFields; Rec.PopulateAllFields)
                {
                    ToolTip = 'Specifies the value of the PopulateAllFields field.', Comment = '%';
                }
                field(RefreshOnActivate; Rec.RefreshOnActivate)
                {
                    ToolTip = 'Specifies the value of the RefreshOnActivate field.', Comment = '%';
                }
                field(SaveValues; Rec.SaveValues)
                {
                    ToolTip = 'Specifies the value of the SaveValues field.', Comment = '%';
                }
                field(ShowFilter; Rec.ShowFilter)
                {
                    ToolTip = 'Specifies the value of the ShowFilter field.', Comment = '%';
                }
                field(SourceTable; Rec.SourceTable)
                {
                    ToolTip = 'Specifies the value of the SourceTable field.', Comment = '%';
                }
                field(SourceTableTemporary; Rec.SourceTableTemporary)
                {
                    ToolTip = 'Specifies the value of the SourceTableTemporary field.', Comment = '%';
                }
                field(SourceTableView; Rec.SourceTableView)
                {
                    ToolTip = 'Specifies the value of the SourceTableView field.', Comment = '%';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(WebURL)
            {
                Caption = 'Web URL';
                Image = Web;

                trigger OnAction()
                begin
                    ShowWebURL();
                end;
            }
            // action(DownloadMetaData)
            // {
            //     Caption = 'Download';

            //     trigger OnAction()
            //     begin
            //         // DownloadODataMetadataDocument();
            //     end;
            // }
        }
        area(Promoted)
        {

            actionref(WebURL_Promoted; WebURL) { }
        }
    }

    views
    {
        view(Bluace)
        {
            Caption = 'Bluace';
            Filters = where(APIPublisher = filter('@bluace'));
            SharedLayout = true;
        }
        view(Microsoft)
        {
            Caption = 'Microsoft';
            Filters = where(APIPublisher = filter('@microsoft'));
            SharedLayout = true;
        }
        view(v20)
        {
            Caption = 'v2.0';
            Filters = where(APIVersion = filter('@v2.0'));
            SharedLayout = true;
        }
        view(v10)
        {
            Caption = 'v1.0';
            Filters = where(APIVersion = filter('@v1.0'));
            SharedLayout = true;
        }
        view(beta)
        {
            Caption = 'Beta';
            Filters = where(APIVersion = filter('@beta'));
            SharedLayout = true;
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetFilter(EntityName, '<>%1', '');
    end;

    procedure DownloadODataMetadataDocument()
    var
        //     HttpWebRequestMgt: Codeunit "Http Web Request Mgt.";
        //     RestClient: Codeunit "Rest Client";
        MetadataTempBlob: Codeunit "Temp Blob";
        //     // HttpStatusCode: DotNet HttpStatusCode;
        //     // ResponseHeaders: DotNet NameValueCollection;
        ResponseInStream: InStream;
    //     ErrorStatusCodeReturnedErr: Label 'The request failed with status code: %1.', Comment = '%1 = a http status code, for example 401';
    //     FailedToSendRequestErr: Label 'The request could not be sent. Details: %1.', Comment = '%1 = a more detailed error message';
    //     MetadataFileNameTxt: Label 'metadata.xml', Locked = true;
    //     // MetadataFileNameTxt: Label 'metadata.xml', Locked = true;
    //     SaveFileDialogFilterMsg: Label 'XML Files (*.xml)|*.xml';
    //     SaveFileDialogTitleMsg: Label 'Save XML file';
    //     Endpoint: Text;
    //     FileName: Text;
    begin
        MetadataTempBlob.CreateInStream(ResponseInStream);

        //     if not CreateMetadataWebRequest(HttpWebRequestMgt, RestClient, Endpoint) then
        //         Error(FailedToSendRequestErr, GetLastErrorText());

        //     RestClient.Get(Endpoint);//.GetResponseMessage().HttpStatusCode

        //     // if not HttpWebRequestMgt.GetResponse(ResponseInStream, HttpStatusCode, ResponseHeaders) then
        //     //     Error(FailedToSendRequestErr, GetLastErrorText());

        //     // if not HttpStatusCode.Equals(HttpStatusCode.OK) then
        //     //     Error(ErrorStatusCodeReturnedErr, HttpStatusCode);

        //     FileName := MetadataFileNameTxt;
        //     DownloadFromStream(ResponseInStream, SaveFileDialogTitleMsg, '', SaveFileDialogFilterMsg, FileName);
    end;

    procedure CreateMetadataWebRequest(var HttpWebRequestMgt: Codeunit "Http Web Request Mgt."; var RestClient: Codeunit "Rest Client"; var Endpoint: Text): Boolean
    var
    //     AzureAdMgt: Codeunit "Azure AD Mgt.";
    //     EnvironmentInfo: Codeunit "Environment Information";
    //     UrlHelper: Codeunit "Url Helper";

    //     CorrelationId: Guid;
    //     BearerTokenTemplateTxt: Label 'Bearer %1', Locked = true;
    //     Token: SecretText;
    begin
        //     if not EnvironmentInfo.IsSaaS() then
        //         exit(false);

        Endpoint := GetUrl(ClientType::ODataV4) + '/$metadata';
        //     Token := GetAccessTokenAsSecretText(GetFixedEndpointWebServiceUrl(), '', false);
        //     if Token.IsEmpty() then begin
        //         // Session.LogMessage('0000E51', NoTokenForMetadataTelemetryErr, Verbosity::Normal, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Category', ODataUtilityTelemetryCategoryTxt);
        //         exit(false);
        //     end;

        //     CorrelationId := CreateGuid();
        //     // Session.LogMessage('0000E53', StrSubstNo(CallingEndpointTxt, Endpoint, CorrelationId), Verbosity::Normal, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Category', ODataUtilityTelemetryCategoryTxt);

        //     // HttpWebRequestMgt.Initialize(Endpoint);
        //     // HttpWebRequestMgt.SetMethod('GET');
        //     RestClient.Initialize();
        //     // RestClient.SetBaseAddress(Endpoint);
        //     RestClient.SetAuthorizationHeader(SecretStrSubstNo(BearerTokenTemplateTxt, Token));
        //     RestClient.SetDefaultRequestHeader('x-ms-correlation-id', CorrelationId);
        //     RestClient.SetUserAgentHeader('BusinessCentral/cod6170');
        //     // HttpWebRequestMgt.AddHeader('Authorization', SecretStrSubstNo(BearerTokenTemplateTxt, Token));
        //     // HttpWebRequestMgt.AddHeader('x-ms-correlation-id', CorrelationId);
        //     // HttpWebRequestMgt.SetUserAgent('BusinessCentral/cod6170');
        //     exit(true);
    end;

    // procedure GetFixedEndpointWebServiceUrl(): Text
    // begin

    //     //if IsPPE() then
    //     //    exit('https://api.businesscentral.dynamics-tie.com');
    //     //if IsTIE() then
    //     //    exit('https://api.businesscentral.dynamics-servicestie.com');
    //     //if IsPROD() then
    //     exit('https://api.businesscentral.dynamics.com');
    //     //exit('');
    // end;

    // procedure GetAccessTokenAsSecretText(ResourceUrl: Text; ResourceName: Text; ShowDialog: Boolean) AccessToken: SecretText
    // var
    //     AzureADMgt: Codeunit "Azure AD Mgt.";
    //     AzureADAccessDialog: Page "Azure AD Access Dialog";
    //     AuthorizationCode: SecretText;
    // begin
    //     // Does everything required to retrieve an access token for the given service, including
    //     // showing the Azure AD wizard and auth code retrieval form if necessary.
    //     if (not AzureADMgt.IsAzureADAppSetupDone()) and ShowDialog then begin
    //         Page.RunModal(Page::"Azure AD App Setup Wizard");
    //         if not AzureADMgt.IsAzureADAppSetupDone() then
    //             // Don't continue if user cancelled or errored out of the setup wizard.
    //             exit(AccessToken);
    //     end;

    //     if AzureADMgt.AcquireToken(ResourceUrl, AccessToken) then
    //         if not AccessToken.IsEmpty() then
    //             exit(AccessToken);

    //     if AzureADMgt.IsSaaS() then begin
    //         Clear(AccessToken);
    //         exit(AccessToken);
    //     end;

    //     if ShowDialog then
    //         AuthorizationCode := AzureADAccessDialog.GetAuthorizationCodeAsSecretText(ResourceUrl, ResourceName);
    //     if not AuthorizationCode.IsEmpty() then
    //         AccessToken := AzureADMgt.AcquireTokenByAuthorizationCodeAsSecretText(AuthorizationCode, ResourceUrl);
    // end;

    local procedure ShowWebURL()
    var
        EnvironmentInformation: Codeunit "Environment Information";
        APIUrlTok: Label 'https://api.businesscentral.dynamics.com/v2.0/%1/%2/api/%3/%4/%5/companies(<company guid>)/%6', Locked = true;
        URL: Text;
    begin
        // URL := 'https://api.businesscentral.dynamics.com/v2.0/';
        // URL += Database.TenantId() + '/' + EnvironmentInformation.GetEnvironmentName() + '/api/';
        // URL += Rec.APIPublisher + '/';
        // URL += Rec.APIGroup + '/';
        // URL += Rec.APIVersion + '/';
        // URL += 'companies(<company guid>)/';
        // URL += Rec.EntitySetName;
        URL := StrSubstNo(APIUrlTok, Database.TenantId(), EnvironmentInformation.GetEnvironmentName(), Rec.APIPublisher, Rec.APIGroup, Rec.APIVersion, Rec.EntitySetName);
        Message(URL);
    end;
}