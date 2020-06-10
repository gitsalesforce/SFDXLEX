trigger OpportunityAccount on Opportunity (after delete) {
    list<Opportunity> newopp = trigger.old;
    Set<id> opplist = new set<id>();
    for(Opportunity opp:newopp){
        opplist.add(opp.id);
    }
    system.debug(opplist);

}