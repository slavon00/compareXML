permissionset 87654 PermissionXML_pte
{
    Caption = 'Permission XML', Locked = true;
    Assignable = true;
    Permissions = tabledata PropertyDifference_pte = RIMD,
        tabledata Property_pte = RIMD,
        table PropertyDifference_pte = X,
        table Property_pte = X,
        codeunit CompareManagement_pte = X,
        page "Compare XML_pte" = X,
        page PropertyDifferences_pte = X,
        page ViewXML_pte = X;
}