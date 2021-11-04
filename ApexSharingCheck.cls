public class ApexSharingCheck {

        public static boolean manualShareRead(Id recordId, Id userOrGroupId){

            OpportunityShare oppShr  = new OpportunityShare();
            oppShr.OpportunityId = recordId;
            oppShr.UserOrGroupId = userOrGroupId;
            oppShr.OpportunityAccessLevel = 'Read';
            oppShr.RowCause = 'Manual';

            Database.SaveResult sr = Database.insert(oppShr,false);

            if(sr.isSuccess()){
                return true;
            }
            else {
                Database.Error err = sr.getErrors()[0];
                if(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  &&
                        err.getMessage().contains('AccessLevel')){
                    return true;
                }
                else{
                    return false;
                }
            }
        }
    }