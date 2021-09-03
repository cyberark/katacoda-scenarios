
API: `cemGetRecommendations()`

Example:
```
def result = cemGetRecommendations(platform: env.demo_platform, accountId: env.demo_accountId, entityId: env.demo_entityId)

if (result) {
    println("Recommendations of $result.entity_id")
    result.recommendations.active_recommendations.each {
        println "$it"
    }
}
```
