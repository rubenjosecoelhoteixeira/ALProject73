codeunit 50011 "Luhn Verification"
{
    Description = 'ARQNRSH';

    trigger OnRun()
    var
        SalesLine: Record "Sales Line";
        StartingDate: Date;
        EndingDate: Date;
        SalesAmountMsg: Label 'Total amount in sales documents: %1';
    begin
        StartingDate := CalcDate('<-1M>', WorkDate());
        EndingDate := WorkDate();
        SalesLine.SetRange("Sell-to Customer No.", '10000');
        SalesLine.SetFilter("Document Type", '%1|%2', SalesLine."Document Type"::Order, SalesLine."Document Type"::Invoice);
        SalesLine.CalcSums("Line Amount");
        Message(SalesAmountMsg, SalesLine."Line Amount");
    end;
}