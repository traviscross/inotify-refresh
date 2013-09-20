inotify-refresh
===============

This tool causes your web browser to refresh automatically when you
modify any file in a given directory.  It aims to work as well as
possible without doing anything too involved.

License
-------

This code is available under the terms of the MIT license.

Dependencies
------------

You'll need to install:

 * inotify-tools
 * xdotool

On a Debian-based distribution you can run:

    apt-get install inotify-tools xdotool

Installation
------------

This is a Bash script; simply put the file somewhere in your path:

    sudo install -m0755 inotify-refresh.sh /usr/bin/inotify-refresh

...or simply copy it into the directory of a project that you're
working on.

Usage
-----

    ./inotify-refresh.sh [-b <browser title>] [-t <tab title>] <path>

where:

    <browser title> the name of your web browser as it appears in the
    title bar; the default is "Chromium"
    
    <tab title> if present, don't refresh the web browser unless this
    string appears before the browser name in the title bar of the browser
    window
    
    <path> the path to the source of the project you're working on

When any file is created, modified, moved, or deleted from your
project directory, inotify-refresh will attempt to refresh your web
browser.

Limitations
-----------

In a multi-tab web browser, if you don't have your project in the
active tab, the web browser will refresh the wrong tab unless you've
given the -t option, in which case it will simply fail to refresh any
tab at all.

Similar Projects
----------------

* [Tincr](http://tin.cr/)
* [guard-livereload](https://github.com/guard/guard-livereload)
* [rack-livereload](https://github.com/johnbintz/rack-livereload)

Author
------

inotify-refresh was written by Travis Cross.
