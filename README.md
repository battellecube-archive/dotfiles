# CUBE Tools Container


## I got no time to read stuff!

Just do this and it might work.  If not find, time to read stuff ;)


_NOTE: For now you need to **export BRANCH=your-dev-branch** until this gets
merged to `main`_

```sh
curl -sSL -o ~/.local/bin/cube-tools https://raw.githubusercontent.com/battellecube/dotfiles/$BRANCH/cube-tools
chmod +x ~/.local/bin/cube-tools
```

That will pull down a help script to run your container.  Assuming `~/.local/bin` is in your path, you should be able to run you container.

```sh
cube-tools
```


## Hacking the Gibson

Build the base `cube-tools` image
```sh
build -t -f Containerfile.cube-tools cube-tools .
```

Build the `cube-tools-qb` image
```sh
build -f Containerfile -t cube-tools-qb
```

Create and run a `cube-tools-qb container
```sh
run -it -rm cube-tools-qb:latest bash
```

Clean-up after yourself
```sh
podman ps -qa | xargs podman rm; podman images -aq|xargs podman rmi --force
```
