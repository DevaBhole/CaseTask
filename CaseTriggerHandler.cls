public class CaseTriggerHandler {
    
    public static void checkParentChildCase(Map<Id,Case> newCaseMap,Map<Id,Case> oldCaseMap){
        Set<Id> parentIDs = new Set<ID>();
        for(Case caseObj : newCaseMap.values()){
            parentIDs.add(caseObj.Id);
        }
        if (!parentIDs.isEmpty()) {
            List<Case> childCases = [SELECT id,Status,ParentId FROM Case WHERE ParentId IN : parentIDs];
            for(Case caseObj : childCases){
                if(caseObj.Status != 'Closed'){
                    newCaseMap.get(caseObj.ParentId).addError('Cannot close parent case until all child cases are closed');
                }
            }
        }
    }
}