# Daedalus Project Docs

Docs [website](https://docs.daedalus-project.io/).

Docs are generated using [Hugo](https://gohugo.io/).

## Develop

Serve Hugo with live reload

```
hugo server -D --baseURL http://docs.daedalus-project.local --bind $YOUR_IP_ADDRESS
```

## Deploy website

```
hugo --gc --minify -s .
```

Html files are generate under **public** folder.

## Test Docker images

Any change in non master neither develop branches creates update daedalus-project-docs-develop:nightly.

````
docker create --name DaedalusProjectDocs --hostname docs -p 8080:80 -i daedalusproject/daedalus-project-docs-develop:nightly
docker start DaedalusProjectDocs
````

Remember to delete the container
```
docker stop DaedalusProjectDocs
docker rm DaedalusProjectDocs
docker rmi daedalusproject/daedalus-project-docs-develop:nightly
```

## CI/CD

[Gitlab pipelines](/.gitlab-ci.yml) control CI and deployment to Kubernetes cluster, see [Kubernetes](/kubernetes) section for more details.
