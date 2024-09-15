# PGAdmin

## Instructions

* Visit [`http://localhost:5050`](http://localhost:5050/)
* Use the email and password provided under the `PGADMIN_DEFAULT_EMAIL` and `PGADMIN_DEFAULT_PASSWORD` env variables as credentials.
* The first time you log in you need to register a server in the server group, located in the tree view at the left sidebar of the screen with a **Servers** label.
  * Right click it, **Register**, **Server...**.
  * In the **General** tab fill in the **Name** input field with `Docker`, for example.
  * Then go to the **Connection** tab and use the `POSTGRES_HOSTNAME` env var value for **Host name/address**, the `POSTGRES_USERNAME` value for **Username** and the `POSTGRES_PASSWORD` for the **Password** input. The three of them are `postgres` by default. Then click Save and you're done.
  * Once you create a database you'll be able to see it from the **Databases** dropdown.
