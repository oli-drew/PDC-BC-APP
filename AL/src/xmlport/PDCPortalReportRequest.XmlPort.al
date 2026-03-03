/// <summary>
/// XmlPort PDC Portal Report Request (ID 50032).
/// </summary>
XmlPort 50032 "PDC Portal Report Request"
{
    Encoding = UTF8;
    FormatEvaluate = Xml;

    schema
    {
        textelement(data)
        {
            MaxOccurs = Once;
            MinOccurs = Once;
            textelement(filter)
            {
                MaxOccurs = Once;
                MinOccurs = Zero;
                textelement(formatFilter)
                {
                    MinOccurs = Zero;
                }
                textelement(noFilter)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                }
                textelement(startDateFilter)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                }
                textelement(endDateFilter)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                }
                textelement(branchFilter)
                {
                    MinOccurs = Zero;
                }
                textelement(typeFilter)
                {
                }
            }
        }
    }

    /// <summary>
    /// GetFormatFilter.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetFormatFilter(): Text
    begin
        exit(formatFilter);
    end;

    /// <summary>
    /// GetNoFilter.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetNoFilter(): Text
    begin
        exit(noFilter);
    end;

    /// <summary>
    /// GetStartDateFilter.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetStartDateFilter(): Text
    begin
        exit(startDateFilter);
    end;

    /// <summary>
    /// GetEndDateFilter.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetEndDateFilter(): Text
    begin
        exit(endDateFilter);
    end;

    /// <summary>
    /// GetBranchFilter.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetBranchFilter(): Text
    begin
        exit(branchFilter);
    end;

    /// <summary>
    /// GetTypeFilter.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetTypeFilter(): Text
    begin
        exit(typeFilter);
    end;
}

