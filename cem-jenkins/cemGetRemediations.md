
API: `cemGetRemediations()`

Example:
```
def result = cemGetRemediations(platform: env.demo_platform, accountId: env.demo_accountId, entityId: env.demo_entityId)

if (result) {
    println("Remediations of $result.entityId")
    result.remediations.each {
        println("$it.UN_USED_PERMISSIONS.LEAST_PRIVILEGE.data")
    }
}
```
