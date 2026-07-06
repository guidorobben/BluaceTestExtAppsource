codeunit 83904 "UT Item TPTE"
{
    Permissions =
        tabledata "Contract Setup CBLC" = R,
        tabledata Item = RM;
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryItemLIB: Codeunit "Library - Item LIB";
        LibraryRandom: Codeunit "Library - Random";

    [Test]
    procedure CreateServiceItems()
    var
        ContractSetupCBLC: Record "Contract Setup CBLC";
        Item: Record Item;
    begin
        ContractSetupCBLC.Get();

        // ItemCategory.Get(ContractSetupCBLC."Item Category Service");
        Clear(Item);
        if not Item.Get('SERVICE1') then
            LibraryItemLIB.CreatePriceItem(Item, 'SERVICE1', LibraryRandom.RandDecInRange(10, 100, 0), LibraryRandom.RandDecInRange(50, 100, 0), 'MAAND');
        Item.TestField("No.");
        Item.Validate("Item Category Code", ContractSetupCBLC."Item Category Service");
        Item.Modify(true);

        Clear(Item);
        if not Item.Get('SERVICE2') then
            LibraryItemLIB.CreatePriceItem(Item, 'SERVICE2', LibraryRandom.RandDecInRange(10, 100, 0), LibraryRandom.RandDecInRange(50, 100, 0), 'MAAND');
        Item.TestField("No.");
        Item.Validate("Item Category Code", ContractSetupCBLC."Item Category Service");
        Item.Modify(true);

        Clear(Item);
        if not Item.Get('SERVICE3') then
            LibraryItemLIB.CreatePriceItem(Item, 'SERVICE3', LibraryRandom.RandDecInRange(10, 100, 0), LibraryRandom.RandDecInRange(50, 100, 0), 'MAAND');
        Item.TestField("No.");
        Item.Validate("Item Category Code", ContractSetupCBLC."Item Category Service");
        Item.Modify(true);
    end;
}
