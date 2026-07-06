codeunit 83855 "Run Object Helper TPTE"
{
    Permissions = tabledata "Run Object History TPTE" = RIM;

    procedure RunTable(ObjectID: Integer)
    var
        PageManagement: Codeunit "Page Management";
        RunRecordRef: RecordRef;
    begin
        RunRecordRef.Open(ObjectID);
        PageManagement.PageRun(RunRecordRef);
    end;

    procedure SaveHistory(ObjectType: Option " ","Table",,"Report",,"Codeunit","XMLport",,"Page","Query"; ObjectID: Integer)
    var
        RunObjectHistory: Record "Run Object History TPTE";
        TypeHelper: Codeunit "Type Helper TPTE";
    begin
        RunObjectHistory.Init();
        RunObjectHistory."User ID" := TypeHelper.GetUserID();
        RunObjectHistory.Type := ObjectType;
        RunObjectHistory.ID := ObjectID;
        RunObjectHistory."Last Run" := Today();
        if not RunObjectHistory.Insert(false) then
            if RunObjectHistory.Modify(false) then; //On purpose
        Commit(); // Save
    end;

    procedure RunObject(CurrObjectType: Enum "Object Type TPTE"; ObjectID: Integer)
    begin
        case CurrObjectType of
            CurrObjectType::Table:
                RunTable(ObjectID);
            CurrObjectType::Report:
                Report.Run(ObjectID);
            CurrObjectType::Query:
                Hyperlink(GetUrl(ClientType::Current, CompanyName(), ObjectType::Query, ObjectID));
            CurrObjectType::XMLport:
                Xmlport.Run(ObjectID);
            CurrObjectType::Codeunit:
                Codeunit.Run(ObjectID);
            CurrObjectType::Page:
                Page.Run(ObjectID);
        end;
    end;

    procedure RunObject(CurrentObjectType: Option " ","Table",,"Report",,"Codeunit","XMLport",,"Page","Query"; ObjectID: Integer)
    // var
    //     NoQueriesErr: Label 'Queries are not supported.';
    begin
        case CurrentObjectType of
            CurrentObjectType::Table:
                RunTable(ObjectID);
            CurrentObjectType::Report:
                Report.Run(ObjectID);
            CurrentObjectType::Query:
                Hyperlink(GetUrl(ClientType::Current, CompanyName(), ObjectType::Query, ObjectID));
            CurrentObjectType::XMLport:
#pragma warning disable LC0005
                Xmlport.Run(ObjectID);
#pragma warning restore LC0005
            CurrentObjectType::Codeunit:
                Codeunit.Run(ObjectID);
            CurrentObjectType::Page:
                Page.Run(ObjectID);
        end;
    end;
}
