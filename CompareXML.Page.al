page 87654 "Compare XML_pte"
{
    ApplicationArea = All;
    Caption = 'Compare XML';
    PageType = Worksheet;
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            grid(Files)
            {
                group(SourceFile)
                {
                    Caption = 'Source File';
                    part(ViewSource; ViewXML_pte) { }
                }
                group(TargetFile)
                {
                    Caption = 'Target File';
                    part(ViewTarget; ViewXML_pte) { }
                }
            }
            part(Lines; PropertyDifferences_pte) { }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Compare)
            {
                Caption = 'Compare';
                ToolTip = 'Compares.';
                Image = CompareCOA;

                trigger OnAction()
                var
                    TempSource, TempTarget : Record Property_pte temporary;
                    TempPropertyDifference: Record PropertyDifference_pte temporary;
                    CompareManagementpte: Codeunit CompareManagement_pte;
                begin
                    CurrPage.ViewSource.Page.GetRecord(TempSource);
                    if TempSource.FindSet() then
                        repeat
                            CompareManagementpte.InsertProperty(TempSource.fKey, TempSource.GetValue(), PropertyType_pte::Source, TempPropertyDifference);
                        until TempSource.Next() = 0;
                    CurrPage.ViewTarget.Page.GetRecord(TempTarget);
                    if TempTarget.FindSet() then
                        repeat
                            CompareManagementpte.InsertProperty(TempTarget.fKey, TempTarget.GetValue(), PropertyType_pte::Target, TempPropertyDifference);
                        until TempTarget.Next() = 0;
                    CurrPage.Lines.Page.SetRecord(TempPropertyDifference);
                end;
            }
        }
    }
}