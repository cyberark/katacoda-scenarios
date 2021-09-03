
# Download Configuration
In your terminal, download the Conjur quick-start configuration:

```
git clone https://github.com/cyberark/conjur-quickstart.git
cd conjur-quickstart
```{{execute}}

# Pull Image
Pull all the required Docker images from DockerHub.
docker-compose can do this for you automatically.  It will take a few moments.

`docker-compose pull`{{execute}}

# Generate Master Key
Generate your master data key and load it into the environment:

`docker-compose run --no-deps --rm conjur data-key generate > data_key`{{execute}}

`export CONJUR_DATA_KEY="$(< data_key)"`{{execute}}

> Prevent data loss:
> The conjurctl conjur data-key generate command gives you a master data key. Back it up in a safe location.
