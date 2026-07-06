report 83907 "Open XML File TPTE"
{
    ApplicationArea = All;
    Caption = 'Open XML File';
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
                        ToolTip = 'Specifies the filepath to the xml file.';

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
        OpenXMLFile: Codeunit "Open XML File TPTE";

    trigger OnPreReport()
    begin
        if FileName = '' then
            Error(EnterFileNameErr);
    end;

    trigger OnPostReport()
    begin
        ProcessXMLFile();
    end;

    var
        FileInStream: InStream;
        EnterFileNameErr: Label 'Please enter a filename.';
        FileName: Text;

    local procedure SelectFile(): Text
    begin
        exit(OpenXMLFile.SelectFile(FileInStream));
    end;

    local procedure ProcessXMLFile()
    begin
        OpenXMLFile.Initialize();
        OpenXMLFile.LoadFromStream();
        OpenXMLFile.AddFileStream();
        OpenXMLFile.OpenXMLPage();
    end;
}
