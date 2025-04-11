## Release versions

New versions of the Marble app are released about every week. The version numbers are of the format "vX.Y.Z", where X, Y and Z are numbers.
Every version of the Marble app correponds to a pair of versions of the backend and frontend executables. A pair of (backend version, frontend version) that are together in a release are compatible.
Note that version "vX.Y.Z" of the Marble app will not necessarily use the same versions "vX.Y.Z" of the backend and frontend. Typically, the patch version "Z" (and in rare cases, the minor version "Y") may be different.

The mapping of `Marble version => backend and frontend versions` can be found in the following way:
For a given release of the Marble app (= release tag on the https://github.com/checkmarble/marble repository),

- `x-backend-image-version` and `x-frontend-image-version` can be found at the top of the docker-compose.yaml file of the repository
- the relevant version tags can also be found in the `kubernetes/.versions` file
