@AbapCatalog.sqlViewName: 'ZIUSER'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #BASIC
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'User(logon) Contact Data'
define view ZI_User
  as select from I_UserContactCard
{
  key ContactCardID       as bname,
      Person              as persnumber,
      BusinessPartnerUUID as bpperson,

      FirstName,
      LastName


}
