# Bristol T2
## Groups
Added to /etc/condor/config.d/11_fairshares.config
```GROUP_SORT_EXPR = \
ifThenElse(AccountingGroup=?="<none>", 3.4e+38, \
ifThenElse(AccountingGroup=?="group_HIGHPRIO", -20, \
ifThenElse(AccountingGroup=?="group_DTEAM_OPS", -10, \
ifThenElse(GroupQuota > 0, GroupResourcesInUse/GroupQuota, \
3.3e+38))))```
and
```AcctSubGroup = \ 
ifThenElse(regexp("prd",Owner),	"production",\
ifThenElse(regexp("pil",Owner),"pilot",\
ifThenElse(regexp("sgm",Owner),"admin",\
x509UserProxyVOName)))
AcctGroup = strcat("group_",x509UserProxyVOName,".",AcctSubGroup)
# condor uses AcctGroup, but some monitoring scripts use AccountingGroup
# let's have both.
AccountingGroup = $(AcctGroup)
# This one is not useful for grid sites but is useful if you want to
# implement user based quotas:
# group_<name>.<subgroup>.<user name>
#AcctGroup = strcat("group_",x509UserProxyVOName,".",AcctSubGroup,".",Owner)
SUBMIT_EXPRS = $(SUBMIT_EXPRS) AcctGroup AcctSubGroup AccountingGroup```
to /etc/condor/condor_config.local in order to make condor map grid users to local groups (does not seem to work yet).