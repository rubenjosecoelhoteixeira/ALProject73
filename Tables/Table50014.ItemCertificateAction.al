table 50014 "Item Certificate Action"
{
    Caption = 'Item Certificate Action';
    DataClassification = CustomerContent;
    Description = 'ARQNRSH';

    fields
    {
        field(1; "Certificate No."; Code[20])
        {
            Caption = 'Certificate No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Item Certificate";
        }
        field(2; "Action Date"; Date)
        {
            Caption = 'Action Date';
            DataClassification = CustomerContent;
        }
        field(3; "Action Type"; Option)
        {
            Caption = 'Action Type';
            DataClassification = CustomerContent;
            OptionMembers = " ","Issued","Prolonged","Revoked";
        }
        field(4; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Action Type" = "Action Type"::Revoked then
                    TestField("Expiration Date", 0D)
                else
                    if "Expiration Date" < "Action Date" then
                        FieldError("Expiration Date", ' cannot be earlier than ' + FieldName("Action Date"));
            end;
        }
        field(5; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Certificate No.", "Action Date")
        {
            Clustered = true;
        }
    }
}