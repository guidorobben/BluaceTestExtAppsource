codeunit 83880 "Feature Management TPTE"
{
    Permissions =
        tabledata "Feature Data Update Status" = R,
        tabledata "Feature Key" = RM;

    procedure EnableFeature(FeatureID: Text[50])
    var
        FeatureKey: Record "Feature Key";
    begin
        FeatureKey.Get(FeatureID);
        EnableFeature(FeatureKey);
    end;

    procedure EnableFeature(FeatureKey: Record "Feature Key")
    var
        FeatureDataUpdateStatus: Record "Feature Data Update Status";
    begin
        FeatureKey.Enabled := FeatureKey.Enabled::"All Users";
        FeatureKey.Modify(true);

        GetFeatureDataUpdateStatus(FeatureKey, FeatureDataUpdateStatus);
        FeatureDataUpdateStatus.Confirmed := true;

        if not Update(FeatureDataUpdateStatus) then
            Error('');
    end;

    local procedure GetFeatureDataUpdateStatus(FeatureKey: Record "Feature Key"; var FeatureDataUpdateStatus: Record "Feature Data Update Status")
    begin
        FeatureDataUpdateStatus.Get(FeatureKey.ID, CompanyName());
        //     if FeatureDataUpdateStatus."Background Task" then
        //         UpdateBackgroundTaskStatus(FeatureDataUpdateStatus);
        // end else
        //     InitializeFeatureDataUpdateStatus(FeatureKey, FeatureDataUpdateStatus, true);
    end;

    procedure Update(var FeatureDataUpdateStatus: Record "Feature Data Update Status"): Boolean
    begin
        if not FeatureDataUpdateStatus."Data Update Required" then
            exit(true);

        // if not ConfirmDataUpdate(FeatureDataUpdateStatus) then
        //     exit(false);

        // if FeatureDataUpdateStatus."Background Task" then
        //     exit(ScheduleTask(FeatureDataUpdateStatus));
        Codeunit.Run(Codeunit::"Update Feature Data", FeatureDataUpdateStatus);
        exit(true);
    end;
}