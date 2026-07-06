codeunit 83875 "ErrorInfo Handler TPTE"
{
    InherentEntitlements = X;
    InherentPermissions = X;

    /*
        Error(
            ErrorInfoWrapper
                .Title('My custom error title, from second app')
                .Message('My custom error message')
                .DetailedMessage('My custom detailed error message')
                .AddCustomDimension('MyCustomDimension', 'MyCustomValue')
                .AddCustomDimension('MyCustomDimension2', 'MyCustomValue2')
                .ControlName('MyControlName')
                .DataClassification(DataClassification::OrganizationIdentifiableInformation)
                .AddNavigationAction('Open Vendor Card', Page::"Vendor Card", Vendor.RecordId)
                .AddAction('My custom action', Codeunit::MyCodeunit, 'FixError', 'Action description')
                .GetErrorInfo()
        );
    */

    var
        ErrorInfoHandlerImpl: Codeunit "ErrorInfo Handler Impl TPTE";

    /// <summary>
    /// Creates a new ErrorInfo Handler object.
    /// Also initializes a new instance of the ErrorInfo Handler variable.
    /// </summary>
    procedure Create(): Codeunit "ErrorInfo Handler TPTE"
    begin
        this.ErrorInfoHandlerImpl.Create();
        exit(this);
    end;

    /// <summary>
    /// Creates a new ErrorInfo object.
    /// Also initializes a new instance of the ErrorInfo variable.
    /// </summary>
    /// <param name="MessageParam">Specifies the message that will be sent to telemetry. For a 'Client' error type, the message will also be appear in the client.</param>
    /// <returns></returns>
    procedure Create(MessageParam: Text): Codeunit "ErrorInfo Handler TPTE"
    begin
        this.ErrorInfoHandlerImpl.Create(MessageParam);
        exit(this);
    end;

    /// <summary>
    /// Specifies the title of the error.
    /// </summary>
    /// <param name="TitleParam">The title will be shown at the top of the error message window. If not set, there won't be any title.</param>
    /// <returns></returns>
    procedure Title(TitleParam: Text): Codeunit "ErrorInfo Handler TPTE"
    begin
        this.ErrorInfoHandlerImpl.Title(TitleParam);
        exit(this);
    end;


    /// <summary>
    /// Specifies the message of the error.
    /// </summary>
    /// <param name="MessageParam">Specifies the message that will be sent to telemetry. For a 'Client' error type, the message will also be appear in the client.</param>
    /// <returns></returns>
    procedure Message(MessageParam: Text): Codeunit "ErrorInfo Handler TPTE"
    begin
        this.ErrorInfoHandlerImpl.Message(MessageParam);
        exit(this);
    end;

    /// <summary>
    /// Specifies the detailed message of the error.
    /// </summary>
    /// <param name="DetailedMessageParam">The detailed message will not be shown to the client, it will just be part of the details copied with "Share details".</param>
    /// <returns></returns>
    procedure DetailedMessage(DetailedMessageParam: Text): Codeunit "ErrorInfo Handler TPTE"
    begin
        this.ErrorInfoHandlerImpl.DetailedMessage(DetailedMessageParam);
        exit(this);
    end;

    /// <summary>
    /// Add custom dimension to the error. Custom dimensions will be sent to telemetry and will be shown in the details copied with "Share details".
    /// They are also useful in combination with AddAction to provide additional context to the action.
    /// Call this function as often as needed to add multiple custom dimensions.
    /// </summary>
    /// <param name="CustomDimensionKey">The key of the dimension to add</param>
    /// <param name="CustomDimensionValue">The value of the dimension to add</param>
    /// <returns></returns>
    procedure AddCustomDimension(CustomDimensionKey: Text; CustomDimensionValue: Text): Codeunit "ErrorInfo Handler TPTE"
    begin
        this.ErrorInfoHandlerImpl.AddCustomDimension(CustomDimensionKey, CustomDimensionValue);
        exit(this);
    end;

    /// <summary>
    /// Specifies the control name that the error relates to.
    /// </summary>
    /// <param name="Name">Name of the control</param>
    /// <returns></returns>
    procedure ControlName(Name: Text): Codeunit "ErrorInfo Handler TPTE"
    begin
        this.ErrorInfoHandlerImpl.ControlName(Name);
        exit(this);
    end;

    /// <summary>
    /// Specifies the classification of the error. Values include 'CustomerContent', 'EndUserIdentifiableInformation', 'EndUserPseudonymousIdentifiers', 'AccountData', 'OrganizationIdentifiableInformation', 'SystemMetadata', and 'ToBeClassified'
    /// This affects how the error message will be shown in telemetry.
    /// </summary>
    /// <param name="Classification"></param>
    /// <returns></returns>
    procedure DataClassification(Classification: DataClassification): Codeunit "ErrorInfo Handler TPTE"
    begin
        this.ErrorInfoHandlerImpl.DataClassification(Classification);
        exit(this);
    end;

    /// <summary>
    /// Adds a navigation action for the error. A navigation action can help the user to navigate to a specific page in order to fix the error.
    /// </summary>
    /// <param name="ActionCaption">Caption of the action button on the error message.</param>
    /// <param name="PageNoParam">Page number that will be opened by the action.</param>
    /// <returns></returns>
    procedure AddNavigationAction(ActionCaption: Text; PageNoParam: Integer): Codeunit "ErrorInfo Handler TPTE"
    begin
        this.ErrorInfoHandlerImpl.AddNavigationAction(ActionCaption, PageNoParam);
        exit(this);
    end;

    /// <summary>
    /// Adds a navigation action for the error. A navigation action can help the user to navigate to a specific page in order to fix the error.
    /// </summary>
    /// <param name="ActionCaption">Caption of the action button on the error message.</param>
    /// <param name="PageNoParam">Page number that will be opened by the action.</param>
    /// <param name="RecordIdParam">RecordId of the record that should be opened by the page.</param>
    /// <returns></returns>
    procedure AddNavigationAction(ActionCaption: Text; PageNoParam: Integer; RecordIdParam: RecordId): Codeunit "ErrorInfo Handler TPTE"
    begin
        this.ErrorInfoHandlerImpl.AddNavigationAction(ActionCaption, PageNoParam, RecordIdParam);
        exit(this);
    end;

    /// <summary>
    /// Adds a navigation action for the error. A navigation action can help the user to navigate to a specific page in order to fix the error.
    /// </summary>
    /// <param name="ActionCaption">Caption of the action button on the error message.</param>
    /// <param name="PageNoParam">Page number that will be opened by the action.</param>
    /// <param name="TableIdParam">Table number of the record that should be opened by the page.</param>
    /// <param name="SystemIdParam">System if of the record that should be opened by the page.</param>
    /// <returns></returns>
    procedure AddNavigationAction(ActionCaption: Text; PageNoParam: Integer; TableIdParam: Integer; SystemIdParam: Guid): Codeunit "ErrorInfo Handler TPTE"
    begin
        this.ErrorInfoHandlerImpl.AddNavigationAction(ActionCaption, PageNoParam, TableIdParam, SystemIdParam);
        exit(this);
    end;

    /// <summary>
    /// Specifies the page number that the error relates to.
    /// This will be used by the navigation action to open the correct page.
    /// </summary>
    /// <param name="PageNoParam">Page number that will be opened by the action.</param>
    /// <returns></returns>
    procedure PageNo(PageNoParam: Integer): Codeunit "ErrorInfo Handler TPTE"
    begin
        this.ErrorInfoHandlerImpl.PageNo(PageNoParam);
        exit(this);
    end;

    /// <summary>
    /// Specifies the record id that the error relates to.
    /// This will be used by the navigation action to open the correct record.
    /// </summary>
    /// <param name="RecordIdParam">RecordId of the record that should be opened by the page.</param>
    /// <returns></returns>
    procedure RecordId(RecordIdParam: RecordId): Codeunit "ErrorInfo Handler TPTE"
    begin
        this.ErrorInfoHandlerImpl.RecordId(RecordIdParam);
        exit(this);
    end;

    /// <summary>
    /// Specifies the field number that the error relates to.
    /// This will be used by the navigation action to point the user the correct field on the target page.
    /// </summary>
    /// <param name="FieldNoParam">Field number that will be focused by the action.</param>
    /// <returns></returns>
    procedure FieldNo(FieldNoParam: Integer): Codeunit "ErrorInfo Handler TPTE"
    begin
        this.ErrorInfoHandlerImpl.FieldNo(FieldNoParam);
        exit(this);
    end;

    /// <summary>
    /// Specifies the table number that the error relates to.
    /// This will be used by the navigation action to open the correct record.
    /// </summary>
    /// <param name="TableIdParam">Table number of the record that should be opened by the page.</param>
    /// <returns></returns>
    procedure TableId(TableIdParam: Integer): Codeunit "ErrorInfo Handler TPTE"
    begin
        this.ErrorInfoHandlerImpl.TableId(TableIdParam);
        exit(this);
    end;

    /// <summary>
    /// Specifies the system id that the error relates to.
    /// This will be used by the navigation action to open the correct record.
    /// </summary>
    /// <param name="SystemIdParam">System id of the record that should be opened by the page.</param>
    /// <returns></returns>
    procedure SystemId(SystemIdParam: Guid): Codeunit "ErrorInfo Handler TPTE"
    begin
        this.ErrorInfoHandlerImpl.SystemId(SystemIdParam);
        exit(this);
    end;

    /// <summary>
    /// Adds an action to the error. An action can help to fix the error for the user.
    /// </summary>
    /// <param name="ActionCaption">Caption of the action button on the error message.</param>
    /// <param name="CodeunitId">Id of the codeunit that contains the method that should be executed by the action.</param>
    /// <param name="MethodName">Name of the method that should be executed by the action.</param>
    /// <returns></returns>
    procedure AddAction(ActionCaption: Text; CodeunitId: Integer; MethodName: Text): Codeunit "ErrorInfo Handler TPTE"
    begin
        this.ErrorInfoHandlerImpl.AddAction(ActionCaption, CodeunitId, MethodName);
        exit(this);
    end;

    /// <summary>
    /// Adds an action to the error. An action can help to fix the error for the user.
    /// </summary>
    /// <param name="ActionCaption">Caption of the action button on the error message.</param>
    /// <param name="CodeunitId">Id of the codeunit that contains the method that should be executed by the action.</param>
    /// <param name="MethodName">Name of the method that should be executed by the action.</param>
    /// <param name="Description">Tooltip text that will be shown when the user hovers over the action button.</param>
    /// <returns></returns>
    procedure AddAction(ActionCaption: Text; CodeunitId: Integer; MethodName: Text; Description: Text): Codeunit "ErrorInfo Handler TPTE"
    begin
        this.ErrorInfoHandlerImpl.AddAction(ActionCaption, CodeunitId, MethodName, Description);
        exit(this);
    end;

    /// <summary>
    /// Specifies if the error is collectible using ErrorBehavior.Collect.
    /// </summary>
    /// <param name="CollectibleParam">True if the error should be collectible, false otherwise.</param>
    /// <returns></returns>
    procedure Collectible(CollectibleParam: Boolean): Codeunit "ErrorInfo Handler TPTE"
    begin
        this.ErrorInfoHandlerImpl.Collectible(CollectibleParam);
        exit(this);
    end;

    /// <summary>
    /// Specifies type of the error. 'Client' shows the specified message in the client and sends it to telemetry. 'Internal' shows a generic message in the client and sends the specified message to telemetry.
    /// </summary>
    /// <param name="ErrorTypeParam">Type of the error</param>
    /// <returns></returns>
    procedure ErrorType(ErrorTypeParam: ErrorType): Codeunit "ErrorInfo Handler TPTE"
    begin
        this.ErrorInfoHandlerImpl.ErrorType(ErrorTypeParam);
        exit(this);
    end;

    /// <summary>
    /// Specifies the severity level of the error. This can determine whether the error should be sent to telemetry (which is based on the trace level setting of the server).
    /// </summary>
    /// <param name="VerbosityParam">Verbosity level of the error</param>
    /// <returns></returns>
    procedure Verbosity(VerbosityParam: Verbosity): Codeunit "ErrorInfo Handler TPTE"
    begin
        this.ErrorInfoHandlerImpl.Verbosity(VerbosityParam);
        exit(this);
    end;

    /// <summary>
    /// Returns the ErrorInfo object that was built by the ErrorInfoWrapper.
    /// Use this function to pass the ErrorInfo object to the Error function.
    /// </summary>
    /// <returns></returns>
    procedure GetErrorInfo(): ErrorInfo
    begin
        exit(this.ErrorInfoHandlerImpl.GetErrorInfo());
    end;
}