page 83856 "Object Source TPTE"
{
    ApplicationArea = All;
    Caption = 'Object Source';
    PageType = Card;
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(ObjectTypeControl; ObjectType)
                {
                    Caption = 'Object Type';
                    OptionCaption = ' ,Table,,Report,,Codeunit,XMLport,,Page,Query', Comment = ',Table,,Report,,Codeunit,XMLport,,Page,Query';
                }
                field(ObjectIDControl; ObjectID)
                {
                    Caption = 'Object ID';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        OnLookupObject();
                    end;
                }
            }
            part(InfoDialogPart; "Info Dialog Part TPTE") { }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Run)
            {
                Caption = 'Object Info';
                Image = Info;

                trigger OnAction()
                begin
                    GetObjectSourceInfo();
                end;
            }
        }
        area(Promoted)
        {
            actionref(Run_Promoted; Run) { }
        }
    }

    var
        ObjectSource: Codeunit "Object Source TPTE";
        ObjectID: Integer;
        ObjectType: Option " ","Table",,"Report",,"Codeunit","XMLport",,"Page","Query";

    local procedure OnLookupObject()
    var
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        AllObjWithCaption.SetRange("Object Type", ObjectType);
        if Page.RunModal(Page::"All Objects with Caption", AllObjWithCaption) = Action::LookupOK then
            ObjectID := AllObjWithCaption."Object ID";
    end;

    local procedure ShowNAVAppInstalled(var AllObjWithCaption: Record AllObjWithCaption; var NAVAppInstalledApp: Record "NAV App Installed App")
    var
        InfoDialog: Codeunit "Info Dialog TPTE";
    begin
        InfoDialog.Initialize();
        InfoDialog.AddHeader('Object');
        InfoDialog.Add(AllObjWithCaption.FieldCaption("Object Type"), Format(AllObjWithCaption."Object Type"));
        InfoDialog.Add(AllObjWithCaption.FieldCaption("Object ID"), AllObjWithCaption."Object ID");
        InfoDialog.Add(AllObjWithCaption.FieldCaption("Object Name"), AllObjWithCaption."Object Name");
        InfoDialog.Add(AllObjWithCaption.FieldCaption("App Package ID"), AllObjWithCaption."App Package ID");
        InfoDialog.AddEmptyLine();
        InfoDialog.AddHeader('App');
        InfoDialog.Add(NAVAppInstalledApp.FieldCaption("Package ID"), NAVAppInstalledApp."Package ID");
        InfoDialog.Add(NAVAppInstalledApp.FieldCaption("App ID"), NAVAppInstalledApp."App ID");
        InfoDialog.Add(NAVAppInstalledApp.FieldCaption(Name), NAVAppInstalledApp.Name);
        InfoDialog.Add(NAVAppInstalledApp.FieldCaption(Publisher), NAVAppInstalledApp.Publisher);
        InfoDialog.Add(NAVAppInstalledApp.FieldCaption("Published As"), Format(NAVAppInstalledApp."Published As"));
        InfoDialog.Add(NAVAppInstalledApp.FieldCaption("Version Major"), NAVAppInstalledApp."Version Major");
        InfoDialog.Add(NAVAppInstalledApp.FieldCaption("Version Minor"), NAVAppInstalledApp."Version Minor");
        InfoDialog.Add(NAVAppInstalledApp.FieldCaption("Version Revision"), NAVAppInstalledApp."Version Revision");
        InfoDialog.Add(NAVAppInstalledApp.FieldCaption("Version Build"), NAVAppInstalledApp."Version Build");
        CurrPage.InfoDialogPart.Page.ShowData(InfoDialog);
    end;

    local procedure GetObjectSourceInfo()
    var
        AllObjWithCaption: Record AllObjWithCaption;
        NAVAppInstalledApp: Record "NAV App Installed App";
    begin
        NAVAppInstalledApp := ObjectSource.GetObjectSource(ObjectType, ObjectID);
        if NAVAppInstalledApp.Name = '' then
            exit;
        AllObjWithCaption := ObjectSource.GetObjectInfo(ObjectType, ObjectID);

        ShowNAVAppInstalled(AllObjWithCaption, NAVAppInstalledApp);
    end;
}
