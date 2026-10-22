table 87655 PropertyDifference_pte
{
    Caption = 'PropertyDifference';
    TableType = Temporary;

    fields
    {
        field(1; Source; Blob)
        {
            Caption = 'Source';
        }
        field(2; fKey; Text[250])
        {
            Caption = 'Key';
            NotBlank = true;
            ToolTip = 'Specifies the value of the fKey field.';
        }
        field(3; Target; Blob)
        {
            Caption = 'Target';
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

    internal procedure SetSource(Input: Text)
    var
        OutStream: OutStream;
    begin
        Clear(Rec.Source);
        Rec.Source.CreateOutStream(OutStream);
        OutStream.WriteText(Input);
    end;

    internal procedure GetSource() Output: Text
    var
        InStream: InStream;
    begin
        Rec.CalcFields(Source);
        Rec.Source.CreateInStream(InStream);
        InStream.ReadText(Output);
    end;

    internal procedure SetTarget(Input: Text)
    var
        OutStream: OutStream;
    begin
        Clear(Rec.Target);
        Rec.Target.CreateOutStream(OutStream);
        OutStream.WriteText(Input);
    end;

    internal procedure GetTarget() Output: Text
    var
        InStream: InStream;
    begin
        Rec.CalcFields(Target);
        Rec.Target.CreateInStream(InStream);
        InStream.ReadText(Output);
    end;

    internal procedure Compare(SourceVal: Text; TargetVal: Text) Result: Integer
    var
        TypeHelper: Codeunit "Type Helper";
        SourceBigInt: BigInteger;
        TargetBigInt: BigInteger;
        SourceBool: Boolean;
        TargetBool: Boolean;
        SourceDate: Date;
        TargetDate: Date;
        SourceDateTime: DateTime;
        TargetDateTime: DateTime;
        SourceDec: Decimal;
        TargetDec: Decimal;
        SourceInt: Integer;
        TargetInt: Integer;
        SourceTime: Time;
        TargetTime: Time;
    begin
        case true of
            (SourceVal = '') and (TargetVal = ''):
                exit(0);
            SourceVal = '':
                exit(-1);
            TargetVal = '':
                exit(1);
            Evaluate(SourceInt, SourceVal) and Evaluate(TargetInt, TargetVal):
                case true of
                    SourceInt < TargetInt:
                        exit(-1);
                    SourceInt > TargetInt:
                        exit(1);
                    else
                        exit(0);
                end;
            Evaluate(SourceBigInt, SourceVal) and Evaluate(TargetBigInt, TargetVal):
                case true of
                    SourceBigInt < TargetBigInt:
                        exit(-1);
                    SourceBigInt > TargetBigInt:
                        exit(1);
                    else
                        exit(0);
                end;
            Evaluate(SourceDec, SourceVal) and Evaluate(TargetDec, TargetVal):
                case true of
                    SourceDec < TargetDec:
                        exit(-1);
                    SourceDec > TargetDec:
                        exit(1);
                    else
                        exit(0);
                end;
            Evaluate(SourceBool, SourceVal) and Evaluate(TargetBool, TargetVal):
                case true of
                    (not SourceBool) and TargetBool:
                        exit(-1);
                    SourceBool and (not TargetBool):
                        exit(1);
                    else
                        exit(0);
                end;
            Evaluate(SourceDate, SourceVal) and Evaluate(TargetDate, TargetVal):
                case true of
                    SourceDate < TargetDate:
                        exit(-1);
                    SourceDate > TargetDate:
                        exit(1);
                    else
                        exit(0);
                end;
            Evaluate(SourceTime, SourceVal) and Evaluate(TargetTime, TargetVal):
                case true of
                    SourceTime < TargetTime:
                        exit(-1);
                    SourceTime > TargetTime:
                        exit(1);
                    else
                        exit(0);
                end;
            Evaluate(SourceDateTime, SourceVal) and Evaluate(TargetDateTime, TargetVal):
                exit(TypeHelper.CompareDateTime(SourceDateTime, TargetDateTime));
            SourceVal < TargetVal:
                exit(-1);
            SourceVal > TargetVal:
                exit(1);
            else
                exit(0);
        end;
    end;
}