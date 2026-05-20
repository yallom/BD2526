@echo off
set OUTPUT=main.sql

:: Clear/create output file
type nul > %OUTPUT%

echo -- ==================================== >> %OUTPUT%
echo -- MODEL >> %OUTPUT%
echo -- ==================================== >> %OUTPUT%
type model.sql >> %OUTPUT%
echo. >> %OUTPUT%
echo. >> %OUTPUT%

echo -- ==================================== >> %OUTPUT%
echo -- FUNCTIONS >> %OUTPUT%
echo -- ==================================== >> %OUTPUT%

for /R functions %%f in (*.sql) do (
    echo. >> %OUTPUT%
    echo -- FILE: %%f >> %OUTPUT%
    echo. >> %OUTPUT%
    type "%%f" >> %OUTPUT%
    echo. >> %OUTPUT%
)

echo -- ==================================== >> %OUTPUT%
echo -- TRIGGERS >> %OUTPUT%
echo -- ==================================== >> %OUTPUT%

for /R triggers %%f in (*.sql) do (
    echo. >> %OUTPUT%
    echo -- FILE: %%f >> %OUTPUT%
    echo. >> %OUTPUT%
    type "%%f" >> %OUTPUT%
    echo. >> %OUTPUT%
)

echo -- ==================================== >> %OUTPUT%
echo -- SEEDER >> %OUTPUT%
echo -- ==================================== >> %OUTPUT%
type seeder.sql >> %OUTPUT%
echo. >> %OUTPUT%
echo. >> %OUTPUT%

echo -- ==================================== >> %OUTPUT%
echo -- PROCEDURES >> %OUTPUT%
echo -- ==================================== >> %OUTPUT%

for /R procedures %%f in (*.sql) do (
    echo. >> %OUTPUT%
    echo -- FILE: %%f >> %OUTPUT%
    echo. >> %OUTPUT%
    type "%%f" >> %OUTPUT%
    echo. >> %OUTPUT%
)

echo -- ==================================== >> %OUTPUT%
echo -- VIEWS >> %OUTPUT%
echo -- ==================================== >> %OUTPUT%

for /R views %%f in (*) do (
    echo. >> %OUTPUT%
    echo -- FILE: %%f >> %OUTPUT%
    echo. >> %OUTPUT%
    type "%%f" >> %OUTPUT%
    echo. >> %OUTPUT%
)

echo Generated %OUTPUT% successfully.