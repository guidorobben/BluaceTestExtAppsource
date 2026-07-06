codeunit 83870 "Base64 Converter TPTE"
{
    var
        // SelectedFilePath: Text;
        Base64Convert: Codeunit "Base64 Convert";
        SelectedInstream: InStream;

    procedure SelectFile(var FileInStream: InStream): Text
    var
        AppFileFilterTxt: Label 'XML Files (*.pdf)|*.pdf';
        FilePath: Text;
    begin
        UploadIntoStream('Select File', '', AppFileFilterTxt, FilePath, FileInStream);
        SelectedInstream := FileInStream;
        // message(format(SelectedInstream.Length));
        // message(ToBase64());
        // SelectedFilePath := FilePath;
        exit(FilePath);
    end;

    // procedure GetSelectedFilePath(): Text[250]
    // begin
    //     exit(SelectedFilePath);
    // end;

    procedure FromBase64()
    begin

    end;

    procedure ToBase64() Base64Text: Text
    begin
        // message(format(SelectedInstream.Length));
        Base64Text := Base64Convert.ToBase64(SelectedInstream);
        // Message(Base64Text);
    end;

    procedure GetSelectFileInStream(): InStream
    begin
        exit(SelectedInstream);
    end;
}