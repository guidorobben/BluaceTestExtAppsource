codeunit 83939 "Appl. Area Helper TPTE"
{
    SingleInstance = true;

    var
        AreaEnabled: Boolean;
        CalledFromWizard: Boolean;

    procedure IsTechnicalManagementApplicationAreaEnabled(): Boolean
    var
        ApplicationAreaSetup: Record "Application Area Setup";
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
    begin
        if ApplicationAreaMgmtFacade.GetApplicationAreaSetupRecFromCompany(ApplicationAreaSetup, CompanyName()) then
            exit(ApplicationAreaSetup."Area CBLC");
    end;

    procedure RefreshExperienceTier()
    var
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
    begin
        ApplicationAreaMgmtFacade.RefreshExperienceTierCurrentCompany();
    end;

    procedure RegisterApplicationArea(var TempApplicationAreaSetup: Record "Application Area Setup" temporary)
    var
        Handled: Boolean;
    begin
        OnBeforeRegisterApplicationArea(TempApplicationAreaSetup, Handled);
        if Handled then
            exit;

        if CalledFromWizard then
            TempApplicationAreaSetup."Area CBLC" := AreaEnabled
        else
            TempApplicationAreaSetup."Area CBLC" := IsTechnicalManagementApplicationAreaEnabled();

        Clear(CalledFromWizard);

        TempApplicationAreaSetup.Manufacturing := true;
    end;

    procedure SetAreaEnabled(Enabled: Boolean)
    begin
        AreaEnabled := Enabled;
        CalledFromWizard := true;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeRegisterApplicationArea(var TempApplicationAreaSetup: Record "Application Area Setup" temporary; var Handled: Boolean)
    begin
    end;
}