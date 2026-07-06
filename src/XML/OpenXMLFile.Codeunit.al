codeunit 83868 "Open XML File TPTE"
{
    var
        TempXMLBuffer: Record "XML Buffer" temporary;
        SelectedInstream: InStream;
        SelectedFilePath: Text;


    procedure Initialize()
    begin
        TempXMLBuffer.DeleteAll(false);
    end;

    procedure SelectFile(var FileInStream: InStream): Text
    var
        AppFileFilterTxt: Label 'XML Files (*.xml)|*.xml';
        FilePath: Text;
    begin
        UploadIntoStream('Select File', '', AppFileFilterTxt, FilePath, FileInStream);
        SelectedInstream := FileInStream;
        SelectedFilePath := FilePath;
        exit(FilePath);
    end;

    procedure LoadFromStream()
    begin
        LoadFromStream(SelectedInstream);
    end;

    procedure LoadFromStream(var TempCurrentXMLBuffer: Record "XML Buffer" temporary)
    begin
        TempCurrentXMLBuffer.LoadFromStream(SelectedInstream);
    end;

    procedure LoadFromStream(FileInStream: InStream)
    begin
        TempXMLBuffer.LoadFromStream(FileInStream);
    end;

    procedure AddFileStream()
    begin
        AddFileStream(SelectedInstream, CopyStr(SelectedFilePath, 1, 250));
    end;

    procedure AddFileStream(FileInStream: InStream; FilePath: Text[250])
    var
        XmlOutStream: OutStream;
    begin
        TempXMLBuffer.Init();
        TempXMLBuffer."Entry No." := 0;
        TempXMLBuffer.Depth := 0;
        TempXMLBuffer.Name := 'Stream to xml file';
        TempXMLBuffer.Path := FilePath;
        TempXMLBuffer."Value BLOB".CreateOutStream(XmlOutStream, TextEncoding::UTF8);
        CopyStream(XmlOutStream, FileInStream);
        TempXMLBuffer.Insert(false);
    end;

    procedure OpenXMLPage()
    begin
        TempXMLBuffer.Reset();
        Page.Run(Page::"Open XML TPTE", TempXMLBuffer);
    end;

    procedure GetSelectedFilePath(): Text[250]
    begin
        exit(SelectedFilePath);
    end;

    procedure GetSelectFileInStream(): InStream
    begin
        exit(SelectedInstream);
    end;
}