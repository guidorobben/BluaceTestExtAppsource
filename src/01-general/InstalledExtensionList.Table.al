table 83858 "Installed Extension List TPTE"
{
    Caption = 'Installed Extension List';
    DataClassification = CustomerContent;
    Permissions =
        tabledata "Installed Extension List TPTE" = RID,
        tabledata "NAV App Installed App" = R;
    TableType = Temporary;

    fields
    {
        field(1; "App ID"; Guid)
        {
            Caption = 'App ID';
            Editable = false;
        }
        field(2; "Package ID"; Guid)
        {
            Caption = 'Package ID';
            Editable = false;
        }
        field(3; Name; Text[250])
        {
            Caption = 'Name';
            Editable = false;
        }
        field(4; Publisher; Text[250])
        {
            Caption = 'Publisher';
            Editable = false;
        }
        field(5; "Version Major"; Integer)
        {
            Caption = 'Version Major';
        }
        field(6; "Version Minor"; Integer)
        {
            Caption = 'Version Minor';
        }
        field(7; "Version Build"; Integer)
        {
            Caption = 'Version Build';
        }
        field(8; "Version Revision"; Integer)
        {
            Caption = 'Version Revision';
        }
        field(16; "Published As"; Option)
        {
            Caption = 'Published As';
            OptionCaption = 'Global, PTE, Dev';
            OptionMembers = Global,PTE,Dev;
        }
        field(50000; "Select App Record"; Boolean)
        {
            Caption = 'Select App Record';
            Editable = true;
        }
    }
    keys
    {
        key(PK; "App ID")
        {
            Clustered = true;
        }
        key(Name; Name) { }
    }

    internal procedure ClearInstalledApps()
    begin
        Rec.Reset();
        Rec.DeleteAll(false);
    end;

    internal procedure GetInstalledApps()
    var
        NAVAppInstalledApp: Record "NAV App Installed App";
        IsMicrosoftExtTxt: Label 'Microsoft', Locked = true;
    begin
        NAVAppInstalledApp.Reset();
        if NAVAppInstalledApp.FindSet(false) then
            repeat
                if NAVAppInstalledApp.Publisher <> IsMicrosoftExtTxt then begin
                    Rec.Init();
                    Rec.TransferFields(NAVAppInstalledApp, true);
                    Rec.Validate("Select App Record", false);
                    Rec.Insert(false);
                end;
            until NAVAppInstalledApp.Next() = 0;
    end;

    internal procedure UninstallApp()
    var
        ConfirmMgt: Codeunit "Confirm Management";
        ExtensionManagement: Codeunit "Extension Management";
        DeleteAppDateQst: Label 'Do you want to Clear the Extension Data?';
        UnistallQst: Label 'Are you sure you want to Uninstall %1 by %2 ?', Comment = '%1 is the Extension Name, %2 is the Publisher';
    begin
        Rec.Reset();
        Rec.SetRange("Select App Record", true);
        if Rec.FindSet(false) then
            repeat
                CheckIfMicrosoftExt(Rec);
                CheckPublishType(Rec);
                Clear(ExtensionManagement);
                if not ConfirmMgt.GetResponse(StrSubstNo(UnistallQst, Rec.Name, Rec.Publisher), false) then
                    exit;

                if ConfirmMgt.GetResponse(DeleteAppDateQst, false) then begin
                    if not ExtensionManagement.UninstallExtensionAndDeleteExtensionData(Rec."Package ID", false) then
                        Message(GetLastErrorText());
                end else
                    if not ExtensionManagement.UninstallExtension(Rec."Package ID", false) then
                        Message(GetLastErrorText());
            until Rec.Next() = 0;
    end;

    internal procedure UnPublishApp()
    var
        ConfirmMgt: Codeunit "Confirm Management";
        ExtensionManagement: Codeunit "Extension Management";
        UnPublishQst: Label 'Do you want to UnPublish %1 %3 ?', Comment = '%1 is the Extension Name, %2 is the Publisher';
    begin
        Rec.Reset();
        Rec.SetRange("Select App Record", true);
        if Rec.FindSet(false) then
            repeat
                CheckIfMicrosoftExt(Rec);
                Clear(ExtensionManagement);
                if not ConfirmMgt.GetResponse(StrSubstNo(UnPublishQst, Rec.Name, Rec.Publisher), false) then
                    exit;
                if not ExtensionManagement.UnpublishExtension(Rec."Package ID") then
                    Message(GetLastErrorText());
            until Rec.Next() = 0;
    end;

    internal procedure DownloadAppSourceFile(var InstalledExtensionList: Record "Installed Extension List TPTE" temporary)
    var
        ExtensionManagement: Codeunit "Extension Management";
    begin
        ExtensionManagement.DownloadExtensionSource(InstalledExtensionList."Package ID");
    end;

    internal procedure GetExtensionSource(InstalledExtensionList: Record "Installed Extension List TPTE" temporary)
    var
        DataCompression: Codeunit "Data Compression";
        ExtensionManagement: Codeunit "Extension Management";
        ExtensionSourceTempBlob: Codeunit "Temp Blob";
        AppFileInStream: InStream;
        ZipInStream: InStream;
        AppFileOutStream: OutStream;
        ZipOutStream: OutStream;
        FullFileName: Text;
        ZipFileName: Text[50];
    begin
        ZipFileName := 'AppFiles_.zip';
        DataCompression.CreateZipArchive();
        InstalledExtensionList.Reset();
        InstalledExtensionList.SetRange("Select App Record", true);
        if InstalledExtensionList.FindSet(false) then
            repeat
                ExtensionSourceTempBlob.CreateOutStream(AppFileOutStream);
                ExtensionManagement.GetExtensionSource(InstalledExtensionList."Package ID", ExtensionSourceTempBlob);
                ExtensionSourceTempBlob.CreateInStream(AppFileInStream);
                FullFileName := InstalledExtensionList.Name + '.app';
                DataCompression.AddEntry(AppFileInStream, FullFileName);
            until InstalledExtensionList.Next() = 0;

        ExtensionSourceTempBlob.CreateOutStream(ZipOutStream);
        DataCompression.SaveZipArchive(ZipOutStream);
        ExtensionSourceTempBlob.CreateInStream(ZipInStream);
        DownloadFromStream(ZipInStream, '', '', '', ZipFileName);
    end;

    internal procedure CreateDependecyMessage()
    var
        RecordProcessed, RecordsFound : Integer;
        BuildTxt: Text;
        DependecyMsg: Text;
    begin
        DependecyMsg := '';
        RecordsFound := 0;
        RecordProcessed := 0;
        BuildTxt := '{\' +
                    '"id": "%1",\' +
                    '"name": "%2",\' +
                    '"version": "%3",\' +
                    '"publisher": "%4"\' +
                    '}';
        Rec.Reset();
        Rec.SetRange("Select App Record", true);
        if Rec.FindSet(false) then begin
            RecordsFound := Rec.Count();
            repeat
                DependecyMsg := DependecyMsg + StrSubstNo(BuildTxt, RemoveSpecialChar(Rec."App ID"),
                                                          Rec.Name,
                                                          GetAppVersion(Rec),
                                                          Rec.Publisher);
                RecordProcessed += 1;
                if RecordProcessed < RecordsFound then
                    DependecyMsg := DependecyMsg + ',\';
            until Rec.Next() = 0;
        end;

        if DependecyMsg <> '' then
            Message(DependecyMsg);
    end;

    local procedure CheckIfMicrosoftExt(InstalledExtensionList: Record "Installed Extension List TPTE" temporary)
    var
        IsMicrosoftExtErr: Label 'Can not uninstall a Microsoft extension', Locked = true;
        IsMicrosoftExtLbl: Label 'Microsoft', Locked = true;
    begin
        if InstalledExtensionList.Publisher = IsMicrosoftExtLbl then
            Error(IsMicrosoftExtErr);
    end;

    local procedure CheckPublishType(InstalledExtensionList: Record "Installed Extension List TPTE" temporary)
    var
        IsNotPTEErr: Label 'Can not uninstall an extension of type %1', Locked = true;
    begin
        if InstalledExtensionList."Published As" = InstalledExtensionList."Published As"::Global then
            Error(IsNotPTEErr, Format(InstalledExtensionList."Published As"));
    end;

    local procedure GetAppVersion(InstalledExtensionList: Record "Installed Extension List TPTE" temporary): Text
    var
        AppVersion: Text;
    begin
        AppVersion := Format(InstalledExtensionList."Version Major") + '.' +
                      Format(InstalledExtensionList."Version Minor") + '.' +
                      Format(InstalledExtensionList."Version Build") + '.' +
                      Format(InstalledExtensionList."Version Revision");
        exit(AppVersion);
    end;

    local procedure RemoveSpecialChar(p_AppID: Text): Text
    var
        AppID: Text;
    begin
        AppID := p_AppID;
        AppID := DelChr(AppID, '=', '{');
        AppID := DelChr(AppID, '=', '}');
        exit(AppID);
    end;
}