# Backend

## Environment

Create a `.env` file in the root of the project

```bash
PORT=3000
```

## Docker

Run docker commands from root of project:

*Development*
* docker-compose up

**Note:** 

Nodemon will restart the application on each save. Port 9229 has been exposed to attach the node debugger.

*Build (Locally)*
* `docker build -t actions-demo:test --target test .`
* `docker build -t actions-demo:prod --target prod .`

*Run (Locally)*
* `docker run --rm -t actions-demo:test`
* `docker run --rm -p 3000:3000 -t actions-demo:prod`
