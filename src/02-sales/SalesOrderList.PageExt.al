pageextension 83935 "Sales Order List TPTE" extends "Sales Order List"
{
    layout
    {
        modify("Posting Date")
        {
            Visible = true;
        }
    }
    actions
    {
        addlast(processing)
        {

            action(DeleteTPTE)
            {
                ApplicationArea = All;
                Caption = 'Delete in filter';

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    ConfirmManagement: Codeunit "Confirm Management";
                begin
                    if not ConfirmManagement.GetResponse('Delete all in filter', true) then
                        exit;

                    CurrPage.SetSelectionFilter(SalesHeader);
                    SalesHeaderHelperTPTE.DeleteSelected(SalesHeader);
                    // if SalesHeader.FindSet() then
                    //     repeat
                    //         if not SalesHeader.Delete(true) then; //IGNORE
                    //         Commit();
                    //     until SalesHeader.Next() = 0;
                end;
            }
        }

        addlast(Promoted)
        {
            group(TestExtTPTE_Promoted)
            {

                Caption = 'Text Ext.';

                actionref(DeleteTPTE_Promoted; DeleteTPTE) { }
            }
        }
    }

    views
    {
        addfirst
        {

            view(ViewName)
            {
                Caption = 'Guido';
                Filters = where(Status = filter(Open));
                SharedLayout = false;

                // layout
                // {

                // }
            }
        }
    }

    var
        SalesHeaderHelperTPTE: Codeunit "Sales Header Helper TPTE";
}
