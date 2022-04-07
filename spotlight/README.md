# README

This is an installation of [Spotlight](https://github.com/projectblacklight/spotlight) version 3.3. The aim is to integrate this spotlight with a Hyrax3 application.
The project is currently configured for the data in https://digital.wpi.edu/



## Run Spotlight

Clone the project and change directories to the spotlight application

```
$ git clone https://github.com/CottageLabs/spotlight.git
$ cd spotlight/spotlight
```

Start Solr (possibly using `solr_wrapper` in development or testing):

```
$ solr_wrapper
```

and the Rails development server:

```
$ rails server
```

Go to http://localhost:3000 in your browser.

