# Stock internal DSL

## Design idea

Given a simple server responding to some wouldbe stock commands, design a dsl that allows a user to call make request to these commands in any arbitrary order and let them conditionally execute the command at runtime.

## Implementation

The implementation follows a standard builder pattern in disguise, starting out with the `action_builder` which contains an operation corresponding to what action should be executed and a set of conditions that may or may not fail at run time when the specific action is exectued. Conditions is a recursive structure meaning that they can be nested via the `or_`, `and_` and `not_` constructs. After constructing the 'dsl' it is passed to the `run` function of the program which takes a list and as it is called pulls the head of that list which will become the next action executed, thus the stock dsl actions executions follow a FIFO philosophy.
When an action is run,


## How to run
* Make sure that the erlang compiler is installed
* Open your desired shell
* CD into the directory where the .erl files are located
* Open the erlang command tool by typing `erl`
* first compile the server 
```erlang
c(stock_server).
```
* Then compile the client
```erlang
c(stock_server).
```
* Now run the server
```
Server = stock_server:start().
```
* Now run the client and see the DSL in action
```erlang
stock_client:main(Server).
```
