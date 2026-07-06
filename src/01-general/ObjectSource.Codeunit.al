codeunit 83857 "Object Source TPTE"
{
    procedure GetObjectSource(ObjectType: Integer; ObjectID: Integer) InstalledApp: Record "NAV App Installed App"
    var
        AllObj: Record AllObj;
    begin
        if not AllObj.Get(ObjectType, ObjectID) then
            exit;

        InstalledApp.SetRange("Package ID", AllObj."App Package ID");
        InstalledApp.FindFirst();
    end;

    procedure GetObjectInfo(ObjectType: Integer; ObjectID: Integer) AllObjWithCaption: Record AllObjWithCaption
    begin
        AllObjWithCaption.Get(ObjectType, ObjectID);
    end;
}