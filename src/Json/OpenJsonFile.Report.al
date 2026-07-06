report 83850 "Open Json File TPTE"
{
    ApplicationArea = All;
    Caption = 'Open Json File';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(FileNameControl; FileName)
                    {
                        ApplicationArea = All;
                        Caption = 'Filename';
                        Editable = false;
                        ToolTip = 'Specifies the filepath to the json file.';

                        trigger OnAssistEdit()
                        var
                            SelectedFileName: Text;
                        begin
                            SelectedFileName := SelectFile();
                            if SelectedFileName <> '' then
                                FileName := SelectedFileName;
                        end;
                    }
                }
            }
        }
    }

    var
        JSONBuffer: Codeunit "Json Buffer TPTE";

    trigger OnPreReport()
    begin
        if FileName = '' then
            Error(EnterFileNameErr);
    end;

    trigger OnPostReport()
    begin
        ProcessJsonFile();
    end;

    var
        FileInStream: InStream;
        EnterFileNameErr: Label 'Please enter a filename.';
        FileName: Text;

    local procedure SelectFile(): Text
    begin
        exit(JSONBuffer.SelectFile(FileInStream));
    end;

    local procedure ProcessJsonFile()
    var
    begin
        JSONBuffer.Initialize();
        JSONBuffer.ReadFromStream();
        JSONBuffer.OpenJsonPage();
    end;

    // local procedure AddFileStream(var TempXMLBuffer: Record "XML Buffer" temporary)
    // var
    //     XmlOutStream: OutStream;
    // begin
    //     TempXMLBuffer.Init();
    //     TempXMLBuffer."Entry No." := 0;
    //     TempXMLBuffer.Depth := 0;
    //     TempXMLBuffer.Name := 'Xml Stream';
    //     TempXMLBuffer.Path := 'Stream';
    //     TempXMLBuffer."Value BLOB".CreateOutStream(XmlOutStream, TextEncoding::UTF8);
    //     CopyStream(XmlOutStream, FileInStream);
    //     TempXMLBuffer.Insert(false);
    // end;

    // local procedure LoadFromStream(var TempXMLBuffer: Record "XML Buffer" temporary)
    // begin
    //     TempXMLBuffer.LoadFromStream(FileInStream);
    // end;

    // local procedure OpenXMLPage(var TempXMLBuffer: Record "XML Buffer" temporary)
    // begin
    //     TempXMLBuffer.Reset();
    //     Page.Run(Page::"XML Buffer TPTE", TempXMLBuffer);
    // end;
}