# GitHub API

Small service that scrapes User and Repository data from GitHub and stores the data in a database. This service expose a query API that accepts parameters relevant to the data and returns a well-formed API object.

## Installation

This steps are necessary to get the application up and running.

It requires [Ruby 2.6.3](https://www.ruby-lang.org/en/news/2019/04/17/ruby-2-6-3-released/) and [Mongo 4.0](https://docs.mongodb.com/manual/release-notes/4.0/) previous installed to run. Check [this gist](https://gist.github.com/felipetio/b1878c7038cadfd4d89ba3c78cb4a141) to have the pre requisites installed on MacOSX.


```sh
$ cd github_api
$ bundle install
$ rake db:setup
$ rake db:create_indexes
$ rails s
```

## Scraping github data
The followings steps are necessary to connect to GitHub’s API to scrape and store Repository and User data.

### Fetching current user data

```sh
$ cd github_api
$ rake "github:fetch_me" GITHUB_ACCESS_TOKEN=your_top_secret_access_token
```

### Fetching others public user data

```sh
$ cd github_api
$ rake "github:fetch[felipetio,fabiofleitas]" GITHUB_ACCESS_TOKEN=your_top_secret_access_token
```
### Cronjobs
To schedule cronjobs to scrape more data you can add a `.env` file with your token to protected it.
`GITHUB_ACCESS_TOKEN=your_top_secret_access_token`

Now you can add the following comand in you corntab:
`cd path/to/github_api && bundle exec rake github:fetch_me`

## Query Format

The query format is designed to be simple and readable in the URL, it follows these rules:
-   All query parameters are encapsulate in a dict, keys are assumed to be field names
-   Special query parameters sort, limit and offset are treated specially, any other query parameter is ignored.

### Operators

In the most simplistic form,  `eq[<field>]=<value>`  in the query translates to an equals filter, for example  `name=foo`  translates to a  `{name: 'foo'}`  query filter specification.

In the previous example the `eq`  operator was used. To use other operators change it to supported operators: `gt, gte, lt, lte`

### Values

Values are auto-detected and converted to an data-type, but would be important to have a way explicitly specified in the field spec.

If multiple values are given for the same field, the value is considered an array, regardless of the operator type.

### Special Parameters

#### offset

Specifies the offset into the documents list.

#### limit

Specifies the number of documents to limit the result.

#### sort

Field to sort the result on. By default, the sort is in an ascending order.

### Examples

#### Basic search

- Ruby repositories:
http://localhost:3000/api/v1/repositories?eq[language]=Ruby
- Repositories inside a project:
http://localhost:3000/api/v1/repositories?eq[has_projects]=true

#### Search with operators
- With one or more forks:
http://localhost:3000/api/v1/repositories?gte[forks]=1
- With less than 10 watchers
http://localhost:3000/api/v1/repositories?lt[watchers]=10

#### Sorting results
- Ascending sort:
http://localhost:3000/api/v1/repositories?sort=size
- Descending sort:
http://localhost:3000/api/v1/repositories?sort=-size (TODO)

#### Pagination
- First page:
http://localhost:3000/api/v1/repositories?limit=10
- Second page:
http://localhost:3000/api/v1/repositories?offset=10&limit=10

### Testing
This steps are necessary to execute the test suite:

```sh
$ cd github_api
$ rspec
```
