page 83863 "API Queries TPTE"
{
    ApplicationArea = All;
    Caption = 'API Queries';
    Editable = false;
    PageType = List;
    SourceTable = "Query Metadata";
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
                field(APIVersion; Rec.APIVersion)
                {
                    ToolTip = 'Specifies the value of the APIVersion field.', Comment = '%';
                }
                field(APIGroup; Rec.APIGroup)
                {
                    ToolTip = 'Specifies the value of the APIGroup field.', Comment = '%';
                }
                field("App ID"; Rec."App ID")
                {
                    ToolTip = 'Specifies the value of the App ID field.', Comment = '%';
                }
                field(InherentEntitlements; Rec.InherentEntitlements)
                {
                    ToolTip = 'Specifies the value of the InherentEntitlements field.', Comment = '%';
                }
                field(InherentPermissions; Rec.InherentPermissions)
                {
                    ToolTip = 'Specifies the value of the InherentPermissions field.', Comment = '%';
                }
            }
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
}