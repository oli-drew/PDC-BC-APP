/// <summary>
/// EnumExtension PDC Service Integration (ID 50300) extends Service Integration.
/// Adds Azure File Share as an integration option for E-Document services.
/// </summary>
enumextension 50300 "PDC Service Integration" extends "Service Integration"
{
    value(50300; "PDC Azure File Share")
    {
        Caption = 'Azure File Share';
        Implementation = IDocumentSender = "PDC Azure File Share Connector",
                         IDocumentReceiver = "PDC Azure File Share Connector";
    }
}
