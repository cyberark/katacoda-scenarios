
API: `cemGetEntities()`

Example:
```
def result = cemGetEntities(platform: env.demo_platform)
if (result) {
    println("total no of entities: " + result.hits.size() )
    result.hits.each {
        println "Name: $it.entityName, Score: $it.riskTotalScore"

    }
}
```
