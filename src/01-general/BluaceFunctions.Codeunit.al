codeunit 83910 "Bluace Functions TPTE"
{
    Access = Internal;
    Permissions =
        tabledata Date = R,
        tabledata Field = R,
        tabledata "License Permission" = R;

    trigger OnRun()
    begin
    end;

    var
        FileManagement: Codeunit "File Management";

    procedure CurrentWeekNo() Result: Integer
    var
        lrDate: Record Date;
        ldDate: Date;
    begin
        ldDate := CalcDate('<-CW>', WorkDate());
        lrDate.SetLoadFields("Period No.");
        lrDate.Get(lrDate."Period Type"::Week, ldDate);
        Result := lrDate."Period No.";
    end;

    procedure ExtractFilename(FileName: Text[255]): Text
    var
        I: Integer;
    begin
        for I := StrLen(FileName) downto 1 do
            if FileName[I] = '\' then exit(CopyStr(FileName, I + 1));
    end;

    procedure ExtractFilename2(FileName: Text[255]; ExFileExt: Boolean) Result: Text
    var
        I: Integer;
    begin
        Result := FileName;

        for I := StrLen(FileName) downto 1 do
            if FileName[I] = '\' then begin
                Result := CopyStr(FileName, I + 1);
                I := 1;
            end;

        if ExFileExt then
            for I := StrLen(Result) downto 1 do
                if Result[I] = '.' then
                    Result := CopyStr(Result, 1, I - 1);
    end;


    procedure GetExtension(FileName: Text[250]) Result: Text
    begin
        Result := FileManagement.GetExtension(FileName);
    end;

    procedure PADSTRBV(String: Text[1024]; Length: Integer; FillChar: Text[1]; PadLeft: Boolean) Result: Text
    begin
        Result := String;
        if StrLen(Result) < Length then
            if PadLeft then //zet de fillchar voor de string
                while StrLen(Result) < Length do
                    Result := FillChar + Result
            else // BEGIN
                while StrLen(Result) < Length do
                    Result += FillChar;
    end;

    procedure PADZERO(String: Text[20]; Length: Integer) Result: Text
    var
        "Count": Integer;
    begin
        Count := Length - StrLen(String);

        if Count > 0 then
            Result := PadStr(Result, Count, '0');

        Result += String;
        exit(Result);
    end;

    procedure ReplaceStr(var String: Text[250]; What: Text[100]; ReplaceWith: Text[100]; Once: Boolean) Result: Boolean
    var
        StringPos: Integer;
        TempString: Text[250];
    begin
        TempString := String;

        if Once then begin
            StringPos := StrPos(TempString, What);
            if StringPos > 0 then begin
                TempString := CopyStr(TempString, 1, StringPos - 1) + ReplaceWith + CopyStr(TempString, StringPos + StrLen(What));

                Result := true;
            end;
        end else
            while StrPos(TempString, What) > 0 do begin
                StringPos := StrPos(TempString, What);
                TempString := CopyStr(TempString, 1, StringPos - 1) + ReplaceWith + CopyStr(TempString, StringPos + StrLen(What));

                Result := true;
            end;

        String := TempString;
    end;

    procedure ExtractFilePath(FileName: Text[255]) Result: Text
    var
        I: Integer;
    begin
        for I := StrLen(FileName) downto 1 do
            if FileName[I] = '\' then
                exit(CopyStr(FileName, 1, I));
    end;

    procedure BuildFilePath(FilePath: Text; IncludeSlash: Boolean) Result: Text
    begin
        Result := DelChr(FilePath, '>', '\');

        if IncludeSlash then
            Result := Result + '\';
    end;

    procedure FilePathIsNetwork(FilePath: Text[255]) Result: Boolean
    begin
        //A205
        Result := CopyStr(FilePath, 1, 2) = '\\';
    end;

    // procedure InCodeArray(var CodeArray: array[100] of Code[20]; Code: Code[20]): Boolean
    // var
    //     I: Integer;
    // begin
    //     for I := 1 to ArrayLen(CodeArray) do
    //         if CodeArray[I] = Code then
    //             exit(true);

    //     exit(false);
    // end;

    // procedure AddToCodeArray(var CodeArray: array[100] of Code[20]; Code: Code[20])
    // var
    //     I: Integer;
    // begin
    //     CompressArray(CodeArray);
    //     for I := 1 to ArrayLen(CodeArray) do
    //         if CodeArray[I] = '' then begin
    //             CodeArray[I] := Code;
    //             I := ArrayLen(CodeArray)
    //         end;
    // end;

    // procedure SortCodeArray(var pArray: array[100] of Code[20])
    // var
    //     Finish: Integer;
    //     I: Integer;
    //     ToExit: Boolean;
    // begin
    //     CompressArray(pArray);
    //     for I := 1 to ArrayLen(pArray) do begin
    //         if pArray[I] = '' then
    //             Finish := I;
    //     end;

    //     repeat
    //         ToExit := true;
    //         for I := 1 to (Finish - 1) do begin
    //             if pArray[I] > pArray[I + 1] then begin
    //                 Swap(pArray[I], pArray[I + 1]);
    //                 ToExit := false;
    //             end;
    //         end;
    //         Finish -= 1;
    //     until ToExit;
    // end;


    procedure CodeArrayToOptionString(pcCodeArray: array[100] of Code[20]): Text[1024]
    var
        I: Integer;
        ltOptionString: Text[1024];
    begin
        for I := 1 to ArrayLen(pcCodeArray) do
            if pcCodeArray[I] <> '' then
                ltOptionString += pcCodeArray[I] + ',';

        if StrLen(ltOptionString) > 1 then
            ltOptionString := CopyStr(ltOptionString, 1, StrLen(ltOptionString) - 1);

        exit(ltOptionString);
    end;

    procedure Swap(var pValue: Code[20]; var pValue2: Code[20])
    var
        temp: Code[20];
    begin
        temp := pValue;
        pValue := pValue2;
        pValue2 := temp;
    end;

    procedure FormatDec(ldValue: Decimal) Result: Text[50]
    begin
        Result := Format(ldValue, 0, '<Precision,2:><Sign><Integer><1000Character,.><Decimals><Comma,,>');
    end;

    procedure RightStr(String: Text; Length: Integer) Result: Text
    begin
        //A456
        if String = '' then
            exit;

        if Length > StrLen(String) then
            exit(String);

        exit(CopyStr(String, StrLen(String) - Length + 1, Length));
    end;

    procedure RemoveHiddenChar(ValueToClean: Text[1024]) Result: Text[1024]
    var
        CH: Text[3];
    begin
        //A546
        CH[1] := 9;  //- TAB
        CH[2] := 13; //- CR - Carriage Return
        CH[3] := 10; //- LF - Line Feed
        Result := DelChr(ValueToClean, '=', CH);
    end;

    procedure OnlyNumbers(String: Text[100]) Result: Text[100]
    begin
        //A714
        Result := DelChr(String, '=', DelChr(String, '=', '0123456789'));
    end;

    // procedure FileLineCounter(ptPath: Text[250]): Integer
    // begin
    //     //A705
    //     exit(FileContentsMatchCounter('^.*$', ptPath));
    // end;

    // procedure FileContentsMatchCounter(ptPattern: Text[100]; path: Text[250]): Integer
    // var
    //     Matches: DotNet MatchCollection;
    //     RegEx: DotNet Regex;
    //     FileTemp: File;
    //     Stream: InStream;
    //     FileTextLine: Text[250];
    //     ServerFileName: Text[250];
    //     MatchCounter: Integer;
    // begin
    //     //A705 start
    //     MatchCounter := 0;
    //     ServerFileName := FileMgt.UploadFileSilent(path); //A456
    //     FileTemp.Open(ServerFileName);
    //     FileTemp.CreateInStream(Stream);
    //     while not (Stream.EOS) do begin
    //         Stream.ReadText(FileTextLine);
    //         Matches := RegEx.Matches(FileTextLine, ptPattern);
    //         MatchCounter += Matches.Count();
    //     end;
    //     FileTemp.Close;
    //     exit(MatchCounter);
    //     //A705 eind
    // end;

    // procedure GetCurrentRoleCenter() Result: Text[100]
    // begin
    //     exit(UserMgtBV.CurrentRoleCenter); //A986
    // end;

    // procedure GetCurrentRoleCenterID() Result: Integer
    // begin
    //     exit(UserMgtBV.CurrentRoleCenterID); //A986
    // end;

    // procedure IsDebugMode() Result: Boolean
    // var
    //     BVApplMgt: Codeunit "ApplicationManagement BVE";
    // begin
    //     Result := BVApplMgt.IsDebugMode; //A456
    // end;

    // procedure HasReadPermission(TableID: Integer) Result: Boolean
    // var
    //     LicensePermission: Record "License Permission";
    // begin
    //     LicensePermission.SetRange("Object Type", LicensePermission."Object Type"::Table);
    //     LicensePermission.SetRange("Object Number", TableID);

    //     if not LicensePermission.FindFirst() then
    //         exit;

    //     if LicensePermission."Read Permission" <> LicensePermission."Read Permission"::" " then
    //         exit(true);
    // end;

    procedure FilterRecRef(var TableRecordRef: RecordRef; TableFilter: Text; KeyIndex: Integer)
    var
        Field: Record "Field";
        CurrentFieldRef: FieldRef;
        Pos: Integer;
        FieldCaption2: Text;
        FieldFilter: Text;
        TableName2: Text;
    begin
        //A1070
        Pos := 1;
        if GetValue(TableFilter, Pos, ':', TableName2) then begin
            Pos += 1;
            while GetValue(TableFilter, Pos, '=', FieldCaption2) and GetValue(TableFilter, Pos, ',', FieldFilter)
            do begin
                Field.SetRange(TableNo, TableRecordRef.Number());
                Field.SetRange("Field Caption", FieldCaption2);
                Field.SetRange(Enabled, true);
                if Field.FindFirst() then begin
                    CurrentFieldRef := TableRecordRef.Field(Field."No.");
                    CurrentFieldRef.SetFilter(FieldFilter);
                end;
            end;
        end;

        if KeyIndex <> 0 then
            TableRecordRef.CurrentKeyIndex := KeyIndex;
    end;

    procedure GetValue(Value: Text; var Position: Integer; StopChar: Char; var ExitValue: Text): Boolean
    var
        Advanced: Boolean;
        FirstCharacter: Boolean;
        Stop: Boolean;
        Char: Char;
    begin
        //A1070
        ExitValue := '';
        FirstCharacter := true;

        if Position > StrLen(Value) then
            exit(false);

        while not Stop do begin
            Char := Value[Position];
            case true of
                Char = '"':
                    if FirstCharacter then
                        Advanced := true
                    else
                        if Advanced then
                            if Value[Position + 1] = '"' then begin
                                ExitValue += Format(Char);
                                Position += 1;
                            end else begin
                                Stop := true;
                                Position += 1;
                            end
                        else
                            ExitValue += Format(Char);

                Char = StopChar:
                    if Advanced then
                        ExitValue += Format(Char)
                    else
                        Stop := true;

                else
                    ExitValue += Format(Char);
            end;

            FirstCharacter := false;
            Position += 1;
            if Position > StrLen(Value) then
                Stop := true;
        end;

        ExitValue := DelChr(ExitValue, '<>');
        exit(true);
    end;
}