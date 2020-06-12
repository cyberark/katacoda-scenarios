# Contributing to the Conjur Katacoda Scenarios

For general contribution and community guidelines, please see the [community
repo](https://github.com/cyberark/community).

## Table of Contents
- [Prerequisites](#prerequisites)
- [Katacoda Documentation](#katacoda-documentation)
- [Building and Testing](#building-and-testing)
- [Troubleshooting Steps](#troubleshooting-steps)
- [Contribution Workflow](#contribution-workflow)

## Prerequisites
The Katacoda CLI is recommended in order to create a new scenario. You can
install the Katacoda CLI by running `npm install katacoda-cli --global` in the
terminal. You can find the documentation for the Katacoda CLI
[here](https://www.npmjs.com/package/katacoda-cli).

## Katacoda Documentation
A link to the Katacoda documentation can be found
[here](https://www.katacoda.community/welcome.html).

Additionally, it is recommended that you look at the other scenarios in the
[`cyberark/katacoda-scenarios`](https://github.com/cyberark/katacoda-scenarios/)
repository to see how Katacoda has been used in other tutorials.

## Building and Testing
The Katacoda scenarios can be tested using the `katacoda-cli`. In order to
validate that the structure of your scenario is properly defined, you can run
`katacoda validate:all .` in the root directory of the
[`cyberark/katacoda-scenarios`](https://github.com/cyberark/katacoda-scenarios/)
directory.

In order for your scenario to be properly validated, all extraneous files (if
any) must be included directly in the `assets` directory of your scenario.

Our repository also runs this command automatically using a Github action.

## Troubleshooting Steps
Katacoda may take some time to properly load in changes to your scenario. It can
take anywhere from 5 to 30 minutes for the scenario to propagate onto Katacoda.

If it takes longer than this to run, we highly recommend checking your Github
log and pushing again if necessary.

## Contribution Workflow
1. Fork the repository to your Github account (this is necessary in order to set
up a [Katacoda webhook](https://katacoda.com/teach/git-hosted-scenarios)
2. If issue for relevant change has not been created, open one
[here](https://github.com/cyberark/katacoda-scenarios/issues)
3. Add the `implementing` label to the issue once you begin to work on it
4. Commit your changes (`git commit`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request, linking the issue in the description (e.g.
   `Connected to #123`) and ask another developer to review and merge your code
7. Replace `implementing` with `implemented` label in issue
