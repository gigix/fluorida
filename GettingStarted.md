# Get Fluorida #

### Download Pre-built Binary ###

Download Fluorida [zip package](http://fluorida.googlecode.com/files/Fluorida-0.0.1.zip) and unzip.

That's it.

Open **Tester.swf** with [Adobe Flash Player](http://www.adobe.com/products/flashplayer/), and you should see a successful test suite running.

http://lh3.google.com/gigix1980/R8_HvfXatII/AAAAAAAACvM/gPJJD2vbWYM/s400/fluorida-1.PNG

### Build From Source Code ###

Check out Fluorida source code from our [Subversion repository](http://code.google.com/p/fluorida/source/checkout):

```
# Non-members may check out a read-only working copy anonymously over HTTP.
svn checkout http://fluorida.googlecode.com/svn/trunk/ fluorida-read-only
```

[Rake](http://rake.rubyforge.org/), [Flex 3 SDK](http://www.adobe.com/go/flex_trial) and [Flash Player](http://www.adobe.com/products/flashplayer/) are required to build Fluorida. **NOTE**: Flex Builder is not required.

Make sure `rake` and `mxmlc` are in `PATH`. Download [Flash Player](http://www.adobe.com/products/flashplayer/) to `$PROJECT_ROOT/sa_flashplayer_9_debug.exe`. Then invoke `rake` at `$PROJECT_ROOT` and you should see a successful test suite running.

(If you haven't downloaded Flash Player, Fluorida build script will do that for your. In that case you have to make sure `wget` is in `PATH`.)

Invoke `rake` to re-build Fluorida without running test suite. You can find built binary at `$PROJECT_ROOT/bin`.

# Use Fluorida Locally #

Running locally, Fluorida always loads test suite from **[default.fls](http://code.google.com/p/fluorida/source/browse/trunk/src/default.fls)**, which exists in the same directory along with **Tester.swf**. Edit **default.fls** to refer to your test cases.

# Use Fluorida Within Website #

  * Embed **Tester.swf** into a [web page](http://code.google.com/p/fluorida/source/browse/trunk/website/app/views/tester/open.rhtml):

```
<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
     id="Tester" width="800" height="600"
     codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab">
 <param name="movie" value="<%= tester_swf %>" />
 <param name="allowScriptAccess" value="always" />
 <embed src="<%= tester_swf %>" name="Tester" align="middle" allowScriptAccess="always"
     play="true" loop="false" type="application/x-shockwave-flash"
	 width="800" height="600"
     pluginspage="http://www.macromedia.com/go/getflashplayer">
  </embed>
</object>
```

  * Define `startTest()` Javascript function in the web page, this function should
    1. specify URL of test suite, then
    1. kick off test

```
     function startTest() {
	     thisMovie("Tester").setTestSuite("<%= @suite_url %>");
	     thisMovie("Tester").startTest();
     }

     function thisMovie(movieName) {
         if (navigator.appName.indexOf("Microsoft") != -1) {
             return window[movieName];
         } else {
             return document[movieName];
         }
     }     
```

# Write Your Own Tests #

A Fluorine **test suite** (`*.fls`) is a plain-old-text-file. Each row in that file represents the URL of a test case. For example:

```
# This is a test suite
sample/success_case.flt
sample/error_case.flt
sample/fail_case.flt
```

A Fluorine **test case** (`*.flt`) is yet-another-plain-old-text-file. Each row in that file represents a command. A **command** is a vertical-bar-separated-string. The first column of a command is the **action** and others are **arguments**. For example:

```
# This is a successful test case
|open|aut.swf|
|click|helloButton|
|verifyText|helloText|hi there|
```

Before we come up to more sophisticated reference documentation, please refer to [our samples](http://code.google.com/p/fluorida/source/browse/trunk/test/sample) when you write your own tests.