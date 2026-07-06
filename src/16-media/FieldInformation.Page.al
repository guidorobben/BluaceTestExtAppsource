page 83851 "Field Information TPTE"
{
    ApplicationArea = All;
    Caption = 'Field Information';
    Editable = false;
    PageType = List;
    SourceTable = "Field";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(TableNo; Rec.TableNo)
                {
                    ToolTip = 'Specifies the table number.';
                }
                field(TableName; Rec.TableName)
                {
                    ToolTip = 'Specifies the name of the table.';
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the ID number of the field in the table.';
                }
                field(FieldName; Rec.FieldName)
                {
                    ToolTip = 'Specifies the name of the field in the table.';
                }
                field("Field Caption"; Rec."Field Caption")
                {
                    ToolTip = 'Specifies the caption of the field, that is, the name that will be shown in the user interface.';
                }
                field(Enabled; Rec.Enabled)
                {
                    ToolTip = 'Specifies the value of the Enabled field.', Comment = '%';
                }
                field(Class; Rec.Class)
                {
#pragma warning disable AC0017
                    ToolTip = 'Specifies the type of class. Normal is data entry, FlowFields calculate and display results immediately, and FlowFilters display results based on user-defined filter values that affect the calculation of a FlowField.';
#pragma warning restore AC0017
                }
                field(Type; Rec."Type")
                {
                    ToolTip = 'Specifies the type of the field in the table, which indicates the type of data it contains.';
                }
                field("Type Name"; Rec."Type Name")
                {
                    ToolTip = 'Specifies the type of data.';
                }
                field(OptionString; Rec.OptionString)
                {
                    ToolTip = 'Specifies the option string.';
                }
                field(DataClassification; Rec.DataClassification)
                {
                    ToolTip = 'Specifies the data classification.';
                }
                field(RelationTableNo; Rec.RelationTableNo)
                {
                    ToolTip = 'Specifies the ID number of a table from which the field on the current table gets data. For example, the field can provide a lookup into another table.';
                }
                field(RelationFieldNo; Rec.RelationFieldNo)
                {
                    ToolTip = 'Specifies the value of the RelationFieldNo field.', Comment = '%';
                }
                field(ExternalName; Rec.ExternalName)
                {
                    ToolTip = 'Specifies the value of the ExternalName field.', Comment = '%';
                }
                field(IsPartOfPrimaryKey; Rec.IsPartOfPrimaryKey)
                {
                    ToolTip = 'Specifies the value of the IsPartOfPrimaryKey field.', Comment = '%';
                }
                field(Len; Rec.Len)
                {
                    ToolTip = 'Specifies the value of the Len field.', Comment = '%';
                }
                field(ObsoleteReason; Rec.ObsoleteReason)
                {
                    ToolTip = 'Specifies the value of the ObsoleteReason field.', Comment = '%';
                }
                field(ObsoleteState; Rec.ObsoleteState)
                {
                    ToolTip = 'Specifies the value of the ObsoleteState field.', Comment = '%';
                }
                field(SQLDataType; Rec.SQLDataType)
                {
                    ToolTip = 'Specifies the value of the SQLDataType field.', Comment = '%';
                }
                field("App Package ID"; Rec."App Package ID")
                {
                    ToolTip = 'Specifies the value of the App Package ID field.', Comment = '%';
                }
                field("App Runtime Package ID"; Rec."App Runtime Package ID")
                {
                    ToolTip = 'Specifies the value of the App Runtime Package ID field.', Comment = '%';
                }
            }

        }

        area(FactBoxes)
        {
            part(FieldInformation; "Field Info. Part TPTE")
            {
                SubPageLink = TableNo = field(TableNo), "No." = field("No.");
            }
            part("Table Info. Part TPTE"; "Table Info. Part TPTE")
            {
                SubPageLink = "Object ID" = field(TableNo);
            }
        }
    }

    views
    {
        view(MediaSet)
        {
            Caption = 'Media';
            Filters = where(Type = filter(Media | MediaSet));
            SharedLayout = true;
        }
        view(Obsolete)
        {
            Caption = 'Obsolete';
            Filters = where(ObsoleteState = filter(<> No));
            SharedLayout = true;
        }
    }
}
