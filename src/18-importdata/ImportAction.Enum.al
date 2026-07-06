enum 83851 "Import Action TPTE"
{
    Extensible = true;

#pragma warning disable LC0045
    value(0; Insert)
    {
        Caption = 'Insert';
    }
#pragma warning restore LC0045
    value(10; "Modify")
    {
        Caption = 'Modify';
    }
    value(20; "Insert (Delete first)")
    {
        Caption = 'Insert (Delete first)';
    }

    // Insert,,,Modify,,,"Insert (Delete first)"
}