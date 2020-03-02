# Stock internal DSL

## Design idea

Given a simple server responding to some wouldbe stock commands, design a dsl that allows a user to make requests to these commands in any arbitrary order and let them conditionally execute the commands at runtime.

## Implementation

The implementation follows a standard builder pattern, starting with the `action_builder` which contains a list of operations, corresponding to what action should be executed, and a set of conditions that may or may not fail at run time when the specific action is executed. Conditions is a recursive structure, meaning that they can be nested via the `or_`, `and_` and `not_` constructs. After constructing the 'DSL' it is passed to the `run` function of the program, which takes a list; and as it is called, pulls the head of that list which will become the next action executed. Thus the stock DSL actions follow a FIFO philosophy.
When an action is run, it can consist of multiple `operations` where the design only allows _all_ operations to be executed, if the condition tree passes. Where it will then execute all the programmed operations and return to the outer `run` scope and pull the next action from the list of remaining actions.


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
c(stock_client).
```
* Now run the server
```
Server = stock_server:start().
```
* Now run the client and see the DSL in action
```erlang
stock_client:main(Server).
```
<h2> Or view the included MP4 file