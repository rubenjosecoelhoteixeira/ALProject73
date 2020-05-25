table 50012 "Item Certificate"
{
    Caption = 'Item Certificate';
    DataClassification = CustomerContent;
    Description = 'ARQNRSH';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(2; "CA Code"; Code[20])
        {
            Caption = 'CA Code';
            DataClassification = CustomerContent;
            TableRelation = "Certification Authority";
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item."No." where(Type = const(Inventory));
        }
        field(4; "Issued Date"; Date)
        {
            Caption = 'Issued Date';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup ("Item Certificate Action"."Action Date" where("Certificate No." = field("No."), "Action Type" = const(Issued)));
        }
        field(5; "Last Prolonged Date"; Date)
        {
            Caption = 'Last Prolonged Date';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = max ("Item Certificate Action"."Action Date" where("Certificate No." = field("No."), "Action Type" = const(Prolonged)));
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    procedure DeleteCertificateActions()
    var
        ItemCertificateAction: Record "Item Certificate Action";
    begin
        ItemCertificateAction.SetRange("Certificate No.", "No.");
        ItemCertificateAction.DeleteAll();
    end;

    procedure UpdateItemOnActions()
    var
        ItemCertificateAction: Record "Item Certificate Action";
    begin
        ItemCertificateAction.SetRange("Certificate No.", "No.");
        ItemCertificateAction.ModifyAll("Item No.", "Item No.");
    end;

    procedure IsCertificateIssued(): Boolean
    var
        ItemCertificateAction: Record "Item Certificate Action";
    begin
        exit(CertificateActionExists(ItemCertificateAction."Action Type"::Issued));
    end;

    procedure IsCertificateRevoked(): Boolean
    var
        ItemCertificateAction: Record "Item Certificate Action";
    begin
        exit(CertificateActionExists(ItemCertificateAction."Action Type"::Revoked));
    end;

    procedure CertificateActionExists(ActionType: Option): Boolean
    var
        ItemCertificateAction: Record "Item Certificate Action";
    begin
        with ItemCertificateAction do begin
            SetRange("Certificate No.", "No.");
            SetRange("Action Type", ActionType);
        end;
    end;

    trigger OnModify()
    begin
        if "Item No." <> xRec."Item No." then
            UpdateItemOnActions();
    end;

    trigger OnDelete()
    begin
        DeleteCertificateActions();
    end;
}