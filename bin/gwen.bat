@REM gwen-web launcher script
@REM
@REM Environment:
@REM JAVA_HOME - location of a JDK home dir (optional if java on path)
@REM CFG_OPTS  - JVM options (optional)
@REM Configuration:
@REM GWEN_WEB_config.txt found in the GWEN_WEB_HOME.
@setlocal enabledelayedexpansion

@echo off

if "%GWEN_WEB_HOME%"=="" set "GWEN_WEB_HOME=%~dp0\\.."

set "APP_LIB_DIR=%GWEN_WEB_HOME%\lib\"

rem Detect if we were double clicked, although theoretically A user could
rem manually run cmd /c
for %%x in (!cmdcmdline!) do if %%~x==/c set DOUBLECLICKED=1

rem FIRST we load the config file of extra options.
set "CFG_FILE=%GWEN_WEB_HOME%\GWEN_WEB_config.txt"
set CFG_OPTS=
if exist %CFG_FILE% (
  FOR /F "tokens=* eol=# usebackq delims=" %%i IN ("%CFG_FILE%") DO (
    set DO_NOT_REUSE_ME=%%i
    rem ZOMG (Part #2) WE use !! here to delay the expansion of
    rem CFG_OPTS, otherwise it remains "" for this loop.
    set CFG_OPTS=!CFG_OPTS! !DO_NOT_REUSE_ME!
  )
)

rem We use the value of the JAVACMD environment variable if defined
set _JAVACMD=%JAVACMD%

if "%_JAVACMD%"=="" (
  if not "%JAVA_HOME%"=="" (
    if exist "%JAVA_HOME%\bin\java.exe" set "_JAVACMD=%JAVA_HOME%\bin\java.exe"
  )
)

if "%_JAVACMD%"=="" set _JAVACMD=java

rem Detect if this java is ok to use.
for /F %%j in ('"%_JAVACMD%" -version  2^>^&1') do (
  if %%~j==java set JAVAINSTALLED=1
  if %%~j==openjdk set JAVAINSTALLED=1
)

rem BAT has no logical or, so we do it OLD SCHOOL! Oppan Redmond Style
set JAVAOK=true
if not defined JAVAINSTALLED set JAVAOK=false

if "%JAVAOK%"=="false" (
  echo.
  echo A Java JDK is not installed or can't be found.
  if not "%JAVA_HOME%"=="" (
    echo JAVA_HOME = "%JAVA_HOME%"
  )
  echo.
  echo Please go to
  echo   http://www.oracle.com/technetwork/java/javase/downloads/index.html
  echo and download a valid Java JDK and install before running gwen-web.
  echo.
  echo If you think this message is in error, please check
  echo your environment variables to see if "java.exe" and "javac.exe" are
  echo available via JAVA_HOME or PATH.
  echo.
  if defined DOUBLECLICKED pause
  exit /B 1
)


rem We use the value of the JAVA_OPTS environment variable if defined, rather than the config.
set _JAVA_OPTS=%JAVA_OPTS%
if "!_JAVA_OPTS!"=="" set _JAVA_OPTS=!CFG_OPTS!

rem We keep in _JAVA_PARAMS all -J-prefixed and -D-prefixed arguments
rem "-J" is stripped, "-D" is left as is, and everything is appended to JAVA_OPTS
set _JAVA_PARAMS=
set _APP_ARGS=

:param_loop
call set _PARAM1=%%1
set "_TEST_PARAM=%~1"

if ["!_PARAM1!"]==[""] goto param_afterloop


rem ignore arguments that do not start with '-'
if "%_TEST_PARAM:~0,1%"=="-" goto param_java_check
set _APP_ARGS=!_APP_ARGS! !_PARAM1!
shift
goto param_loop

:param_java_check
if "!_TEST_PARAM:~0,2!"=="-J" (
  rem strip -J prefix
  set _JAVA_PARAMS=!_JAVA_PARAMS! !_TEST_PARAM:~2!
  shift
  goto param_loop
)

if "!_TEST_PARAM:~0,2!"=="-D" (
  rem test if this was double-quoted property "-Dprop=42"
  for /F "delims== tokens=1,*" %%G in ("!_TEST_PARAM!") DO (
    if not ["%%H"] == [""] (
      set _JAVA_PARAMS=!_JAVA_PARAMS! !_PARAM1!
    ) else if [%2] neq [] (
      rem it was a normal property: -Dprop=42 or -Drop="42"
      call set _PARAM1=%%1=%%2
      set _JAVA_PARAMS=!_JAVA_PARAMS! !_PARAM1!
      shift
    )
  )
) else (
  if "!_TEST_PARAM!"=="-main" (
    call set CUSTOM_MAIN_CLASS=%%2
    shift
  ) else (
    set _APP_ARGS=!_APP_ARGS! !_PARAM1!
  )
)
shift
goto param_loop
:param_afterloop

set _JAVA_OPTS=!_JAVA_OPTS! !_JAVA_PARAMS!
:run
 
set "APP_CLASSPATH=%APP_LIB_DIR%\org.gweninterpreter.gwen-web-2.14.0.jar;%APP_LIB_DIR%\org.gweninterpreter.gwen-2.11.0.jar;%APP_LIB_DIR%\org.scala-lang.scala-library-2.12.3.jar;%APP_LIB_DIR%\io.cucumber.gherkin-4.1.3.jar;%APP_LIB_DIR%\io.cucumber.gherkin-jvm-deps-1.0.4.jar;%APP_LIB_DIR%\com.github.scopt.scopt_2.12-3.6.0.jar;%APP_LIB_DIR%\org.slf4j.slf4j-log4j12-1.7.22.jar;%APP_LIB_DIR%\org.slf4j.slf4j-api-1.7.22.jar;%APP_LIB_DIR%\log4j.log4j-1.2.17.jar;%APP_LIB_DIR%\com.typesafe.scala-logging.scala-logging_2.12-3.5.0.jar;%APP_LIB_DIR%\org.scala-lang.scala-reflect-2.12.3.jar;%APP_LIB_DIR%\jline.jline-2.14.2.jar;%APP_LIB_DIR%\commons-codec.commons-codec-1.10.jar;%APP_LIB_DIR%\org.apache.commons.commons-text-1.1.jar;%APP_LIB_DIR%\org.apache.commons.commons-lang3-3.5.jar;%APP_LIB_DIR%\com.github.tototoshi.scala-csv_2.12-1.3.4.jar;%APP_LIB_DIR%\com.jayway.jsonpath.json-path-2.2.0.jar;%APP_LIB_DIR%\net.minidev.json-smart-2.2.1.jar;%APP_LIB_DIR%\net.minidev.accessors-smart-1.1.jar;%APP_LIB_DIR%\org.ow2.asm.asm-5.0.3.jar;%APP_LIB_DIR%\joda-time.joda-time-2.9.7.jar;%APP_LIB_DIR%\org.seleniumhq.selenium.selenium-chrome-driver-3.6.0.jar;%APP_LIB_DIR%\org.seleniumhq.selenium.selenium-api-3.6.0.jar;%APP_LIB_DIR%\org.seleniumhq.selenium.selenium-remote-driver-3.6.0.jar;%APP_LIB_DIR%\net.bytebuddy.byte-buddy-1.7.5.jar;%APP_LIB_DIR%\org.apache.commons.commons-exec-1.3.jar;%APP_LIB_DIR%\commons-logging.commons-logging-1.2.jar;%APP_LIB_DIR%\com.google.code.gson.gson-2.8.0.jar;%APP_LIB_DIR%\com.google.guava.guava-23.0.jar;%APP_LIB_DIR%\com.google.code.findbugs.jsr305-1.3.9.jar;%APP_LIB_DIR%\com.google.errorprone.error_prone_annotations-2.0.18.jar;%APP_LIB_DIR%\com.google.j2objc.j2objc-annotations-1.1.jar;%APP_LIB_DIR%\org.codehaus.mojo.animal-sniffer-annotations-1.14.jar;%APP_LIB_DIR%\org.apache.httpcomponents.httpclient-4.5.3.jar;%APP_LIB_DIR%\org.apache.httpcomponents.httpcore-4.4.6.jar;%APP_LIB_DIR%\net.java.dev.jna.jna-4.1.0.jar;%APP_LIB_DIR%\net.java.dev.jna.jna-platform-4.1.0.jar;%APP_LIB_DIR%\org.seleniumhq.selenium.selenium-firefox-driver-3.6.0.jar;%APP_LIB_DIR%\org.seleniumhq.selenium.selenium-ie-driver-3.6.0.jar;%APP_LIB_DIR%\org.seleniumhq.selenium.selenium-safari-driver-3.6.0.jar;%APP_LIB_DIR%\org.seleniumhq.selenium.selenium-support-3.6.0.jar;%APP_LIB_DIR%\commons-io.commons-io-2.5.jar"
set "APP_MAIN_CLASS=gwen.web.WebInterpreter"
set "APP_CLASSPATH=%GWEN_CLASSPATH%;%SELENIUM_HOME%\*;%SELENIUM_HOME%\libs\*;%APP_CLASSPATH%"

if defined CUSTOM_MAIN_CLASS (
    set MAIN_CLASS=!CUSTOM_MAIN_CLASS!
) else (
    set MAIN_CLASS=!APP_MAIN_CLASS!
)

rem Call the application and pass all arguments unchanged.
"%_JAVACMD%" !_JAVA_OPTS! !GWEN_WEB_OPTS! -cp "%APP_CLASSPATH%" %MAIN_CLASS% !_APP_ARGS!

@endlocal


:end

exit /B %ERRORLEVEL%
