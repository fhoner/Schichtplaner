# Schichtplaner

Schichtplaner is a tool to manage schedules of working shifts. It's intention was to have a nice little tool for voluntary associations to easily distribute the helpers into the given time boxes.

  - Create multiple productions with individual time shifts
  - Collect information of workers to easily contact all workers at once
  - Limit the count of workers per shift
  - Get notified via email when changes occured
  - Export time tables to PDF

![Overview](http://fs5.directupload.net/images/170122/h3oapu49.png)

![Edit shift](http://fs5.directupload.net/images/170122/uttsglj4.png)

### Tech

Schichtplaner is based on Twitter Bootstrap UI framework and uses several third party plugins for better user experience.


### Installation

Schichtplaner requires PHP7 and MySql 5.6 or higher.
Download and extract the [latest release](https://github.com/fhoner/Schichtplaner/releases).

Install the dependencies and devDependencies.

```sh
$ cd master
$ npm install
$ composer install
```

Build the distributables.

```sh
$ grunt
```

### Import database

Use the sampledb.sql and run the script on your MySql instance.

### Configuration

See config_sample.php and change the values to your servers configuration. Please consider to set the rewrite base directory in .htaccess file as well.

### Run

Open Schichtplaner in your webbrowser at e.g. http://localhost/schichtplaner/.
