@isTest
public with sharing class ApexSharingCheckTest {

        static testMethod void testManualShareRead(){

            List<User> users = [SELECT Id FROM User WHERE ProfileId = '00e20000001nSOBAA2' AND IsActive = true LIMIT 2];

            Id User1Id = users[0].Id;
            Id User2Id = users[1].Id;

            Account acc = BRTestDataFactory.createAccount('Test acc');
            insert acc;
            Opportunity opp = BRTestDataFactory.createOpportunity(acc.id, 'Test opp');
            opp.OwnerId = user1Id;
            insert opp;

            System.assertEquals(ApexSharingCheck.manualShareRead(opp.Id, user2Id), true);

            List<OpportunityShare> opportunityShares = [SELECT Id, UserOrGroupId, OpportunityAccessLevel,
                    RowCause FROM OpportunityShare WHERE OpportunityId = :opp.Id AND UserOrGroupId= :user2Id];

            // Проверяем, что есть только 1 шаринг
            System.assertEquals(opportunityShares.size(), 1);

            // Атрибуты шаринга
            System.assertEquals(opportunityShares[0].OpportunityAccessLevel, 'Read');
            System.assertEquals(opportunityShares[0].RowCause, 'Manual');
            System.assertEquals(opportunityShares[0].UserOrGroupId, user2Id);

            delete opp;

            // Пробуем вставить для удаленной записи
            System.assertEquals(ApexSharingCheck.manualShareRead(opp.Id, user2Id), false);
        }

}