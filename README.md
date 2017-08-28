# Library
This repository is a community-owned policy library for the Open Policy Agent.
The goal is to provide a place where the community can find and share logic for
analyzing common JSON documents like Terraform plans and Kubernetes API objects.

The basic premise is to provide a library of Rego helper functions that
other people can reuse and modify when writing their own policies
along with example policies built using those functions, and
tests that the example policies and helper functions operate as they should.
OPA will be outfitted to pull in libraries and push/contribute helper functions
to the library.

The basic format of each library is:

* Any number of .rego files within a directory constitute a library.
* Files beginning with `example` are example policies demonstrating how to use the library.
* Files beginning with `test` are tests either of the library or of the examples.
* Files beginning with `input` are sample inputs used for tests or just as examples.





