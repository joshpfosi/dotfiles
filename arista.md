# Arista

## AIDs

* aid/851 - Newcomer Cheat Sheet
* aid/48 - Software Engineering at Arista
* aid/95 - Saving Running Config Approach
* aid/992 - Tutorial: Creating an Agent
* aid/296 - Writing Product Tests - test documentation is also here
* aid/6 - Arista Build System Tutorial
* aid/555 - Namespace DUTs
* aid/2972 - Feature Toggles
* aid/86 - Tracing
* aid/118 - CLI Plugin Developers' Guide
* aid/572 - Model Based Testing
* aid/1051 - Artools (A4) Background
* aid/1238 - Initial screening notes and questions
* aid/15,16 - CI docs
* aid/2621 - Idle Restart timer
* aid/1402 - BGP Confederations
* aid/708 - Route Maps
* aid/1502 - Triage Process
* aid/3545 - Test Suite Generation from Tags in Tests
* aid/1752 - Caring for MacPhyConcs
* aid/3516 - Pattern Rules
* aid/90 - Code coverage / Valgrind help
* aid/2656 - EOS C/C++ Code coverage
* aid/3347 - Coveraged
* aid/2438 - QuickTests
* aid/3578 - AMI/MIO
* aid/855 - ArosTest
* aid/30 - Bugs / Escapes - sev1, sev2, sev3
* aid/710 - Filing Bugs
* aid/1872 - Accelerated Software Upgrade (ASU)
* aid/1026 - Swi Workspace
* aid/1711 - Release Notes
* aid/1203 - Arcov
   * aid/2374
* aid/496 - Installing Arora, User Accounts, and making changes to Arora
* aid/1612 - Project Settings
* Flamegraph - https://docs.google.com/document/d/1uOFSuOqRvQsdzgPgaVrPneMlMp1Dy69ah1HNzgCZjKc/edit?ts=58adf6dd#
* aid/365 - Putting Your Software on Hardware
* aid/1161 - BGP Rib-out data structures

## TOIs

* I need to create two TOIs for Bloomington features
* AID on TOIs: aid/1863
* TOI cheatsheet - https://docs.google.com/a/arista.com/document/d/18HssG6v0ZPD_mhfu0nKB4vFnYjohcCyXZvN4AvSE2to/edit


#### a4c

* aid/3871 - a4c Cheat Sheet
* a4c alpha program - https://docs.google.com/document/d/1Iji2qHXZKX1QRbWmMJck4bLkRyhjCypiCaSlVwDEYJ8/edit#heading=h.gp4h2xq1hyjw
* aid/3894 - Home Containers

### Creating new aids

* `a4 newaid -t <title> -r <URL> -d "."` - the "." uses title as description

## Running gated under Valgrind (or any agent)

```
AGENTS_UNDER_VALGRIND=Rib RIB_VALGRIND_ARGS='--leak-check=full --log-file=/tmp/vgrind.log' Bgp/stest/RouteMapSetCommListClausesTest.py
```

## Helpful BGP /go pages

* Most helpful gated link ever: https://docstore.mik.ua/gated/node59.html
* Testing in BGP - go/bgp-testing
   * Stest tags - go/bgp-stest-tags
* BGP Feature interactions - go/bgp-feature-interactions
* Arista Groups - go/groups
* Gated Escalations - http://go/unicast-esc
* Gated U videos - https://sites.google.com/a/aristanetworks.com/routing/routing-hq-techtalks?pli=1
* Release matrix - https://docs.google.com/spreadsheets/d/1GWkvw0dvHdrbgPFV6COYNQYzTtrKmJEsAZLdocrCiE4/edit#gid=4

* GII - http://nexthop.aristanetworks.com/Documentation/gated/manuals/10.0.1/operation/pdf/gii.pdf

### Marking all bugs ignored in 1 release as ignore for another:

```
for bugid in $(a4 bugs --blocking-all=il.elgin-ignore,in.bedford-triage -p ArosTest | awk '{print $1};'); do

   echo $bugid

   a4 bug $bugid -b in.bedford-ignore -B in.bedford-triage -c "Ignoring for in.bedford since it's il.elgin ignore" -q

done
```

## Workflows

### For new features

* Write AID / design document - get it reviewed
* Create MUT plan - break project up into MUTs
* Create and launch MUTs
* Add code reviews as they are made
* Draft a "Test Plan" spreadsheet
* Tag tests
* Add pattern rules so changes to the relevant functions run your new tests
* Determine which tests to run via a4 suggestTests and tags
   * Use http://go/bgp-stest-tags to find test suites which make sense
      * Schedule via: `ScheduleStest -S <suite>`
   * Use grep and other hack solutions to come up with ptests to run
      * Schedule via: `ScheduleTest "<re>"`
* Compute code coverage
   * `a4 make -p Coverage`
   * `Coveraged`
* Submit to Aboard

### For bugs

* `a4 mut clone -c myproj -b pkg myproj0`
* `sh /user/joshpfosi/.newtreerc`
* Create test which reproduces bug
* FIX BUG
* (until Gitar supports Abuild via `p4 shelves`)
   * `git a review` to post
   * `git commit --amend` and `git a review` to incoporate review changes
   * Generate tests and run quick tests
   ```
   ScheduleStest -S Bgp/Srd --dryRun -v | sed -e '/^Att/d' | \
      sed -e 's/^\s*//g' | sort | uniq > ~/install-map0.tests
   ```
* `git a launch`

### For resolving bugs you create in eos-trunk

* Identify logre which exhibits problem and download logfile ('raw' link from
dashboard)
* Submit a new bug via `a4 abug`, e.g.
```
a4 abug -p Bgp -s "Maximum accepted routes CliSave erroneously uses addCommand \
instead of append" -u joshpfosi -l logfile.log -a all "cmds.addCommand\\( \
'neighbor %s maximum-accepted-routes %d %s'"
```

or

```
a4 abug -p Bgp -s \
"BGP mock failure: ECMP head found for prefix in flashCallback" -l logfile.log \
-a mock \
"in flashCallback\n.{1,50}assert self\.cdut\.getBgpEcmpHead\( prefix \) is None"
```

* Potentially, make a new MUT for the bug and follow "For bugs" above
* Post change for review
* Submit fix with `fixes=BUGID` via `a4 submit` or (guessing as never done this
with a MUT), `a4 mut launch` OR `git a launch` after amending
* Bug will automatically be marked resolved and fixed-by.
* Update affected projects

### Patching an already launched change

* `a4 newtree <proj>`
* Create change and commit
* If you want to add the change to the same review, as we have a new commit and
thus cannot amend, we must set `ConfigPreserveDescription` in gitar via:

```
git config --add gitar.preservedescription True
```

* Then, `git a launch -r <review-id>`

### a4 bug[s]

* Marking as dup: `a4 bug --dup-of <orig-bug-id> --status=r/dup <dup-bug-id>`
* Changing a bug's logre:
   * `a4 abug -d <bugid>`
   * `a4 abug -l Abuild.log --bug <bugid> "<regex>"`

### Gitar

* `a4 yum install -y git`
* `a4 yum install -y pthon-gitar`
* Update Gitar:

```
a4 yum erase -y python-gitar
a4 yum install -y python-gitar
```

* `git a init` -- will branch packages, too
* Removing a pending changelist: `git notes --ref gitar-changes remove`
   * May also require `a4 change -d <change-id>`

#### Setup

#### Working

* Create a feature branch
* Commit at will
* When time to push, squash commits into 1
* `git a push` will merge the feature into master, and `a4 submit` the changes
to Perforce

## Interview Screening

* See Gitlab repository, https://gitlab.aristanetworks.com/joshpfosi/screening,
for up to date README

* Do the problems yourself FIRST (under `joshpfosi@recruit.arista.com:~/screening`)
* Interview using Arista cloud server (recruit.arista.com)
* `arecruit` - tool for managing candidates
* Email template:

```
Hey NAME,

So for the interview just be prepared to talk about programming in C, including basic types, data structures and algorithms.  I'll ask you to do some coding via a screen sharing application (tmux -- if you haven't heard of it, that's okay, but may help to briefly familiarize yourself).  Detailed instructions on how to log in are below. You'll need access to a terminal window and ssh to connect to the Linux virtual machine. 	
	
You'll have an temporary account on recruit.arista.com.  Here are the steps:
	
1. ssh to recruit.arista.com.  Username: USERNAME.  I'll give you the password verbally when I call.
2. When you get to the shell prompt, type "tmux attach -t 0".
3. You should see a screen split into two panes.
4. You can run an editor (emacs or vi) in one and use the shell in the other. You may (e.g. if you are unfamiliar w/ tmux) use just one screen!)
5. Move between panes with "Ctrl-b <right/left-arrow>".	
	
The list above is for your reference once we are going.  You won't be able to do anything until I give you the password.	
	
Please confirm, and let me know if you have any questions.

Thanks,
Josh

P.S. This is just a screen -- don't stress!
```

* On day of interview:
   * create temp account for interviewee via `tempaccount USERNAME`
   * recruit.arista.com password: aristarecruit
   * Create new directory: `USERNAME_screening` copied from `screening`
      * scp -r joshpfosi@recruit.arista.com:~/screening/screening ~
      * scp -r screening USERNAME@recruit.arista.com:USERNAME_screening
   * Sign in as them: `ssh USERNAME@recruit.arista.com`
   * `cd USERNAME_screening`
   * `tmux`
   * Split pane vertically: `Ctrl-b %`
   * Move between panes: `Ctrl-b <arrow-key>`
   * Take notes in `joshpfosi@recruit.arista.com:~/screening_notes.md`
* Agenda
   * Hey, how are you?
   * Good good, relax this is just a screening
   * We'll dive right into some coding questions
   * Then at the end I'll leave some time for any questions you may have /
   overview of next steps

## CLI

### CAPI

* http://aid.aristanetworks.com/2150/cached.html
* External [Customer facing] CAPI doc - https://docs.google.com/document/d/10dsRuwVClM6uhbNsLRIWwAMp-BB1DYGy2v-IAKbMhfk/edit#heading=h.nss6dup7uvdj
 * CAPI Functional Spec - https://docs.google.com/document/d/1M7KbJuqUBTzTgt6HGPOCQKUBfwnfGZ6tC7rmo5htmTk/edit#heading=h.wnm30kc4vqb3
 * CAPI-zing RIB CLI

* The EOS CLI is defined via CliPlugins for various packages. The Ribd CLI is a
distinct entity which defines a CLI to the gated data model via the AMI server.
Arista would like to convert all EOS CLI commands which invoke the Ribd CLI to use
the CAPI interface to the AMI server directly to avoid parsing the command twice.

* `runCli` can be called on a EOS switch to run EOS CLI commands

## gated

### Logging

I usually add the following to tests I want to enable gated debug logs.
Add/remove any levels as needed.

```bash
   def trace( self, no='' ):
      self.rtrA.globalConfigCmdIs( "%s trace rib enable SharedMem all" % no )
      self.rtrA.globalConfigCmdIs( "%s trace rib enable Smash* all" % no )
      self.rtrA.globalConfigCmdIs( "%s trace rib enable Gated* all" % no )
      self.rtrA.globalConfigCmdIs( "no trace rib enable Gated all" )
      self.rtrA.globalConfigCmdIs( "%s trace rib enable Rib::* all" % no )
      self.rtrA.globalConfigCmdIs( "no trace rib enable Rib::Timer all" )
      self.rtrA.globalConfigCmdIs( "no trace rib enable Rib::Task all" )
      self.rtrA.globalConfigCmdIs( "%s trace rib enable RibGatedBgp all" % no )
```

You can also just cut/paste the following if you have an active CLI session:

```bash
    trace rib enable Gated* all
    trace rib enable Rib::* all
    trace rib enable RibGatedBgp all
    no trace rib enable Gated all
    no trace rib enable Rib::Timer all
    no trace rib enable Rib::Task all

    trace monitor <agent> | grep -v also works well for filtering
```
tail -f /var/log/agents/Rib-5610  | grep -vi "epoll_wait\|timeout\|timer\|ping\|handlePeerStat\|dog\|schedul\|cache"

To see what the levels are use 'show trace rib'. Note that knowing how our
levels map to gated levels is not a trivial matter.

Also, to apply to a whole test:

```
TRACE=Rib::*/* <test>
```

* Under gated, `ami_common` defines AMI entities shared by CAPI / EOS CLI and the
Ribd CLI
* Specifically, `ami_common/*_params.{c.h}` define INPUT enums and vtables whereas
`ami_common/*.{c,h}` define OUTPUT enums and vtables
* DGETs are enums in `mioagt/mio_api.h`
* `mioagt/ospf_api.h` defines the SIDs for new commands
* A `*_dget_*.c` file (e.g. `new_ospf/new_ospf_dget_request.c` or
`bgp/bgp_dget_summary.c`) defines a DGET NODE which is appended to a global array in
`mioagt/mio_dget.c`. This can be used to hook up the request key (e.g.
`MIO_DGET_SUMMARY`) with its implementation.
* MIO Guide - http://nexthop.aristanetworks.com/Documentation/gated/manuals/ngc_3.0/mio_api/pdf/mio.pdfAutotest does not support tests w/ more than 1 physical dut
* To support this we use an MLAG (two switches acting as one) then "break" it
into the two underlying duts
* Upon test failure, the mlag dut needs to be sanitized again
* Use `Art sanitize -m` as it is sufficient and faster than regular `Art
sanitize`

* MIO has a standalone module
   * spawns a separate thread which handles incoming AMI requests and responds to the
   `cliribd` process the Python module has forked off
   * Attaching to the cliribd is simple:
      * `pgrep -f cliribd` to obtain the pid and `sudo gdb -p pid`
   * To attach to the MIO server:
      * `netstat -tulpn` and determine the process with the AMI_SERVER_PORT open
      * `sudo gdb -p pid` to the pid of that process

### cliribd

* Parses commands using convoluted `cli_cmd_t` tree, calling appropriate callbacks
which build up appropriate data structures for the command
   * For routemaps this means a route map data structure which upon "exit" from the
   routemap config mode, gets serialized over AMI to the MIO servervia
   `cli_routemap_send_seq`
   * Therefore, adding a new route map clause to cliribd requires adding parsing code
   (new `cli_cmd_t` structures), but also MIO server deserialization boilerplate to
   receive the new clause server-side

## BGP

* BGP uses flags which were originally implemented as `#define`d shifted bits and set
via macros
* As that does not scale beyond 64 flags, an `enum` implementation replaced it
* Relying (erroneously?) on the compiler to store enum values as integers, and a
fancy typedef made the refactor relatively painless

### SRD

* Selective Route Download
* optimization on policy evaluation: if a "policy" (e.g. route maps, access lists)
changes, but it is an SRD only change (e.g. the route-map associated w/ SRD),
then we set a bit in `srd_changes` so we only evaluate policy on the selected
routes (selected via SRD)
* when deleting an SRD route-map (which is also used as inbound policy), this
optimization will erroneously be applied (i.e. it is incorrectly considered to
be an SRD only change), and so the inbound policy is not re-evaluated
* the predicate "SRD only change" is computed by reference counting
   * `adv->adv_list` stores policy (each node is a different policy, say)
   * policy changes are stored in a dirty `adv_list`
   * the change is considered to involve other policies iff the adv list
   contains more references than just the references to SRD policy nodes.
      * e.g. I have a route map inbound policy, and SRD policy
      * the `adv_entry->adv_refcount` would be calculated as: 1 for being in the
      global `adv_list`, 1 for addition into the dirty `adv_list`, 1 for being
      in ipv4 SRD policy, 1 for being in ipv6 SRD policy, 1 for inbound policy,
      and (perhaps -- not sure) 1 for being in a maintentance route map
   * note, the dirty entries contribute to the reference count in `adv_refcount`
   and so are subtracted from this count -- otherwise, we'd be double counting
   dirty policies -- in truth, using the reference count to compute this
   predicate is not the best choice as they are not connected, but rather
   "happen to work"
* when deleting a route map, the `adv_entry` for the route map is deleted and so
the reference count is decremented
   * this occurs *prior* to computing if the change is SRD only
* however, `g_dirty_adv_list` contains all `adv_entry`s which are changing and
so it still contains the `adv_entry` and still contributes 1 to the reference
count
* therefore, when the dirty references are subtracted from the overall reference
count, the single route map is essentially being "removed" *twice*. That is, the
reference count corresponding to its existence as well as an import policy (or
export policy), a contribution of 2, is entirely decremented away
   * this essential erases the import (or export) policy, and so SRD concludes
   the change is SRD only (falsely)

### BGP Encapsulation SAFI / BGP Tunnel Encapsulation Attribute

#### RFC 5512 (https://tools.ietf.org/html/rfc5512)

* Sometimes we need BGP to encapsulate its messages e.g. to use an IPv6 tunnel
connecting to IPv4 nodes
* The BGP encapsulation SAFI (as w/ all SAFIs) labels a BGP message as encoding
a specific kind of information
   * In this case, the BGP speaker adds the BGP tunnnel encapsulation attribute
   which encodes the relevant header details to include on an encapsulated
   packet which another BGP speaker wants to send to itself
* Using a SAFI, instead of just an attribute, allows a change to the
encapsulation information to require only 1 update to be sent instead of
prefix-specific UPDATEs if there was only the attribute

#### BGP Tunnel Encapsulation Attribute (https://tools.ietf.org/html/draft-ietf-idr-tunnel-encaps-01)

* Deprecates RFC 5521 as encapsulation SAFI was "never used"

#### Segment Routing Architecture (https://tools.ietf.org/html/draft-ietf-spring-segment-routing-07)

* segment routing leverages source routing
   * source routing - concept of specifying entire path through network
* "A node steers a packet through list of instructions, called segments"
* can be applied to MPLS (multiprotocol label switching) architecture without changes to forwarding plane
   * a segment maps to a single MPLS label
   * ordered list of segments maps to a stack of labels
   * active segment maps to top of stack
* can be applied to IPv6 w/ a new routing header
   * a segment maps to a an IPv6 address
   * ordered list of segments maps to an ordered list of IPv6 addresses encoded
   in the routing header
   * active segment maps to destination address of packet
* can be used for traffic engineering among other "network functions"

#### Advertising Segment Routing Traffic Engineering Policies in BGP (https://tools.ietf.org/html/draft-previdi-idr-segment-routing-te-policy-00)

* adds a new BGP SAFI + NLRI to advertise SR TE policy
* advertised along w/ Tunnel Encapsulation Attribute
* policy is advertised with the information needed by the receiving speaker in
order for the receiver to instantiate the policy in its forwarding table and
apply that policy

## Miscellaneous

* In order to include `ami_common/*` in `new_ospf/*`, both `AMI_SERVER` and
`AMI_COMMON` must be defined

### Helpful CLI Commands

* `show running config`
* `show ip bgp` - shows BGP routing table
* `show ip route bgp` - shows BGP routes
* `show ip bgp neighbor / peer X.X.X.X advertised-routes / received-routes`
* `clear ip bgp` - clears BGP routing table
* `neighbor X.X.X.X route-map <mapname> in / out` - sets inbound or outbound route map

### Helpful Python

* `ipRouteIs` => `ip route <prefix> <intf>` and `ipaddrStr` can just be `None`
* `NOPDB=1` to prevent dropping into PDB on failures

## Art

* Simple sequence to grab a router for testing:

```bash
Art grab rtr1
Art on
Art attach
```

* Multinode topology:

```bash
Art grab -f ip1 ip2
Art on ip1 ip2
Art ifconnect ip1:Et1 ip2:Et1
Art attach ip1
Art attach ip2
```

## Ptests

* If only changing Python test code, simply remaking the package is enough if Python
code changes

## A4

* If `a4 make` hangs, try `--no-use-resourced -j 4`
* Delete a project: `a4 project delete <name>`
* Submitting to reviewboard: `a4 project postreview -r <review-num>`
* `a4 rpmbuild <project>` - Builds RPMs to be loaded onto a DUT
* Add new files to `<project>.spec.ar` to be picked up by `rpmbuild`
* Web interface: http://src
* Kick off an Abulid: `Abuildd -f $WP`
* Kill an Abuild: `Abuildd -ki <id>`
* When checking build status, `start` column is the greatest CL# in the build, so
long as the CL# you submitted is less than this value, your CL is part of the build.
* Check status of Abuild: `ap abuild -g`
* `a4 make -p <pkg> pylint` reproduces `Job pylint <pkg> failed` -- `a4 revert
<pkg>/pylint.dat` first though!
* Triaging bugs: `a4 bugs -p <pkg> --triage`
* Triaging a particular release: `a4 bugs -p <pkg> -B <release>-triage`
* Moving a bug: `a4 bug -B il.elgin-triage -b il.elgin-looking -u joshpfosi <BUG#>`
* `a4 yum install --enablerepo=\*` to install more global packages
* Better deletetree (kills processes): `sudo deletree -k <proj>`
* Removing a change list: `a4 change -d <cl>`
* Showing changelists which impact a file: `a4 filelog <filepath>`

### Shelving (like `git stash`)

* Shelving files: `a4 shelve`
* Before submitting, the shelved changelist must be removed: `a4 shelve -c <changelist> -d`

### Re-parenting a Project

* `a4 project setting parent=<project>`
* `a4 project sync`
--
* a4 project setting parent=bloomington-rel
* a4 mut parent bloomington-rel

## Testing

* Setting test seed
   * determine random seed from Abuild log
   * `ARTEST_RANDSEED=<seed> <test>`

### Becoming Package Maintainer

* Edit `/eng/package/<package>/Maintainers`

### Patching files

* Obtain a diff via `a4 [project] diff` and edit the paths to eliminate p4 remnants 
* `patch -R -b -p0 < myfile.diff` should work like a charm

## Product Tests

* Use `<ptest> --showDuts` to determine what DUT to grab
* `Art grab <dut>`
* `Art sanitize`
* `a4 make -p <package> product_nocheck`
* `Art update`
* `Art ssh -u root`
* `service ProcMgr restart`
* THEN, run `<ptest>`

## Helpful Resources

* http://www.arista.com/docs/Manuals/ConfigGuide.pdf
* BGP Reading List - https://docs.google.com/document/d/1UtAv_K_WZ4iDLki4Op07TM647tB5nX93yN_ooweEKg0/edit#heading=h.hhqqyejdt51w

## Builds

* Once ready to merge (Ship it): `a4 project setting mergeToParent=True mergeApprovers=croche`

## Debugging

* Build logs: `curl <url> | vim -`
* Notes on debugging / attaching GDB: https://docs.google.com/document/d/1A02hLAMmLdmIrxVlTZhR8tOX76stvOTrywWRVcAIQBo/edit
* When running with nondefault-VRFs, ribd spawns child processes for each VRF. To
attach to `<vrf>` on `<dut>`:
   * `netns Artest*`
   * `cat /var/run/agents/<dut>.Rib-vrf-<vrf>-vrf`

## Model Tests

* With the BGP tests which test a variety of attributes (`BgpCliTests`) the
attributes are defined across two lists (why -- who knows): `CliNeighborAttrs` in
`BgpCliTests.py` and `NeighborAttrs` in `BgpTestLib`.

## BGP

* Good resource: http://www.cisco.com/c/en/us/support/docs/ip/border-gateway-protocol-bgp/26634-bgp-toc.html
* Debugging command: `show ipv6 bgp neighbor vrf all`

## RouteMap

* route maps have `permit` and `deny` clauses
* a `permit` functions as: `redistribute IF all <clauses> are TRUE`
* a `deny` is the negation and functions as: `redistribute IF any <clauses> are FALSE`
   * OR `do NOT redistribute IF all <clauses> are TRUE` (the opposite of `permit`)

### Implementation Details

* `RouteMap` package exposes the CLI and TAC model which maintains route map state
* TAC model gets shoved into gated via MIO
* route maps are inherently protocol independent
   * a router configures in and out routemaps to apply to a peer
   * a protocol peer configuration would select a routemap to use
      * e.g. BGP decides to use routemap X
* RouteMap tests appear to verify gated config matches EOS config via cliribd e.g.
`RouteMapBasicTests.py:asPathConfigTest`

### TAC model

* `RouteMap` config is a collection of `RouteMap`s
* A `RouteMap` is a collection of `MapEntry``s i.e. `permit` and `deny` clauses
* A `MapEntry` has (among other things) a collection of `MatchRule`s indexed by
`option`
* A `MapRule` has a field `option`, of type `MapOption` which is an enum with each
possible match rule

### Gated

* `/src/gated/gated-ctk/ssrc/cli/routemap/routemap.{ch}` defines the AMI interface

### RouteMap CLI

* `addMatch` is used to add a new match command to the CLI in the correct mode
* `isMatchAttrEnabled` is used to tie the list of match attributes in `RouteMapLib`
to the CLI. That is, the `RouteMapLib` list is the single point of truth for enabling
match attributes
* cliribd processes route maps in `/src/gated/gated-ctk/src/cli/routemap/routemap.c`

### RouteMap Testing

* New match commands are adding to `RouteMapLib.py` via `addMatchAttr` which appends
to a global variable, `MatchAttributes`
* `MatchAttributes` is used in `MatchTest` to presumably sanity test the match
phrases

### Links

* similar reviewboard diff: http://reviewboard/r/74894/diff/#index_header
* confederations: http://aid.aristanetworks.com/1402/cached.html

## Miscellaneous Errors & Solutions

```shell
~/2016.155058-joshpfosi @us102.sjc> ac
26648 client:Server connection closed.
Traceback (most recent call last):
  File "/usr/bin/a4", line 463, in <module>
    sys.exit( main() )
  File "/usr/bin/a4", line 429, in main
    runAristaCommand( cmd, args, profile, nested )
  File "/usr/bin/a4", line 384, in runAristaCommand
    runcmd()
  File "/usr/bin/a4", line 370, in runcmd
    sys.exit( a4commands[ cmd ].run( args, nested ) )
  File "/usr/bin/a4", line 70, in run
    execute( args )
  File "/usr/bin/a4", line 52, in execute
    result.append( f( args=_args ) )
  File "/usr/lib/python2.7/site-packages/A4/chroot.py", line 539, in chrootHandler
    chrootInNsd( asRoot, isolate, cmd, container, archstr, extraBindMounts )
  File "/usr/lib/python2.7/site-packages/A4/chroot.py", line 208, in chrootInNsd
    netnsExecLoginShell( rootdir, isolate, svrName, cmd, asRoot )
  File "/usr/lib/python2.7/site-packages/A4/chrootLib.py", line 146, in netnsExecLoginShell
    postChrootIsolateActions( svrName )
  File "/usr/lib/python2.7/site-packages/A4/chrootLib.py", line 178, in postChrootIsolateActions
    svr )
  File "/usr/lib/python2.7/site-packages/A4/chrootLib.py", line 154, in netnsRun
    return A4.Helpers.run( netnsCmd, **kwargs )
  File "/usr/lib/python2.7/site-packages/A4/Helpers.py", line 131, in run
    echoCapture=echoCapture, timeStamp=timeStamp, timeout=timeout )[ 0 ]
  File "/usr/lib/python2.7/site-packages/A4/Helpers.py", line 263, in runAndReturnPid
    raise e
A4.Helpers.SystemCommandError: '/usr/bin/netns /home/joshpfosi/2016.155058-joshpfosi/isolate /usr/bin/sudo /bin/su --command=echo \(none\) > /proc/sys/kernel/hostname': error code 255 (stdout='') (stderr=None)
```

Solution ([here](https://groups.google.com/a/arista.com/forum/#!search/How$20to$20fix$20%22a4$20chroot%22$20failing$20with$20%22client$3AServer$20connection$20closed%22/interns2016-blr/UJBmbltg-O0/SAwlzAJEAgAJ)):

```shell
~/2016.155058-joshpfosi @us102.sjc> netns -l | grep joshpfosi
/home/joshpfosi/2016.155058-joshpfosi/isolate
/home/joshpfosi/2016.joshpfosi-localas/chroot
/home/joshpfosi/2016.joshpfosi-localas/isolate
/home/joshpfosi/2016.155058-joshpfosi/chroot
/home/joshpfosi/external0/isolate
/home/joshpfosi/external0/chroot
~/2016.155058-joshpfosi @us102.sjc> sudo netns -k /home/joshpfosi/2016.155058-joshpfosi/isolate
killed 22539
~/2016.155058-joshpfosi @us102.sjc> sudo netns -k /home/joshpfosi/2016.155058-joshpfosi/chroot
killed 5322
~/2016.155058-joshpfosi @us102.sjc> netns -l | grep joshpfosi
/home/joshpfosi/2016.joshpfosi-localas/chroot
/home/joshpfosi/2016.joshpfosi-localas/isolate
/home/joshpfosi/external0/isolate
/home/joshpfosi/external0/chroot
~/2016.155058-joshpfosi @us102.sjc> ac
~/2016.155058-joshpfosi @dhcp-2058-16.sjc%
```

# Bgp

## Bug 183485

* aid/2170 on 'received-routes filtered'
* just running 'received-routes' lists LocPref as '-' but adding filtered shows
'100'
* This seems expected b/c the rmap w/ 'set local preference 200' is denied --
probably happened after 'set match import' was made set clause aware
* bug caused by fix for 168944

# ArosTest

## Bug 144081

* `go/codenames` - product types
* are bugs hitting same chassis, or chipset, then that should be assigned to
specific maintainers of that group
* it could be widespread, but still kernel specific (eos-kernel-dev)
* BUG 144081 appears to be failing in BadblocksTest.py so il.elgin-rel should
ignore
* but that test is in ArosTest so, dig in
* deduced by checking log, and seeing back trace - test appeared to do Ctrl-C,
Ctrl-Z and this is problematic

## Bug 166575

* Timed out waiting for /mnt/usb1 (external flash device) - used to indicate bad
flash device - aka not our problem
* c or s leading backtrace means 'serial console' and 'ssh', respectively

## Bug 163131

* recovery partition - protected area on hardware from which we can boot a
stable EOS image
* indicates likely a product issue not ArosTest
* email swlab-helpdesk to open ticket and unblock il.elgin-rel

* move to <branch>-ignore if we expect bug to hit again and do not care about it
* `Art -u arostest-dev grab -d 0 -c "comment" do305`

## Bug 144582

* `a4 mock` issue - reproduce via `a4 mock --dumpOnFailure <pkg>`
* be sure to run `a4 rpmbuild <pkg>` on any changed packages first
* ArosTest:EosEdut#replaceConfig depends on 'replace config'
   * a CLI command provided by ConfigSession
* ArosTest cannot depend on ConfigSession directly due to a dependency cycle
   * Agent -> StateMgr -> ArosTest -> ConfigSession -> Agent
* need to move replaceConfig to ConfigSession/ArosTestPlugin

# DUT Caretaking

* My dut (cd296) stopped running tests for a few days
* Noticed many tests appeared stuck in the running state via `mysql`:
   * `mysql -h mysql-shadow -u arastra`
   * `use Arjob`
   * `select result,project,name,target,owner,startTime,endTime from job where target='rdam://lf332' order by job.id DESC LIMIT 100;`
   * Checked out autotest server: `a4 ssh atest352`
   * Saw load balance was far to high (via `top`) and killed long-running
   `python` processes -- tests scheduled again
      * `strace -p <pid>` can be used to monitor for function calls

# tmux at Arista

* To connect to another's session:

```
# from your user server
a4 ssh <target-user-server>
a4 sudo su - <target-user>
<navigate to ws and attach>
```

# Bugzilla

* if a `-B` fails to remove a bug from triage (say), there is likely a recursive
dependency
   * resolve via Buzilla's 'show dependency tree'

# Sysdb hangs

* Check logs: netns Artest-<> + vi /var/log/ip1.Sysdb
* If UnknownTypeError, find TACC type, note file its in
* Go to package Makefile, and find library file is in
* Install missing library `a4 yum install -y <Pkg>-lib`
* This indicates a dependency issue in parent

# Setting `preserveFailedState`

* From within an arbitrary workspace:

```
a4 choose +//eng/etc
a4 sync /eng/etc/logre
a4 edit /eng/etc/logre
vi /eng/etc/logre # Add 'preserveFailedState' to note and description of bug
a4 submit -d "BUG 188278: Setting preserveFailedState"
a4 choose -//eng/etc
```

# A4 Update failure

```
[/home/joshpfosi/b165987/RPMS] Transaction Check Error:
[/home/joshpfosi/b165987/RPMS]   file /usr/lib/python2.7/site-packages/CoppAclPTestLib.pyc from install of QosTest-ptest-1.0.0-4326924.eostrunk.1.i686 conflicts with file from package Qos-ptest-1.0.2-4268059.joshpfosib1659870.i686
[/home/joshpfosi/b165987/RPMS]   file /usr/lib/python2.7/site-packages/CoppCpuQScalePTestLib.pyc from install of QosTest-ptest-1.0.0-4326924.eostrunk.1.i686 conflicts with file from package Qos-ptest-1.0.2-4268059.joshpfosib1659870.i686
[/home/joshpfosi/b165987/RPMS]   file /usr/lib/python2.7/site-packages/CoppDynamicClassPTestLib.pyc from install of QosTest-ptest-1.0.0-4326924.eostrunk.1.i686 conflicts with file from package Qos-ptest-1.0.2-4268059.joshpfosib1659870.i686
[/home/joshpfosi/b165987/RPMS]   file /usr/lib/python2.7/site-packages/CoppDynamicQScalePTestLib.pyc from install of QosTest-ptest-1.0.0-4326924.eostrunk.1.i686 conflicts with file from package Qos-ptest-1.0.2-4268059.joshpfosib1659870.i686
[/home/joshpfosi/b165987/RPMS]   file /usr/lib/python2.7/site-packages/CoppFragmentedPktPTestLib.pyc from install of QosTest-ptest-1.0.0-4326924.eostrunk.1.i686 conflicts with file from package Qos-ptest-1.0.2-4268059.joshpfosib1659870.i686
[/home/joshpfosi/b165987/RPMS]   file /usr/lib/python2.7/site-packages/CoppNonCpuTrafficPTestLib.pyc from install of QosTest-ptest-1.0.0-4326924.eostrunk.1.i686 conflicts with file from package Qos-ptest-1.0.2-4268059.joshpfosib1659870.i686
[/home/joshpfosi/b165987/RPMS]   file /usr/lib/python2.7/site-packages/CoppRebootPTestLib.pyc from install of QosTest-ptest-1.0.0-4326924.eostrunk.1.i686 conflicts with file from package Qos-ptest-1.0.2-4268059.joshpfosib1659870.i686
[/home/joshpfosi/b165987/RPMS]   file /usr/lib/python2.7/site-packages/CoppStaticQPTestLib.py from install of QosTest-ptest-1.0.0-4326924.eostrunk.1.i686 conflicts with file from package Qos-ptest-1.0.2-4268059.joshpfosib1659870.i686
[/home/joshpfosi/b165987/RPMS]   file /usr/lib/python2.7/site-packages/CoppStaticQPTestLib.pyc from install of QosTest-ptest-1.0.0-4326924.eostrunk.1.i686 conflicts with file from package Qos-ptest-1.0.2-4268059.joshpfosib1659870.i686
[/home/joshpfosi/b165987/RPMS]   file /usr/lib/python2.7/site-packages/CoppStaticQSandTestLib.py from install of QosTest-ptest-1.0.0-4326924.eostrunk.1.i686 conflicts with file from package Qos-ptest-1.0.2-4268059.joshpfosib1659870.i686
[/home/joshpfosi/b165987/RPMS]   file /usr/lib/python2.7/site-packages/CoppStaticQSandTestLib.pyc from install of QosTest-ptest-1.0.0-4326924.eostrunk.1.i686 conflicts with file from package Qos-ptest-1.0.2-4268059.joshpfosib1659870.i686
[/home/joshpfosi/b165987/RPMS]   file /usr/lib/python2.7/site-packages/EcnPTestLib.py from install of QosTest-ptest-1.0.0-4326924.eostrunk.1.i686 conflicts with file from package Qos-ptest-1.0.2-4268059.joshpfosib1659870.i686
[/home/joshpfosi/b165987/RPMS]   file /usr/lib/python2.7/site-packages/EcnPTestLib.pyc from install of QosTest-ptest-1.0.0-4326924.eostrunk.1.i686 conflicts with file from package Qos-ptest-1.0.2-4268059.joshpfosib1659870.i686
[/home/joshpfosi/b165987/RPMS]   file /usr/lib/python2.7/site-packages/QosDutTests.pyc from install of QosTest-ptest-1.0.0-4326924.eostrunk.1.i686 conflicts with file from package Qos-ptest-1.0.2-4268059.joshpfosib1659870.i686
[/home/joshpfosi/b165987/RPMS]   file /usr/lib/python2.7/site-packages/QosHitlessRestartPTestLib.pyc from install of QosTest-ptest-1.0.0-4326924.eostrunk.1.i686 conflicts with file from package Qos-ptest-1.0.2-4268059.joshpfosib1659870.i686
[/home/joshpfosi/b165987/RPMS]   file /usr/lib/python2.7/site-packages/QosPolicerPTestLib.pyc from install of QosTest-ptest-1.0.0-4326924.eostrunk.1.i686 conflicts with file from package Qos-ptest-1.0.2-4268059.joshpfosib1659870.i686
[/home/joshpfosi/b165987/RPMS]
[/home/joshpfosi/b165987/RPMS] Error Summary
[/home/joshpfosi/b165987/RPMS] -------------
[/home/joshpfosi/b165987/RPMS]
+-> command returned 1 in 0:00:16.579649 ('sh -o pipefail -c prefix "[/home/joshpfosi/b165987/RPMS] " sudo env "LD_LIBRARY_PATH=" "PATH=/home/joshpfosi/tools/bin:/home/joshpfosi/i686/bin:/home/joshpfosi/tools/bin:/home/joshpfosi/i686/bin:/usr/lib/ccache:/home/joshpfosi/tools/bin:/home/joshpfosi/x86_64/bin:/usr/lib64/ccache:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/bin:/home/joshpfosi/.local/bin:/home/joshpfosi/bin:/home/joshpfosi/.local/bin:/home/joshpfosi/bin" yum -c /etc/Ayum.conf -y update 2>&1 | tee /tmp/tmpAGERq0')
Maybe installing restricted python source packages
+-> command returned 0 in 0:00:01.326972 ('sh -o pipefail -c prefix "[/home/joshpfosi/b165987/RPMS] " sudo env "LD_LIBRARY_PATH=" "PATH=/home/joshpfosi/tools/bin:/home/joshpfosi/i686/bin:/home/joshpfosi/tools/bin:/home/joshpfosi/i686/bin:/usr/lib/ccache:/home/joshpfosi/tools/bin:/home/joshpfosi/x86_64/bin:/usr/lib64/ccache:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/bin:/home/joshpfosi/.local/bin:/home/joshpfosi/bin:/home/joshpfosi/.local/bin:/home/joshpfosi/bin" yum -c /etc/Ayum.conf -y install Arbus-lib-pysrc Ark-pysrc Cli-lib-pysrc Mlag-pysrc Rib-lib-pysrc Strata-pysrc StrataL3-pysrc SysMgr-cli-pysrc Sysdb-pysrc SysdbAgent-pysrc TaccPyUtils-pysrc libtac-pysrc libtacutils-pysrc 2>&1 | tee /tmp/tmpmxcuLu')
Updating installed rpms
====================== Conflicts with file from package ======================
  You are attempting to install RPMS with conflicting files with already
  installed RPMs. It is normally caused by some files being moved across
packages or RPMs without updating version and obsoletes in the spec file
properly (see http://aid/10 for more details).

  To work around this problem, try to uninstall the conflicting RPMs
by 'sudo rpm -e --nodeps' and reinstall.
==============================================================================
ERROR: 'yum -c /etc/Ayum.conf' failed
'a4 update --rpms' exited with nonzero status (1)
```

* fix via `a4 erase -y Qos-ptest`

# Profiling

* `perf` is integrated into `Art`
* Set up a ptest and use `Art perf start` and `Art perf flamegraph` etc.

# Gerrit

* Default Gerrit port is 29418
* If having trouble pushing, ensure `.git/config` contains:

```
url = ssh://joshpfosi@gerrit:29418/gitar.git
```

* Pushing to Gerrit: `git push origin HEAD:refs/for/master`

# Installing zsh / oh-my-zsh

* `a4 yum install -y enablerepo=* zsh` in workspace (newtreerc / mutrc)
* Change default shell to zsh: `chsh -s $(which zsh)`
   * Make sure `which zsh` is in /etc/shells
* Had to add `TERM=xterm-256color # Force proper coloring in tmux sessions` to
get collors working

## a4 make mysql error

```
BUG35200: connection #0 to mysql failed
BUG35200: user='arastra', db='AbuildStats', host='statsdb', socket=None, private=False
BUG35200: (2005, "Unknown MySQL server host 'statsdb' (111)")
BUG35200: connection #1 to mysql failed
BUG35200: user='arastra', db='AbuildStats', host='statsdb', socket=None, private=False
BUG35200: (2005, "Unknown MySQL server host 'statsdb' (111)")
BUG35200: connection #2 to mysql failed
BUG35200: user='arastra', db='AbuildStats', host='statsdb', socket=None, private=False
BUG35200: (2005, "Unknown MySQL server host 'statsdb' (111)")
2017-03-12 09:33:21: 'a4 make' Abuild stats collection is disabled globally
Loaded plugins: visitallrepos
Generating dependencies for 1 packages... took 3.57s
2017-03-12 09:33:56: 'a4 make' packages: gated(member)
2017-03-12 09:33:56: 'a4 make' targets: default
2017-03-12 09:33:56: Manager __init__( [('ramMb', 257349L), ('cores', 32)], 'us102.sjc.aristanetworks.com', 31424 )
Unable to connect to server us102.sjc.aristanetworks.com:31424: [Errno -2] Name or service not known
BUG35200: connection #0 to mysql failed
BUG35200: user='arastra', db='Abuild', host='abuilddb', socket=None, private=True
BUG35200: (2005, "Unknown MySQL server host 'abuilddb' (111)")
BUG35200: connection #1 to mysql failed
BUG35200: user='arastra', db='Abuild', host='abuilddb', socket=None, private=True
BUG35200: (2005, "Unknown MySQL server host 'abuilddb' (111)")
BUG35200: connection #2 to mysql failed
BUG35200: user='arastra', db='Abuild', host='abuilddb', socket=None, private=True
BUG35200: (2005, "Unknown MySQL server host 'abuilddb' (111)")
Traceback (most recent call last):
  File "/usr/lib/python2.7/site-packages/A4/make.py", line 2385, in makeHandler
    return _makeHandler( args )
  File "/usr/lib/python2.7/site-packages/A4/make.py", line 2574, in _makeHandler
    jobs, ap, packages )
  File "/usr/lib/python2.7/site-packages/A4/make.py", line 2747, in _initResourceManagerAndMemUsageTracker
    accessDb=opts.use_resourced )
  File "/usr/lib/python2.7/site-packages/A4/make.py", line 1496, in __init__
    self.refresh( data )
  File "/usr/lib/python2.7/site-packages/A4/make.py", line 1506, in refresh
    conn = A4.Helpers.abuildDb( private=True )
  File "/usr/lib/python2.7/site-packages/A4/Helpers.py", line 619, in abuildDb
    return mysqlDb( user, db, host, socket, private, autocommit )
  File "/usr/lib/python2.7/site-packages/A4/Helpers.py", line 599, in mysqlDb
    return newConnection()
  File "/usr/lib/python2.7/site-packages/A4/Helpers.py", line 596, in newConnection
    return connect()
  File "/usr/lib/python2.7/site-packages/A4/Helpers.py", line 585, in connect
    return MySQLdb.connect( host=host, user=user, db=db )
  File "/usr/lib/python2.7/site-packages/MySQLdb/__init__.py", line 81, in Connect
    return Connection(*args, **kwargs)
  File "/usr/lib/python2.7/site-packages/MySQLdb/connections.py", line 187, in __init__
    super(Connection, self).__init__(*args, **kwargs2)
OperationalError: (2005, "Unknown MySQL server host 'abuilddb' (111)")
```

* fixed by using `a4 make -p gated` instead of `a4make` alias
* happened again, had to ssh in again, chroot and run it outside of tmux
* this may happen if I am `netns`'d (thanks Appu) -- just `exit`

# (Split) MLAG duts

* Autotest does not support tests w/ more than 1 physical dut
* To support this we use an MLAG (two switches acting as one) then "break" it
into the two underlying duts
* Upon test failure, the mlag dut needs to be sanitized again
* Use `Art sanitize -m` as it is sufficient and faster than regular `Art
sanitize`

# Artools

* Building Artools symlinks the workspace's tools to /bld
   * Consequently, if /bld/Artools is deleted, we lose all our tools!
   * To fix this, we can copy /usr from a healthy workspace (hacky and time
     consuming)
   * OR, we can use Jb's commands (untested):

   ```
   rpm -Uvh /src/Artools/RPMS/i386_18/Artools-bootstrap.i686.rpm
   rpm -Uvh /src/Artools/RPMS/i386_18/Artools.i686.rpm
   ```

   * OR, we `a4c rebase` and hope things go well :)

# `apwg` Notes

* Slides: https://docs.google.com/presentation/d/15NAzNOsa8yMA8yKLcEuOo-gquG6DUllgYITpM7gdbAQ/edit#slide=id.g1d21734eb0_0_105

# Misc

* To check if your mut is part of a build: `ap abuild -s -p bedford.A1-rel`

# My Bgp Bfd bug

* To create bug (after downloading log file): `a4 abug -s "KeyError in bfdNeighbor" -p Bgp -b bedford.A1-mustfix <regex>`
* To edit logre: `a4 abug -e 195438`
* Needs to block mustifx: `a4 bug -b bedford.A1-mustfix 195438`
* To scan logs: `a4 logscan -e --next=bedford-maint --projectSpecific Bgp`

* To re-logscan logs where a specific bug hit: `ap autotest --hitBug 184417 -q --logscan`

# Adding debuginfo for an agent to a systest dut

* https://groups.google.com/a/arista.com/forum/#!search/install$20debuginfo$20on$20a$20dut/bgp-dev/QG8q95CoMdQ/Q9GNn_V8BwAJ
* `a4 make -p gated product_nocheck` - build RPM for gated
* Copy it over to dut: `Art scp /RPMS/gated.i686.rpm wa452:/tmp`
* Install on dut: `sudo rpm -Uvh /tmp/gated.i686.rpm`
* Follow http://aid.aristanetworks.com/978/

* With a CLI core use `sudo gdb python -c <core>` to get to a backtrace

* Restart agent: `agent rib terminate`

For catching regressions, this shows all changes that merged between two dates in a package in a branch
* a4 changes //src/gated/bloomington-rel/...@2018/02/10,@2018/02/20 -ai
*  http://p4web:8081/@md=d&cd=//src/ArBgp/eos-trunk/&c=1Vc@//src/ArBgp/eos-trunk/?ac=43&mx=50
* a4 files //src/ArBgp/eos-trunk/...@2016/12/18,2016/12/19 - That lists all the files that have changed on eos-trunk between those 2 dates - just one day in this example.

* cat summary.txt| grep FAIL | awk '{print "Bgp/stest/"$2".py"}' > /tmp/failed.tests
