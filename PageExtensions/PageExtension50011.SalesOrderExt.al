pageextension 50011 SalesOrderExt extends "Sales Order"
{
    layout
    {
        addlast(factboxes)
        {
            part(ItemCertificationFactBox; ItemCertificateFactBox)
            {
                Caption = 'Item Certificate Details';
                SubPageLink = "Item No." = field(upperlimit("No."));
            }

        }
    }
}