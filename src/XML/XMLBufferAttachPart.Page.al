page 83928 "XML Buffer Attach. Part TPTE"
{
    ApplicationArea = All;
    Caption = 'Attachments';
    PageType = ListPart;
    SourceTable = "XML Buffer Attachment TPTE";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    Visible = false;
                }
                field(Filename; Rec.Filename) { }
                field("File Type"; Rec."File Type") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ShowAttachment)
            {
                Caption = 'Show';

                trigger OnAction()
                begin
                    ViewAttachment(false);
                end;
            }
            action(DownloadAttachment)
            {
                Caption = 'Download';

                trigger OnAction()
                begin
                    ViewAttachment(true);
                end;
            }
        }
    }

    procedure AddAttachment(TempXMLBufferAttachment: Record "XML Buffer Attachment TPTE" temporary)
    begin
        Rec.Init();
        Rec."Entry No." := 1;
        Rec.Filename := TempXMLBufferAttachment.Filename;
        Rec."File Type" := TempXMLBufferAttachment."File Type";
        Rec."Attached Data" := TempXMLBufferAttachment."Attached Data";
        Rec.Insert(false);
    end;

    internal procedure ViewAttachment(Download: Boolean)
    var
        XMLInstream: InStream;
        ExportLbl: Label 'Export';
        NoValueErr: Label 'The BLOB field ''%1'' has no value.', Comment = '%1= FieldCaption';
        FileName2: Text;
    begin
        FileName2 := Rec.Filename;
        Rec.CalcFields("Attached Data");

        if not Rec."Attached Data".HasValue() then
            Error(NoValueErr, Rec.FieldCaption("Attached Data"));

        Rec."Attached Data".CreateInStream(XMLInstream, TextEncoding::UTF8);
        if Download then
            File.DownloadFromStream(XMLInstream, ExportLbl, '', '', FileName2)
        else
            File.ViewFromStream(XMLInstream, FileName2, true);
    end;
}