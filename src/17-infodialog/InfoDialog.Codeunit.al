codeunit 83858 "Info Dialog TPTE"
{
    Permissions =
        tabledata "Info Dialog TPTE" = rid;

    var
        InfoDialog: Record "Info Dialog TPTE";
        LastEntryNo: Integer;
        PageCaption: Text;

    procedure Initialize()
    begin
        LastEntryNo := 0;
        InfoDialog.DeleteAll(false);
    end;

    procedure Add(Name: Text[100])
    begin
        Add(Name, '', false, "Info Dialog Event Code TPTE"::" ");
    end;

    procedure Add(Name: Text; Value: Text[100])
    begin
        Add(Name, Value, false, "Info Dialog Event Code TPTE"::" ");
    end;

    procedure Add(Name: Text; Value: Integer)
    begin
        Add(Name, Format(Value), false, "Info Dialog Event Code TPTE"::" ");
    end;

    procedure Add(Name: Text[100]; Value: Boolean)
    begin
        Add(Name, Format(Value), false, "Info Dialog Event Code TPTE"::" ");
    end;

    procedure AddHeader(Name: Text[100])
    begin
        Add(Name, '', true, "Info Dialog Event Code TPTE"::" ");
    end;

    procedure Add(Name: Text; Value: Text[100]; Header: Boolean; EventCode: Enum "Info Dialog Event Code TPTE")
    begin
        CreateInfoBufferLine(Name, Value, Header, EventCode);
    end;

    procedure Add(Name: Text[100]; Value: Text[100]; EventCode: Enum "Info Dialog Event Code TPTE")
    begin
        Add(Name, Value, false, EventCode);
    end;

    procedure AddEmptyLine()
    begin
        Add('', '', false, "Info Dialog Event Code TPTE"::" ");
    end;

    procedure OpenInfoDialog()
    // var
    //     InfoBufferTPTE: Page "Info Buffer TPTE";
    begin
        InfoDialog.Reset();
        if InfoDialog.FindFirst() then; //Set pointer to first
        Page.Run(Page::"Info Dialog TPTE", InfoDialog);
        // InfoBufferTPTE.GetRecord(InfoBuffer); //FIXME
        // InfoBufferTPTE.SetRecord(InfoBuffer);
        // InfoBufferTPTE.SetTableView(InfoBuffer);
        // InfoBufferTPTE.Run();
    end;

    local procedure CreateInfoBufferLine(Name: Text; Value: Text[100]; Header: Boolean; EventCode: Enum "Info Dialog Event Code TPTE")
    var
        EntryNo: Integer;
    begin
        EntryNo := GetNewEntryNo();

        InfoDialog.Init();
        InfoDialog.Validate("Entry No.", EntryNo);
        InfoDialog.Validate(Name, CopyStr(Name, 1, MaxStrLen(InfoDialog.Name)));
        InfoDialog.Validate("Value", Value);
        InfoDialog.Validate(Header, Header);
        InfoDialog.Validate("Event Code", EventCode);
        InfoDialog.Insert(true);
    end;

    procedure SetCaption(CaptionText: Text)
    begin
        PageCaption := CaptionText;
    end;

    local procedure GetNewEntryNo(): Integer
    begin
        LastEntryNo += 1;
        exit(LastEntryNo);
    end;

    procedure TransferInfoDialog(var ToInfoDialog: Record "Info Dialog TPTE")
    begin
        if InfoDialog.FindSet() then
            repeat
                ToInfoDialog.Init();
                ToInfoDialog := InfoDialog;
                ToInfoDialog.Insert(false);
            until InfoDialog.Next() = 0;
    end;
}