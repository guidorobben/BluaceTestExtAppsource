page 83859 "Pages Overview TPTE"
{
    ApplicationArea = All;
    Caption = 'Pages Overview';
    Editable = false;
    PageType = List;
    SourceTable = "Page Metadata";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(ID; Rec.ID)
                {
                    ToolTip = 'Specifies the value of the ID field.', Comment = '%';
                }
                field(Caption; Rec.Caption)
                {
                    ToolTip = 'Specifies the value of the Caption field.', Comment = '%';
                }
                field(SourceTable; Rec.SourceTable)
                {
                    ToolTip = 'Specifies the value of the SourceTable field.', Comment = '%';
                }
                field(EntitySetName; Rec.EntitySetName)
                {
                    ToolTip = 'Specifies the value of the EntitySetName field.', Comment = '%';
                }
                field(EntityName; Rec.EntityName)
                {
                    ToolTip = 'Specifies the value of the EntityName field.', Comment = '%';
                }
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

            }
        }
    }

    views
    {
        view(APIPages)
        {
            Caption = 'API Pages';
            Filters = where(PageType = filter(API));
            SharedLayout = true;
        }
    }
}