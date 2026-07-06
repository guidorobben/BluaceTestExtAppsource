codeunit 83941 "XML Buffer Helper TPTE"
{
    Permissions =
        tabledata "XML Buffer" = R;

    internal procedure GetValueAsInteger(var XMLBuffer: Record "XML Buffer"; Fatal: Boolean) Result: Integer
    var
        EvaluateToIntegerErr: Label 'The value ''%1'' from path ''%2'' could not be converted to integer.', Comment = '%1=Value, %2=Xml Path';
        NodeValue: Text;
    begin
        NodeValue := XMLBuffer.GetValue();
        if NodeValue = '' then
            exit;

        if Fatal then begin
            if not Evaluate(Result, NodeValue, 9) then
                Error(EvaluateToIntegerErr, NodeValue, XMLBuffer.Path);
        end else
            Evaluate(Result, NodeValue, 9);
    end;

    internal procedure GetValueAsDecimal(var XMLBuffer: Record "XML Buffer"; Fatal: Boolean) Result: Decimal
    var
        EvaluateToDecimalErr: Label 'The value ''%1'' from path ''%2'' could not be converted to decimal.', Comment = '%1=Value, %2=Xml Path';
        NodeValue: Text;
    begin
        NodeValue := XMLBuffer.GetValue();
        if NodeValue = '' then
            exit;

        if Fatal then begin
            if not Evaluate(Result, NodeValue, 9) then
                Error(EvaluateToDecimalErr, NodeValue, XMLBuffer.Path);
        end else
            Evaluate(Result, NodeValue, 9);
    end;

    internal procedure GetValueAsDate(var XMLBuffer: Record "XML Buffer"; Fatal: Boolean) Result: Date
    var
        EvaluateToDateErr: Label 'The value ''%1'' from path ''%2'' could not be converted to date.', Comment = '%1=Value, %2=Xml Path';
        NodeValue: Text;
    begin
        NodeValue := XMLBuffer.GetValue();
        if NodeValue = '' then
            exit;

        if Fatal then begin
            if not Evaluate(Result, NodeValue, 9) then
                Error(EvaluateToDateErr, NodeValue, XMLBuffer.Path);
        end else
            Evaluate(Result, NodeValue, 9);
    end;

    internal procedure GetValueAsBoolean(var XMLBuffer: Record "XML Buffer"; Fatal: Boolean) Result: Boolean
    var
        EvaluateToDateErr: Label 'The value ''%1'' from path ''%2'' could not be converted to boolean.', Comment = '%1=Value, %2=Xml Path';
        NodeValue: Text;
    begin
        NodeValue := XMLBuffer.GetValue();
        if NodeValue = '' then
            exit;

        if Fatal then begin
            if not Evaluate(Result, NodeValue, 9) then
                Error(EvaluateToDateErr, NodeValue, XMLBuffer.Path);
        end else
            Evaluate(Result, NodeValue, 9);
    end;

    procedure LoadFromXMLDocument(var XMLBuffer: Record "XML Buffer"; Document: XmlDocument)
    var
        XMLText: Text;
    begin
        Document.WriteTo(XMLText);
        XMLBuffer.LoadFromText(XMLText);
    end;

    procedure SelectSingleNode(XPath: Text; var XMLBuffer: Record "XML Buffer"): Text
    begin
        XMLBuffer.Reset();
        XMLBuffer.SetFilter(Path, XPath);
        if XMLBuffer.FindFirst() then
            exit(XMLBuffer.Value);
    end;

    procedure GetAttribute(var CurrentXMLBuffer: Record "XML Buffer"; Name: Text; var XMLBuffer: Record "XML Buffer"): Text
    begin
        XMLBuffer.Reset();
        XMLBuffer.SetLoadFields(Value);
        XMLBuffer.SetCurrentKey("Parent Entry No.", Type, Name);
        XMLBuffer.SetRange("Parent Entry No.", CurrentXMLBuffer."Entry No.");
        XMLBuffer.SetRange(Type, XMLBuffer.Type::Attribute);
        XMLBuffer.SetRange(Name, Name);
        if XMLBuffer.FindFirst() then
            exit(XMLBuffer.Value);
    end;
}
