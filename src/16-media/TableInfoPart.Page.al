page 83853 "Table Info. Part TPTE"
{
    ApplicationArea = All;
    Caption = 'Table Info. Part';
    PageType = CardPart;
    SourceTable = AllObjWithCaption;
    SourceTableView = where("Object Type" = const(Table));

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Object ID"; Rec."Object ID")
                {
                    ToolTip = 'Specifies the Object ID.';
                }
                field("Object Name"; Rec."Object Name")
                {
                    ToolTip = 'Specifies the Object Name.';
                }
                field(RecordCountrControl; RecordCount)
                {
                    Caption = 'Record Count';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Open)
            {
                Caption = 'Open';
                Image = List;

                trigger OnAction()
                var
                    PageManagement: Codeunit "Page Management";
                    TableRecordRef: RecordRef;
                begin
                    TableRecordRef.Open(Rec."Object ID");
                    PageManagement.PageRun(TableRecordRef);
                end;
            }
        }
    }

    var
        RecordCount: Integer;

    trigger OnAfterGetCurrRecord()
    begin
        OpenTable();
    end;

    [TryFunction]
    local procedure OpenTable()
    var
        TableRecordRef: RecordRef;
    begin
        TableRecordRef.Open(Rec."Object ID");
        RecordCount := TableRecordRef.Count();
    end;
}
