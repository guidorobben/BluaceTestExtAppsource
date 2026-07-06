page 83864 "Base64 Converter TPTE"
{
    ApplicationArea = All;
    Caption = 'Base64 Converter';
    PageType = Card;
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Source';

                field(SourceTextControl; SourceText)
                {
                    Caption = 'Source Text';
                    MultiLine = true;
                    ShowCaption = false;
                }
            }
            // group(Translated)
            // {
            //     Caption = 'Translated';

            //     field(DestinationText; DestinationText)
            //     {
            //         Caption = 'Destination Text';
            //         MultiLine = true;
            //         ShowCaption = false;
            //     }
            // }
        }
    }

    actions
    {
        area(Processing)
        {
            action(OpenFile)
            {
                Caption = 'Select file';
                Image = Open;

                trigger OnAction()
                begin
                    SelectAndOpenFile();
                end;
            }
            action(ConvertToBase64)
            {
                Caption = 'To Base64';

                trigger OnAction()
                begin
                    SourceText := Base64Converter.ToBase64();
                    // Base64Convert.FromBase64(AttachedDataNode.AsXmlElement().InnerText, PdfOutStream);
                    // TempBlob.CreateOutStream(PdfOutStream);
                    // Base64Convert.FromBase64(Rec.GetValue(), PdfOutStream);
                    // TempBlob.CreateInStream(pdfInstream, TextEncoding::UTF8);

                    // // Rec."Attached Data".CreateInStream(XMLInstream, TextEncoding::UTF8);
                    // F := 'value.pdf';
                    // File.DownloadFromStream(pdfInstream, 'EXPORT', '', '', F);
                end;
            }
            // action(ConvertBase64)
            // {
            //     Caption = 'Convert Value (Base64)';

            //     trigger OnAction()
            //     var
            //         Base64Convert: Codeunit "Base64 Convert";
            //         TempBlob: Codeunit "Temp Blob";
            //         pdfInstream: InStream;
            //         PdfOutStream: OutStream;
            //         F: Text;
            //     begin
            //         // Base64Convert.FromBase64(AttachedDataNode.AsXmlElement().InnerText, PdfOutStream);
            //         TempBlob.CreateOutStream(PdfOutStream);
            //         Base64Convert.FromBase64(Rec.GetValue(), PdfOutStream);
            //         TempBlob.CreateInStream(pdfInstream, TextEncoding::UTF8);

            //         // Rec."Attached Data".CreateInStream(XMLInstream, TextEncoding::UTF8);
            //         F := 'value.pdf';
            //         File.DownloadFromStream(pdfInstream, 'EXPORT', '', '', F);
            //     end;
            // }
            // action(ShowValue)
            // {
            //     Caption = 'Show Value';

            //     trigger OnAction()
            //     begin
            //         ShowValues();
            //     end;
            // }
            // action(OpenStream)
            // {
            //     Caption = 'Open Stream';

            //     trigger OnAction()
            //     var
            //         ValueInstream: InStream;
            //         FileName: Text;
            //         ValueXmlDocument: XmlDocument;
            //     begin
            //         Rec.CalcFields("Value BLOB");
            //         Rec."Value BLOB".CreateInStream(ValueInstream);
            //         // FileName := StrSubstNo(FileTok, InboundPurchMessage."Entry No.");
            //         FileName := 'stream.xml';

            //         XmlDocument.ReadFrom(ValueInstream, ValueXmlDocument);
            //         DownloadFromStream(ValueInstream, '', '', '', FileName);
            //     end;

            // }
        }

        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(OpenXML_Promoted; OpenFile) { }
                // actionref(ExtractXmlAttachments_Promoted; ExtractXmlAttachments) { }
                // actionref(ConvertBase64_Promoted; ConvertBase64) { }
                // actionref(ShowValue_Promoted; ShowValue) { }
                // actionref(OpenStream_Promoted; OpenStream) { }
                // actionref(ExtractBase64XmlAttachment_Promoted; ExtractBase64XmlAttachment) { }
                actionref(ConvertToBase64_Promoted; ConvertToBase64) { }
            }
        }
    }

    var
        Base64Converter: Codeunit "Base64 Converter TPTE";
        DestinationText, SourceText : Text;

    // procedure AddBase64Attachment(TempXMLBufferAttachment: Record "XML Buffer Attachment TPTE" temporary)
    // var
    //     Base64Convert: Codeunit "Base64 Convert";
    //     DataOutStream: OutStream;
    //     RecValue: Text;
    //     xmldoc: XmlDocument;
    // begin
    //     RecValue := Rec.GetValue();
    //     RecValue := Base64Convert.FromBase64(RecValue);
    //     XmlDocument.ReadFrom(RecValue, xmldoc);

    //     TempXMLBufferAttachment."Attached Data".CreateOutStream(DataOutStream, TextEncoding::Windows);
    //     xmldoc.WriteTo(DataOutStream);
    //     AddAttachment(TempXMLBufferAttachment);
    // end;

    // procedure SetXmlDocument(XmlDoc: XmlDocument)
    // begin
    //     OpenXmlDoc := XmlDoc;
    // end;

    // local procedure ShowValues()
    // var
    //     DateValue: Date;
    //     DecimalValue: Decimal;
    //     IntegerValue: Integer;
    //     XMLValue: Text;
    // begin
    //     XMLValue := Rec.GetValue();
    //     if Evaluate(DecimalValue, XMLValue, 9) then; //
    //     if Evaluate(DateValue, XMLValue, 9) then; //
    //     if Evaluate(IntegerValue, XMLValue, 9) then; //
    //     // if Evaluate(DecimalValue, XMLValue, 9) then; //
    //     Message('XML: ' + XMLValue + '\' +
    //             'Decimal: ' + Format(DecimalValue) + '\' +
    //             'Integer: ' + Format(IntegerValue) + '\' +
    //             'Date: ' + Format(DateValue) + '\' +
    //             'Length: ' + Format(StrLen(XMLValue))
    //            );
    // end;

    local procedure SelectAndOpenFile()
    var
        FileInStream: InStream;
    begin
        Base64Converter.SelectFile(FileInStream);
        // Message(Base64Converter.ToBase64());
        ToBase64();
    end;

    local procedure ToBase64()
    begin
        SourceText := Base64Converter.ToBase64();
        Message(SourceText);
    end;
}