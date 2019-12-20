# homebus-sunrise-sunset

This is a simple HomeBus data source which publishes sunrise and sunset times for the given latitude and longitude.

## Usage

On its first run, `homebus-sunrise-sunset` needs to know how to find the HomeBus provisioning server.

```
bundle exec homebus-sunrise-sunset -b homebus-server-IP-or-domain-name -P homebus-server-port
```

The port will usually be 80 (its default value).

Once it's provisioned it stores its provisioning information in `.env.provisioning`.

`homebus-sunrise-sunset` also needs to know:

- the latitude and longitude of the location whose sunrise and sunset times are being reported

