trigger CaseTrigger on Case (before update) 
{
    if(Trigger.isUpdate){
        if(Trigger.isBefore){
        	CaseTriggerHandler.checkParentChildCase(Trigger.newMap, Trigger.oldMap);
        }
    }

}