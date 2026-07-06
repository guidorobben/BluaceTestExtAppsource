codeunit 83877 "Json Buffer TPTE"
{
    var
        TempJSONBuffer: Record "JSON Buffer" temporary;

        SelectedInstream: InStream;
        // GlobalEntryNo: Integer;
        SelectedFilePath: Text;

    procedure Initialize()
    begin

    end;

    procedure SelectFile(var FileInStream: InStream): Text
    var
        AppFileFilterTxt: Label 'Yaml Source File (*.yml)|*.yml';
        FilePath: Text;
    begin
        UploadIntoStream('Select File', '', AppFileFilterTxt, FilePath, FileInStream);
        SelectedInstream := FileInStream;
        SelectedFilePath := FilePath;
        exit(FilePath);
    end;

    procedure ReadFromStream()
    var
        JsonText: Text;
    // TempBlob: Codeunit "Temp Blob";
    begin
        SelectedInstream.Read(JsonText);
        TempJSONBuffer.ReadFromText(JsonText);
    end;

    procedure OpenJsonPage()
    begin
        TempJSONBuffer.Reset();
        if TempJSONBuffer.FindFirst() then; //Pointer to first
        Page.Run(Page::"JSON Buffer TPTE", TempJSONBuffer);
    end;
}