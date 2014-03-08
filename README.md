# Coin

## Description

Coin is a tool to collect OS / DB information to diagnose performance issues,
gather statistics on a regular basis and so on.
You can add your own "command" to collect information you want.

## Usage

    $ coin -h
    Description:
        Collect OS / DB information

    Usage: coin [options] <action> [<command>]

    Option:
        -n, --node <node>  Remote nodes (comma-delimited list)
        -u, --user <user>  OS user to log in as on the remote node
        -h, --help         Output help

    Action:
        copy
        deploy
        list
        start
        stop
        undeploy

    For help on each action and its options use:
        coin -h <action>

    Command:
        dbbench      Collect OS / DB statistics for DB benchmark test.
        dbhang       Collect diagnostic information for DB performance / hang issue.
        dbstat       Collect DB statistics.
        heapdump     Collect heapdump for Oracle shared pool issue.
        hello        Example command (Just say hello).
        osstat       Collect OS statistics.

    Example:
        coin start hello    # start "hello" Coin command on local
        coin list hello     # list running "hello" Coin command on local
        coin -a list        # list all running Coin command on local
        coin stop hello     # stop "hello" Coin command on local
        coin -a stop        # stop all running Coin command on local

        coin -n node1,node2 deploy                  # deploy Coin to node1 and node2
        coin -n node1,node2 start hello             # start "hello" Coin command on node1 and node2
        coin -n node1,node2 list hello              # list running "hello" Coin command on node1 and node2
        coin -n node1,node2 -a list                 # list all running Coin command on node1 and node2
        coin -n node1,node2 stop hello              # stop "hello" Coin command on node1 and node2
        coin -n node1,node2 -a stop                 # stop all running Coin command on node1 and node2
        coin -n node1,node2 -l copy 'coin*' ./      # copy last log files from node1 and node2 to current directory on local
        coin -n node1,node2 copy 'coin*' ./log      # copy all log files from node1 and node2 to ./log on local
        coin -n node1,node2 undeploy                # undeploy Coin from node1 and node2

        coin -h stop    # output help on "stop" action

## License

Distributed under the BSD License.

Copyright (C) 2013, Takashi Hashizume
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
