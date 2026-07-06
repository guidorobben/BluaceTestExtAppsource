page 83911 "Open XML TPTE"
{
    ApplicationArea = All;
    Caption = 'Open XML';
    Editable = false;
    PageType = Worksheet;
    ShowFilter = true;
    SourceTable = "XML Buffer";
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field(Depth; Rec.Depth)
                {
                    ToolTip = 'Specifies the value of the Depth field.';
                }
                field("Data Type"; Rec."Data Type")
                {
                    ToolTip = 'Specifies the value of the Data Type field.';
                }
                field("Import ID"; Rec."Import ID")
                {
                    ToolTip = 'Specifies the value of the Import ID field.';
                    Visible = false;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the name of the imported record.';
                }
                field("Node Number"; Rec."Node Number")
                {
                    ToolTip = 'Specifies the value of the Node Number field.';
                }
                field("Parent Entry No."; Rec."Parent Entry No.")
                {
                    ToolTip = 'Specifies the value of the Parent Entry No. field.';
                }
                field(Namespace; Rec.Namespace)
                {
                    ToolTip = 'Specifies the value of the Namespace field.';
                }
                field(Path; Rec.Path)
                {
                    ToolTip = 'Specifies the value of the Path field.';
                }
                field(Type; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(Value; Rec."Value")
                {
                    ToolTip = 'Specifies the value of the imported record.';
                }
                field("Value BLOB"; Rec."Value BLOB".HasValue())
                {
                    Caption = 'BLOB Value';
                    ToolTip = 'Specifies the value of the Value BLOB field.';
                }
            }
        }
        area(FactBoxes)
        {
            part(XMLBufferAttachments; "XML Buffer Attach. Part TPTE") { }
        }
    }

    actions
    {
        area(Processing)
        {
            action(OpenXML)
            {
                Caption = 'Open XML';
                Image = Open;

                trigger OnAction()
                begin
                    SelectAndOpenXMLFile();
                end;
            }
            action(ExtractXmlAttachments)
            {
                Caption = 'Extract Attachments';
                Image = Attachments;

                trigger OnAction()
                begin
                    ExtractAttachments();
                end;
            }
            action(ExtractBase64XmlAttachment)
            {
                Caption = 'Extract Base64 Attachment';
                Image = Attachments;

                trigger OnAction()
                begin
                    ExtractBase64Attachment();
                end;
            }
            action(ConvertBase64)
            {
                Caption = 'Convert Value (Base64)';

                trigger OnAction()
                var
                    Base64Convert: Codeunit "Base64 Convert";
                    TempBlob: Codeunit "Temp Blob";
                    pdfInstream: InStream;
                    PdfOutStream: OutStream;
                    F: Text;
                begin
                    // Base64Convert.FromBase64(AttachedDataNode.AsXmlElement().InnerText, PdfOutStream);
                    TempBlob.CreateOutStream(PdfOutStream);
                    Base64Convert.FromBase64(Rec.GetValue(), PdfOutStream);
                    TempBlob.CreateInStream(pdfInstream, TextEncoding::UTF8);

                    // Rec."Attached Data".CreateInStream(XMLInstream, TextEncoding::UTF8);
                    F := 'value.pdf';
                    File.DownloadFromStream(pdfInstream, 'EXPORT', '', '', F);
                end;
            }
            action(ShowValue)
            {
                Caption = 'Show Value';

                trigger OnAction()
                begin
                    ShowValues();
                end;
            }
            action(OpenStream)
            {
                Caption = 'Open Stream';

                trigger OnAction()
                var
                    ValueInstream: InStream;
                    FileName: Text;
                    ValueXmlDocument: XmlDocument;
                begin
                    Rec.CalcFields("Value BLOB");
                    Rec."Value BLOB".CreateInStream(ValueInstream);
                    // FileName := StrSubstNo(FileTok, InboundPurchMessage."Entry No.");
                    FileName := 'stream.xml';

                    XmlDocument.ReadFrom(ValueInstream, ValueXmlDocument);
                    DownloadFromStream(ValueInstream, '', '', '', FileName);
                end;

            }
        }

        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(OpenXML_Promoted; OpenXML) { }
                actionref(ExtractXmlAttachments_Promoted; ExtractXmlAttachments) { }
                actionref(ConvertBase64_Promoted; ConvertBase64) { }
                actionref(ShowValue_Promoted; ShowValue) { }
                actionref(OpenStream_Promoted; OpenStream) { }
                actionref(ExtractBase64XmlAttachment_Promoted; ExtractBase64XmlAttachment) { }
            }
        }
    }

    var
        OpenXMLFile: Codeunit "Open XML File TPTE";
        OpenXmlDoc: XmlDocument;

    local procedure ExtractAttachments()
    var
        TempXMLBufferAttachment: Record "XML Buffer Attachment TPTE" temporary;
    begin
        TempXMLBufferAttachment.Init();
        TempXMLBufferAttachment.Filename := 'File.pdf';
        TempXMLBufferAttachment."File Type" := 'pdf';

        AddAttachment(TempXMLBufferAttachment);
    end;

    local procedure ExtractBase64Attachment()
    var
        TempXMLBufferAttachment: Record "XML Buffer Attachment TPTE" temporary;
    begin
        TempXMLBufferAttachment.Init();
        TempXMLBufferAttachment.Filename := 'Base64.xml';
        TempXMLBufferAttachment."File Type" := 'xml';

        AddBase64Attachment(TempXMLBufferAttachment);
    end;

    procedure AddBase64Attachment(TempXMLBufferAttachment: Record "XML Buffer Attachment TPTE" temporary)
    var
        Base64Convert: Codeunit "Base64 Convert";
        DataOutStream: OutStream;
        RecValue: Text;
        xmldoc: XmlDocument;
    begin
        RecValue := Rec.GetValue();
        RecValue := Base64Convert.FromBase64(RecValue);
        XmlDocument.ReadFrom(RecValue, xmldoc);

        TempXMLBufferAttachment."Attached Data".CreateOutStream(DataOutStream, TextEncoding::Windows);
        xmldoc.WriteTo(DataOutStream);
        AddAttachment(TempXMLBufferAttachment);
    end;

    procedure AddAttachment(TempXMLBufferAttachment: Record "XML Buffer Attachment TPTE" temporary)
    begin
        CurrPage.XMLBufferAttachments.Page.AddAttachment(TempXMLBufferAttachment);
    end;

    procedure SetXmlDocument(XmlDoc: XmlDocument)
    begin
        OpenXmlDoc := XmlDoc;
    end;

    local procedure ShowValues()
    var
        DateValue: Date;
        DecimalValue: Decimal;
        IntegerValue: Integer;
        XMLValue: Text;
    begin
        XMLValue := Rec.GetValue();
        if Evaluate(DecimalValue, XMLValue, 9) then; //
        if Evaluate(DateValue, XMLValue, 9) then; //
        if Evaluate(IntegerValue, XMLValue, 9) then; //
        // if Evaluate(DecimalValue, XMLValue, 9) then; //
        Message('XML: ' + XMLValue + '\' +
                'Decimal: ' + Format(DecimalValue) + '\' +
                'Integer: ' + Format(IntegerValue) + '\' +
                'Date: ' + Format(DateValue) + '\' +
                'Length: ' + Format(StrLen(XMLValue))
               );
    end;

    local procedure SelectAndOpenXMLFile()
    var
        FileInStream: InStream;
    begin
        OpenXMLFile.Initialize();
        OpenXMLFile.SelectFile(FileInStream);
        OpenXMLFile.LoadFromStream(Rec);
        // OpenXMLFile.AddFileStream();
    end;
}