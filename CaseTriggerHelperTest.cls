@isTest
public class CaseTriggerHelperTest {
    @testSetup
    static void createCaseRecords(){
        List<Case> lstParentCases = new List<Case>();
        List<Case> lstChildCases = new List<Case>();
        for(Integer casecreate = 1; casecreate <= 25; casecreate++){
            Case parentCaseObj = new Case();
            parentCaseObj.Subject = 'Test Parent Case' + casecreate;
            parentCaseObj.Origin = 'Phone';
            parentCaseObj.Status = 'New';
            lstParentCases.add(parentCaseObj);
        }
        insert lstParentCases; 
        
        List<Case> getlstParentCases = [SELECT Id FROM Case WHERE Subject LIKE 'Test Parent Case%'];
        for(Case caseObj : getlstParentCases){
            Case childCaseObj = new Case();
            childCaseObj.Subject = 'Test Child Case' ;
            childCaseObj.Origin = 'Email';
            childCaseObj.Status = 'New';
            childCaseObj.ParentId = caseObj.Id;
            lstChildCases.add(childCaseObj);
        }
        
        insert lstChildCases;
    }
    
    @isTest
    static void testPreventStatusFromClosed() {
        Test.startTest();
        List<Case> lstUpdateCases = new List<Case>();
        for(Case updateCase : [SELECT Id, Status, Subject FROM Case WHERE Subject LIKE 'Test Parent Case%']){
            updateCase.Status = 'Closed';
            lstUpdateCases.add(updateCase);
        }
        try{
            update lstUpdateCases;
        }catch(DMLException dml){
            System.debug(dml.getMessage());
            System.assert(dml.getMessage().contains('Cannot close parent case until all child cases are closed'));
        }
        Test.stopTest();
    }
}