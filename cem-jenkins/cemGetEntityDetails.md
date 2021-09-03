
API: `cemGetEntityDetails()`

Example:
```
def result = cemGetEntityDetails(platform: env.demo_platform, accountId: env.demo_accountId, entityId: env.demo_entityId)

if (result) {
    println "Name: $result.entity_name, Score: $result.exposure_level"
}
```
