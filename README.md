Shariff Perl Backend
===================

Shariff is used to determine how often a page is shared in social media, but without generating requests from the displaying page to the social sites.

![Shariff Logo © 2014 Heise Zeitschriften Verlag](http://www.heise.de/icons/ho/shariff-logo.png)

This document describes the Perl backend. The following backends are also available:

* [shariff-backend-node](https://github.com/heiseonline/shariff-backend-node)
* [shariff-backend-php](https://github.com/heiseonline/shariff-backend-php)

Installing the Shariff backend on you own server
------------------------------------------------

This software is based on [Mojolicious](http://mojolicio.us). Make sure, you've installed it, e.g. by running `cpanm Mojolicious`.

To get started with the shariff backend, unzip the current [release](https://github.com/heiseonline/shariff-backend-perl/releases) zip file into a local folder. Start the server application by using the [hypnotoad](http://mojolicio.us/perldoc/hypnotoad) script.

```bash
$ hypnotoad script/shariff
Server available at http://127.0.0.1:8080.
```

You need to proxy requests from your webserver to the hypnotoad server. See [Mojolicious Cookbook](http://mojolicio.us/perldoc/Mojolicious/Guides/Cookbook#DEPLOYMENT) for some Nginx or Apache recipes.

This project is bundled with a configuration file `shariff.conf`. The following configuration options are available:

| Key         | Type      | Description |
|-------------|-----------|-------------|
| `cache`     | `hashref` | Cache settings described below |
| `domain`    | `regexp`  | A regular expression describing one or more domain(s) for which share counts may be requested |
| `hypnotoad` | `hashref` | Hypnotoad webserver settings as described in [Mojolicious docs](http://mojolicio.us/perldoc/Mojo/Server/Hypnotoad#SETTINGS). You may want to change the `listen` setting. |
| `services`  | `hashref` | Service specific settings |

Cache settings:

| Key       | Type  | Description | Default |
|-----------|-------|-------------|---------|
| `class`   | `scalar` | Cache class name to use. | `Heise::Shariff::Cache`. |
| `expires` | `scalar` | Time in seconds to hold fetched data in in-memory cache. | 60 |
| `options` | `arrayref` | A list of options to be passed to the cache class constructor. Setting `options` to `[{foo => 'bar'}, 'baz']` leads to call `$cache->new({foo => 'bar'}, 'baz')`. | `[]` |

Testing your installation
-------------------------

If the backend runs under `http://example.com/my-shariff-backend/`, calling the URL `http://example.com/my-shariff-backend/?url=http%3A%2F%2Fwww.example.com` should return a JSON structure with numbers in it, e.g.:

```json
{"facebook":1452,"twitter":404,"googleplus":23}
```
