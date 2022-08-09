trigger OSF_Trigger_Case on Case (before insert, before update) {
    OSF_Trigger_Case_Handler.handleBeforeUpdate(Trigger.new, Trigger.isUpdate);

}