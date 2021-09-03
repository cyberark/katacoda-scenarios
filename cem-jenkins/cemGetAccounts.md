
API: `cemGetAccounts()`

Example:
```
def result = cemGetAccounts()
println (result.data.size() )

for (platform in result.data) {
   println("Platform: $platform.platform")
   platform.accounts.each {
       println("workspace id: ${it.workspace_id}, status: ${it.workspace_status}")
}
```
