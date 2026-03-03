/// <summary>
/// Table PDC Portal (ID 50053).
/// </summary>
table 50053 "PDC Portal"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
        }
        field(3; "Portal Type"; Option)
        {
            OptionCaption = 'Customer,Vendor,Employee,Fast Order,Quest,Demo,Knowledge,nEPay';
            OptionMembers = Customer,Vendor,Employee,"Fast Order",Quest,Demo,"Knowledge;nEPay";
        }
        field(4; Url; Text[250])
        {
            ExtendedDatatype = URL;
        }
        field(5; "Reset Pwd. Email Templ. Code"; Code[50])
        {
        }
        field(6; "Email Address"; Text[100])
        {
        }
        field(7; "Email Sender Name"; Text[100])
        {
        }
        field(8; AllowSSO; Boolean)
        {
            InitValue = false;
            NotBlank = true;
        }
        field(9; SSOPSK; Text[80])
        {
        }
        field(10; SSOCreatePortalUser; Boolean)
        {
            InitValue = false;
            NotBlank = true;
        }
        field(100; "Incident Type Filter"; Code[200])
        {
        }
        field(200; "Assistance Text"; Blob)
        {
            SubType = Memo;
        }
        field(201; "nEPay URL"; Text[250])
        {
        }
        field(202; "nEPay Merchant Id"; Text[250])
        {
        }
        field(203; "Admin Only Login"; Boolean)
        {
        }
        field(50000; "Wardrobe Series Nos."; Code[20])
        {
            Caption = 'Wardrobe Series Nos.';
            TableRelation = "No. Series";
        }
        field(50001; "Draft Orders Series Nos."; Code[20])
        {
            Caption = 'Draft Orders Series Nos.';
            TableRelation = "No. Series";
        }
        field(50002; "Branch Staff Series Nos."; Code[20])
        {
            Caption = 'Branch Staff Series Nos.';
            TableRelation = "No. Series";
        }
        field(50003; "Use Workflow Notifications"; Boolean)
        {
            Caption = 'Use Workflow Notifications';
        }
        field(50004; "Show Message"; Boolean)
        {
            Caption = 'Show Message';
        }
        field(50005; "Message Text"; Text[250])
        {
            Caption = 'Message Text';
        }
        field(50006; "Link Address"; Text[100])
        {
        }
        field(50007; "Override Display Cookie"; Boolean)
        {
            Caption = 'Override Display Cookie';
        }
        field(50008; "Apply Return To Invoice"; Boolean)
        {
            Caption = 'Apply Return To Invoice';
        }
        field(50009; "Page Size"; Integer)
        {
            Caption = 'Page Size';
        }
        // field(50010; "Debug Folder"; Text[30])
        // {
        //     Caption = 'Debug Folder';
        // }
        field(50011; "Contract Series Nos."; Code[20])
        {
            Caption = 'Contract Series Nos.';
            TableRelation = "No. Series";
        }
        field(50012; "Tenant Id"; Text[50])
        {
            Caption = 'Tenant Id';
        }
        field(50013; "Client Id"; Text[50])
        {
            Caption = 'Client Id';
        }
        field(50014; "Secret"; Text[250])
        {
            Caption = 'Secret';
            ExtendedDatatype = Masked;
        }
        field(50015; "Issuer"; Text[100])
        {
            Caption = 'Issuer';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        PDCNavPortalUserRole.Reset();
        PDCNavPortalUserRole.SetRange("Portal Code", Code);
        PDCNavPortalUserRole.DeleteAll();
    end;

    var
        PDCNavPortalUserRole: Record "PDC Portal User Role";

    /// <summary>
    /// GetAssistanceText.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetAssistanceText(): Text
    var
        BigText: BigText;
        InStream: InStream;
        Text: Text;
    begin
        CalcFields("Assistance Text");
        "Assistance Text".CreateInstream(InStream);
        BigText.Read(InStream);
        if (BigText.Length > 0) then begin
            BigText.GetSubText(Text, 1);
            exit(Text);
        end;
        exit('');
    end;

}

