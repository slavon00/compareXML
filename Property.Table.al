table 87654 Property_pte
{
    Caption = 'Property';
    TableType = Temporary;

    fields
    {
        field(1; fKey; Text[250])
        {
            Caption = 'Key';
            NotBlank = true;
            AllowInCustomizations = AsReadOnly;
            ToolTip = 'Specifies the value of the Key field.';
        }
        field(2; fValue; Blob)
        {
            Caption = 'Value';
            AllowInCustomizations = AsReadOnly;
        }
    }
    keys
    {
        key(PK; fKey)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(Brick; fKey) { }
        fieldgroup(DropDown; fKey) { }
    }

    internal procedure SetValue(Input: Text)
    var
        OutStream: OutStream;
    begin
        Clear(Rec.fValue);
        Rec.fValue.CreateOutStream(OutStream);
        OutStream.WriteText(Input);
    end;

    internal procedure GetValue() Output: Text
    var
        InStream: InStream;
    begin
        Rec.CalcFields(fValue);
        Rec.fValue.CreateInStream(InStream);
        InStream.ReadText(Output);
    end;
}