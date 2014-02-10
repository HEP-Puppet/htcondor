# Bristol
## Groups
Added to /etc/condor/config.d/11_fairshares.config
```GROUP_SORT_EXPR = ifThenElse(AccountingGroup=?="<none>", 3.4e+38, ifThenElse(AccountingGroup=?="group_HIGHPRIO", -20, ifThenElse(AccountingGroup=?="group_DTEAM_OPS", -10, ifThenElse(GroupQuota > 0, GroupResourcesInUse/GroupQuota, 3.3e+38))))```
in order to make condor map grid users to local groups (does not seem to work yet).